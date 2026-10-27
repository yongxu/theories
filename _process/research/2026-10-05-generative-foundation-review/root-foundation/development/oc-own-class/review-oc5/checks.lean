/-! ## The reviewer's checks -/

section Checks

variable {α : Type u}

/-- **(C1) The reach lets one's line end only where the net does.** Where everything downstream of `m` lies on its
line under a class, no occurrence on that line (`m` included) ends while it still conditions something. -/
theorem reach_ends_where_net_ends {R E : «际» α} (hE : «类» E) {m y : α}
    (reach : ∀ t, «及» R m t → «所及» R E m t) (onLine : «所及» R E m y) (ends : «亡» R E y) :
    ∀ w, ¬ R y w := fun w step =>
  have all := («后皆续当且仅当后皆同类» hE).mp reach
  have my : E m y := match onLine with
    | .inl e => e ▸ hE.refl m
    | .inr line => «线内同类» hE line
  have down : «及» R m w := match onLine with
    | .inl e => by cases e; exact .one step
    | .inr line => «及之传递» («及之单调» (R := «续» R E) (S := R) (fun _ _ c => c.1) m y line) (.one step)
  ends ⟨w, step, hE.trans (hE.symm my) (all w down)⟩

/-- **(C2) A line that ends while its last stage still conditions something has no reach.** -/
theorem ending_line_no_reach {R E : «际» α} (hE : «类» E) {m y : α}
    (line : «相续» R E m y) (ends : «亡» R E y) (goes : ∃ w, R y w) :
    ¬ ∀ t, «及» R m t → «所及» R E m t := fun reach =>
  match goes with
  | ⟨w, hw⟩ => reach_ends_where_net_ends hE reach (.inr line) ends w hw

/-- **(C6) Given P2, P4 and acting, the class holds the effects of every occurrence alike to the member.** -/
theorem all_alike_held {R E : «际» α} (hE : «类» E) {m : α} (atClass : «本类至终有常» R E m)
    (goes : ∃ w, R m w) (held : «所缘同于» R E m) : ∀ u, E m u → «所缘同于» R E u :=
  fun _ mu _ step =>
    hE.trans (hE.symm mu) (hE.symm («本类常闭则所缘同类» hE atClass goes held (hE.symm mu) step))

/-- **(C7) Conversely, where each alike occurrence decides whether it conditions anything, the holding of the
effects of every occurrence alike to the member gives P2 and P4.** -/
theorem held_all_alike_gives_condition {R E : «际» α} (hE : «类» E) {m : α}
    (decided : ∀ u, E m u → (∃ w, R u w) ∨ ∀ w, ¬ R u w)
    (all : ∀ u, E m u → «所缘同于» R E u) : «本类至终有常» R E m ∧ «所缘同于» R E m :=
  ⟨fun u u' mu mu' v step => match decided u' mu' with
     | .inl ⟨w, hw⟩ => .inl ⟨w, hw, hE.trans (hE.symm (all u mu v step))
         (hE.trans (hE.symm mu) (hE.trans mu' (all u' mu' w hw)))⟩
     | .inr stops => .inr stops,
   all m (hE.refl m)⟩

/-- **(C8) The chapter's "of each kind that one leaves, and nothing of a kind one does not leave".** Where the member
acts and the condition holds at its class: every alike occurrence that conditions anything conditions something of
the kind of each of the member's leaving effects, itself leaving; and whatever an alike occurrence conditions that
leaves the class is of the kind of some leaving effect of the member. -/
theorem leaves_each_kind_one_leaves {R E : «际» α} (hE : «类» E) {m : α} (goes : ∃ w, R m w)
    (atClass : «本类至终有常» R E m) :
    (∀ u w, E m u → R m w → ¬ E m w → (∃ z, R u z) → ∃ v, R u v ∧ E w v ∧ ¬ E m v) ∧
      (∀ u v, E m u → R u v → ¬ E m v → ∃ w, R m w ∧ E v w ∧ ¬ E m w) :=
  match («本类常当且仅当与己相随» hE goes).mp atClass with
  | ⟨toSelf, fromSelf⟩ =>
    ⟨fun u w mu hw out acts => match fromSelf u w mu hw with
       | .inl ⟨v, hv, wv⟩ => ⟨v, hv, wv, fun mv => out (hE.trans mv (hE.symm wv))⟩
       | .inr stops => match acts with
         | ⟨z, hz⟩ => absurd hz (stops z),
     fun u v mu hv out => match toSelf u v mu hv with
       | ⟨w, hw, vw⟩ => ⟨w, hw, vw, fun mw => out (hE.trans mw (hE.symm vw))⟩⟩

/-- **(C11) Where the member acts, P2 with P4 is exactly that the class holds the effects of every occurrence alike to
the member, each of which settles whether it conditions anything.** The second conjunct is what the pure core needs
for the backward direction, and P2 itself gives it where the member acts. -/
theorem p2p4_iff_all_held {R E : «际» α} (hE : «类» E) {m : α} (goes : ∃ w, R m w) :
    («本类至终有常» R E m ∧ «所缘同于» R E m) ↔
      (∀ u, E m u → «所缘同于» R E u) ∧ (∀ u, E m u → (∃ w, R u w) ∨ ∀ w, ¬ R u w) :=
  ⟨fun ⟨atClass, held⟩ =>
     ⟨all_alike_held hE atClass goes held,
      fun u mu => match goes with
        | ⟨w, hw⟩ => match atClass m u (hE.refl m) mu w hw with
          | .inl ⟨v, hv, _⟩ => .inl ⟨v, hv⟩
          | .inr stops => .inr stops⟩,
   fun ⟨all, decided⟩ => held_all_alike_gives_condition hE decided all⟩

/-- **(C10) The proposed law, as one declaration (亡而网续则后不皆续).** Where a line from a member ends while it
still conditions something, not everything downstream of the member lies on its line; no regularity is assumed. -/
theorem «亡而网续则后不皆续» {R E : «际» α} (hE : «类» E) {m y : α} (line : «相续» R E m y)
    (ends : «亡» R E y) (goes : ∃ w, R y w) : ¬ ∀ t, «及» R m t → «所及» R E m t := fun reach =>
  match goes with
  | ⟨w, hw⟩ => ends ⟨w, hw, hE.trans (hE.symm («线内同类» hE line))
      ((«后皆续当且仅当后皆同类» hE).mp reach w
        («及之传递» («及之单调» (R := «续» R E) (S := R) (fun _ _ c => c.1) m y line) (.one hw)))⟩

/-- **(C12) C11 as one declaration, for landing.** Where the member acts, the condition at its class with the holding
of its effects is exactly that the class holds the effects of every occurrence alike to it, each of which settles
whether it conditions anything. -/
theorem «本类常闭当且仅当同类皆闭» {R E : «际» α} (hE : «类» E) {m : α} (goes : ∃ w, R m w) :
    («本类至终有常» R E m ∧ «所缘同于» R E m) ↔
      (∀ u, E m u → «所缘同于» R E u) ∧ (∀ u, E m u → (∃ w, R u w) ∨ ∀ w, ¬ R u w) :=
  ⟨fun ⟨atClass, held⟩ =>
     ⟨fun _ mu _ step =>
        hE.trans (hE.symm mu) (hE.symm («本类常闭则所缘同类» hE atClass goes held (hE.symm mu) step)),
      fun u mu => match goes with
        | ⟨w, hw⟩ => match atClass m u (hE.refl m) mu w hw with
          | .inl ⟨v, hv, _⟩ => .inl ⟨v, hv⟩
          | .inr stops => .inr stops⟩,
   fun ⟨all, decided⟩ =>
     ⟨fun u u' mu mu' v step => match decided u' mu' with
        | .inl ⟨w, hw⟩ => .inl ⟨w, hw, hE.trans (hE.symm (all u mu v step))
            (hE.trans (hE.symm mu) (hE.trans mu' (all u' mu' w hw)))⟩
        | .inr stops => .inr stops,
      all m (hE.refl m)⟩⟩

/-- **(C14) The path's need is the holding of effects at the member and along its own line (后皆续当且仅当自与线皆闭).**
Everything downstream of `m` lies on its line under a class exactly where the class holds the effects of `m` and of
every occurrence on its line from `m`; no regularity is assumed. -/
theorem «后皆续当且仅当自与线皆闭» {R E : «际» α} (hE : «类» E) {m : α} :
    (∀ t, «及» R m t → «所及» R E m t) ↔
      «所缘同于» R E m ∧ ∀ y, «相续» R E m y → «所缘同于» R E y :=
  ⟨fun reach =>
     ⟨«后皆续则所缘同于» hE reach,
      fun y line v step => hE.trans (hE.symm («线内同类» hE line))
        ((«后皆续当且仅当后皆同类» hE).mp reach v
          («及之传递» («及之单调» (R := «续» R E) (S := R) (fun _ _ c => c.1) m y line) (.one step)))⟩,
   fun ⟨held, along⟩ =>
     have next : ∀ {a b : α}, «所及» R E m a → R a b → «相续» R E m b := fun onLine step =>
       match onLine with
       | .inl e => by cases e; exact .one ⟨step, held _ step⟩
       | .inr line => «及之传递» line (.one ⟨step, along _ line _ step⟩)
     have go : ∀ {a t : α}, «及» R a t → «所及» R E m a → «相续» R E m t := fun d => by
       induction d with
       | one step => exact fun onLine => next onLine step
       | more step _ ih => exact fun onLine => ih (.inr (next onLine step))
     fun _ down => .inr (go down (.inl rfl))⟩

end Checks

/-- **(C3) The organism's class of `FiniteFamilies` has no reach from the first birth**: its line ends at old age,
which still conditions the second member's birth. -/
theorem organism_no_reach :
    ¬ ∀ t, «及» FiniteFamilies.step (false, 0) t →
      «所及» FiniteFamilies.step FiniteFamilies.member (false, 0) t :=
  ending_line_no_reach (m := (false, 0)) (y := (false, 1)) FiniteFamilies.member_class
    («及».one ⟨⟨rfl, rfl, Nat.lt_succ_of_le (Nat.le_succ_of_le (Nat.le_succ 0))⟩, rfl, rfl⟩)
    (fun ⟨z, ⟨_, e2, _⟩, ⟨_, d⟩⟩ => by
      have hz : z.2 = 2 := e2
      rw [hz] at d
      exact Bool.noConfusion d)
    ⟨(false, 2), rfl, rfl, Nat.lt_succ_of_le (Nat.le_succ_of_le (Nat.le_refl 1))⟩

namespace FiniteFamilies

/-- **(C13) The proposed witness, through the proposed law**: the organism's class does not take in everything
downstream of the first birth; its line ends at old age, which still conditions the second member's birth. -/
theorem member_no_reach : ¬ ∀ t, «及» step (false, 0) t → «所及» step member (false, 0) t :=
  «亡而网续则后不皆续» (m := (false, 0)) (y := (false, 1)) member_class
    («及».one ⟨⟨rfl, rfl, Nat.lt_succ_of_le (Nat.le_succ_of_le (Nat.le_succ 0))⟩, rfl, rfl⟩)
    (fun ⟨z, ⟨_, e2, _⟩, ⟨_, d⟩⟩ => by
      have hz : z.2 = 2 := e2
      rw [hz] at d
      exact Bool.noConfusion d)
    ⟨(false, 2), rfl, rfl, Nat.lt_succ_of_le (Nat.le_succ_of_le (Nat.le_refl 1))⟩

end FiniteFamilies

/-- **(C4) P2 and the path's need are incomparable.** In `FiniteWake` the condition holds at the member's class,
the member acts, and the reach fails (the member's effects are not held); in `OtherLeaves` the reach holds and the
condition fails. -/
theorem p2_and_need_incomparable :
    ((∃ w, FiniteWake.step FiniteWake.Occ.m w) ∧
      «本类至终有常» FiniteWake.step FiniteWake.own FiniteWake.Occ.m ∧
      ¬ ∀ t, «及» FiniteWake.step FiniteWake.Occ.m t → «所及» FiniteWake.step FiniteWake.own FiniteWake.Occ.m t) ∧
    ((∀ t, «及» OtherLeaves.step OtherLeaves.Occ.m t →
        «所及» OtherLeaves.step («二分» OtherLeaves.inClass) OtherLeaves.Occ.m t) ∧
      ¬ «本类至终有常» OtherLeaves.step («二分» OtherLeaves.inClass) OtherLeaves.Occ.m) :=
  ⟨⟨⟨FiniteWake.Occ.i, trivial⟩,
    «至终有常则本类至终有常» FiniteWake.own_class FiniteWake.constant_to_end FiniteWake.Occ.m,
    fun reach => FiniteWake.not_held («后皆续则所缘同于» FiniteWake.own_class reach)⟩,
   ⟨OtherLeaves.reach_without_condition.2.2, OtherLeaves.reach_without_condition.1⟩⟩

/-! (C5) Record law 7 drops "where the member conditions something": a member that conditions nothing, an
occurrence `u` alike to it conditioning `x` outside the class. The condition holds at the member's class, the class
holds the member's effects (vacuously), and it does not hold the effects of `u`, an alike occurrence. -/
namespace Idle

inductive Occ | m | u | x

def step : «际» Occ
  | .m, .m => False
  | .m, .u => False
  | .m, .x => False
  | .u, .m => False
  | .u, .u => False
  | .u, .x => True
  | .x, .m => False
  | .x, .u => False
  | .x, .x => False

def inClass : Occ → Bool
  | .m => true
  | .u => true
  | .x => false

theorem counter :
    (∀ w, ¬ step .m w) ∧ «本类至终有常» step («二分» inClass) .m ∧ «所缘同于» step («二分» inClass) .m ∧
      «二分» inClass .m .u ∧ ¬ «所缘同于» step («二分» inClass) .u :=
  ⟨fun w h => by cases w <;> exact h,
   fun a b ma mb v r => by
     cases a <;> cases b <;> cases v <;>
       first
       | exact False.elim r
       | exact Bool.noConfusion ma
       | exact Bool.noConfusion mb
       | exact .inl ⟨.x, trivial, rfl⟩
       | exact .inr (fun w h => by cases w <;> exact h),
   fun v h => by cases v <;> exact False.elim h,
   rfl,
   fun held => Bool.noConfusion (held .x trivial)⟩

end Idle

/-- **(C9) In `OtherLeaves` the other alike occurrence is off the member's line**: nothing downstream of `m` is `c`.
The texts say "off its line"; `other_not_held` does not state it. -/
theorem other_off_line : ¬ «及» OtherLeaves.step OtherLeaves.Occ.m OtherLeaves.Occ.c := fun down =>
  Bool.noConfusion (OtherLeaves.reached_after down rfl)

#print axioms «后皆同类则后皆续»
#print axioms «后皆续当且仅当后皆同类»
#print axioms «后皆续则所缘同于»
#print axioms «后皆同类当且仅当自与后皆闭»
#print axioms «本类常闭则后皆续»
#print axioms «本类常当且仅当与己相随»
#print axioms «外分唯系己出之同»
#print axioms «闭则外分无关»
#print axioms OtherLeaves.reach_without_condition
#print axioms OtherLeaves.other_not_held
#print axioms reach_ends_where_net_ends
#print axioms ending_line_no_reach
#print axioms organism_no_reach
#print axioms p2_and_need_incomparable
#print axioms Idle.counter
#print axioms all_alike_held
#print axioms held_all_alike_gives_condition
#print axioms leaves_each_kind_one_leaves
#print axioms other_off_line
#print axioms «亡而网续则后不皆续»
#print axioms p2p4_iff_all_held
#print axioms «本类常闭当且仅当同类皆闭»
#print axioms FiniteFamilies.member_no_reach
#print axioms «后皆续当且仅当自与线皆闭»
