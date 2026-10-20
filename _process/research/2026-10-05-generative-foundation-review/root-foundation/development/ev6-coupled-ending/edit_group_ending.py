#!/usr/bin/env python3
"""EV6: groups whose conditions are coupled, in Becoming.GroupEnding: a member depending on a family whose renewal is
gated on it as one leaves no descendant after the family's excess; groups depending on one family end together and are
not selected among; the one-condition law derived as the family of one condition (board rule 9).
usage: python3 -B edit_group_ending.py FILE"""
import sys
from pathlib import Path

p = Path(sys.argv[1])
text = p.read_text()


def once(old, new):
    global text
    assert text.count(old) == 1, ('edit does not match once', old[:100], text.count(old))
    text = text.replace(old, new)


once('''/-- A member depending, at a need of at least `m`, on a condition whose gated renewal ran into
`n` steps of joint excess from `T` starting below `n + m`, leaves no descendant at any step from
`T + n` on: it is not active there (`Flow.joint_excess_ends`). -/
theorem excess_childless (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) {c : X} {m : Nat}
    (gated : ∀ t f, f ∈ L.present t → 0 < L.give t f c →
      W.requires t f c ∧ m ≤ W.need t f c)
    {T n : Nat} (excess : ∀ k, k < n → L.given (T + k) c < L.taken (T + k) c)
    (start : W.level T c < n + m) (k : Nat) {g : X}
    (depends : W.requires (T + n + k) g c) (high : m ≤ W.need (T + n + k) g c) (x : X) :
    ¬ L.DescendsAt W (T + n + k) x g :=
  inactive_childless acting
    (Becoming.Flow.joint_excess_ends balances acting dependent gated excess start k g depends high) x
''', '''/-- A member depending, at a need of at least `m`, on some condition of a family whose renewal is
gated on the family as one (whatever gives to a member depends on some member at a need of at
least `m`), where the family's uptake exceeded its replenishment over `n` steps from `T` starting
from a stock below `n + m`, leaves no descendant at any step from `T + n` on: it is not active
there (`Flow.family_excess_ends`). -/
theorem family_childless (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) {ds : List X} {m : Nat}
    (gated : ∀ t f, f ∈ L.present t → ∀ d, d ∈ ds → 0 < L.give t f d →
      ∃ e, e ∈ ds ∧ W.requires t f e ∧ m ≤ W.need t f e)
    {T n : Nat} (excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k))
    (start : W.stock ds T < n + m) (k : Nat) {g e : X} (inside : e ∈ ds)
    (depends : W.requires (T + n + k) g e) (high : m ≤ W.need (T + n + k) g e) (x : X) :
    ¬ L.DescendsAt W (T + n + k) x g :=
  inactive_childless acting
    (Becoming.Flow.family_excess_ends balances acting dependent gated excess start k g e inside
      depends high) x

/-- A member depending, at a need of at least `m`, on a condition whose gated renewal ran into
`n` steps of joint excess from `T` starting below `n + m`, leaves no descendant at any step from
`T + n` on: the family of one condition. -/
theorem excess_childless (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) {c : X} {m : Nat}
    (gated : ∀ t f, f ∈ L.present t → 0 < L.give t f c →
      W.requires t f c ∧ m ≤ W.need t f c)
    {T n : Nat} (excess : ∀ k, k < n → L.given (T + k) c < L.taken (T + k) c)
    (start : W.level T c < n + m) (k : Nat) {g : X}
    (depends : W.requires (T + n + k) g c) (high : m ≤ W.need (T + n + k) g c) (x : X) :
    ¬ L.DescendsAt W (T + n + k) x g :=
  family_childless (ds := [c]) balances acting dependent
    (fun t f present => Becoming.Flow.gate_single (gated t f present)) excess start k (.head [])
    depends high x
''')

once('''/-- Where every member of a generation is not active, the next generation is empty: one
condition shared by every group, once it ends them, leaves no group to select among. -/''',
'''/-- Groups whose conditions are coupled end together: where every member of every group depends,
at a need of at least `m`, on some condition of one family whose renewal is gated on the family
as one and whose uptake exceeded its replenishment over `n` steps from `T` starting from a stock
below `n + m`, then at every generation of descent from `T + n` on each group leaves no
offspring, and nothing is selected among the groups, for any amount. The members need not share
a condition: depending on conditions of one coupled family is enough. -/
theorem coupled_end_together (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) {ds : List X} {m : Nat}
    (gated : ∀ t f, f ∈ L.present t → ∀ d, d ∈ ds → 0 < L.give t f d →
      ∃ e, e ∈ ds ∧ W.requires t f e ∧ m ≤ W.need t f e)
    {T n : Nat} (excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k))
    (start : W.stock ds T < n + m) (k : Nat) {G : Generations X}
    (descended : SelectionTerm.Flow.Descended L W G) {gs : List (List X)}
    (within : ∀ h p, h ∈ gs → p ∈ h → p ∈ G.family (T + n + k))
    (coupled : ∀ h p, h ∈ gs → p ∈ h →
      ∃ e, e ∈ ds ∧ W.requires (T + n + k) p e ∧ m ≤ W.need (T + n + k) p e)
    (a : X → Nat) :
    (∀ h, h ∈ gs → total h (G.offspringNumber (T + n + k)) = 0) ∧
      concordAmong gs (G.offspringNumber (T + n + k)) a = 0 ∧
      discordAmong gs (G.offspringNumber (T + n + k)) a = 0 :=
  have ends : ∀ h, h ∈ gs → total h (G.offspringNumber (T + n + k)) = 0 := fun h mh =>
    group_childless acting descended (fun p mp => within h p mh mp) fun p mp => match coupled h p mh mp with
      | ⟨e, inside, depends, high⟩ =>
        Becoming.Flow.family_excess_ends balances acting dependent gated excess start k p e inside
          depends high
  ⟨ends, concord_uniform (w := fun h => total h (G.offspringNumber (T + n + k))) ends
      (fun h => total h a),
    discord_uniform (w := fun h => total h (G.offspringNumber (T + n + k))) ends
      (fun h => total h a)⟩

/-- So ending selects among groups only between coupled families: where every group with less
of the amount than another has its members each depending, at a need of at least `m`, on some
condition of a family whose gated renewal ran into family excess as above, the groups with less
leave nothing at every generation from `T + n` on. -/
theorem ended_of_family (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) {ds : List X} {m : Nat}
    (gated : ∀ t f, f ∈ L.present t → ∀ d, d ∈ ds → 0 < L.give t f d →
      ∃ e, e ∈ ds ∧ W.requires t f e ∧ m ≤ W.need t f e)
    {T n : Nat} (excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k))
    (start : W.stock ds T < n + m) (k : Nat) {G : Generations X}
    (descended : SelectionTerm.Flow.Descended L W G) {gs : List (List X)}
    (listed : whole gs = G.family (T + n + k)) {a : X → Nat}
    (coupled : ∀ g h, g ∈ gs → h ∈ gs → total h a < total g a → ∀ p, p ∈ h →
      ∃ e, e ∈ ds ∧ W.requires (T + n + k) p e ∧ m ≤ W.need (T + n + k) p e) :
    Ended gs (G.offspringNumber (T + n + k)) a :=
  ended_of_inactive acting descended listed fun g h mg mh less p mp =>
    match coupled g h mg mh less p mp with
    | ⟨e, inside, depends, high⟩ =>
      Becoming.Flow.family_excess_ends balances acting dependent gated excess start k p e inside
        depends high

/-- Where every member of a generation is not active, the next generation is empty: one
condition shared by every group, once it ends them, leaves no group to select among. -/''')

p.write_text(text)
print('edited', p)

# --- the module doc ---
text = p.read_text()
once('''* **A condition shared by every group.** Where every member of a generation is not active (every
  group depending on one condition that ran into joint excess), the next generation is empty
  (`Flow.all_end`): one shared condition gives no selection among the groups that keeps it; every
  group ends with it.''',
'''* **A condition shared by every group.** Where every member of a generation is not active (every
  group depending on one condition that ran into joint excess), the next generation is empty
  (`Flow.all_end`): one shared condition gives no selection among the groups that keeps it; every
  group ends with it.
* **Conditions coupled into one family.** A group's condition need not be its own or shared: a
  neighbour can renew it while drawing on a condition of its own. Where the renewal of a family
  of conditions is gated on the family read as one (whatever gives to a member depends on some
  member at a need of at least `m`) and the family's uptake exceeded its replenishment as in
  `Flow.family_excess_ends`, a member depending on any condition of the family leaves no
  descendant from then on (`Flow.family_childless`; `Flow.excess_childless` is the family of
  one condition). Groups whose members depend on conditions of one such family end together:
  each leaves no offspring and nothing is selected among them (`Flow.coupled_end_together`).
  So ending selects among groups only between families: where the groups with less of an
  amount depend on a family that ran into excess, they leave nothing (`Flow.ended_of_family`).''')
once('''The amount is any reading; which group's condition runs into joint excess, and why, is a
hypothesis wherever it enters, as is that the groups' members depend on their own condition.''',
'''The amount is any reading; which group's condition, or which family of conditions, runs into
joint excess, and why, is a hypothesis wherever it enters, as is which conditions the groups'
members depend on.''')
p.write_text(text)
print('doc edited', p)
