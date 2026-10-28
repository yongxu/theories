# UE15 review: `Becoming.ReorderingGrowth` and its note

28 October 2026. AI-written independent review for board item UE15. Read: the module [tree/Becoming/ReorderingGrowth.lean](tree/Becoming/ReorderingGrowth.lean) (SHA-1 `6b4795bc99f5`), [NOTE.md](NOTE.md) (SHA-1 `e3693baed361`), [DESIGN.md](DESIGN.md) and [DRAFT-NOTES.md](DRAFT-NOTES.md), against the package's `Presence`, `CausalGrowth`, `Reordering`, `OrderNormal` and `Decidedness`, the records `order-of-exchanges-is-the-invariant` and `the-present-on-causal-set-growth`, and 01 §1 and §9.6. The module was rebuilt from a copy in a separate tree, with a probe module beside it (source in the appendix): the module has 49 theorems in 60 declarations and the probe 11 in 15, every axiom report empty, nothing unclean. Line numbers are as read; the landing kit, which another session is still writing, is cited by content as well.

## Verdict

The Lean is sound and pure core. Its only tactics act on closed goals: `decide` on numerals and on `place` of literal lists, and `subst` and `rcases` on equations. There is no `simp`, `omega`, `funext`, `by_cases` or classical step, and the rebuilt audit is empty. Each statement says what its docstring says, except for one hypothesis a docstring leaves out (F4) and one docstring that says more than its theorem (`natural_iff_vee`, F2). Each transfer composes the right UE14 law with that law's own decision and bounds. `Reordering` is not satisfied so trivially that a law is emptied: the empty list is always a reordering, so every law on every reordering covers the world as it is, and the laws on some reordering are UE14's constructions carried back by `natural_reordering`. The witnesses are the worlds their docstrings describe. The note states the representation and the laws of presence exactly, with one error to fix before landing: it reads the gap between persistence and presence as dependence, and a probe world with no dependence and the least footprint has persistence without presence (F1). The headline that a world's reorderings are the courses of growth should be stated of numberings (F2). With F1 and F2 fixed, the module and note can land; the rest are improvements and style.

## Findings

**F1 (E). The gap between persistence and presence is not dependence.**
*Where.* Module header lines 61–62 ("the gap is the dependence reading of joining"). NOTE line 14 (the converse "fails only through dependence … So presence on the World is persistence together with no dependence between"), line 52 (last sentence), line 63 ("the gap being dependence"), line 74 ("where something between depends on what it touched") and line 80 ("and the gap as dependence"). The kit repeats the claim: kit/study_ue15.txt, Readings ("So presence on the World is persistence with no dependence between"), and the regions note in kit/texts_ue15.py ("not conversely (dependence)"). DESIGN.md line 14 is the historical design and can stay.
*What the Lean says.* `ByDependence.persists_not_present` gives one world in which the exchange that ends presence is joined to the first through a dependence. It says nothing about other ways the two can come apart.
*Counterexample (probe, `UE15Probe.Restored.persists_not_present`).* Four steps, each touching only the relatum `0`, which rises, rises, falls back and rises. No relatum requires another. The footprint touches only what moves (`touches_moved`), so it is the least footprint containing the exchanges. The relatum `0` is shown when step 3 is taken as it was right after step 0, yet on no reordering of the four steps is exchange 0 present when exchange 3 is taken. A footprint may also touch a relatum it does not move, since `Contains` constrains only untouched relata. With every step touching every relatum (`Footprinted.contains_everything`), every two exchanges are joined wherever there is a relatum at all, and presence on the world as it is holds only between consecutive steps, whatever persists.
*What is exact (probe, `present_identity_iff`).* On the world as it is, an exchange is present when another is taken exactly where it precedes it and no exchange between is joined to it. Persistence follows because no exchange between touches what it touched. The gap is every way of being joined that leaves what it touched as it was: a dependence, a touch that does not move it, or moving it and moving it back.
*Fix.* The minimal version follows; with F3, cite `present_identity_iff` and the landed witness instead of the probe.
- Header lines 61–62: "So presence at a step is stronger than persistence: an exchange between can end presence without moving what the earlier one touched, here through a dependence."
- NOTE line 14, from "on the world as it is" to the end: "on the world as it is, presence gives persistence of everything the exchange touched, and the converse fails wherever an exchange between is joined to it yet leaves what it touched as it was: through a dependence, through a touch that does not move it, or by moving it and moving it back. So what presence adds to persistence is that nothing between is joined to the earlier exchange, and what every reordering keeps of it is the one link, as on causal-set growth."
- NOTE line 52, last sentence: "So presence at a step is stronger than persistence. Dependence is one source of the gap; another is an exchange between that moves what the first touched and moves it back, with no dependence and the least footprint (review probe `Restored`)."
- NOTE line 63: "…; persistence does not give presence, since an exchange between can be joined to it without leaving a trace on what it touched."
- NOTE line 74: replace "where something between depends on what it touched" with "where an exchange between is joined to it without leaving a trace on what it touched, through a dependence for instance".
- NOTE line 80: delete ", and the gap as dependence,".

**F2 (O). The representation matches numberings; it does not identify reorderings with courses.**
*Where.* Header lines 13–15 and 25–26 (bold); the `reorderings_are_courses` docstring, line 136; the `natural_iff_vee` docstring, line 754 ("its reorderings are the courses growing the vee", which that theorem does not state); NOTE lines 8 and 61; the kit's record statement (kit/make_records_ue15.py, "A world's reorderings of a stretch are the courses of growth…") and two texts in kit/texts_ue15.py.
*What the Lean says.* Where the footprint contains the exchanges, take `π` renumbering the stretch. Three things are equivalent: `π` is the numbering of some reordering; it is a natural labelling of `exchanges r m`; and some course from the empty set relabels `exchanges r m` onto its configuration at size `m` by `π`. So the correspondence is between numberings, each paired with a course and a relabelling, and it is many-to-one both ways. Reorderings that give one numbering agree over the stretch (`Footprinted.reorder_determined`), which is harmless. One course carries several numberings wherever the order has automorphisms. The probe's `one_course_two_reorderings` shows this in `VeeWorld`: the world as it is (`place []`) and the reordering `[1]` are numberings by one and the same course, the two later births matched to the two later exchanges the other way round. So `VeeWorld.presence_varies` varies the matching, not the course.
*Fix.* Write "the numberings a world's reorderings give a stretch are exactly the orders of birth of the courses of growth of its order of exchanges" in each place: header 13–15 and 25–26, docstring 136, NOTE 8 and 61, and the kit's record statement and texts. Add at NOTE line 8: "The correspondence is between numberings: reorderings giving one numbering agree over the stretch (`Footprinted.reorder_determined`), and one course carries several numberings where the order has automorphisms." For the `natural_iff_vee` docstring: "So its natural labellings are the vee's." UE14's wording ("on one course and not on another") has the same looseness, but its Lean carries the relabelling, so nothing landed is wrong.

**F3 (I). Add the law that "what presence means on the World" needs.** The probe's `first_of_precedes` and `present_identity_iff`, both with empty axiom reports, state presence on the world as it is exactly, and `present_persists` then reads as their consequence for touched relata. Adding the probe's `Restored` world as well (perhaps named `MovedBack`) lets the corrected texts of F1 cite a landed witness with no dependence and the least footprint. The source is in the appendix; it uses `Witnesses.emptyFlow` (F7).

**F4 (O). `course_converse` needs `r₂.Contains`, and the texts omit it.**
*Where.* Docstring lines 192–198, header lines 29–31, NOTE lines 8 ("A world taking the same exchanges…") and 30.
*Fix.* Docstring: "Where both footprints contain the exchanges and `r₂` takes across step `π i` …". NOTE line 30: "A world whose footprint contains its exchanges, taking across step `π i` …". Header and NOTE line 8: "a world whose footprint contains its exchanges, taking the same exchanges in the order of a course, …".

**F5 (O). What happens to the forms with no decision of UE14's `Decidable` laws.**
*Where.* NOTE line 46 ("Their no-decision forms reach the World through `every_reordering_iff`") and line 62 ("UE14's laws of presence hold on the World's reorderings by instance"); the Decisions in LANDING.md and kit/study_ue15.txt repeat the first.
*What holds.* The four laws are correctly reported as not instanced: a Prop-valued `Decided` cannot give `Decidable` data constructively. Of their forms with no decision, `every_iff_not_not` and `present_every_iff_only_link` are instanced. `together_every_iff_not_not` reaches the World through `every_reordering_iff` but is not stated. `past_every_iff` has no such form in UE14.
*Fix.* Add the probe's `together_every_reordering_not_not`: two exchanges of the stretch are present together on every reordering exactly where, doubly negated, they precede the same exchanges of the stretch. Both bounds of present together are then on the World, as both bounds already are for taken before and for presence when taken. Then write at line 46: "Of their forms with no decision, `every_iff_not_not`, `together_every_iff_not_not` and `present_every_iff_only_link` are instanced (`every_reordering_not_not`, `together_every_reordering_not_not`, `present_every_reordering`); `past_every_iff` has none in UE14." At line 62: "UE14's main laws of presence (taken before, the present as an antichain, present together, presence when taken) hold on the World's reorderings by instance, each with exactly its decision." Without the lemma, write "… `together_every_iff_not_not` reaches the World through `every_reordering_iff` but is not stated", and leave present together on every reordering out of line 62.

**F6 (S). State the representation with the module's own `Reordering`.**
*Where.* Lines 142–153. The left side is spelled `EachStep (fun t => 0 ≤ t ∧ t + 2 ≤ 0 + m) ts ∧ r.Independent ts ∧ ∀ i, 0 ≤ i → i < 0 + m → …`. That is `Reordering r m ts` with offsets, so the theorem reads neither as its docstring nor as `natural_reordering`.
*Fix.* The probe's `reordering_iff_course` states it as `(∃ ts, Reordering r m ts ∧ ∀ i, i < m → place ts i = π i) ↔ NaturalLabelling (exchanges r m) π σ`, and `↔ ∃ run …`, proved directly from `natural_iff`, `Independent.keeps` and `natural_reordering`. The hypothesis `reindex` stays, because the left side does not mention `σ`. The name follows UE14's `natural_iff_course` and states the theorem, whereas `reorderings_are_courses` states F2's slogan. The record id `reorderings-are-courses-of-growth` repeats the slogan; `reorderings-as-courses-of-growth` would match the record's title.

**F7 (I). `emptyFlow` duplicates `Witnesses.emptyFlow`.**
*Where.* Lines 550–555, used at lines 598 and 688. `Witnesses.emptyFlow F C`, in `Becoming.Witnesses` inside the closure, is the same flow. The probe's `Restored.world` uses `Witnesses.emptyFlow Nat Nat`, and its `contains` proof (`fun h => nomatch h`) needed no change.
*Fix.* Delete `emptyFlow` and write `⟨Witnesses.emptyFlow Nat Nat, web, touch⟩` in both worlds. Recount: 49 theorems in 59 declarations, before F3's and F5's additions. The record's declaration list drops `emptyFlow`.

**F8 (S). Where Mazurkiewicz's theorem is read on the World.** Header lines 12–13 credit `Becoming.Reordering` with a reading of the core's `rearranges_iff`. But `Reordering` proves `sorts_iff` by its own bubble sort; the reading of `rearranges_iff` on the World is OrderNormal's `Footprinted.rearranges_iff_independent`. Write: "Each reads Mazurkiewicz's theorem on its side: on the World as `Footprinted.sorts_iff` and, from the core's `rearranges_iff`, as `Footprinted.rearranges_iff_independent`; on growth as `Presence.rearranges_iff_natural`."

**F9 (S). Names and one docstring.** `present_persists` and `present_persists_reordering` say that presence persists, but what persists is what the exchange touched. The package's pattern (`link_of_present`) gives `persists_of_present` and `persists_of_present_reordering`, which sit well beside the witness `persists_not_present`. Lines 472–473: "and below no other exchange of the stretch" can be read as "precedes no other"; write "and a link below no other exchange of the stretch". Rename at claim time, if at all.

**F10 (S). The placement list.** NOTE line 86 lists `place_within`, `origin_within` and `reindexes_of_within` as Reordering's; they are OrderNormal's. The module also uses `le_dest` (Prelude), `Run` (Frame) and `Presence.Vee.vee`, which the list omits.

**F11 (I). Standing and literature.** The trace-theory claims are cited at the right strength. That the linear extensions of a trace's dependence order are its interleavings is standard (Mazurkiewicz 1977; The Book of Traces, 1995), and configurations as down-closed sets are Nielsen, Plotkin and Winskel's notion. The other half of the composition is Rideout and Sorkin's own: natural labellings are linear extensions, read as the paths of sequential growth to a causal set (Physical Review D 61, 024002, 2000, already cited by UE14). Add it at NOTE line 80, and say that the composition follows at once from these two standard facts. A light search by the review found no paper connecting traces with causal-set growth, so "was not searched" can become "a light search found none".

**F12 (S). One phrase in the readings.** NOTE line 74: "the World's step index, a choice among interleavings, carries no more of presence than that" can be read as saying that the index carries no presence at all. In fact it fixes presence on its own interleaving (`VeeWorld.presence_varies`). Write: "and which presence holds between the two bounds is the choice of interleaving the step index makes."

## Checked and found exact

- `present_every_reordering`: "the one exchange of the stretch it is linked to" is exact. The quantifier ranges over `k < m`. Below an exchange of the stretch, links in `r.Precedes` are links in the stretch's causal set (`links_exchanges`), since everything between lies below it. Links to exchanges beyond the stretch rightly do not count, because `PresentAt` on `exchanges r m` reads only the stretch.
- Each law of presence has exactly the decision of its UE14 law:
  - none for `every_reordering_not_not` and `present_every_reordering`;
  - the pair decided for `precedes_iff_every_reordering`, or joining decided through `precedes_decided`;
  - precedence weakly decided on the stretch for the laws on some reordering, made global by `exchanges_weakly`.
  The bounds `hi` and `hj` are UE14's.
- The decisions. `precedes_decided_below` and `precedes_weakly_below` recurse on a bound, search with `Decided.exists_below` and `Presence.weakly_exists_below`, and close with `last_of_precedes`. The weak combination uses only ¬¬A and ¬¬B to conclude ¬¬(A ∧ B).
- The witnesses.
  - `ByDependence` touches `{0}`, `{1}`, `{0}`. The relatum `1` requires `0` at every step with need one. `0` stands at 1, 2, 2, 3 and `1` at 0, 0, 1, 1. The footprint contains the exchanges, the dependence is met, and the middle exchange touches nothing the first touches.
  - `VeeWorld` touches `{0, 1}`, `{0}`, `{1}`, with no dependence. `[1]` is a reordering, and `place [1]` takes the later two exchanges to steps 2 and 1.
  - In `ByDependence`, as in `Restored`, every two exchanges are joined, so the only reordering is the empty list and "on no reordering" means "not on the world as it is". This is true, and worth a clause in the note.
- `course_converse`, `reordering_natural`, `natural_reordering` and the stretch lemmas compose `Footprinted.converse`, `Independent.keeps`, `sorts` and `natural_iff_course`, with the offsets `0 + m` handled by `Presence.lt_zero_add` and no function extensionality.

## Appendix: the probe

Built from the package with `python3 -B scratch_build.py <tree> Becoming.ReorderingGrowth Becoming.UE15Probe`, the tree holding a byte-identical copy of the module and this file as `Becoming/UE15Probe.lean`: `Becoming.ReorderingGrowth` 49 theorems in 60 declarations, `Becoming.UE15Probe` 11 in 15, every axiom report empty, nothing unclean.

```lean
import Becoming.ReorderingGrowth

/-! Review probe for UE15 (not for landing): checks on `Becoming.ReorderingGrowth`. -/

namespace Becoming

namespace UE15Probe

open ReorderingGrowth
open CausalGrowth (Causet links process empty)
open Presence (NaturalLabelling MaximalBorn PresentAt)

variable {X : Type}

/-- The first link: where one exchange precedes another, it is joined to an exchange after it and
no later than the other. -/
theorem first_of_precedes {r : Footprinted X} : ∀ {i k : Nat}, r.Precedes i k →
    ∃ k', i < k' ∧ k' ≤ k ∧ r.Joined i k'
  | _, _, .joined lt link => ⟨_, lt, Nat.le_refl _, link⟩
  | _, _, .trans first second => match first_of_precedes first with
    | ⟨k', lt, le, link⟩ => ⟨k', lt, Nat.le_trans le (Nat.le_of_lt second.lt), link⟩

/-- Presence on the world as it is: the exchange across `i` is present when that across `j` is
taken exactly where it precedes it within the stretch and no exchange between is joined to it. -/
theorem present_identity_iff {r : Footprinted X} {m i j : Nat} :
    PresentAt (exchanges r m) (fun k => k) i j ↔
      (i < m ∧ j < m ∧ r.Precedes i j) ∧ ∀ k, i < k → k < j → ¬ r.Joined i k :=
  ⟨fun ⟨pair, after⟩ => ⟨pair, fun k lo hk link =>
      Nat.not_le_of_lt hk (after k ⟨pair.1, Nat.lt_trans hk pair.2.1, .joined lo link⟩)⟩,
   fun ⟨pair, apart⟩ => ⟨pair, fun k ⟨_, _, p⟩ => match Nat.lt_or_ge k j with
     | .inr ge => ge
     | .inl lt => match first_of_precedes p with
       | ⟨k', lo, le, link⟩ => absurd link (apart k' lo (Nat.lt_of_le_of_lt le lt))⟩⟩

/-- The representation stated with `Reordering`, under the name of UE14's `natural_iff_course`. -/
theorem reordering_iff_course {r : Footprinted X} {m : Nat} {π σ : Nat → Nat}
    (contains : r.Contains) (reindex : Reindexes 0 m π σ) :
    ((∃ ts, Reordering r m ts ∧ ∀ i, i < m → place ts i = π i) ↔
      NaturalLabelling (exchanges r m) π σ) ∧
    ((∃ ts, Reordering r m ts ∧ ∀ i, i < m → place ts i = π i) ↔
      ∃ run : Run process, run.state 0 = empty ∧
        CausalGrowth.Kinds.Relabels (exchanges r m) (run.state m) π σ) :=
  have reached : (∃ ts, Reordering r m ts ∧ ∀ i, i < m → place ts i = π i) ↔
      NaturalLabelling (exchanges r m) π σ :=
    ⟨fun ⟨ts, reordering, places⟩ => natural_iff.mpr ⟨reindex,
       fun i j _ below lt link =>
         Eq.subst (motive := fun v => v < π j)
           (places i (Nat.lt_trans lt (Presence.of_lt_zero_add below)))
           (Eq.subst (motive := fun v => place ts i < v) (places j (Presence.of_lt_zero_add below))
             (Footprinted.Independent.keeps contains reordering.2 lt link))⟩,
     natural_reordering contains⟩
  ⟨reached, reached.trans (Presence.natural_iff_course (exchanges_ordered r m))⟩

/-- Present together on every reordering, with no decision: exactly where, doubly negated, the two
precede the same exchanges of the stretch (`Presence.together_every_iff_not_not`). -/
theorem together_every_reordering_not_not {r : Footprinted X} {m : Nat} (contains : r.Contains)
    {x y : Nat} (hx : x < m) (hy : y < m) :
    (∀ ts, Reordering r m ts → ∃ t, MaximalBorn (exchanges r m) (place ts) t x ∧
        MaximalBorn (exchanges r m) (place ts) t y) ↔
      ∀ k, k < m → (r.Precedes x k → ¬ ¬ r.Precedes y k) ∧ (r.Precedes y k → ¬ ¬ r.Precedes x k) :=
  (every_reordering_iff contains
      (Φ := fun π => ∃ t, MaximalBorn (exchanges r m) π t x ∧ MaximalBorn (exchanges r m) π t y)
      (fun π π' same ⟨t, fx, fy⟩ => ⟨t, maximalBorn_stretch π π' same fx,
        maximalBorn_stretch π π' same fy⟩)).symm.trans
    ((Presence.together_every_iff_not_not (exchanges_ordered r m) hx hy).trans
      ⟨fun same k hk => ⟨fun p nq => (same k).1 ⟨hx, hk, p⟩ fun q => nq q.2.2,
         fun q np => (same k).2 ⟨hy, hk, q⟩ fun p => np p.2.2⟩,
       fun same k => ⟨fun ⟨_, hk, p⟩ nq => (same k hk).1 p fun q => nq ⟨hy, hk, q⟩,
         fun ⟨_, hk, q⟩ np => (same k hk).2 q fun p => np ⟨hx, hk, p⟩⟩⟩)

/-! ### Persistence without presence, with no dependence and the least footprint -/

namespace Restored

/-- The relatum `0` rises across the first two of four steps, falls back across the third and
rises across the fourth. -/
def standing : Nat → Nat → Nat
  | 0, _ => 0
  | 1, 0 => 1
  | 1, _ => 0
  | 2, 0 => 2
  | 2, _ => 0
  | 3, 0 => 1
  | 3, _ => 0
  | _ + 4, 0 => 3
  | _ + 4, _ => 0

/-- No relatum depends on another. -/
def web : Web Nat Nat where
  level := standing
  active _ _ := True
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- Each of the four steps touches the relatum `0`, and nothing else. -/
def touch : Nat → Nat → Bool
  | 0, 0 => true
  | 1, 0 => true
  | 2, 0 => true
  | 3, 0 => true
  | _, _ => false

def world : Footprinted Nat := ⟨Witnesses.emptyFlow Nat Nat, web, touch⟩

theorem contains : world.Contains
  | 0, 0, no => Bool.noConfusion no
  | 0, _ + 1, _ => ⟨(fun h => nomatch h), rfl, rfl, fun _ => ⟨rfl, rfl, rfl⟩⟩
  | 1, 0, no => Bool.noConfusion no
  | 1, _ + 1, _ => ⟨(fun h => nomatch h), rfl, rfl, fun _ => ⟨rfl, rfl, rfl⟩⟩
  | 2, 0, no => Bool.noConfusion no
  | 2, _ + 1, _ => ⟨(fun h => nomatch h), rfl, rfl, fun _ => ⟨rfl, rfl, rfl⟩⟩
  | 3, 0, no => Bool.noConfusion no
  | 3, _ + 1, _ => ⟨(fun h => nomatch h), rfl, rfl, fun _ => ⟨rfl, rfl, rfl⟩⟩
  | _ + 4, 0, _ => ⟨(fun h => nomatch h), rfl, rfl, fun _ => ⟨rfl, rfl, rfl⟩⟩
  | _ + 4, _ + 1, _ => ⟨(fun h => nomatch h), rfl, rfl, fun _ => ⟨rfl, rfl, rfl⟩⟩

/-- The footprint touches only what moves, so it is the least footprint containing the exchanges. -/
theorem touches_moved : ∀ n x, world.touch n x = true → ¬ world.web.Unmoved n x
  | 0, 0, _ => fun h => absurd h.1 (by decide)
  | 1, 0, _ => fun h => absurd h.1 (by decide)
  | 2, 0, _ => fun h => absurd h.1 (by decide)
  | 3, 0, _ => fun h => absurd h.1 (by decide)
  | 0, _ + 1, t => Bool.noConfusion t
  | 1, _ + 1, t => Bool.noConfusion t
  | 2, _ + 1, t => Bool.noConfusion t
  | 3, _ + 1, t => Bool.noConfusion t
  | _ + 4, _, t => Bool.noConfusion t

theorem joined (a b : Nat) (ha : a < 4) (hb : b < 4) : world.Joined a b :=
  .inl ⟨0, match a, ha with
    | 0, _ => rfl
    | 1, _ => rfl
    | 2, _ => rfl
    | 3, _ => rfl
    | _ + 4, h => absurd h (Nat.not_lt_of_le (Nat.le_add_left 4 _)),
   match b, hb with
    | 0, _ => rfl
    | 1, _ => rfl
    | 2, _ => rfl
    | 3, _ => rfl
    | _ + 4, h => absurd h (Nat.not_lt_of_le (Nat.le_add_left 4 _))⟩

/-- **Persistence without presence, with no dependence at all**: what the first exchange touched
is shown when the last is taken as right after the first, yet on no reordering is the first present
then: the middle two move it and move it back. -/
theorem persists_not_present :
    world.Contains ∧ (∀ t f c, ¬ world.web.requires t f c) ∧
      (∀ n x, world.touch n x = true → ¬ world.web.Unmoved n x) ∧ world.Precedes 0 3 ∧
      (∀ x, world.touch 0 x = true → world.web.SameAt (0 + 1) world.web 3 x) ∧
      (∀ ts, Reordering world 4 ts → ¬ PresentAt (exchanges world 4) (place ts) 0 3) :=
  ⟨contains, fun _ _ _ h => h, touches_moved, .joined (by decide) (joined 0 3 (by decide) (by decide)),
   fun x touched => match x, touched with
     | 0, _ => ⟨rfl, rfl, fun _ => ⟨rfl, rfl, rfl⟩⟩
     | _ + 1, touched => Bool.noConfusion touched,
   fun _ reordering present =>
     (Presence.link_of_present (exchanges_ordered world 4) (reordering_natural contains reordering)
       present).2 1
       ⟨⟨by decide, by decide, .joined (by decide) (joined 0 1 (by decide) (by decide))⟩,
        ⟨by decide, by decide, .joined (by decide) (joined 1 3 (by decide) (by decide))⟩⟩⟩

end Restored

/-! ### One course, two reorderings -/

theorem swap_below {i : Nat} (hi : i < 3) : swapAt 1 i < 3 := by
  rcases Presence.below_three hi with rfl | rfl | rfl <;> decide

theorem vee_swap {i j : Nat} (hi : i < 3) (hj : j < 3) :
    Presence.Vee.vee.prec i j ↔ Presence.Vee.vee.prec (place [1] i) (place [1] j) := by
  rcases Presence.below_three hi with rfl | rfl | rfl <;>
  rcases Presence.below_three hj with rfl | rfl | rfl <;> decide

/-- **In the vee as a world, the world as it is and the reordering commuting the later two are
numberings by one and the same course**: the course growing the stretch's exchanges in their own
labels relabels them onto its configuration at three births both ways, the two later births matched
to the two later exchanges the other way round. -/
theorem one_course_two_reorderings :
    ∃ run : Run process, run.state 0 = empty ∧
      CausalGrowth.Kinds.Relabels (exchanges VeeWorld.world 3) (run.state 3) (place []) (origin []) ∧
      CausalGrowth.Kinds.Relabels (exchanges VeeWorld.world 3) (run.state 3) (place [1]) (origin [1]) ∧
      place [] 1 ≠ place [1] 1 :=
  have grows := Presence.courseOf_grows (exchanges_ordered VeeWorld.world 3)
  have size : ((Presence.courseOf (exchanges VeeWorld.world 3)
      (exchanges_ordered VeeWorld.world 3)).state 3).size = 3 := grows.2.1
  ⟨Presence.courseOf (exchanges VeeWorld.world 3) (exchanges_ordered VeeWorld.world 3), grows.1,
   ⟨fun i hi => ⟨Nat.lt_of_lt_of_le hi (Nat.le_of_eq size.symm), rfl⟩,
    fun j hj => ⟨Nat.lt_of_lt_of_le hj (Nat.le_of_eq size), rfl⟩,
    fun i j _ _ => (grows.2.2 i j).symm⟩,
   ⟨fun i hi => ⟨Nat.lt_of_lt_of_le (swap_below hi) (Nat.le_of_eq size.symm), origin_place [1] i⟩,
    fun j hj => ⟨swap_below (Nat.lt_of_lt_of_le hj (Nat.le_of_eq size)), place_origin [1] j⟩,
    fun i j hi hj => (VeeWorld.prec_iff_vee i j).trans ((vee_swap hi hj).trans
      ((VeeWorld.prec_iff_vee (place [1] i) (place [1] j)).symm.trans (grows.2.2 _ _).symm))⟩,
   by decide⟩

end UE15Probe

end Becoming
```
