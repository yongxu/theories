import Becoming.PremiseWitnesses
import Becoming.IdleRemoval
import Becoming.MutualDependence
import Becoming.Joining
import Becoming.MatchedCourses
import Becoming.Optimum
import Becoming.Reconfiguration

/-!
# Premises that hold together

Board item LM. A conditional law says nothing where its premises cannot hold together. For these
laws nothing in the package had established the premise: each is met here, jointly with the law's
other premises, in a small model, and, where it costs a line, failed in another. No law is stated
beyond them, and none of these models is a claim about any world.

* **The link to C between listed level paths** (`ListedPaths.premises_hold`): one formation needing
  one unit at every step, one level path admitting it at the first step alone and one at no step.
  Admission is decided, what the two admit is listed, the second extends the first, and an order
  counting what is admitted is increasing in admission and ranks it so. With self-concern in the place
  of that order the continuation condition held de se holds on this web as well
  (`ListedPaths.premises_hold_de_se`). So `Web.extension_ranked_of_increasing` and
  `Web.extension_ranked_of_increasingInOwn` are not vacuous, where the same listing asked of every level
  path would leave no extension (`Web.no_extension_of_listsAdmitted_every`). One formation is the
  smallest case: it shows the premises can hold together, and says nothing of how often they do.
* **Removing idle steps** (`IdleStep.premises_hold`): a stuttering with one idle step, the moving
  steps it reads, and a world idle at that step, with something taking part at the next. Read as idle
  at a later step the same world fails it (`IdleStep.not_idle_later`).
* **Mutual feeding** (`TwoFeeding.mutuallyFed`): two formations, each requiring a condition only the
  other gives to. Where one requires nothing it fails (`OneFeeding.not_mutuallyFed`).
* **Joining** (`Joining.Once.finiteOutcomes`, `Joining.Once.locallyFinite`,
  `Joining.Once.connectedFrom`): the one passage's joining, in which a passage cannot join itself, has
  listed outcomes, holds each role in listed joinings, and is connected from its idle start.
* **A reconfiguration's bound** (`Reconfiguration.covered_and_not`): an arrangement ready for its
  bound, with one cause covered and one not.
* **Readings of matched courses** (`MatchedCourses.readings_hold_together`): one content relation
  relating the non-base claims and relating the base only to itself.
* **Portions returning less than one for one** (`Optimum.AtOnce.returnsLess_met`,
  `Optimum.AtOnce.returnsLess_fails`): met where nothing left stands next, failed where the whole
  stands as it was left. In whole amounts the premise asks that a portion never rise with what is left
  (`Optimum.AtOnce.portion_falls`), so what is met here is that case and no rate between.
-/

namespace Becoming

/-! ## The link to C between listed level paths -/

namespace ListedPaths

/-- One formation needing one unit of one condition at every step. -/
def web : Web Unit Unit :=
  ⟨fun _ _ => 0, fun _ _ => True, fun _ _ _ => True, fun _ _ _ => 1, fun _ _ _ => False⟩

/-- A level path holding nothing at every step. -/
def never : Nat → Unit → Nat := fun _ _ => 0

/-- A level path holding one unit at the first step and nothing after. -/
def once : Nat → Unit → Nat
  | 0, _ => 1
  | _ + 1, _ => 0

/-- Whether the levels admit: the one requirement is met. -/
def admitted (l : Nat → Unit → Nat) (i : Nat × Unit) : Bool := Nat.ble 1 (l i.1 ())

/-- Everything the two paths admit: the formation at the first step. -/
def items : List (Nat × Unit) := [(0, ())]

theorem decides : web.DecidesAdmission admitted := fun _ _ =>
  ⟨fun yes _ _ => Nat.le_of_ble_eq_true yes, fun admits => Nat.ble_eq_true_of_le (admits () trivial)⟩

theorem once_listed : web.ListsAdmitted items once
  | 0, (), _ => .head _
  | _ + 1, (), admits => absurd (admits () trivial) (Nat.not_succ_le_zero 0)

theorem never_listed : web.ListsAdmitted items never :=
  fun _ _ admits => absurd (admits () trivial) (Nat.not_succ_le_zero 0)

theorem extension : Extension web.paths (fun _ => True) never once :=
  ⟨fun _ admits => absurd (admits () trivial) (Nat.not_succ_le_zero 0),
   ((), 0), trivial, fun _ _ => Nat.le_refl 1, fun admits => absurd (admits () trivial) (Nat.not_succ_le_zero 0)⟩

/-- An order counting what is admitted, with weight one. -/
abbrev counted : (Nat × Unit → Bool) → (Nat × Unit → Bool) → Prop :=
  Weighting.ranks items fun _ => 1

theorem increasing : Weighting.Increasing items counted :=
  Weighting.increasing_ranks fun _ _ => Nat.succ_pos 0

/-- **The link's premises hold together, and the link ranks the extension.** -/
theorem premises_hold :
    web.DecidesAdmission admitted ∧ web.ListsAdmitted items once ∧ web.ListsAdmitted items never ∧
      Extension web.paths (fun _ => True) never once ∧ Weighting.Increasing items counted ∧
      counted (admitted never) (admitted once) :=
  ⟨decides, once_listed, never_listed, extension, increasing,
   Web.extension_ranked_of_increasing decides increasing once_listed never_listed extension⟩

/-- **With self-concern in the place of the increasing order**, the continuation condition held de
se on this web, marking the one formation. -/
theorem premises_hold_de_se {O : (Nat × Unit → Bool) → (Nat × Unit → Bool) → Prop}
    (concerned : Weighting.IncreasingInOwn items (fun _ => true) O) :
    Unrestricted (selfAscribed (ownClosure (fun (_ _ : Unit) => True)) (fun (_ : Unit) => ())) ∧
      O (admitted never) (admitted once) :=
  have unrestricted : Unrestricted (selfAscribed (ownClosure (fun (_ _ : Unit) => True)) (fun (_ : Unit) => ())) :=
    ownClosure_unrestricted_iff.mpr fun _ _ => WithinClosure.refl ()
  ⟨unrestricted, Web.extension_ranked_of_increasingInOwn unrestricted (p := ()) (own := fun _ => true)
    (fun _ _ => rfl) decides concerned once_listed never_listed extension⟩

/-- What a level path admits need not be listed: the list without the first step fails. -/
theorem not_listed : ¬ web.ListsAdmitted [] once :=
  fun listed => nomatch listed 0 () fun _ _ => Nat.le_refl 1

end ListedPaths

/-! ## Removing idle steps -/

namespace IdleStep

/-- The reading idle at the first step and moving at every other. -/
def reading : Nat → Nat
  | 0 => 0
  | n + 1 => n

/-- The moving steps it reads. -/
def moving (s : Nat) : Nat := s + 1

theorem stutter : Stutter reading :=
  ⟨rfl, fun n => match n with
    | 0 => .inl rfl
    | _ + 1 => .inr rfl, fun s => ⟨s + 1, rfl⟩⟩

theorem moves : Stutter.Moves reading moving := fun _ => ⟨rfl, rfl⟩

/-- Nothing takes part at the first step; one relatum exchanges at every other. -/
def flow : Flow Unit Unit :=
  ⟨fun t => match t with
    | 0 => []
    | _ + 1 => [()], fun _ _ _ => 1, fun _ _ _ => 1⟩

/-- A web that does not change. -/
def web : Web Unit Unit :=
  ⟨fun _ _ => 1, fun _ _ => True, fun _ _ _ => True, fun _ _ _ => 1, fun _ _ _ => False⟩

/-- The world idle at the first step. -/
def world : World := World.of Unit flow web

theorem idle : world.IdleAt reading
  | 0, _ => ⟨rfl, fun _ => ⟨rfl, rfl, fun _ => ⟨rfl, rfl, rfl⟩⟩⟩
  | n + 1, same => absurd same (Nat.succ_ne_self n)

/-- **Removing idle steps has a case with an idle step in it**: the stuttering, its moving steps and
the world idle at them hold together, and something takes part at a moving step. -/
theorem premises_hold :
    Stutter reading ∧ Stutter.Moves reading moving ∧ world.IdleAt reading ∧ reading 1 = reading 0 ∧
      world.flow.present 1 ≠ [] :=
  ⟨stutter, moves, idle, rfl, fun none => nomatch none⟩

/-- Read as idle at the second step, the world fails it: something takes part there. -/
theorem not_idle_later {ρ : Nat → Nat} (same : ρ 2 = ρ 1) : ¬ world.IdleAt ρ :=
  fun at_ => nomatch (at_ 1 same).1

end IdleStep

/-! ## Mutual feeding -/

namespace TwoFeeding

/-- Each formation requires its own condition. -/
def web : Web Bool Bool :=
  ⟨fun _ _ => 1, fun _ _ => True, fun _ f c => c = f, fun _ _ _ => 1, fun _ _ _ => False⟩

/-- Each formation gives to the other's condition. -/
def flow : Flow Bool Bool :=
  ⟨fun _ => [true, false], fun _ _ _ => 0, fun _ g c => cond (g == c) 0 1⟩

theorem present : ∀ g, g ∈ flow.present 0
  | true => .head _
  | false => .tail _ (.head _)

/-- **Each formation's continuation is fed by the other's**, so the flow is mutually fed. -/
theorem mutuallyFed : flow.MutuallyFed web
  | true, true => WithinClosure.refl _
  | false, false => WithinClosure.refl _
  | true, false => WithinClosure.of_rel ⟨0, rfl, true, rfl, present false, Nat.succ_pos 0⟩
  | false, true => WithinClosure.of_rel ⟨0, rfl, false, rfl, present true, Nat.succ_pos 0⟩

end TwoFeeding

namespace OneFeeding

/-- Only one formation requires anything. -/
def web : Web Bool Bool :=
  ⟨fun _ _ => 1, fun _ _ => True, fun _ f _ => f = true, fun _ _ _ => 1, fun _ _ _ => False⟩

/-- The other gives to everything. -/
def flow : Flow Bool Bool :=
  ⟨fun _ => [true, false], fun _ _ _ => 0, fun _ g _ => cond g 0 1⟩

/-- **Where only one is fed, the flow is not mutually fed**: what requires nothing is fed by nothing. -/
theorem not_mutuallyFed : ¬ flow.MutuallyFed web :=
  fun fed => Bool.noConfusion (fed false true (fun x => x = false)
    (fun x _ (hx : x = false) ⟨_, _, _, requires, _⟩ =>
      Bool.noConfusion ((hx.symm.trans requires) : false = true)) rfl)

end OneFeeding

/-! ## Joining with listed outcomes -/

namespace Joining.Once

/-- What each pair joins into. -/
def outcomes : Piece → Piece → List Piece
  | .start, .start => [.start]
  | .start, .passage => [.passage]
  | .start, .finish => []
  | .finish, .finish => [.finish]
  | .finish, .start => []
  | .finish, .passage => []
  | .passage, .finish => [.passage]
  | .passage, .start => []
  | .passage, .passage => []

theorem eq_of_mem_single {a z : Piece} : z ∈ [a] → z = a
  | .head _ => rfl
  | .tail _ t => nomatch t

theorem joins_of_mem : ∀ {x y z : Piece}, z ∈ outcomes x y → Joins x y z
  | .start, .start, _, m => Eq.subst (motive := Joins .start .start) (eq_of_mem_single m).symm .start
  | .start, .passage, _, m => Eq.subst (motive := Joins .start .passage) (eq_of_mem_single m).symm .enter
  | .finish, .finish, _, m => Eq.subst (motive := Joins .finish .finish) (eq_of_mem_single m).symm .finish
  | .passage, .finish, _, m => Eq.subst (motive := Joins .passage .finish) (eq_of_mem_single m).symm .leave
  | .start, .finish, _, m => nomatch m
  | .finish, .start, _, m => nomatch m
  | .finish, .passage, _, m => nomatch m
  | .passage, .start, _, m => nomatch m
  | .passage, .passage, _, m => nomatch m

theorem mem_of_joins : ∀ {x y z : Piece}, Joins x y z → z ∈ outcomes x y
  | .start, .start, .start, .start => List.Mem.head _
  | .finish, .finish, .finish, .finish => List.Mem.head _
  | .start, .passage, .passage, .enter => List.Mem.head _
  | .passage, .finish, .passage, .leave => List.Mem.head _

/-- **The one passage's joining has listed outcomes.** -/
theorem finiteOutcomes : joining.FiniteOutcomes := fun x y =>
  ⟨outcomes x y, fun _ => ⟨mem_of_joins, joins_of_mem⟩⟩

/-- Whether two pieces are one. -/
def same : Piece → Piece → Bool
  | .start, .start => true
  | .finish, .finish => true
  | .passage, .passage => true
  | .start, .finish => false
  | .start, .passage => false
  | .finish, .start => false
  | .finish, .passage => false
  | .passage, .start => false
  | .passage, .finish => false

theorem same_iff : ∀ {a b : Piece}, same a b = true ↔ a = b
  | .start, .start => ⟨fun _ => rfl, fun _ => rfl⟩
  | .finish, .finish => ⟨fun _ => rfl, fun _ => rfl⟩
  | .passage, .passage => ⟨fun _ => rfl, fun _ => rfl⟩
  | .start, .finish => ⟨fun h => Bool.noConfusion h, fun h => nomatch h⟩
  | .start, .passage => ⟨fun h => Bool.noConfusion h, fun h => nomatch h⟩
  | .finish, .start => ⟨fun h => Bool.noConfusion h, fun h => nomatch h⟩
  | .finish, .passage => ⟨fun h => Bool.noConfusion h, fun h => nomatch h⟩
  | .passage, .start => ⟨fun h => Bool.noConfusion h, fun h => nomatch h⟩
  | .passage, .finish => ⟨fun h => Bool.noConfusion h, fun h => nomatch h⟩

/-- The joinings of the one passage. -/
def occurrences : List (Occurrence joining) :=
  [⟨.start, .start, .start, .start⟩, ⟨.finish, .finish, .finish, .finish⟩,
   ⟨.start, .passage, .passage, .enter⟩, ⟨.passage, .finish, .passage, .leave⟩]

theorem mem_occurrences : ∀ e : Occurrence joining, e ∈ occurrences
  | ⟨_, _, _, .start⟩ => .head _
  | ⟨_, _, _, .finish⟩ => .tail _ (.head _)
  | ⟨_, _, _, .enter⟩ => .tail _ (.tail _ (.head _))
  | ⟨_, _, _, .leave⟩ => .tail _ (.tail _ (.tail _ (.head _)))

/-- **Each piece holds each role in a listed set of joinings.** -/
theorem locallyFinite : joining.LocallyFinite := fun x r =>
  ⟨occurrences.filter fun e => same (e.at r) x, fun e =>
    ⟨fun held => ListTests.mem_filter_iff.mpr ⟨mem_occurrences e, same_iff.mpr held⟩,
     fun m => same_iff.mp (ListTests.mem_filter_iff.mp m).2⟩⟩

/-- The joining the passage enters by. -/
def enters : Occurrence joining := ⟨.start, .passage, .passage, .enter⟩

/-- The joining the passage leaves by. -/
def leaves : Occurrence joining := ⟨.passage, .finish, .passage, .leave⟩

/-- **Through roles, everything is reached from the idle start.** -/
theorem connectedFrom : joining.ConnectedFrom .start :=
  have into : joining.roleFrame.P.step (.inl .start) (.enter .first) (.inr enters) :=
    (rfl : enters.at .first = .start)
  have out : joining.roleFrame.P.step (.inr enters) (.leave .second) (.inl .passage) :=
    (rfl : Piece.passage = enters.at .second)
  have on : joining.roleFrame.P.step (.inl .passage) (.enter .first) (.inr leaves) :=
    (rfl : leaves.at .first = .passage)
  have off : joining.roleFrame.P.step (.inr leaves) (.leave .second) (.inl .finish) :=
    (rfl : Piece.finish = leaves.at .second)
  have toPassage : Reach joining.roleFrame.P (.inl .start) (.inl .passage) :=
    (Reach.of_step into).trans (Reach.of_step out)
  fun a => match a with
    | .start => Reach.refl _ _
    | .passage => toPassage
    | .finish => toPassage.trans ((Reach.of_step on).trans (Reach.of_step off))

end Joining.Once

/-! ## A reconfiguration's bound -/

namespace Reconfiguration

/-- Two members, each failing by its own cause; the bound allows the first's. -/
def twoCauses : Arrangement := ⟨[0, 1], fun d => .cause d, [[0]]⟩

/-- **A bound covers what it allows, on an arrangement ready for it.** So the laws asking a covered
cause on a ready arrangement have a case, and a cause outside the bound fails the premise. -/
theorem covered_and_not : ready twoCauses = true ∧ Covered twoCauses [0] ∧ ¬ Covered twoCauses [1] :=
  ⟨rfl, ⟨[0], List.Mem.head _, fun _ m => m⟩, fun ⟨b, (member : b ∈ [[0]]), sub⟩ => match b, member, sub with
    | _, .head _, sub => match sub 1 (.head _) with
      | .tail _ t => nomatch t
    | _, .tail _ t, _ => nomatch t⟩

end Reconfiguration

/-! ## Readings of matched courses -/

namespace MatchedCourses

/-- The reading relating the non-base claims and the base only to itself. -/
def lossesAlike (c d : Claim) : Prop := (c ≠ .base ∧ d ≠ .base) ∨ (c = .base ∧ d = .base)

/-- **Both readings of the content relation hold together**, so the conditional anchors
(`MatchedCourses.conditional_lower_anchor`, `MatchedCourses.conditional_upper_anchor`) and the fragile
case (`MatchedCourses.fragile_b3_not_matching`) are read on one relation. -/
theorem readings_hold_together : BasicAlike lossesAlike ∧ BaseApart lossesAlike :=
  ⟨fun _ _ c d => .inl ⟨c, d⟩, fun _ same => match same with
    | .inl ⟨no, _⟩ => absurd rfl no
    | .inr ⟨_, at_⟩ => at_⟩

end MatchedCourses

/-! ## Portions returning less than one for one -/

namespace Optimum.AtOnce

/-- **What is left may return nothing.** Where nothing left stands next, every portion returns less
than one for one. In whole amounts that is what the premise asks (`Optimum.AtOnce.portion_falls`). -/
theorem returnsLess_met (portion : Nat → Nat → Nat → Nat) (k N : Nat) :
    ReturnsLess (fun _ _ => 0) portion k N :=
  fun _ _ _ _ _ _ pos => Nat.lt_add_of_pos_right pos

/-- **The whole, standing as it was left, returns one for one**, so it fails the premise wherever a
drawer has a step after the first. -/
theorem returnsLess_fails {k N : Nat} (drawer : 0 < k) (later_ : 1 < N) :
    ¬ ReturnsLess (fun _ x => x) (fun _ _ z => z) k N :=
  fun returns => Nat.lt_irrefl _ (returns 0 drawer 0 later_ 0 1 (Nat.succ_pos 0))

end Optimum.AtOnce

end Becoming
