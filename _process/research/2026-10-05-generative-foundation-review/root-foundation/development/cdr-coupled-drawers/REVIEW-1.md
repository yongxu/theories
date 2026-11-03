# CDR: two independent readings of the draft

AI-written (two Claude Opus readers, read-only, 3 November 2026), of the draft of board item CDR: `Becoming.CoupledDrawers` moved onto the core, its record, 05 §7's theorem, COLLECTIVE-DIRECTION's row, the Lean README's rows and the checker's scope text. Reader 1 checked every claim against the Lean statements; reader 2 checked coherence with the account and the literature. Every finding was taken; the draft's record id `drawers-coupled-for-each-step-keep-only-above-the-need` was replaced, its title being false at c = m. Paths and line numbers are the draft's.

## Reader 1: the Lean against the text

I found 19 problems in this slice: four that state more than the Lean proves, the rest dropped hypotheses, inexact names and zh drift. Every declaration the record names exists under its exact name, in `Becoming.Optimum.Coupled`, `…Coupled.AtOnce` and `…Coupled.AtOnce.Shores`. The gate laws sit in `section Gate` inside `Coupled`, so the names are right. The count of 72 declarations, 57 of them theorems, matches the file (15 defs). The claim that the renewal forgone a step is nothing on the gated renewal checks against `Optimum.frontier_keeps_stepwise`'s `r - q`, which is `q - q` there. Nothing was built or run; this is a reading against the Lean source.

Paths: R = `/Users/ren/tmp/prefreeze-fix/wt-cdr/theories/becoming/results/records/drawers-coupled-for-each-step-keep-only-above-the-need.json`, CD = `/Users/ren/tmp/prefreeze-fix/wt-cdr/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/CoupledDrawers.lean`.

## Claims the Lean does not prove

**1. R:13 (statement en), and zh line 14 the same**
- Words at fault: "drawing at once with no drawer able to meet the need alone, they drain at every coupling."
- Why it is wrong: `AtOnce.unpivotal_drain_perfect` (CD:848–851) has two premises, `small` and `returns` (`portion d (t+1) (G t b) ≤ portion d (t+1) (G t 0) + b`). The statement drops `returns`. The theorem also only proves that the drain *is perfect*; it does not prove that the drawers drain. R:111 itself says the record does not show that the drain is the only perfect profile.
- Proposed: "drawing at once, where no drawer's portion reaches the need and none returns more than one for one on what its drawer alone leaves, drawing everything is perfect at every coupling." zh to match.

**2. CD:47–48 (module docstring)**
- Words at fault: "two shores each reaching `p < m`, together reaching `p + p`, keep nothing at any coupling rate."
- Why it is wrong: `Shores.drain_perfect` (CD:1021–1024) proves the drain is perfect and the need is unmet under it. It does not prove that every perfect profile keeps nothing. It also needs `G = fun _ x => x`, and the docstring drops that.
- Proposed: "with the level left as it is, two shores each reaching `p < m`, together reaching `p + p`, have the drain perfect at every coupling rate, the need met at no step."

**3. R:130 (counterexample en/zh)**
- Words at fault: "every coupling below the need drains it at once" and "two shores together reaching the need drain at every coupling."
- Why it is wrong:
  - The first clause drops "two drawers or more in turn, no floor". `drains_below` needs `two : 1 < k` (CD:363). With one drawer, `one_keeps_first` (CD:657–659) shows keeping below the need.
  - The second clause has the same overclaim as item 2, and the identity `G` is dropped.
- Proposed: "on the gated renewal the renewal forgone a step is nothing, and with two drawers or more in turn and no floor every coupling below the need leaves every perfect profile draining at every step; drawing at once, with the level left as it is, two shores together reaching the need have the drain perfect at every coupling."

**4. "The last drawer … draws nothing later whatever it leaves"**
- Where: 05-COLLECTIVES.md:196, CD:25–26 and R:152 (correspondence).
- Why it is wrong: this is proved only where every drawer follows the drain or `keep m` at every later step. See `drawn_drained` (CD:303–305) and `drawn_kept_late` (CD:437–439), both with an `AllFollow` hypothesis. In general the last drawer is passed what earlier drawers leave and can draw it.
- Proposed: "where every later step drains or keeps the need, the last drawer of a step decides whether the need is met and draws nothing later whatever it leaves."

## Hypotheses dropped

**5. README.md:205 and README.zh.md:203**
- Words at fault: "at every `c` without a pivotal drawer (`…unpivotal_drain_perfect`)" and zh 「无关键抽取者时于每个 `c` 皆然」.
- Why it is wrong: both drop `returns` (CD:849–850). The Becoming.lean bullet and the check_becoming.py scope keep it.
- Proposed: "at every `c` where no portion reaches the need and none returns more than one for one", and the zh 「凡无一份达到需要、且无一份回报多于一对一时，于每个 `c` 皆然」.

**6. `perfect_uncoupled` covers drawers in turn only**
- Where: CD:19–20, "With `c = 0` the coupled notion is the existing one", which follows a description of both arrangements; and R:170–171 (dependency), "with c = 0 they are the same notion (perfect_uncoupled)", where "they" means in turn and at once.
- Why it is wrong: `perfect_uncoupled` (CD:136–137) is stated for `InTurn.Perfect` only. No at-once counterpart exists.
- Proposed: "With `c = 0` the coupled notion in turn is `InTurn.Perfect` (`perfect_uncoupled`)."

**7. R:84–85 (law 8 en/zh)**
- Words at fault: "two shores each reaching p < m, together reaching p + p, are such a case."
- Why it is wrong: `Shores.drain_perfect` fixes `G = fun _ x => x` (CD:1022). The third clause is about a level of `p + p` (CD:1024).
- Proposed: "two shores each reaching p < m, together reaching p + p, with the level left as it is, are such a case, the need met at no step, though both leaving all they reach of p + p leave p + p."

**8. R:47 (law 4) and CD:631**
- Words at fault: "what stands next from the need meets it."
- Why it is wrong: `kept_levels` takes `holds : ∀ t x, m ≤ x → m ≤ G t x` (CD:429, `include holds`). That is every level at or above the need, not the need alone. The proof uses only `x = m`, but the statement as written requires all of `holds`.
- Proposed: "at or above the need what stands next meets it."

**9. CD:630 (kept_levels docstring)**
- Words at fault: "Where at least one drawer follows `keep m`."
- Why it is wrong: the hypothesis is `AllFollow rules k (keep m) t`, so every drawer follows it, together with `one : 0 < k` (CD:634–635).
- Proposed: "Where there is at least one drawer and every drawer follows `keep m`."

**10. Positive need missing on the keeping side**
- Where: CD:27–35 and 40–48, Becoming.lean bullet ("a need `m`"), README.md:205 / README.zh.md:203, and the check_becoming.py scope.
- Why it is wrong: `kept_above`, `keeping_perfect`, `gated_threshold` and `drain_perfect_iff` all take `pos : 0 < m` (CD:578, 599, 769, 890). On the keeping side `m < c` does not imply it.
- Proposed: say "a positive need `m`" in the first sentence of each.

**11. R:38 (law 3 en/zh) and 05-COLLECTIVES.md:196**
- Words at fault: "Under the gate (…), where m < c every perfect profile …", opening a new sentence.
- Why it is wrong: it drops "two drawers or more in turn, no floor". `kept_above` needs `two : 1 < k` and low `fun _ _ _ => 0` (CD:578–579). The case `k = 1` is not covered.
- Proposed: "Under the gate (…), with two drawers or more in turn and no floor, where m < c …"

**12. "One drawer keeps over two steps where several in turn drain"**
- Where: Becoming.lean bullet, check_becoming.py scope and README rows.
- Why it is wrong: it drops the gated renewal, `c < m` and `0 < c + q` (CD:687). The one drawer also does not keep over both steps: it keeps at the first, and draws everything at the last (`rules 0 1 a = 0`, CD:659).
- Proposed: "on the gated renewal, where `c < m` and `0 < c + q`, one drawer keeps the need at the first of two steps where several in turn drain."

**13. CD:37–38**
- Words at fault: "leaves at least the need at the first step."
- Why it is wrong: the theorem says this only of an amount at least the need (`∀ a, m ≤ a →`, CD:659, 689).
- Proposed: "leaves at least the need of an amount at least the need at the first step."

## Names, zh and softer points

14. **COLLECTIVE-DIRECTION.md:51.** The row cites `Coupled.drains_below`, `Coupled.kept_above`, `Coupled.kept_levels` and `Coupled.AtOnce.unpivotal_drain_perfect`. The exact names are `Optimum.Coupled.…`; the same row writes `Optimum.frontier_keeps_stepwise` in full. Proposed: add the `Optimum.` prefix to all four.

15. **R:48 (zh law 4).** 「水平在视野之前每步都满足它」 means "before the horizon", but the en says "to the horizon", and the Lean has `t ≤ N` (CD:636). Proposed: 「直至视野每步都满足它」.

16. **R:14 (zh statement).** 「轮流抽取时，在门之下，每步耦合高于需要则留住需要，低于需要则…耗尽，不论更新」 puts the gate over the drain clause too, which clashes with 「不论更新」. In the en the gate qualifies keeping only. Proposed: 「轮流抽取时，每步耦合低于需要则在视野之前每步耗尽，不论更新；在门之下，高于需要则留住需要」.

17. **README.zh.md:203.** 「抽尽完美恰当无一抽取者留下所得多于其所留」 drops the en's "alone", and the Lean compares against the others draining (CD:886). Proposed: 「…恰当其他抽取者皆抽尽时，无一抽取者独自留下所得多于其所留」.

18. **R:111 (does_not_show 2).** "where several drawers can each meet the need and free riding admits many" asserts a multiplicity nothing proves. Proposed: "where several drawers can each meet the need, where free riding may admit many."

19. **05-COLLECTIVES.md:196, plus R:152 and R:106.** Four softer points:
    - "the renewal forgone a step is nothing, so the threshold is the need itself": the "so" reads as cause, but the threshold comes from `drains_below` and `kept_above`, not from the forgone renewal being zero. Proposed: "yet".
    - "several optimizers drain as one would … is a law of one step that does not extend": that law is in a different model (one step, capacities). What is shown inside this model is only the in-turn contrast. Proposed: "its analogue for drawers in turn fails with a coupling for each step over a horizon."
    - R:152: "an iff with witnesses on both sides for every renewal law below the need" describes no in-turn theorem; the only iffs are at once (`drain_perfect_iff`, `drain_perfect_iff_reach`). Proposed: "witnesses on both sides of the need for every renewal law (drain) and under the gate (keeping), and an iff drawing at once."
    - R:106: "without the gate, where a level below the need can regrow past it" names only one of the gate's three parts. Proposed: add "or one meeting it can fall below it, or what stands next from nothing with the need exceeds what stands next from the need."

The Becoming.lean bullet's own conditions for the in-turn laws (two or more, no floor, `c < m` / `m < c`, the gate) and for `drain_perfect_iff` match the Lean, apart from items 10 and 12. "A leaf" is right: only Becoming.lean imports the module.

## Reader 2: coherence and literature

I found eight problems, listed most serious first. None is fatal, but findings 1–4 would mislead a reader. Several things are fine as they stand:

- **No stale study wording.** No text in `theories/becoming`, README.md, ONE-PAGE.md, ONE-ARGUMENT.md, 08-METHOD.md, review/SCIENCES.md or review/ALIGNMENT.md still says these laws are only in a study or not landed. The one place that did, COLLECTIVE-DIRECTION.md:51, is fixed by the diff.
- **No carry-over to several optimizers.** No text carries `frontier_keeps_stepwise` over to several optimizers. COLLECTIVE-DIRECTION:51 keeps "It is one optimizer's law, not a collective exit as it stands."
- **Theorem matches the Lean, no duplication.** Apart from finding 1, the new 05 §7 theorem matches the Lean. It does not duplicate the drawers-in-turn theorem: the uncoupled case comes in only through `perfect_uncoupled`.
- **Renames change no statement.** I diffed the scratch tree against the landed module. Only the renames and the docstring wording changed.

**1. The mutual_as_one contrast goes further than the Lean** (05-COLLECTIVES.md:196, with the same reading in the record's `related[1]` at json:201 and its correspondence at json:152)
- **Words at fault:** "so that several optimizers drain as one would ([the cases]) is a law of one step that does not extend to a coupling for each step over a horizon."
- **It crosses models without saying so.** `one_keeps_several_drain` (CoupledDrawers.lean:687) compares k=1 with k≥2 drawers in turn, over two steps, on `gatedRenewal`. It says nothing about `MutualBest` on the World, where `mutual_as_one` lives. Round 3 §3 flags exactly this kind of model-crossing, and the record's own `does_not_show[2]` concedes it. The chapter sentence drops it.
- **The coupling is not the cause.** The hypothesis `0 < c + q` (line 657) admits c = 0 with q > 0. There one drawer keeps from the renewal alone, while several drain by `drains_below`, as already without a coupling by `InTurn.perfect_at_floors`. So the split comes from drawers ranking the steps that remain, not from the coupling.
- **"A law of one step" is too narrow.** The same law already extends over courses that re-optimize at each step (`Optimum.mutual_course_beyond`, `Web.mutual_course_lost`; 05:208, row r-re-optimizing-above-a-renewal-ends-it).
- **Proposed:** "There, where `c < m` and `0 < c + q`, one drawer over two steps keeps the need at the first step where two drawers or more in turn drain it (`Optimum.Coupled.one_keeps_several_drain`), with no coupling at all where `0 < q`. Among drawers ranking the steps that remain, several in turn do not draw as one drawer would. That several optimizers drain as one of their joint capacity would ([the cases](#r-several-optimizers-drain-by-their-joint-capacity)) is shown for one step and for courses re-optimizing at each step, in another model; this contrast is inside drawers in turn."

**2. `related[1]` says the reverse of the Lean** (record json:201)
- **Words at fault:** "with a coupling for each step over a horizon, in turn, they do not drain as one drawer would"
- **Why:** it reads as if one drawer drains and the several do not. The Lean says the several drain (`drains_below`, :363) and one drawer keeps (`one_keeps_first`, :657).
- **Proposed:** "Several optimizers drain one step as one would with their joint capacity. Among drawers in turn on a gated renewal, two or more drain where one drawer keeps (`one_keeps_several_drain`), even with no coupling where `0 < q`. That contrast is inside drawers in turn, not inside the model of mutual best responses."

**3. "They drain" claims more than the Lean proves** (record `statement.en` json:13 and its zh; `counterexamples[0].detail` json:130)
- **Words at fault:** "drawing at once with no drawer able to meet the need alone, they drain at every coupling" and "two shores together reaching the need drain at every coupling"
- **Why:** `unpivotal_drain_perfect` (:848) and `Shores.drain_perfect` (:1021) prove only that drawing everything is a perfect profile. They do not prove it is the only one, which the record's own `does_not_show[1]` concedes. The statement also drops the premise that no portion returns more than one for one.
- **Proposed (statement):** "…drawing at once, where no drawer can meet the need alone and no portion returns more than one for one, drawing everything is perfect at every coupling."
- **Proposed (counterexample):** "…drawing at once, for two shores together reaching the need, drawing everything is perfect at every coupling and the need is met at no step."

**4. The title fails at c = m** (record title json:5 and its zh "高于"; the id and the anchor `r-drawers-coupled-for-each-step-keep-only-above-the-need`)
- **Words at fault:** "Drawers coupled for each step keep a need only above it"
- **Why:** at c = m, keeping is perfect (`keeping_perfect`, :599, needs only m ≤ c; the `gated_threshold` docstring says "At c = m both are perfect"). What `drains_below` makes necessary is c ≥ m. The title is right only if "keep" means "every perfect profile keeps", and only in turn: at once, keeping is not characterized at all.
- **Proposed:** "Several drawers in turn, coupled for each step, keep a need only where the coupling reaches it" (zh: 不低于需要时). The id and anchor would follow. They are not landed yet, so renaming is cheap.

**5. The c = 0 equivalence is claimed for both arrangements** (record `dependencies[0].detail.en` json:170; module docstring CoupledDrawers.lean:19–20)
- **Words at fault:** "drawers in turn and at once … with c = 0 they are the same notion (perfect_uncoupled)"
- **Why:** `perfect_uncoupled` (:136) is stated only for `InTurn.Perfect`. The `AtOnce` namespace has no analogue.
- **Proposed:** "with c = 0 the coupled notion of drawers in turn is the existing one (perfect_uncoupled); at once, the coupled notion is defined alike, but no equivalence is proved."

**6. The literature correspondence drops reading depth and grading** (record `correspondence.en` json:152)
- **Reading depth is lost.** Round 3 §5/§7 says:
  - Palfrey–Rosenthal's point was "taken from prior knowledge, not re-read".
  - Admati–Perry and Selten 1978 are prior knowledge.
  - The full texts of Erev–Rapoport, Admati–Perry and Diekert were not read (Diekert's PDF did not extract).
  - Bagnoli–Lipman was read only as a record link.
- **Grading is lost.** The note grades them separately: "a specialization", "a specialization in kind", "different model, same mechanism". The record merges them.
- **Bagnoli–Lipman may be misdescribed** (my prior knowledge, plausible only). Its main game is, I believe, a simultaneous provision-point game, so "sequential step-level provision, where the last mover is pivotal" may not describe it. The note gives no description to support that wording.
- **"An iff" overstates the in-turn threshold.** The record says "an iff with witnesses on both sides for every renewal law below the need". In turn it is not an iff: c = m is a tie, and the keeping side needs the gate. The iff is `AtOnce.drain_perfect_iff`.
- **Proposed:** mark each source, e.g. "(Palfrey and Rosenthal 1984, from prior knowledge, not re-read; a specialization)", "(Erev and Rapoport 1990, abstract; Bagnoli and Lipman 1989, record only; Admati and Perry 1991, prior knowledge; a specialization in kind)", "(Barrett 2013; Diekert 2017, abstracts: a different model, the same mechanism)". Then replace the exact-form clause with: "The exact form is the account's: in turn, the drain for every renewal law where c < m and keeping under the gate where m < c, with witnesses on both sides; at once, the iff for the drain; and the contrast inside drawers in turn between one drawer and several."

**7. Older texts the new result now qualifies** (lower)
- **several-optimizers-drain-by-their-joint-capacity.json:122 (md:56), correspondence reading.** "what keeps it is a coupling into it or a lowered capacity" is now qualified by CDR. Among drawers in turn, a coupling for each step met keeps the need only where it reaches the need. Drawing at once, with no pivotal drawer, the drain stays perfect at every coupling. Proposed: append "; over a horizon a coupling for each step met keeps it, among drawers in turn, only where it reaches the need, and drawing at once without a pivotal drawer the drain stays perfect at every rate ([drawers-coupled-…])".
- **a-step-coupling-keeps-at-every-horizon `does_not_show`/`next_delta` "several optimizers ranking courses"** could point to the new record for the in-turn and at-once case.
- **05:427 and 08-METHOD.md:731 still list "several optimizers ranking whole courses" / "drawers ranking courses" as open.** This predates the change and stays true for general rising orders, but could note the CDR case.

**8. Small wording and names** (lowest)
- **Record `related[0]` json:194, "several drawers in turn need the coupling to exceed the need itself":** the necessary condition is c ≥ m (`drains_below`), and c > m is sufficient for every perfect profile to keep only under the gate. Proposed: "for every perfect profile to keep it, several drawers in turn need, under the gate, a coupling above the need itself; below it they drain whatever the renewal."
- **Record `laws[4]` json:54, "the four laws hold together":** this is ambiguous against the record's own numbering of laws. Proposed: "the drain and keeping laws above hold together".
- **`stepCoupling` is apt.** It states the structure exactly, `c` where what is left meets `m`, else 0, and it matches "a step coupling" in a-step-coupling-keeps-at-every-horizon.
- **`worthKeeping` is acceptable but states a verdict rather than the structure** (0 < c + q: keeping adds the coupling and the renewal drawn later). It fits the module's "worth" vocabulary; a more structural name would be `keepingGains`.
- **An exchange word survives the rename:** the local `have cost` at CoupledDrawers.lean:947. Proposed: `coupledAtMost` or `metWithin`.
- **COLLECTIVE-DIRECTION.md:51 writes short names (`Coupled.drains_below`, `Coupled.kept_above`, `Coupled.AtOnce.unpivotal_drain_perfect`).** 02-MAP already uses `Coupled.Indexed.*` for `RegimeMargin.Coupled`, so these read ambiguously. Use `Optimum.Coupled.…`, as 05 does.
