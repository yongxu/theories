import Becoming.SharedCodes
import Becoming.FreeEnergyCounting

/-!
# Counted codes: the law of a code formed between formations, for beliefs held as counts

The law of a code formed between formations (`Becoming.SharedCodes`, 05 §9) is stated for codes:
each formation holds one form for each sense. The principle's agents hold beliefs instead. A
likelihood mapping meanings to words is learned as Dirichlet counts, updated by adding the counts
of what is observed or heard. This module states the code law for beliefs held as counts and
learned by rules of that kind (board item UE25).

* **Counts and a unique greatest word.** A belief state gives each agent, for each meaning, a count
  of each word, in any type `V` with an order `<` (natural counts below; a strict order suffices
  for the symmetry laws). `rename σ m c` reads a count vector with the words at `m` renamed by
  `σ m`. `UniqueGreatest c w` says `w` alone has the greatest count: the word a posterior mean
  names as most likely, with no tie. With `<` irreflexive and transitive:
  - two different words are never both uniquely greatest (`unique_greatest_not_two`; with words
    told apart by a decision, `unique_greatest_eq`);
  - where `σ m` is onto, a uniquely greatest word of the renamed counts is carried to one of the
    counts (`unique_greatest_rename`);
  - counts that a renaming moving every word leaves unchanged have no uniquely greatest word
    (`fixed_no_unique_greatest`).
* **Never a shared uniquely greatest word.** `Renamed π σ X Y` says that `Y` is `X` with the agents
  exchanged by `π` and the words renamed by `σ`, count by count.
  - A law keeping the exchange alone and the renaming alone keeps the two together (`keeps_both`).
  - In a state related to itself, where the renaming at `m` is onto, an agent's uniquely greatest
    word for `m`, renamed, is that of the agent the exchange gives it (`unique_greatest_exchanged`);
    along the run of a law keeping the relation (`Law.KeepsRelation`) from a start related to
    itself, so at every step (`unique_greatest_exchanged_run`).
  - There, at a meaning where the renaming is onto and moves every word, two agents the exchange
    relates never hold one word as each one's uniquely greatest (`never_shared`). Where the
    exchange is an involution, the renaming need not be onto (`never_shared_of_involution`).
  - Where two agents the exchange relates hold the same counts for `m`, the renaming moving every
    word there, those counts have no uniquely greatest word (`shared_no_unique_greatest`).
  - With the exchange an involution and the renaming onto, the code of uniquely greatest words read
    off a state related to itself is a code related to itself in the sense of the code law
    (`read_relabels`).
* **Learning by what is heard keeps both symmetries.** In `hear p rule`, each agent's new counts
  for `m` are given by `rule m` from its own counts for `m` and those of the agent `p i` it hears
  (the hearer is given the meaning). This keeps the relation where three things hold
  (`hear_keeps`):
  - the speaker map commutes with the exchange;
  - the rule reads the counts count by count;
  - the rule commutes with renaming.

  Such a rule gives counts a renaming fixes from counts it fixes (`tied_hears_tied`): a speaker it
  covers never names one word from a tie. In natural counts, adding the counts of what is heard
  (`addHeard`), the form of the principle's update of Dirichlet counts, keeps the relation where
  what is heard reads count by count and commutes with renaming (`addHeard_keeps`). Adding the
  speaker's own counts (`addSpeaker`) is the case where what is heard is the speaker's counts,
  unnormalized and re-added at every step (`addSpeaker_keeps`). With an involutive speaker map,
  the two agents then hold one model after one step and at every later step (`addSpeaker_shares`,
  `addSpeaker_shares_run`). With the exchange, an involution, as the speaker map, from a start
  related to itself, at a meaning whose every word the renaming moves, that model has no uniquely
  greatest word (`addSpeaker_tied`). Learning gated by the whole model (`gatedHear`), the counts
  heard entering with a weight the hearer's whole model gives, is not of `hear`'s form, since the
  gate reads every meaning; it keeps the relation where, besides the conditions of `addHeard_keeps`,
  the gate is unchanged by the renaming (`gatedHear_keeps`).
* **Free-energy minimization is unchanged by a renaming that permutes the words.**
  - Over a renamed listing, the product of powers is that of the renamed weights and counts
    (`powerProduct_map`; totals by `Becoming.total_map`).
  - Totals and products of powers are unchanged by a permutation of the listing (`total_perm`,
    `powerProduct_perm`).
  - So, over a listing the renaming permutes, a count belief reaches the free-energy bound for some
    weights exactly where its renaming reaches it for the renamed weights (`bound_invariant`).
  - Where the weights are unchanged by a renaming moving every word and their total is positive, a
    belief at the bound over a listing of every word has no uniquely greatest word
    (`minimizer_no_unique_greatest`).
  - So, under a law keeping the relation in natural counts, where two agents the exchange relates
    hold the same counts for `m`, a belief over which word to say at the bound for those counts as
    weights has no uniquely greatest word (`shared_minimizer_no_unique_greatest`).
* **Witnesses** (two agents, two words, one meaning; the exchange swaps the agents, the renaming
  swaps the words).
  - Agents with opposite counts, `2, 1` and `1, 2`, each hold a uniquely greatest word, and the two
    words differ. One step of adding the speaker's counts gives both `3, 3`: one model, with no
    uniquely greatest word (`Witness.added_tie`).
  - From no counts, a speaker saying the first word of greatest count, a tie going to the first
    word, brings both agents to hold that word as uniquely greatest after one hearing
    (`Witness.sayFirst_shared`). Its rule does not commute with the renaming
    (`Witness.sayFirst_not_alike`): the order is a preferred word.
  - From a start that the exchange with the renaming does not relate to itself, `1, 0` and `0, 0`
    (`Witness.lead_not_symmetric`), one step of adding the speaker's counts gives both `1, 0`, a
    shared uniquely greatest word (`Witness.asymmetric_shared`).

**Modelling choices.** The model makes these choices:
- counts in an order (natural counts for learning and free energy), read as counts added to a
  common positive prior that every renaming fixes, so that a count of nothing is a proper
  Dirichlet belief;
- relations of counts stated count by count (equality of count vectors as functions would need
  function extensionality, which the pure core does not assume);
- discrete synchronous steps of a determined law;
- the hearer given the meaning;
- one renaming for each meaning (a symmetry of a scheme that infers meanings from words only where
  the renaming is the same for every meaning);
- a unique greatest count as the reading of a word named for a meaning.

Not modelled:
- speaking by sampling. In the two-state Lewis game, reinforcement with sampled signals reaches a
  signalling system (Argiento, Pemantle, Skyrms and Volkov 2009), and for cells UE24 shows an
  exchangeable law in place of the deterministic one;
- the normalized predictive, gating and forgetting of the principle's schemes, over the reals;
- the time agreement takes;
- free energy over parameters.

**Standing.** The symmetry argument is Curie's principle. Conventions are equilibria that symmetry
does not select (Lewis 1969), and signalling dynamics reach one by chance or by an asymmetry
(Skyrms 2010). The Dirichlet update is the principle's learning of the likelihood (Friston,
FitzGerald, Rigoli, Schwartenbeck, O'Doherty and Pezzulo 2016).

Every law is near-definitional or an instance of the core's law of a kept relation. New are two
things:
- the statement of the code law for beliefs held as counts and learned by rules of the principle's
  form, joined to the counting form of the free-energy bound;
- the reading against the statement that language emerges from free-energy minimization.

Every declaration has an empty axiom report. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

namespace CountedCodes

open FreeEnergyCounting

universe u v w x

section UniqueGreatest

variable {M : Type v} {F : Type w} {V : Type x}

/-- The counts `c` read with the words at `m` renamed by `σ m`: the count of `w` is the count of
`σ m w`. -/
def rename (σ : M → F → F) (m : M) (c : F → V) : F → V := fun w => c (σ m w)

/-- `w` alone has the greatest count. -/
def UniqueGreatest [LT V] (c : F → V) (w : F) : Prop := ∀ w', w' ≠ w → c w' < c w

variable [LT V]

/-- **Two different words are never both uniquely greatest**, for an irreflexive, transitive
order. -/
theorem unique_greatest_not_two (irrefl : ∀ a : V, ¬ a < a)
    (trans : ∀ a b d : V, a < b → b < d → a < d) {c : F → V} {w w' : F}
    (g : UniqueGreatest c w) (g' : UniqueGreatest c w') : ¬ w ≠ w' :=
  fun ne => irrefl _ (trans _ _ _ (g' w ne) (g w' fun e => ne e.symm))

/-- **The uniquely greatest word is one**, where words are told apart by a decision. -/
theorem unique_greatest_eq [DecidableEq F] (irrefl : ∀ a : V, ¬ a < a)
    (trans : ∀ a b d : V, a < b → b < d → a < d) {c : F → V} {w w' : F}
    (g : UniqueGreatest c w) (g' : UniqueGreatest c w') : w = w' :=
  match decEq w w' with
  | isTrue e => e
  | isFalse ne => absurd ne (unique_greatest_not_two irrefl trans g g')

/-- **A uniquely greatest word of the renamed counts is carried to one of the counts**, where the
renaming is onto. -/
theorem unique_greatest_rename {σ : M → F → F} {m : M} (onto : ∀ u, ∃ v, σ m v = u)
    {c : F → V} {v : F} (g : UniqueGreatest (rename σ m c) v) : UniqueGreatest c (σ m v) :=
  fun u ne => match onto u with
    | ⟨w, e⟩ => e ▸ g w fun wv => ne (e.symm.trans (congrArg (σ m) wv))

/-- **Counts a renaming moving every word leaves unchanged have no uniquely greatest word**, for
an irreflexive order. -/
theorem fixed_no_unique_greatest (irrefl : ∀ a : V, ¬ a < a) {σ : M → F → F} {m : M}
    (moves : ∀ y, σ m y ≠ y) {c : F → V} (fixed : ∀ y, c (σ m y) = c y) (w : F) :
    ¬ UniqueGreatest c w :=
  fun g => irrefl _ ((fixed w) ▸ g (σ m w) (moves w))

end UniqueGreatest

section Symmetry

variable {I : Type u} {M : Type v} {F : Type w} {V : Type x}

/-- `Y` is `X` with the agents exchanged by `π` and, at each meaning, the words renamed by `σ`,
count by count. -/
def Renamed (π : I → I) (σ : M → F → F) (X Y : I → M → F → V) : Prop :=
  ∀ i m w, Y i m w = X (π i) m (σ m w)

variable {π : I → I} {σ : M → F → F} {T : (I → M → F → V) → I → M → F → V}

/-- **Keeping both, a law keeps the two together**: a law privileging none of the agents `π`
exchanges and none of the words `σ` renames keeps the exchange with the renaming. -/
theorem keeps_both (exchanges : Law.KeepsRelation T (Renamed π fun _ y => y))
    (renames : Law.KeepsRelation T (Renamed (fun i => i) σ)) :
    Law.KeepsRelation T (Renamed π σ) :=
  fun X Y related =>
    have exchanged : Renamed π (fun _ y => y) X (fun i m w => X (π i) m w) := fun _ _ _ => rfl
    have renamed : Renamed (fun i => i) σ (fun i m w => X (π i) m w) Y := related
    fun i m w => (renames _ _ renamed i m w).trans (exchanges _ _ exchanged i m (σ m w))

variable [LT V]

/-- **In a state related to itself, an agent's uniquely greatest word, renamed, is that of the
agent the exchange gives it**, where the renaming is onto. -/
theorem unique_greatest_exchanged {X : I → M → F → V} (symmetric : Renamed π σ X X) {m : M}
    (onto : ∀ u, ∃ v, σ m v = u) {i : I} {v : F} (g : UniqueGreatest (X i m) v) :
    UniqueGreatest (X (π i) m) (σ m v) :=
  unique_greatest_rename onto fun w ne =>
    show X (π i) m (σ m w) < X (π i) m (σ m v) from (symmetric i m w) ▸ (symmetric i m v) ▸ g w ne

/-- **Along the run of a law keeping the relation, from a start related to itself, an agent's
uniquely greatest word, renamed, is that of the agent the exchange gives it**, where the renaming
is onto. -/
theorem unique_greatest_exchanged_run (keeps : Law.KeepsRelation T (Renamed π σ))
    {X : I → M → F → V} (symmetric : Renamed π σ X X) {m : M} (onto : ∀ u, ∃ v, σ m v = u)
    (n : Nat) {i : I} {v : F} (g : UniqueGreatest ((Law.run T X).state n i m) v) :
    UniqueGreatest ((Law.run T X).state n (π i) m) (σ m v) :=
  unique_greatest_exchanged (Law.KeepsRelation.run keeps symmetric n) onto g

/-- **Never a shared uniquely greatest word.** Under a law keeping the exchange of agents by `π`
together with the renaming of words by `σ`, from a start related to itself, where the renaming at
`m` is onto and moves every word, two agents the exchange relates never hold one word as each one's
uniquely greatest for `m`. -/
theorem never_shared (irrefl : ∀ a : V, ¬ a < a) (trans : ∀ a b d : V, a < b → b < d → a < d)
    (keeps : Law.KeepsRelation T (Renamed π σ)) {X : I → M → F → V} (symmetric : Renamed π σ X X)
    {m : M} (onto : ∀ u, ∃ v, σ m v = u) (moves : ∀ y, σ m y ≠ y) (n : Nat) (i : I) {v v' : F}
    (g : UniqueGreatest ((Law.run T X).state n i m) v)
    (g' : UniqueGreatest ((Law.run T X).state n (π i) m) v') : v ≠ v' :=
  fun e => unique_greatest_not_two irrefl trans
    (unique_greatest_exchanged_run keeps symmetric onto n g) (e ▸ g') (moves v)

/-- **The same where the exchange is an involution**, the renaming not assumed onto. -/
theorem never_shared_of_involution (irrefl : ∀ a : V, ¬ a < a)
    (trans : ∀ a b d : V, a < b → b < d → a < d) (keeps : Law.KeepsRelation T (Renamed π σ))
    {X : I → M → F → V} (symmetric : Renamed π σ X X) (involution : ∀ i, π (π i) = i) {m : M}
    (moves : ∀ y, σ m y ≠ y) (n : Nat) (i : I) {v : F}
    (g : UniqueGreatest ((Law.run T X).state n i m) v)
    (g' : UniqueGreatest ((Law.run T X).state n (π i) m) v) : False :=
  have related := Law.KeepsRelation.run keeps symmetric n
  have here : (Law.run T X).state n i m v < (Law.run T X).state n (π i) m v :=
    (related i m v).symm ▸ g' (σ m v) (moves v)
  have there : (Law.run T X).state n (π i) m v < (Law.run T X).state n i m v :=
    ((related (π i) m v).trans
      (congrArg (fun j => (Law.run T X).state n j m (σ m v)) (involution i))).symm ▸
        g (σ m v) (moves v)
  irrefl _ (trans _ _ _ here there)

/-- **Shared counts have no uniquely greatest word.** Under a law keeping the relation, from a
start related to itself, where two agents the exchange relates hold the same counts for `m` and
the renaming moves every word there, those counts have no uniquely greatest word. -/
theorem shared_no_unique_greatest (irrefl : ∀ a : V, ¬ a < a)
    (keeps : Law.KeepsRelation T (Renamed π σ)) {X : I → M → F → V} (symmetric : Renamed π σ X X)
    {m : M} (moves : ∀ y, σ m y ≠ y) (n : Nat) (i : I)
    (same : ∀ w, (Law.run T X).state n i m w = (Law.run T X).state n (π i) m w) (w : F) :
    ¬ UniqueGreatest ((Law.run T X).state n i m) w :=
  fixed_no_unique_greatest irrefl moves
    (fun y => (same (σ m y)).trans (Law.KeepsRelation.run keeps symmetric n i m y).symm) w

/-- **Joined to the code law.** Where each agent holds a uniquely greatest word at each meaning,
the code of those words read off a state related to itself is a code related to itself in the sense
of `SharedCodes.Relabels`, with the exchange an involution and the renaming onto. -/
theorem read_relabels [DecidableEq F] (irrefl : ∀ a : V, ¬ a < a)
    (trans : ∀ a b d : V, a < b → b < d → a < d) {X : I → M → F → V}
    (symmetric : Renamed π σ X X) (involution : ∀ i, π (π i) = i) (onto : ∀ m u, ∃ v, σ m v = u)
    {C : I → M → F} (read : ∀ i m, UniqueGreatest (X i m) (C i m)) :
    SharedCodes.Relabels π σ C C :=
  fun i m =>
    unique_greatest_eq irrefl trans (read i m)
      (Eq.subst (motive := fun j => UniqueGreatest (X j m) (σ m (C (π i) m))) (involution i)
        (unique_greatest_exchanged symmetric (onto m) (read (π i) m)))

end Symmetry

section Hearing

variable {I : Type u} {M : Type v} {F : Type w} {V : Type x}

/-- **Learning by what is heard.** Each agent's new counts for `m` are given by `rule m` from its
own counts for `m` and those of the agent `p i` it hears, the meaning given. -/
def hear (p : I → I) (rule : M → (F → V) → (F → V) → F → V) (X : I → M → F → V) :
    I → M → F → V :=
  fun i m w => rule m (X i m) (X (p i) m) w

/-- The rule reads the counts count by count: counts that agree at every word give one result. This
is extensionality of the rule in its counts, stated because no axiom of function extensionality is
used; it restricts nothing else. -/
def ReadsCountByCount (rule : M → (F → V) → (F → V) → F → V) : Prop :=
  ∀ m c c' d d', (∀ w, c w = c' w) → (∀ w, d w = d' w) → ∀ w, rule m c d w = rule m c' d' w

/-- The rule commutes with renaming the words. -/
def CommutesWithRenaming (σ : M → F → F) (rule : M → (F → V) → (F → V) → F → V) : Prop :=
  ∀ m c d w, rule m (rename σ m c) (rename σ m d) w = rule m c d (σ m w)

/-- **Learning by what is heard keeps both symmetries** where the speaker map commutes with the
exchange and the rule reads count by count and commutes with renaming. -/
theorem hear_keeps {π p : I → I} {σ : M → F → F} {rule : M → (F → V) → (F → V) → F → V}
    (commutes : ∀ i, p (π i) = π (p i)) (reads : ReadsCountByCount rule)
    (alike : CommutesWithRenaming σ rule) : Law.KeepsRelation (hear p rule) (Renamed π σ) :=
  fun X Y related i m w =>
    (reads m (Y i m) (rename σ m (X (π i) m)) (Y (p i) m) (rename σ m (X (π (p i)) m))
        (related i m) (related (p i) m) w).trans
      ((alike m (X (π i) m) (X (π (p i)) m) w).trans
        (congrArg (fun j => rule m (X (π i) m) (X j m) (σ m w)) (commutes i).symm))

/-- **From tied counts, tied counts.** A rule reading count by count and commuting with renaming
gives, from own and heard counts the renaming fixes, counts it fixes: a speaker it covers never
names one word from a tie. -/
theorem tied_hears_tied {σ : M → F → F} {rule : M → (F → V) → (F → V) → F → V}
    (reads : ReadsCountByCount rule) (alike : CommutesWithRenaming σ rule) {m : M} {c d : F → V}
    (fixed : ∀ y, c (σ m y) = c y) (fixed' : ∀ y, d (σ m y) = d y) (w : F) :
    rule m c d (σ m w) = rule m c d w :=
  (alike m c d w).symm.trans (reads m (rename σ m c) c (rename σ m d) d fixed fixed' w)

/-- **Adding the counts of what is heard**, the form of the principle's update of Dirichlet counts:
own counts plus `say m d`, the counts heard from the speaker's counts `d`. -/
def addHeard (say : M → (F → Nat) → F → Nat) : M → (F → Nat) → (F → Nat) → F → Nat :=
  fun m c d w => c w + say m d w

/-- **Adding what is heard keeps both symmetries** where the speaker map commutes with the
exchange and what is heard reads count by count and commutes with renaming. -/
theorem addHeard_keeps {π p : I → I} {σ : M → F → F} {say : M → (F → Nat) → F → Nat}
    (commutes : ∀ i, p (π i) = π (p i))
    (reads : ∀ m d d', (∀ w, d w = d' w) → ∀ w, say m d w = say m d' w)
    (alike : ∀ m d w, say m (rename σ m d) w = say m d (σ m w)) :
    Law.KeepsRelation (hear p (addHeard say)) (Renamed π σ) :=
  hear_keeps commutes
    (fun m _ _ d d' same same' w =>
      (congrArg (· + say m d w) (same w)).trans (congrArg (_ + ·) (reads m d d' same' w)))
    (fun m c d w => congrArg (c (σ m w) + ·) (alike m d w))

/-- **Adding the speaker's counts**: what is heard is the speaker's counts for the meaning,
unnormalized and re-added at every step. -/
def addSpeaker : M → (F → Nat) → (F → Nat) → F → Nat := addHeard fun _ d => d

/-- **Adding the speaker's counts keeps both symmetries** where the speaker map commutes with the
exchange. -/
theorem addSpeaker_keeps {π p : I → I} {σ : M → F → F} (commutes : ∀ i, p (π i) = π (p i)) :
    Law.KeepsRelation (hear p (addSpeaker (M := M) (F := F))) (Renamed π σ) :=
  addHeard_keeps commutes (fun _ _ _ same w => same w) (fun _ _ _ => rfl)

/-- **Two agents hearing each other hold one model after one step**, where the speaker map is an
involution. -/
theorem addSpeaker_shares {p : I → I} (involution : ∀ i, p (p i) = i) (X : I → M → F → Nat)
    (i : I) (m : M) (w : F) : hear p addSpeaker X i m w = hear p addSpeaker X (p i) m w :=
  (Nat.add_comm _ _).trans
    (congrArg (X (p i) m w + ·) (congrArg (fun j => X j m w) (involution i).symm))

/-- **Along the run, the two hold one model at every step after the first.** -/
theorem addSpeaker_shares_run {p : I → I} (involution : ∀ i, p (p i) = i) (X : I → M → F → Nat)
    (n : Nat) (i : I) (m : M) (w : F) :
    (Law.run (hear p addSpeaker) X).state (n + 1) i m w =
      (Law.run (hear p addSpeaker) X).state (n + 1) (p i) m w :=
  addSpeaker_shares involution _ i m w

/-- **The one model has no uniquely greatest word.** With the exchange as the speaker map, an
involution, from a start related to itself, at a meaning whose every word the renaming moves, the
two agents hold one model at every step after the first, and it has no uniquely greatest word for
the meaning. -/
theorem addSpeaker_tied {π : I → I} {σ : M → F → F} (involution : ∀ i, π (π i) = i)
    {X : I → M → F → Nat} (symmetric : Renamed π σ X X) {m : M} (moves : ∀ y, σ m y ≠ y)
    (n : Nat) (i : I) :
    (∀ w, (Law.run (hear π addSpeaker) X).state (n + 1) i m w =
        (Law.run (hear π addSpeaker) X).state (n + 1) (π i) m w) ∧
      ∀ w, ¬ UniqueGreatest ((Law.run (hear π addSpeaker) X).state (n + 1) i m) w :=
  ⟨addSpeaker_shares_run involution X n i m,
   shared_no_unique_greatest Nat.lt_irrefl (addSpeaker_keeps fun _ => rfl) symmetric moves (n + 1)
     i (addSpeaker_shares_run involution X n i m)⟩

/-- **Learning gated by the whole model**: the counts heard enter with a weight that the hearer's
whole model gives, as an update weighted by the policy to update or not. The gate reads every
meaning, so the law is not of `hear`'s form. -/
def gatedHear (p : I → I) (gate : (M → F → Nat) → Nat) (say : M → (F → Nat) → F → Nat)
    (X : I → M → F → Nat) : I → M → F → Nat :=
  fun i m w => X i m w + gate (X i) * say m (X (p i) m) w

/-- **A gate unchanged by the renaming keeps both symmetries** where the speaker map commutes with
the exchange and what is heard reads count by count and commutes with renaming. -/
theorem gatedHear_keeps {π p : I → I} {σ : M → F → F} {gate : (M → F → Nat) → Nat}
    {say : M → (F → Nat) → F → Nat} (commutes : ∀ i, p (π i) = π (p i))
    (reads : ∀ m d d', (∀ w, d w = d' w) → ∀ w, say m d w = say m d' w)
    (alike : ∀ m d w, say m (rename σ m d) w = say m d (σ m w))
    (invariant : ∀ c d : M → F → Nat, (∀ m w, d m w = c m (σ m w)) → gate d = gate c) :
    Law.KeepsRelation (gatedHear p gate say) (Renamed π σ) :=
  fun X Y related i m w =>
    have gated : gate (Y i) = gate (X (π i)) := invariant _ _ (related i)
    have heard : say m (Y (p i) m) w = say m (X (p (π i)) m) (σ m w) :=
      (reads m (Y (p i) m) (rename σ m (X (π (p i)) m)) (related (p i) m) w).trans
        ((alike m (X (π (p i)) m) w).trans
          (congrArg (fun j => say m (X j m) (σ m w)) (commutes i).symm))
    show Y i m w + gate (Y i) * say m (Y (p i) m) w =
        X (π i) m (σ m w) + gate (X (π i)) * say m (X (p (π i)) m) (σ m w) from
      (congrArg (· + gate (Y i) * say m (Y (p i) m) w) (related i m w)).trans
        (congrArg (X (π i) m (σ m w) + ·)
          ((congrArg (· * say m (Y (p i) m) w) gated).trans (congrArg (gate (X (π i)) * ·) heard)))

end Hearing

section FreeEnergy

variable {α : Type}

/-- The product of powers over a renamed listing is that of the renamed weights and counts. -/
theorem powerProduct_map {β : Type} (σ : α → β) (a n : β → Nat) :
    ∀ hs : List α,
      powerProduct a n (hs.map σ) = powerProduct (fun h => a (σ h)) (fun h => n (σ h)) hs
  | [] => rfl
  | h :: hs => congrArg (a (σ h) ^ n (σ h) * ·) (powerProduct_map σ a n hs)

/-- A total is unchanged by a permutation of the listing. -/
theorem total_perm (f : α → Nat) {l l' : List α} (p : l.Perm l') : total l f = total l' f := by
  induction p with
  | nil => rfl
  | cons y _ ih => exact congrArg (f y + ·) ih
  | swap y z l =>
    show f z + (f y + total l f) = f y + (f z + total l f)
    exact Nat.add_left_comm _ _ _
  | trans _ _ ih1 ih2 => exact ih1.trans ih2

/-- A product of powers is unchanged by a permutation of the listing. -/
theorem powerProduct_perm (a n : α → Nat) {l l' : List α} (p : l.Perm l') :
    powerProduct a n l = powerProduct a n l' := by
  induction p with
  | nil => rfl
  | cons y _ ih => exact congrArg (a y ^ n y * ·) ih
  | swap y z l =>
    show a z ^ n z * (a y ^ n y * powerProduct a n l) = a y ^ n y * (a z ^ n z * powerProduct a n l)
    exact mul_turn _ _ _
  | trans _ _ ih1 ih2 => exact ih1.trans ih2

/-- **Free-energy minimization is unchanged by a renaming that permutes the words.** Over a listing
the renaming permutes, a count belief reaches the free-energy bound for weights `a` exactly where
its renaming reaches it for the renamed weights. -/
theorem bound_invariant (σ : α → α) (n a : α → Nat) (hs : List α)
    (permutes : (hs.map σ).Perm hs) :
    (total hs n ^ total hs n * powerProduct a n hs =
        total hs a ^ total hs n * powerProduct n n hs) ↔
      (total hs (fun h => n (σ h)) ^ total hs (fun h => n (σ h)) *
          powerProduct (fun h => a (σ h)) (fun h => n (σ h)) hs =
        total hs (fun h => a (σ h)) ^ total hs (fun h => n (σ h)) *
          powerProduct (fun h => n (σ h)) (fun h => n (σ h)) hs) := by
  rw [← total_map σ n hs, ← total_map σ a hs, ← powerProduct_map σ a n hs,
    ← powerProduct_map σ n n hs, total_perm n permutes, total_perm a permutes,
    powerProduct_perm a n permutes, powerProduct_perm n n permutes]

/-- **A free-energy minimizer under weights a renaming fixes has no uniquely greatest word.** Where
the weights are unchanged by a renaming moving every word and their total is positive, a count
belief at the free-energy bound over a listing of every word has no uniquely greatest word. -/
theorem minimizer_no_unique_greatest {σ : α → α} (moves : ∀ y, σ y ≠ y) {n a : α → Nat}
    {hs : List α} (every : ∀ h, h ∈ hs) (fixed : ∀ h, a (σ h) = a h) (positive : 0 < total hs a)
    (reaches : total hs n ^ total hs n * powerProduct a n hs =
      total hs a ^ total hs n * powerProduct n n hs) (w : α) : ¬ UniqueGreatest n w :=
  have prop := proportional_of_bound_eq n a hs reaches
  fixed_no_unique_greatest Nat.lt_irrefl (σ := fun (_ : Unit) => σ) (m := ()) moves
    (fun y => Nat.eq_of_mul_eq_mul_right positive
      ((prop (σ y) (every _)).trans
        ((congrArg (· * total hs n) (fixed y)).trans (prop y (every y)).symm))) w

/-- **Shared counts give a minimizer with no uniquely greatest word.** Under a law keeping the
relation in natural counts, from a start related to itself, where two agents the exchange relates
hold the same counts for `m`, the renaming moving every word there, a belief over which word to say
at the free-energy bound for those counts as weights, over a listing of every word with a positive
total, has no uniquely greatest word. -/
theorem shared_minimizer_no_unique_greatest {I : Type u} {M : Type v} {π : I → I}
    {σ : M → α → α} {T : (I → M → α → Nat) → I → M → α → Nat}
    (keeps : Law.KeepsRelation T (Renamed π σ)) {X : I → M → α → Nat}
    (symmetric : Renamed π σ X X) {m : M} (moves : ∀ y, σ m y ≠ y) (n : Nat) (i : I)
    (same : ∀ w, (Law.run T X).state n i m w = (Law.run T X).state n (π i) m w)
    {b : α → Nat} {hs : List α} (every : ∀ h, h ∈ hs)
    (positive : 0 < total hs ((Law.run T X).state n i m))
    (reaches : total hs b ^ total hs b * powerProduct ((Law.run T X).state n i m) b hs =
      total hs ((Law.run T X).state n i m) ^ total hs b * powerProduct b b hs) (w : α) :
    ¬ UniqueGreatest b w :=
  minimizer_no_unique_greatest moves every
    (fun y => (same (σ m y)).trans (Law.KeepsRelation.run keeps symmetric n i m y).symm) positive
    reaches w

end FreeEnergy

/-! ## Witnesses: two agents, two words, one meaning -/

namespace Witness

/-- Opposite counts: agent `false` counts `2` for `false` and `1` for `true`, agent `true` the
reverse. -/
def opposite : Bool → Unit → Bool → Nat := fun i _ w => bif i == w then 2 else 1

theorem opposite_symmetric : Renamed (fun i => !i) (fun _ y => !y) opposite opposite
  | false, _, false => rfl
  | false, _, true => rfl
  | true, _, false => rfl
  | true, _, true => rfl

/-- **Adding the speaker's counts to opposite counts.** Each agent holds a uniquely greatest word
and the two words differ; one step gives both the counts `3, 3`, one model with no uniquely
greatest word. -/
theorem added_tie :
    UniqueGreatest (opposite false ()) false ∧ UniqueGreatest (opposite true ()) true ∧
      (∀ i w, (Law.run (hear (fun i => !i) addSpeaker) opposite).state 1 i () w = 3) ∧
      ∀ i w, ¬ UniqueGreatest ((Law.run (hear (fun i => !i) addSpeaker) opposite).state 1 i ()) w :=
  ⟨fun w' ne => match w', ne with
    | true, _ => Nat.lt_succ_self 1
    | false, ne => absurd rfl ne,
   fun w' ne => match w', ne with
    | false, _ => Nat.lt_succ_self 1
    | true, ne => absurd rfl ne,
   fun i w => match i, w with
    | false, false => rfl
    | false, true => rfl
    | true, false => rfl
    | true, true => rfl,
   fun i => (addSpeaker_tied ListTests.not_not opposite_symmetric (m := ()) ListTests.not_ne_self 0 i).2⟩

/-- No counts at all. -/
def zero : Bool → Unit → Bool → Nat := fun _ _ _ => 0

/-- The exchange with the renaming relates `zero` to itself. -/
theorem zero_symmetric : Renamed (fun i => !i) (fun _ y => !y) zero zero := fun _ _ _ => rfl

/-- Saying the first word of greatest count: `true` where it counts strictly more, else `false`;
what is heard is one count for the word said. -/
def sayFirst : Unit → (Bool → Nat) → Bool → Nat :=
  fun _ c w => bif Nat.blt (c false) (c true) then (bif w then 1 else 0) else (bif w then 0 else 1)

/-- **A preferred word brings a shared uniquely greatest word.** From no counts, after one hearing
of the first word of greatest count, both agents hold `false` as uniquely greatest. -/
theorem sayFirst_shared (i : Bool) :
    UniqueGreatest ((Law.run (hear (fun i => !i) (addHeard sayFirst)) zero).state 1 i ()) false :=
  fun w' ne => match w', ne with
    | true, _ => Nat.zero_lt_one
    | false, ne => absurd rfl ne

/-- **The order is a preferred word**: adding the first word of greatest count does not commute
with renaming the words. -/
theorem sayFirst_not_alike : ¬ CommutesWithRenaming (fun (_ : Unit) y => !y) (addHeard sayFirst) :=
  fun alike => absurd (alike () (fun _ => 0) (fun _ => 0) false) (by decide)

/-- Agent `false` counts `1` for `false`, agent `true` nothing. -/
def lead : Bool → Unit → Bool → Nat := fun i _ w => bif i then 0 else (bif w then 0 else 1)

/-- The exchange with the renaming does not relate `lead` to itself. -/
theorem lead_not_symmetric : ¬ Renamed (fun i => !i) (fun (_ : Unit) y => !y) lead lead :=
  fun h => absurd (h false () false) (by decide)

/-- **An asymmetric start brings a shared uniquely greatest word.** One step of adding the
speaker's counts gives both agents the counts `1, 0`, with `false` uniquely greatest. -/
theorem asymmetric_shared (i : Bool) :
    UniqueGreatest ((Law.run (hear (fun i => !i) addSpeaker) lead).state 1 i ()) false :=
  match i with
  | false => fun w' ne => match w', ne with
    | true, _ => Nat.zero_lt_one
    | false, ne => absurd rfl ne
  | true => fun w' ne => match w', ne with
    | true, _ => Nat.zero_lt_one
    | false, ne => absurd rfl ne

end Witness

end CountedCodes

end Becoming
