# MA4b: the independent review

26 October 2026. One independent read-only review by a separate AI agent (Claude Opus, in a subagent of the drafting session), of `tree/Becoming/ReadInTime.lean` and `NOTE.md` as committed at `b69dfcb1e`, with the landing kit as committed at `9c62bf7d6` read as well. It rebuilt the module, ran probes in its own scratch folder and edited nothing in the repository. Its probe module is copied here as `review-probe-ReadInTimeProbe.lean.txt`, and the five scripts of its integer mirror that it cites as `review-mirror/*.py.txt` (the scratch paths below are volatile). Its report follows verbatim; what was taken is in NOTE.md §8.

---

I found no unsound Lean, but the text needs fixes before landing. One sentence of the module docstring states as a law something a probe refutes: a reading from the one step between need not come too late. Rebuilt independently, the module gives 25 theorems in 31 declarations, every axiom report empty, in core style. The declarations prove what step 7 of AJ's plan asks, as conditional laws of this model.

The problems are in:
- the module docstring's account of the window: what the step between does, the schedule premise, and ties;
- premises dropped from bullets and docstrings: `Accrues`, `lo' ≤ hi` and the reading step;
- "linear" for a deadline that is quadratic;
- the standing;
- NOTE.md §3.8, §5 and §7.

The same sentences recur in the landing kit committed after the review target (`9c62bf7d6`), which also cites a declaration the module lacks. I edited nothing in the repository; the probes are in my scratch folder.

**Files**
- M = `/Users/ren/theories/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ma4b-read-in-time/tree/Becoming/ReadInTime.lean`, as committed at `b69dfcb1e` (unchanged at the head).
- N = `/Users/ren/theories/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ma4b-read-in-time/NOTE.md`, the same.
- K = the kit folder, `/Users/ren/theories/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ma4b-read-in-time/`.
- Probes (scratch, volatile, not in the repository):
  - `/private/tmp/claude-501/-Users-ren-theories/b7c6b747-6b9c-4356-8b68-e395f26999fa/scratchpad/ma4b-review/tree/Becoming/ReadInTimeProbe.lean`, probes P1 to P15.
  - An exact integer mirror of the model and the scripts run on it, in `/private/tmp/claude-501/-Users-ren-theories/b7c6b747-6b9c-4356-8b68-e395f26999fa/scratchpad/ma4b-review/py/`: `model.py`, `search3.py`, `witness.py`, `p2_fate.py`, `p12_fate.py`.
  - Copy the probe file into the kit if a record or NOTE cites it.

**Soundness: confirmed.**
- M is byte-identical to its blob at `b69dfcb1e` (sha256 `aa9a34e3…`), and so is N (`afd8c689…`).
- I compiled M fresh with Lean 4.29.1, called directly against the scratch build of its imports. It exited 0 with no message, and the olean is byte-identical to the builder's (`bfbbc588…`).
- `scratch_build.py` (which recompiled it once more after a probe change) gives `unclean` [], 25 theorems in 31 declarations, `with_axioms` {}. The checker's `#print axioms` driver reports "does not depend on any axioms" for all 31.
- M imports only `Becoming.DrawnShaping`. It has no `simp` and no `omega`. Its one `rw` (M:182) is with `Nat.ble_eq_true_of_le`, an equation, not an iff. `decide` is used only on closed numerals.
- The probe module (it imports `Becoming.ReadInTime`) built cleanly: 29 theorems in 39 declarations, every axiom report empty, in the same style. A deliberately false probe (the witness read from step 3, locked at step 5) fails, as it should.
- This is a working build, not a receipt. The prelude-only compile and the environment audit run only in the checker at landing. The build cache is `~/.cache/becoming-lean`, outside the repository.
- Witness numbers, confirmed by the Lean and by the mirror:
  - the start's rule is 9 to 8, and the deadline 8 · 3 · 1 = 24;
  - the late reading is 550 to 580, 42260 to 42680 and 28225784 to 27231056 at MA4's shares of steps 2, 3 and 4;
  - read from steps 0, 1 and 2, the course is turned from steps 2, 3 and 4;
  - read from step 3, it is locked in the shapers' favour from step 6;
  - read from steps 4 and 5, it is kept from steps 5 and 6.
- `Window.too_late` does show that in the witness a reading from step 3 is one step too late. It is too late against both the last reading in time (step 2) and the share at the reading, which still favours the others. It does not show that this holds at every step between (finding 1).

## Findings

**1. error — M:36–40 (the window bullet's last sentence), with N:68.**
- Text: "… and at most one step lies between: the step at which the late reading favours the others strictly at its share and the shapers strictly at the next (`one_between`). A reading from there comes one step too late."
- `one_between` says that at most one step escapes both iffs. It says nothing about the course read from that step, and the witness's relock (`Window.too_late`) is only one of two outcomes.
- Probe `between_turns` (P1): a = 1, p = 0, c = 1, hi = 3, lo = 2, lo' = 0, one shaper to three others, read at every step, the loss read from step 0.
  - Every premise of `one_between`, `kept_early_iff` and `turned_early_iff` holds. The start's rule is 13 to 8. The late reading is 7 to 8 at the start and 76 to 74 at MA4's share of step 1.
  - So step 0 is the step between. `between_neither` shows, by the module's own iffs, that the course read from step 0 is neither kept from step 1 nor turned from step 2. `only_zero` shows that `one_between` makes it the only such step.
  - Yet the course read from step 0 is locked the other way at every step from step 4. This follows from `turned_iff` at r = 2: the late reading is 556 to 566 at that course's share of step 2, and 41872 to 42248 at its share of step 3.
  - The rule in force runs 7 to 8, then 76 to 74, then 556 to 566: the course starts a new round.
- A survey with the mirror (numeric only, not Lean):
  - Ranges: a ≤ 3; p ≤ 2; 1 ≤ c ≤ 5; c < hi ≤ 10; every `lo` and `lo'` up to `hi`; favoured starts of one or two shapers to 1–15 others; bound 0–4; read every step.
  - Of 50,342 courses read from the step between, 42,702 (84.8%) are first locked in the shapers' favour at N + 3, 5 or 7, and 7,640 (15.2%) are first locked the other way at N + 4, 6 or 8.
  - None stays unlocked within 13 steps of N.
- Fix: replace M:36–40 (this also takes findings 2 and 7) with:
  > "Along MA4's course the late reading never falls (`late_rises`), so, with the rule read at steps `N` and `N + 1`, the steps from which a reading turns the course come first and those from which it keeps the lock come last (ties aside, where both hold), and at most one step lies between: the step at which the late reading favours the others strictly at its share and the shapers strictly at the next (`one_between`). From that step neither law decides: the rule in force favours the others for one step, and the course starts a new round, to which `kept_iff` and `turned_iff` apply again from step `N + 2` (in the witness the course is locked in the shapers' favour again from step 6, `Window.too_late`; it can also be turned for good)."

  Make the same change at N:68.
- Optional Lean, built (P14): `between_round (readers : lo' ≤ hi) (late1 : favours (drawn … lo' (drawnCourse … (N + 1)).1)) (at_next : reads (N + 1) = true) (at_two : reads (N + 2) = true) : (∀ k, Locked … (lossCourse … (N + 2 + (1 + k)))) ↔ favours (drawn … lo' (lossCourse … (N + 2)).1.1)`.
  - It needs neither the start favoured nor `lo ≤ hi`.
  - `between_round_P1` shows its right side failing in P1 (556 to 566), where `turned_iff` then turns the course.

**2. error — M:36–39 ("so the steps … come first … come last, and at most one step lies between") and M:316–318, with N:68.**
- Text, M:316–318: "So at every step `N` but at most one, a reading from `N` keeps the lock for good (`kept_early_iff`) or turns the course for good (`turned_early_iff`)."
- `kept_early_iff` needs step N reading, and `turned_early_iff` needs steps N and N + 1 reading. The inference drops both, and without them two steps can escape both laws.
- Probes (P2), on the witness read at every step but step 3 (`notThree`):
  - `turned_early_needs_next`: at N = 2, the right side of `turned_early_iff` holds (42260 to 42680 at MA4's share of step 3) and every other premise holds. Yet the course read from step 2 is not locked the other way at step 4. So `turned_early_iff` is false without `at_next`.
  - `two_neither`: at N = 2 and at N = 3, the course is neither kept from N + 1 nor turned from N + 2. By the mirror, the first is turned from step 5 and the second kept from step 5.
- Fix:
  - M:37: as in finding 1.
  - M:316: "So, where steps `N` and `N + 1` read, at every step `N` but at most one …".
  - N:68: the same.

**3. error — M:22–27 (the "Turned" bullet).**
- Text: "At a reading step at which the loss has reached its bound and the late reading favours the others at the share there (ties included), the next step reading too, the course is locked the other way for good …".
- `turned_iff` takes `readers : lo' ≤ hi`. Its docstring states this premise; the bullet drops it, though the Kept bullet keeps it.
- Probe `turned_needs_readers` (P3): a = 1, p = 0, c = 4, hi = 1, lo = 0, lo' = 2, from one to one under a rule of 1 to 2, the loss read from step 0, read every step.
  - The late reading favours the others at the shares of steps 0 and 1 (5 to 10, then 8 to 15), so the right side holds.
  - Yet the course is not locked the other way at step 2: the late reading there, 70 to 125, lies above the rule in force, 8 to 15.
  - With `lo' > hi`, the late reading reads against the share.
- Fix: "At a reading step at which the loss has reached its bound, with `lo' ≤ hi`, and the late reading favours …".

**4. error — `Accrues` dropped at M:18–27 (both bullets), M:115–118 (`kept_iff`), M:134 (`loss_next`), M:143–147 (`turned_iff`) and M:74–82.**
- `kept_iff`, `turned_iff` and `loss_next` take `accrues : Accrues fB`, and no docstring says so. `loss_next`'s "Every step adds at least one to the loss" holds only where `fB` accrues.
- Probe `kept_needs_accrues` (P4): the loss reset to zero at every step, N = 1, the witness's readings, two shapers to one other, a rule of 1 to 1 with the loss at 1.
  - Every other premise of `kept_iff` holds, and so does its right side (9 ≤ 10).
  - Yet the course is not locked at step 2: once the loss falls below N, the others read `lo` again.
- Fix:
  - Add "the loss growing by at least one a step (`Accrues fB`)" to both bullets and both docstrings.
  - M:134: "Where `fB` accrues, every step adds at least one to the loss."
  - M:74–82: add "that the loss, once it reaches the bound, stays there (here it grows by at least one a step; in MA4's course by one from zero)".

**5. overclaim — `lo' ≤ hi` dropped from "this form" at M:64–65, M:49 and M:468.**
- Texts:
  - M:64–65: "Read from step 4 or any later step, by any reading of this form, the course stays locked in the shapers' favour for good (`Window.late_kept`)".
  - M:49: "no reading of this form by the others alone turns the course (`closed_for_every`)".
  - M:468: "the others reading the loss with any `lo'`".
- M:75–77 defines "this form" as the same `a`, `p` and `c`, with what comes back read as a natural number. That admits `lo' > hi`. Yet `late_kept` takes `lo' ≤ 5`, and `kept_iff`, `kept_early_iff`, `closed_kept`, `closed_for_every` and `deadline` all take `lo' ≤ hi`.
- Probe `late_kept_needs_readers` (P5): the witness with lo' = 6, the loss read from step 4.
  - The rule in force at step 5 favours the shapers (43370744 to 27231056), yet the course is not locked there: with `lo' > hi`, the late reading falls as the share rises.
  - The course is not turned either: with c ≤ hi < lo', the late reading favours the shapers at every share. What fails is the lock the sentence states, not the direction.
- Fix:
  - M:64: "by any reading of this form with `lo' ≤ 5`".
  - M:49: "no reading of this form with `lo' ≤ hi` …".
  - M:468: "with any such `lo'`".
  - Or fold `lo' ≤ hi` into "this form" at M:75–77 and say so there once.

**6. gap — the reading step dropped at M:41–45 and M:46–49.**
- Text, M:43: "the others reading the loss from any step `s + d` leave the course locked in the shapers' favour for good (`closed_kept`)".
- `closed_kept` and `closed_for_every` take `at_N : reads (s + d) = true`, and give the lock from step `s + d + 1`.
- Probe `closed_kept_needs_reading` (P12): the witness read at every step but step 5.
  - The late reading favours the shapers at MA4's share of step 4.
  - Yet with the bound at step 5, the course is not locked at step 6. By the mirror, it is locked from step 7.
  - So the bullet's "for good", with no starting step, is not what the Lean proves.
- Fix: "from any reading step `s + d` leave the course locked in the shapers' favour at every step from `s + d + 1`"; the same at M:48–49.

**7. overclaim (ties) — M:37–38, M:44–45, M:49 and N:28.**
- Texts:
  - M:37–38: "the steps from which a reading turns the course come first and those from which it keeps the lock come last".
  - M:44–45: "So their reading can turn the course only if it comes before the first step at which their late reading would favour the shapers".
  - M:49: "no reading of this form … turns the course".
  - N:28: "Equivalently, …".
- `favours` and `disfavours` are weak, which the module never says. Where every rule read ties, a course is locked both ways at once.
- Probe `tie_both` (P13): MA4's witness at its critical mass (a = 1, p = 0, c = 1, hi = 3, lo = lo' = 0, one shaper to two others), read every step, the loss read from step 0.
  - Every rule read is 6 to 6.
  - By the module's own iffs, the course read from step 0 is both kept from step 1 and turned from step 2.
  - The late reading favours the shapers at step 0, and the premises of `closed_for_every` hold there. Yet the reading turns the course, in the module's sense of "turns".
- N:28 is a consequence of `closed_kept`, not an equivalent statement, and it holds only where kept and turned exclude each other.
- Fix:
  - Add once, as MA3's module does: "`favours` and `disfavours` are weak: where the late reading ties at a share that stays, a reading both keeps and turns in the sense of these laws (`tie_both`)".
  - M:44–45: "only if it comes before the first step at which their late reading would favour the shapers strictly".
  - N:28: "So, but at a tie, …".

**8. error (minor) — "linear" at M:78, M:471 and N:67.**
- Texts:
  - M:78: "The deadline is a bound linear in the start's counts".
  - M:471: "it is a bound, linear in the start's counts".
  - N:67: "So the bound is loose, linear where the share grows geometrically."
- For the rule read at the start, g.other = (x.carrier + x.other) · (a + c + p). The deadline is therefore (x.carrier + x.other) · (a + c + p) · c · x.other, which is quadratic in the counts.
- It is also not a law of the share: every verdict depends only on ratios, yet doubling the counts multiplies the deadline by four.
- Probe `scaled_deadline` (P10): from two to two the deadline is 96, while the window is closed from step 4 exactly as from one to one. `closed_for_every` applies at s = 4 for every `lo' ≤ 5`, and at step 3 the least late reading still favours the others strictly.
- Fix:
  - M:78: "The deadline is a bound, `(x.carrier + x.other) * (a + c + p) * c * x.other`, quadratic in the start's counts and not invariant under scaling them, which leaves every share and the window unchanged (96 from two to two); it is not the step …".
  - M:471 and N:67 likewise.

**9. overclaim (standing) — M:68–72 and N:40–45.**
- Texts:
  - M:69: "In this model it is the dilemma of Collingridge (1980): control is easy while the need for it is not yet read, and hard once it is."
  - M:71–72: "What it adds is the join on the spine: the exact window, its lag of one step, and a deadline."
  - N:45: "with the exact window and the lag".
- Collingridge's dilemma has two horns: while change is easy, its need cannot be known; once the need is known, change is hard.
  - Here only the second horn is a theorem (`closed_kept`, `closed_for_every`, `deadline`).
  - The first horn is a premise: the bound `N`, before which the others read nothing of the loss.
  - And "hard" here means "impossible by any reading of this form", from a sharp step.
- "The exact window": the window is exact at every step but at most one, whose course the laws leave open (finding 1), and only with steps N and N + 1 reading (finding 2).
- "Its lag of one step": the lag belongs to the representation. In `Pace.turn` a rule read at a step is in force from the next, carried over from MA2's `Thinned`.
- The laws compose MA2's `rule_read`, `read_late_kept` and `read_in_time_turns` with MA4's monotone course (`drawn_locks`, `pool_reads`, `locked_not_below`). New on the spine are that composition, `late_rises`, `one_between` and the deadline, each elementary.
- Closer prior work on the timing than the tipping models:
  - Biggs, Carpenter and Brock 2009 (PNAS 106(3):826–831). The window for averting a regime shift is discrete and ends abruptly, and where the driver can only be changed gradually, action is needed well before the shift. This is the continuous analogue of the window and of "one step before the share alone would say". They model no response delay.
  - Replicator dynamics with a delay: Alboszta and Miękisz 2004 (J. Theor. Biol. 231(2):175–179, discrete time) and Tao and Wang 1997 (J. Theor. Biol. 187:111–116, continuous time). There a delay destabilises an interior equilibrium. Compare the rounds of two steps at the step between; the comparison is loose, since here the threshold is unstable even without a delay.
  - Cowan 1991 (Econ. J. 101(407):801–814): lock-in while the merit of the alternatives is still being learned.
  - Witt 1997 (IJIO 15(6):753–773): critical masses and lock-in.
  - Pierson 1993 (World Politics 45(4):595–628): policy feedback, a rule shaping those who read it.
  - Unruh 2000 and 2002 (Energy Policy 28(12):817–830; 30(4):317–325): carbon lock-in and escaping it.
  - Two more whose bibliographic records I verified but whose contents I give from memory:
    - David 1987, "Some new standards for the economics of standardization in the information age", in Dasgupta and Stoneman (eds.), CUP (narrow policy windows).
    - Marchant, Allenby and Herkert (eds.), *The Growing Gap Between Emerging Technologies and Legal-Ethical Oversight: The Pacing Problem* (year and publisher, Springer 2011, from memory).
- Fix, M:68–72 (and N:40–45 to match):
  > "Standing: elementary, MA2's `Thinned` laws composed with MA4's monotone course; the lag of one step is the representation's (a rule read at a step is in force from the next). In this model the second horn of Collingridge's dilemma (1980) is a theorem: from the first step at which the late reading would favour the shapers, no reading of this form turns the course; the first, that the need is read too late, is the premise that the loss is read only from `N`. Biggs, Carpenter and Brock (2009) give the continuous analogue of the window. Lock-in and its timing (David 1985, Arthur 1989, Cowan 1991), the tipping models (Schelling 1978, Granovetter 1978) and replicator selection with a delay (Alboszta and Miękisz 2004) are credited. What it adds on the spine is the join: a window exact at every step but at most one, given readings at steps `N` and `N + 1`; its lag of one step; and a deadline."

**10. error — N:32–34 (§3.8) and N:66 (§7).**
- N:33: "locked in the shapers' favour again from step 5".
  - `Window.too_late` proves the lock from step 6, and at step 5 it fails (probe `too_late_not_at_five`, P9).
  - The rule in force at step 5 favours the shapers (28225784 to 27231056), but the late reading at the share there lies below it.
- N:32: "Read from step 0, 1 or 2, the course is turned for good". This is true by computation (turned from steps 2, 3 and 4), but only step 2 is in the Lean (`Window.in_time`).
- N:66: "Statements 1 to 6 and 8 are as designed".
  - `turned_iff` (statement 3) adds `lo' ≤ hi`, which the design lacks and finding 3 shows is needed.
  - It also drops the design's premise that the rule in force at r favours the shapers.
  - Statement 8 differs as described above.
- Fix:
  - N:33: "from step 6".
  - N:32: "Read from step 2 (and, by computation, from 0 or 1)".
  - N:66: "Statements 1, 2 and 4 to 6 are as designed; statement 3 needs `lo' ≤ hi` and not the rule in force favouring; statement 8 is proved for readings from steps 2, 3 and 4 on (the relock from step 6), and computed only from 0 and 1".

**11. error — N:51 (§5), repeated in the board row (`_process/BECOMING-WORKBOARD.md:50`).**
- Texts:
  - N:51: "With an unbounded reading of their own (any rule `w` not above `u`), the others can always turn the course."
  - Board row: "an unbounded reading of their own always turns the course".
- This is false as worded, and unproved.
  - Take w = u, which is not above u; in this module's form, that is lo' = hi.
  - The late reading is then u at every share. Where c < hi, u favours the shapers strictly at every share (`drawn_favours_iff`).
  - So the right side of `turned_early_iff` fails at every step, and no reading turns the course. In the witness this is lo' = 5.
- What does hold (by hand, not in the Lean): if `w` is chosen after the share is seen, far enough below `u`, the late pool favours the others at the shares of steps N and N + 1 (others are present, `other_pos`), and `Thinned.read_in_time_turns` then turns the course. That is a reading whose weight is set by the state, which is a different law.
- Fix, at N:51 and in the board row:
  > "With a late reading whose weight against the shapers is chosen after the share is seen (a rule `w` far enough below `u`), the others could turn the course from any share; that is not stated here. So the window is a law of readings of this form, and the record must say so."

**12. imprecision — docstrings and citations.**
- M:547: "(27231056 to 28225784)" reverses carrier and other. The module writes the carriers first (9 to 8; 550 to 580), so this should be "28225784 to 27231056".
- M:427–428 (`held_le`): "the rule in force is never below the start's" is the reason, not the statement. Write: "MA4's share at every step is not below the share under the start's rule held fixed, since the rule in force is never below the start's".
- M:6–8 and N:7: "every course read from the share alone is locked".
  - `drawn_locked_either` is about courses that start from the rule read at their start.
  - A rule in force against the reading need not lock (`RuleCapture.Reversed.not_absorbed`).
  - Add "from the rule read at its start".
- M:16–17: the fact that past the bound the rule read is MA4's rule with `lo'` is `Thinned.lossPool_past` (or `Thinned.rule_read`). `DrawnShaping.drawn_favours_iff` only gives that rule's verdict. Cite both.

**13. imprecision (N's vocabulary) — "the late verdict" at N:24–30 and N:68; "The strongest reading" at N:29; "of their own" at N:51.**
- M says "the late reading" and "the least reading".
- "Verdict" is a juridical word, where the naming rule asks for structural ones.
- "Strongest" (against the shapers) and "least" (what comes back to them) name the same reading in two ways.
- "A reading of their own" is the possessive the MA4 review struck ("own readers").
- Fix: use M's terms throughout N. Finding 11's fix removes "of their own".

**14. suggestion — which premises are needed and which are not.**
- Not needed, built (P7, P8):
  - `covers_of_strict`: `lo ≤ hi` together with a start favouring strictly gives `c < hi`, so `deadline'` holds without `covers`.
  - `one_between'`: `lo ≤ hi` alone suffices. Neither `lo' ≤ hi` nor the start favoured is needed: MA4's course is monotone one way or the other, and the late reading reads the share one way or the other.
  - `closed_for_every'`: the start favoured is not needed. With `lo ≤ hi`, the least late reading favouring at some step forces the start's rule to favour.
- Not needed, by hand (not built):
  - `kept_early_iff` without `lo ≤ hi`: where c ≤ hi every rule MA4 reads favours and `kept_iff` applies; where c > hi, both sides are false.
  - `least_iff` without `covers`: where c > hi, both sides are false.
  - `deadline` without `lo ≤ hi`, keeping `covers`: every rule in force is then at least `shaped a hi p c`, and `held_past` with that rule gives the bound, since its `other`, a + c + p, is at most g.other.
- Needed, each with a counterexample built:

  | Premise | Theorems that need it | Probe |
  |---|---|---|
  | `Accrues` | `kept_iff` | P4 |
  | `lo' ≤ hi` | `turned_iff` | P3 |
  | `lo' ≤ hi` | `kept_iff`, `kept_early_iff`, `closed_kept`, `closed_for_every`, `late_kept` | P5 |
  | `lo' ≤ hi` | `late_rises` | `late_rises_needs_readers` |
  | the start favoured | `kept_early_iff` and `closed_kept`, where lo < lo' | P6, `kept_early_needs_fav` |
  | the start favoured | `late_rises` | `late_rises_needs_fav` |
  | `lo ≤ hi` | `late_rises` | `late_rises_needs_step` |
  | the reading steps | `turned_early_iff` | P2 |
  | the reading steps | `closed_kept`, `closed_for_every`, `kept_early_iff` | P12 |
  | `some` | `deadline` | `deadline_needs_some` |
  | `strict` | `deadline` | `deadline_needs_strict` |

  - `deadline_needs_some`: no shaper; the start's rule is 3 to 2, and the deadline 2.
  - `deadline_needs_strict`: the start's rule is 6 to 6, the deadline 12, read at step 12; the rule in force at step 13 favours the others.
- Dropping the premises shown here to be unneeded strengthens `one_between`, `closed_for_every` and `deadline` at no cost.

**15. suggestion (names; board rule 9).**
- `late_rises` states "never falls" (weakly), while elsewhere in the package "rises" is strict (`DrawnShaping.drawn_rises`). Use `late_never_falls`.
- `one_between` states "at most one". Use `at_most_one_between`.
- "closed" (`closed_kept`, `closed_for_every` and their hypotheses named `closed`) here means that the window has closed. But the module opens `ClosedCapture`, where "closed" means read from the share alone. Use, for instance, `kept_once_favoured` and `kept_past_least`, with hypotheses `favoured` and `least_favours`.
- `held x g t` is `Law.orbit (fun y => CarrierCounts.select y g) x t`, and `held_counts` follows from `RuleShaping.orbit_held`. But `RuleShaping.held` is a rule's power, a different type under the same name. That gives two paths to one fact and two `held`s of different types. Reuse the orbit, or rename this one `heldCourse` with a one-line equation to the orbit.
- `Window.one_pos` and `Window.even` repeat `DrawnShaping.CriticalMass.one_pos` and `.even` (as RuleShaping's and ChoiceCountCapture's witnesses also do). This is the integrator's call.
- `lossRead` is also the name of `ClosedCapture.Beyond.lossRead`, a different rule, and the module opens `ClosedCapture`. `lateRead` would be distinct.
- Otherwise there is no social or financial word in M, and no "give back", "repay" or "own readers"; in N, only those in finding 13. The other names state their meaning.

## AJ's condition 2: what a record may and may not claim

PLAN §1, condition 2: "Where a lock forms, the selection leaves it by reading what lies beyond its share before the loss passes its point of no return."

- **What a record may claim, in this model.** Take a start under the rule read there that favours the shapers, with `lo ≤ hi`. A lock then forms at or above MA4's critical mass; above the mass, condition 1 fails. Let the others read the loss from a bound N, with a late reading of this form and `lo' ≤ hi`, and let the rule be read at steps N and N + 1. Then:
  - the lock is left for good exactly where the late reading still favours the others at MA4's share of step N + 1 (`turned_early_iff`);
  - it is kept exactly where the late reading favours the shapers at the share of step N (`kept_early_iff`);
  - from the first step at which the late reading would favour the shapers, no such reading leaves it (`closed_kept`); past the least reading's threshold, no reading of this form does (`closed_for_every`);
  - from a start favouring strictly with a shaper present, that threshold is passed by step (x.carrier + x.other)(a + c + p) · c · x.other, under every schedule (`deadline`).

  So in this model condition 2 can hold where condition 1 fails.
- **The point of no return belongs to the share, not the loss.**
  - In this model the loss only times the others' reading. It enters no count, and its amount past N is never read.
  - The point of no return lies at the step between or just after it, on the share's course; the share's course decides it, and finding 1 leaves the step between undecided.
  - Whether condition 2 holds depends on how the premise N stands to that course. What sets N is not modelled.
  - Either read condition 2's wording this way for this model, or have the plan say "before the share passes the step from which the late reading would favour the shapers".
- **What must be stated as premises:**
  - the readers are drawn from the selected and counted as the population counts them (`Drawn.pool`);
  - the others read the loss, all at once from the bound N, switching from `lo` to `lo'`, while the shapers keep `hi`;
  - the late reading has this form (the same a, p and c, with a natural number read as coming back), with `lo' ≤ hi`;
  - `lo ≤ hi`;
  - the start favoured (strictly, with a shaper present, for the deadline);
  - the readings at N and N + 1;
  - the loss growing by at least one a step (`Accrues`; `Beyond.lossStep` from zero for the window in MA4's course);
  - discrete steps, natural counts, others present, no noise, and readers who do not learn.
- **What a record may not claim:**
  - that condition 2 holds or fails for actual rules or for a trained judge (according to the kit's record text, LA2 found the timing law did not apply to the one judge it tested);
  - that the window's length, or the deadline, is the time actually available; the deadline is a loose bound that depends on scale;
  - that a reading from the step between is too late;
  - anything about late readings of another form, including one whose weight is chosen after the share is seen (finding 11);
  - that conditions 1 and 2 are independent: the model shows condition 2 without condition 1, not condition 1 together with a capture-like lock that is not left;
  - that a turned course is better than a kept one, which needs C.
- **Below the critical mass, MA4b adds nothing.** There the course is locked the other way (MA4), which is not a capture.

## In the landing kit (`9c62bf7d6`, committed after the review target)

The kit was not a target of this review, but it carries the record and chapter texts, so its problems are listed here. Its own boundary items already agree with finding 1: `K/study_ma4b.txt:56` and `K/make_records_ma4b.py:178–180` leave the step between open. The texts below should be brought into line with them.

**`in_time_earlier` is cited but missing.**
- It is cited at `K/study_ma4b.txt:22`, `K/texts_ma4b.py:40` and `K/make_records_ma4b.py:94`, but M does not contain it, and `D()` (`K/make_records_ma4b.py:48–52`) stops on a missing declaration.
- Built as P15, as follows. In M, drop the `{reads}` binder and the `ReadInTime.` prefix.

```lean
theorem in_time_earlier {reads : Nat → Bool} (step : lo ≤ hi) (readers : lo' ≤ hi) {x : CarrierCounts}
    (fav : CarrierCounts.favours (DrawnShaping.drawn a p c hi lo pos x)) {s t : Nat} (le : s ≤ t)
    (later : CarrierCounts.disfavours
      (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x t).1)) :
    CarrierCounts.disfavours
      (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x s).1) :=
  CarrierCounts.lower
    (Eq.subst (motive := fun j => CarrierCounts.order.le
        (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x s).1)
        (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x j).1))
      (add_sub_of_le le) (ReadInTime.late_rises step readers fav s (t - s)))
    later
```

**Finding 1 recurs in these places:**
- `K/texts_ma4b.py:40`: "from which a reading comes one step too late".
- `K/texts_ma4b.py:34`, `:61`, `:63` and `:70`: "only a reading in time leaves that lock" (and its Chinese). There "in time" is defined as the late reading one step on still favouring the others. P1's reading does not meet that definition, yet it leaves the lock.
- `K/texts_ma4b.py:51`: "the last reading that turns the course comes a step earlier still". The last step from which a reading turns the course for certain is two steps before the first step at which the late reading would favour the shapers, and the step between is open.
- `K/study_ma4b.txt:23`.
- `K/make_records_ma4b.py:144–146` (the record statement) and `:213–221` ("the window closes a step before the first step …"; "the exact window").
- The MA4 and MA2 record updates (`K/make_records_ma4b.py:292–293`, `:305–306`, `:319–320`) say "only in time". That is true if "in time" means "before the first step at which the late reading would favour the shapers" (this is `closed_kept`, ties aside); say so once.
- A replacement record statement within the limits (289 and 73 characters):
  > "Where a rule's readers come from those it selects and the others among them read a loss late, a reading while their late reading a step on still favours them turns the course; once it would favour the shapers the lock stays; at most one step lies between, and a deadline bounds the window."

  > 规则之读者取自其所选者、其中他者迟读损失时：读时下一步之迟读仍偏向他者，则转其进程；迟读一旦偏向塑规者，则锁定留存；其间至多一步；一期限界此窗口。

**Finding 2 recurs in these places:**
- `K/integrate_ma4b.py:44–46`, `:64–65`, `:80–81` and `:94–95` state "at most one step lies between" without the readings.
- The README rows also say "the window is exact" and "窗口恰定".
- `K/texts_ma4b.py:40` has "every step reading", which is right.

**Finding 5 and the deadline's premises recur in these places:**
- `K/texts_ma4b.py:40` ends "read from step 4 or later, by any reading of this form, the lock stays". It needs `lo' ≤ 5`.
- `K/texts_ma4b.py:40`, `K/integrate_ma4b.py:46–48`, `:65–66`, `:81–83` and `:96–97`, and `K/study_ma4b.txt:27–28` drop `lo ≤ hi` and `lo' ≤ hi` from the deadline. They also say "turns" where the Lean proves the lock in the shapers' favour.
- `K/make_records_ma4b.py:106–108` has the deadline's premises right.

**`K/board_ma4b.py:14–17`:** `STANDING` is unset, and EXPECTED's "the exact window" is replaced at landing. A STANDING drawn from this review:
> "Standing (independent review): elementary, MA2's Thinned laws composed with MA4's monotone course, the lag of one step being the representation's; the window is exact at every step but at most one, given readings at N and N + 1, and the course from that step is left open; the deadline is a loose bound, quadratic in the start's counts; in this model Collingridge's second horn is a theorem and the first a premise (the bound N); the nearest prior result is Biggs, Carpenter and Brock 2009."

## Verdict

Land after the listed fixes. The Lean is sound and proves what step 7 of AJ's plan asks, as conditional laws of this model. Its declaration docstrings are exact except those named in findings 2, 4, 8 and 12.
- **Required before landing (text only):** findings 1–11, together with their recurrences in the landing kit, including `in_time_earlier`. That means:
  - withdrawing "one step too late" for the step between;
  - stating the readings at N and N + 1, `Accrues`, `lo' ≤ hi` and the reading step wherever the laws need them;
  - adding the tie caveat;
  - "quadratic" for "linear";
  - the standing's two horns and its credits;
  - "step 6" in NOTE §3.8;
  - withdrawing NOTE §5's "always turn".
- **Recommended:** findings 12–13, and `between_round` (P14), so that the window bullet can say what the step between does.
- **For the integrator:** findings 14–15.

Sources checked:
- [Biggs, Carpenter and Brock 2009, full text](https://pmc.ncbi.nlm.nih.gov/articles/PMC2630060)
- [Biggs, Carpenter and Brock 2009, Stockholm Resilience Centre record](https://www.stockholmresilience.org/publications/publications/2010-01-05-turning-back-from-the-brink-detecting-an-impending-regime-shift-in-time-to-avert-it.html)
- [Alboszta and Miękisz 2004](https://arxiv.org/abs/q-bio/0409024)
- [Tao and Wang 1997, in a Springer reference list](https://link.springer.com/doi/10.1007/s13235-011-0028-1)
- [Cowan 1991](https://ideas.repec.org/a/ecj/econjl/v101y1991i407p801-14.html)
- [Witt 1997](https://ideas.repec.org/a/eee/indorg/v15y1997i6p753-773.html)
- [Pierson 1993](https://www.cambridge.org/core/journals/world-politics/article/abs/when-effect-becomes-cause-policy-feedback-and-political-change/EB310F82411B3E31406E03C1381E6740)
- [Unruh 2000 and 2002, via the carbon lock-in entry](https://en.wikipedia.org/wiki/Carbon_lock-in)
- [David 1987, bibliographic record](https://cepr.org/chapters/some-new-standards-economics-standardization-information-age)
- [Collingridge's dilemma](https://en.wikipedia.org/wiki/Collingridge_dilemma)
- [Marchant, Allenby and Herkert (eds.), catalogue record](https://katalog.hacettepe.edu.tr/client/rss/hitlist/default/qu=Herkert%2C+Joseph+R.)
