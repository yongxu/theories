import Becoming.ReadingsPersist
import Becoming.LineageDrawdown

/-!
# ReadingsSpread: how readings form, spread and lock (读之所传)

Route (b)'s piece K1 (Ren, 9 November 2026: "ok - 这一类请平行化认真完成，非常重要",
`sources/15-codex-theory-conversations/2026-11-09-route-b-ethics-forms.md`; 8 November: "right or wrong
are 'cognitive structures/dynamics' … 'higher order in dynamics/patterns' … which leads to cascading
changes", `…/2026-11-08-within-becoming-no-should.md`; 10 November: the dynamics to be made "connected,
mapped, and 'unified'"). J2 (`Becoming.ReadingsPersist`) asked which readings persist when a line
carries a fixed inherited reading. This module lets the reading vary at descent, puts several lines in
one world with the pool read off the course, and asks which readings spread under selection by share,
which lock, and where that depends on whether acts return. It is not a ranking: no order of readings
is stated, only what the counts do. No ethical premise and no axiom enters.

* **Revision at descent is the reading loop's update across a step.** Each kid carries its parent's
  reading updated by what the parent sensed at the step it gave (`Generations.RevisesBy`,
  `Flow.RevisesBy`; `ReadingLoop.joint`'s `update`, here across descent). The reading is carried by the
  slot a member stands in, as in J2: revision is a parent giving its standing on to a slot carrying the
  updated reading. Inheritance is the update that keeps the reading (`Flow.inheritsReading_iff`); the
  line read off a flow revises as the flow does (`Flow.RevisesBy.lineOf`). A member is counted in a
  cohort only where it comes to stand, so revision while a member goes on standing is not modelled.
* **The share of a region of readings moves by Price's equation, revision its transmission term.** A
  region of readings (`inR : Sig → Bool`) is counted one at each carrier (`Generations.carrying`); the
  revisions into and out of it across a step are the descents across its boundary
  (`Generations.revisedIn`, `revisedOut`), and they are exactly Price's transmission terms for the count
  (`carrying_raisedAt`, `carrying_loweredAt`). So the share moves by selection proper and by revision
  together (`Generations.share_step`, `mean_step` read for the count). With inheritance nothing is
  revised and the share moves by selection proper alone (`revised_none_of_inherits`; the case of
  `moved_by_selection`). At fixation, every member carrying the region, selection proper is none, and
  the carriers at the next step are the next cohort less the revisions out (`fixed_step`, from `price`):
  a region that has spread to every member is moved only by revision. Near-definitional.
* **Spread needs what feeds the carriers.** In generations of descent in a flow where only active
  formations give and activity needs support, a region every supported member carries is not selected
  against (`Flow.supported_carriers_not_against`, `support_not_against`'s case); at a step where no
  carrier is active, the next cohort's carriers are exactly the revisions into the region
  (`Flow.carriers_inactive_step`, which needs only that active formations give); and under balance,
  where every carrier at a stretch's end requires, at a need of at least `m`, a family whose stock was
  drawn over the stretch below `m` (the ledger), the same holds at the stretch's end
  (`Flow.carriers_drawn_down`, `LineageDrawdown`'s ledger and `family_ends_below_at` restricted to the
  carriers). At such a step a region moves by revision alone. Near-definitional compositions.
* **The share selects no reading beyond the lines' coupling closure.** Under Bound's premises (the rest
  a law of what has stood reading through coupling; the part acting by `act` or `act'`, laws of what has
  stood, `act` reading through its members' coupling, the two agreeing under every level history on
  everything coupled into the coupling closure of a group drawn through the two courses; both courses
  feasible), the listed slots standing and carrying
  any region are as many at every step in the one course as in the other, every slot lying within the
  closure, its own standing coupled into it (`standingCount_unselected`, J2's `reader_kept_alike`
  counted): selection by share, read off the slots standing, favours an act's trace on what couples in,
  never a scope. Near-definitional.
* **A lock: a region closed under revision on the course.** Where a region holds every member at `T`
  and, at every step from `T` on, a carrier's reading updated by what it senses stays in it
  (`Generations.ClosedFrom`), it holds every member at every later step (`fixed_of_closedFrom`, from the
  closure law `kept_iff`, now in `ReadingsPersist`); the other way, a carrier whose update leaves it puts
  a non-carrier into the next cohort (`revised_out`). Two cases give the lock: *variation drawn from
  what is present*, each member sensing the reading of a member of its own cohort and the update keeping
  the region where both lie in it (copying, recombination): fixation is then a lock, directly
  (`fixed_of_present`); and, standing read off a web's levels, revision copying the reading of a relatum
  standing then, where from `T` on every relatum standing carries the region: the region is then closed
  under revision from `T` on (`Flow.closedFrom_of_standing`), so a course that removes the other
  readings' carriers closes the region, under copying. A region absent from a cohort re-enters the next
  only by revision in (`absent_step`). Near-definitional. Not named `Locked`, which is
  RuleCapture's lock of a rule reading the share it selects (K2's join).
* **Witnesses.**
  - `Revised` (generations, descent supplied): a share rising by selection proper (one of two to two of
    two, nothing revised), then fixed, selection proper none, and falling by one revision out
    (`rises_then_revised`).
  - `Contact` (generations, descent and what is sensed supplied): the other reading's carrier leaving no
    kid and every member sensing only its own cohort, the narrow reading is carried by every member at
    every later step (`removed_locked`); a narrow carrier sensing a wide one puts a wide kid into the next
    cohort (`met_replaced`).
  - `Commons` (World, every course the one the acts generate, `Commons.generated`; finitely many relata,
    every course's balance proved for all steps). A focal line (four slots, two sub-lines), a wide line
    and a dweller's line; the focal and wide lines draw on a source, the dweller requires a habitat. A
    member stands one step and, fed, passes its standing on. The focal line reads its own line only
    (draws two from the source and takes the habitat), its line and its source (draws one and takes the
    habitat) or everything (draws two, spares the habitat); taking the habitat, a focal member passes its
    standing on to a second slot. The acts are assigned by design. The population is the descent the
    flow shows from the three founders; the narrow readings are those that do not read the dweller.
    - Reading everything, either world: no narrow carrier at any step, the population three at every
      step, every line persisting (`keep_unmoved`, `keep_persists`).
    - Reading its line and its source, nothing coming back: the narrow count is one of three, two of
      four, then two of three at every later step; selection proper is positive across the first two
      steps (as the acts give: the focal member's second kid comes from the habitat, and the dweller's
      member, its habitat gone, passes its standing on to none) and none at the two after; nothing is
      revised; the dweller's line is removed, the focal and wide lines persist (`cleared_spreads`).
    - The same reading where the dweller renews the source: the same counts over the first three steps,
      selection proper positive across the first two; then the focal line is removed from the third
      step, the wide line from the sixth, and the population is empty from then on (`clearedBack_ends`).
    - Reading its own line only, nothing coming back: the same counts over the first three steps,
      selection proper positive across the first two; then the narrow count is none at every step and
      the population one, the focal line removed and the wide line persisting
      (`overdrawn_spreads_then_ends`). Where the dweller renews the source, the same counts over the
      first three steps, selection proper positive across the first two, and every line is removed by
      the third step, the dweller's from the second (`overdrawnBack_ends`).

**Readings (the AI's, 10 November 2026).**
- Readings form at descent, as the reading loop's update read across a step, and spread as Price's
  equation says: by selection proper on carrying them and by revision. A reading spreads by selection
  only while what feeds its carriers lasts; read off the slots standing, its share is blind beyond the
  lines' coupling closure, as persistence is (J2), so share selection favours an act's trace on what
  couples in, never a scope.
- A narrow reading spreads where its act draws on what another line's continuation requires and nothing
  comes back: in `Commons`, as built, its count rises with its second kid from the habitat and the other
  line's ending, and nothing turns it. Where the loss returns (the dweller renewed the source) the same spread ends with every line;
  where its draw overruns its own source it ends with its line. How long a narrow reading spreads is how
  long what feeds it lasts, and that depends on whether what it removes returns.
- A reading that has spread to every member is moved only by revision. Where variation is drawn from
  what is present, fixation is a lock, and a course that removes the carriers of the other readings
  closes the region under copying: removing one's readers removes one's revisers (J2's
  `RemovesItsReaders`, read at the level of readings). Only variation from beyond the population, a
  reading from outside, can then replace it.

What is not derived: how a reading's act comes to be what it is (the acts are supplied, as in J2); a
lock in the `Commons` world itself (its readings are inherited, so its lock is trivial, and the
removal-closes-the-region law is shown on supplied generations); revision while a member goes on
standing; a selection whose rule or pool is shaped by what it selects (K2's); reading in time (K3's);
any order among readings. Every declaration has an empty axiom report.
-/

namespace Becoming

variable {X Sig : Type}

/-! ## Revision at descent: the reading loop's update across a step -/

namespace SelectionTerm.Generations

variable {α O : Type}

/-- **Revision at descent, as the reading loop's update** (`ReadingLoop.joint`'s `update`, across
descent): each kid carries its parent's reading updated by what the parent sensed at the step it gave
(`sense`). Inheritance is the update that keeps the reading whatever is sensed. -/
def RevisesBy (G : Generations α) (read : α → Sig) (sense : Nat → α → O) (upd : Sig → O → Sig) :
    Prop :=
  ∀ t p k, p ∈ G.family t → k ∈ G.kids t p → read k = upd (read p) (sense t p)

/-- **A region closed under revision on the course from `T` on**: wherever a member at a step `≥ T`
carries the region, its reading updated by what it senses then lies in the region. -/
def ClosedFrom (G : Generations α) (read : α → Sig) (sense : Nat → α → O) (upd : Sig → O → Sig)
    (P : Sig → Prop) (T : Nat) : Prop :=
  ∀ t, T ≤ t → ∀ p, p ∈ G.family t → P (read p) → P (upd (read p) (sense t p))

variable {G : Generations α} {read : α → Sig} {sense : Nat → α → O} {upd : Sig → O → Sig}
  {P : Sig → Prop} {T : Nat}

/-- **A lock: a region fixed at `T` and closed under revision on the course from `T` on stays fixed.**
`kept_iff` with descent read as revision. Near-definitional. -/
theorem fixed_of_closedFrom (revises : G.RevisesBy read sense upd)
    (fixed : ∀ x, x ∈ G.family T → P (read x)) (closed : G.ClosedFrom read sense upd P T) :
    ∀ n x, x ∈ G.family (T + n) → P (read x) :=
  (kept_iff fixed).mpr fun _ _ holds ⟨le, _, parent, kid⟩ =>
    (congrArg P (revises _ _ _ parent kid)).mpr (closed _ le _ parent holds)

/-- **And the other way**: a member carrying the region at a step whose revision there leaves it, with a
kid, puts a non-carrier into the next cohort. -/
theorem revised_out {t : Nat} {p k : α} (revises : G.RevisesBy read sense upd)
    (parent : p ∈ G.family t) (kid : k ∈ G.kids t p) (leaves : ¬ P (upd (read p) (sense t p))) :
    k ∈ G.family (t + 1) ∧ ¬ P (read k) :=
  ⟨ListTests.mem_flatMap_iff.mpr ⟨p, parent, kid⟩,
   fun holds => leaves ((congrArg P (revises t p k parent kid)).mp holds)⟩

/-- **Variation drawn from what is present: fixation is a lock.** Where what each member senses is the
reading of some member of its cohort (copying, recombination, any learning from those present), and
the update keeps the region wherever both the reading and what is sensed lie in it, a region fixed at
`T` stays fixed at every later step. Inheritance and copying are cases (the update keeping the reading,
or taking what is sensed). -/
theorem fixed_of_present {src : Nat → α → α} {upd : Sig → Sig → Sig}
    (revises : G.RevisesBy read (fun t p => read (src t p)) upd)
    (present : ∀ t p, p ∈ G.family t → src t p ∈ G.family t)
    (keeps : ∀ σ τ, P σ → P τ → P (upd σ τ))
    (fixed : ∀ x, x ∈ G.family T → P (read x)) : ∀ n x, x ∈ G.family (T + n) → P (read x)
  | 0, x, member => fixed x member
  | n + 1, _, member => match ListTests.mem_flatMap_iff.mp member with
    | ⟨p, parent, kid⟩ =>
      (congrArg P (revises _ _ _ parent kid)).mpr
        (keeps _ _ (fixed_of_present revises present keeps fixed n p parent)
          (fixed_of_present revises present keeps fixed n _ (present _ p parent)))

end SelectionTerm.Generations

namespace Flow

variable {O : Type} {L : Flow X X} {W : Web X X}

variable (L W) in
/-- **Revision at descent in a flow**: whoever descends from a relatum carries the relatum's reading
updated by what it sensed at the step it gave. The reading is carried by the slot a member stands in,
so revision is a parent giving its standing on to a slot that carries the updated reading. -/
def RevisesBy (read : X → Sig) (sense : Nat → X → O) (upd : Sig → O → Sig) : Prop :=
  ∀ t x g, L.DescendsAt W t x g → read x = upd (read g) (sense t g)

/-- Inheritance is revision by the update that keeps the reading. -/
theorem inheritsReading_iff {read : X → Sig} :
    L.InheritsReading W read ↔ L.RevisesBy W read (fun _ _ => ()) (fun σ _ => σ) :=
  ⟨fun inherits t x g descends => inherits t x g descends,
   fun revises t x g descends => revises t x g descends⟩

/-- The line read off a flow revises as the flow does. -/
theorem RevisesBy.lineOf [DecidableEq X] {read : X → Sig} {sense : Nat → X → O}
    {upd : Sig → O → Sig} (revises : L.RevisesBy W read sense upd) {members first : List X} :
    (L.lineOf W members first).RevisesBy read sense upd :=
  fun t p _ _ kid => revises t _ p (mem_lineOf_kids.mp kid).2

/-- **Removing the other readings' carriers closes the region, where revision copies what stands.**
Where each member senses the reading of a relatum standing then (`src`), the update keeps the region
wherever both lie in it, and from `T` on every relatum standing carries the region, the region is
closed under revision on the course from `T` on. -/
theorem closedFrom_of_standing {G : SelectionTerm.Generations X} {read : X → Sig}
    {src : Nat → X → X} {upd : Sig → Sig → Sig} {P : Sig → Prop} {T : Nat}
    (stands : ∀ t g, T ≤ t → g ∈ G.family t → 0 < W.level t (src t g))
    (keeps : ∀ σ τ, P σ → P τ → P (upd σ τ))
    (carried : ∀ t y, T ≤ t → 0 < W.level t y → P (read y)) :
    G.ClosedFrom read (fun t g => read (src t g)) upd P T :=
  fun t le p mp holds => keeps _ _ holds (carried t _ le (stands t p le mp))

end Flow

/-! ## A region of readings among generations: its count, its revisions, its share -/

namespace SelectionTerm.Generations

variable {α : Type}

/-- The same generations read with another amount. -/
def withAmount (G : Generations α) (a : Nat → α → Nat) : Generations α := ⟨G.first, G.kids, a⟩

theorem withAmount_family (G : Generations α) (a : Nat → α → Nat) :
    ∀ t, (G.withAmount a).family t = G.family t
  | 0 => rfl
  | t + 1 => congrArg (fun F => F.flatMap (G.kids t)) (withAmount_family G a t)

/-- **Carrying a region of readings.** Each member counts one where its reading lies in the region
(`inR`), none where it does not: the generations' sum at a step is the number of carriers, their mean
the region's share. -/
def carrying (G : Generations α) (read : α → Sig) (inR : Sig → Bool) : Generations α :=
  G.withAmount fun _ x => bif inR (read x) then 1 else 0

/-- **Revisions into the region** across the step from `t`: the descents from a parent outside it to a
kid in it. -/
def revisedIn (G : Generations α) (read : α → Sig) (inR : Sig → Bool) (t : Nat) : Nat :=
  total (G.family t) fun p => total (G.kids t p) fun k => bif inR (read k) && !inR (read p) then 1 else 0

/-- **Revisions out of the region** across the step from `t`: the descents from a parent in it to a kid
outside it. -/
def revisedOut (G : Generations α) (read : α → Sig) (inR : Sig → Bool) (t : Nat) : Nat :=
  total (G.family t) fun p => total (G.kids t p) fun k => bif inR (read p) && !inR (read k) then 1 else 0

variable {G : Generations α} {read : α → Sig} {inR : Sig → Bool}

theorem excess_indicator (b c : Bool) :
    excess (bif b then 1 else 0) (bif c then 1 else 0) = bif b && !c then 1 else 0 := by
  cases b <;> cases c <;> rfl

theorem carrying_family (t : Nat) : (G.carrying read inR).family t = G.family t :=
  withAmount_family G _ t

theorem carrying_size (t : Nat) : (G.carrying read inR).size t = G.size t :=
  congrArg List.length (carrying_family t)

/-- What transmission raised, for a region's count, is the revisions into it. -/
theorem carrying_raisedAt (t : Nat) : (G.carrying read inR).raisedAt t = G.revisedIn read inR t :=
  (congrArg (fun F => total F fun p => total (G.kids t p) fun k =>
      excess (bif inR (read k) then 1 else 0) (bif inR (read p) then 1 else 0)) (carrying_family t)).trans
    (total_congr (fun p => total_congr (fun k => excess_indicator (inR (read k)) (inR (read p))) _) _)

/-- What transmission lowered, for a region's count, is the revisions out of it. -/
theorem carrying_loweredAt (t : Nat) : (G.carrying read inR).loweredAt t = G.revisedOut read inR t :=
  (congrArg (fun F => total F fun p => total (G.kids t p) fun k =>
      excess (bif inR (read p) then 1 else 0) (bif inR (read k) then 1 else 0)) (carrying_family t)).trans
    (total_congr (fun p => total_congr (fun k => excess_indicator (inR (read p)) (inR (read k))) _) _)

/-- **The share of a region moves by selection and by revision** (Price's equation, `mean_step`, read
for a region's count). The size times the next count, with the revisions out and the discordant pairs,
is the next size times the count, with the concordant pairs and the revisions in: concordance and
discordance are selection proper on carrying the region, the revisions its transmission. -/
theorem share_step (t : Nat) :
    G.size t * (G.carrying read inR).sum (t + 1) +
        (G.size t * G.revisedOut read inR t + (G.carrying read inR).discordAt t) =
      G.size (t + 1) * (G.carrying read inR).sum t +
        ((G.carrying read inR).concordAt t + G.size t * G.revisedIn read inR t) := by
  have step := (G.carrying read inR).mean_step t
  rw [carrying_size, carrying_size, carrying_raisedAt, carrying_loweredAt] at step
  exact step

/-- A quantity agreeing with another at every member has the same total. -/
theorem total_congr_mem {q r : α → Nat} :
    ∀ {ps : List α}, (∀ p, p ∈ ps → q p = r p) → total ps q = total ps r
  | [], _ => rfl
  | p :: _, same => Naturals.add_congr (same p (.head _))
      (total_congr_mem fun x mem => same x (.tail p mem))

/-- **At fixation selection proper vanishes; only revision moves the region.** Where every member at a
step carries the region, nothing is concordant or discordant, the count is the size, nothing is revised
in, and the carriers at the next step are its size less the revisions out (`price` read there). -/
theorem fixed_step {t : Nat} (fixed : ∀ x, x ∈ G.family t → inR (read x) = true) :
    (G.carrying read inR).concordAt t = 0 ∧ (G.carrying read inR).discordAt t = 0 ∧
      (G.carrying read inR).sum t = G.size t ∧ G.revisedIn read inR t = 0 ∧
      (G.carrying read inR).sum (t + 1) + G.revisedOut read inR t = G.size (t + 1) :=
  have one : ∀ p, p ∈ (G.carrying read inR).family t → (G.carrying read inR).amount t p = 1 :=
    fun p mem => congrArg (fun b => bif b then 1 else 0)
      (fixed p ((congrArg (p ∈ ·) (carrying_family t)).mp mem))
  have none : G.revisedIn read inR t = 0 :=
    total_eq_zero fun p mp => total_eq_zero fun k _ => by
      show (bif inR (read k) && !inR (read p) then 1 else 0) = 0
      rw [fixed p mp]
      cases inR (read k) <;> rfl
  have prices := price ((G.carrying read inR).family t) ((G.carrying read inR).kids t)
    ((G.carrying read inR).amount t) ((G.carrying read inR).amount (t + 1))
  have selected_eq : selected ((G.carrying read inR).family t) ((G.carrying read inR).kids t)
      ((G.carrying read inR).amount t) = G.size (t + 1) :=
    (total_congr_mem fun p mp => (congrArg ((G.carrying read inR).kids t p).length.mul (one p mp)).trans
      (Nat.mul_one _)).trans (((G.carrying read inR).born_eq t).trans (carrying_size (t + 1)))
  have raised_eq : raised ((G.carrying read inR).family t) ((G.carrying read inR).kids t)
      ((G.carrying read inR).amount t) ((G.carrying read inR).amount (t + 1)) = 0 :=
    (carrying_raisedAt t).trans none
  ⟨concord_alike one _, discord_alike one _,
   (total_congr_mem one).trans ((total_ones _).trans (carrying_size t)),
   none,
   (congrArg (· + _) ((G.carrying read inR).offspring_eq t).symm).trans
     ((congrArg (_ + ·) (carrying_loweredAt t).symm).trans
       (prices.trans ((congrArg (· + _) selected_eq).trans (congrArg (_ + ·) raised_eq))))⟩

/-- **A region absent from a cohort re-enters only by revision in.** Where no member at a step carries
the region, nothing is concordant or discordant, and its carriers at the next step are exactly the
revisions into it. (With inheritance the revisions in are none, `revised_none_of_inherits`; with
variation drawn from what is present and an update keeping the complementary region, `fixed_of_present`
on that region keeps the reading absent.) -/
theorem absent_step {t : Nat} (absent : ∀ x, x ∈ G.family t → inR (read x) = false) :
    (G.carrying read inR).concordAt t = 0 ∧ (G.carrying read inR).discordAt t = 0 ∧
      (G.carrying read inR).sum (t + 1) = G.revisedIn read inR t :=
  have zero : ∀ p, p ∈ (G.carrying read inR).family t → (G.carrying read inR).amount t p = 0 :=
    fun p mem => congrArg (fun b => bif b then 1 else 0)
      (absent p ((congrArg (p ∈ ·) (carrying_family t)).mp mem))
  ⟨concord_alike zero _, discord_alike zero _,
   ((G.carrying read inR).offspring_eq t).symm.trans
    ((congrArg (fun F => total F fun p => total (G.kids t p) fun k => bif inR (read k) then 1 else 0)
      (carrying_family t)).trans
      (total_congr_mem fun p mp => total_congr (fun k => by
        show (bif inR (read k) then 1 else 0) = bif inR (read k) && !inR (read p) then 1 else 0
        rw [absent p mp]
        cases inR (read k) <;> rfl) _))⟩

/-- **With inheritance nothing is revised**: where every kid carries its parent's reading, no descent
crosses the region's boundary, so the share moves by selection proper alone (the case of
`moved_by_selection`). -/
theorem revised_none_of_inherits (inherits : ∀ t p k, p ∈ G.family t → k ∈ G.kids t p → read k = read p)
    (t : Nat) : G.revisedIn read inR t = 0 ∧ G.revisedOut read inR t = 0 :=
  ⟨total_eq_zero fun p mp => total_eq_zero fun k kid => by
      show (bif inR (read k) && !inR (read p) then 1 else 0) = 0
      rw [inherits t p k mp kid]
      cases inR (read p) <;> rfl,
   total_eq_zero fun p mp => total_eq_zero fun k kid => by
      show (bif inR (read p) && !inR (read k) then 1 else 0) = 0
      rw [inherits t p k mp kid]
      cases inR (read p) <;> rfl⟩

end SelectionTerm.Generations

/-! ## Spread needs what feeds the carriers -/

namespace Flow

variable {L : Flow X X} {W : Web X X} {G : SelectionTerm.Generations X} {read : X → Sig}
  {inR : Sig → Bool}

theorem indicator_le_one (b : Bool) : (bif b then 1 else 0) ≤ 1 := by
  cases b
  · exact Nat.zero_le 1
  · exact Nat.le_refl 1

/-- **Where the supported members carry the region, it is not selected against.** In generations of
descent in a flow where only active formations give and activity needs support, where every supported
member at a step carries the region, nothing is discordant between offspring numbers and carrying it,
so the carriers' offspring-weighted count is at least its uniform share (`support_not_against`, read
for a region's count). -/
theorem supported_carriers_not_against (acting : L.Acting W) (dependent : W.Dependent)
    (descended : SelectionTerm.Flow.Descended L W G) {t : Nat}
    (carriers : ∀ p, p ∈ G.family t → W.Supported t p → inR (read p) = true) :
    (G.carrying read inR).discordAt t = 0 ∧
      SelectionTerm.born ((G.carrying read inR).family t) ((G.carrying read inR).kids t) *
          total ((G.carrying read inR).family t) ((G.carrying read inR).amount t) ≤
        ((G.carrying read inR).family t).length *
          selected ((G.carrying read inR).family t) ((G.carrying read inR).kids t)
            ((G.carrying read inR).amount t) :=
  SelectionTerm.Flow.support_not_against acting dependent
    (fun p k mp kid => descended t p k
      ((congrArg (p ∈ ·) (SelectionTerm.Generations.carrying_family t)).mp mp) kid)
    fun p mp supported q _ =>
      have carries := carriers p
        ((congrArg (p ∈ ·) (SelectionTerm.Generations.carrying_family t)).mp mp) supported
      Nat.le_trans (indicator_le_one (inR (read q)))
        (Nat.le_of_eq (congrArg (fun b => bif b then 1 else 0) carries).symm)

/-- **Where no carrier acts, a region moves by revision alone.** In generations of descent in a flow
where only active formations give, at a step where no member carrying the region is active, the
carriers at the next step are exactly the revisions into the region. -/
theorem carriers_inactive_step (acting : L.Acting W) (descended : SelectionTerm.Flow.Descended L W G)
    {t : Nat} (inactive : ∀ p, p ∈ G.family t → inR (read p) = true → ¬ W.active t p) :
    (G.carrying read inR).sum (t + 1) = G.revisedIn read inR t :=
  ((G.carrying read inR).offspring_eq t).symm.trans
    ((congrArg (fun F => total F fun p => total (G.kids t p) fun k => bif inR (read k) then 1 else 0)
      (SelectionTerm.Generations.carrying_family t)).trans
      (SelectionTerm.Generations.total_congr_mem fun p mp =>
        match hp : inR (read p) with
        | true => (total_eq_zero fun k kid =>
              absurd ((descended t p k mp kid).active acting) (inactive p mp hp)).trans
            (total_eq_zero fun k kid =>
              absurd ((descended t p k mp kid).active acting) (inactive p mp hp)).symm
        | false => total_congr (fun k => by
            show (bif inR (read k) then 1 else 0) = bif inR (read k) && !false then 1 else 0
            cases inR (read k) <;> rfl) _))

/-- **Drawn down, a region moves by revision alone.** In generations of descent in a balanced flow where
only active formations give and activity needs support, where every carrier of the region at step
`T + n` requires, at a need of at least `m`, a member of a family whose stock was drawn
over the `n` steps from `T` below `m` (the ledger: the stock with what was given it is below `m` with
what was taken from it), the carriers at the next step are exactly the revisions into the region
(`LineageDrawdown`'s ledger and `Flow.family_ends_below_at`, restricted to the carriers). -/
theorem carriers_drawn_down (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) (descended : SelectionTerm.Flow.Descended L W G) {ds : List X}
    {m T n : Nat}
    (draws : W.stock ds T + total (steps T n) (L.replenishment ds) <
      m + total (steps T n) (L.uptake ds))
    (carriers : ∀ q, q ∈ G.family (T + n) → inR (read q) = true →
      ∃ e, e ∈ ds ∧ W.requires (T + n) q e ∧ m ≤ W.need (T + n) q e) :
    (G.carrying read inR).sum (T + n + 1) = G.revisedIn read inR (T + n) :=
  carriers_inactive_step acting descended fun q mq hq => match carriers q mq hq with
    | ⟨_, inside, req, high⟩ => Flow.family_ends_below_at (dependent (T + n) q)
        ((LineageDrawdown.below_iff balances ds T n m).mpr draws) inside req high

end Flow

/-! ## The share selects no reading beyond the lines' coupling closure -/

/-- The listed slots standing at a step that carry the region, counted. -/
def standingCount (ms : List X) (read : X → Sig) (inR : Sig → Bool) (l : Nat → X → Nat) (t : Nat) :
    Nat :=
  total ms fun x => bif inR (read x) && Nat.ble 1 (l t x) then 1 else 0

section Unselected

variable {law : ExchangeLaw X X} {W : Web X X} {obs : X → X → Prop} {part : X → Bool}
  {group : X → Prop} {present : Nat → List X} {start : X → Nat}

/-- **The share a course gives selects no reading beyond the lines' coupling closure.** Under the
premises of `reader_kept_alike` (the rest a law of what has stood reading through coupling; the part
acting by `act` or `act'`, laws of what has stood, `act` reading through its members' coupling, the two
agreeing on everything coupled into the coupling closure of `group` drawn through the two courses; both
courses feasible), let every listed slot lie within that closure, its own standing coupled into it.
Then at every step the listed slots standing and carrying any region of readings are as many in the one
course as in the other: the share of every region among the slots standing is the same course in both,
whatever the two acts do beyond the closure. J2's `reader_kept_alike`, counted. -/
theorem standingCount_unselected {act act' : ExchangeLaw X X}
    (na : law.Nonanticipating) (naAct : act.Nonanticipating) (naAct' : act'.Nonanticipating)
    (through : law.Through W obs part) (actThrough : act.Through W obs (fun h => !part h))
    (feasible : (law.withAct part act).Feasible present start)
    (feasible' : (law.withAct part act').Feasible present start)
    (agree : ∀ t h l c, part h = true →
      (∃ g, WithinClosureOf (((law.withAct part act).course present start).CoupledFromEither W
          ((law.withAct part act').course present start) obs) group g ∧ W.CoupledInto obs g c) →
        act.take t h l c = act'.take t h l c ∧ act.give t h l c = act'.give t h l c)
    {ms : List X} (own : ∀ x, x ∈ ms → obs x x)
    (inside : ∀ x, x ∈ ms → WithinClosureOf (((law.withAct part act).course present start).CoupledFromEither
      W ((law.withAct part act').course present start) obs) group x)
    (read : X → Sig) (inR : Sig → Bool) (t : Nat) :
    standingCount ms read inR ((law.withAct part act).levels present start) t =
      standingCount ms read inR ((law.withAct part act').levels present start) t :=
  SelectionTerm.Generations.total_congr_mem fun x mx =>
    congrArg (fun b => bif inR (read x) && b then 1 else 0)
      (ReadingsPersist.Habitat.ble_congr (reader_kept_alike na naAct naAct' through actThrough feasible
        feasible' agree (own x mx) (inside x mx) t))

end Unselected

/-! ## Witnesses on generations: selection, fixation, revision, and the lock both ways -/

namespace ReadingsSpread.Revised

/-- Six members: `0` carries the narrow reading (`true`) and leaves two kids carrying it, `1` carries
the wide one and leaves none; at the next step each of the two leaves one kid, the second revised
out. -/
def read : Nat → Bool
  | 0 => true
  | 1 => false
  | 2 => true
  | 3 => true
  | 4 => true
  | _ => false

def generations : SelectionTerm.Generations Nat where
  first := [0, 1]
  kids := fun t p => match t, p with
    | 0, 0 => [2, 3]
    | 1, 2 => [4]
    | 1, 3 => [5]
    | _, _ => []
  amount := fun _ _ => 0

/-- **A share rising by selection, then moved by revision alone.** The narrow reading's count goes from
one of two to two of two across the first step, by selection proper (concordance two, discordance
none, nothing revised); it is then fixed, selection proper is none, and across the second step it
falls to one of two by one revision out. -/
theorem rises_then_revised :
    (generations.carrying read id).sum 0 = 1 ∧ generations.size 0 = 2 ∧
      (generations.carrying read id).concordAt 0 = 2 ∧ (generations.carrying read id).discordAt 0 = 0 ∧
      generations.revisedIn read id 0 = 0 ∧ generations.revisedOut read id 0 = 0 ∧
      (generations.carrying read id).sum 1 = 2 ∧ generations.size 1 = 2 ∧
      (generations.carrying read id).concordAt 1 = 0 ∧ (generations.carrying read id).discordAt 1 = 0 ∧
      generations.revisedOut read id 1 = 1 ∧
      (generations.carrying read id).sum 2 = 1 ∧ generations.size 2 = 2 :=
  ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

end ReadingsSpread.Revised

namespace ReadingsSpread.Contact

/-- Readings: `true` the narrow one. Revision copies what is sensed. -/
def copy (_ τ : Bool) : Bool := τ

/-- Member `0` carries the narrow reading, `1` the wide one; later members carry the narrow one. -/
def read : Nat → Bool
  | 1 => false
  | _ => true

/-- **The other reading's carrier removed**: `1` leaves no kid; `0` leaves `2`, and from then on each
member leaves the next. -/
def removed : SelectionTerm.Generations Nat where
  first := [0, 1]
  kids := fun t p => match t, p with
    | 0, 0 => [2]
    | 0, _ => []
    | _ + 1, p => [p + 1]
  amount := fun _ _ => 0

/-- What a member senses: itself (only what is present in its cohort; after the first step the
cohort holds no other reading). -/
def senseSelf (_ : Nat) (p : Nat) : Nat := p

theorem removed_family : ∀ t, removed.family (t + 1) = [t + 2]
  | 0 => rfl
  | t + 1 => (congrArg (fun F => F.flatMap (removed.kids (t + 1))) (removed_family t)).trans rfl

theorem removed_revises : removed.RevisesBy read (fun t p => read (senseSelf t p)) copy := by
  intro t p k parent kid
  show read k = read p
  cases t with
  | zero =>
    have parent' : p ∈ [0, 1] := parent
    cases parent' with
    | head =>
      have kid' : k ∈ [2] := kid
      cases kid' with
      | head => rfl
      | tail _ h => cases h
    | tail _ h =>
      cases h with
      | head =>
        have kid' : k ∈ ([] : List Nat) := kid
        cases kid'
      | tail _ h => cases h
  | succ t =>
    have parent' : p ∈ [t + 2] := (congrArg (p ∈ ·) (removed_family t)).mp parent
    cases parent' with
    | head =>
      have kid' : k ∈ [t + 2 + 1] := kid
      cases kid' with
      | head => rfl
      | tail _ h => cases h
    | tail _ h => cases h

/-- **Removed, then locked.** From the first step on every member carries the narrow reading and senses
only what is present: by `fixed_of_present`, it is carried by every member at every later step. -/
theorem removed_locked : ∀ n x, x ∈ removed.family (1 + n) → read x = true :=
  SelectionTerm.Generations.fixed_of_present (P := fun σ => σ = true) (src := senseSelf)
    removed_revises
    (fun _ _ member => member)
    (fun _ _ _ h => h)
    (by
      intro x member
      have m : x ∈ [2] := (congrArg (x ∈ ·) (removed_family 0)).mp member
      cases m with
      | head => rfl
      | tail _ h => cases h)

/-- **Met, then replaced**: `0` senses the wide carrier `1` and its kid copies the wide reading. -/
def met : SelectionTerm.Generations Nat where
  first := [0, 1]
  kids := fun t p => match t, p with
    | 0, 0 => [3]
    | 0, 1 => [4]
    | _, _ => []
  amount := fun _ _ => 0

def senseOther (_ : Nat) : Nat → Nat
  | 0 => 1
  | p => p

/-- Members `3` on carry the wide reading in this course. -/
def readMet : Nat → Bool
  | 0 => true
  | 2 => true
  | _ => false

theorem met_revises : met.RevisesBy readMet (fun t p => readMet (senseOther t p)) copy := by
  intro t p k parent kid
  cases t with
  | zero =>
    have parent' : p ∈ [0, 1] := parent
    cases parent' with
    | head =>
      have kid' : k ∈ [3] := kid
      cases kid' with
      | head => rfl
      | tail _ h => cases h
    | tail _ h =>
      cases h with
      | head =>
        have kid' : k ∈ [4] := kid
        cases kid' with
        | head => rfl
        | tail _ h => cases h
      | tail _ h => cases h
  | succ t =>
    have kid' : k ∈ ([] : List Nat) := kid
    cases kid'

/-- **Met, then replaced.** Fixed? No: the narrow carrier, sensing the wide one, puts a wide kid into the
next cohort (`revised_out`): the region is not closed on this course from the first step. -/
theorem met_replaced : 3 ∈ met.family 1 ∧ ¬ readMet 3 = true :=
  SelectionTerm.Generations.revised_out (P := fun σ => σ = true) (t := 0) (p := 0) met_revises
    (List.Mem.head _) (List.Mem.head _) (fun h => Bool.noConfusion h)

end ReadingsSpread.Contact

/-! ## Witness: a commons, a focal line drawing on a dweller's habitat, with and without return -/

namespace ReadingsSpread.Commons

/-- The focal line's slots `n0 n1 n2 n3` (two sub-lines, `n0 ↔ n2` and `n1 ↔ n3`), a wide line `w0 w1`,
the source `s` both draw on, the habitat `h`, and the dweller's line `d0 d1`. -/
inductive Rel where
  | n0 | n1 | n2 | n3 | w0 | w1 | s | h | d0 | d1
  deriving DecidableEq

/-- The focal line's reading: its own line only, the line and its source, or everything. -/
inductive Reading where
  | own | source | whole

/-- What a focal member draws from the source: two where it reads its own line only or everything (its
whole need from its own source), one where it reads its line and its source (taking the habitat in
place of one unit of the source). -/
def drawS : Reading → Nat
  | .own => 2
  | .source => 1
  | .whole => 2

/-- Whether a focal member takes the habitat: where it does not read the dweller. -/
def clears : Reading → Bool
  | .own => true
  | .source => true
  | .whole => false

/-- A relatum stands: its level is at least one. -/
def stands (l : Nat → Rel → Nat) (t : Nat) (x : Rel) : Bool := Nat.ble 1 (l t x)

/-- A member is fed: the focal slots where the source stands at five or more, the wide line's where it
stands at one or more, the dweller's where the habitat stands at one or more. -/
def fed (l : Nat → Rel → Nat) (t : Nat) : Rel → Bool
  | .n0 | .n1 | .n2 | .n3 => Nat.ble 5 (l t .s)
  | .w0 | .w1 => Nat.ble 1 (l t .s)
  | .d0 | .d1 => Nat.ble 1 (l t .h)
  | .s | .h => true

/-- What each relatum takes from and gives to each condition across a step, from whether it stands
(`st`), is fed (`fd`) and the habitat stands (`hh`). A standing member takes its own unit (each lasts
one step) and, fed, passes its standing on to the next slot of its line; a focal member draws from the
source as its reading gives and, reading the dweller out, takes the habitat where it stands, passing
its standing on to a second slot as well (`n0` to `n1`, `n2` to `n3`); a wide member draws one. Where
nothing comes back (`back = false`) the source renews itself by three; where the dweller renews it,
each fed dweller member gives it three. -/
def conduct (back : Bool) (σ : Reading) (st fd hh : Bool) : Rel → Rel → Nat × Nat
  | .n0, .n0 | .n1, .n1 | .n2, .n2 | .n3, .n3 | .w0, .w0 | .w1, .w1 | .d0, .d0 | .d1, .d1 =>
      (bif st then 1 else 0, 0)
  | .n0, .n1 | .n2, .n3 =>
      (0, bif st && fd && clears σ && hh then 1 else 0)
  | .n0, .n2 | .n1, .n3 | .n2, .n0 | .n3, .n1 | .w0, .w1 | .w1, .w0 | .d0, .d1 | .d1, .d0 =>
      (0, bif st && fd then 1 else 0)
  | .n0, .n3 | .n0, .w0 | .n0, .w1 | .n0, .d0 | .n0, .d1 | .n1, .n0 | .n1, .n2 | .n1, .w0 | .n1, .w1
    | .n1, .d0 | .n1, .d1 | .n2, .n1 | .n2, .w0 | .n2, .w1 | .n2, .d0 | .n2, .d1 | .n3, .n0
    | .n3, .n2 | .n3, .w0 | .n3, .w1 | .n3, .d0 | .n3, .d1 | .w0, .n0 | .w0, .n1 | .w0, .n2
    | .w0, .n3 | .w0, .h | .w0, .d0 | .w0, .d1 | .w1, .n0 | .w1, .n1 | .w1, .n2 | .w1, .n3 | .w1, .h
    | .w1, .d0 | .w1, .d1 | .s, .n0 | .s, .n1 | .s, .n2 | .s, .n3 | .s, .w0 | .s, .w1 | .s, .h
    | .s, .d0 | .s, .d1 | .h, .n0 | .h, .n1 | .h, .n2 | .h, .n3 | .h, .w0 | .h, .w1 | .h, .s
    | .h, .h | .h, .d0 | .h, .d1 | .d0, .n0 | .d0, .n1 | .d0, .n2 | .d0, .n3 | .d0, .w0 | .d0, .w1
    | .d0, .h | .d1, .n0 | .d1, .n1 | .d1, .n2 | .d1, .n3 | .d1, .w0 | .d1, .w1 | .d1, .h =>
      (0, 0)
  | .n0, .s | .n1, .s | .n2, .s | .n3, .s =>
      (bif st && fd then drawS σ else 0, 0)
  | .n0, .h | .n1, .h | .n2, .h | .n3, .h =>
      (bif st && fd && clears σ && hh then 1 else 0, 0)
  | .w0, .s | .w1, .s =>
      (bif st && fd then 1 else 0, 0)
  | .s, .s =>
      (0, bif back then 0 else 3)
  | .d0, .s | .d1, .s =>
      (0, bif back && (st && fd) then 3 else 0)

/-- **The act a reading gives**: each relatum's conduct read off its own standing, whether it is fed,
and whether the habitat stands. -/
def act (back : Bool) (σ : Reading) : ExchangeLaw Rel Rel :=
  ⟨fun t x l c => (conduct back σ (stands l t x) (fed l t x) (stands l t .h) x c).1,
   fun t x l c => (conduct back σ (stands l t x) (fed l t x) (stands l t .h) x c).2⟩

/-- The focal line's slots. -/
def isFocal : Rel → Bool
  | .n0 => true
  | .n1 => true
  | .n2 => true
  | .n3 => true
  | .w0 => false
  | .w1 => false
  | .s => false
  | .h => false
  | .d0 => false
  | .d1 => false

/-- The readings carried when the focal line carries `σ`: every other relatum reads everything. -/
def readOf (σ : Reading) (x : Rel) : Reading := bif isFocal x then σ else .whole

/-- The rest acting by its readings. -/
def restLaw (back : Bool) : ExchangeLaw Rel Rel := ExchangeLaw.byReading (act back) fun _ => .whole

/-- The world in which the focal line carries `σ`: Bound's `law.withAct part (act σ)`. -/
def world (back : Bool) (σ : Reading) : ExchangeLaw Rel Rel := (restLaw back).withAct isFocal (act back σ)

/-- **Each relatum acts by the reading it carries.** -/
theorem world_byReading (back : Bool) (σ : Reading) (t : Nat) (x : Rel) (l : Nat → Rel → Nat) (c : Rel) :
    (ExchangeLaw.byReading (act back) (readOf σ)).take t x l c = (world back σ).take t x l c ∧
      (ExchangeLaw.byReading (act back) (readOf σ)).give t x l c = (world back σ).give t x l c := by
  cases x <;> exact ⟨rfl, rfl⟩

def members : List Rel := [.n0, .n1, .n2, .n3, .w0, .w1, .s, .h, .d0, .d1]

/-- The focal slots require the source at five, the wide line's at one, the dweller's the habitat at
one. -/
def requires : Rel → Rel → Prop
  | .n0, .n0 | .n0, .n1 | .n0, .n2 | .n0, .n3 | .n0, .w0 | .n0, .w1 | .n0, .h | .n0, .d0 | .n0, .d1
    | .n1, .n0 | .n1, .n1 | .n1, .n2 | .n1, .n3 | .n1, .w0 | .n1, .w1 | .n1, .h | .n1, .d0
    | .n1, .d1 | .n2, .n0 | .n2, .n1 | .n2, .n2 | .n2, .n3 | .n2, .w0 | .n2, .w1 | .n2, .h
    | .n2, .d0 | .n2, .d1 | .n3, .n0 | .n3, .n1 | .n3, .n2 | .n3, .n3 | .n3, .w0 | .n3, .w1
    | .n3, .h | .n3, .d0 | .n3, .d1 | .w0, .n0 | .w0, .n1 | .w0, .n2 | .w0, .n3 | .w0, .w0
    | .w0, .w1 | .w0, .h | .w0, .d0 | .w0, .d1 | .w1, .n0 | .w1, .n1 | .w1, .n2 | .w1, .n3
    | .w1, .w0 | .w1, .w1 | .w1, .h | .w1, .d0 | .w1, .d1 | .s, .n0 | .s, .n1 | .s, .n2 | .s, .n3
    | .s, .w0 | .s, .w1 | .s, .s | .s, .h | .s, .d0 | .s, .d1 | .h, .n0 | .h, .n1 | .h, .n2
    | .h, .n3 | .h, .w0 | .h, .w1 | .h, .s | .h, .h | .h, .d0 | .h, .d1 | .d0, .n0 | .d0, .n1
    | .d0, .n2 | .d0, .n3 | .d0, .w0 | .d0, .w1 | .d0, .s | .d0, .d0 | .d0, .d1 | .d1, .n0
    | .d1, .n1 | .d1, .n2 | .d1, .n3 | .d1, .w0 | .d1, .w1 | .d1, .s | .d1, .d0 | .d1, .d1 =>
      False
  | .n0, .s | .n1, .s | .n2, .s | .n3, .s | .w0, .s | .w1, .s | .d0, .h | .d1, .h =>
      True

def need (x : Rel) (_ : Rel) : Nat := bif isFocal x then 5 else 1

/-- The web with levels `lev`: a relatum is active while it stands and is fed. -/
def webOf (lev : Nat → Rel → Nat) : Web Rel Rel :=
  ⟨lev, fun t x => 0 < lev t x ∧ fed lev t x = true, fun _ => requires, fun _ => need,
   fun _ => requires⟩

/-- The flow in which every relatum exchanges as the world gives under the levels `lev`. -/
def flowOf (back : Bool) (σ : Reading) (lev : Nat → Rel → Nat) : Flow Rel Rel :=
  ⟨fun _ => members, fun t x c => (world back σ).take t x lev c,
   fun t x c => (world back σ).give t x lev c⟩

theorem flowOf_follows (back : Bool) (σ : Reading) (lev : Nat → Rel → Nat) :
    (flowOf back σ lev).Follows (world back σ) (fun _ => false) (webOf lev).level :=
  fun _ _ _ _ => ⟨rfl, rfl⟩

/-! ### The acts read what has stood -/

theorem fed_of_agree {l l' : Nat → Rel → Nat} {t : Nat} (same : ∀ c, l t c = l' t c) :
    ∀ x, fed l t x = fed l' t x
  | .n0 | .n1 | .n2 | .n3 => congrArg (Nat.ble 5) (same .s)
  | .w0 | .w1 => congrArg (Nat.ble 1) (same .s)
  | .d0 | .d1 => congrArg (Nat.ble 1) (same .h)
  | .s | .h => rfl

theorem act_nonanticipating (back : Bool) (σ : Reading) : (act back σ).Nonanticipating :=
  fun t x l l' agree c => by
    have same : ∀ c, l t c = l' t c := agree t (Nat.le_refl t)
    show (conduct back σ (stands l t x) (fed l t x) (stands l t .h) x c).1 =
        (conduct back σ (stands l' t x) (fed l' t x) (stands l' t .h) x c).1 ∧
      (conduct back σ (stands l t x) (fed l t x) (stands l t .h) x c).2 =
        (conduct back σ (stands l' t x) (fed l' t x) (stands l' t .h) x c).2
    rw [show stands l t x = stands l' t x from congrArg (Nat.ble 1) (same x),
      show stands l t .h = stands l' t .h from congrArg (Nat.ble 1) (same .h), fed_of_agree same x]
    exact ⟨rfl, rfl⟩

theorem world_nonanticipating (back : Bool) (σ : Reading) : (world back σ).Nonanticipating :=
  ExchangeLaw.withAct_nonanticipating
    (ExchangeLaw.byReading_nonanticipating (act_nonanticipating back) _) (act_nonanticipating back σ)

/-! ### The six courses -/

open ReadingsPersist.Habitat (alt alt' first second)

/-- One at even steps from the second on. -/
def evenLate : Nat → Nat
  | 0 => 0
  | 1 => 0
  | t + 2 => alt t

/-- **Kept** (the focal line reads everything, either world): every line passes its standing on at every
step; the source stays at five, the habitat at one. -/
def keep (t : Nat) : Rel → Nat
  | .n0 => alt t
  | .n1 => 0
  | .n2 => alt' t
  | .n3 => 0
  | .w0 => alt t
  | .w1 => alt' t
  | .s => 5
  | .h => 1
  | .d0 => alt t
  | .d1 => alt' t

/-- **Cleared, nothing coming back** (the focal line reads its line and its source): at the first step
the focal member takes the habitat and passes its standing on to two slots; from then on the focal line
has two members at every step, the wide line one, the dweller's line none from the second step; the
source rises to six and stays. -/
def cleared (t : Nat) : Rel → Nat
  | .n0 => alt t
  | .n1 => alt' t
  | .n2 => alt' t
  | .n3 => evenLate t
  | .w0 => alt t
  | .w1 => alt' t
  | .s => Witnesses.profile [5] 6 t
  | .h => first t
  | .d0 => first t
  | .d1 => second t

/-- The source where the focal line reads its own line only and nothing comes back: five, five, three,
then rising by two at each step. -/
def overSource : Nat → Nat
  | 0 => 5
  | 1 => 5
  | t + 2 => 2 * t + 3

/-- **Overdrawn, nothing coming back** (the focal line reads its own line only): it takes the habitat
and doubles at the first step, draws four at the second, finds the source below its need at the third
and ends; the wide line persists on the renewing source; the dweller's line ends. -/
def overdrawn (t : Nat) : Rel → Nat
  | .n0 => Witnesses.profile [1, 0, 1] 0 t
  | .n1 => second t
  | .n2 => second t
  | .n3 => Witnesses.profile [0, 0, 1] 0 t
  | .w0 => alt t
  | .w1 => alt' t
  | .s => overSource t
  | .h => first t
  | .d0 => first t
  | .d1 => second t

/-- **Cleared, the dweller renewing the source** (the focal line reads its line and its source): it
doubles as before; the dweller's line ends, the source is no longer renewed, the focal line finds it
below its need at the third step and ends, and the wide line ends at the sixth. -/
def clearedBack (t : Nat) : Rel → Nat
  | .n0 => Witnesses.profile [1, 0, 1] 0 t
  | .n1 => second t
  | .n2 => second t
  | .n3 => Witnesses.profile [0, 0, 1] 0 t
  | .w0 => Witnesses.profile [1, 0, 1, 0, 1] 0 t
  | .w1 => Witnesses.profile [0, 1, 0, 1, 0, 1] 0 t
  | .s => Witnesses.profile [5, 6, 3, 2, 1] 0 t
  | .h => first t
  | .d0 => first t
  | .d1 => second t

/-- **Overdrawn, the dweller renewing the source** (the focal line reads its own line only): every line
ends at the third step. -/
def overdrawnBack (t : Nat) : Rel → Nat
  | .n0 => Witnesses.profile [1, 0, 1] 0 t
  | .n1 => second t
  | .n2 => second t
  | .n3 => Witnesses.profile [0, 0, 1] 0 t
  | .w0 => Witnesses.profile [1, 0, 1] 0 t
  | .w1 => second t
  | .s => Witnesses.profile [5, 5] 0 t
  | .h => first t
  | .d0 => first t
  | .d1 => second t

def start : Rel → Nat := keep 0

def present : Nat → List Rel := fun _ => members

theorem keep_balances : ∀ (back : Bool) (t : Nat) (c : Rel),
    (webOf keep).level (t + 1) c + (flowOf back .whole keep).taken t c =
      (webOf keep).level t c + (flowOf back .whole keep).given t c
  | false, 0, c => by cases c <;> rfl
  | false, 1, c => by cases c <;> rfl
  | false, t + 2, c => keep_balances false t c
  | true, 0, c => by cases c <;> rfl
  | true, 1, c => by cases c <;> rfl
  | true, t + 2, c => keep_balances true t c

theorem cleared_balances_late : ∀ (t : Nat) (c : Rel),
    (webOf cleared).level (t + 3) c + (flowOf false .source cleared).taken (t + 2) c =
      (webOf cleared).level (t + 2) c + (flowOf false .source cleared).given (t + 2) c
  | 0, c => by cases c <;> rfl
  | 1, c => by cases c <;> rfl
  | t + 2, c => cleared_balances_late t c

theorem cleared_balances : (flowOf false .source cleared).Balances (webOf cleared)
  | 0, c => by cases c <;> rfl
  | 1, c => by cases c <;> rfl
  | t + 2, c => cleared_balances_late t c

/-- From the fourth step on, only the wide line draws on the source: one unit at each step. -/
theorem overdrawn_taken_late : ∀ t, (flowOf false .own overdrawn).taken (t + 3) .s = 1
  | 0 => rfl
  | 1 => rfl
  | t + 2 => overdrawn_taken_late t

theorem overdrawn_balances_late : ∀ (t : Nat) (c : Rel),
    (webOf overdrawn).level (t + 4) c + (flowOf false .own overdrawn).taken (t + 3) c =
      (webOf overdrawn).level (t + 3) c + (flowOf false .own overdrawn).given (t + 3) c
  | t, .s => by
    show overSource (t + 4) + (flowOf false .own overdrawn).taken (t + 3) .s =
      overSource (t + 3) + (flowOf false .own overdrawn).given (t + 3) .s
    rw [overdrawn_taken_late t]
    rfl
  | 0, c => by cases c <;> rfl
  | 1, c => by cases c <;> rfl
  | t + 2, .n0 => overdrawn_balances_late t .n0
  | t + 2, .n1 => overdrawn_balances_late t .n1
  | t + 2, .n2 => overdrawn_balances_late t .n2
  | t + 2, .n3 => overdrawn_balances_late t .n3
  | t + 2, .w0 => overdrawn_balances_late t .w0
  | t + 2, .w1 => overdrawn_balances_late t .w1
  | t + 2, .h => overdrawn_balances_late t .h
  | t + 2, .d0 => overdrawn_balances_late t .d0
  | t + 2, .d1 => overdrawn_balances_late t .d1

theorem overdrawn_balances : (flowOf false .own overdrawn).Balances (webOf overdrawn)
  | 0, c => by cases c <;> rfl
  | 1, c => by cases c <;> rfl
  | 2, c => by cases c <;> rfl
  | t + 3, c => overdrawn_balances_late t c

theorem clearedBack_balances : (flowOf true .source clearedBack).Balances (webOf clearedBack)
  | 0, c => by cases c <;> rfl
  | 1, c => by cases c <;> rfl
  | 2, c => by cases c <;> rfl
  | 3, c => by cases c <;> rfl
  | 4, c => by cases c <;> rfl
  | 5, c => by cases c <;> rfl
  | _ + 6, c => by cases c <;> rfl

theorem overdrawnBack_balances : (flowOf true .own overdrawnBack).Balances (webOf overdrawnBack)
  | 0, c => by cases c <;> rfl
  | 1, c => by cases c <;> rfl
  | 2, c => by cases c <;> rfl
  | _ + 3, c => by cases c <;> rfl

/-- **Each is the course the acts generate** (`ExchangeLaw.levels_of_follows`): nothing about the
courses is supplied beyond the acts, the web, the starting levels and the relata present. -/
theorem generated :
    (∀ back t c, keep t c = (world back .whole).levels present start t c) ∧
    (∀ t c, cleared t c = (world false .source).levels present start t c) ∧
    (∀ t c, overdrawn t c = (world false .own).levels present start t c) ∧
    (∀ t c, clearedBack t c = (world true .source).levels present start t c) ∧
    (∀ t c, overdrawnBack t c = (world true .own).levels present start t c) :=
  ⟨fun back t c => ExchangeLaw.levels_of_follows (world_nonanticipating back .whole) (keep_balances back)
      (fun _ => rfl) (flowOf_follows back .whole keep) (fun _ => rfl) t t (Nat.le_refl t) c,
   fun t c => ExchangeLaw.levels_of_follows (world_nonanticipating false .source) cleared_balances
      (fun _ => rfl) (flowOf_follows false .source cleared) (fun c => by cases c <;> rfl) t t
      (Nat.le_refl t) c,
   fun t c => ExchangeLaw.levels_of_follows (world_nonanticipating false .own) overdrawn_balances
      (fun _ => rfl) (flowOf_follows false .own overdrawn) (fun c => by cases c <;> rfl) t t
      (Nat.le_refl t) c,
   fun t c => ExchangeLaw.levels_of_follows (world_nonanticipating true .source) clearedBack_balances
      (fun _ => rfl) (flowOf_follows true .source clearedBack) (fun c => by cases c <;> rfl) t t
      (Nat.le_refl t) c,
   fun t c => ExchangeLaw.levels_of_follows (world_nonanticipating true .own) overdrawnBack_balances
      (fun _ => rfl) (flowOf_follows true .own overdrawnBack) (fun c => by cases c <;> rfl) t t
      (Nat.le_refl t) c⟩

/-! ### The population read off each course, and its share -/

/-- The population read off a course: the descent the flow shows from the three lines' founders. -/
def pop (back : Bool) (σ : Reading) (lev : Nat → Rel → Nat) : SelectionTerm.Generations Rel :=
  (flowOf back σ lev).lineOf (webOf lev) members [.n0, .w0, .d0]

/-- The narrow readings: those that do not read the dweller. -/
def isNarrow : Reading → Bool
  | .own => true
  | .source => true
  | .whole => false

/-- The narrow readings' count among the population. -/
def narrow (back : Bool) (σ : Reading) (lev : Nat → Rel → Nat) : SelectionTerm.Generations Rel :=
  (pop back σ lev).carrying (readOf σ) isNarrow

/-- The count of a course's narrow carriers at a step is read off its cohort then. -/
theorem narrow_sum (back : Bool) (σ : Reading) (lev : Nat → Rel → Nat) (t : Nat) :
    (narrow back σ lev).sum t = total ((pop back σ lev).family t)
      (fun x => bif isNarrow (readOf σ x) then 1 else 0) :=
  congrArg (fun F => total F fun x => bif isNarrow (readOf σ x) then 1 else 0)
    (SelectionTerm.Generations.carrying_family t)

/-- **Readings are inherited along descent**, in every course of every world. -/
theorem inherits (back : Bool) (σ : Reading) (lev : Nat → Rel → Nat) :
    (flowOf back σ lev).InheritsReading (webOf lev) (readOf σ) := by
  intro t x g descends
  have gives := descends.2.1
  cases g <;> cases x <;> first | rfl | exact absurd gives (Nat.lt_irrefl 0)

theorem flatMap_congr {α β : Type} {f g : α → List β} (same : ∀ a, f a = g a) :
    ∀ l : List α, l.flatMap f = l.flatMap g
  | [] => rfl
  | a :: l => (congrArg (· ++ l.flatMap f) (same a)).trans (congrArg (g a ++ ·) (flatMap_congr same l))

theorem keep_shift : ∀ (back : Bool) (t : Nat),
    (pop back .whole keep).family (t + 2) = (pop back .whole keep).family t
  | false, 0 => rfl
  | true, 0 => rfl
  | back, t + 1 => (congrArg (fun F => F.flatMap ((pop back .whole keep).kids (t + 2)))
      (keep_shift back t)).trans rfl

theorem cleared_shift : ∀ t,
    (pop false .source cleared).family (t + 4) = (pop false .source cleared).family (t + 2)
  | 0 => rfl
  | t + 1 => (congrArg (fun F => F.flatMap ((pop false .source cleared).kids (t + 4)))
      (cleared_shift t)).trans rfl

theorem overdrawn_kids_shift : ∀ t p,
    (pop false .own overdrawn).kids (t + 5) p = (pop false .own overdrawn).kids (t + 3) p := by
  intro t p
  cases p <;> rfl

theorem overdrawn_shift : ∀ t,
    (pop false .own overdrawn).family (t + 5) = (pop false .own overdrawn).family (t + 3)
  | 0 => rfl
  | t + 1 => (congrArg (fun F => F.flatMap ((pop false .own overdrawn).kids (t + 5)))
      (overdrawn_shift t)).trans (flatMap_congr (overdrawn_kids_shift t) _)

/-- **Kept, either world: nothing moves.** No member carries a narrow reading at any step, and the
population is three at every step. -/
theorem keep_unmoved (back : Bool) :
    ∀ t, (narrow back .whole keep).sum t = 0 ∧ (pop back .whole keep).size t = 3
  | 0 => by cases back <;> exact ⟨rfl, rfl⟩
  | 1 => by cases back <;> exact ⟨rfl, rfl⟩
  | t + 2 =>
    ⟨(narrow_sum back .whole keep (t + 2)).trans
        ((congrArg (fun F => total F fun x => bif isNarrow (readOf .whole x) then 1 else 0)
          (keep_shift back t)).trans ((narrow_sum back .whole keep t).symm.trans (keep_unmoved back t).1)),
     (congrArg List.length (keep_shift back t)).trans (keep_unmoved back t).2⟩

/-! ### Which lines go on, and the narrow share, course by course -/

/-- The three lines. -/
inductive Line where
  | focal | wide | dweller

def isWide : Rel → Bool
  | .n0 => false
  | .n1 => false
  | .n2 => false
  | .n3 => false
  | .w0 => true
  | .w1 => true
  | .s => false
  | .h => false
  | .d0 => false
  | .d1 => false

def isDweller : Rel → Bool
  | .n0 => false
  | .n1 => false
  | .n2 => false
  | .n3 => false
  | .w0 => false
  | .w1 => false
  | .s => false
  | .h => false
  | .d0 => true
  | .d1 => true

/-- Each line's slots. -/
def slotsOf : Line → Rel → Prop
  | .focal, x => isFocal x = true
  | .wide, x => isWide x = true
  | .dweller, x => isDweller x = true

theorem profile_late : ∀ (vs : List Nat) (t : Nat), vs.length ≤ t → Witnesses.profile vs 0 t = 0
  | [], _, _ => rfl
  | _ :: _, 0, le => absurd le (Nat.not_succ_le_zero _)
  | _ :: vs, t + 1, le => profile_late vs t (Nat.le_of_succ_le_succ le)

/-- A line none of whose slots stands from `T` on, and one of which stands at the start, is removed. -/
theorem removes_of_gone {lev : Nat → Rel → Nat} {i : Line} {x₀ : Rel} (slot : slotsOf i x₀)
    (begins : 0 < lev 0 x₀) {T : Nat} (gone : ∀ t x, T ≤ t → slotsOf i x → lev t x = 0) :
    RemovesLine slotsOf lev i :=
  ⟨⟨x₀, slot, begins⟩, T, fun t le ⟨x, sx, stands⟩ =>
    Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le stands (Nat.le_of_eq (gone t x le sx)))⟩

/-- A line two of whose slots alternate stands late. -/
theorem standsLate_alt {lev : Nat → Rel → Nat} {i : Line} {x y : Rel} (sx : slotsOf i x)
    (sy : slotsOf i y) (ex : ∀ t, lev t x = alt t) (ey : ∀ t, lev t y = alt' t) :
    StandsLate (slotsOf i) lev :=
  fun N => match ReadingsPersist.Habitat.alt_or N with
  | .inl p => ⟨N, x, Nat.le_refl N, sx, Nat.lt_of_lt_of_le p (Nat.le_of_eq (ex N).symm)⟩
  | .inr p => ⟨N, y, Nat.le_refl N, sy, Nat.lt_of_lt_of_le p (Nat.le_of_eq (ey N).symm)⟩

/-- From the second step on the cleared course's population alternates between two cohorts. -/
theorem cleared_family_late : ∀ t, (pop false .source cleared).family (t + 2) = [.n3, .n0, .w0] ∨
    (pop false .source cleared).family (t + 2) = [.n1, .n2, .w1]
  | 0 => .inl rfl
  | 1 => .inr rfl
  | t + 2 => (cleared_shift t) ▸ cleared_family_late t

/-- **Cleared, nothing coming back: the narrow reading spreads and keeps its share.** Where the focal
line reads its line and its source and nothing comes back from the dweller, the narrow count among the
population is one of three at the start, two of four after the first step and two of three at every
step from the second on. Across the first two steps it rises by selection proper (discordance none,
concordance positive), nothing is
revised, and at the next two steps selection proper is none. The dweller's line is removed; the focal
and the wide lines persist. (Which members leave how many kids is computed in the proof, as the acts
give; the statement gives the counts and the selection terms.) -/
theorem cleared_spreads :
    ((narrow false .source cleared).sum 0 = 1 ∧ (pop false .source cleared).size 0 = 3) ∧
    ((narrow false .source cleared).sum 1 = 2 ∧ (pop false .source cleared).size 1 = 4) ∧
    (∀ t, (narrow false .source cleared).sum (t + 2) = 2 ∧ (pop false .source cleared).size (t + 2) = 3) ∧
    ((narrow false .source cleared).discordAt 0 = 0 ∧ 0 < (narrow false .source cleared).concordAt 0) ∧
    ((narrow false .source cleared).discordAt 1 = 0 ∧ 0 < (narrow false .source cleared).concordAt 1) ∧
    ((narrow false .source cleared).concordAt 2 = 0 ∧ (narrow false .source cleared).discordAt 2 = 0 ∧
      (narrow false .source cleared).concordAt 3 = 0 ∧ (narrow false .source cleared).discordAt 3 = 0) ∧
    (∀ t, (pop false .source cleared).revisedIn (readOf .source) isNarrow t = 0 ∧
      (pop false .source cleared).revisedOut (readOf .source) isNarrow t = 0) ∧
    RemovesLine slotsOf cleared .dweller ∧ StandsLate (slotsOf .focal) cleared ∧
      StandsLate (slotsOf .wide) cleared :=
  have late : ∀ t, (narrow false .source cleared).sum (t + 2) = 2 ∧
      (pop false .source cleared).size (t + 2) = 3 := fun t => by
    have sumF : (narrow false .source cleared).sum (t + 2) =
        total ((pop false .source cleared).family (t + 2))
          (fun x => bif isNarrow (readOf .source x) then 1 else 0) :=
      congrArg (fun F => total F fun x => bif isNarrow (readOf .source x) then 1 else 0)
        (SelectionTerm.Generations.carrying_family (t + 2))
    cases cleared_family_late t with
    | inl e => exact ⟨sumF.trans (e ▸ rfl), (congrArg List.length e).trans rfl⟩
    | inr e => exact ⟨sumF.trans (e ▸ rfl), (congrArg List.length e).trans rfl⟩
  ⟨⟨rfl, rfl⟩, ⟨rfl, rfl⟩, late, ⟨rfl, by decide⟩, ⟨rfl, by decide⟩, ⟨rfl, rfl, rfl, rfl⟩,
   fun t => SelectionTerm.Generations.revised_none_of_inherits
     (fun t p k _ kid => (inherits false .source cleared) t k p ((Flow.mem_lineOf_kids.mp kid).2)) t,
   removes_of_gone (x₀ := .d0) rfl (by decide) (T := 2) (fun t x le sx => by
     cases x <;> first
       | exact Bool.noConfusion sx
       | exact (ReadingsPersist.Habitat.late_zero t le).1
       | exact (ReadingsPersist.Habitat.late_zero t le).2),
   standsLate_alt (x := .n0) (y := .n2) rfl rfl (fun _ => rfl) (fun _ => rfl),
   standsLate_alt (x := .w0) (y := .w1) rfl rfl (fun _ => rfl) (fun _ => rfl)⟩

/-- **Kept, either world: every line persists.** -/
theorem keep_persists :
    StandsLate (slotsOf .focal) keep ∧ StandsLate (slotsOf .wide) keep ∧
      StandsLate (slotsOf .dweller) keep :=
  ⟨standsLate_alt (x := .n0) (y := .n2) rfl rfl (fun _ => rfl) (fun _ => rfl),
   standsLate_alt (x := .w0) (y := .w1) rfl rfl (fun _ => rfl) (fun _ => rfl),
   standsLate_alt (x := .d0) (y := .d1) rfl rfl (fun _ => rfl) (fun _ => rfl)⟩

/-- **Cleared where the dweller renews the source: the narrow reading spreads, then every line ends.**
The narrow count is one of three, two of four and two of three over the first three steps, rising by
selection proper across the first two as where nothing comes back; then the source, no longer renewed,
falls below the focal line's need (by the course: three at the third step, the focal need five), the focal line is removed from the third step (the count is none of
one at the third, fourth and fifth), the wide line from the sixth, and the population is empty from
the sixth on. -/
theorem clearedBack_ends :
    ((narrow true .source clearedBack).sum 0 = 1 ∧ (pop true .source clearedBack).size 0 = 3) ∧
    ((narrow true .source clearedBack).sum 1 = 2 ∧ (pop true .source clearedBack).size 1 = 4) ∧
    ((narrow true .source clearedBack).sum 2 = 2 ∧ (pop true .source clearedBack).size 2 = 3) ∧
    ((narrow true .source clearedBack).sum 3 = 0 ∧ (pop true .source clearedBack).size 3 = 1) ∧
    ((narrow true .source clearedBack).sum 4 = 0 ∧ (pop true .source clearedBack).size 4 = 1) ∧
    ((narrow true .source clearedBack).sum 5 = 0 ∧ (pop true .source clearedBack).size 5 = 1) ∧
    (∀ k, (pop true .source clearedBack).family (6 + k) = []) ∧
    ((narrow true .source clearedBack).discordAt 0 = 0 ∧ 0 < (narrow true .source clearedBack).concordAt 0) ∧
    ((narrow true .source clearedBack).discordAt 1 = 0 ∧ 0 < (narrow true .source clearedBack).concordAt 1) ∧
    RemovesLine slotsOf clearedBack .dweller ∧ RemovesLine slotsOf clearedBack .focal ∧
      RemovesLine slotsOf clearedBack .wide :=
  ⟨⟨rfl, rfl⟩, ⟨rfl, rfl⟩, ⟨rfl, rfl⟩, ⟨rfl, rfl⟩, ⟨rfl, rfl⟩, ⟨rfl, rfl⟩,
   SelectionTerm.Generations.family_nil_from (T := 6) rfl,
   ⟨rfl, by decide⟩, ⟨rfl, by decide⟩,
   removes_of_gone (x₀ := .d0) rfl (by decide) (T := 2) (fun t x le sx => by
     cases x <;> first
       | exact Bool.noConfusion sx
       | exact profile_late _ t (Nat.le_trans (by decide) le)),
   removes_of_gone (x₀ := .n0) rfl (by decide) (T := 3) (fun t x le sx => by
     cases x <;> first
       | exact Bool.noConfusion sx
       | exact profile_late _ t (Nat.le_trans (by decide) le)),
   removes_of_gone (x₀ := .w0) rfl (by decide) (T := 6) (fun t x le sx => by
     cases x <;> first
       | exact Bool.noConfusion sx
       | exact profile_late _ t (Nat.le_trans (by decide) le))⟩

/-- From the third step on the overdrawn course's population is the wide line's one member. -/
theorem overdrawn_family_late : ∀ t, (pop false .own overdrawn).family (t + 3) = [.w1] ∨
    (pop false .own overdrawn).family (t + 3) = [.w0]
  | 0 => .inl rfl
  | 1 => .inr rfl
  | t + 2 => (overdrawn_shift t) ▸ overdrawn_family_late t

/-- **Overdrawn, nothing coming back: the narrow reading spreads while its source lasts, then ends.**
Where the focal line reads its own line only, it takes the habitat and draws two from the source per
member: the narrow count is one of three, two of four and two of three over the first three steps,
selection proper positive across the first two; at the third step the source stands below the focal
line's need (by the course: the source at three, the focal need five), and from then on the population
is the wide line's one member, none of it narrow. The focal and the dweller's lines
are removed; the wide line persists on the renewing source. -/
theorem overdrawn_spreads_then_ends :
    ((narrow false .own overdrawn).sum 0 = 1 ∧ (pop false .own overdrawn).size 0 = 3) ∧
    ((narrow false .own overdrawn).sum 1 = 2 ∧ (pop false .own overdrawn).size 1 = 4) ∧
    ((narrow false .own overdrawn).sum 2 = 2 ∧ (pop false .own overdrawn).size 2 = 3) ∧
    (∀ t, (narrow false .own overdrawn).sum (t + 3) = 0 ∧ (pop false .own overdrawn).size (t + 3) = 1) ∧
    ((narrow false .own overdrawn).discordAt 0 = 0 ∧ 0 < (narrow false .own overdrawn).concordAt 0) ∧
    ((narrow false .own overdrawn).discordAt 1 = 0 ∧ 0 < (narrow false .own overdrawn).concordAt 1) ∧
    RemovesLine slotsOf overdrawn .focal ∧ RemovesLine slotsOf overdrawn .dweller ∧
      StandsLate (slotsOf .wide) overdrawn :=
  ⟨⟨rfl, rfl⟩, ⟨rfl, rfl⟩, ⟨rfl, rfl⟩,
   fun t => match overdrawn_family_late t with
     | .inl e => ⟨(narrow_sum false .own overdrawn (t + 3)).trans (e ▸ rfl),
         (congrArg List.length e).trans rfl⟩
     | .inr e => ⟨(narrow_sum false .own overdrawn (t + 3)).trans (e ▸ rfl),
         (congrArg List.length e).trans rfl⟩,
   ⟨rfl, by decide⟩, ⟨rfl, by decide⟩,
   removes_of_gone (x₀ := .n0) rfl (by decide) (T := 3) (fun t x le sx => by
     cases x <;> first
       | exact Bool.noConfusion sx
       | exact profile_late _ t (Nat.le_trans (by decide) le)),
   removes_of_gone (x₀ := .d0) rfl (by decide) (T := 2) (fun t x le sx => by
     cases x <;> first
       | exact Bool.noConfusion sx
       | exact profile_late _ t (Nat.le_trans (by decide) le)),
   standsLate_alt (x := .w0) (y := .w1) rfl rfl (fun _ => rfl) (fun _ => rfl)⟩

/-- **Overdrawn where the dweller renews the source: every line is removed by the third step.** The
narrow count is one of three, two of four and two of three over the first three steps, selection proper
positive across the first two; the source is then empty, and the population is empty from the third step
on; the dweller's line is removed from the second step, the focal and wide lines from the third. -/
theorem overdrawnBack_ends :
    ((narrow true .own overdrawnBack).sum 0 = 1 ∧ (pop true .own overdrawnBack).size 0 = 3) ∧
    ((narrow true .own overdrawnBack).sum 1 = 2 ∧ (pop true .own overdrawnBack).size 1 = 4) ∧
    ((narrow true .own overdrawnBack).sum 2 = 2 ∧ (pop true .own overdrawnBack).size 2 = 3) ∧
    (∀ k, (pop true .own overdrawnBack).family (3 + k) = []) ∧
    ((narrow true .own overdrawnBack).discordAt 0 = 0 ∧ 0 < (narrow true .own overdrawnBack).concordAt 0) ∧
    ((narrow true .own overdrawnBack).discordAt 1 = 0 ∧ 0 < (narrow true .own overdrawnBack).concordAt 1) ∧
    RemovesLine slotsOf overdrawnBack .focal ∧ RemovesLine slotsOf overdrawnBack .wide ∧
      RemovesLine slotsOf overdrawnBack .dweller :=
  ⟨⟨rfl, rfl⟩, ⟨rfl, rfl⟩, ⟨rfl, rfl⟩,
   SelectionTerm.Generations.family_nil_from (T := 3) rfl,
   ⟨rfl, by decide⟩, ⟨rfl, by decide⟩,
   removes_of_gone (x₀ := .n0) rfl (by decide) (T := 3) (fun t x le sx => by
     cases x <;> first
       | exact Bool.noConfusion sx
       | exact profile_late _ t (Nat.le_trans (by decide) le)),
   removes_of_gone (x₀ := .w0) rfl (by decide) (T := 3) (fun t x le sx => by
     cases x <;> first
       | exact Bool.noConfusion sx
       | exact profile_late _ t (Nat.le_trans (by decide) le)),
   removes_of_gone (x₀ := .d0) rfl (by decide) (T := 2) (fun t x le sx => by
     cases x <;> first
       | exact Bool.noConfusion sx
       | exact profile_late _ t (Nat.le_trans (by decide) le))⟩

end ReadingsSpread.Commons

end Becoming
