import Becoming.GrammarCandidates
import Becoming.GrammarLaws

/-!
# The corpus's conditional laws in the grammar (丙一之律) — OU5 design scratch

Board item OU5, part A (`development/ou5-conditional-laws/DESIGN.md`). The units classed 丙一 are
grouped by the law they state; this file proves, outside the package, the laws the design marks
new, and checks the countermodels and the compositions of existing laws the design cites. Which unit
states which law is an AI reconstruction (`data/groups.tsv`); the classical text decides nothing, and
Lean checks only the derivation. Names are provisional until OU's owner decides them.
-/

namespace Becoming

universe u

section Change

variable {α : Type u}

/-! ## G01 穷变通久, G06 感而遂通 -/

/-- **Exhausted, it alters (穷则变, G01).** What ends under a class and is continued under another
alters: it continues under the second and the first tells its two ends apart. Read for
「易窮則變」 (XCX-02-008), with 窮 read as ending under a class and 變 as alteration (`«异»`). -/
theorem «穷则变» {R E F : «际» α} {x y : α} (ends : «亡» R E x) (continues : «续» R F x y) :
    «异» R F E x y :=
  ⟨continues, fun same => ends ⟨y, continues.1, same⟩⟩

/-- **What is exhausted alters exactly where it has a successor (穷则变当且仅当有后).** For what ends
under `E`, altering into a continuation under `F` is having a successor under `F`. Where it has none
it does not alter: 穷而息, the countermodel the plan names (`«穷而息之例»`). -/
theorem «穷则变当且仅当有后» {R E F : «际» α} {x : α} (ends : «亡» R E x) :
    (∃ y, «异» R F E x y) ↔ «有后» R F x :=
  ⟨fun ⟨y, c, _⟩ => ⟨y, c⟩, fun ⟨y, c⟩ => ⟨y, «穷则变» ends c⟩⟩

/-- **Affected, it passes through (感而遂通, G06).** Where a class is constant under 缘 and under its
converse, an occurrence with a predecessor under it passes through: going never ends and coming
never ends. Constancy gives the successor, so having a predecessor suffices where
`«两向有常则通»` takes abiding. Read for 「寂然不動，感而遂通天下之故」 (XCS-10-006), with 感 read as a
predecessor reaching it under the class. -/
theorem «感而遂通» {R E : «际» α} (hE : «类» E) (hc : «有常» R E) (hc' : «有常» («逆» R) E) {x : α}
    (affected : «有前» R E x) : «通» R E x :=
  «两向有常则通» hE hc hc' ⟨affected, «有常则续不尽» hc affected⟩

/-- **Exhausted it alters, altered it passes through, passing through it lasts (穷变通久, G01).**
Where the class `F` an ending continues under is constant under 缘 and under its converse, what
ends under `E` and is continued under `F` alters, what it alters into passes through under `F`, and
its line under `F` never ends. Read for 「易窮則變，變則通，通則久」 (XCX-02-008), with 久 read as the line
never ending (`«不穷»`). -/
theorem «穷变通久» {R E F : «际» α} (hF : «类» F) (hc : «有常» R F) (hc' : «有常» («逆» R) F)
    {x y : α} (ends : «亡» R E x) (continues : «续» R F x y) :
    «异» R F E x y ∧ «通» R F y ∧ «不穷» R F y :=
  have passes := «感而遂通» hF hc hc' ⟨x, continues⟩
  ⟨«穷则变» ends continues, passes, passes.1⟩

/-- **Exhausted and ceasing (穷而息之例).** One occurrence with nothing after it ends under every
class and does not alter. -/
theorem «穷而息之例» : ∃ (R E F : «际» Unit), «亡» R E () ∧ ¬ ∃ y, «异» R F E () y :=
  ⟨fun _ _ => False, «一», «一», fun ⟨_, r, _⟩ => r, fun ⟨_, ⟨r, _⟩, _⟩ => r⟩

/-- **Altered and not passing through (变而不通之例).** Counting up from zero: zero ends under
identity and continues under the one into one, the one is constant one way only, and one does not
pass through: coming back it ends at zero (as `«有常而不通»`). -/
theorem «变而不通之例» :
    ∃ (R : «际» Nat), «亡» R «静» 0 ∧ «续» R «一» 0 1 ∧ «有常» R «一» ∧ ¬ «通» R «一» 1 := by
  let R : «际» Nat := fun m n => n = m + 1
  have hc : «有常» R «一» := by
    apply («有常之逐点» R «一»).mpr
    intro u u' _ v _
    exact ⟨u' + 1, rfl, trivial⟩
  refine ⟨R, fun ⟨y, r, e⟩ => ?_, ⟨rfl, trivial⟩, hc, fun ⟨_, back⟩ => ?_⟩
  · cases e; exact Nat.noConfusion r
  · match back 0 (.inr (.one ⟨rfl, trivial⟩)) with
    | ⟨w, hw, _⟩ => exact Nat.noConfusion hw

/-- **Still and unaffected, it does not pass through (寂而不感之例).** One occurrence with no
relation: the one is constant both ways, and with no predecessor it does not pass through. -/
theorem «寂而不感之例» :
    ∃ (R E : «际» Unit), «有常» R E ∧ «有常» («逆» R) E ∧ ¬ «有前» R E () ∧ ¬ «通» R E () :=
  ⟨fun _ _ => False, «一», fun _ _ ⟨_, _, r⟩ => r.elim, fun _ _ ⟨_, _, r⟩ => r.elim,
   fun ⟨_, r, _⟩ => r, fun ⟨go, _⟩ => match go () (.inl rfl) with | ⟨_, r, _⟩ => r⟩

/-! ## G02 相推而生 -/

/-- **Alternation generates (相推则全生成, G02).** Where everything is continued under a coarse class
`L` and every step of 缘 leaves the fine class `E`, the coarse line from anything never ends and a
carrying renewal lies ahead of each of its points: 全生成. Read for 「日往則月來，月往則日來，日月相推而
明生焉」 (XCX-04-004) and 「寒暑相推而歲成焉」 (XCX-04-005), with 相推 read as each step passing from one
phase to the other. -/
theorem «相推则全生成» {R L E : «际» α} (onward : ∀ y, «有后» R L y)
    (leaves : ∀ a b, R a b → ¬ E a b) (x : α) : «全生成» R L E x :=
  ⟨fun y _ => onward y, fun y _ => match onward y with
    | ⟨z, c⟩ => ⟨y, z, .inl rfl, c, fun ⟨w, r, e⟩ => leaves w z r e⟩⟩

/-- **Day and night generate (昼夜全生成).** Two occurrences, each the condition of the other: under
the one and identity, every occurrence is 全生成. -/
theorem «昼夜全生成» (x : Bool) : «全生成» (fun a b : Bool => b = !a) «一» «静» x :=
  «相推则全生成» (R := fun a b : Bool => b = !a) (L := «一») (E := «静»)
    (fun y => ⟨!y, rfl, trivial⟩) (fun a b r e => by cases e; cases a <;> exact Bool.noConfusion r) x

end Change

/-! ## G03 物壮则老, G04 复归其根 -/

section Room

variable {α : Type u}

open GrammarLaws in
/-- **A line that does not return is shorter than its room (无环之线短于所列, G03).** Where nothing
reaches itself, a line of `n` steps of continuation whose places a list holds has fewer steps than
the list is long: pigeonhole along the line gives a place it comes back to, which a relation without
cycles does not have. Read for 「物壯則老，是謂不道，不道早已」 (LZ-30-008, LZ-55-009), with 壯 read as a
rise that does not return (不道, after 「反者道之動」) and 早已 as ending within its room. -/
theorem «无环之线短于所列» {R E : «际» α} (acyclic : «无环» R) {l : List α} {g : Nat → α} {n : Nat}
    (steps : ∀ i, i < n → «续» R E (g i) (g (i + 1))) (held : ∀ i, i ≤ n → g i ∈ l) :
    n < l.length :=
  match Nat.lt_or_ge n l.length with
  | .inl lt => lt
  | .inr ge =>
    match revisits_within l g (fun i le => held i (Nat.le_trans le ge)) with
    | ⟨i, _, lt, le, same⟩ => match gap_of_lt lt with
      | ⟨d, gap⟩ =>
        have within : i + (d + 1) ≤ n :=
          Eq.subst (motive := fun k => k ≤ n) gap (Nat.le_trans le ge)
        have reach : «及» R (g i) (g (i + (d + 1))) :=
          «线则及» (fun k lt => (steps k lt).1) d i within
        absurd (Eq.subst (motive := fun w => «及» R (g i) w)
          ((congrArg g gap).symm.trans same.symm) reach) (acyclic (g i))

/-- **A rise that does not return, in bounded room, does not go on for ever (无环有限则非不穷, G03).**
Where nothing reaches itself and a list holds everything the line from `x` reaches, that line is not
endless. -/
theorem «无环有限则非不穷» {R E : «际» α} (acyclic : «无环» R) {x : α} {l : List α}
    (held : ∀ y, (x = y ∨ «相续» R E x y) → y ∈ l) : ¬ «不穷» R E x := fun endless =>
  let Rs : «际» {y : α // x = y ∨ «相续» R E x y} := fun a b => «续» R E a.1 b.1
  have total : ∀ a, ∃ b, Rs a b := fun a => match endless a.1 a.2 with
    | ⟨z, c⟩ => ⟨⟨z, .inr (match a.2 with
        | .inl e => Eq.subst (motive := fun w => «相续» R E w z) e.symm (.one c)
        | .inr line => «相续之续» line c)⟩, c⟩
  match «遍后则有线» total l.length ⟨x, .inl rfl⟩ with
  | ⟨g, _, steps⟩ =>
    Nat.lt_irrefl _ («无环之线短于所列» acyclic (g := fun i => (g i).1) steps
      (fun i _ => held _ (g i).2))

/-- Reach along the successor of counting rises. -/
theorem counting_reach_lt {x y : Nat} (h : «及» (fun m n : Nat => n = m + 1) x y) : x < y := by
  induction h with
  | one r => exact Eq.subst (motive := fun w => _ < w) r.symm (Nat.lt_succ_self _)
  | more r _ ih => exact Nat.lt_trans (Eq.subst (motive := fun w => _ < w) r.symm (Nat.lt_succ_self _)) ih

/-- **Without bound, a line that does not return goes on (无环而不穷之例).** Counting up: nothing
reaches itself, and the line from zero never ends. -/
theorem «无环而不穷之例» :
    ∃ (R : «际» Nat), «无环» R ∧ «不穷» R «一» 0 :=
  ⟨fun m n => n = m + 1, fun x h => Nat.lt_irrefl x (counting_reach_lt h),
   fun y _ => ⟨y + 1, rfl, trivial⟩⟩

/-- **In bounded room, a line that returns goes on (返而不穷之例).** Day and night: a list of two holds
everything, the line never ends, and it returns. -/
theorem «返而不穷之例» :
    ∃ (R : «际» Bool), (∀ y, y ∈ [false, true]) ∧ «不穷» R «一» false ∧ ¬ «无环» R :=
  ⟨fun a b => b = !a, fun y => match y with
    | false => .head _
    | true => .tail _ (.head _),
   («昼夜往来不穷» false).1, fun acyclic => acyclic false (.more rfl (.one rfl))⟩

/-- **Merging, a line need not return (并而不返之例, G04).** Two occurrences, both continued by the
second: everything has a successor and two occurrences hold everything, but the first does not
return. -/
theorem «并而不返之例» :
    ∃ (R : «际» Bool), (∀ y, y ∈ [false, true]) ∧ (∀ x, ∃ y, R x y) ∧ ¬ «及» R false false := by
  refine ⟨fun _ b => b = true, fun y => match y with
    | false => .head _
    | true => .tail _ (.head _), fun _ => ⟨true, rfl⟩, fun h => ?_⟩
  have lands : ∀ {x y : Bool}, «及» (fun _ b : Bool => b = true) x y → y = true := by
    intro x y h
    induction h with
    | one r => exact r
    | more _ _ ih => exact ih
  exact Bool.noConfusion (lands h)

/-- **Without bound, merging nothing, a line need not return (无尽而不返之例, G04).** Counting up:
everything has a successor, nothing merges, nothing returns. -/
theorem «无尽而不返之例» :
    ∃ (R : «际» Nat), (∀ x, ∃ y, R x y) ∧ «定前» R ∧ «无环» R :=
  ⟨fun m n => n = m + 1, fun x => ⟨x + 1, rfl⟩,
   «定前之逐点».mpr fun _ _ _ r r' => Nat.succ.inj (r.symm.trans r'),
   fun x h => Nat.lt_irrefl x (counting_reach_lt h)⟩

end Room

section Distinction

variable {α : Type u}

/-! ## G05 乾坤毁则无以见易, G07 动静有常 -/

/-- **No alteration exactly where the distinction parts no continuation (无异当且仅当类不分续, G05).**
Nothing alters from `E` under `F` exactly where `F` tells apart the two ends of no continuation under
`E` (up to double negation). Where `F` holds everywhere, nothing alters (`«平等无异»`). Read for
「乾坤毀，則无以見易；易不可見，則乾坤或幾乎息矣」 (XCS-12-012), with 乾坤 read as the two classes of one
distinction. -/
theorem «无异当且仅当类不分续» {R E F : «际» α} :
    (∀ x y, ¬ «异» R E F x y) ↔ ∀ x y, «续» R E x y → ¬¬ F x y :=
  ⟨fun none x y c apart => none x y ⟨c, apart⟩, fun kept x y ⟨c, apart⟩ => kept x y c apart⟩

/-- **With the distinction, alteration shows (分则见易之例).** Day and night under the one, told apart
by identity: the step from one to the other alters. -/
theorem «分则见易之例» : «异» (fun a b : Bool => b = !a) «一» «静» false true :=
  ⟨⟨rfl, trivial⟩, fun h => Bool.noConfusion h⟩

/-- **A class not constant is not within its core (非有常之类不含于核之例, G07).** Two occurrences, the
first its own successor and the second with none: the one is not constant, and its core does not
put the two together. -/
theorem «非有常之类不含于核之例» :
    ∃ (R : «际» Bool), ¬ «有常» R «一» ∧ ¬ «核» R «一» false true := by
  refine ⟨fun a b => a = false ∧ b = false, fun hc => ?_, fun ⟨S, _, _, hc, hs⟩ => ?_⟩
  · match («有常之逐点» _ «一»).mp hc false true trivial false ⟨rfl, rfl⟩ with
    | ⟨_, ⟨h, _⟩, _⟩ => exact Bool.noConfusion h
  · match («有常之逐点» _ S).mp hc false true hs false ⟨rfl, rfl⟩ with
    | ⟨_, ⟨h, _⟩, _⟩ => exact Bool.noConfusion h

end Distinction

/-! ## G08 缘起之设, G09 依则离无 -/

section Dependence

variable {α : Type u}

/-- **Nothing arises without a condition exactly where everything is conditioned
(无缘不起当且仅当皆有缘, G08).** That nothing begins under the one is that every occurrence is not-not
conditioned. So 「無緣即不起」 (JSZ-C-016) states a premise of the model, as OU6 found for
「一切物皆從眾緣生」 (`«从缘生非文法之律»`): the grammar admits an occurrence with no condition. -/
theorem «无缘不起当且仅当皆有缘» (R : «际» α) :
    (∀ y, ¬ «生» R «一» y) ↔ ∀ y, ¬¬ ∃ x, R x y :=
  ⟨fun h y none => h y (fun ⟨x, r, _⟩ => none ⟨x, r⟩),
   fun h y begins => h y (fun ⟨x, r⟩ => begins ⟨x, r, trivial⟩)⟩

/-- `Q` depends on `P` along `R` (依): every occurrence with `Q` has a condition with `P`. -/
def «依» (R : «际» α) (P Q : α → Prop) : Prop := ∀ y, Q y → ∃ x, R x y ∧ P x

/-- **Where `Q` depends on `P`, without `P` there is no `Q` (依则离无, G09).** Read for
「離心則無六塵境界」 (QXL-JS-119), 「離見則無境界」 (QXL-JS-085) and the 起信论's other units of the form 離
X 則無 Y, with the dependence the text states (以依 X 故有 Y) as the premise. -/
theorem «依则离无» {R : «际» α} {P Q : α → Prop} (dep : «依» R P Q) (none : ¬ ∃ x, P x) :
    ¬ ∃ y, Q y :=
  fun ⟨y, q⟩ => match dep y q with | ⟨x, _, p⟩ => none ⟨x, p⟩

/-- **Dependences compose (依之传, G09).** If `Q` depends on `P` along `R` and `S` on `Q` along `R'`,
then `S` depends on `P` along `R` then `R'`. Read for the chain 「以無明滅故心無有起，以無起故境界隨滅」
(QXL-JS-197). -/
theorem «依之传» {R R' : «际» α} {P Q S : α → Prop} (first : «依» R P Q) (second : «依» R' Q S) :
    «依» («而» R R') P S :=
  fun z s => match second z s with
    | ⟨y, r', q⟩ => match first y q with
      | ⟨x, r, p⟩ => ⟨x, ⟨y, r, r'⟩, p⟩

/-- **Without the dependence, `Q` stands without `P` (不依之例).** One occurrence with `Q`, no
relation, nothing with `P`. -/
theorem «不依之例» :
    ∃ (R : «际» Unit) (P Q : Unit → Prop), ¬ «依» R P Q ∧ (¬ ∃ x, P x) ∧ ∃ y, Q y :=
  ⟨fun _ _ => False, fun _ => False, fun _ => True,
   fun dep => match dep () trivial with | ⟨_, r, _⟩ => r, fun ⟨_, p⟩ => p, ⟨(), trivial⟩⟩

/-- **In a net without cycles nothing is co-present (无环则无俱有, G10).** -/
theorem «无环则无俱有» {R : «际» α} (acyclic : «无环» R) {x y : α} : ¬ «俱有» R x y :=
  fun ⟨a, b⟩ => acyclic x («及之传递» a b)

end Dependence

/-! ## G15 前际后际 -/

section Limits

variable {α : Type u}

/-- Along the core, lines follow each other: a line from `u'` under a class is matched, place by
place, by a line from anything `u'` is related to by a symmetric constant relation within the
class. -/
theorem «核下线相随» {R E S : «际» α} (hE : «类» E) (hSE : «则» S E) (hc : «有常» R S) :
    ∀ {u' z' : α}, «相续» R E u' z' → ∀ {u : α}, S u' u → ∃ z, «相续» R E u z ∧ S z' z := by
  intro u' z' line
  induction line with
  | one c =>
    intro u h
    match («有常之逐点» R S).mp hc _ u h _ c.1 with
    | ⟨v, r, s⟩ => exact ⟨v, .one ⟨r, hE.trans (hE.symm (hSE _ _ h)) (hE.trans c.2 (hSE _ _ s))⟩, s⟩
  | more c _ ih =>
    intro u h
    match («有常之逐点» R S).mp hc _ u h _ c.1 with
    | ⟨m, r, s⟩ => match ih s with
      | ⟨z, l, s'⟩ =>
        exact ⟨z, .more ⟨r, hE.trans (hE.symm (hSE _ _ h)) (hE.trans c.2 (hSE _ _ s))⟩ l, s'⟩

/-- **A line without end is so for its whole core class (不穷于核下不变, G15).** For a class `E`, what
the core puts with an occurrence whose line under `E` never ends has a line under `E` that never ends:
an end, the 後際, does not tell apart what the core does not. Read for 「如來藏無有後際，諸佛所得涅槃與之
相應則無後際」 (QXL-JS-326), with 相應 read as lying in one class of the core. -/
theorem «不穷于核下不变» {R E : «际» α} (hE : «类» E) {y y' : α} (hk : «核» R E y y')
    (endless : «不穷» R E y) : «不穷» R E y' :=
  match hk with
  | ⟨S, hSE, hs, hc, hyy⟩ => fun z' reach =>
    have matched : ∃ z, (y = z ∨ «相续» R E y z) ∧ S z' z := match reach with
      | .inl e => ⟨y, .inl rfl, Eq.subst (motive := fun w => S w y) e (hs _ _ hyy)⟩
      | .inr line => match «核下线相随» hE hSE hc line (hs _ _ hyy) with
        | ⟨z, l, s⟩ => ⟨z, .inr l, s⟩
    match matched with
    | ⟨z, onY, s⟩ => match endless z onY with
      | ⟨w, r, e⟩ => match («有常之逐点» R S).mp hc z z' (hs _ _ s) w r with
        | ⟨w', r', s'⟩ => ⟨w', r', hE.trans (hE.trans (hSE _ _ s) e) (hSE _ _ s')⟩

/-- **A beginning, the 前際, is not kept along the one-way core (生于核下可变之例, G15).** Three
occurrences, the third conditioning the second: the first and the second have no successor, so the
core of the one puts them together, yet the first begins and the second does not. Beginning is kept
only along the two-way core (`«生于位核下不变»`). -/
theorem «生于核下可变之例» :
    ∃ (β : Type) (R : «际» β) (a b : β), «核» R «一» a b ∧ «生» R «一» a ∧ ¬ «生» R «一» b := by
  let R : «际» (Option Bool) := fun x y => x = some true ∧ y = some false
  let S : «际» (Option Bool) := fun u v => (u = none ∨ u = some false) ∧ (v = none ∨ v = some false)
  have hc : «有常» R S := by
    apply («有常之逐点» R S).mpr
    intro u u' ⟨hu, _⟩ v r
    match hu with
    | .inl h => exact absurd (h.symm.trans r.1) (fun e => by cases e)
    | .inr h => exact absurd (h.symm.trans r.1) (fun e => by cases e)
  refine ⟨Option Bool, R, none, some false,
    ⟨S, fun _ _ _ => trivial, fun _ _ ⟨a, b⟩ => ⟨b, a⟩, hc, ⟨.inl rfl, .inr rfl⟩⟩,
    fun ⟨_, r, _⟩ => absurd r.2 (fun e => by cases e),
    fun begins => begins ⟨some true, ⟨rfl, rfl⟩, trivial⟩⟩

/-- **Without a beginning and still ending (无始而有终之例, G15).** Counting down to zero: going back
from zero never ends, and zero ends. So 無始 does not give 無終 (「染法從無始已來熏習不斷，乃至得佛後則有斷」,
QXL-JS-238). -/
theorem «无始而有终之例» : ∃ (R : «际» Nat), «不穷» («逆» R) «一» 0 ∧ «亡» R «一» 0 :=
  ⟨fun m n => m = n + 1, fun y _ => ⟨y + 1, rfl, trivial⟩, fun ⟨_, r, _⟩ => Nat.noConfusion r⟩

/-- **What depends on the beginningless can begin (依于无始而有始之例, G15).** Counting down to the
first of a kind, which conditions one occurrence of another kind: under the class of the two kinds,
going back from the first never ends, the other occurrence depends on that kind, and it begins. So
dependence on what has no 前際 does not give no 前際 (「以如來藏無前際故，無明之相亦無有始」, QXL-JS-324,
needs more than dependence). -/
theorem «依于无始而有始之例» :
    ∃ (R E : «际» (Bool × Nat)), «类» E ∧ «依» R (fun x => x.1 = true) (fun y => y = (false, 0)) ∧
      «不穷» («逆» R) E (true, 0) ∧ «生» R E (false, 0) := by
  let R : «际» (Bool × Nat) := fun x y =>
    (x.1 = true ∧ y.1 = true ∧ x.2 = y.2 + 1) ∨ (x = (true, 0) ∧ y = (false, 0))
  let E : «际» (Bool × Nat) := fun x y => x.1 = y.1
  have kept : ∀ {a b : Bool × Nat}, «相续» («逆» R) E a b → a.1 = b.1 := by
    intro a b h
    induction h with
    | one c => exact c.2
    | more c _ ih => exact c.2.trans ih
  refine ⟨R, E, ⟨fun _ => rfl, Eq.symm, Eq.trans⟩, fun y q => ?_, fun y reach => ?_, ?_⟩
  · exact Eq.subst (motive := fun w => ∃ x, R x w ∧ x.1 = true) q.symm ⟨(true, 0), .inr ⟨rfl, rfl⟩, rfl⟩
  · have hy : y.1 = true := match reach with
      | .inl e => Eq.subst (motive := fun w : Bool × Nat => w.1 = true) e rfl
      | .inr l => (kept l).symm
    exact ⟨(true, y.2 + 1), .inl ⟨rfl, hy, rfl⟩, hy⟩
  · intro ⟨x, r, e⟩
    match r with
    | .inl ⟨_, h, _⟩ => exact Bool.noConfusion h
    | .inr ⟨hx, _⟩ => exact Bool.noConfusion ((congrArg Prod.fst hx).symm.trans e)

/-- **Holding together (相须之例, G11).** Two classes, the first and second coordinates of two bits,
each point but the two mixed ones its own successor: their joint class is constant and neither alone
is, and what both put together goes on while a mate under one alone ends. -/
theorem «相须之例» :
    «相须» (fun (u v : Bool × Bool) => u.1 = u.2 ∧ v = u)
      (fun u v => u.1 = v.1) (fun u v => u.2 = v.2) := by
  refine ⟨?_, fun hc => ?_, fun hc => ?_⟩
  · apply («有常之逐点» _ _).mpr
    intro u u' ⟨h1, h2⟩ v ⟨r1, r2⟩
    refine ⟨u', ⟨?_, rfl⟩, ?_⟩
    · exact h1.symm.trans (r1.trans h2)
    · cases r2; exact ⟨h1, h2⟩
  · match («有常之逐点» _ _).mp hc (false, false) (false, true) rfl (false, false) ⟨rfl, rfl⟩ with
    | ⟨_, ⟨h, _⟩, _⟩ => exact Bool.noConfusion h
  · match («有常之逐点» _ _).mp hc (false, false) (true, false) rfl (false, false) ⟨rfl, rfl⟩ with
    | ⟨_, ⟨h, _⟩, _⟩ => exact Bool.noConfusion h

end Limits

/-! ## Compositions of existing laws the design cites (checks, not proposals; named so the audit reads them) -/

section Checks

variable {α : Type u}

/-- G16: what has no condition begins under every class (`«一之生»`, `«生于粗则生于细»`). -/
theorem check_unconditioned_begins_everywhere {R : «际» α} {y : α} (none : ∀ x, ¬ R x y) (E : «际» α) : «生» R E y :=
  «生于粗则生于细» R (fun _ _ _ => trivial) ((«一之生» R y).mpr none)

/-- G02, G14: the short line ends, so it is not 全生成; the one is not constant on it. -/
theorem check_short_not_generating : ¬ «全生成» Map.short «一» «静» false :=
  fun g => «全生成有终不并» ⟨g, Map.Short.degeneration⟩
theorem check_short_not_constant : ¬ «有常» Map.short «一» := fun hc =>
  match («有常之逐点» _ «一»).mp hc false true trivial true ⟨rfl, rfl⟩ with
  | ⟨_, ⟨h, _⟩, _⟩ => Bool.noConfusion h

/-- G02: the still occurrence keeps, so it is not 全生成. -/
theorem check_still_not_generating : ¬ «全生成» Map.still «一» «一» () :=
  fun g => «全生成全守不并» ⟨g, Map.Still.keeping⟩

/-- G16: the short line's end is not its own condition and ends (LZ-07-002 read structurally). -/
theorem check_short_end_not_own_condition : ¬ Map.short true true ∧ «亡» Map.short «一» true :=
  ⟨fun ⟨h, _⟩ => Bool.noConfusion h, Map.short_end⟩

/-- G24: an occurrence can end with nothing before it. -/
theorem check_end_without_rise : «生» (fun _ _ : Unit => False) «一» () ∧ «亡» (fun _ _ : Unit => False) «一» () :=
  ⟨fun ⟨_, r, _⟩ => r, fun ⟨_, r, _⟩ => r⟩

/-- G22: a balance that reverses does not keep "heavier than" within "hangs lower than". -/
theorem check_reversing_balance : ¬ «则» («像» (fun b : Bool => !b) (fun a b => a = true ∧ b = false))
    (fun p q => p = true ∧ q = false) :=
  fun within => match within false true ⟨true, false, rfl, ⟨rfl, rfl⟩, rfl⟩ with
    | ⟨h, _⟩ => Bool.noConfusion h

end Checks

end Becoming
