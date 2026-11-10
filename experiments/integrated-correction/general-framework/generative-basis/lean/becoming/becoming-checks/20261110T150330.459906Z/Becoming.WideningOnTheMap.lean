import Becoming.KeepingWidening
import Becoming.HeldPossible

/-!
# Keeping widening on the map: generation that loses nothing (广即不失之生成)

07's widening and the map's generation (`Becoming.GrammarMap`) read on one line. Read a course's
moments with the relation of the next step (`Steps.next`), and what is held at each moment as a
chain of predicates `Q`, such as what levels admit along a course. Read them as the map reads, in
two places:

* in the coarse place, **nothing lost** (`Steps.includes`): from `n` to `m` everything held at `n`
  is held at `m`. It is a preorder in the place of the map's coarse class, not a class: a symmetric
  relation there could not tell loss from gain. Its line goes on exactly while nothing is lost at
  each step (`Steps.buqiong_includes_iff`), and nothing is lost across any stretch exactly where
  nothing is lost across each step (`Steps.includesFrom_iff`);
* in the fine place, **the same possible** (`Steps.same`), a class finer than it
  (`Steps.same_class`, `Steps.same_includes`). A line under it begins at a step exactly where the
  step changes what is held (`Steps.begins_iff`).

The fine class is fixed apart from widening. The coarse relation is not: it is keeping widening's
own inclusion half, defined from what is held and not through `Widens`. Then:

* **The representation: keeping widening is 全生成 at (nothing lost, the same possible), both ways,
  under two premises.** Where each point is, at each moment, refuted or unrefuted there, keeping
  widening from a moment gives 全生成 there (`Steps.generation_of_keepsWidening`): the step at which
  a new point arrives is located, with the point (`Steps.change_located`). Where, wherever not
  everything held after a step was held before, something new there is found, 全生成 gives keeping
  widening (`Steps.keepsWidening_of_generation`); a listing of each moment's holding, with what is
  held decided, gives that premise (`Steps.found_of_listed`). With neither premise, 全生成 gives
  nothing lost and, after every step, a step after which not everything held was held before
  (`Steps.includes_not_back_of_generation`). With both, the two are one
  (`Steps.generation_iff_keepsWidening`). Keeping widening from a moment is 07's chain form of the
  chain shifted to it (`Steps.keepsWideningFrom_iff_shift`; from the first moment,
  `Steps.keepsWidening_iff_from_zero` and `Steps.generation_of_reachingKeepsWidening`).
* **The join with both classes fixed apart: generation that loses nothing, parted by exactly
  loss.** 全生成 at (nothing lost, the same possible) is 全生成 at (the one, the same possible),
  where what is held changes after every moment, together with nothing lost, with no premise
  (`Steps.generation_includes_iff`). So, under the same two premises, keeping widening is
  generation under (the one, the same possible) that loses nothing
  (`Steps.keepsWidening_iff_generation_losing_nothing`). A possible that moves at every step,
  holding one point and losing it at the next, is 全生成 under the one at every moment and keeps
  widening from none (`Steps.Moving.generation`, `Steps.Moving.not_generation_includes`,
  `Steps.Moving.not_keepsWidening`). A possible that gains a point at every step and loses none has
  both from every moment (`Steps.Growing.keepsWidening`, `Steps.Growing.generation`).
* **What each premise says about the course.** Generation is known by refutation (a line begins
  where no predecessor is alike), widening by exhibition (something is held that was not), and the
  premises are that gap. Locating the step at which a point arrives within a stretch is weak
  excluded middle: keeping widening gives 全生成 for every chain exactly where it holds
  (`Steps.forward_iff_wem`), since a possible each of whose points arrives at one of two moments, as
  a proposition decides, keeps widening, and the step its generation names tells the proposition
  refuted or unrefuted (`Steps.arriving`). Exhibiting the point a step adds, from the step's not
  being alike, is excluded middle: 全生成 gives keeping widening for every chain exactly where it
  holds (`Steps.back_iff_em`), since a possible each of whose points is held from the next moment
  where a proposition holds is 全生成 wherever the proposition is unrefuted, and keeps widening only
  where it holds (`Steps.dawning`). Even where every holding is decided, exhibiting the point is an
  unbounded search, Markov's principle (`Steps.markov_of_keepsWidening_of_generation`).
* **On the World, by name.** Along each formation continuing itself, the World's keeping widening
  is this chain's, read on what levels admit (`Web.keepsWidening_itself_iff`, from the landed
  `Web.keepsWidening_iff_chain` and the shift). So, under the same premises on admission, keeping
  widening by name is 全生成 of the course's moments at (nothing lost, the same possible)
  (`Web.generation_of_keepsWidening_byName`, `Web.keepsWidening_byName_iff_generation`). On the
  occurrences, by name, each formation admitted from the moment on is 全守, from nothing lost alone
  (`Web.kept_of_includes_by_name`), and the course's moments are 全生成
  (`Web.kept_by_name_and_generation_on_moments`, the two together). The two halves sit on two
  carriers, the occurrences and the moments, so they are not the map's two grains of one carrier.

**Standing.** Near-definitional: the laws unfold both definitions on the line of moments. The iff
at (nothing lost, the same possible) is a representation of keeping widening on the map's grammar,
not a join of two notions fixed apart, since nothing lost is widening's own inclusion half. The
join with both classes fixed apart (the one and the same possible) is the split: under the two
premises keeping widening is that generation with nothing lost, generation does not give it
(`Steps.Moving`), and what separates them is exactly loss. At (the one, the same possible) the join
holds without the converse, because the one does not count loss; the held class of
`Run.generation_of_heldKeepsWidening` is a further fine class, whose converse fails on
`Oscillating`. The calibrations of the premises are of the logic, each stated with what it says
about the course.

**What is not derived.** The World's keeping widening along a continuation other than by name; the
comparison of two courses; an order ranking by widening rather than by generation. With every claim
counted, C is the requirement that an order rank each course above every course it widens (07 §4.4).

Every declaration has an empty axiom report.
-/

namespace Becoming

namespace Steps

variable {X : Type}

/-- Nothing lost (不失): everything held at `n` is held at `m`, inclusion along the moments. -/
def includes (Q : Nat → X → Prop) : «际» Nat := fun n m => ∀ x, Q n x → Q m x

/-- The same possible (同): what is held at `n` is what is held at `m`. -/
def same (Q : Nat → X → Prop) : «际» Nat := fun n m => ∀ x, Q n x ↔ Q m x

/-- **Keeping widening from `N`**, 07's form for a chain of predicates: from `N` on nothing held is
lost across any stretch, and after every step something not held there is held later. -/
def KeepsWideningFrom (Q : Nat → X → Prop) (N : Nat) : Prop :=
  (∀ S U, N ≤ S → S ≤ U → includes Q S U) ∧ ∀ S, N ≤ S → ∃ U, S ≤ U ∧ ∃ x, Q U x ∧ ¬ Q S x

variable {Q : Nat → X → Prop}

/-- The same possible is a class. -/
theorem same_class : «类» (same Q) :=
  ⟨fun _ _ => Iff.rfl, fun s x => (s x).symm, fun s s' x => (s x).trans (s' x)⟩

/-- The same possible is finer than nothing lost. -/
theorem same_includes : «则» (same Q) (includes Q) :=
  fun _ _ s x => (s x).mp

theorem includes_refl (n : Nat) : includes Q n n := fun _ h => h

theorem includes_trans {n m k : Nat} (h : includes Q n m) (h' : includes Q m k) : includes Q n k :=
  fun x q => h' x (h x q)

/-- On the line of moments, a line under a class begins at a step exactly where the step is not
alike under it. -/
theorem begins_iff {E : «际» Nat} {t : Nat} : «生» next E (t + 1) ↔ ¬ E t (t + 1) :=
  ⟨fun begins alike => begins (hasPred_iff.mpr alike), fun apart h => apart (hasPred_iff.mp h)⟩

/-- What a line along the moments reaches is later: GrammarMap's law of the successor
(`Map.step_reached_le`), read at `next`, which is the same relation. -/
theorem reached_le {L : «际» Nat} {x y : Nat} (reached : «所及» next L x y) : x ≤ y :=
  Map.step_reached_le reached

/-- Where the line from `N` never ends, it reaches every later moment. -/
theorem reaches_of_buqiong {L : «际» Nat} {N y : Nat} (endless : «不穷» next L N) (le : N ≤ y) :
    «所及» next L N y :=
  match le_dest le with
  | ⟨0, at_⟩ => .inl at_.symm
  | ⟨k + 1, at_⟩ => .inr (Eq.subst (motive := fun z => «相续» next L N z) at_.symm
      (reached_of_buqiong endless k))

/-- **The line of nothing lost goes on from `N` exactly while nothing is lost at each step.** -/
theorem buqiong_includes_iff {N : Nat} : «不穷» next (includes Q) N ↔ ∀ n, N ≤ n → includes Q n (n + 1) :=
  ⟨fun endless _ le => match le_dest le with
     | ⟨k, at_⟩ => Eq.subst (motive := fun m => includes Q m (m + 1)) at_.symm
         (buqiong_iff.mp endless k),
   fun each => buqiong_iff.mpr fun k => each (N + k) (Nat.le_add_right N k)⟩

/-- Nothing is lost across any stretch from `N` exactly where nothing is lost across each step. -/
theorem includesFrom_iff {N : Nat} :
    (∀ S U, N ≤ S → S ≤ U → includes Q S U) ↔ ∀ n, N ≤ n → includes Q n (n + 1) :=
  have across : ∀ (each : ∀ n, N ≤ n → includes Q n (n + 1)) (S : Nat), N ≤ S →
      ∀ d, includes Q S (S + d) := fun each S le d => by
    induction d with
    | zero => exact includes_refl S
    | succ d ih => exact includes_trans ih (each (S + d) (Nat.le_trans le (Nat.le_add_right S d)))
  ⟨fun nothing_lost n le => nothing_lost n (n + 1) le (Nat.le_succ n),
   fun each S U le later => match le_dest later with
     | ⟨d, at_⟩ => Eq.subst (motive := fun m => includes Q S m) at_.symm (across each S le d)⟩

/-- **全生成 at (nothing lost, the same possible) is 全生成 at (the one, the same possible) with
nothing lost**: what parts the two is loss. -/
theorem generation_includes_iff {N : Nat} :
    «全生成» next (includes Q) (same Q) N ↔
      «不穷» next (includes Q) N ∧ «全生成» next «一» (same Q) N :=
  ⟨fun ⟨endless, ahead⟩ => ⟨endless, generation_iff_begins.mpr fun y le =>
     match ahead y (reaches_of_buqiong endless le) with
     | ⟨z, _, toZ, ⟨⟨step, _⟩, begins⟩⟩ =>
       ⟨z, reached_le toZ, Eq.subst (motive := fun w => «生» next (same Q) w) step begins⟩⟩,
   fun ⟨endless, generation⟩ => ⟨endless, fun y reached =>
     have from_y : «不穷» next (includes Q) y := fun z hz => endless z («所及之传递» reached hz)
     match generation_iff_begins.mp generation y (reached_le reached) with
     | ⟨n, le, begun⟩ => ⟨n, n + 1, reaches_of_buqiong from_y le,
         ⟨⟨rfl, buqiong_includes_iff.mp endless n (Nat.le_trans (reached_le reached) le)⟩, begun⟩⟩⟩⟩

/-- **The step at which a point arrives is located, with the point**, where each point is, at each
moment, refuted or unrefuted: a point not held at `S` and not refuted at `S + d` is not held at some
moment of the stretch and not refuted at the next. -/
theorem change_located (wdec : ∀ n x, ¬ Q n x ∨ ¬¬ Q n x) {S : Nat} {x : X} (before : ¬ Q S x) :
    ∀ d, ¬¬ Q (S + d) x → ∃ n, S ≤ n ∧ n < S + d ∧ ¬ Q n x ∧ ¬¬ Q (n + 1) x
  | 0, held => (held before).elim
  | d + 1, held => match wdec (S + d) x with
    | .inl not_yet => ⟨S + d, Nat.le_add_right S d, Nat.lt_succ_self _, not_yet, held⟩
    | .inr earlier => match change_located wdec before d earlier with
      | ⟨n, from_, lt, not_yet, arrives⟩ => ⟨n, from_, Nat.lt_succ_of_lt lt, not_yet, arrives⟩

/-- **Where each point is, at each moment, refuted or unrefuted, keeping widening from `N` is 全生成
at (nothing lost, the same possible) there**: the step at which something new arrives is
located. -/
theorem generation_of_keepsWidening (wdec : ∀ n x, ¬ Q n x ∨ ¬¬ Q n x) {N : Nat}
    (keeps : KeepsWideningFrom Q N) : «全生成» next (includes Q) (same Q) N :=
  generation_includes_iff.mpr ⟨buqiong_includes_iff.mpr (includesFrom_iff.mp keeps.1),
    generation_iff_begins.mpr fun y le => match keeps.2 y le with
      | ⟨_, later, x, held, before⟩ => match le_dest later with
        | ⟨d, at_⟩ =>
          match change_located wdec before d
              (fun refuted => refuted (Eq.subst (motive := fun m => Q m x) at_ held)) with
          | ⟨n, from_, _, not_yet, arrives⟩ =>
            ⟨n, from_, begins_iff.mpr fun s => arrives fun h => not_yet ((s x).mpr h)⟩⟩

/-- **全生成 at (nothing lost, the same possible) gives nothing lost and, after every step, a step
after which not everything held was held before**, with no premise. -/
theorem includes_not_back_of_generation {N : Nat} (generation : «全生成» next (includes Q) (same Q) N) :
    (∀ S U, N ≤ S → S ≤ U → includes Q S U) ∧ ∀ S, N ≤ S → ∃ n, S ≤ n ∧ ¬ includes Q (n + 1) n :=
  match generation_includes_iff.mp generation with
  | ⟨endless, under_one⟩ =>
    ⟨includesFrom_iff.mpr (buqiong_includes_iff.mp endless), fun S le =>
      match generation_iff_begins.mp under_one S le with
      | ⟨n, from_, begun⟩ => ⟨n, from_, fun back => begins_iff.mp begun fun x =>
          ⟨buqiong_includes_iff.mp endless n (Nat.le_trans le from_) x, back x⟩⟩⟩

/-- **Where, wherever not everything held after a step was held before, something new there is
found, 全生成 at (nothing lost, the same possible) from `N` is keeping widening there.** -/
theorem keepsWidening_of_generation
    (found : ∀ n, ¬ includes Q (n + 1) n → ∃ x, Q (n + 1) x ∧ ¬ Q n x) {N : Nat}
    (generation : «全生成» next (includes Q) (same Q) N) : KeepsWideningFrom Q N :=
  match includes_not_back_of_generation generation with
  | ⟨nothing_lost, opens⟩ => ⟨nothing_lost, fun S le => match opens S le with
    | ⟨n, from_, apart⟩ => match found n apart with
      | ⟨x, held, before⟩ => ⟨n + 1, Nat.le_succ_of_le from_, x, held,
          fun earlier => before (nothing_lost S n le from_ x earlier)⟩⟩

/-- **Keeping widening is 全生成 at (nothing lost, the same possible), both ways**, where each point
is, at each moment, refuted or unrefuted, and something new is found after each step after which not
everything held was held before. -/
theorem generation_iff_keepsWidening (wdec : ∀ n x, ¬ Q n x ∨ ¬¬ Q n x)
    (found : ∀ n, ¬ includes Q (n + 1) n → ∃ x, Q (n + 1) x ∧ ¬ Q n x) {N : Nat} :
    «全生成» next (includes Q) (same Q) N ↔ KeepsWideningFrom Q N :=
  ⟨keepsWidening_of_generation found, generation_of_keepsWidening wdec⟩

/-- **Keeping widening is generation under (the one, the same possible) that loses nothing**, under
the same premises: the join with both classes fixed apart from widening. Nothing lost is what
widening adds to the map's generation. -/
theorem keepsWidening_iff_generation_losing_nothing (wdec : ∀ n x, ¬ Q n x ∨ ¬¬ Q n x)
    (found : ∀ n, ¬ includes Q (n + 1) n → ∃ x, Q (n + 1) x ∧ ¬ Q n x) {N : Nat} :
    KeepsWideningFrom Q N ↔
      (∀ n, N ≤ n → includes Q n (n + 1)) ∧ «全生成» next «一» (same Q) N :=
  (generation_iff_keepsWidening wdec found).symm.trans (generation_includes_iff.trans
    ⟨fun h => ⟨buqiong_includes_iff.mp h.1, h.2⟩, fun h => ⟨buqiong_includes_iff.mpr h.1, h.2⟩⟩)

/-- Where what is held is decided, a list holding what a moment holds has a point the previous
moment does not hold, or none. -/
theorem new_in_list_or_none (dec : ∀ n x, Q n x ∨ ¬ Q n x) (n : Nat) :
    ∀ l : List X, (∃ x, x ∈ l ∧ Q (n + 1) x ∧ ¬ Q n x) ∨ ∀ x, x ∈ l → Q (n + 1) x → Q n x
  | [] => .inr fun _ m => nomatch m
  | a :: l => match dec (n + 1) a, dec n a with
    | .inl held, .inr before => .inl ⟨a, List.Mem.head l, held, before⟩
    | .inl _, .inl earlier => match new_in_list_or_none dec n l with
      | .inl ⟨x, m, held', before'⟩ => .inl ⟨x, List.Mem.tail a m, held', before'⟩
      | .inr rest => .inr fun x m => match m with
        | List.Mem.head _ => fun _ => earlier
        | List.Mem.tail _ m' => rest x m'
    | .inr absent, _ => match new_in_list_or_none dec n l with
      | .inl ⟨x, m, held', before'⟩ => .inl ⟨x, List.Mem.tail a m, held', before'⟩
      | .inr rest => .inr fun x m => match m with
        | List.Mem.head _ => fun held' => absurd held' absent
        | List.Mem.tail _ m' => rest x m'

/-- **Where what is held is decided and each moment's holding is listed, something new is found
after each step after which not everything held was held before.** -/
theorem found_of_listed (dec : ∀ n x, Q n x ∨ ¬ Q n x) (list : Nat → List X)
    (listed : ∀ n x, Q n x → x ∈ list n) (n : Nat) (apart : ¬ includes Q (n + 1) n) :
    ∃ x, Q (n + 1) x ∧ ¬ Q n x :=
  match new_in_list_or_none dec n (list (n + 1)) with
  | .inl ⟨x, _, held, before⟩ => ⟨x, held, before⟩
  | .inr none_new => (apart fun x held => none_new x (listed (n + 1) x held) held).elim

/-- 07's chain form is keeping widening from the first moment. -/
theorem keepsWidening_iff_from_zero : Reaching.KeepsWidening Q ↔ KeepsWideningFrom Q 0 :=
  ⟨fun ⟨kept_on, opens⟩ =>
    ⟨fun S _ _ later x held => match le_dest later with
       | ⟨d, at_⟩ => Eq.subst (motive := fun m => Q m x) at_.symm (kept_on S d x held),
     fun S _ => match opens S with
       | ⟨d, x, held, before⟩ => ⟨S + d, Nat.le_add_right S d, x, held, before⟩⟩,
   fun ⟨nothing_lost, opens⟩ =>
    ⟨fun n d x held => nothing_lost n (n + d) (Nat.zero_le n) (Nat.le_add_right n d) x held,
     fun n => match opens n (Nat.zero_le n) with
       | ⟨_, later, x, held, before⟩ => match le_dest later with
         | ⟨d, at_⟩ => ⟨d, x, Eq.subst (motive := fun m => Q m x) at_ held, before⟩⟩⟩

/-- **Keeping widening from `T` is 07's chain form of the chain shifted by `T`.** -/
theorem keepsWideningFrom_iff_shift {T : Nat} :
    KeepsWideningFrom Q T ↔ Reaching.KeepsWidening (fun n => Q (T + n)) :=
  ⟨fun ⟨nothing_lost, opens⟩ =>
    ⟨fun n d x held => Eq.subst (motive := fun m => Q m x) (Nat.add_assoc T n d)
       (nothing_lost (T + n) (T + n + d) (Nat.le_add_right T n) (Nat.le_add_right _ d) x held),
     fun n => match opens (T + n) (Nat.le_add_right T n) with
       | ⟨_, later, x, held, before⟩ => match le_dest later with
         | ⟨d, at_⟩ => ⟨d, x, Eq.subst (motive := fun m => Q m x)
             (at_.trans (Nat.add_assoc T n d)) held, before⟩⟩,
   fun ⟨kept_on, opens⟩ =>
    ⟨fun _ _ from_ later x held => match le_dest from_, le_dest later with
       | ⟨n, atS⟩, ⟨d, atU⟩ =>
         have here : Q (T + n) x := Eq.subst (motive := fun m => Q m x) atS held
         Eq.subst (motive := fun m => Q m x)
           ((Nat.add_assoc T n d).symm.trans ((congrArg (· + d) atS).symm.trans atU.symm))
           (kept_on n d x here),
     fun S from_ => match le_dest from_ with
       | ⟨n, atS⟩ => match opens n with
         | ⟨d, x, now, before⟩ => ⟨S + d, Nat.le_add_right S d, x,
             Eq.subst (motive := fun m => Q m x)
               ((Nat.add_assoc T n d).symm.trans (congrArg (· + d) atS).symm) now,
             fun earlier => before (Eq.subst (motive := fun m => Q m x) atS earlier)⟩⟩⟩

/-- **Where each point is, at each moment, refuted or unrefuted, 07's chain form of keeping widening
is 全生成 at (nothing lost, the same possible) at the first moment.** -/
theorem generation_of_reachingKeepsWidening (wdec : ∀ n x, ¬ Q n x ∨ ¬¬ Q n x)
    (keeps : Reaching.KeepsWidening Q) : «全生成» next (includes Q) (same Q) 0 :=
  generation_of_keepsWidening wdec (keepsWidening_iff_from_zero.mp keeps)

/-! ## Witnesses: loss parts them, and both together -/

/-- A possible that moves: at each moment it holds that moment alone. -/
def moving : Nat → Nat → Prop := fun n x => x = n

/-- What moves changes at every step: every moment is 全生成 under the one. -/
theorem Moving.generation (N : Nat) : «全生成» next «一» (same moving) N :=
  generation_iff_begins.mpr fun y _ => ⟨y, Nat.le_refl y, begins_iff.mpr fun s =>
    Nat.succ_ne_self y ((s y).mp rfl).symm⟩

/-- What moves loses what it held: no moment is 全生成 at (nothing lost, the same possible). -/
theorem Moving.not_generation_includes (N : Nat) : ¬ «全生成» next (includes moving) (same moving) N :=
  fun generation => Nat.succ_ne_self N
    ((buqiong_includes_iff.mp (generation_includes_iff.mp generation).1 N (Nat.le_refl N) N rfl).symm)

/-- What moves keeps widening from no moment. -/
theorem Moving.not_keepsWidening (N : Nat) : ¬ KeepsWideningFrom moving N :=
  fun keeps => Nat.succ_ne_self N (keeps.1 N (N + 1) (Nat.le_refl N) (Nat.le_succ N) N rfl).symm

/-- A possible that grows: at each moment it holds every earlier moment. -/
def growing : Nat → Nat → Prop := fun n x => x < n

/-- What grows keeps widening from every moment. -/
theorem Growing.keepsWidening (N : Nat) : KeepsWideningFrom growing N :=
  ⟨fun _ _ _ later _ held => Nat.lt_of_lt_of_le held later,
   fun S _ => ⟨S + 1, Nat.le_succ S, S, Nat.lt_succ_self S, Nat.lt_irrefl S⟩⟩

/-- What grows is 全生成 at (nothing lost, the same possible) at every moment. -/
theorem Growing.generation (N : Nat) : «全生成» next (includes growing) (same growing) N :=
  generation_of_keepsWidening (fun n x => match Nat.decLt x n with
    | isTrue lt => .inr fun refuted => refuted lt
    | isFalse ge => .inl ge) (Growing.keepsWidening N)

/-! ## What each premise of deciding says about the course

Generation is known by refutation, widening by exhibition. Locating the step at which a point
arrives is weak excluded middle; exhibiting the point a step adds is excluded middle. -/

/-- Where excluded middle holds, what is new at a step is found wherever it is not refuted. -/
theorem found_of_em (em : ∀ P : Prop, P ∨ ¬ P) :
    ∀ n, ¬ includes Q (n + 1) n → ∃ x, Q (n + 1) x ∧ ¬ Q n x :=
  fun n apart => match em (∃ x, Q (n + 1) x ∧ ¬ Q n x) with
  | .inl found => found
  | .inr none_new => (apart fun x held => match em (Q n x) with
      | .inl earlier => earlier
      | .inr before => (none_new ⟨x, held, before⟩).elim).elim

/-- Twice a number. -/
def twice : Nat → Nat
  | 0 => 0
  | k + 1 => twice k + 2

theorem le_twice : ∀ k, k ≤ twice k + 2
  | 0 => Nat.zero_le _
  | k + 1 => Nat.le_succ_of_le (Nat.succ_le_succ (le_twice k))

/-- A possible each of whose points arrives at one of two moments, as `P` decides: point `k` is
held from moment `2k + 2`, and already at `2k + 1` where `P` holds. -/
def arriving (P : Prop) : Nat → Nat → Prop
  | 0, _ => False
  | 1, 0 => P
  | 1, _ + 1 => False
  | _ + 2, 0 => True
  | n + 2, k + 1 => arriving P n k

theorem Arriving.includes {P : Prop} : ∀ n k, arriving P n k → arriving P (n + 1) k
  | 0, _, held => held.elim
  | 1, 0, _ => trivial
  | 1, _ + 1, held => held.elim
  | _ + 2, 0, _ => trivial
  | n + 2, k + 1, held => Arriving.includes n k held

theorem Arriving.early {P : Prop} : ∀ n k, n ≤ k → ¬ arriving P n k
  | 0, _, _ => fun held => held
  | 1, 0, le => absurd le (Nat.not_succ_le_zero 0)
  | 1, _ + 1, _ => fun held => held
  | _ + 2, 0, le => absurd le (Nat.not_succ_le_zero _)
  | n + 2, k + 1, le => Arriving.early n k (Nat.le_of_succ_le (Nat.le_of_succ_le_succ le))

theorem Arriving.late {P : Prop} : ∀ k, arriving P (twice k + 2) k
  | 0 => trivial
  | k + 1 => Arriving.late (P := P) k

/-- What arrives keeps widening from the first moment, whatever `P` is. -/
theorem Arriving.keepsWidening {P : Prop} : KeepsWideningFrom (arriving P) 0 :=
  ⟨includesFrom_iff.mpr fun n _ k held => Arriving.includes n k held,
   fun S _ => ⟨twice S + 2, le_twice S, S, Arriving.late S, Arriving.early S S (Nat.le_refl S)⟩⟩

/-- A step of what arrives that changes what is held tells `P` refuted or unrefuted. -/
theorem Arriving.tells {P : Prop} : ∀ n, ¬ same (arriving P) n (n + 1) → ¬ P ∨ ¬¬ P
  | 0, apart => .inr fun refuted => apart fun k => match k with
    | 0 => ⟨fun held => held.elim, fun held => (refuted held).elim⟩
    | _ + 1 => Iff.rfl
  | 1, apart => .inl fun held => apart fun k => match k with
    | 0 => ⟨fun _ => trivial, fun _ => held⟩
    | _ + 1 => Iff.rfl
  | n + 2, apart => Arriving.tells n fun s => apart fun k => match k with
    | 0 => Iff.rfl
    | k + 1 => s k

/-- **Locating the step needs weak excluded middle**: if keeping widening gives 全生成 at (nothing
lost, the same possible) for every chain, every proposition is refuted or unrefuted. -/
theorem wem_of_generation_of_keepsWidening
    (forward : ∀ Q : Nat → Nat → Prop, KeepsWideningFrom Q 0 → «全生成» next (includes Q) (same Q) 0)
    (P : Prop) : ¬ P ∨ ¬¬ P :=
  match generation_iff_begins.mp (generation_includes_iff.mp (forward (arriving P)
      Arriving.keepsWidening)).2 0 (Nat.le_refl 0) with
  | ⟨n, _, begun⟩ => Arriving.tells n (begins_iff.mp begun)

/-- **Keeping widening gives 全生成 at (nothing lost, the same possible) for every chain exactly
where weak excluded middle holds.** -/
theorem forward_iff_wem :
    (∀ Q : Nat → Nat → Prop, ∀ N, KeepsWideningFrom Q N → «全生成» next (includes Q) (same Q) N) ↔
      ∀ P : Prop, ¬ P ∨ ¬¬ P :=
  ⟨fun forward => wem_of_generation_of_keepsWidening fun Q => forward Q 0,
   fun wem _ _ => generation_of_keepsWidening fun _ _ => wem _⟩

/-- A possible each of whose points is held from the next moment, where `P` holds. -/
def dawning (P : Prop) : Nat → Nat → Prop := fun n k => k < n ∧ P

/-- Where `P` is not refuted, what dawns is 全生成 at (nothing lost, the same possible) at the first
moment. -/
theorem Dawning.generation {P : Prop} (unrefuted : ¬¬ P) :
    «全生成» next (includes (dawning P)) (same (dawning P)) 0 :=
  generation_includes_iff.mpr ⟨buqiong_includes_iff.mpr fun _ _ _ held => ⟨Nat.lt_succ_of_lt held.1, held.2⟩,
    generation_iff_begins.mpr fun y _ => ⟨y, Nat.le_refl y, begins_iff.mpr fun s =>
      unrefuted fun held => Nat.lt_irrefl y ((s y).mpr ⟨Nat.lt_succ_self y, held⟩).1⟩⟩

/-- **Exhibiting the point needs excluded middle**: if 全生成 at (nothing lost, the same possible)
gives keeping widening for every chain, every proposition not refuted holds. -/
theorem dne_of_keepsWidening_of_generation
    (back : ∀ Q : Nat → Nat → Prop, «全生成» next (includes Q) (same Q) 0 → KeepsWideningFrom Q 0)
    (P : Prop) (unrefuted : ¬¬ P) : P :=
  match (back (dawning P) (Dawning.generation unrefuted)).2 0 (Nat.le_refl 0) with
  | ⟨_, _, _, held, _⟩ => held.2

/-- **全生成 at (nothing lost, the same possible) gives keeping widening for every chain exactly where
excluded middle holds.** -/
theorem back_iff_em :
    (∀ Q : Nat → Nat → Prop, ∀ N, «全生成» next (includes Q) (same Q) N → KeepsWideningFrom Q N) ↔
      ∀ P : Prop, P ∨ ¬ P :=
  ⟨fun back P => dne_of_keepsWidening_of_generation (fun Q => back Q 0) (P ∨ ¬ P)
     fun neither => neither (.inr fun held => neither (.inl held)),
   fun em _ _ => keepsWidening_of_generation (found_of_em em)⟩

/-- A decided possible: at each moment, the points `(m, k)` with `m` earlier and `p k`. -/
def marked (p : Nat → Bool) : Nat → Nat × Nat → Prop := fun n x => x.1 < n ∧ p x.2 = true

/-- **Even where what is held is decided, exhibiting the point is Markov's principle**: if 全生成 at
(nothing lost, the same possible) gives keeping widening for every decided chain, a sequence not
refuted to hold somewhere holds somewhere. -/
theorem markov_of_keepsWidening_of_generation
    (back : ∀ Q : Nat → Nat × Nat → Prop, (∀ n x, Q n x ∨ ¬ Q n x) →
      «全生成» next (includes Q) (same Q) 0 → KeepsWideningFrom Q 0)
    (p : Nat → Bool) (unrefuted : ¬ ∀ k, p k = false) : ∃ k, p k = true :=
  have dec : ∀ n x, marked p n x ∨ ¬ marked p n x := fun n x =>
    match Nat.decLt x.1 n, hp : p x.2 with
    | isTrue lt, true => .inl ⟨lt, hp⟩
    | isTrue _, false => .inr fun ⟨_, e⟩ => Bool.noConfusion (hp.symm.trans e)
    | isFalse ge, _ => .inr fun ⟨lt, _⟩ => ge lt
  have generation : «全生成» next (includes (marked p)) (same (marked p)) 0 :=
    generation_includes_iff.mpr ⟨buqiong_includes_iff.mpr fun _ _ _ ⟨lt, e⟩ => ⟨Nat.lt_succ_of_lt lt, e⟩,
      generation_iff_begins.mpr fun y _ => ⟨y, Nat.le_refl y, begins_iff.mpr fun s =>
        unrefuted fun k => match hk : p k with
          | false => rfl
          | true => absurd ((s (y, k)).mpr ⟨Nat.lt_succ_self y, hk⟩).1 (Nat.lt_irrefl y)⟩⟩
  match (back (marked p) dec generation).2 0 (Nat.le_refl 0) with
  | ⟨_, _, x, ⟨_, e⟩, _⟩ => ⟨x.2, e⟩

end Steps

namespace Web

variable {F C : Type} {W : Web F C} {l : Nat → C → Nat} {T : Nat}

/-- **Along each formation continuing itself, the World's keeping widening is the chain's**, read
on what the levels admit: the landed `Web.keepsWidening_iff_chain` with the shift. -/
theorem keepsWidening_itself_iff :
    W.KeepsWidening itself l T ↔ Steps.KeepsWideningFrom (fun t f => W.Admits (l t) t f) T :=
  keepsWidening_iff_chain.trans
    (Steps.keepsWideningFrom_iff_shift (Q := fun t f => W.Admits (l t) t f)).symm

/-- **Where admission is, at each moment, refuted or unrefuted, keeping widening by name is 全生成
of the course's moments at (nothing lost, the same possible).** -/
theorem generation_of_keepsWidening_byName
    (wdec : ∀ t f, ¬ W.Admits (l t) t f ∨ ¬¬ W.Admits (l t) t f)
    (keeps : W.KeepsWidening itself l T) :
    «全生成» Steps.next (Steps.includes fun t f => W.Admits (l t) t f)
      (Steps.same fun t f => W.Admits (l t) t f) T :=
  Steps.generation_of_keepsWidening wdec (keepsWidening_itself_iff.mp keeps)

/-- **Keeping widening by name is 全生成 of the course's moments at (nothing lost, the same
possible), both ways**, where admission is, at each moment, refuted or unrefuted and what is newly
admitted at a step is found wherever it is not refuted. -/
theorem keepsWidening_byName_iff_generation
    (wdec : ∀ t f, ¬ W.Admits (l t) t f ∨ ¬¬ W.Admits (l t) t f)
    (found : ∀ n, ¬ Steps.includes (fun t f => W.Admits (l t) t f) (n + 1) n →
      ∃ f, W.Admits (l (n + 1)) (n + 1) f ∧ ¬ W.Admits (l n) n f) :
    W.KeepsWidening itself l T ↔
      «全生成» Steps.next (Steps.includes fun t f => W.Admits (l t) t f)
        (Steps.same fun t f => W.Admits (l t) t f) T :=
  keepsWidening_itself_iff.trans (Steps.generation_iff_keepsWidening wdec found).symm

/-- **On the occurrences, by name, each formation is kept; on the course's moments, the admitted
range is generated.** Each formation admitted from `T` on is 全守, from nothing lost alone, and no
occurrence is 全生成; where admission is, at each moment, refuted or unrefuted, the admitted range
is 全生成 at (nothing lost, the same possible) on the course's moments. The two halves sit on two
carriers, so they are not the map's two grains of one carrier; a corollary of the two theorems. -/
theorem kept_by_name_and_generation_on_moments (wdec : ∀ t f, ¬ W.Admits (l t) t f ∨ ¬¬ W.Admits (l t) t f)
    (keeps : W.KeepsWidening itself l T) :
    (∀ S f, T ≤ S → W.Admits (l S) S f →
      «全守» (continuationStep itself) (W.admitting l).activityClass (W.admitting l).carrierClass
          (S, f) ∧
        ¬ «全生成» (continuationStep itself) (W.admitting l).activityClass
          (W.admitting l).carrierClass (S, f)) ∧
      «全生成» Steps.next (Steps.includes fun t f => W.Admits (l t) t f)
        (Steps.same fun t f => W.Admits (l t) t f) T :=
  ⟨fun _ _ from_ admitted => kept_of_includes_by_name keeps.1 from_ admitted,
   generation_of_keepsWidening_byName wdec keeps⟩

end Web

end Becoming
