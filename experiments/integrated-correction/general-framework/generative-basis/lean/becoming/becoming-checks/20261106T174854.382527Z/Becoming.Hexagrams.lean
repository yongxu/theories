import Becoming.Branching
import Becoming.Learning
import Becoming.LearningRuns

/-!
# Hexagrams: six two-valued lines, the change of a line, and the law of waxing and waning

Ren, 19 October 2026, asked for the relation of the theory with the 周易, above all the 易传, to
be built into the repository with an explicit mapping on the spine. This module states the
configurations the text itself describes, six lines each unbroken or broken, as a world of the
spine, and states on it laws the spine proves for every world, with no premise beyond what each
law names. The passages of the text are mapped to these declarations in the study and the
chapter; what a passage claims beyond them is not in this module.

* **Sixty-four configurations, two values decided.** A hexagram is six lines read from the bottom,
  each `true` (unbroken, 陽) or `false` (broken, 陰) (`Hexagram`, `Hexagram.line`). Equality and
  membership are told line by line with no axiom (`eqb`, `eq_of_eqb`, `ne_of_eqb`,
  `mem_of_memb`). The received order of the sixty-four, each read from its lower and upper
  trigram, holds every configuration (`order`, `order_length`, `mem_order`), and its pairs are
  each turned over, or, where turning over gives the same hexagram, changed in every line
  (`Paired`, `order_paired`).
* **The change of one line.** A step turns the line at one place into its opposite (`flip`,
  `changes`). Every configuration returns (`changes_returns`), every configuration can be had
  from every other (`reach_every`), every possibility is kept, and the process merges
  (`changes_merges`, `changes_keeps`): returning does not give merging nothing where the course
  branches (`Becoming.Branching`).
* **The law of waxing and waning.** Every line rises one place, and the top line passes out and
  enters at the bottom as its opposite (`waxWane`); run backward, every line falls one place
  (`unwaxWane`). The law merges nothing (`waxWane_lossless`), so by `Law.lossless_iff_returns`
  every configuration returns (`waxWane_returns`). Six steps change every line
  (`six_steps`, `run_six_steps`), twelve have every configuration again (`twelve_steps`), and
  each pair of the received order is the first turned over or the first six steps on along the
  law (`order_paired_by_law`). From all lines broken, the
  unbroken lines rise from the bottom one step at a time until all are unbroken, and the broken
  lines then rise in the same way (`waxing`, `waning`); the first return to all broken is at the
  twelfth step (`first_return`), the first unbroken line comes back at the seventh step from all
  unbroken (`seventh_step`), and some configurations return at the fourth (`fourth_step`).
* **Where the law merges.** Where only a broken line enters at the bottom (`wane`), the law
  merges (`wane_merges`); after six steps every configuration is all broken (`wane_six`), which
  the law never leaves (`allBroken_absorbing`), so every other configuration is drawn in, never
  comes back and never returns (`wane_drawn`, `wane_never_back`, `wane_not_returns`), and a
  possibility is lost for good (`wane_loses`). For every law of hexagrams, every configuration
  returns exactly where the law merges nothing (`every_returns_iff`, read on the law as a process).
* **Symmetries and what a lumping carries.** The law commutes with the complement
  (`waxWane_complement`), and turning a hexagram over runs the law backward
  (`reverse_wax`, `reverse_waxWane`). Named by the member whose top line is broken, the pair of a hexagram and
  its complement is a lumping the law goes alike across (`pairOf`, `pairs_lumped`,
  `pairs_goAlike`, through `Learning.goAlike_iff_lumped`); the count of unbroken lines is not
  (`yang_not_lumped`, `yang_not_goAlike`).
* **The lines as claims, as a frame and as a world.** Read along the law, the claim at a place is
  realized where its line is unbroken (`lines`). Along every run of the law, a line comes to be
  unbroken at arbitrarily late steps (`arising_recurs`), so by `Frame.claims_recur_iff` a line
  also ceases to be unbroken at arbitrarily late steps (`ceasing_recurs`); read as the world of
  the frame, its relata, the places, arise and cease at arbitrarily late steps
  (`world_arising_recurs`, `world_ceasing_recurs`).
* **Going on within the sixty-four.** Any sixty-five steps of a run of hexagrams, under every
  process on them, revisit a configuration (`revisits_within_order`), and every run of the change of lines revisits from
  every step on (`changes_run_revisits`); the law with its history kept is held by no list
  (`kept_history_unlisted`).

**Classical sources.** `waxWane` is the twisted ring (Johnson) counter on six cells; the
statements are finite computations or instances of the spine's laws. What is the spine's own is
that each is an instance of a law stated for every world.

No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

open Generative

/-- Six lines read from the bottom (`l1`) to the top (`l6`). `true` is an unbroken line (陽),
`false` a broken one (陰). Each line is one or the other: the two values are decided. -/
structure Hexagram where
  l1 : Bool
  l2 : Bool
  l3 : Bool
  l4 : Bool
  l5 : Bool
  l6 : Bool

namespace Hexagram

/-- The six places, from the bottom (初) to the top (上). -/
inductive Place where
  | p1
  | p2
  | p3
  | p4
  | p5
  | p6

/-- The six places in order. -/
def places : List Place := [.p1, .p2, .p3, .p4, .p5, .p6]

/-- The line at a place. -/
def line (s : Hexagram) : Place → Bool
  | .p1 => s.l1
  | .p2 => s.l2
  | .p3 => s.l3
  | .p4 => s.l4
  | .p5 => s.l5
  | .p6 => s.l6

/-! ## Equality and membership, told line by line -/

/-- Two line values agree. -/
def same : Bool → Bool → Bool
  | true, true => true
  | true, false => false
  | false, true => false
  | false, false => true

theorem same_eq : ∀ {a b : Bool}, same a b = true → a = b
  | true, true, _ => rfl
  | false, false, _ => rfl
  | true, false, h => Bool.noConfusion h
  | false, true, h => Bool.noConfusion h

theorem same_self : ∀ a : Bool, same a a = true
  | true => rfl
  | false => rfl

/-- Two hexagrams agree at every line. -/
def eqb (s t : Hexagram) : Bool :=
  same s.l1 t.l1 && same s.l2 t.l2 && same s.l3 t.l3 && same s.l4 t.l4 && same s.l5 t.l5 &&
    same s.l6 t.l6

theorem eq_of_eqb : ∀ {s t : Hexagram}, eqb s t = true → s = t
  | ⟨_, _, _, _, _, _⟩, ⟨_, _, _, _, _, _⟩, h =>
    match bool_of_and_true h with
    | ⟨h5, e6⟩ => match bool_of_and_true h5 with
      | ⟨h4, e5⟩ => match bool_of_and_true h4 with
        | ⟨h3, e4⟩ => match bool_of_and_true h3 with
          | ⟨h2, e3⟩ => match bool_of_and_true h2 with
            | ⟨e1, e2⟩ => by
              cases same_eq e1
              cases same_eq e2
              cases same_eq e3
              cases same_eq e4
              cases same_eq e5
              cases same_eq e6
              rfl

theorem eqb_self : ∀ s : Hexagram, eqb s s = true
  | ⟨a, b, c, d, e, f⟩ => by
    show (same a a && same b b && same c c && same d d && same e e && same f f) = true
    rw [same_self a, same_self b, same_self c, same_self d, same_self e, same_self f]
    rfl

theorem ne_of_eqb {s t : Hexagram} (h : eqb s t = false) : s ≠ t :=
  fun same => by
    cases same
    exact Bool.noConfusion ((eqb_self s).symm.trans h)

/-- `s` is among the hexagrams of a list, told line by line. -/
def memb (s : Hexagram) : List Hexagram → Bool
  | [] => false
  | t :: l => eqb s t || memb s l

theorem mem_of_memb {s : Hexagram} : ∀ {l : List Hexagram}, memb s l = true → s ∈ l
  | [], h => Bool.noConfusion h
  | t :: _, h => match ListTests.or_cases h with
    | .inl here => by
      cases eq_of_eqb here
      exact List.Mem.head _
    | .inr there => List.Mem.tail t (mem_of_memb there)

/-! ## The received order holds every configuration -/

/-- The received order of the sixty-four (序卦), each read from its lower trigram (lines 1-3) and
its upper trigram (lines 4-6) as the text gives them. -/
def order : List Hexagram := [
    ⟨true, true, true, true, true, true⟩,  -- 1 乾: 乾下乾上
    ⟨false, false, false, false, false, false⟩,  -- 2 坤: 坤下坤上
    ⟨true, false, false, false, true, false⟩,  -- 3 屯: 震下坎上
    ⟨false, true, false, false, false, true⟩,  -- 4 蒙: 坎下艮上
    ⟨true, true, true, false, true, false⟩,  -- 5 需: 乾下坎上
    ⟨false, true, false, true, true, true⟩,  -- 6 訟: 坎下乾上
    ⟨false, true, false, false, false, false⟩,  -- 7 師: 坎下坤上
    ⟨false, false, false, false, true, false⟩,  -- 8 比: 坤下坎上
    ⟨true, true, true, false, true, true⟩,  -- 9 小畜: 乾下巽上
    ⟨true, true, false, true, true, true⟩,  -- 10 履: 兌下乾上
    ⟨true, true, true, false, false, false⟩,  -- 11 泰: 乾下坤上
    ⟨false, false, false, true, true, true⟩,  -- 12 否: 坤下乾上
    ⟨true, false, true, true, true, true⟩,  -- 13 同人: 離下乾上
    ⟨true, true, true, true, false, true⟩,  -- 14 大有: 乾下離上
    ⟨false, false, true, false, false, false⟩,  -- 15 謙: 艮下坤上
    ⟨false, false, false, true, false, false⟩,  -- 16 豫: 坤下震上
    ⟨true, false, false, true, true, false⟩,  -- 17 隨: 震下兌上
    ⟨false, true, true, false, false, true⟩,  -- 18 蠱: 巽下艮上
    ⟨true, true, false, false, false, false⟩,  -- 19 臨: 兌下坤上
    ⟨false, false, false, false, true, true⟩,  -- 20 觀: 坤下巽上
    ⟨true, false, false, true, false, true⟩,  -- 21 噬嗑: 震下離上
    ⟨true, false, true, false, false, true⟩,  -- 22 賁: 離下艮上
    ⟨false, false, false, false, false, true⟩,  -- 23 剝: 坤下艮上
    ⟨true, false, false, false, false, false⟩,  -- 24 復: 震下坤上
    ⟨true, false, false, true, true, true⟩,  -- 25 无妄: 震下乾上
    ⟨true, true, true, false, false, true⟩,  -- 26 大畜: 乾下艮上
    ⟨true, false, false, false, false, true⟩,  -- 27 頤: 震下艮上
    ⟨false, true, true, true, true, false⟩,  -- 28 大過: 巽下兌上
    ⟨false, true, false, false, true, false⟩,  -- 29 坎: 坎下坎上
    ⟨true, false, true, true, false, true⟩,  -- 30 離: 離下離上
    ⟨false, false, true, true, true, false⟩,  -- 31 咸: 艮下兌上
    ⟨false, true, true, true, false, false⟩,  -- 32 恒: 巽下震上
    ⟨false, false, true, true, true, true⟩,  -- 33 遯: 艮下乾上
    ⟨true, true, true, true, false, false⟩,  -- 34 大壯: 乾下震上
    ⟨false, false, false, true, false, true⟩,  -- 35 晉: 坤下離上
    ⟨true, false, true, false, false, false⟩,  -- 36 明夷: 離下坤上
    ⟨true, false, true, false, true, true⟩,  -- 37 家人: 離下巽上
    ⟨true, true, false, true, false, true⟩,  -- 38 睽: 兌下離上
    ⟨false, false, true, false, true, false⟩,  -- 39 蹇: 艮下坎上
    ⟨false, true, false, true, false, false⟩,  -- 40 解: 坎下震上
    ⟨true, true, false, false, false, true⟩,  -- 41 損: 兌下艮上
    ⟨true, false, false, false, true, true⟩,  -- 42 益: 震下巽上
    ⟨true, true, true, true, true, false⟩,  -- 43 夬: 乾下兌上
    ⟨false, true, true, true, true, true⟩,  -- 44 姤: 巽下乾上
    ⟨false, false, false, true, true, false⟩,  -- 45 萃: 坤下兌上
    ⟨false, true, true, false, false, false⟩,  -- 46 升: 巽下坤上
    ⟨false, true, false, true, true, false⟩,  -- 47 困: 坎下兌上
    ⟨false, true, true, false, true, false⟩,  -- 48 井: 巽下坎上
    ⟨true, false, true, true, true, false⟩,  -- 49 革: 離下兌上
    ⟨false, true, true, true, false, true⟩,  -- 50 鼎: 巽下離上
    ⟨true, false, false, true, false, false⟩,  -- 51 震: 震下震上
    ⟨false, false, true, false, false, true⟩,  -- 52 艮: 艮下艮上
    ⟨false, false, true, false, true, true⟩,  -- 53 漸: 艮下巽上
    ⟨true, true, false, true, false, false⟩,  -- 54 歸妹: 兌下震上
    ⟨true, false, true, true, false, false⟩,  -- 55 豐: 離下震上
    ⟨false, false, true, true, false, true⟩,  -- 56 旅: 艮下離上
    ⟨false, true, true, false, true, true⟩,  -- 57 巽: 巽下巽上
    ⟨true, true, false, true, true, false⟩,  -- 58 兌: 兌下兌上
    ⟨false, true, false, false, true, true⟩,  -- 59 渙: 坎下巽上
    ⟨true, true, false, false, true, false⟩,  -- 60 節: 兌下坎上
    ⟨true, true, false, false, true, true⟩,  -- 61 中孚: 兌下巽上
    ⟨false, false, true, true, false, false⟩,  -- 62 小過: 艮下震上
    ⟨true, false, true, false, true, false⟩,  -- 63 既濟: 離下坎上
    ⟨false, true, false, true, false, true⟩  -- 64 未濟: 坎下離上
  ]

theorem order_length : order.length = 64 := rfl

/-- **The received order holds every configuration.** -/
theorem mem_order (s : Hexagram) : s ∈ order := by
  cases s with
  | mk a b c d e f =>
    cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> cases f <;>
      exact mem_of_memb rfl

/-- Every line into its opposite (錯). -/
def complement : Hexagram → Hexagram
  | ⟨a, b, c, d, e, f⟩ => ⟨!a, !b, !c, !d, !e, !f⟩

/-- Turned over, the top line becoming the bottom (覆, 綜). -/
def reverse : Hexagram → Hexagram
  | ⟨a, b, c, d, e, f⟩ => ⟨f, e, d, c, b, a⟩

theorem complement_complement : ∀ s : Hexagram, complement (complement s) = s
  | ⟨a, b, c, d, e, f⟩ => by
    show (⟨!!a, !!b, !!c, !!d, !!e, !!f⟩ : Hexagram) = ⟨a, b, c, d, e, f⟩
    rw [ListTests.not_not a, ListTests.not_not b, ListTests.not_not c, ListTests.not_not d,
      ListTests.not_not e, ListTests.not_not f]

/-- Two consecutive members of the order are paired: the second is the first turned over, or,
where turning over gives the same hexagram, the first changed in every line. -/
def Paired (s t : Hexagram) : Prop :=
  (reverse s ≠ s ∧ t = reverse s) ∨ (reverse s = s ∧ t = complement s)

/-- The order taken two by two. -/
def pairs : List Hexagram → List (Hexagram × Hexagram)
  | [] => []
  | [_] => []
  | s :: t :: rest => (s, t) :: pairs rest

/-- Pairing, told line by line. -/
def pairedb (s t : Hexagram) : Bool :=
  (!eqb (reverse s) s && eqb t (reverse s)) || (eqb (reverse s) s && eqb t (complement s))

theorem paired_of_pairedb {s t : Hexagram} (h : pairedb s t = true) : Paired s t :=
  match ListTests.or_cases h with
  | .inl turned => match bool_of_and_true turned with
    | ⟨other, eq⟩ => .inl ⟨ne_of_eqb (ListTests.false_of_not other), eq_of_eqb eq⟩
  | .inr changed => match bool_of_and_true changed with
    | ⟨fixed, eq⟩ => .inr ⟨eq_of_eqb fixed, eq_of_eqb eq⟩

/-- Every pair of a list is paired, told line by line. -/
def allPaired : List (Hexagram × Hexagram) → Bool
  | [] => true
  | q :: l => pairedb q.1 q.2 && allPaired l

theorem paired_of_allPaired : ∀ {l : List (Hexagram × Hexagram)}, allPaired l = true →
    ∀ q, q ∈ l → Paired q.1 q.2
  | [], _, _, mem => nomatch mem
  | _ :: _, h, _, .head _ => paired_of_pairedb (bool_of_and_true h).1
  | _ :: _, h, q, .tail _ mem => paired_of_allPaired (bool_of_and_true h).2 q mem

/-- **Two by two, each pair of the order is turned over or changed in every line**
(二二相耦，非覆即變). -/
theorem order_paired : ∀ q, q ∈ pairs order → Paired q.1 q.2 :=
  paired_of_allPaired rfl

/-! ## The change of one line -/

/-- The line at place `k` turns into its opposite (爻變). -/
def flip : Place → Hexagram → Hexagram
  | .p1, ⟨a, b, c, d, e, f⟩ => ⟨!a, b, c, d, e, f⟩
  | .p2, ⟨a, b, c, d, e, f⟩ => ⟨a, !b, c, d, e, f⟩
  | .p3, ⟨a, b, c, d, e, f⟩ => ⟨a, b, !c, d, e, f⟩
  | .p4, ⟨a, b, c, d, e, f⟩ => ⟨a, b, c, !d, e, f⟩
  | .p5, ⟨a, b, c, d, e, f⟩ => ⟨a, b, c, d, !e, f⟩
  | .p6, ⟨a, b, c, d, e, f⟩ => ⟨a, b, c, d, e, !f⟩

theorem flip_flip : ∀ (k : Place) (s : Hexagram), flip k (flip k s) = s
  | .p1, ⟨a, b, c, d, e, f⟩ =>
    congrArg (fun x => (⟨x, b, c, d, e, f⟩ : Hexagram)) (ListTests.not_not a)
  | .p2, ⟨a, b, c, d, e, f⟩ =>
    congrArg (fun x => (⟨a, x, c, d, e, f⟩ : Hexagram)) (ListTests.not_not b)
  | .p3, ⟨a, b, c, d, e, f⟩ =>
    congrArg (fun x => (⟨a, b, x, d, e, f⟩ : Hexagram)) (ListTests.not_not c)
  | .p4, ⟨a, b, c, d, e, f⟩ =>
    congrArg (fun x => (⟨a, b, c, x, e, f⟩ : Hexagram)) (ListTests.not_not d)
  | .p5, ⟨a, b, c, d, e, f⟩ =>
    congrArg (fun x => (⟨a, b, c, d, x, f⟩ : Hexagram)) (ListTests.not_not e)
  | .p6, ⟨a, b, c, d, e, f⟩ =>
    congrArg (fun x => (⟨a, b, c, d, e, x⟩ : Hexagram)) (ListTests.not_not f)

/-- The change of one line: a step turns the line at one place into its opposite. -/
def changes : Process Hexagram Place := ⟨fun s k t => t = flip k s⟩

/-- **Every configuration returns under the change of lines**: changing a line twice. -/
theorem changes_returns (s : Hexagram) : Branching.Returns changes s :=
  ⟨.p1, flip .p1 s, rfl, Reach.of_step (a := Place.p1) (flip_flip .p1 s).symm⟩

/-- All lines broken (坤). -/
def allBroken : Hexagram := ⟨false, false, false, false, false, false⟩

/-- **The change of lines merges**: two configurations differing at two places reach one. -/
theorem changes_merges : Branching.Merges changes :=
  ⟨⟨true, false, false, false, false, false⟩, ⟨false, true, false, false, false, false⟩,
    .p1, .p2, allBroken, ne_of_eqb rfl, rfl, rfl⟩

/-- **Every possibility is kept, though the process merges.** -/
theorem changes_keeps : Branching.KeepsPossibilities changes ∧ ¬ Branching.Lossless changes :=
  ⟨Branching.keeps_of_returns changes_returns, Branching.Merges.not_lossless changes_merges⟩

theorem line_step : ∀ x y : Bool, y = x ∨ y = !x
  | true, true => .inl rfl
  | true, false => .inr rfl
  | false, false => .inl rfl
  | false, true => .inr rfl

theorem lift {α β : Type} (g : α → β) {x y z : α} : y = x ∨ y = z → g y = g x ∨ g y = g z
  | .inl e => .inl (congrArg g e)
  | .inr e => .inr (congrArg g e)

theorem toward {k : Place} {s t : Hexagram} : t = s ∨ t = flip k s → Reach changes s t
  | .inl same => by
    cases same
    exact Reach.refl changes _
  | .inr step => Reach.of_step step

/-- **Every configuration can be had from every other** (周流六虛), changing the lines at the
places where the two differ. -/
theorem reach_every : ∀ s t : Hexagram, Reach changes s t
  | ⟨a1, a2, a3, a4, a5, a6⟩, ⟨b1, b2, b3, b4, b5, b6⟩ =>
    Reach.trans (toward (k := .p1)
      (lift (fun x => (⟨x, a2, a3, a4, a5, a6⟩ : Hexagram)) (line_step a1 b1)))
    (Reach.trans (toward (k := .p2)
      (lift (fun x => (⟨b1, x, a3, a4, a5, a6⟩ : Hexagram)) (line_step a2 b2)))
    (Reach.trans (toward (k := .p3)
      (lift (fun x => (⟨b1, b2, x, a4, a5, a6⟩ : Hexagram)) (line_step a3 b3)))
    (Reach.trans (toward (k := .p4)
      (lift (fun x => (⟨b1, b2, b3, x, a5, a6⟩ : Hexagram)) (line_step a4 b4)))
    (Reach.trans (toward (k := .p5)
      (lift (fun x => (⟨b1, b2, b3, b4, x, a6⟩ : Hexagram)) (line_step a5 b5)))
      (toward (k := .p6)
        (lift (fun x => (⟨b1, b2, b3, b4, b5, x⟩ : Hexagram)) (line_step a6 b6)))))))

/-- **A run of the change of lines revisits from every step on.** -/
theorem changes_run_revisits (r : Run changes) (T : Nat) :
    ∃ i j, T ≤ i ∧ i < j ∧ r.state i = r.state j :=
  r.revisits_from (fun n => mem_order (r.state n)) T

/-! ## The law of waxing and waning -/

/-- Every line rises one place, and the top line passes out and enters at the bottom as its
opposite (消息). -/
def waxWane : Hexagram → Hexagram
  | ⟨a, b, c, d, e, f⟩ => ⟨!f, a, b, c, d, e⟩

/-- The law run backward: every line falls one place, and the bottom line passes out and enters
at the top as its opposite. -/
def unwaxWane : Hexagram → Hexagram
  | ⟨a, b, c, d, e, f⟩ => ⟨b, c, d, e, f, !a⟩

theorem unwax_wax : ∀ s : Hexagram, unwaxWane (waxWane s) = s
  | ⟨a, b, c, d, e, f⟩ =>
    congrArg (fun x => (⟨a, b, c, d, e, x⟩ : Hexagram)) (ListTests.not_not f)

/-- **The law of waxing and waning merges nothing.** -/
theorem waxWane_lossless : Law.Lossless waxWane :=
  Law.lossless_iff.mpr fun x y same => (unwax_wax x).symm.trans ((congrArg unwaxWane same).trans (unwax_wax y))

/-- **Under the law of waxing and waning every configuration returns**, by
`Law.lossless_iff_returns` on the received order. -/
theorem waxWane_returns : ∀ s, Law.Returns waxWane s :=
  (Law.lossless_iff_returns mem_order).mp waxWane_lossless

/-- The same, read on the law as a process of the spine. -/
theorem waxWane_process_returns (s : Hexagram) : Branching.Returns (Law.process waxWane) s :=
  Branching.law_returns_iff.mpr (waxWane_returns s)

/-- **Six steps change every line.** -/
theorem six_steps : ∀ s : Hexagram, Law.orbit waxWane s 6 = complement s
  | ⟨_, _, _, _, _, _⟩ => rfl

/-- **Six steps on along every run of the law, every line is changed.** -/
theorem run_six_steps (s : Hexagram) (n : Nat) :
    (Law.run waxWane s).state (n + 6) = complement ((Law.run waxWane s).state n) :=
  (Law.orbit_add waxWane s n 6).trans (six_steps (Law.orbit waxWane s n))

/-- **Twelve steps on along every run of the law, the configuration is had again.** -/
theorem twelve_steps (s : Hexagram) (n : Nat) :
    (Law.run waxWane s).state (n + 12) = (Law.run waxWane s).state n :=
  (Law.orbit_add waxWane s n 12).trans
    ((Law.orbit_add waxWane (Law.orbit waxWane s n) 6 6).trans
      ((congrArg (fun x => Law.orbit waxWane x 6) (six_steps (Law.orbit waxWane s n))).trans
        ((six_steps _).trans (complement_complement _))))

/-- **Each pair of the received order is linked by the law of waxing and waning**: the second is
the first turned over, or, where turning over gives the same hexagram, the first six steps on along
the law's run (非覆即變, the change in every line being six steps of waxing and waning). -/
theorem order_paired_by_law : ∀ q, q ∈ pairs order →
    (reverse q.1 ≠ q.1 ∧ q.2 = reverse q.1) ∨
      (reverse q.1 = q.1 ∧ q.2 = (Law.run waxWane q.1).state 6) :=
  fun q mem => match order_paired q mem with
    | .inl turned => .inl turned
    | .inr ⟨fixed, changed⟩ => .inr ⟨fixed, changed.trans (six_steps q.1).symm⟩

/-- `k` unbroken lines from the bottom and the rest broken: 坤, 復, 臨, 泰, 大壯, 夬, 乾 for
`k` from 0 to 6. -/
def rising : Nat → Hexagram
  | 0 => ⟨false, false, false, false, false, false⟩
  | 1 => ⟨true, false, false, false, false, false⟩
  | 2 => ⟨true, true, false, false, false, false⟩
  | 3 => ⟨true, true, true, false, false, false⟩
  | 4 => ⟨true, true, true, true, false, false⟩
  | 5 => ⟨true, true, true, true, true, false⟩
  | _ => ⟨true, true, true, true, true, true⟩

/-- `k` broken lines from the bottom and the rest unbroken: 乾, 姤, 遯, 否, 觀, 剝, 坤 for `k`
from 0 to 6. -/
def falling : Nat → Hexagram
  | 0 => ⟨true, true, true, true, true, true⟩
  | 1 => ⟨false, true, true, true, true, true⟩
  | 2 => ⟨false, false, true, true, true, true⟩
  | 3 => ⟨false, false, false, true, true, true⟩
  | 4 => ⟨false, false, false, false, true, true⟩
  | 5 => ⟨false, false, false, false, false, true⟩
  | _ => ⟨false, false, false, false, false, false⟩

theorem not_le_six (k : Nat) : ¬ k + 7 ≤ 6 :=
  Nat.not_le_of_gt (Nat.lt_of_lt_of_le (Nat.lt_succ_self 6) (Nat.le_add_left 7 k))

/-- **Waxing**: from all lines broken, the unbroken lines rise from the bottom one step at a time
until all are unbroken. -/
theorem waxing : ∀ k, k ≤ 6 → (Law.run waxWane (rising 0)).state k = rising k
  | 0, _ => rfl
  | 1, _ => rfl
  | 2, _ => rfl
  | 3, _ => rfl
  | 4, _ => rfl
  | 5, _ => rfl
  | 6, _ => rfl
  | k + 7, le => absurd le (not_le_six k)

/-- **Waning**: from all lines unbroken, the broken lines rise from the bottom one step at a time
until all are broken. -/
theorem waning : ∀ k, k ≤ 6 → (Law.run waxWane (rising 6)).state k = falling k
  | 0, _ => rfl
  | 1, _ => rfl
  | 2, _ => rfl
  | 3, _ => rfl
  | 4, _ => rfl
  | 5, _ => rfl
  | 6, _ => rfl
  | k + 7, le => absurd le (not_le_six k)

/-- **The first unbroken line comes back at the seventh step from all unbroken** (乾 to 復). -/
theorem seventh_step : (Law.run waxWane (rising 6)).state 7 = rising 1 := rfl

theorem not_lt_twelve (k : Nat) : ¬ k + 12 < 12 :=
  Nat.not_lt_of_le (Nat.le_add_left 12 k)

/-- **All broken first returns at the twelfth step.** -/
theorem first_return : ∀ p, 0 < p → p < 12 → (Law.run waxWane (rising 0)).state p ≠ rising 0
  | 0, pos, _ => absurd pos (Nat.lt_irrefl 0)
  | 1, _, _ => ne_of_eqb rfl
  | 2, _, _ => ne_of_eqb rfl
  | 3, _, _ => ne_of_eqb rfl
  | 4, _, _ => ne_of_eqb rfl
  | 5, _, _ => ne_of_eqb rfl
  | 6, _, _ => ne_of_eqb rfl
  | 7, _, _ => ne_of_eqb rfl
  | 8, _, _ => ne_of_eqb rfl
  | 9, _, _ => ne_of_eqb rfl
  | 10, _, _ => ne_of_eqb rfl
  | 11, _, _ => ne_of_eqb rfl
  | k + 12, _, lt => absurd lt (not_lt_twelve k)

/-- 隨: lines 1 and 4 and 5 unbroken. -/
def sui : Hexagram := ⟨true, false, false, true, true, false⟩

/-- **Some configurations return at the fourth step** (隨, 中孚, 蠱, 小過). -/
theorem fourth_step : (Law.run waxWane sui).state 4 = sui ∧ (Law.run waxWane sui).state 2 ≠ sui :=
  ⟨rfl, ne_of_eqb rfl⟩

/-! ## Where the law merges -/

/-- Every line rises one place, the top line passes out, and a broken line enters at the
bottom: waning with no waxing. -/
def wane : Hexagram → Hexagram
  | ⟨a, b, c, d, e, _⟩ => ⟨false, a, b, c, d, e⟩

/-- **Where only a broken line enters, the law merges** (剝 and 坤 go on to 坤). -/
theorem wane_merges : Law.Merges wane :=
  Law.merges_iff.mpr ⟨falling 5, rising 0, ne_of_eqb rfl, rfl⟩

/-- **After six steps every configuration is all broken.** -/
theorem wane_six : ∀ s : Hexagram, (Law.run wane s).state 6 = allBroken
  | ⟨_, _, _, _, _, _⟩ => rfl

/-- **All broken is a region the law never leaves.** -/
theorem allBroken_absorbing : Law.Absorbing wane (fun s => s = allBroken) :=
  fun _ inside => by
    cases inside
    rfl

/-- **Every other configuration is drawn into all broken.** -/
theorem wane_drawn {s : Hexagram} (other : s ≠ allBroken) :
    Law.DrawnInto wane (fun x => x = allBroken) s :=
  ⟨other, 6, wane_six s⟩

/-- **What is drawn in never comes back**, by `Law.DrawnInto.never_back`. -/
theorem wane_never_back {s : Hexagram} (other : s ≠ allBroken) :
    ∀ k, (Law.run wane s).state (6 + k) ≠ s :=
  Law.DrawnInto.never_back allBroken_absorbing other (wane_six s)

/-- **And never returns**, by `Law.Drawn.not_returns`, read on the law as a process. -/
theorem wane_not_returns {s : Hexagram} (other : s ≠ allBroken) :
    ¬ Branching.Returns (Law.process wane) s :=
  fun returns => Law.Drawn.not_returns ⟨_, allBroken_absorbing, wane_drawn other⟩
    (Branching.law_returns_iff.mp returns)

/-- **A possibility is lost for good**, by `Law.Merges.loses`, read on the law as a process. -/
theorem wane_loses : ¬ Branching.KeepsPossibilities (Law.process wane) :=
  fun keeps => wane_merges.loses mem_order
    (fun s => (Branching.law_keeps_iff.mp keeps) order.length s)

/-- The same merge, read on the law as a process of the spine. -/
theorem wane_process_merges : Branching.Merges (Law.process wane) :=
  Branching.law_merges_iff.mpr wane_merges

/-- **For every law of hexagrams, every configuration returns exactly where the law merges
nothing** (`Law.lossless_iff_returns` on the received order). -/
theorem every_returns_iff (next : Hexagram → Hexagram) :
    (∀ s, Branching.Returns (Law.process next) s) ↔ Branching.Lossless (Law.process next) :=
  ⟨fun returns => Branching.law_lossless_iff.mpr
      ((Law.lossless_iff_returns mem_order).mpr fun s => Branching.law_returns_iff.mp (returns s)),
   fun lossless s => Branching.law_returns_iff.mpr
      ((Law.lossless_iff_returns mem_order).mp (Branching.law_lossless_iff.mp lossless) s)⟩

/-! ## Symmetries and what a lumping carries -/

/-- **The law commutes with the complement.** -/
theorem waxWane_complement : ∀ s : Hexagram, waxWane (complement s) = complement (waxWane s)
  | ⟨_, _, _, _, _, _⟩ => rfl

theorem reverse_wax : ∀ s : Hexagram, reverse (waxWane s) = unwaxWane (reverse s)
  | ⟨_, _, _, _, _, _⟩ => rfl

/-- **Turning over runs the law backward**: along every run, each step turned over is a step of
the law run backward. -/
theorem reverse_waxWane (s : Hexagram) (n : Nat) :
    reverse ((Law.run waxWane s).state (n + 1)) = unwaxWane (reverse ((Law.run waxWane s).state n)) :=
  reverse_wax _

/-- The pair of a hexagram and its complement, named by the member whose top line is broken. -/
def pairOf : Hexagram → Hexagram
  | ⟨a, b, c, d, e, true⟩ => ⟨!a, !b, !c, !d, !e, false⟩
  | ⟨a, b, c, d, e, false⟩ => ⟨a, b, c, d, e, false⟩

theorem pairOf_cases : ∀ s : Hexagram, pairOf s = s ∨ pairOf s = complement s
  | ⟨_, _, _, _, _, true⟩ => .inr rfl
  | ⟨_, _, _, _, _, false⟩ => .inl rfl

theorem complement_inj {s t : Hexagram} (same : complement s = complement t) : s = t :=
  (complement_complement s).symm.trans ((congrArg complement same).trans (complement_complement t))

/-- Two hexagrams name one pair exactly where they are equal or complements. -/
theorem pairOf_eq {s t : Hexagram} (same : pairOf s = pairOf t) : t = s ∨ t = complement s :=
  match pairOf_cases s, pairOf_cases t with
  | .inl hs, .inl ht => .inl (ht.symm.trans (same.symm.trans hs))
  | .inl hs, .inr ht =>
    .inr ((complement_complement t).symm.trans
      (congrArg complement (ht.symm.trans (same.symm.trans hs))))
  | .inr hs, .inl ht => .inr (ht.symm.trans (same.symm.trans hs))
  | .inr hs, .inr ht => .inl (complement_inj (ht.symm.trans (same.symm.trans hs)))

theorem pairOf_complement : ∀ s : Hexagram, pairOf (complement s) = pairOf s
  | ⟨_, _, _, _, _, true⟩ => rfl
  | ⟨a, b, c, d, e, false⟩ => by
    show (⟨!!a, !!b, !!c, !!d, !!e, false⟩ : Hexagram) = ⟨a, b, c, d, e, false⟩
    rw [ListTests.not_not a, ListTests.not_not b, ListTests.not_not c, ListTests.not_not d,
      ListTests.not_not e]

/-- **The law goes alike across the pairs of complements.** -/
theorem pairs_lumped : Learning.Lumped pairOf (fun s => pairOf (waxWane s)) :=
  fun s t same => match pairOf_eq same with
  | .inl e => by
    subst e
    rfl
  | .inr e => by
    subst e
    exact ((congrArg pairOf (waxWane_complement s)).trans (pairOf_complement (waxWane s))).symm

/-- **The pairs of complements are a lumping the law goes alike across**, by
`Learning.goAlike_iff_lumped`. -/
theorem pairs_goAlike : GoAlike (Law.process waxWane) pairOf :=
  Learning.goAlike_iff_lumped.mpr pairs_lumped

/-- The count of unbroken lines. -/
def yang (s : Hexagram) : Nat :=
  s.l1.toNat + s.l2.toNat + s.l3.toNat + s.l4.toNat + s.l5.toNat + s.l6.toNat

/-- **The count of unbroken lines is not a lumping the law goes alike across**: 泰 and 否 have
three each, and go on to four and to two. -/
theorem yang_not_lumped : ¬ Learning.Lumped yang (fun s => yang (waxWane s)) :=
  fun lumped => absurd (lumped (rising 3) (falling 3) rfl) (by decide)

theorem yang_not_goAlike : ¬ GoAlike (Law.process waxWane) yang :=
  fun alike => yang_not_lumped (Learning.goAlike_iff_lumped.mp alike)

/-! ## The lines as claims, as a frame and as a world -/

/-- The lines read as claims along the law: the claim at a place is realized where its line is
unbroken. -/
def lines : Frame Hexagram Unit Place := ⟨Law.process waxWane, fun s k => s.line k = true⟩

theorem complement_l1 : ∀ s : Hexagram, (complement s).l1 = !s.l1
  | ⟨_, _, _, _, _, _⟩ => rfl

/-- Six steps on, the bottom line is turned. -/
theorem bottom_turns (s : Hexagram) (n : Nat) :
    (Law.orbit waxWane s (n + 6)).l1 = !(Law.orbit waxWane s n).l1 :=
  (congrArg Hexagram.l1 ((Law.orbit_add waxWane s n 6).trans
    (six_steps (Law.orbit waxWane s n)))).trans (complement_l1 _)

/-- A two-valued course that is `false` at `a` and `true` at `a + n` comes to be `true` across
some step in between. -/
theorem rises_between (p : Nat → Bool) : ∀ n a, p a = false → p (a + n) = true →
    ∃ i, a ≤ i ∧ i < a + n ∧ p i = false ∧ p (i + 1) = true
  | 0, _, low, high => Bool.noConfusion (low.symm.trans high)
  | n + 1, a, low, high =>
    match h : p (a + 1) with
    | true => ⟨a, Nat.le_refl a, Nat.lt_of_lt_of_le (Nat.lt_succ_self a)
        (Nat.succ_le_succ (Nat.le_add_right a n)), low, h⟩
    | false =>
      match rises_between p n (a + 1) h
          (((Nat.succ_add a n).trans (Nat.add_succ a n).symm) ▸ high) with
      | ⟨i, le, lt, at_i, after⟩ =>
        ⟨i, Nat.le_of_succ_le le, ((Nat.succ_add a n).trans (Nat.add_succ a n).symm) ▸ lt,
          at_i, after⟩

theorem not_true_of_false {b : Bool} (h : b = false) : ¬ b = true :=
  fun t => Bool.noConfusion (h.symm.trans t)

/-- **Along every run of the law, a line comes to be unbroken at arbitrarily late steps.** -/
theorem arising_recurs (s : Hexagram) :
    Recurs places (fun k => ComesToBe (fun n => lines.realized ((Law.run waxWane s).state n) k)) :=
  fun N =>
    let p := fun n => (Law.orbit waxWane s n).l1
    let found : ∃ i, N ≤ i ∧ p i = false ∧ p (i + 1) = true :=
      match v : p N with
      | false => match rises_between p 6 N v (by
            show (Law.orbit waxWane s (N + 6)).l1 = true
            rw [bottom_turns s N]
            exact ListTests.not_eq_true_of_false v) with
        | ⟨i, le, _, at_i, after⟩ => ⟨i, le, at_i, after⟩
      | true =>
        have low : p (N + 6) = false := by
          show (Law.orbit waxWane s (N + 6)).l1 = false
          rw [bottom_turns s N]
          exact ListTests.not_false_of_true v
        match rises_between p 6 (N + 6) low (by
            show (Law.orbit waxWane s (N + 6 + 6)).l1 = true
            rw [bottom_turns s (N + 6)]
            exact ListTests.not_eq_true_of_false low) with
        | ⟨i, le, _, at_i, after⟩ => ⟨i, Nat.le_trans (Nat.le_add_right N 6) le, at_i, after⟩
    match found with
    | ⟨i, le, at_i, after⟩ => ⟨i, .p1, le, .head _, not_true_of_false at_i, after⟩

/-- **So a line also ceases to be unbroken at arbitrarily late steps**, by
`Frame.claims_recur_iff`. -/
theorem ceasing_recurs (s : Hexagram) :
    Recurs places (fun k => CeasesToBe (fun n => lines.realized ((Law.run waxWane s).state n) k)) :=
  have _decided : ∀ (k : Place) (t : Nat),
      Decidable (lines.realized ((Law.run waxWane s).state t) k) :=
    fun _ _ => instDecidableEqBool _ _
  (Frame.claims_recur_iff (F := lines) (r := Law.run waxWane s)).mp (arising_recurs s)

/-- **Read as a world, the places arise at arbitrarily late steps.** -/
theorem world_arising_recurs (s : Hexagram) :
    Recurs places (fun k t => (lines.world (Law.run waxWane s)).web.Arises t k) :=
  (arising_recurs s).mono fun _ _ comes => Frame.arises_iff.mpr comes

/-- **And cease at arbitrarily late steps.** -/
theorem world_ceasing_recurs (s : Hexagram) :
    Recurs places (fun k t => (lines.world (Law.run waxWane s)).web.Ceases t k) :=
  (ceasing_recurs s).mono fun _ _ ceases => ceases

/-! ## Going on within the sixty-four -/

/-- **Any sixty-five steps of a run of hexagrams revisit a configuration**, under every process
on them: sixty-four is the length of the received order (`order_length`), which holds every
configuration. -/
theorem revisits_within_order {A : Type} {P : Process Hexagram A} (r : Run P) :
    ∃ i j, i < j ∧ j ≤ 64 ∧ r.state i = r.state j :=
  order_length ▸ revisits_within order r.state (fun n _ => mem_order (r.state n))

/-- **The law with its history kept is held by no list**, by `Law.withHistory_unlisted`. -/
theorem kept_history_unlisted (h : Hexagram × List Hexagram) :
    ¬ ∃ l : List (Hexagram × List Hexagram), ∀ n, (Law.run (Law.withHistory waxWane) h).state n ∈ l :=
  Law.withHistory_unlisted waxWane h

end Hexagram

end Becoming
