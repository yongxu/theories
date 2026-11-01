import Becoming.Decidedness

/-!
# Census tables: what a class of worlds adds to the law of counting, for any listing

`Becoming.Population` shows that the tally is the whole law of counting: a property of the
counts of a listing holds wherever what holds is listed exactly when it holds of every tally
(`counting_laws`). The modules that follow ask what a class of worlds adds to that law: the
worlds meeting a selection of the premises, those enclosed from some step on, the finite ones,
those where the premises bind (`Becoming.Counting`), for each listing a world has: what is
active, what stands, what depends (`Becoming.Standing`). Every one of their laws has one shape,
stated here once for any class of worlds and any listing a world has, a determination
`L w : X w → Nat → Prop` of what is listed in the world `w`.

* **The counts of a listing.** `n`, `c` and `a` count a listed family where `n` is its length at
  each step, `c` counts what of it ceases across the step and `a` what after it came to be,
  counts as relations with no decision procedure (`FamilyCounts`); they are a tally
  (`FamilyCounts.tally`), and where a procedure decides they are its marks
  (`familyCounts_decided`). A property holds of a listing of a world where it holds of every
  listed family and every counts of it (`World.ListingHolds`), and of the marks of every listed
  family where a procedure decides (`World.ListingMarksHold`).
* **A census table.** A class of worlds and a condition on the counts form a table where every
  listed family of every world of the class has counts meeting the condition (soundness, stated
  for counts as relations) and every tally meeting the condition is the marks of some listed
  family of some world of the class with a decision procedure (`World.Witnessed`). Then a
  property of the counts holds of every listing of every world of the class exactly when it holds
  of every tally meeting the condition: for every property, with counts as relations
  (`World.table_holds`), and for every pointwise property, with the marks a procedure gives
  (`World.table_marks_hold`). So the decided form of each law of counting is a corollary of the
  counted soundness and the same witness, and needs no proof of its own; the condition `True`
  gives the laws with no added condition (`World.table_holds_free`, `World.table_marks_hold_free`).
* **Agreeing listings.** Determinations agreeing at each step list, count and decide alike
  (`Listed.congr`, `FamilyCounts.congr`, `ceasings_congr`, `comings_congr`), so a witness under
  one listing is one under any listing agreeing with it in the worlds of the class
  (`World.witnessedAt_of`, `World.WitnessedAt.congr`), and the marks of two procedures deciding
  one listing satisfy the same pointwise properties (`World.listingMarksHold_of_marksHold`). Where whatever
  comes to be across a step needs something held at it, nothing comes to be across a step at
  which nothing is counted (`FamilyCounts.company`).
* **The census of activity** is the listing `fun w x t => w.web.active t x`: `World.CensusMarksHold`,
  `World.CountsOf` and `World.CountsHold` are its forms, and `World.census_table_marks_hold`,
  `World.census_table_holds₂` and their forms for two and three hypotheses state the table for
  it (read by `Becoming.Counting`, `Becoming.CensusCounts` and `Becoming.CensusBinding`). What
  stands (`fun w x t => 0 < w.web.level t x`) and what depends (pairs of relata, `requires`) are
  the other listings `Becoming.Standing` reads.

No premise beyond what each theorem names. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

variable {α : Type}

/-- Two numbers balancing across a step, the ceased among those before it, are a tally there. -/
theorem tally_step {n n' c a : Nat} (le : c ≤ n) (across : n' + c = n + a) :
    ∃ k, n = k + c ∧ n' = k + a :=
  match exists_add_of_le le with
  | ⟨k, before⟩ =>
    ⟨k, before, add_right_cancel c (across.trans
      ((congrArg (· + a) before).trans (Nat.add_right_comm k c a)))⟩

/-- What a listed family counts across each step, as relations: `n` counts what holds at each
step, `c` what of it ceases across the step, `a` what holds after the step and came to be across
it. -/
def FamilyCounts (p : α → Nat → Prop) (l : Nat → List α) (n c a : Nat → Nat) : Prop :=
  ∀ t, n t = (l t).length ∧ Counts (l t) (fun x => CeasesToBe (p x) t) (c t) ∧
    Counts (l (t + 1)) (fun x => ComesToBe (p x) t) (a t)

/-- **The counts of a listed family are a tally**, with no decidedness. -/
theorem FamilyCounts.tally {p : α → Nat → Prop} {l : Nat → List α} {n c a : Nat → Nat}
    (listed : Listed p l) (counted : FamilyCounts p l n c a) : Tally n c a := fun t =>
  match counted t, counted (t + 1) with
  | ⟨length, ceased, came⟩, ⟨length', _, _⟩ =>
    have across : (l (t + 1)).length + c t = (l t).length + a t :=
      Counts.listed_across (p := p) (listed t) (listed (t + 1)) ceased came
    match tally_step (Nat.le_trans ceased.le_length (Nat.le_of_eq length.symm))
      ((congrArg (· + c t) length').trans (across.trans (congrArg (· + a t) length.symm))) with
    | ⟨k, before, after⟩ => ⟨k, before, after⟩

/-- Where a procedure decides, its marks are the counts of a listed family. -/
theorem familyCounts_decided {p : α → Nat → Prop} [∀ x t, Decidable (p x t)] (l : Nat → List α) :
    FamilyCounts p l (fun t => (l t).length) (fun t => ceasings (l t) p t)
      (fun t => comings (l (t + 1)) p t) :=
  fun _ => ⟨rfl, counts_total _, counts_total _⟩

/-- Counts given by values agreeing with them at each step are counts. -/
theorem FamilyCounts.of_eq {p : α → Nat → Prop} {l : Nat → List α} {n c a n' c' a' : Nat → Nat}
    (counted : FamilyCounts p l n c a) (same : ∀ t, n t = n' t ∧ c t = c' t ∧ a t = a' t) :
    FamilyCounts p l n' c' a' := fun t =>
  match counted t, same t with
  | ⟨length, ceased, came⟩, ⟨sameN, sameC, sameA⟩ =>
    ⟨sameN.symm.trans length, sameC ▸ ceased, sameA ▸ came⟩

/-! ## Agreeing listings -/

/-- Coming to be respects agreement at the step and after it. -/
theorem comesToBe_congr {p q : Nat → Prop} {t : Nat} (now : p t ↔ q t)
    (next : p (t + 1) ↔ q (t + 1)) : ComesToBe p t ↔ ComesToBe q t :=
  ⟨fun comes => ⟨fun holds => comes.1 (now.mpr holds), next.mp comes.2⟩,
   fun comes => ⟨fun holds => comes.1 (now.mp holds), next.mpr comes.2⟩⟩

/-- So does ceasing to be. -/
theorem ceasesToBe_congr {p q : Nat → Prop} {t : Nat} (now : p t ↔ q t)
    (next : p (t + 1) ↔ q (t + 1)) : CeasesToBe p t ↔ CeasesToBe q t :=
  ⟨fun ceases => ⟨now.mp ceases.1, fun holds => ceases.2 (next.mpr holds)⟩,
   fun ceases => ⟨now.mpr ceases.1, fun holds => ceases.2 (next.mp holds)⟩⟩

/-- Counts of ceasing agree for determinations that agree at the step and after it. -/
theorem ceasings_congr {p q : α → Nat → Prop} [∀ a t, Decidable (p a t)]
    [∀ a t, Decidable (q a t)] (as : List α) {t : Nat}
    (same : ∀ a, (p a t ↔ q a t) ∧ (p a (t + 1) ↔ q a (t + 1))) :
    ceasings as p t = ceasings as q t :=
  total_congr (fun a => mark_iff (ceasesToBe_congr (same a).1 (same a).2)) as

/-- So do counts of coming. -/
theorem comings_congr {p q : α → Nat → Prop} [∀ a t, Decidable (p a t)]
    [∀ a t, Decidable (q a t)] (as : List α) {t : Nat}
    (same : ∀ a, (p a t ↔ q a t) ∧ (p a (t + 1) ↔ q a (t + 1))) :
    comings as p t = comings as q t :=
  total_congr (fun a => mark_iff (comesToBe_congr (same a).1 (same a).2)) as

/-- What indicates a proposition indicates one agreeing with it. -/
theorem Indicates.congr {p q : Prop} {k : Nat} (same : p ↔ q) (indicates : Indicates p k) :
    Indicates q k :=
  match indicates with
  | .inl ⟨holds, one⟩ => .inl ⟨same.mp holds, one⟩
  | .inr ⟨fails, zero⟩ => .inr ⟨fun holds => fails (same.mpr holds), zero⟩

/-- A count of the members of which `q` holds counts those of which what agrees with `q`
holds. -/
theorem Counts.congr {q q' : α → Prop} (same : ∀ a, q a ↔ q' a) :
    ∀ {as : List α} {n : Nat}, Counts as q n → Counts as q' n
  | [], _, zero => zero
  | a :: _, _, ⟨k, m, indicates, rest, sum⟩ =>
    ⟨k, m, indicates.congr (same a), Counts.congr same rest, sum⟩

/-- A listing of what holds lists what agrees with it. -/
theorem Listed.congr {p q : α → Nat → Prop} {l : Nat → List α} (same : ∀ x t, p x t ↔ q x t)
    (listed : Listed p l) : Listed q l :=
  fun t => ⟨(listed t).1, fun x => (same x t).symm.trans ((listed t).2 x)⟩

/-- The counts of a listed family are its counts under any determination agreeing with it. -/
theorem FamilyCounts.congr {p q : α → Nat → Prop} {l : Nat → List α} {n c a : Nat → Nat}
    (same : ∀ x t, p x t ↔ q x t) (counted : FamilyCounts p l n c a) : FamilyCounts q l n c a :=
  fun t => match counted t with
  | ⟨length, ceased, came⟩ =>
    ⟨length, ceased.congr fun x => ceasesToBe_congr (same x t) (same x (t + 1)),
     came.congr fun x => comesToBe_congr (same x t) (same x (t + 1))⟩

/-- Where whatever comes to be across a step needs something held at it, nothing comes to be
across a step at which nothing is counted. -/
theorem FamilyCounts.company {p : α → Nat → Prop} {l : Nat → List α} {n c a : Nat → Nat}
    (counted : FamilyCounts p l n c a) {t : Nat}
    (ground : ∀ x, x ∈ l (t + 1) → ComesToBe (p x) t → 0 < (l t).length) : 0 < a t → 0 < n t :=
  fun arising => match counted t with
  | ⟨length, _, came⟩ => match came.exists_of_pos arising with
    | ⟨x, listed, comes⟩ => Nat.lt_of_lt_of_le (ground x listed comes) (Nat.le_of_eq length.symm)

namespace World

/-! ## A census table, for any listing -/

section Table

variable {X : World → Type} (L : (w : World) → X w → Nat → Prop)

/-- `Q` holds of every listed family of the world `w` and every counts of it. -/
def ListingHolds (w : World) (Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop) : Prop :=
  ∀ l n c a, Listed (L w) l → FamilyCounts (L w) l n c a → Q n c a

/-- `Q` holds of the marks of every listed family of the world `w`, where a procedure decides
what is listed. -/
def ListingMarksHold (w : World) [∀ x t, Decidable (L w x t)]
    (Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop) : Prop :=
  ∀ l, Listed (L w) l → Q (fun t => (l t).length) (fun t => ceasings (l t) (L w) t)
    (fun t => comings (l (t + 1)) (L w) t)

/-- `n`, `c` and `a` are the marks of a listed family of some world of the class, with a
procedure deciding what is listed there. -/
def WitnessedAt (Class : World → Prop) (n c a : Nat → Nat) : Prop :=
  ∃ (w : World) (_ : ∀ x t, Decidable (L w x t)) (l : Nat → List (X w)), Class w ∧
    Listed (L w) l ∧
      ∀ t, (l t).length = n t ∧ ceasings (l t) (L w) t = c t ∧ comings (l (t + 1)) (L w) t = a t

/-- Every tally meeting `C` is the marks of a listed family of some world of the class, with a
procedure deciding what is listed there. -/
def Witnessed (Class : World → Prop) (C : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop) :
    Prop :=
  ∀ n c a, Tally n c a → C n c a → WitnessedAt L Class n c a

variable {L} {Class : World → Prop} {C Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop}

/-- A listed family of a world of the class, under one listing, witnesses its marks under any
listing agreeing with it in that world. -/
theorem witnessedAt_of {L' : (w : World) → X w → Nat → Prop} {Class : World → Prop}
    {n c a : Nat → Nat} (w : World) [decided : ∀ x t, Decidable (L w x t)] (l : Nat → List (X w))
    (within : Class w) (same : ∀ x t, L w x t ↔ L' w x t) (listed : Listed (L w) l)
    (counts : ∀ t, (l t).length = n t ∧ ceasings (l t) (L w) t = c t ∧
      comings (l (t + 1)) (L w) t = a t) :
    WitnessedAt L' Class n c a :=
  have decided' : ∀ x t, Decidable (L' w x t) := fun x t =>
    @decidable_of_iff _ _ (same x t) (decided x t)
  have agree : ∀ x t, (L' w x t ↔ L w x t) ∧ (L' w x (t + 1) ↔ L w x (t + 1)) := fun x t =>
    ⟨(same x t).symm, (same x (t + 1)).symm⟩
  ⟨w, decided', l, within, listed.congr same, fun t =>
    ⟨(counts t).1,
     (@ceasings_congr _ (L' w) (L w) decided' decided (l t) t fun x => agree x t).trans
       (counts t).2.1,
     (@comings_congr _ (L' w) (L w) decided' decided (l (t + 1)) t fun x => agree x t).trans
       (counts t).2.2⟩⟩

/-- So a witness under one listing is one under any listing agreeing with it in the worlds of
the class. -/
theorem WitnessedAt.congr {L' : (w : World) → X w → Nat → Prop} {Class : World → Prop}
    {n c a : Nat → Nat} (same : ∀ w, Class w → ∀ x t, L w x t ↔ L' w x t)
    (witnessed : WitnessedAt L Class n c a) : WitnessedAt L' Class n c a :=
  match witnessed with
  | ⟨w, decided, l, within, listed, counts⟩ =>
    @witnessedAt_of _ L L' Class n c a w decided l within (same w within) listed counts

/-- Where `Q` is pointwise, what one procedure's marks satisfy another's satisfy: marks deciding the
same listing agree. -/
theorem listingMarksHold_of_marksHold (pointwise : Pointwise Q) {w : World}
    {decided decided' : ∀ x t, Decidable (L w x t)}
    (marks : @ListingMarksHold X L w decided Q) : @ListingMarksHold X L w decided' Q :=
  fun l listed => pointwise (fun t =>
    ⟨rfl, @ceasings_congr _ (L w) (L w) decided decided' (l t) t fun _ => ⟨Iff.rfl, Iff.rfl⟩,
     @comings_congr _ (L w) (L w) decided decided' (l (t + 1)) t fun _ => ⟨Iff.rfl, Iff.rfl⟩⟩)
    (marks l listed)

/-- **A census table, with counts as relations.** Where every listed family of every world of the
class has counts meeting `C`, and every tally meeting `C` is witnessed in the class, a property
holds of every listing of every world of the class exactly when it holds of every tally meeting
`C`: for every property, with no decidedness. -/
theorem table_holds (sound : ∀ w, Class w → w.ListingHolds L C)
    (witnessed : Witnessed L Class C) :
    (∀ n c a, Tally n c a → C n c a → Q n c a) ↔ ∀ w, Class w → w.ListingHolds L Q :=
  ⟨fun law w within l n c a listed counted =>
    law n c a (counted.tally listed) (sound w within l n c a listed counted),
   fun law n c a tally condition => match witnessed n c a tally condition with
    | ⟨w, _, l, within, listed, same⟩ =>
      law w within l n c a listed ((familyCounts_decided l).of_eq same)⟩

/-- **A census table, with the marks a procedure gives.** The same table gives the law for every
pointwise property of the marks: the decided form is a corollary of the counted soundness and the
same witness. -/
theorem table_marks_hold (pointwise : Pointwise Q) (sound : ∀ w, Class w → w.ListingHolds L C)
    (witnessed : Witnessed L Class C) :
    (∀ n c a, Tally n c a → C n c a → Q n c a) ↔
      ∀ (w : World) [∀ x t, Decidable (L w x t)], Class w → w.ListingMarksHold L Q :=
  ⟨fun law w _ within l listed => law _ _ _ ((familyCounts_decided l).tally listed)
    (sound w within l _ _ _ listed (familyCounts_decided l)),
   fun law n c a tally condition => match witnessed n c a tally condition with
    | ⟨w, _, l, within, listed, same⟩ => pointwise same (law w within l listed)⟩

/-- The table with no added condition: a property holds of every listing of every world of the
class exactly when it holds of every tally, where every tally is witnessed in the class. -/
theorem table_holds_free (witnessed : Witnessed L Class fun _ _ _ => True) :
    (∀ n c a, Tally n c a → Q n c a) ↔ ∀ w, Class w → w.ListingHolds L Q :=
  have table := table_holds (Q := Q) (fun _ _ _ _ _ _ _ _ => trivial) witnessed
  ⟨fun law => table.mp fun n c a tally _ => law n c a tally,
   fun law n c a tally => table.mpr law n c a tally trivial⟩

/-- So for the marks a procedure gives, for every pointwise property. -/
theorem table_marks_hold_free (pointwise : Pointwise Q) (witnessed : Witnessed L Class fun _ _ _ => True) :
    (∀ n c a, Tally n c a → Q n c a) ↔
      ∀ (w : World) [∀ x t, Decidable (L w x t)], Class w → w.ListingMarksHold L Q :=
  have table := table_marks_hold pointwise (fun _ _ _ _ _ _ _ _ => trivial) witnessed
  ⟨fun law => table.mp fun n c a tally _ => law n c a tally,
   fun law n c a tally => table.mpr law n c a tally trivial⟩

end Table

/-! ## The census of activity -/

variable {w : World}

/-- `Q` holds of the counts of every census of the world: how many are active at each step,
how many cease and how many arise across it. -/
def CensusMarksHold (w : World) [∀ t x, Decidable (w.web.active t x)]
    (Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop) : Prop :=
  ∀ alive, w.web.Census alive → Q (fun t => (alive t).length)
    (fun t => ceasings (alive t) (fun x s => w.web.active s x) t)
    (fun t => comings (alive (t + 1)) (fun x s => w.web.active s x) t)

/-- `n`, `c` and `a` count the census `alive`: how many are active at each step, how many of
them cease across it, and how many active after it came to be across it; counts as relations,
with no decision procedure. -/
abbrev CountsOf (w : World) (alive : Nat → List w.Relatum) (n c a : Nat → Nat) : Prop :=
  Becoming.FamilyCounts (fun x s => w.web.active s x) alive n c a

/-- `Q` holds of every census of the world and every counts of it. -/
def CountsHold (w : World) (Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop) : Prop :=
  ∀ alive n c a, w.web.Census alive → w.CountsOf alive n c a → Q n c a

/-- **The counts of a census are a tally**, with no decidedness. -/
theorem CountsOf.tally {alive : Nat → List w.Relatum} {n c a : Nat → Nat}
    (census : w.web.Census alive) (counted : w.CountsOf alive n c a) : Tally n c a :=
  Becoming.FamilyCounts.tally census counted

/-- Where a procedure decides activity, its marks count every census. -/
theorem countsOf_decided [∀ t x, Decidable (w.web.active t x)] (alive : Nat → List w.Relatum) :
    w.CountsOf alive (fun t => (alive t).length)
      (fun t => ceasings (alive t) (fun x s => w.web.active s x) t)
      (fun t => comings (alive (t + 1)) (fun x s => w.web.active s x) t) :=
  familyCounts_decided alive

/-- What holds of every counted census holds of the census counts a procedure gives. -/
theorem CountsHold.marks [∀ t x, Decidable (w.web.active t x)]
    {Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop} (holds : w.CountsHold Q) :
    w.CensusMarksHold Q :=
  fun alive census => holds alive _ _ _ census (countsOf_decided alive)

/-- For a pointwise property, what holds of the census counts a procedure gives holds of every
counted census. -/
theorem countsHold_of_marks [∀ t x, Decidable (w.web.active t x)]
    {Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop} (pointwise : Pointwise Q)
    (marks : w.CensusMarksHold Q) : w.CountsHold Q :=
  fun alive _ _ _ census counted => pointwise (fun t =>
    match counted t, countsOf_decided (w := w) alive t with
    | ⟨length, ceased, came⟩, ⟨_, ceased', came'⟩ =>
      ⟨length.symm, ceased'.unique ceased, came'.unique came⟩) (marks alive census)

/-- The table for the census of activity, with the marks a procedure gives (`table_marks_hold`). -/
theorem census_table_marks_hold {Class : World → Prop}
    {C Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop} (pointwise : Pointwise Q)
    (sound : ∀ w, Class w → w.CountsHold C)
    (witnessed : Witnessed (fun w x t => w.web.active t x) Class C) :
    (∀ n c a, Tally n c a → C n c a → Q n c a) ↔
      ∀ (w : World) [∀ t x, Decidable (w.web.active t x)], Class w → w.CensusMarksHold Q :=
  have table := table_marks_hold pointwise sound witnessed
  ⟨fun law w inst within =>
    have marks := table.mp law
    @marks w (fun x t => inst t x) within,
   fun law => table.mpr fun w inst within => @law w (fun t x => inst x t) within⟩

/-- The table for the census of activity with no added condition, with the marks a procedure
gives. -/
theorem census_table_marks_hold_free {Class : World → Prop}
    {Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop} (pointwise : Pointwise Q)
    (witnessed : Witnessed (fun w x t => w.web.active t x) Class fun _ _ _ => True) :
    (∀ n c a, Tally n c a → Q n c a) ↔
      ∀ (w : World) [∀ t x, Decidable (w.web.active t x)], Class w → w.CensusMarksHold Q :=
  have table := census_table_marks_hold (Q := Q) pointwise (fun _ _ _ _ _ _ _ _ => trivial) witnessed
  ⟨fun law => table.mp fun n c a tally _ => law n c a tally,
   fun law n c a tally => table.mpr law n c a tally trivial⟩

/-- The table for the census of activity where the class is given by two hypotheses and the
condition by two, curried as the laws state them; counts as relations. -/
theorem census_table_holds₂ {A B : World → Prop}
    {C D Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop}
    (sound : ∀ w, A w → B w → w.CountsHold fun n c a => C n c a ∧ D n c a)
    (witnessed : Witnessed (fun w x t => w.web.active t x) (fun w => A w ∧ B w)
      fun n c a => C n c a ∧ D n c a) :
    (∀ n c a, Tally n c a → C n c a → D n c a → Q n c a) ↔
      ∀ w, A w → B w → w.CountsHold Q :=
  have table := table_holds (Q := Q) (fun w within => sound w within.1 within.2) witnessed
  ⟨fun law w a b => table.mp (fun n c a tally both => law n c a tally both.1 both.2) w ⟨a, b⟩,
   fun law n c a tally first second => table.mpr (fun w within => law w within.1 within.2) n c a
     tally ⟨first, second⟩⟩

/-- So with the marks a procedure gives, for every pointwise property. -/
theorem census_table_marks_hold₂ {A B : World → Prop}
    {C D Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop} (pointwise : Pointwise Q)
    (sound : ∀ w, A w → B w → w.CountsHold fun n c a => C n c a ∧ D n c a)
    (witnessed : Witnessed (fun w x t => w.web.active t x) (fun w => A w ∧ B w)
      fun n c a => C n c a ∧ D n c a) :
    (∀ n c a, Tally n c a → C n c a → D n c a → Q n c a) ↔
      ∀ (w : World) [∀ t x, Decidable (w.web.active t x)], A w → B w → w.CensusMarksHold Q :=
  have table := census_table_marks_hold (Q := Q) pointwise (fun w within => sound w within.1 within.2)
    witnessed
  ⟨fun law w _ a b => table.mp (fun n c a tally both => law n c a tally both.1 both.2) w ⟨a, b⟩,
   fun law n c a tally first second => table.mpr (fun w _ within => law w within.1 within.2) n c a
     tally ⟨first, second⟩⟩

/-- The table for the census of activity with two hypotheses and three conditions; counts as
relations. -/
theorem census_table_holds₃ {A B : World → Prop}
    {C D E Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop}
    (sound : ∀ w, A w → B w → w.CountsHold fun n c a => C n c a ∧ D n c a ∧ E n c a)
    (witnessed : Witnessed (fun w x t => w.web.active t x) (fun w => A w ∧ B w)
      fun n c a => C n c a ∧ D n c a ∧ E n c a) :
    (∀ n c a, Tally n c a → C n c a → D n c a → E n c a → Q n c a) ↔
      ∀ w, A w → B w → w.CountsHold Q :=
  have table := table_holds (Q := Q) (fun w within => sound w within.1 within.2) witnessed
  ⟨fun law w a b => table.mp (fun n c a tally all => law n c a tally all.1 all.2.1 all.2.2) w
      ⟨a, b⟩,
   fun law n c a tally first second third => table.mpr (fun w within => law w within.1 within.2)
     n c a tally ⟨first, second, third⟩⟩

/-- So with the marks a procedure gives, for every pointwise property. -/
theorem census_table_marks_hold₃ {A B : World → Prop}
    {C D E Q : (Nat → Nat) → (Nat → Nat) → (Nat → Nat) → Prop} (pointwise : Pointwise Q)
    (sound : ∀ w, A w → B w → w.CountsHold fun n c a => C n c a ∧ D n c a ∧ E n c a)
    (witnessed : Witnessed (fun w x t => w.web.active t x) (fun w => A w ∧ B w)
      fun n c a => C n c a ∧ D n c a ∧ E n c a) :
    (∀ n c a, Tally n c a → C n c a → D n c a → E n c a → Q n c a) ↔
      ∀ (w : World) [∀ t x, Decidable (w.web.active t x)], A w → B w → w.CensusMarksHold Q :=
  have table := census_table_marks_hold (Q := Q) pointwise (fun w within => sound w within.1 within.2)
    witnessed
  ⟨fun law w _ a b => table.mp (fun n c a tally all => law n c a tally all.1 all.2.1 all.2.2) w
      ⟨a, b⟩,
   fun law n c a tally first second third =>
     table.mpr (fun w _ within => law w within.1 within.2) n c a tally ⟨first, second, third⟩⟩

end World

end Becoming
