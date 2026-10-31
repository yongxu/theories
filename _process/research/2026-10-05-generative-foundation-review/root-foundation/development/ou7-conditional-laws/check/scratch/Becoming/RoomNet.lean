import Becoming.GrammarTesting
import Becoming.GrammarLaws
import Becoming.GrammarReadings
import Becoming.MapRegions

/-!
# Two rooms on the net of the possible: testing (验) by a window

Scratch module for board item OU5, part B (`ou5-conditional-laws/check/DESIGN.md`). One rule makes
the nets of three rooms. A room has a level; its surroundings are at `3` while its window is shut and
at `0` once it opens. Each step it exchanges one unit toward them, and a heater, reading what is
left, gives `c` where that is below its set point `3`. The unheated room (`c = 0`) is in balance with
its surroundings; the thermostat is `c = 2`; `c = 1` gives exactly what the open window draws. The
window's opening is in the net (`net`): the successors of an occurrence are alternatives, the
possible-net reading. `shut` is the net without it.

* **Regions** (at warm or not, and the same level): the thermostat at its set point is 全生成 and 守,
  the mixed region, from a rule (`«恒温生守相杂»`); the unheated room keeps and reaches an end, and
  after the window opens degenerates while renewing (`«平衡守而有终»`, `«开窗则平衡新而尽»`); the
  `c = 1` room is 全守, rest's region (`«给如所取则全守»`).
* **Testing.** Without the window every room at its set point is one core class at the finest
  class (`«不开窗则同核»`); with it the first stage of the level tells the unheated room from every
  heated one (`«开窗则一层可分»`), and warm or not needs exactly the third (`«开窗以温三层乃分»`);
  warmth does not tell two heated rooms apart (`«二恒温以温不可分»`).
* **A conditional law.** Warmth is a constant class under the net exactly where the heater gives
  (`«温有常当且仅当有给»`), and then it never ends along any branch (`«温不穷当且仅当有给»`, by
  `«有常则往不穷»`).

Every declaration has an empty axiom report.
-/

namespace Becoming

namespace Rooms

/-! ## The rule and the nets -/

/-- An occurrence of a room: whether its window is open, and its level, in whole units of heat. -/
structure At where
  opened : Bool
  level : Nat

/-- The surroundings' level: `3` while the window is shut, `0` once it is open. -/
def outside (opened : Bool) : Nat := cond opened 0 3

/-- The exchange with surroundings at `σ`: one unit toward them. -/
def exchange (σ x : Nat) : Nat := if x < σ then x + 1 else if σ < x then x - 1 else x

/-- The heater: reading the level `z` left after the exchange, it gives `c` where `z` is below its
set point `3`, and nothing otherwise. -/
def heater (c z : Nat) : Nat := if z < 3 then c else 0

/-- The rule: the exchange with the surroundings, then the heater's giving. -/
def next (c σ x : Nat) : Nat := exchange σ x + heater c (exchange σ x)

/-- While the window stays shut: the room exchanges with surroundings at `3`. -/
def shut (c : Nat) : «际» At := fun x y =>
  x.opened = false ∧ y.opened = false ∧ y.level = next c 3 x.level

/-- With the window's opening in the net: a shut room may stay shut or open its window, an open
window stays open, and each step exchanges with the surroundings the window leaves. -/
def net (c : Nat) : «际» At := fun x y =>
  (x.opened = false ∨ y.opened = true) ∧ y.level = next c (outside y.opened) x.level

/-- The window open: the net from open occurrences only. -/
def openNet (c : Nat) : «际» At := fun x y => x.opened = true ∧ net c x y

/-- The fine class: the same level. -/
def sameLevel : «际» At := fun x y => x.level = y.level

/-- Whether a room is warm: above the open surroundings' level. -/
def warm (x : At) : Bool :=
  match x.level with
  | 0 => false
  | _ + 1 => true

/-- The coarse class: warm or not. -/
def alike : «际» At := fun x y => warm x = warm y

/-- The set point, the window shut. -/
def s3 : At := ⟨false, 3⟩

theorem alike_class : «类» alike := ⟨fun _ => rfl, fun h => h.symm, fun h₁ h₂ => h₁.trans h₂⟩

/-- A shut room at its set point stays at it. -/
theorem stays_shut (c l : Nat) : net c ⟨false, l⟩ ⟨false, next c 3 l⟩ := ⟨.inl rfl, rfl⟩

/-- Any room can open its window, or keep it open. -/
theorem opens (c : Nat) (x : At) : net c x ⟨true, next c 0 x.level⟩ := ⟨.inr rfl, rfl⟩

/-- An open window stays open, by the open rule. -/
theorem net_open {c l : Nat} : ∀ {y : At}, net c ⟨true, l⟩ y → y = ⟨true, next c 0 l⟩
  | ⟨true, _⟩, ⟨_, e⟩ => congrArg (At.mk true) e
  | ⟨false, _⟩, ⟨.inl h, _⟩ => Bool.noConfusion h
  | ⟨false, _⟩, ⟨.inr h, _⟩ => Bool.noConfusion h

/-- A shut room stays shut or opens its window. -/
theorem net_shut {c l : Nat} : ∀ {y : At}, net c ⟨false, l⟩ y →
    y = ⟨false, next c 3 l⟩ ∨ y = ⟨true, next c 0 l⟩
  | ⟨false, _⟩, ⟨_, e⟩ => .inl (congrArg (At.mk false) e)
  | ⟨true, _⟩, ⟨_, e⟩ => .inr (congrArg (At.mk true) e)

/-- While the window stays shut, a room at its set point stays there. -/
theorem shut_s3 {c : Nat} : ∀ {y : At}, shut c s3 y → y = s3
  | ⟨false, _⟩, ⟨_, _, e⟩ => congrArg (At.mk false) e
  | ⟨true, _⟩, ⟨_, h, _⟩ => Bool.noConfusion h

/-- **An open occurrence begins a line of its level exactly where the open rule moves its level**
(here the direction used: where it moves it, it begins). -/
theorem begins_open {c l : Nat} (moves : next c 0 l ≠ l) : «生» (net c) sameLevel ⟨true, l⟩ :=
  fun ⟨_, ⟨_, e⟩, same⟩ => moves (Eq.subst (motive := fun k => l = next c 0 k) same e).symm

/-- A shut room at its set point begins nothing: it continues itself. -/
theorem not_begins_s3 (c : Nat) : ¬ «生» (net c) sameLevel s3 :=
  fun begins => begins ⟨s3, stays_shut c 3, rfl⟩

theorem warm_of_pos : ∀ {x : At}, 0 < x.level → warm x = true
  | ⟨_, 0⟩, h => absurd h (Nat.lt_irrefl 0)
  | ⟨_, _ + 1⟩, _ => rfl

/-- Where the heater gives, the rule never leaves a room at the open surroundings' level. -/
theorem next_pos {c : Nat} (hc : 1 ≤ c) (σ x : Nat) : 0 < next c σ x := by
  unfold next
  cases exchange σ x with
  | zero => exact Nat.lt_of_lt_of_le hc (Nat.le_add_left c 0)
  | succ k => exact Nat.lt_of_lt_of_le (Nat.succ_pos k) (Nat.le_add_right (k + 1) _)

/-- **In a heated room every successor is warm.** -/
theorem heated_warm {c : Nat} (hc : 1 ≤ c) {x y : At} (h : net c x y) : warm y = true :=
  warm_of_pos (Eq.subst (motive := fun k => 0 < k) h.2.symm (next_pos hc _ _))

/-! ## The unheated room (`c = 0`) -/

namespace Unheated

def b2 : At := ⟨true, 2⟩
def b1 : At := ⟨true, 1⟩
def b0 : At := ⟨true, 0⟩

theorem s3_b2 : net 0 s3 b2 := opens 0 s3
theorem b2_b1 : net 0 b2 b1 := opens 0 b2
theorem b1_b0 : net 0 b1 b0 := opens 0 b1

theorem begins_b2 : «生» (net 0) sameLevel b2 := begins_open (by decide)
theorem begins_b1 : «生» (net 0) sameLevel b1 := begins_open (by decide)

/-- Warmth ends at the open occurrence at `1`: its only successor is cold. -/
theorem b1_ends : «亡» (net 0) alike b1 := fun ⟨_, r, a⟩ => by
  cases net_open r
  exact Bool.noConfusion a

/-- The line of warmth from the set point stays within `s3`, `b2` and `b1`. -/
theorem closed : «闭» («续» (net 0) alike) (fun y => y = s3 ∨ y = b2 ∨ y = b1)
  | _, _, .inl rfl, ⟨r, _⟩ => match net_shut r with
    | .inl e => .inl e
    | .inr e => .inr (.inl e)
  | _, _, .inr (.inl rfl), ⟨r, _⟩ => .inr (.inr (net_open r))
  | _, _, .inr (.inr rfl), c => absurd ⟨_, c⟩ b1_ends

theorem reach {y : At} (h : «所及» (net 0) alike s3 y) : y = s3 ∨ y = b2 ∨ y = b1 :=
  match h with
  | .inl e => .inl e.symm
  | .inr l => «闭之及» closed (.inl rfl) l

theorem keeps : «守» (net 0) alike sameLevel s3 :=
  ⟨fun y => y = s3, rfl,
   fun z hz => match z, hz with | _, rfl => ⟨s3, rfl, stays_shut 0 3, rfl⟩,
   fun u v hu hv t => by subst hu; subst hv; exact not_begins_s3 0 t.2⟩

theorem ends : «有终» (net 0) alike s3 :=
  ⟨b1, .inr (.more ⟨s3_b2, rfl⟩ (.one ⟨b2_b1, rfl⟩)), b1_ends⟩

theorem not_generates : ¬ «生成» (net 0) alike sameLevel s3 := fun ⟨S, _, closedS, ahead⟩ =>
  have no_b1 : ¬ S b1 := fun h => match closedS b1 h with
    | ⟨_, _, c⟩ => b1_ends ⟨_, c⟩
  have no_b2 : ¬ S b2 := fun h => match closedS b2 h with
    | ⟨_, hw, r, _⟩ => no_b1 (Eq.subst (motive := S) (net_open r) hw)
  match ahead s3 ‹S s3› with
  | ⟨u, v, su, sv, hu, ⟨r, _⟩, begins⟩ => match reach hu with
    | .inl e => by
        subst e
        cases net_shut r with
        | inl ev => subst ev; exact not_begins_s3 0 begins
        | inr ev => subst ev; exact no_b2 sv
    | .inr (.inl e) => no_b2 (e ▸ su)
    | .inr (.inr e) => no_b1 (e ▸ su)

/-- **The unheated room at its set point keeps and reaches an end (平衡守而有终)**: it keeps along
the shut branch, its warmth ends along the window's, it renews on the way, and it is neither 生成
nor 退化. -/
theorem «平衡守而有终» :
    «守» (net 0) alike sameLevel s3 ∧ «有终» (net 0) alike s3 ∧
      «新而有终» (net 0) alike sameLevel s3 ∧ ¬ «生成» (net 0) alike sameLevel s3 ∧
      ¬ «退化» (net 0) alike s3 :=
  ⟨keeps, ends, ⟨ends, s3, b2, .inl rfl, ⟨s3_b2, rfl⟩, begins_b2⟩, not_generates,
   fun d => «守退化不并» ⟨keeps, d⟩⟩

theorem ends_b1 : «尽» (net 0) alike b1 := .mk fun y c => absurd ⟨y, c⟩ b1_ends

theorem ends_b2 : «尽» (net 0) alike b2 :=
  .mk fun _ ⟨r, _⟩ => Eq.subst (motive := «尽» (net 0) alike) (net_open r).symm ends_b1

/-- **After the window opens the unheated room degenerates while renewing (开窗则平衡新而尽).** -/
theorem «开窗则平衡新而尽» : «退化» (net 0) alike b2 ∧ «新而尽» (net 0) alike sameLevel b2 :=
  ⟨ends_b2, ends_b2, b2, b1, .inl rfl, ⟨b2_b1, rfl⟩, begins_b1⟩

/-- The rest of its rows: at the set point neither strong form (it reaches an end), and after the
window opens neither generation nor keeping from some point on (it degenerates). -/
theorem rows :
    ¬ «全生成» (net 0) alike sameLevel s3 ∧ ¬ «全守» (net 0) alike sameLevel s3 ∧
      «后守» (net 0) alike sameLevel s3 ∧
      ¬ «生成» (net 0) alike sameLevel b2 ∧ ¬ «后守» (net 0) alike sameLevel b2 :=
  ⟨fun g => «全生成有终不并» ⟨g, ends⟩, fun k => «全守有终不并» ⟨k, ends⟩, «守则后守» keeps,
   fun g => «生成退化不并» ⟨g, ends_b2⟩, fun k => «后守退化不并» ⟨k, ends_b2⟩⟩

end Unheated

/-! ## The heater that gives what the window draws (`c = 1`) -/

namespace Matched

def k3 : At := ⟨true, 3⟩

theorem s3_k3 : net 1 s3 k3 := opens 1 s3
theorem k3_k3 : net 1 k3 k3 := opens 1 k3

theorem not_begins_k3 : ¬ «生» (net 1) sameLevel k3 := fun b => b ⟨k3, k3_k3, rfl⟩

theorem closed : «闭» (net 1) (fun y => y = s3 ∨ y = k3)
  | _, _, .inl rfl, r => match net_shut r with
    | .inl e => .inl e
    | .inr e => .inr e
  | _, _, .inr rfl, r => .inr (net_open r)

theorem reach {x y : At} (hx : x = s3 ∨ x = k3) (h : «所及» (net 1) alike x y) : y = s3 ∨ y = k3 :=
  match h with
  | .inl e => Eq.subst (motive := fun z => z = s3 ∨ z = k3) e hx
  | .inr l => «闭之及» (fun a b ha c => closed a b ha c.1) hx l

theorem no_renewal {x z w : At} (hx : x = s3 ∨ x = k3) (hz : «所及» (net 1) alike x z) :
    ¬ «传» (net 1) alike sameLevel z w := fun ⟨⟨r, _⟩, b⟩ =>
  match closed z w (reach hx hz) r with
  | .inl e => not_begins_s3 1 (e ▸ b)
  | .inr e => not_begins_k3 (e ▸ b)

theorem keeping {x : At} (hx : x = s3 ∨ x = k3) : «全守» (net 1) alike sameLevel x :=
  ⟨fun y hy => match y, reach hx hy with
     | _, .inl rfl => ⟨s3, stays_shut 1 3, rfl⟩
     | _, .inr rfl => ⟨k3, k3_k3, rfl⟩,
   x, .inl rfl, fun _ _ hz => no_renewal hx hz⟩

theorem not_generates : ¬ «生成» (net 1) alike sameLevel s3 := fun ⟨_, hs, _, ahead⟩ =>
  match ahead s3 hs with
  | ⟨_, _, _, _, hu, t⟩ => no_renewal (.inl rfl) hu t

/-- **A heater giving exactly what the window draws keeps, in the strong form (给如所取则全守)**:
before and after the window opens nothing renews at the grain of the level, rest's region. -/
theorem «给如所取则全守» :
    «全守» (net 1) alike sameLevel s3 ∧ «全守» (net 1) alike sameLevel k3 ∧
      ¬ «生成» (net 1) alike sameLevel s3 :=
  ⟨keeping (.inl rfl), keeping (.inr rfl), not_generates⟩

theorem keeps_at : ∀ {x : At}, (x = s3 ∨ x = k3) → «守» (net 1) alike sameLevel x
  | _, .inl rfl => ⟨fun y => y = s3, rfl,
      fun z hz => match z, hz with | _, rfl => ⟨s3, rfl, stays_shut 1 3, rfl⟩,
      fun _ _ hu _ t => no_renewal (.inl rfl)
        (Eq.subst (motive := fun z => «所及» (net 1) alike s3 z) hu.symm (.inl rfl)) t⟩
  | _, .inr rfl => ⟨fun y => y = k3, rfl,
      fun z hz => match z, hz with | _, rfl => ⟨k3, rfl, k3_k3, rfl⟩,
      fun _ _ hu _ t => no_renewal (.inr rfl)
        (Eq.subst (motive := fun z => «所及» (net 1) alike k3 z) hu.symm (.inl rfl)) t⟩

/-- The rest of its rows: it keeps at both occurrences, and is neither 全生成 nor 有终 nor 退化. -/
theorem rows :
    «守» (net 1) alike sameLevel s3 ∧ «守» (net 1) alike sameLevel k3 ∧
      ¬ «全生成» (net 1) alike sameLevel s3 ∧ ¬ «有终» (net 1) alike s3 ∧ ¬ «退化» (net 1) alike s3 :=
  ⟨keeps_at (.inl rfl), keeps_at (.inr rfl),
   fun g => «全生成全守不并» ⟨g, keeping (.inl rfl)⟩, fun e => «全守有终不并» ⟨keeping (.inl rfl), e⟩,
   fun d => «守退化不并» ⟨keeps_at (.inl rfl), d⟩⟩

end Matched

/-! ## The thermostat (`c = 2`) -/

namespace Thermostat

def o4 : At := ⟨true, 4⟩
def o3 : At := ⟨true, 3⟩

theorem s3_o4 : net 2 s3 o4 := opens 2 s3
theorem o4_o3 : net 2 o4 o3 := opens 2 o4
theorem o3_o4 : net 2 o3 o4 := opens 2 o3

theorem begins_o4 : «生» (net 2) sameLevel o4 := begins_open (by decide)
theorem begins_o3 : «生» (net 2) sameLevel o3 := begins_open (by decide)

/-- The three occurrences the thermostat reaches from its set point. -/
def Reached (y : At) : Prop := y = s3 ∨ y = o4 ∨ y = o3

theorem closed : «闭» (net 2) Reached
  | _, _, .inl rfl, r => match net_shut r with
    | .inl e => .inl e
    | .inr e => .inr (.inl e)
  | _, _, .inr (.inl rfl), r => .inr (.inr (net_open r))
  | _, _, .inr (.inr rfl), r => .inr (.inl (net_open r))

theorem reach {x y : At} (hx : Reached x) (h : «所及» (net 2) alike x y) : Reached y :=
  match h with
  | .inl e => Eq.subst (motive := Reached) e hx
  | .inr l => «闭之及» (fun a b ha c => closed a b ha c.1) hx l

/-- From each occurrence reached, a carrying renewal to an occurrence reached: the opening, and
every open step. -/
theorem renews : ∀ {y : At}, Reached y → ∃ w, «传» (net 2) alike sameLevel y w ∧ Reached w
  | _, .inl rfl => ⟨o4, ⟨⟨s3_o4, rfl⟩, begins_o4⟩, .inr (.inl rfl)⟩
  | _, .inr (.inl rfl) => ⟨o3, ⟨⟨o4_o3, rfl⟩, begins_o3⟩, .inr (.inr rfl)⟩
  | _, .inr (.inr rfl) => ⟨o4, ⟨⟨o3_o4, rfl⟩, begins_o4⟩, .inr (.inl rfl)⟩

theorem generation {x : At} (hx : Reached x) : «全生成» (net 2) alike sameLevel x :=
  ⟨fun _ hy => match renews (reach hx hy) with | ⟨w, t, _⟩ => ⟨w, t.1⟩,
   fun y hy => match renews (reach hx hy) with | ⟨w, t, _⟩ => ⟨y, w, .inl rfl, t⟩⟩

theorem generates : «生成» (net 2) alike sameLevel s3 :=
  ⟨Reached, .inl rfl,
   fun _ hz => match renews hz with | ⟨w, t, hw⟩ => ⟨w, hw, t.1⟩,
   fun z hz => match renews hz with | ⟨w, t, hw⟩ => ⟨z, w, hz, hw, .inl rfl, t⟩⟩

theorem keeps : «守» (net 2) alike sameLevel s3 :=
  ⟨fun y => y = s3, rfl,
   fun z hz => match z, hz with | _, rfl => ⟨s3, rfl, stays_shut 2 3, rfl⟩,
   fun u v hu hv t => by subst hu; subst hv; exact not_begins_s3 2 t.2⟩

/-- **The thermostat at its set point generates and keeps (恒温生守相杂)**: along the window's branch
the heater renews the level at every step, and along the shut branch it rests. -/
theorem «恒温生守相杂» : «生成» (net 2) alike sameLevel s3 ∧ «守» (net 2) alike sameLevel s3 :=
  ⟨generates, keeps⟩

/-- In the strong form too, before and after the window opens. -/
theorem generation_strong :
    «全生成» (net 2) alike sameLevel s3 ∧ «全生成» (net 2) alike sameLevel o4 ∧
      «全生成» (net 2) alike sameLevel o3 :=
  ⟨generation (.inl rfl), generation (.inr (.inl rfl)), generation (.inr (.inr rfl))⟩

/-- The open window's net is a single line. -/
theorem openNet_single {c : Nat} : ∀ {z w w' : At}, openNet c z w → openNet c z w' → w = w'
  | ⟨true, _⟩, _, _, ⟨_, r⟩, ⟨_, r'⟩ => (net_open r).trans (net_open r').symm
  | ⟨false, _⟩, _, _, ⟨h, _⟩, _ => Bool.noConfusion h

theorem begins_open_line {y : At} (b : «生» (net 2) sameLevel y) : «生» (openNet 2) sameLevel y :=
  fun ⟨x, r, same⟩ => b ⟨x, r.2, same⟩

theorem generates_open : «生成» (openNet 2) alike sameLevel o4 :=
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
and the thermostat generating there does not keep from some point on (`«单行则生成后守不并»`). At
its set point the net branches, and it generates and keeps from some point on together: the
condition is needed. -/
theorem single_line_tested :
    ¬ «后守» (openNet 2) alike sameLevel o4 ∧
      (¬ ∀ {z w w' : At}, net 2 z w → net 2 z w' → w = w') ∧
      «生成» (net 2) alike sameLevel s3 ∧ «后守» (net 2) alike sameLevel s3 :=
  ⟨fun k => «单行则生成后守不并» (R := openNet 2) (L := alike) (E := sameLevel)
     (fun h h' => openNet_single h h') ⟨generates_open, k⟩,
   fun single => Bool.noConfusion (congrArg At.opened (single (stays_shut 2 3) s3_o4)),
   generates, «守则后守» keeps⟩

/-- The open occurrences the thermostat reaches after the window opens. -/
theorem closed_open : «闭» (net 2) (fun y => y = o4 ∨ y = o3)
  | _, _, .inl rfl, r => .inr (net_open r)
  | _, _, .inr rfl, r => .inl (net_open r)

/-- **After the window opens the thermostat does not keep from some point on**, on the net itself:
every step of its line is a carrying renewal. -/
theorem not_keepsAfter_open {x : At} (hx : x = o4 ∨ x = o3) : ¬ «后守» (net 2) alike sameLevel x :=
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

/-- The rest of its rows: at the set point neither 全守 nor 有终; after opening it does not keep. -/
theorem rows :
    ¬ «全守» (net 2) alike sameLevel s3 ∧ ¬ «有终» (net 2) alike s3 ∧
      ¬ «守» (net 2) alike sameLevel o4 ∧ ¬ «后守» (net 2) alike sameLevel o4 :=
  ⟨fun k => «全生成全守不并» ⟨generation (.inl rfl), k⟩,
   fun e => «全生成有终不并» ⟨generation (.inl rfl), e⟩,
   fun k => not_keepsAfter_open (.inl rfl) («守则后守» k), not_keepsAfter_open (.inl rfl)⟩

end Thermostat

/-! ## A conditional law on the family -/

/-- **Warmth is a constant class under the net exactly where the heater gives
(温有常当且仅当有给).** -/
theorem «温有常当且仅当有给» (c : Nat) : «有常» (net c) alike ↔ 1 ≤ c := by
  constructor
  · intro h
    cases c with
    | zero => exact absurd h («有亡之续则不有常» ⟨Unheated.b2_b1, rfl⟩ Unheated.b1_ends)
    | succ k => exact Nat.succ_le_succ (Nat.zero_le k)
  · intro hc
    exact («有常之逐点» (net c) alike).mpr fun _ u' _ _ r =>
      ⟨⟨true, next c 0 u'.level⟩, opens c u', (heated_warm hc r).trans (heated_warm hc (opens c u')).symm⟩

/-- **Warmth never ends along any branch from the set point exactly where the heater gives
(温不穷当且仅当有给)**: by `«有常则往不穷»` where it gives, and by the window's branch where it
does not. -/
theorem «温不穷当且仅当有给» (c : Nat) : «不穷» (net c) alike s3 ↔ 1 ≤ c := by
  constructor
  · intro h
    cases c with
    | zero =>
      exact absurd (h Unheated.b1 (.inr (.more ⟨Unheated.s3_b2, rfl⟩ (.one ⟨Unheated.b2_b1, rfl⟩)))) Unheated.b1_ends
    | succ k => exact Nat.succ_le_succ (Nat.zero_le k)
  · intro hc
    exact «有常则往不穷» ((«温有常当且仅当有给» c).mpr hc) ⟨s3, stays_shut c 3, rfl⟩

/-! ## Testing: rooms side by side -/

/-- Rooms side by side: an occurrence tagged with its heater's `c`. -/
abbrev Tagged : Type := Nat × At

/-- Every room with the window's opening in the net. -/
def joint : «际» Tagged := fun x y => x.1 = y.1 ∧ net x.1 x.2 y.2

/-- Every room with its window shut. -/
def jointShut : «际» Tagged := fun x y => x.1 = y.1 ∧ shut x.1 x.2 y.2

/-- The same level, whatever the room. -/
def jointLevel : «际» Tagged := fun x y => sameLevel x.2 y.2

/-- Warm or not, whatever the room. -/
def jointAlike : «际» Tagged := fun x y => alike x.2 y.2

/-- **While no window opens, every room at its set point is one core class at the finest class,
whatever its heater (不开窗则同核).** -/
theorem «不开窗则同核» (c c' : Nat) : «核» jointShut jointLevel (c, s3) (c', s3) :=
  ⟨fun x y => x.2 = s3 ∧ y.2 = s3,
   fun _ _ ⟨hx, hy⟩ => (congrArg At.level hx).trans (congrArg At.level hy).symm,
   fun _ _ ⟨hx, hy⟩ => ⟨hy, hx⟩,
   («有常之逐点» jointShut _).mpr fun u u' ⟨hu, hu'⟩ v ⟨_, r⟩ => by
     obtain ⟨c₁, w⟩ := u'
     cases hu'
     exact ⟨(c₁, s3), ⟨rfl, rfl, rfl, rfl⟩, shut_s3 (hu ▸ r), rfl⟩,
   rfl, rfl⟩

/-- **With the window in the net, the first stage of the level tells the unheated room from every
heated one (开窗则一层可分).** -/
theorem «开窗则一层可分» {c : Nat} (hc : 1 ≤ c) :
    ¬ «层» joint jointLevel 1 (0, s3) (c, s3) ∧ ¬ «核» joint jointLevel (0, s3) (c, s3) :=
  have stage : ¬ «层» joint jointLevel 1 (0, s3) (c, s3) := fun ⟨_, forth, _⟩ =>
    match forth (0, Unheated.b2) ⟨rfl, Unheated.s3_b2⟩ with
    | ⟨(_, y), ⟨_, r⟩, same⟩ => match net_shut r with
      | .inl e => absurd (show (2 : Nat) = 3 from same.trans (congrArg At.level e)) (by decide)
      | .inr e => Nat.ne_of_lt (show (2 : Nat) < 2 + c from Nat.add_lt_add_left hc 2)
          (same.trans (congrArg At.level e))
  ⟨stage, «可分则不在核» ⟨1, stage⟩⟩

/-- The two heaters are told apart by the first stage of the level too. -/
theorem heaters_told_apart : ¬ «层» joint jointLevel 1 (2, s3) (1, s3) := fun ⟨_, forth, _⟩ =>
  match forth (2, Thermostat.o4) ⟨rfl, Thermostat.s3_o4⟩ with
  | ⟨(_, y), ⟨_, r⟩, same⟩ => match net_shut r with
    | .inl e => absurd (show (4 : Nat) = 3 from same.trans (congrArg At.level e)) (by decide)
    | .inr e => absurd (show (4 : Nat) = 3 from same.trans (congrArg At.level e)) (by decide)

/-- The unheated room's set point and its first open occurrence step only to warm occurrences. -/
theorem unheated_ahead_warm {z y : At} (hz : z = s3 ∨ z = Unheated.b2) (r : net 0 z y) :
    warm y = true :=
  match hz with
  | .inl e => by
      subst e
      cases net_shut r with
      | inl ey => subst ey; rfl
      | inr ey => subst ey; rfl
  | .inr e => by
      subst e
      cases net_open r
      rfl

/-- At the first stage of warm or not, the unheated room's set point or its first open occurrence is
not told from any warm occurrence of a heated room. -/
theorem stage_one {c : Nat} (hc : 1 ≤ c) {z w : At} (hz : z = s3 ∨ z = Unheated.b2)
    (hw : warm w = true) : «层» joint jointAlike 1 (0, z) (c, w) :=
  have warm_z : warm z = true := match hz with
    | .inl e => e ▸ rfl
    | .inr e => e ▸ rfl
  ⟨warm_z.trans hw.symm,
   fun _ ⟨_, r⟩ => ⟨(c, ⟨true, next c 0 w.level⟩), ⟨rfl, opens c w⟩,
     (unheated_ahead_warm hz r).trans (heated_warm hc (opens c w)).symm⟩,
   fun _ ⟨_, r⟩ => ⟨(0, ⟨true, next 0 0 z.level⟩), ⟨rfl, opens 0 z⟩,
     (unheated_ahead_warm hz (opens 0 z)).trans (heated_warm hc r).symm⟩⟩

/-- **Under warm or not, the window tells the unheated room from a heated one exactly at the third
stage (开窗以温三层乃分)**: the open window takes three steps to empty the unheated room's
warmth. -/
theorem «开窗以温三层乃分» {c : Nat} (hc : 1 ≤ c) :
    «层» joint jointAlike 2 (0, s3) (c, s3) ∧ ¬ «层» joint jointAlike 3 (0, s3) (c, s3) :=
  ⟨⟨stage_one hc (.inl rfl) rfl,
    fun v ⟨e, r⟩ => by
      obtain ⟨c₀, y⟩ := v
      cases e
      exact ⟨(c, s3), ⟨rfl, stays_shut c 3⟩, match net_shut r with
        | .inl ey => stage_one hc (.inl ey) rfl
        | .inr ey => stage_one hc (.inr ey) rfl⟩,
    fun v' ⟨e, r⟩ => by
      obtain ⟨c₀, y⟩ := v'
      cases e
      exact ⟨(0, s3), ⟨rfl, stays_shut 0 3⟩, stage_one hc (.inl rfl) (heated_warm hc r)⟩⟩,
   fun ⟨_, forth, _⟩ => match forth (0, Unheated.b2) ⟨rfl, Unheated.s3_b2⟩ with
    | ⟨(c₁, _), ⟨e₁, _⟩, ⟨_, forth₂, _⟩⟩ => match forth₂ (0, Unheated.b1) ⟨rfl, Unheated.b2_b1⟩ with
      | ⟨(c₂, _), ⟨e₂, _⟩, ⟨_, forth₃, _⟩⟩ => match forth₃ (0, Unheated.b0) ⟨rfl, Unheated.b1_b0⟩ with
        | ⟨_, ⟨_, r₃⟩, same⟩ =>
          Bool.noConfusion (same.trans (heated_warm (e₂ ▸ e₁ ▸ hc) r₃))⟩

/-- **Warmth does not tell two heated rooms apart (二恒温以温不可分).** -/
theorem «二恒温以温不可分» {c c' : Nat} (hc : 1 ≤ c) (hc' : 1 ≤ c') :
    «核» joint jointAlike (c, s3) (c', s3) :=
  ⟨fun x y => 1 ≤ x.1 ∧ 1 ≤ y.1 ∧ warm x.2 = true ∧ warm y.2 = true,
   fun _ _ ⟨_, _, wx, wy⟩ => wx.trans wy.symm,
   fun _ _ ⟨a, b, wx, wy⟩ => ⟨b, a, wy, wx⟩,
   («有常之逐点» joint _).mpr fun _ u' ⟨hu, hu', _, _⟩ _ ⟨e, r⟩ =>
     ⟨(u'.1, ⟨true, next u'.1 0 u'.2.level⟩), ⟨rfl, opens u'.1 u'.2⟩,
      e ▸ hu, hu', heated_warm hu r, heated_warm hu' (opens u'.1 u'.2)⟩,
   hc, hc', rfl, rfl⟩

end Rooms

end Becoming
