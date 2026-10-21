/-- Across an enclosed step the enclosing family is, as far as can be refuted, widened to one
without repetition holding what is active before and after the step, balanced and dissipated on. -/
theorem Enclosed.around_census (balanced : v.Balanced M) (dissipative : v.Dissipative M)
    {alive : Nat → List w.Relatum} {t : Nat} (enclosed : v.Enclosed M t) :
    ¬¬ ∃ es, Distinct es ∧ (∀ c, c ∈ alive t → c ∈ es) ∧ (∀ c, c ∈ alive (t + 1) → c ∈ es) ∧
      v.BalancesOn M es t ∧ v.DissipatesOn M es t :=
  fun no => enclosed.around_not_not (alive t ++ alive (t + 1)) fun ⟨es, distinct, sub, closed⟩ =>
    no ⟨es, distinct, fun c mem => sub c (mem_append_of_left _ mem),
      fun c mem => sub c (mem_append_of_right _ mem), fun c _ => balanced t c,
      dissipative es t distinct closed⟩

/-- Across an enclosed step the census's total does not rise, as far as can be refuted. -/
theorem census_still {alive : Nat → List w.Relatum} (census : w.web.Census alive)
    (embodied : v.Embodied M) (balanced : v.Balanced M) (dissipative : v.Dissipative M) {t : Nat}
    (enclosed : v.Enclosed M t) :
    ¬¬ M.le (v.censusStock M alive (t + 1)) (v.censusStock M alive t) := fun no =>
  enclosed.around_census (alive := alive) balanced dissipative
    fun ⟨_, distinct, before, after, balances, dissipates⟩ =>
      stock_census census embodied distinct before fun ⟨down, _⟩ =>
        stock_census census embodied distinct after fun ⟨_, up⟩ =>
          no (M.le_trans up (M.le_trans (stock_still balances dissipates) down))

/-- Across an enclosed step at which a relatum active before or after it changes its level, the
census's total falls strictly. -/
theorem census_falls {alive : Nat → List w.Relatum} (census : w.web.Census alive)
    (embodied : v.Embodied M) (balanced : v.Balanced M) (dissipative : v.Dissipative M) {t : Nat}
    (enclosed : v.Enclosed M t) {x : w.Relatum} (member : x ∈ alive t ∨ x ∈ alive (t + 1))
    (changes : v.Rises M t x ∨ v.Falls M t x) :
    ¬ M.le (v.censusStock M alive t) (v.censusStock M alive (t + 1)) := fun le =>
  enclosed.around_census (alive := alive) balanced dissipative
    fun ⟨_, distinct, before, after, balances, dissipates⟩ =>
      stock_census census embodied distinct before fun ⟨up, _⟩ =>
        stock_census census embodied distinct after fun ⟨_, down⟩ =>
          change_lowers balances dissipates
            (match member with
              | .inl now => before x now
              | .inr next => after x next) changes
            (M.le_trans up (M.le_trans le down))

/-- **The rest theorem over any amounts, enclosed.** In a world in any amounts with a census of its
active relata, every relatum embodied, a balanced and dissipative flow and every step from `T` on
enclosed, where the census's total stops falling from `T` on, that the world rests from some step on
cannot be refuted. No premise on the amounts and no decision: at each step the enclosing family is
widened, as far as can be refuted, to hold what is active before and after it
(`InAmounts.Enclosed.around_census`), its total is the census's each way
(`InAmounts.stock_census`), and each arising or ceasing lowers it strictly
(`InAmounts.census_falls`). -/
theorem rests_unrefuted_enclosed_of_stops {alive : Nat → List w.Relatum} (census : w.web.Census alive)
    (embodied : v.Embodied M) (balanced : v.Balanced M) (dissipative : v.Dissipative M) {T : Nat}
    (enclosed : ∀ t, T ≤ t → v.Enclosed M t) (stops : M.FallsStop (v.censusStock M alive) T) :
    ¬ ¬ ∃ N, w.RestsFrom N :=
  World.rests_unrefuted_iff.mpr
  ⟨fun arising => stops fun N from_ none_ => arising N fun ⟨t, x, after, arises⟩ =>
      none_ ⟨t, after, census_falls census embodied balanced dissipative
        (enclosed t (Nat.le_trans from_ after)) (.inr (((census (t + 1)).2 x).mp arises.2))
        (.inl (rises_of_arises (fun _ y _ s => embodied s y) arises))⟩,
   fun ceasing => stops fun N from_ none_ => ceasing N fun ⟨t, x, after, ceases⟩ =>
      none_ ⟨t, after, census_falls census embodied balanced dissipative
        (enclosed t (Nat.le_trans from_ after)) (.inl (((census t).2 x).mp ceases.1))
        (.inr (falls_of_ceases embodied ceases))⟩⟩

/-- **The rest theorem over any amounts, read finitely, enclosed.** Where, besides, the census's
total is read off configurations a list holds from `T` on, it stops falling
(`Amounts.rests_unrefuted_of_finite_reading`), so the world rests from some step on, unrefuted. No
least loss, no Archimedean property and no decision. -/
theorem rests_unrefuted_enclosed {alive : Nat → List w.Relatum} (census : w.web.Census alive)
    (embodied : v.Embodied M) (balanced : v.Balanced M) (dissipative : v.Dissipative M) {T : Nat}
    (enclosed : ∀ t, T ≤ t → v.Enclosed M t) {S : Type} {g : Nat → S} {q : S → A} {l : List S}
    (held : ∀ t, T ≤ t → g t ∈ l) (reads : ∀ t, T ≤ t → v.stock M (alive t) t = q (g t)) :
    ¬ ¬ ∃ N, w.RestsFrom N :=
  rests_unrefuted_enclosed_of_stops census embodied balanced dissipative enclosed
    (Amounts.fallsStop_congr reads (Amounts.rests_unrefuted_of_finite_reading held fun t later no =>
      census_still census embodied balanced dissipative (enclosed t later) fun le =>
        no (Eq.subst (motive := fun x => M.le x (q (g t))) (reads (t + 1) (Nat.le_succ_of_le later))
          (Eq.subst (motive := fun x => M.le (v.stock M (alive (t + 1)) (t + 1)) x)
            (reads t later) le))))

/-- **Rest in amounts with no endless fall.** In amounts where no amount falls without end
(`Amounts.NoEndlessFall`: a least fall in Archimedean amounts gives it,
`Amounts.noEndlessFall_of_fallsAtLeast`), every world with a census of its active relata, all
embodied, a balanced and dissipative flow and every step from some step on enclosed rests from some
step on, unrefuted: the census's total does not rise (`InAmounts.census_still`). -/
theorem rests_unrefuted_enclosed_of_noEndlessFall (none_ : M.NoEndlessFall)
    {alive : Nat → List w.Relatum} (census : w.web.Census alive) (embodied : v.Embodied M)
    (balanced : v.Balanced M) (dissipative : v.Dissipative M) {T : Nat}
    (enclosed : ∀ t, T ≤ t → v.Enclosed M t) : ¬ ¬ ∃ N, w.RestsFrom N :=
  rests_unrefuted_enclosed_of_stops census embodied balanced dissipative enclosed
    (none_ _ T fun t later => census_still census embodied balanced dissipative (enclosed t later))

end InAmounts

/-! ## Whole numbers are the instance -/

/-- A world read in whole-number amounts: its own levels, takes and gives. -/
def wholeAmounts (w : World) : w.InAmounts Nat :=
  ⟨w.web.level, w.flow.take, w.flow.give⟩

variable {w : World}

/-- A world's balance is its balance in whole-number amounts. -/
theorem balanced_whole (balanced : w.Balanced) : w.wholeAmounts.Balanced Amounts.whole :=
  fun t c => Nat.le_of_eq ((congrArg (w.web.level (t + 1) c + ·) (Amounts.totalOf_whole _)).trans
    ((balanced t c).trans (congrArg (w.web.level t c + ·) (Amounts.totalOf_whole _)).symm))

/-- In whole numbers, a total that with its sign is within another and holds the other is
nothing. -/
theorem nothing_of_sign {G T : Nat} (within : G + sign T ≤ T) (back : T ≤ G) : T ≤ 0 :=
  match T, within, back with
  | 0, _, _ => Nat.le_refl 0
  | _ + 1, within, back => absurd (Nat.le_trans within back) (Nat.not_succ_le_self G)

/-- A world's dissipation is its dissipation in whole-number amounts: what gives back all it takes
takes nothing, since a whole number that takes something loses at least one. -/
theorem dissipative_whole (dissipative : w.Dissipative) :
    w.wholeAmounts.Dissipative Amounts.whole := fun ds t distinct closed f mem =>
  have closedAt : w.flow.ClosedAt ds t := fun f mem c outside =>
    ⟨Nat.le_antisymm (closed f mem c outside).1 (Nat.zero_le _),
     Nat.le_antisymm (closed f mem c outside).2 (Nat.zero_le _)⟩
  have within := dissipative ds t distinct closedAt f mem
  have takes := Amounts.totalOf_whole (a := w.flow.take t f) ds
  have gives := Amounts.totalOf_whole (a := w.flow.give t f) ds
  ⟨Eq.subst (motive := fun x => x ≤ Amounts.whole.totalOf ds (w.flow.take t f)) gives.symm
      (Eq.subst (motive := fun x => total ds (w.flow.give t f) ≤ x) takes.symm
        (Nat.le_trans (Nat.le_add_right _ _) within)),
   fun back => Eq.subst (motive := fun x => x ≤ 0) takes.symm
      (nothing_of_sign within
        (Eq.subst (motive := fun x => total ds (w.flow.take t f) ≤ x) gives
          (Eq.subst (motive := fun x => x ≤ Amounts.whole.totalOf ds (w.flow.give t f)) takes back)))⟩

/-- A world whose arising is embodied has it embodied in whole-number amounts. -/
theorem arisingEmbodied_whole (embodied : w.ArisingEmbodied) :
    w.wholeAmounts.ArisingEmbodied Amounts.whole := fun t x arises s =>
  (embodied t x arises s).trans ⟨fun pos le => Nat.not_le_of_gt pos le, Nat.gt_of_not_le⟩

/-- A world whose relata are embodied has them embodied in whole-number amounts. -/
theorem embodied_whole (embodied : w.Embodied) : w.wholeAmounts.Embodied Amounts.whole :=
  fun t x => (embodied x t).trans ⟨fun pos le => Nat.not_le_of_gt pos le, Nat.gt_of_not_le⟩

/-- A step a world's flow encloses is enclosed in whole-number amounts. -/
theorem enclosed_whole {t : Nat} (enclosed : w.flow.Enclosed t) :
    w.wholeAmounts.Enclosed Amounts.whole t :=
  match enclosed with
  | ⟨es, distinct, closed⟩ => ⟨es, distinct, fun f mem c outside =>
      ⟨Nat.le_of_eq (closed f mem c outside).1, Nat.le_of_eq (closed f mem c outside).2⟩⟩

/-- **The whole-number instance, finite.** A finite world whose flow balances and dissipates and
whose arising is embodied rests from some step on, unrefuted, with the premises of
`World.rests_unrefuted` and nothing more, by the law over any amounts: no whole number falls without
end (`Amounts.whole_noEndlessFall`). -/
theorem rests_unrefuted_whole (finite : w.Finite) (balanced : w.Balanced)
    (dissipative : w.Dissipative) (embodied : w.ArisingEmbodied) : ¬ ¬ ∃ N, w.RestsFrom N :=
  match finite with
  | ⟨all, distinct, every⟩ =>
    have balances : ∀ t, 0 ≤ t → w.wholeAmounts.BalancesOn Amounts.whole all t :=
      fun t _ c _ => balanced_whole balanced t c
    have dissipates : ∀ t, 0 ≤ t → w.wholeAmounts.DissipatesOn Amounts.whole all t := fun t _ =>
      dissipative_whole dissipative all t distinct fun _ _ c outside => absurd (every c) outside
    InAmounts.rests_unrefuted_of_stops (T := 0) (fun _ _ x _ => every x) balances dissipates
      (arisingEmbodied_whole embodied)
      (Amounts.whole_noEndlessFall _ 0 fun t later no =>
        no (InAmounts.stock_still (balances t later) (dissipates t later)))

/-- **The whole-number instance, enclosed.** A world with a census of its active relata, all
embodied, a balanced and dissipative flow and every step from `T` on enclosed rests from some step
on, unrefuted, with the premises of `World.rests_unrefuted_enclosed` and nothing more, by the law
over any amounts (`InAmounts.rests_unrefuted_enclosed_of_noEndlessFall`): no whole number falls
without end. -/
theorem rests_unrefuted_enclosed_whole (counted : w.Counted) (embodied : w.Embodied)
    (balanced : w.Balanced) (dissipative : w.Dissipative) {T : Nat}
    (enclosed : ∀ t, T ≤ t → w.flow.Enclosed t) : ¬ ¬ ∃ N, w.RestsFrom N :=
  match counted with
  | ⟨_, census⟩ =>
    InAmounts.rests_unrefuted_enclosed_of_noEndlessFall Amounts.whole_noEndlessFall census
      (embodied_whole embodied) (balanced_whole balanced) (dissipative_whole dissipative)
      fun t later => enclosed_whole (enclosed t later)

end World

/-! ## A standing passing along an endless fall: the premise is needed -/

namespace Pass

/-- Which relatum holds the standing at step `t`: `true` at even steps. -/
def even : Nat → Bool
  | 0 => true
  | t + 1 => !even t

/-- Active is holding. -/
def web : Web Bool Bool :=
  ⟨fun _ _ => 0, fun t x => x = even t, fun _ _ _ => False, fun _ _ _ => 0, fun _ _ _ => False⟩

/-- The holder takes part in each step. -/
def flow : Flow Bool Bool :=
  ⟨fun t => [even t], fun _ _ _ => 0, fun _ _ _ => 0⟩

/-- The world of two relata passing one standing. -/
def world : World :=
  World.of Bool flow web

/-- What is active at each step: the holder. -/
def alive (t : Nat) : List Bool :=
  [even t]

variable {A : Type} (M : Amounts A)

/-- The amount `s` where the relatum is the holder `h`, nothing elsewhere. -/
def at_ : Bool → Bool → A → A
  | true, true, s => s
  | true, false, _ => M.zero
  | false, true, _ => M.zero
  | false, false, s => s

/-- Along amounts `d`: the holder stands at `d t`, takes it all from itself, and gives `d (t + 1)`
to the other. -/
def amounts (d : Nat → A) : world.InAmounts A :=
  ⟨fun t x => at_ M (even t) x (d t),
   fun t f c => at_ M (even t) f (at_ M (even t) c (d t)),
   fun t f c => at_ M (even t) f (at_ M (!even t) c (d (t + 1)))⟩

variable {M} {d : Nat → A}

theorem at_self (h : Bool) (s : A) : at_ M h h s = s := by
  cases h <;> rfl

theorem at_other : ∀ {h x : Bool}, ¬ x = h → ∀ s : A, at_ M h x s = M.zero
  | true, true, other, _ => absurd rfl other
  | true, false, _, _ => rfl
  | false, true, _, _ => rfl
  | false, false, other, _ => absurd rfl other

theorem not_self (h : Bool) : ¬ (!h) = h := by
  cases h <;> exact fun same => nomatch same

/-- Whether a relatum is `p` is decided. -/
theorem decide_eq (p : Bool) : ∀ x : Bool, x = p ∨ ¬ x = p :=
  match p with
  | true => fun
    | true => .inl rfl
    | false => .inr fun same => nomatch same
  | false => fun
    | true => .inr fun same => nomatch same
    | false => .inl rfl

/-- Whether a relatum is in a list is decided. -/
theorem decide_mem (h : Bool) : ∀ ds : List Bool, h ∈ ds ∨ ¬ h ∈ ds
  | [] => .inr fun mem => nomatch mem
  | a :: ds => match decide_eq h a with
    | .inl same => .inl (Eq.subst (motive := fun z => h ∈ z :: ds) same.symm (.head ds))
    | .inr other => match decide_mem h ds with
      | .inl inside => .inl (.tail a inside)
      | .inr out => .inr fun mem => match mem_cons_cases mem with
        | .inl same => other same.symm
        | .inr inside => out inside

/-- Every relatum is in the pair. -/
theorem member : ∀ x : Bool, x ∈ [true, false]
  | true => .head _
  | false => .tail _ (.head _)

/-- The pair is listed without repetition. -/
theorem pair_distinct : Distinct [true, false] :=
  ⟨fun mem => match mem_cons_cases mem with
    | .inl same => (nomatch same)
    | .inr rest => (nomatch rest), ⟨(fun mem => nomatch mem), trivial⟩⟩

/-- An amount falling strictly at a step is above nothing there. -/
theorem positive (falls : ∀ t, ¬ M.le (d t) (d (t + 1))) (t : Nat) : ¬ M.le (d t) M.zero :=
  fun le => falls t (M.le_trans le (M.zero_le _))

theorem stands_iff (h x : Bool) {s : A} (positive : ¬ M.le s M.zero) :
    x = h ↔ ¬ M.le (at_ M h x s) M.zero := by
  cases h <;> cases x
  · exact ⟨fun _ => positive, fun _ => rfl⟩
  · exact ⟨(fun same => nomatch same), fun no => absurd (M.le_refl _) no⟩
  · exact ⟨(fun same => nomatch same), fun no => absurd (M.le_refl _) no⟩
  · exact ⟨fun _ => positive, fun _ => rfl⟩

/-- The holder is the one taking part. -/
theorem present_holder {t : Nat} {f : Bool} (mem : f ∈ world.flow.present t) : f = even t :=
  have held : f ∈ [even t] := mem
  match held with
  | .head _ => rfl

theorem take_of_present {t : Nat} {f : Bool} (mem : f ∈ world.flow.present t) (c : Bool) :
    (amounts M d).take t f c = at_ M (even t) c (d t) := by
  show at_ M (even t) f (at_ M (even t) c (d t)) = _
  rw [present_holder mem, at_self]

theorem give_of_present {t : Nat} {f : Bool} (mem : f ∈ world.flow.present t) (c : Bool) :
    (amounts M d).give t f c = at_ M (!even t) c (d (t + 1)) := by
  show at_ M (even t) f (at_ M (!even t) c (d (t + 1))) = _
  rw [present_holder mem, at_self]

/-- A census of what is active: the holder. -/
theorem census : world.web.Census alive := fun _ =>
  ⟨⟨(fun mem => nomatch mem), trivial⟩, fun x =>
    ⟨fun same => Eq.subst (motive := fun z => x ∈ [z]) same (.head []), fun mem =>
      match mem_cons_cases mem with
      | .inl same => same
      | .inr rest => nomatch rest⟩⟩

/-- Every relatum is embodied: active exactly where its level is not within nothing. -/
theorem embodied (falls : ∀ t, ¬ M.le (d t) (d (t + 1))) : (amounts M d).Embodied M :=
  fun t x => stands_iff (even t) x (positive falls t)

/-- The flow balances at every step: what one relatum loses the other gains, with the loss. -/
theorem balanced : (amounts M d).Balanced M := fun t c =>
  Amounts.le_of_eq (by
    show M.add (at_ M (!even t) c (d (t + 1)))
        (M.add (at_ M (even t) (even t) (at_ M (even t) c (d t))) M.zero) =
      M.add (at_ M (even t) c (d t))
        (M.add (at_ M (even t) (even t) (at_ M (!even t) c (d (t + 1)))) M.zero)
    rw [at_self, at_self, Amounts.add_zero, Amounts.add_zero, M.add_comm])

/-- The flow dissipates: every family without repetition closed across a step holds the holder and
the other, so the holder takes `d t` from it and gives back `d (t + 1)`, strictly less. -/
theorem dissipative (still : ∀ t, M.le (d (t + 1)) (d t)) (falls : ∀ t, ¬ M.le (d t) (d (t + 1))) :
    (amounts M d).Dissipative M := fun ds t distinct closed f mem =>
  have holder : even t ∈ ds := match decide_mem (even t) ds with
    | .inl inside => inside
    | .inr out => absurd (Eq.subst (motive := fun x => M.le x M.zero)
        ((take_of_present mem (even t)).trans (at_self _ _)) (closed f mem (even t) out).1)
        (positive falls t)
  have other : (!even t) ∈ ds := match decide_mem (!even t) ds with
    | .inl inside => inside
    | .inr out => absurd (Eq.subst (motive := fun x => M.le x M.zero)
        ((give_of_present mem (!even t)).trans (at_self _ _)) (closed f mem (!even t) out).2)
        (positive falls (t + 1))
  have takes : M.totalOf ds ((amounts M d).take t f) = d t :=
    (Amounts.totalOf_congr fun c _ => take_of_present mem c).trans
      ((Amounts.totalOf_single (decide_eq (even t)) (fun _ away => at_other away _) distinct
        holder).trans (at_self _ _))
  have gives : M.totalOf ds ((amounts M d).give t f) = d (t + 1) :=
    (Amounts.totalOf_congr fun c _ => give_of_present mem c).trans
      ((Amounts.totalOf_single (decide_eq (!even t)) (fun _ away => at_other away _) distinct
        other).trans (at_self _ _))
  ⟨Eq.subst (motive := fun x => M.le x (M.totalOf ds ((amounts M d).take t f))) gives.symm
      (Eq.subst (motive := fun x => M.le (d (t + 1)) x) takes.symm (still t)),
   fun back => absurd
      (Eq.subst (motive := fun x => M.le x (d (t + 1))) takes
        (Eq.subst (motive := fun x => M.le (M.totalOf ds ((amounts M d).take t f)) x) gives back))
      (falls t)⟩

/-- The pair is closed across every step. -/
theorem closed (t : Nat) : (amounts M d).ClosedAt M [true, false] t :=
  fun _ _ c out => absurd (member c) out

/-- Every step is enclosed by the pair. -/
theorem enclosed (t : Nat) : (amounts M d).Enclosed M t :=
  ⟨[true, false], pair_distinct, closed t⟩

/-- At every step one relatum arises and the other ceases. -/
theorem arises (t : Nat) : world.web.Arises t (!even t) :=
  ⟨not_self (even t), rfl⟩

theorem ceases (t : Nat) : world.web.Ceases t (even t) :=
  ⟨rfl, fun same => not_self (even t) same.symm⟩

/-- **The world rests from no step on**: one relatum arises and the other ceases at every step. -/
theorem never_rests : ∀ N, ¬ world.RestsFrom N :=
  fun N quiet => (quiet N (Nat.le_refl N) (!even N)).1 (arises N)

/-- **An endless fall keeps a world from rest.** Along any amount `d` falling strictly at every
step, in any amounts, the standing passing between two relata meets every premise of the enclosed
rest theorem over any amounts but its one, that the census's total stops falling: a census of the
active relata, every relatum embodied, a balanced and dissipative flow, every step enclosed; and the
world rests from no step on. -/
theorem endless_keeps_from_rest (still : ∀ t, M.le (d (t + 1)) (d t))
    (falls : ∀ t, ¬ M.le (d t) (d (t + 1))) :
    world.web.Census alive ∧ (amounts M d).Embodied M ∧ (amounts M d).Balanced M ∧
      (amounts M d).Dissipative M ∧ (∀ t, (amounts M d).Enclosed M t) ∧
      ∀ N, ¬ world.RestsFrom N :=
  ⟨census, embodied falls, balanced, dissipative still falls, enclosed, never_rests⟩

/-- **No list holds the levels of an endless fall**, by the rest theorem over any amounts read
finitely: a list holding them would bring the world to rest. Its falls that never stop and the
unbounded count of its level functions are one fact read twice, as for the halving stock
(`Halving.stock_unlisted`). -/
theorem levels_unlisted (still : ∀ t, M.le (d (t + 1)) (d t))
    (falls : ∀ t, ¬ M.le (d t) (d (t + 1))) :
    ¬ ∃ ls : List (Bool → A), ∀ t, (amounts M d).level t ∈ ls :=
  fun ⟨_, held⟩ =>
    World.InAmounts.rests_unrefuted_reading (M := M) (v := amounts M d) (T := 0)
      (ds := [true, false]) (g := (amounts M d).level) (read := fun lv => lv)
      (fun _ _ x _ => member x) (fun t _ c _ => balanced t c)
      (fun t _ => dissipative still falls _ t pair_distinct (closed t))
      (fun _ x _ s => (embodied falls) s x) (fun t _ => held t) (fun _ _ _ _ => rfl)
      fun ⟨N, quiet⟩ => never_rests N quiet

end Pass

/-! ## Rest over all worlds in given amounts -/

namespace Amounts

variable {A : Type}

/-- Every world in amounts `M` with a census of its active relata, all embodied, a balanced and
dissipative flow and every step from some step on enclosed rests from some step on, unrefuted. -/
def WorldsRest (M : Amounts A) : Prop :=
  ∀ (w : World) (v : w.InAmounts A) (alive : Nat → List w.Relatum) (T : Nat), w.web.Census alive →
    v.Embodied M → v.Balanced M → v.Dissipative M → (∀ t, T ≤ t → v.Enclosed M t) →
    ¬ ¬ ∃ N, w.RestsFrom N

variable {M : Amounts A}

/-- **Where no amount falls without end, every world rests**
(`World.InAmounts.rests_unrefuted_enclosed_of_noEndlessFall`). -/
theorem worldsRest_of_noEndlessFall (none_ : M.NoEndlessFall) : M.WorldsRest :=
  fun _ _ _ _ census embodied balanced dissipative enclosed =>
    World.InAmounts.rests_unrefuted_enclosed_of_noEndlessFall none_ census embodied balanced
      dissipative enclosed

/-- **Where every world rests, no amount falls strictly at every step**: along such an amount a
standing passing between two relata never rests (`Pass.endless_keeps_from_rest`). So rest over
every world lies between no endless fall and no fall at every step, which coincide wherever the
steps at which an amount falls can be chosen. -/
theorem not_endlessFall_of_worldsRest (rest : M.WorldsRest) : ¬ M.EndlessFall :=
  fun ⟨d, falls⟩ =>
    match Pass.endless_keeps_from_rest (d := d) (fun t => (falls t).1) (fun t => (falls t).2) with
    | ⟨census, embodied, balanced, dissipative, enclosed, never⟩ =>
      rest Pass.world _ Pass.alive 0 census embodied balanced dissipative (fun t _ => enclosed t)
        fun ⟨N, quiet⟩ => never N quiet

/-- Every world in whole-number amounts rests. -/
theorem whole_worldsRest : Amounts.whole.WorldsRest :=
  worldsRest_of_noEndlessFall whole_noEndlessFall

end Amounts

/-- **Without a least fall, some world never rests.** Dyadic amounts are Archimedean, no amount above
nothing is within every strict fall, and some world in them never rests. -/
theorem Halving.worlds_need_not_rest :
    Dyadic.amounts.Archimedean ∧
      (∀ ε, ¬ Dyadic.amounts.le ε Dyadic.amounts.zero → ¬ Dyadic.amounts.FallsAtLeast ε) ∧
      ¬ Dyadic.amounts.WorldsRest :=
  ⟨Dyadic.archimedean, Halving.no_least_fall,
   fun rest => Amounts.not_endlessFall_of_worldsRest rest Halving.endless⟩

/-- **Without the Archimedean property, some world never rests.** In layered amounts every strict
fall is by at least a fine unit above nothing, the amounts are not Archimedean, and some world in
them never rests. -/
theorem Layered.worlds_need_not_rest :
    Layered.amounts.FallsAtLeast Layered.least ∧ ¬ Layered.amounts.le Layered.least Layered.amounts.zero ∧
      ¬ Layered.amounts.Archimedean ∧ ¬ Layered.amounts.WorldsRest :=
  ⟨Layered.fallsAtLeast, Layered.least_positive, Layered.not_archimedean,
   fun rest => Amounts.not_endlessFall_of_worldsRest rest Layered.endless⟩

end Becoming
