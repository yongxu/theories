# Review of UE18: the Markov blanket as a coupling structure, and what the existence claim forbids

29 October 2026. Independent review, AI-written, of `Becoming.Blanket` ([module](tree/Becoming/Blanket.lean), sha256 `555ee68e…6078a63`, [build](scratch-2.log)), [NOTE](NOTE.md) (sha256 `ec42c8c8…389cef4f`) and [DESIGN](DESIGN.md), against the [plan](../ue-unified-explanation/FEP-INTEGRATION.md) (item 3), its [source](../../../../../../sources/15-codex-theory-conversations/2026-10-29-fep-integral-explains-more.md), `Runaway`, `Selection` with [03 §1](../../../../../../theories/becoming/chapters/03-KNOWING.md#r-selection-through-couplings), `ConditionalWeights`, UE1's `ChoiceCountCapture`, the [search](../ue1-fep-bridge/THIRD-PART-SEARCH.md) (candidate 15) and the UE16 and UE17 drafts. Every cited work exists as cited (web search); Kirchhoff and others (2018) §3 and Ramstead and others (2023) §2 were checked at the source. Line numbers refer to the module's bytes above; the probe's tree is not kept, its source is below.

## Verdict

The Lean is sound and pure core: rebuilt with a probe, `Becoming.Blanket` has 13 theorems in 24 declarations and the probe 25 in 30, every axiom report empty, no warnings, every proof a term, no hypothesis unsatisfiable. `Blanketed` is a fair discrete, deterministic form of Friston's (2013) partition: sensory states not influenced by internal ones, active states not by external ones. But the module proves less than its text says, and as drafted explains nothing beyond landed laws: the join to the World is asserted (F1); a free energy is not a reading of the internal course (F2); the witness fixes one trivial internal law (F3); Law 1 is the known time-unrolled blanket and restates UE1 (F4); two existence laws are vacuous off the domain and the "only" is unproved (F5); the calibration's standing needs correcting (F6). The probe supplies the missing pieces: the agent driven by its sensory course alone, Law 2 for every model and policy, the sensory reading's lumping (03 §6), and the witness joined to the World's coupling by threshold. It can land after F1–F6; F7 and F8 are improvements.

## Findings

**F1 (O). The join to selection through couplings is not a theorem** (l. 13–15, 24–27, 33–36; NOTE §1, §3, §4; the board line). `reads_through_blanket` applies its hypothesis `reads` to `inner_alike_up_to`: function congruence. No declaration names `Web`, `Flow`, `SelectsThrough` or a law of 03 §1, and the module builds without `import Becoming.Runaway` with the same counts, so Law 2's World half is a citation. The plan's "every law of selection through couplings applies to them" and "one closure among several" are not delivered, and AGENTS.md asks new results to extend the spine rather than build another model. *Fix:* reword as "the analogue, on a determined law, of selection through couplings", or prove the join. For the witness it is cheap: the Drain's sensory part is the World's admission at need one (`sensory_is_admission`), and from one start its courses are blanket-alike before step `n + 2` exactly where the two supply histories are alike through the formation's couplings, by threshold only, up to `n` (`blanket_iff_through`). The general join, a World formation with a policy through its couplings as the agent of a blanketed law whose sensory course is its own course (`Web.selectsThrough_iff_prefix`), its environment the levels and step under the others' fixed exchange, is an item of its own; until it lands the record calls the reading text. Use the import or drop it.

**F2 (E). A free energy reads the sensory record, and the break is seen when it comes** (l. 24–27, 141–144, 186–188; NOTE §1, §2). A variational free energy is a function of the belief and the record, `F(μ, s)`, not among the readings `read : (Nat → I) → V`. At step four of the witness the sensory parts differ (false in the short course, true in the long) while the internal parts agree (`sensed_at_break`), so a free energy there separates the courses. What is alike is every reading of the internal course up to step four and of the internal and blanket courses before it; what goes unseen is the break *coming*, T6's wording, the threshold reading registering the break itself a step after the supply runs out. And the short course ends at the next step, five, not "the next step but one" (l. 188). *Fix:* "every reading of the internal and blanket courses before step four, a free energy of a belief given the sensory record among them" (or `reads_through_blanket` for readings of `(inner, sense, act)` agreeing before `n`); name Law 2 "self-evidencing does not see its break coming"; correct l. 188; list among what is left out that no free energy is defined here (UE17's is in the periphery).

**F3 (O). The witness shows nothing about self-evidencing** (l. 28–36, 157–192; NOTE §1–§3). `Drain.law` fixes the internal law `i && s`, has no action and no model, and its internal course is `true` to step four in both courses: `readings_alike` is a fact about a constant course, its generality all from `reads_through_blanket`. *Fix:* quantify over the model and the policy. With an internal part `Bool × M`, any `update : M → Bool → A → M` and any policy `Bool × M → Bool → A → A`, from a supply of three and from every supply of four or more, every reading of the internal course up to step four is alike, while at step five the first has ended and the second goes on (`AnyModel.any_model`; a free-energy-minimizing update among them). And state the law it instances: on every blanketed law whose sensory part reads the external part only through `π` (`Learning.Lumped π (b.sensory s a)`, 03 §6), two courses from one internal, sensory and active start whose external parts are alike through `π` before `n` have one internal, sensory and active part up to `n` (`through_reading`; the Drain reads through `Nat.blt 0`, `drain_reads_threshold`). Say that no action of the witness changes the supply, so persisting is not in its policy's gift (F7 (iv)).

**F4 (O). Law 1's standing and its overlap with UE1** (l. 7–10, 17–24; NOTE §1, §5). (a) "So internal and external states are independent given the blanket" (l. 8–9) does not follow in general for the blanket's present state at a steady state (Biehl, Pollock and Kanai 2021; Aguilera and others 2022). Sparse coupling gives independence given the blanket's *history*, the time-unrolled blanket (Virgo, Rosas and Biehl 2022), of which `internal_through_blanket` is the deterministic case; with random starts it gives conditional independence where the internal and external starts are independent given the blanket's start. (b) The sensory and active courses are Pearl's blanket of the internal course in the law's unrolled graph, while the partition is what Bruineberg and others (2022) call a Friston blanket: "Pearl's Markov blanket in dynamical form" should say which. (c) UE1 already calls this near-definitional (`ChoiceCountCapture`: sparse coupling "already says as much") and adds that an action must be listed among what couples in, a formation's own exchange not being among its couplings (03 §1). The analogue of the couplings is the sensory part alone: the internal and active parts are driven by the sensory course, the sensory and external parts by the active course (`agent_through_sensory`, `world_through_active`; `internal_through_blanket` follows, `internal_of_agent`), so a determined policy is a selection through the sensory course with no action listed. *Fix:* qualify l. 8–9 and l. 24; grade Law 1 "known (the time-unrolled blanket), deterministic case; near-definitional"; adopt the agent form; say what it adds to UE1.

**F5 (O). Two existence laws are vacuous off the domain, and the "only" is unproved** (l. 37–44, 202–268; NOTE §1, §2). `point_whole_share` and `least_surprise` hold for a course not listed, both shares `⟨0, 0⟩` (`point_off_domain`); listed, `least_surprise` says only that a share is at most the whole. The point weighting's content is that every event not holding at the course weighs nothing (`point_forbids_rest`) and the listed course something (`point_pos`). "A course forbidden outright needs a weighting fixed apart from it" claims a necessity; `unweighted_share` proves the sufficient direction, and the DESIGN's `read_off_admits` was not built. *Fix:* add `x ∈ l`; adopt `point_forbids_rest` and `point_pos`; prove the necessity: a listed state's share is nothing exactly where its weight is (`forbids_iff`), and the weighting read off a run gives every visited, listed state a positive share (`read_off_admits`). Give Ω one meaning: `point` and `isCourse` call it courses, `visits` states.

**F6 (O). The calibration of the existence claim** (l. 11–13, 37–44; NOTE §1, §4, §5). (a) The principle's density is the steady-state density of the system's own law, over states, not a weighting chosen per course. For a determined law the calibration is fair once it says so [AI reading, D45]: the path weighting from a start is the point weighting on its course; `point x` is the counting weighting restricted to the record of being `x` (`point_is_restrict`), so the model read off the course is conditioning on the course itself (03 §6's restriction, UE17's posterior); a steady state is a cycle's occupation weighting, which `visits` reads. "Fixed apart from it" then means a density of another law. (b) The witness has such a steady state: from step five the short course rests at its ended configuration, a fixed point (`short_rests`), where the partition is trivially a blanket (the long one from step 102, by simulation). So the claim's antecedent holds of the ended system, as of the principle's inert examples (candidate 15); saying so joins Law 3 to the blanketed law. (c) Andrews (2021) defends the principle as a formal structure whose content lies in the models it is construed with, not that its as-if reading is empty; its proponents class it with stationary action, "not falsifiable, strictly speaking" (Ramstead and others 2023, §2). "Forbids nothing alone" is conceded, not found; the critics' worry is breadth (Raja and others 2021; Bruineberg and others 2022). Nor is the antecedent empty: a blanket in the steady-state density holds only in a narrow region of weakly coupled linear systems (Aguilera and others 2022). *Fix:* state (a) and (b) in the header and NOTE; grade the law "known and conceded; near-definitional"; in NOTE §1 write "laws of the courses themselves, holding whatever weighting is put on them".

**F7 (I). What would make it explain more.** As drafted UE18 makes the blanket and the existence claim integral but states nothing beyond T6, 03 §1 and UE1; the record must say so. Within reach: (i) Law 1 in its agent form and `through_reading` on 03 §6's `Learning.Lumped`, making Law 2 a law of every blanketed agent; (ii) F1's World join, for the witness now and in general as its own item; (iii) placing the principle's anticipation: Kirchhoff and others (2018, §3.2) have adaptive active inference act "ahead of actuality" through a deep generative model, partly on priors shaped by selection (§3.3); by T6 and `through_reading`, for a supply coupled in by threshold only, that anticipation comes from such priors, a coupling by level or another formation, never from the blanket's course; (iv) a law the principle leaves open: under a threshold-reading policy that can raise the supply and keeps every supply from breaking, every reading stays true, so its actions are alike from every supply and it cannot spend a larger one (the blanket form of `Flow.policy_keeps_difference`; not probed); (v) the claim's average form, the weighting read off a course maximizing its likelihood (Gibbs, UE17's periphery; its counting form unproved there).

**F8 (S). Names, placement and coverage.** `Parts`' fields (`inner`, `sense`, `act`, `outer`) and `Blanketed`'s maps (`internal`, `sensory`, `active`, `external`) name the parts twice: use one set. Give the partition its relational basis in one sentence: four parts of one law, told apart by which reads which, no separate entities. `Drain` repeats the landed witness name `Optimum.Drain` (`ThresholdDrain`); `least_surprise` → `least_surprisal`. Count laws, not corollaries: `inner_alike_up_to`, `reads_through_blanket`, `readings_alike` and `point_whole_share` are one-line consequences. Record 1 (03 §1) should link 02's [runaway record](../../../../../../theories/becoming/chapters/02-MAP.md#r-runaway-distance-uncoupled) and [03 §10](../../../../../../theories/becoming/chapters/03-KNOWING.md#break-seen-coming), whose invisible half Law 2 restates; record 2's home (03 §6) fits `point_is_restrict`. NOTE §6 should list 08 §8's bullet (DESIGN §3) and the undelivered sparse-coupling witness; bring the plan's item 3 to what lands.

## Probe

`python3 -B scratch_build.py <tree> Becoming.Blanket Becoming.UE18ReviewProbe` from the package folder, the module byte-identical to the study's: Blanket 13 theorems in 24 declarations, the probe 25 in 30, every axiom report empty, no warnings. Without `import Becoming.Runaway` the module builds with the same counts (58 modules in its closure, not 59).

```lean
import Becoming.Blanket

/-! Review probe for UE18: not for landing. -/

namespace Becoming

namespace UE18ReviewProbe

open Blanket ConditionalWeights

universe u

/-- Three equalities give one equality of a three-place map. -/
theorem congr3 {α β γ δ : Sort _} (f : α → β → γ → δ) {a a' : α} {b b' : β} {c c' : γ}
    (ha : a = a') (hb : b = b') (hc : c = c') : f a b c = f a' b' c' :=
  match ha, hb, hc with
  | rfl, rfl, rfl => rfl

/-! ## P1. The agent is driven by its sensory course alone, the world by its active course alone -/

section Agent

variable {I S A E : Type u} (b : Blanketed I S A E)

/-- Two courses from one internal and one active state, alike on the sensory part before `n`,
have one internal and one active state at `n`. -/
theorem agent_through_sensory {x y : Parts I S A E} (inner : x.inner = y.inner)
    (act : x.act = y.act) :
    ∀ n, (∀ k, k < n → (b.course x k).sense = (b.course y k).sense) →
      (b.course x n).inner = (b.course y n).inner ∧ (b.course x n).act = (b.course y n).act
  | 0, _ => ⟨inner, act⟩
  | n + 1, alike =>
    match agent_through_sensory inner act n (fun k lt => alike k (Nat.lt_succ_of_lt lt)) with
    | ⟨i, a⟩ =>
      ⟨congr3 b.internal i (alike n (Nat.lt_succ_self n)) a,
       congr3 b.active i (alike n (Nat.lt_succ_self n)) a⟩

/-- Two courses from one sensory and one external state, alike on the active part before `n`,
have one sensory and one external state at `n`. -/
theorem world_through_active {x y : Parts I S A E} (sense : x.sense = y.sense)
    (outer : x.outer = y.outer) :
    ∀ n, (∀ k, k < n → (b.course x k).act = (b.course y k).act) →
      (b.course x n).sense = (b.course y n).sense ∧ (b.course x n).outer = (b.course y n).outer
  | 0, _ => ⟨sense, outer⟩
  | n + 1, alike =>
    match world_through_active sense outer n (fun k lt => alike k (Nat.lt_succ_of_lt lt)) with
    | ⟨s, e⟩ =>
      ⟨congr3 b.sensory s (alike n (Nat.lt_succ_self n)) e,
       congr3 b.external s (alike n (Nat.lt_succ_self n)) e⟩

/-- `internal_through_blanket` is a corollary: the active part's agreement after the start
follows from the internal and sensory parts. -/
theorem internal_of_agent {x y : Parts I S A E} (start : x.inner = y.inner) :
    ∀ n, b.BlanketAlike x y n → (b.course x n).inner = (b.course y n).inner
  | 0, _ => start
  | n + 1, alike =>
    (agent_through_sensory b start (alike 0 (Nat.succ_pos n)).2 (n + 1)
      fun k lt => (alike k lt).1).1

/-! ## P3. Through what the sensory part reads of the external part (03 §6's lumping) -/

/-- Where the sensory part reads the external part only through `π`, two courses from one
internal, sensory and active state whose external parts are alike through `π` before `n` have one
internal, sensory and active state at `n`. -/
theorem through_reading {P : Type} (π : E → P)
    (reads : ∀ s a, Learning.Lumped π (b.sensory s a)) {x y : Parts I S A E}
    (inner : x.inner = y.inner) (sense : x.sense = y.sense) (act : x.act = y.act) :
    ∀ n, (∀ k, k < n → π (b.course x k).outer = π (b.course y k).outer) →
      (b.course x n).inner = (b.course y n).inner ∧ (b.course x n).sense = (b.course y n).sense ∧
        (b.course x n).act = (b.course y n).act
  | 0, _ => ⟨inner, sense, act⟩
  | n + 1, alike =>
    match through_reading π reads inner sense act n
        (fun k lt => alike k (Nat.lt_succ_of_lt lt)) with
    | ⟨i, s, a⟩ =>
      ⟨congr3 b.internal i s a,
       (reads (b.course x n).sense (b.course x n).act _ _ (alike n (Nat.lt_succ_self n))).trans
         (congr3 b.sensory s a rfl),
       congr3 b.active i s a⟩

end Agent

/-- The Drain's sensory part reads the supply only through the threshold. -/
theorem drain_reads_threshold (s : Bool) (a : Unit) :
    Learning.Lumped (Nat.blt 0) (Drain.law.sensory s a) :=
  fun _ _ same => same

/-! ## P1b. A reading through the blanket separates at most what it tells apart -/

/-- An internal part that reads nothing. -/
def deaf : Blanketed Unit Bool Unit Bool where
  internal _ _ _ := ()
  sensory _ _ e := e
  active _ _ _ := ()
  external _ _ e := e

theorem deaf_lumps :
    ¬ deaf.BlanketAlike ⟨(), true, (), true⟩ ⟨(), false, (), false⟩ 1 ∧
      ∀ n, (deaf.course ⟨(), true, (), true⟩ n).inner =
        (deaf.course ⟨(), false, (), false⟩ n).inner :=
  ⟨fun alike => Bool.noConfusion (show true = false from (alike 0 Nat.zero_lt_one).1),
   fun _ => rfl⟩

/-! ## P2. The Drain with any model and any policy, from any larger supply -/

namespace AnyModel

variable {M A : Type} (update : M → Bool → A → M) (policy : Bool × M → Bool → A → A)

/-- The internal part is whether the system goes on with a model `M` updated from what it senses
and does; the active part is any policy; the supply drains by one each step. -/
def law : Blanketed (Bool × M) Bool A Nat where
  internal i s a := (i.1 && s, update i.2 s a)
  sensory _ _ e := Nat.blt 0 e
  active i s a := policy i s a
  external _ _ e := e - 1

/-- Going on, with model `m`, act `a` and a supply. -/
def start (m : M) (a : A) (supply : Nat) : Parts (Bool × M) Bool A Nat :=
  ⟨(true, m), true, a, supply⟩

theorem sensed_alike (m : M) (a : A) (d : Nat) : ∀ k, k < 4 →
    ((law update policy).course (start m a 3) k).sense =
      ((law update policy).course (start m a (d + 4)) k).sense
  | 0, _ => rfl
  | 1, _ => rfl
  | 2, _ => rfl
  | 3, _ => rfl
  | k + 4, lt => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 4 k))

theorem blanket_alike (m : M) (a : A) (d : Nat) :
    (law update policy).BlanketAlike (start m a 3) (start m a (d + 4)) 4 :=
  fun k lt => ⟨sensed_alike update policy m a d k lt,
    (agent_through_sensory (law update policy) (x := start m a 3) (y := start m a (d + 4)) rfl rfl
      k fun j lt' => sensed_alike update policy m a d j (Nat.lt_trans lt' lt)).2⟩

/-- **Whatever the model and the policy**, every reading of the internal course up to step four is
alike from a supply of three and from every supply of four or more, while at step five the first
has ended and the second goes on. -/
theorem any_model (m : M) (a : A) (d : Nat) {V : Type} (read : (Nat → Bool × M) → V)
    (reads : ∀ f g : Nat → Bool × M, (∀ k, k ≤ 4 → f k = g k) → read f = read g) :
    read (fun k => ((law update policy).course (start m a 3) k).inner) =
        read (fun k => ((law update policy).course (start m a (d + 4)) k).inner) ∧
      ((law update policy).course (start m a 3) 5).inner.1 = false ∧
      ((law update policy).course (start m a (d + 4)) 5).inner.1 = true :=
  ⟨(law update policy).reads_through_blanket read reads rfl (blanket_alike update policy m a d),
   rfl,
   match d with
   | 0 => rfl
   | _ + 1 => rfl⟩

end AnyModel

/-! ## P4. `point_whole_share` and `least_surprise` off the domain -/

/-- On the domain `[1]`, the weighting on `0`, not listed, gives the event of being `0` the share
`⟨0, 0⟩`, which `point_whole_share` calls the whole share. -/
theorem point_off_domain :
    share [1] (point (0 : Nat)) (isCourse 0) = ⟨0, 0⟩ ∧
      (share [1] (point (0 : Nat)) (isCourse 0)).Same Share.one ∧
      ∀ e, (share [1] (point (0 : Nat)) e).le (share [1] (point 0) (isCourse 0)) :=
  ⟨rfl, point_whole_share 0 [1], fun e => least_surprise 0 [1] e⟩

/-! ## P5. What the point weighting says: every event off the course weighs nothing -/

/-- A listed entry meeting an event weighs at most the event's mass. -/
theorem le_mass_of_mem {Ω : Type u} {w : Ω → Nat} {e : Ω → Bool} {x : Ω} (holds : e x = true) :
    ∀ {l : List Ω}, x ∈ l → w x ≤ mass l w e
  | _, .head _ => Nat.le_trans (Nat.le_of_eq (if_pos holds).symm) (Nat.le_add_right _ _)
  | _, .tail _ mem => Nat.le_trans (le_mass_of_mem holds mem) (Nat.le_add_left _ _)

section Weights

variable {Ω : Type u} [DecidableEq Ω]

/-- Under the weighting on `x`, an event not holding at `x` weighs nothing. -/
theorem point_forbids_rest (x : Ω) {e : Ω → Bool} (off : e x = false) :
    ∀ l : List Ω, (share l (point x) e).part = 0
  | [] => rfl
  | y :: l =>
    have head : (if e y = true then point x y else 0) = 0 :=
      match decEq y x with
      | isTrue same =>
        if_neg fun h : e y = true =>
          Bool.noConfusion (off.symm.trans ((congrArg e same).symm.trans h))
      | isFalse other =>
        match decEq (e y) true with
        | isTrue h => (if_pos h).trans (if_neg other)
        | isFalse h => if_neg h
    (congrArg (· + mass l (point x) e) head).trans
      ((Nat.zero_add _).trans (point_forbids_rest x off l))

/-- Under the weighting on a listed `x`, the event of being `x` weighs something. -/
theorem point_pos {x : Ω} {l : List Ω} (mem : x ∈ l) :
    0 < (share l (point x) (isCourse x)).part :=
  Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le Nat.zero_lt_one (Nat.le_of_eq (if_pos rfl).symm))
    (le_mass_of_mem (w := point x) (e := isCourse x) (decide_eq_true rfl) mem)

/-! ## P6. Forbidding a listed state is weighing it nothing; the read-off weighting never does -/

theorem forbids_iff {w : Ω → Nat} {x : Ω} {l : List Ω} (mem : x ∈ l) :
    (share l w (isCourse x)).part = 0 ↔ w x = 0 :=
  ⟨fun zero => Nat.eq_zero_of_le_zero
      (Nat.le_trans (le_mass_of_mem (w := w) (e := isCourse x) (decide_eq_true rfl) mem)
        (Nat.le_of_eq zero)),
   fun zero => unweighted_share w x zero l⟩

theorem read_off_admits (r : Nat → Ω) {n k : Nat} (lt : k < n) {l : List Ω} (mem : r k ∈ l) :
    0 < (share l (visits r n) (isCourse (r k))).part :=
  Nat.lt_of_lt_of_le (visits_pos r n k lt)
    (le_mass_of_mem (w := visits r n) (e := isCourse (r k)) (decide_eq_true rfl) mem)

/-- The weighting on `x` is the counting weighting restricted to the record of being `x`: read
off the course, the existence claim's model is conditioning on the course itself. -/
theorem point_is_restrict (x y : Ω) :
    point x y = ConditionalWeights.restrict (isCourse x) (fun _ => 1) y :=
  match decEq y x with
  | isTrue same =>
    (if_pos same).trans (if_pos (decide_eq_true same : isCourse x y = true)).symm
  | isFalse other =>
    (if_neg other).trans
      (if_neg (fun h : isCourse x y = true => other (of_decide_eq_true h))).symm

end Weights

/-! ## P7. The ended Drain rests: a steady state of its law -/

/-- The ended configuration. -/
def ended : Parts Bool Bool Unit Nat := ⟨false, false, (), 0⟩

theorem ended_rests : Drain.law.step ended = ended := rfl

theorem short_rests : ∀ n, Drain.law.course Drain.short (n + 5) = ended
  | 0 => rfl
  | n + 1 => (congrArg Drain.law.step (short_rests n)).trans ended_rests

/-! ## P8. The sensory part sees the break when it comes; the Drain's blanket is the World's
coupling by threshold -/

/-- At step four the sensory part has registered the break in the short course and not in the
long one, while the internal parts are alike: a free energy reading the sensory record there
separates them. -/
theorem sensed_at_break :
    (Drain.law.course Drain.short 4).sense = false ∧ (Drain.law.course Drain.long 4).sense = true ∧
      (Drain.law.course Drain.short 4).inner = (Drain.law.course Drain.long 4).inner :=
  ⟨rfl, rfl, rfl⟩

/-- The Drain's supply read as a web: the one formation requires the one condition at need one. -/
def drainWeb : Web Unit Unit :=
  ⟨fun _ _ => 0, fun _ _ => True, fun _ _ _ => True, fun _ _ _ => 1, fun _ _ _ => True⟩

/-- The Drain's sensory part is the World's admission at need one. -/
theorem sensory_is_admission (s : Bool) (a : Unit) (e t : Nat) :
    drainWeb.Admits (fun _ => e) t () ↔ Drain.law.sensory s a e = true :=
  ⟨fun admits => Nat.ble_eq_true_of_le (admits () trivial),
   fun reads _ _ => Nat.le_of_ble_eq_true reads⟩

theorem outer_course (x : Parts Bool Bool Unit Nat) :
    ∀ s, (Drain.law.course x s).outer = x.outer - s
  | 0 => rfl
  | s + 1 => congrArg (· - 1) (outer_course x s)

theorem sense_succ (x : Parts Bool Bool Unit Nat) (s : Nat) :
    (Drain.law.course x (s + 1)).sense = Nat.blt 0 (x.outer - s) :=
  congrArg (Nat.blt 0) (outer_course x s)

theorem bool_eq_of_iff : ∀ {b b' : Bool}, (b = true ↔ b' = true) → b = b'
  | true, true, _ => rfl
  | false, false, _ => rfl
  | true, false, h => Bool.noConfusion (h.1 rfl)
  | false, true, h => Bool.noConfusion (h.2 rfl)

/-- **The Drain's blanket is the World's coupling by threshold.** From one internal and sensory
start, the courses from two supplies are alike on the blanket before step `n + 2` exactly where the
two supply histories are alike through the formation's couplings, by threshold only, up to `n`. -/
theorem blanket_iff_through (e e' n : Nat) :
    Drain.law.BlanketAlike ⟨true, true, (), e⟩ ⟨true, true, (), e'⟩ (n + 2) ↔
      drainWeb.AlikeThroughUpTo (fun _ _ => False) () (fun t _ => e - t) (fun t _ => e' - t) n :=
  ⟨fun alike s le =>
    have same : Nat.blt 0 (e - s) = Nat.blt 0 (e' - s) :=
      (sense_succ ⟨true, true, (), e⟩ s).symm.trans
        ((alike (s + 1) (Nat.succ_lt_succ (Nat.lt_succ_of_le le))).1.trans
          (sense_succ ⟨true, true, (), e'⟩ s))
    ⟨((sensory_is_admission true () (e - s) s).trans
        ⟨fun h => same.symm.trans h, fun h => same.trans h⟩).trans
        (sensory_is_admission true () (e' - s) s).symm,
     fun _ never => never.elim⟩,
   fun through k lt => match k, lt with
    | 0, _ => ⟨rfl, rfl⟩
    | s + 1, lt =>
      ⟨(sense_succ ⟨true, true, (), e⟩ s).trans
        ((bool_eq_of_iff
          (((sensory_is_admission true () (e - s) s).symm.trans
            (through s (Nat.le_of_lt_succ (Nat.lt_of_succ_lt_succ lt))).1).trans
            (sensory_is_admission true () (e' - s) s))).trans
          (sense_succ ⟨true, true, (), e'⟩ s).symm),
       rfl⟩⟩

end UE18ReviewProbe

end Becoming
```

## Sources added

- Virgo, N., Rosas, F. E., and Biehl, M. (2022). Embracing sensorimotor history: time-synchronous and time-unrolled Markov blankets in the free-energy principle. Behavioral and Brain Sciences 45, e215.
- Ramstead, M. J. D., and others (2023). On Bayesian mechanics: a physics of and by beliefs. Interface Focus 13, 20220029.
