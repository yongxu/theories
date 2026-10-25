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
`c`, alike to `m`, goes on to `d` alone. -/
theorem finer_not_constant_at : ¬ «本类至终有常» step finer .m := fun atClass =>
  match atClass .m .c rfl rfl .b trivial with
  | .inl ⟨v', r, e⟩ => match v', r, e with
    | .d, _, e => Nat.noConfusion (Nat.succ.inj e)
  | .inr stops => stops .d trivial

end FinerOutside

namespace UnevenOutside

/-! A member `s` conditioning `t`, `a` conditioning `s`, `b` conditioning `x`, and nothing else. The member's
class is `s` and `t`. Under the split into that class and the rest, the class is constant up to the net's
end at `s` and holds `s`'s effects, but is not constant up to the net's end: `a` and `b` are alike outside,
`a` conditions `s`, and `b` goes on to `x` alone. Divided more finely, `a` apart from `b` and `x`, the class
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
`a` conditions `s`, and `b` goes on without conditioning anything alike to `s`. -/
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
