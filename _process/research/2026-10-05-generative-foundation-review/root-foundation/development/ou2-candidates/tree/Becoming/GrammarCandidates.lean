import Becoming.GrammarReadings

/-!
# The corpus's candidate theorems of the grammar, tested (文法之候选定理，检验)

Board item OU2c of the one-unfolding plan (`one-unfolding-root/PLAN.md` §三, §4, §5). The
first-batch classification (`one-unfolding-root/classify/`) marks 59 units as class 乙, candidate
theorems of the grammar. Each is read here, where it reads at all, as a statement about relations
and classes over every carrier, in the terms of `Becoming.Grammar` and `Becoming.GrammarReadings`,
and then proved, refuted by a countermodel, or proved under a premise it needs (then it is really
丙一). The outcome of each unit, with its declaration, is in `ou2-candidates/outcomes.tsv`. Every
reading is an AI reconstruction; the unit's own sense and what the reading loses are recorded
there.

Four families of results carry most of the candidates.

* **Correlatives (相待).** Where the two members are the two ends of one relation (condition and
  result, goer and going, longer and shorter), each is had exactly where the other is
  (`«能所相待»`, `«三法相因待»`, `«因果互即»`); two independent relations have no such law
  (`«二际可偏举»`). Where the two are a mark and its complement (有 and 无, 美 and 惡, 染 and 淨),
  the mark gives its complement (`«有相则非亦有相»`), but the complement gives the mark back only
  under double-negation stability: the symmetric law over every carrier is equivalent to it
  (`«相待之还当且仅当双非可还»`), and holds for a decided two-valued reading (`«二值之相待»`).
* **No own position (无定性).** An occurrence begins under some class and not under another
  exactly when it is not-not conditioned and is not its own condition (`«定性之判»`); its own
  condition abides under every class (`«自缘则常»`). Everything ends under identity (念念滅)
  exactly where nothing is its own condition (`«念念灭当且仅当无自缘»`). So the 中论's readings
  of 「從眾緣生故無定性」 and the 起信论's 「四相俱時」 need one premise, that nothing is its own
  condition, which the grammar does not assume.
* **Precedence (缘先果后).** Every condition strictly precedes its result exactly where the net has
  no cycle (`«缘先果后当且仅当无环»`); a cycle of 缘 is one co-present cluster (`«俱有»`).
* **What no finite test separates (不可致詰).** The core is never separated at a finite stage
  (`«核则不可致诘»`); the converse fails in an infinitely branching net (`«致诘不尽»`) and holds
  where the relation of no separating stage is itself constant (`«不可致诘而有常则混而为一»`).

Every declaration has an empty axiom report.
-/

namespace Becoming

universe u

section Correlatives

variable {α : Type u}

/-- Conditions something (能; 青目's 緣成, ZL-01-132): `x` has a result under `R`. -/
def «能» (R : «际» α) (x : α) : Prop := ∃ y, R x y

/-- Is conditioned (所; 果): `y` has a condition under `R`. -/
def «所» (R : «际» α) (y : α) : Prop := ∃ x, R x y

/-- **The two ends of one relation stand together (能所相待).** Something conditions exactly
where something is conditioned. Read for 「可燃無故燃亦無、燃無故可燃亦無」 (ZL-07-165), 「因去法故有去者，
若先無去法則無去者」 (ZL-02-161), 「去者因去法成，去法因去者成」 (ZL-02-147), 「因去有去者，因去者有去」
(ZL-02-128), 「因去法有去者」 (ZL-02-036), and for 王弼's 「可得而親，則可得而疏」 with 親疏 and 貴賤 as the
two ends of one comparison (LZ-56-003, LZ-56-005). -/
theorem «能所相待» (R : «际» α) : (∃ x, «能» R x) ↔ (∃ y, «所» R y) :=
  ⟨fun ⟨x, y, h⟩ => ⟨y, x, h⟩, fun ⟨y, x, h⟩ => ⟨x, y, h⟩⟩

/-- Being conditioned is conditioning under the converse: the result is the result of its cause,
the cause the cause of its result (「果是即因之果，因是即果之因」, 承遷's note JSZ-C-123; 長短相較,
高下相傾 in LZ-02-003). -/
theorem «因果互即» (R : «际» α) (x y : α) :
    («所» R y ↔ «能» («逆» R) y) ∧ (R x y ↔ «逆» R y x) :=
  ⟨⟨fun ⟨w, h⟩ => ⟨w, h⟩, fun ⟨w, h⟩ => ⟨w, h⟩⟩, ⟨fun h => h, fun h => h⟩⟩

/-- Two relations given apart can be raised one alone (偏舉): the first is inhabited and the second
not. So the law of correlatives is a law of the two ends of one relation only (王弼's 「喜怒同根」),
and fails for a pair such as benefit and harm read as two relations (LZ-56-004). -/
theorem «二际可偏举» : ∃ (β : Type) (B H : «际» β), (∃ x, «能» B x) ∧ ¬ ∃ x, «能» H x :=
  ⟨Unit, «一», fun _ _ => False, ⟨(), (), trivial⟩, fun ⟨_, _, h⟩ => h⟩

/-- Where harm is the converse of benefit (what benefits one is drawn from another, 「同根」), the
two cannot be raised one alone (LZ-56-004, under its premise). -/
theorem «同根则不可偏举» {B H : «际» α} (h : «谓» H («逆» B)) :
    (∃ x, «能» B x) → ∃ y, «能» H y :=
  fun ⟨x, y, b⟩ => ⟨y, x, (h y x).mpr b⟩

/-- Following before and after (前後相隨, LZ-02-003): to have a successor in a line is to have a
predecessor in the converse line. -/
theorem «前后相随» (R E : «际» α) (x : α) : «有后» R E x ↔ «有前» («逆» R) («逆» E) x :=
  ⟨fun ⟨y, r, e⟩ => ⟨y, r, e⟩, fun ⟨y, r, e⟩ => ⟨y, r, e⟩⟩

/-- Mutual answering (相和): the meet of a relation with its converse. -/
def «互» (R : «际» α) : «际» α := «合» R («逆» R)

/-- 音聲相和 (LZ-02-003): mutual answering is symmetric. -/
theorem «互之对称» (R : «际» α) : «则» («互» R) («逆» («互» R)) :=
  fun _ _ ⟨a, b⟩ => ⟨b, a⟩

/-- **Arising and ending wait on each other (生滅相因待, ZL-21-135).** To begin under `E` is to end
under the converse net and class: the two positions are one relation read in two directions. -/
theorem «生亡对偶» (R E : «际» α) (y : α) : «生» R E y ↔ «亡» («逆» R) («逆» E) y :=
  ⟨fun h ⟨x, r, e⟩ => h ⟨x, r, e⟩, fun h ⟨x, r, e⟩ => h ⟨x, r, e⟩⟩

/-- Read as existence, the mutual waiting fails: on the natural numbers with each number a condition
of the next, something begins under the one and nothing ends. -/
theorem «有生不必有亡» :
    ∃ (β : Type) (R : «际» β), (∃ x, «生» R «一» x) ∧ ∀ x, ¬ «亡» R «一» x :=
  ⟨Nat, fun n m => m = n + 1, ⟨0, fun ⟨_, r, _⟩ => Nat.noConfusion r⟩,
   fun x h => h ⟨x + 1, rfl, trivial⟩⟩

/-- Three that wait on one another (相因待, ZL-02-166): with `A` from goer to going and `B` from
going to place, the goer of a composed going. -/
def «作者» (A B : «际» α) (x : α) : Prop := ∃ g p, A x g ∧ B g p

/-- The going (去法) of a composed going. -/
def «作业» (A B : «际» α) (g : α) : Prop := ∃ x p, A x g ∧ B g p

/-- The place gone to (所去處) of a composed going. -/
def «处所» (A B : «际» α) (p : α) : Prop := ∃ x g, A x g ∧ B g p

/-- **去法、去者、所去處，是法皆相因待 (ZL-02-166).** The three positions of one composed relation are
had together: each is inhabited exactly where the others are. -/
theorem «三法相因待» (A B : «际» α) :
    ((∃ x, «作者» A B x) ↔ (∃ g, «作业» A B g)) ∧ ((∃ g, «作业» A B g) ↔ (∃ p, «处所» A B p)) :=
  ⟨⟨fun ⟨x, g, p, a, b⟩ => ⟨g, x, p, a, b⟩, fun ⟨g, x, p, a, b⟩ => ⟨x, g, p, a, b⟩⟩,
   ⟨fun ⟨g, x, p, a, b⟩ => ⟨p, x, g, a, b⟩, fun ⟨p, x, g, a, b⟩ => ⟨g, x, p, a, b⟩⟩⟩

/-- Not a condition of a result (非緣, ZL-01-204): `x` is not a condition of `y`, and `y` is a
result. A non-condition is said of a result, as the 中论's 「非緣」 is a non-condition of a fruit. -/
def «非缘» (R : «际» α) (x y : α) : Prop := ¬ R x y ∧ «所» R y

/-- **無果故，緣非緣亦無 (ZL-01-204).** Where nothing is a result, nothing is a condition and nothing is
a non-condition of a result. -/
theorem «无果则缘非缘皆无» (R : «际» α) (h : ¬ ∃ y, «所» R y) :
    (¬ ∃ x, «能» R x) ∧ ¬ ∃ x y, «非缘» R x y :=
  ⟨fun hx => h ((«能所相待» R).mp hx), fun ⟨_, y, _, hy⟩ => h ⟨y, hy⟩⟩

/-- Read with 非緣 as the complement of 緣, the second half fails: where nothing is a result,
everything is a non-condition. -/
theorem «无果则皆非能» (R : «际» α) (h : ¬ ∃ y, «所» R y) : ∀ x, ¬ «能» R x :=
  fun x hx => h ((«能所相待» R).mp ⟨x, hx⟩)

/-- **Time apart from going is not had (離去法去時不可得, ZL-02-018).** Reach, of which the order of
time is the strict part, relates only what conditions to what is conditioned. -/
theorem «及之两端» {R : «际» α} {x y : α} (h : «及» R x y) : «能» R x ∧ «所» R y := by
  induction h with
  | one r => exact ⟨⟨_, r⟩, ⟨_, r⟩⟩
  | more r _ ih => exact ⟨⟨_, r⟩, ih.2⟩

/-- **因去故有住 (ZL-07-213).** Abiding is had through going on: what abides is continued and
continues, and a stop (ending with a predecessor) has a going before it. -/
theorem «住因于续» {R E : «际» α} {x : α} :
    («住» R E x → «有前» R E x ∧ «有后» R E x) ∧
      («有前» R E x ∧ «亡» R E x → ∃ w, «续» R E w x) :=
  ⟨fun h => h, fun ⟨⟨w, c⟩, _⟩ => ⟨w, c⟩⟩

end Correlatives

section Marks

variable {α : Type u}

/-- A mark (相, lakṣaṇa): `P` tells something apart, holding of something and failing of
something. -/
def «有相» (P : α → Prop) : Prop := (∃ x, P x) ∧ ∃ y, ¬ P y

/-- **天下皆知美之為美，斯惡已 (LZ-02-001; 皆知善之為善，斯不善已, LZ-02-002).** To know a mark as a
mark is to have its complement: what is known as telling apart has something it fails of. -/
theorem «知相则有其非» {P : α → Prop} (h : «有相» P) : ∃ y, ¬ P y := h.2

/-- **若離不覺之心，則無真覺自相可說 (QXL-JS-073).** Where nothing falls outside a mark, it has no mark
to be said. -/
theorem «离非无相» {P : α → Prop} (h : ¬ ∃ y, ¬ P y) : ¬ «有相» P :=
  fun hm => h hm.2

/-- **若無色者，則無虛空之相 (QXL-JS-303).** Where nothing is form, the absence of form has no mark. -/
theorem «无色则无虚空之相» {P : α → Prop} (h : ¬ ∃ x, P x) : ¬ «有相» (fun x => ¬ P x) :=
  fun ⟨_, ⟨y, nny⟩⟩ => nny (fun py => h ⟨y, py⟩)

/-- A mark gives its complement a mark (有生無: from 有 to 無, LZ-02-003). -/
theorem «有相则非亦有相» {P : α → Prop} (h : «有相» P) : «有相» (fun x => ¬ P x) :=
  match h with
  | ⟨⟨x, px⟩, ⟨y, npy⟩⟩ => ⟨⟨y, npy⟩, ⟨x, fun n => n px⟩⟩

/-- Bool-valued truth: not true, so false. -/
theorem «非真则假» {b : Bool} (h : ¬ b = true) : b = false :=
  match b, h with
  | false, _ => rfl
  | true, h => absurd rfl h

/-- Bool-valued truth: not false, so true. -/
theorem «非假则真» {b : Bool} (h : ¬ b = false) : b = true :=
  match b, h with
  | true, _ => rfl
  | false, h => absurd rfl h

/-- **Correlatives of a decided reading stand together both ways (二值之相待).** For a two-valued
reading, its two cells have a mark exactly together. -/
theorem «二值之相待» (f : α → Bool) : «有相» (fun x => f x = true) ↔ «有相» (fun x => f x = false) :=
  ⟨fun ⟨⟨x, hx⟩, ⟨y, hy⟩⟩ => ⟨⟨y, «非真则假» hy⟩, ⟨x, fun h => Bool.noConfusion (h.symm.trans hx)⟩⟩,
   fun ⟨⟨x, hx⟩, ⟨y, hy⟩⟩ => ⟨⟨y, «非假则真» hy⟩, ⟨x, fun h => Bool.noConfusion (hx.symm.trans h)⟩⟩⟩

/-- A predicate on two points: false at the first, `Q` at the second. -/
def «二点» (Q : Prop) : Bool → Prop
  | false => False
  | true => Q

/-- **The return of correlatives is double-negation stability (相待之还当且仅当双非可还).** That the
complement's mark gives the mark back, for every carrier and mark (有無相生 both ways, LZ-02-003;
染淨相待, QXL-JS-331), is equivalent to `¬¬Q → Q` for every proposition. -/
theorem «相待之还当且仅当双非可还» :
    (∀ (β : Type) (P : β → Prop), «有相» (fun x => ¬ P x) → «有相» P) ↔ ∀ Q : Prop, ¬¬Q → Q := by
  constructor
  · intro h Q nnq
    match h Bool («二点» Q) ⟨⟨false, fun f => f⟩, ⟨true, nnq⟩⟩ with
    | ⟨⟨false, pa⟩, _⟩ => exact False.elim pa
    | ⟨⟨true, pa⟩, _⟩ => exact pa
  · intro dne β P ⟨⟨x, npx⟩, ⟨y, nnpy⟩⟩
    exact ⟨⟨y, dne _ nnpy⟩, ⟨x, npx⟩⟩

/-- **Holding of all, a predicate tells nothing apart (雖實有此諸功德義，而無差別之相, QXL-JS-247).** -/
theorem «遍而无相» {P : α → Prop} (h : ∀ x, P x) : ¬ «有相» P :=
  fun ⟨_, ⟨y, npy⟩⟩ => npy (h y)

/-- **Mistaking relative to a reference (依覺故迷，若離覺性則無不覺, QXL-JS-072).** Being lost takes as alike
what the reference tells apart (`«成坏»` read as mistaking); where the reference tells nothing
apart (the one), there is no mistaking. -/
theorem «离方无迷» (E : «际» α) (x y : α) : ¬ «成坏» E «一» x y :=
  fun h => h.2 trivial

/-- Read with 不覺 as the complement of 覺, the unit's second half fails: where nothing is awake,
everything is not awake. -/
theorem «离觉则皆不觉» {A : α → Prop} (h : ¬ ∃ x, A x) : ∀ x, ¬ A x :=
  fun x hx => h ⟨x, hx⟩

/-- An initial awakening (始覺): awake, with a condition that is not awake. -/
def «始觉» (R : «际» α) (A : α → Prop) (y : α) : Prop := A y ∧ ∃ x, R x y ∧ ¬ A x

/-- **依不覺故說有始覺 (QXL-JS-038).** An initial awakening is said only where there is non-awakening. -/
theorem «始觉依不觉» {R : «际» α} {A : α → Prop} {y : α} (h : «始觉» R A y) : ∃ x, ¬ A x ∧ R x y :=
  match h with
  | ⟨_, x, r, n⟩ => ⟨x, n, r⟩

end Marks

section Positions

variable {α : Type u}

/-- Identity is a class. -/
theorem «静之为类» : «类» («静» : «际» α) := ⟨fun _ => rfl, Eq.symm, Eq.trans⟩

/-- No own position (無定性): `x` begins under some class and not under another. -/
def «无定性» (R : «际» α) (x : α) : Prop :=
  ∃ E₁ E₂ : «际» α, «类» E₁ ∧ «类» E₂ ∧ «生» R E₁ x ∧ ¬ «生» R E₂ x

/-- **When a position depends on the class (定性之判).** An occurrence has no own position exactly
when it is not-not conditioned and is not its own condition. Read for 「諸法從眾緣生故自無定性」
(ZL-01-183), 「若法眾緣生，即是寂滅性」 (ZL-07-159), 「從眾緣生法無自性」 (ZL-07-166): with a condition,
the conclusion needs the premise that `x` is not its own condition (不自生). -/
theorem «定性之判» {R : «际» α} {x : α} : «无定性» R x ↔ (¬¬ ∃ w, R w x) ∧ ¬ R x x := by
  constructor
  · intro ⟨E₁, _, h₁, _, b, nb⟩
    exact ⟨fun n => nb (fun ⟨w, r, _⟩ => n ⟨w, r⟩), fun rxx => b ⟨x, rxx, h₁.refl x⟩⟩
  · intro ⟨nn, nr⟩
    refine ⟨«静», «一», «静之为类», «一为类», ?_, ?_⟩
    · intro ⟨w, r, e⟩
      cases e
      exact nr r
    · intro b
      exact nn (fun ⟨w, r⟩ => b ⟨w, r, trivial⟩)

/-- So what comes from a condition and is not its own condition has no own position. -/
theorem «缘生而不自生则无定性» {R : «际» α} {x : α} (hc : ∃ w, R w x) (nr : ¬ R x x) :
    «无定性» R x :=
  «定性之判».mpr ⟨fun n => n hc, nr⟩

/-- **Its own condition holds a position under every class (自缘则常).** What conditions itself abides
under every class: it neither begins nor ends (「若法無成無壞，是法應或無或常」, ZL-21-058). -/
theorem «自缘则常» {R : «际» α} {x : α} (h : R x x) {E : «际» α} (hE : «类» E) : «住» R E x :=
  ⟨⟨x, h, hE.refl x⟩, ⟨x, h, hE.refl x⟩⟩

/-- **Thread from hemp, cloth from thread (從縷有布、從麻有縷, ZL-07-164).** A middle link that is not its own
condition abides under the one and begins and ends under identity. -/
theorem «缕之无定性» {R : «际» α} {x y z : α} (nr : ¬ R y y) (hxy : R x y) (hyz : R y z) :
    «住» R «一» y ∧ «生» R «静» y ∧ «亡» R «静» y :=
  ⟨⟨⟨x, hxy, trivial⟩, ⟨z, hyz, trivial⟩⟩,
   fun ⟨w, r, e⟩ => by cases e; exact nr r,
   fun ⟨w, r, e⟩ => by cases e; exact nr r⟩

/-- **The four positions at once (四相俱時而有，皆無自立, QXL-JS-049).** An occurrence with a condition and
a consequence, not its own condition, begins and ends under identity, abides under the one, and
alters into its consequence under the one while identity tells them apart. -/
theorem «四相俱时» {R : «际» α} {x y z : α} (nr : ¬ R y y) (hxy : R x y) (hyz : R y z) :
    «生» R «静» y ∧ «亡» R «静» y ∧ «住» R «一» y ∧ «异» R «一» «静» y z :=
  match «缕之无定性» nr hxy hyz with
  | ⟨a, b, e⟩ => ⟨b, e, a, ⟨hyz, trivial⟩, fun q => by cases q; exact nr hyz⟩

/-- **Everything ends at each moment exactly where nothing is its own condition (念念灭当且仅当无自缘).**
「一切有為法念念滅故，無不滅法」 (ZL-07-203) and 「一切有為法常有滅相」 (ZL-01-161), read as ending under
identity, are the premise that nothing conditions itself. -/
theorem «念念灭当且仅当无自缘» (R : «际» α) : (∀ x, «亡» R «静» x) ↔ ∀ x, ¬ R x x :=
  ⟨fun h x r => h x ⟨x, r, rfl⟩, fun h x ⟨_, r, e⟩ => by cases e; exact h x r⟩

/-- **若離於成壞，是亦無有法 (ZL-21-057).** An occurrence begins under some class, and ends under some
class, exactly when it is not its own condition. -/
theorem «有成坏当且仅当不自缘» (R : «际» α) (x : α) :
    ((∃ E, «类» E ∧ «生» R E x) ↔ ¬ R x x) ∧ ((∃ E, «类» E ∧ «亡» R E x) ↔ ¬ R x x) :=
  ⟨⟨fun ⟨_, hE, b⟩ r => b ⟨x, r, hE.refl x⟩,
    fun nr => ⟨«静», «静之为类», fun ⟨_, r, e⟩ => by cases e; exact nr r⟩⟩,
   ⟨fun ⟨_, hE, b⟩ r => b ⟨x, r, hE.refl x⟩,
    fun nr => ⟨«静», «静之为类», fun ⟨_, r, e⟩ => by cases e; exact nr r⟩⟩⟩

/-- **The unconditioned has no mark of its own (無為自無別相, ZL-07-298).** Under any one class, not
beginning, not abiding and not ending hold together of nothing. -/
theorem «无为无别相» (R E : «际» α) (x : α) :
    ¬ (¬ «生» R E x ∧ ¬ «住» R E x ∧ ¬ «亡» R E x) :=
  fun ⟨nb, na, ne⟩ => nb (fun hp => ne (fun hs => na ⟨hp, hs⟩))

/-- **Not everything comes from conditions, and self-conditioning is allowed (一切物皆從眾緣生,
ZL-07-285).** The grammar admits an occurrence with no condition and an occurrence that is its own
condition: both are conditions on a model, not laws. -/
theorem «从缘生非文法之理» :
    (∃ (β : Type) (R : «际» β) (x : β), ∀ w, ¬ R w x) ∧ (∃ (β : Type) (R : «际» β) (x : β), R x x) :=
  ⟨⟨Unit, fun _ _ => False, (), fun _ h => h⟩, ⟨Unit, «一», (), trivial⟩⟩

/-- **若斷，不應相續 (ZL-01-059).** What ends under a class starts no line under it. -/
theorem «断则无相续» {R E : «际» α} {x : α} (h : «亡» R E x) (y : α) : ¬ «相续» R E x y :=
  fun l => match l with
    | .one c => h ⟨_, c⟩
    | .more c _ => h ⟨_, c⟩

end Positions

section Precedence

variable {α : Type u}

/-- **緣成由於果，以果後、緣先故 (ZL-01-132).** Every condition strictly precedes its result (the result
does not reach back to it) exactly where the net has no cycle. -/
theorem «缘先果后当且仅当无环» (R : «际» α) : (∀ x y, R x y → ¬ «及» R y x) ↔ «无环» R := by
  constructor
  · intro h x hxx
    cases hxx with
    | one r => exact h x x r (.one r)
    | more r rest => exact h _ _ r rest
  · intro acyc x y r hyx
    exact acyc x (.more r hyx)

/-- Co-presence (俱有): each reaches the other, the two lie on one cycle of 缘. -/
def «俱有» (R : «际» α) : «际» α := fun x y => «及» R x y ∧ «及» R y x

/-- **相由成立 (JSZ-P-07-029).** Conditions of each other are co-present, and then reach is no strict
order. -/
theorem «相由则俱有» {R : «际» α} {x y : α} (hxy : R x y) (hyx : R y x) :
    «俱有» R x y ∧ ¬ «无环» R :=
  ⟨⟨.one hxy, .one hyx⟩, fun acyc => acyc x (.more hxy (.one hyx))⟩

/-- **同為一念 (JSZ-P-07-030).** Co-presence is symmetric and transitive, and reflexive on what it
relates: one cluster. -/
theorem «俱有为一念» (R : «际» α) :
    (∀ {x y}, «俱有» R x y → «俱有» R y x) ∧
      (∀ {x y z}, «俱有» R x y → «俱有» R y z → «俱有» R x z) ∧
      (∀ {x y}, «俱有» R x y → «俱有» R x x) :=
  ⟨fun ⟨a, b⟩ => ⟨b, a⟩,
   fun ⟨a, b⟩ ⟨c, d⟩ => ⟨«及之传递» a c, «及之传递» d b⟩,
   fun ⟨a, b⟩ => ⟨«及之传递» a b, «及之传递» a b⟩⟩

end Precedence

section SelfOther

variable {α : Type u}

/-- **他性於他亦是自性 (ZL-01-108; 主伴交輝, JSZ-P-07-022).** Under a class, what is other to `x` is
self to itself, and `x` is other to it: self and other turn with the standpoint. -/
theorem «自他随位» {E : «际» α} (hE : «类» E) {x y : α} (h : ¬ E x y) :
    ¬ E y x ∧ E y y ∧ E x x :=
  ⟨fun e => h (hE.symm e), hE.refl y, hE.refl x⟩

/-- **有自故有他 (ZL-01-097), 自無故他亦無 (ZL-01-095).** Under a class, an other is had only where a
self is: where nothing is self, nothing is other. -/
theorem «他依于自» {E : «际» α} (hE : «类» E) :
    ((∃ x y, ¬ E x y) → ∃ x, E x x) ∧ ((¬ ∃ x, E x x) → ¬ ∃ x y, ¬ E x y) :=
  ⟨fun ⟨x, _, _⟩ => ⟨x, hE.refl x⟩, fun h ⟨x, _, _⟩ => h ⟨x, hE.refl x⟩⟩

/-- Read as entailment, 有自故有他 fails: under the one there is self and no other. -/
theorem «有自不必有他» : ∃ (β : Type) (E : «际» β), «类» E ∧ (∃ x, E x x) ∧ ¬ ∃ x y, ¬ E x y :=
  ⟨Unit, «一», «一为类», ⟨(), trivial⟩, fun ⟨_, _, h⟩ => h trivial⟩

end SelfOther

section Grains

variable {α : Type u}

/-- **同異交得 (MJ-J-091).** What a class tells apart is at once alike under the one and apart under
it (同異 together, `«成坏»`). -/
theorem «同异交得» {F : «际» α} {x y : α} (h : ¬ F x y) : «成坏» «一» F x y :=
  ⟨trivial, h⟩

/-- **推而共之，至于无共然后止 (XZ-ZM-054).** The one is a class, every relation lies inside it, and a
relation containing it is it: coarsening stops there. -/
theorem «至于无共然后止» :
    «类» («一» : «际» α) ∧ (∀ E : «际» α, «则» E «一») ∧ ∀ E : «际» α, «则» «一» E → «谓» E «一» :=
  ⟨«一为类», fun _ _ _ _ => trivial, fun _ h x y => ⟨fun _ => trivial, fun _ => h x y trivial⟩⟩

/-- **推而别之，至于无别然后至 (XZ-ZM-057).** Identity lies inside every class, and a class inside
identity is identity: refinement arrives there. -/
theorem «至于无别然后至» :
    (∀ E : «际» α, «类» E → «则» «静» E) ∧ ∀ F : «际» α, «类» F → «则» F «静» → «谓» F «静» :=
  ⟨fun _ hE x _ e => by cases e; exact hE.refl x,
   fun _ hF h x y => ⟨h x y, fun e => by cases e; exact hF.refl x⟩⟩

/-- **物有同状而异所者，有异状而同所者，可别也 (XZ-ZM-061).** Alike under one class and apart under
another, two are told apart by the joint class. -/
theorem «状所可别» {S P : «际» α} {x y : α} (h : (S x y ∧ ¬ P x y) ∨ (¬ S x y ∧ P x y)) :
    ¬ «合» S P x y :=
  fun ⟨s, p⟩ => match h with
    | .inl ⟨_, np⟩ => np p
    | .inr ⟨ns, _⟩ => ns s

/-- **總攝一切法 (QXL-JS-008).** A class covers the carrier: every occurrence lies in its own cell. -/
theorem «门摄一切» {E : «际» α} (hE : «类» E) (x : α) : E x x ∧ «一» x x :=
  ⟨hE.refl x, trivial⟩

/-- **畢竟平等、無有變異 (QXL-JS-013).** Where the telling class is the one, nothing alters. -/
theorem «平等无异» (R E : «际» α) (x y : α) : ¬ «异» R E «一» x y :=
  fun h => h.2 trivial

/-- The successor net on the natural numbers: each number a condition of the next. -/
def «薪火» : «际» Nat := fun n m => m = n + 1

/-- **指窮於爲薪，火傳也 (ZZ-YSZ-038).** Each stick ends under identity, while the fire's line under the
one never ends. -/
theorem «薪尽火传» (n : Nat) : «亡» «薪火» «静» n ∧ «不穷» «薪火» «一» n :=
  ⟨fun ⟨_, r, e⟩ => Nat.ne_of_lt (Nat.lt_succ_self n) (e.trans r),
   fun y _ => ⟨y + 1, rfl, trivial⟩⟩

end Grains

section Contact

variable {α : Type u}

/-- Contact (攖，相得也, MJ-J-068), with `P z A` read as "`z` is in `A`": sharing something. -/
def «攖» (P : «际» α) : «际» α := «而» («逆» P) P

/-- Taken wholly (盡): whatever is in `A` is in `B`. -/
def «尽» (P : «际» α) : «际» α := fun A B => ∀ z, P z A → P z B

/-- A point (端，體之無序而最前者, MJ-J-062): something is in it, and at most one thing. -/
def «端» (P : «际» α) (A : α) : Prop := (∃ z, P z A) ∧ ∀ z z', P z A → P z' A → z = z'

/-- Extended (尺): two different things are in it. -/
def «有厚» (P : «际» α) (A : α) : Prop := ∃ z z', P z A ∧ P z' A ∧ z ≠ z'

/-- **端與端，俱盡 (MJ-S-068.2).** Two points in contact are each wholly in the other. -/
theorem «端与端俱尽» {P : «际» α} {A B : α} (hA : «端» P A) (hB : «端» P B) (h : «攖» P A B) :
    «尽» P A B ∧ «尽» P B A :=
  match h with
  | ⟨z, pa, pb⟩ =>
    ⟨fun w pw => by cases hA.2 w z pw pa; exact pb,
     fun w pw => by cases hB.2 w z pw pb; exact pa⟩

/-- **尺與端，或盡或不盡 (MJ-S-068.3).** A point in contact with an extended line is wholly in it, and the
line is not wholly in the point. -/
theorem «尺与端或尽或不尽» {P : «际» α} {A B : α} (hA : «端» P A) (hB : «有厚» P B)
    (h : «攖» P A B) : «尽» P A B ∧ ¬ «尽» P B A := by
  refine ⟨?_, ?_⟩
  · intro w pw
    match h with
    | ⟨z, pa, pb⟩ => cases hA.2 w z pw pa; exact pb
  · intro hBA
    match hB with
    | ⟨z, z', pz, pz', ne⟩ => exact ne (hA.2 z z' (hBA z pz) (hBA z' pz'))

/-- **Two extended bodies in contact can be wholly in each other (against 尺與尺俱不盡, MJ-S-068.1, and
體攖不相盡, MJ-S-068.5).** Two different lines with the same two points. -/
theorem «尺与尺可相尽» :
    ∃ (β : Type) (P : «际» β) (A B : β),
      A ≠ B ∧ «有厚» P A ∧ «有厚» P B ∧ «攖» P A B ∧ «尽» P A B ∧ «尽» P B A :=
  ⟨Nat, fun z A => (z = 0 ∨ z = 1) ∧ (A = 2 ∨ A = 3), 2, 3,
   fun h => Nat.noConfusion (Nat.succ.inj (Nat.succ.inj h)),
   ⟨0, 1, ⟨.inl rfl, .inl rfl⟩, ⟨.inr rfl, .inl rfl⟩, fun h => Nat.noConfusion h⟩,
   ⟨0, 1, ⟨.inl rfl, .inr rfl⟩, ⟨.inr rfl, .inr rfl⟩, fun h => Nat.noConfusion h⟩,
   ⟨0, ⟨.inl rfl, .inl rfl⟩, ⟨.inl rfl, .inr rfl⟩⟩,
   fun _ h => ⟨h.1, .inr rfl⟩, fun _ h => ⟨h.1, .inl rfl⟩⟩

/-- Outside (相外, MJ-S-067): something in `A` is not in `B`. -/
def «相外» (P : «际» α) : «际» α := fun A B => ∃ z, P z A ∧ ¬ P z B

/-- Not outside each other (不相外, 堅白不相外也, MJ-J-067). -/
def «不相外» (P : «际» α) : «际» α := fun A B => ¬ «相外» P A B ∧ ¬ «相外» P B A

/-- Wholly in each other (相盡). -/
def «相尽» (P : «际» α) : «际» α := fun A B => «尽» P A B ∧ «尽» P B A

/-- Wholly in each other, not outside each other. -/
theorem «相尽则不相外» {P : «际» α} {A B : α} (h : «相尽» P A B) : «不相外» P A B :=
  ⟨fun ⟨z, pa, npb⟩ => npb (h.1 z pa), fun ⟨z, pb, npa⟩ => npa (h.2 z pb)⟩

/-- A body of one part: the part is in the first body, and in the second where `Q`. -/
def «坚白之体» (Q : Prop) : «际» Bool := fun _ A => A = false ∨ (A = true ∧ Q)

/-- **堅白之攖，相盡 (MJ-S-068.4), from 堅白不相外 (MJ-J-067).** That not being outside each other gives
being wholly in each other, for every carrier, is equivalent to double-negation stability. -/
theorem «不相外则相尽当且仅当双非可还» :
    (∀ (β : Type) (P : «际» β) (A B : β), «不相外» P A B → «相尽» P A B) ↔ ∀ Q : Prop, ¬¬Q → Q := by
  constructor
  · intro h Q nnq
    have hn : «不相外» («坚白之体» Q) false true :=
      ⟨fun ⟨_, _, npb⟩ => nnq (fun q => npb (.inr ⟨rfl, q⟩)), fun ⟨_, _, npa⟩ => npa (.inl rfl)⟩
    match (h Bool («坚白之体» Q) false true hn).1 false (.inl rfl) with
    | .inl e => exact Bool.noConfusion e
    | .inr ⟨_, q⟩ => exact q
  · intro dne β P A B ⟨h₁, h₂⟩
    exact ⟨fun z pa => dne _ (fun npb => h₁ ⟨z, pa, npb⟩),
      fun z pb => dne _ (fun npa => h₂ ⟨z, pb, npa⟩)⟩

end Contact

section Disputation

/-- **是不俱當 (MJ-S-076.2).** Of 牛 and 非牛 said of one thing, not both fit. -/
theorem «是不俱当» {β : Type u} (P : β → Prop) (x : β) : ¬ (P x ∧ ¬ P x) :=
  fun ⟨p, np⟩ => np p

/-- **不俱當，必或不當 (MJ-S-076.3).** That one of 牛 and 非牛 fails to fit, for every carrier and
predicate, is weak excluded middle. -/
theorem «必或不当当且仅当弱排中» :
    (∀ (β : Type) (P : β → Prop) (x : β), ¬ P x ∨ ¬¬ P x) ↔ ∀ Q : Prop, ¬ Q ∨ ¬¬ Q :=
  ⟨fun h Q => h Unit (fun _ => Q) (), fun h _ P x => h (P x)⟩

end Disputation

section Inquiry

variable {α : Type u}

/-- Not told apart at stage `k` (不可致詰 at `k`): alike under `E`, and at `k + 1` every step of each is
matched by a step of the other not told apart at `k`. -/
def «诘» (R E : «际» α) : Nat → «际» α
  | 0 => E
  | k + 1 => fun u u' => E u u' ∧ (∀ v, R u v → ∃ v', R u' v' ∧ «诘» R E k v v') ∧
      (∀ v', R u' v' → ∃ v, R u v ∧ «诘» R E k v v')

/-- What a symmetric constant relation inside `E` relates is told apart at no stage. -/
theorem «对称有常则不可诘» {R E S : «际» α} (hSE : «则» S E) (hs : «则» S («逆» S))
    (hc : «有常» R S) : ∀ k u u', S u u' → «诘» R E k u u'
  | 0, u, u', h => hSE u u' h
  | k + 1, u, u', h =>
    ⟨hSE u u' h,
     fun v r => match («有常之逐点» R S).mp hc u u' h v r with
       | ⟨v', r', s⟩ => ⟨v', r', «对称有常则不可诘» hSE hs hc k v v' s⟩,
     fun v' r' => match («有常之逐点» R S).mp hc u' u (hs u u' h) v' r' with
       | ⟨v, r, s⟩ => ⟨v, r, «对称有常则不可诘» hSE hs hc k v v' (hs v' v s)⟩⟩

/-- **The core is never told apart (核则不可致诘, LZ-14-002, one direction).** -/
theorem «核则不可致诘» {R E : «际» α} {u u' : α} (h : «核» R E u u') (k : Nat) : «诘» R E k u u' :=
  match h with
  | ⟨_, hSE, hs, hc, s⟩ => «对称有常则不可诘» hSE hs hc k u u' s

/-- Stages are symmetric for a symmetric `E`. -/
theorem «诘之对称» {R E : «际» α} (hE : «则» E («逆» E)) : ∀ k u u', «诘» R E k u u' → «诘» R E k u' u
  | 0, u, u', h => hE u u' h
  | k + 1, _, _, ⟨e, f, b⟩ =>
    ⟨hE _ _ e,
     fun v' r' => match b v' r' with | ⟨v, r, s⟩ => ⟨v, r, «诘之对称» hE k v v' s⟩,
     fun v r => match f v r with | ⟨v', r', s⟩ => ⟨v', r', «诘之对称» hE k v v' s⟩⟩

/-- **此三者，不可致詰，故混而為一 (LZ-14-002), under its premise.** Where the relation of being told apart at
no stage is itself constant (what image-finiteness gives, classically), what no stage tells apart
lies in the core. -/
theorem «不可致诘而有常则混而为一» {R E : «际» α} (hE : «则» E («逆» E))
    (hc : «有常» R (fun u u' => ∀ k, «诘» R E k u u')) {u u' : α} (h : ∀ k, «诘» R E k u u') :
    «核» R E u u' :=
  ⟨fun u u' => ∀ k, «诘» R E k u u', fun _ _ s => s 0,
   fun a b s k => «诘之对称» hE k a b (s k), hc, h⟩

/-- An infinitely branching net (歧网): `«甲»` and `«乙»` go to every finite chain, and `«乙»` also to an
endless one. -/
inductive «歧网»
  | «甲»
  | «乙»
  | «链» (n i : Nat)
  | «无尽» (j : Nat)

/-- The steps of the branching net. -/
def «歧网之步» : «际» «歧网»
  | .«甲», y => ∃ n, y = .«链» n 0
  | .«乙», y => (∃ n, y = .«链» n 0) ∨ y = .«无尽» 0
  | .«链» n i, y => i < n ∧ y = .«链» n (i + 1)
  | .«无尽» j, y => y = .«无尽» (j + 1)

/-- Every occurrence is not told apart from itself at any stage, under the one. -/
theorem «歧网之自反» : ∀ k (x : «歧网»), «诘» «歧网之步» «一» k x x
  | 0, _ => trivial
  | k + 1, _ => ⟨trivial, fun v r => ⟨v, r, «歧网之自反» k v⟩, fun v r => ⟨v, r, «歧网之自反» k v⟩⟩

/-- A finite chain with at least `k` steps left is not told apart at stage `k` from the endless one. -/
theorem «链与无尽不可诘» : ∀ k n i j, i + k ≤ n → «诘» «歧网之步» «一» k (.«链» n i) (.«无尽» j)
  | 0, _, _, _, _ => trivial
  | k + 1, n, i, j, h =>
    have lt : i < n := Nat.lt_of_lt_of_le (Nat.lt_succ_of_le (Nat.le_add_right i k)) h
    have next : i + 1 + k ≤ n := Nat.le_trans (Nat.le_of_eq (Nat.succ_add i k)) h
    ⟨trivial,
     fun v r => match r with
       | ⟨_, e⟩ => by cases e; exact ⟨.«无尽» (j + 1), rfl, «链与无尽不可诘» k n (i + 1) (j + 1) next⟩,
     fun v' r' => by
       cases r'
       exact ⟨.«链» n (i + 1), ⟨lt, rfl⟩, «链与无尽不可诘» k n (i + 1) (j + 1) next⟩⟩

/-- `«甲»` and `«乙»` are told apart at no stage. -/
theorem «甲乙不可诘» : ∀ k, «诘» «歧网之步» «一» k .«甲» .«乙»
  | 0 => trivial
  | k + 1 =>
    ⟨trivial,
     fun v r => match r with
       | ⟨n, e⟩ => by cases e; exact ⟨.«链» n 0, .inl ⟨n, rfl⟩, «歧网之自反» k _⟩,
     fun v' r' => match r' with
       | .inl ⟨n, e⟩ => by cases e; exact ⟨.«链» n 0, ⟨n, rfl⟩, «歧网之自反» k _⟩
       | .inr e => by
         cases e
         exact ⟨.«链» k 0, ⟨k, rfl⟩, «链与无尽不可诘» k k 0 0 (Nat.le_of_eq (Nat.zero_add k))⟩⟩

/-- No constant relation relates the endless chain to a finite one. -/
theorem «无尽与链不同核» {S : «际» «歧网»} (hc : «有常» «歧网之步» S) :
    ∀ d j n i, i + d = n → ¬ S (.«无尽» j) (.«链» n i)
  | 0, j, n, i, e, s => by
    cases e
    match («有常之逐点» «歧网之步» S).mp hc _ _ s (.«无尽» (j + 1)) rfl with
    | ⟨_, ⟨lt, _⟩, _⟩ => exact Nat.lt_irrefl i lt
  | d + 1, j, n, i, e, s =>
    match («有常之逐点» «歧网之步» S).mp hc _ _ s (.«无尽» (j + 1)) rfl with
    | ⟨v, ⟨_, ev⟩, s'⟩ => by
      cases ev
      exact «无尽与链不同核» hc d (j + 1) n (i + 1) ((Nat.succ_add i d).trans e) s'

/-- `«甲»` and `«乙»` are not in one class of the core. -/
theorem «甲乙不同核» : ¬ «核» «歧网之步» «一» .«甲» .«乙» := by
  intro ⟨S, _, hs, hc, s⟩
  match («有常之逐点» «歧网之步» S).mp hc _ _ (hs _ _ s) (.«无尽» 0) (.inr rfl) with
  | ⟨v, ⟨n, ev⟩, s'⟩ =>
    cases ev
    exact «无尽与链不同核» hc n 0 n 0 (Nat.zero_add n) s'

/-- **What no finite inquiry separates need not be one (致诘不尽, LZ-14-002).** In an infinitely
branching net, two occurrences are told apart at no finite stage and yet lie in no class of the
core: 「不可致詰，故混而為一」 needs a premise. -/
theorem «致诘不尽» :
    ∃ (β : Type) (R : «际» β) (u u' : β), (∀ k, «诘» R «一» k u u') ∧ ¬ «核» R «一» u u' :=
  ⟨«歧网», «歧网之步», .«甲», .«乙», «甲乙不可诘», «甲乙不同核»⟩

end Inquiry

end Becoming
