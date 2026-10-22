import Becoming.SelectionGap
import Becoming.Exclusion

/-!
# Training: what a selection over act laws installs

`Becoming.Learning` stated training as a selection through the data: a fit is right beyond the
data exactly where the class it can reach determines it (`Training.fit_right_iff`). A learner
acting in a world does not receive its data: its data are the courses its own act law generates
with everything else. This module reads training as a selection over a learner's candidate act
laws through those courses, the rest acting by one law of exchange (`Becoming.Counterfactual`),
and states what such a selection can install. No premise enters beyond what each theorem names.

* **A law is installed only along its own courses.** A situation fixes what the learner's law
  does not: the others' law (one realization of their noise), the start, and how the learner's law
  is executed there. Two laws of what has stood that exchange alike along the levels the first
  generates generate the same levels (`ExchangeLaw.levels_agree_of_along`). So two candidates
  giving alike, for the part, along the course the first generates in each situation have the same
  courses, levels and exchanges (`Training.same_courses_of_along`), and every training reading
  candidates through their courses trains them alike (`Training.trained_alike_of_along`). With
  noise, what is fixed is fixed by the realizations, whatever weight a training gives them.
* **Exploration installs only where the law itself acts.** A law explored on a schedule acts by an
  exploring law at the steps the schedule marks (`Training.explore`); two laws giving alike at the
  steps left to them along the explored courses have the same explored courses
  (`Training.explored_same_courses`), so what the law does at an exploring step, or under a history
  no explored course passes, is fixed by no training reading those courses.
* **Off its courses, what is installed is what its representation cannot tell from them.** A
  lumping of histories (`Training.Lumping`) is an equivalence at each step that never separates
  histories agreeing up to it; the part's coupling and agreement itself are lumpings
  (`Training.Lumping.coupling`, `Training.Lumping.agreement`). Two laws reading through a lumping
  (`Training.ReadsThrough`) with the same courses exchange alike at every history it lumps with a
  course (`Training.installed_where_lumped`; the coupling case `Training.installed_where_alike`).
  At a history it lumps with no course, a law of the class with the same courses takes any amount
  there and responds or not to a difference it separates (`Training.free_where_unlumped`,
  `Training.response_free_where_unlumped`, by one construction, a take set on a predicate the
  reading respects, `Training.setOn`, `Training.setOn_lumped`); the coupling and the finest lumping
  are its cases (`Training.response_free_where_apart`, `Training.response_free_off_courses`):
  nothing is installed off the courses beyond what the representation lumps with them. This is
  `Training.fit_right_iff` with the courses as the data and the representation's lumping as the
  class.
* **Training through a reward's couplings.** A training is through a selector `r`'s couplings up
  to `T` where candidates whose levels are alike through `r`'s couplings up to `T` in every
  situation are selected alike (`Training.TrainsThrough`). Every such training reads the courses
  (`Training.TrainsThrough.reads`), and two candidates are trained alike by every one exactly when
  their levels are alike through `r`'s couplings in every situation (`Training.trained_alike_iff`,
  `Web.selects_alike_iff` on the learner's own courses; by construction). What a reward reading
  levels through `r`'s couplings settles on, its optimum among the candidates, is such a training
  (`Training.settles_through`, `Training.Settles`), and with the classes decided some such reward
  settles on one of two candidates and not the other wherever their levels are apart through
  `r`'s couplings in one situation (`Training.settles_apart`). With both act laws reading what has
  stood, the rest's law reading through coupling and both courses feasible, two candidates
  agreeing on every condition coupled into the coupling closure of `r`, drawn through their two
  courses, are trained alike by every training through `r`'s couplings
  (`Training.trained_alike_beyond_closure`, from `act_courses_unselected`): a difference in what
  the learner's act does is installed only where it reaches what couples into the reward's
  closure.
* **Which settled law is reached is the search's.** A search step improving for a reward stays or
  moves to a candidate rewarded more (`Training.Improving`); every candidate the reward settles on
  is a rest of every improving search (`Training.settled_rests`), and a search started there stays
  (`Training.settled_stays`). Under a bounded reward an improving search rests within the bound
  from every start, so the basin of a start is where its orbit stands then
  (`Training.rested_or_risen`, `Training.comes_to_rest`). A local search over a neighbourhood
  relation, the search's parameterization (`Training.LocalSearch`), rests exactly where no
  neighbour is rewarded more (`Training.LocalSearch.rests_iff`), and with every candidate a
  neighbour exactly where the reward settles (`Training.LocalSearch.rests_iff_settles`): the rests
  a narrower neighbourhood adds are its implicit bias, not the reward's.
* **Coupling into a condition installs nothing where the rest outruns it.** A reading that is the
  same for every candidate leaves the optimum of a reward with it at any weight the optimum
  without it (`Training.settles_weighted_iff`). Where, in each candidate's course, renewal depends
  on what it renews at need one and the rest takes from the condition jointly more than is given
  at each of `n` steps from `T`, from a level at most `n`, every score reading the condition only
  from `T + n` on is the same for every candidate (`Training.outrun_reading_same`, from
  `Flow.outrun_reading_alike`), so a reward adding such a reading at any weight settles exactly
  where the reward without it settles (`Training.outrun_settles_iff`). In a commons computed here
  (`Training.Commons`), the learner's reward reading its store and the stock at step four through
  its coupling, by level, into both: where the rest takes no more than the renewal, restraint is
  settled exactly at weights of at least one (`Commons.renewed_restraint_settles_iff`); where it
  takes more, restraint is settled at no weight and the drawing law at every weight
  (`Commons.outrun_restraint_unsettled`, `Commons.outrun_drawing_settles`). What decides is where
  the reading falls against what the rest does, not how much it weighs: CG2's X2 as a theorem. At
  weight one, with the rest within the renewal, both laws are settled, the drawing law responding to
  the stock and restraint not, and every improving search keeps the one it starts from
  (`Commons.renewed_both_settle`, `Commons.drawing_responds`, `Commons.start_decides`). Where the
  rest outruns the renewal, a local search with empty neighbourhoods rests at restraint, which no
  reward weight settles on, and one in which every candidate is a neighbour leaves it
  (`Commons.outrun_neighbourhood_decides`): the parameterization can install what the reward
  cannot.

What is not derived: which lumping an actual architecture's representation makes, or which
neighbourhoods its updates search, both properties of the system read empirically; the weights a
training gives noise realizations or explored courses, which change what is rewarded more and not
what can be installed; which basin a given start lies in for a particular system, beyond that it
is reached within the bound. The trainings here read each candidate through its own courses, as
the optimum of any reward does. The representation commits to discrete steps and natural amounts.
No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

variable {F C : Type}

/-! ## A law is fixed along its own course -/

namespace ExchangeLaw

/-- Two laws exchange alike along the history `l`: at every step every formation takes and gives
alike under it. -/
def AlongAlike (law law' : ExchangeLaw F C) (l : Nat → C → Nat) : Prop :=
  ∀ t h c, law.take t h l c = law'.take t h l c ∧ law.give t h l c = law'.give t h l c

variable {law law' : ExchangeLaw F C} {present : Nat → List F} {start : C → Nat}

/-- Under laws of what has stood exchanging alike along the levels the first generates, what each
exchanges across the step from `n` under its own history so far is alike, where the levels agree
up to `n`. -/
theorem exchange_along (na : law.Nonanticipating) (na' : law'.Nonanticipating)
    (along : law.AlongAlike law' (law.levels present start)) {n : Nat}
    (agree : AgreeUpTo (law.levels present start) (law'.levels present start) n) (f : F) (c : C) :
    law.take n f (law.history present start n) c = law'.take n f (law'.history present start n) c ∧
      law.give n f (law.history present start n) c =
        law'.give n f (law'.history present start n) c :=
  have own := na n f _ _ (history_agree n) c
  have other := na' n f _ _ agree c
  have back := na' n f _ _ (history_agree (law := law') n) c
  ⟨own.1.trans ((along n f c).1.trans (other.1.trans back.1.symm)),
   own.2.trans ((along n f c).2.trans (other.2.trans back.2.symm))⟩

/-- **A law is fixed by what it does along its own course.** Two laws of what has stood that
exchange alike along the levels the first generates generate the same levels. -/
theorem levels_agree_of_along (na : law.Nonanticipating) (na' : law'.Nonanticipating)
    (along : law.AlongAlike law' (law.levels present start)) :
    ∀ n, AgreeUpTo (law.levels present start) (law'.levels present start) n
  | 0 => fun s le _ =>
    match s, le with
    | 0, _ => rfl
  | n + 1 => fun s le c =>
    have agree := levels_agree_of_along na na' along n
    match le_succ_cases le with
    | .inl before => agree s before c
    | .inr now =>
      have given : law.givenUnder present (law.history present start n) n c =
          law'.givenUnder present (law'.history present start n) n c :=
        total_congr_on fun f _ => (exchange_along na na' along agree f c).2
      have taken : law.takenUnder present (law.history present start n) n c =
          law'.takenUnder present (law'.history present start n) n c :=
        total_congr_on fun f _ => (exchange_along na na' along agree f c).1
      now ▸ (levels_succ n c).trans
        ((congrArg (fun x => x + law.givenUnder present (law.history present start n) n c -
            law.takenUnder present (law.history present start n) n c)
            (agree n (Nat.le_refl n) c)).trans
          ((congrArg (fun g => law'.levels present start n c + g -
              law.takenUnder present (law.history present start n) n c) given).trans
            ((congrArg (fun k => law'.levels present start n c +
                law'.givenUnder present (law'.history present start n) n c - k) taken).trans
              (levels_succ n c).symm)))

end ExchangeLaw

/-! ## Training as a selection over act laws through their courses -/

namespace Training

section Laws

variable {E Θ : Type} (law : E → ExchangeLaw F C) (part : F → Bool) (present : Nat → List F)
  (start : E → C → Nat)

/-- The levels the learner generates in situation `e` acting as `a e`: the part acts by `a e`, the
rest by the situation's law `law e`, from the situation's starting levels. A situation fixes what
the learner's law does not: the others' law (one realization of their noise), the start, and how
the learner's law is executed there (exploration). -/
def levels (a : E → ExchangeLaw F C) (e : E) : Nat → C → Nat :=
  ((law e).withAct part (a e)).levels present (start e)

/-- The course the learner generates in situation `e` acting as `a e`. -/
def course (a : E → ExchangeLaw F C) (e : E) : Flow F C :=
  ((law e).withAct part (a e)).course present (start e)

/-- Two executions generate the same courses: in every situation the same levels and the same
exchanges, every formation's, at every step. -/
def SameCourses (a b : E → ExchangeLaw F C) : Prop :=
  ∀ e t, (∀ c, levels law part present start a e t c = levels law part present start b e t c) ∧
    ∀ h c, (course law part present start a e).take t h c =
        (course law part present start b e).take t h c ∧
      (course law part present start a e).give t h c = (course law part present start b e).give t h c

/-- A training over the candidates `cand`, each executed in each situation, reads each candidate
through its courses: candidates with the same courses are selected alike. -/
def Reads (cand : Θ → E → ExchangeLaw F C) (select : Θ → Prop) : Prop :=
  ∀ θ θ', SameCourses law part present start (cand θ) (cand θ') → (select θ ↔ select θ')

variable {law part present start}

/-- **Along its courses the act law fixes them.** Let the situations' laws and two executions read
what has stood, and let the two give alike, for each member of the part, along the course the
first generates in each situation. Then the two generate the same courses: the same levels, and
every formation exchanging alike, in every situation at every step. -/
theorem same_courses_of_along {a b : E → ExchangeLaw F C} (na : ∀ e, (law e).Nonanticipating)
    (naA : ∀ e, (a e).Nonanticipating) (naB : ∀ e, (b e).Nonanticipating)
    (along : ∀ e t h, part h = true → ∀ c,
      (a e).take t h (levels law part present start a e) c =
          (b e).take t h (levels law part present start a e) c ∧
        (a e).give t h (levels law part present start a e) c =
          (b e).give t h (levels law part present start a e) c) :
    SameCourses law part present start a b :=
  fun e t =>
    have alongAll : ((law e).withAct part (a e)).AlongAlike ((law e).withAct part (b e))
        (((law e).withAct part (a e)).levels present (start e)) := fun s h c => by
      show ((bif part h then (a e).take s h _ c else (law e).take s h _ c) =
          bif part h then (b e).take s h _ c else (law e).take s h _ c) ∧
        ((bif part h then (a e).give s h _ c else (law e).give s h _ c) =
          bif part h then (b e).give s h _ c else (law e).give s h _ c)
      cases member : part h
      · exact ⟨rfl, rfl⟩
      · exact along e s h member c
    have agree := ExchangeLaw.levels_agree_of_along
      (ExchangeLaw.withAct_nonanticipating (na e) (naA e))
      (ExchangeLaw.withAct_nonanticipating (na e) (naB e)) alongAll
    ⟨fun c => agree t t (Nat.le_refl t) c,
     fun h c =>
      have same := (ExchangeLaw.withAct_nonanticipating (na e) (naB e)) t h _ _ (agree t) c
      ⟨(alongAll t h c).1.trans same.1, (alongAll t h c).2.trans same.2⟩⟩

/-- **A law is installed only along its own courses.** Under the conditions of
`same_courses_of_along`, every training reading candidates through their courses trains the two
alike. -/
theorem trained_alike_of_along {cand : Θ → E → ExchangeLaw F C} {θ θ' : Θ}
    (na : ∀ e, (law e).Nonanticipating) (naA : ∀ e, (cand θ e).Nonanticipating)
    (naB : ∀ e, (cand θ' e).Nonanticipating)
    (along : ∀ e t h, part h = true → ∀ c,
      (cand θ e).take t h (levels law part present start (cand θ) e) c =
          (cand θ' e).take t h (levels law part present start (cand θ) e) c ∧
        (cand θ e).give t h (levels law part present start (cand θ) e) c =
          (cand θ' e).give t h (levels law part present start (cand θ) e) c)
    {select : Θ → Prop} (reads : Reads law part present start cand select) :
    select θ ↔ select θ' :=
  reads θ θ' (same_courses_of_along na naA naB along)

/-! ## Exploration -/

/-- The act law `a` explored on the schedule `s`: at the steps `s` marks the part acts by the
exploring law `x`, elsewhere by `a`. -/
def explore (s : Nat → Bool) (x a : ExchangeLaw F C) : ExchangeLaw F C :=
  ⟨fun t h l c => bif s t then x.take t h l c else a.take t h l c,
   fun t h l c => bif s t then x.give t h l c else a.give t h l c⟩

/-- An explored law reads what has stood where the exploring law and the law do. -/
theorem explore_nonanticipating {s : Nat → Bool} {x a : ExchangeLaw F C}
    (naX : x.Nonanticipating) (naA : a.Nonanticipating) : (explore s x a).Nonanticipating :=
  fun t h l l' agree c => by
    show ((bif s t then x.take t h l c else a.take t h l c) =
        bif s t then x.take t h l' c else a.take t h l' c) ∧
      ((bif s t then x.give t h l c else a.give t h l c) =
        bif s t then x.give t h l' c else a.give t h l' c)
    cases s t
    · exact naA t h l l' agree c
    · exact naX t h l l' agree c

/-- **Exploration installs only where the law itself acts.** Let each situation explore on its own
schedule `s e` by its own law `x e`, all reading what has stood, and let two act laws give alike,
for each member of the part, along the explored course the first generates in each situation at
every step the schedule leaves to the law. Then the two, explored, generate the same courses: what
the law does at an exploring step, or at a step left to it under a history no explored course
passes, is fixed by no training reading the explored courses. -/
theorem explored_same_courses {s : E → Nat → Bool} {x : E → ExchangeLaw F C}
    {a b : ExchangeLaw F C} (na : ∀ e, (law e).Nonanticipating) (naX : ∀ e, (x e).Nonanticipating)
    (naA : a.Nonanticipating) (naB : b.Nonanticipating)
    (along : ∀ e t h, part h = true → s e t = false → ∀ c,
      a.take t h (levels law part present start (fun e => explore (s e) (x e) a) e) c =
          b.take t h (levels law part present start (fun e => explore (s e) (x e) a) e) c ∧
        a.give t h (levels law part present start (fun e => explore (s e) (x e) a) e) c =
          b.give t h (levels law part present start (fun e => explore (s e) (x e) a) e) c) :
    SameCourses law part present start (fun e => explore (s e) (x e) a)
      (fun e => explore (s e) (x e) b) :=
  same_courses_of_along na (fun e => explore_nonanticipating (naX e) naA)
    (fun e => explore_nonanticipating (naX e) naB) fun e t h member c => by
      show ((bif s e t then (x e).take t h _ c else a.take t h _ c) =
          bif s e t then (x e).take t h _ c else b.take t h _ c) ∧
        ((bif s e t then (x e).give t h _ c else a.give t h _ c) =
          bif s e t then (x e).give t h _ c else b.give t h _ c)
      cases exploring : s e t
      · exact along e t h member exploring c
      · exact ⟨rfl, rfl⟩

/-! ## What the installed law does off its courses -/

/-- A lumping of histories by each formation up to each step: an equivalence at each step that
never separates histories agreeing up to it. What a law reads of the history through it is a
learner's representation; a coupling and agreement itself are lumpings. -/
structure Lumping (F C : Type) where
  alike : F → Nat → (Nat → C → Nat) → (Nat → C → Nat) → Prop
  refl : ∀ h t l, alike h t l l
  symm : ∀ {h t l l'}, alike h t l l' → alike h t l' l
  trans : ∀ {h t l l' l''}, alike h t l l' → alike h t l' l'' → alike h t l l''
  of_agree : ∀ {h t l l'}, AgreeUpTo l l' t → alike h t l l'

/-- Agreeing up to a step is symmetric. -/
theorem agree_symm {l l' : Nat → C → Nat} {t : Nat} (agree : AgreeUpTo l l' t) :
    AgreeUpTo l' l t :=
  fun s le c => (agree s le c).symm

/-- Histories agreeing up to a step are alike through every coupling up to it. -/
theorem alike_of_agree {W : Web F C} {obs : F → C → Prop} {g : F} {l l' : Nat → C → Nat} {t : Nat}
    (agree : AgreeUpTo l l' t) : W.AlikeThroughUpTo obs g l l' t :=
  fun s le =>
    ⟨⟨fun admits c requires => Nat.le_trans (admits c requires) (Nat.le_of_eq (agree s le c)),
      fun admits c requires =>
        Nat.le_trans (admits c requires) (Nat.le_of_eq (agree s le c).symm)⟩,
     fun c _ => agree s le c⟩

/-- The lumping of a web's couplings: histories alike through a formation's coupling up to a
step. -/
def Lumping.coupling (W : Web F C) (obs : F → C → Prop) : Lumping F C :=
  ⟨fun h t l l' => W.AlikeThroughUpTo obs h l l' t, fun _ _ _ s _ => Web.AlikeThrough.refl s,
   fun alike => alike.symm, fun first second => first.trans second, alike_of_agree⟩

/-- The finest lumping: histories agreeing up to a step. -/
def Lumping.agreement : Lumping F C :=
  ⟨fun _ t l l' => AgreeUpTo l l' t, fun _ _ _ _ _ _ => rfl, agree_symm,
   fun first second s le c => (first s le c).trans (second s le c), id⟩

/-- An act law reads through a lumping for the part: each member exchanges alike under histories
it lumps together up to the step. -/
def ReadsThrough (ρ : Lumping F C) (part : F → Bool) (a : ExchangeLaw F C) : Prop :=
  ∀ h, part h = true → ∀ t l l', ρ.alike h t l l' → a.GivesAlike t h l l'

/-- A law reading through the part's coupling reads through the coupling's lumping. -/
theorem ReadsThrough.of_through {W : Web F C} {obs : F → C → Prop} {a : ExchangeLaw F C}
    (through : a.Through W obs (fun h => !part h)) : ReadsThrough (Lumping.coupling W obs) part a :=
  fun h member => through h (congrArg Bool.not member)

/-- A law reading through the coupling's lumping reads through the part's coupling. -/
theorem ReadsThrough.through {W : Web F C} {obs : F → C → Prop} {a : ExchangeLaw F C}
    (reads : ReadsThrough (Lumping.coupling W obs) part a) : a.Through W obs (fun h => !part h) :=
  fun h out => reads h (by
    cases member : part h
    · exact absurd ((congrArg Bool.not member).symm.trans out) (by decide)
    · rfl)

/-- A law of what has stood reads through agreement. -/
theorem ReadsThrough.of_nonanticipating {a : ExchangeLaw F C} (na : a.Nonanticipating) :
    ReadsThrough Lumping.agreement part a :=
  fun h _ t l l' agree => na t h l l' agree

/-- **What a learner's lumping cannot tell from its courses is installed.** Let two act laws read
through a lumping for the part and have the same courses. At every history a member lumps, up to a
step, with the levels of one of the first's courses, the two take and give alike for that member
across that step. -/
theorem installed_where_lumped {ρ : Lumping F C} {a b : ExchangeLaw F C}
    (readsA : ReadsThrough ρ part a) (readsB : ReadsThrough ρ part b)
    (same : SameCourses law part present start (fun _ => a) (fun _ => b)) {h : F}
    (member : part h = true) {t : Nat} {l : Nat → C → Nat} {e : E}
    (lumped : ρ.alike h t l (levels law part present start (fun _ => a) e)) :
    ∀ c, a.take t h l c = b.take t h l c ∧ a.give t h l c = b.give t h l c :=
  fun c =>
    have levelsSame : ρ.alike h t (levels law part present start (fun _ => a) e)
        (levels law part present start (fun _ => b) e) :=
      ρ.of_agree fun s _ c => (same e s).1 c
    have onA := readsA h member t _ _ lumped c
    have onB := readsB h member t _ _ (ρ.trans lumped levelsSame) c
    have course := (same e t).2 h c
    ⟨onA.1.trans ((ExchangeLaw.withAct_take_of_part member t _ c).symm.trans
        (course.1.trans ((ExchangeLaw.withAct_take_of_part member t _ c).trans onB.1.symm))),
     onA.2.trans ((ExchangeLaw.withAct_give_of_part member t _ c).symm.trans
        (course.2.trans ((ExchangeLaw.withAct_give_of_part member t _ c).trans onB.2.symm)))⟩

/-- The case of the part's coupling: two laws reading through it with the same courses exchange
alike at every history a member's coupling cannot tell from one of the courses. -/
theorem installed_where_alike {W : Web F C} {obs : F → C → Prop} {a b : ExchangeLaw F C}
    (through : a.Through W obs (fun h => !part h)) (throughB : b.Through W obs (fun h => !part h))
    (same : SameCourses law part present start (fun _ => a) (fun _ => b)) {h : F}
    (member : part h = true) {t : Nat} {l : Nat → C → Nat} {e : E}
    (alike : W.AlikeThroughUpTo obs h l (levels law part present start (fun _ => a) e) t) :
    ∀ c, a.take t h l c = b.take t h l c ∧ a.give t h l c = b.give t h l c :=
  installed_where_lumped (ρ := Lumping.coupling W obs) (ReadsThrough.of_through through)
    (ReadsThrough.of_through throughB) same member alike

/-- The act law `a` with its take set to `k` across the step from `t₀`, for each formation `h`,
under every history `l` with `P h l`; it is `a` everywhere else. -/
def setOn (a : ExchangeLaw F C) (P : F → (Nat → C → Nat) → Prop)
    (decided : ∀ h l, Decidable (P h l)) (t₀ k : Nat) : ExchangeLaw F C :=
  ⟨fun t h l c => if t = t₀ then @ite _ (P h l) (decided h l) k (a.take t h l c)
      else a.take t h l c,
    a.give⟩

variable {a : ExchangeLaw F C} {P : F → (Nat → C → Nat) → Prop}
  {decided : ∀ h l, Decidable (P h l)} {t₀ k : Nat}

theorem setOn_take_off {t : Nat} {h : F} {l : Nat → C → Nat} {c : C} (off : ¬ (t = t₀ ∧ P h l)) :
    (setOn a P decided t₀ k).take t h l c = a.take t h l c :=
  show (if t = t₀ then @ite _ (P h l) (decided h l) k (a.take t h l c) else a.take t h l c) =
      a.take t h l c from
  match Nat.decEq t t₀ with
  | isTrue now => (if_pos now).trans (@if_neg _ (decided h l) (fun holds => off ⟨now, holds⟩) _ _ _)
  | isFalse other => if_neg other

theorem setOn_take_at {h : F} {l : Nat → C → Nat} {c : C} (holds : P h l) :
    (setOn a P decided t₀ k).take t₀ h l c = k :=
  show (if t₀ = t₀ then @ite _ (P h l) (decided h l) k (a.take t₀ h l c) else a.take t₀ h l c) =
      k from
  (if_pos rfl).trans (@if_pos _ (decided h l) holds _ _ _)

/-- **Setting a take keeps what a law respects.** Where `a` gives alike under histories related by
`rel` for the formations `who`, and `P h` does not tell apart histories related at `t₀`, the law
set on `P` gives alike under them too. -/
theorem setOn_respects {rel : Nat → F → (Nat → C → Nat) → (Nat → C → Nat) → Prop} {who : F → Prop}
    (respects : ∀ h, who h → ∀ t l l', rel t h l l' → a.GivesAlike t h l l')
    (invariant : ∀ h, who h → ∀ l l', rel t₀ h l l' → (P h l ↔ P h l')) :
    ∀ h, who h → ∀ t l l', rel t h l l' → (setOn a P decided t₀ k).GivesAlike t h l l' :=
  fun h member t l l' related c =>
    ⟨match Nat.decEq t t₀, decided h l with
      | isTrue now, isTrue holds => by
        subst now
        exact (setOn_take_at holds).trans
          (setOn_take_at ((invariant h member l l' related).mp holds)).symm
      | isTrue now, isFalse fails => by
        subst now
        exact (setOn_take_off fun both => fails both.2).trans
          ((respects h member t l l' related c).1.trans
            (setOn_take_off fun both => fails ((invariant h member l l' related).mpr both.2)).symm)
      | isFalse other, _ =>
        (setOn_take_off fun both => other both.1).trans
          ((respects h member t l l' related c).1.trans
            (setOn_take_off fun both => other both.1).symm),
     (respects h member t l l' related c).2⟩

/-- The law set on what a lumping lumps with `m` at `t₀` reads what has stood where `a` does,
reads through the lumping where `a` does, and, where no member lumps `m` with any course `a`
generates, has the same courses as `a`. -/
theorem setOn_lumped {ρ : Lumping F C} (na : ∀ e, (law e).Nonanticipating)
    (naA : a.Nonanticipating) (reads : ReadsThrough ρ part a) {m : Nat → C → Nat}
    (decidedLumped : ∀ h l, Decidable (ρ.alike h t₀ m l))
    (off : ∀ e h, part h = true →
      ¬ ρ.alike h t₀ m (levels law part present start (fun _ => a) e)) (k : Nat) :
    (setOn a (fun h l => ρ.alike h t₀ m l) decidedLumped t₀ k).Nonanticipating ∧
      ReadsThrough ρ part (setOn a (fun h l => ρ.alike h t₀ m l) decidedLumped t₀ k) ∧
      SameCourses law part present start (fun _ => a)
        (fun _ => setOn a (fun h l => ρ.alike h t₀ m l) decidedLumped t₀ k) :=
  have na' : (setOn a (fun h l => ρ.alike h t₀ m l) decidedLumped t₀ k).Nonanticipating :=
    fun t h l l' agree =>
      setOn_respects (rel := fun t _ l l' => AgreeUpTo l l' t) (who := fun _ => True)
        (fun h _ t l l' agree => naA t h l l' agree)
        (fun _ _ _ _ agree => ⟨fun first => ρ.trans first (ρ.of_agree agree),
          fun second => ρ.trans second (ρ.of_agree (agree_symm agree))⟩) h trivial t l l' agree
  ⟨na',
   setOn_respects (rel := fun t h l l' => ρ.alike h t l l') (who := fun h => part h = true) reads
     fun _ _ _ _ lumped => ⟨fun first => ρ.trans first lumped, fun second => ρ.trans second (ρ.symm lumped)⟩,
   same_courses_of_along na (fun _ => naA) (fun _ => na') fun e _ h member _ =>
     ⟨(setOn_take_off (P := fun h l => ρ.alike h t₀ m l) (decided := decidedLumped)
        fun both => off e h member both.2).symm, rfl⟩⟩

/-- **What a learner's lumping tells apart from every course is installed by no training.** Let
the situations' laws and the act law `a` read what has stood, `a` through a lumping for the part,
and let no member lump the history `m` up to `t₀` with any course `a` generates, being lumped with
`m` decided. For every amount `k` there is an act law reading what has stood and through the
lumping, with the same courses as `a`, taking `k` across the step from `t₀` for each member under
every history it lumps with `m`. -/
theorem free_where_unlumped {ρ : Lumping F C} (na : ∀ e, (law e).Nonanticipating)
    (naA : a.Nonanticipating) (reads : ReadsThrough ρ part a) {m : Nat → C → Nat}
    (decidedLumped : ∀ h l, Decidable (ρ.alike h t₀ m l))
    (off : ∀ e h, part h = true →
      ¬ ρ.alike h t₀ m (levels law part present start (fun _ => a) e)) (k : Nat) :
    ∃ b : ExchangeLaw F C, b.Nonanticipating ∧ ReadsThrough ρ part b ∧
      (∀ h l c, ρ.alike h t₀ m l → b.take t₀ h l c = k) ∧
      SameCourses law part present start (fun _ => a) (fun _ => b) :=
  have built := setOn_lumped na naA reads decidedLumped off k
  ⟨_, built.1, built.2.1, fun _ _ _ lumped => setOn_take_at lumped, built.2.2⟩

/-- **Whether the installed law responds where its lumping tells a history from its courses is
fixed by no training.** Under the conditions of `free_where_unlumped`, let `m'` be a history a
member does not lump with `m` up to `t₀`. Some act law reading what has stood and through the
lumping, with the same courses as `a`, takes from `c` for that member alike under `m` and `m'`,
and some takes differently. -/
theorem response_free_where_unlumped {ρ : Lumping F C} (na : ∀ e, (law e).Nonanticipating)
    (naA : a.Nonanticipating) (reads : ReadsThrough ρ part a) {m m' : Nat → C → Nat}
    (decidedLumped : ∀ h l, Decidable (ρ.alike h t₀ m l))
    (off : ∀ e h, part h = true →
      ¬ ρ.alike h t₀ m (levels law part present start (fun _ => a) e))
    {h : F} (apart : ¬ ρ.alike h t₀ m m') (c : C) :
    (∃ b : ExchangeLaw F C, b.Nonanticipating ∧ ReadsThrough ρ part b ∧
        SameCourses law part present start (fun _ => a) (fun _ => b) ∧
        b.take t₀ h m c = b.take t₀ h m' c) ∧
      ∃ b : ExchangeLaw F C, b.Nonanticipating ∧ ReadsThrough ρ part b ∧
        SameCourses law part present start (fun _ => a) (fun _ => b) ∧
        b.take t₀ h m c ≠ b.take t₀ h m' c :=
  have there : ∀ k, (setOn a (fun h l => ρ.alike h t₀ m l) decidedLumped t₀ k).take t₀ h m' c =
      a.take t₀ h m' c := fun _ => setOn_take_off fun both => apart both.2
  have at_m : ∀ k, (setOn a (fun h l => ρ.alike h t₀ m l) decidedLumped t₀ k).take t₀ h m c = k :=
    fun _ => setOn_take_at (ρ.refl h t₀ m)
  have built := fun k => setOn_lumped na naA reads decidedLumped off k
  ⟨⟨_, (built (a.take t₀ h m' c)).1, (built _).2.1, (built _).2.2,
     (at_m _).trans (there _).symm⟩,
   ⟨_, (built (a.take t₀ h m' c + 1)).1, (built _).2.1, (built _).2.2,
     fun equal => Nat.succ_ne_self (a.take t₀ h m' c)
       (((at_m _).symm.trans equal).trans (there _))⟩⟩

/-- The case of the part's coupling: at a history each member's coupling tells apart from every
course, some law reading what has stood and through the coupling, with the same courses, takes any
amount, and responds or not to a difference the member's coupling separates. -/
theorem response_free_where_apart {W : Web F C} {obs : F → C → Prop}
    (na : ∀ e, (law e).Nonanticipating) (naA : a.Nonanticipating)
    (through : a.Through W obs (fun h => !part h)) {m m' : Nat → C → Nat}
    (decidedAlike : ∀ h l, Decidable (W.AlikeThroughUpTo obs h m l t₀))
    (off : ∀ e h, part h = true →
      ¬ W.AlikeThroughUpTo obs h m (levels law part present start (fun _ => a) e) t₀)
    {h : F} (apart : ¬ W.AlikeThroughUpTo obs h m m' t₀) (c : C) :
    (∃ b : ExchangeLaw F C, b.Nonanticipating ∧ b.Through W obs (fun h => !part h) ∧
        SameCourses law part present start (fun _ => a) (fun _ => b) ∧
        b.take t₀ h m c = b.take t₀ h m' c) ∧
      ∃ b : ExchangeLaw F C, b.Nonanticipating ∧ b.Through W obs (fun h => !part h) ∧
        SameCourses law part present start (fun _ => a) (fun _ => b) ∧
        b.take t₀ h m c ≠ b.take t₀ h m' c :=
  let both := response_free_where_unlumped (ρ := Lumping.coupling W obs) na naA
    (ReadsThrough.of_through through) decidedAlike off apart c
  let ⟨b, naB, readsB, same, alikeTake⟩ := both.1
  let ⟨b', naB', readsB', same', apartTake⟩ := both.2
  ⟨⟨b, naB, readsB.through, same, alikeTake⟩, ⟨b', naB', readsB'.through, same', apartTake⟩⟩

/-- **Nothing is installed off the courses.** The case of the finest lumping: for a history `m'`
not agreeing with `m` up to `t₀`, where `m` up to `t₀` is passed by no course of `a`, some act law
of what has stood with the same courses as `a` takes from `c` alike under `m` and `m'`, and some
takes differently. -/
theorem response_free_off_courses (na : ∀ e, (law e).Nonanticipating) (naA : a.Nonanticipating)
    {m m' : Nat → C → Nat} (decidedAgree : ∀ l, Decidable (AgreeUpTo m l t₀))
    (off : ∀ e, ¬ AgreeUpTo m (levels law part present start (fun _ => a) e) t₀)
    (apart : ¬ AgreeUpTo m m' t₀) (h : F) (c : C) :
    (∃ b : ExchangeLaw F C, b.Nonanticipating ∧
        SameCourses law part present start (fun _ => a) (fun _ => b) ∧
        b.take t₀ h m c = b.take t₀ h m' c) ∧
      ∃ b : ExchangeLaw F C, b.Nonanticipating ∧
        SameCourses law part present start (fun _ => a) (fun _ => b) ∧
        b.take t₀ h m c ≠ b.take t₀ h m' c :=
  let both := response_free_where_unlumped (ρ := Lumping.agreement) (h := h) na naA
    (ReadsThrough.of_nonanticipating naA) (fun _ l => decidedAgree l) (fun e _ _ => off e) apart c
  let ⟨b, naB, _, same, alikeTake⟩ := both.1
  let ⟨b', naB', _, same', apartTake⟩ := both.2
  ⟨⟨b, naB, same, alikeTake⟩, ⟨b', naB', same', apartTake⟩⟩

/-! ## Training through a reward's couplings -/

variable {cand : Θ → E → ExchangeLaw F C} {W : Web F C} {obs : F → C → Prop} {r : F} {T : Nat}

variable (law part present start cand) in
/-- A training through `r`'s couplings up to `T`: candidates whose levels are alike through `r`'s
couplings up to `T` in every situation are selected alike. -/
def TrainsThrough (W : Web F C) (obs : F → C → Prop) (r : F) (T : Nat) (select : Θ → Prop) :
    Prop :=
  ∀ θ θ', (∀ e, W.AlikeThroughUpTo obs r (levels law part present start (cand θ) e)
      (levels law part present start (cand θ') e) T) → (select θ ↔ select θ')

/-- A training through a reward's couplings reads candidates through their courses. -/
theorem TrainsThrough.reads {select : Θ → Prop}
    (through : TrainsThrough law part present start cand W obs r T select) :
    Reads law part present start cand select :=
  fun θ θ' same => through θ θ' fun e => alike_of_agree fun s _ c => (same e s).1 c

/-- **Training through a reward's couplings reaches exactly what couples into it, on the
learner's own courses.** Two candidates are trained alike by every training through `r`'s
couplings up to `T` exactly when their levels are alike through `r`'s couplings up to `T` in
every situation. As `Web.selects_alike_iff`, by construction. -/
theorem trained_alike_iff {θ θ' : Θ} :
    (∀ select, TrainsThrough law part present start cand W obs r T select →
        (select θ ↔ select θ')) ↔
      ∀ e, W.AlikeThroughUpTo obs r (levels law part present start (cand θ) e)
        (levels law part present start (cand θ') e) T :=
  ⟨fun all => (all (fun θ'' => ∀ e, W.AlikeThroughUpTo obs r
      (levels law part present start (cand θ) e) (levels law part present start (cand θ'') e) T)
      (fun _ _ alike =>
        ⟨fun first e => (first e).trans (alike e),
         fun second e => (second e).trans (alike e).symm⟩)).mp
      fun _ s _ => Web.AlikeThrough.refl s,
   fun alike _ through => through θ θ' alike⟩

/-- A reward reads the candidates through `r`'s couplings up to `T`: candidates whose levels are
alike through them in every situation are rewarded alike. -/
def RewardsThrough (W : Web F C) (obs : F → C → Prop) (r : F) (T : Nat) (reward : Θ → Nat) :
    Prop :=
  ∀ θ θ', (∀ e, W.AlikeThroughUpTo obs r (levels law part present start (cand θ) e)
      (levels law part present start (cand θ') e) T) → reward θ = reward θ'

/-- A reward settles on a candidate where no candidate is rewarded more. -/
def Settles (reward : Θ → Nat) (θ : Θ) : Prop :=
  ∀ θ', reward θ' ≤ reward θ

/-- **What a reward through `r`'s couplings settles on is a training through them.** -/
theorem settles_through {reward : Θ → Nat}
    (through : RewardsThrough (law := law) (part := part) (present := present) (start := start)
      (cand := cand) W obs r T reward) :
    TrainsThrough law part present start cand W obs r T (Settles reward) :=
  fun θ θ' alike =>
    have same := through θ θ' alike
    ⟨fun settles θ'' => Nat.le_trans (settles θ'') (Nat.le_of_eq same),
     fun settles θ'' => Nat.le_trans (settles θ'') (Nat.le_of_eq same.symm)⟩

/-- A score of level histories through `r`'s couplings up to `T`, read in one situation, is a
reward through them. -/
theorem score_rewards {score : (Nat → C → Nat) → Nat} (scores : W.ScoresThrough obs r T score)
    (e₀ : E) :
    RewardsThrough (law := law) (part := part) (present := present) (start := start)
      (cand := cand) W obs r T (fun θ => score (levels law part present start (cand θ) e₀)) :=
  fun _ _ alike => scores _ _ (alike e₀)

/-- **Where two candidates' levels are apart through `r`'s couplings, some reward through them
settles on one and not the other.** With the class of the first's levels decided in one
situation where the two are apart, the reward giving one to the candidates in that class settles
on the first and not on the second. -/
theorem settles_apart {θ θ' : Θ} {e₀ : E}
    (decided : ∀ l, Decidable (W.AlikeThroughUpTo obs r (levels law part present start (cand θ) e₀)
      l T))
    (apart : ¬ W.AlikeThroughUpTo obs r (levels law part present start (cand θ) e₀)
      (levels law part present start (cand θ') e₀) T) :
    ∃ reward : Θ → Nat, RewardsThrough (law := law) (part := part) (present := present)
        (start := start) (cand := cand) W obs r T reward ∧
      Settles reward θ ∧ ¬ Settles reward θ' :=
  let mark : Θ → Nat := fun θ'' =>
    @ite _ (W.AlikeThroughUpTo obs r (levels law part present start (cand θ) e₀)
      (levels law part present start (cand θ'') e₀) T) (decided _) 1 0
  have markAt : mark θ = 1 := @if_pos _ (decided _) (fun s _ => Web.AlikeThrough.refl s) _ _ _
  have markOff : mark θ' = 0 := @if_neg _ (decided _) apart _ _ _
  have le_one : ∀ θ'', mark θ'' ≤ 1 := fun θ'' =>
    match decided (levels law part present start (cand θ'') e₀) with
    | isTrue yes => Nat.le_of_eq (@if_pos _ (decided _) yes _ _ _)
    | isFalse no => Nat.le_trans (Nat.le_of_eq (@if_neg _ (decided _) no _ _ _)) (Nat.zero_le 1)
  ⟨mark,
   fun θ₁ θ₂ alike =>
    match decided (levels law part present start (cand θ₁) e₀),
      decided (levels law part present start (cand θ₂) e₀) with
    | isTrue first, isTrue second =>
      (@if_pos _ (decided _) first _ _ _).trans (@if_pos _ (decided _) second _ _ _).symm
    | isFalse first, isFalse second =>
      (@if_neg _ (decided _) first _ _ _).trans (@if_neg _ (decided _) second _ _ _).symm
    | isTrue first, isFalse second => absurd (first.trans (alike e₀)) second
    | isFalse first, isTrue second => absurd (second.trans (alike e₀).symm) first,
   fun θ'' => Nat.le_trans (le_one θ'') (Nat.le_of_eq markAt.symm),
   fun settles => Nat.not_succ_le_zero 0 (Nat.le_trans (Nat.le_of_eq markAt.symm)
      (Nat.le_trans (settles θ) (Nat.le_of_eq markOff)))⟩

/-- A search step over the candidates is improving for a reward where it stays or moves to a
candidate the reward rewards more. -/
def Improving (reward : Θ → Nat) (next : Θ → Θ) : Prop :=
  ∀ θ, next θ = θ ∨ reward θ < reward (next θ)

/-- **Every candidate a reward settles on is a rest of every improving search.** -/
theorem settled_rests {reward : Θ → Nat} {next : Θ → Θ} (improving : Improving reward next)
    {θ : Θ} (settles : Settles reward θ) : next θ = θ :=
  match improving θ with
  | .inl same => same
  | .inr up => absurd (settles (next θ)) (Nat.not_le_of_gt up)

/-- **Where a reward settles on several candidates, an improving search keeps the one it starts
from.** Every improving search started at a settled candidate stays there at every step, so which
of several settled laws is reached is fixed by the search's start and steps, not by the reward. -/
theorem settled_stays {reward : Θ → Nat} {next : Θ → Θ} (improving : Improving reward next)
    {θ : Θ} (settles : Settles reward θ) : ∀ n, Law.orbit next θ n = θ
  | 0 => rfl
  | n + 1 => (congrArg next (settled_stays improving settles n)).trans
      (settled_rests improving settles)

/-- A local search over the neighbourhood relation `near`: from each candidate it stays or moves to
a neighbour the reward rewards more, and it moves wherever some neighbour is rewarded more. The
neighbourhoods are the search's parameterization. -/
def LocalSearch (near : Θ → Θ → Prop) (reward : Θ → Nat) (next : Θ → Θ) : Prop :=
  (∀ θ, next θ = θ ∨ (near θ (next θ) ∧ reward θ < reward (next θ))) ∧
    ∀ θ θ', near θ θ' → reward θ < reward θ' → next θ ≠ θ

/-- A local search is improving. -/
theorem LocalSearch.improving {near : Θ → Θ → Prop} {reward : Θ → Nat} {next : Θ → Θ}
    (search : LocalSearch near reward next) : Improving reward next :=
  fun θ => match search.1 θ with
    | .inl same => .inl same
    | .inr ⟨_, up⟩ => .inr up

/-- **A local search rests exactly where no neighbour is rewarded more.** -/
theorem LocalSearch.rests_iff {near : Θ → Θ → Prop} {reward : Θ → Nat} {next : Θ → Θ}
    (search : LocalSearch near reward next) {θ : Θ} :
    next θ = θ ↔ ∀ θ', near θ θ' → reward θ' ≤ reward θ :=
  ⟨fun rests θ' neighbour => Nat.le_of_not_lt fun up => search.2 θ θ' neighbour up rests,
   fun best => match search.1 θ with
    | .inl same => same
    | .inr ⟨neighbour, up⟩ => absurd (best _ neighbour) (Nat.not_le_of_gt up)⟩

/-- **With every candidate a neighbour, a local search rests exactly at what the reward settles
on.** The rests a narrower neighbourhood adds are the parameterization's, not the reward's. -/
theorem LocalSearch.rests_iff_settles {reward : Θ → Nat} {next : Θ → Θ}
    (search : LocalSearch (fun _ _ => True) reward next) {θ : Θ} :
    next θ = θ ↔ Settles reward θ :=
  ⟨fun rests θ' => search.rests_iff.mp rests θ' trivial,
   fun settles => search.rests_iff.mpr fun θ' _ => settles θ'⟩

/-- Before an improving search rests, its reward has risen by at least the steps taken: at each step
it has rested or the reward of where it stands is at least the step. -/
theorem rested_or_risen {reward : Θ → Nat} {next : Θ → Θ} (improving : Improving reward next)
    (θ : Θ) : ∀ n, next (Law.orbit next θ n) = Law.orbit next θ n ∨
      n ≤ reward (Law.orbit next θ n)
  | 0 => .inr (Nat.zero_le _)
  | n + 1 => match rested_or_risen improving θ n with
    | .inl rests => .inl (congrArg next rests)
    | .inr risen => match improving (Law.orbit next θ n) with
      | .inl same => .inl (congrArg next same)
      | .inr up => .inr (Nat.lt_of_le_of_lt risen up)

/-- **Under a bounded reward an improving search comes to rest within the bound.** Where the reward
is at most `B`, from every start the search rests at step `B + 1`: the basin of a start is where its
orbit stands then. -/
theorem comes_to_rest {reward : Θ → Nat} {next : Θ → Θ} (improving : Improving reward next)
    {B : Nat} (bounded : ∀ θ, reward θ ≤ B) (θ : Θ) :
    next (Law.orbit next θ (B + 1)) = Law.orbit next θ (B + 1) :=
  match rested_or_risen improving θ (B + 1) with
  | .inl rests => rests
  | .inr risen => absurd (Nat.le_trans risen (bounded _)) (Nat.not_succ_le_self B)

/-- **A difference in what the learner's act does is installed only where it reaches what couples
into the reward's closure.** Let the rest's law read what has stood and through coupling, and,
in every situation, let the two candidates read what has stood, the first through its members'
coupling, both courses be feasible, and the two agree on every condition coupled into `r`'s
coupling closure drawn through their two courses. Then every training through `r`'s couplings
trains them alike. -/
theorem trained_alike_beyond_closure {θ θ' : Θ} (na : ∀ e, (law e).Nonanticipating)
    (naA : ∀ e, (cand θ e).Nonanticipating) (naB : ∀ e, (cand θ' e).Nonanticipating)
    (through : ∀ e, (law e).Through W obs part)
    (actThrough : ∀ e, (cand θ e).Through W obs (fun h => !part h))
    (feasible : ∀ e, ((law e).withAct part (cand θ e)).Feasible present (start e))
    (feasible' : ∀ e, ((law e).withAct part (cand θ' e)).Feasible present (start e))
    (agree : ∀ e t h l c, part h = true →
      (∃ g, WithinClosure ((((law e).withAct part (cand θ e)).course present
          (start e)).CoupledFromEither W (((law e).withAct part (cand θ' e)).course present
          (start e)) obs) r g ∧ W.CoupledInto obs g c) →
        (cand θ e).take t h l c = (cand θ' e).take t h l c ∧
          (cand θ e).give t h l c = (cand θ' e).give t h l c)
    {select : Θ → Prop} (training : TrainsThrough law part present start cand W obs r T select) :
    select θ ↔ select θ' :=
  training θ θ' fun e =>
    (act_courses_unselected (f := r) (na e) (naA e) (naB e) (through e) (actThrough e) (feasible e)
      (feasible' e) (agree e) (WithinClosure.refl r) (Web.class_selects (l := levels law part present start
        (cand θ) e))).mp fun s _ => Web.AlikeThrough.refl s

/-! ## Coupling into a condition the rest outruns installs nothing -/

/-- **A reading the same for every candidate leaves the optimum.** Where `read` is the same for
every candidate, a reward adding it at any weight settles exactly where `own` settles. -/
theorem settles_weighted_iff {own read : Θ → Nat} (same : ∀ θ θ', read θ = read θ') (w : Nat)
    {θ : Θ} : Settles (fun θ' => own θ' + w * read θ') θ ↔ Settles own θ :=
  ⟨fun settles θ' => Naturals.le_of_add_le_add_right
      (Nat.le_trans (settles θ') (Nat.le_of_eq (congrArg (fun x => own θ + w * x) (same θ θ')))),
   fun settles θ' => Nat.le_trans (Nat.add_le_add_right (settles θ') _)
      (Nat.le_of_eq (congrArg (fun x => own θ + w * x) (same θ' θ)))⟩

/-- **Where the rest outruns the renewal in every candidate's course, a reading after its end is
the same for every candidate.** In situation `e₀`, let each candidate's course balance, only
active formations give in it, activity there need support, whatever gives to `c` depend on it at
need one, and a list of the rest take from `c` jointly more than is given at each of `n` steps
from `T`, from a level at most `n`. Every score reading `c` only from `T + n` on then scores every
candidate's levels alike. -/
theorem outrun_reading_same {e₀ : E} {c : C} {n : Nat}
    (balances : ∀ θ, (course law part present start (cand θ) e₀).Balances
      (W.withLevel (levels law part present start (cand θ) e₀)))
    (acting : ∀ θ, (course law part present start (cand θ) e₀).Acting
      (W.withLevel (levels law part present start (cand θ) e₀)))
    (dependent : ∀ θ, (W.withLevel (levels law part present start (cand θ) e₀)).Dependent)
    (gated : ∀ θ t g, g ∈ present t → 0 < (course law part present start (cand θ) e₀).give t g c →
      W.requires t g c ∧ 1 ≤ W.need t g c)
    (rest : Θ → List F) (distinct : ∀ θ, Distinct (rest θ))
    (taking : ∀ θ j g, j < n → g ∈ rest θ →
      0 < (course law part present start (cand θ) e₀).take (T + j) g c → g ∈ present (T + j))
    (outruns : ∀ θ j, j < n → (course law part present start (cand θ) e₀).given (T + j) c <
      total (rest θ) fun g => (course law part present start (cand θ) e₀).take (T + j) g c)
    (low : ∀ θ, levels law part present start (cand θ) e₀ T c < n + 1)
    {score : (Nat → C → Nat) → Nat}
    (reads : ∀ l l', (∀ k, l (T + n + k) c = l' (T + n + k) c) → score l = score l')
    (θ θ' : Θ) :
    score (levels law part present start (cand θ) e₀) =
      score (levels law part present start (cand θ') e₀) :=
  Flow.outrun_reading_alike (balances θ) (acting θ) (dependent θ) (balances θ') (acting θ')
    (dependent θ') (gated θ) (gated θ') (distinct θ) (distinct θ') (taking θ) (taking θ')
    (outruns θ) (outruns θ') (low θ) (low θ') reads

/-- **Coupling into a condition the rest outruns installs nothing, at any weight.** Under the
conditions of `outrun_reading_same`, a reward adding to `own` a score reading `c` only from
`T + n` on, at any weight, settles exactly where `own` settles. -/
theorem outrun_settles_iff {e₀ : E} {c : C} {n : Nat}
    (balances : ∀ θ, (course law part present start (cand θ) e₀).Balances
      (W.withLevel (levels law part present start (cand θ) e₀)))
    (acting : ∀ θ, (course law part present start (cand θ) e₀).Acting
      (W.withLevel (levels law part present start (cand θ) e₀)))
    (dependent : ∀ θ, (W.withLevel (levels law part present start (cand θ) e₀)).Dependent)
    (gated : ∀ θ t g, g ∈ present t → 0 < (course law part present start (cand θ) e₀).give t g c →
      W.requires t g c ∧ 1 ≤ W.need t g c)
    (rest : Θ → List F) (distinct : ∀ θ, Distinct (rest θ))
    (taking : ∀ θ j g, j < n → g ∈ rest θ →
      0 < (course law part present start (cand θ) e₀).take (T + j) g c → g ∈ present (T + j))
    (outruns : ∀ θ j, j < n → (course law part present start (cand θ) e₀).given (T + j) c <
      total (rest θ) fun g => (course law part present start (cand θ) e₀).take (T + j) g c)
    (low : ∀ θ, levels law part present start (cand θ) e₀ T c < n + 1)
    {score : (Nat → C → Nat) → Nat}
    (reads : ∀ l l', (∀ k, l (T + n + k) c = l' (T + n + k) c) → score l = score l')
    (own : Θ → Nat) (w : Nat) {θ : Θ} :
    Settles (fun θ' => own θ' + w * score (levels law part present start (cand θ') e₀)) θ ↔
      Settles own θ :=
  settles_weighted_iff (outrun_reading_same balances acting dependent gated rest distinct taking
    outruns low reads) w

end Laws

/-! ## A computed commons -/

namespace Commons

/-- The learner, the rest drawing beside it, and the formation whose giving renews the stock. -/
inductive Member where
  | learner
  | rest
  | renewer

/-- The conditions: `false` the stock, `true` the learner's store. -/
abbrev Stock : Bool := false

/-- Everyone is present at every step. -/
def present : Nat → List Member := fun _ => [.learner, .rest, .renewer]

/-- The renewer gives one unit to the stock across a step where the stock stands at one or more:
renewal gated at need one. The rest takes from the stock `draw` units where it stands at one or
more. -/
def others (draw : Nat) : ExchangeLaw Member Bool :=
  ⟨fun t f l c => match f, c with
    | .rest, false => if l t false = 0 then 0 else draw
    | .rest, true => 0
    | .learner, _ => 0
    | .renewer, _ => 0,
   fun t f l c => match f, c with
    | .renewer, false => if l t false = 0 then 0 else 1
    | .renewer, true => 0
    | .learner, _ => 0
    | .rest, _ => 0⟩

/-- The drawing law: the learner takes one unit from the stock into its store where the stock
stands at three or more. -/
def drawing : ExchangeLaw Member Bool :=
  ⟨fun t f l c => match f, c with
    | .learner, false => if 3 ≤ l t false then 1 else 0
    | .learner, true => 0
    | .rest, _ => 0
    | .renewer, _ => 0,
   fun t f l c => match f, c with
    | .learner, true => if 3 ≤ l t false then 1 else 0
    | .learner, false => 0
    | .rest, _ => 0
    | .renewer, _ => 0⟩

/-- Restraint: the learner exchanges nothing. -/
def restraint : ExchangeLaw Member Bool := ⟨fun _ _ _ _ => 0, fun _ _ _ _ => 0⟩

/-- The candidates: `true` restraint, `false` the drawing law. -/
def cand : Bool → ExchangeLaw Member Bool := fun b => if b then restraint else drawing

/-- The learner is the part. -/
def part : Member → Bool := fun f => match f with
  | .learner => true
  | .rest => false
  | .renewer => false

/-- One situation: four in the stock, nothing in the store. -/
def start : Unit → Bool → Nat := fun _ c => if c then 0 else 4

/-- The levels a candidate generates with the rest drawing `draw` a step. -/
def lev (draw : Nat) (b : Bool) : Nat → Bool → Nat :=
  levels (fun _ => others draw) part present start (fun _ => cand b) ()

/-- The learner's reward at weight `w`: its store at step four, and `w` times the stock then. -/
def reward (draw w : Nat) (b : Bool) : Nat := lev draw b 4 true + w * lev draw b 4 false

/-- The learner couples into both conditions by level. -/
def obs : Member → Bool → Prop := fun f _ => match f with
  | .learner => True
  | .rest => False
  | .renewer => False

/-- The web read: nothing required, so admission is never in question. -/
def web : Web Member Bool :=
  ⟨fun _ _ => 0, fun _ _ => True, fun _ _ _ => False, fun _ _ _ => 0, fun _ _ _ => False⟩

/-- The reward reads through the learner's coupling, by level, into the stock and its store. -/
theorem reward_through (draw w : Nat) :
    RewardsThrough (law := fun _ => others draw) (part := part) (present := present)
      (start := start) (cand := fun b _ => cand b) web obs .learner 4 (reward draw w) :=
  score_rewards (fun l l' alike =>
    (congrArg (· + w * l 4 false) ((alike 4 (Nat.le_refl 4)).2 true trivial)).trans
      (congrArg (l' 4 true + w * ·) ((alike 4 (Nat.le_refl 4)).2 false trivial))) ()

/-- The reward couples into the stock. -/
theorem couples_into_stock : web.CoupledInto obs .learner Stock :=
  Or.inr trivial

theorem renewed_drawing_store : lev 1 false 4 true = 2 := rfl
theorem renewed_drawing_stock : lev 1 false 4 false = 2 := rfl
theorem renewed_restraint_store : lev 1 true 4 true = 0 := rfl
theorem renewed_restraint_stock : lev 1 true 4 false = 4 := rfl
theorem outrun_drawing_store : lev 2 false 4 true = 1 := rfl
theorem outrun_drawing_stock : lev 2 false 4 false = 0 := rfl
theorem outrun_restraint_store : lev 2 true 4 true = 0 := rfl
theorem outrun_restraint_stock : lev 2 true 4 false = 0 := rfl

theorem renewed_restraint_reward (w : Nat) : reward 1 w true = w * 4 :=
  show lev 1 true 4 true + w * lev 1 true 4 false = w * 4 from
  (congrArg (· + w * lev 1 true 4 false) renewed_restraint_store).trans
    ((Nat.zero_add _).trans (congrArg (w * ·) renewed_restraint_stock))

theorem renewed_drawing_reward (w : Nat) : reward 1 w false = 2 + w * 2 :=
  show lev 1 false 4 true + w * lev 1 false 4 false = 2 + w * 2 from
  (congrArg (· + w * lev 1 false 4 false) renewed_drawing_store).trans
    (congrArg (2 + w * ·) renewed_drawing_stock)

theorem outrun_restraint_reward (w : Nat) : reward 2 w true = 0 :=
  show lev 2 true 4 true + w * lev 2 true 4 false = 0 from
  (congrArg (· + w * lev 2 true 4 false) outrun_restraint_store).trans
    ((Nat.zero_add _).trans ((congrArg (w * ·) outrun_restraint_stock).trans (Nat.mul_zero w)))

theorem outrun_drawing_reward (w : Nat) : reward 2 w false = 1 :=
  show lev 2 false 4 true + w * lev 2 false 4 false = 1 from
  (congrArg (· + w * lev 2 false 4 false) outrun_drawing_store).trans
    (congrArg (1 + ·) ((congrArg (w * ·) outrun_drawing_stock).trans (Nat.mul_zero w)))

/-- Two and twice a weight reach four times it only from weight one. -/
theorem one_le_of_le : ∀ w : Nat, 2 + w * 2 ≤ w * 4 → 1 ≤ w
  | 0, le => absurd le (by decide)
  | w + 1, _ => Nat.succ_le_succ (Nat.zero_le w)

/-- **Where the rest takes no more than the renewal, restraint is settled exactly at weights of at
least one.** -/
theorem renewed_restraint_settles_iff (w : Nat) : Settles (reward 1 w) true ↔ 1 ≤ w :=
  ⟨fun settles => one_le_of_le w (Nat.le_trans (Nat.le_of_eq (renewed_drawing_reward w).symm)
      (Nat.le_trans (settles false) (Nat.le_of_eq (renewed_restraint_reward w)))),
   fun one θ' =>
    match θ' with
    | true => Nat.le_refl _
    | false =>
      Nat.le_trans (Nat.le_of_eq (renewed_drawing_reward w))
        (Nat.le_trans
          (Nat.add_le_add_right (Nat.le_trans (by decide : 2 ≤ 1 * 2)
            (Nat.mul_le_mul_right 2 one)) (w * 2))
          (Nat.le_of_eq ((Nat.mul_add w 2 2).symm.trans (renewed_restraint_reward w).symm)))⟩

/-- **Where the rest outruns the renewal, restraint is settled at no weight.** -/
theorem outrun_restraint_unsettled (w : Nat) : ¬ Settles (reward 2 w) true :=
  fun settles => Nat.not_succ_le_zero 0 (Nat.le_trans (Nat.le_of_eq (outrun_drawing_reward w).symm)
    (Nat.le_trans (settles false) (Nat.le_of_eq (outrun_restraint_reward w))))

/-- **Where the rest outruns the renewal, the drawing law is settled at every weight.** -/
theorem outrun_drawing_settles (w : Nat) : Settles (reward 2 w) false :=
  fun θ' => match θ' with
    | false => Nat.le_refl _
    | true => Nat.le_trans (Nat.le_of_eq (outrun_restraint_reward w))
        (Nat.le_trans (Nat.zero_le 1) (Nat.le_of_eq (outrun_drawing_reward w).symm))

/-- **At weight one both laws are settled.** Where the rest draws within the renewal, the reward
at weight one settles on restraint and on the drawing law alike. -/
theorem renewed_both_settle : Settles (reward 1 1) true ∧ Settles (reward 1 1) false :=
  have restrained : reward 1 1 true = 4 := renewed_restraint_reward 1
  have drawn : reward 1 1 false = 4 := renewed_drawing_reward 1
  have both : ∀ θ', reward 1 1 θ' ≤ 4 := fun θ' => match θ' with
    | true => Nat.le_of_eq restrained
    | false => Nat.le_of_eq drawn
  ⟨fun θ' => Nat.le_trans (both θ') (Nat.le_of_eq restrained.symm),
   fun θ' => Nat.le_trans (both θ') (Nat.le_of_eq drawn.symm)⟩

/-- The drawing law responds to the stock's level: it takes one where the stock stands at three and
nothing where it stands at none. Restraint takes nothing under every history. -/
theorem drawing_responds :
    drawing.take 0 .learner (fun _ _ => 3) false ≠ drawing.take 0 .learner (fun _ _ => 0) false ∧
      ∀ t h l c, restraint.take t h l c = 0 :=
  ⟨by decide, fun _ _ _ _ => rfl⟩

/-- **Which law is installed is the search's start.** At weight one, with the rest drawing within
the renewal, every improving search started at restraint stays at restraint and every one started
at the drawing law stays at the drawing law: the same reward installs a law that responds to the
stock or one that does not, as the search starts. -/
theorem start_decides {next : Bool → Bool} (improving : Improving (reward 1 1) next) :
    (∀ n, Law.orbit next true n = true) ∧ ∀ n, Law.orbit next false n = false :=
  ⟨settled_stays improving renewed_both_settle.1, settled_stays improving renewed_both_settle.2⟩

/-- **A neighbourhood can install what no reward weight does.** Where the rest outruns the renewal,
restraint is settled at no weight, yet a local search whose neighbourhoods are empty rests at it;
one in which every candidate is a neighbour moves from it to the drawing law. -/
theorem outrun_neighbourhood_decides (w : Nat) :
    LocalSearch (fun _ _ => False) (reward 2 w) id ∧ id true = true ∧
      ¬ Settles (reward 2 w) true ∧
      ∀ next, LocalSearch (fun _ _ => True) (reward 2 w) next → next true = false :=
  ⟨⟨fun _ => .inl rfl, fun _ _ never => never.elim⟩, rfl, outrun_restraint_unsettled w,
   fun next search => match moved : next true with
    | false => rfl
    | true => absurd ((search.rests_iff_settles).mp moved) (outrun_restraint_unsettled w)⟩

end Commons

end Training

end Becoming
