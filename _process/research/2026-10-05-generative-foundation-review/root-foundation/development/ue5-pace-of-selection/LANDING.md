# UE5: what lands, and how

26 October 2026. AI-authored landing note for board item UE5, written with the revision against [REVIEW-UE5](REVIEW-UE5.md). The laws, witnesses and readings are in [NOTE.md](NOTE.md). This note says what lands and where, which rule 9 moves stay owners' decisions, and how the scripts in this kit land it. No script has been run beyond a parse check, and no chapter, record, board row or generated page has been changed.

**The decision.** Land one record, `pace-of-selection-within-what-flows-in` (family F01, region `life`, base `old-base`). Its home is 04 §4, directly after [what bounds offspring numbers](../../../../../../theories/becoming/chapters/04-LIFE.md#r-what-bounds-offspring-numbers), whose open clause it answers. It also gets one bullet in 08 §8's [known results beyond the table](../../../../../../theories/becoming/chapters/08-METHOD.md#beyond-the-table). The module is a leaf ([rule 9](#rule-9)). In the record [what bounds offspring numbers](../../../../../../theories/becoming/results/records/what-bounds-offspring-numbers.md), the next delta loses the clause UE5 answers ("a lineage open to inflow, bounded by what flows in") and the history gains an entry; its laws and their statements are unchanged.

## What lands

**The record.**
- Id `pace-of-selection-within-what-flows-in`; kind theorem, status recorded-checked.
- Title: *The pace of selection, within what flows into the lineages carrying an amount* (选择之速，不过流入携带该量之谱系者).
- Statement: "Under balance on the lineages, offspring standing at m or more, parents at most m and exact transmission, a total rises by at most what flows into carrying lineages over m, and a cap on each parent's lineage inflow caps its growth at a power of the cap; a bound by the whole's inflow is false."
- Its whole text is in [make_records_ue5.py](make_records_ue5.py) (`build`), which is the authority:
  - 26 laws (17 general, 9 on the witnesses), every declaration of the module cited exactly once, which the script asserts;
  - two hypotheses, eight items it does not show, four counterexamples.
- The repository's record lint (`style.lint`) and field validation found nothing on a preview built from it.

**The module**, from [`tree/Becoming/`](tree/Becoming/). The scratch build ([log](scratch.log), 2026-10-25T16:01Z, checkout `94676cb2c`) had no error and no warning, every axiom report empty, and the core pure. The package's Lean is unchanged at `fde9115cb`.

| Module | Theorems | Declarations | Imports | sha256 |
|---|---|---|---|---|
| `Becoming.SelectionPace` | 103 | 224 | `Becoming.Reproduction`, `Becoming.Entropy` | `92556df7…07a3ca` |

- *The general part*: 41 theorems and 4 definitions (`lineage`, `carriedInflow`, `carriers`, `numbered`). The theorems are 13 laws, 13 corollaries, 2 restatements under exact transmission (`sum_exact`, `mean_step_exact`) and 13 helpers.
- *The witnesses*: 62 theorems in 179 declarations, in six worlds (`Displacement`, `Fed`, `Inherited`, `Swap`, `Uncapped`, `Shrink`). Sixteen theorems state what a world shows; the other 46 are its facts.

**Laws** (a summary; `m` is the least standing, and the script's text is the authority).
1. **Offspring within what stood and what flowed in.** Take a step at which the flow balances on some relata followed by the offspring of some parents, each offspring coming to stand at `m` or more. Then `m` for each offspring, with what the relata stand at after the step, is at most what they stood at before and the list's inflow (`born_within_inflow`).
   - It is read on a parent and on a generation (`parent_within_inflow`, `generation_within_inflow`).
   - Parents standing at no more than `m` pin every later member at exactly `m` (`standing_pinned`).
   - In a web where activity needs support, `m` follows from a need (`stands_of_need`).
2. **The response of a carried amount.** The carried inflow sums, lineage by lineage, what flows into each parent's lineage weighted by its amount, so what passes between carrying lineages counts (`carriedInflow`).
   - With exact transmission and each parent standing at no more than `m`: m·s′ ≤ m·s + the carried inflow (`total_within_carried`).
   - In a population not shrinking: m·(n·s′) ≤ m·(n′·s) + n·(the carried inflow), and so for the selection term proper (`response_within_carried`, `selection_within_carried`).
   - A rise nothing feeds shrinks the population (`unfed_rise_shrinks`).
3. **The carriers and the rest of a whole** (an amount of zero or one). m·s′, with what the rest stands at after the step, is at most m·s with what the rest stood at before and what flows into the carriers, the rest and the carriers' offspring (`share_within_rest`).
   - This is the law that a rise past the inflow is drawn from beyond, read on offspring.
   - With no rest, the rise is within the inflow into the carriers' joint lineage, which is at most the carried inflow (`share_within_joint`, `joint_within_carried`, from `inflow_lineage_le`).
4. **Over a stretch** the bounds add (`stretch_within_carried`, `moved_within_carried`, `steps_to_move`). For an amount of zero or one at constant size `N`, reaching the whole from a share p₀ needs a carried inflow of at least m·N·(1 − p₀) over the stretch: a linear bound, never above m·N.
5. **A cap on each parent**: [the per-parent law](#the-per-parent-law), below.
6. **Offspring number.** Read by offspring number, take exact transmission, the next generation standing at no more than `m` and the population not shrinking. Write V for the squared differences of offspring numbers over pairs and I for the inflow into the next generation and its offspring.
   - Then m·V ≤ n·I (`number_step_within_inflow`, `number_spread_within_inflow`).
   - With nothing flowing in, offspring numbers are uniform (`number_unfed_uniform`).
   - Where offspring number is itself transmitted exactly, m·(response)² ≤ n·I·(the amount's spread), with the inflow of the next step (`response_sq_within_inflow`).
7. **Witnesses.**
   - The natural statement fails (`Displacement.natural_fails`, `Displacement.rest_falls`).
   - The audit's candidate, with the same step's inflow, fails even with offspring number inherited (`Inherited.same_step_fails`).
   - The bounds are met with equality (`Displacement.displacement`, `Displacement.factor`, `Fed.fed`, `Inherited.next_step_attained`, `Inherited.stretch_attained`).
   - The carried inflow counts what passes between carrying lineages (`Swap.swap`).
   - Without parents standing at no more than `m`, or with the population shrinking, the response law fails (`Uncapped.uncapped`, `Shrink.shrink`).

<a id="the-per-parent-law"></a>
**The per-parent law** (review suggestion 18, added in counting form). The premises:
- a step at which the flow balances on a parent and its offspring (`lineage [p] kids`);
- each offspring coming to stand at `m` or more;
- the parent standing at no more than `m` before the step;
- `0 < m`;
- `inflow(lineage [p] kids) + m ≤ k·m`.

Under them the parent leaves at most `k` offspring (`parent_within_factor`). The rest follows:
- `total_within_factor`: with these premises for every parent of a generation and exact transmission, s_{t+1} ≤ k·s_t;
- `total_within_power`: with them at each of `T` steps, s_T ≤ k^T·s_0;
- `share_within_power`: adding n_0 ≤ n_T, n_0·s_T ≤ k^T·(n_T·s_0);
- `whole_within_power`: adding n_T ≤ s_T, n_0 ≤ k^T·s_0. So from `c` carriers among `N`, T ≥ log_k(N/c) = log_k(1/p₀).

`Displacement` meets the factor law with equality for k = 2 (`Displacement.factor`). This is the reproductive-excess limit of Nei (1971) and Felsenstein (1971) in counts. It is near-definitional once the cap is supplied: the flow's part is turning a cap on what flows in into a cap on offspring.

**Conditions** (the record's hypotheses). No axiom, and these modelling choices:
- discrete steps;
- natural-number amounts and standings;
- generations each listed as the offspring of the last;
- balance only on the family a lineage occupies across the step;
- each offspring coming to stand at a supplied least standing `m` or more.

Dissipation is not used. Each law adds only the premises it states:
- parents standing at no more than `m`;
- exact transmission;
- a population not shrinking;
- an amount of zero or one;
- the cap `k·m`;
- offspring number transmitted exactly.

**Does not show** (the record's eight items, in brief).
- A pace bounded by what flows into the whole or into the population's own lineage: that is false.
- Haldane's limit from selective deaths, which the generations do not list.
- The carriers' joint law for an amount above one; how long exact transmission of offspring number with growth can last within a bounded inflow; drift and mutation.
- A least standing from the dynamics: `m` is supplied, tied to need only through `stands_of_need`.
- A tightening by dissipation.
- A balanced-on form of Entropy's stock law (the Entropy owner's decision), and why `born_within_stock` stays.
- That actual populations meet the per-member bounds or exact transmission of offspring number. Soft selection is a reading, not a theorem.
- That any pace, amount or lineage is better: no evaluation enters, and ranking needs C.

**Links to other records.**
- Dependencies, all formal reuse: what-bounds-offspring-numbers, additive-part-of-offspring-variance, selection-term-over-generations, evolution-on-descent, a-rise-past-the-inflow-is-drawn-from-beyond, laws-of-one-step.
- Related: what-a-rise-draws-from-beyond, entropy-history-and-record.

**The home text and the 08 line.** [texts_ue5.py](texts_ue5.py) holds the text and is the authority. Every chapter edit only adds lines, except 08's receipt sentence, which every landing rewrites.
- *04 §4*, between `r-what-bounds-offspring-numbers` and `r-additive-part-of-offspring-variance`, the script adds:
  - the anchor `r-pace-of-selection-within-what-flows-in`;
  - a theorem paragraph with five bullets: offspring within what stood and what flowed in, the response of a carried amount, the carriers and the rest, the cap on each parent, and offspring number;
  - a witnesses paragraph;
  - a labelled reading [AI reading, D45]. It reads the result as Malthus's limit read on the carrying lineages, and the per-parent form as the reproductive-excess limit in counts. It is not Haldane's cost, which counts selective deaths. Wallace's soft selection is the setting of a part gaining from the rest.
- *04, elsewhere*: the link reference `[selectionpace]` and an item in the Open list.
- *08 §8*: one bullet at the end of the known results beyond the table. It says that:
  - the result is the Malthusian limit read on the carrying lineages, joined to Price's and Fisher's identities;
  - the per-parent form is the Nei–Felsenstein limit in counts, not Haldane's cost;
  - the variance bound is density regulation of heritable variance in fitness;
  - the third part is yes and weak, carried by its premises;
  - the natural statement is false.

## Rule 9

**A leaf, with its reason.** The module joins `Becoming.Reproduction` and `Becoming.Entropy`, neither of which imports the other, and no module below needs a pace of selection. No landed module is changed. The root module's bullet (`integrate_ue5.py`) says it is a leaf and why.

The review's moves are generalizations below that would change modules other owners hold. They are listed here as owners' decisions or notes for the integrator, and none is made:
1. **A balanced-on form of Entropy's stock law** (review suggestion 14; the probe's R1, with empty axiom reports). *The Entropy owner's decision.*
   - `Entropy` would gain `Flow.BalancesOn.stock_gained` and `Flow.BalancesOn.stock_inflow`. The existing `Flow.Balances.stock_gained` and `Flow.Balances.stock_inflow` would be proved from them, with their statements unchanged; Dissipation's `BalancesOn.runs_down` is the precedent.
   - `born_within_inflow` would then cite the law instead of re-deriving it inline, and could keep `lost` on the left.
   - Until then, its docstring and the record say that it re-derives Entropy's law on the list balanced on.
2. **`born_within_stock` stays beside `born_within_inflow`.** *No move; the record says why.*
   - They are siblings. In the pure core neither placement of the offspring derives the other: the support form needs the offspring distinct, and without decidable equality a family cannot be split into its offspring and the rest.
   - Making `runs_down` a case of the stock law would move `inflow` and `lost` below `Dissipation`, a refactor of shared modules.
3. **`mean_step_exact` to `SelectionTerm`**, as `Generations.mean_step_exact`. *The SelectionTerm owner's decision.*
   - Four declarations re-derive it inline and would use it: `balanced_exact_iff`, `raises_exact_iff`, `Reproduction.Generations.response_sq_le` and `Reproduction.Breeding.response`.
   - If the move is declined it stays here, its docstring calling it the fifth statement of the rewrite.
4. **`numbered`, `numbered_family` and `numbered_number` beside `Reproduction.Generations.ByNumber`**, the generations that predicate describes. *The Reproduction owner's decision.*
5. **The inflow's subadditivity to `Entropy`**, where `Flow.inflow` is defined. *The Entropy owner's decision.*
   - `excess_add_le` and `excess_total_le` would sit beside `Flow.excess_le_of_le_add`.
   - `inflow_lineage_le` would move in a form for any lists, with the lineage form its case.
   - The probe's R2, that a family dissipated on has no inflow, belongs there too; the module cites its two lemmas instead (`Flow.DissipatesOn.gainlessOn`, `Flow.gainlessOn_iff_inflow`).
   - If `lineage` moves below, its name should avoid the other senses of "lineage" in the prose of `Copying`, `Courses`, `Evolution` and `Founding`.
6. **For the integrator only.** `Flow` proves `Balances.over` and `BalancesOn.over` separately, which predates the rule.
7. **Witness reuse; no move.** `Displacement` is `Reproduction.OnePool`'s flow, a parent taking three units and giving one to each of two offspring. Its pool is split into a pool and another member, and it is read with `SelectionTerm.Rising`'s counts. The module's docstring says so.

**If an owner takes move 1, 3, 4 or 5 before landing**, this module and its record change with it. Then:
- rebuild and save `scratch.log`;
- update `KIT_SHA256` in `integrate_ue5.py`;
- update the declaration lists and the count (224) in `make_records_ue5.py`, and the support set in `register_ue5.py`.

After landing, the same moves would change a landed module's names.

## Not scripted: options for the lander

Two edits would rewrite an existing line rather than add one, so research-check's scoped drift could bear on records citing those sections. The scripts leave them out:
- *04's Open list, the programme's item.* Its clause "evolution of the conditions of evolution (lineages open to inflow, read with what they draw from beyond)" could point to §4's new result for its first part.
- *08 §12, item 9 (evolution's selection term).* Its Landed list could add the pace of selection within what flows in.

## Landing (for the lander)

**How the scripts behave.**
- Run them from the checkout root of a clean landing worktree, on the then-current main, in the order below.
- Each asserts that every edit applies exactly once and that what it adds is absent.
- None has been run, and each parses.
- On main at `fde9115cb`, a read-only check and a static evaluation of each script's edits found every anchor exactly once and every target absent.
- `N` is the next study section; the last is §410, UE4's.

**The steps.**
1. `python3 -B <kit>/integrate_ue5.py`. It asserts the kit module's sha256 and copies the module into the package, then edits four places:
   - the root module: an import after `Becoming.Entropy`, and an L1 bullet after Entropy's;
   - the checker's core list, after `"Becoming.Entropy"`;
   - the checker's SCOPE text, after Reproduction's entry;
   - the README rows (EN, ZH), after Entropy's row.
2. The checker (`check_becoming.py`), for a fresh core receipt `RECEIPT`.
3. `python3 -B <kit>/texts_ue5.py RECEIPT N`. It writes:
   - the 04 and 08 text above;
   - 08's receipt counts, read from the receipt (UE1's pattern, asserted to match once);
   - the study section `N`, from [study_ue5.txt](study_ue5.txt);
   - the record's and the module's regions.
4. `python3 -B <kit>/make_records_ue5.py RECEIPT N`. It first checks the receipt: passed, the module's hash, empty axiom reports, 224 declarations, the linked records present, the new record absent. Then it writes the record. Last it updates what bounds offspring numbers, after asserting that the record round-trips byte for byte.
5. The renders and checks AGENTS asks for: `make research-render`, `research-check`, `research-links`, `research-test`.
6. The connectivity run, then `python3 -B <kit>/register_ue5.py CONNECTIVITY_LOG`. It registers this module's apart roots only, and refuses if another module's are unclassified:
   - the six worlds as model witnesses;
   - the 13 helpers as support;
   - `sum_exact` and `mean_step_exact` as restatements;
   - the rest as general structure.
7. `python3 -B <kit>/board_ue5.py land UE5 RECEIPT N QUEUE STATE`. It does four things:
   - takes the withdrawn label "the theory's form of Haldane's cost of selection" out of the row's title;
   - moves the row to the history file;
   - puts the queue text at the head of the queue note;
   - names the receipt as the latest.

   It refuses a queue text without `§N` and the receipt, and any text with either withdrawn Haldane phrase. Before landing, `board_ue5.py title UE5` makes the title fix alone, and `board_ue5.py state UE5 TEXT` sets the state.

**Suggested texts** (for the lander to adapt, with `RECEIPT`, `N` and the date filled in).

```text
STATE: landed 2026-10-DD (core receipt `RECEIPT`, study §N; record pace-of-selection-within-what-flows-in,
home 04 §4; reviewed, REVIEW-UE5.md, every finding taken; the natural statement false, the pace within what
flows into the carrying lineages; third part against Price and Fisher yes and weak)

QUEUE: UE5 landed (the pace of selection: a pace bounded by what flows into the whole is false, a part of a
closed whole rising by drawing on the rest; under balance on the lineages, offspring standing at m or more,
parents at most m and exact transmission, a total rises by at most what flows into the carrying lineages over m,
counted lineage by lineage; a cap on each parent's lineage inflow caps growth at k^T, the reproductive-excess
limit of Nei and Felsenstein in counts; read by offspring number, its variance within the next generation's
inflow per member; the third part against Price and Fisher yes and weak; `Becoming.SelectionPace` 103 theorems
in 224 declarations, a leaf, core receipt `RECEIPT`, study §N, new record pace-of-selection-within-what-flows-in,
home 04 §4, what-bounds-offspring-numbers' next delta updated, row in the history file)
```

**Re-check.** The reviewer has not re-checked the revision. If a re-check is made, its verdict goes into three places before landing:
- the study's review paragraph ([study_ue5.txt](study_ue5.txt));
- the record's validation scope ([make_records_ue5.py](make_records_ue5.py));
- the board state.
