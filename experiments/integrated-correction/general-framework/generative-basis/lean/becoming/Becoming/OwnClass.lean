import Becoming.GrammarPath
import Becoming.GrammarScope
import Becoming.Centers
import Becoming.FlowCenters
import Becoming.Identity

/-!
# A center's own class: what the net fixes of it (本类之定)

Chapter 7 §4.6 reads the self whose continuation acting presupposes as a line under a class on the
root, and asks two things of that class at oneself: P2, constancy up to the net's end at one's own
class (`«本类至终有常»`), and P4, that the class hold one's effects (`«所缘同于»`). Chapter 7's open
line on de se asks which class a center's own line runs under, and whether the net fixes it. This
module answers it for the classes meeting P2 and P4, and reads the class on a flow.

* **P2 and P4 together are one closure (本类常闭则类闭).** At a member that conditions something, P2
  and P4 hold exactly where the member's block is closed under the net: whatever anything alike to
  the member conditions is alike to it (`«本类常闭则类闭»`, `«类闭则本类常闭»`,
  `«本类常闭当且仅当类闭»`). The converse direction asks that it be decided, of each occurrence alike
  to the member, whether it conditions something, since P2 is a disjunction; no classical principle
  is used.
* **They are closed under meets (本类常闭之交).** At a member that conditions something, the meet of
  two classes meeting P2 and P4 meets them (`«本类常闭之交»`), and so does the meet of any family of
  them that has a member (`«本类常闭之遍交»`). The ∀∃ form of P2 does not break this, since under P4
  every effect of an alike occurrence lies in the block, and any one of them is alike to any other.
  The family is not closed under joins: in `JoinBreaks` two classes meeting P2 and P4 at a member that
  conditions something have a least common coarsening that does not.
* **The least class is the member with all that follows it (后类最细).** The class `«后类» R m` holds
  `m` alike with everything within its closure under the net and nothing else with anything; it is
  defined from the net and the member alone. Every class meeting P2 and P4 at `m` contains it
  (`«本类常闭则含后类»`), with no premise that `m` conditions anything, and wherever some class meets
  P2 and P4 at `m`, it does too (`«后类本类常闭»`); so it is the least such class (`«后类最细»`). It
  holds `m`'s effects with no premise, and meets P2 wherever it is decided, of each occurrence downstream
  of `m`, whether it conditions something (`«判则后类本类常闭»`), and with no decision wherever everything
  within `m`'s closure has `m` within its own, as at an element returning along the net in
  `Becoming.FlowCenters`'s sense (`«返则后类本类常闭»`, `ReturnsAlong.downstreamClass_regular`).
* **Every class meeting P2 and P4 reaches what the one reaches (本类常闭则所及即一之所及).** From a
  member, a line under any class meeting P2 and P4 there reaches exactly what a line under the one
  reaches: the member and everything downstream of it (`«本类常闭则所及即一之所及»`). Given P2, P4 is
  equivalent to that (`«本类常则闭当且仅当所及即一之所及»`). The least class reaches it with no premise
  (`«后类之所及即一之所及»`); P2 is what makes every class holding one's effects reach the same. With each center under a class of its own
  meeting P2 and P4 at it, the per-center condition along the net is the condition at the one
  (`«各本类常闭则续无外即一之续无外»`), so along a net with no cycle it holds only where every center is
  one and the same occurrence (`«各本类常闭续无外则同一中心»`).
* **P2 alone fixes only the moment (静最细).** The identity meets P2 at every occurrence and is the least
  class that does (`«静之本类至终有常»`, `«静最细»`, near-definitional), and fails P4 wherever the occurrence conditions something other than itself
  (`«静不闭»`). P2 alone is not closed under meets: in `MeetBreaks`, two classes meet P2 at a member
  that conditions something and their meet does not (`MeetBreaks.meet_not_constant_at`). Where the
  member conditions nothing, P4 asks nothing and the meet of two classes meeting both can fail P2
  (`MeetBreaks.idle_both`, `MeetBreaks.idle_meet_not_constant`); the least class there is still
  `«后类»`, the identity on the member's block.
* **The class read on a flow (CouplingClass).** On a flow read as a net along affecting, take the class
  of a formation `f` to be "within `f`'s coupling closure or not" (`Flow.CouplingClass`). P4 then holds
  exactly where everything `f` affects lies within its coupling closure
  (`Flow.couplingClass_held_iff`), and with coupling by threshold only, exactly where whatever `f`
  affects can affect it back at some remove (`Flow.couplingClass_held_iff_back`). Everything
  downstream of `f` lies on its line under this class exactly where everything within its reach lies
  within its coupling closure (`Flow.couplingClass_reach_iff`): wherever its acts return
  (`Flow.ReachReturns.couplingClass_reach`), and with coupling by threshold only, exactly there
  (`Flow.couplingClass_reach_iff_returns`). The line itself stays within the coupling closure
  (`Flow.couplingClass_line_within`), and with coupling by threshold only it reaches exactly `f`'s
  loop, what `f` affects that can affect it back (`Flow.couplingClass_line_iff_loop`). These are
  near-definitional: the class holds by construction what it is drawn on, and the laws say that a line
  under a class stays in its block (`«线内同类»`). On the root the same reading, the class of what can
  reach a member, has its line reach exactly the member's loop (`«返之所及即环»`), only the member itself
  along a net with no cycle (`«无环则返之所及唯己»`), and the reach can hold
  while P2 fails at it (`ReturnsNotRegular`): at a formation that affects something, P2 and P4 together
  ask that its coupling closure be closed under affecting (`Flow.couplingClass_closed`), more than that
  acts return.

Read together [a reading, not a theorem]: wherever a center's own class meets P2 and P4, the net fixes
the least such class and the reach of every such class, everything downstream of the center; which of
those classes is one's own it does not fix, and nothing the line reaches turns on it. Nor does the net
fix whether one's own class meets P4: at every occurrence that conditions something other than itself
the identity meets P2 and not P4, while `«后类»` holds its effects and meets P2 wherever any class meets
both or it is decided as above. So, granted P2, the de se question on §4.6's path is P4 and nothing
more, the crux of §4.7. Which class is one's own, and whether acting presupposes a class meeting P4,
are not settled here.

Every declaration has an empty axiom report.
-/

namespace Becoming

universe u v

section OwnClass

variable {α : Type u}

/-! ## P2 and P4 together: the member's block closed under the net -/

/-- **Under P2 and P4 at a member that conditions something, its block is closed under the net
(本类常闭则类闭).** Whatever anything alike to the member conditions is alike to it. -/
theorem «本类常闭则类闭» {R E : «际» α} (hE : «类» E) {m : α} (atClass : «本类至终有常» R E m)
    (goes : ∃ w, R m w) (held : «所缘同于» R E m) : «闭» R (E m) :=
  fun _ _ mu step => hE.symm («本类常闭则所缘同类» hE atClass goes held (hE.symm mu) step)

/-- **Where the member's block is closed under the net, P4 holds at the member, and P2 wherever it is
decided, of each occurrence alike to the member, whether it conditions something (类闭则本类常闭).** -/
theorem «类闭则本类常闭» {R E : «际» α} (hE : «类» E) {m : α} (closed : «闭» R (E m))
    (decided : ∀ u, E m u → (∃ w, R u w) ∨ ∀ w, ¬ R u w) :
    «本类至终有常» R E m ∧ «所缘同于» R E m :=
  ⟨fun u u' mu mu' v step => match decided u' mu' with
     | .inl ⟨w, hw⟩ => .inl ⟨w, hw, hE.trans (hE.symm (closed u v mu step)) (closed u' w mu' hw)⟩
     | .inr stops => .inr stops,
   fun v step => closed m v (hE.refl m) step⟩

/-- **At a member that conditions something, P2 and P4 hold exactly where its block is closed under the
net (本类常闭当且仅当类闭)**, where it is decided of each occurrence alike to it whether it conditions
something. -/
theorem «本类常闭当且仅当类闭» {R E : «际» α} (hE : «类» E) {m : α} (goes : ∃ w, R m w)
    (decided : ∀ u, E m u → (∃ w, R u w) ∨ ∀ w, ¬ R u w) :
    «本类至终有常» R E m ∧ «所缘同于» R E m ↔ «闭» R (E m) :=
  ⟨fun ⟨atClass, held⟩ => «本类常闭则类闭» hE atClass goes held,
   fun closed => «类闭则本类常闭» hE closed decided⟩

/-! ## Closed under meets -/

/-- The meet of two classes is a class. -/
theorem «合为类» {E F : «际» α} (hE : «类» E) (hF : «类» F) : «类» («合» E F) :=
  ⟨fun x => ⟨hE.refl x, hF.refl x⟩, fun h => ⟨hE.symm h.1, hF.symm h.2⟩,
   fun h k => ⟨hE.trans h.1 k.1, hF.trans h.2 k.2⟩⟩

/-- **The classes meeting P2 and P4 at a member that conditions something are closed under meets
(本类常闭之交).** Under P4 every effect of an occurrence alike to the member lies in each block, so the
witness P2 gives under one class serves the meet. -/
theorem «本类常闭之交» {R E F : «际» α} (hE : «类» E) (hF : «类» F) {m : α} (goes : ∃ w, R m w)
    (atE : «本类至终有常» R E m) (heldE : «所缘同于» R E m)
    (atF : «本类至终有常» R F m) (heldF : «所缘同于» R F m) :
    «本类至终有常» R («合» E F) m ∧ «所缘同于» R («合» E F) m :=
  have closedE := «本类常闭则类闭» hE atE goes heldE
  have closedF := «本类常闭则类闭» hF atF goes heldF
  ⟨fun u u' mu mu' v step => match atE u u' mu.1 mu'.1 v step with
     | .inl ⟨w, hw, _⟩ => .inl ⟨w, hw,
         hE.trans (hE.symm (closedE u v mu.1 step)) (closedE u' w mu'.1 hw),
         hF.trans (hF.symm (closedF u v mu.2 step)) (closedF u' w mu'.2 hw)⟩
     | .inr stops => .inr stops,
   fun v step => ⟨heldE v step, heldF v step⟩⟩

/-- The meet of a family of relations (皆): alike where alike under each. -/
def «皆» {ι : Sort v} (E : ι → «际» α) : «际» α := fun x y => ∀ i, E i x y

/-- The meet of a family of classes is a class. -/
theorem «皆为类» {ι : Sort v} {E : ι → «际» α} (each : ∀ i, «类» (E i)) : «类» («皆» E) :=
  ⟨fun x i => (each i).refl x, fun h i => (each i).symm (h i),
   fun h k i => (each i).trans (h i) (k i)⟩

/-- **The meet of any family of classes meeting P2 and P4 at a member that conditions something, the
family having a member, meets them (本类常闭之遍交).** -/
theorem «本类常闭之遍交» {ι : Sort v} {R : «际» α} {E : ι → «际» α} (each : ∀ i, «类» (E i)) {m : α}
    (goes : ∃ w, R m w) (i₀ : ι) (atClass : ∀ i, «本类至终有常» R (E i) m)
    (held : ∀ i, «所缘同于» R (E i) m) :
    «本类至终有常» R («皆» E) m ∧ «所缘同于» R («皆» E) m :=
  have closed : ∀ i, «闭» R (E i m) := fun i => «本类常闭则类闭» (each i) (atClass i) goes (held i)
  ⟨fun u u' mu mu' v step => match atClass i₀ u u' (mu i₀) (mu' i₀) v step with
     | .inl ⟨w, hw, _⟩ => .inl ⟨w, hw, fun i =>
         (each i).trans ((each i).symm (closed i u v (mu i) step)) (closed i u' w (mu' i) hw)⟩
     | .inr stops => .inr stops,
   fun v step i => held i v step⟩

/-! ## The least class: the member with all that follows it -/

/-- **The class of a member with all that follows it (后类).** Alike where the same, or where both lie
within the member's closure under the net. It is defined from the net and the member alone. -/
def «后类» (R : «际» α) (m : α) : «际» α := fun x y => x = y ∨ («所闭» R m x ∧ «所闭» R m y)

theorem «后类为类» (R : «际» α) (m : α) : «类» («后类» R m) :=
  ⟨fun _ => .inl rfl,
   fun h => match h with
     | .inl e => .inl e.symm
     | .inr ⟨a, b⟩ => .inr ⟨b, a⟩,
   fun h k => match h, k with
     | .inl e, k => by subst e; exact k
     | h, .inl e => by subst e; exact h
     | .inr ⟨a, _⟩, .inr ⟨_, c⟩ => .inr ⟨a, c⟩⟩

/-- The member's block under `«后类»` is its closure under the net. -/
theorem «后类之本» {R : «际» α} {m x : α} : «后类» R m m x ↔ «所闭» R m x :=
  ⟨fun h => match h with
     | .inl e => by subst e; exact «所闭之自反» R _
     | .inr ⟨_, b⟩ => b,
   fun b => .inr ⟨«所闭之自反» R m, b⟩⟩

/-- **Under P2 and P4 at a member, everything within its closure under the net is alike to it
(本类常闭则后皆同).** No premise that the member conditions anything. -/
theorem «本类常闭则后皆同» {R E : «际» α} (hE : «类» E) {m : α} (atClass : «本类至终有常» R E m)
    (held : «所缘同于» R E m) {x : α} (within : «所闭» R m x) : E m x :=
  have closed : «闭» R (fun y => m = y ∨ (E m y ∧ ∃ w, R m w)) := fun u v inside step =>
    match inside with
    | .inl e => by subst e; exact .inr ⟨held v step, v, step⟩
    | .inr ⟨mu, goes⟩ =>
        .inr ⟨hE.symm («本类常闭则所缘同类» hE atClass goes held (hE.symm mu) step), goes⟩
  match within _ closed (.inl rfl) with
  | .inl e => by subst e; exact hE.refl _
  | .inr ⟨mx, _⟩ => mx

/-- **Every class meeting P2 and P4 at a member contains the member's class of what follows it
(本类常闭则含后类).** -/
theorem «本类常闭则含后类» {R E : «际» α} (hE : «类» E) {m : α} (atClass : «本类至终有常» R E m)
    (held : «所缘同于» R E m) : «则» («后类» R m) E :=
  fun x _ h => match h with
  | .inl e => by subst e; exact hE.refl x
  | .inr ⟨a, b⟩ => hE.trans (hE.symm («本类常闭则后皆同» hE atClass held a))
      («本类常闭则后皆同» hE atClass held b)

/-- **Wherever some class meets P2 and P4 at a member, the member's class of what follows it does
(后类本类常闭).** -/
theorem «后类本类常闭» {R E : «际» α} (hE : «类» E) {m : α} (atClass : «本类至终有常» R E m)
    (held : «所缘同于» R E m) :
    «本类至终有常» R («后类» R m) m ∧ «所缘同于» R («后类» R m) m :=
  ⟨fun u u' mu mu' v step =>
     have inU : «所闭» R m u := «后类之本».mp mu
     have inU' : «所闭» R m u' := «后类之本».mp mu'
     match atClass u u' («本类常闭则后皆同» hE atClass held inU)
         («本类常闭则后皆同» hE atClass held inU') v step with
     | .inl ⟨w, hw, _⟩ => .inl ⟨w, hw, .inr ⟨«所闭之闭» R m u v inU step, «所闭之闭» R m u' w inU' hw⟩⟩
     | .inr stops => .inr stops,
   fun _ step => «后类之本».mpr («及之所闭» _ _ (.one step))⟩

/-- **Where it is decided, of each occurrence downstream of a member, whether it conditions something, the
member's class of what follows it meets P2 and P4 (判则后类本类常闭).** -/
theorem «判则后类本类常闭» {R : «际» α} {m : α}
    (decided : ∀ u, «所闭» R m u → (∃ w, R u w) ∨ ∀ w, ¬ R u w) :
    «本类至终有常» R («后类» R m) m ∧ «所缘同于» R («后类» R m) m :=
  «类闭则本类常闭» («后类为类» R m)
    (fun u v mu step => «后类之本».mpr («所闭之闭» R m u v («后类之本».mp mu) step))
    (fun u mu => decided u («后类之本».mp mu))

/-- The first step of a path. -/
theorem «及之首步» {R : «际» α} {x y : α} (down : «及» R x y) : ∃ w, R x w :=
  match down with
  | .one s => ⟨_, s⟩
  | .more s _ => ⟨_, s⟩

/-- **At a member whose closure returns to it, the member's class of what follows it meets P2 and P4
(返则后类本类常闭).** Where everything within `m`'s closure under the net has `m` within its own, no decision
is needed: an occurrence alike to `m` other than `m` reaches `m`, so conditions something, and `m` conditions
something wherever anything alike to it does. -/
theorem «返则后类本类常闭» {R : «际» α} {m : α} (returns : ∀ x, «所闭» R m x → «所闭» R x m) :
    «本类至终有常» R («后类» R m) m ∧ «所缘同于» R («后类» R m) m :=
  ⟨fun u u' mu mu' v step =>
     have inU : «所闭» R m u := «后类之本».mp mu
     have inU' : «所闭» R m u' := «后类之本».mp mu'
     have inV : «所闭» R m v := «所闭之闭» R m u v inU step
     have goes' : ∃ w, R u' w := match «所闭当且仅当同一或及».mp (returns u' inU') with
       | .inr down => «及之首步» down
       | .inl e => by
         subst e
         exact match «所闭当且仅当同一或及».mp inU with
           | .inl e' => by subst e'; exact ⟨v, step⟩
           | .inr down => «及之首步» down
     match goes' with
     | ⟨w, hw⟩ => .inl ⟨w, hw, .inr ⟨inV, «所闭之闭» R m u' w inU' hw⟩⟩,
   fun _ step => «后类之本».mpr («及之所闭» _ _ (.one step))⟩

/-- **The least class meeting P2 and P4 at a member (后类最细).** Wherever some class meets them at
`m`, `«后类» R m` meets them, and every class that meets them contains it. -/
theorem «后类最细» {R : «际» α} {m : α}
    (met : ∃ E, «类» E ∧ «本类至终有常» R E m ∧ «所缘同于» R E m) :
    («本类至终有常» R («后类» R m) m ∧ «所缘同于» R («后类» R m) m) ∧
      ∀ E, «类» E → «本类至终有常» R E m → «所缘同于» R E m → «则» («后类» R m) E :=
  match met with
  | ⟨_, hE, atClass, held⟩ =>
    ⟨«后类本类常闭» hE atClass held, fun _ hE' atClass' held' => «本类常闭则含后类» hE' atClass' held'⟩

/-! ## The reach of every class meeting P2 and P4 -/

/-- **Under P2 and P4 at a member, its line under the class reaches exactly what a line under the one
reaches (本类常闭则所及即一之所及):** the member and everything downstream of it. -/
theorem «本类常闭则所及即一之所及» {R E : «际» α} (hE : «类» E) {m : α}
    (atClass : «本类至终有常» R E m) (held : «所缘同于» R E m) (t : α) :
    «所及» R E m t ↔ «所及» R «一» m t :=
  ⟨fun reached => match reached with
     | .inl e => .inl e
     | .inr line => .inr («及之单调» (fun _ _ c => ⟨c.1, trivial⟩) _ _ line),
   fun reached => match eq_or_reach_iff_reached.mpr reached with
     | .inl e => .inl e
     | .inr down =>
       have goes : ∃ w, R m w := match down with
         | .one s => ⟨_, s⟩
         | .more s _ => ⟨_, s⟩
       .inr («本类常闭则后皆续» hE atClass goes held (hE.refl m) down).2⟩

/-- **The line from a member under its class of what follows it reaches exactly what a line under the one
reaches (后类之所及即一之所及),** with no premise: everything downstream of the member is alike to it by
definition (`«后皆同类则后皆续»`). -/
theorem «后类之所及即一之所及» (R : «际» α) (m t : α) :
    «所及» R («后类» R m) m t ↔ «所及» R «一» m t :=
  ⟨fun reached => match reached with
     | .inl e => .inl e
     | .inr line => .inr («及之单调» (fun _ _ c => ⟨c.1, trivial⟩) _ _ line),
   fun reached => match eq_or_reach_iff_reached.mpr reached with
     | .inl e => .inl e
     | .inr down => .inr («后皆同类则后皆续» («后类为类» R m)
         (fun _ d => «后类之本».mpr («及之所闭» _ _ d)) down)⟩

/-- **Given P2 at a member, P4 holds exactly where its line under the class reaches what the one's
reaches (本类常则闭当且仅当所及即一之所及).** -/
theorem «本类常则闭当且仅当所及即一之所及» {R E : «际» α} (hE : «类» E) {m : α}
    (atClass : «本类至终有常» R E m) :
    «所缘同于» R E m ↔ ∀ t, («所及» R E m t ↔ «所及» R «一» m t) :=
  ⟨fun held => «本类常闭则所及即一之所及» hE atClass held,
   fun same => «后皆续则所缘同于» hE
     (fun t down => (same t).mpr (eq_or_reach_iff_reached.mp (.inr down)))⟩

/-- **With each center under a class of its own meeting P2 and P4 at it, the condition along the net
is the condition at the one (各本类常闭则续无外即一之续无外).** -/
theorem «各本类常闭则续无外即一之续无外» {Pos : Type} {R : «际» α} {E : Pos → «际» α}
    {center : Pos → α} (each : ∀ p, «类» (E p))
    (atClass : ∀ p, «本类至终有常» R (E p) (center p)) (held : ∀ p, «所缘同于» R (E p) (center p)) :
    (∀ p x, «所及» R (E p) (center p) x) ↔ «续无外» R «一» center :=
  ⟨fun all p x => («本类常闭则所及即一之所及» (each p) (atClass p) (held p) x).mp (all p x),
   fun none p x => («本类常闭则所及即一之所及» (each p) (atClass p) (held p) x).mpr (none p x)⟩

/-- **And along a net with no cycle it holds only where every center is one and the same occurrence
(各本类常闭续无外则同一中心).** -/
theorem «各本类常闭续无外则同一中心» {Pos : Type} {R : «际» α} {E : Pos → «际» α}
    {center : Pos → α} (acyclic : «无环» R) (each : ∀ p, «类» (E p))
    (atClass : ∀ p, «本类至终有常» R (E p) (center p)) (held : ∀ p, «所缘同于» R (E p) (center p))
    (all : ∀ p x, «所及» R (E p) (center p) x) (p q : Pos) : center p = center q :=
  «续无外则同一中心» acyclic
    ((«各本类常闭则续无外即一之续无外» each atClass held).mp all) p q

/-! ## P2 alone: the moment -/

/-- **The identity meets P2 at every occurrence (静之本类至终有常).** -/
theorem «静之本类至终有常» (R : «际» α) (m : α) : «本类至终有常» R «静» m :=
  fun u u' (mu : m = u) (mu' : m = u') v step => by subst mu; subst mu'; exact .inl ⟨v, step, rfl⟩

/-- **The identity is the least class meeting P2 at an occurrence (静最细):** it meets P2 there, and every
class contains it. Near-definitional: every class is reflexive. -/
theorem «静最细» (R : «际» α) (m : α) :
    «本类至终有常» R «静» m ∧ ∀ E : «际» α, «类» E → «则» «静» E :=
  ⟨«静之本类至终有常» R m, fun _ hE x _ e => by subst e; exact hE.refl x⟩

/-- **It fails P4 wherever the occurrence conditions something other than itself (静不闭).** -/
theorem «静不闭» {R : «际» α} {m v : α} (step : R m v) (other : m ≠ v) : ¬ «所缘同于» R «静» m :=
  fun held => other (held v step)

end OwnClass

/-! ## A region read as a class

The class of a region is `Web.alikeBy` (`Becoming.Identity`): two occurrences are alike when both lie in it or
neither does. It is stated for carriers in `Type`, so the laws of this part are too. -/

section Region

variable {α : Type}

/-- **A line from inside a region, under the region's class, stays inside it (内外之线不出).** -/
theorem «内外之线不出» {R : «际» α} {S : α → Prop} {f t : α} (inside : S f)
    (reached : «所及» R (Web.alikeBy S) f t) : S t :=
  match reached with
  | .inl e => e ▸ inside
  | .inr line => («线内同类» (Web.alikeBy_class S) line).mp inside

/-- **Under a region's class, P4 at a member inside it is that everything it conditions lies inside
(内外之所缘同于).** -/
theorem «内外之所缘同于» {R : «际» α} {S : α → Prop} {f : α} (inside : S f) :
    «所缘同于» R (Web.alikeBy S) f ↔ ∀ v, R f v → S v :=
  ⟨fun held v step => (held v step).mp inside,
   fun into v step => ⟨fun _ => into v step, fun _ => inside⟩⟩

/-- **Under a region's class, everything downstream of a member inside it lies on its line exactly
where everything downstream of it lies inside (内外之后皆续当且仅当后皆在内).** -/
theorem «内外之后皆续当且仅当后皆在内» {R : «际» α} {S : α → Prop} {f : α} (inside : S f) :
    (∀ t, «及» R f t → «所及» R (Web.alikeBy S) f t) ↔ ∀ t, «及» R f t → S t :=
  («后皆续当且仅当后皆同类» (Web.alikeBy_class S)).trans
    ⟨fun alike t down => (alike t down).mp inside,
     fun into t down => ⟨fun _ => into t down, fun _ => inside⟩⟩

/-! ## The class of what can reach a member -/

/-- A path along the net to an occurrence that reaches `f` back lies on a line under the class of what
can reach `f`. -/
theorem «返之线» {R : «际» α} {f a t : α} (down : «及» R a t) (back : «所闭» R t f) :
    «相续» R (Web.alikeBy («所闭» («逆» R) f)) a t := by
  revert back
  induction down with
  | @one a b step =>
    intro back
    exact .one ⟨step, ⟨fun _ => «所闭之逆».mpr back,
      fun _ => «所闭之逆».mpr («所闭之传递» («及之所闭» _ _ (.one step)) back)⟩⟩
  | @more a b c step rest ih =>
    intro back
    have bf : «所闭» R b f := «所闭之传递» («及之所闭» _ _ rest) back
    exact .more ⟨step, ⟨fun _ => «所闭之逆».mpr bf,
      fun _ => «所闭之逆».mpr («所闭之传递» («及之所闭» _ _ (.one step)) bf)⟩⟩ (ih back)

/-- **Under the class of what can reach a member, its line reaches exactly its loop (返之所及即环):**
what it reaches that reaches it back. -/
theorem «返之所及即环» {R : «际» α} {f t : α} :
    «所及» R (Web.alikeBy («所闭» («逆» R) f)) f t ↔ «所闭» R f t ∧ «所闭» R t f :=
  ⟨fun reached =>
     ⟨match reached with
       | .inl e => by subst e; exact «所闭之自反» R _
       | .inr line => «及之所闭» _ _ («相续含于及» R _ _ _ line),
      «所闭之逆».mp («内外之线不出» («所闭之自反» _ f) reached)⟩,
   fun ⟨there, back⟩ => match «所闭当且仅当同一或及».mp there with
     | .inl e => .inl e
     | .inr down => .inr («返之线» down back)⟩

/-- **Under that class, everything downstream of a member lies on its line exactly where everything it
reaches reaches it back (返之后皆续当且仅当皆返).** -/
theorem «返之后皆续当且仅当皆返» {R : «际» α} {f : α} :
    (∀ t, «及» R f t → «所及» R (Web.alikeBy («所闭» («逆» R) f)) f t) ↔
      ∀ t, «所闭» R f t → «所闭» R t f :=
  («内外之后皆续当且仅当后皆在内» («所闭之自反» _ f)).trans
    ⟨fun into t there => match «所闭当且仅当同一或及».mp there with
       | .inl e => by subst e; exact «所闭之自反» R _
       | .inr down => «所闭之逆».mp (into t down),
     fun returns t down => «所闭之逆».mpr (returns t («及之所闭» _ _ down))⟩

/-- **Along a net with no cycle, the line from an occurrence under the class of what can reach it reaches
only the occurrence itself (无环则返之所及唯己).** -/
theorem «无环则返之所及唯己» {R : «际» α} (acyclic : «无环» R) {f t : α}
    (reached : «所及» R (Web.alikeBy («所闭» («逆» R) f)) f t) : f = t :=
  match «返之所及即环».mp reached with
  | ⟨there, back⟩ => match «所闭当且仅当同一或及».mp there, «所闭当且仅当同一或及».mp back with
    | .inl e, _ => e
    | _, .inl e => e.symm
    | .inr a, .inr b => absurd («及之传递» a b) (acyclic f)

end Region

/-- **At an element returning along the net (`ReturnsAlong`, `Becoming.FlowCenters`), the element's class of
what follows it meets P2 and P4, and is the least class meeting them.** `ReturnsAlong` is the hypothesis of
`«返则后类本类常闭»`, stated through `WithinClosure`. -/
theorem ReturnsAlong.downstreamClass_regular {X : Type} {R : «际» X} {m : X} (returns : ReturnsAlong R m) :
    («本类至终有常» R («后类» R m) m ∧ «所缘同于» R («后类» R m) m) ∧
      ∀ E, «类» E → «本类至终有常» R E m → «所缘同于» R E m → «则» («后类» R m) E :=
  have regular := «返则后类本类常闭» returns
  «后类最细» ⟨_, «后类为类» R m, regular.1, regular.2⟩

/-! ## Witnesses -/

namespace JoinBreaks

/-! A member `m` conditioning `a`, and `z` conditioning `w`; nothing else is conditioned. One class
holds `m` with `a` and `x` with `z`; another holds `m`, `a` and `x` together. Each block of `m` is
closed under the net, so each class meets P2 and P4 at `m`. The least class containing both holds `m`,
`a`, `x` and `z` together, and `z` conditions `w`, which it does not hold. -/

inductive Occ | m | a | x | z | w

def step : «际» Occ
  | .m, .m => False
  | .m, .a => True
  | .m, .x => False
  | .m, .z => False
  | .m, .w => False
  | .a, .m => False
  | .a, .a => False
  | .a, .x => False
  | .a, .z => False
  | .a, .w => False
  | .x, .m => False
  | .x, .a => False
  | .x, .x => False
  | .x, .z => False
  | .x, .w => False
  | .z, .m => False
  | .z, .a => False
  | .z, .x => False
  | .z, .z => False
  | .z, .w => True
  | .w, .m => False
  | .w, .a => False
  | .w, .x => False
  | .w, .z => False
  | .w, .w => False

def labelE : Occ → Nat
  | .m => 0 | .a => 0 | .x => 1 | .z => 1 | .w => 2

def labelF : Occ → Nat
  | .m => 0 | .a => 0 | .x => 0 | .z => 1 | .w => 2

def labelJ : Occ → Nat
  | .m => 0 | .a => 0 | .x => 0 | .z => 0 | .w => 2

def E : «际» Occ := fun u v => labelE u = labelE v
def F : «际» Occ := fun u v => labelF u = labelF v
def J : «际» Occ := fun u v => labelJ u = labelJ v

theorem E_class : «类» E := ⟨fun _ => rfl, Eq.symm, Eq.trans⟩
theorem F_class : «类» F := ⟨fun _ => rfl, Eq.symm, Eq.trans⟩
theorem J_class : «类» J := ⟨fun _ => rfl, Eq.symm, Eq.trans⟩

theorem m_goes : ∃ v, step .m v := ⟨.a, trivial⟩

theorem decided (u : Occ) : (∃ v, step u v) ∨ ∀ v, ¬ step u v := by
  cases u
  · exact .inl ⟨.a, trivial⟩
  · exact .inr fun v h => by cases v <;> exact False.elim h
  · exact .inr fun v h => by cases v <;> exact False.elim h
  · exact .inl ⟨.w, trivial⟩
  · exact .inr fun v h => by cases v <;> exact False.elim h

/-- **The first class meets P2 and P4 at `m`.** -/
theorem E_meets : «本类至终有常» step E .m ∧ «所缘同于» step E .m :=
  «类闭则本类常闭» E_class (fun u v mu s => by
    cases u <;> cases v <;> first | exact False.elim s | exact Nat.noConfusion mu | rfl)
    (fun u _ => decided u)

/-- **So does the second.** -/
theorem F_meets : «本类至终有常» step F .m ∧ «所缘同于» step F .m :=
  «类闭则本类常闭» F_class (fun u v mu s => by
    cases u <;> cases v <;> first | exact False.elim s | exact Nat.noConfusion mu | rfl)
    (fun u _ => decided u)

theorem E_le_J : «则» E J := fun u v e => by
  cases u <;> cases v <;> first | rfl | exact Nat.noConfusion e | exact Nat.noConfusion (Nat.succ.inj e)

theorem F_le_J : «则» F J := fun u v e => by
  cases u <;> cases v <;> first | rfl | exact Nat.noConfusion e | exact Nat.noConfusion (Nat.succ.inj e)

/-- **`J` is the least class containing both.** -/
theorem J_least (G : «际» Occ) (hG : «类» G) (hE : «则» E G) (hF : «则» F G) : «则» J G := by
  have ma : G .m .a := hE _ _ rfl
  have mx : G .m .x := hF _ _ rfl
  have xz : G .x .z := hE _ _ rfl
  have mz : G .m .z := hG.trans mx xz
  have base : ∀ u, labelJ u = 0 → G .m u := fun u h => by
    cases u
    · exact hG.refl _
    · exact ma
    · exact mx
    · exact mz
    · exact Nat.noConfusion h
  intro u v e
  cases u <;> cases v <;>
    first
    | exact hG.refl _
    | exact Nat.noConfusion e
    | exact Nat.noConfusion (Nat.succ.inj e)
    | exact hG.trans (hG.symm (base _ rfl)) (base _ rfl)

/-- **The least class containing both fails P2 and P4 at `m`:** `z`, alike to `m` under it, conditions
`w`, which is not. -/
theorem J_fails : ¬ («本类至终有常» step J .m ∧ «所缘同于» step J .m) := fun ⟨atClass, held⟩ =>
  Nat.noConfusion («本类常闭则所缘同类» J_class atClass m_goes held (show J .z .m from rfl)
    (show step .z .w from trivial))

end JoinBreaks

namespace MeetBreaks

/-! A member `m` conditioning `a` and `b`, an occurrence `m'` alike to it conditioning `c` and `d`, and
an occurrence `n`, alike to both, that conditions nothing; nothing else is conditioned. One class holds
`a` with `c` and `b` with `d`, the other `a` with `d` and `b` with `c`. Each meets P2 at `m`; their meet
holds `a`, `b`, `c` and `d` apart, and `m'` conditions nothing alike to `a`. Neither holds `m`'s effects.
At `n`, which conditions nothing, P4 asks nothing and the same happens. -/

inductive Occ | m | m' | n | a | b | c | d

def step : «际» Occ
  | .m, .m => False
  | .m, .m' => False
  | .m, .n => False
  | .m, .a => True
  | .m, .b => True
  | .m, .c => False
  | .m, .d => False
  | .m', .m => False
  | .m', .m' => False
  | .m', .n => False
  | .m', .a => False
  | .m', .b => False
  | .m', .c => True
  | .m', .d => True
  | .n, .m => False
  | .n, .m' => False
  | .n, .n => False
  | .n, .a => False
  | .n, .b => False
  | .n, .c => False
  | .n, .d => False
  | .a, .m => False
  | .a, .m' => False
  | .a, .n => False
  | .a, .a => False
  | .a, .b => False
  | .a, .c => False
  | .a, .d => False
  | .b, .m => False
  | .b, .m' => False
  | .b, .n => False
  | .b, .a => False
  | .b, .b => False
  | .b, .c => False
  | .b, .d => False
  | .c, .m => False
  | .c, .m' => False
  | .c, .n => False
  | .c, .a => False
  | .c, .b => False
  | .c, .c => False
  | .c, .d => False
  | .d, .m => False
  | .d, .m' => False
  | .d, .n => False
  | .d, .a => False
  | .d, .b => False
  | .d, .c => False
  | .d, .d => False

def labelE : Occ → Nat
  | .m => 0 | .m' => 0 | .n => 0 | .a => 1 | .b => 2 | .c => 1 | .d => 2

def labelF : Occ → Nat
  | .m => 0 | .m' => 0 | .n => 0 | .a => 1 | .b => 2 | .c => 2 | .d => 1

def E : «际» Occ := fun u v => labelE u = labelE v
def F : «际» Occ := fun u v => labelF u = labelF v

theorem E_class : «类» E := ⟨fun _ => rfl, Eq.symm, Eq.trans⟩
theorem F_class : «类» F := ⟨fun _ => rfl, Eq.symm, Eq.trans⟩

/-- Each class meets P2 at any occurrence of the block `{m, m', n}`. -/
theorem E_constant (o : Occ) (inBlock : labelE o = 0) : «本类至终有常» step E o := by
  intro u u' mu mu' v r
  cases o <;> (try exact Nat.noConfusion inBlock) <;>
  cases u <;> cases v <;> (try exact False.elim r) <;> cases u' <;>
    first
    | exact Nat.noConfusion mu
    | exact Nat.noConfusion mu'
    | exact Nat.noConfusion (Nat.succ.inj mu')
    | exact Nat.noConfusion (Nat.succ.inj (Nat.succ.inj mu'))
    | exact .inl ⟨.a, trivial, rfl⟩
    | exact .inl ⟨.b, trivial, rfl⟩
    | exact .inl ⟨.c, trivial, rfl⟩
    | exact .inl ⟨.d, trivial, rfl⟩
    | exact .inr (fun w h => by cases w <;> exact False.elim h)

theorem F_constant (o : Occ) (inBlock : labelF o = 0) : «本类至终有常» step F o := by
  intro u u' mu mu' v r
  cases o <;> (try exact Nat.noConfusion inBlock) <;>
  cases u <;> cases v <;> (try exact False.elim r) <;> cases u' <;>
    first
    | exact Nat.noConfusion mu
    | exact Nat.noConfusion mu'
    | exact Nat.noConfusion (Nat.succ.inj mu')
    | exact Nat.noConfusion (Nat.succ.inj (Nat.succ.inj mu'))
    | exact .inl ⟨.a, trivial, rfl⟩
    | exact .inl ⟨.b, trivial, rfl⟩
    | exact .inl ⟨.c, trivial, rfl⟩
    | exact .inl ⟨.d, trivial, rfl⟩
    | exact .inr (fun w h => by cases w <;> exact False.elim h)

/-- The meet holds `a`, `b`, `c` and `d` apart, and `m'` conditions only `c` and `d`. -/
theorem meet_not_constant (o : Occ) (inBlock : labelE o = 0 ∧ labelF o = 0) :
    ¬ «本类至终有常» step («合» E F) o := fun atClass =>
  have mo : «合» E F o .m := ⟨inBlock.1, inBlock.2⟩
  have m'o : «合» E F o .m' := ⟨inBlock.1, inBlock.2⟩
  match atClass .m .m' mo m'o .a trivial with
  | .inl ⟨v', r, e⟩ => by
    cases v' <;> first
      | exact False.elim r
      | exact Nat.noConfusion (Nat.succ.inj e.1)
      | exact Nat.noConfusion (Nat.succ.inj e.2)
  | .inr stops => stops .c trivial

/-- **Both classes meet P2 at `m`, and their meet does not:** P2 alone is not closed under meets. -/
theorem meet_not_constant_at :
    «本类至终有常» step E .m ∧ «本类至终有常» step F .m ∧ ¬ «本类至终有常» step («合» E F) .m :=
  ⟨E_constant .m rfl, F_constant .m rfl, meet_not_constant .m ⟨rfl, rfl⟩⟩

/-- **Neither holds `m`'s effects.** -/
theorem not_held : ¬ «所缘同于» step E .m ∧ ¬ «所缘同于» step F .m :=
  ⟨fun held => Nat.noConfusion (held .a trivial), fun held => Nat.noConfusion (held .a trivial)⟩

/-- **At `n`, which conditions nothing, both classes meet P2 and P4.** -/
theorem idle_both :
    («本类至终有常» step E .n ∧ «所缘同于» step E .n) ∧
      («本类至终有常» step F .n ∧ «所缘同于» step F .n) :=
  ⟨⟨E_constant .n rfl, fun v h => by cases v <;> exact False.elim h⟩,
   ⟨F_constant .n rfl, fun v h => by cases v <;> exact False.elim h⟩⟩

/-- **And their meet fails P2 there.** -/
theorem idle_meet_not_constant : ¬ «本类至终有常» step («合» E F) .n :=
  meet_not_constant .n ⟨rfl, rfl⟩

end MeetBreaks

namespace ReturnsNotRegular

/-! `f` and `k` condition each other, and `g` conditions `f` and `h`; nothing else is conditioned. What
`f` reaches, `f` and `k`, reaches it back, so under the class of what can reach `f` everything downstream
of `f` lies on its line and the class holds `f`'s effects. P2 fails at `f`: `g` can reach `f`, so is alike
to it, and conditions `h`, which cannot, while `f` conditions only `k`, which can. -/

inductive Occ | f | k | g | h

def step : «际» Occ
  | .f, .f => False
  | .f, .k => True
  | .f, .g => False
  | .f, .h => False
  | .k, .f => True
  | .k, .k => False
  | .k, .g => False
  | .k, .h => False
  | .g, .f => True
  | .g, .k => False
  | .g, .g => False
  | .g, .h => True
  | .h, .f => False
  | .h, .k => False
  | .h, .g => False
  | .h, .h => False

/-- The class of what can reach `f`. -/
def back : «际» Occ := Web.alikeBy («所闭» («逆» step) .f)

theorem within_f {t : Occ} (within : «所闭» step .f t) : t = .f ∨ t = .k :=
  within (fun x => x = .f ∨ x = .k) (fun u v inside s => by
    rcases inside with e | e <;> subst e <;> cases v <;>
      first | exact .inl rfl | exact .inr rfl | exact False.elim s) (.inl rfl)

theorem k_back : «所闭» step .k .f := «及之所闭» _ _ (.one (show step .k .f from trivial))

theorem g_back : «所闭» step .g .f := «及之所闭» _ _ (.one (show step .g .f from trivial))

theorem h_not_back : ¬ «所闭» step .h .f := fun within =>
  match within (fun x => x = .h) (fun u v inside s => by
    subst inside; cases v <;> exact False.elim s) rfl with
  | e => Occ.noConfusion e

/-- **Everything `f` reaches reaches it back.** -/
theorem returns : ∀ t, «所闭» step .f t → «所闭» step t .f := fun _ within =>
  match within_f within with
  | .inl e => by subst e; exact «所闭之自反» _ _
  | .inr e => by subst e; exact k_back

/-- **Under the class of what can reach `f`, everything downstream of `f` lies on its line and the
class holds `f`'s effects, while P2 fails at `f`.** -/
theorem reach_without_regularity :
    (∀ t, «及» step .f t → «所及» step back .f t) ∧ «所缘同于» step back .f ∧
      ¬ «本类至终有常» step back .f :=
  have reach := «返之后皆续当且仅当皆返».mpr returns
  ⟨reach, «后皆续则所缘同于» (Web.alikeBy_class _) reach, fun atClass =>
    match atClass .g .f ⟨fun _ => «所闭之逆».mpr g_back, fun _ => «所闭之自反» _ _⟩
        ((Web.alikeBy_class _).refl _) .h (show step .g .h from trivial) with
    | .inl ⟨v', s, e⟩ => by
      cases v' <;> first
        | exact False.elim s
        | exact h_not_back («所闭之逆».mp (e.mpr («所闭之逆».mpr k_back)))
    | .inr stops => stops .k trivial⟩

end ReturnsNotRegular

/-! ## The class read on a flow -/

variable {F C : Type}

namespace Flow

variable {L : Flow F C} {W : Web F C} {obs : F → C → Prop} {f g : F}

/-- **The class of a formation's coupling closure (CouplingClass):** alike where both lie within it,
or both beyond it. -/
def CouplingClass (L : Flow F C) (W : Web F C) (obs : F → C → Prop) (f : F) : «际» F :=
  Web.alikeBy (L.WithinCoupling W obs f)

theorem couplingClass_class : «类» (L.CouplingClass W obs f) := Web.alikeBy_class _

/-- **P4 read on a flow:** the class of `f`'s coupling closure holds `f`'s effects exactly where
everything `f` affects lies within its coupling closure. -/
theorem couplingClass_held_iff :
    «所缘同于» (L.Affects W) (L.CouplingClass W obs f) f ↔
      ∀ g, L.Affects W f g → L.WithinCoupling W obs f g :=
  «内外之所缘同于» («所闭之自反» _ f)

/-- **With coupling by threshold only, P4 holds exactly where whatever `f` affects can affect it back,
at some remove.** -/
theorem couplingClass_held_iff_back :
    «所缘同于» (L.Affects W) (L.CouplingClass W thresholdOnly f) f ↔
      ∀ g, L.Affects W f g → L.WithinReach W g f :=
  couplingClass_held_iff.trans
    ⟨fun into g a => withinReach_iff_influence.mpr (withinCoupling_thresholdOnly.mp (into g a)),
     fun back g a => withinCoupling_thresholdOnly.mpr (withinReach_iff_influence.mp (back g a))⟩

/-- **Everything downstream of `f` lies on its line under the class of its coupling closure exactly where
everything within its reach lies within its coupling closure.** -/
theorem couplingClass_reach_iff :
    (∀ g, «及» (L.Affects W) f g → «所及» (L.Affects W) (L.CouplingClass W obs f) f g) ↔
      ∀ g, L.WithinReach W f g → L.WithinCoupling W obs f g :=
  («内外之后皆续当且仅当后皆在内» («所闭之自反» _ f)).trans
    ⟨fun into g within => match «所闭当且仅当同一或及».mp within with
       | .inl e => by subst e; exact «所闭之自反» _ _
       | .inr down => into g down,
     fun into g down => into g («及之所闭» _ _ down)⟩

/-- **Where `f`'s acts return, everything downstream of it lies on its line under the class of its
coupling closure, for every coupling by level.** -/
theorem ReachReturns.couplingClass_reach (returns : L.ReachReturns W f) :
    ∀ g, «及» (L.Affects W) f g → «所及» (L.Affects W) (L.CouplingClass W obs f) f g :=
  couplingClass_reach_iff.mpr fun _ within => returns.represented within

/-- **With coupling by threshold only, exactly there.** -/
theorem couplingClass_reach_iff_returns :
    (∀ g, «及» (L.Affects W) f g → «所及» (L.Affects W) (L.CouplingClass W thresholdOnly f) f g) ↔
      L.ReachReturns W f :=
  couplingClass_reach_iff.trans reachReturns_iff_represented.symm

/-- **The line from `f` under the class of its coupling closure stays within its reach and its coupling
closure.** -/
theorem couplingClass_line_within (reached : «所及» (L.Affects W) (L.CouplingClass W obs f) f g) :
    L.WithinReach W f g ∧ L.WithinCoupling W obs f g :=
  ⟨match reached with
    | .inl e => by subst e; exact «所闭之自反» _ _
    | .inr line => «及之所闭» _ _ («相续含于及» _ _ _ _ line),
   «内外之线不出» («所闭之自反» _ f) reached⟩

/-- **With coupling by threshold only, the line from `f` under the class of its coupling closure reaches
exactly `f`'s loop.** -/
theorem couplingClass_line_iff_loop :
    «所及» (L.Affects W) (L.CouplingClass W thresholdOnly f) f g ↔ L.InOneLoop W f g :=
  ⟨fun reached =>
     match couplingClass_line_within reached with
     | ⟨within, coupled⟩ =>
       ⟨within, withinReach_iff_influence.mpr (withinCoupling_thresholdOnly.mp coupled)⟩,
   fun ⟨within, back⟩ =>
     match («返之所及即环» (R := L.Affects W)).mpr ⟨within, back⟩ with
     | .inl e => .inl e
     | .inr line => .inr («及之单调» (fun _ _ c => ⟨c.1,
         withinCoupling_thresholdOnly.trans (c.2.trans withinCoupling_thresholdOnly.symm)⟩) _ _ line)⟩

/-- **P2 and P4 read on a flow, at a formation that affects something, ask that its coupling closure be
closed under affecting.** -/
theorem couplingClass_closed (goes : ∃ g, L.Affects W f g)
    (atClass : «本类至终有常» (L.Affects W) (L.CouplingClass W obs f) f)
    (held : «所缘同于» (L.Affects W) (L.CouplingClass W obs f) f) :
    ClosedUnder (L.Affects W) (L.WithinCoupling W obs f) :=
  fun u v inside a =>
    ((«本类常闭则类闭» couplingClass_class atClass goes held) u v
      ⟨fun _ => inside, fun _ => «所闭之自反» _ f⟩ a).mp («所闭之自反» _ f)

end Flow

end Becoming
