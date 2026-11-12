AI-written, 13 November 2026. The atlas entry `turning-in-time`, read for its premises (v6's atlas finding, item 1).

Worktree `/Users/ren/tmp/tt/wt`, branch `tt-turning-in-time`. I edited two files there:
`theories/becoming/results/atlas/entries/dynamics.json`, the entry `turning-in-time` only, and
`theories/becoming/results/atlas/entries/premises.json`, where I only added entries. I ran no git command that writes,
no `check_becoming.py`, no render and no tests. The edit script is
`/private/tmp/claude-501/-Users-ren--claude-spares-spare-Ao5dcP/3c343411-bb06-4ddc-aa7a-5f9cd79133ad/scratchpad/tt_premises.py`.

## Added to premises.json

13 entries go after `transmission-none-present-depends`. Each has kind "hypothesis of a law", seeded_from `["Lean"]`
and home `theories/becoming/chapters/02-MAP.md#r-turning-in-time`. That anchor exists today. The records' `.md`
pages do not exist until a render. `lean` gives the laws that take the premise, or the definition for `AloneOutside`.

| id | statement | holds_in / fails_in |
|---|---|---|
| `turningintime-aloneoutside` | at every level not marked, the way after a step is alone of the way: ∀ w x, ¬ marked x → renew w x = alone w (TurningInTime.AloneOutside marked alone renew) | holds: `window_alone_outside`, `Three.goes_on` |
| `turningintime-unmarked` | no level that meets the need is marked: ∀ x, need ≤ x → ¬ marked x | holds: `Three.ends_as_it_was`, `unmarked_interval_iff`; fails: `Three.goes_on`, `Three.turned_and_ends`, `Three.line_ends_while_net_goes` |
| `turningintime-as-it-was-ends` | at some step the level of the course as it was from s is below the need: ∃ n, (Law.orbit (asItWas alone left) s n).2 < need | none (the header gives the case where it fails as argued, not as a Lean statement) |
| `turningintime-turns` | at every marked level the way after a step is of the kept kind: ∀ w x, marked x → Kept (renew w x) | holds: `Three.goes_on` |
| `turningintime-kept` | from a way of the kept kind, the way after a step at every level is of the kept kind: ∀ w x, Kept w → Kept (renew w x) | holds: `Three.goes_on` |
| `turningintime-uses` | every way of the kept kind uses exactly H₂: ∀ w, Kept w → use w = H₂ | holds: `Three.goes_on` |
| `turningintime-within` | the need is at most H₂ + y₂, the point of no return of the kept kind's use: need ≤ H₂ + y₂ | holds: `Three.goes_on` |
| `turningintime-start-kept` | the way at the start is of the kept kind: Kept w | none |
| `turningintime-uses-along-orbit` | every way on alone's orbit from the start's way w uses at least H: ∀ j, H ≤ use (Law.orbit alone w j) (H₁ in turns_in_time_iff) | holds: `Three.goes_on` |
| `turningintime-level-meets-need` | the level x the law names meets the need: need ≤ x (in kind_not_toEnd_of_turn, the level x₀ too: need ≤ x₀) | holds: `Three.turned_and_ends`, `Three.line_ends_while_net_goes` |
| `turningintime-other-kind` | at the level x the way after the step is of another kind than the way: ¬ κ (renew w x) = κ w | holds: as above |
| `turningintime-level-unmarked` | the level x₀ is not marked: ¬ marked x₀ | holds: `Three.line_ends_while_net_goes` |
| `turningintime-alone-keeps-kind` | alone takes every way to a way of its kind: ∀ w, κ (alone w) = κ w | holds: `Three.line_ends_while_net_goes` |

Every holds_in or fails_in is under `Becoming.TurningInTime.`. `Three.goes_on` applies `turns_in_time_iff`, discharging
each of its premises (H₂ = 3, y₂ = 3, H₁ = y₁ = 5, need 1, hi 12). In `goes_on` and `turned_and_ends` the marks 9, 8 and
6 meet the need 1. `ends_as_it_was` states `turningintime-unmarked` for the marks from ten to nothing.

**Reused rather than added.** Each has the same premise text:
- **`k3-decided`** for `[DecidablePred marked]`. The ledger's own reading maps every Decidable or DecidablePred binder
  to it, and 143 laws take it. A new id would split one premise in two. The brief listed "whether a level is marked is
  decided" as new.
- **`optimum-coupled-need-positive`** ("the need m is positive: 0 < m") for the positive need.
- **`optimum-level-law`**, **`optimum-renews-at-most`** and **`optimum-draws-above-renewal`** for the level of the course
  as it was in `Optimum`'s form, at most r given and more than r taken at every step. The brief listed these as new.
- **`regimemargin-fromnothing`, `-short`, `-meets`, `-keeps`, `-start-below-point` (x < H + y) and
  `-start-level-le-hi` (x ≤ hi).** Short also stands for short₁, at H₁ and y₁.
- **`regimemargin-step`** for laws whose statement is made through `RegimeMargin.step`, as `margin-of-a-regime` lists it.

## The entry

**premises** (law → takes):
- `ends_with_net`: aloneoutside, optimum-coupled-need-positive, unmarked, optimum-level-law, optimum-renews-at-most, optimum-draws-above-renewal
- `ends_with_net_regime`: aloneoutside, need-positive, unmarked, regimemargin-fromnothing, regimemargin-short, uses-along-orbit, regimemargin-start-below-point, regimemargin-step
- `unending_iff_first_marked`: k3-decided, aloneoutside, as-it-was-ends
- `unending_iff_above`: kept, uses, fromnothing, short, meets, keeps, need-positive, within, start-kept, start-level-le-hi, regimemargin-step
- `turns_in_time_iff`: k3-decided, aloneoutside, turns, kept, uses, fromnothing, short, meets, keeps, need-positive, within, uses-along-orbit, start-below-point, start-level-le-hi, regimemargin-step
- `kind_ends_while_net_goes`: level-meets-need, other-kind
- `kind_not_toEnd_of_turn`: aloneoutside, alone-keeps-kind, level-meets-need, other-kind, level-unmarked. It has a
  `case_of` to `Becoming.«出类不随则本类不至终有常»`, the case the docstring names: R is the net and E the kind's class,
  with m = (w, x), c = (w, x₀) and u = pair renew left (w, x). Its goes is met by the step from (w, x₀), and its clean by
  AloneOutside at the unmarked x₀ with alone keeping the kind.
- `Three.goes_on`, `Three.turned_and_ends`, `Three.line_ends_while_net_goes`, `Three.ends_as_it_was`: none. These
  statements bind no hypothesis.

**drops:**
- **`ends_with_net`: `[]`.** It ends within its premises.
- **`turns_in_time_iff`: `turningintime-unmarked`.** The unending side of the iff is a marked step T at which the need
  is met, so it is a marked level that meets the need.
- **`Three.line_ends_while_net_goes`: `turningintime-unmarked`.** Level 6 is marked and meets the need 1. Together with
  `toEnd_of_unmarked`, its ¬ «至终有常» shows the premise failing.
- **`kind_ends_while_net_goes`: no drops.** Its law binds no marks. That the way turns only at a marked level follows
  under AloneOutside and alone keeping the kind. It is shown only by composing `kind_toEnd_of_unmarked`,
  `«至终有常则本类至终有常»` and `kind_not_toEnd_of_turn`, and no Lean statement does that.

**hypotheses:** `turning-in-time` 1–8 and `going-alike-up-to-the-nets-end` 1–4 (12 pairs).

**compose:** none. The validator requires `to.role` to be one of rule, reading or pool. Neither join reads one
dynamic's state as one of those roles of the other:
- The regime join (`ends_with_net_regime`) makes `RegimeMargin.step` the pair's level step.
- `window_is_pair` regroups the whole joined two-level step as the pair, at a need of nothing.

`case_of` cannot carry these joins either. `ends_with_net_regime` and `window_is_pair` are laws of this dynamic, and
`case_of` refuses a law of the dynamic itself.

**Text corrections:**
- **The exit by `turns_in_time_iff`.** Its edge now gives:
  - AloneOutside and decided marks;
  - the way after a marked step of the kept kind, the kind kept at every step, and every way of it using exactly H₂;
  - nothing given from nothing;
  - giving short of H₂ below y₂ and meeting it from y₂ up to hi, with the step under H₂ keeping the level within hi;
  - a positive need at most H₂ + y₂;
  - giving short of H₁ below y₁, uses of at least H₁ along alone's orbit, and the start below H₁ + y₁ and at most hi.

  The conclusion is said at the first marked step, with the need met there and at every step before it.
- **The mechanism.** The same sentence now says "every way of which uses exactly H2", "nothing given from nothing" and
  "giving short of H1 below y1". This is the same fix as the edge, inside the entry.

## The validator

I loaded `tools/research/atlas.py` and ran `load()` and `validate()` read-only on the worktree's atlas. They report 117
errors. Every one is in `turning-in-time` or a `turningintime-*` premise, and none is in any other entry. All 117 say a
`Becoming.TurningInTime.*` or `Becoming.Law.stepWhile*` name "is declared neither in the core receipt nor in a tracked
live Lean file". They fall in these fields:
- 58 in the declarations, 4 in the exits' laws, 11 in the premises' laws and 3 in the transition;
- 19 in the new premises' `lean`;
- 22 in their `holds_in` and `fails_in`.

`TurningInTime.lean` and `GuardedStep.lean` are untracked in the worktree, so the commit, or the core receipt after
the core run, clears all 117. No structural error remains: fields, ids, takes, drops, case_of, hypotheses' indices and
anchors all pass. The seven GrammarPath laws and `«出类不随则本类不至终有常»` resolve now. All 184 dynamics carry
`premises`, so family A stays read.

## What I left out

- **Laws outside the brief's scope.** The premises cover only the laws named in the exits, the transition and the
  edges. The other theorems in the declarations have no `{law, takes}` yet: the seven GrammarPath laws, `stepWhile_*`,
  `toEnd_iff`, `constant_iff*`, `kind_toEnd_of_unmarked`, `toEnd_of_unmarked`, `alike_along`, `agrees_until_marked`, the
  lock section and the window laws. Family-A neighbours list nearly every theorem they declare. Their premises are
  mostly the ids above, plus `rulecapture-raises`, `-readsshare` and `-upper` for `locked_closed` and `locked_at_class`.
- **Existing premises' `lean` lists.** They do not name the TurningInTime laws that now take them, because the brief
  allowed only additions to the ledger.
