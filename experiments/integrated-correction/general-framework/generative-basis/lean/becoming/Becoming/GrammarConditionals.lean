import Becoming.GrammarCandidates
import Becoming.GrammarLaws

/-!
# The corpus's conditional laws in the grammar (丙一之律)

The corpus's units classed 丙一 (OU plan §八 step 5) state conditional laws, Y given Z. Each family of them
is written in the grammar as "Y 当且仅当 Z" or "Z 则 Y", with a net where Z fails and Y fails with it. Twelve
families' laws stand in the grammar's modules and the corpus's candidate theorems already. This module holds
the rest:
- the new laws: 相推 gives 全生成 (`«皆有后而步皆分则全生成»`); bounded room on a line
  (`«线不返则短于所列»`, `«不返而有限则非不穷»`); what the core puts together never ends alike
  (`«核同则同不穷»`); and dependence (`«依»`, `«所依无则依者无»`, `«依之传»`);
- the definitional lemmas a family needs in order to be stated exactly, with what ending and altering give
  passing through (`«亡而通则异»`, `«有后而两向有常则通»`, `«亡而两向有常则异当且仅当通»`);
- a witness (`…之例`) for every family whose net where Z fails the other modules do not give.

The general laws below it are cited, not restated: `«生于逆核下不变»` (Grammar), with `«生于位核下不变»` as
its case, and `«两向有常有前则通»` (GrammarReadings), with `«两向有常则通»` as its case.

Which unit states which law is an AI reconstruction. Each unit's family, disposition and labelled reading
are kept in the OU7 study's `data/groups.tsv`. A law's reading therefore stands in its docstring, marked
[AI reading], and not in its name. The classical text decides nothing, and Lean checks only the
derivation. The home section is 06 §四, with the record `conditional-laws-of-the-corpus`.
-/

namespace Becoming

universe u

section Change

variable {α : Type u}

/-! ## Ending, alteration and passing through (design G01, G06) -/

/-- **What ends under a class alters exactly where it has a successor (亡者异当且仅当有后).** For what
ends under `E`, altering into a continuation under `F` (`«异» R F E`: `F` continues, `E` tells the two
apart) is having a successor under `F`. One unfolding of `«异»` and `«亡»`; its "则" half, that what
ends under `E` and continues under `F` alters, is the mirror of `«生于细而续于粗则异»`. Read for
「易窮則變」 (XCX-02-008) [AI reading], with 窮 read as ending under a class and 變 as alteration.
Where nothing follows, it does not alter (`«亡而息之例»`). -/
theorem «亡者异当且仅当有后» {R E F : «际» α} {x : α} (ends : «亡» R E x) :
    (∃ y, «异» R F E x y) ↔ «有后» R F x :=
  ⟨fun ⟨y, c, _⟩ => ⟨y, c⟩, fun ⟨y, c⟩ => ⟨y, c, fun same => ends ⟨y, c.1, same⟩⟩⟩

/-- **Ending and ceasing, without alteration (亡而息之例).** One occurrence with nothing after it ends
under every class, ceases (`«息»`: it renews into nothing), and does not alter. -/
theorem «亡而息之例» :
    ∃ (R E F : «际» Unit), «亡» R E () ∧ «息» R F () ∧ ¬ ∃ y, «异» R F E () y :=
  ⟨fun _ _ => False, «一», «一», fun ⟨_, r, _⟩ => r, «自不复生则息» (fun ⟨_, r, _⟩ => r),
   fun ⟨_, ⟨r, _⟩, _⟩ => r⟩

/-- **Constant both ways, with no predecessor, it does not pass through (两向有常而无前不通之例).** One
occurrence with no relation: the one is constant both ways, and with no predecessor it does not pass
through. -/
theorem «两向有常而无前不通之例» :
    ∃ (R E : «际» Unit), «有常» R E ∧ «有常» («逆» R) E ∧ ¬ «有前» R E () ∧ ¬ «通» R E () :=
  ⟨fun _ _ => False, «一», fun _ _ ⟨_, _, r⟩ => r.elim, fun _ _ ⟨_, _, r⟩ => r.elim,
   fun ⟨_, r, _⟩ => r, fun ⟨go, _⟩ => match go () (.inl rfl) with | ⟨_, r, _⟩ => r⟩

/-- **Not constant, and still ending, altering and passing through (不有常而通之例).** Day and night
beside a lone occurrence, under the one: the one is not constant (the lone occurrence has no
successor while the others do), yet `some false` ends under identity, alters into `some true`
(`«异» R «一» «静»`), and `some true` passes through. So two-way constancy is sufficient for passing
through (`«两向有常有前则通»`), not necessary. -/
theorem «不有常而通之例» :
    ∃ (R : «际» (Option Bool)), ¬ «有常» R «一» ∧ «亡» R «静» (some false) ∧
      «异» R «一» «静» (some false) (some true) ∧ «通» R «一» (some true) := by
  let R : «际» (Option Bool) := fun a b => ∃ x, a = some x ∧ b = some (!x)
  have fwd : ∀ c : Bool, R (some c) (some (!c)) := fun c => ⟨c, rfl, rfl⟩
  have bwd : ∀ c : Bool, «逆» R (some c) (some (!c)) := fun c =>
    ⟨!c, rfl, Eq.subst (motive := fun b => some c = some b) (Bool.not_not c).symm rfl⟩
  have onPair : ∀ {S : «际» (Option Bool)}, (∀ a b, S a b → ∃ c, b = some c) →
      ∀ {a b : Option Bool}, «相续» S «一» a b → ∃ c, b = some c := by
    intro S hS a b l
    induction l with
    | one c' => exact hS _ _ c'.1
    | more _ _ ih => exact ih
  have rTo : ∀ a b, R a b → ∃ c, b = some c := fun _ _ ⟨x, _, hb⟩ => ⟨!x, hb⟩
  have rFrom : ∀ a b, «逆» R a b → ∃ c, b = some c := fun _ _ ⟨x, ha, _⟩ => ⟨x, ha⟩
  refine ⟨R, fun hc => ?_, fun ⟨y, ⟨x, hx, hy⟩, e⟩ => ?_, ⟨⟨fwd false, trivial⟩, fun e => ?_⟩, ?_, ?_⟩
  · match («有常之逐点» R «一»).mp hc (some false) none trivial (some true) (fwd false) with
    | ⟨_, ⟨_, h, _⟩, _⟩ => exact nomatch h
  · have hx' : x = false := (Option.some.inj hx).symm
    have e' : some false = some (!x) := e.trans hy
    exact Bool.noConfusion ((Option.some.inj e').trans (congrArg (fun b => !b) hx'))
  · exact Bool.noConfusion (Option.some.inj e)
  · intro y reach
    match reach with
    | .inl e => exact ⟨some false, Eq.subst (motive := fun w => R w (some false)) e (fwd true), trivial⟩
    | .inr l => match onPair rTo l with
      | ⟨c, e⟩ =>
        exact ⟨some (!c), Eq.subst (motive := fun w => R w (some (!c))) e.symm (fwd c), trivial⟩
  · intro y reach
    match reach with
    | .inl e =>
      exact ⟨some false, Eq.subst (motive := fun w => «逆» R w (some false)) e (bwd true), trivial⟩
    | .inr l => match onPair rFrom l with
      | ⟨c, e⟩ =>
        exact ⟨some (!c), Eq.subst (motive := fun w => «逆» R w (some (!c))) e.symm (bwd c), trivial⟩

/-- **What ends passes through only by altering (亡而通则异).** What ends under `E` and passes through
under `F` alters: passing through gives a successor under `F`, and for what ends under `E` that successor
is told apart (`«亡者异当且仅当有后»`). One step from the definition of `«通»`. Read for the 須 of 孔疏's
「則須隨時改變」 on 「易窮則變」 (XCX-02-008) [AI reading]. What does not end under `E` can pass through
without altering (`«通而不异之例»`). -/
theorem «亡而通则异» {R E F : «际» α} {x : α} (ends : «亡» R E x) (h : «通» R F x) :
    ∃ y, «异» R F E x y :=
  («亡者异当且仅当有后» ends).mpr (h.1 x (.inl rfl))

/-- **What has a successor passes through where its class is constant both ways (有后而两向有常则通).** A
successor under `F`, with `F` constant under 缘's converse, gives a predecessor under `F`, and then
`«两向有常有前则通»` applies. -/
theorem «有后而两向有常则通» {R F : «际» α} {x : α} (hF : «类» F) (hc : «有常» R F)
    (hc' : «有常» («逆» R) F) (h : «有后» R F x) : «通» R F x :=
  match h with
  | ⟨y, hr, fy⟩ =>
    match «有常则续不尽» hc' ⟨y, hr, hF.symm fy⟩ with
    | ⟨w, hw, fw⟩ => «两向有常有前则通» hF hc hc' ⟨w, hw, hF.symm fw⟩

/-- **What alters passes through where its class is constant both ways (异而两向有常则通).** The case of
`«有后而两向有常则通»` for a successor that alters: the parting under `E` is not used, and what carries it
is the continuation under `F` and that class's constancy. The constancy is sufficient
(`«不有常而异且通之例»`), a premise the text does not state, and without it what alters can fail to pass
through (`«异而不通之例»`). -/
theorem «异而两向有常则通» {R E F : «际» α} {x y : α} (hF : «类» F) (hc : «有常» R F)
    (hc' : «有常» («逆» R) F) (h : «异» R F E x y) : «通» R F x :=
  «有后而两向有常则通» hF hc hc' ⟨y, h.1⟩

/-- **For what ends, altering and passing through are one where the class is constant both ways
(亡而两向有常则异当且仅当通).** The two laws above joined: what ends under `E`, under `F` constant both
ways, alters exactly where it passes through. So the two steps of 「易窮則變，變則通」 hold in the grammar as
implications under that premise [AI reading], the first also needing a successor under `F`, since what ends
can cease (`«亡而息之例»`). Under these premises having a successor, altering, passing through and never
ending going are one, so there the grammar gives them no direction among them, and it gives no order in
time; what alters need not have ended at all (`«异而未亡之例»`). -/
theorem «亡而两向有常则异当且仅当通» {R E F : «际» α} {x : α} (hF : «类» F) (hc : «有常» R F)
    (hc' : «有常» («逆» R) F) (ends : «亡» R E x) : (∃ y, «异» R F E x y) ↔ «通» R F x :=
  ⟨fun ⟨_, h⟩ => «异而两向有常则通» hF hc hc' h, «亡而通则异» ends⟩

/-- **Altering and not ended (异而未亡之例).** One occurrence with a step to itself and a step to another:
it alters into the other under the one, identity parting them, and it has not ended under identity,
since it also continues itself. So altering does not need ending, though with passing through ending
gives altering (`«亡而通则异»`). -/
theorem «异而未亡之例» :
    ∃ (R : «际» Bool), «异» R «一» «静» false true ∧ ¬ «亡» R «静» false :=
  ⟨fun a _ => a = false, ⟨⟨rfl, trivial⟩, fun e => Bool.noConfusion e⟩,
   fun ends => ends ⟨false, rfl, rfl⟩⟩

/-- **Altering and not passing through (异而不通之例).** One step with nothing after it: the first
occurrence ends under identity and alters under the one into the second, whose line ends, so the first
does not pass through. The one is not constant here, so `«异而两向有常则通»`'s premise is not idle. -/
theorem «异而不通之例» :
    ∃ (R : «际» Bool), «亡» R «静» false ∧ «异» R «一» «静» false true ∧ ¬ «通» R «一» false :=
  ⟨fun a b => a = false ∧ b = true,
   fun ⟨_, ⟨_, hy⟩, e⟩ => Bool.noConfusion (Eq.trans e hy),
   ⟨⟨⟨rfl, rfl⟩, trivial⟩, fun e => Bool.noConfusion e⟩,
   fun ⟨go, _⟩ => match go true (.inr (.one ⟨⟨rfl, rfl⟩, trivial⟩)) with
     | ⟨_, ⟨⟨h, _⟩, _⟩⟩ => Bool.noConfusion h⟩

/-- **Passing through without altering (通而不异之例).** One occurrence related to itself, under the one:
it passes through, and the one parts no step, so it does not alter. Where it has not ended under the class
that parts, passing through does not need altering, so `«亡而通则异»`'s premise is not idle. -/
theorem «通而不异之例» :
    ∃ (R : «际» Unit), «通» R «一» () ∧ ¬ ∃ y, «异» R «一» «一» () y :=
  ⟨fun _ _ => True,
   ⟨fun _ _ => ⟨(), trivial, trivial⟩, fun _ _ => ⟨(), trivial, trivial⟩⟩,
   fun ⟨_, _, n⟩ => n trivial⟩

/-- **Where every step is parted, everything has ended (步皆分则皆亡).** Where `E` parts every step of 缘,
nothing is continued under `E`, so every occurrence ends under it. On 變 read as an alternation at every step
(「一闔一闢」, XCS-11-009) the laws above hold at every place, and 窮 selects no place [AI reading]. -/
theorem «步皆分则皆亡» {R E : «际» α} (leaves : ∀ a b, R a b → ¬ E a b) (x : α) : «亡» R E x :=
  fun ⟨y, hr, he⟩ => leaves x y hr he

/-- **Ending, altering and passing through at one occurrence, with no constancy (不有常而异且通之例).** The
net of `«不有常而通之例»`, at one occurrence: `some false` ends under identity, alters into `some true` and
passes through, under a class that is not constant. So `«异而两向有常则通»`'s constancy is sufficient, not
necessary. -/
theorem «不有常而异且通之例» :
    ∃ (R : «际» (Option Bool)), ¬ «有常» R «一» ∧ «亡» R «静» (some false) ∧
      «异» R «一» «静» (some false) (some true) ∧ «通» R «一» (some false) := by
  let R : «际» (Option Bool) := fun a b => ∃ x, a = some x ∧ b = some (!x)
  have fwd : ∀ c : Bool, R (some c) (some (!c)) := fun c => ⟨c, rfl, rfl⟩
  have bwd : ∀ c : Bool, «逆» R (some c) (some (!c)) := fun c =>
    ⟨!c, rfl, Eq.subst (motive := fun b => some c = some b) (Bool.not_not c).symm rfl⟩
  have onPair : ∀ {S : «际» (Option Bool)}, (∀ a b, S a b → ∃ c, b = some c) →
      ∀ {a b : Option Bool}, «相续» S «一» a b → ∃ c, b = some c := by
    intro S hS a b l
    induction l with
    | one c' => exact hS _ _ c'.1
    | more _ _ ih => exact ih
  have rTo : ∀ a b, R a b → ∃ c, b = some c := fun _ _ ⟨x, _, hb⟩ => ⟨!x, hb⟩
  have rFrom : ∀ a b, «逆» R a b → ∃ c, b = some c := fun _ _ ⟨x, ha, _⟩ => ⟨x, ha⟩
  refine ⟨R, fun hc => ?_, fun ⟨y, ⟨x, hx, hy⟩, e⟩ => ?_, ⟨⟨fwd false, trivial⟩, fun e => ?_⟩, ?_, ?_⟩
  · match («有常之逐点» R «一»).mp hc (some false) none trivial (some true) (fwd false) with
    | ⟨_, ⟨_, h, _⟩, _⟩ => exact nomatch h
  · have hx' : x = false := (Option.some.inj hx).symm
    have e' : some false = some (!x) := e.trans hy
    exact Bool.noConfusion ((Option.some.inj e').trans (congrArg (fun b => !b) hx'))
  · exact Bool.noConfusion (Option.some.inj e)
  · intro y reach
    match reach with
    | .inl e => exact ⟨some true, Eq.subst (motive := fun w => R w (some true)) e (fwd false), trivial⟩
    | .inr l => match onPair rTo l with
      | ⟨c, e⟩ =>
        exact ⟨some (!c), Eq.subst (motive := fun w => R w (some (!c))) e.symm (fwd c), trivial⟩
  · intro y reach
    match reach with
    | .inl e =>
      exact ⟨some true, Eq.subst (motive := fun w => «逆» R w (some true)) e (bwd false), trivial⟩
    | .inr l => match onPair rFrom l with
      | ⟨c, e⟩ =>
        exact ⟨some (!c), Eq.subst (motive := fun w => «逆» R w (some (!c))) e.symm (bwd c), trivial⟩

/-! ## Generation where every step is parted (design G02) -/

/-- **Where everything has a successor and every step is parted, everything is 全生成
(皆有后而步皆分则全生成).** Where everything is continued under a coarse class `L` and the fine class `E`
parts every step of 缘, the coarse line from anything never ends and a carrying renewal lies ahead of
each of its points. A short derivation from the definition of `«全生成»`; sufficient, and the
converse is not claimed. Read for 「日往則月來，月往則日來，日月相推而明生焉」 (XCX-04-004) and
「寒暑相推而歲成焉」 (XCX-04-005) [AI reading], with 相推 read as each step passing from one phase to
the other. -/
theorem «皆有后而步皆分则全生成» {R L E : «际» α} (onward : ∀ y, «有后» R L y)
    (leaves : ∀ a b, R a b → ¬ E a b) (x : α) : «全生成» R L E x :=
  ⟨fun y _ => onward y, fun y _ => match onward y with
    | ⟨z, c⟩ => ⟨y, z, .inl rfl, c, fun ⟨w, r, e⟩ => leaves w z r e⟩⟩

/-- **Day and night generate (昼夜全生成).** Two occurrences, each the condition of the other: under
the one and identity, every occurrence is 全生成. A model instance. -/
theorem «昼夜全生成» (x : Bool) : «全生成» (fun a b : Bool => b = !a) «一» «静» x :=
  «皆有后而步皆分则全生成» (R := fun a b : Bool => b = !a) (L := «一») (E := «静»)
    (fun y => ⟨!y, rfl, trivial⟩) (fun a b r e => by cases e; cases a <;> exact Bool.noConfusion r) x

/-- **Something ends, and it is not 全生成 (有亡而不全生成之例).** The short line: `true` has no
successor, so not everything is continued, and the line from `false` reaches an end, so it is not
全生成. -/
theorem «有亡而不全生成之例» : «亡» Map.short «一» true ∧ ¬ «全生成» Map.short «一» «静» false :=
  ⟨Map.short_end, fun g => «全生成有终不并» ⟨g, Map.Short.reaches_end⟩⟩

/-- **A step not parted, and not 全生成 (步不分而不全生成之例).** The still occurrence: its step keeps
the class, so not every step is parted, and it keeps (全守), so it is not 全生成. -/
theorem «步不分而不全生成之例» :
    Map.still () () ∧ «一» () () ∧ ¬ «全生成» Map.still «一» «一» () :=
  ⟨trivial, trivial, fun g => «全生成全守不并» ⟨g, Map.Still.keeping⟩⟩

end Change

/-! ## Bounded room (design G03, G04) -/

section Room

variable {α : Type u}

open GrammarLaws in
/-- **A line whose places do not come back to themselves is shorter than its list (线不返则短于所列).**
Where no place of a line of `n` steps of continuation reaches itself along continuation, and a list
holds its places, the line has fewer steps than the list is long: pigeonhole along the line gives a
place it comes back to. A derivation of its own; only the line is constrained, not the whole net.
Read for 「物壯則老，是謂不道，不道早已」 (LZ-30-008, LZ-55-009) [AI reading], with 壯 read as a rise
whose line does not come back (不道, after 「反者道之動」). -/
theorem «线不返则短于所列» {R E : «际» α} {l : List α} {g : Nat → α} {n : Nat}
    (noReturn : ∀ i, i ≤ n → ¬ «相续» R E (g i) (g i))
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
        have reach : «相续» R E (g i) (g (i + (d + 1))) :=
          «线则及» (R := «续» R E) (fun k lt => steps k lt) d i within
        absurd (Eq.subst (motive := fun w => «相续» R E (g i) w)
          ((congrArg g gap).symm.trans same.symm) reach)
          (noReturn i (Nat.le_trans (Nat.le_trans (Nat.le_add_right i (d + 1))
            (Nat.le_of_eq gap.symm)) (Nat.le_trans le ge)))

/-- **A line that does not come back, held by a list, does not go on for ever
(不返而有限则非不穷).** Where no place on the line from `x` reaches itself along continuation and a
list holds every place of that line, the line is not endless. Constructively this exhibits no end.
A derivation of its own. -/
theorem «不返而有限则非不穷» {R E : «际» α} {x : α} {l : List α}
    (noReturn : ∀ y, (x = y ∨ «相续» R E x y) → ¬ «相续» R E y y)
    (held : ∀ y, (x = y ∨ «相续» R E x y) → y ∈ l) : ¬ «不穷» R E x := fun endless =>
  let Rs : «际» {y : α // x = y ∨ «相续» R E x y} := fun a b => «续» R E a.1 b.1
  have total : ∀ a, ∃ b, Rs a b := fun a => match endless a.1 a.2 with
    | ⟨z, c⟩ => ⟨⟨z, .inr (match a.2 with
        | .inl e => Eq.subst (motive := fun w => «相续» R E w z) e.symm (.one c)
        | .inr line => «相续之续» line c)⟩, c⟩
  match «遍后则有线» total l.length ⟨x, .inl rfl⟩ with
  | ⟨g, _, steps⟩ =>
    Nat.lt_irrefl _ («线不返则短于所列» (g := fun i => (g i).1) (fun i _ => noReturn _ (g i).2) steps
      (fun i _ => held _ (g i).2))

/-- Reach along the successor of counting rises. -/
theorem counting_reach_lt {x y : Nat} (h : «及» (fun m n : Nat => n = m + 1) x y) : x < y := by
  induction h with
  | one r => exact Eq.subst (motive := fun w => _ < w) r.symm (Nat.lt_succ_self _)
  | more r _ ih => exact Nat.lt_trans (Eq.subst (motive := fun w => _ < w) r.symm (Nat.lt_succ_self _)) ih

/-- **Without cycles, a line goes on where no list bounds it (无环而不穷之例).** Counting up: nothing
reaches itself, and the line from zero never ends. -/
theorem «无环而不穷之例» :
    ∃ (R : «际» Nat), «无环» R ∧ «不穷» R «一» 0 :=
  ⟨fun m n => n = m + 1, fun x h => Nat.lt_irrefl x (counting_reach_lt h),
   fun y _ => ⟨y + 1, rfl, trivial⟩⟩

/-- **In bounded room, a line that comes back goes on (返而不穷之例).** Day and night: a list of two holds
everything, the line from `false` never ends, and it comes back to `false`. -/
theorem «返而不穷之例» :
    ∃ (R : «际» Bool), (∀ y, y ∈ [false, true]) ∧ «不穷» R «一» false ∧ «相续» R «一» false false :=
  ⟨fun a b => b = !a, fun y => match y with
    | false => .head _
    | true => .tail _ (.head _),
   («昼夜往来不穷» false).1, .more ⟨rfl, trivial⟩ (.one ⟨rfl, trivial⟩)⟩

/-- **Finite, everything with a successor, and not returning (有限遍后而不返之例).** Two occurrences,
both continued by the second: two occurrences hold everything and everything has a successor, the
relation merges (`«定前»` fails), and the first does not return. -/
theorem «有限遍后而不返之例» :
    ∃ (R : «际» Bool), (∀ y, y ∈ [false, true]) ∧ (∀ x, ∃ y, R x y) ∧ ¬ «定前» R ∧
      ¬ «及» R false false := by
  refine ⟨fun _ b => b = true, fun y => match y with
    | false => .head _
    | true => .tail _ (.head _), fun _ => ⟨true, rfl⟩,
    fun h => Bool.noConfusion («定前之逐点».mp h false true true rfl rfl), fun h => ?_⟩
  have lands : ∀ {x y : Bool}, «及» (fun _ b : Bool => b = true) x y → y = true := by
    intro x y h
    induction h with
    | one r => exact r
    | more _ _ ih => exact ih
  exact Bool.noConfusion (lands h)

/-- **Everything with a successor, nothing merged, and nothing returning (遍后定前而无环之例).**
Counting up: everything has a successor, the predecessor is fixed, and nothing reaches itself, so no
list holds everything (`«有限遍后定前则皆返»`). -/
theorem «遍后定前而无环之例» :
    ∃ (R : «际» Nat), (∀ x, ∃ y, R x y) ∧ «定前» R ∧ «无环» R :=
  ⟨fun m n => n = m + 1, fun x => ⟨x + 1, rfl⟩,
   «定前之逐点».mpr fun _ _ _ r r' => Nat.succ.inj (r.symm.trans r'),
   fun x h => Nat.lt_irrefl x (counting_reach_lt h)⟩

end Room

section Distinction

variable {α : Type u}

/-! ## Alteration and the relation that parts it (design G05, G07, G17, G20) -/

/-- **No alteration exactly where nothing parts a continuation (无异当且仅当不分续).** Nothing alters
from `E` under `F` (no `«异» R E F`) exactly where `F` tells apart the two ends of no continuation
under `E` (up to double negation). One unfolding of `«异»`, pure logic, for any `F`, a class or not.
Where `F` holds everywhere, nothing alters (`«平等无异»`). Read for 「乾坤毀，則无以見易；易不可見，
則乾坤或幾乎息矣」 (XCS-12-012) [AI reading], with 乾坤 read as the two classes of one distinction. -/
theorem «无异当且仅当不分续» {R E F : «际» α} :
    (∀ x y, ¬ «异» R E F x y) ↔ ∀ x y, «续» R E x y → ¬¬ F x y :=
  ⟨fun none x y c apart => none x y ⟨c, apart⟩, fun kept x y ⟨c, apart⟩ => kept x y c apart⟩

/-- **Where identity parts a continuation, there is alteration (静分续而有异之例).** Day and night
under the one, told apart by identity: the step from one to the other alters. -/
theorem «静分续而有异之例» : «异» (fun a b : Bool => b = !a) «一» «静» false true :=
  ⟨⟨rfl, trivial⟩, fun h => Bool.noConfusion h⟩

/-- **A class not constant is not within its core (非有常之类不含于核之例).** Two occurrences, the
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

/-! ## Conditions and dependence (design G08, G09, G10) -/

section Dependence

variable {α : Type u}

/-- **Nothing begins under the one exactly where nothing is without a condition
(皆不生当且仅当皆非无缘).** That nothing begins under the one is that no occurrence is without a
condition (not-not conditioned). One unfolding of `«生»` (two lines from `«一之生»`). So 「無緣即不起」
(JSZ-C-016) [AI reading] states a premise of the model, not a law of the grammar, as the candidates
found for 「一切物皆從眾緣生」 (`«从缘生非文法之律»`): the grammar admits an occurrence with no condition. -/
theorem «皆不生当且仅当皆非无缘» (R : «际» α) :
    (∀ y, ¬ «生» R «一» y) ↔ ∀ y, ¬¬ ∃ x, R x y :=
  ⟨fun h y none => h y (fun ⟨x, r, _⟩ => none ⟨x, r⟩),
   fun h y begins => h y (fun ⟨x, r⟩ => begins ⟨x, r, trivial⟩)⟩

/-- `Q` depends on `P` along `R` (依): every occurrence with `Q` has a condition with `P`. It is
one-way: `«依» R P Q` does not give `«依» R Q P`. -/
def «依» (R : «际» α) (P Q : α → Prop) : Prop := ∀ y, Q y → ∃ x, R x y ∧ P x

/-- **Where `Q` depends on `P` and nothing is `P`, nothing is `Q` (所依无则依者无).** One unfolding of
`«依»`. Read for 「離心則無六塵境界」 (QXL-JS-119), 「離見則無境界」 (QXL-JS-085) and the 起信论's other
units of the form 離 X 則無 Y [AI reading], with the dependence the text states (以依 X 故有 Y) as the
premise. -/
theorem «所依无则依者无» {R : «际» α} {P Q : α → Prop} (dep : «依» R P Q) (none : ¬ ∃ x, P x) :
    ¬ ∃ y, Q y :=
  fun ⟨y, q⟩ => match dep y q with | ⟨x, _, p⟩ => none ⟨x, p⟩

/-- **Dependences compose (依之传).** If `Q` depends on `P` along `R` and `S` on `Q` along `R'`, then
`S` depends on `P` along `R` then `R'`. Two unfoldings of `«依»` and `«而»`. Read for the chain
「以無明滅故心無有起，以無起故境界隨滅」 (QXL-JS-197) [AI reading]. -/
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

/-- **In a net without cycles nothing is co-present (无环则无俱有).** Where nothing reaches itself, no
two occurrences condition each other and none is co-present: G10's net where the Z of `«相由则俱有»`
fails and its Y fails, for every net without cycles. A corollary: one transitivity step of reach. -/
theorem «无环则无俱有» {R : «际» α} (acyclic : «无环» R) {x y : α} : ¬ «俱有» R x y :=
  fun ⟨a, b⟩ => acyclic x («及之传递» a b)

end Dependence

/-! ## Abiding, ending and constancy (design G08, G11, G13, G14, G16) -/

section Positions

/-- **A beginning and an ending at once (生亡并之例).** One occurrence with no relation begins and ends
under the one: it has no condition and no result. Without a condition it does not abide
(`«生住不并»`), and without a result it ends (斷, read as ending under the one). Read against
「若無因而有萬物者，是則為常」 (ZL-01-099) [AI reading]: false as read, whether 常 is read as abiding
under every class or as never ending. -/
theorem «生亡并之例» : ∃ (R : «际» Unit), «生» R «一» () ∧ «亡» R «一» () :=
  ⟨fun _ _ => False, fun ⟨_, r, _⟩ => r, fun ⟨_, r, _⟩ => r⟩

/-- **Ending under identity and abiding under the one (亡于静而住于一之例).** Counting, at one: it has a
condition and a result and is not its own condition, so it ends under identity and abides under the
one (`«四相俱时»`). Read against 「若無常即墮斷邊」 (ZL-21-113) [AI reading], with 無常 as not abiding
under identity and 斷 as ending under the one: false as read. -/
theorem «亡于静而住于一之例» :
    ∃ (R : «际» Nat) (x : Nat), «亡» R «静» x ∧ «住» R «一» x :=
  match «四相俱时» (R := fun m n : Nat => n = m + 1) (x := 0) (y := 1) (z := 2)
      (fun h => Nat.noConfusion (Nat.succ.inj h)) rfl rfl with
  | ⟨_, ends, abides, _⟩ => ⟨fun m n => n = m + 1, 1, ends, abides⟩

/-- **Without a condition it does not abide, while another goes on (无缘不住而他有后之例).** Zero
conditions one, and two has no condition: two abides under no class, and zero has a successor. Read
against 「若離業有果報，則有斷常」 (ZL-17-051) [AI reading], with the result as two and a deed as zero:
the result is not 常 and the deed is not 斷, so false as read. -/
theorem «无缘不住而他有后之例» :
    ∃ (R : «际» Nat), (∀ x, ¬ R x 2) ∧ (∀ E, ¬ «住» R E 2) ∧ «有后» R «一» 0 :=
  have none : ∀ x : Nat, ¬ (x = 0 ∧ (2 : Nat) = 1) := fun _ ⟨_, h⟩ => Nat.noConfusion (Nat.succ.inj h)
  ⟨fun a b => a = 0 ∧ b = 1, none, fun _ ⟨⟨x, r, _⟩, _⟩ => none x r, ⟨1, ⟨rfl, rfl⟩, trivial⟩⟩

/-- **Its own condition, it begins under no class (自缘而不生之例).** One occurrence that is its own
condition: under every class it abides (`«自缘则常»`), so it begins under none (`«生住不并»`). Read
against 「若決定有去、有去者，應有初發」 (ZL-02-070) [AI reading], with own position read as own
condition: false as read. -/
theorem «自缘而不生之例» : ∃ (R : «际» Unit), R () () ∧ ∀ E, «类» E → ¬ «生» R E () :=
  ⟨«一», trivial, fun _ hE begins => «生住不并» ⟨begins, «自缘则常» trivial hE⟩⟩

/-- **With a predecessor, not constant, and ending (有前不有常而亡之例).** The short line: `true` has a
predecessor under the one, the one is not constant on the line (`«有亡之续则不有常»`), and `true`
ends. -/
theorem «有前不有常而亡之例» :
    «有前» Map.short «一» true ∧ ¬ «有常» Map.short «一» ∧ «亡» Map.short «一» true :=
  ⟨⟨false, ⟨rfl, rfl⟩, trivial⟩, «有亡之续则不有常» ⟨⟨rfl, rfl⟩, trivial⟩ Map.short_end, Map.short_end⟩

/-- **Not constant, and never ending (不有常而不穷之例).** Counting up beside a lone occurrence, under
the one: the one is not constant, yet the line from one never ends. Read against 「不爾，便無恒相持用」
(CWS-P6+P7+P8-020) [AI reading], the converse of G11's law: false as read. So constancy is
sufficient for a line that never ends (`«有常则往不穷»`), not necessary. -/
theorem «不有常而不穷之例» :
    ∃ (R : «际» (Option Nat)), ¬ «有常» R «一» ∧ «有前» R «一» (some 1) ∧ «不穷» R «一» (some 1) := by
  let R : «际» (Option Nat) := fun a b => ∃ m, a = some m ∧ b = some (m + 1)
  have fwd : ∀ m : Nat, R (some m) (some (m + 1)) := fun m => ⟨m, rfl, rfl⟩
  have onLine : ∀ {a b : Option Nat}, «相续» R «一» a b → ∃ c, b = some c := by
    intro a b l
    induction l with
    | one c' => match c'.1 with | ⟨m, _, hb⟩ => exact ⟨m + 1, hb⟩
    | more _ _ ih => exact ih
  refine ⟨R, fun hc => ?_, ⟨some 0, fwd 0, trivial⟩, fun y reach => ?_⟩
  · match («有常之逐点» R «一»).mp hc (some 0) none trivial (some 1) (fwd 0) with
    | ⟨_, ⟨_, h, _⟩, _⟩ => exact nomatch h
  · match reach with
    | .inl e => exact ⟨some 2, Eq.subst (motive := fun w => R w (some 2)) e (fwd 1), trivial⟩
    | .inr l => match onLine l with
      | ⟨c, e⟩ =>
        exact ⟨some (c + 1), Eq.subst (motive := fun w => R w (some (c + 1))) e.symm (fwd c), trivial⟩

end Positions

/-! ## Marks, conditions together, images (design G18, G19, G22) -/

section Marks

/-- **No mark, and its complement no mark (无相而非亦无相之例).** What holds everywhere has no mark
(`«遍而无相»`), and its complement, holding nowhere, has none either: where the mark fails, its
complement's fails too (`«有相则非亦有相»`). -/
theorem «无相而非亦无相之例» : ∃ (P : Unit → Prop), ¬ «有相» P ∧ ¬ «有相» (fun x => ¬ P x) :=
  ⟨fun _ => True, «遍而无相» (fun _ => trivial), fun ⟨⟨_, np⟩, _⟩ => np trivial⟩

/-- **Nothing conditions and nothing is conditioned (无能无所之例).** The empty net: where nothing
precedes, nothing follows (`«能所相待»`). -/
theorem «无能无所之例» : ∃ (R : «际» Unit), (¬ ∃ x, «能» R x) ∧ ¬ ∃ y, «所» R y :=
  ⟨fun _ _ => False, fun ⟨_, _, r⟩ => r, fun ⟨_, _, r⟩ => r⟩

/-- **The image does not keep (像不保之例).** A balance that reverses: the image of "heavier than"
under reversal is not within "hangs lower than" (`«保之像»`). -/
theorem «像不保之例» : ¬ «则» («像» (fun b : Bool => !b) (fun a b => a = true ∧ b = false))
    (fun p q => p = true ∧ q = false) :=
  fun within => match within false true ⟨true, false, rfl, ⟨rfl, rfl⟩, rfl⟩ with
    | ⟨h, _⟩ => Bool.noConfusion h

end Marks

/-! ## Ends and beginnings along the core (design G11, G15) -/

section Limits

variable {α : Type u}

/-- **Under a relation within a class and constant under 缘, lines follow each other
(类内有常则线相随).** A line from `u'` under the class `E` is matched, place by place, by a line under
`E` from anything `u'` is related to by `S`, where `S` lies within `E` and is constant under 缘; its
end is related by `S` to the matched end. `S` need not be symmetric. A derivation of its own (by
induction on the line). -/
theorem «类内有常则线相随» {R E S : «际» α} (hE : «类» E) (hSE : «则» S E) (hc : «有常» R S) :
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

/-- **What the core puts together never ends alike (核同则同不穷).** For a class `E`, what the core
puts with an occurrence whose line under `E` never ends has a line under `E` that never ends, as
`«亡于核下不变»` keeps ending along the core. At the converse net it keeps beginninglessness along the
core of the converse net, as `«生于逆核下不变»` keeps beginning there. A derivation of its own. Read for
「如來藏無有後際，諸佛所得涅槃與之相應則無後際」 (QXL-JS-326) [AI reading], with 相應 read as lying in
one class of the core. -/
theorem «核同则同不穷» {R E : «际» α} (hE : «类» E) {y y' : α} (hk : «核» R E y y')
    (endless : «不穷» R E y) : «不穷» R E y' :=
  match hk with
  | ⟨S, hSE, hs, hc, hyy⟩ => fun z' reach =>
    have matched : ∃ z, (y = z ∨ «相续» R E y z) ∧ S z' z := match reach with
      | .inl e => ⟨y, .inl rfl, Eq.subst (motive := fun w => S w y) e (hs _ _ hyy)⟩
      | .inr line => match «类内有常则线相随» hE hSE hc line (hs _ _ hyy) with
        | ⟨z, l, s⟩ => ⟨z, .inr l, s⟩
    match matched with
    | ⟨z, onY, s⟩ => match endless z onY with
      | ⟨w, r, e⟩ => match («有常之逐点» R S).mp hc z z' (hs _ _ s) w r with
        | ⟨w', r', s'⟩ => ⟨w', r', hE.trans (hE.trans (hSE _ _ s) e) (hSE _ _ s')⟩

/-- **A beginning is not kept along the core of the forward net (生于核下可变之例).** Three
occurrences, the third conditioning the second: the first and the second have no successor, so the
core of the one puts them together, yet the first begins and the second does not. A beginning is kept
along the core of the converse net (`«生于逆核下不变»`), not along the forward core. -/
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

/-- **Never ending beside ending, apart under the core (不穷与亡不同核之例).** A loop beside a lone
occurrence: the line from the loop never ends, the lone occurrence ends, and the core does not put
them together, since ending is kept along the core (`«亡于核下不变»`). -/
theorem «不穷与亡不同核之例» :
    ∃ (R : «际» (Option Unit)), «不穷» R «一» (some ()) ∧ «亡» R «一» none ∧
      ¬ «核» R «一» (some ()) none := by
  let R : «际» (Option Unit) := fun a b => a = some () ∧ b = some ()
  have lands : ∀ {a b : Option Unit}, «相续» R «一» a b → b = some () := by
    intro a b l
    induction l with
    | one c => exact c.1.2
    | more _ _ ih => exact ih
  have ends : «亡» R «一» none := fun ⟨_, r, _⟩ => nomatch r.1
  refine ⟨R, fun y on => ?_, ends, fun hk => ?_⟩
  · have hy : y = some () := match on with
      | .inl e => e.symm
      | .inr l => lands l
    exact ⟨some (), ⟨hy, rfl⟩, trivial⟩
  · match hk with
    | ⟨S, hSE, hs, hc, h⟩ =>
      exact «亡于核下不变» ⟨fun _ => trivial, fun _ => trivial, fun _ _ => trivial⟩
        ⟨S, hSE, hs, hc, hs _ _ h⟩ ends ⟨some (), ⟨rfl, rfl⟩, trivial⟩

/-- **The core of the converse net is not within the core (逆核不含于核之例).** Three occurrences: `0`
and `1` have no condition, `0` conditions `2`, and `1` conditions nothing. The core of the converse
net puts `0` and `1` together; the core does not, nor therefore the two-way core (`«位核含于核»`). So
`«生于逆核下不变»` reaches pairs that `«生于位核下不变»` does not. -/
theorem «逆核不含于核之例» :
    ∃ (R : «际» Nat), «核» («逆» R) «一» 0 1 ∧ ¬ «核» R «一» 0 1 := by
  let R : «际» Nat := fun a b => a = 0 ∧ b = 2
  refine ⟨R, ⟨fun u v => (u = 0 ∨ u = 1) ∧ (v = 0 ∨ v = 1), fun _ _ _ => trivial,
    fun _ _ ⟨a, b⟩ => ⟨b, a⟩, ?_, ⟨.inl rfl, .inr rfl⟩⟩, ?_⟩
  · apply («有常之逐点» («逆» R) _).mpr
    intro u u' ⟨hu, _⟩ v r
    match hu with
    | .inl h => exact absurd (h.symm.trans r.2) (fun e => Nat.noConfusion e)
    | .inr h => exact absurd (h.symm.trans r.2) (fun e => Nat.noConfusion (Nat.succ.inj e))
  · intro ⟨S, _, hs, hc, s01⟩
    match («有常之逐点» R S).mp hc 0 1 s01 2 ⟨rfl, rfl⟩ with
    | ⟨_, ⟨h, _⟩, _⟩ => exact Nat.noConfusion h

/-- **Without a beginning and still ending (无始而有终之例).** Counting down to zero: going back from
zero never ends, and zero ends. Read for 「染法從無始已來熏習不斷，乃至得佛後則有斷」 (QXL-JS-238)
[AI reading]: 無始 does not give 無終. -/
theorem «无始而有终之例» : ∃ (R : «际» Nat), «不穷» («逆» R) «一» 0 ∧ «亡» R «一» 0 :=
  ⟨fun m n => m = n + 1, fun y _ => ⟨y + 1, rfl, trivial⟩, fun ⟨_, r, _⟩ => Nat.noConfusion r⟩

/-- **What depends on the beginningless can begin (依于无始而有始之例).** Counting down to the first
of a kind, which conditions one occurrence of another kind: under the class that tells the two kinds
apart, going back from the first never ends, the other occurrence depends on that kind, and it
begins. The verdict needs a class that tells the kinds apart: under the one the other occurrence has a
predecessor. Read for 「以如來藏無前際故，無明之相亦無有始」 (QXL-JS-324) [AI reading]: dependence on what
has no 前際 does not give no 前際. -/
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

/-- **Holding together (相须之例).** Three bits, the first two compared by two classes: a point goes on
(to any point with its first two bits) only where its first two bits agree. The joint class (first two
bits alike) is constant and neither class alone is, and the joint class is not identity: it puts
together two distinct points. -/
theorem «相须之例» :
    «相须» (fun (u v : Bool × Bool × Bool) => u.1 = u.2.1 ∧ v.1 = u.1 ∧ v.2.1 = u.2.1)
      (fun u v => u.1 = v.1) (fun u v => u.2.1 = v.2.1) ∧
    «合» (fun (u v : Bool × Bool × Bool) => u.1 = v.1) (fun u v => u.2.1 = v.2.1)
      (false, false, false) (false, false, true) ∧
    (false, false, false) ≠ ((false, false, true) : Bool × Bool × Bool) := by
  refine ⟨⟨?_, fun hc => ?_, fun hc => ?_⟩, ⟨rfl, rfl⟩,
    fun h => Bool.noConfusion (congrArg (fun p : Bool × Bool × Bool => p.2.2) h)⟩
  · apply («有常之逐点» _ _).mpr
    intro u u' ⟨h1, h2⟩ v ⟨r1, r2, r3⟩
    exact ⟨v, ⟨h1.symm.trans (r1.trans h2), r2.trans h1, r3.trans h2⟩, rfl, rfl⟩
  · match («有常之逐点» _ _).mp hc (false, false, false) (false, true, false) rfl (false, false, false)
        ⟨rfl, rfl, rfl⟩ with
    | ⟨_, ⟨h, _⟩, _⟩ => exact Bool.noConfusion h
  · match («有常之逐点» _ _).mp hc (false, false, false) (true, false, false) rfl (false, false, false)
        ⟨rfl, rfl, rfl⟩ with
    | ⟨_, ⟨h, _⟩, _⟩ => exact Bool.noConfusion h

end Limits

end Becoming
