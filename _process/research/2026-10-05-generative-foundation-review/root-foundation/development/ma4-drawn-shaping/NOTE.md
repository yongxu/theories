# MA4: what comes back to the shapers, read by readers drawn from the selected (kit note)

25 to 26 October 2026. AI-authored working note for board item MA4 (step 6 of [AJ's plan](../aj-joint-selection/PLAN.md)). The module is drafted in this kit's `tree/` as `Becoming.DrawnShaping`, a new leaf of the pure core on `Becoming.RuleShaping` (MA3), `Becoming.ClosedCapture` (MA2) and `Becoming.ChoiceCountCapture` (for one lemma, `lower_strict`), changing none of them. Its statements go to its record and home section when it lands. This note says what was asked, what the Lean proves, its standing, what is open, and what was taken from the [independent review](REVIEW-MA4.md).

## 1. What was asked

[MA3's record](../../../../../../theories/becoming/results/records/shaping-the-rule-selected-by-what-comes-back.md) names as next "a theorem joining what comes back to the shapers with MA2's readers drawn from the selected", and its dependency on [MA2's record](../../../../../../theories/becoming/results/records/readers-drawn-from-the-selected.md) says "no theorem joins the two yet". AJ's plan reads the meta-attractor as conditions 1 and 2 failing together (control over the selection selected, and the rule it shapes locked). Without the join that sentence is a reading, not a statement of the model. The alignment dossier (AJ4) has to say so too.

## 2. The join

MA3's rule after shaping, `shaped a s p c` (each shaper leaves `a + s + p`, each other `a + c + p`), is read by readers drawn from the population as it counts them (MA2's `Drawn.pool`): each shaper among the readers reads it with `hi` coming back to the shapers alone, each other with `lo`. Both kinds of reader read the same `a`, `p` and `c`. The rule read at population `x` is `drawn a p c hi lo pos x`; at a reading step it is `drawnRead`; the course from `x` under the rule read there is `drawnCourse`.

## 3. What the Lean proves (scratch build, 31 theorems in 38 declarations, every axiom report empty)

- **The loop's premise, moved to who reads.**
  - `drawn_reads_iff`: the rule read reads the share monotonically (`ReadsShare`) exactly where `lo ≤ hi`. The proof composes `shaped_le_iff` (two rules after shaping, alike but for what comes back, are ordered as what comes back) with MA2's `pool_reads_iff`.
  - `drawn_against`: with `hi ≤ lo` the rule read reads against the share (MA2's `pool_against`).
- **The critical mass.**
  - `drawn_favours_iff`: at `x` the rule read favours the shapers (weakly) exactly where `x.carrier * c + x.other * c ≤ x.carrier * hi + x.other * lo`. `drawn_lt_iff` is its strict converse.
  - `drawn_favours_alike`: neither `a` nor `p` moves this.
  - `critical_iff`: with `lo ≤ c ≤ hi`, exactly where `x.other * (c - lo) ≤ x.carrier * (hi - c)`.
  - `alike_favours_iff`: with `lo = hi = s`, exactly where `c ≤ s`, at every share.
- **The regimes, exactly.**
  - `favours_everywhere_iff`, with no hypothesis: the rule read favours the shapers at every share exactly where `c ≤ lo ∧ c ≤ hi`.
  - `disfavours_strictly_everywhere_iff`, with no hypothesis: it favours the others strictly at every share exactly where `lo < c ∧ hi ≤ c`. The boundary `hi = c`, `lo < c` is "nowhere".
  - `critical_mass_iff`, with `lo ≤ hi`: some share favours the shapers and another the others strictly exactly where `lo < c < hi`.
  - So with `lo ≤ hi` there are three regimes:
    - favoured everywhere where `c ≤ lo`;
    - a critical mass where `lo < c < hi`;
    - favoured nowhere where `lo < c` and `hi ≤ c`.
- **One loop, either way.** With `lo ≤ hi`, under every schedule of reading, from a start under the rule read there:
  - `drawn_locks`: where that rule favours the shapers, every configuration of the course is locked (`RuleCapture.Locked`), and neither the share nor the rule in force is ever below the start.
  - `drawn_from_below`: where it favours the others, every configuration is locked the other way (`Locked` on the reversed order with `disfavours`), and neither the share nor the rule in force is ever above the start.
  - `drawn_locked_either`: every such course is locked one way at every step or the other way at every step.
  - `drawn_rises`: where the start favours the shapers strictly, the shapers present, the share rises strictly at every step. It goes through `upper_strictly`.
  - `drawn_falls`: where the start favours the others strictly, shapers present at the start, it falls strictly at every step. It goes through `ChoiceCountCapture.lower_strict`, `present_along_course`, `drawn_carrier_pos` and MA3's `falls_strictly`.
  - `present_along_course`: carriers present stay present along every course whose reading gives each carrier an offspring.
- **Witness `CriticalMass`** (`a = 1`, `p = 0`, `c = 1`, `hi = 3`, `lo = 0`):
  - From one shaper to one other, five offspring to four (`even_favours`). The course is locked from the start and the share rises at every step (`even_locks`, `even_rises`).
  - From one to three, seven to eight (`few_disfavours`). The course is locked the other way and the share falls at every step (`few_locks`, `few_falls`).
  - At one to two, six each (`at_mass`), and the share stays where it is (`at_mass_stays`).
  - In every start the shapers among the readers read three times the cost as coming back.
- **Witness `Against`** (`c = 1`, `hi = 0`, `lo = 3`), `not_locked`:
  - from one to one the rule read favours the shapers strictly, five to four;
  - read at every step, the course is not locked at step 1;
  - the rule in force at step 2 (21 to 18) is below the start's.
  - So `drawn_locks` needs `lo ≤ hi`.

## 4. Standing, what it adds, what it forbids

**Standing: elementary.**
- Where `lo < c < hi` the model is the stag hunt in which the second strategy's payoff does not depend on the partner:
  - a shaper meeting a shaper leaves `a + p + hi`;
  - a shaper meeting an other leaves `a + p + lo`;
  - an other meeting anyone leaves `a + p + c`.
- The critical mass is its mixed equilibrium, at the shapers' share `(c − lo)/(hi − lo)`.
- Risk dominance compares `hi + lo` with `2c` (Harsanyi and Selten 1988, *A General Theory of Equilibrium Selection in Games*; Skyrms 2004, *The Stag Hunt and the Evolution of Social Structure*). That Skyrms's stag hunt has the partner-independent second payoff is from memory, not checked in the text.
- Both readings give each other `a + c + p`, so the rule read is the frequency-weighted mean of the two readings up to a common factor. Reading at every step is therefore discrete-time replicator selection, up to a lag of one step: the rule in force is read from the population before (Hofbauer and Sigmund 1998, *Evolutionary Games and Population Dynamics*).
- The threshold reading is that of binary choices with externalities:
  - Schelling 1973, *J. Conflict Resolution* 17(3):381–428. This is closer than Schelling 1971, *J. Math. Sociol.* 1:143–186, which is spatial segregation.
  - Schelling 1978, *Micromotives and Macrobehavior*, chapters 3 and 7.
  - Granovetter 1978, *AJS* 83(6):1420–1443. His thresholds are distributed; here there is one.
  - Oliver, Marwell and Teixeira 1985, *AJS* 91(3):522–556, for the term "critical mass".
- The lock is the lock-in of increasing returns (Arthur 1989, *Economic Journal* 99(394):116–131). There it comes from random arrivals; here the start decides it.
- A biology comparator for readers who favour their own kind is the greenbeard (Gardner and West 2010, *Evolution* 64(1):25–38). Only the bibliographic record is verified.
- "Bistability" is the literature's description. The Lean proves the direction at every step on each side of the mass and the lock under every schedule, not convergence to either boundary state.
- The lock half is near-definitional. `drawn_locks` and `drawn_from_below` are `RuleCapture`'s `locked_stays` and `locked_not_below` at a start read there, and `drawn_reads_iff` is a two-step composition. What is new on the spine is the critical-mass computation: `drawn_favours_iff`, `drawn_lt_iff`, `critical_iff`, the three regime iffs and the witnesses.
- The credits were verified against publication records by the reviewer (REVIEW-MA4.md, finding 9).

**What it adds, for this model.**
1. MA3's loop premise, `ReadsShare`, is moved to who reads, not removed. For the rule read by readers drawn from the selected it is equivalent to `lo ≤ hi` (`drawn_reads_iff`); with `hi ≤ lo` the rule read reads against the share (`drawn_against`). MA3 enters through `shaped`, `present_of_le` and `falls_strictly`; its `byBack` laws are not used.
2. MA3's assumed threshold (`thresholdBack`, a step at one to one) is replaced by a critical mass computed from who reads, with its exact location (`critical_iff`) and its exact regimes (`favours_everywhere_iff`, `disfavours_strictly_everywhere_iff`, `critical_mass_iff`).
3. Above the critical mass one start condition gives both of the meta-attractor's failures. The capacity's share rises at every step, the shapers present (`drawn_rises`), and every configuration is locked (`drawn_locks`). At the mass the share stays (`at_mass_stays`). Whether a reading of a loss beyond the share comes too late to leave this lock is not joined here.
4. Below it control is not selected, yet the course is locked the other way: the rule in force favours those without the capacity and stays a monotone reading of the share.
   - This is no capture by the shapers. It is the same closed reading as ClosedCapture's: every course from the rule read at its start is locked one way or the other (`drawn_locked_either`).
   - So condition 1 holding does not unlock the rule. Condition 2 needs a reading beyond the share (closed capture, MA2's `Thinned`), which is not joined here.
   - The model does not show the two conditions independent: it shows that condition 1 does not give condition 2, and it cannot show the converse.

**What it forbids, in this deterministic model**, under its premises, each with its known source:
- **That a capacity is selected wherever the shapers among the readers read more coming back than it costs** (`c < hi`). Below the mass it falls (`CriticalMass.few_falls`).
  - In any coordination game, a strategy that is best against itself is not selected from outside its basin.
  - This holds only without noise. Under rare mutation in a large finite population the long-run state is the risk-dominant one (Kandori, Mailath and Rob 1993, *Econometrica* 61(1):29–56; Young 1993, *Econometrica* 61(1):57–84).
  - In the witness `hi + lo = 3 > 2c = 2`, so that long-run state is capture by the shapers.
- **That what every member receives moves the critical mass** (`drawn_favours_alike`). This is MA3's `favours_alike` carried through the pool.
- **That a rule read from the share alone is left unlocked where control is not selected** (`drawn_from_below`, `drawn_locked_either`). This is the closed reading of ClosedCapture.

## 5. Open

- **The timing of a loss.** A loss read by the others among the readers once the shapers pass the critical mass, where MA2's timing (`Thinned.kept_iff`, `turned_iff`) meets this module: the point of no return, derived from the rise (a candidate MA4b).
- **What the model holds constant or leaves out.**
  - Readers who learn (`hi`, `lo` changing with the share).
  - A cost changing with the share.
  - Readers not counted as the population counts them.
  - Noise: the risk-dominant selection of Kandori, Mailath and Rob, and Young.
  - Convergence to the boundary states.
- **A mixed point.** Where `lo > hi` and `hi < c ≤ lo`, the rule read favours the shapers at some share but not at every share. That is a mixed point, not a critical mass. It is derived by hand from the two regime iffs and not stated in Lean.
- **Rule-9 candidates for `RuleCapture`'s owner** (review findings 13 and 14):
  - The generic lock at a start read there (the reviewer's `read_start_locks`). MA3's `threshold_from_above`/`threshold_from_below`, `ChoiceCountCapture.counted_locks` and this module's `drawn_locks`/`drawn_from_below` all prove it inline.
  - `upper_strictly`, beside `ChoiceCountCapture.lower_strict`.
  - `present_along_course`, of which MA3's `threshold_present_below` is an instance.

## 6. What was taken from the review

The review is [REVIEW-MA4.md](REVIEW-MA4.md); its probe is kept as `review-probe-DrawnShapingProbe.lean.txt`. It found no unsound Lean and gave the verdict "land after the listed fixes". Taken, by finding:

- **1, 2 and 8 (the regimes).**
  - The regimes are stated exactly.
  - Added: the hypothesis-free iffs `favours_everywhere_iff` and `disfavours_strictly_everywhere_iff` and the helper `drawn_lt_iff` (all from the probe), and the new `critical_mass_iff` (with `lo ≤ hi`, a share decides exactly where `lo < c < hi`). These replace the earlier step forms.
  - `lo ≤ hi` is restored in the summary and the readings.
  - Reading (c) is restated with `critical_iff` and the boundary.
- **3 (independence).** "Independent" is withdrawn. `drawn_locked_either` is added, in the stronger form "one way at every step".
- **4 and 5 (readings a and b).** Both readings are restated without the equivocation on "lock". `CriticalMass.at_mass_stays` and `CriticalMass.few_locks` are added.
- **6 (moved, not derived).** "Moved to who reads, not removed" is used everywhere: here, in the module, and in AJ's plan step 6.
- **7 and 9 (scope and credits).**
  - The forbidden items are labelled "in this deterministic model", each with its known source.
  - The stag-hunt correspondence and the noise bound are in the module docstring.
  - The credits are as the reviewer verified them.
- **10 (naming).** "Read as coming back" replaces "give back", and "the shapers among the readers" replaces "each shaper's own readers". "Repay" is gone.
- **11 (what is not derived).** It now names:
  - the same `a`, `p` and `c` for both kinds of reader;
  - starts under the rule read there (`RuleCapture.Reversed.not_absorbed`);
  - no noise.
- **12 (wording).**
  - "Monotonically" is added where the premise is stated.
  - `drawn_split`'s docstring is corrected.
  - The module now says that `favours` and `disfavours` are weak.
  - The summary says "at the mass both hold and the share stays".
- **13 (duplicates).**
  - `lower_strictly` is dropped for `ChoiceCountCapture.lower_strict`, and its import is added.
  - `upper_strictly` is kept as its mirror.
  - `present_drawn` is generalized to `present_along_course`.
- **14 (the generic lock).** It is recorded as a rule-9 candidate for the integrator (§5). The record's standing says the lock half is near-definitional.
- **15 (additions).** Added: `drawn_against`, `drawn_locked_either`, `CriticalMass.few_locks`, `CriticalMass.at_mass_stays`, and `Against.not_locked` (the reviewer's `locks_needs_step`).
- **16 (name).** `drawnBack` is renamed `drawnRead`.

Not taken: the generic `read_start_locks` in this module. A general law of `RuleCapture` belongs in `RuleCapture`, and its owner decides on the board (rule 9).
