Kept as written; local paths in it point to the session's scratch folder.

AI-written second reading, 12 November 2026

# Second reading of `Becoming/TurningInTime.lean`

Read only. Nothing was built, run or changed. Line numbers are the module's
(`/Users/ren/theories/tmp/r7/the-loop/lean/Becoming/TurningInTime.lean`) unless a file is named;
the base files are in
`/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`.

## In short

I found no false theorem statement, and the three witness courses compute by hand as their
docstrings say. The problems are in what is claimed around the statements:

1. The grammar section presents as its own laws one exact duplicate and three one-line corollaries
   of laws the root already has.
2. Several docstrings leave out premises without which the sentence is false as read.
3. One heading names an exact threshold that the theorem does not give and that the module's own
   witness contradicts.
4. The marks do no work in the exact condition: the iff holds without them, and "between the marks"
   comes from one premise plus the definition of `renew`.
5. "renew", "carrier" and "condition" collide with the root's own terms, and the root's terms for
   this subject (`«至终有常»`, `«异»`, `«因于核»`) are not used.

## High

**H1. The grammar section restates the root (lines 16-28, 99-136).**

- `alike_steps` (128-136) is `«同行之迭»` (GrammarLaws.lean 2677-2681), the same statement up to
  variable names. It is used once, at 387. Remove it and call the root's law.
- `not_constant` (122-126) is the contrapositive of `«有常则可续»` (GrammarLaws.lean 2592); its proof
  is that one call.
- `core_apart` (117-120) is `«亡于核下不变»` (Grammar.lean 523) taken at the one, carried from `E` by
  `«核之单调»` (598) and the core's symmetry: core-related under `E` gives core-related under the
  one; `u'` ends under the one, so `u` would, but `R u v`.
- `core_step` (99-103) is the pointwise form of `(«根» R E).2.1`.
- `core_steps` (105-115) is the only one I did not find in the root (searched `Grammar*.lean` for
  constancy over `«迭»` or `«历»`). It is the core's case of a law true of every constant relation
  (`«有常» R S` gives `«有常» («迭» R n) S`), and nothing in the file uses it.

Header line 20, "Three laws here say what lies in that gap", should say which are the root's and
where. The root also already has the phenomenon witnessed: `«有亡之续则不有常»` (Grammar.lean 370)
and the flame, `«以核为判据则火无续»` (791, "the core's futures differ by how long is left").

**H2. Premises missing from docstrings; the sentences are false without them.**

- `used_up_alike` (453-461): the docstring omits `nothing : FromNothing c.giving` and
  `needed : 0 < c.need`. With `need = 0` nothing ever ends. With `giving 0 = 1`, `H = 5`, `need = 1`
  the level sits at one for ever. Header 52-56 has the same omissions.
- `ends_below_least_use` (475-481): the same two premises omitted; header 57-59 likewise.
- `Turning.unmarked_ends` (655-658): the docstring states no premise but "no level between the
  marks". It needs the start not using less and below `H₁ + y₁`; a line from a way that uses less,
  inside the band, never ends whatever the marks (`Turning.holds`).
- Header 60-66, the exact condition: omits `high : s.2 ≤ hi` (602), which the right-to-left
  direction needs. The theorem's own docstring (597-600) has it.
- `Turning` docstring (517-521) and header 60-62 omit four of the twelve fields: `nothing`, `least`,
  `needed`, `within`. `within` (`need ≤ H₂ + y₂`) is substantive.
- `[DecidablePred Less]` (554, 583, 601, 648, 656) is nowhere said. In a package that keeps an empty
  axiom report it is a real premise.
- Smaller: `constant_iff` takes `k : Way` (the ways are inhabited), unstated. `left_zero`, `left_lt`,
  `falls`, `falls_le`, `gone`, `below_stays`, `above_of_never_ends` do not name `FromNothing` (nor
  `needed` at 499-503).

**H3. "The last level from which it can turn" (475; header 57) is not what is proved.**
`ends_below_least_use` gives one direction: below `H + y`, with `H` a floor on every way's use, the
line ends whatever the ways do. It does not show `H + y` is the last such level, and it is not the
level *from which* a turn works. `Witness.too_late` turns at level six, which is exactly
`H₂ + y₂ = 3 + 3`, and ends, because the step at which it turns still uses five. What is bounded is
the level *left with a way that already uses less*. An exact title: "Below the least use's point of
no return no turn keeps it going".

**H4. In the exact condition the marks carry nothing; the turn is between them by stipulation.**
`Turning.goes_on_iff` (597-644) holds in a simpler form, by the same proof without the case split at
615-621 and without the field `alone`:

```
(∀ n, c.need ≤ c.level s n) ↔
  ∃ j, ¬ Less (c.way s j) ∧ Less (c.way s (j + 1)) ∧ H₂ + y₂ ≤ c.level s (j + 1)
```

Neither `Between` nor `withLevel` is needed. The stated form follows from this one by
`Turning.alone` (531) and the definition of `renew` (171): a way of the first kind comes to the
second only where `renew` consults `withLevel`, which is between the marks by definition. So the
theorem's content is about the two kinds. That the turn lies between the marks is a premise and a
definition, and the docstrings (597-600, header 60-66) read as if it were part of what is proved
exact. `Turning.alone` is as substantive as `kept` and is missing from "What is assumed and what is
not shown".

Related, on the same theorem:

- The right side is an event on the same line, not a condition on the marks, the need or the start.
  No theorem says for which marks the event occurs, beyond `unmarked_ends`. The header's opening
  "states … when a going on … turns" (9-10) is delivered as "exactly where this event occurs on its
  line".
- `first_less` gives `j < s.2` and the proof discards it (614). Stating it would make the right side
  a bounded search.
- The premises do most of the work: one kind is doomed (`more`, `short₁`), the other is absorbing
  (`kept`) and holds on a band (`meets`, `keeps`). The iff composes `gone`, `RegimeMargin.holds` and
  bookkeeping. The setting is satisfiable and both sides occur (see the witness), so it is not
  vacuous; it is exact because the setting stipulates the two regimes.

## Medium

**M1. Inexact wording on the main results.**

- 597-598, "below the point of no return of what it uses": the premise is `s.2 < H₁ + y₁`, where
  `H₁` is a floor on what ways of the first kind use. A way using more than `H₁` has a higher point
  (`rises_by_draw`, RegimeMargin.lean 793), so the docstring covers starts the theorem does not.
- Header 9-10, "turns before the condition is gone": the condition is that the level left by the
  turning step is at least `H₂ + y₂`. `too_late` turns while six is left and ends.
- Header 52, "Along a line none of whose levels lies between the marks": `used_up_alike` assumes
  `Unmarked`, about every level at or above the need, on the line or not. The proof uses it only at
  the line's levels (467, 470, 473), so the theorem can be weakened to what the header says.
- Header 79-80, "`falls` is its `ends_below`": `gone` (444) is; `falls` is the analogue of
  `Adjusted.orbit_bound` (RegimeMargin.lean 539).
- Title line 4, "turns or ends": a line can turn and end (`too_late`). What is proved is "never ends
  exactly where it turns in time", in the setting.
- `Turning.first_less` (581-585) says "a first step"; the statement gives a step from not-less to
  less, with firstness not stated.

**M2. Conclusions that are the definitions unfolded, under bold headings.**

- `ends_iff` (234): `cond` (182) has no successor below `need`. Ending is defined, not derived.
- `differs_between` (322), `way_alone` (376), `goesAlike_of_unmarked` (341): the definition of
  `renew`.
- `unmarked_iff` (330), `between_ended` (368): arithmetic on `Between`.
- `constant_iff` (347): the left-to-right half does not use `un` (348-350). In every course with a
  way, constancy gives `need = 0`, because `alike` (185) ignores the level and `cond` is cut at
  `need`; the pair `(k, need)`, `(k, 0)` is in the carrier whether any line reaches it or not. The
  general form, through the law the header cites and `cond_fixed`, is: constant exactly where it
  goes alike and `need = 0`. `constant_iff` is its unmarked case. `cond_fixed` (206) is proved and
  never used, and `«局定后则有常当且仅当同行可续»` is cited (19) and never applied.
- `core_tells` (362) uses no `Unmarked` and is `core_apart` at the model, true of every relation.
  The header's "Then …" (47-49) places it and `constant_iff` under the unmarked case.

The header is honest about one choice (39-41, "it is a definition here, not a theorem"). It should
say the same of these, and list: ending is `level < need` by definition; `alike` ignoring the level
is a choice; the turning step uses as before (`step`, 178: the new way takes effect at the next
step, which is what makes `too_late` late); marks and need are constants.

**M3. Line 28 has no theorem behind it.** "So what a class does not tell now, and its core does, is
what it depends on without its differing" is a reading. In the model the core is shown only to tell
a level at which it goes on from one at which it has ended. The stronger law is at hand from
`core_steps` with `core_apart`: core-related occurrences have lines equally long (if `u` takes `n`
steps to something that has a next, so does `u'`). That would give `core_steps` a use and the
sentence a statement.

**M4. Terms that collide with the root, and root terms not used.**

- "renew", "renewing alone", "renews into", "at every renewal" (`renew` 171; 530, 534, 599): the
  root glosses `«复生»` as "renews" and `«复生至»` as "renews into" (Grammar.lean 152, 646), a
  different thing, and under the one there is none (`«一之下无复生»`, 251).
- "carrier": the grammar's carrier is the type (header line 16 uses it so). Lines 38-39 and 77 use
  it for "whatever carries that difference". It stands where "reader" would have stood.
- "condition": `cond` (182) is the model's 缘, a relation between occurrences. "One condition with a
  level" (33, 142) is a coordinate of the occurrence. One word, two senses, in a module whose claim
  is the root's terms.
- The gap between going alike and constancy has a name in the root: `«至终有常»`, constancy up to
  the net's end (GrammarPath.lean 222), used by OwnClass, RoutesToC and FromTheDynamics. With a
  fixed successor the unmarked respect is that. The module does not say so.
- "Turns" and "differs" along a line are the root's `«异»` (Grammar.lean 147). "Depends on" is
  `«因于核»` / `«足以定核»` (612, 615), with the flame and its fuel as witness (`«火薪相须»`, 832).
  For every course with a positive need and a way, the respect depends through the core on the
  class "same level" (cheaply: their joint class is identity, as in the four-moment flame). None of
  this is stated, so the header's "the centre … said in the grammar's own terms" (11) holds for the
  ending and the alike/constant gap, not for the turning.
- "Differ" is used in two senses: across levels at one step (`differs_between`, which is `«同行»`)
  and along the line ("ends without having differed", 10, 70-71; `unturned`).
- `Course.Lasts` (194) and `lasts_or_ended` (261) rebuild `Lasting.Lasts` (Lasting.lean 107) and the
  determined-law duality (`reaches_iff_not_lasts`, 831) under the same name; RegimeMargin imports
  Lasting. I read only Lasting's header and declaration list.

**M5. `left_lt` and `falls` beside RegimeMargin.**

- `left_lt` (398-413) is not a generalization of `Adjusted.step_below` (RegimeMargin.lean 485). It
  is its third conjunct at the draw `c.use k` and the regime's giving, after weakening
  `Short g H y` to `Short g (c.use k) y` (from `H ≤ c.use k`) and taking `draw_pos` (449) for the
  recent giving. A step has one use. The docstring's "At a standing use this is …" has the relation
  the wrong way round; derive it.
- `falls` and `gone` (417-451) do generalize the regime's `orbit_bound` / `ends_below` (705), along
  the draw, where `Adjusted` generalizes along the giving. RegimeMargin has no law for a draw that
  changes from step to step, so the content is new. It is stated on `Course`, with the draws being
  `c.use (c.way s j)`, so `ends_below` is not its case in RegimeMargin's terms and the adjusted
  giving is not covered. By the rule the general law belongs in RegimeMargin, on a run with a draw
  at each step never less than `H`, the standing draw its constant case, and `Course.falls` reads
  it. As it stands it sits beside, not below.

**M6. Field words under other names, and doers.** A level that a use lowers and a giving raises is a
stock with a draw and a renewal; the word is avoided and the construct kept (RegimeMargin's "draw"
appears once, line 81). `left k x = (x - use k) + giving (x - use k)` is one step on a pair, and the
docstrings tell it as two doers: the going on "uses", "uses up", "needs"; the condition "gives
back". "Can turn", `in_time`, `too_late`, "as before", "once turned" fit something with an aim.
Line 12-14, "the words other fields use for the same thing", asserts a correspondence that lines
77-79 say is not shown.

**M7. The witness is real and thin.**

- Under a use of five, `Peaked.giving` (at most four) is short at every level
  (`ends_beyond_giving`, RegimeMargin.lean 721), so `y₁ = 4` marks no threshold: the way as before
  ends from every level. The docstring's "(and beyond)" (682) admits it.
- From any level up to eight a turn is in time only at level eight (seven leaves four, six leaves
  two), so the only in-time event is at step zero. No course shows a turn after a fall that is still
  in time.
- A witness with a real threshold and a window of two steps, worked by hand and not checked in
  Lean: giving `min z (12 - z)`, uses five and three, `y₁ = 5` (point ten, where the level rests at
  ten), `y₂ = 3` (point six), `hi = 12`, start nine. As before: 9, 8, 6, 2, 0. A turn at step zero
  leaves eight, at step one leaves six (both go on), at step two leaves two (ends).
- `unturned` uses marks nine and nought, which satisfy both disjuncts of `unmarked_iff`. Marks seven
  and six (`high` at or above the need, `low` above `high`) give the same numbers and show the case
  the header motivates.
- The docstrings say more than the statements: `in_time` (705) states only `«不穷»`, not "at once"
  or "the level left is six"; `too_late` (712-713) does not state that the way at step one is still
  as before, nor the levels six and two. Both are true by computation and cheap to add. "The fall
  makes a difference at once" (703): at step zero nothing has fallen.

**M8. Simpler statements; premises to drop or weaken.**

- `Turning.least` looks droppable (sketch, not checked in Lean). Left to right: after the first way
  that uses less, the level is the regime's run under `H₂`; were the level left below `H₂ + y₂`,
  `RegimeMargin.ends_below` would end it. Right to left, for steps before the turn: use `falls_le`
  under `H₁` from that step in place of `below_stays` under `H₂`. Then `uses_least`, `below_stays`
  and `above_of_never_ends` are not needed for the iff, and "uses less" is a reading the proof does
  not use.
- `high : s.2 ≤ hi` is unused left to right, and so in `unmarked_ends`. `unmarked_ends` is a weaker
  corollary of `used_up_alike` (whose `uses` follows from `more` and `alone`): that gives the
  positive form, an ended occurrence within `s.2` steps, from five fields. "The line ends" (655) is
  stated only as `¬ «不穷»`.
- `used_up_alike`: `uses` for every `j` (460) is needed only for `j < x`.
- `used_up_alike` and `ends_below_least_use` share one proof; one lemma (uses at least `H` on the
  first `s.2` steps while it lasts) gives both.
- `ends_iff`, `steps_iff`, `lasts_or_ended`, `never_ends_iff`, `cond_fixed` use nothing of `Course`
  but "a determined step cut by a guard". They are the partial-law forms of `Law.steps_orbit` and
  `Law.step_fixed` (Recurrence.lean 255, 263) and belong there, once.
- `ends_below_least_use`'s conclusion is the root's `«迭内»` (GrammarLaws.lean 1176).

**M9. Steps after the end.** `step` (178) is total, so `way` and `level` (188, 191) run on after the
level is below the need. `way_alone`, `falls`, `falls_le`, `gone`, `below_stays`, `less_onward`,
`first_less` are about that orbit and call it "a line"; the grammar's line stops. No theorem's truth
is affected: `never_ends_iff` quantifies over every step including the first below the need, and
`used_up_alike` / `ends_below_least_use` go through `lasts_or_ended`. In `goes_on_iff` the witness
`j` ranges over the whole orbit; a `j` after an end is excluded only by `within` and by the level
not rising below `H₂ + y₂` (636-644). With `high < need` and `low ≤ high` the orbit past the end can
consult `withLevel`; nothing follows since `cond` has stopped. Say once, at `way` / `level`, that
they are the step taken `n` times whether or not the going on lasted.

## Low

- Unused in the file: `core_steps`, `cond_fixed`, `alike_class` (202), `way_shift` (216), `way_add`
  (222).
- Names: `Turning` names a bundle of twelve premises. `Turning.alone` (a premise) against
  `Course.alone` (a function). `least` is a field (543) and, with another meaning, a hypothesis
  (479, 494, 502). Hypotheses `low` / `high` in `Turning.holds` and `goes_on_iff` (569, 602) are the
  band's ends, not the marks `c.low` / `c.high`. `Unmarked` reads "has no marks" and meets
  `Sequences.Marks` (Recurrence.lean 187) and `Amounts.unmarked_or_marked`. `Course` is here a law's
  parameters, while the package uses "course" for a run; "three courses from one start" reads as
  three runs. `Course.alike` takes a course it ignores (185).
- "End at `t`" (239) for arriving, in the theorem that relates steps to ending.
- 类 is "class" in the grammar section and "respect" in the model. `core_apart` and `not_constant`
  say "class" where `E` is any relation (they prove more).
- "No level between the marks" (340, 345, 383) drops "at which it goes on"; `Unmarked` is weaker.
- "`high` is the level at and below which …" (37-38, 149): by `renew` the level makes a difference
  only down to `low`.
- `Turning.meets` doc (538), "from `y₂` up to `hi`": `Meets` bounds `z + H₂ ≤ hi`.
- "Point of no return" for `H + y` under `Short` alone is a level below which giving is short, not
  a least one. RegimeMargin's header uses it the same way.
- Line 18, "A class can go alike … and still not be constant", has its witness only by combining
  `goesAlike_of_unmarked` and `constant_iff` on `course 9 0`; it is not stated.

## The witness, by hand

`Peaked.giving z = min z (8 - z)`: 0, 1, 2, 3, 4, 3, 2, 1, 0 at 0 to 8. Need one; `true` uses five,
`false` uses three; `alone = id`; between the marks every way becomes `false`.

`turning low high : Turning _ (· = false) 5 4 3 3 8`, all twelve fields: giving 0 = 0; `true` uses
5; giving below four is 0..3, under five; `id` keeps `true`; `false` uses 3; `renew false x = false`
either way; giving below three is 0, 1, 2; giving at 3, 4, 5 is 3, 4, 3, at least three; the step
under three takes 8 to 8, 7 to 8, 6 to 6, 5 to 4, 4 to 2, 3 and below to 0, all within eight;
3 ≤ 5; 0 < 1; 1 ≤ 6. Satisfiable for every pair of marks.

- `in_time`, marks 7 and 8, from `(true, 8)`: eight is between; it becomes `false`; left is
  3 + giving 3 = 6, at least six. Then `(false, 6)` goes to `(false, 6)` for ever. Right.
- `too_late`, marks 5 and 6: `(true, 8)` to `(true, 6)` (eight not between; 3 + 3); to `(false, 2)`
  (six between; 1 + 1); to `(false, 0)` (0 + 0). Levels 8, 6, 2 meet the need; nought does not.
  Turned at step one at level six, two left, ended after three steps. Right.
- `unturned`, marks 9 and 0: `(true, 8)`, `(true, 6)`, `(true, 2)`, `(true, 0)`. Right.

Both sides of the iff occur under the theorem's own premises (start `true`, 8 < 9, 8 ≤ 8): true and
true in `in_time`; false and false in the other two, which reach an ended occurrence.

## The root's terms (item 5)

`«同行»`, `«有常»`, `«核»`, `«迭»`, `«亡»`, `«不穷»`, `«定后»`, `«类»` are used in the senses of
Grammar.lean and GrammarLaws.lean. `«亡» c.cond «一» t` is rightly read "nothing continues it in any
respect": under the one, continuation is 缘 itself (`«一之续»`, Grammar.lean 162), and what ends
under a coarser class ends under every finer (`«亡于粗则亡于细»`, 170). `Course.never_ends_iff`
(276) is what its docstring says. One remark: the respect `alike` is used for going alike, constancy
and the core, never for continuation; under `alike` a step that changes the way is itself an ending
in the root's sense.

## Not checked

- Nothing compiled; I took the build and the empty axiom report on the author's word and read proofs
  only to see which premises each uses.
- The sketches (the simpler iff of H4, dropping `least`, `left_lt` from `step_below`, the second
  witness) are worked by hand, not in Lean.
- `PoolFromCourse`, `ReadOffInTime` beyond its header, `BeyondCoupling`; Lasting and GrammarPath
  beyond headers and the definitions cited. Other modules were not searched for further duplicates.
- The texts beside the module (`THE-LOOP*.md`, `EIGHT-DOUBTS.md`) and any Chinese rendering.
