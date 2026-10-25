# MA4: the independent review

25 to 26 October 2026. One independent read-only review by a separate AI agent (Claude Opus, in a subagent of the drafting session), of `tree/Becoming/DrawnShaping.lean` and `NOTE.md` as committed at `ca83edcb4` with one docstring fix after it (the direction of the reversed lock in `drawn_from_below`). It rebuilt the module, ran probes in its own scratch folder and edited nothing in the repository. Its report follows verbatim; what was taken is in NOTE.md §6.

---

I found no unsound Lean, but the text needs fixes before landing. Rebuilt independently, the module gives 25 theorems in 32 declarations with every axiom report empty, and every declaration's docstring matches its statement. The problems are in the module docstring (its summary bullets and readings) and in NOTE.md §4. I edited nothing in the repository; the probe module is in my scratch folder.

**Files**
- M = `/Users/ren/theories/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ma4-drawn-shaping/tree/Becoming/DrawnShaping.lean`
- N = `/Users/ren/theories/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ma4-drawn-shaping/NOTE.md`
- Probes (scratch, not in the repository): `/private/tmp/claude-501/-Users-ren-theories/b7c6b747-6b9c-4356-8b68-e395f26999fa/scratchpad/ma4-review/tree/Becoming/DrawnShapingProbe.lean`

**Soundness: confirmed.**
- I built a byte-identical copy (sha256 `e5a3cc33…`) with `scratch_build.py`. The module was compiled and audited, not restored from the cache; `unclean` [], 25 theorems in 32 declarations, `with_axioms` {}.
- A direct `#print axioms` over all 32 declarations reports "does not depend on any axioms".
- It imports only `RuleShaping` and `ClosedCapture`, both on the checker's core list.
- The probe module (it imports `DrawnShaping` and `ChoiceCountCapture`) also built cleanly: 16 theorems in 17 declarations, every axiom report empty, no `omega`, `simp` or iff rewrites. A deliberately false `decide` fails as it should.
- The build script stores passing steps in `~/.cache/becoming-lean`, which is outside the repository.

## Findings

**1. error — M:29–33.**
- Text: "Outside that range no share decides either: the rule read favours the shapers at every share exactly where the others among the readers give back at least the cost (`favours_everywhere_iff`), and where the shapers among them give back less than it, it favours the others strictly at every share (`disfavours_everywhere`)."
- Both theorems take `step : lo ≤ hi`. The sentence drops it, and without it both halves are false:
  - `everywhere_needs_step`: a=1, p=0, c=1, hi=0, lo=1. Here `c ≤ lo`, yet at one to one each shaper leaves 3 and each other 4.
  - `disfavours_needs_step`: c=1, hi=0, lo=5. Here `hi < c`, yet with no shapers the rule read favours the shapers 6 to 2.
- The partition is also wrong. Inside `lo ≤ c ≤ hi`:
  - at `c = lo` the rule read favours at every share;
  - at `c = hi` with `lo < c` it favours at none (`at_hi_nowhere`: c = hi = 3, lo = 0).
  - A share decides exactly where `lo < c < hi`.
- Fix, replacing M:27–33: "With `lo ≤ c ≤ hi` this is `x.other * (c - lo) ≤ x.carrier * (hi - c)` (`critical_iff`), so where `lo < c < hi` a share decides: the shapers stand to the others at least as `c - lo` to `hi - c`. With readers alike … (`alike_favours_iff`). With `lo ≤ hi`, no share decides elsewhere: the rule read favours the shapers at every share exactly where `c ≤ lo` (`favours_everywhere_iff`); where `hi < c` it favours the others strictly at every share (`disfavours_everywhere`); at `c = hi`, `lo < c`, it favours the shapers at none (`critical_iff`)."
- Optional Lean, built, needing no hypothesis:
  - `favours_everywhere_iff' : (∀ x, favours (drawn a p c hi lo pos x)) ↔ c ≤ lo ∧ c ≤ hi`
  - `strictly_disfavoured_everywhere_iff : (∀ x, (drawn … x).carrier < (drawn … x).other) ↔ lo < c ∧ hi ≤ c`

**2. error — M:51–58 (the summary) and M:65–74 (readings b and c).**
- The summary says the selection and the lock "are one loop with a critical mass" with no `lo ≤ hi`, which `drawn_locks` and `drawn_from_below` need.
- Probe `locks_needs_step` (c=1, hi=0, lo=3, from one to one, read every step):
  - the start's rule read favours strictly, 5 to 4;
  - yet the course is not `Locked` at step 1;
  - and the rule in force at step 2, 21 to 18, is below the start's.
- "With a critical mass" also needs `lo < c < hi`.
- Readings (b) and (c) carry `lo ≤ hi` only through the word "even".
- Reading (c), "the critical mass at `c` shapers to `hi - c` others", needs `c ≤ hi` (`critical_iff`'s `covers`) and cites no theorem.
- Reading (c), "falls at every share", needs the shapers present, and it also holds at `hi = c`.
- Fix, M:51–52: "…drawn from those it selects and the shapers among the readers read at least as much coming back to the shapers as the others among them do (`lo ≤ hi`), … are one loop, with a critical mass where `lo < c < hi`: …"
- Fix, reading (c): "With `lo = 0` and `c ≤ hi` the critical mass is `c` shapers to `hi - c` others (`critical_iff`). With `lo ≤ hi`, where `hi ≤ c` and `lo < c`, the share falls at every step from every start with shapers present (`disfavours_everywhere` for `hi < c`, `critical_iff` at `hi = c`; `drawn_falls`)."

**3. error — N:43, "the two conditions are independent in this model".**
- With `lo ≤ hi`, every course from the rule read at its start is locked one way or the other at every step. I built this as `drawn_locked_either`.
- The configuration holds nothing beyond the share.
- So condition 2, as AJ's PLAN §1 states it ("leaves it by reading what lies beyond its share before the loss passes its point of no return"), holds at no course of this model.
- The model shows that condition 1 does not give condition 2. It cannot show the converse, so it does not show independence.
- Fix: "4. Below it control is not selected, yet the course is locked the other way. In this model, whose rule is read from the share alone, every course from the rule read at its start is locked one way or the other, so condition 1 holding does not unlock the rule. Condition 2 needs a reading beyond the share (closed capture, MA2's `Thinned`), which is not joined here."

**4. overclaim (equivocation on "lock") — M:65–69 (reading b) and N:45, third item.**
- "Locks the other way" is an honest name for `drawn_from_below`:
  - `Locked (reverse order) disfavours h p` unfolds to `disfavours p.2 ∧ order.le (h p.1 p.2) p.2`;
  - that is the sense of `RuleCapture.Reversed.locked_down` and MA2's `read_in_time_turns`.
- The inference then slides from this formal lock to condition 2's lock, one not left in time by a reading beyond the share.
- MA4 has no loss and no such reading. So "keeping control unselected leaves the rule locked by the share all the same" holds by the model's premise, which ClosedCapture already states ("What leaves is a change of the law …"), not by the critical mass.
- The lock below the mass is a lock against the shapers, not the meta-attractor's capture.
- "Keeping" suggests an act; the model has only starts below the mass.
- Fix: "Below the critical mass the capacity is not selected (its share never rises, `drawn_from_below`; strictly falls where strict, the shapers present, `drawn_falls`), and the course is still locked, the other way: the rule in force favours those without the capacity and stays a monotone reading of the share. This is no capture by the shapers. It is the same closed reading (`ClosedCapture`): here every course from the rule read at its start is locked one way or the other. So control not selected does not by itself give a lock left in time; leaving needs a reading of what lies beyond the share, which this model does not contain (MA2's `Thinned`, not joined)."

**5. overclaim — M:61–64 (reading a) and N:42.**
- The text says the two failures "are one loop from above the critical mass (`drawn_locks`)".
- `drawn_locks` takes weak favouring and gives "never below" plus the lock. "Control over the selection selected" needs the strict rise, which is `drawn_rises` (strict start, shapers present).
- At the mass the share stays where it is (built: `at_mass_stays`).
- That a reading of a loss would come too late is MA2's timing, which is open (N:49).
- Fix: "…(`lo ≤ hi`), above the critical mass one start condition gives both: the capacity's share rises at every step, the shapers present (`drawn_rises`), and every configuration is locked (`drawn_locks`); at the mass the share stays. Whether a reading of a loss beyond the share comes too late to leave this lock is not joined here."

**6. overclaim — N:40, "MA3's loop premise … is derived from who reads".**
- `drawn_reads_iff` is an equivalence: the premise is moved to `lo ≤ hi`, not discharged.
- MA2's record says "moved to who reads, not removed", and M:78 itself says "moved".
- `byBack`, `covering_locks` and MA3's threshold laws are unused, and no theorem relates `drawnBack` to `byBack`.
- Fix: "1. MA3's loop premise, `ReadsShare`, is moved to who reads, not removed: for the rule read by readers drawn from the selected it is equivalent to `lo ≤ hi` (`drawn_reads_iff`). MA3 enters through `shaped`, `present_of_le` and `falls_strictly`; its `byBack` laws are not used."

**7. overclaim (scope) — N:45 "What it forbids", and M:70.**
- All three items are true in the model, but none is open in the neighbouring literature or specific to the join.
- (i) `few_falls` refutes "selected wherever hi > c". In any coordination game, a strategy that is best against itself is not selected from outside its basin. It also holds only of courses without noise:
  - in the witness `hi + lo = 3 > 2c = 2`, so the shapers' state is risk dominant (critical share 1/3);
  - under rare mutation in a finite population the long-run state is the shapers' (Kandori, Mailath and Rob 1993; Young 1993).
- (ii) The same addition to both kinds moves no rest point; this is MA3's `favours_alike` carried through the pool.
- (iii) This is the closed reading of ClosedCapture; cite it with `drawn_locked_either`.
- Fix: label the items "in this deterministic model", give each its known source, and add the noise bound to "What is not derived".

**8. imprecision — N:41, "everywhere at `c ≤ lo`, a critical mass between, nowhere at `hi < c`".**
- The boundary `c = hi` with `lo < c` is "nowhere".
- Exact regimes, with `lo ≤ hi`:
  - favoured at every share exactly where `c ≤ lo`;
  - a critical mass exactly where `lo < c < hi`;
  - favoured at no share exactly where `hi ≤ c ∧ lo < c` (the built iffs of finding 1).
- When `lo > hi`, "favoured at some share and not all" also holds for `hi < c ≤ lo`. That is a mixed point, not a critical mass (derived by hand from the two iffs, not stated in Lean).

**9. imprecision (standing and credits) — N:37.**
- "One unstable interior rest point" holds only where `lo < hi` and `lo < c < hi`.
- The Lean states the direction at every step on each side and the lock, under every schedule. It proves no convergence to the boundary states, so "bistability" is the literature's description, not what is proved.
- Closest known result: the stag hunt in which the second strategy's payoff does not depend on the partner:
  - shaper meeting shaper `a+p+hi`, shaper meeting other `a+p+lo`, other meeting anyone `a+p+c`;
  - the critical mass is its mixed equilibrium, at shapers' share `(c−lo)/(hi−lo)`;
  - risk dominance compares `hi + lo` with `2c` (Harsanyi and Selten 1988).
- Because both readings give each other `a + c + p`, the unnormalized pool is the frequency-weighted mean. So the correspondence to discrete-time replicator selection is exact up to the reading lag.
- Credits:
  - Hofbauer and Sigmund 1998 ✓.
  - Skyrms 2004 ✓; that his stag hunt has the partner-independent second payoff is from memory, not checked in the text.
  - Schelling 1973, *J. Conflict Resolution* 17(3):381–428 ✓ (binary choices with externalities). It is closer than Schelling 1971 (*J. Math. Sociol.* 1:143–186 ✓), which is spatial segregation.
  - Schelling 1978, chapter 3 (critical-mass models) and chapter 7 (binary choices); chapter numbers come from a 2006-edition contents listing.
  - Granovetter 1978, *AJS* 83(6):1420–1443 ✓; his thresholds are distributed, here there is a single one.
  - Oliver, Marwell and Teixeira 1985, *AJS* 91(3):522–556 ✓, for the term "critical mass".
  - Arthur 1989, *Economic Journal* 99(394):116–131 ✓; his lock-in comes from random arrivals, here the start decides deterministically.
  - Kandori, Mailath and Rob 1993, *Econometrica* 61(1):29–56 ✓, and Young 1993, *Econometrica* 61(1):57–84 ✓.
  - Biology comparator for readers who favour their own kind: greenbeards (Gardner and West 2010, *Evolution* 64(1):25–38). Only the bibliographic record is verified; that obligate-cost greenbeards need a critical frequency I could not confirm in the text.

**10. imprecision (naming rule).**
- "repay" (M:70, N:45) is an exchange word, the kind earlier reviews struck.
- "each shaper's own readers" (M:48–49, 70, 73; N:33, 45): no reader belongs to a shaper.
- "give back" (M:23, 31–32, 53, 57, 63, 73, 77, 124, 143, 158–159, 189, 200; N:33, 51) makes readers agents of a giving the model does not contain. MA3's word is "comes back", and M:43 already has the exact form.
- Fix for M:70: "A capacity for which the shapers among the readers read more coming back than it costs (`c < hi`) is not thereby selected: …"
- Fix for M:48–49: "In both starts the shapers among the readers read three times the cost as coming back, so that does not decide; how many of the readers are shapers does."
- Elsewhere replace "give back" with "read as coming back".

**11. imprecision — M:76–85 "What is not derived".**
- M:77 says "more back"; the premise is `lo ≤ hi`, so it should say "at least as much".
- Add these unstated choices:
  - both kinds of reader read the same `a`, `p` and `c` and differ only in what comes back to the shapers alone, which is why MA2's caveat on pool sizes does not bite here;
  - starts are under the rule read there; a rule in force against the reading can carry the share across the mass (`RuleCapture.Reversed.not_absorbed`);
  - with `hi ≤ lo` the rule read reads against the share (`pool_against`);
  - there is no noise.

**12. imprecision (minor).**
- M:21–23 and M:123–125: `drawnBack` reads the share for every `hi` and `lo`; what `lo ≤ hi` gives is that it reads it monotonically. MA2's `pool_reads_iff` says "monotonically"; use that.
- M:137 (`drawn_split`): for the others' kind the part is the cost, not "what comes back". Say "the part from `s` and `t`, and the part from `a + p`".
- The module never says `favours` and `disfavours` are weak (MA3's does). At the mass both locks hold and the share stays, so M:56 "the critical mass decides which way" needs "at the mass, neither". Add MA3's sentence and cite `at_mass_stays`.

**13. suggestion (board rule 9) — M:270–281 and M:303–327.**
- `lower_strictly` restates `ChoiceCountCapture.lower_strict` (ChoiceCountCapture.lean:327), proof included. Built: `lower_strictly_is_lower_strict : ∀ {g g'}, order.le g' g → g.carrier < g.other → g'.carrier < g'.other := @ChoiceCountCapture.lower_strict`, which typechecks. That is two paths to one fact.
- Options:
  - Lift `lower_strict` and its mirror `upper_strictly` beside `CarrierCounts.upper`/`lower` in RuleCapture. This changes two landed modules, so it is the owners' call on the board.
  - Or import `ChoiceCountCapture` (a core module) and use its lemma.
  - At minimum, the record should name the duplicate.
- `present_drawn` uses nothing of `drawn` except `drawn_carrier_pos`. It is a general law that MA3's `threshold_present_below` also instantiates.

**14. suggestion (rule 9; what the join adds).**
- Built, generic in `S`, `R`, `P`, `M`, axiom-free: `read_start_locks (raises) (monotone : ReadsShare P M h) (upper) (fav : favours (h x g)) (k) : Locked M favours h (paced f h reads (x, h x g) k) ∧ P.le x (…).1 ∧ M.le (h x g) (…).2`.
- `drawn_locks'` and `drawn_from_below'` restate the module's two theorems word for word as one-line instances of it.
- `ChoiceCountCapture.counted_locks` and MA3's `threshold_from_above`/`below` prove the same pattern inline.
- So the lock half of MA4 is near-definitional, and `drawn_reads_iff` is a two-step composition (`pool_reads_iff`, then `shaped_le_iff`).
- What is new on the spine is the critical-mass computation (`drawn_favours_iff`, `critical_iff`, the regimes, the witness), which is elementary. The record's standing should say so, and the board row should say why MA4 is a leaf.

**15. suggestion (gaps a careful reader needs).** All built and axiom-free:
- `drawn_against (readers : hi ≤ lo) : ReadsShare order (reverse order) (drawnBack …)`, the complement of `drawn_reads_iff` that N:51 leaves open, with `locks_needs_step` as its witness.
- `drawn_locked_either (step : lo ≤ hi) : Locked … ∨ Locked (reverse order) disfavours …`, which turns M:56 "either way the rule locks" and finding 3 into theorems.
- `few_locks`, the reversed lock from one to three, which is the course reading (b) is about.
- `at_mass_stays`.

**16. suggestion (name) — M:104 `drawnBack`.**
- It is the reading at a reading step, the same kind of thing as MA2's `poolRead`. In English "drawn back" means withdrawn; `drawnRead` would be exact.
- The other names asked about state their meaning and break no rule.

## Verdict

Land after the listed fixes. The Lean is sound, its declaration docstrings are exact, and it proves what step 6 of AJ's plan asks.
- **Required before landing (text only):** findings 1–7 and 10–11. That means restoring `lo ≤ hi` and the regime boundary, withdrawing "independent", restating readings (a) and (b) without the equivocation on "lock", writing "moved" instead of "derived", placing the result against the stag hunt with the noise bound, and removing "repay".
- **Recommended:** finding 13 (the `lower_strict` duplicate) and the additions in finding 15.
- **For the integrator:** finding 14.

Sources checked:
- [Schelling 1973](https://ideas.repec.org/e/psc152.html)
- [Schelling 1971](https://bibsonomy.org/bibtex/1fd25d60f9f7726c2c45a33a9880e633)
- [Schelling 1978 contents](https://www.librarything.com/work/57888)
- [Granovetter 1978](https://sociology.stanford.edu/publications/threshold-models-collective-behavior)
- [Arthur 1989](https://ideas.repec.org/a/ecj/econjl/v99y1989i394p116-31.html)
- [Oliver, Marwell and Teixeira 1985](https://users.ssc.wisc.edu/~oliver/PROTESTS/ArticleCopies/OliverMarwellCritMassI.pdf)
- [Kandori, Mailath and Rob 1993](https://ideas.repec.org/a/ecm/emetrp/v61y1993i1p29-56.html)
- [Young 1993](https://ideas.repec.org/a/ecm/emetrp/v61y1993i1p57-84.html)
- [Harsanyi and Selten, via the risk-dominance entry](https://en.wikipedia.org/wiki/Risk_dominance)
- [Skyrms 2004](https://katalog.lib.cas.cz/Record/002877390)
- [Hofbauer and Sigmund](https://homepage.univie.ac.at/josef.hofbauer/bams.htm)
- [Gardner and West 2010](https://research-portal.st-andrews.ac.uk/en/publications/greenbeards/)
