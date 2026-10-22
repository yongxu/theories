import Becoming.Hexagrams
import Becoming.Context
import Becoming.ContextArrivalTraces
import Becoming.LearningRuns

/-!
# The places of a hexagram and their relations, read in context

`Becoming.Hexagrams` states the six-line configurations of the 周易 as a world of the spine. This
module states the relations the text reads between the places of a hexagram: 正 (a line in phase
with its place), 應 (the lines at one height of the two trigrams), 比 (adjacent lines, with 承 and
乘) and 中 (the middle height). Each relation holds at a site, a place, a height or a seam between
two places, not of a line taken alone, so each is stated as a reading indexed by its site, a
`Contextual` reading of the spine (`Becoming.Context`). No premise is used.

* **Sites.** A trigram has three heights (`Height`), a hexagram two trigrams (`Half`), and each
  place is one height of one half (`place`, `heightOf`); two adjacent places meet at a seam
  (`Seam`, `below`, `above`). The places alternate in parity across every seam (`odd`,
  `odd_above`).
* **The four relations.** A line is in phase where its value is its place's parity, unbroken at
  the odd places and broken at the even (`inPhase`, 正, 當位). The two lines at one height are
  opposed where their values differ (`opposed`, 應; alike, 敵應). Two adjacent lines alternate
  where they differ (`alternates`, 比); going up across the seam the value rises from broken to
  unbroken (`rises`, 承) or falls (`falls`, 乘). The middle places are the middle height,
  lines 2 and 5 (`middle`, 中).
* **Readings in context.** A relation read at each of its sites is a contextual reading of one
  claim, the configuration (`atSites`); it glues to one reading of the whole configuration
  exactly where every site shows the same (`atSites_glues_iff`). The two trigrams read as
  contexts, each showing its line at every height (`halves`), glue exactly where no height is
  opposed (`halves_glues_iff`): opposition is where the two contexts show a height apart, the
  line there being two claims, one in each trigram. So no frame of context-free claims fits the
  heights under any process, while the indexed frame fits (`halves_no_free_frame`,
  `halves_indexed`, through `Contextual.fitsFree_iff` and `Contextual.indexed_fits`).
* **Where a reading of the whole exists.** The phases glue exactly at 既濟 and 未濟 (every line
  in phase, every line out of phase: `phases_glue_iff`, `inPhase_all_iff`, `inPhase_none_iff`);
  the oppositions at the configurations whose trigrams are complements (every height opposed)
  and the doubled trigrams (none: `oppositions_glue_iff`); the seams at 乾, 坤, 既濟 and 未濟
  (`seams_glue_iff`). So no frame of context-free claims fits the phases, the oppositions or the
  alternations under any process, while the indexed frame fits (`phases_no_free_frame`,
  `oppositions_no_free_frame`, `seams_no_free_frame`, `atSites_indexed`).
* **Opposition is told by phase.** The two places of a height have opposite
  parities, so the lines there are opposed exactly where both are in phase or both are out of
  phase (`opposed_iff_phase`). Both middle lines in phase gives the middle opposed
  (`middle_phase_opposed`), and every line out of phase gives every height opposed
  (`out_of_phase_opposed`). An unbroken middle line whose height is opposed and a broken one
  pick out the same configurations: the middle height opposed (`middleUnbrokenOpposed_eq`,
  `middleBrokenOpposed_eq`).
* **Under the complement and turning over.** The complement turns every phase and keeps every
  opposition and every alternation, and exchanges rises and falls (`inPhase_complement`,
  `phaseCount_complement`, `opposed_complement`, `alternates_complement`, `rises_complement`);
  turning over turns every phase at the mirrored place, keeps opposition at the mirrored height
  and exchanges rises and falls at the mirrored seam (`inPhase_reverse`, `phaseCount_reverse`,
  `opposed_reverse`, `rises_reverse`).
* **Under the change of one line.** Changing the line at a place turns its phase and the
  opposition at its height and leaves every other place and height as it was
  (`inPhase_flip_self`, `inPhase_flip_other`, `opposed_flip_self`, `opposed_flip_other`); the
  count of lines in phase moves by one (`phaseCount_flip`).
* **Under the law of waxing and waning.** Each line rises across a seam with its value
  (`line_waxWane_above`), so its phase turns at every rise and is kept only where the top line
  enters at the bottom as its opposite (`inPhase_waxWane_above`, `inPhase_waxWane_bottom`): the
  count of lines in phase and the count after one step add to five, or seven where the top line
  was in phase (`phaseCount_waxWane`), so the count changes parity at every step
  (`phaseCount_parity`, `phase_parity_along_run`), and along the twelve steps from 乾 it is 3, 2,
  3, 2, 3, 2, 3, 4, 3, 4, 3, 4 (`phase_qian_orbit`). The count is not a lumping the law goes
  alike across (`phaseCount_not_lumped`, `phaseCount_not_goAlike`). An alternation travels with
  its two lines (`alternates_carried`, `rises_carried`, `falls_carried`). The oppositions of the
  three heights travel with their two lines and turn at the wrap: they run under the same law of
  waxing and waning on three cells (`opposition_waxWane`, `waxWane3`), so they are a lumping the
  law goes alike across (`opposition_lumped`, `opposition_goAlike`, through
  `Learning.goAlike_iff_lumped`); three steps turn every opposition (`opposed_three_steps`), six
  keep it (`opposition_six`), and the oppositions return at the second step exactly where the
  bottom and top heights are opposed and the middle is not, or the other way round
  (`opposition_two_iff`); the other six patterns form one cycle of six steps through every height
  opposed and every height alike (`opposition_cycle`, `waxWane3_moves`). The doubled trigrams are
  three steps from opposition at every height (`halves_glue_three`).
* **A rise and a fall across the seams.** The rises and the falls of a configuration differ in
  number by its ends: rises and the bottom line together count as many as falls and the top line
  (`rises_falls_ends`).
* **Along the unfolding.** These laws are read on the runs of the spine. Along every run of
  waxing and waning (`Law.run`) each line's phase turns as it rises (`run_phase_rises`,
  `run_phase_enters`, `run_phaseCount`) and alternations travel with their lines (`run_carried`);
  six steps on every phase is turned, and so, opposition being told by phase, every opposition is
  kept (`run_six_turns`, `run_six_keeps`); three steps on every opposition is turned
  (`run_three_turns`, `run_doubled_three`); the pattern of oppositions changes at every step, is
  had again two steps on exactly at the two alternating patterns, and from every height opposed
  goes round in six (`run_opposition_moves`, `run_opposition_two_iff`, `run_opposition_cycle`).
  Along every run of the change of one line, each step turns the phase of the line it changes and
  the opposition at its height and keeps every other (`changes_run_phase`,
  `changes_run_opposition`). Turned over, a run of waxing and waning is the run of the law backward
  from the turned-over configuration, on which every relation is mirrored (`backward_run`,
  `backward_relations`). Whatever a run of any process shows, opposition is told by phase
  (`shown_along_run`).
* **What the 彖 and the 象 say of particular configurations.** The configurations the passage map
  of the chapter on the 易传 cites are named by their number in the received order (`number`,
  `jiJi`, `weiJi`, ...), and what the text says of their places is checked on them
  (`jiJi_inPhase`, `weiJi_opposed`, `heng_opposed`, `xian_opposed`, `gen_halves_glue`,
  `tongRen_second`, `xiaoXu_fourth`, `daYou_fifth`, `guiMei_falls`, `guai_falls`). Four censuses
  list the text's explicit statements of a kind, each checked on its configuration (the chapter's
  check finds every such statement in the preserved pages and compares it with the list): the
  小象's statements of place (`placeStatements_agree`), of the middle and in phase
  (`centreStatements_agree`), of a broken line over an unbroken one (`fallStatements_agree`),
  and the 彖's unbroken middle line opposed (`middleOppositionStatements_agree`). Where the text
  departs from the relation, the configuration is stated as it is (`xu_top_inPhase`,
  `gen_fifth_out_of_phase`).

What the text adds to these relations, the judgements of fortune, the ranks of places and the
readings of 初 and 上, is not in this module; the chapter on the 易传 reads each passage.

**Classical sources.** The relations are those the 彖 and the 象 use; their systematic statement
is traditionally credited to 王弼's 《周易略例》 (not preserved in this repository). The module
states them on the configurations and proves what they do under the laws of `Becoming.Hexagrams`.
`waxWane3` is the twisted ring counter on three cells.

No ethical predicate, ranking or axiom occurs.
* **Censuses and bands.** Every 小象 sentence saying a line is 中 is of a middle place, four other
  sentences listed apart (`xiaoxiangMiddle_census`); every sentence saying a line's way is exhausted is
  of the top place, five others apart (`exhausted_census`); every sentence of a broken line carrying an
  unbroken one is of a rise (`riseStatements_agree`); every 彖 中正 is of a middle line in phase
  (`tuanCentreStatements_agree`); two more place statements agree (`placeStatementsMore_agree`). The
  bands of the three powers and the heights are two divisions, jointly fixing a place and neither a
  function of the other, each band spanning one seam (`bands_and_heights`, `neither_function`,
  `band_seams`, `band_seam_unique`).
-/

namespace Becoming

open Generative

namespace Hexagram

/-! ## Sites: heights, halves and seams -/

/-- The three heights of a trigram, from the bottom: low (初, 四), middle (二, 五) and high
(三, 上). -/
inductive Height where
  | low
  | mid
  | high

/-- The two trigrams of a hexagram, as halves of its six places: lower (lines 1-3) and upper
(lines 4-6). -/
inductive Half where
  | lower
  | upper

/-- The place at a height of a half. -/
def place : Half → Height → Place
  | .lower, .low => .p1
  | .lower, .mid => .p2
  | .lower, .high => .p3
  | .upper, .low => .p4
  | .upper, .mid => .p5
  | .upper, .high => .p6

/-- The height of a place within its trigram. -/
def heightOf : Place → Height
  | .p1 => .low
  | .p2 => .mid
  | .p3 => .high
  | .p4 => .low
  | .p5 => .mid
  | .p6 => .high

/-- The seam between two adjacent places, from that of lines 1 and 2 to that of lines 5 and 6. -/
inductive Seam where
  | s12
  | s23
  | s34
  | s45
  | s56

/-- The place below a seam. -/
def below : Seam → Place
  | .s12 => .p1
  | .s23 => .p2
  | .s34 => .p3
  | .s45 => .p4
  | .s56 => .p5

/-- The place above a seam. -/
def above : Seam → Place
  | .s12 => .p2
  | .s23 => .p3
  | .s34 => .p4
  | .s45 => .p5
  | .s56 => .p6

/-- The seam one place higher; the top seam goes round to the bottom one. -/
def Seam.next : Seam → Seam
  | .s12 => .s23
  | .s23 => .s34
  | .s34 => .s45
  | .s45 => .s56
  | .s56 => .s12

/-- A place turned over: the top becomes the bottom. -/
def Place.mirror : Place → Place
  | .p1 => .p6
  | .p2 => .p5
  | .p3 => .p4
  | .p4 => .p3
  | .p5 => .p2
  | .p6 => .p1

/-- A height turned over: low and high exchange. -/
def Height.mirror : Height → Height
  | .low => .high
  | .mid => .mid
  | .high => .low

/-- A seam turned over. -/
def Seam.mirror : Seam → Seam
  | .s12 => .s56
  | .s23 => .s45
  | .s34 => .s34
  | .s45 => .s23
  | .s56 => .s12

/-! ## The four relations -/

/-- The parity of a place: `true` at the odd places (1, 3, 5), `false` at the even ones. -/
def odd : Place → Bool
  | .p1 => true
  | .p2 => false
  | .p3 => true
  | .p4 => false
  | .p5 => true
  | .p6 => false

/-- **The places alternate in parity across every seam** (迭用柔剛). -/
theorem odd_above : ∀ j : Seam, odd (above j) = !odd (below j)
  | .s12 => rfl
  | .s23 => rfl
  | .s34 => rfl
  | .s45 => rfl
  | .s56 => rfl

/-- **In phase** (正, 當位): the line at a place has the value of the place's parity, unbroken at
an odd place and broken at an even one. -/
def inPhase (s : Hexagram) (k : Place) : Bool := same (s.line k) (odd k)

/-- **Opposed** (應): the lines at one height of the two trigrams have different values; where
they agree, the height is alike (敵應). -/
def opposed (s : Hexagram) (h : Height) : Bool := !same (s.line (place .lower h)) (s.line (place .upper h))

/-- **Alternating across a seam** (比): the two adjacent lines have different values. -/
def alternates (s : Hexagram) (j : Seam) : Bool := !same (s.line (below j)) (s.line (above j))

/-- **A rise across a seam** (承): a broken line below an unbroken one. -/
def rises (s : Hexagram) (j : Seam) : Bool := !s.line (below j) && s.line (above j)

/-- **A fall across a seam** (乘): an unbroken line below a broken one. -/
def falls (s : Hexagram) (j : Seam) : Bool := s.line (below j) && !s.line (above j)

/-- **The middle places** (中): the middle height of each trigram, lines 2 and 5. -/
def middle (k : Place) : Bool :=
  match heightOf k with
  | .mid => true
  | .low => false
  | .high => false

/-- The count of lines in phase. -/
def phaseCount (s : Hexagram) : Nat :=
  (inPhase s .p1).toNat + (inPhase s .p2).toNat + (inPhase s .p3).toNat + (inPhase s .p4).toNat +
    (inPhase s .p5).toNat + (inPhase s .p6).toNat

/-- The count of rises. -/
def riseCount (s : Hexagram) : Nat :=
  (rises s .s12).toNat + (rises s .s23).toNat + (rises s .s34).toNat + (rises s .s45).toNat +
    (rises s .s56).toNat

/-- The count of falls. -/
def fallCount (s : Hexagram) : Nat :=
  (falls s .s12).toNat + (falls s .s23).toNat + (falls s .s34).toNat + (falls s .s45).toNat +
    (falls s .s56).toNat

/-! ## Readings in context -/

/-- A relation read at each of its sites, as what each site shows of one claim, the
configuration. -/
def atSites {K : Type} (r : Hexagram → K → Bool) : Contextual Hexagram K Unit Bool :=
  ⟨fun _ _ => True, fun s k _ => r s k⟩

/-- **A relation read at its sites glues to a reading of the whole configuration exactly where
every site shows what one site shows.** -/
theorem atSites_glues_iff {K : Type} (r : Hexagram → K → Bool) (home : K) (s : Hexagram) :
    (atSites r).Glues s ↔ ∀ k, r s k = r s home :=
  ⟨fun ⟨_, hv⟩ k => (hv k () trivial).trans (hv home () trivial).symm,
   fun all => ⟨fun _ => r s home, fun k _ _ => all k⟩⟩

/-- **So it glues exactly where the relation holds at every site or at none.** -/
theorem atSites_glues_iff_constant {K : Type} (r : Hexagram → K → Bool) (home : K) (s : Hexagram) :
    (atSites r).Glues s ↔ (∀ k, r s k = true) ∨ (∀ k, r s k = false) :=
  (atSites_glues_iff r home s).trans
    ⟨fun all => match e : r s home with
      | true => .inl fun k => (all k).trans e
      | false => .inr fun k => (all k).trans e,
     fun
      | .inl every => fun k => (every k).trans (every home).symm
      | .inr nowhere => fun k => (nowhere k).trans (nowhere home).symm⟩

/-- The two trigrams as contexts: each shows its line at every height. -/
def halves : Contextual Hexagram Half Height Bool :=
  ⟨fun _ _ => True, fun s t h => s.line (place t h)⟩

/-- Read with its trigram, the line at a height is a claim of the indexed frame, realized where the
line at that place has that value (`Contextual.indexed_fits`). -/
theorem halves_indexed {A : Type} (P : Process Hexagram A) (s : Hexagram) (t : Half) (h : Height)
    (b : Bool) : (halves.indexed P).realized s (t, h, b) ↔ s.line (place t h) = b :=
  (halves.indexed_fits P s t h b).trans ⟨fun both => both.2, fun e => ⟨trivial, e⟩⟩

theorem eq_iff_not_same : ∀ x y : Bool, x = y ↔ (!same x y) = false
  | true, true => ⟨fun _ => rfl, fun _ => rfl⟩
  | false, false => ⟨fun _ => rfl, fun _ => rfl⟩
  | true, false => ⟨fun e => Bool.noConfusion e, fun e => Bool.noConfusion e⟩
  | false, true => ⟨fun e => Bool.noConfusion e, fun e => Bool.noConfusion e⟩

/-- **The two trigrams show a height alike exactly where it is not opposed.** -/
theorem halves_agree_at (s : Hexagram) (h : Height) :
    s.line (place .lower h) = s.line (place .upper h) ↔ opposed s h = false :=
  eq_iff_not_same _ _

/-- **The trigrams glue exactly where no height is opposed** (上下敵應): the line at each height
is then one claim; at an opposed height it is two, one in each trigram. -/
theorem halves_glues_iff (s : Hexagram) : halves.Glues s ↔ ∀ h, opposed s h = false :=
  (halves.glues_iff_agree (fun _ => .lower) (fun _ => trivial) s).trans
    ⟨fun agree h => (halves_agree_at s h).mp (agree .lower .upper h trivial trivial),
     fun nowhere t t' h _ _ =>
      have e := (halves_agree_at s h).mpr (nowhere h)
      match t, t' with
      | .lower, .lower => rfl
      | .lower, .upper => e
      | .upper, .lower => e.symm
      | .upper, .upper => rfl⟩

/-- **No frame of context-free claims fits the heights under any process**, since 泰's trigrams
do not glue (`Contextual.fitsFree_iff`); the indexed frame fits (`halves_indexed`). -/
theorem halves_no_free_frame {A : Type} (P : Process Hexagram A) :
    ¬ ∃ F : Frame Hexagram A (Height × Bool), F.P = P ∧ halves.FitsFree F :=
  fun fits => Bool.noConfusion ((halves_glues_iff (rising 3)).mp
    ((halves.fitsFree_iff P (fun _ => .lower) (fun _ => trivial)).mp fits (rising 3)) .low)

/-! ## The configurations named in the passage map -/

/-- The member of a list at an index counted from zero, all broken past its end. -/
def nth : List Hexagram → Nat → Hexagram := Law.memberAt allBroken

/-- The configuration numbered `n` (1 to 64) in the received order. -/
def number (n : Nat) : Hexagram := nth order (n - 1)

/-- 需 (5). -/
def xu : Hexagram := number 5

/-- 小畜 (9). -/
def xiaoXu : Hexagram := number 9

/-- 同人 (13). -/
def tongRen : Hexagram := number 13

/-- 大有 (14). -/
def daYou : Hexagram := number 14

/-- 咸 (31). -/
def xian : Hexagram := number 31

/-- 恒 (32). -/
def heng : Hexagram := number 32

/-- 夬 (43). -/
def guai : Hexagram := number 43

/-- 艮 (52). -/
def gen : Hexagram := number 52

/-- 歸妹 (54). -/
def guiMei : Hexagram := number 54

/-- 既濟 (63). -/
def jiJi : Hexagram := number 63

/-- 未濟 (64). -/
def weiJi : Hexagram := number 64

/-! ## Where a reading of the whole exists -/

/-- **既濟 has every line in phase** (剛柔正而位當). -/
theorem jiJi_inPhase : ∀ k, inPhase jiJi k = true
  | .p1 => rfl
  | .p2 => rfl
  | .p3 => rfl
  | .p4 => rfl
  | .p5 => rfl
  | .p6 => rfl

/-- **未濟 has every line out of phase** (不當位). -/
theorem weiJi_out_of_phase : ∀ k, inPhase weiJi k = false
  | .p1 => rfl
  | .p2 => rfl
  | .p3 => rfl
  | .p4 => rfl
  | .p5 => rfl
  | .p6 => rfl

/-- **Every line is in phase exactly at 既濟.** -/
theorem inPhase_all_iff (s : Hexagram) : (∀ k, inPhase s k = true) ↔ s = jiJi :=
  ⟨fun all => by
    cases s with
    | mk a b c d e f =>
      cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> cases f <;>
        first
        | rfl
        | exact Bool.noConfusion (all .p1)
        | exact Bool.noConfusion (all .p2)
        | exact Bool.noConfusion (all .p3)
        | exact Bool.noConfusion (all .p4)
        | exact Bool.noConfusion (all .p5)
        | exact Bool.noConfusion (all .p6),
   fun e => by
    subst e
    exact jiJi_inPhase⟩

/-- **Every line is out of phase exactly at 未濟.** -/
theorem inPhase_none_iff (s : Hexagram) : (∀ k, inPhase s k = false) ↔ s = weiJi :=
  ⟨fun nowhere => by
    cases s with
    | mk a b c d e f =>
      cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> cases f <;>
        first
        | rfl
        | exact Bool.noConfusion (nowhere .p1)
        | exact Bool.noConfusion (nowhere .p2)
        | exact Bool.noConfusion (nowhere .p3)
        | exact Bool.noConfusion (nowhere .p4)
        | exact Bool.noConfusion (nowhere .p5)
        | exact Bool.noConfusion (nowhere .p6),
   fun e => by
    subst e
    exact weiJi_out_of_phase⟩

/-- **The phases read at the six places glue to a reading of the whole exactly at 既濟 and
未濟.** -/
theorem phases_glue_iff (s : Hexagram) : (atSites inPhase).Glues s ↔ s = jiJi ∨ s = weiJi :=
  (atSites_glues_iff_constant inPhase .p1 s).trans
    ⟨fun
      | .inl all => .inl ((inPhase_all_iff s).mp all)
      | .inr nowhere => .inr ((inPhase_none_iff s).mp nowhere),
     fun
      | .inl e => .inl ((inPhase_all_iff s).mpr e)
      | .inr e => .inr ((inPhase_none_iff s).mpr e)⟩

/-- **The oppositions read at the three heights glue exactly where every height is opposed, the
trigrams being complements, or none is, the trigram doubled.** -/
theorem oppositions_glue_iff (s : Hexagram) :
    (atSites opposed).Glues s ↔ (∀ h, opposed s h = true) ∨ halves.Glues s :=
  (atSites_glues_iff_constant opposed .low s).trans
    ⟨fun
      | .inl all => .inl all
      | .inr nowhere => .inr ((halves_glues_iff s).mpr nowhere),
     fun
      | .inl all => .inl all
      | .inr glued => .inr ((halves_glues_iff s).mp glued)⟩

/-- Every seam alternates exactly at 既濟 and 未濟. -/
theorem alternates_all_iff (s : Hexagram) : (∀ j, alternates s j = true) ↔ s = jiJi ∨ s = weiJi :=
  ⟨fun all => by
    cases s with
    | mk a b c d e f =>
      cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> cases f <;>
        first
        | exact .inl rfl
        | exact .inr rfl
        | exact Bool.noConfusion (all .s12)
        | exact Bool.noConfusion (all .s23)
        | exact Bool.noConfusion (all .s34)
        | exact Bool.noConfusion (all .s45)
        | exact Bool.noConfusion (all .s56),
   fun
    | .inl e => by
      subst e
      intro j
      cases j <;> rfl
    | .inr e => by
      subst e
      intro j
      cases j <;> rfl⟩

/-- No seam alternates exactly at 乾 and 坤. -/
theorem alternates_none_iff (s : Hexagram) :
    (∀ j, alternates s j = false) ↔ s = rising 6 ∨ s = rising 0 :=
  ⟨fun nowhere => by
    cases s with
    | mk a b c d e f =>
      cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> cases f <;>
        first
        | exact .inl rfl
        | exact .inr rfl
        | exact Bool.noConfusion (nowhere .s12)
        | exact Bool.noConfusion (nowhere .s23)
        | exact Bool.noConfusion (nowhere .s34)
        | exact Bool.noConfusion (nowhere .s45)
        | exact Bool.noConfusion (nowhere .s56),
   fun
    | .inl e => by
      subst e
      intro j
      cases j <;> rfl
    | .inr e => by
      subst e
      intro j
      cases j <;> rfl⟩

/-- **The alternations read at the five seams glue exactly at 乾, 坤, 既濟 and 未濟.** -/
theorem seams_glue_iff (s : Hexagram) :
    (atSites alternates).Glues s ↔ s = rising 6 ∨ s = rising 0 ∨ s = jiJi ∨ s = weiJi :=
  (atSites_glues_iff_constant alternates .s12 s).trans
    ⟨fun
      | .inl all => .inr (.inr ((alternates_all_iff s).mp all))
      | .inr nowhere => match (alternates_none_iff s).mp nowhere with
        | .inl e => .inl e
        | .inr e => .inr (.inl e),
     fun
      | .inl e => .inr ((alternates_none_iff s).mpr (.inl e))
      | .inr (.inl e) => .inr ((alternates_none_iff s).mpr (.inr e))
      | .inr (.inr e) => .inl ((alternates_all_iff s).mpr e)⟩

/-! ## Opposition is told by phase -/

/-- **The lines at one height are opposed exactly where both are in phase or both are out of
phase**, the two places of a height having opposite parities. -/
theorem opposed_iff_phase : ∀ (s : Hexagram) (h : Height),
    opposed s h = same (inPhase s (place .lower h)) (inPhase s (place .upper h))
  | ⟨a, _, _, d, _, _⟩, .low => by cases a <;> cases d <;> rfl
  | ⟨_, b, _, _, e, _⟩, .mid => by cases b <;> cases e <;> rfl
  | ⟨_, _, c, _, _, f⟩, .high => by cases c <;> cases f <;> rfl

/-- **Both middle lines in phase gives the middle opposed** (中正而應). -/
theorem middle_phase_opposed {s : Hexagram} (lower : inPhase s .p2 = true)
    (upper : inPhase s .p5 = true) : opposed s .mid = true :=
  (opposed_iff_phase s .mid).trans ((congrArg (fun x => same x (inPhase s .p5)) lower).trans
    (congrArg (same true) upper))

/-- **Every line out of phase gives every height opposed** (雖不當位，剛柔應). -/
theorem out_of_phase_opposed {s : Hexagram} (out : ∀ k, inPhase s k = false) (h : Height) :
    opposed s h = true :=
  (opposed_iff_phase s h).trans
    ((congrArg (fun x => same x (inPhase s (place .upper h))) (out _)).trans (congrArg (same false) (out _)))

/-- **Every line in phase gives every height opposed.** -/
theorem in_phase_opposed {s : Hexagram} (all : ∀ k, inPhase s k = true) (h : Height) :
    opposed s h = true :=
  (opposed_iff_phase s h).trans
    ((congrArg (fun x => same x (inPhase s (place .upper h))) (all _)).trans (congrArg (same true) (all _)))

/-- An unbroken line at a middle place whose height is opposed (剛中而應). -/
def middleUnbrokenOpposed (s : Hexagram) : Bool :=
  (s.line .p2 && opposed s .mid) || (s.line .p5 && opposed s .mid)

/-- A broken line at a middle place whose height is opposed (柔中而應). -/
def middleBrokenOpposed (s : Hexagram) : Bool :=
  (!s.line .p2 && opposed s .mid) || (!s.line .p5 && opposed s .mid)

/-- **An unbroken middle line opposed is the middle height opposed.** -/
theorem middleUnbrokenOpposed_eq : ∀ s : Hexagram, middleUnbrokenOpposed s = opposed s .mid
  | ⟨_, b, _, _, e, _⟩ => by cases b <;> cases e <;> rfl

/-- **And so is a broken middle line opposed**: the two name one relation from its two ends. -/
theorem middleBrokenOpposed_eq : ∀ s : Hexagram, middleBrokenOpposed s = opposed s .mid
  | ⟨_, b, _, _, e, _⟩ => by cases b <;> cases e <;> rfl

/-! ## Under the complement and turning over -/

theorem same_not_left : ∀ x y : Bool, same (!x) y = !same x y
  | true, true => rfl
  | true, false => rfl
  | false, true => rfl
  | false, false => rfl

theorem same_not_not : ∀ x y : Bool, same (!x) (!y) = same x y
  | true, true => rfl
  | true, false => rfl
  | false, true => rfl
  | false, false => rfl

theorem neither : ∀ {x y : Bool}, (x || y) = false → x = false ∧ y = false
  | false, false, _ => ⟨rfl, rfl⟩
  | true, _, h => Bool.noConfusion h
  | false, true, h => Bool.noConfusion h

theorem line_complement : ∀ (s : Hexagram) (k : Place), (complement s).line k = !s.line k
  | ⟨_, _, _, _, _, _⟩, .p1 => rfl
  | ⟨_, _, _, _, _, _⟩, .p2 => rfl
  | ⟨_, _, _, _, _, _⟩, .p3 => rfl
  | ⟨_, _, _, _, _, _⟩, .p4 => rfl
  | ⟨_, _, _, _, _, _⟩, .p5 => rfl
  | ⟨_, _, _, _, _, _⟩, .p6 => rfl

/-- **The complement turns every phase.** -/
theorem inPhase_complement (s : Hexagram) (k : Place) : inPhase (complement s) k = !inPhase s k :=
  (congrArg (fun x => same x (odd k)) (line_complement s k)).trans (same_not_left _ _)

/-- **So the counts in phase of a configuration and its complement add to six.** -/
theorem phaseCount_complement : ∀ s : Hexagram, phaseCount (complement s) + phaseCount s = 6
  | ⟨a, b, c, d, e, f⟩ => by
    cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> cases f <;> rfl

/-- **The complement keeps every opposition** (錯 keeps 應). -/
theorem opposed_complement : ∀ (s : Hexagram) (h : Height), opposed (complement s) h = opposed s h
  | ⟨a, _, _, d, _, _⟩, .low => by cases a <;> cases d <;> rfl
  | ⟨_, b, _, _, e, _⟩, .mid => by cases b <;> cases e <;> rfl
  | ⟨_, _, c, _, _, f⟩, .high => by cases c <;> cases f <;> rfl

/-- **And every alternation.** -/
theorem alternates_complement : ∀ (s : Hexagram) (j : Seam),
    alternates (complement s) j = alternates s j
  | ⟨a, b, _, _, _, _⟩, .s12 => by cases a <;> cases b <;> rfl
  | ⟨_, b, c, _, _, _⟩, .s23 => by cases b <;> cases c <;> rfl
  | ⟨_, _, c, d, _, _⟩, .s34 => by cases c <;> cases d <;> rfl
  | ⟨_, _, _, d, e, _⟩, .s45 => by cases d <;> cases e <;> rfl
  | ⟨_, _, _, _, e, f⟩, .s56 => by cases e <;> cases f <;> rfl

/-- **The complement exchanges rises and falls.** -/
theorem rises_complement : ∀ (s : Hexagram) (j : Seam), rises (complement s) j = falls s j
  | ⟨a, b, _, _, _, _⟩, .s12 => by cases a <;> cases b <;> rfl
  | ⟨_, b, c, _, _, _⟩, .s23 => by cases b <;> cases c <;> rfl
  | ⟨_, _, c, d, _, _⟩, .s34 => by cases c <;> cases d <;> rfl
  | ⟨_, _, _, d, e, _⟩, .s45 => by cases d <;> cases e <;> rfl
  | ⟨_, _, _, _, e, f⟩, .s56 => by cases e <;> cases f <;> rfl

theorem line_reverse : ∀ (s : Hexagram) (k : Place), (reverse s).line (Place.mirror k) = s.line k
  | ⟨_, _, _, _, _, _⟩, .p1 => rfl
  | ⟨_, _, _, _, _, _⟩, .p2 => rfl
  | ⟨_, _, _, _, _, _⟩, .p3 => rfl
  | ⟨_, _, _, _, _, _⟩, .p4 => rfl
  | ⟨_, _, _, _, _, _⟩, .p5 => rfl
  | ⟨_, _, _, _, _, _⟩, .p6 => rfl

/-- **Turning over turns every phase, at the mirrored place.** -/
theorem inPhase_reverse : ∀ (s : Hexagram) (k : Place),
    inPhase (reverse s) (Place.mirror k) = !inPhase s k
  | ⟨a, _, _, _, _, _⟩, .p1 => by cases a <;> rfl
  | ⟨_, b, _, _, _, _⟩, .p2 => by cases b <;> rfl
  | ⟨_, _, c, _, _, _⟩, .p3 => by cases c <;> rfl
  | ⟨_, _, _, d, _, _⟩, .p4 => by cases d <;> rfl
  | ⟨_, _, _, _, e, _⟩, .p5 => by cases e <;> rfl
  | ⟨_, _, _, _, _, f⟩, .p6 => by cases f <;> rfl

/-- **So the counts in phase of a configuration and of it turned over add to six.** -/
theorem phaseCount_reverse : ∀ s : Hexagram, phaseCount (reverse s) + phaseCount s = 6
  | ⟨a, b, c, d, e, f⟩ => by
    cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> cases f <;> rfl

/-- **Turning over keeps every opposition, at the mirrored height.** -/
theorem opposed_reverse : ∀ (s : Hexagram) (h : Height),
    opposed (reverse s) (Height.mirror h) = opposed s h
  | ⟨a, _, _, d, _, _⟩, .low => by cases a <;> cases d <;> rfl
  | ⟨_, b, _, _, e, _⟩, .mid => by cases b <;> cases e <;> rfl
  | ⟨_, _, c, _, _, f⟩, .high => by cases c <;> cases f <;> rfl

/-- **And exchanges rises and falls, at the mirrored seam.** -/
theorem rises_reverse : ∀ (s : Hexagram) (j : Seam), rises (reverse s) (Seam.mirror j) = falls s j
  | ⟨a, b, _, _, _, _⟩, .s12 => by cases a <;> cases b <;> rfl
  | ⟨_, b, c, _, _, _⟩, .s23 => by cases b <;> cases c <;> rfl
  | ⟨_, _, c, d, _, _⟩, .s34 => by cases c <;> cases d <;> rfl
  | ⟨_, _, _, d, e, _⟩, .s45 => by cases d <;> cases e <;> rfl
  | ⟨_, _, _, _, e, f⟩, .s56 => by cases e <;> cases f <;> rfl

/-! ## Under the change of one line -/

theorem line_flip_self : ∀ (k : Place) (s : Hexagram), (flip k s).line k = !s.line k
  | .p1, ⟨_, _, _, _, _, _⟩ => rfl
  | .p2, ⟨_, _, _, _, _, _⟩ => rfl
  | .p3, ⟨_, _, _, _, _, _⟩ => rfl
  | .p4, ⟨_, _, _, _, _, _⟩ => rfl
  | .p5, ⟨_, _, _, _, _, _⟩ => rfl
  | .p6, ⟨_, _, _, _, _, _⟩ => rfl

theorem line_flip_other {k k' : Place} (s : Hexagram) (other : k ≠ k') :
    (flip k s).line k' = s.line k' := by
  cases s
  cases k <;> cases k' <;> first | exact absurd rfl other | rfl

/-- **Changing a line turns its phase.** -/
theorem inPhase_flip_self (k : Place) (s : Hexagram) : inPhase (flip k s) k = !inPhase s k :=
  (congrArg (fun x => same x (odd k)) (line_flip_self k s)).trans (same_not_left _ _)

/-- **And leaves the phase of every other place.** -/
theorem inPhase_flip_other {k k' : Place} (s : Hexagram) (other : k ≠ k') :
    inPhase (flip k s) k' = inPhase s k' :=
  congrArg (fun x => same x (odd k')) (line_flip_other s other)

/-- **The count of lines in phase moves by one at every change of a line.** -/
theorem phaseCount_flip : ∀ (k : Place) (s : Hexagram),
    phaseCount (flip k s) + 1 = phaseCount s ∨ phaseCount s + 1 = phaseCount (flip k s)
  | k, ⟨a, b, c, d, e, f⟩ => by
    cases k <;> cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> cases f <;>
      first | exact .inl rfl | exact .inr rfl

/-- **Changing a line turns the opposition at its height.** -/
theorem opposed_flip_self : ∀ (k : Place) (s : Hexagram),
    opposed (flip k s) (heightOf k) = !opposed s (heightOf k)
  | .p1, ⟨a, _, _, d, _, _⟩ => by cases a <;> cases d <;> rfl
  | .p2, ⟨_, b, _, _, e, _⟩ => by cases b <;> cases e <;> rfl
  | .p3, ⟨_, _, c, _, _, f⟩ => by cases c <;> cases f <;> rfl
  | .p4, ⟨a, _, _, d, _, _⟩ => by cases a <;> cases d <;> rfl
  | .p5, ⟨_, b, _, _, e, _⟩ => by cases b <;> cases e <;> rfl
  | .p6, ⟨_, _, c, _, _, f⟩ => by cases c <;> cases f <;> rfl

/-- **And leaves the opposition at every other height.** -/
theorem opposed_flip_other {k : Place} {h : Height} (s : Hexagram) (other : heightOf k ≠ h) :
    opposed (flip k s) h = opposed s h := by
  cases s
  cases k <;> cases h <;> first | exact absurd rfl other | rfl

/-! ## Under the law of waxing and waning -/

/-- **Each line rises across a seam with its value.** -/
theorem line_waxWane_above : ∀ (s : Hexagram) (j : Seam), (waxWane s).line (above j) = s.line (below j)
  | ⟨_, _, _, _, _, _⟩, .s12 => rfl
  | ⟨_, _, _, _, _, _⟩, .s23 => rfl
  | ⟨_, _, _, _, _, _⟩, .s34 => rfl
  | ⟨_, _, _, _, _, _⟩, .s45 => rfl
  | ⟨_, _, _, _, _, _⟩, .s56 => rfl

theorem same_not_right : ∀ x y : Bool, same x (!y) = !same x y
  | true, true => rfl
  | true, false => rfl
  | false, true => rfl
  | false, false => rfl

/-- **So its phase turns at every rise** (六位時成: what a line shows depends on the place it holds
at each step). -/
theorem inPhase_waxWane_above (s : Hexagram) (j : Seam) :
    inPhase (waxWane s) (above j) = !inPhase s (below j) :=
  (congrArg (fun x => same x (odd (above j))) (line_waxWane_above s j)).trans
    ((congrArg (same (s.line (below j))) (odd_above j)).trans (same_not_right _ _))

/-- **And is kept where the top line enters at the bottom as its opposite.** -/
theorem inPhase_waxWane_bottom : ∀ s : Hexagram, inPhase (waxWane s) .p1 = inPhase s .p6
  | ⟨_, _, _, _, _, f⟩ => by cases f <;> rfl

/-- **The counts in phase before and after a step add to five, or to seven where the top line was
in phase.** -/
theorem phaseCount_waxWane : ∀ s : Hexagram,
    phaseCount (waxWane s) + phaseCount s = 5 + 2 * (inPhase s .p6).toNat
  | ⟨a, b, c, d, e, f⟩ => by
    cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> cases f <;> rfl

/-- **So the count of lines in phase changes parity at every step.** -/
theorem phaseCount_parity : ∀ s : Hexagram, (phaseCount (waxWane s) + phaseCount s) % 2 = 1
  | ⟨a, b, c, d, e, f⟩ => by
    cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> cases f <;> rfl

/-- **Along every run of the law, the count in phase changes parity at every step.** -/
theorem phase_parity_along_run (s : Hexagram) (n : Nat) :
    (phaseCount ((Law.run waxWane s).state (n + 1)) + phaseCount ((Law.run waxWane s).state n)) % 2 = 1 :=
  phaseCount_parity (Law.orbit waxWane s n)

/-- **Along the twelve steps from 乾 the count in phase is 3, 2, 3, 2, 3, 2 while the broken lines
rise, and 3, 4, 3, 4, 3, 4 while the unbroken lines rise**: it never reaches six or none. -/
theorem phase_qian_orbit :
    (List.range 12).map (fun n => phaseCount ((Law.run waxWane (rising 6)).state n)) =
      [3, 2, 3, 2, 3, 2, 3, 4, 3, 4, 3, 4] := rfl

/-- **The count in phase is not a lumping the law goes alike across**: 乾 and 坤 have three each,
and go on to two and four. -/
theorem phaseCount_not_lumped : ¬ Learning.Lumped phaseCount (fun s => phaseCount (waxWane s)) :=
  fun lumped => absurd (lumped (rising 6) (rising 0) rfl) (by decide)

theorem phaseCount_not_goAlike : ¬ GoAlike (Law.process waxWane) phaseCount :=
  fun alike => phaseCount_not_lumped (Learning.goAlike_iff_lumped.mp alike)

/-- **An alternation travels with its two lines**, except across the top seam, whose lines part. -/
theorem alternates_carried : ∀ (s : Hexagram) (j : Seam), j ≠ .s56 →
    alternates (waxWane s) j.next = alternates s j
  | ⟨_, _, _, _, _, _⟩, .s12, _ => rfl
  | ⟨_, _, _, _, _, _⟩, .s23, _ => rfl
  | ⟨_, _, _, _, _, _⟩, .s34, _ => rfl
  | ⟨_, _, _, _, _, _⟩, .s45, _ => rfl
  | ⟨_, _, _, _, _, _⟩, .s56, top => absurd rfl top

/-- **So does a rise.** -/
theorem rises_carried : ∀ (s : Hexagram) (j : Seam), j ≠ .s56 → rises (waxWane s) j.next = rises s j
  | ⟨_, _, _, _, _, _⟩, .s12, _ => rfl
  | ⟨_, _, _, _, _, _⟩, .s23, _ => rfl
  | ⟨_, _, _, _, _, _⟩, .s34, _ => rfl
  | ⟨_, _, _, _, _, _⟩, .s45, _ => rfl
  | ⟨_, _, _, _, _, _⟩, .s56, top => absurd rfl top

/-- **And a fall.** -/
theorem falls_carried : ∀ (s : Hexagram) (j : Seam), j ≠ .s56 → falls (waxWane s) j.next = falls s j
  | ⟨_, _, _, _, _, _⟩, .s12, _ => rfl
  | ⟨_, _, _, _, _, _⟩, .s23, _ => rfl
  | ⟨_, _, _, _, _, _⟩, .s34, _ => rfl
  | ⟨_, _, _, _, _, _⟩, .s45, _ => rfl
  | ⟨_, _, _, _, _, _⟩, .s56, top => absurd rfl top

/-- The oppositions of the low, middle and high heights. -/
def opposition (s : Hexagram) : Bool × Bool × Bool := (opposed s .low, opposed s .mid, opposed s .high)

/-- The law of waxing and waning on three cells: each value rises one cell, and the top value
passes out and enters at the bottom as its opposite. -/
def waxWane3 : Bool × Bool × Bool → Bool × Bool × Bool
  | (a, b, c) => (!c, a, b)

/-- **The oppositions run under the same law on three cells**: each travels with its two lines, the
low to the middle and the middle to the high, and the high turns as it goes round to the low. -/
theorem opposition_waxWane : ∀ s : Hexagram, opposition (waxWane s) = waxWane3 (opposition s)
  | ⟨a, b, c, d, e, f⟩ => by
    cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> cases f <;> rfl

/-- **So the oppositions are a lumping the law goes alike across.** -/
theorem opposition_lumped : Learning.Lumped opposition (fun s => opposition (waxWane s)) :=
  fun s t same =>
    (opposition_waxWane s).trans ((congrArg waxWane3 same).trans (opposition_waxWane t).symm)

/-- By `Learning.goAlike_iff_lumped`. -/
theorem opposition_goAlike : GoAlike (Law.process waxWane) opposition :=
  Learning.goAlike_iff_lumped.mpr opposition_lumped

/-- **Three steps turn every opposition.** -/
theorem opposed_three_steps : ∀ (s : Hexagram) (h : Height),
    opposed (Law.orbit waxWane s 3) h = !opposed s h
  | ⟨a, _, _, d, _, _⟩, .low => by cases a <;> cases d <;> rfl
  | ⟨_, b, _, _, e, _⟩, .mid => by cases b <;> cases e <;> rfl
  | ⟨_, _, c, _, _, f⟩, .high => by cases c <;> cases f <;> rfl

/-- **Six steps keep every opposition**: they give the complement (`six_steps`). -/
theorem opposition_six (s : Hexagram) : opposition (Law.orbit waxWane s 6) = opposition s := by
  rw [six_steps s]
  show (opposed (complement s) .low, opposed (complement s) .mid, opposed (complement s) .high) =
    (opposed s .low, opposed s .mid, opposed s .high)
  rw [opposed_complement, opposed_complement, opposed_complement]

theorem waxWane3_twice_iff : ∀ p : Bool × Bool × Bool,
    waxWane3 (waxWane3 p) = p ↔ p = (true, false, true) ∨ p = (false, true, false)
  | (true, false, true) => ⟨fun _ => .inl rfl, fun _ => rfl⟩
  | (false, true, false) => ⟨fun _ => .inr rfl, fun _ => rfl⟩
  | (true, true, true) => ⟨fun h => Bool.noConfusion (congrArg Prod.fst h),
      fun | .inl h => Bool.noConfusion (congrArg (fun q => q.2.1) h)
          | .inr h => Bool.noConfusion (congrArg Prod.fst h)⟩
  | (true, true, false) => ⟨fun h => Bool.noConfusion (congrArg Prod.fst h),
      fun | .inl h => Bool.noConfusion (congrArg (fun q => q.2.1) h)
          | .inr h => Bool.noConfusion (congrArg Prod.fst h)⟩
  | (true, false, false) => ⟨fun h => Bool.noConfusion (congrArg (fun q => q.2.1) h),
      fun | .inl h => Bool.noConfusion (congrArg (fun q => q.2.2) h)
          | .inr h => Bool.noConfusion (congrArg Prod.fst h)⟩
  | (false, true, true) => ⟨fun h => Bool.noConfusion (congrArg (fun q => q.2.1) h),
      fun | .inl h => Bool.noConfusion (congrArg Prod.fst h)
          | .inr h => Bool.noConfusion (congrArg (fun q => q.2.2) h)⟩
  | (false, false, true) => ⟨fun h => Bool.noConfusion (congrArg Prod.fst h),
      fun | .inl h => Bool.noConfusion (congrArg Prod.fst h)
          | .inr h => Bool.noConfusion (congrArg (fun q => q.2.1) h)⟩
  | (false, false, false) => ⟨fun h => Bool.noConfusion (congrArg Prod.fst h),
      fun | .inl h => Bool.noConfusion (congrArg Prod.fst h)
          | .inr h => Bool.noConfusion (congrArg (fun q => q.2.1) h)⟩

/-- **No pattern of oppositions is had again at the next step.** -/
theorem waxWane3_moves : ∀ p : Bool × Bool × Bool, waxWane3 p ≠ p
  | (true, true, true) => fun h => Bool.noConfusion (congrArg Prod.fst h)
  | (true, true, false) => fun h => Bool.noConfusion (congrArg (fun q => q.2.2) h)
  | (true, false, true) => fun h => Bool.noConfusion (congrArg Prod.fst h)
  | (true, false, false) => fun h => Bool.noConfusion (congrArg (fun q => q.2.1) h)
  | (false, true, true) => fun h => Bool.noConfusion (congrArg (fun q => q.2.1) h)
  | (false, true, false) => fun h => Bool.noConfusion (congrArg Prod.fst h)
  | (false, false, true) => fun h => Bool.noConfusion (congrArg (fun q => q.2.2) h)
  | (false, false, false) => fun h => Bool.noConfusion (congrArg Prod.fst h)

/-- **From every height opposed, the oppositions run through every height alike and back in six
steps**, through six patterns of the eight. -/
theorem opposition_cycle :
    (List.range 7).map (Law.orbit waxWane3 (true, true, true)) =
      [(true, true, true), (false, true, true), (false, false, true), (false, false, false),
        (true, false, false), (true, true, false), (true, true, true)] := rfl

/-- **The oppositions return at the second step exactly where the low and high heights are opposed
and the middle is not, or the other way round**: these two patterns are the other two of the
eight. -/
theorem opposition_two_iff (s : Hexagram) :
    opposition (Law.orbit waxWane s 2) = opposition s ↔
      opposition s = (true, false, true) ∨ opposition s = (false, true, false) := by
  have twice : opposition (Law.orbit waxWane s 2) = waxWane3 (waxWane3 (opposition s)) :=
    (opposition_waxWane (waxWane s)).trans (congrArg waxWane3 (opposition_waxWane s))
  rw [twice]
  exact waxWane3_twice_iff (opposition s)

/-- **The doubled trigrams are three steps from opposition at every height** (乾 to 否, 坤 to
泰). -/
theorem halves_glue_three {s : Hexagram} (glued : halves.Glues s) (h : Height) :
    opposed (Law.orbit waxWane s 3) h = true :=
  (opposed_three_steps s h).trans (congrArg (fun x => !x) ((halves_glues_iff s).mp glued h))

/-! ## A rise and a fall across the seams -/

/-- **Rises and the bottom line count as many as falls and the top line**: going up the six
places, the value rises as often as it falls, but for where it starts and ends. -/
theorem rises_falls_ends : ∀ s : Hexagram, riseCount s + s.l1.toNat = fallCount s + s.l6.toNat
  | ⟨a, b, c, d, e, f⟩ => by
    cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> cases f <;> rfl

/-! ## What the 彖 and the 象 say of particular configurations -/

/-- **未濟's lines are opposed at every height because every line is out of phase**
(`out_of_phase_opposed`). -/
theorem weiJi_opposed (h : Height) : opposed weiJi h = true :=
  out_of_phase_opposed weiJi_out_of_phase h

/-- **恒 is opposed at every height** (剛柔皆應). -/
theorem heng_opposed : ∀ h, opposed heng h = true
  | .low => rfl
  | .mid => rfl
  | .high => rfl

/-- **咸 is opposed at every height** (二氣感應以相與). -/
theorem xian_opposed : ∀ h, opposed xian h = true
  | .low => rfl
  | .mid => rfl
  | .high => rfl

/-- **艮's trigrams glue: no height is opposed** (上下敵應，不相與也). -/
theorem gen_halves_glue : halves.Glues gen :=
  (halves_glues_iff gen).mpr fun
    | .low => rfl
    | .mid => rfl
    | .high => rfl

/-- **同人's second line is broken, in phase and middle, and its height opposed** (柔得位得中，
而應乎乾). -/
theorem tongRen_second :
    tongRen.line .p2 = false ∧ inPhase tongRen .p2 = true ∧ middle .p2 = true ∧
      opposed tongRen .mid = true :=
  ⟨rfl, rfl, rfl, rfl⟩

/-- **小畜's fourth line is broken and in phase, and only its own height is opposed**
(柔得位而上下應之: under the relation of heights, only the first line answers it). -/
theorem xiaoXu_fourth :
    xiaoXu.line .p4 = false ∧ inPhase xiaoXu .p4 = true ∧ opposed xiaoXu .low = true ∧
      opposed xiaoXu .mid = false ∧ opposed xiaoXu .high = false :=
  ⟨rfl, rfl, rfl, rfl, rfl⟩

/-- **大有's fifth line is broken, middle and out of phase, and only the middle height is opposed**
(柔得尊位，大中而上下應之). -/
theorem daYou_fifth :
    daYou.line .p5 = false ∧ middle .p5 = true ∧ inPhase daYou .p5 = false ∧
      opposed daYou .mid = true ∧ opposed daYou .low = false ∧ opposed daYou .high = false :=
  ⟨rfl, rfl, rfl, rfl, rfl, rfl⟩

/-- **歸妹 falls at the seams under its third and fifth lines** (柔乘剛). -/
theorem guiMei_falls : falls guiMei .s23 = true ∧ falls guiMei .s45 = true ∧ fallCount guiMei = 2 :=
  ⟨rfl, rfl, rfl⟩

/-- **夬 falls only at the top seam**: its broken top line is over one unbroken line, the five
being below it (柔乘五剛). -/
theorem guai_falls : falls guai .s56 = true ∧ fallCount guai = 1 ∧ riseCount guai = 0 :=
  ⟨rfl, rfl, rfl⟩

/-! ## Censuses of the text -/

/-- The 小象's explicit statements of place, in the received order: the configuration's number,
the place, and whether the text says the line holds its place (`true`: 位正當, 位當, 當位) or not
(`false`: 位不當, 不當位, 未當位, 未得位). 需's top line (`xu_top_inPhase`) is left out. -/
def placeStatements : List (Nat × Place × Bool) := [
    (10, .p3, false), (10, .p5, true), (12, .p3, false), (12, .p5, true), (16, .p3, false),
    (19, .p3, false), (19, .p4, true), (21, .p3, false), (22, .p4, true), (34, .p5, false),
    (35, .p4, false), (38, .p3, false), (39, .p4, true), (40, .p4, false), (43, .p4, false),
    (45, .p4, false), (47, .p4, false), (51, .p3, false), (55, .p4, false), (56, .p4, false),
    (58, .p3, false), (58, .p5, true), (61, .p3, false), (61, .p5, true), (62, .p4, false),
    (64, .p3, false)
  ]

/-- Every statement of a list holds of its configuration, told line by line. -/
def placesHold : List (Nat × Place × Bool) → Bool
  | [] => true
  | q :: l => same (inPhase (number q.1) q.2.1) q.2.2 && placesHold l

theorem placesHold_sound : ∀ {l : List (Nat × Place × Bool)}, placesHold l = true →
    ∀ q, q ∈ l → inPhase (number q.1) q.2.1 = q.2.2
  | [], _, _, mem => nomatch mem
  | _ :: _, h, _, .head _ => same_eq (bool_of_and_true h).1
  | _ :: _, h, q, .tail _ mem => placesHold_sound (bool_of_and_true h).2 q mem

/-- **Every explicit statement of place in the 小象 but one agrees with the phase of its line.** -/
theorem placeStatements_agree : ∀ q, q ∈ placeStatements → inPhase (number q.1) q.2.1 = q.2.2 :=
  placesHold_sound rfl

/-- **需's top line is in phase**, where its 小象 says 「雖不當位」. -/
theorem xu_top_inPhase : inPhase xu .p6 = true := rfl

/-- The 小象's statements that a line is middle and in its place (中正, 正中), in the received
order: the configuration's number and the place. 艮's fifth line (`gen_fifth_out_of_phase`) is
left out. -/
def centreStatements : List (Nat × Place) := [
    (5, .p5), (6, .p5), (8, .p5), (16, .p2), (17, .p5), (35, .p2), (44, .p5), (48, .p5), (57, .p5)
  ]

/-- Every listed line is middle and in phase, told line by line. -/
def centresHold : List (Nat × Place) → Bool
  | [] => true
  | q :: l => (middle q.2 && inPhase (number q.1) q.2) && centresHold l

theorem centresHold_sound : ∀ {l : List (Nat × Place)}, centresHold l = true →
    ∀ q, q ∈ l → middle q.2 = true ∧ inPhase (number q.1) q.2 = true
  | [], _, _, mem => nomatch mem
  | _ :: _, h, _, .head _ => bool_of_and_true (bool_of_and_true h).1
  | _ :: _, h, q, .tail _ mem => centresHold_sound (bool_of_and_true h).2 q mem

/-- **Every statement of the middle in its place in the 小象 but one is of a middle line in
phase.** -/
theorem centreStatements_agree :
    ∀ q, q ∈ centreStatements → middle q.2 = true ∧ inPhase (number q.1) q.2 = true :=
  centresHold_sound rfl

/-- **艮's fifth line is middle and out of phase**, where its 小象 says 「以中正也」. -/
theorem gen_fifth_out_of_phase : middle .p5 = true ∧ inPhase gen .p5 = false := ⟨rfl, rfl⟩

/-- The 小象's statements of a broken line over an unbroken one (乘剛), in the received order: the
configuration's number and the seam below the line. -/
def fallStatements : List (Nat × Seam) := [(3, .s12), (16, .s45), (21, .s12), (47, .s23), (51, .s12)]

/-- Every listed seam falls, told seam by seam. -/
def fallsHold : List (Nat × Seam) → Bool
  | [] => true
  | q :: l => falls (number q.1) q.2 && fallsHold l

theorem fallsHold_sound : ∀ {l : List (Nat × Seam)}, fallsHold l = true →
    ∀ q, q ∈ l → falls (number q.1) q.2 = true
  | [], _, _, mem => nomatch mem
  | _ :: _, h, _, .head _ => (bool_of_and_true h).1
  | _ :: _, h, q, .tail _ mem => fallsHold_sound (bool_of_and_true h).2 q mem

/-- **Every statement of a broken line over an unbroken one in the 小象 is of a fall at the seam
below the line.** -/
theorem fallStatements_agree : ∀ q, q ∈ fallStatements → falls (number q.1) q.2 = true :=
  fallsHold_sound rfl

/-! ## Censuses of the 小象 and the 彖 (ZG6) -/

/-- Every listed line is middle, told line by line. -/
def middlesHold : List (Nat × Place) → Bool
  | [] => true
  | q :: l => middle q.2 && middlesHold l

theorem middlesHold_sound : ∀ {l : List (Nat × Place)}, middlesHold l = true →
    ∀ q, q ∈ l → middle q.2 = true
  | [], _, _, mem => nomatch mem
  | _ :: _, h, _, .head _ => (bool_of_and_true h).1
  | _ :: _, h, q, .tail _ mem => middlesHold_sound (bool_of_and_true h).2 q mem

/-- The 小象's sentences that say a line is 中 (以中, 得中, 中道, 在中, 中正, 正中, 中行, 中直, 中節,
中以為志 and the like), by configuration and place, in the received order. -/
def xiaoxiangMiddle : List (Nat × Place) := [
    (2, .p5), (5, .p2), (5, .p5), (6, .p5), (7, .p2), (7, .p5), (8, .p5), (9, .p2), (10, .p2),
    (11, .p2), (11, .p5), (13, .p5), (14, .p2), (15, .p2), (16, .p2), (16, .p5), (17, .p5),
    (18, .p2), (19, .p5), (24, .p5), (26, .p2), (29, .p2), (29, .p5), (30, .p2), (32, .p2),
    (34, .p2), (35, .p2), (39, .p5), (40, .p2), (41, .p2), (43, .p2), (43, .p5), (44, .p5),
    (45, .p2), (47, .p2), (47, .p5), (48, .p5), (50, .p5), (51, .p5), (52, .p5), (54, .p5),
    (57, .p2), (57, .p5), (60, .p5), (61, .p2), (63, .p2), (64, .p2)
  ]

/-- The 小象's other sentences with 中: 泰六四 「中心願也」 (the heart), 復六四 「中行獨復」 (quoting
its line text), 豐九四 「日中見斗」 (noon), and 震上六 「中未得也」, which says the line has not the
middle. -/
def xiaoxiangMiddleOther : List (Nat × Place) := [(11, .p4), (24, .p4), (51, .p6), (55, .p4)]

/-- **Every 小象 sentence saying a line is 中 is of a middle place**, the second or the fifth; the
four other sentences with 中 are of places that are not middle, and none of them says the line is
中. -/
theorem xiaoxiangMiddle_census :
    (∀ q, q ∈ xiaoxiangMiddle → middle q.2 = true) ∧ xiaoxiangMiddle.length = 47 ∧
      ∀ q, q ∈ xiaoxiangMiddleOther → middle q.2 = false :=
  ⟨middlesHold_sound rfl, rfl, fun q mem => match q, mem with
    | _, .head _ => rfl
    | _, .tail _ (.head _) => rfl
    | _, .tail _ (.tail _ (.head _)) => rfl
    | _, .tail _ (.tail _ (.tail _ (.head _))) => rfl⟩

/-- The top place. -/
def isTop : Place → Bool
  | .p1 => false
  | .p2 => false
  | .p3 => false
  | .p4 => false
  | .p5 => false
  | .p6 => true

/-- Every listed place is the top, told one by one. -/
def topsHold : List (Nat × Place) → Bool
  | [] => true
  | q :: l => isTop q.2 && topsHold l

theorem topsHold_sound : ∀ {l : List (Nat × Place)}, topsHold l = true → ∀ q, q ∈ l → isTop q.2 = true
  | [], _, _, mem => nomatch mem
  | _ :: _, h, _, .head _ => (bool_of_and_true h).1
  | _ :: _, h, q, .tail _ mem => topsHold_sound (bool_of_and_true h).2 q mem

/-- The sentences saying a line's way is exhausted (窮, 亢): the 小象's 乾上九 「亢龍有悔」, 坤上六
「其道窮也」, 隨上六 「上窮也」, 无妄上九 「窮之災也」, 姤上九 「上窮吝也」, 巽上九 「上窮也」, 節上六
「其道窮也」, 小過上六 「已亢也」, and 比's 彖 「後夫凶，其道窮也」 of its top line. -/
def exhaustedStatements : List (Nat × Place) := [
    (1, .p6), (2, .p6), (8, .p6), (17, .p6), (25, .p6), (44, .p6), (57, .p6), (60, .p6), (62, .p6)
  ]

/-- The 小象's other sentences with 窮: 屯六三 「往吝窮也」, 豫初六 「志窮凶也」, 大壯初九 「其孚窮也」,
旅初六 「志窮災也」, 巽九三 「志窮也」, of will, trust or going, not of a way exhausted. -/
def exhaustedOther : List (Nat × Place) := [(3, .p3), (16, .p1), (34, .p1), (56, .p1), (57, .p3)]

/-- **Every sentence saying a line's way is exhausted is of the top place**; the other sentences with
窮 are of lower places. -/
theorem exhausted_census :
    (∀ q, q ∈ exhaustedStatements → isTop q.2 = true) ∧
      ∀ q, q ∈ exhaustedOther → isTop q.2 = false :=
  ⟨topsHold_sound rfl, fun q mem => match q, mem with
    | _, .head _ => rfl
    | _, .tail _ (.head _) => rfl
    | _, .tail _ (.tail _ (.head _)) => rfl
    | _, .tail _ (.tail _ (.tail _ (.head _))) => rfl
    | _, .tail _ (.tail _ (.tail _ (.tail _ (.head _)))) => rfl⟩

/-- Every listed seam rises, told seam by seam. -/
def risesHold : List (Nat × Seam) → Bool
  | [] => true
  | q :: l => rises (number q.1) q.2 && risesHold l

theorem risesHold_sound : ∀ {l : List (Nat × Seam)}, risesHold l = true →
    ∀ q, q ∈ l → rises (number q.1) q.2 = true
  | [], _, _, mem => nomatch mem
  | _ :: _, h, _, .head _ => (bool_of_and_true h).1
  | _ :: _, h, q, .tail _ mem => risesHold_sound (bool_of_and_true h).2 q mem

/-- The sentences of a broken line carrying an unbroken one above it (承, 順乎剛): 節六四's 小象
「承上道也」 (the seam above the fourth line), 旅's 彖 「柔得中乎外，而順乎剛」 (the fifth below the
top), and 巽's 彖 「柔皆順乎剛」 (the first below the second, the fourth below the fifth). The 小象's
other 承 (師九二 「承天寵」, 蠱 「承考」 「承以德」, 歸妹 「相承」 「承虛筐」) are receiving, carrying on,
helping or holding, not of one line under another. -/
def riseStatements : List (Nat × Seam) := [(56, .s56), (57, .s12), (57, .s45), (60, .s45)]

/-- **Every sentence of a broken line carrying an unbroken one is of a rise at its seam.** -/
theorem riseStatements_agree : ∀ q, q ∈ riseStatements → rises (number q.1) q.2 = true :=
  risesHold_sound rfl

/-- The 彖's sentences that a line is 中正, by the line they speak of: 訟 「尚中正也」, 履 「剛中正」,
同人 「中正而應」 (the second and the fifth), 觀 「中正以觀天下」, 離 「柔麗乎中正」, 益 「中正有慶」
(the second and the fifth), 姤 「剛遇中正」, 巽 「剛巽乎中正」 and 節 「中正以通」. -/
def tuanCentreStatements : List (Nat × Place) := [
    (6, .p5), (10, .p5), (13, .p2), (13, .p5), (20, .p5), (30, .p2), (42, .p2), (42, .p5),
    (44, .p5), (57, .p5), (60, .p5)
  ]

/-- **Every 彖 sentence that a line is 中正 is of a middle line in phase.** -/
theorem tuanCentreStatements_agree :
    ∀ q, q ∈ tuanCentreStatements → middle q.2 = true ∧ inPhase (number q.1) q.2 = true :=
  centresHold_sound rfl

/-- Two more of the 小象's statements of place: 恆九四 「久非其位」 and 渙九五 「王居无咎，正位也」. 噬嗑
六五's 「得當也」 is not listed: its line is broken at the fifth place and out of phase, its 彖 says
「雖不當位」, and 「得當」 there is not a statement of place. -/
def placeStatementsMore : List (Nat × Place × Bool) := [(32, .p4, false), (59, .p5, true)]

/-- **They agree with the phase of their lines.** -/
theorem placeStatementsMore_agree :
    ∀ q, q ∈ placeStatementsMore → inPhase (number q.1) q.2.1 = q.2.2 :=
  placesHold_sound rfl

/-! ## The three powers (三才) -/

/-- The three bands of 說卦's 「兼三才而兩之」: earth (lines 1, 2), man (3, 4) and heaven (5, 6). -/
inductive Band where
  | earth
  | man
  | heaven
  deriving DecidableEq

deriving instance DecidableEq for Height
deriving instance DecidableEq for Seam

/-- The band of a place. -/
def bandOf : Place → Band
  | .p1 => .earth
  | .p2 => .earth
  | .p3 => .man
  | .p4 => .man
  | .p5 => .heaven
  | .p6 => .heaven

/-- The seam within a band. -/
def bandSeam : Band → Seam
  | .earth => .s12
  | .man => .s34
  | .heaven => .s56

/-- **Bands and heights are two divisions**: two places of one band have different heights, and two
places of one height lie in different bands, so neither is a function of the other. -/
theorem bands_and_heights (k k' : Place) :
    bandOf k = bandOf k' → heightOf k = heightOf k' → k = k' := by
  cases k <;> cases k' <;> intro band height <;> first | rfl | (cases band; done) | (cases height; done)

/-- **Each band spans exactly one seam**, and the band of man spans the junction of the two
trigrams: its lower place is the top of the lower trigram and its upper place the bottom of the
upper one. -/
theorem band_seams (b : Band) :
    bandOf (below (bandSeam b)) = b ∧ bandOf (above (bandSeam b)) = b ∧
      below (bandSeam .man) = place .lower .high ∧ above (bandSeam .man) = place .upper .low := by
  cases b <;> exact ⟨rfl, rfl, rfl, rfl⟩

/-- Only the band's own seam lies within it. -/
theorem band_seam_unique (b : Band) (j : Seam) :
    bandOf (below j) = b ∧ bandOf (above j) = b → j = bandSeam b := by
  cases b <;> cases j <;> decide

/-- Neither division is a function of the other: the first and fourth places share a height and not
a band, the first and second a band and not a height. -/
theorem neither_function :
    heightOf .p1 = heightOf .p4 ∧ bandOf .p1 ≠ bandOf .p4 ∧
      bandOf .p1 = bandOf .p2 ∧ heightOf .p1 ≠ heightOf .p2 := by
  decide

/-- The 彖's statements of an unbroken middle line opposed (剛中而應), in the received order. -/
def middleOppositionStatements : List Nat := [7, 19, 25, 45, 46]

/-- Every listed configuration has an unbroken middle line opposed, told one by one. -/
def middleOppositionsHold : List Nat → Bool
  | [] => true
  | n :: l => middleUnbrokenOpposed (number n) && middleOppositionsHold l

theorem middleOppositionsHold_sound : ∀ {l : List Nat}, middleOppositionsHold l = true →
    ∀ n, n ∈ l → middleUnbrokenOpposed (number n) = true
  | [], _, _, mem => nomatch mem
  | _ :: _, h, _, .head _ => (bool_of_and_true h).1
  | _ :: _, h, n, .tail _ mem => middleOppositionsHold_sound (bool_of_and_true h).2 n mem

/-- **Every configuration the 彖 says 剛中而應 of has an unbroken middle line opposed**, so, by
`middleUnbrokenOpposed_eq`, its middle height opposed. -/
theorem middleOppositionStatements_agree :
    ∀ n, n ∈ middleOppositionStatements → middleUnbrokenOpposed (number n) = true :=
  middleOppositionsHold_sound rfl

/-! ## Along the unfolding

The laws above read on the runs and frames of the spine: along every run of the law of waxing and
waning (`Law.run`), along every run of the change of one line (`changes`), on the run of the law
backward from the turned-over configuration, at every step of every run of any process, and on the
frames of any process. -/

/-- Two functions agreeing everywhere map every list alike. -/
theorem map_agree {α : Type} (f g : Nat → α) (agree : ∀ i, f i = g i) : ∀ l : List Nat, l.map f = l.map g
  | [] => rfl
  | i :: l => (congrArg (fun x => x :: l.map f) (agree i)).trans
      (congrArg (fun m => g i :: m) (map_agree f g agree l))

/-- Read with its site, a relation at a site is a claim of the indexed frame, realized where the
relation has that value there (`Contextual.indexed_fits`). -/
theorem atSites_indexed {K A : Type} (r : Hexagram → K → Bool) (P : Process Hexagram A) (s : Hexagram)
    (k : K) (b : Bool) : ((atSites r).indexed P).realized s (k, (), b) ↔ r s k = b :=
  ((atSites r).indexed_fits P s k () b).trans ⟨fun both => both.2, fun e => ⟨trivial, e⟩⟩

/-- **No frame of context-free claims fits the phases under any process**, since 乾's phases do
not glue (`phases_glue_iff`, `Contextual.fitsFree_iff`); the indexed frame fits
(`atSites_indexed`). -/
theorem phases_no_free_frame {A : Type} (P : Process Hexagram A) :
    ¬ ∃ F : Frame Hexagram A (Unit × Bool), F.P = P ∧ (atSites inPhase).FitsFree F :=
  fun fits =>
    match (phases_glue_iff (rising 6)).mp
        (((atSites inPhase).fitsFree_iff P (fun _ => .p1) (fun _ => trivial)).mp fits (rising 6)) with
    | .inl e => Bool.noConfusion (congrArg Hexagram.l2 e)
    | .inr e => Bool.noConfusion (congrArg Hexagram.l1 e)

/-- **Nor the oppositions**, since 復's do not glue (`oppositions_glue_iff`). -/
theorem oppositions_no_free_frame {A : Type} (P : Process Hexagram A) :
    ¬ ∃ F : Frame Hexagram A (Unit × Bool), F.P = P ∧ (atSites opposed).FitsFree F :=
  fun fits =>
    match (oppositions_glue_iff (rising 1)).mp
        (((atSites opposed).fitsFree_iff P (fun _ => .low) (fun _ => trivial)).mp fits (rising 1)) with
    | .inl every => Bool.noConfusion (every .mid)
    | .inr glued => Bool.noConfusion ((halves_glues_iff (rising 1)).mp glued .low)

/-- **Nor the alternations**, since 復's do not glue (`seams_glue_iff`). -/
theorem seams_no_free_frame {A : Type} (P : Process Hexagram A) :
    ¬ ∃ F : Frame Hexagram A (Unit × Bool), F.P = P ∧ (atSites alternates).FitsFree F :=
  fun fits =>
    match (seams_glue_iff (rising 1)).mp
        (((atSites alternates).fitsFree_iff P (fun _ => .s12) (fun _ => trivial)).mp fits (rising 1)) with
    | .inl e => Bool.noConfusion (congrArg Hexagram.l2 e)
    | .inr (.inl e) => Bool.noConfusion (congrArg Hexagram.l1 e)
    | .inr (.inr (.inl e)) => Bool.noConfusion (congrArg Hexagram.l3 e)
    | .inr (.inr (.inr e)) => Bool.noConfusion (congrArg Hexagram.l1 e)

/-- **Along every run of waxing and waning, each line's phase turns as it rises** (六位時成). -/
theorem run_phase_rises (s : Hexagram) (n : Nat) (j : Seam) :
    inPhase ((Law.run waxWane s).state (n + 1)) (above j) = !inPhase ((Law.run waxWane s).state n) (below j) :=
  inPhase_waxWane_above (Law.orbit waxWane s n) j

/-- **And is kept where the top line enters at the bottom as its opposite.** -/
theorem run_phase_enters (s : Hexagram) (n : Nat) :
    inPhase ((Law.run waxWane s).state (n + 1)) .p1 = inPhase ((Law.run waxWane s).state n) .p6 :=
  inPhase_waxWane_bottom (Law.orbit waxWane s n)

/-- **Along every run, the counts in phase at two consecutive steps add to five, or to seven where
the top line was in phase.** -/
theorem run_phaseCount (s : Hexagram) (n : Nat) :
    phaseCount ((Law.run waxWane s).state (n + 1)) + phaseCount ((Law.run waxWane s).state n) =
      5 + 2 * (inPhase ((Law.run waxWane s).state n) .p6).toNat :=
  phaseCount_waxWane (Law.orbit waxWane s n)

/-- **Along every run, alternations, rises and falls travel up with their two lines**, except
across the top seam. -/
theorem run_carried (s : Hexagram) (n : Nat) {j : Seam} (below_top : j ≠ .s56) :
    alternates ((Law.run waxWane s).state (n + 1)) j.next = alternates ((Law.run waxWane s).state n) j ∧
      rises ((Law.run waxWane s).state (n + 1)) j.next = rises ((Law.run waxWane s).state n) j ∧
      falls ((Law.run waxWane s).state (n + 1)) j.next = falls ((Law.run waxWane s).state n) j :=
  ⟨alternates_carried _ j below_top, rises_carried _ j below_top, falls_carried _ j below_top⟩

/-- **Six steps on along every run, every phase is turned and the counts in phase add to six**:
six steps give the complement (`run_six_steps`). -/
theorem run_six_turns (s : Hexagram) (n : Nat) :
    (∀ k, inPhase ((Law.run waxWane s).state (n + 6)) k = !inPhase ((Law.run waxWane s).state n) k) ∧
      phaseCount ((Law.run waxWane s).state (n + 6)) + phaseCount ((Law.run waxWane s).state n) = 6 :=
  ⟨fun k => (congrArg (fun x => inPhase x k) (run_six_steps s n)).trans (inPhase_complement _ k),
   (congrArg (fun x => phaseCount x + phaseCount ((Law.run waxWane s).state n)) (run_six_steps s n)).trans
     (phaseCount_complement _)⟩

/-- **So, opposition being told by phase, every opposition is kept six steps on** (both phases at a
height turned, `opposed_iff_phase`); every alternation is kept, and rises and falls are
exchanged. -/
theorem run_six_keeps (s : Hexagram) (n : Nat) :
    (∀ h, opposed ((Law.run waxWane s).state (n + 6)) h = opposed ((Law.run waxWane s).state n) h) ∧
      (∀ j, alternates ((Law.run waxWane s).state (n + 6)) j = alternates ((Law.run waxWane s).state n) j) ∧
      (∀ j, rises ((Law.run waxWane s).state (n + 6)) j = falls ((Law.run waxWane s).state n) j) :=
  ⟨fun h =>
    let later := (Law.run waxWane s).state (n + 6)
    let now := (Law.run waxWane s).state n
    let turned := (run_six_turns s n).1
    (opposed_iff_phase later h).trans
      ((congrArg (fun x => same x (inPhase later (place .upper h))) (turned (place .lower h))).trans
        ((congrArg (same (!inPhase now (place .lower h))) (turned (place .upper h))).trans
          ((same_not_not _ _).trans (opposed_iff_phase now h).symm))),
   fun j => (congrArg (fun x => alternates x j) (run_six_steps s n)).trans (alternates_complement _ j),
   fun j => (congrArg (fun x => rises x j) (run_six_steps s n)).trans (rises_complement _ j)⟩

/-- **Three steps on along every run, every opposition is turned.** -/
theorem run_three_turns (s : Hexagram) (n : Nat) (h : Height) :
    opposed ((Law.run waxWane s).state (n + 3)) h = !opposed ((Law.run waxWane s).state n) h :=
  (congrArg (fun x => opposed x h) (Law.orbit_add waxWane s n 3)).trans (opposed_three_steps _ h)

/-- **Along every run, a configuration whose trigrams glue is three steps from opposition at every
height.** -/
theorem run_doubled_three (s : Hexagram) (n : Nat) (glued : halves.Glues ((Law.run waxWane s).state n))
    (h : Height) : opposed ((Law.run waxWane s).state (n + 3)) h = true :=
  (congrArg (fun x => opposed x h) (Law.orbit_add waxWane s n 3)).trans (halves_glue_three glued h)

/-- **Along every run, the pattern of oppositions changes at every step.** -/
theorem run_opposition_moves (s : Hexagram) (n : Nat) :
    opposition ((Law.run waxWane s).state (n + 1)) ≠ opposition ((Law.run waxWane s).state n) :=
  fun kept => waxWane3_moves _ ((opposition_waxWane (Law.orbit waxWane s n)).symm.trans kept)

/-- **And it is had again two steps on exactly at the two patterns that alternate.** -/
theorem run_opposition_two_iff (s : Hexagram) (n : Nat) :
    opposition ((Law.run waxWane s).state (n + 2)) = opposition ((Law.run waxWane s).state n) ↔
      opposition ((Law.run waxWane s).state n) = (true, false, true) ∨
        opposition ((Law.run waxWane s).state n) = (false, true, false) :=
  have shifted : (Law.run waxWane s).state (n + 2) = Law.orbit waxWane ((Law.run waxWane s).state n) 2 :=
    Law.orbit_add waxWane s n 2
  ⟨fun back => (opposition_two_iff _).mp ((congrArg opposition shifted).symm.trans back),
   fun pattern => (congrArg opposition shifted).trans ((opposition_two_iff _).mpr pattern)⟩

/-- The oppositions along an orbit follow the law on three cells. -/
theorem opposition_orbit (s : Hexagram) :
    ∀ i, opposition (Law.orbit waxWane s i) = Law.orbit waxWane3 (opposition s) i
  | 0 => rfl
  | i + 1 => (opposition_waxWane _).trans (congrArg waxWane3 (opposition_orbit s i))

/-- **Along every run, from a step with every height opposed, the oppositions go through every
height alike and back in six steps** (`opposition_cycle`). -/
theorem run_opposition_cycle (s : Hexagram) (n : Nat)
    (every : opposition ((Law.run waxWane s).state n) = (true, true, true)) :
    (List.range 7).map (fun i => opposition ((Law.run waxWane s).state (n + i))) =
      [(true, true, true), (false, true, true), (false, false, true), (false, false, false),
        (true, false, false), (true, true, false), (true, true, true)] :=
  (map_agree (fun i => opposition ((Law.run waxWane s).state (n + i))) (Law.orbit waxWane3 (true, true, true))
    (fun i => (congrArg opposition (Law.orbit_add waxWane s n i)).trans
      ((opposition_orbit _ i).trans (congrArg (fun p => Law.orbit waxWane3 p i) every)))
    (List.range 7)).trans opposition_cycle

/-- **Along every run of the change of one line, each step turns the phase of the line it changes
and keeps every other phase, moving the count in phase by one.** -/
theorem changes_run_phase (r : Run changes) (n : Nat) :
    inPhase (r.state (n + 1)) (r.act n) = !inPhase (r.state n) (r.act n) ∧
      (∀ k, r.act n ≠ k → inPhase (r.state (n + 1)) k = inPhase (r.state n) k) ∧
      (phaseCount (r.state (n + 1)) + 1 = phaseCount (r.state n) ∨
        phaseCount (r.state n) + 1 = phaseCount (r.state (n + 1))) :=
  have step : r.state (n + 1) = flip (r.act n) (r.state n) := r.step n
  ⟨(congrArg (fun x => inPhase x (r.act n)) step).trans (inPhase_flip_self _ _),
   fun k other => (congrArg (fun x => inPhase x k) step).trans (inPhase_flip_other _ other),
   match phaseCount_flip (r.act n) (r.state n) with
   | .inl down => .inl ((congrArg (fun x => phaseCount x + 1) step).trans down)
   | .inr up => .inr (up.trans (congrArg phaseCount step).symm)⟩

/-- **And turns the opposition at the changed line's height, keeping every other.** -/
theorem changes_run_opposition (r : Run changes) (n : Nat) :
    opposed (r.state (n + 1)) (heightOf (r.act n)) = !opposed (r.state n) (heightOf (r.act n)) ∧
      ∀ h, heightOf (r.act n) ≠ h → opposed (r.state (n + 1)) h = opposed (r.state n) h :=
  have step : r.state (n + 1) = flip (r.act n) (r.state n) := r.step n
  ⟨(congrArg (fun x => opposed x (heightOf (r.act n))) step).trans (opposed_flip_self _ _),
   fun h other => (congrArg (fun x => opposed x h) step).trans (opposed_flip_other _ other)⟩

/-- **Turned over, a run of waxing and waning is the run of the law backward from the
turned-over configuration** (`reverse_wax`). -/
theorem backward_run (s : Hexagram) :
    ∀ n, (Law.run unwaxWane (reverse s)).state n = reverse ((Law.run waxWane s).state n)
  | 0 => rfl
  | n + 1 => (congrArg unwaxWane (backward_run s n)).trans (reverse_wax _).symm

/-- **So the run backward shows each line at the mirrored place, every phase turned, the counts in
phase adding to six, every opposition at the mirrored height, and rises and falls exchanged at the
mirrored seam.** -/
theorem backward_relations (s : Hexagram) (n : Nat) :
    (∀ k, ((Law.run unwaxWane (reverse s)).state n).line (Place.mirror k) =
        ((Law.run waxWane s).state n).line k) ∧
      (∀ k, inPhase ((Law.run unwaxWane (reverse s)).state n) (Place.mirror k) =
        !inPhase ((Law.run waxWane s).state n) k) ∧
      phaseCount ((Law.run unwaxWane (reverse s)).state n) + phaseCount ((Law.run waxWane s).state n) = 6 ∧
      (∀ h, opposed ((Law.run unwaxWane (reverse s)).state n) (Height.mirror h) =
        opposed ((Law.run waxWane s).state n) h) ∧
      (∀ j, rises ((Law.run unwaxWane (reverse s)).state n) (Seam.mirror j) =
        falls ((Law.run waxWane s).state n) j) :=
  have e := backward_run s n
  ⟨fun k => (congrArg (fun x => Hexagram.line x (Place.mirror k)) e).trans (line_reverse _ k),
   fun k => (congrArg (fun x => inPhase x (Place.mirror k)) e).trans (inPhase_reverse _ k),
   (congrArg (fun x => phaseCount x + phaseCount ((Law.run waxWane s).state n)) e).trans (phaseCount_reverse _),
   fun h => (congrArg (fun x => opposed x (Height.mirror h)) e).trans (opposed_reverse _ h),
   fun j => (congrArg (fun x => rises x (Seam.mirror j)) e).trans (rises_reverse _ j)⟩

/-- **Whatever a run of any process shows, opposition is told by phase**: the lines at a height are
opposed exactly where both or neither are in phase, so both middle lines in phase give the middle
opposed and every line in phase, or every line out of phase, gives every height opposed; an
unbroken and a broken middle line with an answer are the middle height opposed; and rises and the
bottom line count as many as falls and the top line. -/
theorem shown_along_run {A : Type} {P : Process Hexagram A} (r : Run P) (n : Nat) :
    (∀ h, opposed (r.state n) h =
        same (inPhase (r.state n) (place .lower h)) (inPhase (r.state n) (place .upper h))) ∧
      (inPhase (r.state n) .p2 = true → inPhase (r.state n) .p5 = true → opposed (r.state n) .mid = true) ∧
      ((∀ k, inPhase (r.state n) k = true) → ∀ h, opposed (r.state n) h = true) ∧
      ((∀ k, inPhase (r.state n) k = false) → ∀ h, opposed (r.state n) h = true) ∧
      middleUnbrokenOpposed (r.state n) = opposed (r.state n) .mid ∧
      middleBrokenOpposed (r.state n) = opposed (r.state n) .mid ∧
      riseCount (r.state n) + (r.state n).l1.toNat = fallCount (r.state n) + (r.state n).l6.toNat :=
  ⟨opposed_iff_phase (r.state n), middle_phase_opposed, in_phase_opposed, out_of_phase_opposed,
   middleUnbrokenOpposed_eq _, middleBrokenOpposed_eq _, rises_falls_ends _⟩

end Hexagram

end Becoming
