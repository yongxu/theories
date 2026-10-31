import Becoming.GrammarCandidates
import Becoming.GrammarLaws

/-!
# The corpus's conditional laws in the grammar (丙一之律) — OU5 design scratch

Board item OU5, part A (`development/ou5-conditional-laws/DESIGN.md`). The units classed 丙一 are
placed in families of laws; this file proves, outside the package, the laws and witnesses the design
proposes. Each docstring says what kind of law it is: one unfolding of the definitions, a corollary of
existing laws, or a derivation of its own. A general law's name states its statement in the grammar's
words. Which unit states which law is an AI reconstruction (`data/groups.tsv`), so a law's reading
stands in its docstring, marked [AI reading], and not in its name; the classical text decides
nothing, and Lean checks only the derivation. The checks the design cites are in the scratch module
`GrammarConditionalsChecks`.
-/

namespace Becoming

universe u

section Change

variable {α : Type u}

/-! ## Ending, alteration and passing through (design G01, G06) -/

/-- **What ends under a class and continues under another alters (亡而续于他类则异).** It continues
under the second, and the first tells its two ends apart. One unfolding of `«异»` and `«亡»`: the
mirror, on the side of what comes after, of `«生于细而续于粗则异»`. Read for 「易窮則變」 (XCX-02-008)
[AI reading], with 窮 read as ending under a class and 變 as alteration. -/
theorem «亡而续于他类则异» {R E F : «际» α} {x y : α} (ends : «亡» R E x) (continues : «续» R F x y) :
    «异» R F E x y :=
  ⟨continues, fun same => ends ⟨y, continues.1, same⟩⟩

/-- **What ends under a class alters exactly where it has a successor (亡者异当且仅当有后).** For what
ends under `E`, altering into a continuation under `F` is having a successor under `F`: one unfolding
of the definitions, with `«亡而续于他类则异»`. Where it has none it does not alter (`«亡而息之例»`). -/
theorem «亡者异当且仅当有后» {R E F : «际» α} {x : α} (ends : «亡» R E x) :
    (∃ y, «异» R F E x y) ↔ «有后» R F x :=
  ⟨fun ⟨y, c, _⟩ => ⟨y, c⟩, fun ⟨y, c⟩ => ⟨y, «亡而续于他类则异» ends c⟩⟩

/-- **Under a class constant both ways, what has a predecessor passes through (两向有常有前则通).**
Where a class is constant under 缘 and under its converse, an occurrence with a predecessor under it
passes through: going never ends and coming never ends. A corollary: constancy gives the successor
(`«有常则续不尽»`), so a predecessor suffices where `«两向有常则通»` takes abiding. The condition is
sufficient, not necessary. Read for 「寂然不動，感而遂通天下之故」 (XCS-10-006) [AI reading], with 感
read as a predecessor reaching it under the class. -/
theorem «两向有常有前则通» {R E : «际» α} (hE : «类» E) (hc : «有常» R E) (hc' : «有常» («逆» R) E)
    {x : α} (affected : «有前» R E x) : «通» R E x :=
  «两向有常则通» hE hc hc' ⟨affected, «有常则续不尽» hc affected⟩

/-- **What ends and continues under a class constant both ways alters, passes through and never ends
(亡而续于两向有常之类则异通不穷).** A conjunction, not an order: the ending gives the alteration (one
unfolding of the definitions), the two-way constancy gives passing through to anything with a
predecessor under `F`, altered or not, and never ending is half of passing through by definition. So
on 變 read as one alteration, 變 does not enter 通. Tested for 「易窮則變，變則通，通則久」
(XCX-02-008) [AI reading]. -/
theorem «亡而续于两向有常之类则异通不穷» {R E F : «际» α} (hF : «类» F) (hc : «有常» R F)
    (hc' : «有常» («逆» R) F) {x y : α} (ends : «亡» R E x) (continues : «续» R F x y) :
    «异» R F E x y ∧ «通» R F y ∧ «不穷» R F y :=
  have passes := «两向有常有前则通» hF hc hc' ⟨x, continues⟩
  ⟨«亡而续于他类则异» ends continues, passes, passes.1⟩

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

/-! ## Generation where every step is parted (design G02) -/

/-- **Where everything has a successor and every step is parted, everything is 全生成
(皆有后而步皆分则全生成).** Where everything is continued under a coarse class `L` and the fine class `E`
parts every step of 缘, the coarse line from anything never ends and a carrying renewal lies ahead of
each of its points. A short derivation from the definition of `«全生成»`; sufficient, not necessary.
Read for 「日往則月來，月往則日來，日月相推而明生焉」 (XCX-04-004) and 「寒暑相推而歲成焉」 (XCX-04-005)
[AI reading], with 相推 read as each step passing from one phase to the other. -/
theorem «皆有后而步皆分则全生成» {R L E : «际» α} (onward : ∀ y, «有后» R L y)
    (leaves : ∀ a b, R a b → ¬ E a b) (x : α) : «全生成» R L E x :=
  ⟨fun y _ => onward y, fun y _ => match onward y with
    | ⟨z, c⟩ => ⟨y, z, .inl rfl, c, fun ⟨w, r, e⟩ => leaves w z r e⟩⟩

/-- **Day and night generate (昼夜全生成).** Two occurrences, each the condition of the other: under
the one and identity, every occurrence is 全生成. A model instance. -/
theorem «昼夜全生成» (x : Bool) : «全生成» (fun a b : Bool => b = !a) «一» «静» x :=
  «皆有后而步皆分则全生成» (R := fun a b : Bool => b = !a) (L := «一») (E := «静»)
    (fun y => ⟨!y, rfl, trivial⟩) (fun a b r e => by cases e; cases a <;> exact Bool.noConfusion r) x

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

/-! ## Alteration and the relation that parts it (design G05, G07) -/

/-- **No alteration exactly where nothing parts a continuation (无异当且仅当不分续).** Nothing alters
from `E` under `F` exactly where `F` tells apart the two ends of no continuation under `E` (up to
double negation). One unfolding of `«异»`, pure logic, for any `F`, a class or not. Where `F` holds
everywhere, nothing alters (`«平等无异»`). Read for 「乾坤毀，則无以見易；易不可見，則乾坤或幾乎息矣」
(XCS-12-012) [AI reading], with 乾坤 read as the two classes of one distinction. -/
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

/-- **In a net without cycles nothing is co-present (无环则无俱有).** A corollary: one transitivity
step of reach. -/
theorem «无环则无俱有» {R : «际» α} (acyclic : «无环» R) {x y : α} : ¬ «俱有» R x y :=
  fun ⟨a, b⟩ => acyclic x («及之传递» a b)

end Dependence

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
core of the converse net. A derivation of its own. Read for 「如來藏無有後際，諸佛所得涅槃與之相應則無後際」
(QXL-JS-326) [AI reading], with 相應 read as lying in one class of the core. -/
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

/-- **A beginning is kept along the core of the converse net (生于逆核下不变).** For a class `E`, what
the core of the converse net puts with an occurrence that begins under `E` begins under `E`. The mirror
of `«亡于核下不变»`; no forward constancy is needed, so it holds wherever `«生于位核下不变»` does, whose
proof uses only the converse constancy, and on pairs the two-way core does not join. A corollary of
the definitions, like `«亡于核下不变»`. -/
theorem «生于逆核下不变» {R E : «际» α} (hE : «类» E) {y y' : α}
    (hk : «核» («逆» R) E y y') (hy : «生» R E y) : «生» R E y' :=
  fun ⟨w', hr, he⟩ => match hk with
    | ⟨S, hSE, hs, hc, hyy⟩ =>
      match («有常之逐点» («逆» R) S).mp hc y' y (hs y y' hyy) w' hr with
      | ⟨w, hrw, hww⟩ =>
        hy ⟨w, hrw, hE.trans (hE.trans (hE.symm (hSE w' w hww)) he) (hE.symm (hSE y y' hyy))⟩

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
