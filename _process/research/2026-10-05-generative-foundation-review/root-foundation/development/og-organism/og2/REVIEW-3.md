# OG2: short re-check of the third design (AI-written, 2 November 2026)

The same Opus agent as [REVIEW-2](REVIEW-2.md), resumed, so not independent of its own proposal of the door. Commit `4544cf2f2`. Its scripts are in review3-scripts/. Kept as it came back.

**Re-check of OG2's third draft (commit `4544cf2f2`).** L1–L9 pass, and the quota's size on the door side is real. The claim that this joins passing and limiting does not survive.

## High

**H1. §1 and §6's "join passing and limiting" is false of L2–L4 (question 4). The join is keeping and limiting.**
- `steady` under `.members` and `.outside` had 0 state differences in 4,608,000 steps. Inside L4's region the source is never read.
- Split the one age into a teaching age `lt` and a keeping age `lk`: held iff `lt<s` and `(q+(f−c·q·(s−lk)))·s≤g`, with the subtraction truncated (322,560 runs, 0 violations). That gives two independent conditions again.
- The coupling is only the unlisted choice `lt=lk`. A guard force with no passing has the same band.
- Passing and limiting really meet only in Gaps and breach, where `k` sets both, and that is the part only run.
- **Change:** rewrite §1 and §6, list `lt=lk` in §2, and make Gaps a law.

## Medium

- **M1. The quota's size (H3) is gone, with limits.** The band is exactly:
  - `c(s−l)≥2`: integers from `max(1,⌈(f−A)/(c(s−l)−1)⌉)` to `A`, with `A=⌊g/s⌋`
  - `c(s−l)=1`: `[1,A]` if `f≤A`, else empty
  - `c=0`: `[1,A−f]`

  This gave 0 mismatches over 67,158 points, and should replace L3's cases. Only-`q>1` occurs at 4,595 points, all with `c(s−l)≥2`. In runs, `q=1` fails and a larger `q` holds at 38 of 5,200 points. Example: `1,0,2,4,2`, `L=1`.
- **M2. L9's table is exact, but its gloss is false (question 3).** All 19,620 bottom-left cases have `e=0` (13,056) or `c=0` (6,564), with no partial leak, and `e>0` with `c(s−l)≥1` cannot do it. Witness: `1,0,1,1,1`, `q=2`. Write: "it admits more than would have come, or turns no one away". The top-right holds only at `c(s−l)≥2` (all 15,032): a keeper must turn away more than itself.
- **M3. §9 claims what was not done.**
  - "Re-run over all laws" is false of sim3. It has no L10 or L12 and no revision run outside the region. L5 runs from `steady`, on-steps only, and L11's second clause is not run. So §3's "each was run" is false again. My runs pass these.
  - "Breach is now within `e q`" is false. At `3,2,6,4,2`, `q=2`, `L=30`, revising to 0 then back, the state is in band with `e=0`, but draws 10 in its cycle (`q+2f`). It is held to the last state and gone at step 17.
- **M4. §4.1 and L10 miss the band's lower edge.**
  - "Above its band" should be "outside". At `1,0,2,4,2`, `q=1`, `L=3`, the level is 0 at step 3 and gone at step 4.
  - A stricter revision ends it: `steady` at `q=2`, `L=1`, revised to 1, reaches level 0 at step 5.
- **M5. §5 is stale in two places (question 2).**
  - Entering before the draw gives `(q+e)(s+1)`, not `q(s+1)` (3,927 mismatches against 0). Witness: `1,0,2,1,0`, `q=1`.
  - Teaching after ageing also changes `e` to `s−l−1`, not just the window (351 mismatches against 0).
  - End after enter, age before draw, renewal from empty and rationing (L9 survives; L1's end moves) all behave as §5 says. Revising before entering broke nothing. A door shut with no teacher breaks L8's ruin and L9.
- **M6. §4's first row still fails.** `1,1,1,1,1`, `q=3`, `L=1` is gone at step 1. It needs no holder left, or `(q+f)·s≤g`.

## Low: misstatements Lean would expose

- **L8:** "others present at every step" fails at the start from `[]`. Write "after every step".
- **L11:** needs holders of at most `s` cohorts. `1,1,5,1,1`, `[0,1]` enters a holder. `.none` needs no holder at the start.
- **L12:** needs `1≤s`. `s=0`, `[3]` keeps its holder.
- **Gaps:** needs `1≤L`. `2,1,1,0,0`, `q=1`, `L=0`, pattern `(0,1)` fails.
- **Abandoned, "rising":** needs `1≤g`.
- **"Decided in Lean" (L3, Gaps):** no Lean exists yet.

## §6's "the content"

Not as written. L2 is L1 at `a(q)`, L3 is the closed form above, and L4 is one sum bound. Their real content is enforcement drawing on what it guards, which needs no passing. There is one more hidden lemma: Gaps has constant take, so L1, L8's tail, L9 and Gaps are one constant-take lemma.

## Question 1

L1–L9 hold over off-steps and over-long lists, as stated apart from L8's wording. L10–L12 and Gaps hold with the fixes above.

## Go to Lean?

**Yes**, after these changes:
1. H1's rewording and Gaps as a law.
2. The closed-form band.
3. M2–M6 and the Low fixes.
4. L5 off-steps, L10 and L12 added to sim3.

No further review is needed if the laws' statements change only as listed.

## What I ran

No Lean, and nothing in the repository changed. `rule3.py` is written from §2's prose; it had 0 differences from `sim3.step` over 500,000 random steps. A copy of sim3 printed 0 counterexamples. Law ranges were s≤5, g≤21, f≤6, c≤4, varying by law. Everything is bounded runs, not proof.

Scripts are in `/private/tmp/claude-501/-Users-ren-theories/568486ee-fafd-4bf5-b667-a3da885f62a8/scratchpad/og2-review3/`:
- `diff3.py`
- `laws3.py`
- `q4.py`
- `variants3.py`
