#!/usr/bin/env python3
"""OC5: the crux's structure as laws, in Becoming.GrammarPath (OC4's review proved them in scratch,
review-oc4/OC4Doubts.lean, sections B, D, D2 and E; study section 423 left them for the next rebuild), with what
OC5's own review found (REVIEW-OC5.md, findings 4, 10 and 13).

- «后皆同类则后皆续»: where everything downstream of an occurrence is alike to it, everything downstream lies on its
  line under the class, with no regularity assumed; «后皆续当且仅当后皆同类»: so everything downstream of a member
  lies on its line exactly where everything downstream of it is alike to it; «后皆续则所缘同于»: so that reach asks
  that the class hold the member's effects; «后皆续当且仅当自与线皆闭»: the reach is exactly that the class holds
  the effects of the member and of each stage of its line; «亡而网续则后不皆续»: so, like the condition at the
  member's class, the reach excludes a line from the member that ends while its last stage still conditions
  something. «本类常闭则后皆续» now takes its line from «后皆同类则后皆续» (board rule 9), its statement unchanged:
  the condition at the class gives the alikeness, and the alikeness the line.
- «本类常当且仅当与己相随»: where the member conditions something, the condition at its class is that it and each
  alike occurrence follow each other; «外分唯系己出之同»: so how what lies outside is divided bears on the condition
  only through what is alike to the member's own effects that leave the class. «闭则外分无关» is now its corollary
  (board rule 9), its statement unchanged.
- FiniteFamilies.member_no_reach: the organism's case of «亡而网续则后不皆续».
- OtherLeaves, at the end under its own heading: a class holds a member's effects and those of each stage of its
  line, and fails the condition at its class, where another occurrence alike to it, off its line (other_off_line),
  conditions only what leaves the class and so does not have its effects held. So the reach does not need the
  regularity, which the laws above cannot drop (Inconstant), and the regularity, holding the effects of every alike
  occurrence, asks more than the reach does.
- The module doc names each, in the bullet at a member's class and in a bullet of OC5's own after the PF line's
  "Neither premise can be dropped", whose wording stays the PF line's.
usage: build_tree_oc5.py SOURCE OUT"""
import sys
from pathlib import Path

src, out = Path(sys.argv[1]), Path(sys.argv[2])
text = src.read_text(encoding='utf-8')
assert 'theorem «外分唯系出类之同»' in text and '«后皆续当且仅当后皆同类»' not in text, 'expects GrammarPath as on main'


def edit(old, new):
    global text
    assert text.count(old) == 1, (old[:90], text.count(old))
    text = text.replace(old, new)


# the module doc: the division at a member's class, and OC5's own bullet
edit("""  (`«外分唯系出类之同»`). Where the class holds the effects of a member that conditions something, the
  condition keeps every alike occurrence's effects in the class, so the division is idle
  (`«闭则外分无关»`). Merging what lies outside keeps the condition (`«外合不失本类之常»`), so where a
""", """  (`«外分唯系出类之同»`). Where the member conditions something, the condition at its class is that the
  member and each alike occurrence follow each other: whatever an alike occurrence conditions is alike to
  something the member conditions, and whatever the member conditions, each alike occurrence that conditions
  anything conditions something alike to it (`«本类常当且仅当与己相随»`). So how what lies outside is
  divided bears on it only through what is alike to the member's own effects that leave the class
  (`«外分唯系己出之同»`), and where the class holds the member's effects, none of them leaves and the division
  is idle (`«闭则外分无关»`). Merging what lies outside keeps the condition (`«外合不失本类之常»`), so where a
""")
edit("""  is a one-step instance of `«有常之逐点»`, whose conclusion is alikeness to the member's next stage.

Every declaration has an empty axiom report.""", """  is a one-step instance of `«有常之逐点»`, whose conclusion is alikeness to the member's next stage.
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

Every declaration has an empty axiom report.""")

# the reach, with no regularity assumed
edit("""def «所缘同于» (R E : «际» α) (m : α) : Prop := ∀ v, R m v → E m v
""", """def «所缘同于» (R E : «际» α) (m : α) : Prop := ∀ v, R m v → E m v

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
""")

# «本类常闭则后皆续» takes its line from «后皆同类则后皆续»
edit("""alike to the member, where the member conditions something and the class holds its effects, is alike to it
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
""", """alike to the member, where the member conditions something and the class holds its effects, is alike to it
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
""")

# the condition at the class, where the member conditions something, and the division of what lies outside
edit("""/-- **Where the class holds a member's effects, how what lies outside is divided is idle (闭则外分无关).**
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
""", """/-- **Where the member conditions something, the condition at its class is that it and each alike occurrence
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
""")

# the organism's case of the reach excluding an ending line
edit("""  member_not_constant_at («至终有常则本类至终有常» member_class constant (false, 0))

/-- Everything the first birth of a family conditions is in its family. -/
""", """  member_not_constant_at («至终有常则本类至终有常» member_class constant (false, 0))

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
""")

# the witness that the reach does not need the regularity, at the end under its own heading
edit("""end UnevenOutside

end Becoming""", """end UnevenOutside

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

end Becoming""")

out.write_text(text, encoding='utf-8')
print('OC5 laws written to', out)
