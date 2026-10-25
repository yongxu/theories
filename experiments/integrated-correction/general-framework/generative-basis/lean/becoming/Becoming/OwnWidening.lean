import Becoming.Retaining

/-!
# Own widening: where a part's widening of what it can reach is the whole's

`Becoming.Retaining` gave the exact boundary of the generative space: the levels with a part
widen those without it exactly when the part's net draw stays within the margin for what the
levels without it admit (`Flow.widens_iff_within_margin_at`). This module reads that boundary for
a part whose activity widens what can form within a decided region of its own (its options), and
asks when that widening is the whole's.

* **Widening within a region.** Within a decided region of formations, one level path widens
  another when at every step it admits every member the other admits there and at some step one
  more (`Web.WidensWithin`). It exceeds the other over the whole (`Web.WidensWithin.exceeds`), so
  it neither keeps what can form the same nor is widened by the other
  (`Web.WidensWithin.not_keeps`, `Web.WidensWithin.not_narrowed`).
* **Inclusion past a region.** In a balanced flow, where the levels with a part admit within a
  region everything the levels without it admit there, they include the levels without it
  exactly when the part's net draw stays within the margin for every formation outside the
  region that the levels without it admit (`Flow.Balances.includes_iff_beyond_within`).
* **Own widening is the whole's exactly within the margin.** Where the part's activity widens
  within its own region, the levels with it widen those without it exactly when its net draw
  stays within the margin for every formation outside the region that the levels without it
  admit (`Flow.Balances.widens_iff_others_within`), and the two are mixed exactly when, for one
  such formation, the draw goes beyond (`Flow.Balances.mixed_iff_other_beyond`). Own widening is
  never keeping or narrowing; it is widening or mixed, and the margin of the others says which.
* **Zero margin.** Where a formation outside the region, admitted without the part, needs a
  condition at exactly the level the part leaves it without its exchange, any net draw of the
  part on that condition makes own widening mixed (`Flow.Balances.mixed_of_tight`).
* **OwnDrawing on what no other needs.** Where the part's net draw is nothing on every condition
  required by a formation outside the region that the levels without it admit, own widening
  widens the whole, whatever the levels (`Flow.Balances.widens_of_untaken_beyond`).
* **What a measure over the own region reads.** Where own widening widens the whole, the levels
  without the part admit within the own region less than the levels with it at some step
  (`Flow.Balances.widens_yet_own_changed`): a comparison that reads only the own region, in both
  directions, shows a change even where nothing is closed.
* **Any reachable set as an admitted set.** A decided set of formations at each step is what the
  web reading each formation as its own condition, at need one, admits (`Web.admits_reachWeb_iff`).
  No amount is conserved there: balance has content only where reaching an outcome is a threshold
  on amounts that are taken and given.
* **The witness.** `OwnDrawing`: a drawer takes one unit of a shared condition and gives one to its
  store, which its own option needs; another formation needs the shared condition at one. With
  one unit of slack the drawer's own widening widens the whole (`OwnDrawing.ample_widens`); with
  none it is mixed (`OwnDrawing.tight_mixed`, by `Flow.Balances.mixed_of_tight`).

**Reading (the AI's).** Read the levels without the part as the inaction baseline: what would
stand had the part taken and given nothing, the rest acting as they did. Read the part's own region
as its options, so that own widening is keeping options open, or gaining reach. Then gaining reach
coincides with widening what the whole can form exactly where the part's net draw on shared
conditions stays within the margins the others' needs leave, and it is mixed, opening the part's
options while closing another's, exactly beyond. Where every need is met with no slack, every
net draw on a needed condition closes something. Mixed is not ordered: neither the continuation
condition nor calling widening better (C) ranks a mixed comparison, so these theorems say where
gaining reach closes what another can form, not that it is worse. The record names the formal
results on power-seeking and impact measures this corresponds to.

What is not derived: balance (a hypothesis where it enters); the part and its region (decided
families, named); the baseline (the levels without the part's exchange, not another action of the
part); that reaching an outcome is a threshold on levels (the representation's admission). The
representation commits to discrete steps, natural amounts and Prop-valued requirement. No
significance, ranking, ethical predicate or axiom occurs.
-/

namespace Becoming

variable {F C : Type}

namespace Web

variable (W : Web F C)

/-- Within the decided region `region`, the level path `l` widens `l'`: at every step it admits
every member of the region that `l'` admits, and at some step one more member. -/
def WidensWithin (region : F → Bool) (l l' : Nat → C → Nat) : Prop :=
  (∀ t, W.AdmitsWithin (fun f => region f = true) (l t) (l' t) t) ∧
    ∃ t f, region f = true ∧ W.Admits (l t) t f ∧ ¬ W.Admits (l' t) t f

variable {W}

/-- Widening within a region exceeds over the whole. -/
theorem WidensWithin.exceeds {region : F → Bool} {l l' : Nat → C → Nat}
    (widens : W.WidensWithin region l l') : W.Exceeds l l' :=
  match widens.2 with
  | ⟨t, f, _, admits, not⟩ => ⟨t, f, admits, not⟩

/-- Widening within a region does not keep what can form the same. -/
theorem WidensWithin.not_keeps {region : F → Bool} {l l' : Nat → C → Nat}
    (widens : W.WidensWithin region l l') : ¬ W.Keeps l l' :=
  fun keeps => keeps.2.not_exceeded widens.exceeds

/-- Widening within a region is not widened by the other path. -/
theorem WidensWithin.not_narrowed {region : F → Bool} {l l' : Nat → C → Nat}
    (widens : W.WidensWithin region l l') : ¬ W.Widens l' l :=
  fun back => back.1.not_exceeded widens.exceeds

/-- Each formation read as its own condition, at need one, standing at one exactly where `reach`
holds of it. -/
def reachWeb (reach : Nat → F → Bool) : Web F F :=
  ⟨fun t c => match reach t c with
    | true => 1
    | false => 0,
   fun _ _ => True, fun _ f c => c = f, fun _ _ _ => 1, fun _ _ _ => False⟩

/-- **Any reachable set is an admitted set.** At each step the web reading each formation as its
own condition admits exactly the formations `reach` holds of. -/
theorem admits_reachWeb_iff (reach : Nat → F → Bool) (t : Nat) (f : F) :
    (reachWeb reach).Admits ((reachWeb reach).level t) t f ↔ reach t f = true :=
  ⟨fun admits =>
    have one : 1 ≤ (match reach t f with | true => 1 | false => 0) := admits f rfl
    match reach t f, one with
    | true, _ => rfl
    | false, one => absurd one (Nat.not_succ_le_zero 0),
   fun reached c same => match c, same with
    | _, rfl => show 1 ≤ (match reach t f with | true => 1 | false => 0) from
        match reach t f, reached with
        | true, _ => Nat.le_refl 1⟩

end Web

namespace Flow

variable {L : Flow F C} {part : F → Bool} {W : Web F C}

/-- **Inclusion past a region.** In a balanced flow, where the levels with a part admit within a
region everything the levels without it admit there, they include the levels without it exactly
when the part's net draw stays within the margin for every formation outside the region that the
levels without it admit. -/
theorem Balances.includes_iff_beyond_within (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {region : F → Bool}
    (within : ∀ t, W.AdmitsWithin (fun f => region f = true) (W.level t) (l t) t) :
    W.Includes W.level l ↔ ∀ t f, region f = false → W.Admits (l t) t f → ∀ c, W.requires t f c →
      W.need t f c + total (steps 0 t) (fun s => L.partTaken part s c) ≤
        l t c + total (steps 0 t) (fun s => L.partGiven part s c) :=
  ⟨fun includes t f _ admits =>
    (supported_iff_within_margin_at without fun c _ s _ => balances.on [c] s).mp
      (includes t f admits),
   fun margin t f admits => match h : region f with
    | true => within t f h admits
    | false => (supported_iff_within_margin_at without fun c _ s _ => balances.on [c] s).mpr
        (margin t f h admits)⟩

/-- **Own widening is the whole's exactly within the margin.** In a balanced flow, where the part's
activity widens what can form within its own region, the levels with it widen those without it
exactly when its net draw stays within the margin for every formation outside the region that the
levels without it admit. -/
theorem Balances.widens_iff_others_within (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {own : F → Bool}
    (ownWidens : W.WidensWithin own W.level l) :
    W.Widens W.level l ↔ ∀ t f, own f = false → W.Admits (l t) t f → ∀ c, W.requires t f c →
      W.need t f c + total (steps 0 t) (fun s => L.partTaken part s c) ≤
        l t c + total (steps 0 t) (fun s => L.partGiven part s c) :=
  ⟨fun widens => (balances.includes_iff_beyond_within without ownWidens.1).mp widens.1,
   fun margin => ⟨(balances.includes_iff_beyond_within without ownWidens.1).mpr margin,
     ownWidens.exceeds⟩⟩

/-- **Beyond the margin, own widening is mixed.** In a balanced flow, where the part's activity
widens what can form within its own region, the levels with it and without it are mixed exactly
when, for some formation outside the region that the levels without it admit, the part's net draw
on a condition it requires goes beyond the margin. -/
theorem Balances.mixed_iff_other_beyond (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {own : F → Bool}
    (ownWidens : W.WidensWithin own W.level l) :
    W.Mixed W.level l ↔ ∃ t f, own f = false ∧ W.Admits (l t) t f ∧ ¬ ∀ c, W.requires t f c →
      W.need t f c + total (steps 0 t) (fun s => L.partTaken part s c) ≤
        l t c + total (steps 0 t) (fun s => L.partGiven part s c) :=
  ⟨fun mixed => match mixed.2 with
    | ⟨t, f, admits, lost⟩ =>
      ⟨t, f, (match h : own f with
        | true => absurd (ownWidens.1 t f h admits) lost
        | false => rfl), admits, fun margin => lost
          ((supported_iff_within_margin_at without fun c _ s _ => balances.on [c] s).mpr margin)⟩,
   fun ⟨t, f, _, admits, beyond⟩ => ⟨ownWidens.exceeds, t, f, admits, fun supported => beyond
     ((supported_iff_within_margin_at without fun c _ s _ => balances.on [c] s).mp supported)⟩⟩

/-- **Zero margin.** In a balanced flow, where the part's activity widens what can form within its
own region, and a formation outside the region, admitted at `t` by the levels without the part,
needs a condition at exactly the level the part leaves it without its exchange, a net draw of the
part on that condition up to `t` makes the comparison mixed. -/
theorem Balances.mixed_of_tight (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {own : F → Bool}
    (ownWidens : W.WidensWithin own W.level l) {t : Nat} {g : F} {c : C}
    (other : own g = false) (admitted : W.Admits (l t) t g) (requires : W.requires t g c)
    (tight : W.need t g c = l t c)
    (draw : total (steps 0 t) (fun s => L.partGiven part s c) <
      total (steps 0 t) (fun s => L.partTaken part s c)) :
    W.Mixed W.level l :=
  (balances.mixed_iff_other_beyond without ownWidens).mpr ⟨t, g, other, admitted, fun margin =>
    Nat.not_le_of_gt draw (Naturals.le_of_add_le_add_left (Nat.le_trans
      (Nat.le_of_eq (congrArg (· + total (steps 0 t) fun s => L.partTaken part s c) tight.symm))
      (margin c requires)))⟩

/-- **OwnDrawing on what no other needs.** In a balanced flow, where the part's activity widens what
can form within its own region and its net draw up to each step is nothing on every condition
required by a formation outside the region that the levels without it admit, the levels with the
part widen those without it, whatever the levels. -/
theorem Balances.widens_of_untaken_beyond (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {own : F → Bool}
    (ownWidens : W.WidensWithin own W.level l)
    (net : ∀ t f c, own f = false → W.Admits (l t) t f → W.requires t f c →
      total (steps 0 t) (fun s => L.partTaken part s c) ≤
        total (steps 0 t) (fun s => L.partGiven part s c)) :
    W.Widens W.level l :=
  (balances.widens_iff_others_within without ownWidens).mpr fun t f other admits c requires =>
    Nat.add_le_add (admits c requires) (net t f c other admits requires)

/-- **What a measure over the own region reads.** In a balanced flow, where the part's activity
widens what can form within its own region and its net draw stays within the margin for every
formation outside it that the levels without it admit, the levels with the part widen those
without it, and at some step the levels without it do not admit within the own region what the
levels with it admit there. -/
theorem Balances.widens_yet_own_changed (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {own : F → Bool}
    (ownWidens : W.WidensWithin own W.level l)
    (margin : ∀ t f, own f = false → W.Admits (l t) t f → ∀ c, W.requires t f c →
      W.need t f c + total (steps 0 t) (fun s => L.partTaken part s c) ≤
        l t c + total (steps 0 t) (fun s => L.partGiven part s c)) :
    W.Widens W.level l ∧ ∃ t, ¬ W.AdmitsWithin (fun f => own f = true) (l t) (W.level t) t :=
  ⟨(balances.widens_iff_others_within without ownWidens).mpr margin,
   match ownWidens.2 with
   | ⟨t, f, member, admits, not⟩ => ⟨t, fun within => not (within f member admits)⟩⟩

end Flow

/-! ## The witness: one draw paid from a shared condition -/

namespace OwnDrawing

/-- A drawer, the option its store opens, and another formation needing the shared condition. -/
inductive Formation where
  | drawer
  | option
  | other

/-- The shared condition and the drawer's store. -/
inductive Place where
  | shared
  | store

/-- One at the first step, nothing after. -/
def firstStep : Nat → Nat := Witnesses.profile [1] 0

/-- Across the first step the drawer takes one unit of the shared condition and gives one to its
store. -/
def flow : Flow Formation Place where
  present _ := [.drawer, .option, .other]
  take t f c := match f, c with
    | .drawer, .shared => firstStep t
    | .drawer, .store => 0
    | .option, _ => 0
    | .other, _ => 0
  give t f c := match f, c with
    | .drawer, .shared => 0
    | .drawer, .store => firstStep t
    | .option, _ => 0
    | .other, _ => 0

/-- The drawer is the part. -/
def drawerPart : Formation → Bool
  | .drawer => true
  | .option => false
  | .other => false

/-- The drawer's own region: the option its store opens. -/
def own : Formation → Bool
  | .drawer => false
  | .option => true
  | .other => false

/-- With `n` units of the shared condition left after the draw: the option needs the store at
one, the other formation needs the shared condition at one. -/
def web (n : Nat) : Web Formation Place where
  level t c := match c, t with
    | .shared, 0 => n + 1
    | .shared, _ + 1 => n
    | .store, 0 => 0
    | .store, _ + 1 => 1
  active _ _ := True
  requires _ f c := match f, c with
    | .drawer, _ => False
    | .option, .shared => False
    | .option, .store => True
    | .other, .shared => True
    | .other, .store => False
  need _ _ _ := 1
  draws t f c := match f, c with
    | .drawer, .shared => t = 0
    | .drawer, .store => False
    | .option, _ => False
    | .other, _ => False

/-- The levels without the drawer's exchange: the shared condition stays at `n + 1`, the store at
nothing. -/
def withheldLevel (n : Nat) (_ : Nat) : Place → Nat
  | .shared => n + 1
  | .store => 0

theorem balances (n : Nat) : flow.Balances (web n)
  | 0, .shared => rfl
  | 0, .store => rfl
  | _ + 1, .shared => rfl
  | _ + 1, .store => rfl

theorem withheld (n : Nat) : flow.WithheldLevels drawerPart (web n) (withheldLevel n) :=
  ⟨fun t c => match t, c with
    | 0, .shared => rfl
    | 0, .store => rfl
    | _ + 1, .shared => rfl
    | _ + 1, .store => rfl,
   fun c => match c with
    | .shared => rfl
    | .store => rfl⟩

/-- The drawer's activity widens what can form within its own region: without it the option is
never admitted, with it the option is admitted from the first step on. -/
theorem own_widens (n : Nat) : (web n).WidensWithin own (web n).level (withheldLevel n) :=
  ⟨fun _ f member admits => match f, member with
    | .option, _ => absurd (admits .store trivial) (Nat.not_succ_le_zero 0),
   ⟨1, .option, rfl, fun c requires => match c, requires with
     | .store, _ => Nat.le_refl 1,
    fun admits => Nat.not_succ_le_zero 0 (admits .store trivial)⟩⟩

/-- **With slack, own widening widens.** With one unit of the shared condition to spare after the
draw, the drawer's activity widens what can form over the whole. -/
theorem ample_widens (n : Nat) : (web (n + 1)).Widens (web (n + 1)).level (withheldLevel (n + 1)) :=
  ⟨(fun t f admits => match f with
    | .drawer => fun c requires => match c, requires with
      | .shared, no => nomatch no
      | .store, no => nomatch no
    | .option => absurd (admits .store trivial) (Nat.not_succ_le_zero 0)
    | .other => fun c requires => match c, requires, t with
      | .shared, _, 0 => Nat.succ_le_succ (Nat.zero_le (n + 1))
      | .shared, _, _ + 1 => Nat.succ_le_succ (Nat.zero_le n)
      | .store, no, _ => nomatch no),
   (own_widens (n + 1)).exceeds⟩

/-- **Without slack, own widening is mixed.** With nothing of the shared condition to spare after
the draw, the other formation needs it at exactly the level it stands at without the drawer, and
the drawer's own widening is mixed (`Flow.Balances.mixed_of_tight`). -/
theorem tight_mixed : (web 0).Mixed (web 0).level (withheldLevel 0) :=
  (balances 0).mixed_of_tight (withheld 0) (own_widens 0) (t := 1) (g := .other) (c := .shared)
    rfl (fun c requires => match c, requires with
      | .shared, _ => Nat.le_refl 1
      | .store, no => nomatch no) trivial rfl (Nat.zero_lt_one)

end OwnDrawing

end Becoming
