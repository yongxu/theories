import Becoming.GrammarTesting
import Becoming.GrammarLaws
import Becoming.GrammarReadings
import Becoming.MapRegions

/-!
# Rooms on the net of the possible: testing (验) by a window

One rule makes the nets of a family of rooms: the one-unfolding plan's model examples of 验
(`PLAN.md` §八, step 5). A room has a level, in whole units of heat. Its surroundings are at
its set level `m` while its window is shut and at `0` once it opens; each step the level moves one
unit toward the surroundings' level, and a heater, reading the level left, gives `c` where that is
below the set level. So `m` is the room's margin, counted in the open window's draws of one. The
unheated room (`c = 0`) is thermal equilibrium; the heated rooms are thermostats, the matched one
(`c = 1`) giving exactly what the open window draws and the overshooting one (`c = 2`) more. The
window's opening is in the net (`net`): the successors of an occurrence are alternatives, the
possible-net reading. `shut` is the net without it. A heater is a term of its room's rule, not an
occurrence, so the rooms are compared side by side on a carrier that tags each occurrence with its
heater (`joint`): rules compared, not occurrences of one unfolding.

* **Regions**, at a margin of three unless stated (at warm or not, and the level class): the
  overshooting thermostat at its set level is 全生成 and 守, a model case of the mixed region
  (`«给过所取则生守相杂»`); the unheated room keeps and reaches an end, and after the window opens
  degenerates while renewing (`«平衡守而有终»`, `«开窗则平衡新而尽»`); at every positive margin the
  matched thermostat is 全守 (`«给如所取则全守»`), and so is every room while no window opens
  (`shut_rests`).
* **Testing.** Without the window, at every margin, every room at its set level is one core class
  at the level class (`«不开窗则同核»`). With it, at every positive margin, the first stage of the
  level tells the unheated room from every heated one (`«开窗则一层可分»`), and warm or not first
  tells them apart at the stage of the margin (`«开窗以温层如其余乃分»`); warm or not does not tell
  two heated rooms apart (`«有给之室以温不可分»`).
* **A conditional law.** Warmth is a constant class under the net exactly where the heater gives
  (`«温有常当且仅当有给»`), and from a margin of two draws on no line of warmth from the set level
  ends exactly there (`«温不穷当且仅当有给»`, by `«有常则往不穷»`); at a margin of one none ends,
  heater or not (`unended_at_one`), so the margin of two is needed. Across rooms the converse fails
  (`joint_converse`).
* **The toy derived.** `«恒温与平衡»` (`Becoming.GrammarTesting`) stipulates four rooms' branches.
  At a margin of one draw they are the rule's (`toy_branches`), and the toy's verdict at stage 1 is
  the rule's (`toy_verdict`, from `«开窗以温层如其余乃分»` at that margin).
* **The reading order.** The heater reads the level after the exchange, so it answers the window's
  draw within the step. Read before it, the window moves a heated room's level
  (`before_window_moves`); read either way, from a margin of two on, every step of a heated room
  lands warm (`next_pos`, `before_pos`).

The design, its review and re-check, and the hand checks are in the root's development folder,
`ou7-conditional-laws/check/`.

Every declaration has an empty axiom report.
-/

namespace Becoming

namespace Rooms

/-! ## The rule and the nets -/

/-- An occurrence of a room: whether its window is open, and its level, in whole units of heat. -/
structure Occurrence where
  opened : Bool
  level : Nat

/-- The surroundings' level: the set level `m` while the window is shut, `0` once it is open. -/
def surroundings (m : Nat) (opened : Bool) : Nat := cond opened 0 m

/-- The exchange with surroundings at `σ`: the level moves one unit toward them. -/
def exchange (σ x : Nat) : Nat := if x < σ then x + 1 else if σ < x then x - 1 else x

/-- The heater: reading the level `z` left after the exchange, it gives `c` where `z` is below the
set level `m`, and nothing otherwise. -/
def heater (m c z : Nat) : Nat := if z < m then c else 0

/-- The rule: the exchange with the surroundings, then the heater's giving. -/
def next (m c σ x : Nat) : Nat := exchange σ x + heater m c (exchange σ x)

/-- While the window stays shut: the room exchanges with surroundings at the set level. -/
def shut (m c : Nat) : «际» Occurrence := fun x y =>
  x.opened = false ∧ y.opened = false ∧ y.level = next m c m x.level

/-- With the window's opening in the net: a shut room may stay shut or open its window, an open
window stays open, and each step exchanges with the surroundings the window leaves. -/
def net (m c : Nat) : «际» Occurrence := fun x y =>
  (x.opened = false ∨ y.opened = true) ∧ y.level = next m c (surroundings m y.opened) x.level

/-- The window open: the net from open occurrences only. -/
def openNet (m c : Nat) : «际» Occurrence := fun x y => x.opened = true ∧ net m c x y

/-- The level class: the same level. -/
def sameLevel : «际» Occurrence := fun x y => x.level = y.level

/-- Whether a room is warm: above the open surroundings' level. -/
def warm (x : Occurrence) : Bool :=
  match x.level with
  | 0 => false
  | _ + 1 => true

/-- The coarse class: warm or not. -/
def alike : «际» Occurrence := fun x y => warm x = warm y

/-- A room at its set level, the window shut. -/
def start (m : Nat) : Occurrence := ⟨false, m⟩

theorem alike_class : «类» alike := ⟨fun _ => rfl, fun h => h.symm, fun h₁ h₂ => h₁.trans h₂⟩

/-- At the set level the exchange leaves a room where it is, and the heater gives nothing. -/
theorem next_rest (m c : Nat) : next m c m m = m := by
  have e : exchange m m = m := by
    show (if m < m then m + 1 else if m < m then m - 1 else m) = m
    rw [if_neg (Nat.lt_irrefl m), if_neg (Nat.lt_irrefl m)]
  show exchange m m + heater m c (exchange m m) = m
  rw [e]
  show m + (if m < m then c else 0) = m
  rw [if_neg (Nat.lt_irrefl m), Nat.add_zero]

/-- With the window open, a heated room at its set level loses one unit and the heater gives. -/
theorem warms_open (n c : Nat) : next (n + 1) c 0 (n + 1) = n + c := by
  show n + heater (n + 1) c n = n + c
  rw [show heater (n + 1) c n = c from if_pos (Nat.lt_succ_self n)]

/-- A room at its set level, the window shut, may stay as it is. -/
theorem rest_step (m c : Nat) : net m c (start m) (start m) := ⟨.inl rfl, (next_rest m c).symm⟩

/-- Any room can open its window, or keep it open. -/
theorem opens (m c : Nat) (x : Occurrence) : net m c x ⟨true, next m c 0 x.level⟩ := ⟨.inr rfl, rfl⟩

/-- An open window stays open, by the open rule. -/
theorem net_open {m c l : Nat} : ∀ {y : Occurrence}, net m c ⟨true, l⟩ y → y = ⟨true, next m c 0 l⟩
  | ⟨true, _⟩, ⟨_, e⟩ => congrArg (Occurrence.mk true) e
  | ⟨false, _⟩, ⟨.inl h, _⟩ => Bool.noConfusion h
  | ⟨false, _⟩, ⟨.inr h, _⟩ => Bool.noConfusion h

/-- A shut room stays shut or opens its window. -/
theorem net_shut {m c l : Nat} : ∀ {y : Occurrence}, net m c ⟨false, l⟩ y →
    y = ⟨false, next m c m l⟩ ∨ y = ⟨true, next m c 0 l⟩
  | ⟨false, _⟩, ⟨_, e⟩ => .inl (congrArg (Occurrence.mk false) e)
  | ⟨true, _⟩, ⟨_, e⟩ => .inr (congrArg (Occurrence.mk true) e)

/-- While the window stays shut, a room at its set level stays there. -/
theorem shut_start {m c : Nat} : ∀ {y : Occurrence}, shut m c (start m) y → y = start m
  | ⟨false, _⟩, ⟨_, _, e⟩ => congrArg (Occurrence.mk false) (e.trans (next_rest m c))
  | ⟨true, _⟩, ⟨_, h, _⟩ => Bool.noConfusion h

/-- **Where the open rule moves its level, an open occurrence begins a line of its level.** -/
theorem begins_open {m c l : Nat} (moves : next m c 0 l ≠ l) : «生» (net m c) sameLevel ⟨true, l⟩ :=
  fun ⟨_, ⟨_, e⟩, same⟩ => moves (Eq.subst (motive := fun k => l = next m c 0 k) same e).symm

/-- A shut room at its set level is not a beginning at its level: it continues itself. -/
theorem not_begins_start (m c : Nat) : ¬ «生» (net m c) sameLevel (start m) :=
  fun begins => begins ⟨start m, rest_step m c, rfl⟩

theorem warm_of_pos : ∀ {x : Occurrence}, 0 < x.level → warm x = true
  | ⟨_, 0⟩, h => absurd h (Nat.lt_irrefl 0)
  | ⟨_, _ + 1⟩, _ => rfl

/-- Warm or not reads the level alone. -/
theorem warm_of_level {x y : Occurrence} (h : x.level = y.level) : warm x = warm y :=
  congrArg (fun l => warm ⟨false, l⟩) h

/-- Where the heater gives below a positive set level, the rule never leaves a room at the open
surroundings' level. -/
theorem next_pos {m c : Nat} (hm : 1 ≤ m) (hc : 1 ≤ c) (σ x : Nat) : 0 < next m c σ x := by
  unfold next
  cases exchange σ x with
  | zero =>
    show 0 < 0 + (if 0 < m then c else 0)
    rw [if_pos (show 0 < m from hm)]
    exact Nat.lt_of_lt_of_le hc (Nat.le_add_left c 0)
  | succ k => exact Nat.lt_of_lt_of_le (Nat.succ_pos k) (Nat.le_add_right (k + 1) _)

/-- **In a heated room with a positive set level every successor is warm**: every branch stays
warm. -/
theorem heated_warm {m c : Nat} (hm : 1 ≤ m) (hc : 1 ≤ c) {x y : Occurrence} (h : net m c x y) :
    warm y = true :=
  warm_of_pos (Eq.subst (motive := fun k => 0 < k) h.2.symm (next_pos hm hc _ _))

/-- The exchange takes at most one unit. -/
theorem exchange_ge (σ x : Nat) : x - 1 ≤ exchange σ x := by
  show x - 1 ≤ (if x < σ then x + 1 else if σ < x then x - 1 else x)
  exact if h : x < σ then by
      rw [if_pos h]; exact Nat.le_trans (Nat.sub_le x 1) (Nat.le_succ x)
    else if h' : σ < x then by
      rw [if_neg h, if_pos h']; exact Nat.le_refl _
    else by
      rw [if_neg h, if_neg h']; exact Nat.sub_le x 1

/-- Without a heater nothing is given. -/
theorem heater_zero (m z : Nat) : heater m 0 z = 0 := ite_self 0

/-- Without a heater the rule is the exchange alone. -/
theorem next_zero (m σ x : Nat) : next m 0 σ x = exchange σ x :=
  (congrArg (exchange σ x + ·) (heater_zero m (exchange σ x))).trans (Nat.add_zero _)

/-- **With the window open and no heater, a room loses one unit a step.** -/
theorem cools (m : Nat) (b : Bool) (l : Nat) : net m 0 ⟨b, l + 1⟩ ⟨true, l⟩ :=
  ⟨.inr rfl, (next_zero m 0 (l + 1)).symm⟩

/-- Warmth ends at an unheated room's open occurrence at `1`: its only successor is cold. -/
theorem cold_after (m : Nat) : «亡» (net m 0) alike ⟨true, 1⟩ := fun ⟨_, r, a⟩ =>
  Bool.noConfusion (Eq.subst (motive := fun y => alike ⟨true, 1⟩ y)
    ((net_open r).trans (congrArg (Occurrence.mk true) (next_zero m 0 1))) a)

/-- The unheated room's cold open occurrence steps only to itself. -/
theorem cold_step {m : Nat} {y : Occurrence} (r : net m 0 ⟨true, 0⟩ y) : y = ⟨true, 0⟩ :=
  (net_open r).trans (congrArg (Occurrence.mk true) (next_zero m 0 0))

/-! ## The unheated room (`c = 0`), at a margin of three -/

namespace Unheated

def b2 : Occurrence := ⟨true, 2⟩
def b1 : Occurrence := ⟨true, 1⟩
def b0 : Occurrence := ⟨true, 0⟩

theorem s3_b2 : net 3 0 (start 3) b2 := cools 3 false 2
theorem b2_b1 : net 3 0 b2 b1 := cools 3 true 1
theorem b1_b0 : net 3 0 b1 b0 := cools 3 true 0

theorem begins_b2 : «生» (net 3 0) sameLevel b2 := begins_open (by decide)
theorem begins_b1 : «生» (net 3 0) sameLevel b1 := begins_open (by decide)

/-- Warmth ends at the open occurrence at `1`: its only successor is cold. -/
theorem b1_ends : «亡» (net 3 0) alike b1 := cold_after 3

/-- The occurrences warmth's line reaches from the set level, `start 3`, `b2` and `b1`, are closed
under it. -/
theorem closed : «闭» («续» (net 3 0) alike) (fun y => y = start 3 ∨ y = b2 ∨ y = b1)
  | _, _, .inl rfl, ⟨r, _⟩ => match net_shut r with
    | .inl e => .inl e
    | .inr e => .inr (.inl e)
  | _, _, .inr (.inl rfl), ⟨r, _⟩ => .inr (.inr (net_open r))
  | _, _, .inr (.inr rfl), c => absurd ⟨_, c⟩ b1_ends

theorem reach {y : Occurrence} (h : «所及» (net 3 0) alike (start 3) y) :
    y = start 3 ∨ y = b2 ∨ y = b1 :=
  match h with
  | .inl e => .inl e.symm
  | .inr l => «闭之及» closed (.inl rfl) l

theorem keeps : «守» (net 3 0) alike sameLevel (start 3) :=
  ⟨fun y => y = start 3, rfl,
   fun z hz => match z, hz with | _, rfl => ⟨start 3, rfl, rest_step 3 0, rfl⟩,
   fun u v hu hv t => by subst hu; subst hv; exact not_begins_start 3 0 t.2⟩

theorem ends : «有终» (net 3 0) alike (start 3) :=
  ⟨b1, .inr (.more ⟨s3_b2, rfl⟩ (.one ⟨b2_b1, rfl⟩)), b1_ends⟩

/-- Not 生成: a generating family holding the set level needs a renewal ahead between members whose
lines go on, and the only renewals ahead lie on the window's branch, whose warmth ends. -/
theorem not_generates : ¬ «生成» (net 3 0) alike sameLevel (start 3) :=
  fun ⟨S, _, closedS, ahead⟩ =>
  have no_b1 : ¬ S b1 := fun h => match closedS b1 h with
    | ⟨_, _, c⟩ => b1_ends ⟨_, c⟩
  have no_b2 : ¬ S b2 := fun h => match closedS b2 h with
    | ⟨_, hw, r, _⟩ => no_b1 (Eq.subst (motive := S) (net_open r) hw)
  match ahead (start 3) ‹S (start 3)› with
  | ⟨u, v, su, sv, hu, ⟨r, _⟩, begins⟩ => match reach hu with
    | .inl e => by
        subst e
        cases net_shut r with
        | inl ev => subst ev; exact not_begins_start 3 0 begins
        | inr ev => subst ev; exact no_b2 sv
    | .inr (.inl e) => no_b2 (e ▸ su)
    | .inr (.inr e) => no_b1 (e ▸ su)

theorem ends_b1 : «尽» (net 3 0) alike b1 := .mk fun y c => absurd ⟨y, c⟩ b1_ends

theorem ends_b2 : «尽» (net 3 0) alike b2 :=
  .mk fun _ ⟨r, _⟩ => Eq.subst (motive := «尽» (net 3 0) alike) (net_open r).symm ends_b1

/-- The rest of its rows: at the set level it keeps from some point on and is in neither strong form
(it reaches an end), so warmth is not a constant class under its net (`«有终则粗不有常»`); after the
window opens it reaches an end, and is in no region of generation or keeping (it degenerates). -/
theorem rows :
    ¬ «全生成» (net 3 0) alike sameLevel (start 3) ∧ ¬ «全守» (net 3 0) alike sameLevel (start 3) ∧
      «后守» (net 3 0) alike sameLevel (start 3) ∧ ¬ «有常» (net 3 0) alike ∧
      ¬ «生成» (net 3 0) alike sameLevel b2 ∧ ¬ «守» (net 3 0) alike sameLevel b2 ∧
      ¬ «后守» (net 3 0) alike sameLevel b2 ∧ ¬ «全生成» (net 3 0) alike sameLevel b2 ∧
      ¬ «全守» (net 3 0) alike sameLevel b2 ∧ «有终» (net 3 0) alike b2 :=
  have ends_at : «有终» (net 3 0) alike b2 := ⟨b1, .inr (.one ⟨b2_b1, rfl⟩), b1_ends⟩
  have not_after : ¬ «后守» (net 3 0) alike sameLevel b2 := fun k => «后守退化不并» ⟨k, ends_b2⟩
  ⟨fun g => «全生成有终不并» ⟨g, ends⟩, fun k => «全守有终不并» ⟨k, ends⟩, «守则后守» keeps,
   «有终则粗不有常» ⟨start 3, rest_step 3 0, rfl⟩ ends,
   fun g => «生成退化不并» ⟨g, ends_b2⟩, fun k => not_after («守则后守» k), not_after,
   fun g => «全生成有终不并» ⟨g, ends_at⟩, fun k => «全守有终不并» ⟨k, ends_at⟩, ends_at⟩

end Unheated

/-- **The unheated room at its set level keeps and reaches an end (平衡守而有终)**, at a margin of
three: it keeps along the shut branch, its warmth ends along the window's, it renews on the way,
and it is neither 生成 nor 退化. -/
theorem «平衡守而有终» :
    «守» (net 3 0) alike sameLevel (start 3) ∧ «有终» (net 3 0) alike (start 3) ∧
      «新而有终» (net 3 0) alike sameLevel (start 3) ∧
      ¬ «生成» (net 3 0) alike sameLevel (start 3) ∧ ¬ «退化» (net 3 0) alike (start 3) :=
  ⟨Unheated.keeps, Unheated.ends,
   ⟨Unheated.ends, start 3, Unheated.b2, .inl rfl, ⟨Unheated.s3_b2, rfl⟩, Unheated.begins_b2⟩,
   Unheated.not_generates, fun d => «守退化不并» ⟨Unheated.keeps, d⟩⟩

/-- **After the window opens the unheated room degenerates while renewing (开窗则平衡新而尽)**, at
its open occurrence at `2`, at a margin of three. -/
theorem «开窗则平衡新而尽» :
    «退化» (net 3 0) alike Unheated.b2 ∧ «新而尽» (net 3 0) alike sameLevel Unheated.b2 :=
  ⟨Unheated.ends_b2, Unheated.ends_b2, Unheated.b2, Unheated.b1, .inl rfl, ⟨Unheated.b2_b1, rfl⟩,
   Unheated.begins_b1⟩

/-! ## The matched thermostat (`c = 1`), at every positive margin -/

namespace Matched

/-- The matched thermostat after its window opens, at its set level. -/
def kept (m : Nat) : Occurrence := ⟨true, m⟩

/-- With the window open, the matched heater gives back the unit the window draws. -/
theorem open_rest {m : Nat} (hm : 1 ≤ m) : next m 1 0 m = m := by
  cases m with
  | zero => exact absurd hm (by decide)
  | succ n => exact warms_open n 1

theorem start_kept {m : Nat} (hm : 1 ≤ m) : net m 1 (start m) (kept m) :=
  Eq.subst (motive := fun v => net m 1 (start m) ⟨true, v⟩) (open_rest hm) (opens m 1 (start m))

theorem kept_kept {m : Nat} (hm : 1 ≤ m) : net m 1 (kept m) (kept m) :=
  Eq.subst (motive := fun v => net m 1 (kept m) ⟨true, v⟩) (open_rest hm) (opens m 1 (kept m))

theorem not_begins_kept {m : Nat} (hm : 1 ≤ m) : ¬ «生» (net m 1) sameLevel (kept m) :=
  fun b => b ⟨kept m, kept_kept hm, rfl⟩

/-- The set level, shut or open, is closed under the matched thermostat's net. -/
theorem closed {m : Nat} (hm : 1 ≤ m) : «闭» (net m 1) (fun y => y = start m ∨ y = kept m)
  | _, _, .inl rfl, r => match net_shut r with
    | .inl e => .inl (e.trans (congrArg (Occurrence.mk false) (next_rest m 1)))
    | .inr e => .inr (e.trans (congrArg (Occurrence.mk true) (open_rest hm)))
  | _, _, .inr rfl, r => .inr ((net_open r).trans (congrArg (Occurrence.mk true) (open_rest hm)))

theorem reach {m : Nat} (hm : 1 ≤ m) {x y : Occurrence} (hx : x = start m ∨ x = kept m)
    (h : «所及» (net m 1) alike x y) : y = start m ∨ y = kept m :=
  match h with
  | .inl e => Eq.subst (motive := fun z => z = start m ∨ z = kept m) e hx
  | .inr l => «闭之及» (fun a b ha c => closed hm a b ha c.1) hx l

theorem no_renewal {m : Nat} (hm : 1 ≤ m) {x z w : Occurrence} (hx : x = start m ∨ x = kept m)
    (hz : «所及» (net m 1) alike x z) : ¬ «传» (net m 1) alike sameLevel z w := fun ⟨⟨r, _⟩, b⟩ =>
  match closed hm z w (reach hm hx hz) r with
  | .inl e => not_begins_start m 1 (e ▸ b)
  | .inr e => not_begins_kept hm (e ▸ b)

theorem keeping {m : Nat} (hm : 1 ≤ m) {x : Occurrence} (hx : x = start m ∨ x = kept m) :
    «全守» (net m 1) alike sameLevel x :=
  ⟨fun y hy => match y, reach hm hx hy with
     | _, .inl rfl => ⟨start m, rest_step m 1, rfl⟩
     | _, .inr rfl => ⟨kept m, kept_kept hm, rfl⟩,
   x, .inl rfl, fun _ _ hz => no_renewal hm hx hz⟩

theorem not_generates {m : Nat} (hm : 1 ≤ m) {x : Occurrence} (hx : x = start m ∨ x = kept m) :
    ¬ «生成» (net m 1) alike sameLevel x := fun ⟨_, hs, _, ahead⟩ =>
  match ahead x hs with
  | ⟨_, _, _, _, hu, t⟩ => no_renewal hm hx hu t

theorem keeps_at {m : Nat} (hm : 1 ≤ m) : ∀ {x : Occurrence}, (x = start m ∨ x = kept m) →
    «守» (net m 1) alike sameLevel x
  | _, .inl rfl => ⟨fun y => y = start m, rfl,
      fun z hz => match z, hz with | _, rfl => ⟨start m, rfl, rest_step m 1, rfl⟩,
      fun _ _ hu _ t => no_renewal hm (.inl rfl)
        (Eq.subst (motive := fun z => «所及» (net m 1) alike (start m) z) hu.symm (.inl rfl)) t⟩
  | _, .inr rfl => ⟨fun y => y = kept m, rfl,
      fun z hz => match z, hz with | _, rfl => ⟨kept m, rfl, kept_kept hm, rfl⟩,
      fun _ _ hu _ t => no_renewal hm (.inr rfl)
        (Eq.subst (motive := fun z => «所及» (net m 1) alike (kept m) z) hu.symm (.inl rfl)) t⟩

/-- The rest of its rows: at both occurrences it keeps, and keeps from some point on, and is neither
生成 nor 全生成 nor 有终 nor 退化. -/
theorem rows {m : Nat} (hm : 1 ≤ m) :
    «守» (net m 1) alike sameLevel (start m) ∧ «守» (net m 1) alike sameLevel (kept m) ∧
      «后守» (net m 1) alike sameLevel (start m) ∧ «后守» (net m 1) alike sameLevel (kept m) ∧
      ¬ «生成» (net m 1) alike sameLevel (kept m) ∧
      ¬ «全生成» (net m 1) alike sameLevel (start m) ∧ ¬ «全生成» (net m 1) alike sameLevel (kept m) ∧
      ¬ «有终» (net m 1) alike (start m) ∧ ¬ «有终» (net m 1) alike (kept m) ∧
      ¬ «退化» (net m 1) alike (start m) ∧ ¬ «退化» (net m 1) alike (kept m) :=
  ⟨keeps_at hm (.inl rfl), keeps_at hm (.inr rfl),
   «守则后守» (keeps_at hm (.inl rfl)), «守则后守» (keeps_at hm (.inr rfl)),
   not_generates hm (.inr rfl),
   fun g => «全生成全守不并» ⟨g, keeping hm (.inl rfl)⟩,
   fun g => «全生成全守不并» ⟨g, keeping hm (.inr rfl)⟩,
   fun e => «全守有终不并» ⟨keeping hm (.inl rfl), e⟩, fun e => «全守有终不并» ⟨keeping hm (.inr rfl), e⟩,
   fun d => «守退化不并» ⟨keeps_at hm (.inl rfl), d⟩, fun d => «守退化不并» ⟨keeps_at hm (.inr rfl), d⟩⟩

end Matched

/-- **A heater giving exactly what the window draws keeps, in the strong form (给如所取则全守)**, at
every positive margin: before and after the window opens nothing renews at the level class. -/
theorem «给如所取则全守» {m : Nat} (hm : 1 ≤ m) :
    «全守» (net m 1) alike sameLevel (start m) ∧ «全守» (net m 1) alike sameLevel (Matched.kept m) ∧
      ¬ «生成» (net m 1) alike sameLevel (start m) :=
  ⟨Matched.keeping hm (.inl rfl), Matched.keeping hm (.inr rfl), Matched.not_generates hm (.inl rfl)⟩

/-! ## The overshooting thermostat (`c = 2`), at a margin of three -/

namespace Overshooting

def o4 : Occurrence := ⟨true, 4⟩
def o3 : Occurrence := ⟨true, 3⟩

theorem s3_o4 : net 3 2 (start 3) o4 := opens 3 2 (start 3)
theorem o4_o3 : net 3 2 o4 o3 := opens 3 2 o4
theorem o3_o4 : net 3 2 o3 o4 := opens 3 2 o3

theorem begins_o4 : «生» (net 3 2) sameLevel o4 := begins_open (by decide)
theorem begins_o3 : «生» (net 3 2) sameLevel o3 := begins_open (by decide)

/-- The three occurrences the overshooting thermostat reaches from its set level. -/
def Reached (y : Occurrence) : Prop := y = start 3 ∨ y = o4 ∨ y = o3

/-- What the overshooting thermostat reaches is closed under its net. -/
theorem closed : «闭» (net 3 2) Reached
  | _, _, .inl rfl, r => match net_shut r with
    | .inl e => .inl e
    | .inr e => .inr (.inl e)
  | _, _, .inr (.inl rfl), r => .inr (.inr (net_open r))
  | _, _, .inr (.inr rfl), r => .inr (.inl (net_open r))

theorem reach {x y : Occurrence} (hx : Reached x) (h : «所及» (net 3 2) alike x y) : Reached y :=
  match h with
  | .inl e => Eq.subst (motive := Reached) e hx
  | .inr l => «闭之及» (fun a b ha c => closed a b ha c.1) hx l

/-- From each occurrence reached, a carrying renewal to an occurrence reached. -/
theorem renews : ∀ {y : Occurrence}, Reached y → ∃ w, «传» (net 3 2) alike sameLevel y w ∧ Reached w
  | _, .inl rfl => ⟨o4, ⟨⟨s3_o4, rfl⟩, begins_o4⟩, .inr (.inl rfl)⟩
  | _, .inr (.inl rfl) => ⟨o3, ⟨⟨o4_o3, rfl⟩, begins_o3⟩, .inr (.inr rfl)⟩
  | _, .inr (.inr rfl) => ⟨o4, ⟨⟨o3_o4, rfl⟩, begins_o4⟩, .inr (.inl rfl)⟩

/-- **The opening is a carrying renewal, and so is every step after it; the shut step is not.** -/
theorem renewing_steps :
    «传» (net 3 2) alike sameLevel (start 3) o4 ∧ ¬ «传» (net 3 2) alike sameLevel (start 3) (start 3) ∧
      ∀ {y w : Occurrence}, (y = o4 ∨ y = o3) → net 3 2 y w → «传» (net 3 2) alike sameLevel y w :=
  ⟨⟨⟨s3_o4, rfl⟩, begins_o4⟩, fun t => not_begins_start 3 2 t.2,
   fun {_ w} hy r => match hy with
     | .inl e => by
         subst e
         have ew := net_open r
         subst ew
         exact ⟨⟨o4_o3, rfl⟩, begins_o3⟩
     | .inr e => by
         subst e
         have ew := net_open r
         subst ew
         exact ⟨⟨o3_o4, rfl⟩, begins_o4⟩⟩

theorem generation {x : Occurrence} (hx : Reached x) : «全生成» (net 3 2) alike sameLevel x :=
  ⟨fun _ hy => match renews (reach hx hy) with | ⟨w, t, _⟩ => ⟨w, t.1⟩,
   fun y hy => match renews (reach hx hy) with | ⟨w, t, _⟩ => ⟨y, w, .inl rfl, t⟩⟩

theorem generates {x : Occurrence} (hx : Reached x) : «生成» (net 3 2) alike sameLevel x :=
  ⟨Reached, hx,
   fun _ hz => match renews hz with | ⟨w, t, hw⟩ => ⟨w, hw, t.1⟩,
   fun z hz => match renews hz with | ⟨w, t, hw⟩ => ⟨z, w, hz, hw, .inl rfl, t⟩⟩

theorem keeps : «守» (net 3 2) alike sameLevel (start 3) :=
  ⟨fun y => y = start 3, rfl,
   fun z hz => match z, hz with | _, rfl => ⟨start 3, rfl, rest_step 3 2, rfl⟩,
   fun u v hu hv t => by subst hu; subst hv; exact not_begins_start 3 2 t.2⟩

/-- In the strong form, before and after the window opens. -/
theorem generation_strong :
    «全生成» (net 3 2) alike sameLevel (start 3) ∧ «全生成» (net 3 2) alike sameLevel o4 ∧
      «全生成» (net 3 2) alike sameLevel o3 :=
  ⟨generation (.inl rfl), generation (.inr (.inl rfl)), generation (.inr (.inr rfl))⟩

/-- The open window's net is a single line. -/
theorem openNet_single {m c : Nat} :
    ∀ {z w w' : Occurrence}, openNet m c z w → openNet m c z w' → w = w'
  | ⟨true, _⟩, _, _, ⟨_, r⟩, ⟨_, r'⟩ => (net_open r).trans (net_open r').symm
  | ⟨false, _⟩, _, _, ⟨h, _⟩, _ => Bool.noConfusion h

theorem begins_open_line {y : Occurrence} (b : «生» (net 3 2) sameLevel y) :
    «生» (openNet 3 2) sameLevel y :=
  fun ⟨x, r, same⟩ => b ⟨x, r.2, same⟩

theorem generates_open : «生成» (openNet 3 2) alike sameLevel o4 :=
  ⟨fun y => y = o4 ∨ y = o3, .inl rfl,
   fun z hz => match z, hz with
     | _, .inl rfl => ⟨o3, .inr rfl, ⟨rfl, o4_o3⟩, rfl⟩
     | _, .inr rfl => ⟨o4, .inl rfl, ⟨rfl, o3_o4⟩, rfl⟩,
   fun z hz => match z, hz with
     | _, .inl rfl => ⟨o4, o3, .inl rfl, .inr rfl, .inl rfl, ⟨⟨rfl, o4_o3⟩, rfl⟩,
         begins_open_line begins_o3⟩
     | _, .inr rfl => ⟨o3, o4, .inr rfl, .inl rfl, .inl rfl, ⟨⟨rfl, o3_o4⟩, rfl⟩,
         begins_open_line begins_o4⟩⟩

/-- **The single-line law, tested both ways.** Where the window is open, the net is a single line,
and the overshooting thermostat generating there does not keep from some point on
(`«单行则生成后守不并»`). At its set level the net branches, and it generates and keeps from some
point on together: the condition is needed. -/
theorem single_line_tested :
    ¬ «后守» (openNet 3 2) alike sameLevel o4 ∧
      (¬ ∀ {z w w' : Occurrence}, net 3 2 z w → net 3 2 z w' → w = w') ∧
      «生成» (net 3 2) alike sameLevel (start 3) ∧ «后守» (net 3 2) alike sameLevel (start 3) :=
  ⟨fun k => «单行则生成后守不并» (R := openNet 3 2) (L := alike) (E := sameLevel)
     (fun h h' => openNet_single h h') ⟨generates_open, k⟩,
   fun single => Bool.noConfusion (congrArg Occurrence.opened (single (rest_step 3 2) s3_o4)),
   generates (.inl rfl), «守则后守» keeps⟩

/-- The open occurrences the overshooting thermostat reaches after the window opens, `o4` and `o3`,
are closed under its net. -/
theorem closed_open : «闭» (net 3 2) (fun y => y = o4 ∨ y = o3)
  | _, _, .inl rfl, r => .inr (net_open r)
  | _, _, .inr rfl, r => .inl (net_open r)

/-- **After the window opens the overshooting thermostat does not keep from some point on**, on the
net itself: every step of its line is a carrying renewal. -/
theorem not_keepsAfter_open {x : Occurrence} (hx : x = o4 ∨ x = o3) :
    ¬ «后守» (net 3 2) alike sameLevel x :=
  fun ⟨S, _, closedS, z, hz, sz, quiet⟩ =>
    have open_z : z = o4 ∨ z = o3 := match hz with
      | .inl e => Eq.subst (motive := fun y => y = o4 ∨ y = o3) e hx
      | .inr l => «闭之及» (fun a b ha c => closed_open a b ha c.1) hx l
    match closedS z sz with
    | ⟨w, sw, r, a⟩ => match open_z with
      | .inl e => by
          subst e
          have ew := net_open r
          subst ew
          exact quiet o4 o3 sz sw (.inl rfl) ⟨⟨r, a⟩, begins_o3⟩
      | .inr e => by
          subst e
          have ew := net_open r
          subst ew
          exact quiet o3 o4 sz sw (.inl rfl) ⟨⟨r, a⟩, begins_o4⟩

/-- The rest of its rows: at the set level neither 全守 nor 有终 nor 退化; after opening it generates,
and neither keeps, nor keeps from some point on, nor degenerates, nor is 全守 or 有终. -/
theorem rows :
    ¬ «全守» (net 3 2) alike sameLevel (start 3) ∧ ¬ «有终» (net 3 2) alike (start 3) ∧
      ¬ «退化» (net 3 2) alike (start 3) ∧
      ∀ {x : Occurrence}, (x = o4 ∨ x = o3) →
        «生成» (net 3 2) alike sameLevel x ∧ ¬ «守» (net 3 2) alike sameLevel x ∧
          ¬ «后守» (net 3 2) alike sameLevel x ∧ ¬ «退化» (net 3 2) alike x ∧
          ¬ «全守» (net 3 2) alike sameLevel x ∧ ¬ «有终» (net 3 2) alike x :=
  ⟨fun k => «全生成全守不并» ⟨generation (.inl rfl), k⟩,
   fun e => «全生成有终不并» ⟨generation (.inl rfl), e⟩,
   fun d => «生成退化不并» ⟨generates (.inl rfl), d⟩,
   fun {x} hx =>
     have reached : Reached x := match hx with
       | .inl e => .inr (.inl e)
       | .inr e => .inr (.inr e)
     ⟨generates reached, fun k => not_keepsAfter_open hx («守则后守» k), not_keepsAfter_open hx,
      fun d => «生成退化不并» ⟨generates reached, d⟩, fun k => «全生成全守不并» ⟨generation reached, k⟩,
      fun e => «全生成有终不并» ⟨generation reached, e⟩⟩⟩

end Overshooting

/-- **Where the heater gives more than the window takes, the room at its set level generates and
keeps (给过所取则生守相杂)**: the overshooting thermostat, at a margin of three. Along the window's
branch the heater renews the level at every step, and along the shut branch it rests. A model case
of `Map.«生守相杂»`, where a stipulated fork's root generates along its chain and keeps along its
still occurrence: here the fork is the rule's, the window's branch is the chain and the shut branch
the still occurrence, read at warm or not and the level rather than at the one and equality. It is
stronger: at its set level the overshooting thermostat is 全生成, a renewal ahead of every
occurrence it reaches (`Overshooting.generation_strong`). -/
theorem «给过所取则生守相杂» :
    «生成» (net 3 2) alike sameLevel (start 3) ∧ «守» (net 3 2) alike sameLevel (start 3) :=
  ⟨Overshooting.generates (.inl rfl), Overshooting.keeps⟩

/-! ## Rest, at every margin -/

theorem shut_rest_step (m c : Nat) : shut m c (start m) (start m) := ⟨rfl, rfl, (next_rest m c).symm⟩

/-- **While no window opens, every room at its set level rests in the strong form (全守)**, whatever
its heater: a law of the shut net. With `«给如所取则全守»`, the matched thermostat's 全守 on the
full net, rest and that heater's regulation lie in one region of the map. -/
theorem shut_rests (m c : Nat) : «全守» (shut m c) alike sameLevel (start m) :=
  have closed : «闭» («续» (shut m c) alike) (fun y => y = start m) :=
    fun _ _ hx s => by subst hx; exact shut_start s.1
  have only : ∀ {y}, «所及» (shut m c) alike (start m) y → y = start m := fun h => match h with
    | .inl e => e.symm
    | .inr l => «闭之及» closed rfl l
  ⟨fun _ hy => Eq.subst (motive := «有后» (shut m c) alike) (only hy).symm
     ⟨start m, shut_rest_step m c, rfl⟩,
   start m, .inl rfl, fun z w hz ⟨⟨r, _⟩, b⟩ => by
     have ez := only hz
     subst ez
     have ew := shut_start r
     subst ew
     exact b ⟨start m, shut_rest_step m c, rfl⟩⟩

/-- **Once cold, the unheated room keeps its coldness in the strong form**: its open occurrence at
`0` is 全守, read at the other class of warm or not. -/
theorem cold_rests (m : Nat) : «全守» (net m 0) alike sameLevel ⟨true, 0⟩ :=
  have self : net m 0 ⟨true, 0⟩ ⟨true, 0⟩ := ⟨.inr rfl, (next_zero m 0 0).symm⟩
  have closed : «闭» («续» (net m 0) alike) (fun y => y = ⟨true, 0⟩) :=
    fun _ _ hx s => by subst hx; exact cold_step s.1
  have only : ∀ {y}, «所及» (net m 0) alike ⟨true, 0⟩ y → y = ⟨true, 0⟩ := fun h => match h with
    | .inl e => e.symm
    | .inr l => «闭之及» closed rfl l
  ⟨fun _ hy => Eq.subst (motive := «有后» (net m 0) alike) (only hy).symm ⟨⟨true, 0⟩, self, rfl⟩,
   ⟨true, 0⟩, .inl rfl, fun z w hz ⟨⟨r, _⟩, b⟩ => by
     have ez := only hz
     subst ez
     have ew := cold_step r
     subst ew
     exact b ⟨⟨true, 0⟩, self, rfl⟩⟩

/-! ## A conditional law on the family -/

/-- **Warmth is a constant class under the net exactly where the heater gives
(温有常当且仅当有给)**, at every positive set level. -/
theorem «温有常当且仅当有给» (m c : Nat) (hm : 1 ≤ m) : «有常» (net m c) alike ↔ 1 ≤ c := by
  constructor
  · intro h
    cases c with
    | zero => exact absurd h («有亡之续则不有常» ⟨cools m true 1, rfl⟩ (cold_after m))
    | succ k => exact Nat.succ_le_succ (Nat.zero_le k)
  · intro hc
    exact («有常之逐点» (net m c) alike).mpr fun _ u' _ _ r =>
      ⟨⟨true, next m c 0 u'.level⟩, opens m c u',
       (heated_warm hm hc r).trans (heated_warm hm hc (opens m c u')).symm⟩

/-- **Within one room with a positive set level, warmth lies in its own core exactly where the
heater gives**: the constancy law read as a law of the core (`«类有常当且仅当含于核»`). -/
theorem alike_in_core_iff (m c : Nat) (hm : 1 ≤ m) :
    «则» alike («核» (net m c) alike) ↔ 1 ≤ c :=
  («类有常当且仅当含于核» (net m c) alike_class).symm.trans («温有常当且仅当有给» m c hm)

/-- An unheated room's open occurrences at `1` and above reach the last warm one, at `1`, along
warmth's line. -/
theorem cools_to (m : Nat) : ∀ j, «所及» (net m 0) alike ⟨true, j + 1⟩ ⟨true, 1⟩
  | 0 => .inl rfl
  | j + 1 => «所及之传递» (.inr (.one ⟨cools m true (j + 1), rfl⟩)) (cools_to m j)

/-- **From a margin of two draws on, no line of warmth from the set level ends exactly where the
heater gives (温不穷当且仅当有给)**: by `«有常则往不穷»` where it gives, and by the window's branch
where it does not. -/
theorem «温不穷当且仅当有给» (m c : Nat) (hm : 2 ≤ m) : «不穷» (net m c) alike (start m) ↔ 1 ≤ c := by
  constructor
  · intro h
    cases c with
    | zero =>
      cases m with
      | zero => exact absurd hm (by decide)
      | succ n =>
        cases n with
        | zero => exact absurd hm (by decide)
        | succ j =>
          exact absurd (h ⟨true, 1⟩ («所及之传递» (.inr (.one ⟨cools (j + 2) false (j + 1), rfl⟩))
            (cools_to (j + 2) j))) (cold_after (j + 2))
    | succ k => exact Nat.succ_le_succ (Nat.zero_le k)
  · intro hc
    exact «有常则往不穷» ((«温有常当且仅当有给» m c (Nat.le_trans (by decide) hm)).mpr hc)
      ⟨start m, rest_step m c, rfl⟩

/-- **In a heated room no line of warmth from the set level ends, and none reaches an end**, at every
positive margin: Y of `«有常则往不穷»` where its Z holds, and so the Z of `«有终则粗不有常»` fails. -/
theorem heated_unended {m c : Nat} (hm : 1 ≤ m) (hc : 1 ≤ c) :
    «不穷» (net m c) alike (start m) ∧ ¬ «有终» (net m c) alike (start m) :=
  have unended : «不穷» (net m c) alike (start m) :=
    «有常则往不穷» ((«温有常当且仅当有给» m c hm).mpr hc) ⟨start m, rest_step m c, rfl⟩
  ⟨unended, fun ⟨y, hy, ends⟩ => ends (unended y hy)⟩

/-- **At a margin of one draw no line of warmth from the set level ends, heater or not**: the
window's draw takes an unheated room out of warmth in a single step, so no warm occurrence is the
last of warmth's line. The margin of two in `«温不穷当且仅当有给»` is needed. -/
theorem unended_at_one (c : Nat) : «不穷» (net 1 c) alike (start 1) := by
  cases c with
  | zero =>
    have closed : «闭» («续» (net 1 0) alike) (fun y => y = start 1) := fun _ _ hx ⟨r, a⟩ => by
      subst hx
      cases net_shut r with
      | inl e => exact e
      | inr e => subst e; exact Bool.noConfusion a
    exact fun y hy => Eq.subst (motive := fun z => «有后» (net 1 0) alike z)
      (match hy with
        | .inl e => e
        | .inr l => («闭之及» closed rfl l).symm)
      ⟨start 1, rest_step 1 0, rfl⟩
  | succ k =>
    exact «有常则往不穷» ((«温有常当且仅当有给» 1 (k + 1) (Nat.le_refl 1)).mpr
      (Nat.succ_le_succ (Nat.zero_le k))) ⟨start 1, rest_step 1 (k + 1), rfl⟩

/-! ## Testing: rooms side by side -/

/-- Rooms side by side: an occurrence tagged with its heater's `c`, a term of its room's rule that
no class reads. -/
abbrev Tagged : Type := Nat × Occurrence

/-- Every room at the set level `m` with the window's opening in the net; a step keeps the tag. -/
def joint (m : Nat) : «际» Tagged := fun x y => x.1 = y.1 ∧ net m x.1 x.2 y.2

/-- Every room at the set level `m` with its window shut. -/
def jointShut (m : Nat) : «际» Tagged := fun x y => x.1 = y.1 ∧ shut m x.1 x.2 y.2

/-- The level class, whatever the room. -/
def jointLevel : «际» Tagged := fun x y => sameLevel x.2 y.2

/-- Warm or not, whatever the room. -/
def jointAlike : «际» Tagged := fun x y => alike x.2 y.2

/-- **While no window opens, every room at its set level is one core class at the level class,
whatever its heater (不开窗则同核).** -/
theorem «不开窗则同核» (m c c' : Nat) : «核» (jointShut m) jointLevel (c, start m) (c', start m) :=
  ⟨fun x y => x.2 = start m ∧ y.2 = start m,
   fun _ _ ⟨hx, hy⟩ => (congrArg Occurrence.level hx).trans (congrArg Occurrence.level hy).symm,
   fun _ _ ⟨hx, hy⟩ => ⟨hy, hx⟩,
   («有常之逐点» (jointShut m) _).mpr fun u u' ⟨hu, hu'⟩ v ⟨_, r⟩ => by
     obtain ⟨c₁, w⟩ := u'
     cases hu'
     exact ⟨(c₁, start m), ⟨rfl, rfl, rfl, (next_rest m c₁).symm⟩, shut_start (hu ▸ r), rfl⟩,
   rfl, rfl⟩

/-- So, by `«核之单调»`, while no window opens warm or not tells no two rooms at their set level
apart either. -/
theorem shut_one_class_alike (m c c' : Nat) :
    «核» (jointShut m) jointAlike (c, start m) (c', start m) :=
  «核之单调» (jointShut m) (fun _ _ h => warm_of_level h) _ _ («不开窗则同核» m c c')

/-- **With the window in the net, the first stage of the level tells the unheated room from every
heated one (开窗则一层可分)**, at every positive set level. -/
theorem «开窗则一层可分» {m c : Nat} (hm : 1 ≤ m) (hc : 1 ≤ c) :
    ¬ «层» (joint m) jointLevel 1 (0, start m) (c, start m) ∧
      ¬ «核» (joint m) jointLevel (0, start m) (c, start m) := by
  cases m with
  | zero => exact absurd hm (by decide)
  | succ n =>
    have stage : ¬ «层» (joint (n + 1)) jointLevel 1 (0, start (n + 1)) (c, start (n + 1)) :=
      fun ⟨_, forth, _⟩ => match forth (0, ⟨true, n⟩) ⟨rfl, cools (n + 1) false n⟩ with
      | ⟨(_, y), ⟨_, r⟩, same⟩ => match net_shut r with
        | .inl e => Nat.ne_of_lt (Nat.lt_succ_self n)
            ((same.trans (congrArg Occurrence.level e)).trans (next_rest (n + 1) c))
        | .inr e => Nat.ne_of_lt (Nat.add_lt_add_left hc n)
            ((same.trans (congrArg Occurrence.level e)).trans (warms_open n c))
    exact ⟨stage, «可分则不在核» ⟨1, stage⟩⟩

/-- At a margin of three the two heaters are told apart by the first stage of the level too. -/
theorem heaters_told_apart : ¬ «层» (joint 3) jointLevel 1 (2, start 3) (1, start 3) :=
  fun ⟨_, forth, _⟩ =>
  match forth (2, Overshooting.o4) ⟨rfl, Overshooting.s3_o4⟩ with
  | ⟨(_, y), ⟨_, r⟩, same⟩ => match net_shut r with
    | .inl e => absurd (show (4 : Nat) = 3 from same.trans (congrArg Occurrence.level e)) (by decide)
    | .inr e => absurd (show (4 : Nat) = 3 from same.trans (congrArg Occurrence.level e)) (by decide)

/-- An unheated room's step loses at most one unit. -/
theorem unheated_step {m : Nat} {x y : Occurrence} (r : net m 0 x y) : x.level - 1 ≤ y.level :=
  Eq.subst (motive := fun v => x.level - 1 ≤ v)
    (r.2.trans (next_zero m (surroundings m y.opened) x.level)).symm
    (exchange_ge (surroundings m y.opened) x.level)

/-- **Warm or not does not tell an unheated room from a heated one while the unheated room's level
lasts**: at stage `k`, an unheated occurrence above `k` and a warm occurrence of a heated room are
alike. -/
theorem lasts {m c : Nat} (hm : 1 ≤ m) (hc : 1 ≤ c) :
    ∀ (k : Nat) {a b : Occurrence}, k + 1 ≤ a.level → warm b = true →
      «层» (joint m) jointAlike k (0, a) (c, b)
  | 0, _, _, la, wb => (warm_of_pos la).trans wb.symm
  | k + 1, a, b, la, wb =>
    ⟨lasts hm hc k (Nat.le_of_succ_le la) wb,
     fun v ⟨ev, r⟩ => by
       obtain ⟨c₀, a'⟩ := v
       cases ev
       exact ⟨(c, ⟨true, next m c 0 b.level⟩), ⟨rfl, opens m c b⟩,
         lasts hm hc k (Nat.le_trans (Nat.pred_le_pred la) (unheated_step r))
           (heated_warm hm hc (opens m c b))⟩,
     fun v' ⟨ev', r'⟩ => by
       obtain ⟨c₁, b'⟩ := v'
       cases ev'
       exact ⟨(0, ⟨true, next m 0 0 a.level⟩), ⟨rfl, opens m 0 a⟩,
         lasts hm hc k (Nat.le_trans (Nat.pred_le_pred la) (unheated_step (opens m 0 a)))
           (heated_warm hm hc r')⟩⟩

/-- **An unheated room open at `j` is told from every warm occurrence of a heated room at stage
`j`**: the open window empties it in `j` draws, while every step of a heated room is warm. -/
theorem empties {m c : Nat} (hm : 1 ≤ m) (hc : 1 ≤ c) :
    ∀ (j : Nat) {b : Occurrence}, warm b = true → ¬ «层» (joint m) jointAlike j (0, ⟨true, j⟩) (c, b)
  | 0, _, wb, same => Bool.noConfusion (same.trans wb)
  | j + 1, _, _, ⟨_, forth, _⟩ => match forth (0, ⟨true, j⟩) ⟨rfl, cools m true j⟩ with
    | ⟨(c', b'), ⟨e, r⟩, stage⟩ => by
        cases e
        exact empties hm hc j (heated_warm hm hc r) stage

/-- **Under warm or not, the window first tells the unheated room from a heated one at the stage of
its margin (开窗以温层如其余乃分)**: at a margin of `n + 1` draws of one, stage `n` holds and stage
`n + 1` tells them apart. The open window takes the margin's draws to empty the unheated room's
warmth, and the stage counts them; at a margin of three, the stage is three. -/
theorem «开窗以温层如其余乃分» {n c : Nat} (hc : 1 ≤ c) :
    «层» (joint (n + 1)) jointAlike n (0, start (n + 1)) (c, start (n + 1)) ∧
      ¬ «层» (joint (n + 1)) jointAlike (n + 1) (0, start (n + 1)) (c, start (n + 1)) :=
  ⟨lasts (Nat.succ_le_succ (Nat.zero_le n)) hc n (Nat.le_refl _) rfl,
   fun ⟨_, forth, _⟩ => match forth (0, ⟨true, n⟩) ⟨rfl, cools (n + 1) false n⟩ with
    | ⟨(c', b'), ⟨e, r⟩, stage⟩ => by
        cases e
        exact empties (Nat.succ_le_succ (Nat.zero_le n)) hc n
          (heated_warm (Nat.succ_le_succ (Nat.zero_le n)) hc r) stage⟩

/-- **Warm or not does not tell two rooms with a heater apart (有给之室以温不可分)**, at every
positive set level. -/
theorem «有给之室以温不可分» {m c c' : Nat} (hm : 1 ≤ m) (hc : 1 ≤ c) (hc' : 1 ≤ c') :
    «核» (joint m) jointAlike (c, start m) (c', start m) :=
  ⟨fun x y => 1 ≤ x.1 ∧ 1 ≤ y.1 ∧ warm x.2 = true ∧ warm y.2 = true,
   fun _ _ ⟨_, _, wx, wy⟩ => wx.trans wy.symm,
   fun _ _ ⟨a, b, wx, wy⟩ => ⟨b, a, wy, wx⟩,
   («有常之逐点» (joint m) _).mpr fun _ u' ⟨hu, hu', _, _⟩ _ ⟨e, r⟩ =>
     ⟨(u'.1, ⟨true, next m u'.1 0 u'.2.level⟩), ⟨rfl, opens m u'.1 u'.2⟩,
      e ▸ hu, hu', heated_warm hm hu r, heated_warm hm hu' (opens m u'.1 u'.2)⟩,
   hc, hc', warm_of_pos (x := start m) hm, warm_of_pos (x := start m) hm⟩

/-! ## The converse across rooms -/

/-- **Across rooms the converse of `«有常则往不穷»` fails**: beside the unheated room warmth is not
a constant class under the joint net, and still no line of warmth from a heated room's set level
ends. -/
theorem joint_converse {m c : Nat} (hm : 1 ≤ m) (hc : 1 ≤ c) :
    ¬ «有常» (joint m) jointAlike ∧ «不穷» (joint m) jointAlike (c, start m) :=
  have closed : «闭» («续» (joint m) jointAlike) (fun z => 1 ≤ z.1 ∧ warm z.2 = true) :=
    fun _ _ ⟨hz, _⟩ ⟨⟨e, r⟩, _⟩ => ⟨e ▸ hz, heated_warm hm hz r⟩
  ⟨«有亡之续则不有常» (x := (0, ⟨true, 2⟩)) (y := (0, ⟨true, 1⟩)) ⟨⟨rfl, cools m true 1⟩, rfl⟩
     fun ⟨(_, y), ⟨_, r⟩, a⟩ => cold_after m ⟨y, r, a⟩,
   fun y hy =>
     have py : 1 ≤ y.1 ∧ warm y.2 = true := match hy with
       | .inl e => Eq.subst (motive := fun z => 1 ≤ z.1 ∧ warm z.2 = true) e
           ⟨hc, warm_of_pos (x := start m) hm⟩
       | .inr l => «闭之及» closed ⟨hc, warm_of_pos (x := start m) hm⟩ l
     ⟨(y.1, ⟨true, next m y.1 0 y.2.level⟩), ⟨rfl, opens m y.1 y.2⟩,
      py.2.trans (heated_warm hm py.1 (opens m y.1 y.2)).symm⟩⟩

/-! ## A heater that reads before the exchange -/

/-- The rule with the heater reading the level before the exchange instead of after it. -/
def nextBefore (m c σ x : Nat) : Nat := exchange σ x + heater m c x

/-- **Read before the exchange, the window moves a heated room's level**: at a margin of three, from
the set level, the matched heater settles one below it (`3, 2, 2, …`) and the overshooting one
alternates `2` and `3`. Read after it, the heater answers the draw within the step
(`Matched.window_held`, `Overshooting.alternates`). -/
theorem before_window_moves :
    nextBefore 3 1 0 3 = 2 ∧ nextBefore 3 1 0 2 = 2 ∧ nextBefore 3 2 0 3 = 2 ∧
      nextBefore 3 2 0 2 = 3 :=
  ⟨rfl, rfl, rfl, rfl⟩

/-- **Read either way, from a margin of two draws on, every step of a heated room lands warm**
(read after the exchange: `next_pos`). -/
theorem before_pos {m c : Nat} (hm : 2 ≤ m) (hc : 1 ≤ c) (σ x : Nat) : 0 < nextBefore m c σ x :=
  match Nat.lt_or_ge x m with
  | .inl h =>
    Nat.lt_of_lt_of_le hc
      (Eq.subst (motive := fun v => v ≤ nextBefore m c σ x) (if_pos h : heater m c x = c)
        (Nat.le_add_left (heater m c x) (exchange σ x)))
  | .inr h =>
    Nat.lt_of_lt_of_le
      (Nat.lt_of_lt_of_le (Nat.sub_le_sub_right (Nat.le_trans hm h) 1 : 1 ≤ x - 1) (exchange_ge σ x))
      (Nat.le_add_right (exchange σ x) (heater m c x))

/-- At a margin of one, read before the exchange, the open window takes a heated room out of
warmth: at its set level the heater reads no shortfall. -/
theorem before_at_one (c : Nat) : nextBefore 1 c 0 1 = 0 := rfl

/-- Without a heater the two readings are one rule. -/
theorem before_unheated (m σ x : Nat) : nextBefore m 0 σ x = next m 0 σ x :=
  (congrArg (exchange σ x + ·) (heater_zero m x)).trans
    (congrArg (exchange σ x + ·) (heater_zero m (exchange σ x))).symm

/-! ## The toy derived: `«恒温与平衡»` at a margin of one draw -/

/-- `Becoming.GrammarTesting`'s four rooms as the rule's occurrences at a margin of one draw: the
balanced room is the unheated room at its set level, the held room the matched thermostat there,
the cold room the unheated room once its window has opened, the kept room the matched thermostat
once its window has opened. -/
def toy : Room → Tagged
  | .balanced => (0, start 1)
  | .held => (1, start 1)
  | .cold => (0, ⟨true, 0⟩)
  | .kept => (1, ⟨true, 1⟩)

/-- **The toy's stipulated branches are the rule's at a margin of one draw.** Each branch the toy
stipulates, with the window or shut, is a step of the rule; from the balanced and the held room
each step of the rule is one the toy stipulates; and the toy's warmth is the rule's. The toy stops
at the cold and the kept room, where the rule goes on; a first stage does not read past them. -/
theorem toy_branches :
    (∀ x y, Room.opened x y → joint 1 (toy x) (toy y)) ∧
      (∀ x y, Room.closed x y → jointShut 1 (toy x) (toy y)) ∧
      (∀ x, (x = .balanced ∨ x = .held) → ∀ w, joint 1 (toy x) w →
        ∃ y, Room.opened x y ∧ w = toy y) ∧
      (∀ x, (x = .balanced ∨ x = .held) → ∀ w, jointShut 1 (toy x) w →
        ∃ y, Room.closed x y ∧ w = toy y) ∧
      ∀ x, warm (toy x).2 = Room.warm x := by
  refine ⟨fun x y h => ?_, fun x y h => ?_, fun x hx w r => ?_, fun x hx w r => ?_, fun x => ?_⟩
  · cases x <;> cases y
    all_goals first | exact False.elim h | exact ⟨rfl, .inl rfl, rfl⟩
  · cases x <;> cases y
    all_goals first | exact False.elim h | exact ⟨rfl, rfl, rfl, rfl⟩
  · obtain ⟨c₀, a⟩ := w
    obtain ⟨e, r⟩ := r
    cases hx with
    | inl hx =>
      subst hx
      have e' : 0 = c₀ := e
      have r' : net 1 0 ⟨false, 1⟩ a := r
      subst e'
      cases net_shut r' with
      | inl ea => exact ⟨.balanced, trivial, by subst ea; rfl⟩
      | inr ea => exact ⟨.cold, trivial, by subst ea; rfl⟩
    | inr hx =>
      subst hx
      have e' : 1 = c₀ := e
      have r' : net 1 1 ⟨false, 1⟩ a := r
      subst e'
      cases net_shut r' with
      | inl ea => exact ⟨.held, trivial, by subst ea; rfl⟩
      | inr ea => exact ⟨.kept, trivial, by subst ea; rfl⟩
  · obtain ⟨c₀, a⟩ := w
    obtain ⟨e, r⟩ := r
    cases hx with
    | inl hx =>
      subst hx
      have e' : 0 = c₀ := e
      have r' : shut 1 0 (start 1) a := r
      subst e'
      exact ⟨.balanced, trivial, by rw [shut_start r']; rfl⟩
    | inr hx =>
      subst hx
      have e' : 1 = c₀ := e
      have r' : shut 1 1 (start 1) a := r
      subst e'
      exact ⟨.held, trivial, by rw [shut_start r']; rfl⟩
  · cases x <;> rfl

/-- **The toy's verdict is the rule's at a margin of one draw**: the toy's first stage tells the
balanced room from the held one because the rule's first stage tells the unheated room from the
heated one at that margin (`«开窗以温层如其余乃分»`, `n = 0`), and so the toy's rooms are not in one
core class (the second half of `«恒温与平衡»`, here derived). -/
theorem toy_verdict :
    ¬ «层» Room.opened Room.alike 1 Room.balanced Room.held ∧
      ¬ «核» Room.opened Room.alike Room.balanced Room.held :=
  have stage : ¬ «层» Room.opened Room.alike 1 Room.balanced Room.held :=
    match toy_branches with
    | ⟨sound, _, complete, _, warmth⟩ => fun ⟨_, forth, back⟩ =>
      («开窗以温层如其余乃分» (n := 0) (c := 1) (Nat.le_refl 1)).2
        ⟨rfl,
         fun w r => match complete .balanced (.inl rfl) w r with
           | ⟨y, hy, e⟩ => match forth y hy with
             | ⟨y', hy', a⟩ => ⟨toy y', sound _ _ hy',
                 Eq.subst (motive := fun v => jointAlike v (toy y')) e.symm
                   ((warmth y).trans (a.trans (warmth y').symm))⟩,
         fun w' r' => match complete .held (.inr rfl) w' r' with
           | ⟨y', hy', e⟩ => match back y' hy' with
             | ⟨y, hy, a⟩ => ⟨toy y, sound _ _ hy,
                 Eq.subst (motive := fun v => jointAlike (toy y) v) e.symm
                   ((warmth y).trans (a.trans (warmth y').symm))⟩⟩
  ⟨stage, «可分则不在核» ⟨1, stage⟩⟩

end Rooms

end Becoming
