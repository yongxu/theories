import Becoming.Presence

/-!
# A world's reorderings as the growth of its order of exchanges, and presence on the World

`Becoming.Reordering` reads the World's shared index of steps as one choice among interleavings:
with a footprint containing the exchanges, exchanges not joined commute, what shows of the index is
the order of joined exchanges (`Footprinted.Precedes`), and every renumbering of a stretch keeping
it is reached by commuting exchanges not joined (`Footprinted.sorts_iff`). `Becoming.Presence`
reads causal-set growth: the orders of birth of the courses from the empty set growing a
configuration of one kind are its natural labellings (`Presence.natural_iff_course`), and on them it
asks what of presence every course keeps. Each reads Mazurkiewicz's theorem on its side: on the
World as `Footprinted.sorts_iff` and, from the core's `rearranges_iff`, as
`Footprinted.rearranges_iff_independent`; on growth as `Presence.rearranges_iff_natural`. This module
shows that on a world's stretch they are one structure: the numberings a world's reorderings give
the stretch are exactly the orders of birth of the courses of growth of its order of exchanges, so
the laws of presence on causal-set growth hold on the World by instance.

* **The exchanges of a stretch form a causal set** (`exchanges`, `exchanges_ordered`): the first
  `m` steps, the exchange across `i` preceding that across `j` where `r.Precedes i j`.
* **Its natural labellings are the renumberings keeping the order of joined exchanges**
  (`natural_iff`): a renumbering increasing along each joined pair, the earlier first, increases
  along every chain of them (`keeps_precedes`). So, where the footprint contains the exchanges, a
  renumbering of the stretch is the numbering of some reordering exactly where it is a natural
  labelling of the stretch's exchanges, and exactly where it numbers them by a course of causal-set
  growth from the empty set whose configuration at the stretch's size is of their kind
  (`reordering_iff_course`): **the numberings a world's reorderings give a stretch are exactly the
  orders of birth of the courses of growth of its order of exchanges.** The correspondence is between
  numberings: reorderings giving one numbering agree over the stretch
  (`Footprinted.reorder_determined`), and one course carries
  several numberings where the order has automorphisms (`VeeWorld.one_course_two_numberings`). Each
  reordering is a natural labelling and each natural labelling is a reordering's
  (`reordering_natural`, `natural_reordering`), so what holds on every natural labelling, or on
  some, holds on every reordering, or on some, for whatever is read on the stretch
  (`every_reordering_iff`, `some_reordering_iff`). With `Footprinted.converse`, a world whose
  footprint contains its exchanges, taking the same exchanges in the order of a course, agrees with
  a reordering over the stretch (`course_converse`).
* **The decisions on the World.** An exchange precedes a later one exactly where it is joined to it
  or precedes an exchange between them joined to it (`precedes_iff_last`). So joining decided on
  the stretch decides precedence on it, by search over the steps between (`precedes_decided`), and
  joining weakly decided weakly decides it (`precedes_weakly`).
* **The laws of presence on the World, by instance of `Becoming.Presence`**, where the footprint
  contains the exchanges. With no decision, an exchange is taken before another on every reordering
  exactly where its preceding it is not refuted (`every_reordering_not_not`), and with that
  precedence decided exactly where it precedes it (`precedes_iff_every_reordering`; with joining
  decided on the stretch, `precedes_iff_every_reordering_of_joined`). With precedence weakly decided
  on the stretch, one exchange is taken before another on some reordering exactly where the two
  differ and the other does not precede it (`before_some_reordering`), so two different unrelated
  exchanges are taken in either order (`either_order_reordering`). The present of any numbering at a
  stage (`Presence.MaximalBorn`: the exchanges taken by then that precede none taken by then) is an
  antichain of the order of exchanges (`present_unrelated`); with precedence weakly decided every
  antichain given by a Boolean test is the present of some reordering at some stage
  (`antichain_present_reordering`), and two exchanges of the stretch are present together on some
  reordering exactly where neither precedes the other (`together_some_reordering`), and on every
  reordering, with no decision, exactly where, doubly negated, they precede the same exchanges of the
  stretch (`together_every_reordering_not_not`). An exchange is
  present when another is taken (`Presence.PresentAt`) on some reordering exactly where it is a link
  below it in the order of exchanges (`present_some_reordering`, precedence weakly decided), and on
  every reordering exactly where that is the one exchange of the stretch it is linked to
  (`present_every_reordering`, no decision).
* **What presence means on the World.** On the world as it is, an exchange is present when another
  is taken exactly where it precedes it and no exchange between is joined to it
  (`present_identity_iff`, by `first_of_precedes`). So, where the footprint contains the exchanges,
  it leaves every relatum it touched shown when the other is taken as right after its own step
  (`persists_of_present`): no step between touches one, since a step touching one would be joined to
  it. On a reordering on which it is present, the reordered world shows them so when the other is
  taken (`persists_of_present_reordering`). The converse fails wherever what the earlier exchange
  touched persists while an exchange between is joined to it: one joined through a dependence, in a
  world of three exchanges meeting activity needing support (`ByDependence.persists_not_present`),
  or ones that move what it touched and move it back, in a world with no dependence and the least
  footprint (`MovedBack.persists_not_present`). So presence at a step is stronger than persistence: what it
  adds is that nothing between is joined to the earlier exchange.
* **The vee as a world** (`VeeWorld`): one exchange touching two relata, then one touching the first
  and one touching the second. Its order of exchanges is the vee of `Becoming.Presence`
  (`VeeWorld.prec_iff_vee`, `VeeWorld.natural_iff_vee`); the two later exchanges are not joined, so
  commuting them is a reordering (`VeeWorld.reordering`), and the first exchange is present when the
  last is taken on that reordering and not on the world as it is (`VeeWorld.presence_varies`). The
  two numberings are by one and the same course, its two later births matched to the two later
  exchanges the other way round (`VeeWorld.one_course_two_numberings`): what varies is the matching.

**Modelling choices.** The stretch is the first `m` steps (a stretch from another step is not
read); the footprint is given, decided relatum by relatum, and contains the exchanges where a law
says so, and the order of exchanges is relative to it; a footprint may touch a relatum it does not
move. Precedence is decided, or weakly decided, on
the stretch where a law says so; joining decided, or weakly decided, on the stretch gives it.
Presence is read on the order of exchanges as `Becoming.Presence` reads it on causal-set growth, as
being among the maximal exchanges taken, and the antichains are given by a Boolean test. Processes
in general, which have no footprint, continuous time, infinite stretches and the present of a
center are not read. Every declaration has an empty axiom report.
-/

namespace Becoming

namespace ReorderingGrowth

open CausalGrowth (Causet links process empty)
open Presence (NaturalLabelling MaximalBorn PresentAt)

variable {X : Type}

/-! ## The exchanges of a stretch as a causal set -/

/-- **The exchanges of a stretch**: the first `m` steps, the exchange across `i` preceding that
across `j` where both lie in the stretch and `r.Precedes i j`. -/
def exchanges (r : Footprinted X) (m : Nat) : Causet :=
  ⟨m, fun i j => i < m ∧ j < m ∧ r.Precedes i j⟩

/-- **The exchanges of a stretch form a causal set**: transitive by `Precedes.trans`, each preceded
only by earlier steps by `Precedes.lt`. -/
theorem exchanges_ordered (r : Footprinted X) (m : Nat) : (exchanges r m).Ordered where
  trans := fun first second => match first, second with
    | ⟨hi, _, p⟩, ⟨_, hk, q⟩ => ⟨hi, hk, .trans p q⟩
  labelled := fun pair => match pair with
    | ⟨_, _, p⟩ => p.lt
  within := fun pair => match pair with
    | ⟨_, hj, _⟩ => hj

/-- `ts` **reorders the stretch** of the first `m` steps: each commutation lies within it and takes
two exchanges not joined, in the world as it then stands. The exchange across step `n` comes to
step `place ts n`. -/
def Reordering (r : Footprinted X) (m : Nat) (ts : List Nat) : Prop :=
  EachStep (fun t => 0 ≤ t ∧ t + 2 ≤ 0 + m) ts ∧ r.Independent ts

/-! ## Its natural labellings are the reorderings -/

section Natural

variable {r : Footprinted X} {m : Nat} {π σ : Nat → Nat}

/-- **A renumbering keeping the order of joined exchanges keeps the order they generate**:
increasing along each joined pair, the earlier first, it increases along every chain of them. -/
theorem keeps_precedes {S : Nat} (keeps : r.Keeps S m π) :
    ∀ {i j : Nat}, r.Precedes i j → S ≤ i → j < S + m → π i < π j
  | _, _, .joined lt link, from_, below => keeps _ _ from_ below lt link
  | _, _, .trans first second, from_, below =>
    Nat.lt_trans (keeps_precedes keeps first from_ (Nat.lt_trans second.lt below))
      (keeps_precedes keeps second (Nat.le_trans from_ (Nat.le_of_lt first.lt)) below)

/-- **The natural labellings of the stretch's exchanges are the renumberings of the stretch keeping
the order of joined exchanges.** -/
theorem natural_iff : NaturalLabelling (exchanges r m) π σ ↔ Reindexes 0 m π σ ∧ r.Keeps 0 m π :=
  ⟨fun natural => ⟨natural.1, fun i j from_ below lt link =>
     natural.2 i j from_ below lt
       ⟨Nat.lt_trans lt (Presence.of_lt_zero_add below), Presence.of_lt_zero_add below,
        .joined lt link⟩⟩,
   fun ⟨reindex, keeps⟩ => ⟨reindex, fun _ _ from_ below _ pair => match pair with
     | ⟨_, _, p⟩ => keeps_precedes keeps p from_ below⟩⟩

/-- **Each reordering of the stretch is a natural labelling of its exchanges**, the steps the
exchanges came from taking them back. -/
theorem reordering_natural (contains : r.Contains) {ts : List Nat} (reordering : Reordering r m ts) :
    NaturalLabelling (exchanges r m) (place ts) (origin ts) :=
  natural_iff.mpr ⟨reindexes_of_within reordering.1,
    fun _ _ _ _ lt link => Footprinted.Independent.keeps contains reordering.2 lt link⟩

/-- **Each natural labelling of the stretch's exchanges is a reordering's**: some reordering of the
stretch takes each of its exchanges where the labelling does (`Footprinted.sorts`). -/
theorem natural_reordering (contains : r.Contains) (natural : NaturalLabelling (exchanges r m) π σ) :
    ∃ ts, Reordering r m ts ∧ ∀ i, i < m → place ts i = π i :=
  match Footprinted.sorts m 0 contains (natural_iff.mp natural).1 (natural_iff.mp natural).2 with
  | ⟨ts, within, independent, places⟩ =>
    ⟨ts, ⟨within, independent⟩, fun i hi => places i (Nat.zero_le i) (Presence.lt_zero_add hi)⟩

/-- **What holds on every natural labelling holds on every reordering**, and conversely, for what is
read on the stretch: a property of numberings carried by the numbers they give the stretch's
exchanges. -/
theorem every_reordering_iff (contains : r.Contains) {Φ : (Nat → Nat) → Prop}
    (stretch : ∀ π π' : Nat → Nat, (∀ k, k < m → π k = π' k) → Φ π → Φ π') :
    (∀ π σ, NaturalLabelling (exchanges r m) π σ → Φ π) ↔ ∀ ts, Reordering r m ts → Φ (place ts) :=
  ⟨fun every _ reordering => every _ _ (reordering_natural contains reordering),
   fun every _ _ natural => match natural_reordering contains natural with
     | ⟨ts, reordering, places⟩ => stretch _ _ places (every ts reordering)⟩

/-- **What holds on some natural labelling holds on some reordering**, and conversely, for what is
read on the stretch. -/
theorem some_reordering_iff (contains : r.Contains) {Φ : (Nat → Nat) → Prop}
    (stretch : ∀ π π' : Nat → Nat, (∀ k, k < m → π k = π' k) → Φ π → Φ π') :
    (∃ π σ, NaturalLabelling (exchanges r m) π σ ∧ Φ π) ↔ ∃ ts, Reordering r m ts ∧ Φ (place ts) :=
  ⟨fun ⟨_, _, natural, holds⟩ => match natural_reordering contains natural with
     | ⟨ts, reordering, places⟩ =>
       ⟨ts, reordering, stretch _ _ (fun k hk => (places k hk).symm) holds⟩,
   fun ⟨_, reordering, holds⟩ => ⟨_, _, reordering_natural contains reordering, holds⟩⟩

/-- **Where every two consecutive exchanges of the stretch are joined, the only reordering of the
stretch is the world as it is.** -/
theorem reordering_nil (chain : ∀ t, t + 2 ≤ m → r.Joined t (t + 1)) :
    ∀ ts, Reordering r m ts → ts = []
  | [], _ => rfl
  | t :: _, ⟨⟨⟨_, bound⟩, _⟩, ⟨apart, _⟩⟩ =>
    absurd (chain t (Eq.subst (motive := fun v => t + 2 ≤ v) (Nat.zero_add m) bound)) apart

/-- **The numberings a world's reorderings give a stretch are the orders of birth of the courses of
growth of its order of exchanges.** Where the footprint contains the exchanges, a renumbering of the
stretch is the numbering of some reordering exactly where it is a natural labelling of the stretch's
exchanges, and exactly where it numbers them by a course of causal-set growth from the empty set
whose configuration at the stretch's size is of their kind (`Presence.natural_iff_course`): on such a
course the exchange across step `i` is the element born at offset `π i`. -/
theorem reordering_iff_course (contains : r.Contains) (reindex : Reindexes 0 m π σ) :
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

end Natural

/-- **Every world taking the stretch's exchanges in the order of a course agrees with a
reordering** (`Footprinted.converse`). Where both footprints contain the exchanges and `r₂` takes
across step `π i` the exchange `r` takes across `i`, touches what it touches, shows what it
touches after the step as `r` does and starts as `r` does, and `π` numbers the stretch's exchanges by a course of causal-set growth from the empty
set (a relabelling onto its configuration at the stretch's size), some reordering of the stretch
takes each exchange where `π` does, takes the exchanges `r₂` takes, and shows every relatum at every
step of the stretch as `r₂` does. -/
theorem course_converse {r r₂ : Footprinted X} {m : Nat} {π σ : Nat → Nat} (contains : r.Contains)
    (contains₂ : r₂.Contains) {run : Run process} (start : run.state 0 = empty)
    (relabels : CausalGrowth.Kinds.Relabels (exchanges r m) (run.state m) π σ)
    (same : ∀ i, i < m → r.flow.SameExchange i r₂.flow (π i))
    (footprints : ∀ i x, i < m → r₂.touch (π i) x = r.touch i x)
    (changes : ∀ i x, i < m → r.touch i x = true → r.web.SameAt (i + 1) r₂.web (π i + 1) x)
    (begins : ∀ x, r.web.SameAt 0 r₂.web 0 x) :
    ∃ ts, Reordering r m ts ∧ (∀ i, i < m → place ts i = π i) ∧
      (∀ a, a < m → (r.reorder ts).flow.SameExchange a r₂.flow a) ∧
      ∀ k x, k ≤ m → (r.reorder ts).web.SameAt k r₂.web k x :=
  have natural := (Presence.natural_iff_course (exchanges_ordered r m)).mpr ⟨run, start, relabels⟩
  match Footprinted.converse contains contains₂ (natural_iff.mp natural).1 (natural_iff.mp natural).2
      (fun i _ below => same i (Presence.of_lt_zero_add below))
      (fun i x _ below => footprints i x (Presence.of_lt_zero_add below))
      (fun i x _ below => changes i x (Presence.of_lt_zero_add below)) begins with
  | ⟨ts, within, independent, places, exchanged, shown⟩ =>
    ⟨ts, ⟨within, independent⟩, fun i hi => places i (Nat.zero_le i) (Presence.lt_zero_add hi),
     fun a ha => exchanged a (Nat.zero_le a) (Presence.lt_zero_add ha),
     fun k x hk => shown k x (Nat.zero_le k)
       (Eq.subst (motive := fun v => k ≤ v) (Nat.zero_add m).symm hk)⟩

/-! ## The decisions on the World -/

section Decisions

variable {r : Footprinted X} {m : Nat}

/-- **The last link**: where one exchange precedes another, it is joined to it, or it precedes an
exchange between them joined to it. -/
theorem last_of_precedes : ∀ {i j : Nat}, r.Precedes i j →
    (i < j ∧ r.Joined i j) ∨ ∃ k, k < j ∧ i < k ∧ r.Precedes i k ∧ r.Joined k j
  | _, _, .joined lt link => .inl ⟨lt, link⟩
  | _, _, .trans first second => match last_of_precedes second with
    | .inl ⟨lt, link⟩ => .inr ⟨_, lt, first.lt, first, link⟩
    | .inr ⟨k, kj, mk, before, link⟩ =>
      .inr ⟨k, kj, Nat.lt_trans first.lt mk, .trans first before, link⟩

/-- **An exchange precedes a later one exactly where it is joined to it or precedes an exchange
between them joined to it.** -/
theorem precedes_iff_last {i j : Nat} :
    r.Precedes i j ↔ (i < j ∧ r.Joined i j) ∨ ∃ k, k < j ∧ i < k ∧ r.Precedes i k ∧ r.Joined k j :=
  ⟨last_of_precedes, fun last => match last with
    | .inl ⟨lt, link⟩ => .joined lt link
    | .inr ⟨_, kj, _, before, link⟩ => .trans before (.joined kj link)⟩

/-- Joining decided on the stretch decides, for each exchange of the stretch below `n`, which
exchanges precede it: by search over the steps between, those below it decided first. -/
theorem precedes_decided_below (decided : ∀ a b, a < b → b < m → Decided (r.Joined a b)) :
    ∀ n j, j < n → j < m → ∀ i, Decided (r.Precedes i j)
  | 0, _, below, _, _ => absurd below (Nat.not_lt_zero _)
  | n + 1, j, below, hj, i =>
    have direct : Decided (i < j ∧ r.Joined i j) := match Nat.decLt i j with
      | .isTrue lt => match decided i j lt hj with
        | .inl link => .inl ⟨lt, link⟩
        | .inr apart => .inr fun both => apart both.2
      | .isFalse late => .inr fun both => late both.1
    have between : Decided (∃ k, 0 ≤ k ∧ k < j ∧ (i < k ∧ r.Precedes i k ∧ r.Joined k j)) :=
      Decided.exists_below fun k _ kj => match Nat.decLt i k with
        | .isFalse late => .inr fun h => late h.1
        | .isTrue lt =>
          match precedes_decided_below decided n k (Nat.lt_of_lt_of_le kj (Nat.le_of_lt_succ below))
              (Nat.lt_trans kj hj) i, decided k j kj hj with
          | .inl before, .inl link => .inl ⟨lt, before, link⟩
          | .inr absent, _ => .inr fun h => absent h.2.1
          | _, .inr apart => .inr fun h => apart h.2.2
    match direct, between with
    | .inl ⟨lt, link⟩, _ => .inl (.joined lt link)
    | _, .inl ⟨_, _, kj, _, before, link⟩ => .inl (.trans before (.joined kj link))
    | .inr no, .inr absent => .inr fun before => match last_of_precedes before with
      | .inl d => no d
      | .inr ⟨k, kj, lt, before', link⟩ => absent ⟨k, Nat.zero_le k, kj, lt, before', link⟩

/-- **Joining decided on the stretch decides precedence on it.** -/
theorem precedes_decided (decided : ∀ a b, a < b → b < m → Decided (r.Joined a b)) {i j : Nat}
    (hj : j < m) : Decided (r.Precedes i j) :=
  precedes_decided_below decided (j + 1) j (Nat.lt_succ_self j) hj i

/-- Joining weakly decided on the stretch weakly decides, for each exchange of the stretch below
`n`, which exchanges precede it. -/
theorem precedes_weakly_below (weakly : ∀ a b, a < b → b < m → WeaklyDecided (r.Joined a b)) :
    ∀ n j, j < n → j < m → ∀ i, WeaklyDecided (r.Precedes i j)
  | 0, _, below, _, _ => absurd below (Nat.not_lt_zero _)
  | n + 1, j, below, hj, i =>
    have direct : WeaklyDecided (i < j ∧ r.Joined i j) := match Nat.decLt i j with
      | .isTrue lt => match weakly i j lt hj with
        | .inl apart => .inl fun both => apart both.2
        | .inr unrefuted => .inr fun no => unrefuted fun link => no ⟨lt, link⟩
      | .isFalse late => .inl fun both => late both.1
    have between : WeaklyDecided (∃ k, k < j ∧ (i < k ∧ r.Precedes i k ∧ r.Joined k j)) :=
      Presence.weakly_exists_below fun k kj => match Nat.decLt i k with
        | .isFalse late => .inl fun h => late h.1
        | .isTrue lt =>
          match precedes_weakly_below weakly n k (Nat.lt_of_lt_of_le kj (Nat.le_of_lt_succ below))
              (Nat.lt_trans kj hj) i, weakly k j kj hj with
          | .inl absent, _ => .inl fun h => absent h.2.1
          | _, .inl apart => .inl fun h => apart h.2.2
          | .inr unrefuted, .inr unrefuted' =>
            .inr fun no => unrefuted fun before => unrefuted' fun link => no ⟨lt, before, link⟩
    match direct, between with
    | .inr unrefuted, _ => .inr fun no => unrefuted fun ⟨lt, link⟩ => no (.joined lt link)
    | _, .inr unrefuted => .inr fun no => unrefuted fun ⟨_, kj, _, before, link⟩ =>
        no (.trans before (.joined kj link))
    | .inl no, .inl absent => .inl fun before => match last_of_precedes before with
      | .inl d => no d
      | .inr ⟨k, kj, lt, before', link⟩ => absent ⟨k, kj, lt, before', link⟩

/-- **Joining weakly decided on the stretch weakly decides precedence on it.** -/
theorem precedes_weakly (weakly : ∀ a b, a < b → b < m → WeaklyDecided (r.Joined a b)) :
    ∀ i j, i < m → j < m → WeaklyDecided (r.Precedes i j) :=
  fun i j _ hj => precedes_weakly_below weakly (j + 1) j (Nat.lt_succ_self j) hj i

/-- Precedence weakly decided on the stretch weakly decides the precedence of its exchanges. -/
theorem exchanges_weakly (weakly : ∀ a b, a < m → b < m → WeaklyDecided (r.Precedes a b)) :
    ∀ a b, WeaklyDecided ((exchanges r m).prec a b) :=
  fun a b => match Nat.decLt a m, Nat.decLt b m with
  | .isTrue ha, .isTrue hb => match weakly a b ha hb with
    | .inl fails => .inl fun pair => match pair with
      | ⟨_, _, p⟩ => fails p
    | .inr unrefuted => .inr fun no => unrefuted fun p => no ⟨ha, hb, p⟩
  | .isFalse na, _ => .inl fun pair => match pair with
    | ⟨ha, _, _⟩ => na ha
  | _, .isFalse nb => .inl fun pair => match pair with
    | ⟨_, hb, _⟩ => nb hb

/-- **Below an exchange of the stretch, the links of the stretch's exchanges are the links of the
order of exchanges.** -/
theorem links_exchanges {i k : Nat} (hk : k < m) :
    links (exchanges r m).prec i k ↔ links r.Precedes i k :=
  ⟨fun ⟨pair, nothing⟩ => match pair with
     | ⟨_, _, p⟩ => ⟨p, fun z ⟨first, second⟩ =>
         nothing z ⟨⟨Nat.lt_trans first.lt (Nat.lt_trans second.lt hk), Nat.lt_trans second.lt hk, first⟩,
           ⟨Nat.lt_trans second.lt hk, hk, second⟩⟩⟩,
   fun ⟨p, nothing⟩ => ⟨⟨Nat.lt_trans p.lt hk, hk, p⟩, fun z ⟨first, second⟩ =>
     match first, second with
     | ⟨_, _, pz⟩, ⟨_, _, zk⟩ => nothing z ⟨pz, zk⟩⟩⟩

end Decisions

/-! ## The laws of presence on the World -/

section Laws

variable {r : Footprinted X} {m : Nat}

/-- Which of two exchanges of the stretch a numbering takes first is read on the stretch. -/
theorem before_stretch {i j : Nat} (hi : i < m) (hj : j < m) (π π' : Nat → Nat)
    (same : ∀ k, k < m → π k = π' k) (lt : π i < π j) : π' i < π' j :=
  Eq.subst (motive := fun v => v < π' j) (same i hi)
    (Eq.subst (motive := fun v => π i < v) (same j hj) lt)

/-- The present of a numbering at a stage is read on the stretch. -/
theorem maximalBorn_stretch {t x : Nat} (π π' : Nat → Nat) (same : ∀ k, k < m → π k = π' k)
    (present : MaximalBorn (exchanges r m) π t x) : MaximalBorn (exchanges r m) π' t x :=
  match present with
  | ⟨hx, born, after⟩ => ⟨hx, Eq.subst (motive := fun v => v < t) (same x hx) born,
      fun k pair => match pair with
        | ⟨hx', hk, p⟩ => Eq.subst (motive := fun v => t ≤ v) (same k hk) (after k ⟨hx', hk, p⟩)⟩

/-- Presence when an exchange is taken is read on the stretch. -/
theorem presentAt_stretch {i j : Nat} (π π' : Nat → Nat) (same : ∀ k, k < m → π k = π' k)
    (present : PresentAt (exchanges r m) π i j) : PresentAt (exchanges r m) π' i j :=
  match present with
  | ⟨⟨hi, hj, p⟩, after⟩ => ⟨⟨hi, hj, p⟩, fun k first => match first with
    | ⟨hi', hk, q⟩ => Eq.subst (motive := fun v => v ≤ π' k) (same j hj)
        (Eq.subst (motive := fun v => π j ≤ v) (same k hk) (after k ⟨hi', hk, q⟩))⟩

/-- **Taken before on every reordering, with no decision, is precedence not refuted**
(`Presence.every_iff_not_not` on the stretch's exchanges). -/
theorem every_reordering_not_not (contains : r.Contains) {i j : Nat} (hi : i < m) (hj : j < m) :
    (∀ ts, Reordering r m ts → place ts i < place ts j) ↔ ¬ ¬ r.Precedes i j :=
  (every_reordering_iff contains (Φ := fun π => π i < π j) (before_stretch hi hj)).symm.trans
    ((Presence.every_iff_not_not (exchanges_ordered r m) hi hj).trans
      ⟨fun unrefuted fails => unrefuted fun pair => match pair with
         | ⟨_, _, p⟩ => fails p,
       fun unrefuted fails => unrefuted fun p => fails ⟨hi, hj, p⟩⟩)

/-- **The order of exchanges is the order every reordering agrees on** (Szpilrajn's extension theorem
in Dushnik and Miller's intersection form, read on the World through `Presence.every_iff_not_not`):
with the precedence of the pair decided, the exchange across `i` precedes that across `j` exactly
where every reordering of the stretch takes it first. -/
theorem precedes_iff_every_reordering (contains : r.Contains) {i j : Nat} (hi : i < m) (hj : j < m)
    (decided : Decided (r.Precedes i j)) :
    r.Precedes i j ↔ ∀ ts, Reordering r m ts → place ts i < place ts j :=
  ⟨fun p => (every_reordering_not_not contains hi hj).mpr fun fails => fails p,
   fun every => decided.of_not_not ((every_reordering_not_not contains hi hj).mp every)⟩

/-- **So with joining decided on the stretch**, the order of exchanges is the order every
reordering agrees on (`precedes_decided`). -/
theorem precedes_iff_every_reordering_of_joined (contains : r.Contains)
    (decided : ∀ a b, a < b → b < m → Decided (r.Joined a b)) {i j : Nat} (hi : i < m) (hj : j < m) :
    r.Precedes i j ↔ ∀ ts, Reordering r m ts → place ts i < place ts j :=
  precedes_iff_every_reordering contains hi hj (precedes_decided decided hj)

/-- **Taken before on some reordering** (`Presence.before_some_iff`): with precedence weakly decided
on the stretch, one exchange of it is taken before another on some reordering exactly where the two
differ and the other does not precede it. -/
theorem before_some_reordering (contains : r.Contains)
    (weakly : ∀ a b, a < m → b < m → WeaklyDecided (r.Precedes a b)) {i j : Nat} (hi : i < m)
    (hj : j < m) :
    (∃ ts, Reordering r m ts ∧ place ts i < place ts j) ↔ i ≠ j ∧ ¬ r.Precedes j i :=
  (some_reordering_iff contains (Φ := fun π => π i < π j) (before_stretch hi hj)).symm.trans
    ((Presence.before_some_iff (exchanges_weakly weakly) (exchanges_ordered r m) hi hj).trans
      ⟨fun ⟨ne, np⟩ => ⟨ne, fun p => np ⟨hj, hi, p⟩⟩,
       fun ⟨ne, np⟩ => ⟨ne, fun pair => match pair with
         | ⟨_, _, p⟩ => np p⟩⟩)

/-- **No order of unrelated exchanges is common to all reorderings**: with precedence weakly
decided on the stretch, two different exchanges of it neither of which precedes the other are taken
in either order, each on some reordering. -/
theorem either_order_reordering (contains : r.Contains)
    (weakly : ∀ a b, a < m → b < m → WeaklyDecided (r.Precedes a b)) {x y : Nat} (hx : x < m)
    (hy : y < m) (nxy : ¬ r.Precedes x y) (nyx : ¬ r.Precedes y x) (ne : x ≠ y) :
    (∃ ts, Reordering r m ts ∧ place ts x < place ts y) ∧
      (∃ ts, Reordering r m ts ∧ place ts y < place ts x) :=
  ⟨(before_some_reordering contains weakly hx hy).mpr ⟨ne, nyx⟩,
   (before_some_reordering contains weakly hy hx).mpr ⟨fun e => ne e.symm, nxy⟩⟩

/-- **The present is an antichain of the order of exchanges** (`Presence.maximalBorn_unrelated`):
of two exchanges in the present of any numbering at one stage, neither precedes the other. -/
theorem present_unrelated {π : Nat → Nat} {t x y : Nat} (fx : MaximalBorn (exchanges r m) π t x)
    (fy : MaximalBorn (exchanges r m) π t y) : ¬ r.Precedes x y :=
  fun p => Presence.maximalBorn_unrelated fx fy ⟨fx.1, fy.1, p⟩

/-- **Every antichain is the present of a reordering** (`Presence.antichain_present`): with
precedence weakly decided on the stretch, the exchanges of the stretch a Boolean test passes, none
preceding another, are exactly the present of some reordering at some stage. -/
theorem antichain_present_reordering (contains : r.Contains)
    (weakly : ∀ a b, a < m → b < m → WeaklyDecided (r.Precedes a b)) (q : Nat → Bool)
    (inside : ∀ {x}, q x = true → x < m)
    (apart : ∀ {x y}, q x = true → q y = true → ¬ r.Precedes x y) :
    ∃ ts t, Reordering r m ts ∧ ∀ x, MaximalBorn (exchanges r m) (place ts) t x ↔ q x = true :=
  match Presence.antichain_present (exchanges_weakly weakly) (exchanges_ordered r m) q inside
      (fun qx qy pair => match pair with
        | ⟨_, _, p⟩ => apart qx qy p) with
  | ⟨_, _, t, natural, present⟩ => match natural_reordering contains natural with
    | ⟨ts, reordering, places⟩ => ⟨ts, t, reordering, fun x =>
        ⟨fun fx => (present x).mp (maximalBorn_stretch _ _ places fx),
         fun qx => maximalBorn_stretch _ _ (fun k hk => (places k hk).symm) ((present x).mpr qx)⟩⟩

/-- **Present together on some reordering exactly where unrelated** (`Presence.together_some_iff`):
with precedence weakly decided on the stretch, two exchanges are in the present of some reordering
at some stage exactly where both lie in the stretch and neither precedes the other. -/
theorem together_some_reordering (contains : r.Contains)
    (weakly : ∀ a b, a < m → b < m → WeaklyDecided (r.Precedes a b)) {x y : Nat} :
    (∃ ts t, Reordering r m ts ∧ MaximalBorn (exchanges r m) (place ts) t x ∧
        MaximalBorn (exchanges r m) (place ts) t y) ↔
      x < m ∧ y < m ∧ ¬ r.Precedes x y ∧ ¬ r.Precedes y x :=
  ⟨fun ⟨_, _, _, fx, fy⟩ => ⟨fx.1, fy.1, present_unrelated fx fy, present_unrelated fy fx⟩,
   fun ⟨hx, hy, nxy, nyx⟩ =>
     match (Presence.together_some_iff (exchanges_weakly weakly) (exchanges_ordered r m)).mpr
         ⟨hx, hy, fun pair => match pair with
           | ⟨_, _, p⟩ => nxy p,
          fun pair => match pair with
           | ⟨_, _, p⟩ => nyx p⟩ with
     | ⟨_, _, t, natural, fx, fy⟩ => match natural_reordering contains natural with
       | ⟨ts, reordering, places⟩ => ⟨ts, t, reordering,
           maximalBorn_stretch _ _ (fun k hk => (places k hk).symm) fx,
           maximalBorn_stretch _ _ (fun k hk => (places k hk).symm) fy⟩⟩

/-- **Present together on every reordering, with no decision** (`Presence.together_every_iff_not_not`):
two exchanges of the stretch are in the present of every reordering at some stage exactly where,
doubly negated, they precede the same exchanges of the stretch. -/
theorem together_every_reordering_not_not (contains : r.Contains) {x y : Nat} (hx : x < m)
    (hy : y < m) :
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

/-- **An exchange can be present when another is taken exactly where it is a link below it**
(`Presence.present_some_iff_link`): with precedence weakly decided on the stretch, the exchange
across `i` is present when that across `j` is taken, on some reordering, exactly where `i` is a link
below `j` in the order of exchanges. -/
theorem present_some_reordering (contains : r.Contains)
    (weakly : ∀ a b, a < m → b < m → WeaklyDecided (r.Precedes a b)) {i j : Nat} (hj : j < m) :
    (∃ ts, Reordering r m ts ∧ PresentAt (exchanges r m) (place ts) i j) ↔ links r.Precedes i j :=
  (some_reordering_iff contains (Φ := fun π => PresentAt (exchanges r m) π i j)
      presentAt_stretch).symm.trans
    ((Presence.present_some_iff_link (exchanges_weakly weakly) (exchanges_ordered r m) hj).trans
      (links_exchanges hj))

/-- **An exchange must be present when another is taken exactly where that is the one exchange of
the stretch it is linked to** (`Presence.present_every_iff_only_link`), with no decision: the
exchange across `i` is present when that across `j` is taken on every reordering exactly where `i`
is a link below `j` and a link below no other exchange of the stretch. -/
theorem present_every_reordering (contains : r.Contains) {i j : Nat} (hj : j < m) :
    (∀ ts, Reordering r m ts → PresentAt (exchanges r m) (place ts) i j) ↔
      links r.Precedes i j ∧ ∀ k, k < m → links r.Precedes i k → k = j :=
  (every_reordering_iff contains (Φ := fun π => PresentAt (exchanges r m) π i j)
      presentAt_stretch).symm.trans
    ((Presence.present_every_iff_only_link (exchanges_ordered r m)).trans
      ⟨fun ⟨link, only⟩ => ⟨(links_exchanges hj).mp link,
         fun k hk link' => only k ((links_exchanges hk).mpr link')⟩,
       fun ⟨link, only⟩ => ⟨(links_exchanges hj).mpr link, fun k link' => match link' with
         | ⟨⟨hi, hk, p⟩, nothing⟩ => only k hk ((links_exchanges hk).mp ⟨⟨hi, hk, p⟩, nothing⟩)⟩⟩)

end Laws

/-! ## What presence means on the World -/

/-- A relatum unmoved across each step from `a` up to `a + d` is shown at `a + d` as at `a`. -/
theorem sameAt_of_unmoved {W : Web X X} {x : X} {a : Nat} :
    ∀ d, (∀ k, a ≤ k → k < a + d → W.Unmoved k x) → W.SameAt a W (a + d) x
  | 0, _ => Web.SameAt.refl W a x
  | d + 1, unmoved =>
    (sameAt_of_unmoved d fun k lo hi => unmoved k lo (Nat.lt_succ_of_lt hi)).trans
      (unmoved (a + d) (Nat.le_add_right a d) (Nat.lt_succ_self (a + d)))

/-- **The first link**: where one exchange precedes another, it is joined to an exchange after it
and no later than the other. -/
theorem first_of_precedes {r : Footprinted X} : ∀ {i k : Nat}, r.Precedes i k →
    ∃ k', i < k' ∧ k' ≤ k ∧ r.Joined i k'
  | _, _, .joined lt link => ⟨_, lt, Nat.le_refl _, link⟩
  | _, _, .trans first second => match first_of_precedes first with
    | ⟨k', lt, le, link⟩ => ⟨k', lt, Nat.le_trans le (Nat.le_of_lt second.lt), link⟩

/-- **Presence on the world as it is**: the exchange across `i` is present when that across `j` is
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

/-- **What a condition left is still there when what it conditions is taken.** Where the footprint
contains the exchanges, if the exchange across step `i` is present when that across `j` is taken,
on the world as it is, every relatum `i` touches is shown at step `j` as right after `i`'s step: a
step between touching it would be joined to `i`, so preceded by it, and a relatum a step does not
touch is unmoved across it. -/
theorem persists_of_present {r : Footprinted X} {m : Nat} (contains : r.Contains) {i j : Nat}
    (present : PresentAt (exchanges r m) (fun k => k) i j) {x : X} (touched : r.touch i x = true) :
    r.web.SameAt (i + 1) r.web j x :=
  match present with
  | ⟨⟨hi, hj, p⟩, after⟩ =>
    have untouched : ∀ k, i + 1 ≤ k → k < j → r.touch k x = false := fun k lo hk =>
      match h : r.touch k x with
      | true => absurd (after k ⟨hi, Nat.lt_trans hk hj, .joined lo (.inl ⟨x, touched, h⟩)⟩)
          (Nat.not_le_of_lt hk)
      | false => rfl
    match le_dest (Nat.succ_le_of_lt p.lt) with
    | ⟨d, e⟩ => Eq.subst (motive := fun v => r.web.SameAt (i + 1) r.web v x) e.symm
        (sameAt_of_unmoved d fun k lo hk =>
          (contains k x (untouched k lo (Eq.subst (motive := fun v => k < v) e.symm hk))).2)

/-- **On a reordering, too**: where the footprint contains the exchanges and the exchange across
step `i` is present when that across `j` is taken on a reordering of the stretch, the reordered
world shows every relatum `i` touches, at the step it takes `j`'s exchange to, as the world shows it
right after `i`'s step. -/
theorem persists_of_present_reordering {r : Footprinted X} {m : Nat} (contains : r.Contains)
    {ts : List Nat} (reordering : Reordering r m ts) {i j : Nat}
    (present : PresentAt (exchanges r m) (place ts) i j) {x : X} (touched : r.touch i x = true) :
    r.web.SameAt (i + 1) (r.reorder ts).web (place ts j) x :=
  match present with
  | ⟨⟨hi, hj, p⟩, after⟩ =>
    have placed : ∀ {k}, k < m → place ts k < m := fun hk =>
      Presence.of_lt_zero_add (place_within reordering.1 (Nat.zero_le _) (Presence.lt_zero_add hk)).2
    have present' : PresentAt (exchanges (r.reorder ts) m) (fun k => k) (place ts i) (place ts j) :=
      ⟨⟨placed hi, placed hj, (Footprinted.precedes_place contains reordering.2).mp p⟩,
       fun k' pair => match pair with
         | ⟨_, hk', p'⟩ =>
           have back := origin_within reordering.1 (Nat.zero_le k') (Presence.lt_zero_add hk')
           have here : place ts (origin ts k') = k' := place_origin ts k'
           have before : r.Precedes i (origin ts k') :=
             (Footprinted.precedes_place contains reordering.2).mpr
               (Eq.subst (motive := fun v => (r.reorder ts).Precedes (place ts i) v) here.symm p')
           Eq.subst (motive := fun v => place ts j ≤ v) here
             (after (origin ts k') ⟨hi, Presence.of_lt_zero_add back.2, before⟩)⟩
    have touched' : r.touch (origin ts (place ts i)) x = true :=
      Eq.subst (motive := fun v => r.touch v x = true) (origin_place ts i).symm touched
    have shows := (Footprinted.reorder_shows contains reordering.2 (m := place ts i) touched').2
    (Eq.subst (motive := fun v => r.web.SameAt (v + 1) (r.reorder ts).web (place ts i + 1) x)
        (origin_place ts i) shows).trans
      (persists_of_present (Footprinted.reorder_contains contains reordering.2) present'
        ((Footprinted.reorder_touch r ts (place ts i) x).trans touched'))

/-! ## Witnesses -/

namespace ByDependence

/-- The relatum `0` stands at one and rises across the first and the last of three steps, the
relatum `1` rises across the middle one. -/
def standing : Nat → Nat → Nat
  | 0, 0 => 1
  | 0, _ => 0
  | 1, 0 => 2
  | 1, _ => 0
  | 2, 0 => 2
  | 2, 1 => 1
  | 2, _ => 0
  | _ + 3, 0 => 3
  | _ + 3, 1 => 1
  | _ + 3, _ => 0

/-- The relatum `1` depends on the relatum `0` throughout, needing it to stand at one. -/
def web : Web Nat Nat where
  level := standing
  active _ _ := True
  requires _ f c := f = 1 ∧ c = 0
  need _ _ _ := 1
  draws _ _ _ := False

/-- **The dependence is met**: the relatum `0` always stands at one or more, so activity needing
support holds. -/
theorem dependent : web.Dependent := fun t _ _ c needs => match t, c, needs with
  | 0, _, ⟨_, rfl⟩ => Nat.le_refl 1
  | 1, _, ⟨_, rfl⟩ => Nat.le_succ 1
  | 2, _, ⟨_, rfl⟩ => Nat.le_succ 1
  | _ + 3, _, ⟨_, rfl⟩ => Nat.le_succ_of_le (Nat.le_succ 1)

/-- The first and the last step touch the relatum `0`, the middle one the relatum `1`. -/
def touch : Nat → Nat → Bool
  | 0, 0 => true
  | 1, 1 => true
  | 2, 0 => true
  | _, _ => false

/-- Three exchanges, the flow empty (`Witnesses.emptyFlow`), so they change standings only: the first
and the last change the relatum `0`, the middle one changes the relatum `1`, which depends on `0`. -/
def world : Footprinted Nat := ⟨Witnesses.emptyFlow Nat Nat, web, touch⟩

/-- The footprint contains the exchanges. -/
theorem contains : world.Contains
  | 0, 0, no => Bool.noConfusion no
  | 0, 1, _ => ⟨(fun h => nomatch h), rfl, rfl, fun _ => ⟨rfl, rfl, rfl⟩⟩
  | 0, _ + 2, _ => ⟨(fun h => nomatch h), rfl, rfl, fun _ => ⟨rfl, rfl, rfl⟩⟩
  | 1, 0, _ => ⟨(fun h => nomatch h), rfl, rfl, fun _ => ⟨rfl, rfl, rfl⟩⟩
  | 1, 1, no => Bool.noConfusion no
  | 1, _ + 2, _ => ⟨(fun h => nomatch h), rfl, rfl, fun _ => ⟨rfl, rfl, rfl⟩⟩
  | 2, 0, no => Bool.noConfusion no
  | 2, 1, _ => ⟨(fun h => nomatch h), rfl, rfl, fun _ => ⟨rfl, rfl, rfl⟩⟩
  | 2, _ + 2, _ => ⟨(fun h => nomatch h), rfl, rfl, fun _ => ⟨rfl, rfl, rfl⟩⟩
  | _ + 3, 0, _ => ⟨(fun h => nomatch h), rfl, rfl, fun _ => ⟨rfl, rfl, rfl⟩⟩
  | _ + 3, 1, _ => ⟨(fun h => nomatch h), rfl, rfl, fun _ => ⟨rfl, rfl, rfl⟩⟩
  | _ + 3, _ + 2, _ => ⟨(fun h => nomatch h), rfl, rfl, fun _ => ⟨rfl, rfl, rfl⟩⟩

/-- The middle exchange is joined to the first through the relatum `1`'s dependence on `0`. -/
theorem joined_first_middle : world.Joined 0 1 :=
  .inr (.inr ⟨1, 0, rfl, rfl, .inl ⟨rfl, rfl⟩⟩)

/-- The last exchange is joined to the first through the relatum `0`. -/
theorem joined_first_last : world.Joined 0 2 :=
  .inl ⟨0, rfl, rfl⟩

/-- And to the middle one through the dependence. -/
theorem joined_middle_last : world.Joined 1 2 :=
  .inr (.inl ⟨1, 0, rfl, rfl, .inl ⟨rfl, rfl⟩⟩)

/-- **Persistence without presence, through a dependence.** The footprint contains the exchanges,
the first exchange precedes the last, and every relatum the first touches is shown when the last is
taken as right after the first; yet on no reordering of the three steps is the first present when
the last is taken: the middle exchange, which touches none of the first's relata, is joined to it
through its relatum's dependence on what the first touches, and precedes the last, so the first is
not a link below the last (`Presence.link_of_present`). Every two consecutive exchanges are joined,
so the only reordering is the world as it is (`only_reordering`). -/
theorem persists_not_present :
    world.Contains ∧ world.Precedes 0 2 ∧
      (∀ x, world.touch 0 x = true → world.web.SameAt (0 + 1) world.web 2 x) ∧
      (∀ ts, Reordering world 3 ts → ¬ PresentAt (exchanges world 3) (place ts) 0 2) ∧
      world.Joined 0 1 ∧ (∀ x, world.touch 0 x = true → world.touch 1 x = false) :=
  ⟨contains, .joined (by decide) joined_first_last,
   fun x touched => match x, touched with
     | 0, _ => ⟨rfl, rfl, fun _ => ⟨rfl, rfl, rfl⟩⟩
     | _ + 1, touched => Bool.noConfusion touched,
   fun _ reordering present =>
     (Presence.link_of_present (exchanges_ordered world 3) (reordering_natural contains reordering)
       present).2 1
       ⟨⟨by decide, by decide, .joined (by decide) joined_first_middle⟩,
        ⟨by decide, by decide, .joined (by decide) joined_middle_last⟩⟩,
   joined_first_middle,
   fun x touched => match x, touched with
     | 0, _ => rfl
     | _ + 1, touched => Bool.noConfusion touched⟩

/-- Its only reordering is the world as it is (`reordering_nil`). -/
theorem only_reordering : ∀ ts, Reordering world 3 ts → ts = [] :=
  reordering_nil fun t bound => match t, bound with
    | 0, _ => joined_first_middle
    | 1, _ => joined_middle_last
    | k + 2, b =>
      absurd b (Nat.not_le_of_lt (Nat.lt_of_lt_of_le (Nat.lt_succ_self 3) (Nat.le_add_left 4 k)))

end ByDependence

namespace MovedBack

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

/-- Four exchanges on one relatum, the flow empty. -/
def world : Footprinted Nat := ⟨Witnesses.emptyFlow Nat Nat, web, touch⟩

/-- The footprint contains the exchanges. -/
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

/-- **The footprint touches only what moves**, so it is the least footprint containing the
exchanges. -/
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

/-- Every two of the four exchanges are joined, through the relatum `0`. -/
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

/-- **Persistence without presence, with no dependence and the least footprint**: what the first
exchange touched is shown when the last is taken as right after the first, yet on no reordering is
the first present then, the middle two moving it and moving it back. Every two of the four exchanges
are joined, so the only reordering is the world as it is (`only_reordering`). -/
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

/-- Its only reordering is the world as it is (`reordering_nil`). -/
theorem only_reordering : ∀ ts, Reordering world 4 ts → ts = [] :=
  reordering_nil fun t bound => joined t (t + 1) (Nat.lt_trans (Nat.lt_succ_self t) bound) bound

end MovedBack

namespace VeeWorld

/-- The relatum `0` rises across the first two steps, the relatum `1` across the first and the
third. -/
def standing : Nat → Nat → Nat
  | 0, _ => 0
  | 1, 0 => 1
  | 1, 1 => 1
  | 1, _ => 0
  | 2, 0 => 2
  | 2, 1 => 1
  | 2, _ => 0
  | _ + 3, 0 => 2
  | _ + 3, 1 => 2
  | _ + 3, _ => 0

/-- No relatum depends on another. -/
def web : Web Nat Nat where
  level := standing
  active _ _ := True
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- The first step touches both relata, the second the relatum `0`, the third the relatum `1`. -/
def touch : Nat → Nat → Bool
  | 0, 0 => true
  | 0, 1 => true
  | 1, 0 => true
  | 2, 1 => true
  | _, _ => false

/-- **The vee as a world**: one exchange changing both relata, then one changing the first and one
changing the second. -/
def world : Footprinted Nat := ⟨Witnesses.emptyFlow Nat Nat, web, touch⟩

/-- The footprint contains the exchanges. -/
theorem contains : world.Contains
  | 0, 0, no => Bool.noConfusion no
  | 0, 1, no => Bool.noConfusion no
  | 0, _ + 2, _ => ⟨(fun h => nomatch h), rfl, rfl, fun _ => ⟨rfl, rfl, rfl⟩⟩
  | 1, 0, no => Bool.noConfusion no
  | 1, 1, _ => ⟨(fun h => nomatch h), rfl, rfl, fun _ => ⟨rfl, rfl, rfl⟩⟩
  | 1, _ + 2, _ => ⟨(fun h => nomatch h), rfl, rfl, fun _ => ⟨rfl, rfl, rfl⟩⟩
  | 2, 0, _ => ⟨(fun h => nomatch h), rfl, rfl, fun _ => ⟨rfl, rfl, rfl⟩⟩
  | 2, 1, no => Bool.noConfusion no
  | 2, _ + 2, _ => ⟨(fun h => nomatch h), rfl, rfl, fun _ => ⟨rfl, rfl, rfl⟩⟩
  | _ + 3, 0, _ => ⟨(fun h => nomatch h), rfl, rfl, fun _ => ⟨rfl, rfl, rfl⟩⟩
  | _ + 3, 1, _ => ⟨(fun h => nomatch h), rfl, rfl, fun _ => ⟨rfl, rfl, rfl⟩⟩
  | _ + 3, _ + 2, _ => ⟨(fun h => nomatch h), rfl, rfl, fun _ => ⟨rfl, rfl, rfl⟩⟩

theorem joined_first_second : world.Joined 0 1 :=
  .inl ⟨0, rfl, rfl⟩

theorem joined_first_third : world.Joined 0 2 :=
  .inl ⟨1, rfl, rfl⟩

/-- **The two later exchanges are not joined**: they touch no relatum in common, and no relatum
depends on another. -/
theorem apart : ¬ world.Joined 1 2 := fun link => match link with
  | .inl ⟨0, _, h⟩ => Bool.noConfusion h
  | .inl ⟨1, h, _⟩ => Bool.noConfusion h
  | .inl ⟨_ + 2, h, _⟩ => Bool.noConfusion h
  | .inr (.inl ⟨_, _, _, _, rq⟩) => match rq with
    | .inl h => h
    | .inr h => h
  | .inr (.inr ⟨_, _, _, _, rq⟩) => match rq with
    | .inl h => h
    | .inr h => h

/-- So the second does not precede the third: nothing lies between them. -/
theorem not_second_third : ¬ world.Precedes 1 2 := fun p =>
  match last_of_precedes p with
  | .inl ⟨_, link⟩ => apart link
  | .inr ⟨_, k2, k1, _, _⟩ => Nat.lt_irrefl 1 (Nat.lt_of_lt_of_le k1 (Nat.le_of_lt_succ k2))

/-- Within the three steps only the first exchange precedes another, and only the second or the
third. -/
theorem vee_of_precedes {a b : Nat} (hb : b < 3) (p : world.Precedes a b) : a = 0 ∧ (b = 1 ∨ b = 2) :=
  match b, hb, p with
  | 0, _, p => absurd p.lt (Nat.not_lt_zero a)
  | 1, _, p => match a, p with
    | 0, _ => ⟨rfl, .inl rfl⟩
    | _ + 1, p => absurd p.lt (Nat.not_lt_of_le (Nat.le_add_left 1 _))
  | 2, _, p => match a, p with
    | 0, _ => ⟨rfl, .inr rfl⟩
    | 1, p => (not_second_third p).elim
    | _ + 2, p => absurd p.lt (Nat.not_lt_of_le (Nat.le_add_left 2 _))
  | _ + 3, hb, _ => absurd hb (Nat.not_lt_of_le (Nat.le_add_left 3 _))

/-- **Its order of exchanges is the vee of `Becoming.Presence`**: `0` below `1` and `2`. -/
theorem prec_iff_vee (a b : Nat) : (exchanges world 3).prec a b ↔ Presence.Vee.vee.prec a b :=
  ⟨fun pair => match pair with
     | ⟨_, hb, p⟩ => vee_of_precedes hb p,
   fun ⟨a0, b12⟩ => by
     subst a0
     rcases b12 with rfl | rfl
     · exact ⟨by decide, by decide, .joined (by decide) joined_first_second⟩
     · exact ⟨by decide, by decide, .joined (by decide) joined_first_third⟩⟩

/-- So its natural labellings are the vee's. -/
theorem natural_iff_vee {π σ : Nat → Nat} :
    NaturalLabelling (exchanges world 3) π σ ↔ NaturalLabelling Presence.Vee.vee π σ :=
  ⟨Presence.natural_congr (c := exchanges world 3) (c' := Presence.Vee.vee) rfl prec_iff_vee,
   Presence.natural_congr (c := Presence.Vee.vee) (c' := exchanges world 3) rfl
     fun a b => (prec_iff_vee a b).symm⟩

/-- **Commuting the two later exchanges is a reordering** of the three steps. -/
theorem reordering : Reordering world 3 [1] :=
  ⟨⟨⟨Nat.zero_le 1, Nat.le_refl 3⟩, trivial⟩, ⟨apart, trivial⟩⟩

/-- **Presence when the last exchange is taken is a choice of reordering**: on the world as it is,
the first exchange is not present when the third is taken, the second, which it precedes, being
taken before; commuting the later two, it is. -/
theorem presence_varies :
    Reordering world 3 [] ∧ Reordering world 3 [1] ∧
      ¬ PresentAt (exchanges world 3) (place []) 0 2 ∧ PresentAt (exchanges world 3) (place [1]) 0 2 :=
  ⟨⟨trivial, trivial⟩, reordering,
   fun ⟨_, after⟩ => absurd (after 1 ((prec_iff_vee 0 1).mpr ⟨rfl, .inl rfl⟩)) (by decide),
   ⟨(prec_iff_vee 0 2).mpr ⟨rfl, .inr rfl⟩, fun k pair =>
     match k, (prec_iff_vee 0 k).mp pair with
     | _, ⟨_, .inl rfl⟩ => by decide
     | _, ⟨_, .inr rfl⟩ => by decide⟩⟩

/-- Commuting the later two keeps the three steps. -/
theorem swap_below {i : Nat} (hi : i < 3) : swapAt 1 i < 3 := by
  rcases Presence.below_three hi with rfl | rfl | rfl <;> decide

/-- Commuting the later two keeps the vee's precedence. -/
theorem vee_swap {i j : Nat} (hi : i < 3) (hj : j < 3) :
    Presence.Vee.vee.prec i j ↔ Presence.Vee.vee.prec (place [1] i) (place [1] j) := by
  rcases Presence.below_three hi with rfl | rfl | rfl <;>
  rcases Presence.below_three hj with rfl | rfl | rfl <;> decide

/-- **One course, two numberings**: the world as it is and the reordering commuting the later two
number the stretch's exchanges by one and the same course, the course growing them in their own
labels relabelling them onto its configuration at three births both ways, its two later births
matched to the two later exchanges the other way round. So the correspondence of `reordering_iff_course` is between
numberings, and `presence_varies` varies the matching. -/
theorem one_course_two_numberings :
    ∃ run : Run process, run.state 0 = empty ∧
      CausalGrowth.Kinds.Relabels (exchanges world 3) (run.state 3) (place []) (origin []) ∧
      CausalGrowth.Kinds.Relabels (exchanges world 3) (run.state 3) (place [1]) (origin [1]) ∧
      place [] 1 ≠ place [1] 1 :=
  have grows := Presence.courseOf_grows (exchanges_ordered world 3)
  have size : ((Presence.courseOf (exchanges world 3) (exchanges_ordered world 3)).state 3).size = 3 :=
    grows.2.1
  ⟨Presence.courseOf (exchanges world 3) (exchanges_ordered world 3), grows.1,
   ⟨fun i hi => ⟨Nat.lt_of_lt_of_le hi (Nat.le_of_eq size.symm), rfl⟩,
    fun j hj => ⟨Nat.lt_of_lt_of_le hj (Nat.le_of_eq size), rfl⟩,
    fun i j _ _ => (grows.2.2 i j).symm⟩,
   ⟨fun i hi => ⟨Nat.lt_of_lt_of_le (swap_below hi) (Nat.le_of_eq size.symm), origin_place [1] i⟩,
    fun j hj => ⟨swap_below (Nat.lt_of_lt_of_le hj (Nat.le_of_eq size)), place_origin [1] j⟩,
    fun i j hi hj => (prec_iff_vee i j).trans ((vee_swap hi hj).trans
      ((prec_iff_vee (place [1] i) (place [1] j)).symm.trans (grows.2.2 _ _).symm))⟩,
   by decide⟩

end VeeWorld

end ReorderingGrowth

end Becoming
