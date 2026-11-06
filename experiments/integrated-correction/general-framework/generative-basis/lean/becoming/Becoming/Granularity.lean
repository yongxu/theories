import Becoming.Joining
import Becoming.Segmentation
import Becoming.Witnesses

/-!
# Granularity: one unfolding read at a coarser grain

A block names a finite course of the same unfolding (`Frame.blocks`): it goes from one
configuration to another exactly where the course of its word does, through every configuration
between. The frame of blocks has the same configurations and claims; no block restarts the
unfolding, and a history of blocks is the finer history of its words written out
(`Frame.blocks_trace_iff`). Blocks of retained references keep where the course started and count
every formation within, not each block (`Joining.retained_blocks_extend`).

**Tests at two grains.** Every branching test of blocks is a finer test, holding at the same
configurations (`Frame.holds_blocks`), with no premise. So configurations alike at the finer grain
are alike in blocks, and passing the same finer tests passes the same tests of blocks
(`Alike.blocks`, `SameBranchingTests.blocks`); where every finer move is a block of its own, the
tests of blocks recover every finer test (`Frame.blocks_sameBranchingTests_iff`), a sufficient
condition only. The general law of reading one unfolding at another grain: where the tests of two
frames translate into finer frames and the translations agree at two configurations, every
history of the first is matched by one of the second by the same steps, ending where the
translations agree again (`Translates.history_matches_of_em`). It needs the outcomes of each move
of the receiving side listed, and excluded middle, `em : ∀ p : Prop, Decided p`, named; listed
outcomes give listed endpoints of every finite course with no choice (`outcomes_of_trace`). Two
articulations may write the same blocks in their own words, of different moves and lengths
(`Frame.blocks_history_matches_of_em`).

**Recipes.** A recipe chooses at the configuration reached: one move, a test where the course
stands, one recipe after another, or either of two (`Recipe`, `Recipe.Leads`). Its courses are
courses of the frame; tests and choices add no move (`Recipe.Leads.trace`). Whether a recipe leads
to where a test holds is one of finitely many branching tests, with no premise
(`Recipe.leads_iff_afterAny`), so configurations passing the same tests answer every recipe
question alike (`SameBranchingTests.leads_iff`). Read as one test, through negation and
conjunction, a recipe is exact where the tests are decided (`Recipe.holds_after`); for every
frame, that is exactly excluded middle (`Recipe.holds_after_iff_em`). Testing before a prefix is
testing after it where the prefix keeps the test at every configuration it leads to
(`Recipe.branch_earlier_iff`).

**What remains.** Carrying out a recipe part of the way leaves a recipe remaining where the course
stands (`Recipe.Leaves`); the bookkeeping is an unfolding of its own and adds no move
(`Recipe.Leaves.trace`). Resuming what remains completes the recipe, and carrying it out to the
end is a partial course leaving nothing (`Recipe.Leaves.resume`, `Recipe.leads_iff_leaves`).
Partial courses from alike configurations match, keeping what remains, with no premise
(`Recipe.Leaves.alike`); from configurations passing the same tests they match with listed
outcomes and `em` (`Recipe.Leaves.same_of_em`). Moves inserted between a partial course and its
resumption join them into one course, without being part of the recipe
(`Recipe.Leaves.inserted`).

**The witness** `Midway`: from one origin, `risky` and `safe`; `begin` can take `risky` to where
`finish` cannot be taken. Read in completed blocks, and even in blocks of every nonempty prefix,
the two are alike (`Midway.same_completed_tests`, `Midway.same_prefix_tests`), so no test of
prefixes reads the loss (`Midway.no_prefix_reading`), while every description exact for the finer
tests keeps them apart (`Midway.codes_apart`) and exposing the suffix where the course stands
recovers it (`Midway.resumption_recovers_loss`). A recipe testing where it has arrived reaches what
one testing at the start does not; one start leaves different remainders at one configuration,
which every description exact for resumption keeps apart; and an inserted move can disable what
remains (`Midway.testing_before_formation_changes_results`, `Midway.remainder_codes_apart`,
`Midway.inserted_can_disable_resumption`).

Excluded middle enters only as a named hypothesis: to match histories from configurations passing
the same tests, and to read every recipe as one test. The readings of these results are the AI's,
adopted on Ren's delegation of 15 October 2026 (DELEGATED-CHOICES D33). No ethical predicate is
used.
-/

namespace Becoming

open Generative

universe u u' v v' v'' w x x'

/-! ## Lists -/

namespace Granularity

/-- A member of the second list is a member of the two joined, at every universe. -/
theorem mem_joined_right {α : Type u} {a : α} : ∀ (l : List α) {m : List α}, a ∈ m → a ∈ l ++ m
  | [], _, mem => mem
  | _ :: l, _, mem => .tail _ (mem_joined_right l mem)

/-- **A member of a sequence of words written out is a member of one of its words.** -/
theorem mem_encode {α : Type u} {β : Type v} {g : β → List α} {a : α} :
    ∀ {l : List β}, a ∈ Segmentation.encode g l ↔ ∃ b, b ∈ l ∧ a ∈ g b
  | [] => ⟨fun mem => (nomatch (show a ∈ ([] : List α) from mem)), fun ⟨_, mem, _⟩ => (nomatch mem)⟩
  | b :: l =>
    ⟨fun mem => match (ListTests.mem_append_iff (l := g b)).mp
        (show a ∈ g b ++ Segmentation.encode g l from mem) with
      | .inl here => ⟨b, .head l, here⟩
      | .inr rest => match (mem_encode (l := l)).mp rest with
        | ⟨c, inside, at_c⟩ => ⟨c, .tail b inside, at_c⟩,
     fun ⟨c, inside, at_c⟩ => show a ∈ g b ++ Segmentation.encode g l from
      match mem_cons_cases inside with
      | .inl same => mem_appended_left (Segmentation.encode g l)
          (Eq.subst (motive := fun d => a ∈ g d) same at_c)
      | .inr inside => mem_joined_right (g b) ((mem_encode (l := l)).mpr ⟨c, inside, at_c⟩)⟩

/-- **Listing what each member of a list relates to lists what the list relates to**: finitely
many listed relations, gathered with no choice. -/
theorem listed_through {X : Type u} {Y : Type u'} {R : X → Y → Prop}
    (listed : ∀ x, ∃ l : List Y, ∀ y, R x y ↔ y ∈ l) :
    ∀ xs : List X, ∃ l : List Y, ∀ y, (∃ x, x ∈ xs ∧ R x y) ↔ y ∈ l
  | [] => ⟨[], fun _ => ⟨fun ⟨_, mem, _⟩ => (nomatch mem), fun mem => (nomatch mem)⟩⟩
  | x :: xs => match listed x, listed_through listed xs with
    | ⟨l, here⟩, ⟨L, rest⟩ => ⟨l ++ L, fun y =>
      ⟨fun ⟨z, mem, related⟩ => match mem_cons_cases mem with
        | .inl same => mem_appended_left L
            ((here y).mp (Eq.subst (motive := fun w => R w y) same related))
        | .inr mem => mem_joined_right l ((rest y).mp ⟨z, mem, related⟩),
       fun mem => match ListTests.mem_append_iff.mp mem with
        | .inl inside => ⟨x, .head xs, (here y).mpr inside⟩
        | .inr outside => match (rest y).mpr outside with
          | ⟨z, mem, related⟩ => ⟨z, .tail x mem, related⟩⟩⟩

end Granularity

/-! ## Blocks: finite courses of the same unfolding read as single steps -/

section Blocks

variable {S : Type u} {S' : Type u'} {A : Type v} {B : Type v'} {D : Type v''} {C : Type w}

/-- **The frame read at a coarser grain.** A block named `b` goes from `s` to `t` exactly where
the finer course `expand b` does, through every configuration between: the same configurations,
the same claims and the same unfolding, with some of its finite courses named as one step. -/
def Frame.blocks (F : Frame S A C) (expand : B → List A) : Frame S B C :=
  ⟨⟨fun s b t => Trace F.P s (expand b) t⟩, F.realized⟩

/-- **A history of blocks is the finer history of the words written out**, through the same
boundaries: no block restarts the unfolding. -/
theorem Frame.blocks_trace_iff (F : Frame S A C) (expand : B → List A) :
    ∀ (word : List B) {s t : S},
      Trace (F.blocks expand).P s word t ↔ Trace F.P s (Segmentation.encode expand word) t
  | [], _, _ => trace_nil_iff.trans trace_nil_iff.symm
  | b :: rest, s, t =>
    ⟨fun path => match trace_cons_iff.mp path with
      | ⟨m, step, tail⟩ => show Trace F.P s (expand b ++ Segmentation.encode expand rest) t from
          trace_append_iff.mpr ⟨m, step, (Frame.blocks_trace_iff F expand rest).mp tail⟩,
     fun path => match trace_append_iff.mp
        (show Trace F.P s (expand b ++ Segmentation.encode expand rest) t from path) with
      | ⟨_, first, tail⟩ => .cons first ((Frame.blocks_trace_iff F expand rest).mpr tail)⟩

/-- A course of moves read as one test: some course by these moves leads to where the test
holds. -/
def BranchingTest.along : List A → BranchingTest A C → BranchingTest A C
  | [], φ => φ
  | a :: rest, φ => .can a (BranchingTest.along rest φ)

/-- A course read as a test holds exactly where the course leads to where the test holds. -/
theorem BranchingTest.holds_along (F : Frame S A C) :
    ∀ (word : List A) (s : S) (φ : BranchingTest A C),
      BranchingTest.Holds F s (BranchingTest.along word φ) ↔
        ∃ t, Trace F.P s word t ∧ BranchingTest.Holds F t φ
  | [], s, φ =>
    ⟨fun holds => ⟨s, .nil s, holds⟩, fun ⟨_, path, holds⟩ =>
      Eq.subst (motive := fun x => BranchingTest.Holds F x φ) (trace_nil_iff.mp path).symm holds⟩
  | _ :: rest, _, φ =>
    ⟨fun ⟨m, step, holds⟩ => match (BranchingTest.holds_along F rest m φ).mp holds with
      | ⟨t, path, holds'⟩ => ⟨t, .cons step path, holds'⟩,
     fun ⟨t, path, holds⟩ => match trace_cons_iff.mp path with
      | ⟨m, step, tail⟩ => ⟨m, step, (BranchingTest.holds_along F rest m φ).mpr ⟨t, tail, holds⟩⟩⟩

/-- A branching test of blocks read at the finer grain: each block becomes the course of its
word. -/
def BranchingTest.finer (expand : B → List A) : BranchingTest B C → BranchingTest A C
  | .top => .top
  | .claim c => .claim c
  | .not φ => .not (BranchingTest.finer expand φ)
  | .both φ ψ => .both (BranchingTest.finer expand φ) (BranchingTest.finer expand ψ)
  | .can b φ => BranchingTest.along (expand b) (BranchingTest.finer expand φ)

/-- **Every branching test of blocks is a branching test of the finer grain**, holding at the
same configurations. No premise. -/
theorem Frame.holds_blocks (F : Frame S A C) (expand : B → List A) :
    ∀ (φ : BranchingTest B C) (s : S),
      BranchingTest.Holds (F.blocks expand) s φ ↔ BranchingTest.Holds F s (φ.finer expand)
  | .top, _ => Iff.rfl
  | .claim _, _ => Iff.rfl
  | .not φ, s =>
    ⟨fun fails holds => fails ((Frame.holds_blocks F expand φ s).mpr holds),
     fun fails holds => fails ((Frame.holds_blocks F expand φ s).mp holds)⟩
  | .both φ ψ, s =>
    ⟨fun ⟨first, second⟩ =>
      ⟨(Frame.holds_blocks F expand φ s).mp first, (Frame.holds_blocks F expand ψ s).mp second⟩,
     fun ⟨first, second⟩ =>
      ⟨(Frame.holds_blocks F expand φ s).mpr first, (Frame.holds_blocks F expand ψ s).mpr second⟩⟩
  | .can b φ, s =>
    have inner : (∃ t, Trace F.P s (expand b) t ∧ BranchingTest.Holds (F.blocks expand) t φ) ↔
        ∃ t, Trace F.P s (expand b) t ∧ BranchingTest.Holds F t (φ.finer expand) :=
      ⟨fun ⟨t, path, holds⟩ => ⟨t, path, (Frame.holds_blocks F expand φ t).mp holds⟩,
       fun ⟨t, path, holds⟩ => ⟨t, path, (Frame.holds_blocks F expand φ t).mpr holds⟩⟩
    inner.trans (BranchingTest.holds_along F (expand b) s (φ.finer expand)).symm

/-- `tr` translates the branching tests of `G` into those of `F`, a frame on the same
configurations: each test of `G` holds exactly where its translation holds in `F`. -/
def Translates (G : Frame S B C) (F : Frame S A C) (tr : BranchingTest B C → BranchingTest A C) :
    Prop :=
  ∀ s φ, BranchingTest.Holds G s φ ↔ BranchingTest.Holds F s (tr φ)

/-- The blocks are translated into the finer grain. -/
theorem Frame.blocks_translates (F : Frame S A C) (expand : B → List A) :
    Translates (F.blocks expand) F (BranchingTest.finer expand) :=
  fun s φ => F.holds_blocks expand φ s

/-- **Passing the same tests of two translated frames is agreeing on every translation.** -/
theorem Translates.sameBranchingTests_iff {G : Frame S B C} {F : Frame S A C} {G' : Frame S' B C}
    {F' : Frame S' D C} {tr : BranchingTest B C → BranchingTest A C}
    {tr' : BranchingTest B C → BranchingTest D C} (reads : Translates G F tr)
    (reads' : Translates G' F' tr') {s : S} {s' : S'} :
    SameBranchingTests G G' s s' ↔
      ∀ φ, BranchingTest.Holds F s (tr φ) ↔ BranchingTest.Holds F' s' (tr' φ) :=
  ⟨fun same φ => (reads s φ).symm.trans ((same φ).trans (reads' s' φ)),
   fun answers φ => (reads s φ).trans ((answers φ).trans (reads' s' φ).symm)⟩

/-- **Under excluded middle, configurations passing the same branching tests match each step**,
where the outcomes of each move of the second frame are listed: only the receiving side is
listed. -/
theorem SameBranchingTests.step_of_em (em : ∀ p : Prop, Decided p) {F : Frame S A C}
    {G : Frame S' A C} (outcomes' : ∀ s a, ∃ l : List S', ∀ t, G.P.step s a t ↔ t ∈ l)
    {s : S} {s' : S'} (same : SameBranchingTests F G s s') {a : A} {t : S}
    (step : F.P.step s a t) : ∃ t', G.P.step s' a t' ∧ SameBranchingTests F G t t' :=
  match outcomes' s' a with
  | ⟨l', outcome'⟩ => match em (∃ t', t' ∈ l' ∧ SameBranchingTests F G t t') with
    | .inl ⟨t', mem, joined⟩ => ⟨t', (outcome' t').mpr mem, joined⟩
    | .inr absent =>
      match BranchingTest.apart_from_list F G (x := t) l' fun t' mem =>
          apart_of_not_sameBranchingTests em fun joined => absent ⟨t', mem, joined⟩ with
      | ⟨φ, holds, fails⟩ => absurd ((same (.can a φ)).mp ⟨t, step, holds⟩)
          fun ⟨t', step', holds'⟩ => fails t' ((outcome' t').mp step') holds'

/-- **Under excluded middle, configurations passing the same branching tests match every
history**, where the outcomes of each move of the receiving frame are listed: the matched history
takes the same moves and ends where the same tests pass. -/
theorem SameBranchingTests.trace_of_em (em : ∀ p : Prop, Decided p) {F : Frame S A C}
    {G : Frame S' A C} (outcomes' : ∀ s a, ∃ l : List S', ∀ t, G.P.step s a t ↔ t ∈ l)
    {s : S} {word : List A} {t : S} (path : Trace F.P s word t) :
    ∀ {s' : S'}, SameBranchingTests F G s s' →
      ∃ t', Trace G.P s' word t' ∧ SameBranchingTests F G t t' := by
  induction path with
  | nil =>
    intro s' same
    exact ⟨s', .nil s', same⟩
  | cons step _ ih =>
    intro s' same
    exact match SameBranchingTests.step_of_em em outcomes' same step with
    | ⟨_, step', joined⟩ => match ih joined with
      | ⟨t', path', joined'⟩ => ⟨t', .cons step' path', joined'⟩

/-- **Histories of translated frames match where the translations agree** (the general law of
reading one unfolding at another grain). Where the tests of `G` translate into `F`, those of `G'`
into `F'`, the translations agree at `s` and `s'`, and each move of `G'` has listed outcomes, every
history of `G` from `s` is matched by a history of `G'` from `s'` by the same moves, ending where
the translations agree again; excluded middle is the named hypothesis. -/
theorem Translates.history_matches_of_em (em : ∀ p : Prop, Decided p) {G : Frame S B C}
    {F : Frame S A C} {G' : Frame S' B C} {F' : Frame S' D C}
    {tr : BranchingTest B C → BranchingTest A C} {tr' : BranchingTest B C → BranchingTest D C}
    (reads : Translates G F tr) (reads' : Translates G' F' tr')
    (outcomes' : ∀ s b, ∃ l : List S', ∀ t, G'.P.step s b t ↔ t ∈ l) {s : S} {s' : S'}
    (answers : ∀ φ, BranchingTest.Holds F s (tr φ) ↔ BranchingTest.Holds F' s' (tr' φ))
    {word : List B} {t : S} (path : Trace G.P s word t) :
    ∃ t', Trace G'.P s' word t' ∧
      ∀ φ, BranchingTest.Holds F t (tr φ) ↔ BranchingTest.Holds F' t' (tr' φ) :=
  match SameBranchingTests.trace_of_em em outcomes' path
      ((reads.sameBranchingTests_iff reads').mpr answers) with
  | ⟨t', path', same⟩ => ⟨t', path', (reads.sameBranchingTests_iff reads').mp same⟩

/-- **Listed outcomes of each move list the endpoints of each finite course**, with no choice. -/
theorem outcomes_of_trace {P : Process S A}
    (outcomes : ∀ s a, ∃ l : List S, ∀ t, P.step s a t ↔ t ∈ l) :
    ∀ (word : List A) (s : S), ∃ l : List S, ∀ t, Trace P s word t ↔ t ∈ l
  | [], s => ⟨[s], fun _ =>
      ⟨fun path => Eq.subst (motive := fun x => x ∈ [s]) (trace_nil_iff.mp path) (.head []),
       fun mem => Eq.subst (motive := fun x => Trace P s [] x) (CrossSituational.mem_singleton mem).symm
        (.nil s)⟩⟩
  | a :: rest, s => match outcomes s a with
    | ⟨first, listed⟩ => match Granularity.listed_through (R := fun m t => Trace P m rest t)
        (fun m => outcomes_of_trace outcomes rest m) first with
      | ⟨L, gathered⟩ => ⟨L, fun t =>
        ⟨fun path => match trace_cons_iff.mp path with
          | ⟨m, step, tail⟩ => (gathered t).mp ⟨m, (listed m).mp step, tail⟩,
         fun mem => match (gathered t).mpr mem with
          | ⟨m, inside, tail⟩ => .cons ((listed m).mpr inside) tail⟩⟩

/-- Listed outcomes of each finer move list the outcomes of each block. -/
theorem Frame.blocks_outcomes {F : Frame S A C} (expand : B → List A)
    (outcomes : ∀ s a, ∃ l : List S, ∀ t, F.P.step s a t ↔ t ∈ l) :
    ∀ s b, ∃ l : List S, ∀ t, (F.blocks expand).P.step s b t ↔ t ∈ l :=
  fun s b => outcomes_of_trace outcomes (expand b) s

/-- **Histories of blocks match across two articulations where the finer tests agree.** Two
frames, with their own finer moves, each read in blocks named alike but written out in their own
words of different moves and lengths: where the readings of every block test agree at `s` and
`s'` and the second frame's moves have listed outcomes, every course of blocks written out from
`s` is matched by the course of the same blocks written out from `s'`, ending where the readings
agree again. Excluded middle is the named hypothesis. -/
theorem Frame.blocks_history_matches_of_em (em : ∀ p : Prop, Decided p) {F : Frame S A C}
    {F' : Frame S' D C} (left : B → List A) (right : B → List D)
    (outcomes' : ∀ s d, ∃ l : List S', ∀ t, F'.P.step s d t ↔ t ∈ l) {s : S} {s' : S'}
    (answers : ∀ φ : BranchingTest B C,
      BranchingTest.Holds F s (φ.finer left) ↔ BranchingTest.Holds F' s' (φ.finer right))
    {word : List B} {t : S} (path : Trace F.P s (Segmentation.encode left word) t) :
    ∃ t', Trace F'.P s' (Segmentation.encode right word) t' ∧
      ∀ φ : BranchingTest B C,
        BranchingTest.Holds F t (φ.finer left) ↔ BranchingTest.Holds F' t' (φ.finer right) :=
  match Translates.history_matches_of_em em (F.blocks_translates left) (F'.blocks_translates right)
      (Frame.blocks_outcomes right outcomes') answers ((F.blocks_trace_iff left word).mpr path) with
  | ⟨t', path', answers'⟩ => ⟨t', (F'.blocks_trace_iff right word).mp path', answers'⟩

/-- Likeness at the finer grain is a bisimulation of the blocks. -/
theorem Frame.blocks_bisimulation (F : Frame S A C) (G : Frame S' A C) (expand : B → List A) :
    Bisimulation (F.blocks expand) (G.blocks expand) (Alike F G) :=
  fun _ _ alike =>
    ⟨alike.realized,
     fun _ _ path => alike.trace path,
     fun _ _ path' => match alike.symm.trace path' with
      | ⟨t, path, joined⟩ => ⟨t, path, joined.symm⟩⟩

/-- **Configurations alike at the finer grain are alike in blocks**, with no premise. -/
theorem Alike.blocks {F : Frame S A C} {G : Frame S' A C} (expand : B → List A) {s : S} {s' : S'}
    (alike : Alike F G s s') : Alike (F.blocks expand) (G.blocks expand) s s' :=
  ⟨_, Frame.blocks_bisimulation F G expand, alike⟩

/-- **Configurations passing the same finer tests pass the same tests of blocks**, with no
premise: reading at a coarser grain keeps every sameness. -/
theorem SameBranchingTests.blocks {F : Frame S A C} {G : Frame S' A C} (expand : B → List A)
    {s : S} {s' : S'} (same : SameBranchingTests F G s s') :
    SameBranchingTests (F.blocks expand) (G.blocks expand) s s' :=
  ((F.blocks_translates expand).sameBranchingTests_iff (G.blocks_translates expand)).mpr
    fun φ => same (φ.finer expand)

/-- A branching test with its moves renamed. -/
def BranchingTest.rename (name : A → B) : BranchingTest A C → BranchingTest B C
  | .top => .top
  | .claim c => .claim c
  | .not φ => .not (BranchingTest.rename name φ)
  | .both φ ψ => .both (BranchingTest.rename name φ) (BranchingTest.rename name ψ)
  | .can a φ => .can (name a) (BranchingTest.rename name φ)

/-- Where each finer move is named by a block of that move alone, a finer test holds where the
test of the blocks naming its moves holds. -/
theorem Frame.holds_rename_blocks (F : Frame S A C) (expand : B → List A) (name : A → B)
    (single : ∀ a, expand (name a) = [a]) :
    ∀ (φ : BranchingTest A C) (s : S),
      BranchingTest.Holds (F.blocks expand) s (φ.rename name) ↔ BranchingTest.Holds F s φ
  | .top, _ => Iff.rfl
  | .claim _, _ => Iff.rfl
  | .not φ, s =>
    ⟨fun fails holds => fails ((Frame.holds_rename_blocks F expand name single φ s).mpr holds),
     fun fails holds => fails ((Frame.holds_rename_blocks F expand name single φ s).mp holds)⟩
  | .both φ ψ, s =>
    ⟨fun ⟨first, second⟩ => ⟨(Frame.holds_rename_blocks F expand name single φ s).mp first,
        (Frame.holds_rename_blocks F expand name single ψ s).mp second⟩,
     fun ⟨first, second⟩ => ⟨(Frame.holds_rename_blocks F expand name single φ s).mpr first,
        (Frame.holds_rename_blocks F expand name single ψ s).mpr second⟩⟩
  | .can a φ, s =>
    ⟨fun ⟨t, path, holds⟩ =>
      ⟨t, trace_singleton_iff.mp (Eq.subst (motive := fun w => Trace F.P s w t) (single a) path),
       (Frame.holds_rename_blocks F expand name single φ t).mp holds⟩,
     fun ⟨t, step, holds⟩ =>
      ⟨t, Eq.subst (motive := fun w => Trace F.P s w t) (single a).symm (trace_singleton_iff.mpr step),
       (Frame.holds_rename_blocks F expand name single φ t).mpr holds⟩⟩

/-- **Where every finer move is a block of its own, the blocks' tests recover every finer test**:
configurations pass the same tests of blocks exactly where they pass the same finer tests. The
condition is sufficient, not necessary. -/
theorem Frame.blocks_sameBranchingTests_iff {F : Frame S A C} {G : Frame S' A C}
    {expand : B → List A} {name : A → B} (single : ∀ a, expand (name a) = [a]) {s : S} {s' : S'} :
    SameBranchingTests (F.blocks expand) (G.blocks expand) s s' ↔ SameBranchingTests F G s s' :=
  ⟨fun same φ => (F.holds_rename_blocks expand name single φ s).symm.trans
      ((same (φ.rename name)).trans (G.holds_rename_blocks expand name single φ s')),
   SameBranchingTests.blocks expand⟩

/-- **Descriptions whose kernels are passing the same finer tests and passing the same tests of
blocks identify the same configurations**, where every finer move is a block of its own. -/
theorem Frame.blocks_kernel_iff {F : Frame S A C} {expand : B → List A} {name : A → B}
    (single : ∀ a, expand (name a) = [a]) {K : Type x} {K' : Type x'} {π : S → K} {ρ : S → K'}
    (kernel : ∀ s t, π s = π t ↔ SameBranchingTests F F s t)
    (kernel' : ∀ s t, ρ s = ρ t ↔ SameBranchingTests (F.blocks expand) (F.blocks expand) s t)
    (s t : S) : π s = π t ↔ ρ s = ρ t :=
  (kernel s t).trans ((Frame.blocks_sameBranchingTests_iff single).symm.trans (kernel' s t).symm)

end Blocks

/-- **Blocks of retained references keep the configuration and count every formation within.** A
history of blocks of the joining read through retained references extends the configuration it
started from, by one fragment for each finer move written out, not for each block. -/
theorem Joining.retained_blocks_extend {F : Type u} {J : Joining F} {B : Type v}
    (expand : B → List (Nat × Nat)) {xs ys : List F} {word : List B}
    (path : Trace (J.retainedFrame.blocks expand).P xs word ys) :
    (∃ added, ys = xs ++ added) ∧ ys.length = xs.length + (Segmentation.encode expand word).length :=
  match Joining.retained_extends ((J.retainedFrame.blocks_trace_iff expand word).mp path) with
  | ⟨added, extended, counted⟩ =>
    ⟨⟨added, extended⟩, (congrArg List.length extended).trans
      ((ListTests.length_append xs added).trans (congrArg (xs.length + ·) counted))⟩

/-! ## Recipes: finite guarded courses chosen at the configurations reached -/

/-- A recipe of moves: nothing, one move, a branching test at the configuration reached, one
recipe after another, or either of two. A recipe names finite courses of the same unfolding; its
tests are evaluated where the course has arrived, not where it began. -/
inductive Recipe (A : Type v) (C : Type w) where
  | skip
  | move (a : A)
  | guard (φ : BranchingTest A C)
  | seq (p q : Recipe A C)
  | choice (p q : Recipe A C)

section Recipes

variable {S : Type u} {S' : Type u'} {A : Type v} {B : Type v'} {D : Type v''} {C : Type w}

/-- Carried out from `s`, the recipe can lead to `t`. -/
def Recipe.Leads (F : Frame S A C) : Recipe A C → S → S → Prop
  | .skip, s, t => s = t
  | .move a, s, t => F.P.step s a t
  | .guard φ, s, t => s = t ∧ BranchingTest.Holds F s φ
  | .seq p q, s, t => ∃ m, Recipe.Leads F p s m ∧ Recipe.Leads F q m t
  | .choice p q, s, t => Recipe.Leads F p s t ∨ Recipe.Leads F q s t

/-- A word of moves read as a recipe. -/
def Recipe.word : List A → Recipe A C
  | [] => .skip
  | a :: rest => .seq (.move a) (Recipe.word rest)

/-- **A word read as a recipe leads exactly where its course does.** -/
theorem Recipe.leads_word_iff (F : Frame S A C) :
    ∀ (word : List A) {s t : S}, Recipe.Leads F (Recipe.word word) s t ↔ Trace F.P s word t
  | [], _, _ => trace_nil_iff.symm
  | _ :: rest, _, _ =>
    ⟨fun ⟨_, step, tail⟩ => .cons step ((Recipe.leads_word_iff F rest).mp tail),
     fun path => match trace_cons_iff.mp path with
      | ⟨m, step, tail⟩ => ⟨m, step, (Recipe.leads_word_iff F rest).mpr tail⟩⟩

/-- A block is the recipe of its word. -/
theorem Frame.blocks_step_iff_word (F : Frame S A C) (expand : B → List A) {s t : S} {b : B} :
    (F.blocks expand).P.step s b t ↔ Recipe.Leads F (Recipe.word (expand b)) s t :=
  (Recipe.leads_word_iff F (expand b)).symm

/-- **Every course a recipe leads along is a course of the finer moves**: tests and choices add no
move. -/
theorem Recipe.Leads.trace {F : Frame S A C} :
    ∀ {p : Recipe A C} {s t : S}, Recipe.Leads F p s t → ∃ word, Trace F.P s word t
  | .skip, s, _, same => ⟨[], Eq.subst (motive := fun x => Trace F.P s [] x) same (.nil s)⟩
  | .move a, _, t, step => ⟨[a], .cons step (.nil t)⟩
  | .guard _, s, _, ⟨same, _⟩ => ⟨[], Eq.subst (motive := fun x => Trace F.P s [] x) same (.nil s)⟩
  | .seq _ _, _, _, ⟨m, first, second⟩ =>
    match Recipe.Leads.trace first, Recipe.Leads.trace second with
    | ⟨w, path⟩, ⟨w', path'⟩ => ⟨w ++ w', trace_append_iff.mpr ⟨m, path, path'⟩⟩
  | .choice _ _, _, _, .inl first => Recipe.Leads.trace first
  | .choice _ _, _, _, .inr second => Recipe.Leads.trace second

/-- Either of two tests: neither fails. -/
def BranchingTest.either (φ ψ : BranchingTest A C) : BranchingTest A C :=
  .not (.both (.not φ) (.not ψ))

/-- The test that the recipe can lead to where `φ` holds, read as one branching test. -/
def Recipe.after : Recipe A C → BranchingTest A C → BranchingTest A C
  | .skip, φ => φ
  | .move a, φ => .can a φ
  | .guard g, φ => .both g φ
  | .seq p q, φ => Recipe.after p (Recipe.after q φ)
  | .choice p q, φ => BranchingTest.either (Recipe.after p φ) (Recipe.after q φ)

/-- Where the recipe leads to where `φ` holds, the test read after it holds, with no premise. -/
theorem Recipe.holds_after_of_leads (F : Frame S A C) :
    ∀ (p : Recipe A C) {s t : S} {φ : BranchingTest A C},
      Recipe.Leads F p s t → BranchingTest.Holds F t φ → BranchingTest.Holds F s (Recipe.after p φ)
  | .skip, _, _, φ, same, holds =>
    Eq.subst (motive := fun x => BranchingTest.Holds F x φ) same.symm holds
  | .move _, _, t, _, step, holds => ⟨t, step, holds⟩
  | .guard _, _, _, φ, ⟨same, passes⟩, holds =>
    ⟨passes, Eq.subst (motive := fun x => BranchingTest.Holds F x φ) same.symm holds⟩
  | .seq p q, _, _, _, ⟨_, first, second⟩, holds =>
    Recipe.holds_after_of_leads F p first (Recipe.holds_after_of_leads F q second holds)
  | .choice p _, _, _, _, .inl first, holds =>
    fun ⟨fails, _⟩ => fails (Recipe.holds_after_of_leads F p first holds)
  | .choice _ q, _, _, _, .inr second, holds =>
    fun ⟨_, fails⟩ => fails (Recipe.holds_after_of_leads F q second holds)

/-- Every branching test of the frame is decided at every configuration. -/
def TestsDecided (F : Frame S A C) : Prop :=
  ∀ s φ, Decided (BranchingTest.Holds F s φ)

/-- Excluded middle decides every test. -/
theorem TestsDecided.of_em (em : ∀ p : Prop, Decided p) (F : Frame S A C) : TestsDecided F :=
  fun _ _ => em _

/-- **Where each move's outcomes are listed and the claims decided, every branching test is
decided**, with no choice. -/
theorem OutcomesListed.holds_decided {F : Frame S A C} (listed : OutcomesListed F) :
    ∀ (φ : BranchingTest A C) (s : S), Decided (BranchingTest.Holds F s φ)
  | .top, _ => .inl True.intro
  | .claim c, s => listed.realized s c
  | .not φ, s => (OutcomesListed.holds_decided listed φ s).not
  | .both φ ψ, s =>
    (OutcomesListed.holds_decided listed φ s).and (OutcomesListed.holds_decided listed ψ s)
  | .can a φ, s => match listed.outcomes s a with
    | ⟨l, outcome⟩ =>
      match Decided.exists_listed (l := l) fun t _ => OutcomesListed.holds_decided listed φ t with
      | .inl ⟨t, mem, holds⟩ => .inl ⟨t, (outcome t).mpr mem, holds⟩
      | .inr absent => .inr fun ⟨t, step, holds⟩ => absent ⟨t, (outcome t).mp step, holds⟩

/-- Where each move's outcomes are listed and the claims decided, the tests are decided. -/
theorem OutcomesListed.testsDecided {F : Frame S A C} (listed : OutcomesListed F) :
    TestsDecided F :=
  fun s φ => listed.holds_decided φ s

/-- **Where the tests are decided, the test read after a recipe holds exactly where the recipe
leads to where the test holds.** Only `choice` needs the decision. -/
theorem Recipe.holds_after {F : Frame S A C} (decided : TestsDecided F) :
    ∀ (p : Recipe A C) (s : S) (φ : BranchingTest A C),
      BranchingTest.Holds F s (Recipe.after p φ) ↔
        ∃ t, Recipe.Leads F p s t ∧ BranchingTest.Holds F t φ
  | .skip, s, _ =>
    ⟨fun holds => ⟨s, rfl, holds⟩, fun ⟨_, same, holds⟩ =>
      Recipe.holds_after_of_leads F .skip same holds⟩
  | .move _, _, _ => Iff.rfl
  | .guard g, s, _ =>
    ⟨fun ⟨passes, holds⟩ => ⟨s, ⟨rfl, passes⟩, holds⟩, fun ⟨_, leads, holds⟩ =>
      Recipe.holds_after_of_leads F (.guard g) leads holds⟩
  | .seq p q, s, φ =>
    ⟨fun holds => match (Recipe.holds_after decided p s (Recipe.after q φ)).mp holds with
      | ⟨m, first, rest⟩ => match (Recipe.holds_after decided q m φ).mp rest with
        | ⟨t, second, holds'⟩ => ⟨t, ⟨m, first, second⟩, holds'⟩,
     fun ⟨_, leads, holds⟩ => Recipe.holds_after_of_leads F (.seq p q) leads holds⟩
  | .choice p q, s, φ =>
    ⟨fun holds => match decided s (Recipe.after p φ) with
      | .inl yes => match (Recipe.holds_after decided p s φ).mp yes with
        | ⟨t, leads, holds'⟩ => ⟨t, .inl leads, holds'⟩
      | .inr no => match decided s (Recipe.after q φ) with
        | .inl yes => match (Recipe.holds_after decided q s φ).mp yes with
          | ⟨t, leads, holds'⟩ => ⟨t, .inr leads, holds'⟩
        | .inr no' => False.elim (holds ⟨no, no'⟩),
     fun ⟨_, leads, holds⟩ => Recipe.holds_after_of_leads F (.choice p q) leads holds⟩

/-- The frame whose one claim is realized exactly where `p` holds, with no steps. -/
def Recipe.claimFrame (p : Prop) : Frame Unit Unit Unit :=
  ⟨Witnesses.halted _ _, fun _ _ => p⟩

/-- **Reading every recipe as one branching test is exact, for every frame, exactly under
excluded middle.** That the test read after a recipe holds exactly where the recipe leads to where
the test holds, for every frame with one configuration, one move and one claim, holds exactly
where every proposition is decided: the test language has no disjunction, and either of two
tests holds only where neither fails. -/
theorem Recipe.holds_after_iff_em :
    (∀ (F : Frame Unit Unit Unit) (p : Recipe Unit Unit) (s : Unit) (φ : BranchingTest Unit Unit),
      BranchingTest.Holds F s (Recipe.after p φ) ↔
        ∃ t, Recipe.Leads F p s t ∧ BranchingTest.Holds F t φ) ↔
      ∀ p : Prop, Decided p :=
  ⟨fun exact p =>
    match (exact (Recipe.claimFrame p) (.choice (.guard (.claim ())) (.guard (.not (.claim ()))))
        () .top).mp (fun ⟨no, no'⟩ => no' ⟨fun yes => no ⟨yes, True.intro⟩, True.intro⟩) with
    | ⟨_, .inl ⟨_, yes⟩, _⟩ => .inl yes
    | ⟨_, .inr ⟨_, no⟩, _⟩ => .inr no,
   fun em F => Recipe.holds_after (TestsDecided.of_em em F)⟩

/-- The tests that the recipe can lead to where `φ` holds, read as finitely many branching tests,
one of which holds: a choice becomes two alternatives rather than one test. -/
def Recipe.afterAny : Recipe A C → BranchingTest A C → List (BranchingTest A C)
  | .skip, φ => [φ]
  | .move a, φ => [.can a φ]
  | .guard g, φ => [.both g φ]
  | .seq p q, φ => Segmentation.encode (Recipe.afterAny p) (Recipe.afterAny q φ)
  | .choice p q, φ => Recipe.afterAny p φ ++ Recipe.afterAny q φ

/-- **A recipe leads to where a test holds exactly where one of finitely many branching tests
holds**, with no premise: every recipe question is a finite alternative of branching tests. -/
theorem Recipe.leads_iff_afterAny (F : Frame S A C) :
    ∀ (p : Recipe A C) (s : S) (φ : BranchingTest A C),
      (∃ t, Recipe.Leads F p s t ∧ BranchingTest.Holds F t φ) ↔
        ∃ χ, χ ∈ Recipe.afterAny p φ ∧ BranchingTest.Holds F s χ
  | .skip, s, φ =>
    ⟨fun ⟨_, same, holds⟩ =>
      ⟨φ, .head [], Eq.subst (motive := fun x => BranchingTest.Holds F x φ) same.symm holds⟩,
     fun ⟨_, mem, holds⟩ => ⟨s, rfl, Eq.subst (motive := fun ψ => BranchingTest.Holds F s ψ)
        (CrossSituational.mem_singleton mem) holds⟩⟩
  | .move a, s, φ =>
    ⟨fun ⟨t, step, holds⟩ => ⟨.can a φ, .head [], t, step, holds⟩,
     fun ⟨_, mem, holds⟩ => Eq.subst (motive := fun ψ => BranchingTest.Holds F s ψ)
        (CrossSituational.mem_singleton mem) holds⟩
  | .guard g, s, φ =>
    ⟨fun ⟨_, ⟨same, passes⟩, holds⟩ =>
      ⟨.both g φ, .head [], passes,
        Eq.subst (motive := fun x => BranchingTest.Holds F x φ) same.symm holds⟩,
     fun ⟨_, mem, holds⟩ =>
      match Eq.subst (motive := fun ψ => BranchingTest.Holds F s ψ)
          (CrossSituational.mem_singleton mem) holds with
      | ⟨passes, holds'⟩ => ⟨s, ⟨rfl, passes⟩, holds'⟩⟩
  | .seq p q, s, φ =>
    ⟨fun ⟨t, ⟨m, first, second⟩, holds⟩ =>
      match (Recipe.leads_iff_afterAny F q m φ).mp ⟨t, second, holds⟩ with
      | ⟨χ, mem, holds'⟩ => match (Recipe.leads_iff_afterAny F p s χ).mp ⟨m, first, holds'⟩ with
        | ⟨ξ, mem', holds''⟩ => ⟨ξ, Granularity.mem_encode.mpr ⟨χ, mem, mem'⟩, holds''⟩,
     fun ⟨ξ, mem, holds⟩ => match Granularity.mem_encode.mp mem with
      | ⟨χ, mem', mem''⟩ => match (Recipe.leads_iff_afterAny F p s χ).mpr ⟨ξ, mem'', holds⟩ with
        | ⟨m, first, holds'⟩ => match (Recipe.leads_iff_afterAny F q m φ).mpr ⟨χ, mem', holds'⟩ with
          | ⟨t, second, holds''⟩ => ⟨t, ⟨m, first, second⟩, holds''⟩⟩
  | .choice p q, s, φ =>
    ⟨fun ⟨t, leads, holds⟩ => match leads with
      | .inl first => match (Recipe.leads_iff_afterAny F p s φ).mp ⟨t, first, holds⟩ with
        | ⟨χ, mem, holds'⟩ => ⟨χ, mem_appended_left _ mem, holds'⟩
      | .inr second => match (Recipe.leads_iff_afterAny F q s φ).mp ⟨t, second, holds⟩ with
        | ⟨χ, mem, holds'⟩ => ⟨χ, Granularity.mem_joined_right _ mem, holds'⟩,
     fun ⟨χ, mem, holds⟩ => match ListTests.mem_append_iff.mp mem with
      | .inl inside => match (Recipe.leads_iff_afterAny F p s φ).mpr ⟨χ, inside, holds⟩ with
        | ⟨t, first, holds'⟩ => ⟨t, .inl first, holds'⟩
      | .inr outside => match (Recipe.leads_iff_afterAny F q s φ).mpr ⟨χ, outside, holds⟩ with
        | ⟨t, second, holds'⟩ => ⟨t, .inr second, holds'⟩⟩

/-- **Configurations passing the same branching tests answer every recipe question alike**, with
no premise and no finiteness: a recipe leads from one to where a test holds exactly where it does
from the other. -/
theorem SameBranchingTests.leads_iff {F : Frame S A C} {G : Frame S' A C} {s : S} {s' : S'}
    (same : SameBranchingTests F G s s') (p : Recipe A C) (φ : BranchingTest A C) :
    (∃ t, Recipe.Leads F p s t ∧ BranchingTest.Holds F t φ) ↔
      ∃ t', Recipe.Leads G p s' t' ∧ BranchingTest.Holds G t' φ :=
  have middle : (∃ χ, χ ∈ Recipe.afterAny p φ ∧ BranchingTest.Holds F s χ) ↔
      ∃ χ, χ ∈ Recipe.afterAny p φ ∧ BranchingTest.Holds G s' χ :=
    ⟨fun ⟨χ, mem, holds⟩ => ⟨χ, mem, (same χ).mp holds⟩,
     fun ⟨χ, mem, holds⟩ => ⟨χ, mem, (same χ).mpr holds⟩⟩
  (Recipe.leads_iff_afterAny F p s φ).trans (middle.trans (Recipe.leads_iff_afterAny G p s' φ).symm)

/-- The frame whose steps are recipes: a step named `b` leads where the recipe `recipe b` does. -/
def Frame.byRecipes (F : Frame S A C) (recipe : B → Recipe A C) : Frame S B C :=
  ⟨⟨fun s b t => Recipe.Leads F (recipe b) s t⟩, F.realized⟩

/-- A branching test of recipes read as one finer branching test. -/
def BranchingTest.byRecipes (recipe : B → Recipe A C) : BranchingTest B C → BranchingTest A C
  | .top => .top
  | .claim c => .claim c
  | .not φ => .not (BranchingTest.byRecipes recipe φ)
  | .both φ ψ => .both (BranchingTest.byRecipes recipe φ) (BranchingTest.byRecipes recipe ψ)
  | .can b φ => Recipe.after (recipe b) (BranchingTest.byRecipes recipe φ)

/-- **Where the finer tests are decided, every test of recipes is one finer test**, holding at the
same configurations. -/
theorem Frame.holds_byRecipes {F : Frame S A C} (decided : TestsDecided F)
    (recipe : B → Recipe A C) :
    ∀ (φ : BranchingTest B C) (s : S),
      BranchingTest.Holds (F.byRecipes recipe) s φ ↔ BranchingTest.Holds F s (φ.byRecipes recipe)
  | .top, _ => Iff.rfl
  | .claim _, _ => Iff.rfl
  | .not φ, s =>
    ⟨fun fails holds => fails ((Frame.holds_byRecipes decided recipe φ s).mpr holds),
     fun fails holds => fails ((Frame.holds_byRecipes decided recipe φ s).mp holds)⟩
  | .both φ ψ, s =>
    ⟨fun ⟨first, second⟩ => ⟨(Frame.holds_byRecipes decided recipe φ s).mp first,
        (Frame.holds_byRecipes decided recipe ψ s).mp second⟩,
     fun ⟨first, second⟩ => ⟨(Frame.holds_byRecipes decided recipe φ s).mpr first,
        (Frame.holds_byRecipes decided recipe ψ s).mpr second⟩⟩
  | .can b φ, s =>
    have inner : (∃ t, Recipe.Leads F (recipe b) s t ∧
          BranchingTest.Holds (F.byRecipes recipe) t φ) ↔
        ∃ t, Recipe.Leads F (recipe b) s t ∧ BranchingTest.Holds F t (φ.byRecipes recipe) :=
      ⟨fun ⟨t, leads, holds⟩ => ⟨t, leads, (Frame.holds_byRecipes decided recipe φ t).mp holds⟩,
       fun ⟨t, leads, holds⟩ => ⟨t, leads, (Frame.holds_byRecipes decided recipe φ t).mpr holds⟩⟩
    inner.trans (Recipe.holds_after decided (recipe b) s (φ.byRecipes recipe)).symm

/-- Where the finer tests are decided, recipes are translated into the finer grain. -/
theorem Frame.byRecipes_translates {F : Frame S A C} (decided : TestsDecided F)
    (recipe : B → Recipe A C) : Translates (F.byRecipes recipe) F (BranchingTest.byRecipes recipe) :=
  fun s φ => Frame.holds_byRecipes decided recipe φ s

/-- **Listed outcomes of each move and decided tests list where each recipe leads**, with no
choice. -/
theorem Recipe.outcomes {F : Frame S A C}
    (outcomes : ∀ s a, ∃ l : List S, ∀ t, F.P.step s a t ↔ t ∈ l) (decided : TestsDecided F) :
    ∀ (p : Recipe A C) (s : S), ∃ l : List S, ∀ t, Recipe.Leads F p s t ↔ t ∈ l
  | .skip, s => ⟨[s], fun _ =>
      ⟨fun same => Eq.subst (motive := fun x => x ∈ [s]) same (.head []),
       fun mem => (CrossSituational.mem_singleton mem).symm⟩⟩
  | .move a, s => outcomes s a
  | .guard φ, s => match decided s φ with
    | .inl passes => ⟨[s], fun _ =>
        ⟨fun ⟨same, _⟩ => Eq.subst (motive := fun x => x ∈ [s]) same (.head []),
         fun mem => ⟨(CrossSituational.mem_singleton mem).symm, passes⟩⟩⟩
    | .inr fails => ⟨[], fun _ => ⟨fun ⟨_, passes⟩ => absurd passes fails, fun mem => (nomatch mem)⟩⟩
  | .seq p q, s => match Recipe.outcomes outcomes decided p s with
    | ⟨first, listed⟩ => match Granularity.listed_through (R := fun m t => Recipe.Leads F q m t)
        (fun m => Recipe.outcomes outcomes decided q m) first with
      | ⟨L, gathered⟩ => ⟨L, fun t =>
        ⟨fun ⟨m, lead, lead'⟩ => (gathered t).mp ⟨m, (listed m).mp lead, lead'⟩,
         fun mem => match (gathered t).mpr mem with
          | ⟨m, inside, lead'⟩ => ⟨m, (listed m).mpr inside, lead'⟩⟩⟩
  | .choice p q, s =>
    match Recipe.outcomes outcomes decided p s, Recipe.outcomes outcomes decided q s with
    | ⟨l, listed⟩, ⟨l', listed'⟩ => ⟨l ++ l', fun t =>
      ⟨fun lead => match lead with
        | .inl first => mem_appended_left l' ((listed t).mp first)
        | .inr second => Granularity.mem_joined_right l ((listed' t).mp second),
       fun mem => match ListTests.mem_append_iff.mp mem with
        | .inl inside => .inl ((listed t).mpr inside)
        | .inr outside => .inr ((listed' t).mpr outside)⟩⟩

/-- **Histories of recipes match across two articulations where the finer readings agree.** Two
frames, each with its own finer moves and its own recipes for steps named alike: where the
readings of every test of recipes agree at `s` and `s'` and the second frame's moves have listed
outcomes, every history of recipes from `s` is matched by one from `s'` by the same named steps,
ending where the readings agree again. Each side follows its own recipe at the configurations it
reaches. Excluded middle is the named hypothesis. -/
theorem Frame.byRecipes_history_matches_of_em (em : ∀ p : Prop, Decided p) {F : Frame S A C}
    {F' : Frame S' D C} (left : B → Recipe A C) (right : B → Recipe D C)
    (outcomes' : ∀ s d, ∃ l : List S', ∀ t, F'.P.step s d t ↔ t ∈ l) {s : S} {s' : S'}
    (answers : ∀ φ : BranchingTest B C,
      BranchingTest.Holds F s (φ.byRecipes left) ↔ BranchingTest.Holds F' s' (φ.byRecipes right))
    {word : List B} {t : S} (path : Trace (F.byRecipes left).P s word t) :
    ∃ t', Trace (F'.byRecipes right).P s' word t' ∧
      ∀ φ : BranchingTest B C,
        BranchingTest.Holds F t (φ.byRecipes left) ↔ BranchingTest.Holds F' t' (φ.byRecipes right) :=
  Translates.history_matches_of_em em (Frame.byRecipes_translates (TestsDecided.of_em em F) left)
    (Frame.byRecipes_translates (TestsDecided.of_em em F') right)
    (fun s b => Recipe.outcomes outcomes' (TestsDecided.of_em em F') (right b) s) answers path

/-- Test first: where `φ` holds, go on by `yes`; where it fails, by `no`. -/
def Recipe.branch (φ : BranchingTest A C) (yes no : Recipe A C) : Recipe A C :=
  .choice (.seq (.guard φ) yes) (.seq (.guard (.not φ)) no)

/-- A branch leads by `yes` where its test holds and by `no` where it fails. -/
theorem Recipe.leads_branch_iff {F : Frame S A C} {φ : BranchingTest A C} {yes no : Recipe A C}
    {s t : S} :
    Recipe.Leads F (Recipe.branch φ yes no) s t ↔
      (BranchingTest.Holds F s φ ∧ Recipe.Leads F yes s t) ∨
        (¬ BranchingTest.Holds F s φ ∧ Recipe.Leads F no s t) :=
  ⟨fun leads => match leads with
    | .inl ⟨_, ⟨same, passes⟩, rest⟩ =>
      .inl ⟨passes, Eq.subst (motive := fun x => Recipe.Leads F yes x t) same.symm rest⟩
    | .inr ⟨_, ⟨same, fails⟩, rest⟩ =>
      .inr ⟨fails, Eq.subst (motive := fun x => Recipe.Leads F no x t) same.symm rest⟩,
   fun either => match either with
    | .inl ⟨passes, rest⟩ => .inl ⟨s, ⟨rfl, passes⟩, rest⟩
    | .inr ⟨fails, rest⟩ => .inr ⟨s, ⟨rfl, fails⟩, rest⟩⟩

/-- **Testing before a prefix is testing after it, where the prefix keeps the test at every
configuration it leads to.** The condition is sufficient; nothing about other tests is needed. -/
theorem Recipe.branch_earlier_iff {F : Frame S A C} {pre yes no : Recipe A C}
    {φ : BranchingTest A C} {s t : S}
    (stable : ∀ m, Recipe.Leads F pre s m →
      (BranchingTest.Holds F m φ ↔ BranchingTest.Holds F s φ)) :
    Recipe.Leads F (.seq pre (Recipe.branch φ yes no)) s t ↔
      Recipe.Leads F (Recipe.branch φ (.seq pre yes) (.seq pre no)) s t :=
  ⟨fun ⟨m, first, rest⟩ => Recipe.leads_branch_iff.mpr (match Recipe.leads_branch_iff.mp rest with
      | .inl ⟨passes, rest'⟩ => .inl ⟨(stable m first).mp passes, m, first, rest'⟩
      | .inr ⟨fails, rest'⟩ => .inr ⟨fun passes => fails ((stable m first).mpr passes), m, first, rest'⟩),
   fun leads => match Recipe.leads_branch_iff.mp leads with
    | .inl ⟨passes, m, first, rest⟩ =>
      ⟨m, first, Recipe.leads_branch_iff.mpr (.inl ⟨(stable m first).mpr passes, rest⟩)⟩
    | .inr ⟨fails, m, first, rest⟩ =>
      ⟨m, first, Recipe.leads_branch_iff.mpr
        (.inr ⟨fun passes => fails ((stable m first).mp passes), rest⟩)⟩⟩

end Recipes

/-! ## What remains of a recipe: partial courses and their resumption -/

section Remaining

variable {S : Type u} {S' : Type u'} {A : Type v} {C : Type w}

/-- One step of carrying out a recipe from a configuration: a move taken, a test passed where the
course stands, a finished first part dropped, the first part of a sequence advanced, or one side
of a choice taken. What remains and where the course stands advance together. -/
inductive Recipe.Advance (F : Frame S A C) : Recipe A C → S → Recipe A C → S → Prop where
  | move {a : A} {s t : S} : F.P.step s a t → Recipe.Advance F (.move a) s .skip t
  | guard {φ : BranchingTest A C} {s : S} :
      BranchingTest.Holds F s φ → Recipe.Advance F (.guard φ) s .skip s
  | seqSkip (q : Recipe A C) (s : S) : Recipe.Advance F (.seq .skip q) s q s
  | seq {p p' q : Recipe A C} {s t : S} :
      Recipe.Advance F p s p' t → Recipe.Advance F (.seq p q) s (.seq p' q) t
  | left (p q : Recipe A C) (s : S) : Recipe.Advance F (.choice p q) s p s
  | right (p q : Recipe A C) (s : S) : Recipe.Advance F (.choice p q) s q s

/-- The unfolding of carrying out recipes, with what remains and where the course stands as its
configuration. -/
def Recipe.unfolding (F : Frame S A C) : Process (Recipe A C × S) Unit :=
  ⟨fun c _ d => Recipe.Advance F c.1 c.2 d.1 d.2⟩

/-- Carrying out `p` from `s` part of the way can leave `r` remaining at `t`. -/
def Recipe.Leaves (F : Frame S A C) (p : Recipe A C) (s : S) (r : Recipe A C) (t : S) : Prop :=
  Reach (Recipe.unfolding F) (p, s) (r, t)

/-- One advance leaves what it advances to. -/
theorem Recipe.Advance.leaves {F : Frame S A C} {p p' : Recipe A C} {s t : S}
    (advance : Recipe.Advance F p s p' t) : Recipe.Leaves F p s p' t :=
  Reach.of_step (a := ()) advance

/-- What remains of a recipe after one advance, carried on to the end, carries the recipe to the
end. -/
theorem Recipe.Advance.resume {F : Frame S A C} {p p' : Recipe A C} {s t : S}
    (advance : Recipe.Advance F p s p' t) {finish : S} (rest : Recipe.Leads F p' t finish) :
    Recipe.Leads F p s finish := by
  induction advance generalizing finish with
  | move step => exact Eq.subst (motive := fun x => F.P.step _ _ x) rest step
  | guard passes => exact ⟨rest, passes⟩
  | seqSkip q s => exact ⟨s, rfl, rest⟩
  | seq _ ih => exact match rest with
    | ⟨m, first, second⟩ => ⟨m, ih first, second⟩
  | left p q s => exact .inl rest
  | right p q s => exact .inr rest

/-- What remains after a partial course, carried on to the end, carries the recipe to the end. -/
theorem Recipe.trace_resume {F : Frame S A C} {c d : Recipe A C × S} {schedule : List Unit}
    (path : Trace (Recipe.unfolding F) c schedule d) {finish : S}
    (rest : Recipe.Leads F d.1 d.2 finish) : Recipe.Leads F c.1 c.2 finish := by
  induction path with
  | nil => exact rest
  | cons step _ ih => exact Recipe.Advance.resume step (ih rest)

/-- **Resuming what remains completes the recipe.** -/
theorem Recipe.Leaves.resume {F : Frame S A C} {p r : Recipe A C} {s t finish : S}
    (leaves : Recipe.Leaves F p s r t) (rest : Recipe.Leads F r t finish) :
    Recipe.Leads F p s finish :=
  match leaves with
  | ⟨_, path⟩ => Recipe.trace_resume path rest

/-- An advance takes finer moves only: each is a course of the frame. -/
theorem Recipe.Advance.trace {F : Frame S A C} {p p' : Recipe A C} {s t : S}
    (advance : Recipe.Advance F p s p' t) : ∃ word, Trace F.P s word t := by
  induction advance with
  | move step => exact ⟨[_], .cons step (.nil _)⟩
  | guard _ => exact ⟨[], .nil _⟩
  | seqSkip q s => exact ⟨[], .nil _⟩
  | seq _ ih => exact ih
  | left p q s => exact ⟨[], .nil _⟩
  | right p q s => exact ⟨[], .nil _⟩

/-- A partial course takes a course of the frame from where it starts to where it stands. -/
theorem Recipe.trace_native {F : Frame S A C} {c d : Recipe A C × S} {schedule : List Unit}
    (path : Trace (Recipe.unfolding F) c schedule d) : ∃ word, Trace F.P c.2 word d.2 := by
  induction path with
  | nil => exact ⟨[], .nil _⟩
  | cons step _ ih => exact match Recipe.Advance.trace step, ih with
    | ⟨first, lead⟩, ⟨last, tail⟩ => ⟨first ++ last, trace_append_iff.mpr ⟨_, lead, tail⟩⟩

/-- **Every partial course is a course of the frame**: the bookkeeping of what remains adds no
move. -/
theorem Recipe.Leaves.trace {F : Frame S A C} {p r : Recipe A C} {s t : S}
    (leaves : Recipe.Leaves F p s r t) : ∃ word, Trace F.P s word t :=
  match leaves with
  | ⟨_, path⟩ => Recipe.trace_native path

/-- A partial course of the first part of a sequence is a partial course of the sequence, with the
second part still to come. -/
theorem Recipe.Leaves.seq {F : Frame S A C} {p r : Recipe A C} {s t : S}
    (leaves : Recipe.Leaves F p s r t) (q : Recipe A C) :
    Recipe.Leaves F (.seq p q) s (.seq r q) t :=
  match leaves with
  | ⟨schedule, path⟩ => ⟨schedule, trace_map (Q := Recipe.unfolding F)
      (f := fun c => (Recipe.seq c.1 q, c.2)) (fun _ _ _ advance => Recipe.Advance.seq advance) path⟩

/-- Where a recipe leads, carrying it out leaves nothing there. -/
theorem Recipe.Leads.leaves {F : Frame S A C} :
    ∀ {p : Recipe A C} {s t : S}, Recipe.Leads F p s t → Recipe.Leaves F p s .skip t
  | .skip, s, _, same =>
    Eq.subst (motive := fun x => Recipe.Leaves F .skip s .skip x) same (Reach.refl _ _)
  | .move _, _, _, step => (Recipe.Advance.move step).leaves
  | .guard φ, s, _, ⟨same, passes⟩ =>
    Eq.subst (motive := fun x => Recipe.Leaves F (.guard φ) s .skip x) same
      (Recipe.Advance.guard passes).leaves
  | .seq _ q, _, _, ⟨m, first, second⟩ =>
    ((Recipe.Leads.leaves first).seq q).trans
      ((Recipe.Advance.seqSkip q m).leaves.trans (Recipe.Leads.leaves second))
  | .choice p q, s, _, .inl first => (Recipe.Advance.left p q s).leaves.trans (Recipe.Leads.leaves first)
  | .choice p q, s, _, .inr second =>
    (Recipe.Advance.right p q s).leaves.trans (Recipe.Leads.leaves second)

/-- **Carrying a recipe out to the end is a partial course that leaves nothing.** -/
theorem Recipe.leads_iff_leaves (F : Frame S A C) (p : Recipe A C) (s t : S) :
    Recipe.Leads F p s t ↔ Recipe.Leaves F p s .skip t :=
  ⟨Recipe.Leads.leaves, fun leaves => leaves.resume rfl⟩

/-- **A course resumed after inserted moves is one course of the frame**: the partial course, the
inserted moves and the resumption from where those moves led join through their actual
boundaries. It does not say the inserted moves were part of the recipe. -/
theorem Recipe.Leaves.inserted {F : Frame S A C} {p r : Recipe A C} {s reached current finish : S}
    {inserted : List A} (leaves : Recipe.Leaves F p s r reached)
    (change : Trace F.P reached inserted current) (resume : Recipe.Leads F r current finish) :
    ∃ first last, Trace F.P s first reached ∧ Trace F.P current last finish ∧
      Trace F.P s (first ++ inserted ++ last) finish :=
  match leaves.trace, resume.trace with
  | ⟨first, lead⟩, ⟨last, tail⟩ =>
    ⟨first, last, lead, tail,
     trace_append_iff.mpr ⟨current, trace_append_iff.mpr ⟨reached, lead, change⟩, tail⟩⟩

/-- An advance from a configuration is matched from an alike one by the same advance, into alike
configurations. -/
theorem Recipe.Advance.alike {F : Frame S A C} {G : Frame S' A C} {p p' : Recipe A C} {s t : S}
    (advance : Recipe.Advance F p s p' t) {s' : S'} (alike : Alike F G s s') :
    ∃ t', Recipe.Advance G p s' p' t' ∧ Alike F G t t' := by
  induction advance generalizing s' with
  | move step => exact match alike.step step with
    | ⟨t', step', joined⟩ => ⟨t', .move step', joined⟩
  | guard passes => exact ⟨s', .guard ((Alike.holds_iff _ alike).mp passes), alike⟩
  | seqSkip q s => exact ⟨s', .seqSkip q s', alike⟩
  | seq _ ih => exact match ih alike with
    | ⟨t', advance', joined⟩ => ⟨t', .seq advance', joined⟩
  | left p q s => exact ⟨s', .left p q s', alike⟩
  | right p q s => exact ⟨s', .right p q s', alike⟩

/-- Under excluded middle, an advance from a configuration is matched from one passing the same
tests, into configurations passing the same tests, where the outcomes of the second frame's moves
are listed. -/
theorem Recipe.Advance.same_of_em (em : ∀ p : Prop, Decided p) {F : Frame S A C}
    {G : Frame S' A C} (outcomes' : ∀ s a, ∃ l : List S', ∀ t, G.P.step s a t ↔ t ∈ l)
    {p p' : Recipe A C} {s t : S} (advance : Recipe.Advance F p s p' t) {s' : S'}
    (same : SameBranchingTests F G s s') :
    ∃ t', Recipe.Advance G p s' p' t' ∧ SameBranchingTests F G t t' := by
  induction advance generalizing s' with
  | move step => exact match SameBranchingTests.step_of_em em outcomes' same step with
    | ⟨t', step', joined⟩ => ⟨t', .move step', joined⟩
  | guard passes => exact ⟨s', .guard ((same _).mp passes), same⟩
  | seqSkip q s => exact ⟨s', .seqSkip q s', same⟩
  | seq _ ih => exact match ih same with
    | ⟨t', advance', joined⟩ => ⟨t', .seq advance', joined⟩
  | left p q s => exact ⟨s', .left p q s', same⟩
  | right p q s => exact ⟨s', .right p q s', same⟩

/-- Partial courses from alike configurations match, keeping what remains. -/
theorem Recipe.trace_alike {F : Frame S A C} {G : Frame S' A C} {c d : Recipe A C × S}
    {schedule : List Unit} (path : Trace (Recipe.unfolding F) c schedule d) :
    ∀ {s' : S'}, Alike F G c.2 s' →
      ∃ t', Trace (Recipe.unfolding G) (c.1, s') schedule (d.1, t') ∧ Alike F G d.2 t' := by
  induction path with
  | nil =>
    intro s' alike
    exact ⟨s', .nil _, alike⟩
  | @cons _ m _ _ _ step _ ih =>
    intro s' alike
    exact match Recipe.Advance.alike step alike with
    | ⟨m', advance', joined⟩ => match ih joined with
      | ⟨t', path', joined'⟩ => ⟨t', Trace.cons (m := (m.1, m')) advance' path', joined'⟩

/-- **Partial courses from alike configurations match**, keeping what remains of the recipe and
ending alike, with no premise. -/
theorem Recipe.Leaves.alike {F : Frame S A C} {G : Frame S' A C} {p r : Recipe A C} {s t : S}
    (leaves : Recipe.Leaves F p s r t) {s' : S'} (alike : Alike F G s s') :
    ∃ t', Recipe.Leaves G p s' r t' ∧ Alike F G t t' :=
  match leaves with
  | ⟨schedule, path⟩ => match Recipe.trace_alike path alike with
    | ⟨t', path', joined⟩ => ⟨t', ⟨schedule, path'⟩, joined⟩

/-- Under excluded middle, partial courses from configurations passing the same tests match. -/
theorem Recipe.trace_same_of_em (em : ∀ p : Prop, Decided p) {F : Frame S A C}
    {G : Frame S' A C} (outcomes' : ∀ s a, ∃ l : List S', ∀ t, G.P.step s a t ↔ t ∈ l)
    {c d : Recipe A C × S} {schedule : List Unit} (path : Trace (Recipe.unfolding F) c schedule d) :
    ∀ {s' : S'}, SameBranchingTests F G c.2 s' →
      ∃ t', Trace (Recipe.unfolding G) (c.1, s') schedule (d.1, t') ∧
        SameBranchingTests F G d.2 t' := by
  induction path with
  | nil =>
    intro s' same
    exact ⟨s', .nil _, same⟩
  | @cons _ m _ _ _ step _ ih =>
    intro s' same
    exact match Recipe.Advance.same_of_em em outcomes' step same with
    | ⟨m', advance', joined⟩ => match ih joined with
      | ⟨t', path', joined'⟩ => ⟨t', Trace.cons (m := (m.1, m')) advance' path', joined'⟩

/-- **Under excluded middle, partial courses from configurations passing the same tests match**,
keeping what remains of the recipe and ending where the same tests pass, where the outcomes of
the second frame's moves are listed. -/
theorem Recipe.Leaves.same_of_em (em : ∀ p : Prop, Decided p) {F : Frame S A C}
    {G : Frame S' A C} (outcomes' : ∀ s a, ∃ l : List S', ∀ t, G.P.step s a t ↔ t ∈ l)
    {p r : Recipe A C} {s t : S} (leaves : Recipe.Leaves F p s r t) {s' : S'}
    (same : SameBranchingTests F G s s') :
    ∃ t', Recipe.Leaves G p s' r t' ∧ SameBranchingTests F G t t' :=
  match leaves with
  | ⟨schedule, path⟩ => match Recipe.trace_same_of_em em outcomes' path same with
    | ⟨t', path', joined⟩ => ⟨t', ⟨schedule, path'⟩, joined⟩

/-- A configuration of a partial course, what remains with where it stands, resumes to where a
test holds. -/
def Recipe.Resumes (F : Frame S A C) (c : Recipe A C × S) (φ : BranchingTest A C) : Prop :=
  ∃ t, Recipe.Leads F c.1 c.2 t ∧ BranchingTest.Holds F t φ

/-- **A description exact for resumption keeps apart what resumes differently.** -/
theorem Recipe.Resumes.codes_apart {F : Frame S A C} {K : Type x} {π : Recipe A C × S → K}
    (exact : ∀ c d, π c = π d → ∀ φ, Recipe.Resumes F c φ ↔ Recipe.Resumes F d φ)
    {c d : Recipe A C × S} {φ : BranchingTest A C} (resumes : Recipe.Resumes F c φ)
    (not_resumes : ¬ Recipe.Resumes F d φ) : π c ≠ π d :=
  fun same => not_resumes ((exact c d same φ).mp resumes)

end Remaining

/-! ## A loss midway through a block: the witness -/

namespace Midway

/-- Configurations: from `origin`, `enter` reaches `risky` or `safe`; `begin` takes `risky` to
`ready` or `blocked` and `safe` to `ready`; `finish` takes `ready` to `done`. -/
inductive Phase where
  | origin
  | risky
  | safe
  | ready
  | blocked
  | done

/-- The moves. -/
inductive Event where
  | enter
  | begin
  | finish

/-- The steps of the one unfolding. -/
inductive Step : Phase → Event → Phase → Prop where
  | enterRisky : Step .origin .enter .risky
  | enterSafe : Step .origin .enter .safe
  | riskyReady : Step .risky .begin .ready
  | riskyBlocked : Step .risky .begin .blocked
  | safeReady : Step .safe .begin .ready
  | readyDone : Step .ready .finish .done

/-- The frame, with no claims: whatever differs is in the steps. -/
def frame : Frame Phase Event Empty :=
  ⟨⟨Step⟩, fun _ c => nomatch c⟩

/-- Both branches come from the one origin. -/
theorem shared_origin : Trace frame.P .origin [.enter] .risky ∧ Trace frame.P .origin [.enter] .safe :=
  ⟨.cons Step.enterRisky (.nil _), .cons Step.enterSafe (.nil _)⟩

/-- The completed block: `begin` then `finish`. -/
def completed (_ : Unit) : List Event := [.begin, .finish]

/-- The nonempty prefixes of the completed block: `begin`, and `begin` then `finish`. -/
def prefixes : Bool → List Event
  | true => [.begin, .finish]
  | false => [.begin]

/-- The suffix exposed at the reached configuration: `finish`, or `begin`. -/
def resumable : Bool → List Event
  | true => [.finish]
  | false => [.begin]

/-- The completed block leads only to `done`. -/
theorem completed_done {s t : Phase} (path : Trace frame.P s [.begin, .finish] t) : t = .done := by
  cases path with
  | cons _ rest =>
    cases rest with
    | cons second last =>
      cases last
      have second' : Step _ .finish _ := second
      cases second'
      rfl

/-- From `risky` and from `safe` the completed block leads to `done`. -/
theorem completes : Trace frame.P .risky [.begin, .finish] .done ∧
    Trace frame.P .safe [.begin, .finish] .done :=
  ⟨.cons Step.riskyReady (.cons Step.readyDone (.nil _)),
   .cons Step.safeReady (.cons Step.readyDone (.nil _))⟩

/-- Read in completed blocks, `risky` and `safe` are related, and each configuration to itself. -/
def CompletedRelated (s s' : Phase) : Prop :=
  s = s' ∨ (s = .risky ∧ s' = .safe)

/-- Relating `risky` to `safe` is a bisimulation of the completed blocks. -/
theorem completed_bisimulation :
    Bisimulation (frame.blocks completed) (frame.blocks completed) CompletedRelated := by
  intro s s' related
  cases related with
  | inl same =>
    subst same
    exact ⟨fun _ => Iff.rfl, fun _ t step => ⟨t, step, .inl rfl⟩, fun _ t step => ⟨t, step, .inl rfl⟩⟩
  | inr both =>
    cases both with
    | intro at_s at_s' =>
      subst at_s
      subst at_s'
      exact ⟨fun c => (nomatch c),
        fun _ _ path => ⟨.done, completes.2, .inl (completed_done path)⟩,
        fun _ _ path' => ⟨.done, completes.1, .inl (completed_done path').symm⟩⟩

/-- **Completed blocks hide the branch**: `risky` and `safe` are alike in them, and so pass the
same tests of completed blocks. -/
theorem same_completed_tests :
    Alike (frame.blocks completed) (frame.blocks completed) .risky .safe ∧
      SameBranchingTests (frame.blocks completed) (frame.blocks completed) .risky .safe :=
  have alike : Alike (frame.blocks completed) (frame.blocks completed) .risky .safe :=
    ⟨_, completed_bisimulation, .inr ⟨rfl, rfl⟩⟩
  ⟨alike, alike.sameBranchingTests⟩

/-- That `begin` can lead to where `finish` cannot be taken: a continuation lost midway. -/
def lost : BranchingTest Event Empty := .can .begin (.not (.can .finish .top))

/-- **The loss is real**: from `risky` the continuation can be lost midway, from `safe` it
cannot. -/
theorem internal_loss :
    BranchingTest.Holds frame .risky lost ∧ ¬ BranchingTest.Holds frame .safe lost :=
  ⟨⟨.blocked, Step.riskyBlocked, fun ⟨_, step, _⟩ => (nomatch (step : Step .blocked .finish _))⟩,
   fun ⟨t, step, fails⟩ => match t, (step : Step .safe .begin t) with
    | .ready, Step.safeReady => fails ⟨.done, Step.readyDone, True.intro⟩⟩

/-- **Every description exact for the finer tests keeps `risky` and `safe` apart.** -/
theorem codes_apart {K : Type x} {π : Phase → K}
    (exact : ∀ s t, π s = π t → SameBranchingTests frame frame s t) : π .risky ≠ π .safe :=
  fun same => internal_loss.2 ((exact _ _ same lost).mp internal_loss.1)

/-- A configuration from which no block of prefixes leads anywhere. -/
theorem prefixes_stuck {s : Phase} (stuck : ∀ a t, ¬ Step s a t) :
    ∀ b t, ¬ (frame.blocks prefixes).P.step s b t
  | true, _, .cons step _ => stuck _ _ step
  | false, _, .cons step _ => stuck _ _ step

/-- `ready` takes no `begin`, `blocked` and `done` no step. -/
theorem ready_no_begin : ∀ t, ¬ Step .ready .begin t := fun _ step => nomatch step
theorem blocked_stuck : ∀ a t, ¬ Step .blocked a t := fun _ _ step => nomatch step

/-- `ready` takes no block of prefixes. -/
theorem ready_stuck : ∀ b t, ¬ (frame.blocks prefixes).P.step .ready b t
  | true, _, .cons step _ => ready_no_begin _ step
  | false, _, .cons step _ => ready_no_begin _ step

/-- Read in prefixes, `risky` is related to `safe` and `blocked` to `ready`, and each
configuration to itself. -/
def PrefixRelated (s s' : Phase) : Prop :=
  s = s' ∨ (s = .risky ∧ s' = .safe) ∨ (s = .blocked ∧ s' = .ready)

/-- The steps of prefixes from `risky`. -/
theorem risky_prefix_steps {b : Bool} {t : Phase} (path : (frame.blocks prefixes).P.step .risky b t) :
    (b = true ∧ t = .done) ∨ (b = false ∧ (t = .ready ∨ t = .blocked)) := by
  cases b with
  | true =>
    have path' : Trace frame.P .risky [.begin, .finish] t := path
    exact .inl ⟨rfl, completed_done path'⟩
  | false =>
    have path' : Trace frame.P .risky [.begin] t := path
    cases path' with
    | cons first last =>
      cases last
      have first' : Step .risky .begin _ := first
      cases first' with
      | riskyReady => exact .inr ⟨rfl, .inl rfl⟩
      | riskyBlocked => exact .inr ⟨rfl, .inr rfl⟩

/-- The steps of prefixes from `safe`. -/
theorem safe_prefix_steps {b : Bool} {t : Phase} (path : (frame.blocks prefixes).P.step .safe b t) :
    (b = true ∧ t = .done) ∨ (b = false ∧ t = .ready) := by
  cases b with
  | true =>
    have path' : Trace frame.P .safe [.begin, .finish] t := path
    exact .inl ⟨rfl, completed_done path'⟩
  | false =>
    have path' : Trace frame.P .safe [.begin] t := path
    cases path' with
    | cons first last =>
      cases last
      have first' : Step .safe .begin _ := first
      cases first'
      exact .inr ⟨rfl, rfl⟩

/-- From `safe`, prefixes lead to `done` by the whole block and to `ready` by `begin`. -/
theorem safe_prefixes : (frame.blocks prefixes).P.step .safe true .done ∧
    (frame.blocks prefixes).P.step .safe false .ready :=
  ⟨.cons Step.safeReady (.cons Step.readyDone (.nil _)), .cons Step.safeReady (.nil _)⟩

/-- From `risky`, prefixes lead to `done` by the whole block and to `ready` by `begin`. -/
theorem risky_prefixes : (frame.blocks prefixes).P.step .risky true .done ∧
    (frame.blocks prefixes).P.step .risky false .ready :=
  ⟨.cons Step.riskyReady (.cons Step.readyDone (.nil _)), .cons Step.riskyReady (.nil _)⟩

/-- Relating `risky` to `safe` and `blocked` to `ready` is a bisimulation of the prefixes. -/
theorem prefix_bisimulation :
    Bisimulation (frame.blocks prefixes) (frame.blocks prefixes) PrefixRelated := by
  intro s s' related
  cases related with
  | inl same =>
    subst same
    exact ⟨fun _ => Iff.rfl, fun _ t step => ⟨t, step, .inl rfl⟩, fun _ t step => ⟨t, step, .inl rfl⟩⟩
  | inr other =>
    cases other with
    | inl both =>
      cases both with
      | intro at_s at_s' =>
        subst at_s
        subst at_s'
        refine ⟨fun c => (nomatch c), ?_, ?_⟩
        · intro b t path
          cases risky_prefix_steps path with
          | inl whole =>
            cases whole with
            | intro by_whole to =>
              subst by_whole
              subst to
              exact ⟨.done, safe_prefixes.1, .inl rfl⟩
          | inr part =>
            cases part with
            | intro by_begin to =>
              subst by_begin
              cases to with
              | inl to => exact ⟨.ready, safe_prefixes.2, .inl to⟩
              | inr to => exact ⟨.ready, safe_prefixes.2, .inr (.inr ⟨to, rfl⟩)⟩
        · intro b t path'
          cases safe_prefix_steps path' with
          | inl whole =>
            cases whole with
            | intro by_whole to =>
              subst by_whole
              subst to
              exact ⟨.done, risky_prefixes.1, .inl rfl⟩
          | inr part =>
            cases part with
            | intro by_begin to =>
              subst by_begin
              subst to
              exact ⟨.ready, risky_prefixes.2, .inl rfl⟩
    | inr both =>
      cases both with
      | intro at_s at_s' =>
        subst at_s
        subst at_s'
        exact ⟨fun c => (nomatch c),
          fun b t path => absurd path (prefixes_stuck blocked_stuck b t),
          fun b t path' => absurd path' (ready_stuck b t)⟩

/-- **All nonempty prefixes still hide the loss**: read in blocks of every nonempty prefix of the
completed block, `risky` and `safe` are alike, and so pass the same tests of prefixes. -/
theorem same_prefix_tests :
    Alike (frame.blocks prefixes) (frame.blocks prefixes) .risky .safe ∧
      SameBranchingTests (frame.blocks prefixes) (frame.blocks prefixes) .risky .safe :=
  have alike : Alike (frame.blocks prefixes) (frame.blocks prefixes) .risky .safe :=
    ⟨_, prefix_bisimulation, .inr (.inl ⟨rfl, rfl⟩)⟩
  ⟨alike, alike.sameBranchingTests⟩

/-- **No test of prefixes reads the loss**: no branching test of the prefix blocks holds exactly
where the continuation can be lost midway. Richer tests are not excluded. -/
theorem no_prefix_reading :
    ¬ ∃ φ : BranchingTest Bool Empty, ∀ s,
      BranchingTest.Holds (frame.blocks prefixes) s φ ↔ BranchingTest.Holds frame s lost :=
  fun ⟨φ, reads⟩ => internal_loss.2 ((reads .safe).mp
    ((same_prefix_tests.2 φ).mp ((reads .risky).mpr internal_loss.1)))

/-- **Exposing the suffix at the reached configuration recovers the loss**: the test that `begin`
can lead to where `finish` cannot be taken, of the blocks `begin` and `finish`, holds at `risky`
and fails at `safe`. -/
theorem resumption_recovers_loss :
    BranchingTest.Holds (frame.blocks resumable) .risky (.can false (.not (.can true .top))) ∧
      ¬ BranchingTest.Holds (frame.blocks resumable) .safe (.can false (.not (.can true .top))) :=
  ⟨(frame.holds_blocks resumable _ .risky).mpr internal_loss.1,
   fun holds => internal_loss.2 ((frame.holds_blocks resumable _ .safe).mp holds)⟩

/-- **A description reduced to the prefix tests cannot be extended to an exact account of the
finer tests**: where codes agree on whatever passes the same tests of prefixes, no reading of the
codes answers every finer test exactly. -/
theorem reduced_prefix_cannot_extend {K : Type x} {π : Phase → K}
    (reduced : ∀ s t, SameBranchingTests (frame.blocks prefixes) (frame.blocks prefixes) s t →
      π s = π t) :
    ¬ ∃ read : K → BranchingTest Event Empty → Prop,
      ∀ s φ, read (π s) φ ↔ BranchingTest.Holds frame s φ :=
  fun ⟨read, exact⟩ => internal_loss.2 ((exact .safe lost).mp
    (Eq.subst (motive := fun k => read k lost) (reduced _ _ same_prefix_tests.2)
      ((exact .risky lost).mpr internal_loss.1)))

/-! ### Recipes on the witness -/

/-- That `finish` can be taken. -/
def canFinish : BranchingTest Event Empty := .can .finish .top

/-- **Forming changes the test**: `begin` takes `safe` to `ready`; `finish` cannot be taken at
`safe` and can at `ready`. -/
theorem formation_changes_guard : frame.P.step .safe .begin .ready ∧
    ¬ BranchingTest.Holds frame .safe canFinish ∧ BranchingTest.Holds frame .ready canFinish :=
  ⟨Step.safeReady, fun ⟨_, step, _⟩ => (nomatch (step : Step .safe .finish _)),
   ⟨.done, Step.readyDone, True.intro⟩⟩

/-- Begin, then finish where finishing can be taken, and otherwise stop. -/
def adaptive : Recipe Event Empty :=
  .seq (.move .begin) (Recipe.branch canFinish (.move .finish) .skip)

/-- Test at the start whether finishing can be taken: if so, begin and finish; if not, begin. -/
def earlyCheck : Recipe Event Empty :=
  Recipe.branch canFinish (.seq (.move .begin) (.move .finish)) (.move .begin)

/-- **Testing before formation changes the result**: from `safe`, the recipe testing where it has
arrived reaches `done`, and the recipe testing at the start does not. -/
theorem testing_before_formation_changes_results :
    Recipe.Leads frame adaptive .safe .done ∧ ¬ Recipe.Leads frame earlyCheck .safe .done :=
  ⟨⟨.ready, Step.safeReady, Recipe.leads_branch_iff.mpr
      (.inl ⟨⟨.done, Step.readyDone, True.intro⟩, Step.readyDone⟩)⟩,
   fun leads => match Recipe.leads_branch_iff.mp leads with
    | .inl ⟨passes, _⟩ => formation_changes_guard.2.1 passes
    | .inr ⟨_, step⟩ => nomatch (step : Step .safe .begin .done)⟩

/-- Either begin and finish, or only begin. -/
def pending : Recipe Event Empty :=
  .choice (.seq (.move .begin) (.move .finish)) (.move .begin)

/-- **One start and one reached configuration leave different remainders**: from `safe`, carrying
out `pending` can stand at `ready` with `finish` remaining or with nothing remaining. -/
theorem same_start_distinct_remainders :
    Recipe.Leaves frame pending .safe (.move .finish) .ready ∧
      Recipe.Leaves frame pending .safe .skip .ready :=
  ⟨(Recipe.Advance.left _ _ _).leaves.trans
      ((Recipe.Advance.seq (Recipe.Advance.move Step.safeReady)).leaves.trans
        (Recipe.Advance.seqSkip _ _).leaves),
   (Recipe.Advance.right _ _ _).leaves.trans (Recipe.Advance.move Step.safeReady).leaves⟩

/-- What remains changes the continuation: at `ready`, with `finish` remaining the course can reach
where `finish` cannot be taken; with nothing remaining it cannot. -/
theorem remainder_changes_continuation :
    Recipe.Resumes frame (.move .finish, .ready) (.not canFinish) ∧
      ¬ Recipe.Resumes frame (.skip, .ready) (.not canFinish) :=
  ⟨⟨.done, Step.readyDone, fun ⟨_, step, _⟩ => (nomatch (step : Step .done .finish _))⟩,
   fun ⟨_, same, fails⟩ => fails (Eq.subst (motive := fun x => BranchingTest.Holds frame x canFinish)
      same ⟨.done, Step.readyDone, True.intro⟩)⟩

/-- **Every description exact for resumption keeps the remainders apart**, at one configuration
reached from one start. -/
theorem remainder_codes_apart {K : Type x} {π : Recipe Event Empty × Phase → K}
    (exact : ∀ c d, π c = π d → ∀ φ, Recipe.Resumes frame c φ ↔ Recipe.Resumes frame d φ) :
    π (.move .finish, .ready) ≠ π (.skip, .ready) :=
  Recipe.Resumes.codes_apart exact remainder_changes_continuation.1 remainder_changes_continuation.2

/-- **Inserted moves can disable what remains**: `finish` taken from `ready` reaches `done`, where
the `finish` still remaining cannot be taken. -/
theorem inserted_can_disable_resumption :
    frame.P.step .ready .finish .done ∧ Recipe.Leads frame (.move .finish) .ready .done ∧
      ¬ ∃ t, Recipe.Leads frame (.move .finish) .done t :=
  ⟨Step.readyDone, Step.readyDone, fun ⟨_, step⟩ => nomatch (step : Step .done .finish _)⟩

/-- The inserted move changes what the configuration passes. -/
theorem inserted_changes_tests : ¬ SameBranchingTests frame frame .ready .done :=
  fun same => match (same canFinish).mp ⟨.done, Step.readyDone, True.intro⟩ with
  | ⟨_, step, _⟩ => nomatch (step : Step .done .finish _)

end Midway

end Becoming

section Grains

/-!
## Grains: what remained of reading one unfolding at two grains

`Becoming.Granularity` reads one unfolding at a coarser grain, by blocks and by recipes. This
module states the laws of that reading the core did not yet state.

* **Renaming then reading finer returns the test.** Where every finer move is a block of its own,
  a finer test renamed into blocks and read back at the finer grain is the test itself
  (`BranchingTest.finer_rename`), as an equality of tests, not only of where they hold.
* **Either of two tests.** `BranchingTest.either` holds where neither fails; where both tests are
  decided at a configuration, it holds exactly where one of them does
  (`BranchingTest.holds_either`).
* **Histories of recipes are finer courses.** Every history of the frame of recipes is a course of
  the finer moves (`Frame.byRecipes_trace`).
* **Configurations with no step are alike** where they realize the same claims
  (`Alike.of_stuck`), so they pass the same branching tests.
* **The witness** `Midway` has six configurations (`Midway.exists_phase`).

Every declaration's axiom report is empty; the decision of the two tests is a named hypothesis
where it is used. Ported from `Generative.ExplanatoryGranularity`,
`Generative.ExplanatoryGuardedPrograms` and `Generative.ExplanatoryGranularityBoundary` (bridge
fold F3E, 18 October 2026); the port is a restatement in the core, not a new result. The
periphery's `liftTest`, `compile`, `either`, `programModel` and `terminal_questions` are
`BranchingTest.rename`, `BranchingTest.finer`, `BranchingTest.either`, `Frame.byRecipes` and
`Alike.of_stuck`.
-/

namespace Becoming

open Generative

universe u u' v w

variable {S : Type u} {S' : Type u'} {A B : Type v} {C : Type w}

/-- **A finer test renamed into blocks of single moves and read back at the finer grain is the
test itself.** -/
theorem BranchingTest.finer_rename (expand : B → List A) (name : A → B)
    (single : ∀ a, expand (name a) = [a]) :
    ∀ φ : BranchingTest A C, BranchingTest.finer expand (φ.rename name) = φ
  | .top => rfl
  | .claim _ => rfl
  | .not φ => by
    show BranchingTest.not (BranchingTest.finer expand (φ.rename name)) = .not φ
    rw [BranchingTest.finer_rename expand name single φ]
  | .both φ ψ => by
    show BranchingTest.both (BranchingTest.finer expand (φ.rename name))
      (BranchingTest.finer expand (ψ.rename name)) = .both φ ψ
    rw [BranchingTest.finer_rename expand name single φ, BranchingTest.finer_rename expand name single ψ]
  | .can a φ => by
    show BranchingTest.along (expand (name a)) (BranchingTest.finer expand (φ.rename name)) = .can a φ
    rw [single a, BranchingTest.finer_rename expand name single φ]
    rfl

/-- **Where two tests are decided at a configuration, either of them holds exactly where one of
them does.** -/
theorem BranchingTest.holds_either {F : Frame S A C} {s : S} {φ ψ : BranchingTest A C}
    (decided : Decided (BranchingTest.Holds F s φ)) (decided' : Decided (BranchingTest.Holds F s ψ)) :
    BranchingTest.Holds F s (BranchingTest.either φ ψ) ↔
      BranchingTest.Holds F s φ ∨ BranchingTest.Holds F s ψ :=
  ⟨fun neither => match decided, decided' with
    | .inl holds, _ => .inl holds
    | _, .inl holds => .inr holds
    | .inr fails, .inr fails' => False.elim (neither ⟨fails, fails'⟩),
   fun one ⟨fails, fails'⟩ => match one with
    | .inl holds => fails holds
    | .inr holds => fails' holds⟩

/-- **Every history of the frame of recipes is a course of the finer moves.** -/
theorem Frame.byRecipes_trace {F : Frame S A C} {recipe : B → Recipe A C} {s t : S}
    {word : List B} (path : Trace (F.byRecipes recipe).P s word t) : ∃ w, Trace F.P s w t := by
  induction path with
  | nil s => exact ⟨[], .nil s⟩
  | cons step _ rest =>
    match Recipe.Leads.trace step, rest with
    | ⟨w, first⟩, ⟨w', second⟩ => exact ⟨w ++ w', trace_append_iff.mpr ⟨_, first, second⟩⟩

/-- **Configurations with no step that realize the same claims are alike.** -/
theorem Alike.of_stuck {F : Frame S A C} {G : Frame S' A C} {s : S} {s' : S'}
    (claims : ∀ c, F.realized s c ↔ G.realized s' c) (stuck : ∀ a t, ¬ F.P.step s a t)
    (stuck' : ∀ a t, ¬ G.P.step s' a t) : Alike F G s s' :=
  ⟨fun x y => x = s ∧ y = s', fun x y related => by
    cases related.1
    cases related.2
    exact ⟨claims, fun a t step => absurd step (stuck a t), fun a t step => absurd step (stuck' a t)⟩,
   rfl, rfl⟩

/-- **Configurations with no step and no claims pass the same branching tests.** -/
theorem SameBranchingTests.of_stuck {F : Frame S A Empty} {G : Frame S' A Empty} {s : S} {s' : S'}
    (stuck : ∀ a t, ¬ F.P.step s a t) (stuck' : ∀ a t, ¬ G.P.step s' a t) :
    SameBranchingTests F G s s' :=
  (Alike.of_stuck (fun c => nomatch c) stuck stuck').sameBranchingTests

/-- **`Midway` has six configurations.** -/
theorem Midway.exists_phase (p : Midway.Phase → Prop) :
    (∃ s, p s) ↔ p .origin ∨ p .risky ∨ p .safe ∨ p .ready ∨ p .blocked ∨ p .done :=
  ⟨fun ⟨s, holds⟩ => match s, holds with
    | .origin, holds => .inl holds
    | .risky, holds => .inr (.inl holds)
    | .safe, holds => .inr (.inr (.inl holds))
    | .ready, holds => .inr (.inr (.inr (.inl holds)))
    | .blocked, holds => .inr (.inr (.inr (.inr (.inl holds))))
    | .done, holds => .inr (.inr (.inr (.inr (.inr holds)))),
   fun one => match one with
    | .inl holds => ⟨_, holds⟩
    | .inr (.inl holds) => ⟨_, holds⟩
    | .inr (.inr (.inl holds)) => ⟨_, holds⟩
    | .inr (.inr (.inr (.inl holds))) => ⟨_, holds⟩
    | .inr (.inr (.inr (.inr (.inl holds)))) => ⟨_, holds⟩
    | .inr (.inr (.inr (.inr (.inr holds)))) => ⟨_, holds⟩⟩

end Becoming

end Grains
