#!/usr/bin/env python3
"""OC2: the fixes the independent review of OC1 found, applied to Becoming.GrammarPath as OC1 landed it.

- The docstring of «本类至终有常» said the condition "says nothing of how what lies outside is divided"; FinerOutside
  shows it does, through "alike to it" (finding 3).
- «外分唯系出类之同»: how what lies outside is divided bears on the condition only through what is alike to an effect
  that leaves the class (finding 15); «闭则外分无关» is now its corollary (board rule 9), its statement unchanged.
- «内外皆缘则二分本类常»: under the split, the condition holds where every alike occurrence that conditions anything
  conditions something in the class and something outside (findings 6, 14), a corollary of
  «二分本类常当且仅当内外皆随».
- Inconstant.not_constant_at: the witness that the regularity cannot be dropped fails it at the member's class too
  (finding 10), derived from «本类常则闭当且仅当后皆同类»; not_all_follow's global failure now goes through it.
- CleanStep.not_constant_at and CleanStep.ends_where_net_ends: the condition at the member's class asks more than
  that a line end only where the net does (findings 7, 8); not_constant_to_end now goes through not_constant_at.
- FinerWake: a finer division of what lies outside breaks the condition even where every alike occurrence
  conditions something in the class and something outside (finding 6).
- "goes on" in OC1's own text read "conditions something", not the glossary's 延 (finding 5); the module doc's
  bullet says what each new declaration adds.
With `--pf`, also PF's and PF2's uses of "goes on" in the same sense (module doc and witness docstrings), on the
PF line owner's yes; no statement changes.
usage: build_tree_oc2.py SOURCE OUT [--pf]"""
import sys
from pathlib import Path

src, out = Path(sys.argv[1]), Path(sys.argv[2])
PF = '--pf' in sys.argv[3:]
text = src.read_text(encoding='utf-8')
assert 'theorem «闭则外分无关»' in text and '«外分唯系出类之同»' not in text, 'expects GrammarPath as OC1 landed it'


def edit(old, new):
    global text
    assert text.count(old) == 1, (old[:90], text.count(old))
    text = text.replace(old, new)


# the module doc: OC1's bullet, made exact and extended
edit("""  `FiniteSharedCondition.member_not_constant_at`). How what lies outside is divided bears on the condition
  only through "alike to that effect". Where the class holds the effects of a member that conditions
  something, the division is idle (`«闭则外分无关»`). Merging what lies outside keeps the condition
  (`«外合不失本类之常»`), so where a predicate decides the member's class, the split into that class and the
  rest asks least (`«二分»`, `«本类之常至二分»`), and under the split the
  condition is exactly that what stays and what leaves follow every alike step that goes on
  (`«二分本类常当且仅当内外皆随»`). Dividing what lies outside more finely can break it (`FinerOutside`), and
  the global condition can fail under the split while the member's class keeps it and holds the member's
  effects, where alike occurrences outside differ in what they condition in the member's class
  (`UnevenOutside`).
""", """  `FiniteSharedCondition.member_not_constant_at`), and the condition asks more than that a line end only
  where the net does (`CleanStep.ends_where_net_ends`, `CleanStep.not_constant_at`). How what lies outside is
  divided bears on the condition only through what is alike to an effect that leaves the member's class
  (`«外分唯系出类之同»`). Where the class holds the effects of a member that conditions something, the
  condition keeps every alike occurrence's effects in the class, so the division is idle
  (`«闭则外分无关»`). Merging what lies outside keeps the condition (`«外合不失本类之常»`), so where a
  predicate decides the member's class, the split into that class and the rest asks least (`«二分»`,
  `«本类之常至二分»`), and under the split the condition is exactly that what stays and what leaves follow
  every alike occurrence that conditions anything (`«二分本类常当且仅当内外皆随»`); it holds where every
  such occurrence conditions something in the class and something outside (`«内外皆缘则二分本类常»`).
  Dividing what lies outside more finely can break it (`FinerOutside`), even there (`FinerWake`), and the
  global condition can fail under the split while the member's class keeps it and holds the member's
  effects, where alike occurrences outside differ in what they condition in the member's class
  (`UnevenOutside`).
""")
edit("""  what the condition feeds (`Unclosed`); and where the class is not constant, even up to the net's
  end, a member whose effects it holds need not have what follows them alike to it (`Inconstant`).
""", """  what the condition feeds (`Unclosed`); and where the class is not constant, even up to the net's
  end at the member's class, a member whose effects it holds need not have what follows them alike to it
  (`Inconstant`).
""")

# the definition's docstring
edit("""occurrence conditions nothing at all. It is `«至终有常»` asked only of the occurrences alike to the member,
and says nothing of how what lies outside is divided or what it conditions. -/""",
     """occurrence conditions nothing at all. It is `«至终有常»` asked only of the occurrences alike to the member:
it asks nothing of what occurrences outside the member's class condition, but how what lies outside is
divided enters through "alike to it", for an effect that leaves the class (`«外分唯系出类之同»`,
`FinerOutside`). -/""")

# how what lies outside is divided bears only through what leaves; idleness its corollary
edit("""/-- **Where the class holds a member's effects, how what lies outside is divided is idle (闭则外分无关).**
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
""", """/-- **How what lies outside is divided bears on the condition only through what is alike to an effect that
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

/-- **Where the class holds a member's effects, how what lies outside is divided is idle (闭则外分无关).**
Where classes `E` and `F` hold the same occurrences alike to `m`, and `m` conditions something, constancy up
to the net's end at `m`'s class, with the holding of `m`'s effects, under `E` gives both under `F`: the
condition keeps whatever an occurrence alike to `m` conditions alike to `m` (`«本类常闭则所缘同类»`), so
nothing leaves the class (`«外分唯系出类之同»`). -/
theorem «闭则外分无关» {R E F : «际» α} (hE : «类» E) (hF : «类» F) {m : α}
    (same : ∀ x, E m x ↔ F m x) (goes : ∃ w, R m w) (held : «所缘同于» R E m)
    (atClass : «本类至终有常» R E m) : «本类至终有常» R F m ∧ «所缘同于» R F m :=
  ⟨(«外分唯系出类之同» hE hF same (fun _ _ _ mu step =>
      .inl (hE.symm («本类常闭则所缘同类» hE atClass goes held (hE.symm mu) step)))).mp atClass,
   fun v step => (same v).mp (held v step)⟩
""")

# under the split, a sufficient condition
edit("""         .inl ⟨x, hx, «异三则同» (fun xu => ux (Eq.trans uu (Eq.symm xu))) (fun vu => leaves (Eq.symm vu))⟩
       | .inr stops => .inr stops⟩

end Path
""", """         .inl ⟨x, hx, «异三则同» (fun xu => ux (Eq.trans uu (Eq.symm xu))) (fun vu => leaves (Eq.symm vu))⟩
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
""")

# Inconstant: the failure at the member's class
edit("""/-! A member `m` conditioning `v` alike to it, `v` conditioning `w` in a second class: the class holds
the member's effects but is not constant, even up to the net's end, and what follows its effect is not
alike to it. -/""", """/-! A member `m` conditioning `v` alike to it, `v` conditioning `w` in a second class: the class holds
the member's effects but is not constant, even up to the net's end at the member's class, and what follows
its effect is not alike to it. -/""")
edit("""/-- **A class that holds a member's effects but is not constant, even up to the net's end, need not
have what follows them alike to the member.** -/
theorem not_all_follow :
    «所缘同于» step same .m ∧ ¬ «至终有常» step same ∧ ¬ «有常» step same ∧ «及» step .m .w ∧
      ¬ same .w .m :=
  have notToEnd : ¬ «至终有常» step same := fun constant =>
    match constant .v .m rfl .w trivial with
    | .inl ⟨.v, _, e⟩ => Bool.noConfusion e
    | .inl ⟨.m, h, _⟩ => h
    | .inl ⟨.w, h, _⟩ => h
    | .inr stops => stops .v trivial
""", """/-- **The class is not constant up to the net's end even at the member's class**: it holds the member's
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
""")

# CleanStep: the failure at the member's class, and lines that end only where the net does
CLEAN_DOC_OLD = """/-- **An occurrence alike to the member that goes on with nothing outside the class makes the class fail
constancy up to the net's end** (`«出类不随则不至终有常»`). -/"""
CLEAN_DOC_NEW = """/-- **An occurrence alike to the member that conditions something but nothing outside the class makes the
class fail constancy up to the net's end** (`«出类不随则不至终有常»`, through `not_constant_at`). -/"""
edit(CLEAN_DOC_OLD + """
theorem not_constant_to_end : ¬ «至终有常» step own :=
  «出类不随则不至终有常» own_class (m := .m) (c := .i) (u := .u) rfl trivial (fun e => Bool.noConfusion e)
    ⟨.j, trivial⟩ (fun x r => match x, r with
      | .j, _ => fun e => Bool.noConfusion e)
""", """/-- **At the member's class, an occurrence alike to the member that conditions something but nothing
outside the class makes the class fail the condition** (`«出类不随则本类不至终有常»`). -/
theorem not_constant_at : ¬ «本类至终有常» step own .m :=
  «出类不随则本类不至终有常» own_class (m := .m) (c := .i) (u := .u) rfl trivial (fun e => Bool.noConfusion e)
    ⟨.j, trivial⟩ (fun x r => match x, r with
      | .j, _ => fun e => Bool.noConfusion e)

""" + (CLEAN_DOC_NEW if PF else CLEAN_DOC_OLD) + """
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
""")

# OC1's witnesses: "goes on" read "conditions" (the two organism docstrings OC1 moved onto its theorems included)
edit("""first member's line ends at its old age while the net goes on to the second member's birth. -/""",
     """first member's line ends at its old age, which still conditions the second member's birth. -/""")
edit("""/-- **The member's line ends while the net goes on**, so the member's class is not constant up to the
net's end, even at the first member's class. -/""", """/-- **The member's line ends while its last stage still conditions something**, so the member's class is
not constant up to the net's end, even at the first member's class. -/""")
edit("""/-- **Divided more finely, the class is not constant up to the net's end at `m`**: `m` conditions `b`, and
`c`, alike to `m`, goes on to `d` alone. -/""", """/-- **Divided more finely, the class is not constant up to the net's end at `m`**: `m` conditions `b`, and
`c`, alike to `m`, conditions `d` alone. -/""")
edit("""`a` conditions `s`, and `b` goes on to `x` alone. Divided more finely, `a` apart from `b` and `x`, the class""",
     """`a` conditions `s`, and `b` conditions `x` alone. Divided more finely, `a` apart from `b` and `x`, the class""")
edit("""`a` conditions `s`, and `b` goes on without conditioning anything alike to `s`. -/""",
     """`a` conditions `s`, and `b` conditions something but nothing alike to `s`. -/""")

# FinerWake, after FinerOutside
OCC = ['m', 'c', 'i', 'j', 'b', 'd']
TRUE = {('m', 'i'), ('m', 'b'), ('c', 'j'), ('c', 'd')}
table = '\n'.join(f"  | .{x}, .{y} => {'True' if (x, y) in TRUE else 'False'}" for x in OCC for y in OCC)
edit("""end FinerOutside
""", """end FinerOutside

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
""" + table + """

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
""")

if PF:
    # PF's and PF2's "goes on" for "conditions something", on the PF line owner's yes
    for old, new in (
            ("its line ending at old age while the net goes on (`FiniteFamilies`).",
             "its line ending at old age while that stage still conditions something (`FiniteFamilies`)."),
            ("effects (`FiniteWake`, finite and without cycles), and then every step of its line that goes on has\n  an effect outside it.",
             "effects (`FiniteWake`, finite and without cycles), and then every occurrence on its line that conditions\n  anything has an effect outside it."),
            ("/-- Within a family, each stage below the last goes on to the next. -/",
             "/-- Within a family, each stage below the last conditions the next. -/"),
            ("Each family's stage goes on to its next and to the condition's next; the condition's stage goes on to\neach family's next and to its own; nothing goes on after stage `3`.",
             "Each family's stage conditions its next and the condition's next; the condition's stage conditions\neach family's next and its own; a stage `3` conditions nothing."),
            ("/-- A stage below the last goes on to the next stage of the kinds it conditions. -/",
             "/-- A stage below the last conditions the next stage of each kind it is linked to. -/"),
            ("/-! A member `m` conditioning `i` and `u`; `i` goes on to `j` and conditions nothing outside the class.",
             "/-! A member `m` conditioning `i` and `u`; `i` conditions `j` and nothing outside the class."),
            ("Read as an agent, `i` would be an intended effect that goes on with no side effect; that is a",
             "Read as an agent, `i` would be an intended effect that acts with no side effect; that is a"),
            ("without cycles. The class holding `m`, `i` and `j` and keeping `u` and `u₂` apart is constant up to the\nnet's end though not constant, does not hold the member's effects, and every step of its line that\ngoes on has an effect outside it.",
             "without cycles. The class holding `m`, `i` and `j` and keeping `u` and `u₂` apart is constant up to the\nnet's end though not constant, does not hold the member's effects, and every occurrence on its line\nthat conditions anything has an effect outside it."),
            ("/-- **Every step of its line that goes on has an effect outside it.** -/",
             "/-- **Every occurrence on its line that conditions anything has an effect outside it.** -/")):
        edit(old, new)

assert '«外分唯系出类之同»' in text and 'namespace FinerWake' in text
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(text, encoding='utf-8')
print('GrammarPath: OC2 fixes applied' + (" (with PF's and PF2's wording)" if PF else '') + ' ->', out)
