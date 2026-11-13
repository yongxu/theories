AI-written (Opus reader), 13 November 2026

# R3 against the reader modules

The files below are in PKG (`…/lean/becoming/Becoming/`). Read only. The arithmetic was checked in python.

## 1. What a reader is

- **ReaderRebuilding** (`read` 87, `rebuild` 103): units that *raise* the level and draw on it only to rebuild. Age and the source end them; the source rebuilds them. A feeder, not a taker.
- **PoolFromCourse** (`windowRead` 252, `Stands` 256): readers read the loss while it is in `[N,K)`. A *rising* loss reaching `K` removes them, and they are never readmitted (`stands_not_readmitted` 271).
- **ClosedCapture** (`Drawn.pool` 558, `Thinned.lossPool` 785): a reading weighted by population count, thinned by selection. It never ends and is never rebuilt. It reads by reading.
- **ReadingsSpread** (`RevisesBy` 135): carriers of a reading in slots. A line is removed when what it requires falls below its need (focal 5, wide 1, `requires` 746). Revision rebuilds it.
- **FourReaders** (`need` 909): the gauges `near` (3) and `mid` (2) need more of the habitat than the dweller (1), draw nothing, and read *by their admission failing first* (`near_inTime`, `mid_atThePoint`).

**Verdict.** "Needs more than the whole, reads by ending" is FourReaders' gauge, not the design's part.
- The gauge uses nothing. Its ending changes no course; it informs a selection timed against `NoReturnAt`.
- The design's part uses the level, and its ending saves by removing that use. That is ReadingsSpread's focal, draining line, which ends first while the wide line holds (`overdrawn_spreads_then_ends` 1222): the *anti*-reader.
- In PoolFromCourse and ClosedCapture, removing or thinning readers is the harm, because the lock forms (`window_locked_after_removal` 342, `Thinned.read_late_kept`). Read with parts called readers, "do not shield what would end first" advises what the lock does.

Do not use "reader" for the part.

`«读者绝则无储»` (386):

```
(hs : r.source = .level) (hn : 1 ≤ r.count) … (gone : (step r on x).ages = []) : (step r on x).level = 0
```

- A reader rebuilt from the level has effective need 0. It is never a part that ends first (the `m ≤ n` case G5 excludes).
- Readers from `.supply` or `.none` end by age at their span (356, 365), not by a need.
- Their ending removes feeding, which hastens the whole's end.

## 2. Marks already derived from needs

- `Admission.lean:378` `Admits l t f := ∀ c, W.requires t f c → W.need t f c ≤ l c`
- `Continuation.lean:480` `family_ends_below_at … (below : W.stock ds t < m) … (high : m ≤ W.need t g e) : ¬ W.active t g`, and `ends_below_at` after it
- `ReadingsSpread.lean:421` `carriers_drawn_down`
- `Optimum.ends_within`: `∀ t, x 0 < m + t → x t < m`

What G1 to G7 restate:
- G2 is `List.filter` returning its list.
- G3(i)+(ii) is `kind_ends_while_net_goes` (TT:610) at `κ w := p ∈ w`.
- G5 is `turns_in_time_iff` instantiated.
- G7 follows from it and `Optimum.never_rises`: the course as it was never rises, so a larger `m` gives an earlier `T` and an `x_{T+1}` not lower.
- G6's shape is `Three` and `overdrawn_spreads_then_ends`.
- Only G4 is new.

## 3. The window

`window_alone_outside` (TT:850) marks `N ≤ x ∧ x < K`, where the readers *read*. Their removal (`x ≥ K`) is unmarked: the way after is `windowAlone` there.

The design's marks, for a fixed way, are a down-set `{x < max need}` where a part is *removed*. So:
- With `0 < N`, the window is unrepresentable.
- At `N = 0`, `m = K` matches the set, but the part is absent exactly where the readers read.
- Reading the level as `C − loss` aligns the direction, but the marks then fall where TT marks nothing.

Section 6's identification and the design's cannot both hold.

**The lock against G7.** `window_order_kept` (465): readers removed at a lower bound make share, loss and rule not lower. G7: an earlier removal keeps the line going. Both are threshold monotonicity, with opposite valence. The window's net is total and its loss accrues (no line ends), and nothing there lowers a need. Any tie is a reading only.

## 4. G7

**Under G5's premises it holds**, by the argument in §2:
- start below `m` (`T = 0`): fine;
- `m = n`: no `T` with `n ≤ x_T < n`, so it holds vacuously;
- start `≥ H₁+y₁`: holds whenever `Meets g H₂ y₂` holds (`y₂ ≤ y₁`);
- `min z (12−z)`, uses 1–5, starts 0–12: no violation.

**Without the regime premises it is false.** Giving `[0,1,3,0,5,3,2,4,3,0,2,4,6,3,2]`, parts `(m,1)` and `(2,2)`, start 5:
- `m = 5`: both parts stay and 5 is fixed;
- `m' = 6`: the first part ends at 5, and the levels run 5, 3, 2, 0, so the line ends.

**G5 defect.** Over `List Part`, `uses : ∀ w, Kept w → use w = H₂` is false. `turns` makes `[]` Kept at `x < n`, and `use [] = 0`. `AloneOutside` with `id` also fails for lists with needs above `m`. G5 needs a restricted `W` and `H₂ = 0`, or another `Kept` or `use`.

## 5. Sentences that say more than G1 to G7

- "all six follow": `uses` is false as set up (§4).
- "The mark … is an ending of a part that needs more": shown only for a `filter` way; section 6 contradicts it (§3).
- "two needs and a use": `H₂+y₂` stays a giving premise.
- G3(iii) "the part's ending where its net ends is the whole's turn": that is a different net, `[p]` alone. In the whole's net, `(w,x)` continues.
- "G7 is the plain form of 'do not shield'": needs are parameters, and G7 holds only under the regime premises. Shielding is not modelled.
- `Loop.keep` "same shape": a reading.
- G4's "until what remains holds": it rests on supplied `y S` with `Short`, `Meets` and `Keeps` for every `S`.
