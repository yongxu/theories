## 1. Findings

AI-written (EL7, investigator b), 5 November 2026. Scratch only: nothing in /Users/ren/theories was edited or committed. Main was read at 86cad9299.

### 1.1 Verdict

The pair's run is now a balanced flow on a web, and the formula's offspring follow from it exactly: β is what a gift brings the receiver's line, plus any matching a renewer gives for it, and γ is what keeping brings the keeper's line. This meets the Next of `what-giving-that-waits-draws-on` (unification), and it corrects what 05-COLLECTIVES §6 tells a reader (coherence): renewal from outside that does not depend on the giving leaves β = γ where the routes lose nothing, and need asymmetry and renewal gated on support act only at a shortfall, which the formula's own premise of support over the run excludes. It widens scope modestly (dissipation avoided, a third party's matching, a gift or a draw carried past a gated renewal, with witnesses of both signs) and lets the account be wrong a little more, because the sign of β − γ becomes a function of losses and matching that could be measured; but it is not new mathematics and each mechanism is in the literature, so nobody sees farther by it. Land the small item in 1.5 and stop hunting for further sources: the list is exhaustive only at the level of balance, where it is near-definitional.

### 1.2 The questions

All the Lean below is in /Users/ren/tmp/el7/b/Becoming/PairFlow.lean:
- **Module:** `Becoming.PairFlow`, which imports only `Becoming.PairSelection`. The file has 1,093 lines and sha256 `c231b525738b0e0704b74fe14f8f6549324402bc2d297d9930e67fd675f3e5e0`.
- **Compile:** Lean 4.29.1, against the oleans of main 86cad9299.
- **Axiom audit** (/Users/ren/tmp/el7/b/audit/PairFlowAudit.out): 278 of the module's 283 constants have an empty axiom report. The other 5 are generated `injEq` lemmas on `propext`; the checker's audit admits these, and no source declaration uses them.
- **Theorems:** 80 source theorems.
- **References** (/Users/ren/tmp/el7/b/audit/PairFlowImports.out): only to `Init` and Becoming modules. The checker's prelude-only compile was not run.
- Names below drop the prefix `Becoming.PairFlow.`.

**Q1. Can β and γ be derived from a flow? Yes.**
- **Statement.** By `Routes.line_offspring`, on `Routes.flow P (gaveIn s)`, for every place `s` (any laws, any errors), the place's line at step `n` is `s.offspring (start + own·n) (reach + matched) kept n`. That is a + β·received + γ·withheld, where:
  - β = reach + matched: what of a gift reaches the receiver, plus a renewer's matching, passed to its line.
  - γ = kept: what of a withheld gift's amount reaches the keeper's line.
- **Premises met.**
  - The flow balances, only active formations give, and both formations are supported at every step (`Routes.balances`, `acting`, `dependent`, `supported`, given need ≤ standing).
  - `Routes.signs` exhibits parts that meet these premises.
- **Modelling choices.**
  - Discrete steps, natural amounts, Bool giving, constant parts per step.
  - A renewer replaces what each standing draws, so support over the run is built in, not derived.
  - Offspring are read as a line's level, with `a` = start + own·n at each `n`.
- **Content.** Once the routes are constant the derivation is close to definitional; its content is the identity under Q2.
- **Defeat.** Offspring that do not track amounts passed on, or parts that vary with the state; then no constant factors read the run, as at the shortfalls below.

**Q2. When does β exceed γ, and does any of it forbid something?**
- **Constant routes.**
  - `Routes.factor_gap`, `Routes.gap_iff`: where what is kept is the gift's amount (kept + spoiled = reach + spill), β + spill = γ + spoiled + matched. So γ < β exactly where giving loses less on the way than keeping spoils plus the matching.
  - `Routes.plain`: with no loss and no matching, β = γ = reach.
  - `Routes.signs`: γ < β where kept food spoils (`perishing`) and where a renewer matches (`matching`); β < γ where a gift costs its carriage (`carried`).
- **Renewal gated on support** (`Gated`: renewal only while a standing meets its need, giving only while active, a taker beyond drawing within what is held).
  - `Gated.runs_agree_until`, `Gated.factors_equal_while_supported`: while both formations stand, a run where both give at every step and one where neither does keep the same levels, whatever the renewal, draws and needs. So no reading through the levels tells them apart: β = γ.
  - `Gated.lineAt_of_active`: a formation active at every step before `n` has line own·n whatever is given. Read by support, every place supported over the run therefore has β = γ = 0 with a = own·n (this last step by hand).
  - Premises met in `FailedRenewal.agree_to_shortfall`, `read_to_shortfall`, `read_to_shortfall_met` and `GiverAtNeed.kept_first`.
- **What it forbids, inside the model.**
  - β > γ under support over the run, unless giving avoids a loss or a third party matches.
  - Composed by hand with the landed `PairSelection.assorted_lowers_iff` and `never_rises_in_pairs`, giving that waits on giving is not raised where spill ≥ spoiled + matched. There is no combined Lean theorem.
  - The law is conditional on the route model, which is the standing Birch (2014) gives the special version of Hamilton's rule.
- **Defeat.** A system that fits the routes (constant, measured losses and matching, no shortfalls) in which giving that waits rises while spill ≥ spoiled + matched.

**Q3. Is there a general statement of where what a gift brings beyond what it draws can come from, and is it exhaustive?**

The general statement:
- `levels_agree_until`, `levels_agree`: two balanced flows from the same levels keep the same levels if, at each step where the levels agree, their takes and gives on each condition differ only by amounts that cancel.
- `factors_equal`: any reading through the levels then gives both the same.
- So whatever giving brings the pair, on any such reading, comes from a difference in the flow that does not cancel. There are two kinds:
  - **(i) The family's net flow differs.** By losses (dissipation avoided, `Routes.perishing`); by gives from beyond tied to the run (a third party's matching, `Routes.matching`; renewal gated on support, `FailedRenewal`); or by takes from beyond tied to the run (draws; there is no witness of a draw avoided).
  - **(ii) The same amounts are placed differently and the reading is not additive.** For thresholds this is the landed need asymmetry, bounded by Q4's capacity bound.
- This is exhaustive only as far as balance's terms go. It holds of every balanced flow by the definitions and forbids nothing by itself, the standing Birch gives the general, Price-equation version of Hamilton's rule.

The mechanisms I was asked to hunt:
- **Timing** (`FailedRenewal`): the same mutual gifts change nothing before the shortfall. At it, two units given bring the pair's lines `m` more over `m + 4` steps (`lines_gain`, `gifts_sharing`).
- **Storage:** kept against spoiled; the slack above need is the buffer given from.
- **Third party:** matching.
- **Dissipation:** `perishing` and `carried`.
- **Renewal gated on what it renews:**
  - `Gated.stays_fallen`: a formation below its need that is given nothing never stands again.
  - `DrawnBelowNeed.fallen`: one draw of two units from a standing at its need is carried past the gate; the formation never stands again after the taker stops.
  - `GiverAtNeed.gift_lost`: one unit given from the giver's need to a formation that never gives leaves the giver's line `m` short over `m + 1` steps. The receiver, standing either way, leaves the same (`withholder_same`).

At the level of mechanisms the list is an enumeration, not a theorem. Concave (non-threshold) readings, synergy beyond a per-gift matching, and draws avoided by giving fall under (i) or (ii), but none has a witness here. As mathematics none of it can be defeated; only the fit of the readings to a system can fail.

**Q4. "Amounts are conserved but support is not, because needs are thresholds": a law, or near-definitional? Near-definitional.**
- "Support is not conserved" is the landed `PairSelection.Needs.asymmetry_gains`, and it follows from support being a threshold.
- "Conserved" overstates the landed law, which says only that a family gaining nothing does not rise; losses are allowed.
- **The one constraint it carries.** `met_needs_within_start`: in a balanced flow, over a stretch at every step of which the family gains nothing, the needs met at its end total at most its stock at its start. This is a two-line consequence of `metNeed_le` (a met need is within the level, by definition) and the landed `Flow.Balances.stock_not_rises_over`.
- **Attained.** `NeedsAtCapacity.at_capacity`: in the landed asymmetry witness the needs met go from 1 to 3 while the stock is 3.
- **Forbids:** a closed family meeting more need than it held.
- **Defeat:** needs met from something other than the same stock, which is outside the model.

**Q5. Can the model carry a draw past a gated renewal? Yes.** See `Gated`, with `stays_fallen`, `DrawnBelowNeed` and `GiverAtNeed`. Investigator (c) may reuse the module.

**By hand, beyond the Lean.** This is a plain simulation of the `Gated` semantics in one setting, /Users/ren/tmp/el7/b/tools/gated_sim.py, with laws that read the partner, in the `FailedRenewal` setting:
- Answering stops giving after the fallen formation's first missed step, and the pair ends as keeping does: the second's line stays at 2.
- The window of two gives through the miss and the pair recovers: the second's line reaches 9 by step 12.
- Conjecture: under gated renewal a shortfall is an error the partner's law must tolerate, so the formula's supplied errors can be derived from the flow. This is not Lean and not general.

### 1.3 What it forbids that an observation could show

Each item holds only where the model fits: discrete steps and amounts, with constant routes or renewal gated on standing.
1. Among partners that never fall below their needs, where descent depends only on standing, no pattern of giving changes offspring (`Gated.lineAt_of_active`). So giving that waits is not selected there (the landed `assorted_neutral` at β = γ).
2. With constant routes and no shortfalls, giving that waits rises under complete assortment only if transfer loses less than storage spoils plus any third party's addition per gift (`Routes.gap_iff` with the landed assortment laws). Reciprocal giving of storable goods that do not spoil, with costly transfer and no matching, should not spread.
3. Under renewal gated on standing, a formation below its need with no gift or other inflow does not recover (`stays_fallen`), whatever drew it down.
4. A closed group meets at most the need its stock held (near-definitional).

Two observations in what I read are consistent with this; neither is a test of it. Captive vampire bats feed fasted roost-mates (Carter & Wilkinson 2013). The Maasai need-based rule in Aktipis et al. (2016) gives only what keeps the giver above a giving threshold, the threshold `GiverAtNeed` shows to matter.

### 1.4 Against the literature

There is no new mathematics, and no novelty is claimed.

**The factors.** In what was read, b and c are payoff parameters or regression coefficients:
- Van Cleve & Akçay 2014, Evolution 68: 2245–2258. Read through an account of the arXiv text, sections 1–5 and appendix A; the last quarter unread.
- Birch 2014, BJPS 65: 381–411. Accepted manuscript, sections 2–7 read in full.
- The account's derivation of b and c from a balanced flow is the join the record asked for, not a new result.

**The sources of the gain are known:**
- Whitlock, Davis & Yeaman 2007, J Evol Biol 20: 1772–1782 (abstract only; the full text was refused): reciprocal sharing needs the resource's fitness value to differ between partners, with the differences reversing. This is the relative of the pass-through and shortfall results.
- Aktipis et al. 2016, Hum Ecol 44: 353–364 (read through an account of the PMC full text): need-based transfers with a viability threshold pool risk better than account-keeping in volatile settings. `FailedRenewal` and `GiverAtNeed` are discrete caricatures of it.
- Peters & Adamou, arXiv:1506.03414v2 (whole text read from my own extraction): pooling raises time-average growth under multiplicative noise, with expectations unchanged. This is the continuous relative of renewal that depends on what is held.

**Also read through accounts of the full texts:** Carter & Wilkinson 2013 (Proc R Soc B 280: 20122573), Allen, Nowak & Wilson 2013 (PNAS), Weitz et al. 2016 (PNAS), Tilman, Plotkin & Akçay 2020 (Nat Commun).

**Abstract only:** Gardner, West & Wild 2011.

**Not read:** Hauert et al. 2006 (refused, HTTP 429); Queller 1985 and Wilkinson 1984 (not reachable).

**Could not check:**
- whether Whitlock et al.'s models contain a pass-through statement like `runs_agree_until`;
- whether any published model derives b and c from a balanced flow with thresholds, as here. I searched and found none, so nothing is claimed.

### 1.5 Landing

Worth landing as one small item.
- **Lean:** the module above, as `Becoming/PairFlow.lean` in the core (80 theorems). It extends the spine's `Web`, `Flow` and `Balances` and PairSelection's `Place`.
- **Record:** new, `what-decides-giving-against-keeping-on-a-flow` (the name is the lander's to choose). Its statement, 291 characters: "On a pair's run read as a balanced flow, offspring read as a line's level are a + β·received + γ·withheld, and γ < β exactly where giving loses less than keeping spoils with a matching; with renewal gated on support, giving changes nothing while both stand and cuts both ways at a shortfall."
- **Laws:**
  1. What passes through changes no level (`levels_agree_until`, `levels_agree`, `factors_equal`).
  2. The factors follow from the flow, and their sign from its routes (`Routes.*`).
  3. Renewal is gated on support (`Gated.balances`, `acting`, `dependent`, `runs_agree_until`, `factors_equal_while_supported`, `lineAt_of_active`, `lines_agree_while_active`, `stays_fallen`).
  4. At a shortfall, a gift or a draw cuts both ways (`FailedRenewal.*`, `GiverAtNeed.*`, `DrawnBelowNeed.*`).
  5. The needs met stay within the stock (`metNeed`, `met_needs_le_stock`, `met_needs_within_start`, `NeedsAtCapacity.at_capacity`).
- **Formal reuse:** `offspring-read-from-giving-that-waits` (Place, gives, tally); `what-giving-that-waits-draws-on` (the Needs web); `what-a-rise-draws-from-beyond` (`stock_not_rises_over`).
- **Home:** a paragraph in 05-COLLECTIVES §6 with anchor `r-what-decides-giving-against-keeping-on-a-flow`, placed after `r-what-giving-that-waits-draws-on`, plus a correction to that earlier paragraph:
  - Renewal from outside lets the giver give without its level falling, but on the derived flow it leaves β = γ unless it depends on the giving or the routes lose unequally.
  - Need asymmetry acts at a shortfall, outside the reading's premise.
  - The paragraph's closing sentence, that the join is not shown, should point to the new paragraph.
- **The old record** keeps its laws and its "Does not show" items, with a history note that its Next is met.
- **For WS.md:** EL7 (b) stops the hunt for further sources of a gift's surplus. At the level of balance the list is exhaustive and near-definitional. Further content needs a model of a system's renewal and readings (gated, multiplicative, concave), or the law-reading gated run in the conjecture above, which belongs with (a).

## 2. Details

The harness refuses report files from subagents, so /Users/ren/tmp/el7/b/REPORT.md was not written. This message is the whole report: section 1 is as asked, and section 2 is the material for the lander.

### 2.1 Files and checks

**Files**
- /Users/ren/tmp/el7/b/Becoming/PairFlow.lean: the module.
- /Users/ren/tmp/el7/b/audit/PairFlowAudit.{lean,out}: the axiom audit.
- /Users/ren/tmp/el7/b/audit/PairFlowImports.{lean,out}: the direct-reference audit.
- /Users/ren/tmp/el7/b/overlay/: symlinks to the shared oleans, plus `PairFlow.olean`.
- /Users/ren/tmp/el7/olean/: the closure of `Becoming.PairSelection` at main 86cad9299.
- /Users/ren/tmp/el7/b/tools/gated_sim.py: the plain simulation.
- /Users/ren/tmp/el7/b/lit/{peters.txt,birch1.txt}: my own extractions.
- /Users/ren/tmp/el7/b/Becoming/Probe.lean: an axiom probe of the core Nat lemmas; not part of the result.

**Checks run**
- One compile of the module: about 4 s, at load 9 to 12. It was not wrapped in `gate.py hold` because it took only a few seconds.
- The two audits.
- The simulation.

**Not run**
- `check_becoming.py` and `make gate`: forbidden by the task.
- The prelude-only compile, render and research-check.
- Any full suite. This was deliberately deferred to landing; what ran is selected evidence, not a full pass.

### 2.2 Witness settings

- **Routes `signs`** (stand, need, upkeep, own, start, reach, spill, kept, spoiled, matched):
  - perishing ⟨2,1,0,0,0,1,0,0,1,0⟩
  - carried ⟨2,1,0,0,0,1,1,2,0,0⟩
  - matching ⟨2,1,0,0,0,1,0,1,0,1⟩
- **Gated witnesses:** needs 3, upkeep 1, own 1, gift 1.
  - **`FailedRenewal`:** renewal 2 a step, but the second's renewal fails at step 1. Start (5, 3). Sharing and keeping meet at (5, 1) at step 2. From there sharing settles at (3, 3) from step 4, while keeping stays at (5, 1).
  - **`GiverAtNeed`:** renewal 2, start (3, 3). The first always intends to give and the second never does, compared with neither giving. Giving takes the first to (2, 4) from step 1.
  - **`DrawnBelowNeed`:** renewal 2, start (5, 3), neither gives. A taker draws 2 from the second at step 1, leaving (5, 1) from step 2.
- The modelling choices are those listed under Q1, Q2 and the module docstring. No ethical predicate, ranking or axiom occurs. "Rises", "selected" and "raised" are the landed selection laws' relations, read on lines. "Outperform" is Aktipis et al.'s frame: survival time in their simulation.

### 2.3 Draft home paragraph for 05-COLLECTIVES §6

Anchor: `r-what-decides-giving-against-keeping-on-a-flow`.

**Theorem** (World: balance; discrete steps and natural amounts; a pair's run read as a flow on a web, its parts constant per step or its renewal gated on support; offspring read as a line's level). Read a pair's run as a balanced flow in which a renewer replaces what each formation's standing gives and each formation passes what it holds on. Then, for any laws and errors, a place's offspring over `n` steps are `a + β·received + γ·withheld`. Here `β` is what of a gift reaches the receiver, with any matching the renewer gives for it, and `γ` is what of a kept amount reaches the keeper's line; both formations are supported at every step (`PairFlow.Routes.line_offspring`, `PairFlow.Routes.supported`).

Where what is kept is the gift's amount, `γ < β` exactly where giving loses less than keeping spoils with the matching, and with neither loss nor matching `β = γ` (`PairFlow.Routes.gap_iff`, `PairFlow.Routes.plain`). Each sign is met (`PairFlow.Routes.signs`).

Where renewal is given only while a formation stands at its need, a run in which both give at every step and one in which neither does keep the same levels while both stand, whatever the renewal, the draws and the needs (`PairFlow.Gated.runs_agree_until`). So no reading through the levels tells them apart (`PairFlow.Gated.factors_equal_while_supported`). Read by support, a formation standing at every step leaves the same whatever is given (`PairFlow.Gated.lineAt_of_active`). One fallen below its need, to which nothing is given, never stands again (`PairFlow.Gated.stays_fallen`).

At a shortfall a gift cuts both ways:
- two units given to a formation whose renewal failed bring the pair's lines `m` more over `m + 4` steps (`PairFlow.FailedRenewal.lines_gain`, `PairFlow.FailedRenewal.gifts_sharing`);
- one unit given from the giver's need to a formation that never gives leaves the giver `m` short over `m + 1` steps, while the receiver leaves the same (`PairFlow.GiverAtNeed.gift_lost`, `PairFlow.GiverAtNeed.withholder_same`);
- one draw from a standing at its need is carried past the gate (`PairFlow.DrawnBelowNeed.fallen`).

In every balanced flow, two runs whose takes and gives differ only by amounts that cancel keep the same levels (`PairFlow.levels_agree_until`). In a family gaining nothing, the needs met stay within its starting stock, a bound the need-asymmetry witness attains (`PairFlow.met_needs_within_start`, `PairFlow.NeedsAtCapacity.at_capacity`).

[AI reading] Under the reading's premise of support over the run, giving brings more than keeping only by what it saves from loss or what a renewer adds for it. Need asymmetry and gated renewal act where a formation falls below its need, outside that premise.

### 2.4 Correction to `r-what-giving-that-waits-draws-on`

**Opening sentence.**
- Current: "Where giving that waits on giving brings support beyond what it draws (§5), the webs show two ways."
- Proposed: "The webs show two ways a gift can bring support beyond what it draws (§5), the first at a shortfall."

**Closing sentence.**
- Current: "Both bounds have one form, so no web statement compares β with γ, and the join … is not shown."
- Proposed: "Both bounds have one form, so these webs do not compare β with γ. On a flow from which the factors follow, renewal from outside that does not depend on the giving leaves them equal where the routes lose nothing, and need asymmetry acts only below a need (below)."

**Why.** §5's AI reading identifies a gift bringing support beyond what it draws with β exceeding γ. §6 then offers two ways, so a reader would take renewal from outside as a source of the surplus. The closing caveat limits that reading but does not undo it.

### 2.5 Draft record fields

- **Does not show:**
  - Selection on gated runs with laws that read the partner, such as window against answering at a shortfall. Only the simulation covers this.
  - State-dependent parts other than the gate: multiplicative renewal, concave readings.
  - Synergy beyond a per-gift matching.
  - Draws avoided by giving.
  - A combined theorem joining the sign law to the selection laws.
  - Fit to any population.
- **Counterexamples kept:** `Routes.carried` and `GiverAtNeed`.
- **Next** (173 characters): "Law-reading gated runs: the formula's errors derived from shortfalls (a fallen formation cannot give), with the window of two and answering compared where one renewal fails."
- **Correspondence:**
  - vampire bats (Carter & Wilkinson 2013);
  - osotua (Aktipis et al. 2016);
  - pooling (Peters & Adamou);
  - heterogeneity (Whitlock et al. 2007, abstract).
- **Names:** the earlier scratch names `Insured` and `Exposed` were readings. I replaced them with `FailedRenewal` and `GiverAtNeed` and recompiled.

### 2.6 Next

- **For the lander:** compose `Routes.gap_iff` with the landed assortment laws in one theorem, if 1.3 (2) is wanted as a single statement.
- **With or after (a):** law-reading gated runs. The state would carry the last two sends, and the intended giving would be read by the `PairSelection` laws. Shortfalls would then become derived errors, testing the window-against-answering conjecture.
- **For (c):** reuse `Gated` (`stays_fallen`, `DrawnBelowNeed`, `GiverAtNeed`) unchanged for a lineage's fate under repeated draws.
- **For (d):** the observable patterns are 1.3 (1)–(3), each conditional on the model's fit. None of them tests a root law.