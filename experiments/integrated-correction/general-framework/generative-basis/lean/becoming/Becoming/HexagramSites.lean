import Becoming.HexagramPlaces

/-!
# The relations of the places read at other sites: between the ends, and at every pair

`Becoming.HexagramPlaces` reads 正, 應, 比 and 中 at their sites: the phase at each of the six
places, opposition at each height, alternation, rise and fall at each seam. 王弼's 《周易略例》
(preserved in `sources/zhouyi-yizhuan/lueli/`) reads two of these relations at other sites: the
phase only at the four places between the ends (辯位: 初上無陰陽定位), and the answer of two lines
at every pair of places through one line (明彖: 一卦五陽而一陰，則一陰為之主). This module states
both, with no premise, beside the relations of `HexagramPlaces`, and proves how they meet them.

* **The places between the ends.** In the second relation a line between the ends, lines 2 to 5,
  has the phase of `inPhase`, and a line at the bottom or the top has none (`betweenEnds`,
  `fixedPhase`, `fixedPhase_between`, `fixedPhase_end`); a line holds its place where it is in
  phase between the ends (`holdsPlace`, `holdsPlace_iff`, `holdsPlace_inPhase`,
  `holdsPlace_ends`).
* **王弼's argument as a law of the text's statements.** Of two lines that differ at a place,
  every parity of the place puts one in phase (`one_in_phase_of_parity`); 需's top line is broken
  and 乾's unbroken, and the text says neither holds its place (「雖不當位」, 「貴而无位」), so no
  parity of the top fits both (`top_no_parity`). The 小象's statements of place fix the parity of
  places 3, 4 and 5 and its statements of 中正 that of place 2 (`statements_fix_parity`,
  `centre_fixes_parity`); every one is of a place between the ends (`placeStatements_between`).
  Under the second relation every statement of place of the 小象 holds, 需上六's and 乾上九's
  included (`placeStatements_hold`, `xu_top_no_place`, `qian_top`).
* **The 彖's statements of place.** Its nine statements of one line are of places between the ends
  and hold under both relations (`tuanPlaceStatements_agree`); its five statements of a whole
  configuration (蹇, 漸, 歸妹, 既濟, 未濟) all hold under the second relation and two under the first
  (`tuanWhole_between`, `tuanWhole_six`). Every line between the ends holds its place exactly at
  既濟, 蹇, 漸 and 家人, and none does exactly at 未濟, 歸妹, 解 and 睽 (`allHold_iff`,
  `noneHold_iff`).
* **A reading in context.** The phases at the four sites between the ends glue to a reading of the
  whole exactly at those eight configurations, where the six-place phases glue at two, and no frame
  of context-free claims fits them under any process (`between_glues_iff`,
  `between_no_free_frame`, `between_glue_along_run`).
* **What the phases between the ends tell.** A fall across a seam is both lines taking the lower
  place's parity, a rise both taking the other, an alternation both or neither in phase
  (`falls_iff_phase`, `rises_iff_phase`, `alternates_iff_phase`). So configurations showing the
  same phases between the ends agree on the opposition of the middle height and on every relation
  at the three seams between them (`opposed_mid_told`, `inner_seams_told`), while changing the
  bottom or the top line keeps every phase between the ends and turns the opposition of its height
  and the alternation of its seam (`ends_not_told`): 應 at 初四 and 三上 and 比 at the end seams are
  relations of the lines, not of the places.
* **Under the complement, turning over and the change of a line.** The complement turns every
  phase between the ends and turning over takes them to the mirrored place
  (`fixedPhase_complement`, `fixedPhase_reverse`, `placedCount_complement`); changing a line
  between the ends turns its phase, and changing one at an end changes none
  (`fixedPhase_flip_self`, `sameBetween_flip_end`).
* **Under the law of waxing and waning.** The phase at 二 after a step is decided by the line at 初,
  which has none, and between the ends each phase turns as its line rises
  (`fixedPhase_waxWane_enters`, `fixedPhase_waxWane_rises`, `placedCount_waxWane`); so the phases
  between the ends are not a lumping the law goes alike across (`betweenPhases_not_lumped`,
  `betweenPhases_not_goAlike`): 卦不可無六爻. A line holds its place at two of its four places
  between the ends on its way up (`course_between`).
* **Answering at every pair.** Two lines answer each other where their values differ (`answers`);
  應 is answering at a height and 比 at a seam (`opposed_answers`, `alternates_answers`), and
  answering is symmetric (`answers_symm`). A line is sole where every other line answers it
  (`sole`, `sole_answered`, `sole_of_answered`): exactly where its value is held by one line, so
  where a configuration has one unbroken line or five (`sole_count`, `soleAny_count`), at most one
  line (`sole_unique`), at the twelve configurations one change from 乾 or 坤 (`sole_iff_flip`,
  `sole_flip`). The complement and turning over keep it (`sole_complement`, `sole_reverse`).
* **The sole line and the relations of the places.** A sole line is in phase at some
  configurations and out of phase at others, at every place: four of the twelve hold their place,
  four are out of phase between the ends and four are at an end (`sole_any_phase`,
  `sole_places`). Read at the heights it has one answer, its own height opposed, where read at
  every pair it has five (`sole_opposition`); one opposed height does not make a sole line
  (`jie_one_opposed`). Read at the seams a broken sole line has one fall below it and one rise above
  it, an unbroken one the other way round (`sole_broken_seams`, `sole_unbroken_seams`); 夬 is the
  configuration whose broken top line is answered by the five unbroken lines below it
  (`guai_iff`, `guai_sole`).
* **The sole line under the law of waxing and waning.** No configuration with a sole line has one a
  step later (`soleAny_waxWane`, `sole_waxWane_none`); six steps on the sole line is back at its
  place with its value turned (`sole_six`); a sole line at the top passes out and leaves every line
  alike, and the next step a sole line enters at the bottom (`sole_top_passes`): 初上者，始終之象.
* **Censuses.** The 彖 says 上下應 of three configurations, each with a sole line, the one it names
  (`answeredStatements_sole`); 履's third line is sole and 豐 has none, as the 略例 says
  (`lv_sole`, `feng_no_sole`). The line texts (爻辭) say 中 at eleven lines, every one between the
  ends and five at a middle place, and 位 at one, 萃's fifth line, which holds its place
  (`lineTextMiddle_places`, `lineTextPlace_holds`). The chapter's check finds every statement of
  each list in the preserved pages.
* **Along the unfolding.** These laws are read on the runs of the spine: along every run of waxing
  and waning (`run_between_rises`, `run_placedCount`, `run_course_between`, `run_between_six`,
  `run_sole`), on the run backward from the turned-over configuration (`backward_between`,
  `backward_sole`), along every run of the change of one line (`changes_run_between`,
  `changes_run_ends`, `changes_run_sole`), and at every step of every run of any process
  (`between_shown_along_runs`, `between_glue_along_run`, `sole_shown_along_run`,
  `answers_shown_along_run`).

What the 略例 adds to these relations, the ranks of the places (尊卑, 貴賤), the evaluations
(安危, 逆順, 美) and the governance it reads into the sole line (治眾, 主), is not in this module; the
chapter on the 易传 reads each passage. Answering is symmetric, so the sole line answers each
other line exactly as it is answered.

**Classical sources.** 王弼, 《周易略例》 (明彖, 辯位, 略例下), in the Wikisource revision preserved
here with 邢璹's notes. The relations of `HexagramPlaces` are the 彖's and the 象's.

No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

open Generative

namespace Hexagram

/-! ## Lists told member by member -/

theorem all_congr {α : Type} {p q : α → Bool} (h : ∀ x, p x = q x) : ∀ l : List α, l.all p = l.all q
  | [] => rfl
  | a :: l => (congrArg (fun b => b && l.all p) (h a)).trans (congrArg (fun b => q a && b) (all_congr h l))

theorem same_comm : ∀ x y : Bool, same x y = same y x
  | true, true => rfl
  | true, false => rfl
  | false, true => rfl
  | false, false => rfl

/-! ## The places between the ends (初上無位) -/

/-- **The places between the ends**, lines 2 to 5: in 王弼's reading the places with a fixed
parity; the bottom (初) and the top (上) have none (初上無陰陽定位). -/
def betweenEnds : Place → Bool
  | .p1 => false
  | .p2 => true
  | .p3 => true
  | .p4 => true
  | .p5 => true
  | .p6 => false

/-- The four places between the ends, as sites. -/
inductive Between where
  | q2
  | q3
  | q4
  | q5

/-- The place of a site between the ends. -/
def Between.place : Between → Place
  | .q2 => .p2
  | .q3 => .p3
  | .q4 => .p4
  | .q5 => .p5

/-- **The phase with the ends left without a place** (王弼's reading of 位): between the ends, the
phase of the line (`inPhase`); at the bottom and the top, none. -/
def fixedPhase (s : Hexagram) : Place → Option Bool
  | .p1 => none
  | .p2 => some (inPhase s .p2)
  | .p3 => some (inPhase s .p3)
  | .p4 => some (inPhase s .p4)
  | .p5 => some (inPhase s .p5)
  | .p6 => none

/-- **Holding a place** (當位 in 王弼's reading): a line between the ends, in phase. -/
def holdsPlace (s : Hexagram) (k : Place) : Bool := betweenEnds k && inPhase s k

/-- **Between the ends the second relation is the phase.** -/
theorem fixedPhase_between : ∀ (s : Hexagram) (k : Place), betweenEnds k = true →
    fixedPhase s k = some (inPhase s k)
  | _, .p1, h => Bool.noConfusion h
  | _, .p2, _ => rfl
  | _, .p3, _ => rfl
  | _, .p4, _ => rfl
  | _, .p5, _ => rfl
  | _, .p6, h => Bool.noConfusion h

/-- **At the ends it shows nothing.** -/
theorem fixedPhase_end : ∀ (s : Hexagram) (k : Place), betweenEnds k = false → fixedPhase s k = none
  | _, .p1, _ => rfl
  | _, .p2, h => Bool.noConfusion h
  | _, .p3, h => Bool.noConfusion h
  | _, .p4, h => Bool.noConfusion h
  | _, .p5, h => Bool.noConfusion h
  | _, .p6, _ => rfl

/-- **A line holds its place exactly where the second relation shows it in phase.** -/
theorem holdsPlace_iff : ∀ (s : Hexagram) (k : Place), holdsPlace s k = true ↔ fixedPhase s k = some true
  | _, .p1 => ⟨fun h => Bool.noConfusion h, fun h => nomatch h⟩
  | _, .p2 => ⟨congrArg some, Option.some.inj⟩
  | _, .p3 => ⟨congrArg some, Option.some.inj⟩
  | _, .p4 => ⟨congrArg some, Option.some.inj⟩
  | _, .p5 => ⟨congrArg some, Option.some.inj⟩
  | _, .p6 => ⟨fun h => Bool.noConfusion h, fun h => nomatch h⟩

/-- **Holding a place is narrower than being in phase**: it is being in phase between the ends. -/
theorem holdsPlace_inPhase {s : Hexagram} {k : Place} (h : holdsPlace s k = true) : inPhase s k = true :=
  (bool_of_and_true h).2

/-- **No line holds the bottom or the top place.** -/
theorem holdsPlace_ends (s : Hexagram) : holdsPlace s .p1 = false ∧ holdsPlace s .p6 = false := ⟨rfl, rfl⟩

/-! ## 王弼's argument: no parity fits the text's statements at the top -/

/-- 乾 (1). -/
def qian : Hexagram := number 1

/-- **Under every parity of a place, of two lines that differ there one is in phase.** -/
theorem one_in_phase_of_parity : ∀ {x y : Bool}, x ≠ y → ∀ b : Bool, same x b = true ∨ same y b = true
  | true, true, ne, _ => absurd rfl ne
  | false, false, ne, _ => absurd rfl ne
  | true, false, _, true => .inl rfl
  | true, false, _, false => .inr rfl
  | false, true, _, true => .inr rfl
  | false, true, _, false => .inl rfl

/-- **No parity of the top place fits both statements the text makes there** (辯位): 需's top
line is broken and 乾's unbroken, so under either parity one of them would be in phase, while the
小象 of 需 says 「雖不當位」 and the 文言 of 乾 「貴而无位」. -/
theorem top_no_parity : ¬ ∃ b : Bool, same (xu.line .p6) b = false ∧ same (qian.line .p6) b = false :=
  fun ⟨b, hx, hq⟩ =>
    match one_in_phase_of_parity (x := xu.line .p6) (y := qian.line .p6) (fun e => Bool.noConfusion e) b with
    | .inl h => Bool.noConfusion (h.symm.trans hx)
    | .inr h => Bool.noConfusion (h.symm.trans hq)

/-- The parity a statement of place gives: the line's value where it says the line is in phase,
the opposite where it says it is not. -/
def parityOf : Bool → Bool → Bool
  | x, true => x
  | x, false => !x

theorem parity_of_statement : ∀ {x b q : Bool}, same x b = q → b = parityOf x q
  | true, true, true, _ => rfl
  | true, true, false, h => Bool.noConfusion h
  | true, false, true, h => Bool.noConfusion h
  | true, false, false, _ => rfl
  | false, true, true, h => Bool.noConfusion h
  | false, true, false, _ => rfl
  | false, false, true, _ => rfl
  | false, false, false, h => Bool.noConfusion h

/-- **The 小象's statements of place fix the parity of places 3, 4 and 5**: under any parity of the
places for which every listed statement holds, the parity there is `odd`'s (履六三 位不當, 臨六四
位當 and 履九五 位正當 suffice), and `odd` is such a parity (`placeStatements_agree`). -/
theorem statements_fix_parity (par : Place → Bool)
    (fits : ∀ q, q ∈ placeStatements → same ((number q.1).line q.2.1) (par q.2.1) = q.2.2) :
    par .p3 = odd .p3 ∧ par .p4 = odd .p4 ∧ par .p5 = odd .p5 :=
  ⟨parity_of_statement (fits (10, .p3, false) (List.Mem.head _)),
   parity_of_statement (fits (19, .p4, true) (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _
     (List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _)))))))),
   parity_of_statement (fits (10, .p5, true) (List.Mem.tail _ (List.Mem.head _)))⟩

/-- **The 小象's statements of the middle in its place fix the parity of place 2** (豫六二
中正). -/
theorem centre_fixes_parity (par : Place → Bool)
    (fits : ∀ q, q ∈ centreStatements → same ((number q.1).line q.2) (par q.2) = true) :
    par .p2 = odd .p2 :=
  parity_of_statement (fits (16, .p2) (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _)))))

/-- **Every statement of place of the 小象 is of a place between the ends** (《象》無初上得位失位之文):
需上六 is left out of the list (`xu_top_inPhase`). -/
theorem placeStatements_between : ∀ q, q ∈ placeStatements → betweenEnds q.2.1 = true :=
  ListTests.all_sound (fun (q : Nat × Place × Bool) => betweenEnds q.2.1) rfl

/-- The statements of place at the top: 乾上九 (文言, 「貴而无位」) and 需上六 (小象, 「雖不當位」),
each saying the line does not hold its place. -/
def topStatements : List (Nat × Place × Bool) := [(1, .p6, false), (5, .p6, false)]

/-- **Under the second relation every statement of place of the 小象 holds, 需上六's included, and
so does 乾上九's 「无位」.** -/
theorem placeStatements_hold :
    ∀ q, q ∈ placeStatements ++ topStatements → holdsPlace (number q.1) q.2.1 = q.2.2 :=
  fun q mem => same_eq (ListTests.all_sound (fun (q : Nat × Place × Bool) => same (holdsPlace (number q.1) q.2.1) q.2.2) rfl q mem)

/-- **需's top line holds no place under the second relation, as its 小象 says, though it is in phase
under the first.** -/
theorem xu_top_no_place : fixedPhase xu .p6 = none ∧ holdsPlace xu .p6 = false ∧ inPhase xu .p6 = true :=
  ⟨rfl, rfl, rfl⟩

/-- **乾's top line is out of phase under the first relation and holds no place under the second.** -/
theorem qian_top : inPhase qian .p6 = false ∧ holdsPlace qian .p6 = false := ⟨rfl, rfl⟩

/-! ## The 彖's statements of place -/

/-- The 彖's statements of place of one line, in the received order: the configuration's number, the
place and whether the line holds its place: 小畜 柔得位 (六四), 同人 柔得位 (六二), 噬嗑 雖不當位
(六五), 遯 剛當位 (九五), 家人 女正位乎內 (六二) and 男正位乎外 (九五), 渙 柔得位乎外 (六四), 節
當位以節 (九五), 小過 剛失位 (九四). -/
def tuanPlaceStatements : List (Nat × Place × Bool) := [
    (9, .p4, true), (13, .p2, true), (21, .p5, false), (33, .p5, true), (37, .p2, true),
    (37, .p5, true), (59, .p4, true), (60, .p5, true), (62, .p4, false)
  ]

/-- **Every statement of place of one line in the 彖 is of a place between the ends, and agrees with
its line's phase under both relations.** -/
theorem tuanPlaceStatements_agree : ∀ q, q ∈ tuanPlaceStatements →
    betweenEnds q.2.1 = true ∧ inPhase (number q.1) q.2.1 = q.2.2 ∧ holdsPlace (number q.1) q.2.1 = q.2.2 :=
  fun q mem =>
    have h := bool_of_and_true (ListTests.all_sound (fun (q : Nat × Place × Bool) => betweenEnds q.2.1 &&
      (same (inPhase (number q.1) q.2.1) q.2.2 && same (holdsPlace (number q.1) q.2.1) q.2.2)) rfl q mem)
    ⟨h.1, same_eq (bool_of_and_true h.2).1, same_eq (bool_of_and_true h.2).2⟩

/-- Every line between the ends holds its place. -/
def allHold (s : Hexagram) : Bool := inPhase s .p2 && inPhase s .p3 && inPhase s .p4 && inPhase s .p5

/-- No line between the ends holds its place. -/
def noneHold (s : Hexagram) : Bool :=
  !inPhase s .p2 && !inPhase s .p3 && !inPhase s .p4 && !inPhase s .p5

/-- A statement of place of a whole configuration read under the second relation: every line
between the ends holds its place (`true`), or none does (`false`). -/
def wholeBetween (s : Hexagram) : Bool → Bool
  | true => allHold s
  | false => noneHold s

/-- The same statement read under the first relation: every line in phase, or none. -/
def wholeSix (s : Hexagram) : Bool → Bool
  | true => allHold s && inPhase s .p1 && inPhase s .p6
  | false => noneHold s && !inPhase s .p1 && !inPhase s .p6

/-- The 彖's statements of place of a whole configuration, in the received order: 蹇 「當位貞吉」,
漸 「進得位」, 歸妹 「位不當也」, 既濟 「剛柔正而位當也」, 未濟 「雖不當位」. -/
def tuanWholeStatements : List (Nat × Bool) := [(39, true), (53, true), (54, false), (63, true), (64, false)]

/-- **Every statement of place of a whole configuration in the 彖 holds under the second relation.** -/
theorem tuanWhole_between : ∀ q, q ∈ tuanWholeStatements → wholeBetween (number q.1) q.2 = true :=
  ListTests.all_sound (fun (q : Nat × Bool) => wholeBetween (number q.1) q.2) rfl

/-- 蹇 (39). -/
def jian3 : Hexagram := number 39

/-- 漸 (53). -/
def jian4 : Hexagram := number 53

/-- 家人 (37). -/
def jiaRen : Hexagram := number 37

/-- 睽 (38). -/
def kui : Hexagram := number 38

/-- 解 (40). -/
def xie : Hexagram := number 40

/-- **Under the first relation only those of 既濟 and 未濟 hold**: 蹇's and 漸's bottom lines and
漸's top line are out of phase, and 歸妹's bottom and top lines are in phase. -/
theorem tuanWhole_six :
    wholeSix jian3 true = false ∧ wholeSix jian4 true = false ∧ wholeSix guiMei false = false ∧
      wholeSix jiJi true = true ∧ wholeSix weiJi false = true ∧
      inPhase jian3 .p1 = false ∧ inPhase jian4 .p1 = false ∧ inPhase jian4 .p6 = false ∧
      inPhase guiMei .p1 = true ∧ inPhase guiMei .p6 = true :=
  ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

/-- **Every line between the ends holds its place exactly at 既濟, 蹇, 漸 and 家人.** -/
theorem allHold_iff (s : Hexagram) : allHold s = true ↔ s = jiJi ∨ s = jian3 ∨ s = jian4 ∨ s = jiaRen :=
  ⟨fun h => by
    cases s with
    | mk a b c d e f =>
      cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> cases f <;>
        first
        | exact .inl rfl
        | exact .inr (.inl rfl)
        | exact .inr (.inr (.inl rfl))
        | exact .inr (.inr (.inr rfl))
        | exact Bool.noConfusion h,
   fun
    | .inl e => by subst e; rfl
    | .inr (.inl e) => by subst e; rfl
    | .inr (.inr (.inl e)) => by subst e; rfl
    | .inr (.inr (.inr e)) => by subst e; rfl⟩

/-- **No line between the ends holds its place exactly at 未濟, 歸妹, 解 and 睽.** -/
theorem noneHold_iff (s : Hexagram) : noneHold s = true ↔ s = weiJi ∨ s = guiMei ∨ s = xie ∨ s = kui :=
  ⟨fun h => by
    cases s with
    | mk a b c d e f =>
      cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> cases f <;>
        first
        | exact .inl rfl
        | exact .inr (.inl rfl)
        | exact .inr (.inr (.inl rfl))
        | exact .inr (.inr (.inr rfl))
        | exact Bool.noConfusion h,
   fun
    | .inl e => by subst e; rfl
    | .inr (.inl e) => by subst e; rfl
    | .inr (.inr (.inl e)) => by subst e; rfl
    | .inr (.inr (.inr e)) => by subst e; rfl⟩

/-! ## The phases between the ends as a reading in context -/

/-- The phase at each site between the ends. -/
def betweenPhase (s : Hexagram) (q : Between) : Bool := inPhase s q.place

theorem allHold_sites (s : Hexagram) : allHold s = true ↔ ∀ q, betweenPhase s q = true :=
  ⟨fun h =>
    have h123 := bool_of_and_true h
    have h12 := bool_of_and_true h123.1
    have h1 := bool_of_and_true h12.1
    fun
    | .q2 => h1.1
    | .q3 => h1.2
    | .q4 => h12.2
    | .q5 => h123.2,
   fun all => by
    have h2 : inPhase s .p2 = true := all .q2
    have h3 : inPhase s .p3 = true := all .q3
    have h4 : inPhase s .p4 = true := all .q4
    have h5 : inPhase s .p5 = true := all .q5
    show (inPhase s .p2 && inPhase s .p3 && inPhase s .p4 && inPhase s .p5) = true
    rw [h2, h3, h4, h5]
    rfl⟩

theorem noneHold_sites (s : Hexagram) : noneHold s = true ↔ ∀ q, betweenPhase s q = false :=
  ⟨fun h =>
    have h123 := bool_of_and_true h
    have h12 := bool_of_and_true h123.1
    have h1 := bool_of_and_true h12.1
    fun
    | .q2 => ListTests.false_of_not h1.1
    | .q3 => ListTests.false_of_not h1.2
    | .q4 => ListTests.false_of_not h12.2
    | .q5 => ListTests.false_of_not h123.2,
   fun all => by
    have h2 : inPhase s .p2 = false := all .q2
    have h3 : inPhase s .p3 = false := all .q3
    have h4 : inPhase s .p4 = false := all .q4
    have h5 : inPhase s .p5 = false := all .q5
    show (!inPhase s .p2 && !inPhase s .p3 && !inPhase s .p4 && !inPhase s .p5) = true
    rw [h2, h3, h4, h5]
    rfl⟩

/-- **The phases between the ends glue to a reading of the whole exactly where every line between
the ends holds its place or none does**: at eight configurations, where the six-place phases glue
at two (`phases_glue_iff`). -/
theorem between_glues_iff (s : Hexagram) :
    (atSites betweenPhase).Glues s ↔ allHold s = true ∨ noneHold s = true :=
  (atSites_glues_iff_constant betweenPhase .q2 s).trans
    ⟨fun
      | .inl all => .inl ((allHold_sites s).mpr all)
      | .inr nowhere => .inr ((noneHold_sites s).mpr nowhere),
     fun
      | .inl h => .inl ((allHold_sites s).mp h)
      | .inr h => .inr ((noneHold_sites s).mp h)⟩

/-- **No frame of context-free claims fits the phases between the ends under any process**, since
乾's do not glue; the indexed frame fits (`atSites_indexed`). -/
theorem between_no_free_frame {A : Type} (P : Process Hexagram A) :
    ¬ ∃ F : Frame Hexagram A (Unit × Bool), F.P = P ∧ (atSites betweenPhase).FitsFree F :=
  fun fits =>
    match (between_glues_iff qian).mp
        (((atSites betweenPhase).fitsFree_iff P (fun _ => .q2) (fun _ => trivial)).mp fits qian) with
    | .inl h => Bool.noConfusion h
    | .inr h => Bool.noConfusion h

/-! ## What the phases between the ends tell -/

/-- Two configurations show the same phases between the ends. -/
def SameBetween (s t : Hexagram) : Prop := ∀ k, fixedPhase s k = fixedPhase t k

theorem sameBetween_phase {s t : Hexagram} (same : SameBetween s t) {k : Place} (h : betweenEnds k = true) :
    inPhase s k = inPhase t k :=
  Option.some.inj (((fixedPhase_between s k h).symm.trans (same k)).trans (fixedPhase_between t k h))

/-- **A fall across a seam is both lines taking the lower place's parity**: both in phase above an
odd place, both out of phase above an even one (乘 told by 正). -/
theorem falls_iff_phase : ∀ (s : Hexagram) (j : Seam),
    falls s j = (same (inPhase s (below j)) (odd (below j)) && same (inPhase s (above j)) (odd (below j)))
  | ⟨a, b, _, _, _, _⟩, .s12 => by cases a <;> cases b <;> rfl
  | ⟨_, b, c, _, _, _⟩, .s23 => by cases b <;> cases c <;> rfl
  | ⟨_, _, c, d, _, _⟩, .s34 => by cases c <;> cases d <;> rfl
  | ⟨_, _, _, d, e, _⟩, .s45 => by cases d <;> cases e <;> rfl
  | ⟨_, _, _, _, e, f⟩, .s56 => by cases e <;> cases f <;> rfl

/-- **A rise is both lines taking the other parity.** -/
theorem rises_iff_phase : ∀ (s : Hexagram) (j : Seam),
    rises s j = (same (inPhase s (below j)) (!odd (below j)) && same (inPhase s (above j)) (!odd (below j)))
  | ⟨a, b, _, _, _, _⟩, .s12 => by cases a <;> cases b <;> rfl
  | ⟨_, b, c, _, _, _⟩, .s23 => by cases b <;> cases c <;> rfl
  | ⟨_, _, c, d, _, _⟩, .s34 => by cases c <;> cases d <;> rfl
  | ⟨_, _, _, d, e, _⟩, .s45 => by cases d <;> cases e <;> rfl
  | ⟨_, _, _, _, e, f⟩, .s56 => by cases e <;> cases f <;> rfl

/-- **Two adjacent lines alternate exactly where both or neither are in phase.** -/
theorem alternates_iff_phase : ∀ (s : Hexagram) (j : Seam),
    alternates s j = same (inPhase s (below j)) (inPhase s (above j))
  | ⟨a, b, _, _, _, _⟩, .s12 => by cases a <;> cases b <;> rfl
  | ⟨_, b, c, _, _, _⟩, .s23 => by cases b <;> cases c <;> rfl
  | ⟨_, _, c, d, _, _⟩, .s34 => by cases c <;> cases d <;> rfl
  | ⟨_, _, _, d, e, _⟩, .s45 => by cases d <;> cases e <;> rfl
  | ⟨_, _, _, _, e, f⟩, .s56 => by cases e <;> cases f <;> rfl

/-- **The phases between the ends tell the opposition of the middle height**: configurations
showing the same phases between the ends are alike there. -/
theorem opposed_mid_told {s t : Hexagram} (same : SameBetween s t) : opposed s .mid = opposed t .mid :=
  (opposed_iff_phase s .mid).trans
    ((congrArg (fun x => Hexagram.same x (inPhase s .p5)) (sameBetween_phase same (k := .p2) rfl)).trans
      ((congrArg (Hexagram.same (inPhase t .p2)) (sameBetween_phase same (k := .p5) rfl)).trans
        (opposed_iff_phase t .mid).symm))

/-- **And every fall, rise and alternation at a seam between two places between the ends.** -/
theorem inner_seams_told {s t : Hexagram} (same : SameBetween s t) (j : Seam)
    (lower : betweenEnds (below j) = true) (upper : betweenEnds (above j) = true) :
    falls s j = falls t j ∧ rises s j = rises t j ∧ alternates s j = alternates t j :=
  have eb := sameBetween_phase same lower
  have ea := sameBetween_phase same upper
  ⟨(falls_iff_phase s j).trans ((congrArg (fun x => Hexagram.same x (odd (below j)) &&
      Hexagram.same (inPhase s (above j)) (odd (below j))) eb).trans
      ((congrArg (fun x => Hexagram.same (inPhase t (below j)) (odd (below j)) &&
        Hexagram.same x (odd (below j))) ea).trans (falls_iff_phase t j).symm)),
   (rises_iff_phase s j).trans ((congrArg (fun x => Hexagram.same x (!odd (below j)) &&
      Hexagram.same (inPhase s (above j)) (!odd (below j))) eb).trans
      ((congrArg (fun x => Hexagram.same (inPhase t (below j)) (!odd (below j)) &&
        Hexagram.same x (!odd (below j))) ea).trans (rises_iff_phase t j).symm)),
   (alternates_iff_phase s j).trans ((congrArg (fun x => Hexagram.same x (inPhase s (above j))) eb).trans
      ((congrArg (Hexagram.same (inPhase t (below j))) ea).trans (alternates_iff_phase t j).symm))⟩

/-- **Changing a line at an end leaves every phase between the ends.** -/
theorem sameBetween_flip_end : ∀ (k : Place) (s : Hexagram), betweenEnds k = false → SameBetween (flip k s) s
  | .p1, s, _ => fun
    | .p1 => rfl
    | .p2 => congrArg some (inPhase_flip_other s (fun e => Place.noConfusion e))
    | .p3 => congrArg some (inPhase_flip_other s (fun e => Place.noConfusion e))
    | .p4 => congrArg some (inPhase_flip_other s (fun e => Place.noConfusion e))
    | .p5 => congrArg some (inPhase_flip_other s (fun e => Place.noConfusion e))
    | .p6 => rfl
  | .p6, s, _ => fun
    | .p1 => rfl
    | .p2 => congrArg some (inPhase_flip_other s (fun e => Place.noConfusion e))
    | .p3 => congrArg some (inPhase_flip_other s (fun e => Place.noConfusion e))
    | .p4 => congrArg some (inPhase_flip_other s (fun e => Place.noConfusion e))
    | .p5 => congrArg some (inPhase_flip_other s (fun e => Place.noConfusion e))
    | .p6 => rfl
  | .p2, _, h => Bool.noConfusion h
  | .p3, _, h => Bool.noConfusion h
  | .p4, _, h => Bool.noConfusion h
  | .p5, _, h => Bool.noConfusion h

theorem alternates_flip_bottom : ∀ s : Hexagram, alternates (flip .p1 s) .s12 = !alternates s .s12
  | ⟨a, b, _, _, _, _⟩ => by cases a <;> cases b <;> rfl

theorem alternates_flip_top : ∀ s : Hexagram, alternates (flip .p6 s) .s56 = !alternates s .s56
  | ⟨_, _, _, _, e, f⟩ => by cases e <;> cases f <;> rfl

/-- **The phases between the ends do not tell what the ends take part in**: changing the bottom
line keeps every phase between the ends and turns the opposition of the low height and the
alternation of the bottom seam; changing the top line does the same at the high height and the top
seam. 應 at 初四 and 三上 and 比 at the two end seams are relations of the lines, not of the
places. -/
theorem ends_not_told (s : Hexagram) :
    (SameBetween (flip .p1 s) s ∧ opposed (flip .p1 s) .low = !opposed s .low ∧
        alternates (flip .p1 s) .s12 = !alternates s .s12) ∧
      (SameBetween (flip .p6 s) s ∧ opposed (flip .p6 s) .high = !opposed s .high ∧
        alternates (flip .p6 s) .s56 = !alternates s .s56) :=
  ⟨⟨sameBetween_flip_end .p1 s rfl, opposed_flip_self .p1 s, alternates_flip_bottom s⟩,
   ⟨sameBetween_flip_end .p6 s rfl, opposed_flip_self .p6 s, alternates_flip_top s⟩⟩

/-! ## Under the complement, turning over and the change of one line -/

/-- **The complement turns every phase between the ends and leaves the ends without one.** -/
theorem fixedPhase_complement : ∀ (s : Hexagram) (k : Place),
    fixedPhase (complement s) k = (fixedPhase s k).map (fun b => !b)
  | _, .p1 => rfl
  | s, .p2 => congrArg some (inPhase_complement s .p2)
  | s, .p3 => congrArg some (inPhase_complement s .p3)
  | s, .p4 => congrArg some (inPhase_complement s .p4)
  | s, .p5 => congrArg some (inPhase_complement s .p5)
  | _, .p6 => rfl

/-- **Turning over takes the places between the ends to each other and turns their phases.** -/
theorem fixedPhase_reverse : ∀ (s : Hexagram) (k : Place),
    fixedPhase (reverse s) (Place.mirror k) = (fixedPhase s k).map (fun b => !b)
  | _, .p1 => rfl
  | s, .p2 => congrArg some (inPhase_reverse s .p2)
  | s, .p3 => congrArg some (inPhase_reverse s .p3)
  | s, .p4 => congrArg some (inPhase_reverse s .p4)
  | s, .p5 => congrArg some (inPhase_reverse s .p5)
  | _, .p6 => rfl

/-- **Changing a line between the ends turns its phase.** -/
theorem fixedPhase_flip_self (k : Place) (s : Hexagram) (h : betweenEnds k = true) :
    fixedPhase (flip k s) k = (fixedPhase s k).map (fun b => !b) :=
  (fixedPhase_between (flip k s) k h).trans
    ((congrArg some (inPhase_flip_self k s)).trans (congrArg (Option.map fun b => !b) (fixedPhase_between s k h)).symm)

/-- The count of lines holding their place. -/
def placedCount (s : Hexagram) : Nat :=
  (holdsPlace s .p2).toNat + (holdsPlace s .p3).toNat + (holdsPlace s .p4).toNat + (holdsPlace s .p5).toNat

/-- **The counts holding their place of a configuration and its complement add to four.** -/
theorem placedCount_complement : ∀ s : Hexagram, placedCount (complement s) + placedCount s = 4
  | ⟨_, b, c, d, e, _⟩ => by cases b <;> cases c <;> cases d <;> cases e <;> rfl

/-! ## Under the law of waxing and waning -/

/-- **The phase at 二 after a step is decided by the line at 初, which has none** (初為始). -/
theorem fixedPhase_waxWane_enters (s : Hexagram) : fixedPhase (waxWane s) .p2 = some (!inPhase s .p1) :=
  congrArg some (inPhase_waxWane_above s .s12)

/-- **Between the ends, each phase turns as its line rises.** -/
theorem fixedPhase_waxWane_rises (s : Hexagram) (j : Seam) (lower : betweenEnds (below j) = true)
    (upper : betweenEnds (above j) = true) :
    fixedPhase (waxWane s) (above j) = (fixedPhase s (below j)).map (fun b => !b) :=
  (fixedPhase_between (waxWane s) (above j) upper).trans
    ((congrArg some (inPhase_waxWane_above s j)).trans
      (congrArg (Option.map fun b => !b) (fixedPhase_between s (below j) lower)).symm)

/-- **The counts holding their place before and after a step, with the bottom line's phase, add to
four and the fifth line's phase**: what enters at 二 is decided at 初, what leaves 五 goes to 上. -/
theorem placedCount_waxWane : ∀ s : Hexagram,
    placedCount (waxWane s) + placedCount s + (inPhase s .p1).toNat = 4 + (inPhase s .p5).toNat
  | ⟨a, b, c, d, e, _⟩ => by cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> rfl

/-- The phases between the ends. -/
def betweenPhases (s : Hexagram) : Bool × Bool × Bool × Bool :=
  (inPhase s .p2, inPhase s .p3, inPhase s .p4, inPhase s .p5)

/-- **The phases between the ends are not a lumping the law goes alike across**: 乾 and 姤 show the
same, and go on to 姤 and 遯, which do not (卦不可無六爻). -/
theorem betweenPhases_not_lumped : ¬ Learning.Lumped betweenPhases (fun s => betweenPhases (waxWane s)) :=
  fun lumped => absurd (lumped (rising 6) (falling 1) rfl) (by decide)

theorem betweenPhases_not_goAlike : ¬ GoAlike (Law.process waxWane) betweenPhases :=
  fun alike => betweenPhases_not_lumped (Learning.goAlike_iff_lumped.mp alike)

/-- **A line holds its place at two of the four places between the ends on its way up**: the line
at 初 rises through 二, 三, 四 and 五 in the next four steps. -/
theorem course_between : ∀ s : Hexagram,
    (holdsPlace (Law.orbit waxWane s 1) .p2).toNat + (holdsPlace (Law.orbit waxWane s 2) .p3).toNat +
      (holdsPlace (Law.orbit waxWane s 3) .p4).toNat + (holdsPlace (Law.orbit waxWane s 4) .p5).toNat = 2
  | ⟨a, _, _, _, _, _⟩ => by cases a <;> rfl

/-! ## Answering at every pair of places (上下應之) -/

/-- **Two lines answer each other** where their values differ: 應 is this relation at the two
places of a height (`opposed_answers`), 比 at the two places of a seam (`alternates_answers`). -/
def answers (s : Hexagram) (k k' : Place) : Bool := !same (s.line k) (s.line k')

/-- **Answering is symmetric**: a line answers another exactly as it is answered. -/
theorem answers_symm (s : Hexagram) (k k' : Place) : answers s k k' = answers s k' k :=
  congrArg (fun b => !b) (same_comm _ _)

theorem answers_self (s : Hexagram) (k : Place) : answers s k k = false :=
  congrArg (fun b => !b) (same_self _)

theorem opposed_answers (s : Hexagram) (h : Height) : opposed s h = answers s (place .lower h) (place .upper h) :=
  rfl

theorem alternates_answers (s : Hexagram) (j : Seam) : alternates s j = answers s (below j) (above j) := rfl

/-- **The complement keeps every answer.** -/
theorem answers_complement (s : Hexagram) (k k' : Place) : answers (complement s) k k' = answers s k k' :=
  congrArg (fun b => !b) ((congrArg (fun x => same x (complement s |>.line k')) (line_complement s k)).trans
    ((congrArg (same (!s.line k)) (line_complement s k')).trans (same_not_not _ _)))

/-- The five places other than a place. -/
def others : Place → List Place
  | .p1 => [.p2, .p3, .p4, .p5, .p6]
  | .p2 => [.p1, .p3, .p4, .p5, .p6]
  | .p3 => [.p1, .p2, .p4, .p5, .p6]
  | .p4 => [.p1, .p2, .p3, .p5, .p6]
  | .p5 => [.p1, .p2, .p3, .p4, .p6]
  | .p6 => [.p1, .p2, .p3, .p4, .p5]

theorem mem_others : ∀ {k k' : Place}, k' ≠ k → k' ∈ others k := by
  intro k k' ne
  cases k <;> cases k' <;>
    first
    | exact absurd rfl ne
    | exact List.Mem.head _
    | exact List.Mem.tail _ (List.Mem.head _)
    | exact List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _))
    | exact List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _)))
    | exact List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _))))

/-- **The sole line of its kind** (上下應之; 一爻為主): the line at a place answered by every other
line, its value differing from each of the other five. -/
def sole (s : Hexagram) (k : Place) : Bool := (others k).all (answers s k)

/-- **A sole line is answered by every other line.** -/
theorem sole_answered {s : Hexagram} {k : Place} (h : sole s k = true) {k' : Place} (ne : k' ≠ k) :
    answers s k k' = true :=
  ListTests.all_sound (answers s k) h k' (mem_others ne)

theorem not_mem_others_self : ∀ k : Place, ¬ k ∈ others k
  | .p1, .tail _ (.tail _ (.tail _ (.tail _ (.tail _ h)))) => nomatch h
  | .p2, .tail _ (.tail _ (.tail _ (.tail _ (.tail _ h)))) => nomatch h
  | .p3, .tail _ (.tail _ (.tail _ (.tail _ (.tail _ h)))) => nomatch h
  | .p4, .tail _ (.tail _ (.tail _ (.tail _ (.tail _ h)))) => nomatch h
  | .p5, .tail _ (.tail _ (.tail _ (.tail _ (.tail _ h)))) => nomatch h
  | .p6, .tail _ (.tail _ (.tail _ (.tail _ (.tail _ h)))) => nomatch h

/-- **And a line answered by every other is sole.** -/
theorem sole_of_answered {s : Hexagram} {k : Place} (all : ∀ k', k' ≠ k → answers s k k' = true) :
    sole s k = true :=
  ListTests.all_complete (answers s k) fun k' mem => all k' fun e => not_mem_others_self k (e ▸ mem)

/-- **A line is sole exactly where its value is held by one line, so where the configuration has one
unbroken line or five** (至少之地: 五陽而一陰，則一陰為之主). -/
theorem sole_count : ∀ (s : Hexagram) (k : Place),
    sole s k = ((s.line k && yang s == 1) || (!s.line k && yang s == 5))
  | ⟨a, b, c, d, e, f⟩, k => by
    cases k <;> cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> cases f <;> rfl

/-- A sole line somewhere. -/
def soleAny (s : Hexagram) : Bool :=
  sole s .p1 || sole s .p2 || sole s .p3 || sole s .p4 || sole s .p5 || sole s .p6

/-- **A configuration has a sole line exactly where it has one unbroken line or five.** -/
theorem soleAny_count : ∀ s : Hexagram, soleAny s = (yang s == 1 || yang s == 5)
  | ⟨a, b, c, d, e, f⟩ => by
    cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> cases f <;> rfl

theorem sole_any {s : Hexagram} : ∀ {k : Place}, sole s k = true → soleAny s = true
  | .p1, h => ListTests.or_left _ (ListTests.or_left _ (ListTests.or_left _ (ListTests.or_left _ (ListTests.or_left _ h))))
  | .p2, h => ListTests.or_left _ (ListTests.or_left _ (ListTests.or_left _ (ListTests.or_left _ (ListTests.or_right _ h))))
  | .p3, h => ListTests.or_left _ (ListTests.or_left _ (ListTests.or_left _ (ListTests.or_right _ h)))
  | .p4, h => ListTests.or_left _ (ListTests.or_left _ (ListTests.or_right _ h))
  | .p5, h => ListTests.or_left _ (ListTests.or_right _ h)
  | .p6, h => ListTests.or_right _ h

theorem none_sole {s : Hexagram} (h : soleAny s = false) : ∀ k, sole s k = false :=
  have h5 := neither h
  have h4 := neither h5.1
  have h3 := neither h4.1
  have h2 := neither h3.1
  have h1 := neither h2.1
  fun
  | .p1 => h1.1
  | .p2 => h1.2
  | .p3 => h2.2
  | .p4 => h3.2
  | .p5 => h4.2
  | .p6 => h5.2

/-- **At most one line is sole** (主必致一). -/
theorem sole_unique : ∀ {s : Hexagram} {k k' : Place}, sole s k = true → sole s k' = true → k = k' := by
  intro s k k' h h'
  cases s with
  | mk a b c d e f =>
    cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> cases f <;> cases k <;> cases k' <;>
      first
      | rfl
      | exact Bool.noConfusion h
      | exact Bool.noConfusion h'

/-- 乾 for `true`, 坤 for `false`: every line of one value. -/
def uniform : Bool → Hexagram
  | true => rising 6
  | false => allBroken

/-- **A configuration has a sole line at a place exactly where it is one change of that line away
from every line alike**: the twelve configurations one change from 乾 or 坤. -/
theorem sole_iff_flip : ∀ (s : Hexagram) (k : Place), sole s k = true ↔ s = flip k (uniform (!s.line k))
  | ⟨a, b, c, d, e, f⟩, k => by
    cases k <;> cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> cases f <;>
      first
      | exact ⟨fun _ => rfl, fun _ => rfl⟩
      | exact ⟨fun h => Bool.noConfusion h, fun e => absurd e (ne_of_eqb rfl)⟩

/-- **Changing one line of a configuration with every line alike makes it sole.** -/
theorem sole_flip : ∀ (k : Place) (b : Bool), sole (flip k (uniform b)) k = true
  | .p1, true => rfl
  | .p1, false => rfl
  | .p2, true => rfl
  | .p2, false => rfl
  | .p3, true => rfl
  | .p3, false => rfl
  | .p4, true => rfl
  | .p4, false => rfl
  | .p5, true => rfl
  | .p5, false => rfl
  | .p6, true => rfl
  | .p6, false => rfl

/-- **The complement keeps a sole line**, every answer being kept. -/
theorem sole_complement (s : Hexagram) (k : Place) : sole (complement s) k = sole s k :=
  all_congr (answers_complement s k) (others k)

/-- **Turning over keeps a sole line, at the mirrored place.** -/
theorem sole_reverse : ∀ (s : Hexagram) (k : Place), sole (reverse s) (Place.mirror k) = sole s k
  | ⟨a, b, c, d, e, f⟩, k => by
    cases k <;> cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> cases f <;> rfl

/-- **A sole line is in phase at some configurations and out of phase at others, at every place**:
being sole is a matter of number, not of place (處其至少之地). -/
theorem sole_any_phase : ∀ (k : Place) (v : Bool), ∃ s, sole s k = true ∧ inPhase s k = v
  | .p1, true => ⟨flip .p1 (uniform false), rfl, rfl⟩
  | .p1, false => ⟨flip .p1 (uniform true), rfl, rfl⟩
  | .p2, true => ⟨flip .p2 (uniform true), rfl, rfl⟩
  | .p2, false => ⟨flip .p2 (uniform false), rfl, rfl⟩
  | .p3, true => ⟨flip .p3 (uniform false), rfl, rfl⟩
  | .p3, false => ⟨flip .p3 (uniform true), rfl, rfl⟩
  | .p4, true => ⟨flip .p4 (uniform true), rfl, rfl⟩
  | .p4, false => ⟨flip .p4 (uniform false), rfl, rfl⟩
  | .p5, true => ⟨flip .p5 (uniform false), rfl, rfl⟩
  | .p5, false => ⟨flip .p5 (uniform true), rfl, rfl⟩
  | .p6, true => ⟨flip .p6 (uniform true), rfl, rfl⟩
  | .p6, false => ⟨flip .p6 (uniform false), rfl, rfl⟩

/-- The twelve configurations with a sole line, with its place. -/
def soleList : List (Hexagram × Place) :=
  [(flip .p1 (uniform true), .p1), (flip .p2 (uniform true), .p2), (flip .p3 (uniform true), .p3),
    (flip .p4 (uniform true), .p4), (flip .p5 (uniform true), .p5), (flip .p6 (uniform true), .p6),
    (flip .p1 (uniform false), .p1), (flip .p2 (uniform false), .p2), (flip .p3 (uniform false), .p3),
    (flip .p4 (uniform false), .p4), (flip .p5 (uniform false), .p5), (flip .p6 (uniform false), .p6)]

/-- **Of the twelve sole lines, four hold their place, four are out of phase between the ends and
four are at an end, holding none.** -/
theorem sole_places :
    (soleList.filter fun q => holdsPlace q.1 q.2).length = 4 ∧
      (soleList.filter fun q => betweenEnds q.2 && !inPhase q.1 q.2).length = 4 ∧
      (soleList.filter fun q => !betweenEnds q.2).length = 4 :=
  ⟨rfl, rfl, rfl⟩

/-- The pattern of oppositions with one height opposed. -/
def heightMark : Height → Bool × Bool × Bool
  | .low => (true, false, false)
  | .mid => (false, true, false)
  | .high => (false, false, true)

/-- **Read at the heights, a sole line has one answer**: its own height is opposed and the other two
are alike, where read at every pair it has five (`sole_answered`). -/
theorem sole_opposition : ∀ (s : Hexagram) (k : Place), sole s k = true → opposition s = heightMark (heightOf k)
  | ⟨a, b, c, d, e, f⟩, k => by
    intro h
    cases k <;> cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> cases f <;>
      first
      | rfl
      | exact Bool.noConfusion h

/-- 節 (60). -/
def jie : Hexagram := number 60

/-- **One opposed height does not make a sole line**: 節 has only its low height opposed and three
unbroken lines. -/
theorem jie_one_opposed : opposition jie = heightMark .low ∧ soleAny jie = false := ⟨rfl, rfl⟩

/-- One at the bottom place, none elsewhere. -/
def bottomMark : Place → Nat
  | .p1 => 1
  | .p2 => 0
  | .p3 => 0
  | .p4 => 0
  | .p5 => 0
  | .p6 => 0

/-- One at the top place, none elsewhere. -/
def topMark : Place → Nat
  | .p1 => 0
  | .p2 => 0
  | .p3 => 0
  | .p4 => 0
  | .p5 => 0
  | .p6 => 1

/-- **Read at the seams, a broken sole line has one fall, at the seam below it, and one rise, at the
seam above it** (乘 and 承), none where it is at an end. -/
theorem sole_broken_seams : ∀ (s : Hexagram) (k : Place), sole s k = true → s.line k = false →
    (∀ j, above j = k → falls s j = true) ∧ (∀ j, below j = k → rises s j = true) ∧
      fallCount s + bottomMark k = 1 ∧ riseCount s + topMark k = 1 := by
  intro s k h v
  cases s with
  | mk a b c d e f =>
    cases k <;> cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> cases f <;>
      first
      | exact Bool.noConfusion h
      | exact Bool.noConfusion v
      | exact ⟨fun j e => by cases j <;> first | rfl | exact Place.noConfusion e,
               fun j e => by cases j <;> first | rfl | exact Place.noConfusion e, rfl, rfl⟩

/-- **And an unbroken sole line has one rise, at the seam below it, and one fall, at the seam above
it.** -/
theorem sole_unbroken_seams : ∀ (s : Hexagram) (k : Place), sole s k = true → s.line k = true →
    (∀ j, above j = k → rises s j = true) ∧ (∀ j, below j = k → falls s j = true) ∧
      riseCount s + bottomMark k = 1 ∧ fallCount s + topMark k = 1 := by
  intro s k h v
  cases s with
  | mk a b c d e f =>
    cases k <;> cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> cases f <;>
      first
      | exact Bool.noConfusion h
      | exact Bool.noConfusion v
      | exact ⟨fun j e => by cases j <;> first | rfl | exact Place.noConfusion e,
               fun j e => by cases j <;> first | rfl | exact Place.noConfusion e, rfl, rfl⟩

/-- 夬 (43) is the configuration whose broken top line is answered by the five unbroken lines below
it (柔乘五剛). -/
theorem guai_iff (s : Hexagram) : (sole s .p6 = true ∧ s.line .p6 = false) ↔ s = guai :=
  ⟨fun ⟨h, v⟩ => by
    cases s with
    | mk a b c d e f =>
      cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> cases f <;>
        first
        | rfl
        | exact Bool.noConfusion h
        | exact Bool.noConfusion v,
   fun e => by subst e; exact ⟨rfl, rfl⟩⟩

/-- **The sole line of 夬 is at the top, broken, over five unbroken lines; across the seams it
falls only once** (`guai_falls`). -/
theorem guai_sole : sole guai .p6 = true ∧ guai.line .p6 = false ∧ fallCount guai = 1 := ⟨rfl, rfl, rfl⟩

/-! ## The sole line under the law of waxing and waning -/

/-- **No configuration with a sole line has one a step later**: a sole line below the top rises and
the line entering at the bottom takes its value; a sole line at the top passes out and leaves every
line alike. -/
theorem soleAny_waxWane : ∀ s : Hexagram, (soleAny s && soleAny (waxWane s)) = false
  | ⟨a, b, c, d, e, f⟩ => by
    cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> cases f <;> rfl

/-- **A sole line never lasts a step.** -/
theorem sole_waxWane_none {s : Hexagram} {k : Place} (h : sole s k = true) (k' : Place) :
    sole (waxWane s) k' = false :=
  none_sole (and_false_of_true (soleAny_waxWane s) (sole_any h)) k'

/-- **Six steps on a sole line is back at its place, its value turned.** -/
theorem sole_six (s : Hexagram) (k : Place) : sole (Law.orbit waxWane s 6) k = sole s k :=
  (congrArg (fun x => sole x k) (six_steps s)).trans (sole_complement s k)

/-- **A sole line at the top passes out and leaves every line alike, and the next step a sole line
enters at the bottom** (初上者，始終之象). -/
theorem sole_top_passes : ∀ s : Hexagram, sole s .p6 = true →
    (waxWane s = uniform true ∨ waxWane s = uniform false) ∧ sole (Law.orbit waxWane s 2) .p1 = true
  | ⟨a, b, c, d, e, f⟩ => by
    intro h
    cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> cases f <;>
      first
      | exact ⟨.inl rfl, rfl⟩
      | exact ⟨.inr rfl, rfl⟩
      | exact Bool.noConfusion h

/-! ## Censuses of the text -/

/-- The 彖's statements that the lines above and below answer one (上下應), in the received order,
with the place of the line answered: 比 (九五), 小畜 (六四), 大有 (六五). -/
def answeredStatements : List (Nat × Place) := [(8, .p5), (9, .p4), (14, .p5)]

/-- **Every configuration the 彖 says 上下應 of has a sole line, the line it names.** -/
theorem answeredStatements_sole : ∀ q, q ∈ answeredStatements → sole (number q.1) q.2 = true :=
  ListTests.all_sound (fun (q : Nat × Place) => sole (number q.1) q.2) rfl

/-- 履 (10). -/
def lv : Hexagram := number 10

/-- 豐 (55). -/
def feng : Hexagram := number 55

/-- **履's third line is its sole line, answered by every line of 乾 above it** (略例下: 《履》卦六三，
為兌之主，以應於《乾》). -/
theorem lv_sole : sole lv .p3 = true ∧ answers lv .p3 .p4 = true ∧ answers lv .p3 .p5 = true ∧
    answers lv .p3 .p6 = true := ⟨rfl, rfl, rfl, rfl⟩

/-- **豐 has no sole line** (略例下: 卦體不由乎一爻，則全以二體之義明之，豐卦之類是也). -/
theorem feng_no_sole : soleAny feng = false := rfl

/-- **小畜's fourth line is sole: answered by five lines at every pair, by one at the heights.** -/
theorem xiaoXu_answered : sole xiaoXu .p4 = true ∧ opposition xiaoXu = heightMark .low := ⟨rfl, rfl⟩

/-- **And so is 大有's fifth.** -/
theorem daYou_answered : sole daYou .p5 = true ∧ opposition daYou = heightMark .mid := ⟨rfl, rfl⟩

/-- The line texts (爻辭) that say 中, in the received order: the configuration's number and the
place of the line. 中行 at 泰九二, 復六四, 益六三, 益六四 and 夬九五; 林中, 師中 and 中饋 at 屯六三,
師九二 and 家人六二; 日中 at 豐六二, 九三 and 九四. -/
def lineTextMiddle : List (Nat × Place) := [
    (3, .p3), (7, .p2), (11, .p2), (24, .p4), (37, .p2), (42, .p3), (42, .p4), (43, .p5), (55, .p2),
    (55, .p3), (55, .p4)
  ]

/-- The line texts that say 中行. -/
def middleCourseLines : List (Nat × Place) := [(11, .p2), (24, .p4), (42, .p3), (42, .p4), (43, .p5)]

/-- **Every line text that says 中 is of a place between the ends, and five of the eleven are of a
middle place**; of the five that say 中行, two are. -/
theorem lineTextMiddle_places :
    (∀ q, q ∈ lineTextMiddle → betweenEnds q.2 = true) ∧
      (lineTextMiddle.filter fun q => middle q.2).length = 5 ∧
      (middleCourseLines.filter fun q => middle q.2).length = 2 :=
  ⟨ListTests.all_sound (fun (q : Nat × Place) => betweenEnds q.2) rfl, rfl, rfl⟩

/-- The line texts that say 位: 萃九五 「萃有位」. -/
def lineTextPlace : List (Nat × Place) := [(45, .p5)]

/-- **萃's fifth line is middle and holds its place under both relations.** -/
theorem lineTextPlace_holds : ∀ q, q ∈ lineTextPlace →
    middle q.2 = true ∧ inPhase (number q.1) q.2 = true ∧ holdsPlace (number q.1) q.2 = true :=
  fun q mem =>
    have h := bool_of_and_true (ListTests.all_sound (fun (q : Nat × Place) => middle q.2 && (inPhase (number q.1) q.2 && holdsPlace (number q.1) q.2))
      rfl q mem)
    ⟨h.1, (bool_of_and_true h.2).1, (bool_of_and_true h.2).2⟩

/-! ## Along the unfolding -/

/-- **Along every run of waxing and waning, the phase at 二 is decided by the line at 初 a step
before, and between the ends each phase turns as its line rises.** -/
theorem run_between_rises (s : Hexagram) (n : Nat) :
    fixedPhase ((Law.run waxWane s).state (n + 1)) .p2 = some (!inPhase ((Law.run waxWane s).state n) .p1) ∧
      ∀ j, betweenEnds (below j) = true → betweenEnds (above j) = true →
        fixedPhase ((Law.run waxWane s).state (n + 1)) (above j) =
          (fixedPhase ((Law.run waxWane s).state n) (below j)).map (fun b => !b) :=
  ⟨fixedPhase_waxWane_enters _, fun j lower upper => fixedPhase_waxWane_rises _ j lower upper⟩

/-- **Along every run, the counts holding their place at two consecutive steps, with the bottom
line's phase, add to four and the fifth line's phase.** -/
theorem run_placedCount (s : Hexagram) (n : Nat) :
    placedCount ((Law.run waxWane s).state (n + 1)) + placedCount ((Law.run waxWane s).state n) +
        (inPhase ((Law.run waxWane s).state n) .p1).toNat =
      4 + (inPhase ((Law.run waxWane s).state n) .p5).toNat :=
  placedCount_waxWane _

/-- **Along every run, the line at 初 holds its place at two of its next four places.** -/
theorem run_course_between (s : Hexagram) (n : Nat) :
    (holdsPlace ((Law.run waxWane s).state (n + 1)) .p2).toNat +
        (holdsPlace ((Law.run waxWane s).state (n + 2)) .p3).toNat +
        (holdsPlace ((Law.run waxWane s).state (n + 3)) .p4).toNat +
        (holdsPlace ((Law.run waxWane s).state (n + 4)) .p5).toNat = 2 := by
  show (holdsPlace (Law.orbit waxWane s (n + 1)) .p2).toNat + (holdsPlace (Law.orbit waxWane s (n + 2)) .p3).toNat +
      (holdsPlace (Law.orbit waxWane s (n + 3)) .p4).toNat + (holdsPlace (Law.orbit waxWane s (n + 4)) .p5).toNat = 2
  rw [Law.orbit_add waxWane s n 1, Law.orbit_add waxWane s n 2, Law.orbit_add waxWane s n 3,
    Law.orbit_add waxWane s n 4]
  exact course_between _

/-- **Six steps on along every run, every phase between the ends is turned and the counts holding
their place add to four.** -/
theorem run_between_six (s : Hexagram) (n : Nat) :
    (∀ k, fixedPhase ((Law.run waxWane s).state (n + 6)) k =
        (fixedPhase ((Law.run waxWane s).state n) k).map (fun b => !b)) ∧
      placedCount ((Law.run waxWane s).state (n + 6)) + placedCount ((Law.run waxWane s).state n) = 4 :=
  ⟨fun k => (congrArg (fun x => fixedPhase x k) (run_six_steps s n)).trans (fixedPhase_complement _ k),
   (congrArg (fun x => placedCount x + placedCount ((Law.run waxWane s).state n)) (run_six_steps s n)).trans
     (placedCount_complement _)⟩

/-- **Turned over, the run backward shows every phase between the ends turned at the mirrored
place.** -/
theorem backward_between (s : Hexagram) (n : Nat) (k : Place) :
    fixedPhase ((Law.run unwaxWane (reverse s)).state n) (Place.mirror k) =
      (fixedPhase ((Law.run waxWane s).state n) k).map (fun b => !b) :=
  (congrArg (fun x => fixedPhase x (Place.mirror k)) (backward_run s n)).trans (fixedPhase_reverse _ k)

/-- **Along every run of the change of one line, a step at an end keeps every phase between the
ends, and a step between the ends turns the phase of the line it changes.** -/
theorem changes_run_between (r : Run changes) (n : Nat) :
    (betweenEnds (r.act n) = false → SameBetween (r.state (n + 1)) (r.state n)) ∧
      (betweenEnds (r.act n) = true →
        fixedPhase (r.state (n + 1)) (r.act n) = (fixedPhase (r.state n) (r.act n)).map (fun b => !b)) :=
  have step : r.state (n + 1) = flip (r.act n) (r.state n) := r.step n
  ⟨fun atEnd k => (congrArg (fun x => fixedPhase x k) step).trans (sameBetween_flip_end _ _ atEnd k),
   fun between => (congrArg (fun x => fixedPhase x (r.act n)) step).trans (fixedPhase_flip_self _ _ between)⟩

/-- **Whatever two runs of any processes show, the phases between the ends tell the middle
opposition and every relation at the three seams between them; at every step a line holds its
place exactly where the second relation shows it in phase, and a fall is both lines taking the
lower place's parity.** -/
theorem between_shown_along_runs {A B : Type} {P : Process Hexagram A} {Q : Process Hexagram B}
    (r : Run P) (r' : Run Q) (n m : Nat) :
    (SameBetween (r.state n) (r'.state m) →
        opposed (r.state n) .mid = opposed (r'.state m) .mid ∧
          ∀ j, betweenEnds (below j) = true → betweenEnds (above j) = true →
            falls (r.state n) j = falls (r'.state m) j ∧ rises (r.state n) j = rises (r'.state m) j ∧
              alternates (r.state n) j = alternates (r'.state m) j) ∧
      (∀ k, holdsPlace (r.state n) k = true ↔ fixedPhase (r.state n) k = some true) ∧
      (∀ k, holdsPlace (r.state n) k = true → inPhase (r.state n) k = true) ∧
      (∀ k, betweenEnds k = false → fixedPhase (r.state n) k = none) ∧
      holdsPlace (r.state n) .p1 = false ∧ holdsPlace (r.state n) .p6 = false ∧
      (∀ j, falls (r.state n) j = (same (inPhase (r.state n) (below j)) (odd (below j)) &&
        same (inPhase (r.state n) (above j)) (odd (below j)))) ∧
      (∀ j, rises (r.state n) j = (same (inPhase (r.state n) (below j)) (!odd (below j)) &&
        same (inPhase (r.state n) (above j)) (!odd (below j)))) ∧
      (∀ j, alternates (r.state n) j = same (inPhase (r.state n) (below j)) (inPhase (r.state n) (above j))) :=
  ⟨fun same => ⟨opposed_mid_told same, fun j lower upper => inner_seams_told same j lower upper⟩,
   holdsPlace_iff _, fun _ h => holdsPlace_inPhase h, fixedPhase_end _, (holdsPlace_ends _).1,
   (holdsPlace_ends _).2, falls_iff_phase _, rises_iff_phase _, alternates_iff_phase _⟩

/-- **Whatever a run of any process shows, its phases between the ends glue to a reading of the
whole exactly at 既濟, 蹇, 漸 and 家人, where every line between the ends holds its place, and at
未濟, 歸妹, 解 and 睽, where none does.** -/
theorem between_glue_along_run {A : Type} {P : Process Hexagram A} (r : Run P) (n : Nat) :
    (atSites betweenPhase).Glues (r.state n) ↔
      (r.state n = jiJi ∨ r.state n = jian3 ∨ r.state n = jian4 ∨ r.state n = jiaRen) ∨
        (r.state n = weiJi ∨ r.state n = guiMei ∨ r.state n = xie ∨ r.state n = kui) :=
  (between_glues_iff _).trans
    ⟨fun
      | .inl h => .inl ((allHold_iff _).mp h)
      | .inr h => .inr ((noneHold_iff _).mp h),
     fun
      | .inl h => .inl ((allHold_iff _).mpr h)
      | .inr h => .inr ((noneHold_iff _).mpr h)⟩

/-- **Along every run of the change of one line, a step at the bottom keeps every phase between the
ends and turns the opposition of the low height and the alternation of the bottom seam; a step at
the top does the same at the high height and the top seam.** -/
theorem changes_run_ends (r : Run changes) (n : Nat) :
    (r.act n = .p1 → SameBetween (r.state (n + 1)) (r.state n) ∧
        opposed (r.state (n + 1)) .low = !opposed (r.state n) .low ∧
        alternates (r.state (n + 1)) .s12 = !alternates (r.state n) .s12) ∧
      (r.act n = .p6 → SameBetween (r.state (n + 1)) (r.state n) ∧
        opposed (r.state (n + 1)) .high = !opposed (r.state n) .high ∧
        alternates (r.state (n + 1)) .s56 = !alternates (r.state n) .s56) :=
  have step : r.state (n + 1) = flip (r.act n) (r.state n) := r.step n
  ⟨fun bottom =>
    have e : r.state (n + 1) = flip .p1 (r.state n) := step.trans (congrArg (fun k => flip k (r.state n)) bottom)
    ⟨fun k => (congrArg (fun x => fixedPhase x k) e).trans ((ends_not_told _).1.1 k),
     (congrArg (fun x => opposed x .low) e).trans (ends_not_told _).1.2.1,
     (congrArg (fun x => alternates x .s12) e).trans (ends_not_told _).1.2.2⟩,
   fun top =>
    have e : r.state (n + 1) = flip .p6 (r.state n) := step.trans (congrArg (fun k => flip k (r.state n)) top)
    ⟨fun k => (congrArg (fun x => fixedPhase x k) e).trans ((ends_not_told _).2.1 k),
     (congrArg (fun x => opposed x .high) e).trans (ends_not_told _).2.2.1,
     (congrArg (fun x => alternates x .s56) e).trans (ends_not_told _).2.2.2⟩⟩

/-- **Along every run of any process, a line is sole exactly where it is one of one unbroken line
or five, at most one line is sole, it is answered by every other line, and read at the heights it
has one answer.** -/
theorem sole_shown_along_run {A : Type} {P : Process Hexagram A} (r : Run P) (n : Nat) (k : Place) :
    sole (r.state n) k = (((r.state n).line k && yang (r.state n) == 1) ||
        (!(r.state n).line k && yang (r.state n) == 5)) ∧
      soleAny (r.state n) = (yang (r.state n) == 1 || yang (r.state n) == 5) ∧
      (sole (r.state n) k = true ↔ ∀ k', k' ≠ k → answers (r.state n) k k' = true) ∧
      (sole (r.state n) k = true ↔ r.state n = flip k (uniform (!(r.state n).line k))) ∧
      (sole (r.state n) k = true →
        (∀ k', sole (r.state n) k' = true → k = k') ∧ opposition (r.state n) = heightMark (heightOf k) ∧
          ((r.state n).line k = false → fallCount (r.state n) + bottomMark k = 1 ∧
            riseCount (r.state n) + topMark k = 1) ∧
          ((r.state n).line k = true → riseCount (r.state n) + bottomMark k = 1 ∧
            fallCount (r.state n) + topMark k = 1)) ∧
      ((sole (r.state n) .p6 = true ∧ (r.state n).line .p6 = false) ↔ r.state n = guai) :=
  ⟨sole_count _ k, soleAny_count _, ⟨fun h _ ne => sole_answered h ne, sole_of_answered⟩, sole_iff_flip _ k,
   fun h => ⟨fun _ h' => sole_unique h h', sole_opposition _ k h,
     fun v => ⟨(sole_broken_seams _ k h v).2.2.1, (sole_broken_seams _ k h v).2.2.2⟩,
     fun v => ⟨(sole_unbroken_seams _ k h v).2.2.1, (sole_unbroken_seams _ k h v).2.2.2⟩⟩,
   guai_iff _⟩

/-- **Whatever a run of any process shows, answering is symmetric and no line answers itself, 應 is
answering at the heights and 比 at the seams, and the complement keeps every answer.** -/
theorem answers_shown_along_run {A : Type} {P : Process Hexagram A} (r : Run P) (n : Nat) :
    (∀ k k', answers (r.state n) k k' = answers (r.state n) k' k) ∧ (∀ k, answers (r.state n) k k = false) ∧
      (∀ h, opposed (r.state n) h = answers (r.state n) (place .lower h) (place .upper h)) ∧
      (∀ j, alternates (r.state n) j = answers (r.state n) (below j) (above j)) ∧
      (∀ k k', answers (complement (r.state n)) k k' = answers (r.state n) k k') :=
  ⟨answers_symm _, answers_self _, opposed_answers _, alternates_answers _, answers_complement _⟩

/-- **Turned over, the run backward has a sole line exactly where the run forward has one, at the
mirrored place.** -/
theorem backward_sole (s : Hexagram) (n : Nat) (k : Place) :
    sole ((Law.run unwaxWane (reverse s)).state n) (Place.mirror k) = sole ((Law.run waxWane s).state n) k :=
  (congrArg (fun x => sole x (Place.mirror k)) (backward_run s n)).trans (sole_reverse _ k)

/-- **Along every run of waxing and waning, a sole line never lasts a step, is back at its place
six steps on, and a sole line at the top leaves every line alike and is followed by a sole line
at the bottom.** -/
theorem run_sole (s : Hexagram) (n : Nat) (k : Place) (h : sole ((Law.run waxWane s).state n) k = true) :
    (∀ k', sole ((Law.run waxWane s).state (n + 1)) k' = false) ∧
      sole ((Law.run waxWane s).state (n + 6)) k = true ∧
      (k = .p6 → sole ((Law.run waxWane s).state (n + 2)) .p1 = true) :=
  ⟨sole_waxWane_none h,
   ((congrArg (fun x => sole x k) (Law.orbit_add waxWane s n 6)).trans (sole_six _ k)).trans h,
   fun top => by
    subst top
    exact (congrArg (fun x => sole x .p1) (Law.orbit_add waxWane s n 2)).trans (sole_top_passes _ h).2⟩

/-- **Along every run of the change of one line, changing a sole line leaves every line alike,
and changing a line of a configuration with every line alike makes it sole.** -/
theorem changes_run_sole (r : Run changes) (n : Nat) :
    (sole (r.state n) (r.act n) = true → r.state (n + 1) = uniform (!(r.state n).line (r.act n))) ∧
      (∀ b, r.state n = uniform b → sole (r.state (n + 1)) (r.act n) = true) :=
  have step : r.state (n + 1) = flip (r.act n) (r.state n) := r.step n
  ⟨fun h => step.trans ((congrArg (flip (r.act n)) ((sole_iff_flip _ _).mp h)).trans (flip_flip _ _)),
   fun b e => (congrArg (fun x => sole x (r.act n)) (step.trans (congrArg (flip (r.act n)) e))).trans
     (sole_flip _ b)⟩

end Hexagram

end Becoming
