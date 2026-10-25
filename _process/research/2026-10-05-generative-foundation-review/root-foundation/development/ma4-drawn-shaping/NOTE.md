# MA4: what comes back to the shapers, read by readers drawn from the selected (kit note)

25 October 2026. AI-authored working note for board item MA4 (step 6 of [AJ's plan](../aj-joint-selection/PLAN.md)). The module is drafted in this kit's `tree/` as `Becoming.DrawnShaping`, a new leaf of the pure core on `Becoming.RuleShaping` (MA3) and `Becoming.ClosedCapture` (MA2), changing neither. Its statements go to its record and home section when it lands; this note says what was asked, what the Lean proves, its standing and what is open.

## 1. What was asked

[MA3's record](../../../../../../theories/becoming/results/records/shaping-the-rule-selected-by-what-comes-back.md) names as next "a theorem joining what comes back to the shapers with MA2's readers drawn from the selected", and its dependency on [MA2's record](../../../../../../theories/becoming/results/records/readers-drawn-from-the-selected.md) says "no theorem joins the two yet". AJ's plan reads the meta-attractor as conditions 1 and 2 failing together (control over the selection selected, and the rule it shapes locked); without the join that sentence is a reading, not a statement of the model. The alignment dossier (AJ4) has to say so too.

## 2. The join

MA3's rule after shaping, `shaped a s p c` (each shaper leaves `a + s + p`, each other `a + c + p`), is read by readers drawn from the population as it counts them (MA2's `Drawn.pool`): each shaper among the readers reads it with `hi` coming back to the shapers alone, each other with `lo`. The rule read at population `x` is `drawn a p c hi lo pos x`; at a reading step it is `drawnBack`; the course from `x` under the rule read there is `drawnCourse`.

## 3. What the Lean proves (scratch build, 25 theorems in 32 declarations, every axiom report empty)

- **The loop's premise from who reads.** `drawn_reads_iff`: the rule read reads the share (`ReadsShare`) exactly where `lo ≤ hi`. Through `shaped_le_iff` (two rules after shaping, alike but for what comes back, are ordered as what comes back) and MA2's `pool_reads_iff`.
- **The critical mass.**
  - `drawn_favours_iff`: at `x` the rule read favours the shapers (weakly) exactly where `x.carrier * c + x.other * c ≤ x.carrier * hi + x.other * lo`.
  - `drawn_favours_alike`: this does not depend on `a` or `p`.
  - `critical_iff`: with `lo ≤ c ≤ hi`, exactly where `x.other * (c - lo) ≤ x.carrier * (hi - c)`.
  - `alike_favours_iff`: with `lo = hi = s`, exactly where `c ≤ s`, at every share.
  - `favours_everywhere_iff`: with `lo ≤ hi`, the rule read favours the shapers at every share exactly where `c ≤ lo`.
  - `disfavours_everywhere`: with `lo ≤ hi < c`, it favours the others strictly at every share.
- **One loop.** With `lo ≤ hi`, under every schedule of reading, from a start under the rule read there:
  - `drawn_locks`: where that rule favours the shapers, every configuration of the course is locked (`RuleCapture.Locked`), and neither the share nor the rule in force is ever below the start;
  - `drawn_from_below`: where it favours the others, every configuration is locked the other way (`Locked` on the reversed order with `disfavours`), and neither the share nor the rule in force is ever above the start;
  - `drawn_rises`: favouring the shapers strictly at the start, shapers present, the share rises strictly at every step (through `upper_strictly`);
  - `drawn_falls`: favouring the others strictly, shapers present at the start, it falls strictly at every step (through `lower_strictly`, `present_drawn`, `drawn_carrier_pos`, MA3's `falls_strictly`).
- **Witness** `CriticalMass` (`a = 1`, `p = 0`, `c = 1`, `hi = 3`, `lo = 0`):
  - at one shaper to one other, five offspring to four (`even_favours`); locked from the start and rising at every step (`even_locks`, `even_rises`);
  - at one to three, seven to eight (`few_disfavours`), falling at every step (`few_falls`);
  - at one to two, six each (`at_mass`).

  In both starts each shaper's own readers give back three times the cost.

## 4. What it adds, and its standing

**Elementary.** With the readers drawn from the selected, the shapers' offspring number is linear in their frequency, so this is positive frequency-dependent selection with one unstable interior rest point: bistability, classical in population genetics and evolutionary game theory (for example the replicator dynamics of a coordination game; Hofbauer and Sigmund 1998). The threshold reading is that of Schelling's tipping (1971; 1978) and Granovetter's threshold models of collective behaviour (1978), and the lock that of Arthur's lock-in under increasing returns (1989). Hendrycks (2023) and the influence-seeking literature already in MA3's correspondence are the alignment comparators. All to be checked against publication records before landing.

**What it adds** is the join on the spine:
1. MA3's loop premise (what comes back monotone in the share, equivalent to `ReadsShare`) is derived from who reads: the shapers among the readers giving the shapers no less than the others do.
2. MA3's assumed threshold (`thresholdBack`, a step at one to one) is replaced by a critical mass derived from who reads, with its exact location and the three regimes: everywhere at `c ≤ lo`, a critical mass between, nowhere at `hi < c`.
3. The meta-attractor's two failures are one loop above the critical mass.
4. Below it control is not selected, yet the rule locks the other way. So condition 1 of the joint selection does not give condition 2 where readers are drawn from the selected; the two conditions are independent in this model.

**What it forbids** (under its premises): that a capacity is selected wherever its own readers repay it more than it costs (`CriticalMass.few_falls`); that what every member receives moves the critical mass (`drawn_favours_alike`); that keeping control over the selection unselected leaves the rule unlocked (`drawn_from_below`).

## 5. Open

- A loss read by the others among the readers once the shapers pass the critical mass, where MA2's timing (`Thinned.kept_iff`, `turned_iff`) meets this module: the point of no return derived from the rise.
- Readers who learn (`hi`, `lo` changing with the share), a cost changing with the share, readers not counted as the population counts them.
- `lo > hi` (the shapers among the readers giving the shapers less back): the rule read reads against the share (MA2's `pool_against`), not stated here.
- An independent review, then the landing (record, home section 02 §9 after MA3's, study section, 08's counts).
