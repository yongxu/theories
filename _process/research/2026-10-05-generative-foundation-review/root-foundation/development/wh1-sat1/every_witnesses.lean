namespace Generations

/-- **The same parts, the two wholes.** A formation that is the whole of every member is active
at no step, while the lineage, the whole of some member, is active at every step (`generations`):
the member arising two steps on is not yet active. -/
theorem allWhole_never {v : Formation} (all : web.AllWhole parts v) (t : Nat) :
    ¬ web.active t v :=
  all.inactive_of_part (p := .member (t + 2)) trivial fun active => match active with
    | .inl same => Nat.ne_of_lt (Nat.lt_add_of_pos_right (Nat.succ_pos 1)) same
    | .inr same => Nat.ne_of_lt (Nat.lt_succ_of_lt (Nat.lt_add_of_pos_right (Nat.succ_pos 1))) same

end Generations

namespace Rafters

/-- Rafters, a house and what is left of it. -/
inductive Formation where
  | rafter (i : Nat)
  | house
  | remains

/-- Three rafters. -/
def rafters : List Formation := [.rafter 0, .rafter 1, .rafter 2]

/-- The first rafter is taken after the first step, the others stay; the house stands at the
first step only, what is left of it at every step. -/
def web : Web Formation Unit where
  level _ _ := 0
  active t f := match f with
    | .rafter i => t = 0 ∨ 0 < i
    | .house => t = 0
    | .remains => True
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- The house is the whole of every rafter. -/
theorem house : web.AllWhole (· ∈ rafters) .house :=
  fun _ => ⟨fun first p mem => match p, mem with
      | _, .head _ => .inl first
      | _, .tail _ (.head _) => .inl first
      | _, .tail _ (.tail _ (.head _)) => .inl first
      | _, .tail _ (.tail _ (.tail _ no)) => (nomatch no),
    fun every => match every (.rafter 0) (.head _) with
      | .inl first => first
      | .inr stays => absurd stays (Nat.lt_irrefl 0)⟩

/-- What is left is the whole of some rafter. -/
theorem remains : web.Whole (· ∈ rafters) .remains :=
  fun _ => ⟨fun _ => ⟨.rafter 1, .tail _ (.head _), .inr (Nat.succ_pos 0)⟩, fun _ => trivial⟩

/-- Each formation's activity is decided at every step. -/
theorem decided : ∀ t f, Decided (web.active t f)
  | t, .rafter i => match Nat.decEq t 0 with
    | isTrue first => .inl (.inl first)
    | isFalse later => match Nat.decLt 0 i with
      | isTrue kept => .inl (.inr kept)
      | isFalse taken => .inr fun active => match active with
        | .inl first => later first
        | .inr kept => taken kept
  | t, .house => match Nat.decEq t 0 with
    | isTrue first => .inl first
    | isFalse later => .inr later
  | _, .remains => .inl trivial

/-- From the second step on, two of the three rafters are active. -/
theorem grade_two {t : Nat} (later : 0 < t) : web.Grade rafters t 2 :=
  ⟨0, 2, .inr ⟨fun active => match active with
      | .inl first => Nat.lt_irrefl 0 (Eq.subst (motive := (0 < ·)) first later)
      | .inr stays => Nat.lt_irrefl 0 stays, rfl⟩,
    ⟨1, 1, .inl ⟨.inr (Nat.succ_pos 0), rfl⟩, ⟨1, 0, .inl ⟨.inr (Nat.succ_pos 1), rfl⟩, rfl, rfl⟩,
      rfl⟩, rfl⟩

/-- **A rafter taken, no house.** The house of three rafters ceases across the first step, as the
first rafter does; from then on two of the three are active, the whole is diminished, what is
left stands and the house does not. -/
theorem taken :
    web.Ceases 0 .house ∧ web.Ceases 0 (.rafter 0) ∧
    ∀ t, 0 < t → web.Grade rafters t 2 ∧ web.Diminished rafters t ∧
      web.active t .remains ∧ ¬ web.active t .house :=
  ⟨⟨rfl, fun after => Nat.lt_irrefl 0 (Eq.subst (motive := (0 < ·)) after (Nat.succ_pos 0))⟩,
   ⟨.inl rfl, fun active => match active with
      | .inl first => Nat.lt_irrefl 0 (Eq.subst (motive := (0 < ·)) first (Nat.succ_pos 0))
      | .inr stays => Nat.lt_irrefl 0 stays⟩,
   fun t later =>
    have notHouse : ¬ web.active t .house :=
      fun first => Nat.lt_irrefl 0 (Eq.subst (motive := (0 < ·)) first later)
    ⟨grade_two later, (Web.diminished_iff remains house fun p _ => decided t p).mpr ⟨trivial, notHouse⟩,
     trivial, notHouse⟩⟩

end Rafters
