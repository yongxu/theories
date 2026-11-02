# OG2: independent review of the second design (AI-written, 2 November 2026)

One Opus agent read og2/DESIGN.md as second drafted (commit `72c83470e`), reimplemented the rule and ran its laws. Its scripts are in review2-scripts/. Kept as it came back; the third design takes it up.

# OG2 second design: adversarial review

Most laws hold at their stated parameters on settled starts. §4.1's "forbidden" claim and §4's table are false, and the model's content is much thinner than §6 says.

## High

**H1. §4.1's "forbidden" claim fails: a rule with `q·s > g` can outlive its level.** L2 is true only from `settled`.
- **Witness (`s,l,g,f,q,L`):** `3,2,6,1,3,40`, with two off-steps. A revision to 0 and back, all steps on, does the same. Holders cycle on `[0,0,3]` and the level rises 1 a step, indefinitely.
- **Cause:** a new cohort enters at `t` iff one entered at some `t−j`, `j∈[l+1,s]`. Gaps persist only at `l = s−1` (s≤7, every pattern). There the cohorts form `s` separate strands.
- **Law found, not in DESIGN:** at `l = s−1`, from `k≥1` strands with their others, the rule is held forever iff `k·q+(s−k)·f ≤ g` (660,000 cases, 0 violations). L2's third condition is the `k=s` case.
- **Change:** add this law and restrict §4.1. L9's "`Within` is what remains" is also false.

**H2. §4's table is incomplete (question 4).** A held rule inside the window can still end everything.
- **Fourth end, breach:** `3,2,6,4,2,30`, all on, revise to 0 at step 1 and back to 2 at step 3. `q·s ≤ g` holds and the rule is held throughout, but the door opens two steps in three. Level 0 at step 16, gone at 17.
- **Breach also occurs as a transient at `l < s−1`:** `3,1,3,4,1,1`, after two off-steps or a revision to 0 and back (over 2,500 cases each way).
- **Fifth end, abandoned:** at `f=0`, or `.outside` with `q=0`, there is a level and no member, not `gone`. `2,1,5,0,1,3` with a revision to 0.
- **Sixth, a gapped mixed cycle that stays held:** H1's witness.
- **Row 1 needs `1≤f` and `q·s≤g`:** `1,1,1,1,3,1` is gone at step 1. `2,2,3,1,3,4` is gone at step 3.
- **Row 2's "gone, then" fails:** `3,3,6,4,2,1` ends with holders present.
- **Change:** make the table a function of door duty, and add breach and abandoned.

**H3. The model is one lemma and one bit of coupling (questions 1, 2).**
- **Level courses coincide:** `settled` under `.members`, the full queue under `.none` at `f:=q`, no holder at `f:=q`, and `settled` under `.outside` gave 0 differences in 2,433,600 steps. So L2's third condition, L3 overdrawn, L6, the ruin and L8 are one lemma: constant inflow `a`, tenure `s`, stock `(L,g)`. §6 counts them as separate content.
- **Question 1:** yes, the level is built in. L8 follows from the door clause, the cliff and that lemma. It does not need "all leave at once": L8 survives a rationed draw (9,450 cases, 0 failures). It needs "empty stays empty", which §5 only partly names. Dropping the `level = 0` clause broke nothing in my battery at `L≥1`; by inspection it breaks L5.
- **Question 2:** this is largely any boundary on a commons, with teaching added.
  - L2 is a conjunction of two independent models.
  - Dropping teaching loses more than §10 says: L3 unpassed, L4, L7 and L9 (no revision at `.outside`).
  - On the door side the quota has no size: no case had `q≥2` holding where `q=1` fails (s≤4, g≤12).
  - §1's "the door is only as strong as those who keep it" is false of the model. One teacher holds against any `f`.
- **Change (tried, cheap):** a door of strength `c` per teacher, so `max(0, f − c·T)` others enter past `T` teachers.
  - From settled, held forever with the level never falling iff `(q+max(0,f−c·q·(s−l)))·s ≤ g` (301,320 runs, 0 violations).
  - The window becomes two-sided. Among 12,555 parameter points, 2,587 admit no `q`, and at 648 `q=1` fails while a larger `q` works. Example: `s,l,g,f,c = 1,0,2,4,2` admits only `q=2`.
  - `s−l` now counts: at `s=4,g=20,f=6,c=1`, `l≤2` admits `q∈[1,5]` and `l=3` admits none, though `l<s`.
  - Keepers draw on what they guard, so a cost of keeping the door appears without being added. The present door is `c→∞`.
  - I tested this from settled only, not the other laws.

## Medium

**M1. L8 is one quadrant (question 3).** The full comparison is 2×2 and should be stated as such:

| | `f·s≤g` | `g<f·s` |
|---|---|---|
| `q·s≤g` | both go on | rule saves |
| `g<q·s` | **rule ruins** | either ends first, by horizon |

The ruin witness is `1,0,1,1,2,1`. "The rule's presence decides" overclaims by H2. What decides is the door standing at every step, not `Held`.

**M2. L7 is not exact (question 5).**
- The door clause needs `1≤s`: `0,0,0,1` brings nobody in.
- The keep clause needs `1≤L`: `1,0,1,1`, `L=0`, full others is gone.
- "Such a state" must mean no holder, not no teacher. `2,1,3,2,1,L≥1`, `[1,0]` is not ruined, and a holder returns.
- "Once full" hides a dead route: `1,0,1,1`, `L=1`, others `[5]` is gone at once.
- **Corrected keep clause:** no holder, `1≤s`, `1≤f`, `f·s≤g`, `1≤L`, `others = replicate s f`, all steps on. My derivation, not run: length ≤ `s` with every cohort ≤ `f` also suffices.
- The ruin holds as stated (lists longer than `s` included).

**M3. Hypotheses missing.**
- L2 needs "all on, no revision". One off-step kills at `s=1`.
- L3 unpassed needs settled, or holder lists no longer than `s`: `1,1,0,0,1,1`, `[0,1]` still holds after `s` steps. Only over-length lists failed.
- L9 needs "no revision back in the `s` steps": a return before the last exit restored holders in 17,148 cases.
- L10's "exactly where" is false over its three sources, since `.none` does not return either. Say "among the sources that can hold".
- `.outside` needs `1≤s` and `1≤L` to return: `1,0,1,0,'outside'`, `q=1`, `L=0` is gone.
- L10's head `l<s` contradicts "at every teaching age".

**M4. L3 overdrawn is false as literal equality.** `settled` has `others = []`, while a run gives `[0],[0,0]…` (41,395 mismatches). L6's `.none` needs "no holder": `1,1,1,1`, `H=[1]`. Define `settled` with `replicate s 0`, or compare by sums.

**M5. Order.** `sim2` matches the prose: 600,000 random steps, including off-steps, revisions, long lists and `s=0`, 0 differences. The laws depend on the order more than §5 says.

| Order changed | Effect |
|---|---|
| Enter before draw | L1, L2, L3, L6, L8 fail as stated; by derivation the threshold becomes `q(s+1)`. L2 witness: `1,0,1,0,1,1` |
| End after enter | L1, L2, L3, L6, L8 fail |
| Age before draw (also moves the teacher read) | L1, L2, L3, L6, L8 fail |
| Teach after age | L1, L2, L3, L8 fail |
| Revise before enter | Nothing failed |

So `q·s` counts the cohorts drawing, and it depends on the order.

**M6. The reader's sentences overclaim (question 6).**
- "Limiting their draw" is wrong. Each member's draw is fixed at one, and the rule limits entry.
- "An institution has one minimal model" reads as if the model defines what an institution is.
- **Proposed:** "a minimal model of one kind of institution: an entry rule on a shared stock, passed through members; no compliance, no records, no cost of keeping the door".

**M7. §3's "each was run" overclaims again, as REVIEW-1 found of the first draft.**
- `sim2` never checks L8; it prints four traces at one parameter set.
- It also does not check L7's door clause, L9's upward revision or Replaced.
- L1 is checked at level 3, `f=2` only. Off-steps appear only in L4 and L5.
- §5's "each variant below is in `sim2.py`" is false of pupillage, mixed tenures and schism.

## Low

- **Prose gaps:** step 1 does not say the step stops there (read literally, L5 breaks under `.outside`). The zero cohort on an off-step is unstated. Revision on the end step is silent; `sim2` keeps the quota, and the difference is unobservable.
- **Question 3 of §1:** only the quota can change. Tenure, teaching age and source are fixed, so "its rule has all changed" means one number.
- **Replaced:** "at most `s` cohorts" is unneeded at `s≥1`. The state has no labels, so "no founder" needs a trace.
- **`sim2`'s `renew-at-zero` cut** serves holders first, against "draw alike".

## What a hostile reader would call emptiest

- **Institutional economist:** a switch between two exogenous inflows on a linear stock. There is no enforcement cost, no defection, no choice of draw, and a quota that never reads the level.
- **Philosopher of institutions:** nothing is normative. "Holder" is a count, and the door is a clause.
- **Formal modeller:** one queue lemma renamed five times, with the interesting dynamics (H1) outside the stated laws.

The strength-`c` door answers the first and third objections in part. It does not answer the second.

## Literature (four searches, limited)

I did not find the pairing. Neighbours missing from §7:
- [Kandori 1992](https://ideas.repec.org/a/oup/restud/v59y1992i1p81-92..html): a folk theorem for overlapping finite-lived agents in an organization (abstract read).
- [Mankat 2024](https://ideas.repec.org/p/mar/magkse/202418.html): cultural transmission of norms in a common-pool game with a resource stock. The abstract mentions no entry rule, and I did not read the paper. It narrows §7's claimed absence to the entry rule and the door falling with its last teacher.
- [Brede and Boschetti 2009](https://eprints.soton.ac.uk/272862): costly obstruction of access (search summary only; the page returned 403).
- [PLOS ONE 2021, nine Dutch commons](https://ideas.repec.org/a/plo/pone00/0256803.html): sanctioning rules were more frequent early in a common's life (search summary only). This cuts against keepers being needed throughout.
- [Flentge, Polani and Uthmann 2001](https://jasss.soc.surrey.ac.uk/4/4/3.html): possession norms and sanctions spreading as memes (search summary only).

## Lean

**Axiom reports on v4.29.1:**
- **Bring `propext`:** `omega` (also `Quot.sound`), my `simp` sample, `Nat.add_sub_cancel`, `Nat.sub_add_cancel`, `Nat.add_mul`, `Nat.right_distrib`, `Nat.div_add_mod`, `Nat.div_eq`, `List.length_take`, `List.length_replicate`, `List.take_replicate`, `List.sum_append`.
- **Empty:** `Nat.left_distrib`, `Nat.succ_mul`, `Nat.mul_succ`, `Nat.mul_le_mul_*`, `Nat.add_le_add`, `List.sum_cons`, `List.take_succ_cons`, `decide`, `rfl`.

**Expected difficulty (my estimate):**
- **Hardest:** the ruin, which needs an existence claim from any others, a ramp, then a descent, with an early-end split and an explicit bound.
- **Next:** L3 and L6 in `L/d+1` form, since division lemmas carry `propext`. State them as `k·d ≤ L`, `L < (k+1)·d` and `r + k·d = L`. The neighbour left its general horizon as a conjecture, decided only at small levels.
- **Then:** L2's reverse direction, which composes three cases, and Replaced, which needs a trace.
- **Easy:** L1, L4, L5, L8 once the inflow lemma exists.

**Representation:** lists are right. `Fin s → Nat` would need `funext`, which brings `Quot.sound`. Use your own `sumL`, your own structural push-and-keep instead of `List.take`, and additive level statements. A scratch `sumL_rep` compiled with an empty report. One additive helper failed at my first attempt and I did not retry it.

## Should this go on to Lean?

Not yet. Lean would now prove L2 and the table as written, which fix a false picture: the window would read as the rule's condition, when it is only the settled state's. Take H1's strand law, H2's ends and M1's 2×2. Decide on the strength-`c` door, which I recommend because it is the only change I found that couples passing and limiting. Restate everything on one inflow lemma. Then re-run all laws under that door, since I tested it from settled only. A short re-check should do, not a third full review. If the door is declined, the corrected present model can go to Lean, but its reader sentence should then say "an entry threshold with a teaching condition", which is a smaller claim than "an institution".

## What I ran

Nothing in the repository changed, and no Lean was written for the model. All scripts are in `/private/tmp/claude-501/-Users-ren-theories/568486ee-fafd-4bf5-b667-a3da885f62a8/scratchpad/og2-review2/`:
- `rule.py`: the rule reimplemented from the prose.
- `diff.py`: differential test against a copy of `sim2`.
- `sim2_copy.py`: that copy, also run as it stands; it printed 0 counterexamples for the rule.
- `laws.py`: L1–L10 and Replaced, over s 0–5, l 0–6, g 0–12, f 0–4, q 0–4, L 0–12, narrower where lists are enumerated.
- `ends.py`, `reach.py`, `more.py`, `order.py`, `leak.py`: the ends table, reachability, the strand and L8 runs, order variants and the door variant.
- `ax.lean`, `ax2.lean`: axiom reports, the only Lean run.

Nothing here is proved. All results are bounded runs.
