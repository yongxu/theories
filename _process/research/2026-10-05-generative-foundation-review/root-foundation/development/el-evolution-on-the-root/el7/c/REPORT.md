## 1. Verdict

It meets the first test in the work's order, a reader misled: 04 §4, 05 §1 and the record ending-laws-as-regimes-on-a-lineage say that, read on a lineage, renewal from outside such as a sun lies beyond where the ending regimes' verdicts hold, but the gate and `Acting` are idle premises of the gated lineage law and of the map's horizon law it reads (each landed statement is a case of a gate-free law, its type checked equal by `rfl`), and a line drawing past a renewal given from no condition degenerates just the same (`Becoming.LineageDrawdown.Drain.outside_ends`; scratch Lean, 115 declarations, every axiom report empty). It meets no frontier test: on one World law with every premise met, selection on a draw raises the drawers' share past the renewal and the lineage degenerates, the same first generation and pool without selection generate, and one step of selection with no growth ends it, with the ledger `below_iff` the exact condition and the stock one term of it; but this is evolutionary suicide, already known (Gyllenberg, Parvinen and Dieckmann 2002; Parvinen and Dieckmann 2013; Ferrière and Legendre 2013, read), the World is handed its offspring numbers rather than deriving them, so it cannot pose the question that theory answers, whether selection carries a trait to a viability boundary, and what the laws forbid follows near-definitionally from their hypotheses. Continue only to land the smallest item of §5 (the gate-free laws, the drain witness and the corrected sentences), which amends two records and closes the selection record's open drain item; stop the rest (two fates for every course on the World, multiplying takers in general), which is foreseen construction that would change no reader's belief.

---

`/Users/ren/tmp/el7/c/REPORT.md` was not written: the harness refused a report file from a subagent and said to put the content in the reply. So the rest of the report follows here, after section 1 above.

# EL7 (c): a lineage's fate over a horizon, with selection on what draws past a renewal

AI-written, 5 November 2026, investigator (c) of board row EL7 (claim `86cad9299`). Scratch only: nothing in `/Users/ren/theories` was edited or committed. Nothing here is claimed until a reader other than its author has checked it.

- **Lean.** `/Users/ren/tmp/el7/c/Becoming/LineageDrawdown.lean`, module `Becoming.LineageDrawdown`, 1,218 lines, sha256 `5de9760f7b8cc95830ac25ce0d37e1943a69f0e24310f3151c9a9297b780e429`. It imports `Becoming.LineageRegimes` only, whose closure is the pure core from main `86cad9299`, compiled with Lean 4.29.1 into `/Users/ren/tmp/el7/olean` (no Mathlib).
- **Checks run.**
  - Compiled this module only (`/Users/ren/tmp/el7/c/build7.log`).
  - `#print axioms` on all 115 declarations (92 theorems, 21 definitions, 2 structures): every one reports no axioms (`/Users/ren/tmp/el7/c/check/Check5.lean`, `Check5.out`).
  - Three type-identity checks by `rfl`, no axioms (`/Users/ren/tmp/el7/c/check/Check6.lean`, `Check6.out`).
  - Not run, deliberately: `check_becoming.py`, `make gate`, any suite.
- **Earlier copies.** `/Users/ren/tmp/el7/c/history/` (v1, v2, and v4, which is the final file).

## 2. The questions

Names below are in `Becoming.LineageDrawdown` or its `Drain` namespace unless stated. "Lean" means scratch-compiled with an empty axiom report: not landed, and not yet checked by a second reader.

### Q1. Can selection itself drive the ending?

**Established (Lean).** One World law covers three courses that share:
- one first generation: `2`, restrained, draws 1; `4`, a drawer, draws 2;
- a pool of 8 and a renewer giving 3 a step;
- one rule: each organism requires the pool at need 1, stands at its own step, and while active draws its draw and gives a unit to each offspring.

`gate` says whether the renewer requires the pool. The premises are met in each course: `balances_S/N/P`, `acting`, `dependent`, `descended_S/N/P`, `within`.

- **With selection (`courseS`), the lineage degenerates.** Offspring number equals the draw (`offspring_is_draw_S`).
  - Concordance is 1, 2, 4, then 0 at the last nonempty cohort, with no discordance (`selection_S`).
  - The drawers' share goes 1/2, 2/3, 4/5, 8/9 (`share_rises_S`), and the mean draw rises (`mean_rises_S`).
  - Uptake against renewal: 3 against 3 at step 0, then 5 and 9 against 3 (`excess_S`).
  - The ledger condition is met at three steps (`draws_past_S`: 8 + 9 < 1 + 17) and not at two (`short_at_two_S`).
  - Every active organism's line up to step 3 degenerates (`every_active_degenerates_S`, `degenerates_S`). The census is empty from step 4 and the selection term is zero from step 3 (`ends_S`). This holds with the gate and without it.
- **Without selection (`courseN`), the lineage generates.** One offspring each, zero terms (`selection_N`), and the pool stays at 8 (`pool_N`). Both lines are in the map's region «生成», the drawer's included (`generates_N`, via the landed `generation_of_reproducing`).
- **One step of selection with no growth (`courseP`) ends it.**
  - At step 0 the restrained member leaves none and the drawer two: concordance 2 (`selection_P`), then zero terms (`selection_after_P`).
  - Size stays two through step 9 (`sizes_P`), and the drawers' share goes from 1/2 to all (`share_P`).
  - Uptake meets the renewal at step 0 (`no_excess_first_P`), then 4 against 3 for eight steps (`excess_P`). The pool goes 8, 8, 7, …, 0.
  - Every active organism's line up to step 9 degenerates (`every_active_degenerates_P`), and the census ends (`ends_P`).
  - This is the discrete counterpart of a "kamikaze" type, viable while the stock its predecessors left lasts and not alone (Ferrière and Legendre 2013).

**The exact condition (Lean).** Under balance, the family's stock at `T + n` is below `m` exactly where the stock at `T`, plus everything given over the `n` steps, is below `m` plus everything taken (`stock_ledger`, `below_iff`). Where activity needs support, the line then degenerates if its whole reach at that step depends at need at least `m` (`degeneration_of_drawdown`).

The landed count form, `n` excess steps from a stock below `n + m`, is a sufficient case (`below_of_excess`). It misses `courseS`: there is no excess at step 0, 8 is not below 2 + 1, and 6 is not below 1 + 1 (`count_short_S`). Only its `n = 0` instance applies there.

**Does the theory say which fate?** No (Lean, plus a reading). The courses differ only in the `kids` field of `Course`. Offspring numbers are a free slot, and nothing ties what is given to offspring to what is drawn.

**Where plenty of stock enters** (by hand, from `below_iff`). The stock is one additive term against the cumulative net draw.
- Under persistent excess, it sets the horizon.
- Under transient excess, it is a threshold: the need stays met exactly where the stock is at least the need plus the peak cumulative net draw. So plenty can carry a lineage through an overshoot, not only delay its end. This holds for a fixed course of draws while supported.

**On the question's words** (provenance, not warrant).
- "They follow the same way" holds as one law with two fates, not as a law that picks one.
- "Without being generative, abundance can be destroyed" makes generation a cause. In the witness, the pool's loss and the degeneration are both outcomes of one ledger.

**Standing:** Lean, scratch.

**What would defeat it:** a definition (`Descended`, `Dependent`) not meaning what the texts say.

### Q2. Two fates for every course on `Descended` courses, read on the map

Not built.
- **Already landed:** the counting form for every course (`SelectionShift.Horizon.two_fates_of_nonempty`, generic in the member type). On the map: one course per horizon (`Courses.same_terms_two_fates`) and the zero course (`Handover.both_fates`).
- **Missing:** a realization of an arbitrary census on the World.
  - Census lists can repeat a member, so occurrences must be tagged by step and index.
  - Going on would follow by `generation_of_reproducing`, ending by `degeneration_of_empty`.
  - Standing: by hand, a sketch, foreseen.
- **What the drawdown adds** (Lean, read by hand): once the ledger is met with the need unmet, the later census is not free (`ends_of_drawdown`). So two World courses with the same terms but different fates must differ in their ledger, not only in their census.

### Q3. Is every decider one of the three regimes?

**One decider through conditions** (Lean). The landed root `Web.every_branch_ends_of_gone` is the decider: nothing reached at one step is active. Through conditions, that is a step at which the reach's need is unmet (`degeneration_of_unmet`, which needs only `Dependent`), with the ledger as its exact condition.
- No further regime with its own horizon is needed.
- The count form and the draw on a condition given nothing are sufficient conditions.
- The census (an empty cohort) and the schedule decide through offspring numbers, the free slot (by hand).

**The gate is idle** (Lean).
- `degeneration_of_excess` is `LineageRegimes.degeneration_of_family_excess` without its gate and without `Acting`. `landed_of_excess` has the landed type (checked by `rfl`).
- Likewise `Web.family_excess_gone` and `Web.family_excess_degenerates` (`gone_of_excess`, `horizon_of_excess`, `landed_gone`, `landed_horizon`, each checked by `rfl`).
- Why: the landed proofs use `Flow.family_excess_ends` at `k = 0`, where the gate is not used. A line at a class within activity cannot pass a step at which nothing it reaches is active.
- The witnesses:
  - `landed_met`: the landed gated law, met non-vacuously.
  - `outside_ends`: renewal from outside (`from_outside`), every premise but the gate met, and the line degenerates.
  - `degenerates_S false`: the same ending in `courseS` without the gate.
- The gate decides the renewal's fate, not the lineage's:
  - with the gate, `renewal_ends_S` and `renewer_degenerates_S` (a lineage reading of joint excess ending a renewal, in a witness only);
  - without it, `renewal_goes_on_S` and `renewer_goes_on_outside`: the pool returns while the line stays ended.
- This agrees with the landed `Flow.ends_at_race_end` (05 §3: "no renewal need be gated") and with `Restored.returns`. Investigator (b)'s `Gated.stays_fallen` is consistent but was not reused (no census).
- **Grain caveat:** all of this is at classes within activity. At a coarser grain, where a dormant formation carries a line on (`StandingRelay`, `OneBirth.dormant_goes_on_at_support`), whether an outside renewal restores a lineage is not shown.

**Multiplying takers in general** (by hand only). With a fixed renewal `r`, takers at least doubling from one meet the ledger by the least `n` with `stock + n·r < m + 2^n − 1`, while all stay supported. A map law would need "active exactly while supported". Not built.

### Q4. Two courses agreeing on counts and verdict, one going on and one ending

- **Counting form:** landed and not mine; its use here is by hand. `Horizon.keep_family` and `keep_terms` are generic, so any verdict reading consecutive cohorts agrees through `H`, pairs included.
- **Pair model** (by hand, not checked against `kind_rises_iff`): the counts through `H` do not read support after `H`, which WS §6 makes a premise.
- **Consequence:** WS §5 item 4 forbids nothing (text in §5).
- **Defeater:** a pair verdict that reads more than consecutive cohorts.

## 3. What it forbids

**Lean.** Under balance, `Acting`, `Dependent` and `Descended`: once the stock plus what was given is below the need plus what was taken, and every member of cohort `T + n` depends at that need, no later cohort is nonempty and the term is zero from `T + n` (`next_empty_of_unmet`, `ends_of_unmet`, `ends_of_drawdown`, `no_term_of_drawdown`). No gate is needed, so this holds whatever renews the resource, a sun included.

**As an observation.** In a closed population whose members need a resource at a threshold and reproduce only while supported, no offspring appear at or after a step where the resource's ledger falls below the need. Offspring seen there would show that a hypothesis fails (reserves or dormancy, immigration, a need that is not a threshold), not the law. So it is near-definitional through its hypotheses. Nothing is forbidden about which fate selection produces. No frozen test was designed ((d) owns that).

## 4. Against the literature

**Read whole.**
- Ferrière and Legendre 2013, Phil. Trans. R. Soc. B 368: 20120081.
- Parvinen and Dieckmann 2013, J. Theor. Biol. 333: 1–9 (IIASA IR-13-058).

**Read in part.**
- Gyllenberg, Parvinen and Dieckmann 2002, J. Math. Biol. 45: 79–105: abstract, introduction, §4 to Theorem 3, §5.1.
- Dieckmann and Ferrière 2004, IIASA IR-04-063: §5, with Box 5.
- Metz, Geritz, Meszéna, Jacobs and van Heerwaarden, IIASA WP-95-099: §2.1.
- Rankin, López-Sepulcre, Foster and Kokko 2007, J. Evol. Biol. 20: 1459–1468: abstract and introduction (not on the list).

**Not obtained** (bot-check pages, not bypassed).
- Parvinen 2005, Acta Biotheor. 53: 241–264.
- Gyllenberg and Parvinen 2001, Bull. Math. Biol. 63: 981–993.
- Rankin, Bargum and Kokko 2007, TREE 22: 643–651.
- Bell 2017 (citation from memory, unverified).

**Not read at all.**
- Webb 2003, Am. Nat. 161: 181–205.
- Rankin and López-Sepulcre 2005, Oikos 111: 616–619.
- Gomulkiewicz and Holt 1995, Evolution 49: 201–207.

Citation details for the unread ones were taken from the reference lists of papers I read.

**What is known.**
- Evolutionary suicide is well established. Parvinen and Dieckmann show it even under optimizing, frequency-independent selection, through global bifurcations.
- A continuous transition to extinction excludes it, so a discontinuous one is necessary and not sufficient (GPD 2002 Theorem 3 and §5.1; D&F 2004 Box 5).
- Ferrière and Legendre describe single-substitution "kamikaze" mutants.

**What the discrete form adds.**
- An exact accounting identity in place of a bifurcation condition.
- Constructive ends with empty axiom reports.
- A witness inside the account's own World.

**What it does not add.** It adds no test of the literature: the World has no resident attractor, no invasion fitness and no trait dynamics, and its offspring numbers are supplied. That an end lasts, at the grain of activity, is ecology's "extinction is absorbing". No novelty is claimed.

**Could not check.** Whether Parvinen 2007 (Evol. Ecol. Res. 9: 619–633, discrete-time; not read), Webb 2003 or Gomulkiewicz and Holt 1995 already give a ledger form.

## 5. Landing

### Smallest item: a correction with its law and witness, amending two records

Every completed result is kept, `FromOutside` included as the boundary of no excess.

**Lean.** A new core leaf, `Becoming.LineageDrawdown`, as it stands. A leaf is used so that no landed hash changes.
- the ledger: `stock_ledger`, `below_iff`, `below_of_excess`;
- the decider: `degeneration_of_unmet`, `_listed`, `degeneration_of_drawdown`, `degeneration_of_excess`;
- the gate-free horizon: `gone_of_excess`, `horizon_of_excess`;
- the case wrappers, labelled "not a result": `landed_of_excess`, `landed_gone`, `landed_horizon`;
- the census: `next_empty_of_unmet`, `ends_of_unmet`, `ends_of_drawdown`, `no_term_of_drawdown`;
- `Drain`. The correction needs only `courseP`, `outside_ends` and `landed_met`. `courseS` and `courseN` answer the selection record.

**04 §4 (home of ending-laws-as-regimes-on-a-lineage).** Replace the sentence beginning "Renewal from outside, a renewer giving from no listed condition…" with:

> Renewal from outside, a renewer giving from no listed condition and requiring none, with nothing in excess, meets none of the three premises, every formation active and supported at every step (`FromOutside.from_outside`). What puts it outside is the absence of excess, not the source of the renewal: the lineage reading uses neither the gate nor `Acting` and holds without them (`Becoming.LineageDrawdown.degeneration_of_excess`, of which `degeneration_of_family_excess` is the case), so `n` steps of excess from a stock below `n + m` end the line whatever renews the family, a renewer giving from no condition included (`Drain.outside_ends`). The gate decides the renewal's fate: with it the renewal ends with the line, without it the renewal and the level return while the line stays ended (`Drain.renewer_degenerates_S`, `Drain.renewal_goes_on_S`), since a line at a class within activity cannot pass a step at which nothing it reaches is active. Through the ledger the condition is exact: the stock at `T + n` is below `m` exactly where the stock at `T`, with everything given across the `n` steps, is below `m` with everything taken (`below_iff`), and the line degenerates where its reach there so depends (`degeneration_of_drawdown`).

**05 §1.**
- Change "The gated conclusions hold only for" to "The gated conclusions after the step the excess reaches hold only for".
- Replace the parenthetical with:

> (at that step the end holds for any renewal, `Flow.ends_at_race_end`; read on a lineage at a class within activity it lasts, since the line cannot pass that step, so a lineage drawn past a sun's renewal from too small a stock ends without any gate, [04 §4](04-LIFE.md#r-ending-laws-as-regimes-on-a-lineage))

- Optionally, give the own-count-misses-joint-excess record's first does-not-show entry the same qualifier.

**Record ending-laws-as-regimes-on-a-lineage.**
- **statement** (285 characters): "Three ending laws, read as deciding a lineage's region under a premise on the line's reach, are regimes whose horizon the stock sets: renewal run past, dissipation within the family, a draw on a condition given nothing. At each positive stock both fates occur; the first needs no gate."
- **new law:**

> No gate. Under balance and where activity needs support, n steps of excess of a family's uptake over its replenishment from a stock below n + m make the line from an active occurrence at a step not after T + n degenerate at the kind grain wherever everything it reaches at T + n requires a member at such a need, whatever renews the family; the gated reading is its case, its gate and Acting unused, and so is the map's horizon law. Exactly: the stock at T + n is below m where the stock at T with everything given is below m with everything taken.

- **witness law:** `landed_met`, `outside_ends`, `renewer_degenerates_S`, `renewal_ends_S`, `renewal_goes_on_S`, `renewer_goes_on_outside`.
- **hypotheses:** the gate and only-active-giving are carried by the statement but used by no lineage reading.
- **counterexamples:** add `Drain.outside_ends`.
- **correspondence:** "…the scope limit of the gated conclusions after the step the excess reaches; at that step they reach a renewal from an outside source such as a sun, and on a lineage the end lasts".
- **does_not_show:**
  - add: restoration of a lineage by renewal from outside, at a grain coarser than activity;
  - narrow "a lineage reading of joint excess ending a renewal" to "in general" (it is witnessed in `Drain`).
- **next_delta:** through conditions, one decider with the ledger exact. The census deciders and multiplying takers on the map stay open.
- **history:** an EL7 entry saying what was corrected and that nothing was removed.

**Record the-selection-term-and-a-lineages-fate (04 §3).**
- **witness law:**

> In Drain, one World law and three courses from one first generation and pool: each drawer leaving as many offspring as it draws, concordance 1, 2, 4 and 0 at the last nonempty cohort, the uptake meets the renewal at the first step and runs past it after, and every active organism's line up to the step the ledger is met degenerates, with the gate or without; every member leaving one, the pool stays at eight and the lineage generates; the restrained member leaving none and the drawer two once, no growth, eight steps of excess end it.

- The second half of `next_delta` (the suicide witness joined to an amount drawn past the gated renewal) is answered. The first half stays.
- The does-not-show entry "the mark here is a label, not a draw" is answered and moves to history.
- In 04 §3, after `Courses.positive_but_last`, add:

> With the mark a draw on a renewed pool, the same pattern ends by the drain itself, gate or none (`Becoming.LineageDrawdown.Drain.selection_S`, `every_active_degenerates_S`), while with every member leaving one the same first generation and pool generate (`Drain.generates_N`).

**Still required before landing:** the core run, generators, render, `make gate` on the merged tree, and a second reader for the Lean and for each restatement. None of this was done here.

### Not worth landing: text for WS.md

> EL7 (c), 5 November 2026, AI-written. Item 4 of §5, "a fate of the pairs read off their selection, within any horizon", is not a forbidding: the account reads no fate off selection within a horizon. The counting law is landed and generic in what a member is (`SelectionShift.Horizon.keep_family`, `keep_terms`): for every course and horizon `H`, a course that goes on and one that ends keep its cohorts through `H + 1`, so any verdict reading consecutive cohorts, the pairs' included, agrees through `H`. Read in the pair model, by hand and not checked against `kind_rises_iff`: offspring are counted only while supported (§6), and the counts through `H` do not read support after it. Two further items were weighed and stopped, as foreseen constructions that would change nothing a reader is told: two fates for every course of terms on `Descended` World courses (it needs census occurrences tagged by step and index; the counting form is landed for every course and the map form for one course per horizon), and multiplying takers degenerating on the map in general (with a fixed renewal `r`, doubling takers meet the ledger by the least `n` with `stock + n·r < m + 2^n − 1`, by hand; a map law needs activity exactly while supported). What EL7 (c) found worth landing is a correction, not a frontier result: the gated lineage law needs no gate, so renewal from outside does not put a lineage beyond it.