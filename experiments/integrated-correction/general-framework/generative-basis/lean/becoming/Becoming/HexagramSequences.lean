import Becoming.HexagramLaws
import Becoming.HexagramSites
import Becoming.Seeking
import Becoming.Unfolding
import Becoming.Flow

/-!
# What of the arrangements of the 傳 is a law

The 序卦 sets the sixty-four in one order, the 雜卦 in another, the 彖 reads 損, 益, 恒 and 咸 as
泰 and 否 with lines exchanged, 繫辭下 tells the trigrams by the count of their lines (陽卦奇，
陰卦偶), and 說卦 ch. 5 sets the eight trigrams at eight stations (帝出乎震). `Becoming.Hexagrams`
checks the pairing of the received order (`order_paired`) and leaves the arrangements themselves
aside. This module asks of each what a law can carry of it, with no premise, and states each law
along runs.

* **The received order is the run of a law, and only of a table.** A law runs the received order
  where its run from 乾 holds the sixty-four in that order (`RunsOrder`, `runsOrder_iff`). One does
  (`orderNext`, `orderNext_runsOrder`), and every law that does agrees with it everywhere but at
  未濟 (`runsOrder_agrees`); of these exactly the one taking 未濟 back to 乾 merges nothing
  (`runsOrder_lossless_iff`), and it has one orbit of sixty-four (`orderNext_one_orbit`). But every
  law running the order reads every line for every line: changing any line changes any given
  line of the next configuration somewhere (`runsOrder_reads`), so no reading blind to one line
  fixes any line of the next (`runsOrder_blind_not_lumped`), and no three-cell rule on a ring of
  six runs it, with the wrap read straight or turned (`ringRule_not_runsOrder`,
  `twistedRule_not_runsOrder`), the law of waxing and waning among them (`waxWane_twisted`,
  `waxWane_not_runsOrder`). One step of the order is such a rule's: 剝窮上反下, the straight shift
  taking 剝 to 復, where waxing and waning passes through 坤 (`bo_fu`).
  None commutes with 錯, 綜 or both (`runsOrder_not_commutes`): each pair of the order is a step of
  one of them, and a law commuting with an exchange that it steps along goes back the next step
  (`Follows.back`, by `Law.Commutes.paired_halfway`). Every rearrangement of the places with lines
  turned by a mask commutes with 錯 (`rearrange_complement`), so none runs the order
  (`rearrange_not_runsOrder`); and a law running it goes alike neither across the pairs nor across
  the parity of the count (`runsOrder_not_lumped`), the lumpings waxing and waning goes alike
  across. So the order is not the orbit of any law that reads less than the whole configuration
  or keeps any symmetry of the configurations; the 序卦 gives its reasons in words, not in a law.
* **卦變: the exchange of two lines.** Exchanging the lines at two places keeps the count of
  unbroken lines (`swap`, `yang_swap`). An exchange of a line of the lower trigram with one of the
  upper is a step of the law of exchange between the two trigrams, its move one unbroken line
  passed up, passed down or nothing (`across`, `passing`, `across_exchange`): 損 is 泰 with an
  unbroken line passed up (損下益上), 益 is 否 with one passed down (損上益下), and 恒 and 咸 are
  the same exchanges at the other ends (剛上而柔下, 柔上而剛下) (`named_exchanges`). The twenty
  configurations with three unbroken lines are exactly 泰, 否 and the eighteen one exchange across
  from them (`three_iff`, `three_census`). Every course of exchanges keeps the count
  (`exchanges_keep`, `exchanges_run_total`), so from 泰 or 否 it stays among the twenty
  (`exchanges_from_tai_pi`); its trigram counts run by the law of exchange (`exchangesRun`), and
  read as a world it balances, so every rise of a trigram's count is given and every fall taken
  (`exchangeWorld_balances`, `exchangeWorld_rise_fall`).
* **Parity.** Every step of waxing and waning and every change of a line turns the parity of the
  count of unbroken lines, and the complement keeps it (`yangOdd_waxWane`, `yangOdd_flip`,
  `yangOdd_complement`); so the parity is a lumping both go alike across, where the count is not
  (`yangOdd_lumped`, `yangOdd_goAlike`, `yangOdd_goAlike_changes`), turning at every step of their
  runs (`run_yangOdd`, `changes_run_yangOdd`); the nuclear law does not go alike across it
  (`nuclear_yangOdd_not_lumped`, `nuclear_yangOdd_not_goAlike`). For three lines an odd count is
  exactly 乾 or 坤 with one line changed (震, 坎, 艮), an even count exactly 坤 or 乾 with one line
  changed (巽, 離, 兌), and the strokes, a broken line two, have the same parity (`odd3_iff`):
  陽卦奇，陰卦偶 read in the count. Each trigram's count is a part of the configuration's
  (`halfYang_trigram`, `halfYang_total`); a change of a line turns its trigram's class and keeps
  the other's, so along every course of changes it makes a 陽卦 exactly of a 陰卦
  (`trigramOdd_flip`, `changes_run_trigram`).
* **The 雜卦: the same pairs, another order.** The 雜卦 lists each configuration once
  (`zagua_every`). A configuration's partner is it turned over, or, where turning over keeps it,
  changed in every line (`partner`, `paired_iff_partner`, `partner_partner`), and every run of the
  law taking each to its partner is back two steps on (`partner_run`); the received order
  and the 雜卦's first fifty-six both set every configuration beside its partner (`order_partners`,
  `zagua_partners`), and its last eight hold the remaining four pairs with no partner beside
  partner (`zagua_last_eight`). Its sequence too is the run of no law commuting with 錯, 綜 or
  both (`zagua_not_commutes`).
* **No rest under waxing and waning.** No configuration is a rest of the law of waxing and waning
  (`waxWane_moves`): no run of it rests at any step, 既濟 included, nor comes to rest from any
  step on (`run_never_rests`, `never_comes_to_rest`); no course of changes rests at any step
  (`changes_run_never_rests`).
* **The stations of 說卦 ch. 5.** No law running the eight stations from 震 commutes with 錯, 綜,
  both or the rotation of the three lines (`Trigram.stations_not_commutes`), so no three-cell rule
  on a ring of three runs them, with the wrap read straight or turned, nor any rearrangement of the
  heights with a mask (`Trigram.stations_not_rules`, `Trigram.rearrange3_not_stations`); of the four
  pairs of opposite stations only 離 and 坎 are complements, while each of the four pairs of 說卦
  ch. 3 is (`Trigram.opposite_stations`).
* **交.** 否 is 泰 changed in every line and turned over (`pi_of_tai`), so every reading the
  complement keeps reads them alike along every run of waxing and waning from them (`kept_alike`,
  by `Law.Commutes.iterate`); 交, the line of the lower trigram unbroken and that of the upper
  broken at a height, holds at every height of 泰 and none of 否 (`meets`, `meets_tai_pi`): a
  reading with a direction between the two values, which the complement does not keep. Along the
  two runs their oppositions, alternations, pair and parity agree at every step, while 交 tells
  their starts apart (`tai_pi_runs`).

Readings (AI): the 序卦's and 雜卦's reasons, the stations' seasons and directions, which exchange
the 彖 means for a configuration it names, and the judgments 泰 and 否 carry are not in the
module. Equality and membership are decided line by line; the finite facts are checked by
evaluation over the sixty-four. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

open Generative

universe u

namespace Hexagram

/-! ## Lines read by place -/

/-- The configuration with the given line at each place. -/
def ofLines (f : Place → Bool) : Hexagram := ⟨f .p1, f .p2, f .p3, f .p4, f .p5, f .p6⟩

theorem ofLines_line (f : Place → Bool) : ∀ p, (ofLines f).line p = f p
  | .p1 => rfl
  | .p2 => rfl
  | .p3 => rfl
  | .p4 => rfl
  | .p5 => rfl
  | .p6 => rfl

/-- Two configurations with the same line at every place are one. -/
theorem ext_lines : ∀ {s t : Hexagram}, (∀ p, s.line p = t.line p) → s = t
  | ⟨_, _, _, _, _, _⟩, ⟨_, _, _, _, _, _⟩, same => by
    have e1 := same .p1
    have e2 := same .p2
    have e3 := same .p3
    have e4 := same .p4
    have e5 := same .p5
    have e6 := same .p6
    cases e1
    cases e2
    cases e3
    cases e4
    cases e5
    cases e6
    rfl

/-- **Changing a line moves every configuration.** -/
theorem flip_moves (k : Place) (s : Hexagram) : flip k s ≠ s :=
  fun same => Diagonal.flip_moves (s.line k)
    (((line_flip_self k s).symm.trans (congrArg (fun x => x.line k) same)).symm)

/-! ## A property checked on the received order -/

/-- Every member of a list has the property, told member by member. -/
def allOf (p : Hexagram → Bool) : List Hexagram → Bool
  | [] => true
  | s :: l => p s && allOf p l

theorem of_allOf {p : Hexagram → Bool} :
    ∀ {l : List Hexagram}, allOf p l = true → ∀ s, s ∈ l → p s = true
  | [], _, _, mem => nomatch mem
  | _ :: _, h, _, .head _ => (bool_of_and_true h).1
  | _ :: _, h, s, .tail _ mem => of_allOf (bool_of_and_true h).2 s mem

/-- **A property checked on the received order holds of every configuration** (`mem_order`). -/
theorem every_of_order {p : Hexagram → Bool} (checked : allOf p order = true) (s : Hexagram) :
    p s = true :=
  of_allOf checked s (mem_order s)

theorem differs_ne : ∀ {a b : Bool}, (!same a b) = true → a ≠ b
  | true, true, h, _ => Bool.noConfusion h
  | false, false, h, _ => Bool.noConfusion h
  | true, false, _, e => Bool.noConfusion e
  | false, true, _, e => Bool.noConfusion e

/-! ## A list as a stretch of a run -/

section Runs

variable {α : Type u}

/-- The steps of a list: each member with the next. -/
def steps : List α → List (α × α)
  | [] => []
  | [_] => []
  | s :: t :: rest => (s, t) :: steps (t :: rest)

/-- A law follows a list: it takes each member to the next. -/
def Follows (next : α → α) (l : List α) : Prop :=
  ∀ q, q ∈ steps l → next q.1 = q.2

/-- A law runs through a list: its run from the first member holds the list in order. -/
def RunsThrough (next : α → α) : List α → Prop
  | [] => True
  | s :: l => ∀ n, n < l.length + 1 → (Law.run next s).state n = Law.memberAt s (s :: l) n

theorem Follows.head {next : α → α} {s t : α} {l : List α} (follows : Follows next (s :: t :: l)) :
    next s = t :=
  follows (s, t) (.head _)

theorem Follows.tail {next : α → α} {s t : α} {l : List α} (follows : Follows next (s :: t :: l)) :
    Follows next (t :: l) :=
  fun q mem => follows q (.tail _ mem)

/-- Past the start, the member at a place within a list does not depend on what stands past its
end. -/
theorem memberAt_default {d d' : α} :
    ∀ {l : List α} {n : Nat}, n < l.length → Law.memberAt d l n = Law.memberAt d' l n
  | [], _, lt => absurd lt (Nat.not_lt_zero _)
  | _ :: _, 0, _ => rfl
  | _ :: l, n + 1, lt => memberAt_default (l := l) (n := n) (Nat.lt_of_succ_lt_succ lt)

/-- **A law follows a list exactly where its run from the first member holds the list in
order.** -/
theorem runsThrough_iff {next : α → α} :
    ∀ {s : α} {l : List α}, RunsThrough next (s :: l) ↔ Follows next (s :: l)
  | _, [] => ⟨fun _ _ mem => (nomatch mem), fun _ n lt => match n, lt with
      | 0, _ => rfl
      | _ + 1, lt => absurd (Nat.lt_of_succ_lt_succ lt) (Nat.not_lt_zero _)⟩
  | s, t :: l =>
    ⟨fun runs =>
      have head : next s = t := runs 1 (Nat.succ_lt_succ (Nat.zero_lt_succ _))
      have rest : RunsThrough next (t :: l) := fun n lt =>
        (congrArg (fun x => Law.orbit next x n) head.symm).trans
          ((Law.orbit_shift next s n).symm.trans
            ((runs (n + 1) (Nat.succ_lt_succ lt)).trans
              (memberAt_default (d := s) (d' := t) (l := t :: l) (n := n) lt)))
      fun q mem => match q, mem with
        | _, .head _ => head
        | q, .tail _ mem => (runsThrough_iff.mp rest) q mem,
     fun follows n lt => match n, lt with
      | 0, _ => rfl
      | n + 1, lt => (Law.orbit_shift next s n).trans
          ((congrArg (fun x => Law.orbit next x n) follows.head).trans
            (((runsThrough_iff.mpr follows.tail) n (Nat.lt_of_succ_lt_succ lt)).trans
              (memberAt_default (d := t) (d' := s) (l := t :: l) (n := n)
                (Nat.lt_of_succ_lt_succ lt))))⟩

/-- Steps of a list taken by a law, told step by step. -/
def followsb (good : α → α → Bool) : List (α × α) → Bool
  | [] => true
  | q :: l => good q.1 q.2 && followsb good l

theorem of_followsb {good : α → α → Bool} :
    ∀ {l : List (α × α)}, followsb good l = true → ∀ q, q ∈ l → good q.1 q.2 = true
  | [], _, _, mem => nomatch mem
  | _ :: _, h, _, .head _ => (bool_of_and_true h).1
  | _ :: _, h, q, .tail _ mem => of_followsb (bool_of_and_true h).2 q mem

/-- A member of a list is at some place in it. -/
theorem memberAt_of_mem {d s : α} : ∀ {l : List α}, s ∈ l → ∃ n, n < l.length ∧ Law.memberAt d l n = s
  | _ :: _, .head _ => ⟨0, Nat.zero_lt_succ _, rfl⟩
  | _ :: _, .tail _ mem => match memberAt_of_mem mem with
    | ⟨n, lt, at_n⟩ => ⟨n + 1, Nat.succ_lt_succ lt, at_n⟩

/-- Some step of a list has the property, told step by step. -/
def anyStep (p : α × α → Bool) : List (α × α) → Bool
  | [] => false
  | q :: l => p q || anyStep p l

theorem anyStep_sound {p : α × α → Bool} :
    ∀ {l : List (α × α)}, anyStep p l = true → ∃ q, q ∈ l ∧ p q = true
  | [], h => Bool.noConfusion h
  | q :: _, h => match ListTests.or_cases h with
    | .inl here => ⟨q, .head _, here⟩
    | .inr there => match anyStep_sound there with
      | ⟨q', mem, holds⟩ => ⟨q', .tail _ mem, holds⟩

end Runs

/-! ## The received order as a run -/

/-- A law runs the received order: its run from 乾 holds the sixty-four in the order received. -/
def RunsOrder (next : Hexagram → Hexagram) : Prop := RunsThrough next order

theorem runsOrder_iff {next : Hexagram → Hexagram} : RunsOrder next ↔ Follows next order :=
  runsThrough_iff (s := allUnbroken) (l := order.tail)

/-- A step of a list, told line by line. -/
def stepb (s t : Hexagram) (l : List Hexagram) : Bool :=
  anyStep (fun q => eqb q.1 s && eqb q.2 t) (steps l)

theorem step_of_stepb {s t : Hexagram} {l : List Hexagram} (h : stepb s t l = true) :
    (s, t) ∈ steps l :=
  match anyStep_sound h with
  | ⟨(s', t'), mem, both'⟩ => by
    cases eq_of_eqb (bool_of_and_true both').1
    cases eq_of_eqb (bool_of_and_true both').2
    exact mem

/-- A law that follows a list takes a listed step. -/
theorem Follows.step {next : Hexagram → Hexagram} {l : List Hexagram} (follows : Follows next l)
    {s t : Hexagram} (h : stepb s t l = true) : next s = t :=
  follows (s, t) (step_of_stepb h)

/-- The member after `s` in a list, the last member going on to `first`, and `first` where `s` is
not in the list. -/
def nextIn (s first : Hexagram) : List Hexagram → Hexagram
  | [] => first
  | [_] => first
  | t :: u :: rest => match eqb s t with
    | true => u
    | false => nextIn s first (u :: rest)

/-- The law taking each member of the received order to the next, and 未濟 to 乾. -/
def orderNext (s : Hexagram) : Hexagram := nextIn s allUnbroken order

/-- The same law run backward: each member to the one before, and 乾 to 未濟. -/
def orderBack (s : Hexagram) : Hexagram := nextIn s weiJi order.reverse

/-- **A law runs the received order.** -/
theorem orderNext_runsOrder : RunsOrder orderNext :=
  runsOrder_iff.mpr fun q mem =>
    eq_of_eqb (of_followsb (good := fun s t => eqb (orderNext s) t) (l := steps order) rfl q mem)

/-- It closes the order: 未濟 goes on to 乾. -/
theorem orderNext_closes : orderNext weiJi = allUnbroken := rfl

theorem orderBack_next (s : Hexagram) : orderBack (orderNext s) = s :=
  eq_of_eqb (every_of_order (p := fun s => eqb (orderBack (orderNext s)) s) rfl s)

theorem orderNext_back (s : Hexagram) : orderNext (orderBack s) = s :=
  eq_of_eqb (every_of_order (p := fun s => eqb (orderNext (orderBack s)) s) rfl s)

/-- **It merges nothing.** -/
theorem orderNext_lossless : Law.Lossless orderNext :=
  Law.lossless_iff.mpr fun x y same => (orderBack_next x).symm.trans ((congrArg orderBack same).trans (orderBack_next y))

set_option maxRecDepth 100000 in
/-- From 乾 it does not come back before the sixty-fourth step. -/
theorem orderNext_first_return :
    ∀ p, 0 < p → p < 64 → (Law.run orderNext allUnbroken).state p ≠ allUnbroken :=
  first_return_of (next := orderNext) (s := allUnbroken) (n := 63) rfl

set_option maxRecDepth 100000 in
/-- **It has one orbit of sixty-four**: from 乾 it first comes back at the sixty-fourth step,
having passed through every configuration. -/
theorem orderNext_one_orbit :
    (Law.run orderNext allUnbroken).state 64 = allUnbroken ∧
      (∀ p, 0 < p → p < 64 → (Law.run orderNext allUnbroken).state p ≠ allUnbroken) ∧
      ∀ s, ∃ n, n < 64 ∧ (Law.run orderNext allUnbroken).state n = s :=
  ⟨(congrArg orderNext (orderNext_runsOrder 63 (Nat.lt_succ_self 63))).trans orderNext_closes,
   orderNext_first_return,
   fun s => match memberAt_of_mem (d := allUnbroken) (mem_order s) with
    | ⟨n, lt, at_n⟩ => ⟨n, lt, (orderNext_runsOrder n lt).trans at_n⟩⟩

/-- **Every law running the received order agrees with it everywhere but at 未濟**: every other
configuration is the start of a step of the order. -/
theorem runsOrder_agrees {next : Hexagram → Hexagram} (runs : RunsOrder next) {s : Hexagram}
    (other : s ≠ weiJi) : next s = orderNext s :=
  match ListTests.or_cases (every_of_order (p := fun s => eqb s weiJi || stepb s (orderNext s) order) rfl s) with
  | .inl last => absurd (eq_of_eqb last) other
  | .inr step => (runsOrder_iff.mp runs).step step

/-- **Of the laws running the received order, exactly the one closing 未濟 to 乾 merges
nothing.** -/
theorem runsOrder_lossless_iff {next : Hexagram → Hexagram} (runs : RunsOrder next) :
    Law.Lossless next ↔ next weiJi = allUnbroken :=
  ⟨fun lossless => match h : eqb (next weiJi) allUnbroken with
    | true => eq_of_eqb h
    | false =>
      have back : orderBack (next weiJi) ≠ weiJi := fun e =>
        ne_of_eqb h ((orderNext_back (next weiJi)).symm.trans
          ((congrArg orderNext e).trans orderNext_closes))
      absurd (Law.lossless_iff.mp lossless _ _ ((runsOrder_agrees runs back).trans (orderNext_back (next weiJi)))) back,
   fun closes => Law.lossless_iff.mpr fun x y same =>
    have agree : ∀ s, next s = orderNext s := fun s => match h : eqb s weiJi with
      | true => by
        cases eq_of_eqb h
        exact closes
      | false => runsOrder_agrees runs (ne_of_eqb h)
    Law.lossless_iff.mp orderNext_lossless x y ((agree x).symm.trans (same.trans (agree y)))⟩

/-! ## What a law running the order reads -/

/-- The line at `k` of the next configuration reads the line at `q`: at some configuration,
changing the line at `q` changes the line at `k` of the next. -/
def Reads (next : Hexagram → Hexagram) (q k : Place) : Prop :=
  ∃ s, (next (flip q s)).line k ≠ (next s).line k

/-- Two steps of a list, the second from the first's start changed at `q`, going on to lines that
differ at `k`, told step by step. -/
def readsb (l : List Hexagram) (q k : Place) : Bool :=
  anyStep (fun st => anyStep (fun st' =>
    eqb st'.1 (flip q st.1) && !same (st'.2.line k) (st.2.line k)) (steps l)) (steps l)

theorem reads_of_readsb {next : Hexagram → Hexagram} {l : List Hexagram} (follows : Follows next l)
    {q k : Place} (h : readsb l q k = true) : Reads next q k :=
  match anyStep_sound h with
  | ⟨st, mem, inner⟩ => match anyStep_sound inner with
    | ⟨st', mem', found⟩ =>
      have changed : st'.1 = flip q st.1 := eq_of_eqb (bool_of_and_true found).1
      ⟨st.1, fun same' => differs_ne (bool_of_and_true found).2
        ((congrArg (fun x => x.line k) ((congrArg next changed).symm.trans (follows st' mem'))).symm.trans
          (same'.trans (congrArg (fun x => x.line k) (follows st mem))))⟩

/-- **A law running the received order reads every line for every line**: changing any one line
of a configuration changes any given line of the next, at some configuration. -/
theorem runsOrder_reads {next : Hexagram → Hexagram} (runs : RunsOrder next) (q k : Place) :
    Reads next q k :=
  reads_of_readsb (runsOrder_iff.mp runs) (by cases q <;> cases k <;> rfl)

/-- **So no reading blind to the line at one place fixes any line of the next configuration**, in
the sense of `Learning.Lumped`: the next line at every place needs all six lines. -/
theorem runsOrder_blind_not_lumped {next : Hexagram → Hexagram} (runs : RunsOrder next)
    {K : Type u} {π : Hexagram → K} {q : Place} (blind : ∀ s, π (flip q s) = π s) (k : Place) :
    ¬ Learning.Lumped π (fun s => (next s).line k) :=
  fun lumped => match runsOrder_reads runs q k with
    | ⟨s, differs⟩ => differs (lumped _ _ (blind s))

/-- A three-cell rule on a ring of six: each line becomes `ρ` of the line below it, itself and the
line above it, the bottom and top lines neighbours. -/
def ringRule (ρ : Bool → Bool → Bool → Bool) : Hexagram → Hexagram
  | ⟨a, b, c, d, e, f⟩ => ⟨ρ f a b, ρ a b c, ρ b c d, ρ c d e, ρ d e f, ρ e f a⟩

/-- The same with the wrap read turned: below the bottom line stands the top line turned, and above
the top line the bottom line turned. -/
def twistedRule (ρ : Bool → Bool → Bool → Bool) : Hexagram → Hexagram
  | ⟨a, b, c, d, e, f⟩ => ⟨ρ (!f) a b, ρ a b c, ρ b c d, ρ c d e, ρ d e f, ρ e f (!a)⟩

/-- The law of waxing and waning is the twisted rule that takes the line below. -/
theorem waxWane_twisted : ∀ s, waxWane s = twistedRule (fun below _ _ => below) s
  | ⟨_, _, _, _, _, _⟩ => rfl

/-- **No three-cell rule on a ring runs the received order**: line 3 of the next reads only
lines 2 to 4. -/
theorem ringRule_not_runsOrder (ρ : Bool → Bool → Bool → Bool) : ¬ RunsOrder (ringRule ρ) :=
  fun runs => match runsOrder_reads runs .p1 .p3 with
    | ⟨⟨_, _, _, _, _, _⟩, differs⟩ => differs rfl

/-- With the wrap turned, line 3 of the next still does not read line 1. -/
theorem twistedRule_p3 (ρ : Bool → Bool → Bool → Bool) :
    ∀ s, (twistedRule ρ (flip .p1 s)).line .p3 = (twistedRule ρ s).line .p3
  | ⟨_, _, _, _, _, _⟩ => rfl

/-- **Nor with the wrap turned.** -/
theorem twistedRule_not_runsOrder (ρ : Bool → Bool → Bool → Bool) : ¬ RunsOrder (twistedRule ρ) :=
  fun runs => match runsOrder_reads runs .p1 .p3 with
    | ⟨s, differs⟩ => differs (twistedRule_p3 ρ s)

/-- **So the law of waxing and waning does not run the received order.** -/
theorem waxWane_not_runsOrder : ¬ RunsOrder waxWane :=
  fun runs => match runsOrder_reads runs .p1 .p3 with
    | ⟨s, differs⟩ => differs
        ((congrArg (fun x => x.line .p3) (waxWane_twisted (flip .p1 s))).trans
          ((twistedRule_p3 _ s).trans (congrArg (fun x => x.line .p3) (waxWane_twisted s)).symm))

/-- 剝 (23). -/
def bo : Hexagram := number 23

/-- 復 (24). -/
def fu : Hexagram := number 24

/-- **剝窮上反下**: the shift on a ring of six read straight, each line one place up and the top
line to the bottom unturned, takes 剝 to 復 in one step, as turning over does; the law of waxing
and waning turns the top line as it enters, and takes 剝 to 坤 and then to 復. -/
theorem bo_fu :
    (Law.run (ringRule fun below _ _ => below) bo).state 1 = fu ∧ reverse bo = fu ∧
      (Law.run waxWane bo).state 1 = allBroken ∧ (Law.run waxWane bo).state 2 = fu :=
  ⟨rfl, rfl, rfl, rfl⟩

/-! ## What a law running the order keeps -/

/-- **A law commuting with an exchange that takes a member of a list to its image goes back.**
Where a law follows a list and commutes with an exchange `σ`, and the list steps from `s` to `σ s`,
its next step goes back to `s` (`Law.Commutes.paired_halfway` at the first step). -/
theorem Follows.back {α : Type u} {next σ : α → α} {l : List α} (follows : Follows next l)
    (commutes : Law.Commutes next σ) (exchange : ∀ x, σ (σ x) = x) {s t : α}
    (pair : (s, σ s) ∈ steps l) (onward : (σ s, t) ∈ steps l) : t = s :=
  (follows _ onward).symm.trans
    ((congrArg next (follows _ pair).symm).trans
      (Law.Commutes.paired_halfway commutes exchange (k := 1) (follows _ pair)).2)

/-- A list goes on from a pair by a symmetry to another configuration, told line by line. -/
theorem follows_not_commutes {next : Hexagram → Hexagram} {l : List Hexagram} (follows : Follows next l)
    (g : Symmetry) {s t : Hexagram} (pair : stepb s (g.act s) l = true)
    (onward : stepb (g.act s) t l = true) (other : eqb t s = false) : ¬ Law.Commutes next g.act :=
  fun commutes => ne_of_eqb other
    (follows.back commutes (Symmetry.act_self g) (step_of_stepb pair) (step_of_stepb onward))

/-- **No law running the received order commutes with 錯, 綜 or both**: each pair of the order is
a step of one of them, and a law commuting with it would go back. -/
theorem runsOrder_not_commutes {next : Hexagram → Hexagram} (runs : RunsOrder next) :
    ∀ g : Symmetry, g ≠ .keep → ¬ Law.Commutes next g.act
  | .keep, other => absurd rfl other
  | .change, _ => follows_not_commutes (runsOrder_iff.mp runs) .change (s := allUnbroken)
      (t := zhun) rfl rfl rfl
  | .turn, _ => follows_not_commutes (runsOrder_iff.mp runs) .turn (s := zhun) (t := xu) rfl rfl rfl
  | .both, _ => follows_not_commutes (runsOrder_iff.mp runs) .both (s := allUnbroken)
      (t := zhun) rfl rfl rfl

/-- A line turned where the mask is unbroken. -/
def turnedBy : Bool → Bool → Bool
  | b, true => !b
  | b, false => b

theorem turnedBy_not : ∀ b m : Bool, turnedBy (!b) m = !turnedBy b m
  | _, true => rfl
  | _, false => rfl

/-- The places read through a map of places, and the lines turned where a mask is unbroken: line
`p` of the result is the line at `σ p`, turned where the mask is unbroken at `p`. -/
def rearrange (σ : Place → Place) (mask : Hexagram) (s : Hexagram) : Hexagram :=
  ofLines fun p => turnedBy (s.line (σ p)) (mask.line p)

/-- **Every rearrangement of places with a mask commutes with the complement.** -/
theorem rearrange_complement (σ : Place → Place) (mask : Hexagram) :
    Law.Commutes (rearrange σ mask) complement :=
  fun s => ext_lines fun p =>
    ((ofLines_line _ p).trans
      ((congrArg (fun b => turnedBy b (mask.line p)) (line_complement s (σ p))).trans
        (turnedBy_not _ _))).trans
      ((congrArg (fun b => !b) (ofLines_line _ p)).symm.trans
        (line_complement (rearrange σ mask s) p).symm)

/-- **So no rearrangement of places with a mask runs the received order.** -/
theorem rearrange_not_runsOrder (σ : Place → Place) (mask : Hexagram) :
    ¬ RunsOrder (rearrange σ mask) :=
  fun runs => runsOrder_not_commutes runs .change (fun e => nomatch e) (rearrange_complement σ mask)

/-- 訟 (6). -/
def song : Hexagram := number 6

/-- 師 (7). -/
def shi : Hexagram := number 7

/-- **A law running the received order goes alike neither across the pairs of complements nor
across the parity of the count of unbroken lines**, the lumpings the law of waxing and waning goes
alike across: 乾 and 坤 are one pair and go on to 坤 and 屯; 乾 and 訟 have an even count, and go
on to 坤, even, and 師, odd. -/
theorem runsOrder_not_lumped {next : Hexagram → Hexagram} (runs : RunsOrder next) :
    ¬ Learning.Lumped pairOf (fun s => pairOf (next s)) ∧
      ¬ Learning.Lumped (fun s => Nat.beq (yang s % 2) 1) (fun s => Nat.beq (yang (next s) % 2) 1) :=
  have follows := runsOrder_iff.mp runs
  ⟨fun lumped => ne_of_eqb (s := pairOf allBroken) (t := pairOf zhun) rfl
      ((congrArg pairOf (follows.step (s := allUnbroken) (t := allBroken) rfl)).symm.trans
        ((lumped allUnbroken allBroken rfl).trans
          (congrArg pairOf (follows.step (s := allBroken) (t := zhun) rfl)))),
   fun lumped => Bool.noConfusion
      ((congrArg (fun x => Nat.beq (yang x % 2) 1) (follows.step (s := allUnbroken) (t := allBroken) rfl)).symm.trans
        ((lumped allUnbroken song rfl).trans
          (congrArg (fun x => Nat.beq (yang x % 2) 1) (follows.step (s := song) (t := shi) rfl))))⟩

/-! ## The exchange of two lines (卦變) -/

/-- The number of a place, from 1 at the bottom to 6 at the top. -/
def Place.index : Place → Nat
  | .p1 => 1
  | .p2 => 2
  | .p3 => 3
  | .p4 => 4
  | .p5 => 5
  | .p6 => 6

/-- Two places told apart by their numbers. -/
def placeEqb (p q : Place) : Bool := Nat.beq p.index q.index

/-- The place `p`, with the places `i` and `j` exchanged. -/
def Place.exchange (i j p : Place) : Place :=
  match placeEqb p i, placeEqb p j with
  | true, _ => j
  | false, true => i
  | false, false => p

/-- **The exchange of two lines** (卦變): the lines at `i` and `j` change places. -/
def swap (i j : Place) (s : Hexagram) : Hexagram := ofLines fun p => s.line (Place.exchange i j p)

/-- **Exchanging two lines keeps the count of unbroken lines.** -/
theorem yang_swap (i j : Place) (s : Hexagram) : yang (swap i j s) = yang s :=
  Nat.eq_of_beq_eq_true
    (every_of_order (p := fun s => Nat.beq (yang (swap i j s)) (yang s)) (by cases i <;> cases j <;> rfl) s)

/-- The exchange of a line of the lower trigram with a line of the upper: the line at height `h`
below with the line at height `h'` above. -/
def across (h h' : Height) : Hexagram → Hexagram := swap (place .lower h) (place .upper h')

/-- 泰 (11). -/
def tai : Hexagram := number 11

/-- 否 (12). -/
def pi : Hexagram := number 12

/-- 損 (41). -/
def sun : Hexagram := number 41

/-- 益 (42). -/
def yi : Hexagram := number 42

/-- The count of unbroken lines of a trigram of a hexagram. -/
def halfYang (s : Hexagram) : Half → Nat
  | .lower => s.l1.toNat + s.l2.toNat + s.l3.toNat
  | .upper => s.l4.toNat + s.l5.toNat + s.l6.toNat

/-- The counts of the two trigrams make the count of the hexagram. -/
theorem halfYang_total (s : Hexagram) : halfYang s .lower + halfYang s .upper = yang s :=
  Nat.eq_of_beq_eq_true
    (every_of_order (p := fun s => Nat.beq (halfYang s .lower + halfYang s .upper) (yang s)) rfl s)

/-- One unbroken line passed from the lower trigram to the upper: the lower takes it from itself
and gives it to the upper. -/
def passUp : Exchange Half :=
  ⟨[.lower], fun _ c => match c with
    | .lower => 1
    | .upper => 0, fun _ c => match c with
    | .lower => 0
    | .upper => 1⟩

/-- One unbroken line passed from the upper trigram to the lower. -/
def passDown : Exchange Half :=
  ⟨[.upper], fun _ c => match c with
    | .lower => 0
    | .upper => 1, fun _ c => match c with
    | .lower => 1
    | .upper => 0⟩

/-- Nothing passed. -/
def passNone : Exchange Half := ⟨[], fun _ _ => 0, fun _ _ => 0⟩

/-- What exchanging the line at height `h` below with the line at height `h'` above passes between
the trigrams: an unbroken line up where the line below is unbroken and the line above broken, down
in the other case, and nothing where the two agree. -/
def passing (h h' : Height) (s : Hexagram) : Exchange Half :=
  match s.line (place .lower h), s.line (place .upper h') with
  | true, false => passUp
  | false, true => passDown
  | true, true => passNone
  | false, false => passNone

/-- **An exchange across the trigrams is a step of the law of exchange between them**: each
trigram's count after it, with what is taken from it, is its count before, with what is given to
it. -/
theorem across_exchange (h h' : Height) (s : Hexagram) :
    (exchange Half).step (halfYang s) (passing h h' s) (halfYang (across h h' s)) :=
  fun c => Nat.eq_of_beq_eq_true
    (every_of_order (p := fun s => Nat.beq (halfYang (across h h' s) c + (passing h h' s).taken c)
      (halfYang s c + (passing h h' s).given c)) (by cases h <;> cases h' <;> cases c <;> rfl) s)

/-- The exchanges across the trigrams as a process: a step exchanges the lines at the two heights
its move names. -/
def exchanges : Process Hexagram (Height × Height) := ⟨fun s a t => t = across a.1 a.2 s⟩

/-- **損, 益, 恒 and 咸 are 泰 and 否 with a lower and an upper line exchanged.** 損 is 泰 with
lines 3 and 6 exchanged, an unbroken line passing up (損下益上); 益 is 否 with lines 1 and 4
exchanged, an unbroken line passing down (損上益下); 恒 is 泰 with lines 1 and 4 exchanged, the
unbroken line going up and the broken down (剛上而柔下); 咸 is 否 with lines 3 and 6 exchanged,
the broken line going up and the unbroken down (柔上而剛下). -/
theorem named_exchanges :
    (exchanges.step tai (.high, .high) sun ∧ passing .high .high tai = passUp) ∧
      (exchanges.step pi (.low, .low) yi ∧ passing .low .low pi = passDown) ∧
      (exchanges.step tai (.low, .low) heng ∧ passing .low .low tai = passUp) ∧
      (exchanges.step pi (.high, .high) xian ∧ passing .high .high pi = passDown) :=
  ⟨⟨rfl, rfl⟩, ⟨rfl, rfl⟩, ⟨rfl, rfl⟩, ⟨rfl, rfl⟩⟩

/-- The nine configurations one exchange across the trigrams from `s`. -/
def acrossFrom (s : Hexagram) : List Hexagram :=
  [across .low .low s, across .low .mid s, across .low .high s, across .mid .low s,
    across .mid .mid s, across .mid .high s, across .high .low s, across .high .mid s,
    across .high .high s]

theorem mem_acrossFrom {s t : Hexagram} (mem : t ∈ acrossFrom s) : ∃ h h', t = across h h' s := by
  unfold acrossFrom at mem
  exact match t, mem with
  | _, .head _ => ⟨.low, .low, rfl⟩
  | _, .tail _ (.head _) => ⟨.low, .mid, rfl⟩
  | _, .tail _ (.tail _ (.head _)) => ⟨.low, .high, rfl⟩
  | _, .tail _ (.tail _ (.tail _ (.head _))) => ⟨.mid, .low, rfl⟩
  | _, .tail _ (.tail _ (.tail _ (.tail _ (.head _)))) => ⟨.mid, .mid, rfl⟩
  | _, .tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.head _))))) => ⟨.mid, .high, rfl⟩
  | _, .tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.head _)))))) => ⟨.high, .low, rfl⟩
  | _, .tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.head _))))))) =>
    ⟨.high, .mid, rfl⟩
  | _, .tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.head _)))))))) =>
    ⟨.high, .high, rfl⟩
  | _, .tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ mem)))))))) =>
    nomatch mem

theorem beq_of_eq {n m : Nat} (same : n = m) : Nat.beq n m = true :=
  same ▸ beq_self n

/-- **The twenty configurations with three unbroken lines are 泰, 否 and those one exchange across
the trigrams from them**: the configurations of three and three that the 卦變 of 虞翻 and later
commentators derives from 泰 and 否. -/
theorem three_iff (s : Hexagram) :
    yang s = 3 ↔ s = tai ∨ s = pi ∨ ∃ h h', s = across h h' tai ∨ s = across h h' pi :=
  ⟨fun three =>
    match ListTests.or_cases (every_of_order (p := fun s => !Nat.beq (yang s) 3 ||
        (eqb s tai || eqb s pi || memb s (acrossFrom tai) || memb s (acrossFrom pi))) rfl s) with
    | .inl not_three => absurd (beq_of_eq three) (fun e => Bool.noConfusion ((ListTests.false_of_not not_three).symm.trans e))
    | .inr found => match ListTests.or_cases found with
      | .inr from_pi => match mem_acrossFrom (mem_of_memb from_pi) with
        | ⟨h, h', e⟩ => .inr (.inr ⟨h, h', .inr e⟩)
      | .inl rest => match ListTests.or_cases rest with
        | .inr from_tai => match mem_acrossFrom (mem_of_memb from_tai) with
          | ⟨h, h', e⟩ => .inr (.inr ⟨h, h', .inl e⟩)
        | .inl ends => match ListTests.or_cases ends with
          | .inl e => .inl (eq_of_eqb e)
          | .inr e => .inr (.inl (eq_of_eqb e)),
   fun
    | .inl e => e ▸ rfl
    | .inr (.inl e) => e ▸ rfl
    | .inr (.inr ⟨_, _, .inl e⟩) => e ▸ yang_swap _ _ tai
    | .inr (.inr ⟨_, _, .inr e⟩) => e ▸ yang_swap _ _ pi⟩

/-- **Twenty in all, eighteen besides 泰 and 否, no two alike**, counted over the received order. -/
theorem three_census :
    (order.filter fun s => Nat.beq (yang s) 3).length = 20 ∧
      (tai :: pi :: (acrossFrom tai ++ acrossFrom pi)).Nodup :=
  ⟨rfl, nodup_of_distinctb rfl⟩

/-- **Every course of exchanges keeps the count of unbroken lines.** -/
theorem exchanges_keep (v : Nat) : Invariant exchanges (fun s => yang s = v) :=
  fun s _ _ step held => (congrArg yang step).trans ((yang_swap _ _ s).trans held)

/-- **Along every course of exchanges the counts of the two trigrams add to the count at the
start.** -/
theorem exchanges_run_total (r : Run exchanges) (n : Nat) :
    halfYang (r.state n) .lower + halfYang (r.state n) .upper = yang (r.state 0) :=
  (halfYang_total _).trans ((exchanges_keep (yang (r.state 0))).run r rfl n)

/-- **Every course of exchanges from 泰 or 否 stays among the twenty with three unbroken lines**:
at every step it is 泰, 否 or one exchange across from one of them. -/
theorem exchanges_from_tai_pi (r : Run exchanges) (start : r.state 0 = tai ∨ r.state 0 = pi)
    (n : Nat) :
    r.state n = tai ∨ r.state n = pi ∨ ∃ h h', r.state n = across h h' tai ∨ r.state n = across h h' pi :=
  (three_iff _).mp ((exchanges_keep 3).run r (match start with
    | .inl e => e ▸ rfl
    | .inr e => e ▸ rfl) n)

/-- **Along every course of exchanges the counts of the two trigrams run by the law of
exchange**, its moves what each exchange passes. -/
def exchangesRun (r : Run exchanges) : Run (exchange Half) :=
  ⟨fun n => halfYang (r.state n), fun n => passing (r.act n).1 (r.act n).2 (r.state n),
   fun n => Eq.subst (motive := fun x => (exchange Half).step (halfYang (r.state n))
      (passing (r.act n).1 (r.act n).2 (r.state n)) (halfYang x)) (r.step n).symm
      (across_exchange _ _ _)⟩

/-- A course of exchanges read as a world: its relata the two trigrams, each standing at its count
of unbroken lines, what each exchange passes the flow. -/
def exchangeWorld (r : Run exchanges) : World :=
  World.of Half (⟨fun t => (passing (r.act t).1 (r.act t).2 (r.state t)).present,
      fun t => (passing (r.act t).1 (r.act t).2 (r.state t)).take,
      fun t => (passing (r.act t).1 (r.act t).2 (r.state t)).give⟩) (⟨fun t => halfYang (r.state t), fun _ _ => True, fun _ _ _ => False, fun _ _ _ => 0,
      fun _ _ _ => True⟩)

/-- **It balances**, by `World.balances_iff_exchange`. -/
theorem exchangeWorld_balances (r : Run exchanges) :
    (exchangeWorld r).flow.Balances (exchangeWorld r).web :=
  (exchangeWorld r).balances_iff_exchange.mpr (exchangesRun r).step

/-- **So along a course of exchanges every rise of a trigram's count is given to and every fall
taken from** (`Flow.Balances.rise_given`, `Flow.Balances.fall_taken`): what one trigram gains, the
other gives. -/
theorem exchangeWorld_rise_fall (r : Run exchanges) (t : Nat) (c : Half) :
    ((exchangeWorld r).web.Rises t c → 0 < (exchangeWorld r).flow.given t c) ∧
      ((exchangeWorld r).web.Falls t c → 0 < (exchangeWorld r).flow.taken t c) :=
  ⟨fun rises => (exchangeWorld_balances r).rise_given rises,
   fun falls => (exchangeWorld_balances r).fall_taken falls⟩

/-! ## Parity -/

/-- The parity of the count of unbroken lines: `true` where the count is odd. -/
def yangOdd (s : Hexagram) : Bool := Nat.beq (yang s % 2) 1

/-- **Every step of the law of waxing and waning turns the parity.** -/
theorem yangOdd_waxWane (s : Hexagram) : yangOdd (waxWane s) = !yangOdd s :=
  same_eq (every_of_order (p := fun s => same (yangOdd (waxWane s)) (!yangOdd s)) rfl s)

/-- **So does every change of a line.** -/
theorem yangOdd_flip (k : Place) (s : Hexagram) : yangOdd (flip k s) = !yangOdd s :=
  same_eq (every_of_order (p := fun s => same (yangOdd (flip k s)) (!yangOdd s)) (by cases k <;> rfl) s)

/-- The complement keeps it: six lines turn. -/
theorem yangOdd_complement (s : Hexagram) : yangOdd (complement s) = yangOdd s :=
  same_eq (every_of_order (p := fun s => same (yangOdd (complement s)) (yangOdd s)) rfl s)

/-- **The parity is a lumping the law of waxing and waning goes alike across**, beside the count,
which is not (`yang_not_goAlike`). -/
theorem yangOdd_lumped : Learning.Lumped yangOdd (fun s => yangOdd (waxWane s)) :=
  fun s t same' => (yangOdd_waxWane s).trans ((congrArg (fun b => !b) same').trans (yangOdd_waxWane t).symm)

theorem yangOdd_goAlike : GoAlike (Law.process waxWane) yangOdd :=
  Learning.goAlike_iff_lumped.mpr yangOdd_lumped

/-- **And the change of lines goes alike across it**, move by move. -/
theorem yangOdd_goAlike_changes : GoAlike changes yangOdd :=
  fun s s' k _ _ same' step step' => (congrArg yangOdd step).trans ((yangOdd_flip k s).trans
    ((congrArg (fun b => !b) same').trans ((yangOdd_flip k s').symm.trans (congrArg yangOdd step').symm)))

/-- **Along every run of the law of waxing and waning the parity turns at every step.** -/
theorem run_yangOdd (s : Hexagram) (n : Nat) :
    yangOdd ((Law.run waxWane s).state (n + 1)) = !yangOdd ((Law.run waxWane s).state n) :=
  yangOdd_waxWane _

/-- **And along every course of changes.** -/
theorem changes_run_yangOdd (r : Run changes) (n : Nat) :
    yangOdd (r.state (n + 1)) = !yangOdd (r.state n) :=
  (congrArg yangOdd (r.step n)).trans (yangOdd_flip _ _)

/-- **The count of lines in phase has the other parity** (`phaseCount_parity` read in the count of
unbroken lines). -/
theorem phaseCount_yangOdd (s : Hexagram) : Nat.beq (phaseCount s % 2) 1 = !yangOdd s :=
  same_eq (every_of_order (p := fun s => same (Nat.beq (phaseCount s % 2) 1) (!yangOdd s)) rfl s)

/-- 觀 (20). -/
def guan : Hexagram := number 20

/-- **The nuclear law does not go alike across the parity**: 坤 and 觀 have an even count, and go
on to 坤, even, and 剝, odd. -/
theorem nuclear_yangOdd_not_lumped : ¬ Learning.Lumped yangOdd (fun s => yangOdd (nuclear s)) :=
  fun lumped => Bool.noConfusion (lumped allBroken guan rfl)

theorem nuclear_yangOdd_not_goAlike : ¬ GoAlike (Law.process nuclear) yangOdd :=
  fun alike => nuclear_yangOdd_not_lumped (Learning.goAlike_iff_lumped.mp alike)

/-- The count of unbroken lines of three lines from the bottom. -/
def count3 : Bool × Bool × Bool → Nat
  | (a, b, c) => a.toNat + b.toNat + c.toNat

/-- One of three lines changed at a height. -/
def flip3 : Height → Bool × Bool × Bool → Bool × Bool × Bool
  | .low, (a, b, c) => (!a, b, c)
  | .mid, (a, b, c) => (a, !b, c)
  | .high, (a, b, c) => (a, b, !c)

/-- The trigram of a half of a hexagram. -/
def trigramOf (s : Hexagram) : Half → Bool × Bool × Bool
  | .lower => (s.l1, s.l2, s.l3)
  | .upper => (s.l4, s.l5, s.l6)

theorem halfYang_trigram (s : Hexagram) : ∀ c, halfYang s c = count3 (trigramOf s c)
  | .lower => rfl
  | .upper => rfl

/-- The count of strokes of three lines, an unbroken line one stroke and a broken line two. -/
def strokes3 : Bool × Bool × Bool → Nat
  | (a, b, c) => (if a then 1 else 2) + (if b then 1 else 2) + (if c then 1 else 2)

/-- **陽卦奇，陰卦偶**: three lines have an odd count of unbroken lines exactly where they are all
unbroken (乾) or all broken with one line changed (震, 坎, 艮); an even count exactly where they
are all broken (坤) or all unbroken with one line changed (巽, 離, 兌). The strokes and the
unbroken lines add to six, so counting strokes gives the same parity. -/
theorem odd3_iff : ∀ x : Bool × Bool × Bool,
    (Nat.beq (count3 x % 2) 1 = true ↔ x = (true, true, true) ∨ ∃ h, x = flip3 h (false, false, false)) ∧
      (Nat.beq (count3 x % 2) 1 = false ↔
        x = (false, false, false) ∨ ∃ h, x = flip3 h (true, true, true)) ∧
      strokes3 x + count3 x = 6
  | (true, true, true) => ⟨⟨fun _ => .inl rfl, fun _ => rfl⟩, ⟨fun h => Bool.noConfusion h,
      fun | .inl e => nomatch e | .inr ⟨.low, e⟩ => nomatch e | .inr ⟨.mid, e⟩ => nomatch e
          | .inr ⟨.high, e⟩ => nomatch e⟩, rfl⟩
  | (true, false, false) => ⟨⟨fun _ => .inr ⟨.low, rfl⟩, fun _ => rfl⟩, ⟨fun h => Bool.noConfusion h,
      fun | .inl e => nomatch e | .inr ⟨.low, e⟩ => nomatch e | .inr ⟨.mid, e⟩ => nomatch e
          | .inr ⟨.high, e⟩ => nomatch e⟩, rfl⟩
  | (false, true, false) => ⟨⟨fun _ => .inr ⟨.mid, rfl⟩, fun _ => rfl⟩, ⟨fun h => Bool.noConfusion h,
      fun | .inl e => nomatch e | .inr ⟨.low, e⟩ => nomatch e | .inr ⟨.mid, e⟩ => nomatch e
          | .inr ⟨.high, e⟩ => nomatch e⟩, rfl⟩
  | (false, false, true) => ⟨⟨fun _ => .inr ⟨.high, rfl⟩, fun _ => rfl⟩, ⟨fun h => Bool.noConfusion h,
      fun | .inl e => nomatch e | .inr ⟨.low, e⟩ => nomatch e | .inr ⟨.mid, e⟩ => nomatch e
          | .inr ⟨.high, e⟩ => nomatch e⟩, rfl⟩
  | (false, false, false) => ⟨⟨fun h => Bool.noConfusion h,
      fun | .inl e => nomatch e | .inr ⟨.low, e⟩ => nomatch e | .inr ⟨.mid, e⟩ => nomatch e
          | .inr ⟨.high, e⟩ => nomatch e⟩, ⟨fun _ => .inl rfl, fun _ => rfl⟩, rfl⟩
  | (false, true, true) => ⟨⟨fun h => Bool.noConfusion h,
      fun | .inl e => nomatch e | .inr ⟨.low, e⟩ => nomatch e | .inr ⟨.mid, e⟩ => nomatch e
          | .inr ⟨.high, e⟩ => nomatch e⟩, ⟨fun _ => .inr ⟨.low, rfl⟩, fun _ => rfl⟩, rfl⟩
  | (true, false, true) => ⟨⟨fun h => Bool.noConfusion h,
      fun | .inl e => nomatch e | .inr ⟨.low, e⟩ => nomatch e | .inr ⟨.mid, e⟩ => nomatch e
          | .inr ⟨.high, e⟩ => nomatch e⟩, ⟨fun _ => .inr ⟨.mid, rfl⟩, fun _ => rfl⟩, rfl⟩
  | (true, true, false) => ⟨⟨fun h => Bool.noConfusion h,
      fun | .inl e => nomatch e | .inr ⟨.low, e⟩ => nomatch e | .inr ⟨.mid, e⟩ => nomatch e
          | .inr ⟨.high, e⟩ => nomatch e⟩, ⟨fun _ => .inr ⟨.high, rfl⟩, fun _ => rfl⟩, rfl⟩

/-- The parity of the count of unbroken lines of a trigram: `true` where it is odd. -/
def trigramOdd (s : Hexagram) (c : Half) : Bool := Nat.beq (halfYang s c % 2) 1

/-- The other trigram. -/
def Half.other : Half → Half
  | .lower => .upper
  | .upper => .lower

/-- **Changing a line turns the parity of its trigram and keeps the other's.** -/
theorem trigramOdd_flip (c : Half) (h : Height) (s : Hexagram) :
    trigramOdd (flip (place c h) s) c = !trigramOdd s c ∧
      trigramOdd (flip (place c h) s) c.other = trigramOdd s c.other :=
  ⟨same_eq (every_of_order (p := fun s => same (trigramOdd (flip (place c h) s) c) (!trigramOdd s c))
      (by cases c <;> cases h <;> rfl) s),
   same_eq (every_of_order (p := fun s => same (trigramOdd (flip (place c h) s) c.other) (trigramOdd s c.other))
      (by cases c <;> cases h <;> rfl) s)⟩

/-- **Along every course of changes a change of a line makes its trigram one of 乾, 震, 坎, 艮
(陽卦) exactly where it was one of 坤, 巽, 離, 兌 (陰卦)**, and keeps the class of the other. -/
theorem changes_run_trigram (r : Run changes) (n : Nat) (c : Half) (h : Height)
    (at_place : r.act n = place c h) :
    (trigramOdd (r.state (n + 1)) c = true ↔
        trigramOf (r.state n) c = (false, false, false) ∨
          ∃ h', trigramOf (r.state n) c = flip3 h' (true, true, true)) ∧
      trigramOdd (r.state (n + 1)) c.other = trigramOdd (r.state n) c.other :=
  have e : r.state (n + 1) = flip (place c h) (r.state n) :=
    (r.step n).trans (congrArg (fun k => flip k (r.state n)) at_place)
  have turns : trigramOdd (r.state (n + 1)) c = !trigramOdd (r.state n) c :=
    (congrArg (fun t => trigramOdd t c) e).trans (trigramOdd_flip c h (r.state n)).1
  have counted : trigramOdd (r.state n) c = Nat.beq (count3 (trigramOf (r.state n) c) % 2) 1 :=
    congrArg (fun m => Nat.beq (m % 2) 1) (halfYang_trigram (r.state n) c)
  ⟨⟨fun odd => (odd3_iff _).2.1.mp (counted.symm.trans (ListTests.false_of_not (turns.symm.trans odd))),
    fun is => turns.trans (congrArg (fun b => !b) (counted.trans ((odd3_iff _).2.1.mpr is)))⟩,
   (congrArg (fun t => trigramOdd t c.other) e).trans (trigramOdd_flip c h (r.state n)).2⟩

/-! ## The 雜卦: the same pairs, another order -/

/-- The sixty-four in the order of the 雜卦, each by its number in the received order. -/
def zaguaNumbers : List Nat :=
  [1, 2, 8, 7, 19, 20, 3, 4, 51, 52, 41, 42, 26, 25, 45, 46, 15, 16, 21, 22, 58, 57, 17, 18,
    23, 24, 35, 36, 48, 47, 31, 32, 59, 60, 40, 39, 38, 37, 12, 11, 34, 33, 14, 13, 49, 50, 62, 61,
    55, 56, 30, 29, 9, 10, 5, 6, 28, 44, 53, 27, 63, 54, 64, 43]

/-- The 雜卦's sequence of configurations. -/
def zagua : List Hexagram := zaguaNumbers.map number

/-- **The 雜卦 lists every configuration once.** -/
theorem zagua_every : zagua.length = 64 ∧ zagua.Nodup ∧ ∀ s, s ∈ zagua :=
  ⟨rfl, nodup_of_distinctb rfl, fun s => by
    cases s with
    | mk a b c d e f =>
      cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> cases f <;>
        exact mem_of_memb rfl⟩

/-- Choosing the partner: changed in every line where turning over keeps a configuration,
turned over where it does not. -/
def partnerBy (s : Hexagram) : Bool → Hexagram
  | true => complement s
  | false => reverse s

/-- The configuration paired with `s`: `s` turned over, or, where turning over keeps it, changed in
every line (非覆即變). -/
def partner (s : Hexagram) : Hexagram := partnerBy s (eqb (reverse s) s)

/-- **Two configurations are paired as the received order pairs them exactly where the second is
the partner of the first.** -/
theorem paired_iff_partner {s t : Hexagram} : Paired s t ↔ t = partner s :=
  match h : eqb (reverse s) s with
  | true =>
    have kept : reverse s = s := eq_of_eqb h
    have is : partner s = complement s := congrArg (partnerBy s) h
    ⟨(fun | .inl ⟨other, _⟩ => absurd kept other
          | .inr ⟨_, e⟩ => e.trans is.symm),
     fun e => .inr ⟨kept, e.trans is⟩⟩
  | false =>
    have other : reverse s ≠ s := ne_of_eqb h
    have is : partner s = reverse s := congrArg (partnerBy s) h
    ⟨(fun | .inl ⟨_, e⟩ => e.trans is.symm
          | .inr ⟨kept, _⟩ => absurd kept other),
     fun e => .inl ⟨other, e.trans is⟩⟩

/-- **Pairing is mutual**: the partner of the partner is the configuration. -/
theorem partner_partner (s : Hexagram) : partner (partner s) = s :=
  eq_of_eqb (every_of_order (p := fun s => eqb (partner (partner s)) s) rfl s)

/-- **The law taking each configuration to its partner pairs every run**: two steps on, every run
of it is back. -/
theorem partner_run (s : Hexagram) (n : Nat) :
    (Law.run partner s).state (n + 2) = (Law.run partner s).state n :=
  partner_partner _

/-- Every pair of a list of pairs is a configuration and its partner, told pair by pair. -/
theorem partners_of_check {l : List (Hexagram × Hexagram)}
    (h : followsb (fun s t => eqb t (partner s)) l = true) : ∀ q, q ∈ l → q.2 = partner q.1 :=
  fun q mem => eq_of_eqb (of_followsb h q mem)

/-- **The received order pairs every configuration with its partner, side by side.** -/
theorem order_partners : ∀ q, q ∈ pairs order → q.2 = partner q.1 :=
  partners_of_check rfl

/-- **The 雜卦 pairs the same: its first fifty-six are twenty-eight pairs side by side, each a
configuration and its partner**, as `order_paired` has them (`paired_iff_partner`). -/
theorem zagua_partners : ∀ q, q ∈ pairs (zagua.take 56) → q.2 = partner q.1 :=
  partners_of_check rfl

/-- **Its last eight hold the remaining four pairs interleaved**: 大過 姤 漸 頤 既濟 歸妹 未濟 夬, the
partner of each among them, and no two side by side partners. -/
theorem zagua_last_eight :
    zagua.drop 56 = [28, 44, 53, 27, 63, 54, 64, 43].map number ∧
      (∀ s, s ∈ zagua.drop 56 → partner s ∈ zagua.drop 56) ∧
      ∀ q, q ∈ steps (zagua.drop 56) → q.2 ≠ partner q.1 :=
  ⟨rfl, fun s mem => mem_of_memb
      (of_allOf (p := fun s => memb (partner s) (zagua.drop 56)) rfl s mem),
   fun q mem => ne_of_eqb (ListTests.false_of_not
      (of_followsb (good := fun s t => !eqb t (partner s)) (l := steps (zagua.drop 56)) rfl q mem))⟩

/-- **The 雜卦 too is the run of no law commuting with 錯, 綜 or both**: it begins 乾, 坤, 比, 師,
臨. -/
theorem zagua_not_commutes {next : Hexagram → Hexagram} (runs : RunsThrough next zagua) :
    ∀ g : Symmetry, g ≠ .keep → ¬ Law.Commutes next g.act :=
  have follows : Follows next zagua := runsThrough_iff (s := allUnbroken) (l := zagua.tail) |>.mp runs
  fun
  | .keep, other => absurd rfl other
  | .change, _ => follows_not_commutes follows .change (s := allUnbroken) (t := number 8) rfl rfl rfl
  | .turn, _ => follows_not_commutes follows .turn (s := number 8) (t := number 19) rfl rfl rfl
  | .both, _ => follows_not_commutes follows .both (s := allUnbroken) (t := number 8) rfl rfl rfl

/-! ## No rest under waxing and waning -/

/-- **No configuration is a rest of the law of waxing and waning**: six steps on it is its
complement, which moves every configuration (`six_steps`, `complement_moves`). -/
theorem waxWane_moves (s : Hexagram) : waxWane s ≠ s :=
  fun fixed => complement_moves s ((orbit_still fixed 6).symm.trans (six_steps s))

/-- **So no run of it rests at any step**, 既濟 included (終止則亂). -/
theorem run_never_rests (s : Hexagram) (n : Nat) : ¬ RestsAt (Law.run waxWane s).state n :=
  fun rests => waxWane_moves _ rests

/-- **Nor comes to rest from any step on.** -/
theorem never_comes_to_rest (s : Hexagram) : ¬ ∃ T, ∀ n, T ≤ n → RestsAt (Law.run waxWane s).state n :=
  fun ⟨T, rests⟩ => run_never_rests s T (rests T (Nat.le_refl T))

/-- **No course of changes rests at any step**: every change moves the configuration. -/
theorem changes_run_never_rests (r : Run changes) (n : Nat) : ¬ RestsAt r.state n :=
  fun rests => flip_moves (r.act n) (r.state n) ((r.step n).symm.trans rests)

/-! ## The stations of 說卦 ch. 5 -/

namespace Trigram

/-- 乾: three unbroken lines (from the bottom). -/
def qian : Bool × Bool × Bool := (true, true, true)
/-- 兌. -/
def dui : Bool × Bool × Bool := (true, true, false)
/-- 離. -/
def li : Bool × Bool × Bool := (true, false, true)
/-- 震. -/
def zhen : Bool × Bool × Bool := (true, false, false)
/-- 巽. -/
def xun : Bool × Bool × Bool := (false, true, true)
/-- 坎. -/
def kan : Bool × Bool × Bool := (false, true, false)
/-- 艮. -/
def gen : Bool × Bool × Bool := (false, false, true)
/-- 坤. -/
def kun : Bool × Bool × Bool := (false, false, false)

/-- The line of three at a height (1 the bottom) turned. -/
def flip3 : Nat → Bool × Bool × Bool → Bool × Bool × Bool
  | 1, (a, b, c) => (!a, b, c)
  | 2, (a, b, c) => (a, !b, c)
  | _, (a, b, c) => (a, b, !c)

/-- The line at a height is the one line of three that differs from the other two, which agree. -/
def soleAt : Nat → Bool × Bool × Bool → Bool
  | 1, (a, b, c) => (b == c) && (a != b)
  | 2, (a, b, c) => (a == c) && (b != a)
  | _, (a, b, c) => (a == b) && (c != a)

/-- **One search, one line (說卦 「一索」「再索」「三索」).** A line of three is the sole line differing
from the others exactly where the three are 乾 or 坤 with the line at that height turned: 震, 坎, 艮
are 坤 searched at the bottom, the middle and the top, and 巽, 離, 兌 are 乾 so searched. -/
theorem sole_iff_searched (t : Bool × Bool × Bool) :
    soleAt 1 t = (t == flip3 1 qian || t == flip3 1 kun) ∧
      soleAt 2 t = (t == flip3 2 qian || t == flip3 2 kun) ∧
      soleAt 3 t = (t == flip3 3 qian || t == flip3 3 kun) := by
  obtain ⟨a, b, c⟩ := t
  cases a <;> cases b <;> cases c <;> exact ⟨rfl, rfl, rfl⟩

/-- 震, 坎, 艮 are 坤 searched once, twice and three times; 巽, 離, 兌 are 乾 so searched. -/
theorem searched :
    flip3 1 kun = zhen ∧ flip3 2 kun = kan ∧ flip3 3 kun = gen ∧
      flip3 1 qian = xun ∧ flip3 2 qian = li ∧ flip3 3 qian = dui :=
  ⟨rfl, rfl, rfl, rfl, rfl, rfl⟩

/-- Every line of three turned (錯). -/
def complement3 : Bool × Bool × Bool → Bool × Bool × Bool
  | (a, b, c) => (!a, !b, !c)

/-- Three lines turned over (綜). -/
def reverse3 : Bool × Bool × Bool → Bool × Bool × Bool
  | (a, b, c) => (c, b, a)

/-- Every line one place up, the top line to the bottom. -/
def rotate3 : Bool × Bool × Bool → Bool × Bool × Bool
  | (a, b, c) => (c, a, b)

/-- A three-cell rule on a ring of three. -/
def ringRule3 (ρ : Bool → Bool → Bool → Bool) : Bool × Bool × Bool → Bool × Bool × Bool
  | (a, b, c) => (ρ c a b, ρ a b c, ρ b c a)

/-- The same with the wrap read turned. -/
def twistedRule3 (ρ : Bool → Bool → Bool → Bool) : Bool × Bool × Bool → Bool × Bool × Bool
  | (a, b, c) => (ρ (!c) a b, ρ a b c, ρ b c (!a))

/-- The stations of 說卦 ch. 5: 帝出乎震，齊乎巽，相見乎離，致役乎坤，說言乎兌，戰乎乾，勞乎坎，成言乎艮. -/
def stations : List (Bool × Bool × Bool) := [zhen, xun, li, kun, dui, qian, kan, gen]

/-- **The stations are the run of no law commuting with 錯, with 綜, with both or with the rotation
of the lines**: 坤 goes on to 兌 and 乾 to 坎, not to 艮; 巽 to 離 and 兌 to 乾, not to 離; 震 to 巽
and 兌 to 乾, not to 艮; 震 to 巽 and 坎 to 艮, not to 離. -/
theorem stations_not_commutes {next : Bool × Bool × Bool → Bool × Bool × Bool}
    (runs : RunsThrough next stations) :
    ¬ Law.Commutes next complement3 ∧ ¬ Law.Commutes next reverse3 ∧
      ¬ Law.Commutes next (fun x => complement3 (reverse3 x)) ∧ ¬ Law.Commutes next rotate3 :=
  have follows : Follows next stations := runsThrough_iff (s := zhen) (l := stations.tail) |>.mp runs
  have zhen_xun : next zhen = xun := follows _ (.head _)
  have xun_li : next xun = li := follows _ (.tail _ (.head _))
  have kun_dui : next kun = dui := follows _ (.tail _ (.tail _ (.tail _ (.head _))))
  have dui_qian : next dui = qian := follows _ (.tail _ (.tail _ (.tail _ (.tail _ (.head _)))))
  have qian_kan : next qian = kan := follows _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.head _))))))
  have kan_gen : next kan = gen :=
    follows _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.head _)))))))
  ⟨fun commutes => (nomatch qian_kan.symm.trans ((commutes kun).trans (congrArg complement3 kun_dui))),
   fun commutes => (nomatch dui_qian.symm.trans ((commutes xun).trans (congrArg reverse3 xun_li))),
   fun commutes => (nomatch dui_qian.symm.trans
      ((commutes zhen).trans (congrArg (fun x => complement3 (reverse3 x)) zhen_xun))),
   fun commutes => (nomatch kan_gen.symm.trans ((commutes zhen).trans (congrArg rotate3 zhen_xun)))⟩

/-- A three-cell rule on a ring commutes with the rotation. -/
theorem ringRule3_rotate (ρ : Bool → Bool → Bool → Bool) : Law.Commutes (ringRule3 ρ) rotate3
  | (_, _, _) => rfl

/-- **So no three-cell rule on a ring runs the stations, and none with the wrap turned**: 巽 to
離 sets the bottom line from (坤's) neighbourhood broken, broken, unbroken to unbroken, and 坤 to
兌 sets the top line from the same neighbourhood to broken. -/
theorem stations_not_rules (ρ : Bool → Bool → Bool → Bool) :
    ¬ RunsThrough (ringRule3 ρ) stations ∧ ¬ RunsThrough (twistedRule3 ρ) stations :=
  ⟨fun runs => (stations_not_commutes runs).2.2.2 (ringRule3_rotate ρ),
   fun runs =>
    have follows : Follows (twistedRule3 ρ) stations :=
      runsThrough_iff (s := zhen) (l := stations.tail) |>.mp runs
    have up : ρ false false true = true := congrArg Prod.fst (follows _ (.tail _ (.head _)))
    have down : ρ false false true = false :=
      congrArg (fun x => x.2.2) (follows _ (.tail _ (.tail _ (.tail _ (.head _)))))
    Bool.noConfusion (up.symm.trans down)⟩

/-- The line of three at a height. -/
def line3 : Height → Bool × Bool × Bool → Bool
  | .low, (a, _, _) => a
  | .mid, (_, b, _) => b
  | .high, (_, _, c) => c

theorem line3_complement : ∀ (h : Height) (x : Bool × Bool × Bool), line3 h (complement3 x) = !line3 h x
  | .low, (_, _, _) => rfl
  | .mid, (_, _, _) => rfl
  | .high, (_, _, _) => rfl

theorem triple_ext {a a' b b' c c' : Bool} :
    a = a' → b = b' → c = c' → ((a, b, c) : Bool × Bool × Bool) = (a', b', c')
  | rfl, rfl, rfl => rfl

/-- The heights read through a map of heights, and the lines turned where a mask is unbroken. -/
def rearrange3 (σ : Height → Height) (mask : Bool × Bool × Bool) (x : Bool × Bool × Bool) :
    Bool × Bool × Bool :=
  (turnedBy (line3 (σ .low) x) (line3 .low mask), turnedBy (line3 (σ .mid) x) (line3 .mid mask),
    turnedBy (line3 (σ .high) x) (line3 .high mask))

/-- **Every rearrangement of the heights with a mask commutes with 錯.** -/
theorem rearrange3_complement (σ : Height → Height) (mask : Bool × Bool × Bool) :
    Law.Commutes (rearrange3 σ mask) complement3 :=
  fun x =>
    have turned : ∀ h, turnedBy (line3 (σ h) (complement3 x)) (line3 h mask) =
        !turnedBy (line3 (σ h) x) (line3 h mask) := fun h =>
      (congrArg (fun b => turnedBy b (line3 h mask)) (line3_complement (σ h) x)).trans (turnedBy_not _ _)
    triple_ext (turned .low) (turned .mid) (turned .high)

/-- **So none runs the stations.** -/
theorem rearrange3_not_stations (σ : Height → Height) (mask : Bool × Bool × Bool) :
    ¬ RunsThrough (rearrange3 σ mask) stations :=
  fun runs => (stations_not_commutes runs).1 (rearrange3_complement σ mask)

/-- **Of the four opposite stations only 離 and 坎 are complements; each of the four pairs of
說卦 ch. 3 (天地定位，山澤通氣，雷風相薄，水火不相射) is.** -/
theorem opposite_stations :
    (complement3 zhen ≠ dui ∧ complement3 xun ≠ qian ∧ complement3 li = kan ∧ complement3 kun ≠ gen) ∧
      (complement3 qian = kun ∧ complement3 gen = dui ∧ complement3 zhen = xun ∧ complement3 kan = li) :=
  ⟨⟨fun e => (nomatch e), fun e => (nomatch e), rfl, fun e => (nomatch e)⟩, ⟨rfl, rfl, rfl, rfl⟩⟩

end Trigram

/-! ## 交: 泰 and 否 -/

/-- **交** at a height: the line of the lower trigram unbroken and the line of the upper broken
(天在下而地在上). -/
def meets (s : Hexagram) (h : Height) : Bool := s.line (place .lower h) && !s.line (place .upper h)

/-- **否 is 泰 changed in every line, and 泰 turned over.** -/
theorem pi_of_tai : complement tai = pi ∧ reverse tai = pi := ⟨rfl, rfl⟩

/-- **So every reading the complement keeps reads 泰 and 否 alike, along every run of the law of
waxing and waning from them**: the run from 否 is the run from 泰 changed in every line
(`Law.Commutes.iterate`). -/
theorem kept_alike {K : Type u} {π : Hexagram → K} (kept : ∀ s, π (complement s) = π s) (n : Nat) :
    π ((Law.run waxWane pi).state n) = π ((Law.run waxWane tai).state n) :=
  (congrArg (fun s => π ((Law.run waxWane s).state n)) pi_of_tai.1.symm).trans
    ((congrArg π (Law.Commutes.iterate waxWane_complement tai n)).trans (kept _))

/-- **交 tells them apart**: it holds at every height of 泰 and at none of 否, so the complement
does not keep it; it reads a direction into the two values. -/
theorem meets_tai_pi :
    (∀ h, meets tai h = true) ∧ (∀ h, meets pi h = false) ∧
      ¬ ∀ s h, meets (complement s) h = meets s h :=
  ⟨(fun | .low => rfl | .mid => rfl | .high => rfl),
   (fun | .low => rfl | .mid => rfl | .high => rfl),
   fun kept => Bool.noConfusion (kept tai .low)⟩

/-- **Along the runs of waxing and waning from 泰 and from 否, their oppositions, alternations,
pair and parity agree at every step, while 交 tells their starts apart at every height.** -/
theorem tai_pi_runs (n : Nat) :
    (∀ h, opposed ((Law.run waxWane pi).state n) h = opposed ((Law.run waxWane tai).state n) h) ∧
      (∀ j, alternates ((Law.run waxWane pi).state n) j = alternates ((Law.run waxWane tai).state n) j) ∧
      pairOf ((Law.run waxWane pi).state n) = pairOf ((Law.run waxWane tai).state n) ∧
      yangOdd ((Law.run waxWane pi).state n) = yangOdd ((Law.run waxWane tai).state n) ∧
      ∀ h, meets ((Law.run waxWane tai).state 0) h ≠ meets ((Law.run waxWane pi).state 0) h :=
  ⟨fun h => kept_alike (π := fun s => opposed s h) (fun s => opposed_complement s h) n,
   fun j => kept_alike (π := fun s => alternates s j) (fun s => alternates_complement s j) n,
   kept_alike pairOf_complement n, kept_alike yangOdd_complement n,
   fun h same' => Bool.noConfusion ((meets_tai_pi.1 h).symm.trans (same'.trans (meets_tai_pi.2.1 h)))⟩

end Hexagram

end Becoming
