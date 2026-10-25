#!/usr/bin/env python3
"""OC1: constancy up to the net's end read at a member's class, in Becoming.GrammarPath, below PF's and PF2's
laws (board rule 9: their statements stay, their direct proofs go). Reads a GrammarPath (PF2's, or main's once
PF2 has landed) and writes the OC1 version.
usage: python3 -B build_tree.py SOURCE_GrammarPath.lean OUT_GrammarPath.lean"""
import sys
from pathlib import Path

SRC, OUT = Path(sys.argv[1]), Path(sys.argv[2])
text = SRC.read_text(encoding='utf-8')


def replace(old, new):
    global text
    assert text.count(old) == 1, (old[:90], text.count(old))
    text = text.replace(old, new)


def block(start, end_marker):
    """The text from the line starting `start` up to, not including, the next line starting `end_marker`."""
    i = text.index(start)
    j = text.index(end_marker, i + len(start))
    return text[i:j]


# --- the module doc --------------------------------------------------------------------------------------
replace("""* **Neither premise can be dropped.** Where a member's line runs through a condition but the member's""",
        """* **At a member's class (本类至终有常).** Constancy up to the net's end asks its condition of every two
  alike occurrences, so it constrains every block of the class, what lies outside a member's class
  included. Asked only of the occurrences alike to a member, it is *constancy up to the net's end at the
  member's class* (`«本类至终有常»`), and the global condition is that at every member's class
  (`«至终有常之逐类»`). The laws above use only occurrences alike to the member, so each holds at the
  member's class and the global forms are corollaries (`«本类常闭则所缘同类»`, `«本类常闭则后皆续»`,
  `«本类常闭则所及皆及»`, `«本类常则闭当且仅当后皆同类»`, `«本类出类随行»`, `«本类出类随线»`,
  `«出类不随则本类不至终有常»`); a line that ends while it still conditions something fails it at its own
  class (`«亡而网续则本类不至终有常»`; the organism's case in `FiniteFamilies.member_not_constant_at` and
  `FiniteSharedCondition.member_not_constant_at`). How what lies outside is divided bears on the condition
  only through "alike to that effect". Where the class holds the effects of a member that conditions
  something, the division is idle (`«闭则外分无关»`). Merging what lies outside keeps the condition
  (`«外合不失本类之常»`), so where a predicate decides the member's class, the split into that class and the
  rest asks least (`«二分»`, `«本类之常至二分»`), and under the split the
  condition is exactly that what stays and what leaves follow every alike step that goes on
  (`«二分本类常当且仅当内外皆随»`). Dividing what lies outside more finely can break it (`FinerOutside`), and
  the global condition can fail under the split while the member's class keeps it and holds the member's
  effects, where alike occurrences outside differ in what they condition in the member's class
  (`UnevenOutside`).
* **Neither premise can be dropped.** Where a member's line runs through a condition but the member's""")

# --- the condition at a member's class --------------------------------------------------------------------
replace("""theorem «有常则至终有常» {R E : «际» α} (constant : «有常» R E) : «至终有常» R E :=
  fun u u' e v r => .inl ((«有常之逐点» R E).mp constant u u' e v r)
""", """theorem «有常则至终有常» {R E : «际» α} (constant : «有常» R E) : «至终有常» R E :=
  fun u u' e v r => .inl ((«有常之逐点» R E).mp constant u u' e v r)

/-- **Constancy up to the net's end at a member's class (本类至终有常).** Whatever an occurrence alike to
the member conditions, every occurrence alike to the member conditions something alike to it, unless that
occurrence conditions nothing at all. It is `«至终有常»` asked only of the occurrences alike to the member,
and says nothing of how what lies outside is divided or what it conditions. -/
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
""")

replace("""  match constant x y hxy.2 y hxy.1 with
  | .inl ⟨v', hv', ev⟩ => ends ⟨v', hv', ev⟩
  | .inr stops => match goes with
    | ⟨w, hw⟩ => stops w hw
""", """  match constant x y hxy.2 y hxy.1 with
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
""")

# --- PF's laws: the general form at the member's class, the global form its corollary ---------------------
old = block("/-- **Up to the net's end, whatever is alike to a member that conditions something, and whose effects",
            "/-- **A regularity that holds a member's effects takes in all that follows (常闭则后皆续), up to the")
replace(old, """/-- **At a member's class, whatever is alike to a member that conditions something, and whose effects the
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

""")

old = block("/-- **A regularity that holds a member's effects takes in all that follows (常闭则后皆续), up to the",
            "/-- Under a constant class, what is alike to an occurrence that conditions something conditions")
replace(old, """/-- **A regularity that holds a member's effects takes in all that follows (常闭则后皆续), at the member's
class.** Under a class constant up to the net's end at a member's class, everything downstream of anything
alike to the member, where the member conditions something and the class holds its effects, is alike to it
and lies on a line under the class from there. That the member conditions something is needed where the
start is another occurrence alike to it. -/
theorem «本类常闭则后皆续» {R E : «际» α} (hE : «类» E) {m : α} (atClass : «本类至终有常» R E m)
    (goes : ∃ w, R m w) (held : «所缘同于» R E m) {c t : α} (alike : E c m) (down : «及» R c t) :
    E t m ∧ «相续» R E c t := by
  induction down with
  | one step =>
    have et := «本类常闭则所缘同类» hE atClass goes held alike step
    exact ⟨et, .one ⟨step, hE.trans alike (hE.symm et)⟩⟩
  | @more a b _ step _ ih =>
    have eb : E b m := «本类常闭则所缘同类» hE atClass goes held alike step
    match ih eb with
    | ⟨et, rest⟩ => exact ⟨et, .more ⟨step, hE.trans alike (hE.symm eb)⟩ rest⟩

/-- **A regularity that holds a member's effects takes in all that follows (常闭则后皆续), up to the
net's end.** Under a class constant up to the net's end, everything downstream of anything alike to a
member that conditions something, and whose effects the class holds, is alike to it and lies on a line
under the class from there. That the member conditions something is needed where the start is another
occurrence alike to it. -/
theorem «至终常闭则后皆续» {R E : «际» α} (hE : «类» E) (constant : «至终有常» R E) {m : α}
    (goes : ∃ w, R m w) (held : «所缘同于» R E m) {c t : α} (alike : E c m) (down : «及» R c t) :
    E t m ∧ «相续» R E c t :=
  «本类常闭则后皆续» hE («至终有常则本类至终有常» hE constant m) goes held alike down

""")

old = block("/-- **What a line reaches alike to a member that conditions something, and whose effects the class\nholds, it carries on to all that follows**, up to the net's end. -/",
            "/-- **What a line reaches alike to a member whose effects the class holds, it carries on to all that")
replace(old, """/-- **What a line reaches alike to a member that conditions something, and whose effects the class holds,
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

""")

# --- PF2's laws, likewise ------------------------------------------------------------------------------------
replace("""theorem «出类随行» {R E : «际» α} (hE : «类» E) (constant : «至终有常» R E) {m c u : α}
    (alike : E c m) (effect : R m u) (outside : ¬ E m u) (goes : ∃ w, R c w) :
    ∃ x, R c x ∧ E u x ∧ ¬ E c x :=
  match constant m c (hE.symm alike) u effect with
  | .inl ⟨x, hx, ux⟩ => ⟨x, hx, ux, fun cx => outside (hE.trans (hE.symm alike) (hE.trans cx (hE.symm ux)))⟩
  | .inr stops => match goes with
    | ⟨w, hw⟩ => absurd hw (stops w)
""", """theorem «出类随行» {R E : «际» α} (hE : «类» E) (constant : «至终有常» R E) {m c u : α}
    (alike : E c m) (effect : R m u) (outside : ¬ E m u) (goes : ∃ w, R c w) :
    ∃ x, R c x ∧ E u x ∧ ¬ E c x :=
  «本类出类随行» hE («至终有常则本类至终有常» hE constant m) alike effect outside goes
""")
replace("""/-- **What leaves the class follows each alike step (出类随行).** Under a class constant up to the net's""",
        """/-- **What leaves the class follows each alike step (出类随行), at the member's class.** Under a class
constant up to the net's end at a member's class, where the member conditions something not alike to it,
whatever is alike to the member and conditions anything conditions something alike to that effect and
not alike to itself. -/
theorem «本类出类随行» {R E : «际» α} (hE : «类» E) {m c u : α} (atClass : «本类至终有常» R E m)
    (alike : E c m) (effect : R m u) (outside : ¬ E m u) (goes : ∃ w, R c w) :
    ∃ x, R c x ∧ E u x ∧ ¬ E c x :=
  match atClass m c (hE.refl m) (hE.symm alike) u effect with
  | .inl ⟨x, hx, ux⟩ => ⟨x, hx, ux, fun cx => outside (hE.trans (hE.symm alike) (hE.trans cx (hE.symm ux)))⟩
  | .inr stops => match goes with
    | ⟨w, hw⟩ => absurd hw (stops w)

/-- **What leaves the class follows each alike step (出类随行).** Under a class constant up to the net's""")

replace("""  «出类随行» hE constant
    (match line with
     | .inl e => e ▸ hE.refl m
     | .inr l => hE.symm («线内同类» hE l)) effect outside goes
""", """  «本类出类随线» hE («至终有常则本类至终有常» hE constant m) line effect outside goes
""")
replace("""/-- **What leaves the class follows the line (出类随线).** Under a class constant up to the net's end,""",
        """/-- **What leaves the class follows the line (出类随线), at the member's class.** Under a class constant up
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

/-- **What leaves the class follows the line (出类随线).** Under a class constant up to the net's end,""")

replace("""    ¬ «至终有常» R E := fun constant =>
  match «出类随行» hE constant alike effect outside goes with
  | ⟨x, hx, ux, _⟩ => clean x hx ux
""", """    ¬ «至终有常» R E := fun constant =>
  «出类不随则本类不至终有常» hE alike effect outside goes clean («至终有常则本类至终有常» hE constant m)
""")
replace("""/-- **Where nothing leaving the class follows, the class is not constant up to the net's end
(出类不随则不至终有常).**""", """/-- **Where nothing leaving the class follows, the class is not constant up to the net's end at the member's
class (出类不随则本类不至终有常).** Where a member conditions something not alike to it, and an occurrence
alike to the member conditions something but nothing alike to that effect, the class is not constant up to
the net's end at the member's class. -/
theorem «出类不随则本类不至终有常» {R E : «际» α} (hE : «类» E) {m c u : α} (alike : E c m)
    (effect : R m u) (outside : ¬ E m u) (goes : ∃ w, R c w) (clean : ∀ x, R c x → ¬ E u x) :
    ¬ «本类至终有常» R E m := fun atClass =>
  match «本类出类随行» hE atClass alike effect outside goes with
  | ⟨x, hx, ux, _⟩ => clean x hx ux

/-- **Where nothing leaving the class follows, the class is not constant up to the net's end
(出类不随则不至终有常).**""")

old = block("/-- **Up to the net's end, a class holds a member's effects exactly where everything downstream of the",
            "/-- **Under constancy, a class holds a member's effects exactly where everything downstream of the")
replace(old, """/-- **At a member's class, the class holds the member's effects exactly where everything downstream of
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

""")

# --- how what lies outside is divided -------------------------------------------------------------------------
replace("""  «至终常类之闭当且仅当后皆同类» hE («有常则至终有常» constant)

end Path""", """  «至终常类之闭当且仅当后皆同类» hE («有常则至终有常» constant)

/-- **Merging what lies outside a member's class keeps the condition at that class (外合不失本类之常).**
Where `F` relates whatever `E` relates and holds alike to `m` only what `E` does, constancy up to the net's
end at `m`'s class under `E` gives it under `F`: what is alike to an effect under `E` is alike to it under
`F`. -/
theorem «外合不失本类之常» {R E F : «际» α} {m : α} (coarser : ∀ x y, E x y → F x y)
    (same : ∀ x, F m x → E m x) (atClass : «本类至终有常» R E m) : «本类至终有常» R F m :=
  fun u u' mu mu' v step => match atClass u u' (same u mu) (same u' mu') v step with
  | .inl ⟨v', hv', ev⟩ => .inl ⟨v', hv', coarser v v' ev⟩
  | .inr stops => .inr stops

/-- **Where the class holds a member's effects, how what lies outside is divided is idle (闭则外分无关).**
Where classes `E` and `F` hold the same occurrences alike to `m`, and `m` conditions something, constancy up
to the net's end at `m`'s class, with the holding of `m`'s effects, under `E` gives both under `F`. -/
theorem «闭则外分无关» {R E F : «际» α} (hE : «类» E) (hF : «类» F) {m : α}
    (same : ∀ x, E m x ↔ F m x) (goes : ∃ w, R m w) (held : «所缘同于» R E m)
    (atClass : «本类至终有常» R E m) : «本类至终有常» R F m ∧ «所缘同于» R F m :=
  ⟨fun u u' mu mu' v step =>
     match atClass u u' ((same u).mpr mu) ((same u').mpr mu') v step with
     | .inl ⟨v', hv', ev⟩ =>
       have mv : E m v :=
         hE.symm («本类常闭则所缘同类» hE atClass goes held (hE.symm ((same u).mpr mu)) step)
       .inl ⟨v', hv', hF.trans (hF.symm ((same v).mp mv)) ((same v').mp (hE.trans mv ev))⟩
     | .inr stops => .inr stops,
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

end Path""")

# --- the organism, read at its class (PF's witnesses: the global form now a corollary) -----------------------
replace("""/-- **The organism's class is not constant up to the net's end**: the first member's line ends at its
old age while the net goes on to the second member's birth. -/
theorem member_not_constant_to_end : ¬ «至终有常» step member :=
  «亡而网续则不至终有常» (x := (false, 0)) (y := (false, 1))
    ⟨⟨rfl, rfl, Nat.lt_succ_of_le (Nat.le_succ_of_le (Nat.le_succ 0))⟩, rfl, rfl⟩""",
        """/-- The organism's relation is a class. -/
theorem member_class : «类» member :=
  ⟨fun _ => ⟨rfl, rfl⟩, fun ⟨a, b⟩ => ⟨a.symm, b.symm⟩, fun ⟨a, b⟩ ⟨c, d⟩ => ⟨a.trans c, b.trans d⟩⟩

/-- **The organism's class is not constant up to the net's end, even at the first member's class**: the
first member's line ends at its old age while the net goes on to the second member's birth. -/
theorem member_not_constant_at : ¬ «本类至终有常» step member (false, 0) :=
  «亡而网续则本类不至终有常» (x := (false, 0)) (y := (false, 1)) ⟨rfl, rfl⟩ ⟨rfl, rfl⟩
    ⟨⟨rfl, rfl, Nat.lt_succ_of_le (Nat.le_succ_of_le (Nat.le_succ 0))⟩, rfl, rfl⟩""")
replace("""    ⟨(false, 2), rfl, rfl, Nat.lt_succ_of_le (Nat.le_succ_of_le (Nat.le_refl 1))⟩
""", """    ⟨(false, 2), rfl, rfl, Nat.lt_succ_of_le (Nat.le_succ_of_le (Nat.le_refl 1))⟩

/-- **The organism's class is not constant up to the net's end** (from `member_not_constant_at`). -/
theorem member_not_constant_to_end : ¬ «至终有常» step member := fun constant =>
  member_not_constant_at («至终有常则本类至终有常» member_class constant (false, 0))
""")
replace("""/-- **The member's line ends while the net goes on**, so the member's class is not constant up to the
net's end. -/
theorem member_not_constant_to_end : ¬ «至终有常» step member :=
  «亡而网续则不至终有常» (x := (.a, 0)) (y := (.a, 1))
    ⟨⟨trivial, rfl, Nat.zero_lt_succ 2⟩, rfl, rfl⟩""",
        """/-- The member's relation is a class. -/
theorem member_class : «类» member :=
  ⟨fun _ => ⟨rfl, rfl⟩, fun ⟨a, b⟩ => ⟨a.symm, b.symm⟩, fun ⟨a, b⟩ ⟨c, d⟩ => ⟨a.trans c, b.trans d⟩⟩

/-- **The member's line ends while the net goes on**, so the member's class is not constant up to the
net's end, even at the first member's class. -/
theorem member_not_constant_at : ¬ «本类至终有常» step member (.a, 0) :=
  «亡而网续则本类不至终有常» (x := (.a, 0)) (y := (.a, 1)) ⟨rfl, rfl⟩ ⟨rfl, rfl⟩
    ⟨⟨trivial, rfl, Nat.zero_lt_succ 2⟩, rfl, rfl⟩""")
replace("""    ⟨(.a, 2), trivial, rfl, Nat.lt_succ_of_le (Nat.le_succ 1)⟩
""", """    ⟨(.a, 2), trivial, rfl, Nat.lt_succ_of_le (Nat.le_succ 1)⟩

/-- **The member's class is not constant up to the net's end** (from `member_not_constant_at`). -/
theorem member_not_constant_to_end : ¬ «至终有常» step member := fun constant =>
  member_not_constant_at («至终有常则本类至终有常» member_class constant (.a, 0))
""")

# --- the witnesses ---------------------------------------------------------------------------------------------
WITNESSES = (Path(__file__).resolve().parent / 'witnesses.lean').read_text(encoding='utf-8')
assert text.rstrip().endswith('end Becoming')
text = text.rstrip()[:-len('end Becoming')].rstrip('\n') + '\n\n' + WITNESSES.strip('\n') + '\n\nend Becoming\n'

OUT.write_text(text, encoding='utf-8')
print('wrote', OUT)
