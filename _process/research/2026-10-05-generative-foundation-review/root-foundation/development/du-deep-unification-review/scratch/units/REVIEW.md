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
