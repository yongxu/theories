import Becoming.Population
import Becoming.Witnesses
import Becoming.Grammar

/-!
# Identity across steps

A web names its formations by a fixed index type, so which formation at one step is the
same as which at the next is stipulated by the names. The relations at each step do not
fix it. A *re-identification* (`Reidentify`) relates two namings one to one at each
step. The re-identified web (`Web.reidentify`) has, at every step, the same levels,
activity, dependences and drawing; it differs only in which formation of one step
continues which of the step before. A *renaming* is a re-identification that is the same
at every step. Splits and merges, in which one formation continues as several or several
as one, are not re-identifications: they change the continuation relation, not the
number of formations at any step. A *continuation* (`Web.Continues`) reads them.

Results:
* Labels carry nothing. A renaming preserves the readings, defined from the relations,
  that follow a formation through the run (checked for five): the class of a formation
  (renewing or consuming in the run), the tenure of a dependence (`MetAbove`),
  undermining, forming and dissolving, arising and unceasing generation. A renaming keeps
  the pattern of names across steps, so it cannot show that this pattern carries nothing.
* What each step and each condition is does not depend on identity across steps. Every
  re-identification preserves support, keeping and breaking, the class of every
  condition (renewed, consumed, lost), whether activity needs support (`Dependent`),
  and, at each event, being within renewal and breaking. Consumption reads a dependence
  as it stood when it held, against the condition's later levels; it does not follow the
  formation. Re-identifying a flow preserves what is taken and given at each step, the
  balance of depletion and replenishment, and how many formations take and give, so
  whether generation is more without end (`More`). A census of the active formations and
  `Taking` carry over too, so under them more without end makes generation unceasing
  under every re-identification (`More.unceasing_reidentified`), as in the expansion
  (`Expansion.unceasing_reidentified`): under one-to-one readings of identity, the arising
  it forces is not an artefact of naming.
* What a formation is across steps depends on it (`Turnover`). Exchanging names at
  every odd step, with every step's relations unchanged:
  - a formation renewing in the run and one consuming become a web in which no
    formation renews and two consume;
  - a drawer that undermines at every step, because the formation whose need it broke
    still needs the condition, gives way to a web in which no event after the first
    step undermines: each formation needing the condition now has a tenure of one
    step, and its need was never met in it;
  - a web in which no dependence forms or dissolves and nothing arises becomes one in
    which a formation transforms its dependence across a step and formations arise at
    every odd step, so that generation is unceasing.
  The pattern of names across steps carries identity. The representation supplies it as
  a correspondence premise, and `Turnover` shows that the premise is substantive.
  Arisings made by naming alone can meet every premise of
  `Unceasing.activeRenewer_recurs`: `Depletes` is not tied to the arising formation and
  does not screen them out (`TideFlip`).
* Continuity, read one way. A re-identification that keeps the name of every formation
  active before and after a step (`KeepsActive`) makes no arising: what arises under the
  new names arose under the old, so it makes no unceasing generation. One that keeps the
  name of every formation whose dependence on a condition continues across a step
  (`KeepsTenure`) keeps a formation's name over a tenure, keeps every dependence met
  while it held, and removes no undermining. Both conditions are read against the old
  naming: the new naming may join formations the old keeps apart, making a continuity,
  and never removes one. Joining a formation that ends with one that begins at that step
  or later is succession, and it can hide arising and add undermining:
  - two members of a lineage active at alternate steps arise without end when named
    apart, and named as one the lineage is always active and nothing arises
    (`Lineage`);
  - a successor that lives, is supported at its first step, and then needs more of the pool
    than it holds was never met above the pool's later level while its own dependence
    held: drawing after the predecessor's loss undermines nothing when the two are named
    apart, and undermines at every step from the third when the successor succeeds the predecessor
    (`Succession`).
  In each witness the joined naming keeps every continuing activity and dependence of
  the apart naming; the apart naming does not keep the joined naming's
  (`Lineage.one_way`, `Succession.one_way`).
* Continuity, read both ways. When the old naming, read back from the new
  (`Reidentify.back`), also keeps the new naming's continuing activity, arising and
  unceasing generation are preserved exactly; for continuing dependences, undermining
  is preserved exactly. Succession at a single step is then excluded (`no_join`).
  Continuity still
  does not constrain the class of a formation over the run: joining across steps at
  which neither formation is active or depends on anything, as in dormancy, keeps
  continuity both ways and changes which formation renews and which consumes
  (`Dormancy`).
* Splits. Under a census, with each formation taking part listed once and only active
  formations taking, more without end makes formations arise at arbitrarily late steps
  under every continuation in which no formation continues as two
  (`Flow.More.unceasingFrom`, `Web.NoSplit`). Every re-identification is such a
  continuation, and so is one with merges (`Merge`); the decidability the theorem asks
  follows from the census and a decidable continuation (`Census.decideContinues`). On the
  expansion, whose formations never end, that merge comes with a persisting formation
  re-read as arising at every step, so the conclusion holds there without `More`
  (`Merge.idle`); where the merged formation ends, what arises under a merge is exactly
  what is new (`Confluence`).
  Without a census, no split is not enough (`Dormant.no_split_without_arising`). No
  split is sufficient, not necessary: a single split leaves formations arising without
  end (`Fork`), while under a continuation in which new formations bud from one already
  there the same growth forces no arising after the first step (`Budding`). What
  survives every reading is the count, ever more formations active.
* Across one step, exactly. Whatever formations are listed before and after a step, more
  forces arising under a continuation exactly when no formation continues as two
  (`forces_iff_noSplit`); and under every continuation without splits, arising is forced
  exactly when more formations are listed after the step than before (`forced_iff_more`):
  with no more, pairing the formations in order continues every one without a split
  (`paired`). A split at one step leaves formations arising at the others (`Fork`).
* The census balance under a continuation. Under a continuation, a formation ceases
  across a step when it is active before it and continued by no formation active after
  it (`CeasesFrom`); a merge is one formation after the step continuing two before it,
  and `NoMerge` excludes it. Under a census, across each step: without splits, the
  formations active after the step with those ceasing under the continuation are at most
  those active before with those arising under it; without merges, at least; with
  neither, the balance is exact (`Census.balanceFrom`, `Census.balanceFrom_eq`). Each
  formation continuing only itself splits none and merges none (`self_one_to_one`), and
  there the balance is `Listed.across`. So each half of the census law holds under every
  continuation meeting its condition: without splits, ceasing at arbitrarily late steps
  needs arising at arbitrarily late steps (`Census.arisingFrom_of_ceasingFrom`); without
  merges, with at most `B` formations active from some step on, arising at arbitrarily
  late steps needs ceasing at arbitrarily late steps
  (`Census.ceasingFrom_of_arisingFrom`). Each condition is needed. In one web, two
  formations are active at each step; read with each continuing only itself, one arises
  and one ceases across every step; read as budding, ceasing recurs and nothing arises;
  read as joining, arising recurs with at most two active and nothing ceases (`Tandem`).
* Part and whole. A lineage and its members are two levels of one unfolding. Named as a
  formation beside its members, the lineage is active at every step while its members
  arise without end (`Layered`). A web has no relation saying that the lineage is
  constituted by its members; that relation is what a single level of naming omits.

So identity across steps is substantive exactly where a reading follows a formation or
one of its dependences through time: the class of a formation over the run, the tenure
of a dependence, hence undermining and the working stepwise reading of `living`,
transformation as against an ending and another forming, and arising, hence `Unceasing`.
Continuity of activity and dependence, read one way, rules out making arising and
removing undermining and leaves succession open; read both ways it fixes both, and it
still leaves the class of a formation open across dormancy. Whether a lineage is one
formation continuing, many generated, or both at two levels, and whether a successor
inherits a loss, are further readings. Where generation is more without end under a
census, with each formation taking part listed once and only active formations taking,
it is unceasing under every one-to-one reading of identity, and formations arise without
end under every continuation without splits. Ceasing at arbitrarily late steps needs
arising at arbitrarily late steps under every continuation without splits, and under a
bounded census the converse holds under every continuation without merges; a reading
that splits or merges can remove the arising or the ceasing these laws force. The
representation supplies identity through the index type; for an application it is a
correspondence claim. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

variable {F F' C : Type}

/-- Two namings of formations related one to one at each step: at step `t`, the
formation named `x` is the one named `old t x` before, and `new t f` names `f`. -/
structure Reidentify (F F' : Type) where
  old : Nat → F' → F
  new : Nat → F → F'
  old_new : ∀ t f, old t (new t f) = f
  new_old : ∀ t x, new t (old t x) = x

/-- A renaming: the same correspondence at every step. -/
def Reidentify.rename (old : F' → F) (new : F → F') (old_new : ∀ f, old (new f) = f)
    (new_old : ∀ x, new (old x) = x) : Reidentify F F' :=
  ⟨fun _ => old, fun _ => new, fun _ => old_new, fun _ => new_old⟩

/-- What holds of every formation as named at a step holds of every formation. -/
theorem Reidentify.every (σ : Reidentify F F') (t : Nat) {p : F → Prop}
    (named : ∀ x, p (σ.old t x)) : ∀ f, p f :=
  fun f => σ.old_new t f ▸ named (σ.new t f)

/-- At each step, the new names name distinct formations distinctly. -/
theorem Reidentify.new_injective (σ : Reidentify F F') (t : Nat) :
    ∀ f g, σ.new t f = σ.new t g → f = g :=
  fun f g same => (σ.old_new t f).symm.trans ((congrArg (σ.old t) same).trans (σ.old_new t g))

/-- What holds of some formation holds of one as named at a step. -/
theorem Reidentify.some (σ : Reidentify F F') (t : Nat) {p : F → Prop} :
    (∃ f, p f) → ∃ x, p (σ.old t x)
  | ⟨f, holds⟩ => ⟨σ.new t f, (σ.old_new t f).symm ▸ holds⟩

/-- The same correspondence read from the new naming back to the old. -/
def Reidentify.back (σ : Reidentify F F') : Reidentify F' F :=
  ⟨σ.new, σ.old, σ.new_old, σ.old_new⟩

namespace Web

/-- The same web with its formations re-identified across steps: every step's levels,
activity, dependences and drawing are unchanged. -/
def reidentify (W : Web F C) (σ : Reidentify F F') : Web F' C where
  level := W.level
  active t x := W.active t (σ.old t x)
  requires t x := W.requires t (σ.old t x)
  need t x := W.need t (σ.old t x)
  draws t x := W.draws t (σ.old t x)

variable (W : Web F C) (σ : Reidentify F F')

/-! ## What each step and each condition is -/

/-- Each step's relations are unchanged: support, keeping and breaking. -/
theorem reidentify_step (t : Nat) (x : F') (c : C) :
    ((W.reidentify σ).Supported t x ↔ W.Supported t (σ.old t x)) ∧
    ((W.reidentify σ).Kept t x c ↔ W.Kept t (σ.old t x) c) ∧
    ((W.reidentify σ).Broken t x c ↔ W.Broken t (σ.old t x) c) :=
  ⟨.rfl, .rfl, .rfl⟩

theorem reidentify_renewed (c : C) : (W.reidentify σ).Renewed c ↔ W.Renewed c :=
  ⟨fun renewed t => σ.every t (p := fun g => W.requires t g c → W.Kept t g c) (renewed t),
   fun renewed t x => renewed t (σ.old t x)⟩

theorem reidentify_consumed (c : C) : (W.reidentify σ).Consumed c ↔ W.Consumed c :=
  ⟨fun ⟨x, T, unmet⟩ => ⟨σ.old T x, T, unmet⟩,
   fun ⟨g, T, unmet⟩ => match σ.some T (p := fun g =>
      W.requires T g c ∧ ∀ t, T < t → W.level t c < W.need T g c) ⟨g, unmet⟩ with
    | ⟨x, unmet⟩ => ⟨x, T, unmet⟩⟩

theorem reidentify_lost (c : C) : (W.reidentify σ).Lost c ↔ W.Lost c :=
  ⟨fun ⟨x, T, lost⟩ => ⟨σ.old T x, T, lost⟩,
   fun ⟨g, T, lost⟩ => match σ.some T (p := fun g =>
      W.Broken T g c ∧ ∀ t, T < t → W.level t c < W.need T g c) ⟨g, lost⟩ with
    | ⟨x, lost⟩ => ⟨x, T, lost⟩⟩

theorem reidentify_dependent : (W.reidentify σ).Dependent ↔ W.Dependent :=
  ⟨fun dependent t => σ.every t (p := fun f => W.active t f → W.Supported t f) (dependent t),
   fun dependent t x => dependent t (σ.old t x)⟩

/-- At each event, being within renewal is unchanged. -/
theorem reidentify_renewingAt (t : Nat) (x : F') :
    (W.reidentify σ).RenewingAt t x ↔ W.RenewingAt t (σ.old t x) :=
  ⟨fun ⟨active, keeps⟩ => ⟨active, fun c joins =>
    σ.every t (p := fun g => W.requires t g c → W.Kept t g c) (keeps c joins)⟩,
   fun ⟨active, keeps⟩ => ⟨active, fun c joins y depends => keeps c joins (σ.old t y) depends⟩⟩

/-- At each event, breaking is unchanged. -/
theorem reidentify_breakingOn (t : Nat) (x : F') (c : C) :
    (W.reidentify σ).BreakingOn t x c ↔ W.BreakingOn t (σ.old t x) c :=
  ⟨fun ⟨drawn, y, broken⟩ => ⟨drawn, σ.old t y, broken⟩,
   fun ⟨drawn, broken⟩ => ⟨drawn, σ.some t (p := fun g => W.Broken t g c) broken⟩⟩

/-! ## Labels carry nothing -/

section Renaming

variable (old : F' → F) (new : F → F') (old_new : ∀ f, old (new f) = f)
  (new_old : ∀ x, new (old x) = x)

theorem rename_renewingIn (x : F') :
    (W.reidentify (.rename old new old_new new_old)).RenewingIn x ↔ W.RenewingIn (old x) :=
  ⟨fun renewing t c joins => (W.reidentify_renewed _ c).mp (renewing t c joins),
   fun renewing t c joins => (W.reidentify_renewed _ c).mpr (renewing t c joins)⟩

theorem rename_consumingIn (x : F') :
    (W.reidentify (.rename old new old_new new_old)).ConsumingIn x ↔ W.ConsumingIn (old x) :=
  ⟨fun ⟨t, c, drawn, consumed⟩ => ⟨t, c, drawn, (W.reidentify_consumed _ c).mp consumed⟩,
   fun ⟨t, c, drawn, consumed⟩ => ⟨t, c, drawn, (W.reidentify_consumed _ c).mpr consumed⟩⟩

/-- A renaming keeps every tenure, forming and dissolving, and arising. -/
theorem rename_tenure (t : Nat) (x : F') (c : C) (m : Nat) :
    ((W.reidentify (.rename old new old_new new_old)).MetAbove t x c m ↔
      W.MetAbove t (old x) c m) ∧
    ((W.reidentify (.rename old new old_new new_old)).Forms t x c ↔ W.Forms t (old x) c) ∧
    ((W.reidentify (.rename old new old_new new_old)).Dissolves t x c ↔
      W.Dissolves t (old x) c) ∧
    ((W.reidentify (.rename old new old_new new_old)).Arises t x ↔ W.Arises t (old x)) :=
  ⟨.rfl, .rfl, .rfl, .rfl⟩

theorem rename_undermining (t : Nat) (x : F') :
    (W.reidentify (.rename old new old_new new_old)).UnderminingAt t x ↔
      W.UnderminingAt t (old x) :=
  ⟨fun ⟨c, drawn, y, depends, met, fell⟩ => ⟨c, drawn, old y, depends, met, fell⟩,
   fun ⟨c, drawn, undermined⟩ => ⟨c, drawn, (Reidentify.rename old new old_new new_old).some t
    (p := fun g => W.requires t g c ∧ W.MetAbove t g c (W.level (t + 1) c) ∧
      W.level (t + 1) c < W.need t g c)
    undermined⟩⟩

theorem rename_unceasing :
    (W.reidentify (.rename old new old_new new_old)).Unceasing ↔ W.Unceasing :=
  ⟨fun unceasing N => match unceasing N with
    | ⟨t, x, later, arises⟩ => ⟨t, old x, later, arises⟩,
   fun unceasing N => match unceasing N with
    | ⟨t, f, later, arises⟩ =>
      match (Reidentify.rename old new old_new new_old).some t (p := W.Arises t) ⟨f, arises⟩ with
      | ⟨x, arises⟩ => ⟨t, x, later, arises⟩⟩

end Renaming

end Web

/-! ## Flows and censuses -/

/-- What is listed under the new names at a step is what is listed under the old. -/
theorem Reidentify.mem_map (σ : Reidentify F F') (t : Nat) {l : List F} {x : F'} :
    x ∈ l.map (σ.new t) ↔ σ.old t x ∈ l :=
  ⟨fun mem => mem_of_map (σ.new_injective t)
    (Eq.subst (motive := fun y => y ∈ l.map (σ.new t)) (σ.new_old t x).symm mem),
   fun mem => Eq.subst (motive := fun y => y ∈ l.map (σ.new t)) (σ.new_old t x)
    (mem_map_of mem)⟩

/-- A census of the active formations lists them under any re-identification. -/
theorem Web.Census.reidentify {W : Web F C} {alive : Nat → List F} (census : W.Census alive)
    (σ : Reidentify F F') : (W.reidentify σ).Census fun t => (alive t).map (σ.new t) :=
  fun t => ⟨distinct_map (σ.new_injective t) (census t).1, fun x =>
    ((census t).2 (σ.old t x)).trans (σ.mem_map t).symm⟩

/-- A total over the renamed list is the total over the list. -/
theorem total_reidentify (σ : Reidentify F F') (t : Nat) (q : F → Nat) :
    ∀ fs : List F, total (fs.map (σ.new t)) (fun x => q (σ.old t x)) = total fs q
  | [] => rfl
  | f :: fs => congr (congrArg (· + ·) (congrArg q (σ.old_new t f))) (total_reidentify σ t q fs)

namespace Flow

/-- The same flow with its formations re-identified across steps. -/
def reidentify (L : Flow F C) (σ : Reidentify F F') : Flow F' C where
  present t := (L.present t).map (σ.new t)
  take t x := L.take t (σ.old t x)
  give t x := L.give t (σ.old t x)

variable (L : Flow F C) (σ : Reidentify F F')

/-- What is taken from and given to each condition at each step is unchanged. -/
theorem reidentify_amounts (t : Nat) (c : C) :
    (L.reidentify σ).taken t c = L.taken t c ∧ (L.reidentify σ).given t c = L.given t c :=
  ⟨total_reidentify σ t (fun f => L.take t f c) (L.present t),
   total_reidentify σ t (fun f => L.give t f c) (L.present t)⟩

theorem reidentify_balances (W : Web F C) :
    (L.reidentify σ).Balances (W.reidentify σ) ↔ L.Balances W :=
  ⟨fun balances t c =>
    (L.reidentify_amounts σ t c).1 ▸ (L.reidentify_amounts σ t c).2 ▸ balances t c,
   fun balances t c =>
    (L.reidentify_amounts σ t c).1.symm ▸ (L.reidentify_amounts σ t c).2.symm ▸ balances t c⟩

/-- How many formations take and give at each step is unchanged. -/
theorem reidentify_counts (cs : List C) (t : Nat) :
    (L.reidentify σ).takers cs t = L.takers cs t ∧
      (L.reidentify σ).renewers cs t = L.renewers cs t :=
  ⟨total_reidentify σ t (fun f => sign (total cs (L.take t f))) (L.present t),
   total_reidentify σ t (fun f => sign (total cs (L.give t f))) (L.present t)⟩

/-- Only active formations take, from what they draw on, under any re-identification. -/
theorem Taking.reidentify {L : Flow F C} {W : Web F C} (taking : L.Taking W)
    (σ : Reidentify F F') : (L.reidentify σ).Taking (W.reidentify σ) :=
  fun t x c mem positive => taking t (σ.old t x) c ((σ.mem_map t).mp mem) positive

theorem reidentify_more (cs : List C) : (L.reidentify σ).More cs ↔ L.More cs :=
  ⟨fun more K => match more K with
    | ⟨T, many⟩ => ⟨T, fun t later => (L.reidentify_counts σ cs t).1 ▸ many t later⟩,
   fun more K => match more K with
    | ⟨T, many⟩ => ⟨T, fun t later => (L.reidentify_counts σ cs t).1.symm ▸ many t later⟩⟩

end Flow

/-- More without end leaves no step from which nothing arises under any re-identification,
with no census and no decision: where lists cover the active formations at arbitrarily late
steps, and from some step on each formation taking part is listed once and whatever takes is
active. -/
theorem Flow.More.arising_never_stops_reidentified_covering {W : Web F C} {L : Flow F C}
    {cs : List C} {S : Nat} (covered : ∀ N, ∃ M, ∃ l : List F, N ≤ M ∧ ∀ f, W.active M f → f ∈ l)
    (distinct : ∀ t, S ≤ t → Distinct (L.present t))
    (taking : ∀ t f c, S ≤ t → f ∈ L.present t → 0 < L.take t f c → W.active t f)
    (more : L.More cs) (σ : Reidentify F F') : ¬ ∃ N, ∀ t x, N ≤ t → ¬ (W.reidentify σ).Arises t x :=
  Flow.More.arising_never_stops_covering (L := L.reidentify σ) (S := S)
    (fun N => match covered N with
      | ⟨M, l, later, covers⟩ => ⟨M, l.map (σ.new M), later,
          fun x active => (σ.mem_map M).mpr (covers (σ.old M x) active)⟩)
    (fun t from_ => distinct_map (σ.new_injective t) (distinct t from_))
    (fun t x c from_ mem takes => taking t (σ.old t x) c from_ ((σ.mem_map t).mp mem) takes)
    ((L.reidentify_more σ cs).mpr more)

/-- More without end makes generation unceasing under every re-identification, with no
census, where activity is decided from some step on. -/
theorem Flow.More.unceasing_reidentified_covering {W : Web F C} {L : Flow F C} {cs : List C}
    {S : Nat} (decided : ∀ s f, S ≤ s → Decidable (W.active s f))
    (covered : ∀ N, ∃ M, ∃ l : List F, N ≤ M ∧ ∀ f, W.active M f → f ∈ l)
    (distinct : ∀ t, S ≤ t → Distinct (L.present t))
    (taking : ∀ t f c, S ≤ t → f ∈ L.present t → 0 < L.take t f c → W.active t f)
    (more : L.More cs) (σ : Reidentify F F') : (W.reidentify σ).Unceasing :=
  Flow.More.unceasing_covering (L := L.reidentify σ) (S := S)
    (fun s x within => decided s (σ.old s x) within)
    (fun N => match covered N with
      | ⟨M, l, later, covers⟩ => ⟨M, l.map (σ.new M), later,
          fun x active => (σ.mem_map M).mpr (covers (σ.old M x) active)⟩)
    (fun t from_ => distinct_map (σ.new_injective t) (distinct t from_))
    (fun t x c from_ mem takes => taking t (σ.old t x) c from_ ((σ.mem_map t).mp mem) takes)
    ((L.reidentify_more σ cs).mpr more)

/-- Under a census, with each formation taking part listed once and only active formations
taking, more without end makes generation unceasing under every re-identification. -/
theorem Flow.More.unceasing_reidentified {W : Web F C} [decide : ∀ t f, Decidable (W.active t f)]
    {L : Flow F C} {cs : List C} {alive : Nat → List F} (census : W.Census alive)
    (distinct : ∀ t, Distinct (L.present t)) (taking : L.Taking W) (more : L.More cs)
    (σ : Reidentify F F') : (W.reidentify σ).Unceasing :=
  Flow.More.unceasing_reidentified_covering (S := 0) (fun s f _ => decide s f)
    (fun N => ⟨N, alive N, Nat.le_refl N, fun f active => ((census N).2 f).mp active⟩)
    (fun t _ => distinct t) (fun t f c _ mem takes => (taking t f c mem takes).1) more σ

/-! ## Continuity, read one way -/

namespace Reidentify

variable (σ : Reidentify F F') (W : Web F C)

/-- The re-identification keeps the name of every formation active before and after a
step. -/
def KeepsActive : Prop :=
  ∀ t f, W.active t f → W.active (t + 1) f → σ.new (t + 1) f = σ.new t f

/-- The re-identification keeps the name of every formation whose dependence on a
condition holds before and after a step. -/
def KeepsTenure : Prop :=
  ∀ t g c, W.requires t g c → W.requires (t + 1) g c → σ.new (t + 1) g = σ.new t g

variable {σ W}

/-- Keeping continuing dependences, a formation keeps one name over a tenure. -/
theorem steady (keeps : σ.KeepsTenure W) {g : F} {c : C} {s : Nat} :
    ∀ {t}, (∀ u, s ≤ u → u ≤ t → W.requires u g c) →
      ∀ u, s ≤ u → u ≤ t → σ.new u g = σ.new t g
  | 0, _, u, _, le => congrArg (σ.new · g) (Nat.le_antisymm le (Nat.zero_le u))
  | t + 1, held, u, from_, le => match Nat.lt_or_ge u (t + 1) with
    | .inl below =>
      have within : u ≤ t := Nat.le_of_lt_succ below
      (steady keeps (fun v a b => held v a (Nat.le_succ_of_le b)) u from_ within).trans
        (keeps t g c (held t (Nat.le_trans from_ within) (Nat.le_succ t))
          (held (t + 1) (Nat.le_trans from_ (Nat.le_succ_of_le within)) (Nat.le_refl _))).symm
    | .inr above => congrArg (σ.new · g) (Nat.le_antisymm le above)

end Reidentify

namespace Web

variable {W : Web F C} {σ : Reidentify F F'}

/-- Keeping continuing activity, a re-identification makes no arising: what arises under
the new names arose under the old. -/
theorem arises_of_keepsActive (keeps : σ.KeepsActive W) {t : Nat} {x : F'}
    (arises : (W.reidentify σ).Arises t x) : W.Arises t (σ.old (t + 1) x) :=
  ⟨fun active =>
    have named : σ.new t (σ.old (t + 1) x) = x :=
      (keeps t _ active arises.2).symm.trans (σ.new_old (t + 1) x)
    arises.1 (Eq.subst (motive := fun f => W.active t f)
      ((σ.old_new t _).symm.trans (congrArg (σ.old t) named)) active),
   arises.2⟩

theorem unceasing_of_keepsActive (keeps : σ.KeepsActive W)
    (unceasing : (W.reidentify σ).Unceasing) : W.Unceasing :=
  fun N => match unceasing N with
    | ⟨t, _, later, arises⟩ => ⟨t, _, later, arises_of_keepsActive keeps arises⟩

/-- Keeping continuing dependences, a dependence met above `m` while it held is met above
`m` while it held under the new names. -/
theorem metAbove_of_keepsTenure (keeps : σ.KeepsTenure W) {t : Nat} {g : F} {c : C} {m : Nat} :
    W.MetAbove t g c m → (W.reidentify σ).MetAbove t (σ.new t g) c m
  | ⟨s, le, held, met, above⟩ =>
    have same : ∀ u, s ≤ u → u ≤ t → g = σ.old u (σ.new t g) := fun u a b =>
      (σ.old_new u g).symm.trans (congrArg (σ.old u) (Reidentify.steady keeps held u a b))
    ⟨s, le, fun u a b => Eq.subst (motive := fun f => W.requires u f c) (same u a b) (held u a b),
     Eq.subst (motive := fun f => W.need s f c ≤ W.level s c) (same s (Nat.le_refl s) le) met,
     Eq.subst (motive := fun f => m < W.need s f c) (same s (Nat.le_refl s) le) above⟩

/-- Keeping continuing dependences, a re-identification removes no undermining. -/
theorem undermining_of_keepsTenure (keeps : σ.KeepsTenure W) {t : Nat} {f : F} :
    W.UnderminingAt t f → (W.reidentify σ).UnderminingAt t (σ.new t f)
  | ⟨c, drawn, g, depends, met, fell⟩ =>
    ⟨c, Eq.subst (motive := fun f => W.draws t f c) (σ.old_new t f).symm drawn, σ.new t g,
      Eq.subst (motive := fun g => W.requires t g c) (σ.old_new t g).symm depends,
      metAbove_of_keepsTenure keeps met,
      Eq.subst (motive := fun g => W.level (t + 1) c < W.need t g c) (σ.old_new t g).symm fell⟩

end Web

/-! ## Continuity, read both ways -/

namespace Web

variable {W : Web F C} {σ : Reidentify F F'}

/-- If the old names keep the continuing activity of the new naming, every arising under
the old names is an arising under the new. -/
theorem arises_of_back_keepsActive (kept : σ.back.KeepsActive (W.reidentify σ)) {t : Nat}
    {f : F} (arises : W.Arises t f) : (W.reidentify σ).Arises t (σ.new (t + 1) f) :=
  have after : (W.reidentify σ).active (t + 1) (σ.new (t + 1) f) :=
    Eq.subst (motive := fun g => W.active (t + 1) g) (σ.old_new (t + 1) f).symm arises.2
  ⟨fun before =>
    have same : σ.old (t + 1) (σ.new (t + 1) f) = σ.old t (σ.new (t + 1) f) :=
      kept t _ before after
    arises.1 (Eq.subst (motive := fun g => W.active t g)
      (same.symm.trans (σ.old_new (t + 1) f)) before),
   after⟩

/-- Keeping continuing activity in both namings, a re-identification preserves arising
exactly. -/
theorem arises_iff_of_keepsActive_both (keeps : σ.KeepsActive W)
    (kept : σ.back.KeepsActive (W.reidentify σ)) (t : Nat) (x : F') :
    (W.reidentify σ).Arises t x ↔ W.Arises t (σ.old (t + 1) x) :=
  ⟨arises_of_keepsActive keeps,
   fun arises => Eq.subst (motive := fun y => (W.reidentify σ).Arises t y)
     (σ.new_old (t + 1) x) (arises_of_back_keepsActive kept arises)⟩

theorem unceasing_iff_of_keepsActive_both (keeps : σ.KeepsActive W)
    (kept : σ.back.KeepsActive (W.reidentify σ)) :
    (W.reidentify σ).Unceasing ↔ W.Unceasing :=
  ⟨unceasing_of_keepsActive keeps,
   fun unceasing N => match unceasing N with
    | ⟨t, f, later, arises⟩ => ⟨t, σ.new (t + 1) f, later, arises_of_back_keepsActive kept arises⟩⟩

/-- If the old names keep the continuing dependences of the new naming, a dependence met
above `m` while it held under the new names was met above `m` while it held under the
old. -/
theorem metAbove_of_back_keepsTenure (kept : σ.back.KeepsTenure (W.reidentify σ)) {t : Nat}
    {y : F'} {c : C} {m : Nat} :
    (W.reidentify σ).MetAbove t y c m → W.MetAbove t (σ.old t y) c m
  | ⟨s, le, held, met, above⟩ =>
    have same : ∀ u, s ≤ u → u ≤ t → σ.old u y = σ.old t y :=
      Reidentify.steady (σ := σ.back) (W := W.reidentify σ) kept held
    ⟨s, le, fun u a b => Eq.subst (motive := fun g => W.requires u g c) (same u a b) (held u a b),
     Eq.subst (motive := fun g => W.need s g c ≤ W.level s c) (same s (Nat.le_refl s) le) met,
     Eq.subst (motive := fun g => m < W.need s g c) (same s (Nat.le_refl s) le) above⟩

/-- If the old names keep the continuing dependences of the new naming, the
re-identification adds no undermining. -/
theorem undermining_of_back_keepsTenure (kept : σ.back.KeepsTenure (W.reidentify σ))
    {t : Nat} {x : F'} : (W.reidentify σ).UnderminingAt t x → W.UnderminingAt t (σ.old t x)
  | ⟨c, drawn, y, depends, met, fell⟩ =>
    ⟨c, drawn, σ.old t y, depends, metAbove_of_back_keepsTenure kept met, fell⟩

/-- If the old names keep the continuing activity of the new naming, two formations, one
active before a step and one after it, named alike across it are one formation: no join
at a single step. -/
theorem no_join (kept : σ.back.KeepsActive (W.reidentify σ)) {t : Nat} {g h : F}
    (before : W.active t g) (after : W.active (t + 1) h) (named : σ.new t g = σ.new (t + 1) h) :
    g = h :=
  have before' : (W.reidentify σ).active t (σ.new t g) :=
    Eq.subst (motive := fun x => W.active t x) (σ.old_new t g).symm before
  have after' : (W.reidentify σ).active (t + 1) (σ.new t g) :=
    Eq.subst (motive := fun x => (W.reidentify σ).active (t + 1) x) named.symm
      (Eq.subst (motive := fun x => W.active (t + 1) x) (σ.old_new (t + 1) h).symm after)
  (σ.old_new t g).symm.trans ((kept t _ before' after').symm.trans
    ((congrArg (σ.old (t + 1)) named).trans (σ.old_new (t + 1) h)))

/-- Keeping continuing dependences in both namings, a re-identification preserves
undermining exactly. -/
theorem undermining_iff_of_keepsTenure_both (keeps : σ.KeepsTenure W)
    (kept : σ.back.KeepsTenure (W.reidentify σ)) (t : Nat) (x : F') :
    (W.reidentify σ).UnderminingAt t x ↔ W.UnderminingAt t (σ.old t x) :=
  ⟨undermining_of_back_keepsTenure kept,
   fun undermining => Eq.subst (motive := fun y => (W.reidentify σ).UnderminingAt t y)
     (σ.new_old t x) (undermining_of_keepsTenure keeps undermining)⟩

end Web

/-! ## Continuations: splits and merges -/

namespace Web

variable (W : Web F C) (R : Nat → F → F → Prop)

/-- Under the continuation `R`, where `R t g f` reads `f` after the step from `t` as
continuing `g` before it, `f` continues a formation active at `t`. -/
def Continues (t : Nat) (f : F) : Prop :=
  ∃ g, W.active t g ∧ R t g f

/-- Under `R`, `f` arises across the step from `t`: active after it, and continuing no
formation active before it. -/
def ArisesFrom (t : Nat) (f : F) : Prop :=
  W.active (t + 1) f ∧ ¬ W.Continues R t f

/-- Under `R`, formations arise at arbitrarily late steps. -/
def UnceasingFrom : Prop :=
  ∀ N, ∃ t f, N ≤ t ∧ W.ArisesFrom R t f

/-- Under `R`, no formation active before a step continues as two active after it.
Several may continue as one. -/
def NoSplit : Prop :=
  ∀ t g f f', W.active t g → R t g f → R t g f' → W.active (t + 1) f →
    W.active (t + 1) f' → f = f'

/-- With each formation continuing only itself, arising under a continuation is
arising. -/
theorem arisesFrom_self (t : Nat) (f : F) :
    W.ArisesFrom (fun _ g f => g = f) t f ↔ W.Arises t f :=
  ⟨fun ⟨after, alone⟩ => ⟨fun before => alone ⟨f, before, rfl⟩, after⟩,
   fun ⟨before, after⟩ => ⟨after, fun ⟨_, active, same⟩ =>
     before (Eq.subst (motive := fun h => W.active t h) same active)⟩⟩

theorem unceasingFrom_self : W.UnceasingFrom (fun _ g f => g = f) ↔ W.Unceasing :=
  ⟨fun unceasing N => match unceasing N with
    | ⟨t, f, later, arises⟩ => ⟨t, f, later, (W.arisesFrom_self t f).mp arises⟩,
   fun unceasing N => match unceasing N with
    | ⟨t, f, later, arises⟩ => ⟨t, f, later, (W.arisesFrom_self t f).mpr arises⟩⟩

variable {W R}

/-- If more formations are active after a step than before, then under a continuation
without splits one of them arises across it. -/
theorem arisesFrom_of_more (noSplit : W.NoSplit R) {t : Nat}
    [∀ f, Decidable (W.Continues R t f)] {before after : List F}
    (listed : ∀ f, W.active t f → f ∈ before) (distinct : Distinct after)
    (now : ∀ f, f ∈ after → W.active (t + 1) f) (more : before.length < after.length) :
    ∃ f, f ∈ after ∧ W.ArisesFrom R t f :=
  match search (p := W.Continues R t) after with
  | .inl ⟨f, mem, alone⟩ => ⟨f, mem, now f mem, alone⟩
  | .inr all => absurd more (Nat.not_lt_of_ge
      (length_le_of_matched (S := fun f g => W.active t g ∧ R t g f) distinct
        (fun f mem => match all f mem with
          | ⟨g, active, continues⟩ => ⟨g, listed g active, active, continues⟩)
        fun f f' g mem mem' ⟨active, continues⟩ ⟨_, continues'⟩ =>
          noSplit t g f f' active continues continues' (now f mem) (now f' mem')))

/-- A census that grows without bound makes formations arise at arbitrarily late steps
under every continuation without splits. -/
theorem unceasingFrom_of_growth (noSplit : W.NoSplit R)
    [∀ t f, Decidable (W.Continues R t f)] {alive : Nat → List F} (census : W.Census alive)
    (grows : ∀ N K, ∃ t, N ≤ t ∧ K < (alive t).length) : W.UnceasingFrom R :=
  fun N => match grows N (alive N).length with
  | ⟨_, later, larger⟩ => match rises_between (q := fun t => (alive t).length) later larger with
    | ⟨t, from_, _, up⟩ =>
      match arisesFrom_of_more noSplit (fun f a => ((census t).2 f).mp a) ((census (t + 1)).1)
        (fun f mem => ((census (t + 1)).2 f).mpr mem) up with
      | ⟨f, _, arises⟩ => ⟨t, f, from_, arises⟩

end Web

/-- Under a census, with each formation taking part in the flow listed once and only active
formations taking, more without end makes formations arise at arbitrarily late steps under
every continuation in which no formation continues as two. -/
theorem Flow.More.unceasingFrom {W : Web F C} {R : Nat → F → F → Prop}
    [∀ t f, Decidable (W.Continues R t f)] {L : Flow F C} {cs : List C}
    {alive : Nat → List F} (census : W.Census alive) (distinct : ∀ t, Distinct (L.present t))
    (taking : L.Taking W) (more : L.More cs) (noSplit : W.NoSplit R) : W.UnceasingFrom R :=
  W.unceasingFrom_of_growth noSplit census (more.grows census distinct taking)

/-- Under a census, whether a formation continues one active before a step is decidable
where the continuation is: the decidability `Flow.More.unceasingFrom` asks for follows. -/
def Web.Census.decideContinues {W : Web F C} {R : Nat → F → F → Prop}
    [∀ t g f, Decidable (R t g f)] {alive : Nat → List F} (census : W.Census alive)
    (t : Nat) (f : F) : Decidable (W.Continues R t f) :=
  have : Decidable (∃ g, g ∈ alive t ∧ R t g f) := decideSome (p := fun g => R t g f) (alive t)
  decidable_of_decidable_of_iff (p := ∃ g, g ∈ alive t ∧ R t g f)
    ⟨fun ⟨g, mem, r⟩ => ⟨g, ((census t).2 g).mpr mem, r⟩,
     fun ⟨g, active, r⟩ => ⟨g, ((census t).2 g).mp active, r⟩⟩

/-- A re-identification read as a continuation: a formation after a step continues the one
before it that bears its name. -/
def Reidentify.continuation (σ : Reidentify F F') (t : Nat) (g f : F) : Prop :=
  σ.new t g = σ.new (t + 1) f

/-- Every re-identification is a continuation without splits, and arising under it is
arising under the new names. -/
theorem Web.continuation_reidentify (W : Web F C) (σ : Reidentify F F') :
    W.NoSplit σ.continuation ∧ ∀ t f,
      (W.ArisesFrom σ.continuation t f ↔ (W.reidentify σ).Arises t (σ.new (t + 1) f)) :=
  ⟨fun t _ f f' _ same same' _ _ => σ.new_injective (t + 1) f f' (same.symm.trans same'),
   fun t f =>
    ⟨fun ⟨after, alone⟩ =>
      ⟨fun before => alone ⟨σ.old t (σ.new (t + 1) f), before, σ.new_old t _⟩,
       Eq.subst (motive := fun g => W.active (t + 1) g) (σ.old_new (t + 1) f).symm after⟩,
     fun ⟨before, after⟩ =>
      ⟨Eq.subst (motive := fun g => W.active (t + 1) g) (σ.old_new (t + 1) f) after,
       fun ⟨g, active, same⟩ => before (Eq.subst (motive := fun h => W.active t h)
         ((σ.old_new t g).symm.trans (congrArg (σ.old t) same)) active)⟩⟩⟩

/-! ## Across one step: what forces arising -/

/-- Across one step, more forces arising under a continuation `S` exactly when no formation
continues as two. If every member of a list without repetition continues one of a shorter
list, some formation continues as two (`length_le_of_matched`); and a formation continuing
as two continues both members of a list longer than the list holding it alone. -/
theorem forces_iff_noSplit [DecidableEq F] {S : F → F → Prop} :
    (∀ before after : List F, Distinct after → before.length < after.length →
      ¬ ∀ f, f ∈ after → ∃ g, g ∈ before ∧ S g f) ↔
    ∀ g f f', S g f → S g f' → f = f' :=
  ⟨fun forces g f f' continues continues' => match decEq f f' with
    | isTrue same => same
    | isFalse other => absurd (fun _ mem => match mem_cons_cases mem with
        | .inl same => ⟨g, .head [], Eq.subst (motive := S g) same.symm continues⟩
        | .inr mem => match mem_cons_cases mem with
          | .inl same => ⟨g, .head [], Eq.subst (motive := S g) same.symm continues'⟩
          | .inr nothing => nomatch nothing)
      (forces [g] [f, f'] ⟨fun mem => (match mem_cons_cases mem with
          | .inl same => other same
          | .inr nothing => nomatch nothing), (fun nothing => nomatch nothing), trivial⟩
        (Nat.lt_succ_self 1)),
   fun noSplit _ _ distinct more covered => Nat.not_lt_of_ge
     (length_le_of_matched (S := fun f g => S g f) distinct covered
       fun f f' g _ _ continues continues' => noSplit g f f' continues continues') more⟩

/-- The members of two lists paired in order: the first of the second list continues the
first of the first, and so on. -/
def paired : List F → List F → F → F → Prop
  | [], _ => fun _ _ => False
  | _ :: _, [] => fun _ _ => False
  | g :: before, f :: after => fun x y => (x = g ∧ y = f) ∨ paired before after x y

theorem paired_mem : ∀ {before after : List F} {x y : F}, paired before after x y → x ∈ before
  | [], _, _, _, nothing => nomatch nothing
  | _ :: _, [], _, _, nothing => nomatch nothing
  | g :: _, _ :: _, _, _, .inl ⟨same, _⟩ =>
    Eq.subst (motive := fun x => x ∈ g :: _) same.symm (.head _)
  | g :: _, _ :: _, _, _, .inr rest => .tail g (paired_mem rest)

/-- Paired in order from a list without repetition, no formation continues as two. -/
theorem paired_noSplit : ∀ {before after : List F}, Distinct before →
    ∀ g f f', paired before after g f → paired before after g f' → f = f'
  | [], _, _, _, _, _, nothing, _ => nomatch nothing
  | _ :: _, [], _, _, _, _, nothing, _ => nomatch nothing
  | _ :: before, _ :: _, ⟨fresh, distinct⟩, g, f, f', continues, continues' =>
    match continues, continues' with
    | .inl ⟨_, same⟩, .inl ⟨_, same'⟩ => same.trans same'.symm
    | .inl ⟨here, _⟩, .inr rest =>
      absurd (Eq.subst (motive := fun x => x ∈ before) here (paired_mem rest)) fresh
    | .inr rest, .inl ⟨here, _⟩ =>
      absurd (Eq.subst (motive := fun x => x ∈ before) here (paired_mem rest)) fresh
    | .inr rest, .inr rest' => paired_noSplit distinct g f f' rest rest'

/-- Paired in order with a list no shorter, every member of the second list continues one
of the first. -/
theorem paired_covers : ∀ {before after : List F}, after.length ≤ before.length →
    ∀ f, f ∈ after → ∃ g, g ∈ before ∧ paired before after g f
  | _, [], _, _, mem => nomatch mem
  | [], _ :: _, le, _, _ => absurd le (Nat.not_succ_le_zero _)
  | g :: before, _ :: _, le, f, mem => match mem_cons_cases mem with
    | .inl same => ⟨g, .head before, .inl ⟨rfl, same⟩⟩
    | .inr mem => match paired_covers (Nat.le_of_succ_le_succ le) f mem with
      | ⟨g', mem', continues⟩ => ⟨g', .tail g mem', .inr continues⟩

/-- And across one step, under every continuation in which no formation continues as two,
arising is forced exactly when more formations are listed after the step than before:
where no more are, pairing the lists in order continues every formation after the step,
with no split. -/
theorem forced_iff_more {before after : List F} (apart : Distinct before)
    (distinct : Distinct after) :
    (∀ S : F → F → Prop, (∀ g f f', S g f → S g f' → f = f') →
      ¬ ∀ f, f ∈ after → ∃ g, g ∈ before ∧ S g f) ↔ before.length < after.length :=
  ⟨fun forced => match Nat.decLt before.length after.length with
    | isTrue more => more
    | isFalse notMore => absurd (paired_covers (Nat.ge_of_not_lt notMore))
        (forced (paired before after) (paired_noSplit apart)),
   fun more S noSplit covered => Nat.not_lt_of_ge
     (length_le_of_matched (S := fun f g => S g f) distinct covered
       fun f f' g _ _ continues continues' => noSplit g f f' continues continues') more⟩

/-! ## The census balance under a continuation -/

namespace Web

variable (W : Web F C) (R : Nat → F → F → Prop)

/-- Under `R`, `g` is continued across the step from `t`: some formation active after the
step continues it. -/
def Continued (t : Nat) (g : F) : Prop :=
  ∃ f, W.active (t + 1) f ∧ R t g f

/-- Under `R`, `g` ceases across the step from `t`: active before it, and continued by no
formation active after it. -/
def CeasesFrom (t : Nat) (g : F) : Prop :=
  W.active t g ∧ ¬ W.Continued R t g

/-- Under `R`, no formation active after a step continues two active before it. One may
continue as several. -/
def NoMerge : Prop :=
  ∀ t g g' f, W.active t g → W.active t g' → R t g f → R t g' f → W.active (t + 1) f →
    g = g'

/-- With each formation continuing only itself, ceasing under a continuation is ceasing. -/
theorem ceasesFrom_self (t : Nat) (g : F) :
    W.CeasesFrom (fun _ g f => g = f) t g ↔ W.Ceases t g :=
  ⟨fun ⟨before, alone⟩ => ⟨before, fun after => alone ⟨g, after, rfl⟩⟩,
   fun ⟨before, after⟩ => ⟨before, fun ⟨_, active, same⟩ =>
     after (Eq.subst (motive := fun h => W.active (t + 1) h) same.symm active)⟩⟩

/-- Each formation continuing only itself splits none and merges none. -/
theorem self_one_to_one : W.NoSplit (fun _ g f => g = f) ∧ W.NoMerge (fun _ g f => g = f) :=
  ⟨fun _ _ _ _ _ same same' _ _ => same.symm.trans same',
   fun _ _ _ _ _ _ same same' _ => same.trans same'.symm⟩

section Counting

variable [∀ t f, Decidable (W.active t f)] [∀ t f, Decidable (W.Continues R t f)]
  [∀ t g, Decidable (W.Continued R t g)]

instance (t : Nat) (f : F) : Decidable (W.ArisesFrom R t f) := instDecidableAnd

instance (t : Nat) (g : F) : Decidable (W.CeasesFrom R t g) := instDecidableAnd

variable {W R} [∀ t g f, Decidable (R t g f)]

/-- The census balance under a continuation, across one step at whose two ends the active
formations are listed: without splits across it, the formations active after the step with
those ceasing under the continuation are at most those active before with those arising
under it; without merges across it, at least. Only the two listings and the step's splits
and merges are used. -/
theorem Census.balanceFrom_at {alive : Nat → List F} {t : Nat}
    (now : Distinct (alive t) ∧ ∀ f, W.active t f ↔ f ∈ alive t)
    (next : Distinct (alive (t + 1)) ∧ ∀ f, W.active (t + 1) f ↔ f ∈ alive (t + 1)) :
    ((∀ g f f', W.active t g → R t g f → R t g f' → W.active (t + 1) f →
      W.active (t + 1) f' → f = f') →
      (alive (t + 1)).length + total (alive t) (fun g => mark (W.CeasesFrom R t g)) ≤
        (alive t).length + total (alive (t + 1)) (fun f => mark (W.ArisesFrom R t f))) ∧
    ((∀ g g' f, W.active t g → W.active t g' → R t g f → R t g' f →
      W.active (t + 1) f → g = g') →
      (alive t).length + total (alive (t + 1)) (fun f => mark (W.ArisesFrom R t f)) ≤
        (alive (t + 1)).length + total (alive t) (fun g => mark (W.CeasesFrom R t g))) :=
  have after : (alive (t + 1)).length = total (alive (t + 1)) (fun f => mark (W.Continues R t f)) +
      total (alive (t + 1)) (fun f => mark (W.ArisesFrom R t f)) :=
    (total_ones _).symm.trans ((total_congr_on fun f mem =>
      have active : W.active (t + 1) f := (next.2 f).mpr mem
      Eq.symm (mark_add_not (q := W.Continues R t f) (r := W.ArisesFrom R t f)
        (if h : W.Continues R t f then .inl h else .inr ⟨active, h⟩)
        fun both => both.2.2 both.1)).trans (total_add _ _ _))
  have before : (alive t).length = total (alive t) (fun g => mark (W.Continued R t g)) +
      total (alive t) (fun g => mark (W.CeasesFrom R t g)) :=
    (total_ones _).symm.trans ((total_congr_on fun g mem =>
      have active : W.active t g := (now.2 g).mpr mem
      Eq.symm (mark_add_not (q := W.Continued R t g) (r := W.CeasesFrom R t g)
        (if h : W.Continued R t g then .inl h else .inr ⟨active, h⟩)
        fun both => both.2.2 both.1)).trans (total_add _ _ _))
  have swap : total (alive t) (fun g => total (alive (t + 1)) fun f => mark (R t g f)) =
      total (alive (t + 1)) (fun f => total (alive t) fun g => mark (R t g f)) :=
    total_swap (fun g f => mark (R t g f)) (alive (t + 1)) (alive t)
  have continued : total (alive (t + 1)) (fun f => mark (W.Continues R t f)) ≤
      total (alive t) (fun g => total (alive (t + 1)) fun f => mark (R t g f)) :=
    Nat.le_trans (total_le _ fun _ _ => mark_le_total fun ⟨g, active, continues⟩ =>
      ⟨g, (now.2 g).mp active, continues⟩) (Nat.le_of_eq swap.symm)
  have continuing : total (alive t) (fun g => mark (W.Continued R t g)) ≤
      total (alive t) (fun g => total (alive (t + 1)) fun f => mark (R t g f)) :=
    total_le _ fun _ _ => mark_le_total fun ⟨f, active, continues⟩ =>
      ⟨f, (next.2 f).mp active, continues⟩
  ⟨fun noSplit =>
    have pairs : total (alive t) (fun g => total (alive (t + 1)) fun f => mark (R t g f)) ≤
        total (alive t) (fun g => mark (W.Continued R t g)) :=
      total_le _ fun g mem => total_le_mark next.1
        (fun f f' mem_f mem_f' continues continues' =>
          noSplit g f f' ((now.2 g).mpr mem) continues continues'
            ((next.2 f).mpr mem_f) ((next.2 f').mpr mem_f'))
        fun f mem_f continues => ⟨f, (next.2 f).mpr mem_f, continues⟩
    calc (alive (t + 1)).length + total (alive t) (fun g => mark (W.CeasesFrom R t g))
        = (total (alive (t + 1)) (fun f => mark (W.Continues R t f)) +
            total (alive (t + 1)) (fun f => mark (W.ArisesFrom R t f))) +
            total (alive t) (fun g => mark (W.CeasesFrom R t g)) := congrArg (· + _) after
      _ ≤ (total (alive t) (fun g => mark (W.Continued R t g)) +
            total (alive (t + 1)) (fun f => mark (W.ArisesFrom R t f))) +
            total (alive t) (fun g => mark (W.CeasesFrom R t g)) :=
        Nat.add_le_add_right (Nat.add_le_add_right (Nat.le_trans continued pairs) _) _
      _ = (alive t).length + total (alive (t + 1)) (fun f => mark (W.ArisesFrom R t f)) :=
        (Nat.add_right_comm _ _ _).trans (congrArg (· + _) before.symm),
   fun noMerge =>
    have pairs : total (alive t) (fun g => total (alive (t + 1)) fun f => mark (R t g f)) ≤
        total (alive (t + 1)) (fun f => mark (W.Continues R t f)) :=
      Nat.le_trans (Nat.le_of_eq swap) (total_le _ fun f mem => total_le_mark now.1
        (fun g g' mem_g mem_g' continues continues' =>
          noMerge g g' f ((now.2 g).mpr mem_g) ((now.2 g').mpr mem_g')
            continues continues' ((next.2 f).mpr mem))
        fun g mem_g continues => ⟨g, (now.2 g).mpr mem_g, continues⟩)
    calc (alive t).length + total (alive (t + 1)) (fun f => mark (W.ArisesFrom R t f))
        = (total (alive t) (fun g => mark (W.Continued R t g)) +
            total (alive t) (fun g => mark (W.CeasesFrom R t g))) +
            total (alive (t + 1)) (fun f => mark (W.ArisesFrom R t f)) := congrArg (· + _) before
      _ ≤ (total (alive (t + 1)) (fun f => mark (W.Continues R t f)) +
            total (alive t) (fun g => mark (W.CeasesFrom R t g))) +
            total (alive (t + 1)) (fun f => mark (W.ArisesFrom R t f)) :=
        Nat.add_le_add_right (Nat.add_le_add_right (Nat.le_trans continuing pairs) _) _
      _ = (alive (t + 1)).length + total (alive t) (fun g => mark (W.CeasesFrom R t g)) :=
        (Nat.add_right_comm _ _ _).trans (congrArg (· + _) after.symm)⟩

/-- The census balance under a continuation. Under a census, across each step: without
splits, the formations active after the step with those ceasing under the continuation are
at most those active before with those arising under it; without merges, at least. Each
side is read against the continuing pairs: no more formations after the step continue one
before it than there are pairs, nor are more before it continued, and without merges the
first count is the pairs, without splits the second. -/
theorem Census.balanceFrom {alive : Nat → List F} (census : W.Census alive) (t : Nat) :
    (W.NoSplit R → (alive (t + 1)).length + total (alive t) (fun g => mark (W.CeasesFrom R t g)) ≤
      (alive t).length + total (alive (t + 1)) (fun f => mark (W.ArisesFrom R t f))) ∧
    (W.NoMerge R → (alive t).length + total (alive (t + 1)) (fun f => mark (W.ArisesFrom R t f)) ≤
      (alive (t + 1)).length + total (alive t) (fun g => mark (W.CeasesFrom R t g))) :=
  ⟨fun noSplit => (balanceFrom_at (census t) (census (t + 1))).1 (noSplit t),
   fun noMerge => (balanceFrom_at (census t) (census (t + 1))).2 (noMerge t)⟩

/-- Across one step listed at its two ends, with neither splits nor merges across it, the
census balance under a continuation is exact. -/
theorem Census.balanceFrom_eq_at {alive : Nat → List F} {t : Nat}
    (now : Distinct (alive t) ∧ ∀ f, W.active t f ↔ f ∈ alive t)
    (next : Distinct (alive (t + 1)) ∧ ∀ f, W.active (t + 1) f ↔ f ∈ alive (t + 1))
    (noSplit : ∀ g f f', W.active t g → R t g f → R t g f' → W.active (t + 1) f →
      W.active (t + 1) f' → f = f')
    (noMerge : ∀ g g' f, W.active t g → W.active t g' → R t g f → R t g' f →
      W.active (t + 1) f → g = g') :
    (alive (t + 1)).length + total (alive t) (fun g => mark (W.CeasesFrom R t g)) =
      (alive t).length + total (alive (t + 1)) (fun f => mark (W.ArisesFrom R t f)) :=
  Nat.le_antisymm ((balanceFrom_at now next).1 noSplit) ((balanceFrom_at now next).2 noMerge)

/-- Under a census and a continuation with neither splits nor merges, the census balance is
exact across each step. -/
theorem Census.balanceFrom_eq {alive : Nat → List F} (census : W.Census alive) (t : Nat)
    (noSplit : W.NoSplit R) (noMerge : W.NoMerge R) :
    (alive (t + 1)).length + total (alive t) (fun g => mark (W.CeasesFrom R t g)) =
      (alive t).length + total (alive (t + 1)) (fun f => mark (W.ArisesFrom R t f)) :=
  Nat.le_antisymm ((census.balanceFrom t).1 noSplit) ((census.balanceFrom t).2 noMerge)

/-- The census law under a continuation, from a step on: where from `T` on the active
formations are listed at each step and no formation continues as two, ceasing at arbitrarily
late steps needs arising at arbitrarily late steps. Nothing is asked of the steps before
`T`. -/
theorem Census.arisingFrom_of_ceasingFrom_from {alive : Nat → List F} {T : Nat}
    (listing : ∀ s, T ≤ s → Distinct (alive s) ∧ ∀ f, W.active s f ↔ f ∈ alive s)
    (noSplit : ∀ s, T ≤ s → ∀ g f f', W.active s g → R s g f → R s g f' →
      W.active (s + 1) f → W.active (s + 1) f' → f = f')
    (ceasing : ∀ N, ∃ t g, N ≤ t ∧ W.CeasesFrom R t g) : W.UnceasingFrom R :=
  fun N => match gaining_of_losing_from (T := T) (q := fun t => (alive t).length)
      (x := fun t => total (alive t) fun g => mark (W.CeasesFrom R t g))
      (y := fun t => total (alive (t + 1)) fun f => mark (W.ArisesFrom R t f))
      (fun t from_ => (balanceFrom_at (listing t from_)
        (listing (t + 1) (Nat.le_succ_of_le from_))).1 (noSplit t from_))
      (fun M => match ceasing (M + T) with
        | ⟨t, g, later, ceases⟩ => ⟨t, Nat.le_trans (Nat.le_add_right M T) later,
          total_pos_of_mem (((listing t (Nat.le_trans (Nat.le_add_left T M) later)).2 g).mp
            ceases.1) (mark_pos.mpr ceases)⟩) N with
  | ⟨t, later, arose⟩ => match total_pos _ arose with
    | ⟨f, _, arises⟩ => ⟨t, f, later, mark_pos.mp arises⟩

/-- The census law under a continuation: under a census and a continuation in which no
formation continues as two, ceasing at arbitrarily late steps needs arising at arbitrarily
late steps (`arising_of_ceasing`). -/
theorem Census.arisingFrom_of_ceasingFrom {alive : Nat → List F} (census : W.Census alive)
    (noSplit : W.NoSplit R) (ceasing : ∀ N, ∃ t g, N ≤ t ∧ W.CeasesFrom R t g) :
    W.UnceasingFrom R :=
  arisingFrom_of_ceasingFrom_from (T := 0) (fun s _ => census s) (fun s _ => noSplit s) ceasing

/-- And from a step on: where from `T` on the active formations are listed at each step, at
most `B` of them, and no formation continues two, arising at arbitrarily late steps needs
ceasing at arbitrarily late steps. -/
theorem Census.ceasingFrom_of_arisingFrom_from {alive : Nat → List F} {T B : Nat}
    (listing : ∀ s, T ≤ s → Distinct (alive s) ∧ ∀ f, W.active s f ↔ f ∈ alive s)
    (noMerge : ∀ s, T ≤ s → ∀ g g' f, W.active s g → W.active s g' → R s g f → R s g' f →
      W.active (s + 1) f → g = g')
    (bounded : ∀ t, T ≤ t → (alive t).length ≤ B) (arising : W.UnceasingFrom R) :
    ∀ N, ∃ t g, N ≤ t ∧ W.CeasesFrom R t g :=
  fun N => match losing_of_gaining_from (T := T) (q := fun t => (alive t).length)
      (x := fun t => total (alive t) fun g => mark (W.CeasesFrom R t g))
      (y := fun t => total (alive (t + 1)) fun f => mark (W.ArisesFrom R t f))
      (fun t from_ => (balanceFrom_at (listing t from_)
        (listing (t + 1) (Nat.le_succ_of_le from_))).2 (noMerge t from_))
      bounded (fun M => match arising (M + T) with
        | ⟨t, f, later, arises⟩ => ⟨t, Nat.le_trans (Nat.le_add_right M T) later,
          total_pos_of_mem (((listing (t + 1) (Nat.le_succ_of_le
            (Nat.le_trans (Nat.le_add_left T M) later))).2 f).mp arises.1) (mark_pos.mpr arises)⟩) N with
  | ⟨t, later, ceased⟩ => match total_pos _ ceased with
    | ⟨g, _, ceases⟩ => ⟨t, g, later, mark_pos.mp ceases⟩

/-- And under a census and a continuation in which no formation continues two, with at
most `B` formations active at each step from some step on, arising at arbitrarily late
steps needs ceasing at arbitrarily late steps (`ceasing_of_arising`). -/
theorem Census.ceasingFrom_of_arisingFrom {alive : Nat → List F} (census : W.Census alive)
    (noMerge : W.NoMerge R) {T B : Nat} (bounded : ∀ t, T ≤ t → (alive t).length ≤ B)
    (arising : W.UnceasingFrom R) : ∀ N, ∃ t g, N ≤ t ∧ W.CeasesFrom R t g :=
  ceasingFrom_of_arisingFrom_from (fun s _ => census s) (fun s _ => noMerge s) bounded arising

end Counting

/-! ## The census law under a continuation, from one covering list -/

section Covering

/-- The lineage of `g` from step `M`: `h` at step `M + k` is reached from `g` at `M` by `k`
steps of continuation, each between formations active at its two ends. -/
def Lineage (M : Nat) (g : F) : Nat → F → Prop
  | 0, h => h = g
  | k + 1, h => ∃ h₀, Lineage M g k h₀ ∧ W.active (M + k) h₀ ∧ R (M + k) h₀ h ∧
      W.active (M + k + 1) h

variable {W R}

/-- Without splits from `M` on, a lineage reaches at most one formation at each step. -/
theorem Lineage.unique {M : Nat} {g : F}
    (noSplit : ∀ s, M ≤ s → ∀ g f f', W.active s g → R s g f → R s g f' →
      W.active (s + 1) f → W.active (s + 1) f' → f = f') :
    ∀ {k h h'}, W.Lineage R M g k h → W.Lineage R M g k h' → h = h'
  | 0, _, _, same, same' => same.trans same'.symm
  | k + 1, _, _, ⟨h₀, lineage, active₀, cont, active⟩, ⟨h₀', lineage', _, cont', active'⟩ =>
    have prior : h₀ = h₀' := Lineage.unique noSplit lineage lineage'
    noSplit (M + k) (Nat.le_add_right M k) h₀ _ _ active₀ cont
      (Eq.subst (motive := fun x => R (M + k) x _) prior.symm cont') active active'

/-- A lineage reaching a later step passed through every earlier one, and was continued
there. -/
theorem Lineage.through {M : Nat} {g : F} {k : Nat} :
    ∀ i {h'}, W.Lineage R M g (k + 1 + i) h' →
      ∃ h₁ h₂, W.Lineage R M g k h₁ ∧ R (M + k) h₁ h₂ ∧ W.active (M + k + 1) h₂
  | 0, _, ⟨h₀, lineage, _, cont, active⟩ => ⟨h₀, _, lineage, cont, active⟩
  | i + 1, _, ⟨_, lineage, _, _, _⟩ => Lineage.through i lineage

/-- So where the formation a lineage reaches at a step ceases there under the continuation,
the lineage reaches nothing later. -/
theorem Lineage.ends {M : Nat} {g : F}
    (noSplit : ∀ s, M ≤ s → ∀ g f f', W.active s g → R s g f → R s g f' →
      W.active (s + 1) f → W.active (s + 1) f' → f = f')
    {k : Nat} {h : F} (lineage : W.Lineage R M g k h) (ceases : W.CeasesFrom R (M + k) h)
    (i : Nat) {h' : F} : ¬ W.Lineage R M g (k + 1 + i) h' :=
  fun later => match Lineage.through i later with
  | ⟨_, h₂, lineage₁, cont, active⟩ =>
    ceases.2 ⟨h₂, active, Eq.subst (motive := fun x => R (M + k) x h₂)
      (Lineage.unique noSplit lineage₁ lineage) cont⟩

/-- Where nothing arises under the continuation from `M` on, every formation active at a
later step is not refuted to lie on the lineage of one listed at `M`, by a list covering
what is active there. -/
theorem Lineage.back {M : Nat} {l : List F} (covers : ∀ f, W.active M f → f ∈ l)
    (quiet : ∀ s f, M ≤ s → ¬ W.ArisesFrom R s f) :
    ∀ k h, W.active (M + k) h → ¬¬ ∃ g, g ∈ l ∧ W.Lineage R M g k h
  | 0, h, active => fun none => none ⟨h, covers h active, rfl⟩
  | k + 1, h, active => fun none =>
    quiet (M + k) h (Nat.le_add_right M k) ⟨active, fun ⟨h₀, active₀, cont⟩ =>
      Lineage.back covers quiet k h₀ active₀ fun ⟨g, mem, lineage⟩ =>
        none ⟨g, mem, h₀, lineage, active₀, cont, active⟩⟩

/-- Ceasing under the continuation at arbitrarily late steps gives, from any step, any number
of ceasings at distinct steps. -/
theorem ceasingFrom_found (ceasing : ∀ N, ∃ t g, N ≤ t ∧ W.CeasesFrom R t g) :
    ∀ n N, ∃ ps : List (Nat × F), Distinct ps ∧ ps.length = n ∧
      ∀ p, p ∈ ps → N ≤ p.1 ∧ W.CeasesFrom R p.1 p.2
  | 0, _ => ⟨[], trivial, rfl, fun _ mem => nomatch mem⟩
  | n + 1, N => match ceasing N with
    | ⟨t, g, later, ceases⟩ => match ceasingFrom_found ceasing n (t + 1) with
      | ⟨ps, distinct, length, all⟩ =>
        ⟨(t, g) :: ps, ⟨fun mem => Nat.not_succ_le_self t (all _ mem).1, distinct⟩,
         congrArg Nat.succ length, fun p mem => match mem_cons_cases mem with
          | .inl same => Eq.subst (motive := fun q : Nat × F => N ≤ q.1 ∧ W.CeasesFrom R q.1 q.2)
              same.symm ⟨later, ceases⟩
          | .inr mem => ⟨Nat.le_trans (Nat.le_succ_of_le later) (all p mem).1, (all p mem).2⟩⟩

/-- The census law under a continuation, from one covering list: where a list covers what
is active at step `M`, no formation continues as two from `M` on, and ceasing under the
continuation recurs, it is not refuted that something arises under it from `M` on. No
census and no decision is used. Each ceasing from `M` on ends the lineage of one listed
formation, and each lineage ends at most once, so with nothing arising the ceasings would
number at most the list. -/
theorem not_not_arisingFrom_covered {M : Nat} {l : List F}
    (covers : ∀ f, W.active M f → f ∈ l)
    (noSplit : ∀ s, M ≤ s → ∀ g f f', W.active s g → R s g f → R s g f' →
      W.active (s + 1) f → W.active (s + 1) f' → f = f')
    (ceasing : ∀ N, ∃ t g, N ≤ t ∧ W.CeasesFrom R t g) :
    ¬¬ ∃ s f, M ≤ s ∧ W.ArisesFrom R s f :=
  fun nothing =>
    have quiet : ∀ s f, M ≤ s → ¬ W.ArisesFrom R s f :=
      fun s f later arises => nothing ⟨s, f, later, arises⟩
    match ceasingFrom_found ceasing (l.length + 1) M with
    | ⟨ps, distinct, length, all⟩ =>
      not_not_all (P := fun p : Nat × F => ∃ g, g ∈ l ∧ ∃ k, p.1 = M + k ∧
          W.Lineage R M g k p.2) (E := ps)
        (fun p mem => match le_dest (all p mem).1 with
          | ⟨k, same⟩ => fun none => Lineage.back covers quiet k p.2
              (Eq.subst (motive := fun s => W.active s p.2) same (all p mem).2.1)
              fun ⟨g, inside, lineage⟩ => none ⟨g, inside, k, same, lineage⟩)
        fun matched => Nat.not_succ_le_self l.length (Nat.le_trans (Nat.le_of_eq length.symm)
          (length_le_of_matched (S := fun p g => ∃ k, p.1 = M + k ∧ W.Lineage R M g k p.2)
            distinct (fun p mem => match matched p mem with
              | ⟨g, inside, k, same, lineage⟩ => ⟨g, inside, k, same, lineage⟩)
            fun p p' g mem mem' ⟨k, same, lineage⟩ ⟨k', same', lineage'⟩ =>
              have ceases : W.CeasesFrom R (M + k) p.2 :=
                Eq.subst (motive := fun s => W.CeasesFrom R s p.2) same (all p mem).2
              have ceases' : W.CeasesFrom R (M + k') p'.2 :=
                Eq.subst (motive := fun s => W.CeasesFrom R s p'.2) same' (all p' mem').2
              match Nat.lt_or_ge k k' with
              | .inl below => match le_dest below with
                | ⟨i, more⟩ => absurd (Eq.subst (motive := fun j => W.Lineage R M g j p'.2)
                    more lineage')
                    (Lineage.ends noSplit lineage ceases i)
              | .inr above => match Nat.eq_or_lt_of_le above with
                | .inl equal =>
                  have steps : p.1 = p'.1 :=
                    same.trans ((congrArg (M + ·) equal.symm).trans same'.symm)
                  have names : p.2 = p'.2 := Lineage.unique noSplit lineage
                    (Eq.subst (motive := fun j => W.Lineage R M g j p'.2) equal lineage')
                  match p, p', steps, names with
                  | (_, _), (_, _), rfl, rfl => rfl
                | .inr beyond => match le_dest beyond with
                  | ⟨i, more⟩ => absurd (Eq.subst (motive := fun j => W.Lineage R M g j p.2)
                      more lineage)
                      (Lineage.ends noSplit lineage' ceases' i)))

/-- So, with covering lists at arbitrarily late steps and no splits from some step on,
ceasing under the continuation recurring leaves no step from which nothing arises under
it. -/
theorem arisingFrom_not_stopping_covered {T : Nat}
    (covered : ∀ N, ∃ M, ∃ l : List F, N ≤ M ∧ ∀ f, W.active M f → f ∈ l)
    (noSplit : ∀ s, T ≤ s → ∀ g f f', W.active s g → R s g f → R s g f' →
      W.active (s + 1) f → W.active (s + 1) f' → f = f')
    (ceasing : ∀ N, ∃ t g, N ≤ t ∧ W.CeasesFrom R t g) :
    ¬ ∃ N, ∀ t f, N ≤ t → ¬ W.ArisesFrom R t f :=
  fun ⟨N, quiet⟩ => match covered (N + T) with
  | ⟨_, _, later, covers⟩ =>
    not_not_arisingFrom_covered covers
      (fun s from_ => noSplit s (Nat.le_trans (Nat.le_trans (Nat.le_add_left T N) later) from_))
      ceasing fun ⟨s, f, from_, arises⟩ =>
        quiet s f (Nat.le_trans (Nat.le_trans (Nat.le_add_right N T) later) from_) arises

/-! ### The converse: arising recurring needs ceasing -/

/-- A lineage is active at each step it reaches, where it starts active. -/
theorem Lineage.active {M : Nat} {g : F} (start : W.active M g) :
    ∀ {k h}, W.Lineage R M g k h → W.active (M + k) h
  | 0, _, same => Eq.subst (motive := fun x => W.active M x) same.symm start
  | _ + 1, _, ⟨_, _, _, _, active⟩ => active

/-- A lineage reaching a later step passes through each earlier one, and from there is a
lineage itself. -/
theorem Lineage.split {M : Nat} {g : F} {j : Nat} :
    ∀ i {h}, W.Lineage R M g (j + i) h → ∃ x, W.Lineage R M g j x ∧ W.Lineage R (M + j) x i h
  | 0, h, lineage => ⟨h, lineage, rfl⟩
  | i + 1, h, ⟨h₀, lineage, active₀, cont, active⟩ => match Lineage.split i lineage with
    | ⟨x, before, after⟩ =>
      have same : M + (j + i) = M + j + i := (Nat.add_assoc M j i).symm
      ⟨x, before, h₀, after, Eq.subst (motive := fun s => W.active s h₀) same active₀,
        Eq.subst (motive := fun s => R s h₀ h) same cont,
        Eq.subst (motive := fun s => W.active (s + 1) h) same active⟩

/-- Without merges from `M` on, two lineages from `M` reaching one formation at one step start
from one formation. -/
theorem Lineage.origin {M : Nat}
    (noMerge : ∀ s, M ≤ s → ∀ g g' f, W.active s g → W.active s g' → R s g f → R s g' f →
      W.active (s + 1) f → g = g') :
    ∀ {k g g' h}, W.Lineage R M g k h → W.Lineage R M g' k h → g = g'
  | 0, _, _, _, same, same' => same.symm.trans same'
  | k + 1, _, _, _, ⟨h₀, lineage, active₀, cont, active⟩, ⟨h₀', lineage', active₀', cont', _⟩ =>
    have prior : h₀ = h₀' :=
      noMerge (M + k) (Nat.le_add_right M k) h₀ h₀' _ active₀ active₀' cont cont' active
    Lineage.origin noMerge lineage (Eq.subst (motive := fun x => W.Lineage R M _ k x) prior.symm
      lineage')

/-- Where nothing ceases under the continuation from `N` on, a lineage from a formation active
at a step `M` from `N` on is not refuted to reach some formation at every later step. -/
theorem Lineage.onward {N M : Nat} (later : N ≤ M) {g : F}
    (quiet : ∀ t g, N ≤ t → ¬ W.CeasesFrom R t g) (start : W.active M g) :
    ∀ k, ¬¬ ∃ h, W.Lineage R M g k h
  | 0 => fun none => none ⟨g, rfl⟩
  | k + 1 => fun none => Lineage.onward later quiet start k fun ⟨h, lineage⟩ =>
    have active := lineage.active start
    quiet (M + k) h (Nat.le_trans later (Nat.le_add_right M k)) ⟨active, fun ⟨f, after, cont⟩ =>
      none ⟨f, h, lineage, active, cont, after⟩⟩

/-- Arising under the continuation at arbitrarily late steps gives, from any step, any number
of arisings at distinct steps. -/
theorem arisingFrom_found (arising : W.UnceasingFrom R) :
    ∀ n N, ∃ ps : List (Nat × F), Distinct ps ∧ ps.length = n ∧
      ∀ p, p ∈ ps → N ≤ p.1 ∧ W.ArisesFrom R p.1 p.2
  | 0, _ => ⟨[], trivial, rfl, fun _ mem => nomatch mem⟩
  | n + 1, N => match arising N with
    | ⟨t, f, later, arises⟩ => match arisingFrom_found arising n (t + 1) with
      | ⟨ps, distinct, length, all⟩ =>
        ⟨(t, f) :: ps, ⟨fun mem => Nat.not_succ_le_self t (all _ mem).1, distinct⟩,
         congrArg Nat.succ length, fun p mem => match mem_cons_cases mem with
          | .inl same => Eq.subst (motive := fun q : Nat × F => N ≤ q.1 ∧ W.ArisesFrom R q.1 q.2)
              same.symm ⟨later, arises⟩
          | .inr mem => ⟨Nat.le_trans (Nat.le_succ_of_le later) (all p mem).1, (all p mem).2⟩⟩

/-- An arising does not lie on the lineage of an earlier one: without merges from `N` on, the
lineage of a formation arising across the step from `t`, reaching at a later step what the
lineage of one arising across the step from `t + 1 + d` reaches, would pass through the later
formation at its arising, so that formation would continue an active one. -/
theorem lineages_apart {N : Nat}
    (noMerge : ∀ s, N ≤ s → ∀ g g' f, W.active s g → W.active s g' → R s g f → R s g' f →
      W.active (s + 1) f → g = g')
    {t d : Nat} {f₁ f₂ h : F} (from_ : N ≤ t) (arises₂ : W.ArisesFrom R (t + 1 + d) f₂)
    {k₁ k₂ : Nat} (lineage₁ : W.Lineage R (t + 1) f₁ k₁ h)
    (lineage₂ : W.Lineage R (t + 1 + d + 1) f₂ k₂ h) (same : t + 1 + k₁ = t + 1 + d + 1 + k₂) :
    False :=
  have lengths : k₁ = d + 1 + k₂ :=
    add_right_cancel (t + 1) ((Nat.add_comm _ _).trans ((same.trans
      (Nat.add_assoc (t + 1) (d + 1) k₂)).trans (Nat.add_comm _ _)))
  match Lineage.split (j := d + 1) k₂
      (Eq.subst (motive := fun j => W.Lineage R (t + 1) f₁ j h) lengths lineage₁) with
  | ⟨x, ⟨x₀, _, active₀, cont, _⟩, rest⟩ =>
    have origin : x = f₂ := Lineage.origin (M := t + 1 + d + 1)
      (fun s from_s => noMerge s (Nat.le_trans from_ (Nat.le_trans (Nat.le_trans
        (Nat.le_add_right t 1) (Nat.le_trans (Nat.le_add_right (t + 1) d) (Nat.le_succ _))) from_s)))
      rest lineage₂
    arises₂.2 ⟨x₀, active₀, Eq.subst (motive := fun y => R (t + 1 + d) x₀ y) origin cont⟩

/-- The converse of the census law under a continuation, from one covering list: where one list
covers what is active at each step from `T` on, no two formations continue as one from `T` on,
and something arises under the continuation at arbitrarily late steps, ceasing under it never
stops for good. No census and no decision is used. With nothing ceasing from `N` on, the
lineage of each arising goes on, not refuted, and lineages of distinct arisings never meet; so
more arisings than the list holds would leave more formations active at one late step than the
list holds. -/
theorem ceasingFrom_not_stopping_covered {T : Nat} {L : List F}
    (covers : ∀ t, T ≤ t → ∀ f, W.active t f → f ∈ L)
    (noMerge : ∀ s, T ≤ s → ∀ g g' f, W.active s g → W.active s g' → R s g f → R s g' f →
      W.active (s + 1) f → g = g')
    (arising : W.UnceasingFrom R) : ¬ ∃ N, ∀ t g, N ≤ t → ¬ W.CeasesFrom R t g :=
  fun ⟨N₀, quiet₀⟩ =>
    have quiet : ∀ t g, N₀ + T ≤ t → ¬ W.CeasesFrom R t g :=
      fun t g later => quiet₀ t g (Nat.le_trans (Nat.le_add_right N₀ T) later)
    have merge : ∀ s, N₀ + T ≤ s → ∀ g g' f, W.active s g → W.active s g' → R s g f →
        R s g' f → W.active (s + 1) f → g = g' :=
      fun s later => noMerge s (Nat.le_trans (Nat.le_add_left T N₀) later)
    match arisingFrom_found arising (L.length + 1) (N₀ + T) with
    | ⟨ps, distinct, length, all⟩ =>
      have reach : ∀ p, p ∈ ps → p.1 + 1 ≤ total ps (fun q : Nat × F => q.1 + 1) :=
        fun _ mem => le_total_of_mem (q := fun q : Nat × F => q.1 + 1) mem
      not_not_all (P := fun p : Nat × F => ∃ h, h ∈ L ∧ ∃ k,
          p.1 + 1 + k = total ps (fun q : Nat × F => q.1 + 1) ∧ W.Lineage R (p.1 + 1) p.2 k h)
        (E := ps)
        (fun p mem none => match le_dest (reach p mem) with
          | ⟨k, at_end⟩ => Lineage.onward (Nat.le_succ_of_le (all p mem).1) quiet
              (all p mem).2.1 k fun ⟨h, lineage⟩ =>
              none ⟨h, covers _ (Nat.le_trans (Nat.le_add_left T N₀) (Nat.le_trans
                  (Nat.le_succ_of_le (all p mem).1) (reach p mem))) h
                (Eq.subst (motive := fun s => W.active s h) at_end.symm
                  (lineage.active (all p mem).2.1)), k, at_end.symm, lineage⟩)
        fun matched => Nat.not_succ_le_self L.length (Nat.le_trans (Nat.le_of_eq length.symm)
          (length_le_of_matched (S := fun p h => ∃ k,
              p.1 + 1 + k = total ps (fun q : Nat × F => q.1 + 1) ∧ W.Lineage R (p.1 + 1) p.2 k h)
            distinct (fun p mem => match matched p mem with
              | ⟨h, inside, k, at_end, lineage⟩ => ⟨h, inside, k, at_end, lineage⟩)
            fun p p' _ mem mem' ⟨k, at_end, lineage⟩ ⟨k', at_end', lineage'⟩ =>
              have joined : p.1 + 1 + k = p'.1 + 1 + k' := at_end.trans at_end'.symm
              match Nat.lt_or_ge p.1 p'.1 with
              | .inl below => match le_dest below with
                | ⟨_, gap⟩ => absurd (lineages_apart merge (all p mem).1
                    (Eq.subst (motive := fun s => W.ArisesFrom R s p'.2) gap (all p' mem').2)
                    lineage (Eq.subst (motive := fun s => W.Lineage R (s + 1) p'.2 k' _) gap lineage')
                    (joined.trans (congrArg (· + 1 + k') gap))) id
              | .inr above => match Nat.eq_or_lt_of_le above with
                | .inl equal =>
                  have lengths : k = k' := add_right_cancel (p.1 + 1) ((Nat.add_comm _ _).trans
                    ((joined.trans (congrArg (· + 1 + k') equal)).trans (Nat.add_comm _ _)))
                  have names : p.2 = p'.2 := Lineage.origin (M := p.1 + 1)
                    (fun s from_s => merge s (Nat.le_trans (all p mem).1
                      (Nat.le_trans (Nat.le_succ p.1) from_s))) lineage
                    (Eq.subst (motive := fun j => W.Lineage R (p.1 + 1) p'.2 j _) lengths.symm
                      (Eq.subst (motive := fun s => W.Lineage R (s + 1) p'.2 k' _) equal lineage'))
                  match p, p', equal.symm, names with
                  | (_, _), (_, _), rfl, rfl => rfl
                | .inr beyond => match le_dest beyond with
                  | ⟨_, gap⟩ => absurd (lineages_apart merge (all p' mem').1
                      (Eq.subst (motive := fun s => W.ArisesFrom R s p.2) gap (all p mem).2)
                      lineage' (Eq.subst (motive := fun s => W.Lineage R (s + 1) p.2 k _) gap lineage)
                      (joined.symm.trans (congrArg (· + 1 + k) gap))) id))

end Covering

end Web

/-- Under a census, whether a formation active before a step is continued is decidable
where the continuation is. -/
def Web.Census.decideContinued {W : Web F C} {R : Nat → F → F → Prop}
    [∀ t g f, Decidable (R t g f)] {alive : Nat → List F} (census : W.Census alive)
    (t : Nat) (g : F) : Decidable (W.Continued R t g) :=
  have : Decidable (∃ f, f ∈ alive (t + 1) ∧ R t g f) :=
    decideSome (p := fun f => R t g f) (alive (t + 1))
  decidable_of_decidable_of_iff (p := ∃ f, f ∈ alive (t + 1) ∧ R t g f)
    ⟨fun ⟨f, mem, r⟩ => ⟨f, ((census (t + 1)).2 f).mpr mem, r⟩,
     fun ⟨f, active, r⟩ => ⟨f, ((census (t + 1)).2 f).mp active, r⟩⟩

/-! ## Witnesses -/

/-- Whether a step is odd. -/
def odd : Nat → Bool
  | 0 => false
  | t + 1 => !odd t

/-- Whether a step comes after the first. -/
def afterFirst : Nat → Bool := Witnesses.profile [false] true

/-- Exchange by `swap`, or not. -/
def turn (swap : F → F) : Bool → F → F
  | true, f => swap f
  | false, f => f

theorem turn_turn {swap : F → F} (twice : ∀ f, swap (swap f) = f) :
    ∀ b f, turn swap b (turn swap b f) = f
  | true, f => twice f
  | false, _ => rfl

theorem turn_fixed {swap : F → F} {f : F} (fixed : swap f = f) : ∀ b, turn swap b f = f
  | true => fixed
  | false => rfl

/-- At the steps `when` picks, names are exchanged by an involution. -/
def Reidentify.exchanging (when : Nat → Bool) (swap : F → F) (twice : ∀ f, swap (swap f) = f) :
    Reidentify F F :=
  ⟨fun t => turn swap (when t), fun t => turn swap (when t), fun t => turn_turn twice (when t),
    fun t => turn_turn twice (when t)⟩

namespace Turnover

/-- A pool and a spring. -/
inductive Condition where
  | pool
  | spring

/-- A drawer on the pool, a keeper of the spring, a formation that needs the pool, and an
idle one. -/
inductive Formation where
  | drawer
  | keeper
  | consumer
  | idle

/-- The pool holds two units and falls to one. -/
def pool : Nat → Nat := Witnesses.profile [2] 1

/-- The drawer draws the pool. The keeper needs one unit of the spring and draws it. The
consumer needs two units of the pool and is active at the first step only, while
the pool supports it. The idle formation does nothing. -/
def web : Web Formation Condition where
  level t c := match c with
    | .pool => pool t
    | .spring => 1
  active t f := match f with
    | .drawer | .keeper => True
    | .consumer => t = 0
    | .idle => False
  requires _ f c := match f with
    | .keeper => c = .spring
    | .consumer => c = .pool
    | .drawer | .idle => False
  need _ f _ := match f with
    | .keeper => 1
    | .consumer => 2
    | .drawer | .idle => 0
  draws _ f c := match f with
    | .drawer => c = .pool
    | .keeper => c = .spring
    | .consumer | .idle => False

/-- Exchange the drawer with the idle formation and the keeper with the consumer. -/
def swap : Formation → Formation
  | .drawer => .idle
  | .idle => .drawer
  | .keeper => .consumer
  | .consumer => .keeper

theorem swap_swap : ∀ f, swap (swap f) = f
  | .drawer | .keeper | .consumer | .idle => rfl

/-- At every odd step, the drawer and the idle formation exchange names, and so do the
keeper and the consumer. -/
def exchange : Reidentify Formation Formation := .exchanging odd swap swap_swap

/-- The re-identified web. -/
abbrev turned : Web Formation Condition := web.reidentify exchange

theorem pool_late : ∀ {t}, 1 ≤ t → pool t = 1
  | _ + 1, _ => rfl
  | 0, h => absurd h (Nat.not_succ_le_zero 0)

theorem pool_not_renewed : ¬ web.Renewed .pool :=
  fun renewed => Nat.not_succ_le_self 1 (renewed 0 .consumer rfl).2

/-- Whoever needs the spring needs one unit. -/
theorem needs_spring : ∀ {t} f, web.requires t f .spring → web.need t f .spring ≤ 1
  | _, .keeper, _ => Nat.le_refl 1
  | _, .consumer, h | _, .drawer, h | _, .idle, h => nomatch h

/-- Whoever needs the pool needs two units. -/
theorem needs_pool : ∀ {t} f, web.requires t f .pool → web.need t f .pool = 2
  | _, .consumer, _ => rfl
  | _, .keeper, h | _, .drawer, h | _, .idle, h => nomatch h

/-- No one name needs the pool both before and after an exchange. -/
theorem not_both :
    ∀ b f, web.requires 0 (turn swap b f) .pool → ¬ web.requires 0 (turn swap (!b) f) .pool
  | true, .keeper, _, h | false, .consumer, _, h
  | true, .drawer, h, _ | true, .consumer, h, _ | true, .idle, h, _
  | false, .drawer, h, _ | false, .keeper, h, _ | false, .idle, h, _ => nomatch h

/-- As named in `web`: activity needs support; the keeper renews and the drawer consumes;
the drawer undermines at every step, the consumer's need having been met at the
first; and no dependence forms and nothing arises. -/
theorem identified :
    web.Dependent ∧ web.RenewingIn .keeper ∧ web.ConsumingIn .drawer ∧
    (∀ t, web.UnderminingAt t .drawer) ∧ (∀ t f c, ¬ web.Forms t f c) ∧ ¬ web.Unceasing :=
  ⟨fun t f active c depends => match f, active, depends with
    | .keeper, _, depends => match c, depends with
      | .spring, _ => Nat.le_refl 1
      | .pool, h => nomatch h
    | .consumer, active, depends => match t, c, active, depends with
      | 0, .pool, _, _ => Nat.le_refl 2
      | 0, .spring, _, h | _ + 1, _, h, _ => nomatch h
    | .drawer, _, h | .idle, h, _ => (nomatch h),
   fun _ c joins => match c, joins with
    | .spring, _ => fun _ g depends => match g, depends with
      | .keeper, _ => ⟨Nat.le_refl 1, Nat.le_refl 1⟩
      | .consumer, h | .drawer, h | .idle, h => nomatch h
    | .pool, .inl h | .pool, .inr h => (nomatch h),
   ⟨0, .pool, rfl, .consumer, 0, rfl, fun t later => match t, later with
    | _ + 1, _ => Nat.lt_succ_self 1
    | 0, h => absurd h (Nat.lt_irrefl 0)⟩,
   fun _ => ⟨.pool, rfl, .consumer, rfl,
    ⟨0, Nat.zero_le _, fun _ _ _ => rfl, Nat.le_refl 2, Nat.lt_succ_self 1⟩, Nat.lt_succ_self 1⟩,
   fun _ _ _ ⟨before, after⟩ => before after,
   fun unceasing => match unceasing 0 with
    | ⟨_, f, _, inactive, active⟩ => match f, active with
      | .drawer, _ | .keeper, _ => inactive trivial
      | .consumer, h | .idle, h => nomatch h⟩

/-- Re-identified, with every step's relations unchanged: activity still needs support; no
formation renews and two consume; no event after the first step undermines; the keeper
transforms its dependence across the first step; and formations arise at every odd step,
lowering no condition. -/
theorem reidentified :
    turned.Dependent ∧ (∀ x, ¬ turned.RenewingIn x) ∧ turned.ConsumingIn .drawer ∧
    turned.ConsumingIn .idle ∧ (∀ t x, 1 ≤ t → ¬ turned.UnderminingAt t x) ∧
    turned.Dissolves 0 .keeper .spring ∧ turned.Forms 0 .keeper .pool ∧ turned.Unceasing ∧
    ¬ turned.Depletes [.pool, .spring] fun t => ∃ x, turned.Arises t x :=
  have unrenewed : ¬ turned.Renewed .pool :=
    fun renewed => pool_not_renewed ((web.reidentify_renewed exchange .pool).mp renewed)
  have consumed : turned.Consumed .pool :=
    ⟨.consumer, 0, rfl, fun t later => match t, later with
      | _ + 1, _ => Nat.lt_succ_self 1
      | 0, h => absurd h (Nat.lt_irrefl 0)⟩
  have arises : ∀ t, odd t = true → turned.Arises t .drawer := fun t odd' =>
    have odd_next : odd (t + 1) = false := congrArg (!·) odd'
    ⟨Eq.subst (motive := fun b => web.active t (turn swap b .drawer) → False) odd'.symm id,
     Eq.subst (motive := fun b => web.active (t + 1) (turn swap b .drawer)) odd_next.symm trivial⟩
  ⟨(web.reidentify_dependent exchange).mpr identified.1,
   fun x renewing => match x with
    | .drawer => unrenewed (renewing 0 .pool (.inr rfl))
    | .keeper => unrenewed (renewing 1 .pool (.inl rfl))
    | .consumer => unrenewed (renewing 0 .pool (.inl rfl))
    | .idle => unrenewed (renewing 1 .pool (.inr rfl)),
   ⟨0, .pool, rfl, consumed⟩,
   ⟨1, .pool, rfl, consumed⟩,
   fun t _ late ⟨c, _, y, depends, ⟨s, before, held, met, _⟩, fell⟩ => match c with
    | .spring => Nat.not_le_of_gt fell (needs_spring (t := t) _ depends)
    | .pool => match t, late with
      | 0, h => absurd h (Nat.not_succ_le_zero 0)
      | m + 1, _ => match Nat.lt_or_ge s (m + 1) with
        | .inl earlier =>
          not_both (odd m) y (held m (Nat.le_of_lt_succ earlier) (Nat.le_succ m))
            (held (m + 1) (Nat.le_succ_of_le (Nat.le_of_lt_succ earlier)) (Nat.le_refl _))
        | .inr later =>
          Nat.not_succ_le_self 1 (Nat.le_trans
            (Nat.le_of_eq (needs_pool (t := s) _ (held s (Nat.le_refl s) before)).symm)
            (Nat.le_trans met (Nat.le_of_eq (pool_late (Nat.le_trans (Nat.succ_le_succ
              (Nat.zero_le m)) later))))),
   ⟨rfl, fun h => nomatch h⟩, ⟨fun h => (nomatch h), rfl⟩,
   fun N => match h : odd N with
    | true => ⟨N, .drawer, Nat.le_refl N, arises N h⟩
    | false => ⟨N + 1, .drawer, Nat.le_succ N, arises (N + 1) (congrArg (!·) h)⟩,
   fun depletes => match depletes 1 ⟨.drawer, arises 1 rfl⟩
      (fun c _ rises => match c, rises with
        | .pool, rises | .spring, rises => Nat.lt_irrefl 1 rises) with
    | ⟨c, _, falls⟩ => match c, falls with
      | .pool, falls | .spring, falls => Nat.lt_irrefl 1 falls⟩

end Turnover

namespace TideFlip

open Tide (Formation)

/-- Exchange the moon and the flicker. -/
def swap : Formation → Formation
  | .moon => .flicker
  | .flicker => .moon

theorem swap_swap : ∀ f, swap (swap f) = f
  | .moon | .flicker => rfl

/-- At every odd step the moon and the flicker exchange names. -/
def flip : Reidentify Formation Formation := .exchanging odd swap swap_swap

/-- The tide and the moon, with nothing arising (`Tide.still`), named by `flip`. -/
abbrev flipped : Web Formation Unit := Tide.still.reidentify flip

/-- The moon's renewing, carried to the new names. -/
def renews (t : Nat) (x : Formation) (c : Unit) : Prop := Tide.renews t (flip.old t x) c

theorem tide_changes : ∀ t, Tide.tide t < Tide.tide (t + 1) ∨ Tide.tide (t + 1) < Tide.tide t
  | 0 => .inl Nat.zero_lt_one
  | 1 => .inr Nat.zero_lt_one
  | n + 2 => tide_changes n

/-- Under the new names, the name `moon` arises at every odd step. -/
theorem arises : ∀ t, odd t = true → flipped.Arises t .moon := fun _ odd' =>
  ⟨fun moon => Formation.noConfusion
    (Eq.subst (motive := fun b => turn swap b .moon = .moon) odd' moon),
   Eq.subst (motive := fun b => turn swap b .moon = .moon) (congrArg (!·) odd').symm rfl⟩

/-- `Tide.still` has no arising. Named by `flip`, which breaks the moon's continuing
activity, it meets every premise of `Unceasing.activeRenewer_recurs`: activity needs
support, every rise is made by the renewing moon, the tide changes at every step at which
a formation arises, and generation is unceasing. The conclusion, that renewal recurs, is
true; the generation is the naming's. -/
theorem naming_meets_premises :
    (∀ t f, ¬ Tide.still.Arises t f) ∧ ¬ flip.KeepsActive Tide.still ∧
    flipped.Dependent ∧ flipped.RenewedBy renews ∧
    flipped.Depletes [()] (fun t => ∃ x, flipped.Arises t x) ∧ flipped.Unceasing ∧
    ∀ T, ¬ ∀ t, T ≤ t → ∀ x, ¬ flipped.ActiveRenewer renews [()] t x :=
  have made : flipped.RenewedBy renews := fun t _ _ =>
    ⟨flip.new t .moon, flip.old_new t .moon,
     Eq.subst (motive := fun f => Tide.renews t f ()) (flip.old_new t .moon).symm trivial⟩
  have depletes : flipped.Depletes [()] fun t => ∃ x, flipped.Arises t x :=
    (Web.depletes_iff flipped [()] _).mpr fun t _ => ⟨(), .head [], tide_changes t⟩
  have unceasing : flipped.Unceasing := fun N => match h : odd N with
    | true => ⟨N, .moon, Nat.le_refl N, arises N h⟩
    | false => ⟨N + 1, .moon, Nat.le_succ N, arises (N + 1) (congrArg (!·) h)⟩
  ⟨Tide.renewal_without_arising.2.2.2,
   fun keeps => Formation.noConfusion (keeps 0 .moon rfl rfl),
   (Tide.still.reidentify_dependent flip).mpr fun _ _ _ _ depends => (nomatch depends),
   made, depletes, unceasing,
   Web.Unceasing.activeRenewer_recurs flipped made depletes unceasing⟩

end TideFlip

/-- In the expansion every premise of `More.unceasing_reidentified` holds
(`Expansion.counted`), so its generation is unceasing under every re-identification. -/
theorem Expansion.unceasing_reidentified (σ : Reidentify (Expansion.Kind × Nat) F') :
    (Expansion.web.reidentify σ).Unceasing :=
  have : ∀ t f, Decidable (Expansion.web.active t f) := fun t f => Nat.decLt f.2 t
  Flow.More.unceasing_reidentified Expansion.census Expansion.distinct Expansion.growers_take.1
    Expansion.counted.2.2.2 σ

namespace Budding

/-- Every formation continues itself, and every formation continues formation `0`: new
formations bud from it. -/
def buds (_ : Nat) (g f : Nat) : Prop := g = f ∨ g = 0

/-- In the cycle, every premise of `Flow.More.unceasing` holds (`Cycle.counted`) and
generation is unceasing. Read with budding as continuation, formation `0` continues as
many, and nothing arises after the first step. -/
theorem growth_without_arising :
    Cycle.web.Unceasing ∧ ¬ Cycle.web.NoSplit buds ∧
    (∀ t, 1 ≤ t → ∀ f, ¬ Cycle.web.ArisesFrom buds t f) ∧ ¬ Cycle.web.UnceasingFrom buds :=
  have budded : ∀ t, 1 ≤ t → ∀ f, ¬ Cycle.web.ArisesFrom buds t f :=
    fun _ late _ ⟨_, continues⟩ => continues ⟨0, late, .inr rfl⟩
  ⟨Cycle.closed_more.2.2.2.2.2.1,
   fun noSplit => Nat.noConfusion (noSplit 1 0 0 1 Nat.zero_lt_one (.inl rfl) (.inr rfl)
     (Nat.zero_lt_succ 1) (Nat.lt_succ_self 1)),
   budded,
   fun unceasing => match unceasing 1 with
    | ⟨t, f, late, arises⟩ => budded t late f arises⟩

end Budding

namespace Identity.Fork

/-- Each formation continues itself; at step one formation `0` also continues as
formation `1`. -/
def forks (t g f : Nat) : Prop :=
  g = f ∨ (t = 1 ∧ g = 0 ∧ f = 1)

/-- In the cycle, formation `0` continues as two at step one, so `NoSplit` fails, and
formations still arise under the continuation at arbitrarily late steps: `NoSplit` is
sufficient for `Flow.More.unceasingFrom`, not necessary for its conclusion. -/
theorem split_unceasing : ¬ Cycle.web.NoSplit forks ∧ Cycle.web.UnceasingFrom forks :=
  ⟨fun noSplit =>
      have split : (0 : Nat) = 1 := noSplit 1 0 0 1 Nat.zero_lt_one (.inl rfl)
        (.inr ⟨rfl, rfl, rfl⟩) (Nat.zero_lt_succ 1) (Nat.lt_succ_self 1)
      Nat.lt_irrefl 0 (Eq.subst (motive := fun k => 0 < k) split.symm Nat.zero_lt_one),
   fun N => ⟨N + 2, N + 2, Nat.le_add_right N 2, Nat.lt_succ_self (N + 2),
     fun ⟨_, active, continues⟩ => match continues with
      | .inl same => Nat.lt_irrefl (N + 2)
          (Eq.subst (motive := fun h => h < N + 2) same active)
      | .inr ⟨one, _, _⟩ => Nat.lt_irrefl 1
          (Eq.subst (motive := fun k => 1 < k) one (Nat.succ_lt_succ (Nat.zero_lt_succ N)))⟩⟩

end Identity.Fork

namespace Merge

open Expansion (Kind)

/-- The `i`th renewer and the `i`th grower of the expansion both continue as the `i`th
renewer. -/
def merges (_ : Nat) (g f : Kind × Nat) : Prop :=
  f = (.renewer, g.2)

instance decideMerges (t : Nat) : ∀ g f, Decidable (merges t g f)
  | _, (.grower, _) => isFalse fun same => Kind.noConfusion (congrArg Prod.fst same)
  | (_, j), (.renewer, i) => match Nat.decEq i j with
    | isTrue same =>
      isTrue (congrArg (Prod.mk Kind.renewer) same : (Kind.renewer, i) = (.renewer, j))
    | isFalse other => isFalse fun same => other (congrArg Prod.snd same)

theorem noSplit : Expansion.web.NoSplit merges :=
  fun _ _ _ _ _ same same' _ _ => same.trans same'.symm

/-- Two formations active at step one continue as one after it, so the continuation
merges, and with no split and the expansion's census every premise of
`Flow.More.unceasingFrom` holds under it. The conclusion is met idly (`idle`). -/
theorem merging :
    Expansion.web.active 1 (.renewer, 0) ∧ Expansion.web.active 1 (.grower, 0) ∧
    merges 1 (.renewer, 0) (.renewer, 0) ∧ merges 1 (.grower, 0) (.renewer, 0) ∧
    Expansion.web.active 2 (.renewer, 0) ∧ (Kind.renewer, 0) ≠ (Kind.grower, 0) ∧
    Expansion.web.UnceasingFrom merges :=
  have := Expansion.census.decideContinues (R := merges)
  ⟨Nat.zero_lt_one, Nat.zero_lt_one, rfl, rfl, Nat.zero_lt_succ 1,
   fun same => Kind.noConfusion (congrArg Prod.fst same),
   Flow.More.unceasingFrom Expansion.census Expansion.distinct Expansion.growers_take.1
     Expansion.counted.2.2.2 noSplit⟩

/-- No formation continues as a grower, so the first grower, active from step one on,
arises under the merge across every step, and formations arise under it at arbitrarily
late steps without `More`. Under each formation continuing only itself, the same grower
arises only across step zero. -/
theorem idle :
    (∀ N, Expansion.web.ArisesFrom merges N (.grower, 0)) ∧ Expansion.web.UnceasingFrom merges ∧
    ∀ N, ¬ Expansion.web.Arises (N + 1) (.grower, 0) :=
  have idle : ∀ N, Expansion.web.ArisesFrom merges N (.grower, 0) := fun N =>
    ⟨Nat.succ_pos N, fun ⟨_, _, same⟩ => Kind.noConfusion (congrArg Prod.fst same)⟩
  ⟨idle, fun N => ⟨N, (.grower, 0), Nat.le_refl N, idle N⟩,
   fun N arises => arises.1 (Nat.succ_pos N)⟩

end Merge

namespace Confluence

/-- Two formations that merge, and one new formation for each step. -/
inductive Formation where
  | a
  | b
  | new (n : Nat)

/-- `a` is active at step zero only, `b` at every step, the `n`th new formation from step
`n + 1` on. -/
def web : Web Formation Unit where
  level _ _ := 0
  active t f := match f with
    | .a => t = 0
    | .b => True
    | .new n => n < t
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- Each formation continues itself, and across step zero `a` also continues as `b`. -/
def continues (t : Nat) (g f : Formation) : Prop :=
  g = f ∨ (t = 0 ∧ g = .a ∧ f = .b)

/-- `a` is not active after step zero. -/
theorem ended (t : Nat) : ¬ web.active (t + 1) .a := fun same => Nat.noConfusion same

theorem noSplit : web.NoSplit continues :=
  fun t _ _ _ _ r r' after after' => match r, r' with
  | .inl same, .inl same' => same.symm.trans same'
  | .inr ⟨_, _, isB⟩, .inr ⟨_, _, isB'⟩ => isB.trans isB'.symm
  | .inl same, .inr ⟨_, isA, _⟩ => absurd (Eq.subst (motive := fun h => web.active (t + 1) h)
      (same.symm.trans isA) after) (ended t)
  | .inr ⟨_, isA, _⟩, .inl same' => absurd (Eq.subst (motive := fun h => web.active (t + 1) h)
      (same'.symm.trans isA) after') (ended t)

/-- Two formations active at step zero continue as one, without a split, and the merged
formation `a` is not active after it; every formation arising under the continuation is
the new formation of its step, and one arises at every step. -/
theorem confluence :
    web.active 0 .a ∧ web.active 0 .b ∧ Formation.a ≠ .b ∧ continues 0 .a .b ∧
    continues 0 .b .b ∧ web.active 1 .b ∧ ¬ web.active 1 .a ∧ web.NoSplit continues ∧
    (∀ t f, web.ArisesFrom continues t f → f = .new t) ∧ web.UnceasingFrom continues :=
  ⟨rfl, trivial, fun same => Formation.noConfusion same, .inr ⟨rfl, rfl, rfl⟩, .inl rfl,
   trivial, ended 0, noSplit,
   fun t f ⟨after, alone⟩ => match f, after with
    | .a, after => absurd after (ended t)
    | .b, _ => absurd ⟨.b, trivial, .inl rfl⟩ alone
    | .new n, after => congrArg Formation.new (Nat.le_antisymm (Nat.le_of_lt_succ after)
        (Nat.ge_of_not_lt fun before => alone ⟨.new n, before, .inl rfl⟩)),
   fun N => ⟨N, .new N, Nat.le_refl N, Nat.lt_succ_self N, fun ⟨_, active, r⟩ => match r with
    | .inl same => Nat.lt_irrefl N
        (Eq.subst (motive := fun h => web.active N h) same active)
    | .inr ⟨_, _, isB⟩ => Formation.noConfusion isB⟩⟩

end Confluence

/-- Without a census, no split is not enough: in `Dormant`, under each formation continuing
only itself there is no split, only active formations take, each formation taking part is
listed once, and generation is more without end, yet nothing arises under it. -/
theorem Dormant.no_split_without_arising :
    Dormant.web.NoSplit (fun _ g f => g = f) ∧ Expansion.flow.More [()] ∧
    Expansion.flow.Taking Dormant.web ∧ (∀ t, Distinct (Expansion.flow.present t)) ∧
    ¬ Dormant.web.UnceasingFrom (fun _ g f => g = f) :=
  ⟨fun _ _ _ _ _ same same' _ _ => same.symm.trans same',
   Dormant.more_without_arising.2.2.2.2.2.1, Dormant.more_without_arising.2.2.1,
   Expansion.distinct,
   fun unceasing => match (Dormant.web.unceasingFrom_self.mp unceasing) 0 with
    | ⟨t, f, _, arises⟩ => Dormant.more_without_arising.2.2.2.2.2.2 t f arises⟩

namespace Tandem

/-- Formations `t` and `t + 1` are active at step `t`. -/
def web : Web Nat Unit where
  level _ _ := 0
  active t n := n = t ∨ n = t + 1
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

def alive (t : Nat) : List Nat := [t, t + 1]

theorem apart {t k : Nat} (pos : 0 < k) (same : t + k = t) : False :=
  Nat.lt_irrefl t (Eq.subst (motive := fun m => t < m) same (Nat.lt_add_of_pos_right pos))

theorem census : web.Census alive := fun t =>
  ⟨⟨fun mem => (match mem_cons_cases mem with
      | .inl same => apart Nat.zero_lt_one same.symm
      | .inr nothing => nomatch nothing), (fun nothing => nomatch nothing), trivial⟩,
   fun _ => ⟨fun active => match active with
      | .inl same => Eq.subst (motive := fun k => k ∈ alive t) same.symm (.head _)
      | .inr same => Eq.subst (motive := fun k => k ∈ alive t) same.symm (.tail _ (.head _)),
    fun mem => match mem_cons_cases mem with
      | .inl same => .inl same
      | .inr mem => match mem_cons_cases mem with
        | .inl same => .inr same
        | .inr nothing => nomatch nothing⟩⟩

/-- Read with each formation continuing only itself, one formation arises and one ceases
across every step. -/
theorem kept (t : Nat) : web.Arises t (t + 2) ∧ web.Ceases t t :=
  ⟨⟨fun active => match active with
      | .inl same => apart (Nat.zero_lt_succ 1) same
      | .inr same => apart (t := t + 1) Nat.zero_lt_one same, .inr rfl⟩,
   .inl rfl, fun active => match active with
      | .inl same => apart Nat.zero_lt_one same.symm
      | .inr same => apart (Nat.zero_lt_succ 1) same.symm⟩

/-- The later formation continues as itself and as the formation arising across the step;
the earlier continues as none. -/
def buds (t g f : Nat) : Prop := g = t + 1 ∧ (f = t + 1 ∨ f = t + 2)

/-- Read as budding, the later formation continues as two across every step, the earlier
ceases, and nothing arises: under a census, ceasing recurs without arising. Without
`NoSplit`, the census law under a continuation fails
(`Census.arisingFrom_of_ceasingFrom`). -/
theorem budding :
    web.Census alive ∧ ¬ web.NoSplit buds ∧ web.NoMerge buds ∧
    (∀ t, web.CeasesFrom buds t t) ∧ ¬ web.UnceasingFrom buds :=
  have still : ∀ t f, ¬ web.ArisesFrom buds t f := fun t _ ⟨active, alone⟩ =>
    alone ⟨t + 1, .inr rfl, rfl, active⟩
  ⟨census,
   fun noSplit => apart (t := 1) Nat.zero_lt_one
     (noSplit 0 1 1 2 (.inr rfl) ⟨rfl, .inl rfl⟩ ⟨rfl, .inr rfl⟩ (.inl rfl) (.inr rfl)).symm,
   fun _ _ _ _ _ _ continues continues' _ => continues.1.trans continues'.1.symm,
   fun _ => ⟨.inl rfl, fun ⟨_, _, same, _⟩ => apart Nat.zero_lt_one same.symm⟩,
   fun unceasing => match unceasing 0 with
    | ⟨t, f, _, arises⟩ => still t f arises⟩

/-- Both formations continue as the later one; the formation arising across the step
continues none. -/
def joins (t g f : Nat) : Prop := f = t + 1 ∧ (g = t ∨ g = t + 1)

/-- Read as joining, both formations continue as one across every step, a formation arises,
and nothing ceases: with at most two active at each step, arising recurs without ceasing.
Without `NoMerge`, the bounded law under a continuation fails
(`Census.ceasingFrom_of_arisingFrom`). -/
theorem joining :
    (∀ t, (alive t).length ≤ 2) ∧ web.NoSplit joins ∧ ¬ web.NoMerge joins ∧
    (∀ t, web.ArisesFrom joins t (t + 2)) ∧ ∀ t g, ¬ web.CeasesFrom joins t g :=
  ⟨fun _ => Nat.le_refl 2,
   fun _ _ _ _ _ continues continues' _ _ => continues.1.trans continues'.1.symm,
   fun noMerge => apart (t := 0) Nat.zero_lt_one
     (noMerge 0 0 1 1 (.inl rfl) (.inr rfl) ⟨rfl, .inl rfl⟩ ⟨rfl, .inr rfl⟩ (.inl rfl)).symm,
   fun t => ⟨.inr rfl, fun ⟨_, _, same, _⟩ => apart (t := t + 1) Nat.zero_lt_one same⟩,
   fun t _ ⟨active, alone⟩ => alone ⟨t + 1, .inl rfl, rfl, active⟩⟩

end Tandem

namespace Lineage

/-- Two members of a lineage. -/
inductive Member where
  | first
  | second

/-- The first member is active at even steps and the second at odd steps; neither
depends on or draws anything. -/
def web : Web Member Unit where
  level _ _ := 0
  active t m := match m with
    | .first => odd t = false
    | .second => odd t = true
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

def swap : Member → Member
  | .first => .second
  | .second => .first

theorem swap_swap : ∀ m, swap (swap m) = m
  | .first | .second => rfl

/-- One name for the lineage: at odd steps the members exchange names. -/
def one : Reidentify Member Member := .exchanging odd swap swap_swap

theorem arises : ∀ t, odd t = true → web.Arises t .first := fun _ odd' =>
  ⟨fun even => (nomatch odd'.symm.trans even), congrArg (!·) odd'⟩

/-- Named apart, a member arises at every odd step and generation is unceasing. Named as
one, the lineage is always active and nothing arises. Naming it as one keeps every
continuing activity, since no member is active at two successive steps. -/
theorem readings :
    one.KeepsActive web ∧ web.Unceasing ∧ ¬ (web.reidentify one).Unceasing :=
  have always : ∀ t, (web.reidentify one).active t .first := fun t =>
    show web.active t (turn swap (odd t) .first) from match h : odd t with
      | true => h
      | false => h
  have never : ∀ t, ¬ (web.reidentify one).active t .second := fun t =>
    show web.active t (turn swap (odd t) .second) → False from match h : odd t with
      | true => fun first => nomatch h.symm.trans first
      | false => fun second => nomatch h.symm.trans second
  ⟨fun _ m now next => match m, now, next with
    | .first, now, next => nomatch (congrArg (!·) now).symm.trans next
    | .second, now, next => (nomatch (congrArg (!·) now).symm.trans next),
   fun N => match h : odd N with
    | true => ⟨N, .first, Nat.le_refl N, arises N h⟩
    | false => ⟨N + 1, .first, Nat.le_succ N, arises (N + 1) (congrArg (!·) h)⟩,
   fun unceasing => match unceasing 0 with
    | ⟨t, m, _, inactive, active⟩ => match m, inactive, active with
      | .first, inactive, _ => inactive (always t)
      | .second, _, active => never (t + 1) active⟩

/-- Naming the lineage as one keeps the apart naming's continuing activity, and makes a
continuity of activity the apart naming lacks. -/
theorem one_way : one.KeepsActive web ∧ ¬ one.back.KeepsActive (web.reidentify one) :=
  ⟨readings.1, fun kept => readings.2.2
    ((Web.unceasing_iff_of_keepsActive_both readings.1 kept).mpr readings.2.1)⟩

end Lineage

namespace Layered

/-- The two members of `Lineage`, and the lineage itself. -/
inductive Level where
  | first
  | second
  | lineage

/-- `Lineage.web` with the lineage named as a formation beside its members, active at
every step. No relation of the web says that the lineage is constituted by its members;
that part–whole relation is what a single level of naming omits. -/
def web : Web Level Unit where
  level _ _ := 0
  active t w := match w with
    | .first => odd t = false
    | .second => odd t = true
    | .lineage => True
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- The members arise without end while the lineage is active at every step, as some
member is. -/
theorem both :
    web.Unceasing ∧ ∀ t, web.active t .lineage ∧ (web.active t .first ∨ web.active t .second) :=
  have arises : ∀ t, odd t = true → web.Arises t .first := fun _ odd' =>
    ⟨fun even => (nomatch odd'.symm.trans even), congrArg (!·) odd'⟩
  ⟨fun N => match h : odd N with
    | true => ⟨N, .first, Nat.le_refl N, arises N h⟩
    | false => ⟨N + 1, .first, Nat.le_succ N, arises (N + 1) (congrArg (!·) h)⟩,
   fun t => ⟨trivial, match h : odd t with
    | true => .inr h
    | false => .inl h⟩⟩

end Layered

namespace Succession

/-- A drawer, a predecessor that needs the pool at the first step, and a successor that needs it
from the second step on. -/
inductive Formation where
  | drawer
  | predecessor
  | successor

/-- The pool of `Turnover`: two units, then one. The predecessor needs two units at the first
step, where it is active and supported. The successor needs one unit at the second step,
where it is active and supported, and two from the third step on. -/
def web : Web Formation Unit where
  level t _ := Turnover.pool t
  active t f := match f with
    | .drawer => True
    | .predecessor => t = 0
    | .successor => t = 1
  requires t f _ := match f with
    | .drawer => False
    | .predecessor => t = 0
    | .successor => 1 ≤ t
  need t f _ := match f with
    | .drawer => 0
    | .predecessor => 2
    | .successor => match t with
      | 1 => 1
      | _ => 2
  draws _ f _ := match f with
    | .drawer => True
    | .predecessor | .successor => False

def swap : Formation → Formation
  | .drawer => .drawer
  | .predecessor => .successor
  | .successor => .predecessor

theorem swap_swap : ∀ f, swap (swap f) = f
  | .drawer | .predecessor | .successor => rfl

/-- The successor succeeds the predecessor: from the second step on, it bears the
predecessor's name. -/
def succeeds : Reidentify Formation Formation := .exchanging afterFirst swap swap_swap

/-- The re-identified web. -/
abbrev inherited : Web Formation Unit := web.reidentify succeeds

theorem drawer_named (t : Nat) : turn swap (afterFirst t) .drawer = .drawer :=
  turn_fixed rfl (afterFirst t)

/-- Activity needs support, and the successor lives at the second step. Succession keeps
every continuing activity and dependence. Named apart, the drawer undermines at the first
step, where it breaks the predecessor's dependence, and at no later step: the successor's
need was never met above the pool's later level while its dependence held. With the
successor succeeding the predecessor, the predecessor's tenure continues in the successor,
and the drawer undermines at every step from the third. -/
theorem readings :
    web.Dependent ∧ web.active 1 .successor ∧ succeeds.KeepsActive web ∧
    succeeds.KeepsTenure web ∧ web.UnderminingAt 0 .drawer ∧
    (∀ t, 1 ≤ t → ¬ web.UnderminingAt t .drawer) ∧
    ∀ t, 2 ≤ t → inherited.UnderminingAt t .drawer :=
  ⟨fun t f active _ depends => match f, t, active, depends with
    | .drawer, _, _, h => (nomatch h)
    | .predecessor, 0, _, _ => Nat.le_refl 2
    | .predecessor, _ + 1, h, _ => Nat.noConfusion h
    | .successor, 1, _, _ => Nat.le_refl 1
    | .successor, 0, h, _ => Nat.noConfusion h
    | .successor, _ + 2, h, _ => Nat.noConfusion (Nat.succ.inj h),
   rfl,
   fun t f now next => match f, now, next with
    | .drawer, _, _ => (drawer_named (t + 1)).trans (drawer_named t).symm
    | .predecessor, _, next => Nat.noConfusion next
    | .successor, now, next => Nat.noConfusion ((Nat.succ.inj next).symm.trans now),
   fun t g _ now next => match g, t, now, next with
    | .drawer, _, h, _ => (nomatch h)
    | .predecessor, _, _, next => Nat.noConfusion next
    | .successor, _ + 1, _, _ => rfl
    | .successor, 0, now, _ => absurd now (Nat.not_succ_le_zero 0),
   ⟨(), trivial, .predecessor, rfl, .now rfl (Nat.le_refl 2) (Nat.lt_succ_self 1),
    Nat.lt_succ_self 1⟩,
   fun t late ⟨_, _, g, depends, ⟨s, before, held, met, above⟩, _⟩ =>
    match g, depends, held, met, above with
    | .drawer, h, _, _, _ => (nomatch h)
    | .predecessor, h, _, _, _ =>
      Nat.not_succ_le_zero 0 (Eq.subst (motive := fun n => 1 ≤ n) h late)
    | .successor, _, held, met, above =>
      have above_one : 1 < web.need s .successor () := Nat.lt_of_le_of_lt
        (Nat.le_of_eq (Turnover.pool_late (Nat.succ_le_succ (Nat.zero_le t))).symm) above
      have at_most_one : web.need s .successor () ≤ 1 :=
        Nat.le_trans met (Nat.le_of_eq (Turnover.pool_late (held s (Nat.le_refl s) before)))
      Nat.lt_irrefl 1 (Nat.lt_of_lt_of_le above_one at_most_one),
   fun t late => match t, late with
    | m + 2, _ => ⟨(), trivial, .predecessor, Nat.succ_le_succ (Nat.zero_le (m + 1)),
        ⟨0, Nat.zero_le _, fun u _ _ => match u with
          | 0 => rfl
          | v + 1 => Nat.succ_le_succ (Nat.zero_le v),
         Nat.le_refl 2, Nat.lt_succ_self 1⟩,
        Nat.lt_succ_self 1⟩
    | 0, h => absurd h (Nat.not_succ_le_zero 1)
    | 1, h => absurd h (Nat.not_succ_le_self 1)⟩

/-- Succession keeps the apart naming's continuing dependences, and makes a continuity of
dependence the apart naming lacks. -/
theorem one_way : succeeds.KeepsTenure web ∧ ¬ succeeds.back.KeepsTenure inherited :=
  ⟨readings.2.2.2.1, fun kept =>
    readings.2.2.2.2.2.1 2 (Nat.le_succ 1)
      (Eq.subst (motive := fun f => web.UnderminingAt 2 f) (drawer_named 2)
        (Web.undermining_of_back_keepsTenure kept (readings.2.2.2.2.2.2 2 (Nat.le_refl 2))))⟩

end Succession

namespace Dormancy

/-- An early formation, a late one, and one that needs the pool. -/
inductive Formation where
  | early
  | late
  | consumer

/-- A spring and a pool. -/
inductive Condition where
  | spring
  | pool

/-- The spring holds one unit, and the pool is `Turnover`'s: two units, then one. The early
formation is active at the first step only, needs one unit of the spring then, and draws
it. The late formation is active at the third step only and draws the pool. The consumer
formation needs two units of the pool at the first step, where the pool supports it. No
formation is active, or depends on anything, at two successive steps. -/
def web : Web Formation Condition where
  level t c := match c with
    | .spring => 1
    | .pool => Turnover.pool t
  active t f := match f with
    | .early | .consumer => t = 0
    | .late => t = 2
  requires t f c := match f, c with
    | .early, .spring => t = 0
    | .consumer, .pool => t = 0
    | .early, .pool | .consumer, .spring | .late, _ => False
  need _ f _ := match f with
    | .early => 1
    | .late => 0
    | .consumer => 2
  draws t f c := match f, c with
    | .early, .spring => t = 0
    | .late, .pool => t = 2
    | .early, .pool | .late, .spring | .consumer, _ => False

def swap : Formation → Formation
  | .early => .late
  | .late => .early
  | .consumer => .consumer

theorem swap_swap : ∀ f, swap (swap f) = f
  | .early | .late | .consumer => rfl

/-- From the second step on, the late formation bears the early one's name: the two are
joined across the dormant second step. -/
def join : Reidentify Formation Formation := .exchanging afterFirst swap swap_swap

/-- The joined web. -/
abbrev joined : Web Formation Condition := web.reidentify join

/-- Every dependence holds at the first step only. -/
theorem first_only : ∀ t f c, web.requires t f c → t = 0
  | _, .early, .spring, h | _, .consumer, .pool, h => h
  | _, .early, .pool, h | _, .consumer, .spring, h | _, .late, _, h => nomatch h

theorem active_once : ∀ t f, web.active t f → ¬ web.active (t + 1) f
  | _, .early, _, next | _, .consumer, _, next => Nat.noConfusion next
  | _, .late, now, next => Nat.lt_irrefl 2 (Eq.subst (motive := (2 < ·))
      (Eq.subst (motive := fun n => n + 1 = 2) now next) (Nat.lt_succ_self 2))

theorem joined_once : ∀ t x, joined.active t x → ¬ joined.active (t + 1) x
  | 0, .early, _, next => Nat.lt_irrefl 1 (Eq.subst (motive := (1 < ·)) next.symm
      (Nat.lt_succ_self 1))
  | 0, .late, now, _ => Nat.noConfusion now
  | 0, .consumer, _, next => Nat.noConfusion next
  | t + 1, x, now, next => active_once (t + 1) (swap x) now next

theorem dependent : web.Dependent := fun t f _ c depends =>
  match f, c, t, depends with
  | .consumer, .pool, 0, _ => Nat.le_refl 2
  | .early, .spring, 0, _ => Nat.le_refl 1
  | .consumer, .pool, _ + 1, h | .early, .spring, _ + 1, h => Nat.noConfusion h
  | .consumer, .spring, _, h | .early, .pool, _, h | .late, _, _, h => (nomatch h)

/-- The join keeps every continuing activity and dependence, read in both namings: no
formation is active, or depends on anything, at two successive steps under either. -/
theorem keeps_both :
    join.KeepsActive web ∧ join.back.KeepsActive joined ∧
    join.KeepsTenure web ∧ join.back.KeepsTenure joined :=
  ⟨fun t f now next => (active_once t f now next).elim,
   fun t x now next => (joined_once t x now next).elim,
   fun t g c _ next => Nat.noConfusion (first_only (t + 1) g c next),
   fun t _ c _ next => Nat.noConfusion (first_only (t + 1) _ c next)⟩

theorem consumed : web.Consumed .pool :=
  ⟨.consumer, 0, rfl, fun t after => match t, after with
    | _ + 1, _ => Nat.lt_succ_self 1
    | 0, h => absurd h (Nat.lt_irrefl 0)⟩

/-- Named apart, the early formation renews in the run, its spring keeping it, and the
late one consumes. Joined across the dormant step, with continuity kept in both namings,
the formation named early consumes and does not renew. -/
theorem classes :
    web.RenewingIn .early ∧ web.ConsumingIn .late ∧
    joined.ConsumingIn .early ∧ ¬ joined.RenewingIn .early :=
  ⟨fun _ c joins => match c, joins with
    | .spring, _ => fun _ g depends => match g, depends with
      | .early, _ => ⟨Nat.le_refl 1, Nat.le_refl 1⟩
      | .consumer, h | .late, h => (nomatch h)
    | .pool, .inl h | .pool, .inr h => (nomatch h),
   ⟨2, .pool, rfl, consumed⟩,
   ⟨2, .pool, rfl, (web.reidentify_consumed join .pool).mpr consumed⟩,
   fun renewing => Nat.not_succ_le_self 1
     (((web.reidentify_renewed join .pool).mp (renewing 2 .pool (.inr rfl))) 0 .consumer rfl).2⟩

end Dormancy

/-! ## The grammar's reading of identity across steps

`Becoming.Grammar` states continuation (续) for every carrier and every relation. Here the carrier
is the occurrences of formations, pairs `(t, f)` of a step and a formation. 缘 is one step of a
continuation `R` (`Web.continuationStep R`: `(t, g)` is a condition of `(t + 1, f)` where
`R t g f`), the relation this module already reads splits and merges with. The class is activity
(`Web.activityClass W`: two occurrences are alike when both are active or neither is), as the
flame's class is "flame or not". Nothing else is supplied.

* **Positions.** Before an active occurrence, a 续 under activity is a formation active before
  the step that `R` continues as it (`hasPred_iff_continues`); after an active occurrence, a
  formation active after the step continuing it (`hasSucc_iff_continued`). So arising under a
  continuation is beginning (生) of an active occurrence (`arisesFrom_iff_sheng`), ceasing under
  it is ending (亡) (`ceasesFrom_iff_wang`), and an occurrence continuing one and continued by one
  abides (住) (`abides_iff`); arising and ceasing as named are the case of each formation
  continuing only itself (`arises_iff_sheng_itself`, `ceases_iff_wang_itself`). Every occurrence at step `0`
  begins (`begins_at_zero`).
* **Identity is not given by the occurrences.** Under identity (`«静»`) no occurrence continues
  another (`nothing_continues_under_identity`), and an occurrence with a condition and a
  consequence abides under the one while it begins and ends under identity
  (`positions_not_self_standing`, from `«四相无自立»`): which formation at one step is the same as
  which at the next is supplied by a class, which is this module's finding read in the grammar.
* **Lines are orders of precedence.** Continuation steps advance the step index
  (`reach_advances`), so `continuationStep R` has no cycle (`continuationStep_acyclic`) and its
  reach is a strict order (`reach_strict_order`, from `«无环则及为序»`). A lineage (`Lineage`) is
  exactly a line (相续) under activity from an active occurrence (`lineage_iff_line`).
* **Splits and merges.** `NoSplit` says that an active occurrence is continued by at most one
  (`noSplit_iff`), `NoMerge` that an active occurrence continues at most one (`noMerge_iff`). A
  split is a fission (分叉): two occurrences in lines from one, neither in a line from the other,
  in one family (同族) (`split_fission`), as in `Identity.Fork` and in `Tandem`'s budding
  (`Identity.Fork.fission`, `Tandem.budding_fission`). A merge is the two candles (蜡烛之合)
  (`merge_candles`, `Tandem.joining_candles`).
* **Derived from a grammar law.** A formation active at a step and continued by nothing at all
  under `R` ceases under `R` (`ceasesFrom_of_unconditioned`), from `«亡于粗则亡于细»`: activity is
  finer than the one.
-/

namespace Web

/-- 缘 read off a continuation `R`: the occurrence `(t, g)` is a condition of `(u, f)` when `u` is
the step after `t` and `R t g f`. -/
def continuationStep (R : Nat → F → F → Prop) : «际» (Nat × F) :=
  fun x y => y.1 = x.1 + 1 ∧ R x.1 x.2 y.2

/-- The class (类) of a property: two occurrences are alike when both have it or neither does. -/
def alikeBy {α : Type} (P : α → Prop) : «际» α := fun x y => P x ↔ P y

theorem alikeBy_class {α : Type} (P : α → Prop) : «类» (alikeBy P) :=
  ⟨fun _ => Iff.rfl, Iff.symm, Iff.trans⟩



/-- Two occurrences with the same step and the same formation are one. -/
theorem occurrence_eq : ∀ {x y : Nat × F}, x.1 = y.1 → x.2 = y.2 → x = y
  | (_, _), (_, _), rfl, rfl => rfl

variable {W : Web F C} {R : Nat → F → F → Prop}

/-- **Before an active occurrence (有前).** A 续 under activity into `(t + 1, f)` is a formation
active at `t` that `R` continues as `f`. -/
theorem hasPred_iff_continues {t : Nat} {f : F} (after : W.active (t + 1) f) :
    «有前» (continuationStep R) W.activityClass (t + 1, f) ↔ W.Continues R t f :=
  ⟨fun ⟨x, ⟨next, r⟩, alike⟩ =>
     have same : t = x.1 := Nat.succ.inj next
     ⟨x.2, Eq.subst (motive := fun s => W.active s x.2) same.symm (alike.mpr after),
      Eq.subst (motive := fun s => R s x.2 f) same.symm r⟩,
   fun ⟨g, before, r⟩ => ⟨(t, g), ⟨rfl, r⟩, ⟨fun _ => after, fun _ => before⟩⟩⟩

/-- **After an active occurrence (有后).** A 续 under activity out of `(t, g)` is a formation
active at `t + 1` continuing `g`. -/
theorem hasSucc_iff_continued {t : Nat} {g : F} (before : W.active t g) :
    «有后» (continuationStep R) W.activityClass (t, g) ↔ W.Continued R t g :=
  ⟨fun ⟨y, ⟨next, r⟩, alike⟩ =>
     ⟨y.2, Eq.subst (motive := fun s => W.active s y.2) next (alike.mp before), r⟩,
   fun ⟨f, after, r⟩ => ⟨(t + 1, f), ⟨rfl, r⟩, ⟨fun _ => after, fun _ => before⟩⟩⟩

/-- Every occurrence at step `0` begins (生), under every class: nothing precedes the first
step. -/
theorem begins_at_zero (E : «际» (Nat × F)) (f : F) : «生» (continuationStep R) E (0, f) :=
  fun ⟨_, ⟨next, _⟩, _⟩ => Nat.noConfusion next

/-- **Arising under a continuation is beginning (生)** of an active occurrence. -/
theorem arisesFrom_iff_sheng {t : Nat} {f : F} :
    W.ArisesFrom R t f ↔
      W.active (t + 1) f ∧ «生» (continuationStep R) W.activityClass (t + 1, f) :=
  ⟨fun ⟨after, alone⟩ => ⟨after, fun pred => alone ((hasPred_iff_continues after).mp pred)⟩,
   fun ⟨after, begins⟩ => ⟨after, fun cont => begins ((hasPred_iff_continues after).mpr cont)⟩⟩

/-- **Ceasing under a continuation is ending (亡)** of an active occurrence. -/
theorem ceasesFrom_iff_wang {t : Nat} {g : F} :
    W.CeasesFrom R t g ↔ W.active t g ∧ «亡» (continuationStep R) W.activityClass (t, g) :=
  ⟨fun ⟨before, alone⟩ => ⟨before, fun succ => alone ((hasSucc_iff_continued before).mp succ)⟩,
   fun ⟨before, ends⟩ => ⟨before, fun cont => ends ((hasSucc_iff_continued before).mpr cont)⟩⟩

/-- **Abiding (住).** An active occurrence after a step abides exactly where it continues a
formation active before the step and is continued by one active after the next. -/
theorem abides_iff {t : Nat} {f : F} (after : W.active (t + 1) f) :
    «住» (continuationStep R) W.activityClass (t + 1, f) ↔
      W.Continues R t f ∧ W.Continued R (t + 1) f :=
  ⟨fun ⟨pred, succ⟩ =>
     ⟨(hasPred_iff_continues after).mp pred, (hasSucc_iff_continued after).mp succ⟩,
   fun ⟨cont, contd⟩ =>
     ⟨(hasPred_iff_continues after).mpr cont, (hasSucc_iff_continued after).mpr contd⟩⟩

/-- **Arising as named is beginning (生)** where each formation continues only itself. -/
theorem arises_iff_sheng_itself {t : Nat} {f : F} :
    W.Arises t f ↔
      W.active (t + 1) f ∧ «生» (continuationStep fun _ g f => g = f) W.activityClass (t + 1, f) :=
  ⟨fun arises => arisesFrom_iff_sheng.mp ((W.arisesFrom_self t f).mpr arises),
   fun begins => (W.arisesFrom_self t f).mp (arisesFrom_iff_sheng.mpr begins)⟩

/-- **Ceasing as named is ending (亡)** where each formation continues only itself. -/
theorem ceases_iff_wang_itself {t : Nat} {g : F} :
    W.Ceases t g ↔
      W.active t g ∧ «亡» (continuationStep fun _ g f => g = f) W.activityClass (t, g) :=
  ⟨fun ceases => ceasesFrom_iff_wang.mp ((W.ceasesFrom_self t g).mpr ceases),
   fun ends => (W.ceasesFrom_self t g).mp (ceasesFrom_iff_wang.mpr ends)⟩

/-- **Derived from `«亡于粗则亡于细»`.** A formation active at a step and continued by nothing at
all under `R` ceases under `R`: it ends under the one, and activity is finer than the one. -/
theorem ceasesFrom_of_unconditioned {t : Nat} {g : F} (before : W.active t g)
    (none : ∀ f, ¬ R t g f) : W.CeasesFrom R t g :=
  ceasesFrom_iff_wang.mpr ⟨before,
    «亡于粗则亡于细» (continuationStep R) (E := W.activityClass) (E' := «一»)
      (fun _ _ _ => trivial) (fun ⟨_, ⟨_, r⟩, _⟩ => none _ r)⟩

/-- No continuation step relates an occurrence to itself. -/
theorem continuationStep_irrefl (x : Nat × F) : ¬ continuationStep R x x :=
  fun ⟨next, _⟩ => Nat.lt_irrefl x.1
    (Eq.subst (motive := fun s => x.1 < s) next.symm (Nat.lt_succ_self x.1))

/-- **Identity does not continue.** Under identity (`«静»`) no occurrence continues another:
which formation at one step is the same as which at the next is not given by the occurrences. -/
theorem nothing_continues_under_identity (x y : Nat × F) :
    ¬ «续» (continuationStep R) «静» x y :=
  fun ⟨step, same⟩ => continuationStep_irrefl (R := R) y
    (Eq.subst (motive := fun z => continuationStep R z y) same step)

/-- **No position stands by itself (`«四相无自立»`).** Where `g` continues as `f` across the step
from `t` and `f` as `h` across the next, the occurrence `(t + 1, f)` abides under the one and,
under identity, both begins and ends. -/
theorem positions_not_self_standing {t : Nat} {g f h : F} (r : R t g f) (r' : R (t + 1) f h) :
    «住» (continuationStep R) «一» (t + 1, f) ∧ «生» (continuationStep R) «静» (t + 1, f) ∧
      «亡» (continuationStep R) «静» (t + 1, f) :=
  «四相无自立» (y := (t + 1, f)) (x := (t, g)) (z := (t + 2, h)) continuationStep_irrefl
    ⟨rfl, r⟩ ⟨rfl, r'⟩

/-- Reach along continuation steps advances the step. -/
theorem reach_advances {x y : Nat × F} (h : «及» (continuationStep R) x y) : x.1 < y.1 := by
  induction h with
  | one h => exact Eq.subst (motive := fun s => _ < s) h.1.symm (Nat.lt_succ_self _)
  | more h _ ih =>
    exact Nat.lt_trans (Eq.subst (motive := fun s => _ < s) h.1.symm (Nat.lt_succ_self _)) ih

/-- A line (相续) under any class advances the step. -/
theorem line_advances {E : «际» (Nat × F)} {x y : Nat × F}
    (h : «相续» (continuationStep R) E x y) : x.1 < y.1 :=
  reach_advances («相续含于及» _ _ x y h)

/-- **No cycle (无环).** No occurrence reaches itself along continuation steps. -/
theorem continuationStep_acyclic : «无环» (continuationStep R) :=
  fun x h => Nat.lt_irrefl x.1 (reach_advances h)

/-- **Reach is an order of precedence**, from `«无环则及为序»`. -/
theorem reach_strict_order :
    (∀ x, ¬ «及» (continuationStep R) x x) ∧
      (∀ {x y z}, «及» (continuationStep R) x y → «及» (continuationStep R) y z →
        «及» (continuationStep R) x z) ∧
      (∀ {x y}, «及» (continuationStep R) x y → ¬ «及» (continuationStep R) y x) :=
  «无环则及为序» continuationStep_acyclic

/-- **No split, on occurrences.** `NoSplit` says exactly that an active occurrence is continued
(续) under activity by at most one occurrence. -/
theorem noSplit_iff :
    W.NoSplit R ↔ ∀ x y y' : Nat × F, W.active x.1 x.2 →
      «续» (continuationStep R) W.activityClass x y →
      «续» (continuationStep R) W.activityClass x y' → y = y' :=
  ⟨fun noSplit x y y' before ⟨⟨next, r⟩, alike⟩ ⟨⟨next', r'⟩, alike'⟩ =>
     occurrence_eq (next.trans next'.symm)
       (noSplit x.1 x.2 y.2 y'.2 before r r'
         (Eq.subst (motive := fun s => W.active s y.2) next (alike.mp before))
         (Eq.subst (motive := fun s => W.active s y'.2) next' (alike'.mp before))),
   fun one t g f f' before r r' after after' =>
     congrArg Prod.snd (one (t, g) (t + 1, f) (t + 1, f') before
       ⟨⟨rfl, r⟩, ⟨fun _ => after, fun _ => before⟩⟩
       ⟨⟨rfl, r'⟩, ⟨fun _ => after', fun _ => before⟩⟩)⟩

/-- **No merge, on occurrences.** `NoMerge` says exactly that an active occurrence continues (续)
under activity at most one occurrence. -/
theorem noMerge_iff :
    W.NoMerge R ↔ ∀ x x' y : Nat × F, W.active y.1 y.2 →
      «续» (continuationStep R) W.activityClass x y →
      «续» (continuationStep R) W.activityClass x' y → x = x' :=
  ⟨fun noMerge x x' y after ⟨⟨next, r⟩, alike⟩ ⟨⟨next', r'⟩, alike'⟩ =>
     have same : x.1 = x'.1 := Nat.succ.inj (next.symm.trans next')
     occurrence_eq same
       (noMerge x.1 x.2 x'.2 y.2 (alike.mpr after)
         (Eq.subst (motive := fun s => W.active s x'.2) same.symm (alike'.mpr after)) r
         (Eq.subst (motive := fun s => R s x'.2 y.2) same.symm r')
         (Eq.subst (motive := fun s => W.active s y.2) next after)),
   fun one t g g' f before before' r r' after =>
     congrArg Prod.snd (one (t, g) (t, g') (t + 1, f) after
       ⟨⟨rfl, r⟩, ⟨fun _ => after, fun _ => before⟩⟩
       ⟨⟨rfl, r'⟩, ⟨fun _ => after, fun _ => before'⟩⟩)⟩

/-- **A split is a fission (分叉).** Where `g` active at `t` continues as two formations active
after the step, both lie in lines from `(t, g)`, neither lies in a line from the other, they are
two occurrences, and they are in one family (同族): sameness along a line is not transitive. -/
theorem split_fission {t : Nat} {g f f' : F} (before : W.active t g) (r : R t g f)
    (r' : R t g f') (after : W.active (t + 1) f) (after' : W.active (t + 1) f') (apart : f ≠ f') :
    «相续» (continuationStep R) W.activityClass (t, g) (t + 1, f) ∧
      «相续» (continuationStep R) W.activityClass (t, g) (t + 1, f') ∧
      ¬ «相续» (continuationStep R) W.activityClass (t + 1, f) (t + 1, f') ∧
      ¬ «相续» (continuationStep R) W.activityClass (t + 1, f') (t + 1, f) ∧
      (t + 1, f) ≠ (t + 1, f') ∧
      «同族» (continuationStep R) W.activityClass (t + 1, f) (t + 1, f') :=
  have c : «续» (continuationStep R) W.activityClass (t, g) (t + 1, f) :=
    ⟨⟨rfl, r⟩, ⟨fun _ => after, fun _ => before⟩⟩
  have c' : «续» (continuationStep R) W.activityClass (t, g) (t + 1, f') :=
    ⟨⟨rfl, r'⟩, ⟨fun _ => after', fun _ => before⟩⟩
  ⟨.one c, .one c', fun line => Nat.lt_irrefl (t + 1) (line_advances line),
   fun line => Nat.lt_irrefl (t + 1) (line_advances line), fun same => apart (congrArg Prod.snd same),
   .trans (.symm (.step c)) (.step c')⟩

/-- **A merge is the two candles (蜡烛之合).** Where `g` and `g'` active at `t` both continue as
`f` active after the step, `f` continues both, and the two are in one family (同族). -/
theorem merge_candles {t : Nat} {g g' f : F} (before : W.active t g) (before' : W.active t g')
    (r : R t g f) (r' : R t g' f) (after : W.active (t + 1) f) :
    «续» (continuationStep R) W.activityClass (t, g) (t + 1, f) ∧
      «续» (continuationStep R) W.activityClass (t, g') (t + 1, f) ∧
      «同族» (continuationStep R) W.activityClass (t, g) (t, g') :=
  have both := «蜡烛之合» (R := continuationStep R) (E := W.activityClass) (a := (t, g))
    (c := (t, g')) (b := (t + 1, f)) ⟨rfl, r⟩ ⟨rfl, r'⟩ ⟨fun _ => after, fun _ => before⟩
    ⟨fun _ => after, fun _ => before'⟩
  ⟨both.1, both.2, .trans (.step both.1) (.symm (.step both.2))⟩

/-- A lineage of `k + 1` steps from `g` at `M`, continued by `R` from `M` and active at `M + 1`,
is a lineage of `k + 2` steps from what `R` continues as `g`. -/
theorem Lineage.cons {M : Nat} {g f : F} (before : W.active M g) (r : R M g f)
    (after : W.active (M + 1) f) : ∀ (k : Nat) {h : F},
      W.Lineage R (M + 1) f k h → W.Lineage R M g (k + 1) h
  | 0, _, same => ⟨g, rfl, before, Eq.subst (motive := fun x => R M g x) same.symm r,
      Eq.subst (motive := fun x => W.active (M + 1) x) same.symm after⟩
  | k + 1, _, ⟨h₀, lineage, active₀, cont, active⟩ =>
    have shift : M + 1 + k = M + (k + 1) := Nat.succ_add M k
    ⟨h₀, Lineage.cons before r after k lineage,
     Eq.subst (motive := fun s => W.active s h₀) shift active₀,
     Eq.subst (motive := fun s => R s h₀ _) shift cont,
     Eq.subst (motive := fun s => W.active (s + 1) _) shift active⟩

/-- A lineage of `k + 1` steps is a line (相续) under activity from an active occurrence. -/
theorem Lineage.line {M : Nat} {g : F} : ∀ (k : Nat) {h : F}, W.Lineage R M g (k + 1) h →
    W.active M g ∧ «相续» (continuationStep R) W.activityClass (M, g) (M + (k + 1), h)
  | 0, _, ⟨_, same, active₀, cont, active⟩ =>
    have before : W.active M g := Eq.subst (motive := fun x => W.active M x) same active₀
    ⟨before, .one ⟨⟨rfl, Eq.subst (motive := fun x => R M x _) same cont⟩,
      ⟨fun _ => active, fun _ => before⟩⟩⟩
  | k + 1, _, ⟨_, lineage, active₀, cont, active⟩ =>
    match Lineage.line k lineage with
    | ⟨before, line⟩ =>
      ⟨before, «及之传递» line (.one ⟨⟨rfl, cont⟩, ⟨fun _ => active, fun _ => active₀⟩⟩)⟩

/-- A line (相续) under activity from an active occurrence is a lineage of some number of
steps. -/
theorem line_lineage {x y : Nat × F}
    (line : «及» («续» (continuationStep R) W.activityClass) x y) :
    W.active x.1 x.2 → ∃ k, y.1 = x.1 + (k + 1) ∧ W.Lineage R x.1 x.2 (k + 1) y.2 := by
  induction line with
  | @one a b c =>
    intro before
    exact ⟨0, c.1.1, a.2, rfl, before, c.1.2,
      Eq.subst (motive := fun s => W.active s b.2) c.1.1 (c.2.mp before)⟩
  | @more a b z c _ ih =>
    intro before
    have next : b.1 = a.1 + 1 := c.1.1
    have after : W.active (a.1 + 1) b.2 :=
      Eq.subst (motive := fun s => W.active s b.2) next (c.2.mp before)
    match ih (c.2.mp before) with
    | ⟨k, reach, lineage⟩ =>
      exact ⟨k + 1, reach.trans ((congrArg (· + (k + 1)) next).trans (Nat.succ_add a.1 (k + 1))),
        Lineage.cons before c.1.2 after (k + 1)
          (Eq.subst (motive := fun s => W.Lineage R s b.2 (k + 1) z.2) next lineage)⟩

/-- Steps added to one start are equal where they reach the same step. -/
theorem steps_cancel : ∀ {n m k : Nat}, n + m = n + k → m = k
  | _, 0, 0, _ => rfl
  | _, _ + 1, _ + 1, same => congrArg Nat.succ (steps_cancel (Nat.succ.inj same))
  | n, 0, k + 1, same => absurd (Eq.subst (motive := fun s => n < s) same.symm
      (Nat.lt_succ_of_le (Nat.le_add_right n k))) (Nat.lt_irrefl n)
  | n, m + 1, 0, same => absurd (Eq.subst (motive := fun s => n < s) same
      (Nat.lt_succ_of_le (Nat.le_add_right n m))) (Nat.lt_irrefl n)

/-- **A lineage is a line (相续).** A lineage of `k + 1` steps from `g` at `M` is exactly a line
under activity from `(M, g)`, `g` active at `M`, to the occurrence `k + 1` steps on. -/
theorem lineage_iff_line {M k : Nat} {g h : F} :
    W.Lineage R M g (k + 1) h ↔
      W.active M g ∧ «相续» (continuationStep R) W.activityClass (M, g) (M + (k + 1), h) :=
  ⟨Lineage.line k, fun ⟨before, line⟩ => match line_lineage line before with
    | ⟨_, reach, lineage⟩ =>
      Eq.subst (motive := fun i => W.Lineage R M g i h) (steps_cancel reach).symm lineage⟩

end Web

/-- **The fork is a fission (分叉).** In `Identity.Fork`, formation `0` continues as itself and as
formation `1` across step one: two occurrences in lines from one, neither in a line from the
other, in one family. -/
theorem Identity.Fork.fission :
    «相续» (Web.continuationStep Identity.Fork.forks) Cycle.web.activityClass (1, 0) (2, 0) ∧
      «相续» (Web.continuationStep Identity.Fork.forks) Cycle.web.activityClass (1, 0) (2, 1) ∧
      ¬ «相续» (Web.continuationStep Identity.Fork.forks) Cycle.web.activityClass (2, 0) (2, 1) ∧
      ¬ «相续» (Web.continuationStep Identity.Fork.forks) Cycle.web.activityClass (2, 1) (2, 0) ∧
      ((2, 0) : Nat × Nat) ≠ (2, 1) ∧
      «同族» (Web.continuationStep Identity.Fork.forks) Cycle.web.activityClass (2, 0) (2, 1) :=
  Web.split_fission (W := Cycle.web) (R := Identity.Fork.forks) (t := 1) (g := 0) (f := 0) (f' := 1)
    Nat.zero_lt_one (.inl rfl) (.inr ⟨rfl, rfl, rfl⟩) (Nat.zero_lt_succ 1) (Nat.lt_succ_self 1)
    (fun same => Nat.noConfusion same)

/-- **Budding is a fission (分叉) at every step.** In `Tandem`, read as budding, the later
formation continues as itself and as the formation arising across the step. -/
theorem Tandem.budding_fission (t : Nat) :
    «相续» (Web.continuationStep Tandem.buds) Tandem.web.activityClass (t, t + 1) (t + 1, t + 1) ∧
      «相续» (Web.continuationStep Tandem.buds) Tandem.web.activityClass (t, t + 1) (t + 1, t + 2) ∧
      ¬ «相续» (Web.continuationStep Tandem.buds) Tandem.web.activityClass
        (t + 1, t + 1) (t + 1, t + 2) ∧
      ¬ «相续» (Web.continuationStep Tandem.buds) Tandem.web.activityClass
        (t + 1, t + 2) (t + 1, t + 1) ∧
      (t + 1, t + 1) ≠ (t + 1, t + 2) ∧
      «同族» (Web.continuationStep Tandem.buds) Tandem.web.activityClass
        (t + 1, t + 1) (t + 1, t + 2) :=
  Web.split_fission (W := Tandem.web) (R := Tandem.buds) (.inr rfl) ⟨rfl, .inl rfl⟩
    ⟨rfl, .inr rfl⟩ (.inl rfl) (.inr rfl)
    (fun same => Tandem.apart (t := t + 1) Nat.zero_lt_one same.symm)

/-- **Joining is the two candles (蜡烛之合) at every step.** In `Tandem`, read as joining, both
formations active at `t` continue as the later one. -/
theorem Tandem.joining_candles (t : Nat) :
    «续» (Web.continuationStep Tandem.joins) Tandem.web.activityClass (t, t) (t + 1, t + 1) ∧
      «续» (Web.continuationStep Tandem.joins) Tandem.web.activityClass (t, t + 1) (t + 1, t + 1) ∧
      «同族» (Web.continuationStep Tandem.joins) Tandem.web.activityClass (t, t) (t, t + 1) :=
  Web.merge_candles (W := Tandem.web) (R := Tandem.joins) (.inl rfl) (.inr rfl) ⟨rfl, .inl rfl⟩
    ⟨rfl, .inr rfl⟩ (.inl rfl)

end Becoming
