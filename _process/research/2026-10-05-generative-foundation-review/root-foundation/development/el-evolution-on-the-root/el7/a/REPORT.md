## 1. Verdict

Part (a) meets none of AGENTS.md's three tests: no theorem a specialist would not foresee, no prediction that could fail and does not, no premise derived from something weaker. The literature dominates all of it: the account's offspring are the repeated donation game's payoffs (b = β, c = γ) shifted by a + γn, so the exact cohort iff is Hamilton's rule in Queller's form; the four pair terms are the two-level Price partition, β + γ within pairs and |β − γ| among them; one-way errors drawn by chance end every pair whose laws keep mutual withholding, as any chain with a reachable absorbing state ends; and the field's thresholds come back in the counts (win-stay lose-shift's β > 2γ and β > 3γ, generous tit-for-tat forgiving below 1 − γ/β, tit-for-tat never more than one step behind). It meets the coherence test and widens scope a little: compiled with empty axiom reports (/Users/ren/tmp/el7/a/Becoming/EL7aCohorts.lean, /Users/ren/tmp/el7/a/Becoming/EL7aChance.lean), it closes the offspring record's mixed-cohort and four-term lines, and in part the window record's probabilities line; it brings errors by chance onto the spine through Typicality's counts; and it proves that a pair whose laws keep mutual withholding (answering, the window of two, waiting on both, withholding) still gives at step 2k under at most a (1 − r⁴)^k share of error courses, so 05 §5's "the window is a deterministic relative of forgiveness" and D48's "Tolerance lets cooperation survive scattered withholding" hold only for spaced errors, or for horizons shorter than the window's time to total withholding (mean 3.3×10⁴ steps for the window of two at r = 1/20), while forgiveness by chance never ends. Stop (a) as research: land only the small item in §5, and build nothing on stability frames, the cycle as a course or a generous run.

---

REPORT.md was not written: the harness refuses report files from subagents, so the whole report is below. Section 1 is above, verbatim.

## 2. Questions: what was established, its standing, what would defeat it

**Q1. Mixed cohorts and the four terms.** Lean-compiled in /Users/ren/tmp/el7/a/Becoming/EL7aCohorts.lean, which imports Becoming.PairSelection; every `#print axioms` report is empty. K is a place's own withholding.

- **Identities**, for any laws, errors and n:
  - `offspring_balance`: O_s + β·K_o = a + βn + γ·K_s.
  - `pair_balance`: O_s + (β+γ)K_o = O_o + (β+γ)K_s.
  - `pair_total`: O_s + O_o + β(K_s+K_o) = 2(a+βn) + γ(K_s+K_o).
- **`kind_rises_iff_withheld`** (any places, any marks): the kind rises iff β·N₀·P₁ + γ·N₁·Q₀ < β·N₁·P₀ + γ·N₀·Q₁.
  - N₁ and N₀ count the places of the kind and not; Q is own withholding and P partners' withholding, each totalled.
  - Member by member: β·(mean received, kind minus others) > γ·(mean own giving, kind minus others).
  - A mixed cohort of windows, answerers, withholders and alternators under any supplied errors enters only through these six totals, which are the runs' counts.
  - Honest standing: this is `kind_rises_iff` with received + partner's withholding = n substituted, a corollary close to a wrapper.
- **The four terms**, on a cohort listed as pairs:
  - `within_pairs`: offspring's within-pair concordance and discordance are (β+γ) times those of own withholding.
  - `means_of_le` (γ = β + d): the among-pair terms are d times withholding's.
  - `means_of_ge` (β = γ + d): they are d times withholding's, with concordance and discordance exchanged.
  - From these follow `pairs_rises_iff_withheld_le` and `pairs_rises_iff_withheld_ge`; an `example` instantiates the record's `cohort x y z`.
  - Reading: within pairs selection always favours more withholding, with weight β + γ. Among pairs it favours less withholding where β > γ and more where γ > β, with weight |β − γ|.
- **By hand: the link to the field.** Offspring = a + γn + β·G_o − γ·G_s, with G a place's giving. That is the repeated donation game with b = β and c = γ, shifted by a constant common to the cohort. Hence Queller's form of Hamilton's rule and the Price partition (Queller 1985, Price 1972, Okasha 2006: from memory, not read).
- **Worked forms** (by hand, checked numerically with 0 mismatches: `cohort_check.py` over 20,000 cases, `cohort_terms_check.py` over 4,000 with the terms brute-forced):
  - x window pairs, y window–withholder pairs, z withholder pairs, no errors, n ≥ 2: the window rises iff (β−γ)·n·x·(y+2z) > y·(β(2x+y) + γ(y+2z)).
  - The existing `answering_rises_iff` simplifies, with β = γ + e, to e·(xy(2d+1) + 4xz(d+1) + yz) > (x+y+z)(β+γ)·y. It never holds where β ≤ γ.
- **Defeat.** Inside the model, only a misread statement. About the world, a failure of the supplied additivity of offspring in the counts (WS §6).

**Q2. Forgiveness and errors by chance.** The share law is Lean-compiled in /Users/ren/tmp/el7/a/Becoming/EL7aChance.lean, which imports PairSelection and Typicality; every `#print axioms` report is empty. The numbers are exact chain computation, design evidence only. The generous tit-for-tat claims are by hand.

- **Representation stays in the discipline.**
  - Errors are Typicality courses (`List Bool`): each error weighs p, each step without one weighs q, the whole weighs (p+q)^n, and the frequency r = p/(p+q) is rational.
  - `errorsOf` reads 4k values as both formations' errors at steps 1 to 2k. Errors stay one-way.
- **Which laws keep mutual withholding.** `KeepsWithheld f := f (false,false) (false,false) = false`.
  - It holds for answering, windowed, waitingBoth (grim) and withholding (`keeps_*`, by `rfl`).
  - It fails for agreeing, sparing and alternating (`not_keeps_*`).
- **Bursts.** `dead_stays`, `burst_absorbs`, `burst_absorbs_from`: where both formations err at t+1 and t+2, such a pair withholds at every step from t+1 on, whatever the errors after.
- **The share law, `absorbed_share`.**
  - The courses of 4k values under which either formation still gives at step 2k weigh at most S^k, out of T^k, with T = (p+q)⁴ and S < T where p > 0.
  - So the share is at most (1 − r⁴)^k.
  - `window_witness` (`decide`): at p = q = 1, 12 of 16 courses still give at step 2, against a bound of 15.
- **What the deterministic window does not say.**
  - `gives_unless_errs` needs error patterns spaced at the window's width; under chance their share vanishes (by hand: at most (1 − r²)^k per formation).
  - The window only delays total withholding. Exact chain at r = 1/20 (`markov.py`; mean times from `chainf.py`, rerun today):

    | Law | Mean steps to total withholding |
    |---|---|
    | Waiting on both (grim) | 11.2 |
    | Answering | 29.7 |
    | Window of two | 3.3×10⁴ |
    | Window of three (outside the run, which reads two lags) | 1.0×10⁷ |

  - So each added step of window multiplies the time by about (1/r)²: ×306 from two to three, against 400.
  - Over 2,000 steps, though, the window of two still gives 0.919 of the time, with 0.059 of the weight already absorbed. That is more than generous tit-for-tat gives (0.864 forgiving 1/3 of the time, 0.656 at 1/10).
  - Laws that give after mutual withholding never end: agreement gives 0.868 of the time, sparing 0.950.
  - `KeepsWithheld` is the pair's case of `Tolerance.total_stays` ("where no formation spares all it waits on, total withholding stays"); chance makes reaching total withholding certain.
- **Generous tit-for-tat.**
  - It is not in `PairSelection`'s run: the laws read no clock or chance, and errors only withhold.
  - It needs a second pattern that turns an intended withholding into giving, drawn from courses in the same way. That extends the model within the discipline; it was not built.
  - By hand: with any positive forgiving weight, total withholding is left with positive weight at every step, so nothing absorbs.
  - Generosity bound, by hand: a withholder beside a generous answerer forgiving a share f out-leaves a generous pair exactly where γn > β(n−1)(1−f), so in long runs where f > 1 − γ/β. This is q* = min{1−(T−R)/(R−S), (R−P)/(T−P)} = 1 − c/b, the partner bound for reactive strategies in Hilbe, Chatterjee and Nowak 2018, Box 2 (read).
- **Defeat.** Two-way errors, the field's noise, remove the absorbing state. The law follows from the one-way modelling choice and must always be stated with it. The bound is loose, since it counts only bursts aligned to blocks.

**Q3. Stability, best responses, the cycle.** By hand from compiled counts (`counts_agreeing_withholding`, `counts_answering_withholding`, `neutral`, `pair_balance`, `kind_rises_iff`).

- **The field's frames, each with what it compares.** None is the account's own.
  - Best response or Nash (game theory): one formation's payoff under its law against each alternative in a listed set, the partner's law fixed.
  - ESS: an incumbent against a rare mutant.
  - Fudenberg and Maskin 1990 (read): payoffs ordered lexicographically by the number of mistakes, among strategies of finite complexity.
  - Stewart and Plotkin 2013 robustness: a mutant's fixation probability in a population of N against the neutral 1/N, with an explicit criterion under weak selection.
  - Hilbe, Traulsen and Sigmund 2015, Def. 3, and Hilbe, Chatterjee and Nowak 2018, Box 2 (read):
    - partner: nice, and π_I < R implies π_II < R, a comparison with the mutual-cooperation payoff;
    - rival: π_I ≥ π_II, a comparison with the co-player.
  - Press and Dyson's zero-determinant frame: an enforced linear relation between the two long-run payoffs.
  - Imhof, Fudenberg and Nowak 2005 and 2007: time shares of a rare-mutation finite-population process.
  - On the spine each becomes a comparison of offspring over n among the laws the comparer lists, a relation that comparer forms.
- **Agreement against a withholder**, over 2m steps.
  - The withholder beside agreement leaves a + βm + 2γm; an agreement pair leaves a + 2βm; agreement beside the withholder leaves a + γm.
  - Per step, less γ, the matrix is ((β−γ, −γ/2), (β/2, 0)). That is Imhof et al. 2007's win-stay lose-shift against always-defect matrix (read).
  - With pairs formed in proportion to an agreement share x, agreement rises iff x(β−γ) > γ.
  - As x → 1 (a rare withholder) this is β > 2γ; at x = 1/2 it is β > 3γ, Imhof 2007's condition under weak selection. The frame fixes the cohort, and the cohort fixes the threshold.
- **Answering against a withholder**, over 1+d steps: withholding out-leaves an answering pair iff γ(1+d) > βd.
- **Rival.**
  - From `pair_balance`, O_s − O_o = (β+γ)(K_s − K_o).
  - Answering never withholds less than its partner minus one step, so it is never out-left by more than β+γ. This is tit-for-tat's equality relation in Press and Dyson's frame.
  - Hilbe et al. 2018: tit-for-tat starting with giving is the only reactive strategy that is both partner and rival.
- **Agreement beside sparing:** after an error by either one, agreement withholds until sparing's next error.
- **The cycle as a course.** Each arc's comparison is an instance of `kind_rises_iff`:
  - a lone withholder beside a sparer among sparing pairs rises where β+γ > 0;
  - answering pairs among withholder pairs rise where β > γ, and a lone answerer beside a withholder never does;
  - under chance, sparing pairs out-leave answering pairs in long runs where β > γ.

  A course needs a generation map and supplied mutants. It was not built, because it would restate Imhof et al. and Nowak and Sigmund under one-way noise with no prediction that could fail.
- **Defeat:** an arithmetic slip in the two-line counts.

## 3. What it forbids

- **Inside the model:**
  - a kind rising where β·N₀·P₁ + γ·N₁·Q₀ ≥ β·N₁·P₀ + γ·N₀·Q₁;
  - a pair of laws keeping mutual withholding giving at step 2k under more than a (1 − r⁴)^k share of one-way error courses.
- **In the world**, only through supplied readings:
  - the cohort law through additivity (violating counts refute the additive reading, not the identity);
  - the chance law through one-way errors: it forbids cooperation lasting far beyond about 2/r⁴ steps under rules keeping mutual withholding (strict tit-for-tat, tit-for-two-tats, grim) where errors only ever replace giving and nothing forgives.
- No observation is designed, and a specialist would foresee it. Q3 forbids nothing new.

## 4. Against the literature

**New:** no mathematics. New for the account:

- the cohort iff and the closed four terms on its spine;
- errors by chance in counts, with a share law that joins the evolution line to Typicality;
- the exact correspondence: offspring equal the donation game's payoffs plus a + γn;
- correspondences the records lack:
  - `restores_and_answers_iff` matches Hilbe et al. 2017: win-stay lose-shift is "the only memory-1 strategy with these properties (Fig. 1B)" (mutually cooperative, error-correcting, retaliating). The definitions were not compared clause by clause.
  - Agreement is Fudenberg and Maskin 1990's ES example, as restated by Maskin 2009: C first, then C iff both or neither played C.
  - The cohort law is Queller's form.

**Read in full:**

- Imhof, Fudenberg and Nowak 2005 (10.1073/pnas.0502589102)
- Imhof, Fudenberg and Nowak 2007 (10.1016/j.jtbi.2007.03.027)
- Fudenberg and Maskin 1990 (AER 80(2):274–279)
- Maskin 2009 (Springer, 79–84)
- Press and Dyson 2012 (10.1073/pnas.1206569109)
- Stewart and Plotkin 2012 (10.1073/pnas.1208087109)
- Hilbe, Traulsen and Sigmund 2015 (10.1016/j.geb.2015.05.005)
- Hilbe, Chatterjee and Nowak 2018 (10.1038/s41562-018-0320-9)

**Read in part:**

- Martinez-Vaquero, Cuesta and Sánchez 2012 (PMC3329439; its equations were lost in the XML)
- Stewart and Plotkin 2013 (10.1073/pnas.1306246110; main text, not the SI)
- Hilbe et al. 2017 (10.1073/pnas.1621239114; through Table 1 and the discussion)

**Not read:**

- Boyd 1989 (closed). WS §9's description could not be checked against the text.
- Nowak and Sigmund 1992 (search snippet only) and 1993 (abstract only).

**From memory, unverified:** Queller 1985 and 1992, Fletcher and Doebeli 2009, Price 1972, Hamilton 1975, Okasha 2006, Kemeny and Snell 1960, Molander 1985, and Fudenberg, Rand and Dreber 2012. Each must be read before a record cites it.

## 5. The smallest item worth landing

**Item.** "Pair cohorts in counts; errors by chance end pairs keeping mutual withholding." It belongs under AGENTS.md's item 1, a qualification readers need, together with coherence. Claim it on the board first.

**Lean.** Two new core leaves; no existing module changes.

- `Becoming.PairCohorts`, importing PairSelection:
  - `offspring_balance`, `pair_balance`, `pair_total`;
  - `kind_rises_iff_withheld`;
  - `within_pairs`, `means_of_le`, `means_of_ge`;
  - `pairs_rises_iff_withheld_le`, `pairs_rises_iff_withheld_ge`;
  - their helpers.
- `Becoming.PairChance`, importing PairSelection and Typicality:
  - `KeepsWithheld` with its 7 instances;
  - `dead_stays`, `burst_absorbs`, `burst_absorbs_from`;
  - `errorsOf`, `burstFree`, `still_gives_free`, `total_blocks`, `block_lt`;
  - `absorbed_share`, `window_witness`.
- Then the core run and `make gate`. Neither was run here.

**Home, 05 §5.**

- **At `r-offspring-read-from-giving-that-waits`**, add one Theorem sentence: in every cohort a kind rises exactly where β·N₀·P₁ + γ·N₁·Q₀ < β·N₁·P₀ + γ·N₀·Q₁; in a cohort listed as pairs, offspring's within-pair terms are β + γ times own withholding's and its among-pair terms d times, exchanged where β = γ + d. Add a Reading: the offspring are the donation game's payoffs plus a + γn.
- **New anchor for the chance record**, Theorem: where both laws withhold after two steps of mutual withholding, the pair withholds at every step after both err at two consecutive steps, and the courses under which it still gives at step 2k weigh at most S^k of (p+q)^{4k}, with S = (p+q)⁴ − p⁴.
- **The line 133 reading becomes:** "The window is a relative of forgiveness for errors spaced at its width; with errors by chance it delays total withholding and does not prevent it, while generous tit-for-tat, forgiving with a probability and not represented in the run, never ends in it."
- **The D48 reading becomes:** "Tolerance lets cooperation survive withholding spaced wider than its window, and only delays total withholding where withholding comes by chance; it does not rebuild cooperation where it is lost everywhere."

**Records.**

- `offspring-read-from-giving-that-waits`:
  - the "exact condition … four terms" line under Does not show becomes laws;
  - Next keeps only the course of cohorts;
  - Correspondence gains the donation-game identity, Imhof 2007's matrix, and Queller, once read.
- `a-pair-tolerates-only-within-a-window`:
  - "Probabilities" under Does not show narrows to forgiveness with a probability;
  - the window-relative sentences in Does not show and Correspondence are qualified;
  - the Next clause "so that the window meets generous tit-for-tat's forgiveness" is answered: it does not, being a delay rather than a state that never absorbs;
  - Correspondence gains Hilbe et al. 2017 Fig. 1B, Fudenberg and Maskin 1990 with Maskin 2009, and Hilbe et al. 2018 Box 2.
- A new record for the chance law, through research.py.

**WS.md.** Update the §7 lines and the In brief line 66. Qualify §9's "a relative of the window". D-COLLECTIVE-DIRECTION.md:203 (twenty-first review) uses the same phrase; leave it as a review file.

**For WS.md (why the rest stops).** EL7 (a), 5 November 2026, AI-written. Read against Imhof, Fudenberg and Nowak 2005 and 2007; Fudenberg and Maskin 1990; Maskin 2009; Press and Dyson 2012; Stewart and Plotkin 2012 and 2013; Hilbe, Traulsen and Sigmund 2015; Hilbe et al. 2017; Hilbe, Chatterjee and Nowak 2018. Boyd 1989 and Nowak and Sigmund 1992 and 1993 were not read in full. Every result reached is foreseeable:

- offspring are the repeated donation game shifted by a constant, so the cohort law is Hamilton's rule in Queller's form;
- the four pair terms are Price's partition;
- one-way errors by chance end pairs keeping mutual withholding, as an absorbing chain ends;
- the field's thresholds reappear in the counts.

Stability frames and the cycle as a course are not built. Each frame fixes a comparison: a best response over a listed set, fixation against 1/N, a lexicographic order over mistakes, or a cohort, which is why win-stay lose-shift's threshold is β > 2γ in one and β > 3γ in another. Importing one adds that comparison, not a prediction that could fail. A generous run would extend the model only to confirm `Tolerance.total_stays`. What (a) changes for readers: under errors by chance the window delays total withholding and does not prevent it.

## Checks run

- **Lean 4.29.1, against main 86cad9299.** Compiled one at a time under `gate.py hold` with /Users/ren/tmp/el7/a/tools/build.sh: Typicality (a byte-identical copy of main's), EL7aCohorts and EL7aChance. The shared /Users/ren/tmp/el7/olean was not modified; the build reached it through the symlink overlay /Users/ren/tmp/el7/a/olean. Every axiom report is empty.
- **Python design checks** in /Users/ren/tmp/el7/a/scratch/:
  - `cohort_check.py` (0 of 20,000) and `cohort_terms_check.py` (0 of 4,000);
  - `markov.py` (exact rationals) and `chainf.py` (float mirror with mean times, rerun today);
  - `absorb.py` (minimal bursts: a window of w needs 2w errors, grim needs 1);
  - `pairs.py` (mirrors `table_twenty`).
- **Deliberately not run:** `check_becoming.py`, `make gate` and any full suite; the full suite is deferred.
- Nothing in /Users/ren/theories was edited or committed, and its status is clean.