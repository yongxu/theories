import Becoming.Dependence
import Becoming.Decidedness

/-!
# Lexical comparison of two tiers of realized claims

Two alternatives `a`, `b` of one unfolding are compared by what each realizes in two tiers: the
basic claims first, then the gains. `a` is lexically above `b` (`Above basic gain a b`) when it
holds every basic claim of `b` and a basic claim `b` lacks, or holds exactly `b`'s basic claims
and every gain of `b` and a gain `b` lacks. `Above` is a definition of an order: it asserts no
comparison. That a comparison `better` compares exactly so is J1/J2 of the practical
commitments (complete comparison with retained losses, priority of basic conditions), which the
core does not assert. It is the condition `BasicPriority basic gain better`, taken as a
hypothesis by every theorem that concludes something of `better`, as the continuation condition
of §6.15 is taken by the theorems of `Becoming.Significance`.

Ported from `PracticalJudgment` (its comparison), `ConcernExtension` and
`ClassificationRobustJudgment` (F3J, 18 October 2026), with the bridge's readings of them
(`Judgment.frame`, `BetterAt`, `compared_*`, `classification_robust_iff_of_em`,
`classification_robust_iff_iff_em`, `CoursesBridge`), stated here on the core's types. No premise
enters beyond what each theorem names; every declaration has an empty axiom report.

* **The order.** Inclusion and strict inclusion of claims compose (`Included.trans`,
  `StrictIncluded.irrefl`, `StrictIncluded.trans`); `Above` is irreflexive and transitive
  (`Above.irrefl`, `Above.trans`). Retaining `b`'s basic claims and holding one it lacks puts `a`
  above `b` whatever the gains (`Above.anchor`); losing a basic claim `b` holds keeps `a` from
  being above `b`, whatever the number of gains (`Above.no_trade`); holding everything `b`
  holds in both tiers keeps `a` from being above `b` (`Above.not_of_included`).
* **The condition.** Under `BasicPriority`, `better` is irreflexive and transitive, and every
  statement about `Above` is one about `better` (`BasicPriority.iff`, `.irrefl`, `.trans`,
  `.anchor`, `.no_trade`).
* **On a frame.** `Frame.Above F basic living` compares configurations by the basic, then the
  living claims they realize. Every two-tier comparison is one on a frame: the frame whose
  configurations are the alternatives and which realizes the basic claims on the left and the
  gains on the right (`tierFrame`, `above_iff_frame`). A generative extension (`Extension`,
  `Becoming.Metaethics`) is never below its base and is above it wherever it is decided whether
  the extension adds a basic claim (`Frame.not_not_above_of_extension`,
  `Frame.above_of_extension`); so the lexical comparison satisfies C wherever that is decided
  (`Frame.comparison_of_decided`).
* **Adjoined contents.** A description widened by fresh contents (`adjoin`) includes another
  exactly where both the old and the fresh contents are included (`included_adjoin_iff`).
  Strict inclusion passes to the widened description exactly where the fresh contents are
  included (`strictIncluded_adjoin_iff`); a strict gain in the fresh contents with the old ones
  retained is strict (`strictIncluded_adjoin_of_fresh`); crossed changes leave the widened
  descriptions incomparable (`adjoin_crossed`). Adjoining fresh gains can turn incomparable
  alternatives into lexically ordered ones (`Above.adjoin_fresh_gain`), the order then being
  retention of the fresh gains (`Above.adjoin_gain_iff`); adjoining fresh basic contents can
  reverse it (`Above.adjoin_basic_reverses`).
* **Every classification of the fresh contents.** Fresh contents `f` classified by `q` join the
  basic claims where `q` holds and the gains where it fails (`classified`). With none basic the
  comparison is the one with the fresh contents adjoined as gains
  (`classified_none_iff`); with all basic it retains every fresh content of the alternative
  below (`classified_all_retains`). Being above under every classification is retaining the
  fresh contents and being above with them as gains (`classified_robust_iff_of_decided`): the
  forward direction needs nothing; the backward direction needs, at a tie of the old basic
  claims, whether every fresh content of `a` classified basic is held by `b`, and whether `b`
  holds each fresh content, to be decided. Excluded middle is exactly what the criterion needs
  over every type (`classified_robust_iff_iff_em`): with one fresh content, that `b` holds it is
  the proposition the comparison must decide. Along a generative extension nothing is needed
  (`Frame.classified_of_extension`, `Frame.classified_extension_iff`): the basic claims strictly
  grow, so the tie never arises. Strict improvement of the old basic claims with the fresh
  contents retained is above under every classification with no decision
  (`classified_of_basic`).
* **Frames of two kinds of claims.** A frame realizing old and newly distinguished claims realizes
  exactly the adjoined contents of its two parts (`Frame.adjoin_iff`), so inclusion and the
  lexical order of adjoined contents are those of what it realizes (`Frame.included_adjoin_iff`,
  `Frame.above_gain_iff`, `Frame.above_basic_iff`): crossed growth leaves configurations
  incomparable (`Frame.crossed_incomparable`), the order passes to the fresh gains
  (`Frame.gain_transfer_iff`, `Frame.fresh_gains_decide`) and a fresh basic claim can reverse it
  (`Frame.fresh_basic_reverses`). Ported from the join `ExtendedClaimFrames`.
* **Witnesses.** Restoring a basic condition is above celebration that loses it, and the loss
  of the celebration is retained (`Repair.above`, `Repair.loss_retained`); two alternatives each
  holding a distinct protected claim are incomparable (`Crossed.incomparable`); a supplied
  ceiling makes staying within it above any gain beyond it (`Ceiling.above`). Classifying a new
  benefit with an old loss as a gain leaves the alternatives incomparable, as basic orders them
  (`Reorganizing.classification_matters`).

Direction as in `PracticalJudgment`: `Above basic gain a b` and `better a b` say `a` is above.

The two tiers on a frame (`Lexical.Frame.Above` and its laws, `Lexical.tierFrame`,
`Lexical.above_iff_frame`, `Lexical.included_basicSide_iff`, `Lexical.included_gainSide_iff`) are in
`Becoming.FrontierFrames`, which states the commitments on a frame, so this module does not import
the frame (board item W).
* **What the claims do not read.** `Above` reads the claims alone (`Above.congr_left`,
  `Above.congr_right`, through `Included.congr`, `StrictIncluded.congr`), so under `BasicPriority`
  two alternatives realizing the same claims are compared alike, neither better than the other
  (`BasicPriority.same_claims_alike`): a loss imposed by another's part and the same loss self-borne
  are not ordered unless the agent is among the claims; adjoined as a basic claim, it orders them
  (`Above.agent_adjoined`).
-/

namespace Becoming

namespace Lexical

section Order

variable {H : Type} {I : Type}

/-- Every claim `a` holds, `b` holds. -/
def Included (a b : I → Prop) : Prop := ∀ i, a i → b i

/-- `b` holds every claim of `a` and a claim `a` lacks. -/
def StrictIncluded (a b : I → Prop) : Prop :=
  Included a b ∧ ¬ Included b a

theorem Included.refl (a : I → Prop) : Included a a := fun _ held => held

theorem Included.trans {a b c : I → Prop} (first : Included a b) (second : Included b c) :
    Included a c :=
  fun i held => second i (first i held)

theorem StrictIncluded.irrefl (a : I → Prop) : ¬ StrictIncluded a a :=
  fun strict => strict.2 strict.1

theorem StrictIncluded.trans {a b c : I → Prop} (first : StrictIncluded a b)
    (second : StrictIncluded b c) : StrictIncluded a c :=
  ⟨first.1.trans second.1, fun back => first.2 (second.1.trans back)⟩

/-- Holding a claim `a` lacks, with `a`'s claims retained, is strict inclusion. -/
theorem StrictIncluded.of_witness {a b : I → Prop} (retain : Included a b) (i : I)
    (held : b i) (lacking : ¬ a i) : StrictIncluded a b :=
  ⟨retain, fun back => lacking (back i held)⟩

variable {C : Type} {G : Type}

/-- **The lexical order of two tiers.** `a` is above `b`: it strictly includes `b`'s basic
claims, or holds exactly `b`'s basic claims and strictly includes `b`'s gains. A definition of
an order; it asserts no comparison. -/
def Above (basic : H → C → Prop) (gain : H → G → Prop) (a b : H) : Prop :=
  StrictIncluded (basic b) (basic a) ∨
    (Included (basic b) (basic a) ∧ Included (basic a) (basic b) ∧
      StrictIncluded (gain b) (gain a))

variable {basic : H → C → Prop} {gain : H → G → Prop}

theorem Above.irrefl (a : H) : ¬ Above basic gain a a
  | .inl strict => StrictIncluded.irrefl _ strict
  | .inr ⟨_, _, strict⟩ => StrictIncluded.irrefl _ strict

theorem Above.trans {a b c : H} (first : Above basic gain a b) (second : Above basic gain b c) :
    Above basic gain a c :=
  match first, second with
  | .inl ab, .inl bc => .inl (bc.trans ab)
  | .inl ab, .inr ⟨cb, _, _⟩ => .inl ⟨cb.trans ab.1, fun ac => ab.2 (ac.trans cb)⟩
  | .inr ⟨ba, _, _⟩, .inl bc => .inl ⟨bc.1.trans ba, fun ac => bc.2 (ba.trans ac)⟩
  | .inr ⟨ba, ab, gab⟩, .inr ⟨cb, bc, gbc⟩ => .inr ⟨cb.trans ba, ab.trans bc, gbc.trans gab⟩

/-- **A retained basic claim anchors the order**: holding every basic claim of `b` and one it
lacks puts `a` above `b`, whatever the gains. -/
theorem Above.anchor {a b : H} (retain : Included (basic b) (basic a)) (c : C)
    (restored : basic a c) (lost : ¬ basic b c) : Above basic gain a b :=
  .inl (StrictIncluded.of_witness retain c restored lost)

/-- **No number of gains trades for a basic claim**: an alternative losing a basic claim `b`
holds is not above `b`. -/
theorem Above.no_trade {a b : H} (c : C) (held : basic b c) (lost : ¬ basic a c) :
    ¬ Above basic gain a b
  | .inl strict => lost (strict.1 c held)
  | .inr ⟨back, _, _⟩ => lost (back c held)

/-- Holding everything `b` holds in both tiers keeps `a` from being above `b`. -/
theorem Above.not_of_included {a b : H} (basicIncluded : Included (basic a) (basic b))
    (gainIncluded : Included (gain a) (gain b)) : ¬ Above basic gain a b
  | .inl strict => strict.2 basicIncluded
  | .inr ⟨_, _, strict⟩ => strict.2 gainIncluded

/-- `Above` is decided wherever the four inclusions it reads are. -/
theorem Above.decided {a b : H} (ba : Decided (Included (basic b) (basic a)))
    (ab : Decided (Included (basic a) (basic b))) (gba : Decided (Included (gain b) (gain a)))
    (gab : Decided (Included (gain a) (gain b))) : Decided (Above basic gain a b) :=
  match ba, ab with
  | .inr no, _ => .inr fun
      | .inl strict => no strict.1
      | .inr ⟨yes, _, _⟩ => no yes
  | .inl yes, .inr notBack => .inl (.inl ⟨yes, notBack⟩)
  | .inl yes, .inl back => match gba, gab with
    | .inl gyes, .inr gnot => .inl (.inr ⟨yes, back, gyes, gnot⟩)
    | .inr gno, _ => .inr fun
      | .inl strict => strict.2 back
      | .inr ⟨_, _, strict⟩ => gno strict.1
    | .inl _, .inl gback => .inr fun
      | .inl strict => strict.2 back
      | .inr ⟨_, _, strict⟩ => strict.2 gback

end Order

/-! ## The commitment as a condition -/

section Condition

variable {H : Type} {C : Type} {G : Type}

/-- **J1/J2 as a condition**: the comparison `better` compares exactly as the lexical order of the
basic claims, then the gains. The core asserts it nowhere; a theorem about `better` takes it. -/
structure BasicPriority (basic : H → C → Prop) (gain : H → G → Prop) (better : H → H → Prop) :
    Prop where
  iff : ∀ a b, better a b ↔ Above basic gain a b

variable {basic : H → C → Prop} {gain : H → G → Prop} {better : H → H → Prop}

/-- The lexical order itself meets the condition. -/
theorem BasicPriority.above : BasicPriority basic gain (Above basic gain) :=
  ⟨fun _ _ => Iff.rfl⟩

theorem BasicPriority.irrefl (priority : BasicPriority basic gain better) (a : H) :
    ¬ better a a :=
  fun holds => Above.irrefl a ((priority.iff a a).mp holds)

theorem BasicPriority.trans (priority : BasicPriority basic gain better) {a b c : H}
    (first : better a b) (second : better b c) : better a c :=
  (priority.iff a c).mpr (((priority.iff a b).mp first).trans ((priority.iff b c).mp second))

theorem BasicPriority.anchor (priority : BasicPriority basic gain better) {a b : H}
    (retain : Included (basic b) (basic a)) (c : C) (restored : basic a c) (lost : ¬ basic b c) :
    better a b :=
  (priority.iff a b).mpr (Above.anchor retain c restored lost)

theorem BasicPriority.no_trade (priority : BasicPriority basic gain better) {a b : H} (c : C)
    (held : basic b c) (lost : ¬ basic a c) : ¬ better a b :=
  fun holds => Above.no_trade c held lost ((priority.iff a b).mp holds)

end Condition

/-! ## Two tiers on a frame -/

section OnFrame

variable {S : Type} {A : Type} {C : Type}

variable {H : Type} {C' : Type} {G : Type}

/-- The basic claims of a tier frame. -/
def basicSide : Sum C' G → Prop
  | .inl _ => True
  | .inr _ => False

/-- The gains of a tier frame. -/
def gainSide : Sum C' G → Prop
  | .inl _ => False
  | .inr _ => True

variable {basic : H → C' → Prop} {gain : H → G → Prop}

theorem strict_iff {p p' q q' : Prop} (first : p ↔ p') (second : q ↔ q') :
    (p ∧ ¬ q) ↔ (p' ∧ ¬ q') :=
  ⟨fun ⟨x, y⟩ => ⟨first.mp x, fun z => y (second.mpr z)⟩,
   fun ⟨x, y⟩ => ⟨first.mpr x, fun z => y (second.mp z)⟩⟩

variable {basic' living : C → Prop}

end OnFrame

/-! ## Adjoined contents -/

section Adjoin

variable {H : Type} {I J : Type}

/-- A description widened by fresh contents: the old contents on the left, the fresh on the
right. The sum records an admission of contents into one description, not two realms. -/
def adjoin (old : H → I → Prop) (fresh : H → J → Prop) (h : H) : Sum I J → Prop
  | .inl i => old h i
  | .inr j => fresh h j

variable (old : H → I → Prop) (fresh : H → J → Prop)

theorem included_adjoin_iff (a b : H) :
    Included (adjoin old fresh a) (adjoin old fresh b) ↔
      Included (old a) (old b) ∧ Included (fresh a) (fresh b) :=
  ⟨fun included => ⟨fun i held => included (.inl i) held, fun j held => included (.inr j) held⟩,
   fun ⟨first, second⟩ x => match x with
    | .inl i => first i
    | .inr j => second j⟩

/-- Strict inclusion of the old contents passes to the widened description exactly where the
fresh contents are included. -/
theorem strictIncluded_adjoin_iff (a b : H) (strict : StrictIncluded (old a) (old b)) :
    StrictIncluded (adjoin old fresh a) (adjoin old fresh b) ↔ Included (fresh a) (fresh b) :=
  ⟨fun widened => ((included_adjoin_iff old fresh a b).mp widened.1).2,
   fun included => ⟨(included_adjoin_iff old fresh a b).mpr ⟨strict.1, included⟩,
     fun back => strict.2 ((included_adjoin_iff old fresh b a).mp back).1⟩⟩

/-- Retained old contents and a strict gain in the fresh ones make the widened description strict. -/
theorem strictIncluded_adjoin_of_fresh (a b : H) (retained : Included (old a) (old b))
    (strict : StrictIncluded (fresh a) (fresh b)) :
    StrictIncluded (adjoin old fresh a) (adjoin old fresh b) :=
  ⟨(included_adjoin_iff old fresh a b).mpr ⟨retained, strict.1⟩,
   fun back => strict.2 ((included_adjoin_iff old fresh b a).mp back).2⟩

/-- Crossed changes leave the widened descriptions incomparable. -/
theorem adjoin_crossed (a b : H) (oldStrict : StrictIncluded (old a) (old b))
    (freshStrict : StrictIncluded (fresh b) (fresh a)) :
    ¬ Included (adjoin old fresh a) (adjoin old fresh b) ∧
      ¬ Included (adjoin old fresh b) (adjoin old fresh a) :=
  ⟨fun included => freshStrict.2 ((included_adjoin_iff old fresh a b).mp included).2,
   fun included => oldStrict.2 ((included_adjoin_iff old fresh b a).mp included).1⟩

variable {C : Type} {G N R : Type}

/-- **Adjoining fresh gains can order incomparable alternatives**: with the same basic claims and
the same gains neither is above the other; with fresh gains of which `a` holds strictly more,
`a` is above. -/
theorem Above.adjoin_fresh_gain (p : H → C → Prop) (g : H → G → Prop) (f : H → N → Prop)
    (a b : H) (pab : Included (p a) (p b)) (pba : Included (p b) (p a))
    (gab : Included (g a) (g b)) (gba : Included (g b) (g a))
    (strict : StrictIncluded (f b) (f a)) :
    ¬ Above p g a b ∧ ¬ Above p g b a ∧ Above p (adjoin g f) a b :=
  ⟨Above.not_of_included pab gab, Above.not_of_included pba gba,
   .inr ⟨pba, pab, strictIncluded_adjoin_of_fresh g f b a gba strict⟩⟩

/-- With the same basic claims and a strict old gain, being above with fresh gains adjoined is
retaining the fresh gains. -/
theorem Above.adjoin_gain_iff (p : H → C → Prop) (g : H → G → Prop) (f : H → N → Prop) (a b : H)
    (pab : Included (p a) (p b)) (pba : Included (p b) (p a)) (gain : StrictIncluded (g b) (g a)) :
    Above p (adjoin g f) a b ↔ Included (f b) (f a) :=
  ⟨fun above => match above with
    | .inl strict => False.elim (strict.2 pab)
    | .inr ⟨_, _, strict⟩ => (strictIncluded_adjoin_iff g f b a gain).mp strict,
   fun included => .inr ⟨pba, pab, (strictIncluded_adjoin_iff g f b a gain).mpr included⟩⟩

/-- **Adjoining fresh basic contents can reverse the order.** -/
theorem Above.adjoin_basic_reverses (p : H → C → Prop) (g : H → G → Prop) (fb : H → N → Prop)
    (fg : H → R → Prop) (a b : H) (pab : Included (p a) (p b)) (pba : Included (p b) (p a))
    (gain : StrictIncluded (g b) (g a)) (basicFresh : StrictIncluded (fb a) (fb b)) :
    Above p g a b ∧ Above (adjoin p fb) (adjoin g fg) b a :=
  ⟨.inr ⟨pba, pab, gain⟩, .inl (strictIncluded_adjoin_of_fresh p fb a b pab basicFresh)⟩

end Adjoin

/-! ## What the claims do not read -/

section Agency

variable {H : Type} {C G : Type} {basic : H → C → Prop} {gain : H → G → Prop}

/-- Inclusion of claims read through claims held alike. -/
theorem Included.congr {I : Type} {a a' b b' : I → Prop} (ha : ∀ i, a i ↔ a' i)
    (hb : ∀ i, b i ↔ b' i) (inc : Included a b) : Included a' b' :=
  fun i held => (hb i).mp (inc i ((ha i).mpr held))

/-- Strict inclusion of claims read through claims held alike. -/
theorem StrictIncluded.congr {I : Type} {a a' b b' : I → Prop} (ha : ∀ i, a i ↔ a' i)
    (hb : ∀ i, b i ↔ b' i) (strict : StrictIncluded a b) : StrictIncluded a' b' :=
  ⟨strict.1.congr ha hb, fun back => strict.2 (back.congr (fun i => (hb i).symm) fun i => (ha i).symm)⟩

/-- `Above` reads the claims alone, on its left: an alternative realizing the same claims in both
tiers stands above whatever the other does. -/
theorem Above.congr_left {a a' b : H} (bs : ∀ c, basic a c ↔ basic a' c)
    (gs : ∀ g, gain a g ↔ gain a' g) : Above basic gain a b → Above basic gain a' b
  | .inl strict => .inl (strict.congr (fun _ => Iff.rfl) bs)
  | .inr ⟨ba, ab, strict⟩ =>
    .inr ⟨ba.congr (fun _ => Iff.rfl) bs, ab.congr bs fun _ => Iff.rfl, strict.congr (fun _ => Iff.rfl) gs⟩

/-- `Above` reads the claims alone, on its right. -/
theorem Above.congr_right {a b b' : H} (bs : ∀ c, basic b c ↔ basic b' c)
    (gs : ∀ g, gain b g ↔ gain b' g) : Above basic gain a b → Above basic gain a b'
  | .inl strict => .inl (strict.congr bs fun _ => Iff.rfl)
  | .inr ⟨ba, ab, strict⟩ =>
    .inr ⟨ba.congr bs fun _ => Iff.rfl, ab.congr (fun _ => Iff.rfl) bs, strict.congr gs fun _ => Iff.rfl⟩

/-- **What the claims do not read, the comparison cannot weigh.** Under `BasicPriority`, two
alternatives realizing the same basic claims and the same gains are compared alike: neither is
better than the other, and each is better than a third, or worse, exactly where the other is. A
loss laid on someone by another's part and the same loss borne by one's own realize the same claims
where who caused it is not among them; so no comparison under the condition orders them. -/
theorem BasicPriority.same_claims_alike {better : H → H → Prop}
    (priority : BasicPriority basic gain better) {a b : H} (basics : ∀ c, basic a c ↔ basic b c)
    (gains : ∀ g, gain a g ↔ gain b g) :
    ¬ better a b ∧ ¬ better b a ∧ (∀ d, better a d ↔ better b d) ∧ ∀ d, better d a ↔ better d b :=
  have back : ∀ c, basic b c ↔ basic a c := fun c => (basics c).symm
  have gback : ∀ g, gain b g ↔ gain a g := fun g => (gains g).symm
  ⟨fun ab => Above.irrefl b (Above.congr_left basics gains ((priority.iff a b).mp ab)),
   fun ba => Above.irrefl a (Above.congr_left back gback ((priority.iff b a).mp ba)),
   fun d => ⟨fun ad => (priority.iff b d).mpr (Above.congr_left basics gains ((priority.iff a d).mp ad)),
     fun bd => (priority.iff a d).mpr (Above.congr_left back gback ((priority.iff b d).mp bd))⟩,
   fun d => ⟨fun da => (priority.iff d b).mpr (Above.congr_right basics gains ((priority.iff d a).mp da)),
     fun db => (priority.iff d a).mpr (Above.congr_right back gback ((priority.iff d b).mp db))⟩⟩

/-- **With the agent among the basic claims, the two are ordered.** Adjoining to the basic claims a
fresh claim (`spared`, for instance that no loss is laid on the one who loses by another's part)
that the self-borne alternative holds and the imposed one lacks, the self-borne alternative is
lexically above the imposed one wherever it holds every old basic claim the imposed one holds. -/
theorem Above.agent_adjoined {N R : Type} (spared : H → N → Prop) (fg : H → R → Prop)
    {self imposed : H} (same : Included (basic imposed) (basic self))
    (fresh : StrictIncluded (spared imposed) (spared self)) :
    Above (adjoin basic spared) (adjoin gain fg) self imposed :=
  .inl (strictIncluded_adjoin_of_fresh basic spared imposed self same fresh)

end Agency

/-! ## Comparison under every classification of fresh contents -/

section Classified

variable {H : Type} {C G N : Type}

/-- The basic claims with the fresh contents `q` classifies basic. -/
def classifiedBasic (p : H → C → Prop) (f : H → N → Prop) (q : N → Prop) : H → Sum C N → Prop :=
  adjoin p fun h n => f h n ∧ q n

/-- The gains with the fresh contents `q` classifies as gains. -/
def classifiedGain (g : H → G → Prop) (f : H → N → Prop) (q : N → Prop) : H → Sum G N → Prop :=
  adjoin g fun h n => f h n ∧ ¬ q n

/-- The lexical order with the fresh contents `f` classified by `q`. -/
def classified (p : H → C → Prop) (g : H → G → Prop) (f : H → N → Prop) (q : N → Prop) :
    H → H → Prop :=
  Above (classifiedBasic p f q) (classifiedGain g f q)

variable {p : H → C → Prop} {g : H → G → Prop} {f : H → N → Prop} {a b : H}

/-- With every fresh content basic, being above retains every fresh content of `b`. -/
theorem classified_all_retains (above : classified p g f (fun _ => True) a b) :
    Included (f b) (f a) :=
  fun n held => match above with
    | .inl strict => (strict.1 (.inr n) ⟨held, True.intro⟩).1
    | .inr ⟨forward, _, _⟩ => (forward (.inr n) ⟨held, True.intro⟩).1

/-- With no fresh content basic, being above is being above with the fresh contents adjoined as
gains: one direction. -/
theorem classified_none_above (above : classified p g f (fun _ => False) a b) :
    Above p (adjoin g f) a b :=
  match above with
  | .inl ⟨forward, notBack⟩ =>
    .inl ⟨fun c held => forward (.inl c) held,
      fun back => notBack fun i => match i with
        | .inl c => back c
        | .inr _ => fun held => held.2.elim⟩
  | .inr ⟨forward, back, gainForward, gainNotBack⟩ =>
    .inr ⟨fun c held => forward (.inl c) held, fun c held => back (.inl c) held,
      fun i => match i with
        | .inl x => gainForward (.inl x)
        | .inr n => fun held => (gainForward (.inr n) ⟨held, fun no => no⟩).1,
      fun gainBack => gainNotBack fun i => match i with
        | .inl x => gainBack (.inl x)
        | .inr n => fun held => ⟨gainBack (.inr n) held.1, held.2⟩⟩

/-- **With no fresh content basic, the comparison is the one with the fresh contents adjoined as
gains.** -/
theorem classified_none_iff :
    classified p g f (fun _ => False) a b ↔ Above p (adjoin g f) a b :=
  ⟨classified_none_above, fun above => match above with
    | .inl ⟨forward, notBack⟩ =>
      .inl ⟨fun i => match i with
          | .inl c => forward c
          | .inr _ => fun held => held.2.elim,
        fun back => notBack fun c => back (.inl c)⟩
    | .inr ⟨forward, back, gainForward, gainNotBack⟩ =>
      .inr ⟨fun i => match i with
          | .inl c => forward c
          | .inr _ => fun held => held.2.elim,
        fun i => match i with
          | .inl c => back c
          | .inr _ => fun held => held.2.elim,
        fun i => match i with
          | .inl x => gainForward (.inl x)
          | .inr n => fun held => ⟨gainForward (.inr n) held.1, held.2⟩,
        fun gainBack => gainNotBack fun i => match i with
          | .inl x => gainBack (.inl x)
          | .inr n => fun held => (gainBack (.inr n) ⟨held, fun no => no⟩).1⟩⟩

/-- **Strict improvement of the old basic claims with the fresh contents retained is above under
every classification**, with no decision. -/
theorem classified_of_basic (basicStrict : StrictIncluded (p b) (p a))
    (fresh : Included (f b) (f a)) (q : N → Prop) : classified p g f q a b :=
  .inl ⟨fun i => match i with
      | .inl c => basicStrict.1 c
      | .inr n => fun held => ⟨fresh n held.1, held.2⟩,
    fun back => basicStrict.2 fun c => back (.inl c)⟩

/-- **Retaining the fresh contents and being above with them as gains gives being above under a
classification**, where it is decided whether `b` holds each fresh content and whether every
fresh content of `a` the classification makes basic is held by `b`. -/
theorem classified_of_decided (fresh : Included (f b) (f a)) (old : Above p (adjoin g f) a b)
    (q : N → Prop) (held : ∀ n, Decided (f b n))
    (tie : Decided (∀ n, f a n → q n → f b n)) : classified p g f q a b :=
  match old with
  | .inl ⟨forward, notBack⟩ =>
    .inl ⟨fun i => match i with
        | .inl c => forward c
        | .inr n => fun h => ⟨fresh n h.1, h.2⟩,
      fun back => notBack fun c => back (.inl c)⟩
  | .inr ⟨pba, pab, gainForward, gainNotBack⟩ =>
    have forward : Included (classifiedBasic p f q b) (classifiedBasic p f q a) := fun i =>
      match i with
      | .inl c => pba c
      | .inr n => fun h => ⟨fresh n h.1, h.2⟩
    match tie with
    | .inr adds => .inl ⟨forward, fun back => adds fun n fa qn => (back (.inr n) ⟨fa, qn⟩).1⟩
    | .inl kept =>
      .inr ⟨forward, fun i => match i with
          | .inl c => pab c
          | .inr n => fun h => ⟨kept n h.1 h.2, h.2⟩,
        fun i => match i with
          | .inl x => gainForward (.inl x)
          | .inr n => fun h => ⟨fresh n h.1, h.2⟩,
        fun gainBack => gainNotBack fun i => match i with
          | .inl x => gainBack (.inl x)
          | .inr n => fun fa => match held n with
            | .inl yes => yes
            | .inr no => False.elim
                ((fun nq => no (gainBack (.inr n) ⟨fa, nq⟩).1) fun qn => no (kept n fa qn))⟩

/-- **The criterion of comparison under every classification**: `a` is above `b` under every
classification of the fresh contents exactly where it retains `b`'s fresh contents and is above
with them as gains, where whether `b` holds each fresh content, and at each classification
whether `b` holds every fresh content of `a` classified basic, are decided. The forward direction
needs nothing. -/
theorem classified_robust_iff_of_decided (held : ∀ n, Decided (f b n))
    (tie : ∀ q : N → Prop, Decided (∀ n, f a n → q n → f b n)) :
    (∀ q, classified p g f q a b) ↔ Included (f b) (f a) ∧ Above p (adjoin g f) a b :=
  ⟨fun robust => ⟨classified_all_retains (robust _), classified_none_above (robust _)⟩,
   fun ⟨fresh, old⟩ q => classified_of_decided fresh old q held (tie q)⟩

/-- **The criterion with excluded middle named.** -/
theorem classified_robust_iff_of_em (em : ∀ r : Prop, Decided r) :
    (∀ q, classified p g f q a b) ↔ Included (f b) (f a) ∧ Above p (adjoin g f) a b :=
  classified_robust_iff_of_decided (fun _ => em _) (fun _ => em _)

/-- **Two extreme classifications suffice**, with the same decisions. -/
theorem classified_extremes_iff_of_decided (held : ∀ n, Decided (f b n))
    (tie : ∀ q : N → Prop, Decided (∀ n, f a n → q n → f b n)) :
    (∀ q, classified p g f q a b) ↔
      classified p g f (fun _ => False) a b ∧ classified p g f (fun _ => True) a b :=
  ⟨fun robust => ⟨robust _, robust _⟩,
   fun ⟨noneBasic, allBasic⟩ => (classified_robust_iff_of_decided held tie).mpr
     ⟨classified_all_retains allBasic, classified_none_above noneBasic⟩⟩

/-- **A fresh enrichment with the old contents retained is above under every classification**,
with the same decisions. -/
theorem classified_of_fresh (pba : Included (p b) (p a)) (pab : Included (p a) (p b))
    (gba : Included (g b) (g a)) (fresh : StrictIncluded (f b) (f a)) (q : N → Prop)
    (held : ∀ n, Decided (f b n)) (tie : Decided (∀ n, f a n → q n → f b n)) :
    classified p g f q a b :=
  classified_of_decided fresh.1 (.inr ⟨pba, pab, strictIncluded_adjoin_of_fresh g f b a gba fresh⟩)
    q held tie

/-- **Excluded middle is exactly what the criterion needs over every type.** That being above under
every classification follows from retaining the fresh contents and being above with them as
gains, for all types, holds exactly where every proposition is decided: with `a = true`,
`b = false`, one fresh content held at `true` and, at `false`, exactly where `R` holds, and one
gain held only at `true`, being above under the classification making the fresh content basic
is `R` or its failure. What the comparison must decide is whether `b` realizes the fresh
content. -/
theorem classified_robust_iff_iff_em :
    (∀ (H C G N : Type) (p : H → C → Prop) (g : H → G → Prop) (f : H → N → Prop) (a b : H),
      (∀ q, classified p g f q a b) ↔ Included (f b) (f a) ∧ Above p (adjoin g f) a b) ↔
      ∀ R : Prop, Decided R :=
  ⟨fun robust R =>
    match (robust Bool Unit Unit Unit (fun _ _ => True) (fun h _ => h = true)
        (fun h _ => h = true ∨ R) true false).mpr
        ⟨fun _ _ => Or.inl rfl,
         .inr ⟨fun _ _ => True.intro, fun _ _ => True.intro,
           ⟨fun i => match i with
              | .inl _ => fun no => Bool.noConfusion no
              | .inr _ => fun _ => Or.inl rfl,
            fun back => Bool.noConfusion (back (.inl ()) rfl)⟩⟩⟩
        (fun _ => True) with
    | .inl ⟨_, notBack⟩ =>
      .inr fun r => notBack fun i => match i with
        | .inl _ => fun _ => True.intro
        | .inr _ => fun _ => ⟨Or.inr r, True.intro⟩
    | .inr ⟨_, back, _⟩ =>
      match (back (.inr ()) ⟨Or.inl rfl, True.intro⟩).1 with
      | .inl no => Bool.noConfusion no
      | .inr r => .inl r,
   fun em _ _ _ _ _ _ _ _ _ => classified_robust_iff_of_em em⟩

variable {S A : Type}

end Classified

/-! ## Frames of two kinds of claims -/

/-! ## Witnesses -/

namespace Repair

/-- Repair restores the basic condition of living and shared activity. -/
def basis (repair : Bool) (_ : Unit) : Prop := repair = true

/-- Celebration realizes the event that repair loses. -/
def event (repair : Bool) (_ : Unit) : Prop := repair = false

/-- **Repair is above celebration** in the lexical order. -/
theorem above : Above basis event true false :=
  Above.anchor (fun _ held => Bool.noConfusion held) () rfl Bool.noConfusion

/-- The loss of the event is retained: celebration realizes it, repair does not. -/
theorem loss_retained : event false () ∧ ¬ event true () :=
  ⟨rfl, Bool.noConfusion⟩

end Repair

namespace Crossed

/-- Each alternative holds the protected claim the other lacks. -/
def protectedOne (a : Bool) (c : Bool) : Prop := a = c

def noGain (_ : Bool) (_ : Unit) : Prop := False

/-- **Distinct protected claims stay incomparable**, even with equal gains. -/
theorem incomparable :
    ¬ Above protectedOne noGain true false ∧ ¬ Above protectedOne noGain false true :=
  ⟨Above.no_trade false rfl Bool.noConfusion, Above.no_trade true rfl Bool.noConfusion⟩

end Crossed

namespace Ceiling

/-- Staying within a supplied ceiling, read as a basic claim. -/
def within (limit : Nat) (h : Nat × Nat) (_ : Unit) : Prop := h.1 ≤ limit

/-- Optional formations, read as gains. -/
def optional (h : Nat × Nat) (i : Nat) : Prop := i < h.2

/-- **A supplied ceiling makes staying within it above any gain beyond it.** The ceiling is
supplied; no numerical bound follows from living significance. -/
theorem above (limit amount : Nat) : Above (within limit) optional (0, 0) (limit + 1, amount) :=
  Above.anchor (fun _ _ => Nat.zero_le limit) () (Nat.zero_le limit) (Nat.not_succ_le_self limit)

end Ceiling

namespace Reorganizing

def oldBasic (_ : Bool) (_ : Unit) : Prop := True
def oldOccasion (organized : Bool) (_ : Unit) : Prop := organized = false
def newContent (organized : Bool) (_ : Unit) : Prop := organized = true

/-- **The classification of a new benefit matters with a real loss**: the reorganization loses an
old occasion; classified as a gain, the new content leaves the alternatives incomparable;
classified basic, the reorganization is above. -/
theorem classification_matters :
    oldOccasion false () ∧ ¬ oldOccasion true () ∧
      ¬ classified oldBasic oldOccasion newContent (fun _ => False) true false ∧
      ¬ classified oldBasic oldOccasion newContent (fun _ => False) false true ∧
      classified oldBasic oldOccasion newContent (fun _ => True) true false :=
  ⟨rfl, Bool.noConfusion,
   fun above => match classified_none_above above with
    | .inl strict => strict.2 fun _ held => held
    | .inr ⟨_, _, strict⟩ => Bool.noConfusion (strict.1 (.inl ()) rfl),
   fun above => match classified_none_above above with
    | .inl strict => strict.2 fun _ held => held
    | .inr ⟨_, _, strict⟩ => Bool.noConfusion (strict.1 (.inr ()) rfl),
   .inl ⟨fun x => match x with
      | .inl _ => fun held => held
      | .inr _ => fun held => False.elim (Bool.noConfusion held.1),
    fun back => Bool.noConfusion (back (.inr ()) ⟨rfl, True.intro⟩).1⟩⟩

end Reorganizing

end Lexical

end Becoming
