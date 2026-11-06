import Becoming.Grammar
import Becoming.GrammarMap
import Becoming.GrammarCrossing

/-!
# What a line under a class must hold, and what a regularity takes in (所经必同, 常闭则后皆续)

Chapter 7 §4.6 joins two routes into one path to the future: a line continues past a member's end
under a coarser class, and, through the conditions it runs through, reaches what those conditions
later feed. Two of its steps were shown only in witnesses (`Becoming.GrammarCases`). This module
states them for every carrier, relation and class.

* **What a line must pass, its class must hold (所经必同).** Where a region (a decided predicate `P`)
  is left under a class only into a set `C` (every step under the class from inside `P` to outside
  lands in `C`), a line under the class from inside the region to outside holds a member of `C`
  alike to its start, and reaches it (`«所经必同»`): the line's step going out of the region, placed
  on the line (`«定则内至外之线有出步»`, `Becoming.GrammarCrossing`), lands in `C`. So where no member of `C` is alike to the start,
  nothing outside the region is reached under that class (`«所经不同则不及»`). Read with a family as
  the region and its conditions as `C`: a class under which a line runs out of its family through
  its conditions must hold one of them, the one it passes. `SharedCondition.affecting_member_outside`
  is its case.
* **A regularity that holds a member's effects takes in all that follows (常闭则后皆续).** Call a
  member's effects *held* by a relation where everything it conditions is alike to it (`«所缘同于»`).
  This is a property of one member, not the constancy of a coarse net that `«闭合当且仅当有常»`
  calls closure. Under a constant class (`«有常»`), whatever is alike to a member whose effects the
  class holds conditions only what is alike to it (`«常闭则所缘同类»`), so everything downstream of
  anything alike to it is alike to it and on a line under the class from there (`«常闭则后皆续»`),
  and anything a line from a center reaches that is alike to the member carries the line on to all
  that follows it (`«常闭则所及皆及»`). Given constancy, holding a member's effects is equivalent to
  everything downstream of it being alike to it (`«常类之闭当且仅当后皆同类»`): the backward direction
  is the one-step case, and the forward direction is where constancy does its work.
* **Up to the net's end.** Constancy lets no line end after its first step (`«有常则相续不尽»`), so in
  a net where every line ends (finite and with no cycle, for example) no class under which anything
  continues is constant; `FiniteFamilies.one_not_constant` is a witness, where not even the one is. The laws above hold
  under a weaker condition, *constancy up to the net's end* (`«至终有常»`): whatever an alike
  occurrence conditions, this one conditions something alike to it, unless this one conditions
  nothing at all; so a line under the class ends only at an occurrence that conditions nothing.
  Constancy gives it (`«有常则至终有常»`), and a class under which a line ends at an occurrence that
  still conditions something lacks it (`«亡而网续则不至终有常»`, for any relation). Under it the same
  laws hold, for a member that conditions something where the start is another occurrence alike to
  it (`«至终常闭则后皆续»`, `«至终常闭则所及皆及»`, `«至终常类之闭当且仅当后皆同类»`); the constant forms
  are their corollaries. In a finite descent with two families the class of one family is narrower
  than the one, constant up to the net's end, and takes in everything downstream of its first birth
  and nothing of the other family, while the organism's class is not constant up to the net's end,
  its line ending at old age while that stage still conditions something (`FiniteFamilies`). In a finite net with two families
  sharing a condition they affect, every premise holds at once: the class holding the families with
  their condition is narrower than the one, constant up to the net's end and holds the first member's
  effects, and its line from the first family's first birth reaches the second family past the first
  member's end, while the member's class is not constant up to the net's end
  (`FiniteSharedCondition`).
* **What leaves the class follows the line (出类随线).** Under a class constant up to the net's end,
  where a member conditions something not alike to it, every occurrence alike to the member that
  conditions anything conditions something alike to that effect and outside the class (`«出类随行»`),
  so every one on its line does (`«出类随线»`); where one such occurrence conditions nothing alike to
  that effect, the class is not constant up to the net's end (`«出类不随则不至终有常»`, witness
  `CleanStep`). This is nearly the definition of constancy up to the net's end read at a member whose
  effects the class does not hold, and "alike to that effect" is only as fine as the class divides what lies
  outside it. Read with a class drawn by what a member intends [a reading; nothing in the Lean marks an
  intended effect]: such a class can be constant up to the net's end without holding the member's
  effects (`FiniteWake`, finite and without cycles), and then every occurrence on its line that conditions
  anything has an effect outside it.
* **At a member's class (本类至终有常).** Constancy up to the net's end asks its condition of every two
  alike occurrences, so it constrains every block of the class, what lies outside a member's class
  included. Asked only of the occurrences alike to a member, it is *constancy up to the net's end at the
  member's class* (`«本类至终有常»`), and the global condition is that at every member's class
  (`«至终有常之逐类»`). The laws above use only occurrences alike to the member, so each holds at the
  member's class and the global forms are corollaries (`«本类常闭则所缘同类»`, `«本类常闭则后皆续»`,
  `«本类常闭则所及皆及»`, `«本类常则闭当且仅当后皆同类»`, `«本类出类随行»`, `«本类出类随线»`,
  `«出类不随则本类不至终有常»`); a line that ends while it still conditions something fails it at its own
  class (`«亡而网续则本类不至终有常»`; the organism's case in `FiniteFamilies.member_not_constant_at` and
  `FiniteSharedCondition.member_not_constant_at`), and the condition asks more than that a line end only
  where the net does (`CleanStep.ends_where_net_ends`, `CleanStep.not_constant_at`). How what lies outside is
  divided bears on the condition only through what is alike to an effect that leaves the member's class
  (`«外分唯系出类之同»`). Where the member conditions something, the condition at its class is that the
  member and each alike occurrence follow each other: whatever an alike occurrence conditions is alike to
  something the member conditions, and whatever the member conditions, each alike occurrence that conditions
  anything conditions something alike to it (`«本类常当且仅当与己相随»`). So how what lies outside is
  divided bears on it only through what is alike to the member's own effects that leave the class
  (`«外分唯系己出之同»`), and where the class holds the member's effects, none of them leaves and the division
  is idle (`«闭则外分无关»`). Merging what lies outside keeps the condition (`«外合不失本类之常»`), so where a
  predicate decides the member's class, the split into that class and the rest asks least (`«二分»`,
  `«本类之常至二分»`), and under the split the condition is exactly that what stays and what leaves follow
  every alike occurrence that conditions anything (`«二分本类常当且仅当内外皆随»`); it holds where every
  such occurrence conditions something in the class and something outside (`«内外皆缘则二分本类常»`).
  Dividing what lies outside more finely can break it (`FinerOutside`), even there (`FinerWake`), and the
  global condition can fail under the split while the member's class keeps it and holds the member's
  effects, where alike occurrences outside differ in what they condition in the member's class
  (`UnevenOutside`).
* **Neither premise can be dropped from these laws.** Where a member's line runs through a condition
  but the member's effects leave its class, a constant class holding the member with the condition
  does not take in what the condition feeds (`Unclosed`); and where the class is not constant, even
  up to the net's end at the member's class, a member whose effects it holds need not have what
  follows them alike to it (`Inconstant`).
  `ThirdFed.constant_takes_third` in `Becoming.GrammarCases` needs constancy and not this premise: it
  is a one-step instance of `«有常之逐点»`, whose conclusion is alikeness to the member's next stage.
* **What the reach asks (后皆续当且仅当后皆同类).** With no regularity assumed, everything downstream of
  an occurrence lies on its line under a class exactly where everything downstream of it is alike to
  it (`«后皆同类则后皆续»`, `«后皆续当且仅当后皆同类»`), that is, where the class holds the effects of the
  occurrence and of each stage of its line (`«后皆续当且仅当自与线皆闭»`). So the reach asks that the
  class hold the occurrence's effects (`«后皆续则所缘同于»`), and, like the condition at its class
  (`«亡而网续则本类不至终有常»`), it excludes a line from the occurrence that ends while its last stage
  still conditions something (`«亡而网续则后不皆续»`; the organism's case in
  `FiniteFamilies.member_no_reach`). The laws above cannot drop the regularity (`Inconstant`), but the
  reach does not need it: a class can hold the effects of a member and of each stage of its line while
  failing the condition at its class, where an occurrence alike to the member, off its line, conditions
  only what leaves the class (`OtherLeaves`). Where the member conditions something and the class holds
  its effects, the condition holds the effects of every alike occurrence (`«本类常闭则所缘同类»`), on the
  member's line or not, which is more than the reach asks.

Every declaration has an empty axiom report. The decided predicate in `«所经必同»` is what lets the
proof ask, of each occurrence on the line, whether it is still inside the region: it decides every
step of the line as keeping to the region or going out of it (`«定则内至外之线有出步»`); no
classical principle is used.
-/

namespace Becoming

universe u

section Path

variable {α : Type u}

/-- **What a line must pass, its class must hold (所经必同).** Where every step under a class `E` from
inside a region `P` to outside it lands in `C`, a line under `E` from inside to outside holds a member
of `C` alike to its start, and reaches it. -/
theorem «所经必同» {R E : «际» α} (hE : «类» E) {P : α → Bool} {C : α → Prop}
    (exits : ∀ u v, P u = true → «续» R E u v → P v = false → C v) {x y : α}
    (inside : P x = true) (outside : P y = false) (reached : «所及» R E x y) :
    ∃ c, C c ∧ E x c ∧ «所及» R E x c := by
  match reached with
  | .inl e => exact absurd (e ▸ inside) (by rw [outside]; exact Bool.false_ne_true)
  | .inr line =>
    have decided : ∀ a, P a = true ∨ ¬ P a = true := fun a =>
      Bool.casesOn (motive := fun b => b = true ∨ ¬ b = true) (P a) (.inr Bool.false_ne_true)
        (.inl rfl)
    have off : ∀ b : Bool, ¬ b = true → b = false := fun b =>
      Bool.casesOn (motive := fun b => ¬ b = true → b = false) b (fun _ => rfl)
        (fun no => absurd rfl no)
    match «定则内至外之线有出步» (P := fun a => P a = true) decided line inside
        (show ¬ P y = true from fun held => Bool.false_ne_true (outside ▸ held)) with
    | ⟨u, v, step, ⟨member, out⟩, before, _⟩ =>
      have onLine : «相续» R E x v := match before with
        | .inl same => by subst same; exact .one step
        | .inr toU => «及之传递» toU (.one step)
      exact ⟨v, exits u v member step (off (P v) out), «线内同类» hE onLine, .inr onLine⟩

/-- **Where the class holds nothing the line must pass, nothing beyond is reached.** -/
theorem «所经不同则不及» {R E : «际» α} (hE : «类» E) {P : α → Bool} {C : α → Prop}
    (exits : ∀ u v, P u = true → «续» R E u v → P v = false → C v) {x y : α}
    (inside : P x = true) (outside : P y = false) (apart : ∀ c, C c → ¬ E x c) :
    ¬ «所及» R E x y := fun reached =>
  match «所经必同» hE exits inside outside reached with
  | ⟨c, hc, alike, _⟩ => apart c hc alike

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
of it is alike to it (后皆续当且仅当后皆同类).** No regularity is assumed: the forward direction is that the
ends of a line under a class are alike (`«线内同类»`), the backward one `«后皆同类则后皆续»`. -/
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

/-- **Everything downstream of a member lies on its line under a class exactly where the class holds the
effects of the member and of each stage of its line (后皆续当且仅当自与线皆闭).** No regularity is assumed.
Forward, each stage of the line and what it conditions are alike to the member (`«后皆续当且仅当后皆同类»`);
backward, each step from the member or from a stage of its line is a step under the class. -/
theorem «后皆续当且仅当自与线皆闭» {R E : «际» α} (hE : «类» E) {m : α} :
    (∀ t, «及» R m t → «所及» R E m t) ↔
      «所缘同于» R E m ∧ ∀ y, «相续» R E m y → «所缘同于» R E y :=
  ⟨fun reach =>
     ⟨«后皆续则所缘同于» hE reach,
      fun y line v step => hE.trans (hE.symm («线内同类» hE line))
        ((«后皆续当且仅当后皆同类» hE).mp reach v («及之传递» («相续含于及» R E m y line) (.one step)))⟩,
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

/-- **Where a line from a member ends while its last stage still conditions something, not everything
downstream of the member lies on its line (亡而网续则后不皆续).** Like the condition at the member's class
(`«亡而网续则本类不至终有常»`), the reach excludes such a line; no regularity is assumed: the reach would hold
the last stage's effects (`«后皆续当且仅当自与线皆闭»`), so the line would continue from it. -/
theorem «亡而网续则后不皆续» {R E : «际» α} (hE : «类» E) {m y : α} (line : «相续» R E m y)
    (ends : «亡» R E y) (goes : ∃ w, R y w) : ¬ ∀ t, «及» R m t → «所及» R E m t := fun reach =>
  match goes with
  | ⟨w, hw⟩ => ends ⟨w, hw, ((«后皆续当且仅当自与线皆闭» hE).mp reach).2 y line w hw⟩

/-- **Constancy up to the net's end (至终有常).** Whatever an alike occurrence conditions, this one
conditions something alike to it, unless this one conditions nothing at all; so a line under the class
ends only at an occurrence that conditions nothing. -/
def «至终有常» (R E : «际» α) : Prop :=
  ∀ u u', E u u' → ∀ v, R u v → (∃ v', R u' v' ∧ E v v') ∨ ∀ w, ¬ R u' w

/-- Constancy is constancy up to the net's end. -/
theorem «有常则至终有常» {R E : «际» α} (constant : «有常» R E) : «至终有常» R E :=
  fun u u' e v r => .inl ((«有常之逐点» R E).mp constant u u' e v r)

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

/-- **Constancy up to the net's end is that at every member's class (至终有常之逐类).** The global condition
asks of every block of the class, what lies outside any one member's class included, what the condition
at a member's class asks of that member's block. -/
theorem «至终有常之逐类» {R E : «际» α} (hE : «类» E) :
    «至终有常» R E ↔ ∀ m, «本类至终有常» R E m :=
  ⟨«至终有常则本类至终有常» hE, fun each u u' e => each u u u' (hE.refl u) e⟩

/-- **A relation under which a line ends at an occurrence that still conditions something is not
constant up to the net's end (亡而网续则不至终有常).** The up-to-the-end form of `«有亡之续则不有常»`,
for any relation `E`, a class or not. -/
theorem «亡而网续则不至终有常» {R E : «际» α} {x y : α} (hxy : «续» R E x y)
    (ends : «亡» R E y) (goes : ∃ w, R y w) : ¬ «至终有常» R E := fun constant =>
  match constant x y hxy.2 y hxy.1 with
  | .inl ⟨v', hv', ev⟩ => ends ⟨v', hv', ev⟩
  | .inr stops => match goes with
    | ⟨w, hw⟩ => stops w hw

/-- **A line that ends while it still conditions something fails the condition at its class
(亡而网续则本类不至终有常).** Where a line continues from `x` to `y`, both alike to `m`, and ends at `y` while
`y` still conditions something, the relation is not constant up to the net's end at `m`'s class; for any
relation `E`, a class or not. -/
theorem «亡而网续则本类不至终有常» {R E : «际» α} {m x y : α} (mx : E m x) (my : E m y)
    (hxy : «续» R E x y) (ends : «亡» R E y) (goes : ∃ w, R y w) : ¬ «本类至终有常» R E m :=
  fun atClass => match atClass x y mx my y hxy.1 with
  | .inl ⟨v', hv', ev⟩ => ends ⟨v', hv', ev⟩
  | .inr stops => match goes with
    | ⟨w, hw⟩ => stops w hw

/-- **At a member's class, whatever is alike to a member that conditions something, and whose effects the
class holds, conditions only what is alike to it.** -/
theorem «本类常闭则所缘同类» {R E : «际» α} (hE : «类» E) {m : α} (atClass : «本类至终有常» R E m)
    (goes : ∃ w, R m w) (held : «所缘同于» R E m) {u v : α} (alike : E u m) (step : R u v) : E v m :=
  match atClass u m (hE.symm alike) (hE.refl m) v step with
  | .inl ⟨v', hv', ev⟩ => hE.trans ev (hE.symm (held v' hv'))
  | .inr stops => match goes with
    | ⟨w, hw⟩ => absurd hw (stops w)

/-- **Up to the net's end, whatever is alike to a member that conditions something, and whose effects
the class holds, conditions only what is alike to it.** -/
theorem «至终常闭则所缘同类» {R E : «际» α} (hE : «类» E) (constant : «至终有常» R E) {m : α}
    (goes : ∃ w, R m w) (held : «所缘同于» R E m) {u v : α} (alike : E u m) (step : R u v) : E v m :=
  «本类常闭则所缘同类» hE («至终有常则本类至终有常» hE constant m) goes held alike step

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

/-- **A regularity that holds a member's effects takes in all that follows (常闭则后皆续), up to the
net's end.** Under a class constant up to the net's end, everything downstream of anything alike to a
member that conditions something, and whose effects the class holds, is alike to it and lies on a line
under the class from there. That the member conditions something is needed where the start is another
occurrence alike to it. -/
theorem «至终常闭则后皆续» {R E : «际» α} (hE : «类» E) (constant : «至终有常» R E) {m : α}
    (goes : ∃ w, R m w) (held : «所缘同于» R E m) {c t : α} (alike : E c m) (down : «及» R c t) :
    E t m ∧ «相续» R E c t :=
  «本类常闭则后皆续» hE («至终有常则本类至终有常» hE constant m) goes held alike down

/-- **Under a constant class, whatever is alike to a member whose effects the class holds conditions
only what is alike to it.** -/
theorem «常闭则所缘同类» {R E : «际» α} (hE : «类» E) (constant : «有常» R E) {m : α}
    (held : «所缘同于» R E m) {u v : α} (alike : E u m) (step : R u v) : E v m :=
  «至终常闭则所缘同类» hE («有常则至终有常» constant) («有常则可续» constant _ _ _ alike step) held
    alike step

/-- **A regularity that holds a member's effects takes in all that follows (常闭则后皆续).** Under a
constant class, everything downstream of anything alike to a member whose effects the class holds is
alike to it and lies on a line under the class from there. -/
theorem «常闭则后皆续» {R E : «际» α} (hE : «类» E) (constant : «有常» R E) {m : α}
    (held : «所缘同于» R E m) {c t : α} (alike : E c m) (down : «及» R c t) :
    E t m ∧ «相续» R E c t :=
  match down with
  | .one step => «至终常闭则后皆续» hE («有常则至终有常» constant)
      («有常则可续» constant _ _ _ alike step) held alike (.one step)
  | .more step rest => «至终常闭则后皆续» hE («有常则至终有常» constant)
      («有常则可续» constant _ _ _ alike step) held alike (.more step rest)

/-- **What a line reaches alike to a member that conditions something, and whose effects the class holds,
it carries on to all that follows**, at the member's class. -/
theorem «本类常闭则所及皆及» {R E : «际» α} (hE : «类» E) {m x c t : α} (atClass : «本类至终有常» R E m)
    (goes : ∃ w, R m w) (held : «所缘同于» R E m) (toC : «所及» R E x c) (alike : E c m)
    (down : «及» R c t) : «所及» R E x t :=
  «所及之传递» toC (.inr («本类常闭则后皆续» hE atClass goes held alike down).2)

/-- **What a line reaches alike to a member that conditions something, and whose effects the class
holds, it carries on to all that follows**, up to the net's end. -/
theorem «至终常闭则所及皆及» {R E : «际» α} (hE : «类» E) (constant : «至终有常» R E) {m x c t : α}
    (goes : ∃ w, R m w) (held : «所缘同于» R E m) (toC : «所及» R E x c) (alike : E c m)
    (down : «及» R c t) : «所及» R E x t :=
  «本类常闭则所及皆及» hE («至终有常则本类至终有常» hE constant m) goes held toC alike down

/-- **What a line reaches alike to a member whose effects the class holds, it carries on to all that
follows.** Under a constant class, where a line from a center reaches an occurrence alike to such a
member, it reaches everything downstream of that occurrence. -/
theorem «常闭则所及皆及» {R E : «际» α} (hE : «类» E) (constant : «有常» R E) {m x c t : α}
    (held : «所缘同于» R E m) (toC : «所及» R E x c) (alike : E c m) (down : «及» R c t) :
    «所及» R E x t :=
  «所及之传递» toC (.inr («常闭则后皆续» hE constant held alike down).2)

/-- **What leaves the class follows each alike occurrence (出类随行), at the member's class.** Under a
class constant up to the net's end at a member's class, where the member conditions something not alike
to it, whatever is alike to the member and conditions anything conditions something alike to that
effect and not alike to itself. -/
theorem «本类出类随行» {R E : «际» α} (hE : «类» E) {m c u : α} (atClass : «本类至终有常» R E m)
    (alike : E c m) (effect : R m u) (outside : ¬ E m u) (goes : ∃ w, R c w) :
    ∃ x, R c x ∧ E u x ∧ ¬ E c x :=
  match atClass m c (hE.refl m) (hE.symm alike) u effect with
  | .inl ⟨x, hx, ux⟩ => ⟨x, hx, ux, fun cx => outside (hE.trans (hE.symm alike) (hE.trans cx (hE.symm ux)))⟩
  | .inr stops => match goes with
    | ⟨w, hw⟩ => absurd hw (stops w)

/-- **What leaves the class follows each alike occurrence (出类随行).** Under a class constant up to the
net's end, where a member conditions something not alike to it, whatever is alike to the member and
conditions anything conditions something alike to that effect and not alike to itself. Nearly the
definition of constancy up to the net's end, read at a member whose effects the class does not hold. -/
theorem «出类随行» {R E : «际» α} (hE : «类» E) (constant : «至终有常» R E) {m c u : α}
    (alike : E c m) (effect : R m u) (outside : ¬ E m u) (goes : ∃ w, R c w) :
    ∃ x, R c x ∧ E u x ∧ ¬ E c x :=
  «本类出类随行» hE («至终有常则本类至终有常» hE constant m) alike effect outside goes

/-- **What leaves the class follows the line (出类随线), at the member's class.** Under a class constant up
to the net's end at a member's class, where the member conditions something not alike to it, every
occurrence on its line under the class that conditions anything conditions something alike to that effect
and outside the class. -/
theorem «本类出类随线» {R E : «际» α} (hE : «类» E) {m c u : α} (atClass : «本类至终有常» R E m)
    (line : «所及» R E m c) (effect : R m u) (outside : ¬ E m u) (goes : ∃ w, R c w) :
    ∃ x, R c x ∧ E u x ∧ ¬ E c x :=
  «本类出类随行» hE atClass
    (match line with
     | .inl e => e ▸ hE.refl m
     | .inr l => hE.symm («线内同类» hE l)) effect outside goes

/-- **What leaves the class follows the line (出类随线).** Under a class constant up to the net's end,
where a member conditions something not alike to it, every occurrence on its line under the class that
conditions anything conditions something alike to that effect and outside the class. -/
theorem «出类随线» {R E : «际» α} (hE : «类» E) (constant : «至终有常» R E) {m c u : α}
    (line : «所及» R E m c) (effect : R m u) (outside : ¬ E m u) (goes : ∃ w, R c w) :
    ∃ x, R c x ∧ E u x ∧ ¬ E c x :=
  «本类出类随线» hE («至终有常则本类至终有常» hE constant m) line effect outside goes

/-- **Where nothing leaving the class follows, the class is not constant up to the net's end at the member's
class (出类不随则本类不至终有常).** Where a member conditions something not alike to it, and an occurrence
alike to the member conditions something but nothing alike to that effect, the class is not constant up to
the net's end at the member's class. -/
theorem «出类不随则本类不至终有常» {R E : «际» α} (hE : «类» E) {m c u : α} (alike : E c m)
    (effect : R m u) (outside : ¬ E m u) (goes : ∃ w, R c w) (clean : ∀ x, R c x → ¬ E u x) :
    ¬ «本类至终有常» R E m := fun atClass =>
  match «本类出类随行» hE atClass alike effect outside goes with
  | ⟨x, hx, ux, _⟩ => clean x hx ux

/-- **Where nothing leaving the class follows, the class is not constant up to the net's end
(出类不随则不至终有常).** Where a member conditions something not alike to it, and an occurrence alike
to the member conditions something but nothing alike to that effect, the class is not constant up to
the net's end. -/
theorem «出类不随则不至终有常» {R E : «际» α} (hE : «类» E) {m c u : α} (alike : E c m)
    (effect : R m u) (outside : ¬ E m u) (goes : ∃ w, R c w) (clean : ∀ x, R c x → ¬ E u x) :
    ¬ «至终有常» R E := fun constant =>
  «出类不随则本类不至终有常» hE alike effect outside goes clean («至终有常则本类至终有常» hE constant m)

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

/-- **Up to the net's end, a class holds a member's effects exactly where everything downstream of the
member is alike to it.** The backward direction is the one-step case; the forward direction is where
constancy up to the net's end does its work. -/
theorem «至终常类之闭当且仅当后皆同类» {R E : «际» α} (hE : «类» E) (constant : «至终有常» R E) {m : α} :
    «所缘同于» R E m ↔ ∀ t, «及» R m t → E m t :=
  «本类常则闭当且仅当后皆同类» hE («至终有常则本类至终有常» hE constant m)

/-- **Under constancy, a class holds a member's effects exactly where everything downstream of the
member is alike to it.** -/
theorem «常类之闭当且仅当后皆同类» {R E : «际» α} (hE : «类» E) (constant : «有常» R E) {m : α} :
    «所缘同于» R E m ↔ ∀ t, «及» R m t → E m t :=
  «至终常类之闭当且仅当后皆同类» hE («有常则至终有常» constant)

/-- **Merging what lies outside a member's class keeps the condition at that class (外合不失本类之常).**
Where `F` relates whatever `E` relates and holds alike to `m` only what `E` does, constancy up to the net's
end at `m`'s class under `E` gives it under `F`: what is alike to an effect under `E` is alike to it under
`F`. -/
theorem «外合不失本类之常» {R E F : «际» α} {m : α} (coarser : ∀ x y, E x y → F x y)
    (same : ∀ x, F m x → E m x) (atClass : «本类至终有常» R E m) : «本类至终有常» R F m :=
  fun u u' mu mu' v step => match atClass u u' (same u mu) (same u' mu') v step with
  | .inl ⟨v', hv', ev⟩ => .inl ⟨v', hv', coarser v v' ev⟩
  | .inr stops => .inr stops

/-- **How what lies outside is divided bears on the condition only through what is alike to an effect that
leaves the class (外分唯系出类之同).** Where classes `E` and `F` hold the same occurrences alike to `m`, and,
for whatever an occurrence alike to `m` conditions, either it is alike to `m` or `E` and `F` agree on what is
alike to it, constancy up to the net's end at `m`'s class holds under `E` exactly where it holds under `F`. -/
theorem «外分唯系出类之同» {R E F : «际» α} (hE : «类» E) (hF : «类» F) {m : α}
    (same : ∀ x, E m x ↔ F m x)
    (outside : ∀ u v v', E m u → R u v → E m v ∨ (E v v' ↔ F v v')) :
    «本类至终有常» R E m ↔ «本类至终有常» R F m :=
  have agree : ∀ u v v', E m u → R u v → (E v v' ↔ F v v') := fun u v v' mu step =>
    match outside u v v' mu step with
    | .inl mv =>
      ⟨fun ev => hF.trans (hF.symm ((same v).mp mv)) ((same v').mp (hE.trans mv ev)),
       fun fv => hE.trans (hE.symm mv) ((same v').mpr (hF.trans ((same v).mp mv) fv))⟩
    | .inr both => both
  ⟨fun atClass u u' mu mu' v step =>
     match atClass u u' ((same u).mpr mu) ((same u').mpr mu') v step with
     | .inl ⟨v', hv', ev⟩ => .inl ⟨v', hv', (agree u v v' ((same u).mpr mu) step).mp ev⟩
     | .inr stops => .inr stops,
   fun atClass u u' mu mu' v step =>
     match atClass u u' ((same u).mp mu) ((same u').mp mu') v step with
     | .inl ⟨v', hv', fv⟩ => .inl ⟨v', hv', (agree u v v' mu step).mpr fv⟩
     | .inr stops => .inr stops⟩

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

/-- Two values of `Bool` that each differ from a third are the same. -/
theorem «异三则同» : ∀ {a b c : Bool}, ¬ a = c → ¬ b = c → b = a
  | true, true, _, _, _ => rfl
  | false, false, _, _, _ => rfl
  | true, false, true, h, _ => absurd rfl h
  | true, false, false, _, h => absurd rfl h
  | false, true, true, _, h => absurd rfl h
  | false, true, false, h, _ => absurd rfl h

/-- **The split asks least (本类之常至二分).** Where `P` decides which occurrences are alike to `m` under a
class `E`, constancy up to the net's end at `m`'s class under `E` gives it under the split by `P`, whose two
blocks are `m`'s class and the rest. -/
theorem «本类之常至二分» {R E : «际» α} (hE : «类» E) {P : α → Bool} {m : α}
    (decides : ∀ x, E m x ↔ P x = P m) (atClass : «本类至终有常» R E m) :
    «本类至终有常» R («二分» P) m :=
  «外合不失本类之常»
    (fun x y exy => match decEq (P x) (P m) with
      | isTrue xm => Eq.trans xm (Eq.symm ((decides y).mp (hE.trans ((decides x).mpr xm) exy)))
      | isFalse xm =>
        «异三则同» (fun ym => xm ((decides x).mp (hE.trans ((decides y).mpr ym) (hE.symm exy)))) xm)
    (fun x mx => (decides x).mpr (Eq.symm mx)) atClass

/-- **Under the split, the condition at a member's class is that what stays follows and what leaves
follows (二分本类常当且仅当内外皆随).** Constancy up to the net's end at `m`'s block of the split by `P` holds
exactly where, for any two occurrences `u` and `u'` in that block and anything `u` conditions, `u'`
conditions something in the block if that stays in it, and something outside if that leaves it, unless
`u'` conditions nothing. -/
theorem «二分本类常当且仅当内外皆随» {R : «际» α} {P : α → Bool} {m : α} :
    «本类至终有常» R («二分» P) m ↔
      ∀ u u', P m = P u → P m = P u' → ∀ v, R u v →
        (P u = P v → (∃ x, R u' x ∧ P u' = P x) ∨ ∀ w, ¬ R u' w) ∧
        (¬ P u = P v → (∃ x, R u' x ∧ ¬ P u' = P x) ∨ ∀ w, ¬ R u' w) :=
  ⟨fun atClass u u' mu mu' v step =>
     have uu : P u' = P u := Eq.trans (Eq.symm mu') mu
     ⟨fun stays => match atClass u u' mu mu' v step with
        | .inl ⟨x, hx, vx⟩ => .inl ⟨x, hx, Eq.trans uu (Eq.trans stays vx)⟩
        | .inr stops => .inr stops,
      fun leaves => match atClass u u' mu mu' v step with
        | .inl ⟨x, hx, vx⟩ =>
          .inl ⟨x, hx, fun ux => leaves (Eq.trans (Eq.symm uu) (Eq.trans ux (Eq.symm vx)))⟩
        | .inr stops => .inr stops⟩,
   fun both u u' mu mu' v step =>
     have uu : P u' = P u := Eq.trans (Eq.symm mu') mu
     match decEq (P u) (P v) with
     | isTrue stays => match (both u u' mu mu' v step).1 stays with
       | .inl ⟨x, hx, ux⟩ => .inl ⟨x, hx, Eq.trans (Eq.symm stays) (Eq.trans (Eq.symm uu) ux)⟩
       | .inr stops => .inr stops
     | isFalse leaves => match (both u u' mu mu' v step).2 leaves with
       | .inl ⟨x, hx, ux⟩ =>
         .inl ⟨x, hx, «异三则同» (fun xu => ux (Eq.trans uu (Eq.symm xu))) (fun vu => leaves (Eq.symm vu))⟩
       | .inr stops => .inr stops⟩

/-- **Where every occurrence alike to the member that conditions anything conditions something in its
block and something outside it, the split meets the condition at the member's class (内外皆缘则二分本类常).** -/
theorem «内外皆缘则二分本类常» {R : «际» α} {P : α → Bool} {m : α}
    (both : ∀ u, P m = P u →
      ((∃ x, R u x ∧ P u = P x) ∧ (∃ x, R u x ∧ ¬ P u = P x)) ∨ ∀ w, ¬ R u w) :
    «本类至终有常» R («二分» P) m :=
  «二分本类常当且仅当内外皆随».mpr fun _ u' _ mu' _ _ =>
    match both u' mu' with
    | .inl ⟨inside, outside⟩ => ⟨fun _ => .inl inside, fun _ => .inl outside⟩
    | .inr stops => ⟨fun _ => .inr stops, fun _ => .inr stops⟩

end Path

/-! ## Neither premise can be dropped from these laws -/

namespace Unclosed

/-! A member `m` conditioning a condition `c` and an effect `v`, the condition conditioning the member
back and feeding `t`; `m` and `c` in one class, `t` and `v` in another. The class is constant and the
member's line runs through the condition, but the member's effect `v` leaves its class, and what the
condition feeds is not reached. -/

inductive Occ | c | m | t | v

def step : «际» Occ
  | .c, .c => False
  | .c, .m => True
  | .c, .t => True
  | .c, .v => False
  | .m, .c => True
  | .m, .m => False
  | .m, .t => False
  | .m, .v => True
  | .t, .c => False
  | .t, .m => False
  | .t, .t => False
  | .t, .v => False
  | .v, .c => False
  | .v, .m => False
  | .v, .t => False
  | .v, .v => False

/-- The first class holds the condition and the member, the second what they condition beyond. -/
def upper : Occ → Bool
  | .c => true
  | .m => true
  | .t => false
  | .v => false

def same : «际» Occ := fun x y => upper x = upper y

theorem same_class : «类» same := ⟨fun _ => rfl, Eq.symm, Eq.trans⟩

theorem constant : «有常» step same := by
  apply («有常之逐点» step same).mpr
  intro u u' e x r
  match u, u', x, e, r with
  | .c, .c, .m, _, _ => exact ⟨.m, trivial, rfl⟩
  | .c, .c, .t, _, _ => exact ⟨.t, trivial, rfl⟩
  | .c, .m, .m, _, _ => exact ⟨.c, trivial, rfl⟩
  | .c, .m, .t, _, _ => exact ⟨.v, trivial, rfl⟩
  | .m, .c, .c, _, _ => exact ⟨.m, trivial, rfl⟩
  | .m, .c, .v, _, _ => exact ⟨.t, trivial, rfl⟩
  | .m, .m, .c, _, _ => exact ⟨.c, trivial, rfl⟩
  | .m, .m, .v, _, _ => exact ⟨.v, trivial, rfl⟩
  | .c, .t, _, e, _ => exact Bool.noConfusion e
  | .c, .v, _, e, _ => exact Bool.noConfusion e
  | .m, .t, _, e, _ => exact Bool.noConfusion e
  | .m, .v, _, e, _ => exact Bool.noConfusion e

/-- **A constant class holding a member with a condition its line runs through, where the member's
effects leave the class, does not take in what the condition feeds.** -/
theorem not_taken_in :
    «续» step same .m .c ∧ step .c .t ∧ ¬ «所缘同于» step same .m ∧ ¬ same .t .m ∧
      ¬ «所及» step same .m .t :=
  ⟨⟨trivial, rfl⟩, trivial, fun held => Bool.noConfusion (held .v trivial),
   fun e => Bool.noConfusion e,
   fun reached => match reached with
     | .inl e => Occ.noConfusion e
     | .inr line => Bool.noConfusion («线内同类» same_class line)⟩

end Unclosed

namespace Inconstant

/-! A member `m` conditioning `v` alike to it, `v` conditioning `w` in a second class: the class holds
the member's effects but is not constant, even up to the net's end at the member's class, and what follows
its effect is not alike to it. -/

inductive Occ | m | v | w

def step : «际» Occ
  | .m, .m => False
  | .m, .v => True
  | .m, .w => False
  | .v, .m => False
  | .v, .v => False
  | .v, .w => True
  | .w, .m => False
  | .w, .v => False
  | .w, .w => False

def upper : Occ → Bool
  | .m => true
  | .v => true
  | .w => false

def same : «际» Occ := fun x y => upper x = upper y

theorem same_class : «类» same := ⟨fun _ => rfl, Eq.symm, Eq.trans⟩

/-- **The class is not constant up to the net's end even at the member's class**: it holds the member's
effects, and were it constant up to the net's end at the member's class, everything downstream of the
member would be alike to it (`«本类常则闭当且仅当后皆同类»`), but `w` is not. -/
theorem not_constant_at : ¬ «本类至终有常» step same .m := fun atClass =>
  Bool.noConfusion (((«本类常则闭当且仅当后皆同类» same_class atClass).mp (fun x r => match x, r with
      | .v, _ => rfl)) .w
    («及».more (R := step) (x := .m) (y := .v) (z := .w) trivial («及».one (R := step) (x := .v) (y := .w) trivial)))

/-- **A class that holds a member's effects but is not constant, even up to the net's end, need not
have what follows them alike to the member.** -/
theorem not_all_follow :
    «所缘同于» step same .m ∧ ¬ «至终有常» step same ∧ ¬ «有常» step same ∧ «及» step .m .w ∧
      ¬ same .w .m :=
  have notToEnd : ¬ «至终有常» step same := fun constant =>
    not_constant_at («至终有常则本类至终有常» same_class constant .m)
  ⟨fun x r => match x, r with
     | .v, _ => rfl,
   notToEnd,
   fun constant => notToEnd («有常则至终有常» constant),
   «及».more (R := step) (x := .m) (y := .v) (z := .w) trivial («及».one (R := step) (x := .v) (y := .w) trivial),
   fun e => Bool.noConfusion e⟩

end Inconstant

namespace FiniteFamilies

/-! Two families, each with two members in turn, each member young then old, the second member's birth
following the first's old age, and nothing after the second member's old age: a finite net in which
every line ends. An occurrence is its family and its stage `0` to `3` (first young, first old, second
young, second old). -/

abbrev Occ := Bool × Nat

/-- Within a family, each stage below the last conditions the next. -/
def step : «际» Occ := fun x y => x.1 = y.1 ∧ y.2 = x.2 + 1 ∧ x.2 < 3

/-- The class of a family. -/
def family : «际» Occ := fun x y => x.1 = y.1

/-- The class of one member: its family and whether it is the second member. -/
def member : «际» Occ := fun x y => x.1 = y.1 ∧ (decide (2 ≤ x.2) = decide (2 ≤ y.2))

theorem family_class : «类» family := ⟨fun _ => rfl, Eq.symm, Eq.trans⟩

/-- **The family's class is narrower than the one**: the two families are not alike. -/
theorem family_narrower : ¬ family (false, 0) (true, 0) := fun e => Bool.noConfusion e

/-- **In a finite net the one is not constant**: the second member's old age conditions nothing. -/
theorem one_not_constant : ¬ «有常» step («一» : «际» Occ) := fun constant =>
  match («有常之逐点» step «一»).mp constant (false, 2) (false, 3) trivial (false, 3)
      ⟨rfl, rfl, Nat.lt_succ_self 2⟩ with
  | ⟨_, ⟨_, _, h⟩, _⟩ => Nat.lt_irrefl 3 h

/-- **Up to the net's end the family's class is constant**: whatever an occurrence of the family
conditions, every other conditions the next stage of the same family, unless it is the last. -/
theorem family_constant_to_end : «至终有常» step family := by
  intro u u' e v r
  match Nat.decLt u'.2 3 with
  | .isTrue h => exact .inl ⟨(u'.1, u'.2 + 1), ⟨rfl, rfl, h⟩, r.1.symm.trans e⟩
  | .isFalse h => exact .inr (fun _ s => h s.2.2)

/-- The organism's relation is a class. -/
theorem member_class : «类» member :=
  ⟨fun _ => ⟨rfl, rfl⟩, fun ⟨a, b⟩ => ⟨a.symm, b.symm⟩, fun ⟨a, b⟩ ⟨c, d⟩ => ⟨a.trans c, b.trans d⟩⟩

/-- **The organism's class is not constant up to the net's end, even at the first member's class**: the
first member's line ends at its old age, which still conditions the second member's birth. -/
theorem member_not_constant_at : ¬ «本类至终有常» step member (false, 0) :=
  «亡而网续则本类不至终有常» (x := (false, 0)) (y := (false, 1)) ⟨rfl, rfl⟩ ⟨rfl, rfl⟩
    ⟨⟨rfl, rfl, Nat.lt_succ_of_le (Nat.le_succ_of_le (Nat.le_succ 0))⟩, rfl, rfl⟩
    (fun ⟨z, ⟨_, e2, _⟩, ⟨_, d⟩⟩ => by
      have hz : z.2 = 2 := e2
      rw [hz] at d
      exact Bool.noConfusion d)
    ⟨(false, 2), rfl, rfl, Nat.lt_succ_of_le (Nat.le_succ_of_le (Nat.le_refl 1))⟩

/-- **The organism's class is not constant up to the net's end** (from `member_not_constant_at`). -/
theorem member_not_constant_to_end : ¬ «至终有常» step member := fun constant =>
  member_not_constant_at («至终有常则本类至终有常» member_class constant (false, 0))

/-- **Under the organism's class, not everything downstream of the first member's birth lies on its line**:
the line ends at the member's old age, which still conditions the second member's birth
(`«亡而网续则后不皆续»`). -/
theorem member_no_reach : ¬ ∀ t, «及» step (false, 0) t → «所及» step member (false, 0) t :=
  «亡而网续则后不皆续» (m := (false, 0)) (y := (false, 1)) member_class
    («及».one ⟨⟨rfl, rfl, Nat.lt_succ_of_le (Nat.le_succ_of_le (Nat.le_succ 0))⟩, rfl, rfl⟩)
    (fun ⟨z, ⟨_, e2, _⟩, ⟨_, d⟩⟩ => by
      have hz : z.2 = 2 := e2
      rw [hz] at d
      exact Bool.noConfusion d)
    ⟨(false, 2), rfl, rfl, Nat.lt_succ_of_le (Nat.le_succ_of_le (Nat.le_refl 1))⟩

/-- Everything the first birth of a family conditions is in its family. -/
theorem first_birth_held (f : Bool) : «所缘同于» step family (f, 0) := fun _ s => s.1

/-- **Up to the net's end, the family's class takes in everything downstream of the family's first
birth.** -/
theorem family_takes_in_all {f : Bool} {t : Occ} (down : «及» step (f, 0) t) :
    «所及» step family (f, 0) t :=
  «至终常闭则所及皆及» (m := (f, 0)) family_class family_constant_to_end ⟨(f, 1), rfl, rfl, Nat.zero_lt_succ 2⟩
    (first_birth_held f) (.inl rfl) (family_class.refl _) down

/-- **And nothing of the other family**: no line under any relation leaves a family. -/
theorem other_family_outside (E : «际» Occ) (n : Nat) : ¬ «所及» step E (false, 0) (true, n) := by
  have stays : ∀ x y, «相续» step E x y → y.1 = x.1 := by
    intro x y line
    induction line with
    | one c => exact c.1.1.symm
    | more c _ ih => exact ih.trans c.1.1.symm
  intro reached
  match reached with
  | .inl e => exact Bool.noConfusion (congrArg Prod.fst e)
  | .inr line => exact Bool.noConfusion (stays _ _ line)

end FiniteFamilies


namespace FiniteSharedCondition

/-! Two families and a condition they share, each of four stages, and a fourth thing joined to nothing.
Each family's stage conditions its next and the condition's next; the condition's stage conditions
each family's next and its own; a stage `3` conditions nothing. The class "living or the
condition" holds the families with the condition and leaves the fourth thing out. Here every premise
of the path holds at once: a member's line ends, the class is constant up to the net's end and
narrower than the one, it holds the first member's effects, and its line from the first family's
first birth reaches the second family past that member's end. -/

/-- The first family, the second, the shared condition, and a fourth thing joined to nothing. -/
inductive Kind | a | b | r | x

abbrev Occ := Kind × Nat

/-- Which kinds condition which. -/
def link : Kind → Kind → Prop
  | .a, .a => True
  | .a, .b => False
  | .a, .r => True
  | .a, .x => False
  | .b, .a => False
  | .b, .b => True
  | .b, .r => True
  | .b, .x => False
  | .r, .a => True
  | .r, .b => True
  | .r, .r => True
  | .r, .x => False
  | .x, .a => False
  | .x, .b => False
  | .x, .r => False
  | .x, .x => False

/-- A stage below the last conditions the next stage of each kind it is linked to. -/
def step : «际» Occ := fun u v => link u.1 v.1 ∧ v.2 = u.2 + 1 ∧ u.2 < 3

/-- Living or the condition, as against the fourth thing. -/
def joined : Kind → Bool
  | .a => true
  | .b => true
  | .r => true
  | .x => false

/-- The class holding the families with their condition. -/
def held : «际» Occ := fun u v => joined u.1 = joined v.1

/-- The class of one member: its kind and whether it is the second member (stages `2` and `3`). -/
def member : «际» Occ := fun u v => u.1 = v.1 ∧ decide (2 ≤ u.2) = decide (2 ≤ v.2)

theorem held_class : «类» held := ⟨fun _ => rfl, Eq.symm, Eq.trans⟩

theorem link_joined : ∀ k k', link k k' → joined k = true ∧ joined k' = true
  | .a, .a, _ => ⟨rfl, rfl⟩
  | .a, .r, _ => ⟨rfl, rfl⟩
  | .b, .b, _ => ⟨rfl, rfl⟩
  | .b, .r, _ => ⟨rfl, rfl⟩
  | .r, .a, _ => ⟨rfl, rfl⟩
  | .r, .b, _ => ⟨rfl, rfl⟩
  | .r, .r, _ => ⟨rfl, rfl⟩
  | .a, .b, h => False.elim h
  | .a, .x, h => False.elim h
  | .b, .a, h => False.elim h
  | .b, .x, h => False.elim h
  | .r, .x, h => False.elim h
  | .x, .a, h => False.elim h
  | .x, .b, h => False.elim h
  | .x, .r, h => False.elim h
  | .x, .x, h => False.elim h

theorem link_self : ∀ k, joined k = true → link k k
  | .a, _ => trivial
  | .b, _ => trivial
  | .r, _ => trivial
  | .x, h => Bool.noConfusion h

/-- **The class is narrower than the one**: it leaves the fourth thing out. -/
theorem held_narrower : ¬ held (.a, 0) (.x, 0) := fun e => Bool.noConfusion e

/-- **In this finite net the one is not constant.** -/
theorem one_not_constant : ¬ «有常» step («一» : «际» Occ) := fun constant =>
  match («有常之逐点» step «一»).mp constant (.a, 2) (.a, 3) trivial (.a, 3)
      ⟨trivial, rfl, Nat.lt_succ_self 2⟩ with
  | ⟨_, ⟨_, _, h⟩, _⟩ => Nat.lt_irrefl 3 h

/-- **Up to the net's end the class holding the families with their condition is constant.** -/
theorem held_constant_to_end : «至终有常» step held := by
  intro u u' e v r
  have hu : joined u.1 = true := (link_joined _ _ r.1).1
  have hv : joined v.1 = true := (link_joined _ _ r.1).2
  have hu' : joined u'.1 = true := e ▸ hu
  match Nat.decLt u'.2 3 with
  | .isTrue h => exact .inl ⟨(u'.1, u'.2 + 1), ⟨link_self _ hu', rfl, h⟩, hv.trans hu'.symm⟩
  | .isFalse h => exact .inr (fun _ s => h s.2.2)

/-- **The class holds the first member's effects**: everything the first family's first birth
conditions is in it. -/
theorem first_birth_held : «所缘同于» step held (.a, 0) := fun _ s => ((link_joined _ _ s.1).2).symm

/-- The member's relation is a class. -/
theorem member_class : «类» member :=
  ⟨fun _ => ⟨rfl, rfl⟩, fun ⟨a, b⟩ => ⟨a.symm, b.symm⟩, fun ⟨a, b⟩ ⟨c, d⟩ => ⟨a.trans c, b.trans d⟩⟩

/-- **The member's line ends while its last stage still conditions something**, so the member's class is
not constant up to the net's end, even at the first member's class. -/
theorem member_not_constant_at : ¬ «本类至终有常» step member (.a, 0) :=
  «亡而网续则本类不至终有常» (x := (.a, 0)) (y := (.a, 1)) ⟨rfl, rfl⟩ ⟨rfl, rfl⟩
    ⟨⟨trivial, rfl, Nat.zero_lt_succ 2⟩, rfl, rfl⟩
    (fun ⟨z, ⟨_, e2, _⟩, ⟨k, d⟩⟩ => by
      have hz : z.2 = 2 := e2
      rw [hz] at d
      exact Bool.noConfusion d)
    ⟨(.a, 2), trivial, rfl, Nat.lt_succ_of_le (Nat.le_succ 1)⟩

/-- **The member's class is not constant up to the net's end** (from `member_not_constant_at`). -/
theorem member_not_constant_to_end : ¬ «至终有常» step member := fun constant =>
  member_not_constant_at («至终有常则本类至终有常» member_class constant (.a, 0))

/-- **The line under the class from the first family's first birth reaches the second family past the
first member's end**, through the condition the first member affects: the second family's stage `2`,
after the first member's line has ended at stage `1`. -/
theorem reaches_other_past_end : «所及» step held (.a, 0) (.b, 2) :=
  «至终常闭则所及皆及» (m := (.a, 0)) held_class held_constant_to_end
    (⟨(.a, 1), trivial, rfl, Nat.zero_lt_succ 2⟩ : ∃ w, step (.a, 0) w) first_birth_held (.inl rfl) rfl
    («及».more (x := (Kind.a, 0)) (y := (Kind.r, 1)) (z := (Kind.b, 2)) ⟨trivial, rfl, Nat.zero_lt_succ 2⟩
      («及».one ⟨trivial, rfl, Nat.lt_succ_of_le (Nat.le_succ 1)⟩))

/-- **And not the fourth thing**, joined to nothing. -/
theorem fourth_outside (n : Nat) : ¬ «所及» step held (.a, 0) (.x, n) := fun reached =>
  match reached with
  | .inl e => Kind.noConfusion (congrArg Prod.fst e)
  | .inr line => Bool.noConfusion («线内同类» held_class line)

end FiniteSharedCondition


namespace CleanStep

/-! A member `m` conditioning `i` and `u`; `i` conditions `j` and nothing outside the class.
The class holding `m`, `i` and `j` and keeping `u` apart is not constant, even up to the net's end.
Read as an agent, `i` would be an intended effect that acts with no side effect; that is a
reading. -/

inductive Occ | m | i | j | u

def step : «际» Occ
  | .m, .m => False
  | .m, .i => True
  | .m, .j => False
  | .m, .u => True
  | .i, .m => False
  | .i, .i => False
  | .i, .j => True
  | .i, .u => False
  | .j, .m => False
  | .j, .i => False
  | .j, .j => False
  | .j, .u => False
  | .u, .m => False
  | .u, .i => False
  | .u, .j => False
  | .u, .u => False

/-- The line held by the class, as against what leaves it. -/
def intended : Occ → Bool
  | .m => true
  | .i => true
  | .j => true
  | .u => false

def own : «际» Occ := fun x y => intended x = intended y

theorem own_class : «类» own := ⟨fun _ => rfl, Eq.symm, Eq.trans⟩

/-- **At the member's class, an occurrence alike to the member that conditions something but nothing
outside the class makes the class fail the condition** (`«出类不随则本类不至终有常»`). -/
theorem not_constant_at : ¬ «本类至终有常» step own .m :=
  «出类不随则本类不至终有常» own_class (m := .m) (c := .i) (u := .u) rfl trivial (fun e => Bool.noConfusion e)
    ⟨.j, trivial⟩ (fun x r => match x, r with
      | .j, _ => fun e => Bool.noConfusion e)

/-- **An occurrence alike to the member that conditions something but nothing outside the class makes the
class fail constancy up to the net's end** (`«出类不随则不至终有常»`, through `not_constant_at`). -/
theorem not_constant_to_end : ¬ «至终有常» step own := fun constant =>
  not_constant_at («至终有常则本类至终有常» own_class constant .m)

/-- **Yet every line under the class from the member ends only where the net does**: wherever such a line
ends, the occurrence it ends at conditions nothing. So the condition at the member's class asks more than
that a line end only where the net does. -/
theorem ends_where_net_ends {y : Occ} (line : «相续» step own .m y) (ends : «亡» step own y) :
    ∀ w, ¬ step y w :=
  match y, line, ends with
  | .m, _, ends => absurd ⟨.i, trivial, rfl⟩ ends
  | .i, _, ends => absurd ⟨.j, trivial, rfl⟩ ends
  | .j, _, _ => fun w h => by cases w <;> exact False.elim h
  | .u, line, _ => absurd («线内同类» own_class line) (fun e => Bool.noConfusion e)

end CleanStep

namespace FiniteWake

/-! A member `m` conditioning `i` and `u`, `i` conditioning `j` and `u₂`, and nothing after: finite and
without cycles. The class holding `m`, `i` and `j` and keeping `u` and `u₂` apart is constant up to the
net's end though not constant, does not hold the member's effects, and every occurrence on its line
that conditions anything has an effect outside it. Read as an agent with a wake, `i` and `j` would be its intended line
and `u`, `u₂` its side effects; that is a reading. -/

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

/-- **It is not constant**: `j` is alike to `m` and conditions nothing. -/
theorem not_constant : ¬ «有常» step own := fun constant =>
  match («有常之逐点» step own).mp constant .m .j rfl .i trivial with
  | ⟨w, h, _⟩ => by cases w <;> exact False.elim h

/-- **It does not hold the member's effects.** -/
theorem not_held : ¬ «所缘同于» step own .m := fun held => Bool.noConfusion (held .u trivial)

/-- **Every occurrence on its line that conditions anything has an effect outside it.** -/
theorem wake_follows {c : Occ} (onLine : «所及» step own .m c) (goes : ∃ w, step c w) :
    ∃ x, step c x ∧ own .u x ∧ ¬ own c x :=
  «出类随线» own_class constant_to_end onLine trivial (fun e => Bool.noConfusion e) goes

end FiniteWake

namespace FinerOutside

/-! A member `m` conditioning `b`, an occurrence `c` alike to it conditioning `d`, and nothing else. Under the
split into `m`'s class (`m` and `c`) and the rest, the class is constant up to the net's end at `m` without
holding `m`'s effects: each step of the class has an effect outside it. Dividing the rest into `b` and `d`,
with `m`'s class unchanged, breaks the condition: `m`'s effect is `b`, and `c` conditions nothing alike to
`b`. -/

inductive Occ | m | c | b | d

def step : «际» Occ
  | .m, .m => False
  | .m, .c => False
  | .m, .b => True
  | .m, .d => False
  | .c, .m => False
  | .c, .c => False
  | .c, .b => False
  | .c, .d => True
  | .b, .m => False
  | .b, .c => False
  | .b, .b => False
  | .b, .d => False
  | .d, .m => False
  | .d, .c => False
  | .d, .b => False
  | .d, .d => False

/-- The member's class, as against the rest. -/
def inClass : Occ → Bool
  | .m => true
  | .c => true
  | .b => false
  | .d => false

/-- A finer division of the rest: `b` apart from `d`. -/
def kind : Occ → Nat
  | .m => 0
  | .c => 0
  | .b => 1
  | .d => 2

def finer : «际» Occ := fun x y => kind x = kind y

theorem finer_class : «类» finer := ⟨fun _ => rfl, Eq.symm, Eq.trans⟩

/-- Both divisions give `m` the same class. -/
theorem same_class : ∀ y, finer .m y ↔ «二分» inClass .m y
  | .m => ⟨fun _ => rfl, fun _ => rfl⟩
  | .c => ⟨fun _ => rfl, fun _ => rfl⟩
  | .b => ⟨fun e => Nat.noConfusion e, fun e => Bool.noConfusion e⟩
  | .d => ⟨fun e => Nat.noConfusion e, fun e => Bool.noConfusion e⟩

/-- **Under the split, the class is constant up to the net's end at `m`.** -/
theorem split_constant_at : «本类至终有常» step («二分» inClass) .m := by
  intro u u' mu mu' v r
  cases u <;> cases u' <;> cases v <;>
    first
    | exact False.elim r
    | exact Bool.noConfusion mu
    | exact Bool.noConfusion mu'
    | exact .inl ⟨.b, trivial, rfl⟩
    | exact .inl ⟨.d, trivial, rfl⟩
    | exact .inr (fun w h => by cases w <;> exact False.elim h)

/-- **It does not hold `m`'s effects.** -/
theorem not_held : ¬ «所缘同于» step («二分» inClass) .m := fun held => Bool.noConfusion (held .b trivial)

/-- **Divided more finely, the class is not constant up to the net's end at `m`**: `m` conditions `b`, and
`c`, alike to `m`, conditions `d` alone. -/
theorem finer_not_constant_at : ¬ «本类至终有常» step finer .m := fun atClass =>
  match atClass .m .c rfl rfl .b trivial with
  | .inl ⟨v', r, e⟩ => match v', r, e with
    | .d, _, e => Nat.noConfusion (Nat.succ.inj e)
  | .inr stops => stops .d trivial

end FinerOutside

namespace FinerWake

/-! A member `m` conditioning `i` in its class and `b` outside it, an occurrence `c` alike to it conditioning
`j` in the class and `d` outside, and nothing else. Every occurrence alike to `m` that conditions anything
conditions something in the class and something outside, so under the split into `m`'s class and the rest the
class is constant up to the net's end at `m` (`«内外皆缘则二分本类常»`). Dividing the rest into `b` and `d`,
with `m`'s class unchanged, breaks the condition: `m` conditions `b`, and `c` conditions nothing alike to
`b`. Read as an agent with a wake, `i` and `j` would be intended and `b` and `d` side effects of two kinds;
that is a reading. -/

inductive Occ | m | c | i | j | b | d

def step : «际» Occ
  | .m, .m => False
  | .m, .c => False
  | .m, .i => True
  | .m, .j => False
  | .m, .b => True
  | .m, .d => False
  | .c, .m => False
  | .c, .c => False
  | .c, .i => False
  | .c, .j => True
  | .c, .b => False
  | .c, .d => True
  | .i, .m => False
  | .i, .c => False
  | .i, .i => False
  | .i, .j => False
  | .i, .b => False
  | .i, .d => False
  | .j, .m => False
  | .j, .c => False
  | .j, .i => False
  | .j, .j => False
  | .j, .b => False
  | .j, .d => False
  | .b, .m => False
  | .b, .c => False
  | .b, .i => False
  | .b, .j => False
  | .b, .b => False
  | .b, .d => False
  | .d, .m => False
  | .d, .c => False
  | .d, .i => False
  | .d, .j => False
  | .d, .b => False
  | .d, .d => False

/-- The member's class, as against the rest. -/
def inClass : Occ → Bool
  | .m => true
  | .c => true
  | .i => true
  | .j => true
  | .b => false
  | .d => false

/-- A finer division of the rest: `b` apart from `d`. -/
def kind : Occ → Nat
  | .m => 0
  | .c => 0
  | .i => 0
  | .j => 0
  | .b => 1
  | .d => 2

def finer : «际» Occ := fun x y => kind x = kind y

/-- The finer division is a class. -/
theorem finer_class : «类» finer := ⟨fun _ => rfl, Eq.symm, Eq.trans⟩

/-- Both divisions give `m` the same class. -/
theorem same_class : ∀ y, finer .m y ↔ «二分» inClass .m y
  | .m => ⟨fun _ => rfl, fun _ => rfl⟩
  | .c => ⟨fun _ => rfl, fun _ => rfl⟩
  | .i => ⟨fun _ => rfl, fun _ => rfl⟩
  | .j => ⟨fun _ => rfl, fun _ => rfl⟩
  | .b => ⟨fun e => Nat.noConfusion e, fun e => Bool.noConfusion e⟩
  | .d => ⟨fun e => Nat.noConfusion e, fun e => Bool.noConfusion e⟩

/-- **Every occurrence alike to `m` conditions something in the class and something outside, or
nothing.** -/
theorem both : ∀ u, inClass .m = inClass u →
    ((∃ x, step u x ∧ inClass u = inClass x) ∧ (∃ x, step u x ∧ ¬ inClass u = inClass x)) ∨
      ∀ w, ¬ step u w
  | .m, _ => .inl ⟨⟨.i, trivial, rfl⟩, ⟨.b, trivial, fun e => Bool.noConfusion e⟩⟩
  | .c, _ => .inl ⟨⟨.j, trivial, rfl⟩, ⟨.d, trivial, fun e => Bool.noConfusion e⟩⟩
  | .i, _ => .inr (fun w h => by cases w <;> exact False.elim h)
  | .j, _ => .inr (fun w h => by cases w <;> exact False.elim h)
  | .b, e => Bool.noConfusion e
  | .d, e => Bool.noConfusion e

/-- **Under the split, the class is constant up to the net's end at `m`.** -/
theorem split_constant_at : «本类至终有常» step («二分» inClass) .m := «内外皆缘则二分本类常» both

/-- **Divided more finely, the class is not constant up to the net's end at `m`**: `m` conditions `b`, and
`c`, alike to `m`, conditions `j` and `d`, neither alike to `b`. -/
theorem finer_not_constant_at : ¬ «本类至终有常» step finer .m := fun atClass =>
  match atClass .m .c rfl rfl .b trivial with
  | .inl ⟨v', r, e⟩ => match v', r, e with
    | .j, _, e => Nat.noConfusion e
    | .d, _, e => Nat.noConfusion (Nat.succ.inj e)
  | .inr stops => stops .j trivial

end FinerWake

namespace UnevenOutside

/-! A member `s` conditioning `t`, `a` conditioning `s`, `b` conditioning `x`, and nothing else. The member's
class is `s` and `t`. Under the split into that class and the rest, the class is constant up to the net's
end at `s` and holds `s`'s effects, but is not constant up to the net's end: `a` and `b` are alike outside,
`a` conditions `s`, and `b` conditions `x` alone. Divided more finely, `a` apart from `b` and `x`, the class
is constant up to the net's end, and `s`'s class is the same. -/

inductive Occ | s | t | a | b | x

def step : «际» Occ
  | .s, .s => False
  | .s, .t => True
  | .s, .a => False
  | .s, .b => False
  | .s, .x => False
  | .t, .s => False
  | .t, .t => False
  | .t, .a => False
  | .t, .b => False
  | .t, .x => False
  | .a, .s => True
  | .a, .t => False
  | .a, .a => False
  | .a, .b => False
  | .a, .x => False
  | .b, .s => False
  | .b, .t => False
  | .b, .a => False
  | .b, .b => False
  | .b, .x => True
  | .x, .s => False
  | .x, .t => False
  | .x, .a => False
  | .x, .b => False
  | .x, .x => False

/-- The member's class, as against the rest. -/
def inClass : Occ → Bool
  | .s => true
  | .t => true
  | .a => false
  | .b => false
  | .x => false

/-- A finer division of the rest: `a` apart from `b` and `x`. -/
def kind : Occ → Nat
  | .s => 0
  | .t => 0
  | .a => 1
  | .b => 2
  | .x => 2

def finer : «际» Occ := fun y z => kind y = kind z

theorem finer_class : «类» finer := ⟨fun _ => rfl, Eq.symm, Eq.trans⟩

/-- Both divisions give `s` the same class. -/
theorem same_class : ∀ y, finer .s y ↔ «二分» inClass .s y
  | .s => ⟨fun _ => rfl, fun _ => rfl⟩
  | .t => ⟨fun _ => rfl, fun _ => rfl⟩
  | .a => ⟨fun e => Nat.noConfusion e, fun e => Bool.noConfusion e⟩
  | .b => ⟨fun e => Nat.noConfusion e, fun e => Bool.noConfusion e⟩
  | .x => ⟨fun e => Nat.noConfusion e, fun e => Bool.noConfusion e⟩

/-- **Under the split, the class is constant up to the net's end at `s`.** -/
theorem split_constant_at : «本类至终有常» step («二分» inClass) .s := by
  intro u u' mu mu' v r
  cases u <;> cases u' <;> cases v <;>
    first
    | exact False.elim r
    | exact Bool.noConfusion mu
    | exact Bool.noConfusion mu'
    | exact .inl ⟨.t, trivial, rfl⟩
    | exact .inr (fun w h => by cases w <;> exact False.elim h)

/-- **It holds `s`'s effects.** -/
theorem held : «所缘同于» step («二分» inClass) .s := fun v r => match v, r with
  | .t, _ => rfl

/-- **Under the split, the class is not constant up to the net's end**: `a` and `b` are alike outside,
`a` conditions `s`, and `b` conditions something but nothing alike to `s`. -/
theorem split_not_constant_to_end : ¬ «至终有常» step («二分» inClass) := fun constant =>
  match constant .a .b rfl .s trivial with
  | .inl ⟨v', r, e⟩ => match v', r, e with
    | .x, _, e => Bool.noConfusion e
  | .inr stops => stops .x trivial

/-- **Divided more finely, the class is constant up to the net's end.** -/
theorem finer_constant_to_end : «至终有常» step finer := by
  intro u u' e v r
  cases u <;> cases u' <;> cases v <;>
    first
    | exact False.elim r
    | exact Nat.noConfusion e
    | exact Nat.noConfusion (Nat.succ.inj e)
    | exact .inl ⟨.t, trivial, rfl⟩
    | exact .inl ⟨.s, trivial, rfl⟩
    | exact .inl ⟨.x, trivial, rfl⟩
    | exact .inr (fun w h => by cases w <;> exact False.elim h)

end UnevenOutside

/-! ## What the reach does not need -/

namespace OtherLeaves

/-! A member `m` conditioning `v`, `v` conditioning `w`, an occurrence `c` alike to `m` conditioning `x`, and
nothing else; `m`, `v`, `w` and `c` in one class, `x` in another. Everything downstream of the member is alike to
it, so lies on its line under the class, and the class holds its effects; but `m` conditions `v`, and `c`, off
the member's line, conditions only `x`, which is not alike to `v`, so the class is not constant up to the net's
end at the member's class, and does not hold `c`'s effects. The laws above cannot drop the regularity
(`Inconstant`), but the reach does not need it. -/

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

/-- **The occurrence alike to the member is off its line**: nothing downstream of `m` is `c`. -/
theorem other_off_line : ¬ «及» step .m .c := fun down => Bool.noConfusion (reached_after down rfl)

/-- **Without the condition at the member's class, the class holds the member's effects and everything
downstream of it lies on its line.** -/
theorem reach_without_condition :
    ¬ «本类至终有常» step («二分» inClass) .m ∧ «所缘同于» step («二分» inClass) .m ∧
      ∀ t, «及» step .m t → «所及» step («二分» inClass) .m t :=
  have reach : ∀ t, «及» step .m t → «所及» step («二分» inClass) .m t :=
    («后皆续当且仅当后皆同类» («二分为类» inClass)).mpr all_alike
  ⟨not_constant_at, «后皆续则所缘同于» («二分为类» inClass) reach, reach⟩

end OtherLeaves

end Becoming
