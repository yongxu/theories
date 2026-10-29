# GW: re-check of the revised study note against the review

AI re-check, 29 October 2026, Claude Opus 5.5 (`claude-opus-5-5`). Read-only, except for this file. Read: the revised [NOTE.md](NOTE.md), with its §13 mapping of F1–F16; [founding_check_period2.py](founding_check_period2.py) and its `.out`; my [REVIEW-GW.md](REVIEW-GW.md). Re-read against the Lean at HEAD:
- `KeepingWidening` (`Linked.snoc`, the passing laws, `Source`);
- `ContinuedClasses` (`Linked`, `Linked.mono`, `ExceedsAcross.anti`);
- `MapInstances` (`carries_iff`, `generation_renews_late`);
- `Dissipation` (`Dissipative`, `DissipatesOn.takes_of_gives`, `giving_needs_uptake`, `Balances.taking_not_recurring`, `enclosed_of_finite`);
- `Amounts` (`rests_unrefuted`);
- `Change` (`Steps.reached_of_buqiong`);
- `Arising` (`Steps.hasPred_iff`);
- `GrammarMap`;
- `EventualWidening` (`keepsWidening_reidentify`, `KeepsWidening.not_listed`).

Also re-read: D1 with its R25 paragraph, D5, D65 item 4, 07 §2, and `check_becoming.py`'s module lists. I checked the transitive imports of `Becoming.KeepingWidening` and looked for clashes with the new names. No Lean was built, no checker was run and no script was executed. Lean paths are relative to `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`.

## Verdict

Every finding was taken, and the formal ones are resolved correctly:
- The law, re-stated for carrying on of the supported, is true with the given proof. The three kinds of passing are exhaustive (up to double negation), `BeginsAlong` is exactly a passing that begins a line of the reading under activity, and corollary 4 does give the landed `descends_along_passings` by `Linked.mono`.
- The restated `withinKind_cont_iff` (at supported occurrences), `withinKind_begins_iff` (at active ones) and `BeginsAlong.carries_kind_iff` (both directions) hold.
- §3.4's argument is right, and its constructive gap is already closed by `Amounts.rests_unrefuted`.
- `KindRelay`'s claims 1–7 hold.
- `KindRelay.Fed` balances at every condition (fuel included), is dissipative on every family closed across a step, and so meets the first law. Its items 1–4 are unchanged.
- The LPO coding in §9 is right.

No high finding remains. Three medium points remain:
- §7's new text says the witness's "what can form" stays the same, but its admitted set alternates (R1).
- §7 reads D1's last clause as "what C reads", which R25 contradicts, and it rests that on an invariance that belongs to `Web.Widens`, not to the by-name reading it uses (R2).
- The plan uses the exclusion along readings that contain `supportedPassing` without a lemma stating it, which rule 9 asks to land below the landed three (R6).

GW1, GW2, GW3, GW3b and GW5 can be claimed. GW4 can be claimed once R6's lemma is in GW3. §7 and the document proposals need R1–R3's wording before any document changes.

## Each finding, as taken

| Finding | Resolved? |
|---|---|
| F1 | Yes. The World law now gives recurring carrying renewals, not regions (§1 item 1, §3.2, §3.3). Residual wording: R3. |
| F2 | Yes. The premise list is exact, "not dissipative" is stated, §3.4 is added, and the fed witness is right. Residual: §1 item 3 drops a hypothesis (R4); §3.4 cites the wrong lemma, and its constructive route is available (R5). |
| F3 | Yes. Carrying on is read only while supported, the period-2 witness is adopted, and the reading with dormant carrying on is kept as the failing case. Residual: R6. |
| F4 | The redraw is withdrawn, and D65 item 4, 01 §6 and the record are engaged. The replacement text in §7 has R1 and R2. |
| F5–F14 | Yes, as §13 says. |
| F15 | Yes, except that §13's row is stale (R7). |
| F16 | Yes. |

## Findings

**R1 (medium). The witness's "what can form" does not stay the same.**
- *Where:* §7, "What the witnesses have" ("what the part can form, by name over its formations, stays the same throughout") and "What D1 reads 生生 as" ("they change no state that can form"); §1 item 1, "Not conversely"; §1 item 5; the proposal for 07 §2 ("what can form by name can stay the same").
- *What is wrong:* §6's own table refutes this. The levels admit `{a0, b0}` at even steps and `{a1, b1, c, e}` at odd ones, so what can form at a step (D3: "formations whose requirements a course's levels meet") changes at every step, by return. Read literally, the witness does change "接下来能够形成哪些状态".
- *What is true:*
  - it returns with period 2;
  - by name over its six listed formations nothing keeps widening (`Web.KeepsWidening.not_listed`);
  - every two steps admit the same formations.
- *What it needs:* the exclusion of return is D5's revision ("not a return into copies of existing forms"; "a whole that only returns has 不息 but not 生生不息"). D1's text does not contain it. So "without 生生还改变接下来能够形成哪些状态" needs D5 as its stated premise.
- *Fix:* replace "stays the same" by "returns, and keeps widening by name from no step". Argue the exclusion of return from D5, and in the 07 §2 proposal write "can return".

**R2 (medium). D1's last clause is not "what C reads", and the cited invariance belongs to another notion.**
- *Where:* §7, "What C reads" ("D1's R25 paragraph states that it reads what can form so. That is the independent criterion …"; "The last clause, changing what can form, is the part C reads"); §11 ("beyond D1's by-name reading").
- *What is wrong:*
  - R25 says `Web.Widens` compares members of `F` given in advance. It adds that 生生 as D1 reads it, "creating the conditions and generators of further forming, can exceed what widening registers" (`DELEGATED-CHOICES.md`, D1's R25 paragraph). The treatise clause D1 quotes goes on to "以及世界能否继续发现新的形成方式": new ways of forming, outside `F`. So C registers only the part of D1's last clause that lies within `F`. D1 has no "by-name reading"; C's widening has one.
  - The invariance cited, "unchanged by every re-identification" (07 §2), is `Web.Widens`', a same-step comparison of two level paths. The by-name notion §7 actually applies to one course across steps (`KeepsWidening itself`, `not_listed`, `whole_not_keepsWidening`) reads names across steps. It is not invariant: `keepsWidening_reidentify` carries `itself` to `σ.carry itself`, and 07 §2 gives the same point for the lagged order (`NamesAcrossSteps.lag_reads_names`).
- *Fix:* say "C registers the part of D1's last clause within `F` given in advance. R25 notes that 生生 can exceed it, and the witnesses, with `F` fixed, have neither." Drop the invariance argument, or confine it to `Widens`, and correct §11.

**R3 (low). Some wording still claims too much.**
- §1 item 5, "The witness proves them on a model": readings are not proved. A model illustrates them, or is consistent with them.
- The opening paragraph, "those renewals … never give it": the witnesses show that the renewals do not suffice, not that they never come with widening. Write "do not by themselves give it".
- §7's proposal, D5 "confirmed in the form … and still not 生生不息": "not 生生不息" is D5's reading applied, not something the witness shows. Write "illustrated".
- §7, "any reading of lineage": name the interval of §4.

**R4 (low). §1 item 3 drops a hypothesis that (a) needs.**
- *Where:* §1 item 3, "along any reading contained in 'carry on, or pass support' nothing keeps opening".
- *What is wrong:* part (a) also needs carrying on of the supported. Take `R` = passings only, with a still supported formation `s`. Then `s` is linked from nothing, so `ExceedsAcross R S U` holds at every `S < U`, and the reading keeps opening (inclusion fails, so it still does not keep widening).
- *Fix:* §3.4 states the hypothesis correctly; copy it.

**R5 (low). §3.4 cites the wrong lemma, and its constructive route is already available.**
- *The lemma:* the hypotheses are "balances on the list and is dissipated on it from `T`", but `Dissipative.giving_needs_uptake` (`Dissipation.lean:314`) takes the global `Flow.Dissipative` and `Enclosed`. Under the stated hypotheses, cite `DissipatesOn.takes_of_gives` (`:282`), with every condition in the list.
- *The constructive route:*
  - `Amounts.rests_unrefuted` (`Amounts.lean:208`) concludes exactly `¬ ∀ N, T ≤ N → ¬¬ ∃ t, N ≤ t ∧ P t`.
  - Take `s` = the stock of the list, `ε = 1`, `P t` = "some present formation takes", and `m` = the stock at `T` plus one. Its premises follow from `BalancesOn.runs_down` and `DissipatesOn.replenishment_takers`, as `taking_not_recurring_from` uses them.
  - So "if its form fits" can read "it fits". GW3b's standing, "could fail in its constructive form", is too cautious.
- *Also:* the landed name is `Flow.Balances.taking_not_recurring`. §2's "in no course" should read "is not taken from at arbitrarily late steps".

**R6 (medium). The exclusion along `supportedPassing` has no lemma, and rule 9 asks for one below the landed three.**
- *Where:* §4 ("At the top … nothing opens (corollary 4)"; "So the landed laws are the cases at the ends"); §6 item 5, second case; §10 GW3 and GW4 (`.not_keepsWidening_supportedPassing`).
- *What is wrong:*
  - The landed `not_exceedsAcross_along_passings`, `not_keepsOpening_along_passings` and `not_keepsWidening_along_passings` take `passingContinuation ⊆ R`.
  - The new top of the interval is `supportedPassing`, and the plan uses the exclusion along readings that contain it. No landed or planned lemma states that.
  - By rule 9 the general three (hypothesis `supportedPassing ⊆ R`) land below, and the landed three are derived from them; they follow by `ExceedsAcross.anti`.
- *Also loose:* "the landed laws are the cases at the ends".
  - `itself_not_generation` is not a consequence of `supportedItself_not_generation`, since 全生成 is not monotone in the reading.
  - `ClosedCycle.generation_without_widening` is stated along the reading with dormant carrying on. Its 全生成 transfers to `supportedPassing` from supported points, because lines from supported points never take a dormant step, but that needs a line or a lemma.
- *Fix:* add the three general laws to GW3, derive the landed ones from them, and say how the two generation statements stand.

**R7 (low). One row of §13 is stale.**
- *Where:* §13, the F15 row, "`withinKind_cont_iff` holds at every occurrence".
- *What is wrong:* the revised §3.3 restricts it, correctly, to supported occurrences. With carrying on only while supported, the two continuations differ at inactive occurrences.
- *Fix:* make the row match §3.3.

**R8 (low). Registration and script comments.**
- *Registration:* GW4's new instance module must be added to `check_becoming.py`'s `CORE` list, where instance modules such as `Becoming.EventualWideningInstances` sit (line 82), and to its list of module descriptions, and it must be imported by `Becoming.lean`. The plan should say so.
- *Script comments:* `founding_check_period2.py` says "Period 4 in levels" while asserting period 2 (lines 46–48). It also describes the 生生 family as `{(4k, a0), (4k + 2, b0)}`, while the code uses every even step (lines 193 and 209). Both comments are stale.

## New material checked and found correct

- **§3.2.**
  - The law for `R` containing carrying on of the supported: carrying on is used only at a supported `g`, in the case where no supported formation `R`-continues into `g`.
  - The three kinds of passing (step, beginning, beside) are exhaustive up to double negation.
  - `BeginsAlong` is exactly a passing whose end begins a line of `continuationStep R` under activity.
  - `not_along` and `carries`.
  - Corollary 4: every passing is a step of `supportedPassing`, so there are no beginnings, and `Linked.mono` gives the landed statement.
  - Corollary 5: `BeginsAlong supportedItself` is `PassesSupport`. By name, `ExceedsAcross.anti` gives the same.
  - Corollary 3: on `KindRelay` along the reading with dormant carrying on, nothing is lost and beginnings occur at every even step, yet nothing keeps opening.
- **§3.3.**
  - `withinKind_cont_iff` at supported occurrences, with `Q` reflexive.
  - `withinKind_begins_iff` at active occurrences: both sides are refuted exactly by the formation being supported a step before.
  - `BeginsAlong.carries_kind_iff`, both directions. The converse uses `«生于粗则生于细»` from `K` to the carrier class, so the formation was not supported before, so the step is a passing, and a supported same-kind giver would refute `«生» P K`.
  - Nothing lost along the reading is `«不穷» P K`.
- **§3.4.**
  - (a): beginnings are passings, passings give, giving on the finite list needs taking, and taking does not recur.
  - (b): for `R` contained in passings, `carries_iff` makes every carrying renewal from an active occurrence a passing, and `generation_renews_late` makes renewals recur.
  - `KeepingWidening` already imports `Dissipation` and `Amounts`.
- **§6, `KindRelay`.**
  - Along `withinKind` with carrying on while supported: from an even `S`, `c` at `S + 1` is linked from nothing supported at `S`. From an odd `S`, `c` at `S + 2` is linked from nothing at all.
  - Along the reading with dormant carrying on: from an odd `S`, every occurrence at a later step is linked from something supported at `S` (`c` dormant to `c`; `a1`/`b1` through `a0`/`b0`).
  - Claims 2–4 and 7, with the family `{(2k, a0), (2k, b0)}`.
  - The premises as listed, period 2, and `not_listed` by name.
- **§6, `KindRelay.Fed`.**
  - Each fuel condition `t` falls once, by 2 or 4 across step `t`, and stays otherwise. So every condition balances.
  - Every family closed across step `t` must contain `fuel t`, since every present formation takes from it. On such a family each present formation takes its own units plus one and gives its own units: `a0` gives 2 and takes 3, `a1` gives 1 and takes 2. That is dissipation, hence the first law.
  - Fuel is required by no formation, so supports, passings and items 1–4 are unchanged.
  - The conditions are not listed, so `whole_not_keepsWidening` does not apply, while `not_listed` by name still does.
  - The six-condition family is not closed, which is the "not closed" disjunct of `new_beyond_every`. The fuel is spent, not added to the part's levels, as the note says.
- **§9.**
  - `«生» Steps.next E (n + 1)` holds exactly where `b` changes, by `Steps.hasPred_iff`.
  - 生成 at 0 is "changes at arbitrarily late steps", and 后守 at 0 is "constant from some step"; equality on `Bool` is decidable.
  - The coding: `b` changes at `n` exactly where no `k ≤ n` has `p k`, which is decidable by bounded search. 生成 then gives `∀ n, ¬ p n`, and 后守 gives `∃ n, p n`. The claim is "gives LPO", one way, which is right; the converse is not claimed, and it would not hold, since the cover on lines over `Nat` is a stronger dichotomy.
- **§5.** The equivalence holds, `Steps.reached_of_buqiong` serves at the one, and the record calls the law a restatement.
- **§10.**
  - Every module named is in `CORE`.
  - The imports are in place.
  - None of `KindRelay`, `supportedItself`, `supportedPassing`, `BeginsAlong`, `withinKind`, `kindClass` or `«生成后守之定则LPO»` exists yet. `Fed` exists only as a namespace in `SelectionPace`.
  - The records are right: law 9; does-not-show items 2 and 3 stay; item 1 gains the witness.
