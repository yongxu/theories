import Becoming.Reproduction

/-!
# A common shift of offspring numbers: what the selection term proper does and does not decide

`Becoming.SelectionTerm` states the selection term proper in counting form (`concord`,
`discord`: the products of two excesses over ordered pairs) and `Becoming.Reproduction` reads it
on offspring number itself. This module is the counting layer of EL1 (a) and (b): its laws are
about lists, weights and the `Generations` of `Becoming.SelectionTerm`, read with "goes on" as
every later family nonempty and "ends" as every family empty from some generation on. The join
to generations of descent in a flow (`SelectionTerm.Flow.Descended`), to `Embodied` and newness,
and the reading of going on as `«生成»` on the lineage continuation are another module's
(`Becoming.LineageRegions`); nothing here is read on the map's regions. It states what the term
leaves out (how many offspring there are, which decides whether a family goes on, against how
they differ, which is all the term reads) and where the term does decide.

* **Shift invariance, an arithmetic identity with no premise.** A common number added to two
  numbers leaves the excess of one over the other unchanged (`excess_add_right`, not a new law). So where every
  member's weight is shifted by a common `k`, concordance and discordance with any amount are
  unchanged (`concord_shifted`, `discord_shifted`; with the shift read as a function,
  `concord_shift`, `discord_shift`), and alike where the amount is shifted
  (`concord_shift_amount`, `discord_shift_amount`), while the total weight moves by `k` for each
  member (`total_shifted`) and the weighted total by `k` times the total amount
  (`weighted_shift`). Over generations, two families alike at a step in members and amounts,
  whose offspring numbers differ by a common `k`, have the same selection term proper at that
  step, and the next generation of the one is larger by `k` for each member
  (`Generations.shift_step`): the selection term proper does not fix the next generation's size.
* **What a positive term needs.** Positive concordance or discordance of a weight with any
  amount means the weight varies over the list: two members, the one's weight below the
  other's (`weight_varies_of_concord`, `weight_varies_of_discord`), so some member's weight is
  positive (`pos_weight_of_varies`, `pos_weight_of_concord`, `pos_weight_of_discord`). Over
  generations, a positive selection term proper at a step means offspring numbers vary there
  (`Generations.varies_of_selection`), so some member has at least one offspring
  (`Generations.reproducing_of_selection`) and the next generation is nonempty
  (`Generations.next_of_reproducing`, `Generations.next_of_selection`). Conversely, at a step
  whose next generation is empty, both terms are zero (`Generations.last_term_zero`).
* **The boundary on the other side: a term positive at unboundedly many steps decides.** A
  selection term proper positive at every step forces every generation after the first to be
  nonempty (`Generations.never_empties`); and a first generation that is nonempty, with a term
  positive at every step whose family is nonempty, forces every generation to be nonempty
  (`Generations.never_empties_while`). So no course ends whose term is positive at every
  generation while it lasts: at its last nonempty generation the term is zero. More: a term
  positive at unboundedly many steps (past every step, a later one where it is positive) forces
  every generation to be nonempty, the first included, since an empty family stays empty
  (`Generations.never_empties_of_unbounded`). The premise is strictly weaker than positivity at
  every step: a course alternating a concordant step with a step of one copy each has
  concordance two at every even step and no terms at every odd one
  (`Alternating.unbounded_not_every`), and is two members at every generation
  (`Alternating.course_family`).
* **The exception: exact transmission of offspring number.** Read by offspring number
  (`Reproduction.Generations.ByNumber`) with exact transmission at every step `s` with `t ≤ s`
  (each offspring leaving as many offspring as its parent), a member of the family at `t` with
  a positive offspring number keeps a line carrying that same offspring number at every later
  generation (`Generations.line_kept`). So every later generation is nonempty exactly where the
  one after `t` is (`Generations.goes_on_iff`), and a positive selection term at `t` forces it
  (`Generations.goes_on`). This extends the landed one-step law
  `Reproduction.Generations.ByNumber.rises_exact_iff` (with exactness at `t`, the mean rises at
  `t` exactly where concordance at `t` is positive, so a positive term makes generation `t + 2`
  nonempty) to every later generation. What forces going on is exact transmission of a positive
  offspring number; the positive term is one way to have one, not the only one. Exactness at
  `t` alone is not enough: a course read by offspring number, exact at step 0 and not at step 1,
  concordant at step 0, has one member at generations 1 and 2 and is empty from generation 3 on
  (`ExactOnce.exact_once_ends`, a witness). The premises of
  `goes_on` hold together: one member leaving one like itself beside one leaving none, read by
  offspring number, is exact at every step and concordant at the first
  (`OneLine.goes_on_premises`); and those of a common shift hold with `k` positive
  (`OneLine.shift_step_premises`).
* **A zero term decides nothing, even there.** Read by offspring number with exact transmission,
  one offspring each and none each both have no concordance and no discordance at any step; the
  first is one member at every generation, the second is empty from the first step on
  (`ZeroTerm.decides_nothing`).
* **Within any horizon, the course of selection terms does not decide a fate.** For every
  course of generations `G` and every horizon `H`, two courses (`Horizon.going G H`,
  `Horizon.ending G H`) have `G`'s families through `H + 1`, its offspring at every step through
  `H` and its amounts at every step, so `G`'s concordance and discordance at every step through
  `H`; the two have the same concordance and the same discordance at every step (none after
  `H`); every generation of the first from `H + 1` on is as large as `G`'s at `H + 1`, and the
  second is empty from `H + 2` on (`Horizon.same_terms_two_fates`). So where `G`'s term at `H`
  is positive, or merely its generation `H + 1` nonempty, the first goes on forever
  (`Horizon.going_goes_on`, `Horizon.going_goes_on_of_selection`). A course whose term is
  positive at every step (`Horizon.steady`: two and none) goes on, as it must; the courses
  that share its terms through `H` go on and end (`Horizon.steady_two_fates`). Where `G` is
  merely nonempty at `H`, a course with one more offspring at `H` for each member, a copy of
  itself, and one copy each after `H` (`Horizon.goingShifted G H`; at `H` its offspring numbers
  are `G`'s shifted by one, so its terms there are `G`'s by `Generations.shift_step`) has `G`'s
  families and terms through `H` and the same terms as `ending G H` at every step, and is
  nonempty at every generation (`Horizon.two_fates_of_nonempty`). Relative
  standing within a horizon does not decide persistence; a term positive at every step, indeed
  at unboundedly many steps, does; a course nonempty at its first generation whose terms are
  zero from some step on decides nothing.
* **The exact boundary on `Generations`.** Two courses have the same terms where their
  concordance and their discordance agree at every step (`SameTerms`). Where `G`'s terms are zero
  at every step after `H`, `going G H` and `ending G H` have `G`'s terms at every step, not only
  through `H` (`Horizon.same_terms_everywhere_of_zero_after`); so where `G`'s generation `H + 1`
  is also nonempty, `G`'s whole course of terms is shared by a course nonempty at every
  generation from `H + 1` on and one empty from `H + 2` on (`Horizon.zero_after_two_fates`), and
  where `G` is merely nonempty at `H`, by `goingShifted G H`, nonempty at every generation, and
  `ending G H` (`Horizon.zero_after_two_fates_shifted`). Their premises hold together for
  `going steady H`, concordant by two at every step through `H` and two members at `H + 1`
  (`Horizon.zero_after_premises`). For a course nonempty at its first generation whose terms
  are zero after some step, a course nonempty at every generation and a course empty from some
  generation on have its terms at every step (`Horizon.eventually_zero_two_fates`: from the
  last nonempty generation through `H`, found by counting down). Joined
  (`Horizon.terms_boundary`, a restatement of `never_empties_of_unbounded` and
  `eventually_zero_two_fates`, not a further result): for a course nonempty at its first
  generation, terms positive at unboundedly many steps are shared only by courses nonempty at
  every generation, and terms zero after some step are shared by a course that goes on and one
  that ends. Every course of terms falls in one of the two cases only classically; deciding
  which, and finding the `H` of the second case, is not proved here.
* **Positive while it lasts, but for the last generation, and then empty.** For every `N`, a
  course whose family shrinks by one at every step, a marked member having as many offspring as
  the family less one and the others none, has a positive concordance of offspring number with
  the mark at every step before `N`, a nonempty family through `N` with a mark total of one, a
  zero term at `N` (as `last_term_zero` requires) and is empty from `N + 1` on
  (`Shrinking.positive_then_empty`): selection favours the marked member at every step but
  the last while the family ends.

Modelling choices: discrete generations; natural-number weights, amounts and offspring numbers;
finite families as lists, with "goes on" read as nonempty families at every later step and
"ends" as empty families from some step on (so a line whose descendants change kind, or a
revival, is not distinguished here); in the exception, the reading by offspring number and exact
transmission of it at every step from `t` on; in `Horizon.going`, and in `Horizon.goingShifted`
at `H` and after it, a member's added offspring is the member's own label, which is all
`Generations` sees (newness is not represented); "same terms" (`SameTerms`) compares
concordance and discordance only, each against its own course's amounts. The boundary is
stated as two cases, not as a decision between them. Nothing is supposed about what the members
are or how the offspring come about, and no activity predicate occurs. No ethical predicate,
ranking or axiom occurs; every declaration has an empty axiom report.
-/

namespace Becoming

namespace SelectionShift

open SelectionTerm

variable {α : Type}

/-! ## Lists -/

/-- An offspring of a member is in the next family. -/
theorem mem_flatMap_of {f : α → List α} {p k : α} :
    ∀ {ps : List α}, p ∈ ps → k ∈ f p → k ∈ ps.flatMap f
  | _ :: ps, .head _, mk => mem_append_of_left (ps.flatMap f) mk
  | q :: _, .tail _ mp, mk => mem_append_of_right (f q) (mem_flatMap_of mp mk)

/-- Each member leaving one like itself leaves the list as it is. -/
theorem flatMap_singleton : ∀ l : List α, l.flatMap (fun p => [p]) = l
  | [] => rfl
  | p :: l => congrArg (p :: ·) (flatMap_singleton l)

/-- Each member leaving nothing leaves nothing. -/
theorem flatMap_empty : ∀ l : List α, l.flatMap (fun _ => ([] : List α)) = []
  | [] => rfl
  | _ :: l => flatMap_empty l

/-! ## A common shift -/

theorem mul_excess_congr {c x x' y y' : Nat} (first : x' = x) (second : y' = y) :
    c * excess x' y' = c * excess x y :=
  first ▸ second ▸ rfl

/-- Weights shifted at every member by a common `k`, and amounts alike, leave concordance
unchanged. -/
theorem concord_shifted {ps : List α} {w w' a a' : α → Nat} {k : Nat}
    (shift : ∀ p, p ∈ ps → w' p = w p + k) (same : ∀ p, p ∈ ps → a' p = a p) :
    concord ps w' a' = concord ps w a :=
  total_congr_on fun p mp => total_congr_on fun q mq =>
    (congr (congrArg (fun x y => excess x y * excess (a' p) (a' q)) (shift p mp))
        (shift q mq)).trans
      ((congrArg (· * excess (a' p) (a' q)) (excess_add_right (w p) (w q) k)).trans
        (mul_excess_congr (same p mp) (same q mq)))

/-- And discordance. -/
theorem discord_shifted {ps : List α} {w w' a a' : α → Nat} {k : Nat}
    (shift : ∀ p, p ∈ ps → w' p = w p + k) (same : ∀ p, p ∈ ps → a' p = a p) :
    discord ps w' a' = discord ps w a :=
  total_congr_on fun p mp => total_congr_on fun q mq =>
    (congr (congrArg (fun x y => excess x y * excess (a' q) (a' p)) (shift p mp))
        (shift q mq)).trans
      ((congrArg (· * excess (a' q) (a' p)) (excess_add_right (w p) (w q) k)).trans
        (mul_excess_congr (same q mq) (same p mp)))

/-- **Shift invariance.** Adding a common number to every weight leaves concordance with any
amount unchanged. -/
theorem concord_shift (ps : List α) (w a : α → Nat) (k : Nat) :
    concord ps (fun p => w p + k) a = concord ps w a :=
  concord_shifted (fun _ _ => rfl) (fun _ _ => rfl)

theorem discord_shift (ps : List α) (w a : α → Nat) (k : Nat) :
    discord ps (fun p => w p + k) a = discord ps w a :=
  discord_shifted (fun _ _ => rfl) (fun _ _ => rfl)

/-- Adding a common number to every amount leaves concordance unchanged. -/
theorem concord_shift_amount (ps : List α) (w a : α → Nat) (k : Nat) :
    concord ps w (fun p => a p + k) = concord ps w a :=
  total_congr (fun p => total_congr (fun q =>
    congrArg (excess (w p) (w q) * ·) (excess_add_right (a p) (a q) k)) ps) ps

theorem discord_shift_amount (ps : List α) (w a : α → Nat) (k : Nat) :
    discord ps w (fun p => a p + k) = discord ps w a :=
  total_congr (fun p => total_congr (fun q =>
    congrArg (excess (w p) (w q) * ·) (excess_add_right (a q) (a p) k)) ps) ps

/-- The total weight is not invariant: shifted by `k` at every member, it moves by `k` for each
member. -/
theorem total_shifted {ps : List α} {w w' : α → Nat} {k : Nat}
    (shift : ∀ p, p ∈ ps → w' p = w p + k) :
    total ps w' = total ps w + ps.length * k :=
  (total_congr_on shift).trans
    ((total_add w (fun _ => k) ps).trans (congrArg (total ps w + ·) (total_const k ps)))

/-- Nor is the weighted total: it moves by `k` times the total amount. -/
theorem weighted_shift (ps : List α) (w a : α → Nat) (k : Nat) :
    weighted ps (fun p => w p + k) a = weighted ps w a + k * total ps a :=
  (total_congr (fun p => add_mul_split (w p) k (a p)) ps).trans
    ((total_add (fun p => w p * a p) (fun p => k * a p) ps).trans
      (congrArg (weighted ps w a + ·) (total_mul k a ps)))

/-! ## What a positive term needs -/

/-- **Positive concordance means variation.** Concordance of a weight with any amount is
positive only where the weight varies over the list: two members, the one's weight below the
other's. -/
theorem weight_varies_of_concord {ps : List α} {w a : α → Nat} (pos : 0 < concord ps w a) :
    ∃ p q, p ∈ ps ∧ q ∈ ps ∧ w q < w p :=
  match total_pos (q := fun p => total ps fun q => excess (w p) (w q) * excess (a p) (a q))
      ps pos with
  | ⟨p, mp, inner⟩ =>
    match total_pos (q := fun q => excess (w p) (w q) * excess (a p) (a q)) ps inner with
    | ⟨q, mq, product⟩ => ⟨p, q, mp, mq, excess_pos.mp (pos_of_mul_pos product)⟩

/-- And positive discordance. -/
theorem weight_varies_of_discord {ps : List α} {w a : α → Nat} (pos : 0 < discord ps w a) :
    ∃ p q, p ∈ ps ∧ q ∈ ps ∧ w q < w p :=
  match total_pos (q := fun p => total ps fun q => excess (w p) (w q) * excess (a q) (a p))
      ps pos with
  | ⟨p, mp, inner⟩ =>
    match total_pos (q := fun q => excess (w p) (w q) * excess (a q) (a p)) ps inner with
    | ⟨q, mq, product⟩ => ⟨p, q, mp, mq, excess_pos.mp (pos_of_mul_pos product)⟩

/-- A weight that varies over a list is positive at some member. -/
theorem pos_weight_of_varies {ps : List α} {w : α → Nat} :
    (∃ p q, p ∈ ps ∧ q ∈ ps ∧ w q < w p) → ∃ p, p ∈ ps ∧ 0 < w p
  | ⟨p, q, mp, _, lt⟩ => ⟨p, mp, Nat.lt_of_le_of_lt (Nat.zero_le (w q)) lt⟩

theorem pos_weight_of_concord {ps : List α} {w a : α → Nat} (pos : 0 < concord ps w a) :
    ∃ p, p ∈ ps ∧ 0 < w p :=
  pos_weight_of_varies (weight_varies_of_concord pos)

theorem pos_weight_of_discord {ps : List α} {w a : α → Nat} (pos : 0 < discord ps w a) :
    ∃ p, p ∈ ps ∧ 0 < w p :=
  pos_weight_of_varies (weight_varies_of_discord pos)

namespace Generations

variable {G G' : SelectionTerm.Generations α}

/-- **Shift invariance over a step.** Two families alike at a step in members and amounts,
whose offspring numbers differ at every member by a common `k`, have the same concordance and
discordance at that step, while the next generation of the one is larger by `k` for each
member. -/
theorem shift_step {t k : Nat} (family : G'.family t = G.family t)
    (amount : ∀ p, p ∈ G.family t → G'.amount t p = G.amount t p)
    (shift : ∀ p, p ∈ G.family t → G'.offspringNumber t p = G.offspringNumber t p + k) :
    G'.concordAt t = G.concordAt t ∧ G'.discordAt t = G.discordAt t ∧
      G'.size (t + 1) = G.size (t + 1) + G.size t * k :=
  ⟨(congrArg (fun l => concord l (G'.offspringNumber t) (G'.amount t)) family).trans
      (concord_shifted shift amount),
    (congrArg (fun l => discord l (G'.offspringNumber t) (G'.amount t)) family).trans
      (discord_shifted shift amount),
    (G'.born_eq t).symm.trans
      ((congrArg (fun l => total l (G'.offspringNumber t)) family).trans
        ((total_shifted shift).trans (congrArg (· + G.size t * k) (G.born_eq t))))⟩

/-- A positive selection term proper at a step, concordance or discordance with any amount,
means offspring numbers vary there: two members of the family, the one with fewer offspring
than the other. -/
theorem varies_of_selection {t : Nat} (pos : 0 < G.concordAt t ∨ 0 < G.discordAt t) :
    ∃ p q, p ∈ G.family t ∧ q ∈ G.family t ∧
      G.offspringNumber t q < G.offspringNumber t p :=
  match pos with
  | .inl concordant => weight_varies_of_concord concordant
  | .inr discordant => weight_varies_of_discord discordant

/-- So a member of the family has at least one offspring. -/
theorem reproducing_of_selection {t : Nat} (pos : 0 < G.concordAt t ∨ 0 < G.discordAt t) :
    ∃ p, p ∈ G.family t ∧ 0 < G.offspringNumber t p :=
  pos_weight_of_varies (varies_of_selection pos)

/-- A member with at least one offspring makes the next generation nonempty. -/
theorem next_of_reproducing {t : Nat} {p : α} (mp : p ∈ G.family t)
    (pos : 0 < G.offspringNumber t p) : 0 < G.size (t + 1) :=
  match Reproduction.exists_mem_of_length_pos pos with
  | ⟨_, mk⟩ => length_pos_of_mem (mem_flatMap_of (f := G.kids t) mp mk)

/-- A positive selection term proper at a step makes the next generation nonempty. -/
theorem next_of_selection {t : Nat} (pos : 0 < G.concordAt t ∨ 0 < G.discordAt t) :
    0 < G.size (t + 1) :=
  match reproducing_of_selection pos with
  | ⟨_, mp, positive⟩ => next_of_reproducing mp positive

/-- **At a last generation the term is zero.** Where the next generation is empty, concordance
and discordance at the step are zero. -/
theorem last_term_zero {t : Nat} (empty : G.size (t + 1) = 0) :
    G.concordAt t = 0 ∧ G.discordAt t = 0 :=
  ⟨eq_zero_of_not_pos fun pos =>
      Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le (next_of_selection (.inl pos)) (Nat.le_of_eq empty)),
    eq_zero_of_not_pos fun pos =>
      Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le (next_of_selection (.inr pos)) (Nat.le_of_eq empty))⟩

/-- **A term positive at every step decides.** A selection term proper positive at every step
forces every generation after the first to be nonempty. -/
theorem never_empties (pos : ∀ t, 0 < G.concordAt t ∨ 0 < G.discordAt t) :
    ∀ t, 0 < G.size (t + 1) :=
  fun t => next_of_selection (pos t)

/-- **Positive while it lasts, so it lasts.** A nonempty first generation, with a selection term
proper positive at every step whose family is nonempty, forces every generation to be nonempty:
no course has a term positive at every generation while it lasts and ends. -/
theorem never_empties_while (first : 0 < G.size 0)
    (pos : ∀ t, 0 < G.size t → 0 < G.concordAt t ∨ 0 < G.discordAt t) : ∀ t, 0 < G.size t
  | 0 => first
  | t + 1 => next_of_selection (pos t (never_empties_while first pos t))

/-- An empty family stays empty: a generation nonempty at `s` means every earlier one is. -/
theorem nonempty_before {t s : Nat} (le : t ≤ s) (pos : 0 < G.size s) : 0 < G.size t :=
  Nat.pos_of_ne_zero fun zero =>
    match Nat.le.dest le with
    | ⟨d, eq⟩ =>
      Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le pos (Nat.le_of_eq
        ((congrArg G.size eq).symm.trans (Reproduction.Generations.empty_from zero d))))

/-- **A term positive at unboundedly many steps decides.** Where past every step there is a
later one at which the selection term proper is positive, every generation is nonempty, the
first included. -/
theorem never_empties_of_unbounded
    (pos : ∀ t, ∃ s, t ≤ s ∧ (0 < G.concordAt s ∨ 0 < G.discordAt s)) :
    ∀ t, 0 < G.size t := fun t =>
  match pos t with
  | ⟨_, le, positive⟩ => nonempty_before (Nat.le_succ_of_le le) (next_of_selection positive)

/-- **The line of exact transmission.** Read by offspring number, with exact transmission at
every step from `t` on, a member of the family at `t` with a positive offspring number keeps a line
carrying that offspring number: at every later generation some member has it. -/
theorem line_kept (number : Reproduction.Generations.ByNumber G) {t : Nat}
    (exact : ∀ s, t ≤ s → Exact (G.family s) (G.kids s) (G.amount s) (G.amount (s + 1)))
    {p : α} (mp : p ∈ G.family t) (pos : 0 < G.offspringNumber t p) :
    ∀ n, ∃ q, q ∈ G.family (t + n) ∧ G.offspringNumber (t + n) q = G.offspringNumber t p
  | 0 => ⟨p, mp, rfl⟩
  | n + 1 =>
    match line_kept number exact mp pos n with
    | ⟨q, mq, same⟩ =>
      match Reproduction.exists_mem_of_length_pos (l := G.kids (t + n) q)
          (Nat.lt_of_lt_of_le pos (Nat.le_of_eq same.symm)) with
      | ⟨k, mk⟩ =>
        ⟨k, mem_flatMap_of mq mk,
          (number (t + n + 1) k).symm.trans
            ((exact (t + n) (Nat.le_add_right t n) q mq k mk).trans
              ((number (t + n) q).trans same))⟩

/-- So, read by offspring number with exact transmission at every step from `t` on, every later
generation is nonempty exactly where the one after `t` is. -/
theorem goes_on_iff (number : Reproduction.Generations.ByNumber G) {t : Nat}
    (exact : ∀ s, t ≤ s → Exact (G.family s) (G.kids s) (G.amount s) (G.amount (s + 1))) :
    (∀ n, 0 < G.size (t + n + 1)) ↔ 0 < G.size (t + 1) :=
  ⟨fun all => all 0, fun next n =>
    match Reproduction.exists_mem_of_length_pos next with
    | ⟨_, mk⟩ =>
      match Reproduction.mem_flatMap_cases (f := G.kids t) mk with
      | ⟨_, mp, mkp⟩ =>
        match line_kept number exact mp (length_pos_of_mem mkp) n with
        | ⟨_, mq, same⟩ =>
          next_of_reproducing mq
            (Nat.lt_of_lt_of_le (length_pos_of_mem mkp) (Nat.le_of_eq same.symm))⟩

/-- **The exception.** Read by offspring number with exact transmission at every step from `t`
on, a positive selection term proper at `t` (concordance of offspring number with itself)
forces every later generation to be nonempty, and in each a member has at least one
offspring. -/
theorem goes_on (number : Reproduction.Generations.ByNumber G) {t : Nat}
    (exact : ∀ s, t ≤ s → Exact (G.family s) (G.kids s) (G.amount s) (G.amount (s + 1)))
    (pos : 0 < G.concordAt t) :
    (∀ n, ∃ q, q ∈ G.family (t + n) ∧ 0 < G.offspringNumber (t + n) q) ∧
      ∀ n, 0 < G.size (t + n + 1) :=
  match reproducing_of_selection (.inl pos) with
  | ⟨_, mp, positive⟩ =>
    have line : ∀ n, ∃ q, q ∈ G.family (t + n) ∧ 0 < G.offspringNumber (t + n) q := fun n =>
      match line_kept number exact mp positive n with
      | ⟨q, mq, same⟩ => ⟨q, mq, Nat.lt_of_lt_of_le positive (Nat.le_of_eq same.symm)⟩
    ⟨line, fun n => match line n with
      | ⟨_, mq, positive⟩ => next_of_reproducing mq positive⟩

end Generations

/-! ## Witnesses -/

namespace OneLine

/-- One like itself for a marked member, nothing for the other. -/
def keepsOne : Bool → List Bool
  | true => [true]
  | false => []

/-- A marked member beside an unmarked one; each step as `keepsOne`, read by offspring
number. -/
def course : SelectionTerm.Generations Bool where
  first := [true, false]
  kids _ := keepsOne
  amount _ p := (keepsOne p).length

/-- **The premises of the exception hold together.** `course` is read by offspring number, is
exact at every step from the first on, and is concordant at the first; so it goes on. -/
theorem goes_on_premises :
    Reproduction.Generations.ByNumber course ∧
      (∀ s, 0 ≤ s → Exact (course.family s) (course.kids s) (course.amount s)
        (course.amount (s + 1))) ∧
      0 < course.concordAt 0 ∧
      ((∀ n, ∃ q, q ∈ course.family (0 + n) ∧ 0 < course.offspringNumber (0 + n) q) ∧
        ∀ n, 0 < course.size (0 + n + 1)) :=
  have number : Reproduction.Generations.ByNumber course := fun _ _ => rfl
  have exact : ∀ s, 0 ≤ s → Exact (course.family s) (course.kids s) (course.amount s)
      (course.amount (s + 1)) := fun _ _ p _ k mk =>
    match p, mk with
    | true, mk => by
      have same : k = true := ListTests.mem_singleton_iff.mp mk
      subst same
      rfl
    | false, mk => nomatch (mk : k ∈ ([] : List Bool))
  have pos : 0 < course.concordAt 0 := by decide
  ⟨number, exact, pos, Generations.goes_on number exact pos⟩

/-- As `course`, with two more offspring for each member at every step; the amounts are
`course`'s. -/
def shifted : SelectionTerm.Generations Bool where
  first := [true, false]
  kids _ p := if p then [true, true, true] else [false, false]
  amount := course.amount

/-- **The premises of a common shift hold together, with `k` positive.** At the first step,
`shifted` has `course`'s family and amounts, and offspring numbers two more at every member; so
its terms there are `course`'s and its next generation is larger by two for each member. -/
theorem shift_step_premises :
    shifted.family 0 = course.family 0 ∧
      (∀ p, p ∈ course.family 0 → shifted.amount 0 p = course.amount 0 p) ∧
      (∀ p, p ∈ course.family 0 →
        shifted.offspringNumber 0 p = course.offspringNumber 0 p + 2) ∧
      (shifted.concordAt 0 = course.concordAt 0 ∧ shifted.discordAt 0 = course.discordAt 0 ∧
        shifted.size 1 = course.size 1 + course.size 0 * 2) :=
  have family : shifted.family 0 = course.family 0 := rfl
  have amount : ∀ p, p ∈ course.family 0 → shifted.amount 0 p = course.amount 0 p :=
    fun _ _ => rfl
  have shift : ∀ p, p ∈ course.family 0 →
      shifted.offspringNumber 0 p = course.offspringNumber 0 p + 2 := fun p _ =>
    match p with
    | true => rfl
    | false => rfl
  ⟨family, amount, shift, Generations.shift_step family amount shift⟩

end OneLine

namespace ExactOnce

/-- At the first step as `OneLine.keepsOne`; at the second, each member leaves one unmarked
member; from the third on, nothing. -/
def kids : Nat → Bool → List Bool
  | 0 => OneLine.keepsOne
  | 1 => fun _ => [false]
  | _ + 2 => fun _ => []

/-- A marked member beside an unmarked one, each step as `kids`, read by offspring number. -/
def course : SelectionTerm.Generations Bool where
  first := [true, false]
  kids := kids
  amount t p := (kids t p).length

/-- Witness lemma for `exact_once_ends`: `course` is exact at step 0. -/
theorem exact_first :
    Exact (course.family 0) (course.kids 0) (course.amount 0) (course.amount 1) :=
  fun p _ k mk =>
    match p, mk with
    | true, mk => by
      have same : k = true := ListTests.mem_singleton_iff.mp mk
      subst same
      rfl
    | false, mk => nomatch (mk : k ∈ ([] : List Bool))

/-- Witness lemma for `exact_once_ends`: `course` is not exact at step 1 (the marked member
leaves one offspring, which leaves none). -/
theorem not_exact_second :
    ¬ Exact (course.family 1) (course.kids 1) (course.amount 1) (course.amount 2) :=
  fun exact =>
    have parent : true ∈ course.family 1 := List.Mem.head []
    have child : false ∈ course.kids 1 true := List.Mem.head []
    Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le (Nat.succ_pos 0)
      (Nat.le_of_eq (exact true parent false child).symm))

/-- Witness lemma for `exact_once_ends`: offspring number concords with itself at step 0. -/
theorem concord_first : 0 < course.concordAt 0 := by decide

/-- Witness lemma for `exact_once_ends`: generation 3 is empty. -/
theorem size_three : course.size 3 = 0 := rfl

/-- **Witness: exactness at `t` alone does not give going on.** `course` is read by offspring
number, is exact at step 0 and not at step 1, and is concordant at step 0; it is one member at
generations 1 and 2 and empty from generation 3 on, so the conclusion of `Generations.goes_on`
at `t = 0` fails. A witness lemma: it shows that `goes_on`'s premise of
exactness at every step from `t` on cannot be narrowed to exactness at `t`. -/
theorem exact_once_ends :
    Reproduction.Generations.ByNumber course ∧
      Exact (course.family 0) (course.kids 0) (course.amount 0) (course.amount 1) ∧
      ¬ Exact (course.family 1) (course.kids 1) (course.amount 1) (course.amount 2) ∧
      0 < course.concordAt 0 ∧
      (course.size 1 = 1 ∧ course.size 2 = 1) ∧
      (∀ n, course.size (3 + n) = 0) ∧
      ¬ (∀ n, 0 < course.size (0 + n + 1)) :=
  ⟨fun _ _ => rfl, exact_first, not_exact_second, concord_first, ⟨rfl, rfl⟩,
    Reproduction.Generations.empty_from size_three,
    fun all => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le (all 2) (Nat.le_of_eq size_three))⟩

end ExactOnce

namespace ZeroTerm

/-- One member, one offspring at every step, read by its offspring number. -/
def oneEach : SelectionTerm.Generations Unit where
  first := [()]
  kids _ _ := [()]
  amount _ _ := 1

/-- One member, no offspring, read by its offspring number. -/
def noneEach : SelectionTerm.Generations Unit where
  first := [()]
  kids _ _ := []
  amount _ _ := 0

theorem oneEach_family : ∀ t, oneEach.family t = [()]
  | 0 => rfl
  | t + 1 => by
    show (oneEach.family t).flatMap (oneEach.kids t) = [()]
    rw [oneEach_family t]
    rfl

/-- Read by offspring number with exact transmission, one offspring each and none each have no
concordance and no discordance at any step; the first is one member at every generation, the
second is empty from the first step on. -/
theorem decides_nothing :
    Reproduction.Generations.ByNumber oneEach ∧ Reproduction.Generations.ByNumber noneEach ∧
      (∀ t, Exact (oneEach.family t) (oneEach.kids t) (oneEach.amount t)
        (oneEach.amount (t + 1))) ∧
      (∀ t, Exact (noneEach.family t) (noneEach.kids t) (noneEach.amount t)
        (noneEach.amount (t + 1))) ∧
      (∀ t, oneEach.concordAt t = 0 ∧ oneEach.discordAt t = 0) ∧
      (∀ t, noneEach.concordAt t = 0 ∧ noneEach.discordAt t = 0) ∧
      (∀ t, oneEach.size t = 1) ∧ (∀ n, noneEach.size (n + 1) = 0) :=
  ⟨fun _ _ => rfl, fun _ _ => rfl, fun _ _ _ _ _ => rfl,
    fun _ _ _ _ (mem : _ ∈ ([] : List Unit)) => (nomatch mem),
    fun _ => ⟨concord_uniform (k := 1) (fun _ _ => rfl) _,
      discord_uniform (k := 1) (fun _ _ => rfl) _⟩,
    fun _ => ⟨concord_uniform (k := 0) (fun _ _ => rfl) _,
      discord_uniform (k := 0) (fun _ _ => rfl) _⟩,
    fun t => congrArg List.length (oneEach_family t),
    fun n => (congrArg noneEach.size (Nat.add_comm n 1)).trans
      (Reproduction.Generations.empty_from (G := noneEach) (t := 1) rfl n)⟩

end ZeroTerm

/-- Two courses have the same terms: at every step, the same concordance and the same
discordance. -/
def SameTerms (G G' : SelectionTerm.Generations α) : Prop :=
  ∀ t, G'.concordAt t = G.concordAt t ∧ G'.discordAt t = G.discordAt t

/-! ## Two fates within a horizon -/

namespace Horizon

/-- `G`'s offspring at every step through `H`; after `H`, each member leaves `after`. -/
def keep (G : SelectionTerm.Generations α) (H : Nat) (after : α → List α) :
    SelectionTerm.Generations α where
  first := G.first
  kids t := if t ≤ H then G.kids t else after
  amount := G.amount

/-- After `H`, each member leaves one like itself. -/
def going (G : SelectionTerm.Generations α) (H : Nat) : SelectionTerm.Generations α :=
  keep G H fun p => [p]

/-- After `H`, each member leaves nothing. -/
def ending (G : SelectionTerm.Generations α) (H : Nat) : SelectionTerm.Generations α :=
  keep G H fun _ => []

variable {G : SelectionTerm.Generations α} {H : Nat} {after : α → List α}

theorem keep_kids {t : Nat} (le : t ≤ H) : (keep G H after).kids t = G.kids t :=
  if_pos le

theorem keep_kids_after {t : Nat} (gt : ¬ t ≤ H) : (keep G H after).kids t = after :=
  if_neg gt

/-- Through `H + 1`, the families are `G`'s. -/
theorem keep_family : ∀ t, t ≤ H + 1 → (keep G H after).family t = G.family t
  | 0, _ => rfl
  | t + 1, le =>
    have below : t ≤ H := Nat.le_of_succ_le_succ le
    show ((keep G H after).family t).flatMap ((keep G H after).kids t) =
        (G.family t).flatMap (G.kids t) from
    (congrArg (fun l => l.flatMap ((keep G H after).kids t))
        (keep_family t (Nat.le_succ_of_le below))).trans
      (congrArg (fun k => (G.family t).flatMap k) (keep_kids below))

/-- Through `H`, the terms are `G`'s. -/
theorem keep_terms {t : Nat} (le : t ≤ H) :
    (keep G H after).concordAt t = G.concordAt t ∧ (keep G H after).discordAt t = G.discordAt t :=
  have family : (keep G H after).family t = G.family t := keep_family t (Nat.le_succ_of_le le)
  have kids : (keep G H after).kids t = G.kids t := keep_kids le
  ⟨show concord ((keep G H after).family t) (fun p => ((keep G H after).kids t p).length)
        (G.amount t) = concord (G.family t) (fun p => (G.kids t p).length) (G.amount t) by
      rw [family, kids],
    show discord ((keep G H after).family t) (fun p => ((keep G H after).kids t p).length)
        (G.amount t) = discord (G.family t) (fun p => (G.kids t p).length) (G.amount t) by
      rw [family, kids]⟩

/-- After `H`, where every member leaves as many as every other, there are no terms. -/
theorem keep_terms_after {t k : Nat} (gt : ¬ t ≤ H) (same : ∀ p, (after p).length = k) :
    (keep G H after).concordAt t = 0 ∧ (keep G H after).discordAt t = 0 :=
  have number : ∀ p, p ∈ (keep G H after).family t →
      (keep G H after).offspringNumber t p = k := fun p _ =>
    (congrArg (fun f => (f p).length) (keep_kids_after (G := G) (after := after) gt)).trans
      (same p)
  ⟨concord_uniform number _, discord_uniform number _⟩

theorem not_le_after (n : Nat) : ¬ H + 1 + n ≤ H := fun le =>
  Nat.lt_irrefl H (Nat.lt_of_lt_of_le
    (Nat.lt_of_lt_of_le (Nat.lt_succ_self H) (Nat.le_add_right (H + 1) n)) le)

/-- From `H + 1` on, `going`'s families are `G`'s at `H + 1`. -/
theorem going_family : ∀ n, (going G H).family (H + 1 + n) = G.family (H + 1)
  | 0 => keep_family (H + 1) (Nat.le_refl _)
  | n + 1 =>
    show ((going G H).family (H + 1 + n)).flatMap ((going G H).kids (H + 1 + n)) =
        G.family (H + 1) from
    (congrArg (fun l => l.flatMap ((going G H).kids (H + 1 + n))) (going_family n)).trans
      ((congrArg (fun k => (G.family (H + 1)).flatMap k)
          (keep_kids_after (G := G) (after := fun p => [p]) (not_le_after n))).trans
        (flatMap_singleton _))

/-- From `H + 2` on, `ending` is empty. -/
theorem ending_empty : ∀ n, (ending G H).size (H + 2 + n) = 0 :=
  Reproduction.Generations.empty_from (G := ending G H) (t := H + 2)
    (congrArg List.length
      (show ((ending G H).family (H + 1)).flatMap ((ending G H).kids (H + 1)) = [] from
      (congrArg (fun l => l.flatMap ((ending G H).kids (H + 1)))
          (keep_family (H + 1) (Nat.le_refl _))).trans
        ((congrArg (fun k => (G.family (H + 1)).flatMap k)
            (keep_kids_after (G := G) (after := fun _ => []) (not_le_after 0))).trans
          (flatMap_empty _))))

/-- **Within any horizon, the course of selection terms does not decide a fate.** For every
course of generations `G` and horizon `H`: `going G H` and `ending G H` have `G`'s families
through `H + 1`, its offspring at every step through `H` and its amounts at every step, so
`G`'s concordance and discordance at every step through `H`; they have the same concordance and
the same discordance at every step; every generation of `going G H` from `H + 1` on is as large
as `G`'s at `H + 1`; `ending G H` is empty from `H + 2` on. No premise. -/
theorem same_terms_two_fates (G : SelectionTerm.Generations α) (H : Nat) :
    (∀ t, t ≤ H + 1 →
      (going G H).family t = G.family t ∧ (ending G H).family t = G.family t) ∧
    (∀ t, t ≤ H → (going G H).kids t = G.kids t ∧ (ending G H).kids t = G.kids t) ∧
    (∀ t, (going G H).amount t = G.amount t ∧ (ending G H).amount t = G.amount t) ∧
    (∀ t, t ≤ H → (going G H).concordAt t = G.concordAt t ∧
      (going G H).discordAt t = G.discordAt t) ∧
    (∀ t, (ending G H).concordAt t = (going G H).concordAt t ∧
      (ending G H).discordAt t = (going G H).discordAt t) ∧
    (∀ n, (going G H).size (H + 1 + n) = G.size (H + 1)) ∧
    (∀ n, (ending G H).size (H + 2 + n) = 0) :=
  ⟨fun t le => ⟨keep_family t le, keep_family t le⟩,
    fun _ le => ⟨keep_kids le, keep_kids le⟩,
    fun _ => ⟨rfl, rfl⟩,
    fun _ le => keep_terms le,
    fun t => match Nat.decLe t H with
      | .isTrue le =>
        ⟨(keep_terms (G := G) (after := fun _ => []) le).1.trans
            (keep_terms (G := G) (after := fun p => [p]) le).1.symm,
          (keep_terms (G := G) (after := fun _ => []) le).2.trans
            (keep_terms (G := G) (after := fun p => [p]) le).2.symm⟩
      | .isFalse gt =>
        ⟨(keep_terms_after (G := G) (after := fun _ => []) (k := 0) gt fun _ => rfl).1.trans
            (keep_terms_after (G := G) (after := fun p => [p]) (k := 1) gt fun _ => rfl).1.symm,
          (keep_terms_after (G := G) (after := fun _ => []) (k := 0) gt fun _ => rfl).2.trans
            (keep_terms_after (G := G) (after := fun p => [p]) (k := 1) gt
              fun _ => rfl).2.symm⟩,
    fun n => congrArg List.length (going_family n),
    ending_empty⟩

/-- Where `G`'s generation `H + 1` is nonempty, `going G H` is nonempty at every generation from
`H + 1` on. -/
theorem going_goes_on (next : 0 < G.size (H + 1)) : ∀ n, 0 < (going G H).size (H + 1 + n) :=
  fun n => Nat.lt_of_lt_of_le next (Nat.le_of_eq (congrArg List.length (going_family n)).symm)

/-- So where `G`'s selection term proper at `H` is positive. -/
theorem going_goes_on_of_selection (pos : 0 < G.concordAt H ∨ 0 < G.discordAt H) :
    ∀ n, 0 < (going G H).size (H + 1 + n) :=
  going_goes_on (Generations.next_of_selection pos)

/-- A marked member leaves itself and an unmarked one; the unmarked one leaves nothing. -/
def markedPair : Bool → List Bool
  | true => [true, false]
  | false => []

/-- The amount carried: one unit or none. -/
def carried : Bool → Nat
  | true => 1
  | false => 0

/-- A marked member beside an unmarked one, each step as `markedPair`: positive concordance of
offspring number with the mark at every step. -/
def steady : SelectionTerm.Generations Bool where
  first := [true, false]
  kids _ := markedPair
  amount _ := carried

theorem steady_family : ∀ t, steady.family t = [true, false]
  | 0 => rfl
  | t + 1 =>
    show (steady.family t).flatMap markedPair = [true, false] from
    (congrArg (fun l => l.flatMap markedPair) (steady_family t)).trans rfl

theorem steady_terms (t : Nat) : steady.concordAt t = 2 ∧ steady.discordAt t = 0 :=
  ⟨(congrArg (fun l => concord l (steady.offspringNumber t) carried) (steady_family t)).trans rfl,
    (congrArg (fun l => discord l (steady.offspringNumber t) carried) (steady_family t)).trans
      rfl⟩

/-- **A term positive at every step, and the courses sharing it through a horizon.** `steady`
concords by two and discords by nothing at every step, and so is nonempty at every generation
after the first, as `never_empties` requires; for every `H`, `ending steady H` and
`going steady H` concord by two and discord by nothing at every step through `H` and have the
same terms at every step; `going steady H` is two members at every generation from `H + 1` on,
`ending steady H` empty from `H + 2` on. -/
theorem steady_two_fates (H : Nat) :
    (∀ t, steady.concordAt t = 2 ∧ steady.discordAt t = 0) ∧
    (∀ t, 0 < steady.size (t + 1)) ∧
    (∀ t, t ≤ H → (ending steady H).concordAt t = 2 ∧ (ending steady H).discordAt t = 0) ∧
    (∀ t, (ending steady H).concordAt t = (going steady H).concordAt t ∧
      (ending steady H).discordAt t = (going steady H).discordAt t) ∧
    (∀ n, (going steady H).size (H + 1 + n) = 2) ∧
    (∀ n, (ending steady H).size (H + 2 + n) = 0) :=
  have law := same_terms_two_fates steady H
  ⟨steady_terms,
    Generations.never_empties fun t =>
      .inl (Nat.lt_of_lt_of_le (Nat.succ_pos 1) (Nat.le_of_eq (steady_terms t).1.symm)),
    fun t le => ⟨(keep_terms (G := steady) (after := fun _ => []) le).1.trans (steady_terms t).1,
      (keep_terms (G := steady) (after := fun _ => []) le).2.trans (steady_terms t).2⟩,
    law.2.2.2.2.1,
    fun n => (law.2.2.2.2.2.1 n).trans (congrArg List.length (steady_family (H + 1))),
    law.2.2.2.2.2.2⟩

/-! ### Shifted at the horizon -/

/-- `G`, but at `H` each member leaves one more: a copy of itself. -/
def shiftAt (G : SelectionTerm.Generations α) (H : Nat) : SelectionTerm.Generations α where
  first := G.first
  kids t := if t = H then (fun p => G.kids H p ++ [p]) else G.kids t
  amount := G.amount

/-- `shiftAt G H` through `H`; after `H`, each member leaves one like itself. -/
def goingShifted (G : SelectionTerm.Generations α) (H : Nat) : SelectionTerm.Generations α :=
  going (shiftAt G H) H

theorem shiftAt_family : ∀ t, t ≤ H → (shiftAt G H).family t = G.family t
  | 0, _ => rfl
  | t + 1, le =>
    have kids : (shiftAt G H).kids t = G.kids t := if_neg (Nat.ne_of_lt le)
    show ((shiftAt G H).family t).flatMap ((shiftAt G H).kids t) =
        (G.family t).flatMap (G.kids t) from
    (congrArg (fun l => l.flatMap ((shiftAt G H).kids t))
        (shiftAt_family t (Nat.le_of_succ_le le))).trans
      (congrArg (fun k => (G.family t).flatMap k) kids)

/-- At `H`, `shiftAt G H` has `G`'s family and amounts and offspring numbers one more at every
member, so `G`'s terms, and its next generation is `G`'s and one more for each member. -/
theorem shiftAt_step :
    (shiftAt G H).concordAt H = G.concordAt H ∧ (shiftAt G H).discordAt H = G.discordAt H ∧
      (shiftAt G H).size (H + 1) = G.size (H + 1) + G.size H * 1 :=
  Generations.shift_step (G' := shiftAt G H) (G := G) (t := H) (k := 1)
    (shiftAt_family H (Nat.le_refl H)) (fun _ _ => rfl) fun p _ =>
      (congrArg (fun f => (f p).length)
          (if_pos rfl : (shiftAt G H).kids H = fun p => G.kids H p ++ [p])).trans
        (ListTests.length_append (G.kids H p) [p])

/-- Through `H`, the terms of `shiftAt G H` are `G`'s. -/
theorem shiftAt_terms {t : Nat} (le : t ≤ H) :
    (shiftAt G H).concordAt t = G.concordAt t ∧ (shiftAt G H).discordAt t = G.discordAt t :=
  match Nat.lt_or_ge t H with
  | .inl lt =>
    have family : (shiftAt G H).family t = G.family t := shiftAt_family t le
    have kids : (shiftAt G H).kids t = G.kids t := if_neg (Nat.ne_of_lt lt)
    ⟨show concord ((shiftAt G H).family t) (fun p => ((shiftAt G H).kids t p).length)
          (G.amount t) = concord (G.family t) (fun p => (G.kids t p).length) (G.amount t) by
        rw [family, kids],
      show discord ((shiftAt G H).family t) (fun p => ((shiftAt G H).kids t p).length)
          (G.amount t) = discord (G.family t) (fun p => (G.kids t p).length) (G.amount t) by
        rw [family, kids]⟩
  | .inr ge =>
    have same : t = H := Nat.le_antisymm le ge
    same ▸ ⟨shiftAt_step.1, shiftAt_step.2.1⟩

/-- **Two fates within a horizon, where `G` is merely nonempty at it.** For every course `G`
nonempty at `H`: `goingShifted G H` and `ending G H` have `G`'s families through `H`;
`goingShifted G H` has `G`'s concordance and discordance at every step through `H`; the two
have the same terms at every step; `goingShifted G H` is nonempty at every generation, and
`ending G H` is empty from `H + 2` on. -/
theorem two_fates_of_nonempty (nonempty : 0 < G.size H) :
    (∀ t, t ≤ H →
      (goingShifted G H).family t = G.family t ∧ (ending G H).family t = G.family t) ∧
    (∀ t, t ≤ H → (goingShifted G H).concordAt t = G.concordAt t ∧
      (goingShifted G H).discordAt t = G.discordAt t) ∧
    (∀ t, (ending G H).concordAt t = (goingShifted G H).concordAt t ∧
      (ending G H).discordAt t = (goingShifted G H).discordAt t) ∧
    (∀ t, 0 < (goingShifted G H).size t) ∧
    (∀ n, (ending G H).size (H + 2 + n) = 0) :=
  have family : ∀ t, t ≤ H → (goingShifted G H).family t = G.family t := fun t le =>
    (keep_family (G := shiftAt G H) (after := fun p => [p]) t (Nat.le_succ_of_le le)).trans
      (shiftAt_family t le)
  have terms : ∀ t, t ≤ H → (goingShifted G H).concordAt t = G.concordAt t ∧
      (goingShifted G H).discordAt t = G.discordAt t := fun _ le =>
    have kept := keep_terms (G := shiftAt G H) (after := fun p => [p]) le
    ⟨kept.1.trans (shiftAt_terms le).1, kept.2.trans (shiftAt_terms le).2⟩
  ⟨fun t le => ⟨family t le, keep_family t (Nat.le_succ_of_le le)⟩,
    terms,
    fun t => match Nat.decLe t H with
      | .isTrue le =>
        have ended := keep_terms (G := G) (after := fun _ => []) le
        ⟨ended.1.trans (terms t le).1.symm, ended.2.trans (terms t le).2.symm⟩
      | .isFalse gt =>
        have ended := keep_terms_after (G := G) (after := fun _ => []) (k := 0) gt fun _ => rfl
        have went := keep_terms_after (G := shiftAt G H) (after := fun p => [p]) (k := 1) gt
          fun _ => rfl
        ⟨ended.1.trans went.1.symm, ended.2.trans went.2.symm⟩,
    fun t => match Nat.lt_or_ge t (H + 1) with
      | .inl lt =>
        Nat.lt_of_lt_of_le (Generations.nonempty_before (Nat.le_of_lt_succ lt) nonempty)
          (Nat.le_of_eq (congrArg List.length (family t (Nat.le_of_lt_succ lt))).symm)
      | .inr ge =>
        match Nat.le.dest ge with
        | ⟨n, eq⟩ =>
          have size : (goingShifted G H).size (H + 1 + n) = G.size (H + 1) + G.size H * 1 :=
            (congrArg List.length (going_family (G := shiftAt G H) n)).trans shiftAt_step.2.2
          eq ▸ Nat.lt_of_lt_of_le nonempty (Nat.le_trans (Nat.le_of_eq (Nat.mul_one _).symm)
            (Nat.le_trans (Nat.le_add_left _ _) (Nat.le_of_eq size.symm))),
    ending_empty⟩

/-! ### The exact boundary -/

/-- **Terms zero after the horizon are shared everywhere.** Where `G`'s terms are zero at every
step after `H`, `going G H` and `ending G H` have `G`'s terms at every step. -/
theorem same_terms_everywhere_of_zero_after
    (zero : ∀ t, ¬ t ≤ H → G.concordAt t = 0 ∧ G.discordAt t = 0) :
    SameTerms G (going G H) ∧ SameTerms G (ending G H) :=
  ⟨fun t => match Nat.decLe t H with
    | .isTrue le => keep_terms le
    | .isFalse gt =>
      have went := keep_terms_after (G := G) (after := fun p => [p]) (k := 1) gt fun _ => rfl
      ⟨went.1.trans (zero t gt).1.symm, went.2.trans (zero t gt).2.symm⟩,
    fun t => match Nat.decLe t H with
    | .isTrue le => keep_terms le
    | .isFalse gt =>
      have ended := keep_terms_after (G := G) (after := fun _ => []) (k := 0) gt fun _ => rfl
      ⟨ended.1.trans (zero t gt).1.symm, ended.2.trans (zero t gt).2.symm⟩⟩

/-- **A course of terms zero after `H` is shared by two fates.** Where `G`'s terms are zero
after `H` and its generation `H + 1` is nonempty, `going G H` and `ending G H` have `G`'s terms
at every step; the first is nonempty at every generation from `H + 1` on, the second empty from
`H + 2` on. -/
theorem zero_after_two_fates
    (zero : ∀ t, ¬ t ≤ H → G.concordAt t = 0 ∧ G.discordAt t = 0)
    (next : 0 < G.size (H + 1)) :
    SameTerms G (going G H) ∧ SameTerms G (ending G H) ∧
      (∀ n, 0 < (going G H).size (H + 1 + n)) ∧ (∀ n, (ending G H).size (H + 2 + n) = 0) :=
  have same := same_terms_everywhere_of_zero_after zero
  ⟨same.1, same.2, going_goes_on next, ending_empty⟩

/-- **And where `G` is merely nonempty at `H`.** Where `G`'s terms are zero after `H` and its
generation `H` is nonempty, `goingShifted G H` and `ending G H` have `G`'s terms at every step;
the first is nonempty at every generation, the second empty from `H + 2` on. -/
theorem zero_after_two_fates_shifted
    (zero : ∀ t, ¬ t ≤ H → G.concordAt t = 0 ∧ G.discordAt t = 0)
    (nonempty : 0 < G.size H) :
    SameTerms G (goingShifted G H) ∧ SameTerms G (ending G H) ∧
      (∀ t, 0 < (goingShifted G H).size t) ∧ (∀ n, (ending G H).size (H + 2 + n) = 0) :=
  have law := two_fates_of_nonempty nonempty
  have ended := (same_terms_everywhere_of_zero_after zero).2
  ⟨fun t => ⟨(law.2.2.1 t).1.symm.trans (ended t).1, (law.2.2.1 t).2.symm.trans (ended t).2⟩,
    ended, law.2.2.2.1, law.2.2.2.2⟩

/-- **The premises hold together, with terms positive through `H`.** `going steady H`
concords by two at every step through `H`, has no terms after `H`, and is two members at
`H + 1`. -/
theorem zero_after_premises (H : Nat) :
    (∀ t, t ≤ H → (going steady H).concordAt t = 2) ∧
    (∀ t, ¬ t ≤ H →
      (going steady H).concordAt t = 0 ∧ (going steady H).discordAt t = 0) ∧
    (going steady H).size (H + 1) = 2 :=
  ⟨fun t le =>
      (keep_terms (G := steady) (after := fun p => [p]) le).1.trans (steady_terms t).1,
    fun _ gt => keep_terms_after (G := steady) (after := fun p => [p]) (k := 1) gt fun _ => rfl,
    (steady_two_fates H).2.2.2.2.1 0⟩

/-- **Terms zero from some step on decide nothing.** For a course `G` nonempty at its first
generation whose terms are zero after `H`, a course nonempty at every generation and a course
empty from some generation on both have `G`'s terms at every step. (Counting down from `H` to
the last nonempty generation of `G` at or below it, and taking `goingShifted` there.) -/
theorem eventually_zero_two_fates (first : 0 < G.size 0) :
    ∀ H, (∀ t, ¬ t ≤ H → G.concordAt t = 0 ∧ G.discordAt t = 0) →
      ∃ G₁ G₂ : SelectionTerm.Generations α, SameTerms G G₁ ∧ SameTerms G G₂ ∧
        (∀ t, 0 < G₁.size t) ∧ ∃ m, ∀ n, G₂.size (m + n) = 0
  | 0, zero =>
    match zero_after_two_fates_shifted zero first with
    | ⟨s₁, s₂, goes, ends⟩ => ⟨_, _, s₁, s₂, goes, _, ends⟩
  | H + 1, zero =>
    match Nat.decLt 0 (G.size (H + 1)) with
    | .isTrue nonempty =>
      match zero_after_two_fates_shifted zero nonempty with
      | ⟨s₁, s₂, goes, ends⟩ => ⟨_, _, s₁, s₂, goes, _, ends⟩
    | .isFalse not =>
      have empty : G.size (H + 1) = 0 := eq_zero_of_not_pos not
      have at_last : G.concordAt (H + 1) = 0 ∧ G.discordAt (H + 1) = 0 :=
        Generations.last_term_zero (Reproduction.Generations.empty_from empty 1)
      eventually_zero_two_fates first H fun t gt =>
        match Nat.decEq t (H + 1) with
        | .isTrue same => same ▸ at_last
        | .isFalse other => zero t fun le =>
          match Nat.lt_or_eq_of_le le with
          | .inl lt => gt (Nat.le_of_lt_succ lt)
          | .inr same => other same

/-- **The boundary on `Generations`, joined** (a restatement of
`Generations.never_empties_of_unbounded` and `eventually_zero_two_fates`, not a further
result). For a course `G` nonempty at its first generation: where its terms are positive at
unboundedly many steps, every course with its terms is nonempty at every generation; where its
terms are zero after some `H`, a course nonempty at every generation and a course empty from
some generation on have its terms. Which case holds is not decided here. -/
theorem terms_boundary (first : 0 < G.size 0) :
    ((∀ t, ∃ s, t ≤ s ∧ (0 < G.concordAt s ∨ 0 < G.discordAt s)) →
      ∀ G' : SelectionTerm.Generations α, SameTerms G G' → ∀ t, 0 < G'.size t) ∧
    (∀ H, (∀ t, ¬ t ≤ H → G.concordAt t = 0 ∧ G.discordAt t = 0) →
      ∃ G₁ G₂ : SelectionTerm.Generations α, SameTerms G G₁ ∧ SameTerms G G₂ ∧
        (∀ t, 0 < G₁.size t) ∧ ∃ m, ∀ n, G₂.size (m + n) = 0) :=
  ⟨fun pos _ same => Generations.never_empties_of_unbounded fun t =>
      match pos t with
      | ⟨s, le, .inl concordant⟩ =>
        ⟨s, le, .inl (Nat.lt_of_lt_of_le concordant (Nat.le_of_eq (same s).1.symm))⟩
      | ⟨s, le, .inr discordant⟩ =>
        ⟨s, le, .inr (Nat.lt_of_lt_of_le discordant (Nat.le_of_eq (same s).2.symm))⟩,
    eventually_zero_two_fates first⟩

end Horizon

/-! ## Positive at unboundedly many steps, not at every step -/

namespace Alternating

/-- True at even steps, false at odd ones. -/
def even : Nat → Bool
  | 0 => true
  | 1 => false
  | n + 2 => even n

/-- A marked member beside an unmarked one; at an even step each leaves as `Horizon.markedPair`,
at an odd step each leaves one like itself; the mark carried. -/
def course : SelectionTerm.Generations Bool where
  first := [true, false]
  kids t := cond (even t) Horizon.markedPair fun p => [p]
  amount _ := Horizon.carried

theorem step_family (b : Bool) :
    [true, false].flatMap (cond b Horizon.markedPair fun p => [p]) = [true, false] :=
  match b with
  | true => rfl
  | false => rfl

theorem course_family : ∀ t, course.family t = [true, false]
  | 0 => rfl
  | t + 1 =>
    show (course.family t).flatMap (course.kids t) = [true, false] from
    (congrArg (fun l => l.flatMap (course.kids t)) (course_family t)).trans
      (step_family (even t))

theorem step_terms (b : Bool) :
    concord [true, false] (fun p => (cond b Horizon.markedPair (fun p => [p]) p).length)
        Horizon.carried = cond b 2 0 ∧
      discord [true, false] (fun p => (cond b Horizon.markedPair (fun p => [p]) p).length)
        Horizon.carried = 0 :=
  match b with
  | true => ⟨rfl, rfl⟩
  | false => ⟨rfl, rfl⟩

theorem course_terms (t : Nat) :
    course.concordAt t = cond (even t) 2 0 ∧ course.discordAt t = 0 :=
  have family := course_family t
  ⟨(congrArg (fun l => concord l (course.offspringNumber t) Horizon.carried) family).trans
      (step_terms (even t)).1,
    (congrArg (fun l => discord l (course.offspringNumber t) Horizon.carried) family).trans
      (step_terms (even t)).2⟩

theorem even_double : ∀ t, even (2 * t) = true
  | 0 => rfl
  | t + 1 => even_double t

theorem odd_double : ∀ t, even (2 * t + 1) = false
  | 0 => rfl
  | t + 1 => odd_double t

theorem le_double : ∀ t, t ≤ 2 * t
  | 0 => Nat.le_refl 0
  | t + 1 => Nat.succ_le_succ (Nat.le_succ_of_le (le_double t))

/-- **Positive at unboundedly many steps, not at every step, and nonempty throughout.**
`course` concords by two at every even step and has no terms at every odd one; so its term is
positive past every step but not at every step, and every generation is nonempty, by
`Generations.never_empties_of_unbounded` and not by `Generations.never_empties`. -/
theorem unbounded_not_every :
    (∀ t, course.concordAt (2 * t) = 2 ∧ course.discordAt (2 * t) = 0) ∧
    (∀ t, course.concordAt (2 * t + 1) = 0 ∧ course.discordAt (2 * t + 1) = 0) ∧
    (∀ t, ∃ s, t ≤ s ∧ (0 < course.concordAt s ∨ 0 < course.discordAt s)) ∧
    ¬ (∀ t, 0 < course.concordAt t ∨ 0 < course.discordAt t) ∧
    (∀ t, 0 < course.size t) :=
  have at_even : ∀ t, course.concordAt (2 * t) = 2 ∧ course.discordAt (2 * t) = 0 := fun t =>
    ⟨(course_terms (2 * t)).1.trans (congrArg (fun b => cond b 2 0) (even_double t)),
      (course_terms (2 * t)).2⟩
  have at_odd : ∀ t, course.concordAt (2 * t + 1) = 0 ∧ course.discordAt (2 * t + 1) = 0 :=
    fun t => ⟨(course_terms (2 * t + 1)).1.trans (congrArg (fun b => cond b 2 0) (odd_double t)),
      (course_terms (2 * t + 1)).2⟩
  have unbounded : ∀ t, ∃ s, t ≤ s ∧ (0 < course.concordAt s ∨ 0 < course.discordAt s) :=
    fun t => ⟨2 * t, le_double t,
      .inl (Nat.lt_of_lt_of_le (Nat.succ_pos 1) (Nat.le_of_eq (at_even t).1.symm))⟩
  ⟨at_even, at_odd, unbounded,
    fun every => match every 1 with
      | .inl concordant =>
        Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le concordant (Nat.le_of_eq (at_odd 0).1))
      | .inr discordant =>
        Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le discordant (Nat.le_of_eq (at_odd 0).2)),
    Generations.never_empties_of_unbounded unbounded⟩

end Alternating

/-! ## Positive while it lasts, but for the last generation, and then empty -/

namespace Shrinking

/-- A marked member (`some m`) beside `m` unmarked ones (`none`). -/
def line : Nat → List (Option Nat)
  | 0 => []
  | m + 1 => some m :: List.replicate m none

/-- The marked member `some m` leaves `line m`: one marked and `m - 1` unmarked, `m` in all; an
unmarked member leaves nothing. -/
def kids : Option Nat → List (Option Nat)
  | some m => line m
  | none => []

/-- The mark: one for the marked member, none for the others. -/
def mark : Option Nat → Nat
  | some _ => 1
  | none => 0

/-- From `line (N + 1)`, each step as `kids`, the mark carried. -/
def course (N : Nat) : SelectionTerm.Generations (Option Nat) where
  first := line (N + 1)
  kids _ := kids
  amount _ := mark

theorem unmarked_flatMap : ∀ k, (List.replicate k (none : Option Nat)).flatMap kids = []
  | 0 => rfl
  | k + 1 => unmarked_flatMap k

theorem unmarked_mark : ∀ k, total (List.replicate k (none : Option Nat)) mark = 0
  | 0 => rfl
  | k + 1 => (Nat.zero_add _).trans (unmarked_mark k)

theorem replicate_length (a : Option Nat) : ∀ k, (List.replicate k a).length = k
  | 0 => rfl
  | k + 1 => congrArg (· + 1) (replicate_length a k)

/-- A line shrinks by one at each step. -/
theorem line_step (m : Nat) : (line (m + 1)).flatMap kids = line m :=
  show line m ++ (List.replicate m none).flatMap kids = line m from
  (congrArg (line m ++ ·) (unmarked_flatMap m)).trans (ListTests.append_nil (line m))

/-- At step `t`, the course from `line (m + t + 1)` is `line (m + 1)`. -/
theorem course_family : ∀ t m, (course (m + t)).family t = line (m + 1)
  | 0, _ => rfl
  | t + 1, m =>
    have shifted : m + (t + 1) = m + 1 + t := (Nat.succ_add m t).symm
    show ((course (m + (t + 1))).family t).flatMap kids = line (m + 1) by
      rw [shifted, course_family t (m + 1)]
      exact line_step (m + 1)

theorem course_size (t m : Nat) : (course (m + t)).size t = m + 1 :=
  (congrArg List.length (course_family t m)).trans
    (congrArg (· + 1) (replicate_length none m))

theorem course_sum (t m : Nat) : (course (m + t)).sum t = 1 :=
  (congrArg (fun l => total l mark) (course_family t m)).trans
    (congrArg (1 + ·) (unmarked_mark m))

/-- Where the family has an unmarked member, the marked one's offspring exceed theirs and
offspring number concords with the mark. -/
theorem course_concord (t m : Nat) : 0 < (course (m + 1 + t)).concordAt t := by
  show 0 < concord ((course (m + 1 + t)).family t) (fun p => (kids p).length) mark
  rw [course_family t (m + 1)]
  exact total_pos_of_mem (q := fun p => total (line (m + 2)) fun q =>
        excess ((kids p).length) ((kids q).length) * excess (mark p) (mark q))
      (List.Mem.head _)
      (total_pos_of_mem (q := fun q =>
          excess ((kids (some (m + 1))).length) ((kids q).length) *
            excess (mark (some (m + 1))) (mark q))
        (List.Mem.tail _ (List.Mem.head _))
        (Nat.mul_pos (Nat.succ_pos _) (Nat.succ_pos 0)))

/-- **Positive while it lasts, but for the last generation, and then empty.** For every `N`:
`course N` has positive concordance of offspring number with the mark at every step before `N`;
its family is nonempty at every step through `N`, with a mark total of one; at `N` both terms
are zero; and it is empty from `N + 1` on. -/
theorem positive_then_empty (N : Nat) :
    (∀ t, t < N → 0 < (course N).concordAt t) ∧
    (∀ t, t ≤ N → 0 < (course N).size t ∧ (course N).sum t = 1) ∧
    ((course N).concordAt N = 0 ∧ (course N).discordAt N = 0) ∧
    (∀ n, (course N).size (N + 1 + n) = 0) :=
  have at_N : (course N).family N = line 1 :=
    (congrArg (fun G => SelectionTerm.Generations.family G N)
      (congrArg course (Nat.zero_add N))).symm.trans (course_family N 0)
  have last : (course N).family (N + 1) = [] :=
    show ((course N).family N).flatMap kids = [] from
    (congrArg (fun l => l.flatMap kids) at_N).trans rfl
  ⟨fun t lt => match exists_add_of_le (c := t + 1) lt with
    | ⟨m, same⟩ =>
      have shifted : N = m + 1 + t := same.trans (Nat.succ_add m t).symm
      shifted ▸ course_concord t m,
    fun t le => match exists_add_of_le le with
    | ⟨m, same⟩ => same ▸ ⟨Nat.lt_of_lt_of_le (Nat.succ_pos m)
        (Nat.le_of_eq (course_size t m).symm), course_sum t m⟩,
    Generations.last_term_zero (congrArg List.length last),
    Reproduction.Generations.empty_from (G := course N) (t := N + 1)
      (congrArg List.length last)⟩

end Shrinking

end SelectionShift

end Becoming
