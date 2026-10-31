# UnitsApart: the skeptic's findings and their dispositions

Scratch module: `scratch/units/Becoming/UnitsApart.lean` (imports `Becoming.WorldRepresentation` only).
After revision, the build (`scratch_build.py … Becoming.UnitsApart`) reports 29 theorems and 37
declarations, `"unclean": []` (no error or warning), and `"with_axioms": {}`, so every axiom report
is empty. The pre-revision text is kept at the session scratchpad path
`/private/tmp/claude-501/-Users-ren-theories/d722a7b1-e282-4005-8cc2-c349389551f5/scratchpad/UnitsApart.before.lean`.
That path is volatile, so the diff below describes the change.

## 1. Major: the model leaves more free than the unit. Taken, and proved.

The skeptic's point holds. The skeptic's witness (`twoAt 2` and `twoAt 3`) builds, and the general
reason is short: in a still world, conservation is equality of standings, falling is strict order,
standing is sign, a need met is `0 ≤ _`, and everything else does not read amounts. So any
relabelling that keeps sign and order keeps every relation. This is now a theorem, not only a
witness:

- `World.stillAt R s`: the still world with standings `s`. `standingAt_eq_stillAt` (rfl) shows that
  F1's worlds are such worlds. `stillAt_conserves` (Iff.rfl): conservation there is
  `s (t+1) f = s t g`.
- `World.stillAt_relabel_agree`: for any `s` and any `σ` with `0 < σ a ↔ 0 < a` and
  `σ a ≤ σ b ↔ a ≤ b`, the world with standings `σ ∘ s` agrees with the world with standings `s` on
  all eleven model relations. It is supported by `eq_relabelled` and `lt_relabelled`.
- `World.stillAt_squared_agree`: squaring is one such `σ`, by `pos_squared` and `le_squared`.
- `World.oneTwo_not_scaled`: the worlds on `Bool` with standings 1, 2 and 1, 4 agree, and no `k`
  takes the first standings to the second. This is the skeptic's witness in the form of a square,
  derived from the general theorem.
- `World.standing_not_read_up_to_unit`: no `Ψ` that keeps pointwise agreement has, for every world,
  a factor `k` with every standing equal to `k * Ψ`. It is strictly stronger than the earlier
  `standing_not_determined`. The case `k = 1` is the exact reading.

The module doc is reframed to match. The title is now "Standings the occurrence model leaves free:
the unit, and in still worlds more". It says the module states two freedoms, the unit in every world
and order-and-sign relabelling in still worlds. The new bullet is titled "The unit is one freedom
among others". "What the model leaves free here, the unit" now reads "one thing the model leaves
free, the unit". The question of exchange is stated as open, not implied: "Whether conservation's
equation, in worlds with exchange, fixes standings up to a unit, or to what else, is not stated
here." The modelling choices now add "for the relabelling, still worlds only".

So the result bounds the freedom from below. The claim must not say that the amounts gap narrows to
a unit.

## 2. Minor: `standing_not_determined` is F1 recast. Taken, by dropping it.

The skeptic is right that its witness is F1's own pair and adds nothing beyond F1 except a trivial
`order` on one relatum. It is removed. Its role, a no-Ψ statement over every world, is now filled by
`standing_not_read_up_to_unit`, which uses a two-relatum witness that F1 does not give. The
every-world content stays in `standing_not_read` and `atFinerUnit_agree`. **For the parent:** any
claim text that cites `World.standing_not_determined` should cite `standing_not_read` for the
every-world, every-occurrence statement, and `standing_not_read_up_to_unit` for the no-reading
statement.

## 3. Minor: relations miscounted and a garbled docstring. Taken.

- The module doc's first paragraph now reads "the names' step, and the ten relations the model
  selects (the same-step class, conservation's step, …)". That is ten, the same-step class included,
  as in `WorldRepresentation.reidentify_carries`.
- The second bullet now reads "The nine selected relations other than the same-step class, together
  with falling and the order of standings …, agree pointwise". Falling and order are now plainly
  included.
- The `ModelRelations` docstring is rewritten in full sentences with no spliced parenthesis. It
  covers the nine of ten that are kept, the same-step class as the one that is left out, and falling
  and order as the two added. The whole file is wrapped to 100 columns.

## 4. Minor: GrammarTransport coverage is a schema, and "every root statement" overreaches. Taken.

- The second bullet now says "each keeping theorem of that module applies; three are stated as the
  pattern (…). No single statement here says that every term `Becoming.GrammarTransport` keeps reads
  alike."
- "What this covers" no longer says "every root statement". It reads: "Every reading here is a
  reading of this occurrence model with its selection: … the grammar terms
  `Becoming.GrammarTransport`'s keeping theorems build from them, each applied through
  `atFinerUnit_carried`. … the results are about this model, not about the grammar root or another
  model of it."
- I agree with the skeptic's remark that `standing_not_read` and `standing_not_read_up_to_unit`
  quantify over every `Ψ` that respects `Agree`. That covers every number read from these relations,
  so the no-reading results are not schemas.

## 5. Minor: names. Partly taken.

- `sameOccurrences` is renamed `identityOnOccurrences`. It is the identity correspondence on
  `Nat × R`. The package has no `«一一对应».refl` (GrammarTransport defines `symm`, `trans` and
  `prod` only). Adding one to `«一一对应»`'s namespace would be a shared definition that
  GrammarTransport's owner decides, so this stays local. A `«一一对应».refl` is a candidate to
  propose to that owner at landing.
- **Module rename: deferred, with a reason.** The skeptic is right that "UnitsApart" does not say
  what the module states. But the skeptic's own candidates (`FinerUnit`, `UnitFree`) no longer fit
  after finding 1. The module now states a freedom wider than the unit, and "UnitFree" would suggest
  that the unit is the only freedom. A name that states it would be about standings left unread by
  the model, for example `Becoming.UnreadStandings` (proposed). The path and the module name are kept
  here because the task's build command and the parent's references name `Becoming.UnitsApart`. The
  rename belongs at claim or landing time, by the parent, as one move of path and name.
- No other name changed. `atFinerUnit`, `atFinerUnit_conserves`, `atFinerUnit_balanced_iff` and
  `standing_not_read` were confirmed exact. The new names say what they state: `stillAt`,
  `stillAt_relabel_agree`, `stillAt_squared_agree`, `oneTwo_not_scaled`,
  `standing_not_read_up_to_unit`, `eq_relabelled`, `lt_relabelled`, `pos_squared`, `le_squared` and
  `factor_of_one`.

## Proof hygiene notes

- An earlier build of `factor_of_one` used `Nat.eq_one_of_mul_eq_one_right` from `Init`. That
  brought in `propext` through `oneTwo_not_scaled` and `standing_not_read_up_to_unit`. It is
  replaced by a structural proof on `k` and `p`, and the report is now empty.
- The closing steps of `oneTwo_not_scaled` (refuting `4 = 1 * 2`) and of
  `standing_not_read_up_to_unit` (refuting `4 = 2`) use `by decide` on closed `Nat` equalities. Their
  reports are empty.

## Third look (1 November 2026)

A fresh skeptic read the revised module and the commit `75bf578d6` that recorded it. It made five
findings. All are taken except the rename, which is deferred to landing. After this revision, the
build (`scratch_build.py … Becoming.UnitsApart`, output in `scratch/units-build.json`) reports
**32 theorems in 40 declarations**, `"unclean": []` and `"with_axioms": {}`, so every axiom report is
empty. The three declarations added since the second pass are all theorems: `assoc_mul`,
`left_comm_mul` and `ratio_apart`.

### 1. Major: the selection is a choice, and the results nearly hold by construction. Taken.

The finding holds. `WorldRepresentation`'s module doc and the hypotheses of the record
`the-world-represented-both-ways` say that the ten relations are a selection, and that a
re-identification also carries a standing's value. Every selected relation reads amounts only through
sign, through `need ≤ level`, or through conservation's homogeneous linear equation. The two relations
this module adds, falling and `standingOrder`, are also comparisons. So `atFinerUnit_agree` follows
from the shape of the selection.

- The module doc now has a second paragraph. It says that the ten relations are a stated selection,
  and cites the module doc and the record's hypotheses. It says that a selection that read a
  standing's value would read the count, and that one that read the difference of two standings would
  in general not agree at a finer unit. It states the reason the results hold: every relation reads
  amounts only through sign, comparison in one unit, and conservation's homogeneous linear equation.
  It ends: "They are results about this selection, with falling and the order of standings added, not
  about every relation a World carries."
- "What this covers" no longer says "a relation selected later". It names what is not covered: any
  relation that reads a value or a difference of amounts. The examples are the partial identity
  "standing is `n`", which every re-identification carries, and "`x` stands one more than `y`" within
  a step. It says where each fails at `k ≠ 1`, and that the relations "standing is `n`", for every `n`,
  read the count exactly. It says that neither statement is proved here. This third look did not add
  them as theorems, because the point is about the scope of the selection and does not need its own
  result.
- The `ModelRelations` docstring now ends: "This is a selection, not every relation a World carries:
  a re-identification also carries a standing's value, which none of these reads."
- **For the parent (wording of claim and landing texts).** The message of `75bf578d6` cannot be
  changed. It says "amounts not read off the root's model relations", which names the root and
  overclaims. Every claim text, record or study section should instead say "not read off
  `WorldRepresentation`'s selected relations, with falling and the order of standings". It should
  never say "the root's model relations". The skeptic notes that the module doc already made no claim
  to close the amounts gap: worlds with exchange stay open, as in DU `REVIEW.md` §3.

### 2. Minor: "up to a unit" covered one direction only. Taken, by the ratio form.

`World.standing_not_read_up_to_unit` is now the symmetric form, proved with an empty report. No `Ψ`
that keeps pointwise agreement has, for every world, positive whole factors `p` and `q` with `q` times
every standing equal to `p` times what `Ψ` reads. The factors are chosen world by world. With `q = k`
and `p = 1` this is a reading in a unit `k` times finer, and with `q = 1` and `p = k` one in a unit
`k` times coarser. The docstring says this.

The witness is the same pair of still worlds (1, 2 and 1, 4). The arithmetic is the new lemma
`ratio_apart`: from `q·1 = p·a`, `q·2 = p·b`, `q'·1 = p'·a` and `q'·4 = p'·b`, with `0 < p` and
`0 < q'`, it derives `p·q'·2 = p·q'·4` and cancels by `Nat.eq_of_mul_eq_mul_left`. The skeptic's probe
used `rw` and `omega`, which brought in `propext` and `Quot.sound`. Here the regrouping goes through
`assoc_mul` and `left_comm_mul`. Their counterparts in `Init`, `Nat.mul_assoc` and `Nat.mul_left_comm`,
report `propext`, so they are reproved structurally. The closing `2 ≠ 4` is `by decide`, and its
report is empty.

The new form does not contain the old one word for word. In the old form, `k = 0` was allowed in a
world whose standings are all 0. Both forms refute every reading in a positive unit, in either
direction, so the old form is not kept beside the new one. Section 1 above describes the old form,
which is now replaced.

### 3. Minor: the "So …" sentence read as holding world by world. Taken.

Bullet 4 now reads: "So no single reading of the model returns the standings of every world even up
to a unit, …". It then says: "The worlds that refute it are still worlds on two relata; a reading
that returns the standings up to a unit on every world with exchange, or on any class without these
two worlds, is not ruled out." The theorem's docstring has the same qualification. Claim texts should
qualify it the same way: one reading for every world, refuted by still worlds on two relata. The
statement that does hold world by world is the exact count, `standing_not_read`, at every occurrence
of positive standing.

### 4. Minor: `atFinerUnit` is a unit only for `0 < k`. Taken.

The docstring now says: "For `0 < k` this is the world counted in a unit `k` times finer; at `k = 0`
every amount is 0, which is no unit, and at `k = 1` it is `w` counted again." Bullet 1 of the module
doc says the same.

### 5. Minor: the module name. Deferred to landing, with the reason.

The finding holds: "UnitsApart" does not say what the module states, and it suggests standings one
unit apart. It is not done here, for two reasons. First, this task may edit only `UnitsApart.lean`
and this `REVIEW.md`, and a rename moves the path. Second, the build command, `units-build.json` and
the parent's DU texts all name `Becoming.UnitsApart`, so renaming one of them alone would leave
references stale. **For the parent:** at landing, rename the path and the module in one move, to
`Becoming.UnreadStandings` (proposed in section 5 above) or `Becoming.StandingsUnread`. Update every
reference in the same commit, including the namespace `Becoming.UnitsApart` of the helper lemmas. The
other names were confirmed exact by the skeptic: `atFinerUnit*`, `standingOrder`, `stillAt`,
`stillAt_relabel_agree`, `oneTwo_not_scaled`, `standing_not_read` and `factor_of_one`. The new
`ratio_apart`, `assoc_mul` and `left_comm_mul` state what they prove.
