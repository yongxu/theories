# GW: generation and widening, joined or kept apart (study note; the Lean of GW3–GW5 in §15, of GW1, GW2 and GW6 in §18)

AI-written, 29 October 2026, for board item GW, and revised the same day after the [independent review](REVIEW-GW.md). §13 says how each finding was taken. §15 records the Lean of GW3, GW3b, GW4 and GW5, built the same day; §§1–14 are the study as reviewed, and the marks **[planned Lean]** in them refer to the plan of §10, which §15 says how the Lean met. §18 records the Lean of GW1, GW2 and GW6, built on 30 October, with GW6 added at the claim, and §19 its review.

The [twenty-first review](../../BECOMING-TWENTY-FIRST-REVIEW.md) (§2.3 item 3, §2.5, §7) names this the most consequential open link. No law joins the map's generation (生成, `Becoming.GrammarMap`) to the ethics' widening (07 §2), and on the two readings studied, 全生成 and keeping widening do not hold together.

This note is a study and builds no Lean. Statements about landed Lean were read from the source on main at `f8ad3de80`; the reviewer re-read them at `01cad0d12`, where no Lean file had changed. Statements marked **[planned Lean]** form the plan of §10, and none is a result until it is proved and checked. The witnesses of §6 were checked by brute force over a finite horizon: [`founding_check.py`](founding_check.py) for the first design, [`founding_check_period2.py`](founding_check_period2.py) for the one the plan adopts, each with its `.out`. Those checks support the design and replace no proof.

Marks:
- **[AI reading]** is an interpretation by the AI, not a theorem.
- **[argued]** is a hand argument.
- **[hand check]** is a finite enumeration, by hand or by the script.

Purpose (board, "Purpose first"): the step argued where the theory bears on it, here the direction of 生生.

## 1. The verdict

The link exists. On readings of formations it runs one way; read on a course's moments, keeping widening is generation under the one that loses nothing, both ways under premises of deciding (item 7, §18). The negative results stay, and they become the formal content of a distinction the account already draws: generation (生成) is not 生生 (D65 item 4, 01 §6). 生生, as D1 reads it, includes changing what can form. The law of this note says that keeping what can form widening always rides on the map's renewals one grain up, and that those renewals, even generation at two orders, do not by themselves give it.

1. **The law, one way** [Lean, §15].
   - **The World.** Along any reading of the World containing carrying on of the supported, keeping opening needs, up to double negation, a *beginning* after every step: a passing of support that the reading leaves out, into a formation that the reading continues from nothing supported (§3). Each beginning is a carrying renewal (传) along "carry on, or pass support". Where the reading is "within a kind", it is a carrying renewal of the whole at the grain of kinds, the map's order-1 event (§3.3). So keeping widening needs the map's events one grain up to recur. It does not need the map's regions: the law places no renewal ahead of every point of one line.
   - **By name.** The same law says that keeping widening by name needs passings of support at arbitrarily late steps (§3.2, corollary 5).
   - **The held possible.** Where holding is decided, keeping widening gives 全生成 of the course at the pair (the one, what is held). This is `Run.begins_of_heldKeepsWidening` read on the map (§5).
   - **Not conversely.** Generation at two orders, together with renewal without end, can hold while what can form only returns, with period 2, and keeps widening by name from no step (§6).
2. **The two negative results are the two ends of the law** (§4).
   - Along all passings, nothing is left out to begin a line of the reading, so nothing opens (`Flow.not_keepsWidening_along_passings`).
   - By name, no step of the reading crosses formations, so nothing is 全生成 (`Web.itself_not_generation`).
   - `Flow.whole_not_keepsWidening` is not an end of the interval. It is the gain bridge on what can form by name, and on that it is central.
3. **Under dissipation, a finite closed world has neither** [Lean, §15]. 01's dissipation premise stops taking from recurring in a finite closed family (`Balances.taking_not_recurring`). Passings need giving, and giving needs taking, so passings do not recur either. Then, under the four premises of the descent law, along any reading containing carrying on of the supported nothing keeps opening, and, with balance on the list alone, along any reading contained in "carry on, or pass support" no supported line is 全生成. The Lean takes a weaker premise than a finite closed world: a list holding every condition any formation requires, dissipated on from some step. Where a finite family holding what is required is dissipated on, neither holds; both need what lies beyond such a family (corrected after the re-check, §17).
4. **A reading on which 全生成 and keeping widening hold together** [Lean, §15]: passings within a kind continue, passings across kinds begin, and carrying on counts only while supported (§6). Two witnesses carry it.
   - `KindRelay` is a closed conserving world. It meets the four premises of the descent law and the first law, and it is not dissipative.
   - `KindRelay.Fed` is dissipative, its loss paid by fuel each formation draws on and none requires; no list holds its conditions, and the six conditions its formations require conserve, so what is required is not dissipated on (corrected after the Lean review, §16).

   On both:
   - the range keeps widening along that reading;
   - every supported occurrence is 全生成 at two orders: lineages through their parts, and the whole through begun lineages;
   - renewal without end (生生 of the grammar) holds at the grain of kinds;
   - the part's levels and supports return with period 2.

   They do not keep widening:
   - by name;
   - along all passings;
   - within a kind with dormant carrying on by name, which is the first design's reading, and there its widening came only from alternating names (§6).

   The held-possible witness `HeldPossible.RaisedEveryOther` holds together the map's 全生成 (planned) and `Reaching.KeepsWidening` of the held possible, a different notion of widening.
5. **What it says about 生生** [AI reading, §7].
   - **What the witness shows.** On those witnesses the map's generation goes on at two orders, and so do the grammar's 生生 at the kind grain and keeping widening along the lineage reading. All the while, what the part can form (D3: the formations whose requirements its levels meet) only returns, with period 2, and by name over its formations nothing keeps widening. With D5's exclusion of return ("not a return into copies of existing forms") as the premise, that is the treatise's "普通生成改变接下来的状态" without "生生还改变接下来能够形成哪些状态".
   - **What it illustrates.** D65 item 4 ("[生成] is not 生生"), 01 §6 ("That asks more than renewal of lines") and the first does-not-show item of the two-grains record. The witness is a model consistent with them, with generation at two orders, not one.
   - **Proposal.** Nothing in the reading of 生生 is redrawn. 01 §6, 02 §1 and D1 gain the law and the witness: wherever what can form keeps widening, the map's renewals one grain up carry it, and those renewals do not give it.
6. **The map's three regions do not partition** [Lean, §18].
   - 生成 and 守 overlap where lines branch, by design (`Map.«生守相杂»`).
   - The line that renews once and then stays still lies in none of 生成, 守, 退化 at its start.
   - Keeping read as keeping from some point on (`«后守»`, the some-branch form of 全守) closes the gap. With excluded middle, every point lies in 生成, 后守 or 退化, and on a single line the three partition.
   - Telling 生成 from 后守 on a single line gives LPO. Deciding 后守 alone already gives LPO, and deciding 生成 gives only WLPO: to tell whether a line keeps from some point on is to decide whether it stops renewing (§18).
7. **Read on a course's moments, both ways** [Lean, §18]. Take what is held at each moment as a chain of predicates, with nothing lost in the coarse place and the same possible in the fine. Then keeping widening is 全生成, both ways, under two premises of deciding.
   - Nothing lost is keeping widening's own inclusion half, so that iff is a representation.
   - With both classes fixed apart, keeping widening is generation under (the one, the same possible) that loses nothing, and what parts the two is exactly loss (`Steps.Moving`).
   - The premises are exactly weak excluded middle forward and excluded middle back. Generation is known by refutation, widening by exhibition.

## 2. What the landed results say

| Result | What it states exactly | Where |
|---|---|---|
| `«传»` | `«续» R L x y ∧ «生» R E y`: the pattern continues into `y`, and a line under the fine class begins at `y` | `Becoming.GrammarMap` |
| `Web.carries_iff` | from an active `x`, a carrying renewal along `R` (activity coarse, one formation fine) is a step of `R` into an active occurrence whose formation was not active and `R`-continued as itself at `x`'s step | `Becoming.MapInstances` |
| `Flow.passesSupport_carries_iff` | along "carry on, or pass support", a carrying renewal from a supported occurrence is exactly a passing of support | `Becoming.KeepingWidening` |
| `Web.ExceedsAcross R l S U` | some `g` admitted at `U` such that every `f` linked along `R` from step `S` to `(U, g)` is not admitted at `S`; `Linked` asks nothing of activity | `Becoming.ContinuedClasses` |
| `Web.KeepsWidening R l T` | nothing admitted is lost along `R` from `T` (`IncludesAcrossFrom`), and after every step something opens (`KeepsOpening`) | `Becoming.EventualWidening` |
| `Web.KeepsWidening.not_listed` | over a listed type of formations, no range read by name keeps widening | same |
| `Web.includesAcrossFrom_iff_endless` | nothing lost along a continuation is the admitted pattern's line never ending from every admitted occurrence | `Becoming.KeepingWidening` |
| `Flow.descends_along_passings` | under balance, only active giving, activity needing support and requirements never loosening, whatever is supported at `S + k` is, up to double negation, linked along "carry on, or pass support" to something supported at `S` | same |
| `Flow.not_keepsWidening_along_passings` | so along every continuation containing it nothing keeps widening | same |
| `Flow.whole_not_keepsWidening` | in a finite balanced world under the first law, nothing keeps widening by name, with requirements fixed within the finite family | same |
| `Web.itself_not_generation` | by name (continuation `itself`), nothing is 全生成 | `Becoming.MapInstances` |
| `Flow.Balances.taking_not_recurring` | balanced, and dissipated on from some step, a family is not taken from at arbitrarily late steps | `Becoming.Dissipation` |
| `Run.begins_of_heldKeepsWidening` | where holding is decided and the held possible keeps widening, a line under the held class begins after every moment | `Becoming.HeldPossible` |
| `HeldPossible.RaisedEveryOther.both` | the held possible keeps widening (`Reaching.KeepsWidening`), every formation is possible throughout, and `«生生»` holds at moment 0 under the held class | same |
| `HeldPossible.Oscillating.converse_fails` | the rule changes at every step and the whole possible is unlisted, yet the held possible does not keep widening | same |
| `CausalGrowth.no_order_contains_both` | no strict order contains both widening what can be born next and widening what continues | `Becoming.CausalGrowth` |

UE7's note already saw the shape: "A reading on which the two hold together would have to leave out some step of 'carry on, or pass support' … none is constructed" ([UE7 §2.5](../ue7-what-keeps-widening/NOTE.md)). This note says which steps, what they are, and builds one.

## 3. Arrivals along one reading

### 3.1 On the root

The skeleton holds for every relation `R` and classes `L`, `E` [planned Lean, GW2; near-definitional].
- **A carrying renewal begins no line of the pattern**: `«传» R L E x y → ¬ «生» R L y`, since `«续» R L x y` is a predecessor under `L`.
- **A beginning of a part is a beginning of the pattern or the end of a carrying renewal**, as far as can be refuted: `«生» R E y → ¬ ¬ («生» R L y ∨ ∃ x, «传» R L E x y)`. The proof is excluded middle on `«有前» R L y` inside the double negation. It needs no order between `E` and `L`.

`«生于粗则生于细»` (landed) adds that, where `E` is finer than `L`, a beginning of the pattern is a beginning of its parts.

### 3.2 On the World

Fix a web `W` and a flow `L` meeting the four premises `descends_along_passings` uses: balance, only active giving, activity needing support, and requirements never loosening. Admission is read on the actual levels. Let `R : Nat → F → F → Prop` be a continuation containing carrying on of the supported: `∀ t f, W.Supported t f → R t f f`.

A passing of support from `g` into `h` across the step from `t` is one of three kinds:
- a step of `R`;
- a *beginning* along `R`: not a step of `R`, and nothing supported at `t` continues into `h` along `R`;
- a passing *beside* `R`: not a step of `R`, while some other supported formation continues into `h` along `R`.

Only beginnings start a line of the reading. A beginning opens (`ExceedsAcross`) only where it is fresh, that is, where nothing supported at the earlier step is linked along `R` to it (corollary 3).

**Definition** [planned Lean]. `Flow.BeginsAlong L W R t g h := L.PassesSupport W t g h ∧ ∀ f, R t f h → ¬ W.Supported t f`.

The name reads «生»: the passing begins a line of `R` at `(t + 1, h)` under activity. It is not the founding of `Becoming.Founding`, which there means wholes founded by parts of earlier wholes.

Two facts follow:
- `g` is supported, so the passing is not a step of `R` (`BeginsAlong.not_along`).
- `h` arises across the step by `PassesSupport` itself, so a beginning is a carrying renewal along "carry on, or pass support" at (activity, one formation). This is exactly `Flow.passesSupport_carries_iff` (`BeginsAlong.carries`).

**Law** [argued; planned Lean, GW3: `Flow.descends_or_begun`]. Take `S`, `k` and `g` supported at `S + k`. Up to double negation, either:
- some `f` supported at `S` is linked along `R` to `(S + k, g)`; or
- for some `j < k`, a beginning along `R` across the step from `S + j` into some `h` has `(S + j + 1, h)` linked along `R` to `(S + k, g)`.

*Proof* [argued; checked by the reviewer]. Induction on `k`, as in `descends_along_passings`. At `k + 1`, inside the double negation, decide whether some `f` supported at `S + k` has `R (S + k) f g`.
- If one does, apply the induction at `f` and extend the chain by that step (`Web.Linked.snoc`).
- If none does, then `g` is not supported at `S + k`, since carrying on of the supported is in `R`. So `g` gains support. `Flow.gain_given_by_supported_at` (with `Balances.on` and `Acting.giversSupported`) gives, up to double negation, a supported formation passing support to `g`. That passing is a beginning at `j = k`, closed with `Linked.here`.

The proof takes one double negation, with excluded middle inside it, as the landed law does. Carrying on is used only at a supported `g`, which is why carrying on of the supported is enough.

**Corollaries** [argued; planned Lean].
1. `Flow.begun_of_exceedsAcross`: where the levels exceed along `R` from `S` to `U` at `g`, the first case is refuted. So, up to double negation, a beginning along `R` lies across a step from `S` to before `U`, linked along `R` to `(U, g)`.
2. `Flow.begins_late_of_keepsOpening`: where the levels keep opening along `R` from `T`, a beginning along `R` lies after every step from `T` on, up to double negation.
3. Freshness is needed for the converse. A beginning into `h` across the step from `j` opens from `S` only where nothing supported at `S` is linked along `R` to `(j + 1, h)`. So keeping widening needs, besides nothing lost, beginnings after every step, and it is not the same as those two (§6, the reading with dormant carrying on).
4. `Flow.descends_along_passings`, re-proved (board rule 9). Take the continuation "carry on while supported, or pass support" (`Web.supportedPassing`). Every passing is a step of it, so it has no beginning, and the second case is empty. Since `Linked` is monotone in the continuation, the landed law at "carry on, or pass support" follows with its statement unchanged, and `ExceedsAcross.anti` still carries it to every continuation containing passings.
5. Along "carry on while supported" (`Web.supportedItself`), a beginning is a passing of support. So keeping opening there, and so keeping widening by name, which reads more links, needs passings of support at arbitrarily late steps, up to double negation. That is the map's carrying renewals along lineage.

### 3.3 One grain up

Let `Q : F → F → Prop` be a reflexive relation on formations (a *kind*; a class in the witness). Two definitions [planned Lean]:
- `Web.withinKind W Q passes t g f := (g = f ∧ W.Supported t g) ∨ (passes t g f ∧ Q g f)`;
- `Web.kindClass V Q := «合» V.activityClass (fun x y => Q x.2 y.2)`.

Write `P` for the continuation step of "carry on, or pass support", `A` for activity, `K` for `kindClass Q`, and `C` for the carrier class. Three laws relate the reading to the classes [argued; planned Lean]:
- `Web.withinKind_cont_iff`: from every supported occurrence, continuing along `withinKind Q` under activity is continuing along `P` under `K`. This is read on the web through its levels (`Web.admitting`), where active is supported; reflexivity of `Q` is used for carrying on. At an inactive occurrence the two differ, since `P` carries a dormant formation on and `withinKind Q` does not. [hand check, by the script, from supported points.]
- `Web.withinKind_begins_iff`: at an active occurrence, a beginning under `C` along `withinKind Q` is a beginning under `C` along `P`, since both are refuted only by carrying on as itself from an active occurrence. 全生成 reads beginnings only at the ends of steps from active occurrences, so this is all it needs.
- `BeginsAlong.carries_kind_iff`: from a supported giver, a beginning along `withinKind Q` is exactly `«传» P A K`, the whole lineage going on while a line of a kind begins.

So, with `Es 0 = C`, `Es 1 = K` and `Es 2 = A`:
- 全生成 along `withinKind Q` at (activity, one formation) is `«阶全生成» P Es 0` [argued in general; on the relay both are Lean, §15, and their identity is not];
- the beginnings are the order-1 carrying renewals `«传» P (Es 2) (Es 1)`;
- nothing lost along `withinKind Q` is `«不穷» P K` from every supported occurrence (`includesAcrossFrom_iff_endless`).

Keeping widening along the kind reading **needs** nothing lost at `Es 1` and order-1 renewals after every step, and with freshness the two are enough.

### 3.4 Under dissipation

[argued, first by the reviewer; planned Lean, GW3b]. Add dissipation and a finite world: every condition is in a list without repetition, and the flow balances on it and is dissipated on it from `T` on. Then, for every continuation `R` containing carrying on of the supported and contained in "carry on, or pass support":
- **(a)** nothing keeps opening along `R`, so nothing keeps widening;
- **(b)** no supported occurrence is 全生成 along `R` at (activity, one formation).

*Argument.*
- Every passing gives, and on a family dissipated on, with every condition in it, giving needs taking (`DissipatesOn.takes_of_gives`).
- Taking does not recur on the finite family (`Flow.Balances.taking_not_recurring`), so passings do not recur.
- For (a): beginnings are passings, and by corollary 2 they recur.
- For (b): along a reading contained in passings, a carrying renewal into a formation that did not carry on is a passing (`Web.carries_iff`), and 全生成 has renewals beyond every step (`Web.generation_renews_late`).

Constructively, corollary 2 gives "for every `N`, not not some beginning at a step from `N`". So the rest law is needed in the form "not for every `N` from `T`, not not taking at a step from `N`". `Amounts.rests_unrefuted` concludes exactly that form: take the stock of the list, a least loss of one, "some present formation takes" as the marked steps, and the stock at `T` plus one as the bound, with its premises from `BalancesOn.runs_down` and `DissipatesOn.replenishment_takers`, as `taking_not_recurring_from` uses them (the re-check, R5).

This places the togetherness question: in a world that dissipates, keeping widening and 全生成 along such readings both need that no finite family holding what the formations require is dissipated on from some step: what is required lies in no finite family, is supplied from beyond such a family, or is exchanged beyond it without loss to it (corrected after the re-check, §17). The fed witness of §6 is of the second kind: its loss lies wholly in fuel no formation requires, and its family of requirements conserves. It is not a part sustained by supply from beyond (corrected after the Lean review, §16).

## 4. The two negative results as the ends

The readings of the World containing carrying on of the supported and contained in "carry on, or pass support" form an interval.
- **At the top**, "carry on while supported, or pass support", every passing is a step of the reading. Nothing begins a line of it, so nothing opens along any reading containing it (corollary 4 and the three general exclusions of GW3), however much is carried. `ClosedCycle.generation_without_widening` is stated along the reading with dormant carrying on. Its 全生成 carries over to the top of the interval from supported occurrences, since lines under activity from active occurrences never take a dormant step (`Web.supportedPassing_cont_iff`, planned).
- **At the bottom**, "carry on while supported", no passing is a step. Every passing begins (corollary 5), and no step of the reading crosses formations, so no carrying renewal lies along it and nothing is 全生成. Its proof is `Web.itself_not_generation`'s, with "while supported" [planned Lean, a one-line lemma].
- **Between them**, a passing is a step of the reading, a beginning or beside it. Steps that cross formations are the reading's renewals (generation's events). Fresh beginnings are its openings (widening's events). Both can recur together (§6).

The landed readings with dormant carrying on, `itself` and "carry on, or pass support", contain these and read more links. How the landed laws stand to the ends:
- The three landed exclusions (`not_exceedsAcross_along_passings`, `not_keepsOpening_along_passings`, `not_keepsWidening_along_passings`) take "carry on, or pass support" within the reading. They follow from the general three, which take `supportedPassing` within it, by `ExceedsAcross.anti` (board rule 9; GW3).
- `Web.itself_not_generation` is not a consequence of `Web.supportedItself_not_generation`, nor conversely, since 全生成 is not monotone in the reading. Both are cases of one law, for any continuation in which each formation continues only itself (`Web.not_generation_of_within_itself`, placed in `Becoming.MapInstances` after the Lean review, §15).

`Flow.whole_not_keepsWidening` is not an end of this interval. It is the gain bridge at names: keeping widening by name needs a stock passing every bound, which a finite closed family cannot have. `Web.KeepsWidening.not_listed` gives the same over a listed type of formations, with no premise on the flow. Both concern what can form by name, which is what C's widening reads, and on that they are central (§7).

## 5. The held possible: the map's form of a landed law

Read on any process (`Becoming.HeldPossible`):
- the carrier is the course's moments, with `Steps.next` as 缘;
- the coarse class is the one (`«一»`);
- the fine class is the held class `fun n m => Same (r.state n) (r.state m)`.

**Law** [argued; planned Lean, GW5]. `«全生成» Steps.next «一» E N` holds exactly where, for every `y ≥ N`, a line under `E` begins at some `n + 1` with `n ≥ y`. So, where holding is decided and the held possible keeps widening along a course `r`, every moment `N` is 全生成 at (the one, held) (`Run.generation_of_heldKeepsWidening`, from `Run.begins_of_heldKeepsWidening`).

Reach on `Steps.next` comes from `Steps.reached_of_buqiong` (landed, `Becoming.Change`), taken at the one, whose 不穷 is immediate. The equivalence is near-definitional, and the law restates the landed one on the map. Its record says so.

**Converse fails** [argued; planned Lean]. On `Oscillating` the rule changes at every step, so every moment is 全生成 at (the one, held), and the held possible does not keep widening (`Oscillating.converse_fails`).

**Instances** [planned Lean]:
- `RaisedRule`: 全生成 at (the one, held) while every moment ceases (`RaisedRule.ceases`). This is the map's generation without renewal without end.
- `RaisedEveryOther`: 全生成 together with `«生生»` and keeping widening of the held possible. A new theorem extends `both`, whose statement is kept.

On this reading the held class plays the role of `Es 1`. Its beginnings are carried by the course under the one, and they are what the held possible's widening needs.

## 6. A reading on which both hold: `KindRelay`

**The world** [hand check, `founding_check_period2.py`; planned Lean, GW4].
- *Formations:* `a0 a1 e` of kind a, and `b0 b1 c` of kind b. Each requires its own condition at need one, fixed.
- *Conditions:* the formations' own (six, listed); levels count units.
  - Even steps: `a0` holds 2 and `b0` holds 2.
  - Odd steps: `a1`, `b1`, `c` and `e` hold 1 each.
- *Flow.* The present formations are the supported ones.
  - Across an even step: `a0` moves one unit to `a1` and one to `c`; `b0` moves one to `b1` and one to `e`.
  - Across an odd step: `a1 → a0`, `e → a0`, `b1 → b0`, `c → b0`.
- *Premises.* It balances at every condition and step. Only supported formations give. Activity is support. Needs are fixed, so requirements never loosen. Every present formation gives the whole family exactly what it takes (`Conserving`, hence `Gainless`, the first law). The conditions are listed without repetition, and `RequiresWithin` holds. So both landed negative laws apply.
- *Not met:* it is **not dissipative**. Embodiment, a census and bounded transmission are not checked. "Only active relata take, and only what they draw on" (`Flow.Taking`) is met (`KindRelay.taking`, §15).

**What holds** [hand check over 24–40 steps; reviewer's hand check of the period-4 design; planned Lean]. With `Q` "of one kind" and the reading `withinKind Q` (carrying on only while supported):
1. Nothing admitted is lost along the reading, and after every step something opens: `c` or `e` across the next even step, never linked along the reading to anything supported at the earlier step. So `KeepsWidening (withinKind Q) level 0`.
2. Every supported occurrence is 全生成 along the reading at (activity, one formation), which is `«阶全生成» P Es 0`: each lineage renews through brief carriers at every step.
3. Every supported occurrence is `«阶全生成» P Es 1`: from every point of the whole lineage, `a0` or `b0` begins a kind-line within two steps.
4. `«生生» P K` holds at `(0, a0)`. `a0` conditions the beginning of `c`'s kind-line, which goes on into `b0`. `b0` begins `e`'s, which reaches `a0`, and so on: the family is `{(2k, a0), (2k, b0)}`.
5. These do not keep widening:
   - by name, since six formations are listed (`Web.KeepsWidening.not_listed`);
   - along "carry on while supported, or pass support" (corollary 4);
   - along "carry on while supported" (it loses at every step);
   - along the kind reading with dormant carrying on by name. There `c`, begun across step `S`, is linked to `c` supported at `S − 1`, so nothing opens from odd steps.
6. The world returns: its levels, supports and flow repeat with period 2, so what it can form changes at every step and comes back every two.
7. Linking any two formations of one kind opens nothing, since both kinds are admitted at every step. This is a fact of the witness, not a law [hand check].

The first design (`founding_check.py`, period 4, alternating `c`/`c′` and `e`/`e′`) kept widening along the reading with dormant carrying on, but only because the names alternated. The reviewer's period-2 variant has the same lineage structure, and on that reading it does not keep widening. Item 5's last case keeps that finding: with dormant carrying on by name, the reading counts names, not lineages.

**The fed version** `KindRelay.Fed` [hand check of the arithmetic; planned Lean].
- *Conditions:* add the conditions `fuel t`, one for each step, each holding at step 0 what step `t` will use: 2 at even steps, 4 at odd ones.
- *Flow:* each taker also draws on and takes one unit of `fuel t`. Every taker then gives at least one unit less than it takes on every family closed across the step, so the flow is dissipative and hence gainless, and it still balances.
- *What changes:* fuel is not required by any formation, so supports, passings, links and items 1–4 are unchanged. No list holds every condition, so `whole_not_keepsWidening` does not apply.
- *What the part does:* its levels return with period 2 while its fuel is spent. Its six required conditions conserve exactly, and deleting the fuel gives back the closed relay: the fuel pays only the loss `Dissipative` asks for, a sink the part draws on and does not need. So the fed relay shows that dissipation as stated does not by itself exclude the two holding together, where what is required is not dissipated on; it is not a part sustained by supply from beyond (corrected after the Lean review, §16).

**Why the returning part does not contradict `Run.not_keepsWidening_of_returns`.** That law concerns what is read off configurations. `ExceedsAcross` along a reading other than names reads links across the history, which a returning configuration does not fix.

**Why the witness encodes no verdict.** §3's law is stated for every reading, and it fixes the price of keeping widening on any of them: fresh beginnings. The witnesses show only that the price can be paid together with 全生成 at two orders, in a closed conserving world and in a fed dissipative one. Neither chooses the reading C is read on (§7).

## 7. What it says about 生生

[AI reading, D45.]

**What C reads.** C's widening compares which members of `F`, given in advance, the levels admit (`Web.Widens`). It is a same-step comparison of two level paths, unchanged by every re-identification (07 §2). What can form, in that comparison, is D3's: the formations whose requirements a course's levels meet. That is the criterion used here. It was not chosen to fit the witness, and it is not a reading by kind or by lineage. Keeping widening along a lineage reading is a property of that reading's links, and C does not read it.

Two limits on this criterion:
- **It reads names across steps.** Keeping widening by name, one course across steps (`KeepsWidening itself`, `not_listed`, `whole_not_keepsWidening`), reads names across steps. It is not invariant under re-identification (`keepsWidening_reidentify`; for the lagged order, `NamesAcrossSteps.lag_reads_names`).
- **It registers only part of D1.** D1's R25 paragraph says that 生生 as D1 reads it "can exceed what widening registers", and the treatise's clause goes on to "以及世界能否继续发现新的形成方式", new ways of forming outside `F`. So C registers the part of D1's last clause that lies within `F`. With `F` fixed, the witnesses have neither the part within `F`, since what they can form only returns, nor the part outside it.

**What the witnesses have.** On `KindRelay` and `KindRelay.Fed`:
- the map's generation holds at two consecutive orders;
- the grammar's renewal without end holds at the middle grain;
- the range keeps widening along the lineage reading;
- what the part can form only returns, with period 2, and by name over its formations nothing keeps widening (`Web.KeepsWidening.not_listed`).

**What D1 reads 生生 as.** "generation generating generation: what forms preserves, restores, transmits or creates the conditions and generators of further forming, so a course changes what can form, and the capacity to form, along with the state". The treatise it quotes: "普通生成改变接下来的状态；生生还改变接下来能够形成哪些状态". The witnesses create generators of further forming: begun lineages that themselves renew and begin. What they can form changes at every step, but only by returning. With D5's exclusion of return as the premise, they are ordinary generation in the treatise's sense. So:
- **They illustrate, on a model, three adopted readings:** D65 item 4 ("[生成] is not 生生"), 01 §6 ("That asks more than renewal of lines") and the two-grains record's first does-not-show item. The illustration holds with generation at two orders, not only at one, and with keeping widening along a reading added.
- **They show that "creates the conditions and generators of further forming"**, read structurally as begun lines that renew and begin, does not by itself give D1's last clause read with D5. The part of that clause within `F` is what C registers.

**The law between the map and that clause.**
- *One direction:* wherever what can form keeps widening, the map's renewals one grain up carry it. By name this means passings at arbitrarily late steps (§3.2, corollary 5). On the held possible it means 全生成 at (the one, what is held) (§5).
- *Not conversely:* `KindRelay`, `ClosedCycle` and `Oscillating`.

**Where the negative results are central.** Keeping what can form widening has these bounds:
- **A finite closed whole:**
  - nothing keeps widening by name over listed formations (`Web.KeepsWidening.not_listed`);
  - with formations not listed, under the first law and fixed requirements, it still does not (`Flow.whole_not_keepsWidening`).
- **One fixed process:** nothing is added to its whole possible (`Run.possible_of_next`).
- **The held possible:** it keeps widening only where what is held changes without end (`Run.changes_of_heldKeepsWidening`).
- **Under dissipation, a finite closed world:** nothing keeps opening along any reading of §4's interval, and nothing is 全生成 there (§3.4; Lean, §15).
- **Novelty that keeps coming:** it needs exchange beyond every finite family (`Flow.new_beyond_every`, a necessity). That it can be had is `Ladder.frontier_witness`.

**Proposal for the account.** These are proposals; each changes a document only through GW's landing:
- 02 §1's Reading: "no law relates the two" becomes the one-way law, with the interval of §4.
- 07 §2, `r-what-keeping-widening-needs`: "on both readings used … do not hold together" becomes "at both ends of the interval of readings of lineage. Between them they can, where carrying on is read while supported, at the price of fresh beginnings; there what they count is lineage, and what can form can return."
- 01 §6's Reading and D1 gain one sentence with the law and the witness. D5's "a whole that only returns has 不息 but not 生生不息" is illustrated: a part whose levels return can have generation at two orders, and by D5's reading it still has not 生生不息.
- The two-grains record's first does-not-show item gains `KindRelay` as its witness.

**What it does not change.** C, the continuation condition and their roles. The comparison of two courses, which no law here touches, so the second-order direction stays open.

The law narrows that open question in one way. A second-order direction read along a lineage reading would rank begun lineages, which a returning part has. A direction meant as "changes what can form", read within `F` as C reads it, cannot be kept widening by any course from within a finite closed whole.

**For the question of a collective's direction** [for AJ5's page].
- Whatever widening of what can form a collective keeps, its renewals one grain up carry it. This is necessary and not sufficient.
- A collective can renew itself at two orders and begin new lineages without end while what it can form only returns.
- Keeping what can form widening needs, besides, exchange beyond the closed whole, or rules the collective holds that keep changing (§5). In a world that dissipates, the renewal needs that no finite family holding what is required is dissipated on from some step: what is required lies in no finite family, as where new forms keep arising (`Flow.new_beyond_every`), is supplied from beyond such a family, or is exchanged beyond it without loss to it (§3.4; Lean, §15; corrected after the Lean review and its re-check, §§16–17).

## 8. The two orders of "more", read with the split

[AI reading.] `CausalGrowth.no_order_contains_both` is read here as the same complementarity on comparisons.
- A birth with an empty past has nothing continuing into it.
- A birth above an element is continued.
- Widening what can be born next ranks highest the antichain, where nothing continues.
- Widening what continues ranks the chain highest.

No law connects §3's arrivals to CausalGrowth. Stems widen by the reversal of the inclusion of precedence (`CausalGrowth.stems_included_iff`), not by counting births with an empty past. So this is a reading of why the two orders part, not an explanation the Lean gives.

## 9. The map's coverage, decided

**The gap** [hand check, confirmed by the reviewer; planned Lean, GW1: `Map.Once`]. Carrier `{p, q, r}`, with `R` given by `p → q`, `q → r` and `r → r`. The coarse class is `«一»` and the fine class is `«静»`, so `«传» x y` is `R x y ∧ ¬ R y y`.
- `p` is not 生成: every branch from `p` holds `r`, and from `r` no carrying renewal lies ahead.
- `p` is not 守: `«传» p q` holds on its only branch.
- `p` is not 退化: `r` goes on for ever.
- `p` is 全守.

**The decision.** As defined, 生成, 守 and 退化 are not a partition:
- they overlap where lines branch (`Map.«生守相杂»`, by design);
- they leave this gap, because 守 forbids renewal on the whole branch, where 全守 allows renewals before its point.

Define keeping from some point on [planned Lean]:

```lean
def «后守» (R L E : «际» α) (x : α) : Prop :=
  ∃ S : α → Prop, S x ∧ (∀ z, S z → ∃ w, S w ∧ «续» R L z w) ∧
    ∃ z, «所及» R L x z ∧ S z ∧ ∀ u v, S u → S v → «所及» R L z u → ¬ «传» R L E u v
```

The point `z` must be reached from `x`. Otherwise any still point anywhere, added to the family, would make every point that goes on 后守.

Then [argued; checked by the reviewer]:
- `«守则后守»`, and `«全守则后守»` with the whole line from `x` as the family;
- `«后守则延»` and `«后守退化不并»`;
- `«单行则生成后守不并»`: where each occurrence conditions at most one other, both families contain everything reached (`«单行则族含所及»`), and 生成's renewal ahead of `z` contradicts 后守;
- `«三域之周»`: with excluded middle, every point is 生成, 后守 or 退化. Take 延 or 尽. Restrict 延's family to the points reached from `x`, which stays closed. Then either every member has a renewal ahead within the family (生成) or some member does not (后守);
- `Map.Once`: `p` is 后守 and 全守.

**Calibration** [argued; planned Lean]. That every point of every model lies in one of the three is exactly excluded middle, by the `Unit` model with the relation `fun _ _ => P`. That repeats `«延尽之定当且仅当排中»`, so it is a lemma of GW1, not a result.

The informative calibration is on a single line. Take `Steps.next` under the one, and the class `fun n m => b n = b m` of a sequence `b`. A line under it begins at `n + 1` exactly where `b` changes there.
- 生成 at 0 is "`b` changes at arbitrarily late steps".
- 后守 at 0 is "`b` is constant from some step on".

For `p : Nat → Bool`, let `b` change at every step until the first `n` with `p n`, and stay constant after. Placing 0 in 生成 or 后守 then decides `(∃ n, p n) ∨ ∀ n, ¬ p n`. So placing every point that goes on in 生成 or 后守 gives LPO (`«生成后守之定则LPO»`).

What the need says about the unfolding: **to tell generation from keeping on a line is to decide whether the line renews again.** That is a statement of the record, not a calibration of the logic alone.

So, with excluded middle, the three regions cover, keeping read from some point on. On single lines they partition. Where lines branch, 生成 and 后守 overlap, as the map intends. 02's Open item closes, and the strong forms 全生成, 全守 and 有终 already partition with excluded middle (landed).

Whether `«守»` should be redefined as `«后守»` is a change of a shared definition, decided by the owner of `Becoming.GrammarMap` (rule 3). The plan adds `«后守»` beside it and keeps `«守»`, which is strict keeping and is used by `Map.Still.keeps`, `«守退化不并»` and `«单行则生守不并»`.

## 10. Lean plan

Every item:
- is claimed on GW's row before any Lean;
- is built with `scratch_build.py`;
- lands through the queue with one independent review.

Every module named is in the pure core (`check_becoming.py`'s `CORE` list includes `Becoming.KeepingWidening` and `Becoming.HeldPossible`), so every item needs empty axiom reports. The sketched proofs are constructive, with excluded middle only inside double negations. No earlier statement changes, checked by a signature audit as OU3f did.

| Item | Module | Statements | Standing |
|---|---|---|---|
| **GW1** coverage | `Becoming.GrammarMap` (the OU line's owner asked first) | `«后守»`; `«守则后守»`, `«全守则后守»`, `«后守则延»`, `«后守退化不并»`, `«单行则生成后守不并»`, `«三域之周»`; `Map.Once` with `.not_generates`, `.not_keeps`, `.not_degenerates`, `.keepsAfter`, `.keeping`; the `Unit`-model lemma; `«生成后守之定则LPO»` | root; near-definitional; a calibration with its statement about the unfolding |
| **GW2** split on the root | `Becoming.GrammarMap` | `«传则粗不生»`; `«生则或粗生或传»` (no order between the classes) | root; near-definitional |
| **GW3** beginnings | `Becoming.KeepingWidening` (core, a leaf: only `Becoming.lean` imports it), below `descends_along_passings` | `Web.supportedItself`, `Web.supportedPassing`; `Flow.BeginsAlong`; `BeginsAlong.not_along`, `BeginsAlong.carries`; `Flow.descends_or_begun`; `Flow.begun_of_exceedsAcross`; `Flow.begins_late_of_keepsOpening`; `descends_along_passings` re-proved from `descends_or_begun` (rule 9, statement unchanged); the three general exclusions `Flow.not_exceedsAcross_along_supportedPassing`, `not_keepsOpening_…`, `not_keepsWidening_…` (hypothesis: `supportedPassing` within `R`), with the landed three derived from them by `ExceedsAcross.anti`; `Web.supportedPassing_cont_iff` (from active occurrences, continuing along it under activity is continuing along "carry on, or pass support"); `Web.supportedItself_not_generation`; `Web.withinKind`, `Web.kindClass`, `Web.withinKind_cont_iff`, `Web.withinKind_begins_iff`, `BeginsAlong.carries_kind_iff` | World; near-definitional: the theory's biogenesis read along a reading |
| **GW3b** dissipation | same | `Flow.not_keepsOpening_of_dissipative`, `Flow.not_generation_of_dissipative`, through `Amounts.rests_unrefuted` and `DissipatesOn.takes_of_gives` | World; argued, and its constructive route checked by the re-check |
| **GW4** witnesses | a leaf instance module importing `Becoming.KeepingWidening` (rule 9: an instance), registered in `check_becoming.py`'s `CORE` list and its module descriptions and imported by `Becoming.lean`; or in `Becoming.KeepingWidening` itself | `KindRelay.web`, `.flow`; `.balances`, `.acting`, `.dependent`, `.unloosened`, `.conserving`, `.gainless`, `.requiresWithin`; `.keeps_widening` (along `withinKind`), `.generation` (order 0, at every supported occurrence), `.generation_one_up` (order 1), `.renews_without_end` (`«生生»` at the kind class), `.not_keepsWidening_byName`, `.not_keepsWidening_supportedPassing`, `.not_keepsWidening_dormant` (the kind reading with dormant carrying on), `.returns` (period 2); `KindRelay.Fed` with `.dissipative`, `.balances`, `.gainless` and the same items 1–4 | witness |
| **GW5** held | `Becoming.HeldPossible` (core) | `«全生成» Steps.next «一» E N ↔ …` (the equivalence); `Run.generation_of_heldKeepsWidening`; `RaisedRule.generation`, `RaisedEveryOther.generation`, `Oscillating.generation_without_widening` | core; a restatement on the map |
| **GW6** both ways on the moments (added at the claim, 30 October; §18) | `Becoming.WideningOnTheMap`, a core leaf | `Steps.includes`, `Steps.same`, `Steps.KeepsWideningFrom`; the representation both ways under two premises; the split `Steps.generation_includes_iff`; `Moving`, `Growing`; the premises' calibrations; the World by name | core; near-definitional; a representation, and the join as the split by loss |

`Becoming.HeldPossible` imports `Becoming.GrammarMap` and `Becoming.Change` transitively (checked), so GW5 needs no new import.

**Records, by the workflow.**
- `generation-and-degeneration-at-two-grains`: GW1 and GW2.
  - The coverage item leaves 02 Open.
  - Does-not-show items 2 and 3 stay true and stay.
  - Item 1 ("That generation here is the 生生 of life in the whole") gains `KindRelay` as its witness, cross-referenced from GW4.
- `what-keeping-widening-needs`: GW3, GW3b and GW4.
  - Its law 9, the exclusion along passing of support, becomes a corollary of the law of beginnings, generalized below it.
  - Its does-not-show item on 02's open item is revised.
  - "a reading on which 全生成 and keeping widening hold together" leaves "What is not derived" in the module docstring.
  - The title, "What keeping widening needs, and what carries it", already fits.
- `where-the-possible-grows`: GW5, as a restatement.

No new record: each law extends the record whose question it answers.

**Docs.**
- 02 §1: the Reading and Open.
- 07 §2: `r-what-keeping-widening-needs` and its Reading, and `r-where-the-possible-grows`.
- 01 §6: the Reading.
- D1 and D65 item 4: a revision note each (the law and the witness; no change of reading).
- The glossary entries for 生生 and 生成, if either lacks the distinction.
- OPENING and the generativity chain, which are in Ren's voice, only by proposal, and only if they use 生生 for the map's generation.

**Not in the plan.**
- Any ordering of two courses.
- Any change to C, the condition or their roles.
- A reading by kind for C.
- Kinds not given in advance, which the grammar still cannot state.

## 11. What would change this, and what is not shown

- **A web failing one of the four premises** is outside the law of §3.2: a gain given by no supported formation, or requirements loosening (`Loosening`). `Source.from_nothing` meets the four premises and fails only the first law. The law does not use the first law, so `Source` is inside it, and its openings by name are passings from its giver.
- **Readings leaving out carrying on of the supported**, such as `MergedWitness`'s merge continuation, are not covered. On them re-formation counts as opening.
- **A reading of "what can form" other than by name**, adopted for C, would move §7's line. The law of §3 would still say that keeping it widening needs fresh beginnings of that reading.
- **GW3b** is argued, and the re-check found its constructive route through `Amounts.rests_unrefuted`. If the Lean needs more, §3.4 stays argued and its record says so.
- **Not shown:**
  - that kinds are the right grain for any actual system;
  - which reading C should be read on, beyond its comparison by name over `F` given in advance; and the part of D1's 生生 outside `F`, which R25 notes widening does not register;
  - growth by kinds not given in advance;
  - the comparison of two courses;
  - the some-branch regions read on the World where 全生成 fails.

## 12. Modelling commitments

The laws of §3 use discrete steps on one index, natural-number levels and Prop-valued activity read as support, as the landed laws do. The witnesses use unit amounts and needs of one, and the fed version has one fuel condition for each step. The root laws of §3.1 and §9 hold for every carrier and relation.

## 13. The review, and how each finding was taken

The review is [REVIEW-GW.md](REVIEW-GW.md) (Claude Opus 5.5, read-only, 29 October 2026; re-check in §14). It found the formal skeleton sound, every statement about landed Lean correct, and the verdict overreaching in four places. Every finding was taken.

| Finding | Taken as |
|---|---|
| F1 "generation one grain up" overstated | The World law now gives the map's events (carrying renewals) recurring, not its regions (§1 item 1, §3.2, §3.3). "Generation" is kept for 生成 and 全生成. 全生成 from widening is claimed only on the held possible (§5). |
| F2 dissipation | The exact premise list is in §6, and the witness is "not dissipative". §3.4 adds the dissipation corollary (argued, GW3b), and a fed dissipative witness is added. §1 items 3–4 and §7 carry it. |
| F3 names, not lineages | The reading is now carrying on only while supported (§3.2). The adopted witness is the reviewer's period-2 world, and the first design's reading is kept as the case with dormant carrying on, which does not keep widening (§6 item 5). The interval's ends are restated (§4), and the landed laws are their cases. |
| F4 the redraw | Withdrawn. §7 now confirms D65 item 4, 01 §6 and the two-grains record on a model, and reads D1's last clause as the content criterion. The criterion for "what can form" is C's own reading by name (D1 R25), not a classification fitted to the witness. The proposals are listed as proposals. |
| F5 identity stated | "needs", and "with freshness, enough" (§3.3). |
| F6 three kinds of passing | Step of the reading, beginning, or beside it. "Opening" is kept for `ExceedsAcross` (§3.2). |
| F7 by kind name | It is a witness fact (§6 item 7). "or kind" is dropped from what C reads, and `Web.KeepsWidening.not_listed` is cited for names. |
| F8 core | Every module in §10 is core, with empty axiom reports. |
| F9 the name `Founding` | The witness is `KindRelay`, and the passing is `BeginsAlong` («生»), distinguished from `Becoming.Founding` (§3.2). |
| F10 calibration | The `Unit`-model theorem is a lemma. The single-line calibration giving LPO is added with its statement about the unfolding (§9). |
| F11 `Source` | Corrected (§11). |
| F12 records | Law 9; items 2 and 3 stay; item 1 gains the witness (§10). |
| F13 §8 | Labelled an AI reading, and the claim of explanation is withdrawn. |
| F14 citations | `new_beyond_every` is cited as a necessity, with `Ladder.frontier_witness` for the possibility. `RaisedEveryOther`'s notion is named (`Reaching.KeepsWidening`), and the returning witness is squared with `Run.not_keepsWidening_of_returns` (§6). |
| F15 precision | GW2 drops the unused hypothesis. `withinKind_cont_iff` is stated from supported occurrences, where the reading with supported carrying on and passings under kind agree. `withinKind_begins_iff` and the iff for `«传» P A K` are added. Arising is credited to `PassesSupport`. `(j + 1, h)` is corrected. |
| F16 restatement | `Steps.reached_of_buqiong` is cited, and GW5's record calls the law a restatement. |

## 14. The re-check, and how each finding was taken

The same reviewer re-checked the revision ([RECHECK-GW.md](RECHECK-GW.md)). It found every review finding taken and the new material correct: the law with carrying on of the supported, the three kinds of passing, corollaries 4 and 5, §3.3's laws, §3.4 with its constructive route, both witnesses, the LPO coding and the plan. It found no high finding and eight others, all taken.

| Finding | Taken as |
|---|---|
| R1 what can form returns | "stays the same" becomes "only returns, and keeps widening by name from no step". The exclusion of return is credited to D5, as the premise of the treatise's distinction (§1 items 1 and 5, §6 item 6, §7). |
| R2 D1 and the invariance | C registers the part of D1's last clause within `F` given in advance, and R25's point that 生生 can exceed it is stated. The invariance is confined to `Web.Widens`, and the by-name reading across steps is said not to be invariant (§7, §11). |
| R3 wording | "proves" becomes "illustrates" or "consistent with"; "never give it" becomes "do not by themselves give it"; D5 is "illustrated"; the interval of §4 is named. |
| R4 §1 item 3 | Carrying on of the supported is added. |
| R5 §3.4 | It cites `DissipatesOn.takes_of_gives` and `Flow.Balances.taking_not_recurring`, with the constructive route through `Amounts.rests_unrefuted`. GW3b's standing is changed accordingly. |
| R6 exclusion along `supportedPassing` | GW3 adds the three general exclusions, with the landed three derived from them, and `Web.supportedPassing_cont_iff`. §4 says how the two generation statements stand. |
| R7 §13 row | Matched to §3.3. |
| R8 registration and comments | GW4's row names the registration. The script comments are corrected. |

No high finding remained after the re-check. The Lean items are claimed on GW's row before any Lean, and each landing has its own review.

## 15. The Lean of GW3, GW3b, GW4 and GW5

Built on 29 October 2026 in `Becoming.KeepingWidening` (GW3, GW3b and GW4) and `Becoming.HeldPossible` (GW5), on the `gw-lean` branch, first from main at `0227f5c7e` and, after the review (§16), on main merged in at `84f09acf6`. GW4's witnesses sit in `Becoming.KeepingWidening` itself, which §10 allows, so no module is added. Two general lemmas the review asked for went below: `Web.not_carries_of_within_itself` and `Web.not_generation_of_within_itself` in `Becoming.MapInstances`, of which `itself_carries_nothing` and `itself_not_generation` are now cases, and `Web.begins_of_arises` in `Becoming.PatternPassing`, of which the forward half of `arises_iff_sheng_carrier` is now a case (board rule 9; each module has one or two modules downstream). `total_eq_of_supports` stays in `Becoming.KeepingWidening`, its home beside `total_le_of_support` (`Becoming.Dissipation`, 264 modules downstream) at the next full rebuild. GW1 and GW2 (`Becoming.GrammarMap`) are not claimed and not built.

**Checks.** A scratch build of the whole package has no error or warning, and every declaration of the four changed modules has an empty axiom report. A namespace-aware comparison against main finds no earlier declaration's statement changed and none removed. By the scratch audit `Becoming.KeepingWidening` goes from 154 declarations to 304 (247 theorems), `Becoming.HeldPossible` from 110 to 118 (89 theorems), `Becoming.MapInstances` from 26 to 28 and `Becoming.PatternPassing` from 45 to 46. These were scratch builds; the core checker passed at landing, at receipt `20261029T145758.555114Z` on the branch merged with main after WRP2 (study §448), with the signature audit at WRP2's receipt in [signatures.json](signatures.json) (335 landed statements and 70 bodies unchanged, nothing removed, only the seven proofs above changed) and the measures unchanged.

**GW3, the law of beginnings** (§3.2, §3.3, §4).

| Plan | Lean | Note |
|---|---|---|
| `Web.supportedItself`, `Web.supportedPassing` | as planned | with `supportedItself_within`, `supportedPassing_within` |
| `Flow.BeginsAlong`, `.not_along`, `.carries` | as planned, with `BeginsAlong.iff_begins` | the «生» reading: a passing whose end begins a line of `R` under activity |
| `Flow.descends_or_begun` | as planned | the induction of §3.2, excluded middle inside the double negation |
| `Flow.begun_of_exceedsAcross` | as planned | also gives the formation that opens at `U`, linked along `R` to nothing supported at `S` |
| `Flow.begins_late_of_keepsOpening` | as planned | |
| corollary 5 | `Flow.beginsAlong_supportedItself_iff`, `Flow.passes_late_of_keepsOpening_byName` | by name, keeping opening needs a passing of support after every step |
| `descends_along_passings` re-proved (rule 9) | from `Flow.descends_along_supportedPassing`, itself from `descends_or_begun` | statement unchanged; the new law links along supported passings, a stronger statement |
| the three general exclusions | `Flow.not_exceedsAcross_along_supportedPassing`, `not_keepsOpening_…`, `not_keepsWidening_…` | the landed three derived from them, statements unchanged |
| `Web.supportedPassing_cont_iff` | as planned | |
| `Web.supportedItself_not_generation` | by `Web.not_generation_of_within_itself` (MapInstances) | names are the other case |
| `Web.withinKind`, `Web.kindClass`, `withinKind_cont_iff`, `withinKind_begins_iff`, `BeginsAlong.carries_kind_iff` | as planned, with `Web.kindGrains` and `Web.kindClass_within` | the grains one formation, kind and activity for the map's orders |
| (added) | `Web.supported_along`, `Web.endless_of_successor`, `Web.generation_of_one_step_supports`, `Web.Linked.last`; `Web.begins_of_arises` (PatternPassing) | what arises begins a carrier along every continuation, so where supports last one step every endless supported line is 全生成, along every continuation and under every class finer than activity; used by the witness |

**GW3b, dissipation** (§3.4). `Flow.not_keepsOpening_of_dissipated_requirements` and `Flow.not_keepsWidening_of_dissipated_requirements` go through `falls_stop_unrefuted` (`Becoming.Space`), which is `Amounts.rests_unrefuted` at whole numbers, the route of the re-check's R5; a passing of support takes from the list (`Flow.PassesSupport.takes`). `Flow.not_generation_of_dissipated_requirements` needs no World premise beyond balance on the list, and since 全生成's renewals are given outright (`Web.generation_renews_late`) it uses the outright `Flow.taking_not_recurring_from`, not the law of beginnings. All three take a list holding every condition any formation requires, dissipated on from some step (`DissipatesOn`), weaker than a finite world with every condition listed.

**GW4, the witnesses** (§6). Both relays run one relay (`KindRelay.Runs`: a formation is supported exactly where its own condition holds at the step's parity, and passes support exactly where it moves a unit), and the laws are proved once on it:
- item 1, `Runs.keeps_widening`, along `withinKind`, carrying on only while supported;
- item 2, `Runs.generation` along the reading at (activity, one formation), and `Runs.generation_order_zero` along passing at (kind, one formation);
- item 3, `Runs.generation_one_up`, with item 2's second form making `Runs.generation_two_orders`, `«阶全生成»` at orders 0 and 1 with `Web.kindGrains`;
- item 4, `Runs.renews_without_end`, at `(0, a0)`, the family the supported occurrences at even steps;
- item 5, by name and carrying on while supported (`Runs.not_keepsWidening_byName`, `Runs.not_keepsWidening_supportedItself`, from `Runs.not_includes_within_itself`: supports last one step), and with dormant carrying on by name (`Runs.not_keepsOpening_dormant`), where beginnings still recur (`Runs.begins_dormant`, `Runs.beginnings_without_opening`, the law's converse failing).

The closed relay (`KindRelay.web`, `.flow`) proves its premises (`.balances`, `.acting`, `.dependent`, `.unloosened`, `.taking`, `.conserving`, `.gainless`, `.requiresWithin`, with `every_form` and `distinct_forms`, so the finite-whole law's premises are met too), item 5 along supported passings (`.not_keepsWidening_supportedPassing`) and item 6 (`.returns`). The fed relay (`KindRelay.Fed`) has a condition of fuel for each step, holding what that step uses until it is used, drawn on and taken a unit by each formation taking part, and required by none. It proves `.balances`, `.dissipative`, `.gainless`, `.taking` and the rest of the closed relay's list, its part's conservation on the six required conditions (`.conserving_on_part`) and that no list holds its conditions (`.not_listed`). The kind `Q` is chosen with the witness: `c` and `e` are of the kind opposite their givers, so the passings across kinds are the reading's beginnings. Item 7, that linking any two formations of one kind opens nothing, stays a hand check.

**GW5, the held possible** (§5). `Steps.generation_iff_begins` is the equivalence: on the steps under the one, a moment is 全生成 at any fine class exactly where a line under it begins after every later moment. `Run.generation_of_heldKeepsWidening` restates `Run.begins_of_heldKeepsWidening` on the map, and `Run.generation_of_held_changes` gives 全生成 where what is held changes at every step. `RaisedRule.generation` (全生成 while every moment ceases) and `Oscillating.generation` are its cases, `Oscillating.generation_without_widening` shows the converse failing, and `RaisedEveryOther.generation` holds beside `both`, whose statement is kept.

**Not done.** GW1 and GW2. ClosedCycle's 全生成 at the top of the interval as a theorem: `Web.supportedPassing_cont_iff` is its first step, and the transfer is argued (§4). Item 7 of §6.

## 16. The review of the Lean, and how each finding was taken

The review is [REVIEW-GW-LEAN.md](REVIEW-GW-LEAN.md) (Claude Opus 5.5, read-only, 29 October 2026, at `71a83ec27`). It found every theorem proving what its own statement says, rule 9 met for `descends_along_passings` and the three landed exclusions, and five claims in prose or premises to correct, with fifteen lower findings. Every finding was taken.

| Finding | Taken as |
|---|---|
| 1 two orders | `Runs.generation_order_zero` and `Runs.generation_two_orders`, `«阶全生成»` at orders 0 and 1 with `Web.kindGrains`; `Web.generation_of_one_step_supports` takes any class finer than activity. |
| 2 rule-9 twin | The two general lemmas moved to `Becoming.MapInstances`; `itself_carries_nothing` and `itself_not_generation` derived from them, statements unchanged; §4's sentence revised. |
| 3 one way | `Runs.begins_dormant` and `Runs.beginnings_without_opening`. |
| 4 the fed relay | `draws` includes the step's fuel; `Fed.taking`; `Fed.conserving_on_part`; the docstrings, §1 items 3–4, §3.4, §6 and §7 corrected: the fuel pays only the loss dissipation asks for, and the part is not sustained by supply from beyond. |
| 5 one grain up | The headline says beginnings are carrying renewals along passing, and within a kind renewals one grain up. |
| 6 freshness | `begun_of_exceedsAcross` gives the opened formation's apartness. |
| 7 the «生» reading | `BeginsAlong.iff_begins`. |
| 8 standing | Only the opening and widening laws for dissipated requirements are corollaries of the law of beginnings. |
| 9 docstring | `gain_carried` cited as stating the step, not as used. |
| 10 "both readings" | "On names and on passing of support". |
| 11 name | `Web.generation_of_one_step_supports`, "where supports last one step". |
| 12 dissipation names and premise | `every` weakened to every required condition listed; the laws renamed `…_of_dissipated_requirements`. The fed relay escapes them because its requirements conserve and a list holds the fuel of only finitely many steps (`Fed.conserving_on_part`, `Fed.requirements_not_dissipated`, the latter after the re-check). |
| 13 helper twins | `Bool.not_not`, `ListTests.false_of_not` and `distinct_map_on` used; `total_eq_of_supports` moved out of the witness's namespace, its home beside `total_le_of_support` at the next full rebuild (on GW's board row); `KindRelay.inside` stays, since it fixes the formations to the relay's. |
| 14 `begins_of_gains` | Replaced by `Web.begins_of_arises` in `Becoming.PatternPassing`, of which `arises_iff_sheng_carrier`'s forward half is a case. |
| 15 duplicate proofs | `Run.generation_of_held_changes`, of which `RaisedRule.generation` and `Oscillating.generation` are cases. |
| 16 wrapper | `RaisedEveryOther.generation_with_both` removed. |
| 17 by name | `Runs.not_includes_within_itself` from brevity gives the by-name exclusion for both relays; the finite-whole law's application stays checked (`KindRelay.not_keepsWidening_byName_of_whole`, after the re-check). The fed relay's docstring lists the laws that hold of it. |
| 18 the reading chosen | The docstrings and §15 say `Q` is chosen with the witness, and that its openings are the passings across kinds. |
| 19 item 5 and `Taking` | `Runs.not_keepsWidening_supportedItself`; `KindRelay.taking`; §6's "Not met" updated. |
| 20 instance | `local instance`. |

## 17. The re-check of the Lean, and how each finding was taken

The same reviewer re-checked the fixes ([RECHECK-GW-LEAN.md](RECHECK-GW-LEAN.md), at `2ce13d0d1`). It found all twenty findings taken as asked and the fed relay's reading exact, no high finding, one medium and seven low, all taken.

| Finding | Taken as |
|---|---|
| 1 the escapes from dissipation | §1 item 3, §3.4 and §7's bullet name three: what is required lies in no finite family (the route of novelty, `Flow.new_beyond_every`), is supplied from beyond such a family, or is exchanged beyond it without loss to it; §1 item 3 no longer inverts the conditional. |
| 2 "do not apply" | `KindRelay.Fed.requirements_not_dissipated`, cited in the module docstring and §16. |
| 3 citations | Full names. |
| 4 the finite-whole law | `KindRelay.not_keepsWidening_byName_of_whole`, the earlier proof, kept checked. |
| 5 labels | The section header reads "Where what is required is dissipated on, neither"; §1 item 4 and §7 relabelled. |
| 6 premises | §1 item 3 names the descent law's premises for the opening half and balance for the 全生成 half. |
| 7 §3.3's identity | Marked argued in general. |
| 8 the pending move | Recorded on GW's board row; the docstring states only the lemma; `inside` named in §16. |

## 18. The Lean of GW1, GW2 and GW6

Built on 30 October 2026 on the `gw-lean` branch from main at `6376f0da3`, the claim. `Becoming.GrammarMap`'s owner (OU's owner, through OU4) said yes to GW1 and GW2 at `16548a09c`, placed in a core leaf that imports `Becoming.GrammarMap` rather than in that module itself, since 332 of the package's 350 modules depend on it. GW6 is new at the claim. It answers the release gate's item 2, which asks for the map's generation and the ethics' widening joined both ways, or their split stated as a central result. GW1 and GW2 as designed (§§3.1, 9) close 02's Open item and do neither, and GW4's kind relay had already shown the two holding together on one reading. Two things revised the Lean after the build:
- the review (§19);
- OU's owner's two checks for GW6 (WHAT-REMAINS at `cd82afed6`): that the classes are fixed apart from widening, and that each premise of deciding says what its need means for the course.

**GW1 and GW2, in `Becoming.MapRegions`** (a core leaf importing `Becoming.GrammarMap` only; L1). Everything in §10's rows is there:
- the split of a beginning: `«传则粗不生»`, `«粗有前则生为传»`, `«生则或粗生或传»`;
- `«后守»`, with `«守则后守»`, `«全守则后守»`, `«后守则延»`, `«后守退化不并»` and `«单行则生成后守不并»`;
- `«三域之周»` and its calibration `«三域之定当且仅当排中»`, a lemma of GW1;
- `Map.Once` (`Map.once` on `Map.Stage`) with `.not_generates`, `.not_keeps`, `.not_degenerates`, `.keepsAfter` and `.keeping`;
- the single-line readings, after the review: 生成 at the first step is the sequence changing at arbitrarily late steps (`Map.generates_iff_changes`), and 后守 there is its being constant from some step on (`Map.keepsAfter_iff_settles`);
- the calibration on a line, in its strongest form. Deciding 后守 for the sequence that turns until `p` first holds (`Map.Settles.sequence`) gives LPO for `p` (`Map.«后守之定则LPO»`), and deciding 生成 gives only WLPO (`Map.«生成之定则WLPO»`). §10's form follows (`Map.«生成后守之定则LPO»`). Its hypothesis is the Σ⁰₂ decision, for each sequence, whether it changes without end or settles. LPO is the part derived, and without countable choice the core does not give that decision back from LPO. In terms of the unfolding: to tell whether a line keeps from some point on is to decide whether it stops renewing.

**GW6, in `Becoming.WideningOnTheMap`** (a core leaf importing `Becoming.KeepingWidening` and `Becoming.HeldPossible`; L2 through KeepingWidening). Read a course's moments along `Steps.next`, with what is held at each moment as a chain of predicates `Q`. The fine class is the same possible (`Steps.same`). In the coarse place stands nothing lost (`Steps.includes`), a preorder: a symmetric relation there could not tell loss from gain.
- **OU's check (1): the classes and widening.** The fine class is fixed apart from widening. The coarse relation is not: it is keeping widening's own inclusion half, defined from `Q` and not through `Widens`. So `Steps.generation_iff_keepsWidening`, the iff at (nothing lost, the same possible), represents keeping widening on the map; it does not join two notions fixed apart. The join with both classes fixed apart, the one and the same possible, is the split:
  - 全生成 at (nothing lost, the same possible) is 全生成 at (the one, the same possible) together with nothing lost, with no premise (`Steps.generation_includes_iff`);
  - so, under both premises, keeping widening is generation under (the one, the same possible) that loses nothing (`Steps.keepsWidening_iff_generation_losing_nothing`);
  - `Steps.Moving` has the generation and not the widening, and `Steps.Growing` has both.

  That what separates them is exactly loss is the informative content. The release gate's item 2 is met in its second form, the split stated.
- **The representation.**
  - Where each holding is refuted or unrefuted, keeping widening gives 全生成 (`Steps.generation_of_keepsWidening`), through `Steps.change_located`, which locates the step together with its point.
  - Where something new is found after each step after which not everything held was held before, 全生成 gives keeping widening (`Steps.keepsWidening_of_generation`). A listing of each moment's holding, with deciding, gives that premise (`Steps.found_of_listed`).
  - With neither premise, `Steps.includes_not_back_of_generation`.
- **OU's check (2): what each premise says about the course.** Generation is known by refutation: a line begins where no predecessor is alike. Widening is known by exhibition: something is held that was not.
  - **Forward:** exactly weak excluded middle, for every chain (`Steps.forward_iff_wem`). In the coding `Steps.arriving`, each point arrives at one of two moments as a proposition decides, and the step that generation names tells whether the proposition is refuted. Locating where something new arrives needs each moment's holding to be refuted or not.
  - **Back:** exactly excluded middle (`Steps.back_iff_em`). In `Steps.dawning`, each point is held from the next moment where a proposition holds. The course is 全生成 wherever the proposition is unrefuted, and keeps widening only where it holds. Exhibiting what a step adds, from the step's not being alike, needs what is unrefuted to be found. Even on decided chains it is Markov's principle, an unbounded search (`Steps.markov_of_keepsWidening_of_generation`).

  These calibrate the logic, not an omniscience principle about a course's run, and each is stated with what it says about the course.
- **On the World, by name.**
  - `Web.keepsWidening_itself_iff` now comes from the landed `Web.keepsWidening_iff_chain`, through the shift `Steps.keepsWideningFrom_iff_shift`.
  - `Web.generation_of_keepsWidening_byName` and `Web.keepsWidening_byName_iff_generation` hold under the premises on admission.
  - `Web.kept_by_name_and_generation_on_moments`, a corollary, pairs it with `Web.kept_of_includes_by_name`. On the occurrences, each admitted formation is 全守, from nothing lost alone, and the course's moments are 全生成. The two halves sit on two carriers, so this is not the map's two grains of one carrier, and the earlier headline "keeps each formation, generates the whole" is dropped.

What changes in the verdict (§1). The link is one way on the readings of formations (§§3–4) and on the held possible under the one (§5). Read on the moments it is both ways under the two premises, as a representation; as a join with classes fixed apart, it is the split by loss. At (the one, the same possible) the join is one way because the one does not count loss (`Steps.Moving`). The held class of §5 is a further fine class, and its converse fails on `Oscillating`.

Figures at the build (`scratch_build.py`): `Becoming.MapRegions` has 39 theorems in 45 declarations and `Becoming.WideningOnTheMap` 43 theorems in 52; every axiom report is empty and there are no warnings. No earlier module's statement changed. Besides the two leaves, two files changed:
- `Becoming.lean`: the imports, the two new bullets, and the bullets of KeepingWidening and HeldPossible brought up to GW3–GW5;
- `check_becoming.py`: the core list and the scope.

## 19. The review of the Lean, and how each finding was taken

The review is [REVIEW-GW126-LEAN.md](REVIEW-GW126-LEAN.md) (Claude Opus 5.5, read-only, 30 October 2026, of the two modules as first built on `6376f0da3`). It found every theorem proving what its own statement says, with no hidden hypothesis and no high finding. It made six medium findings and fourteen low ones, and its scratch Lean is in its appendix. Every finding was taken, one of them in part.

| Finding | Taken as |
|---|---|
| 1 `dec` stronger than needed | `wdec : ∀ n x, ¬ Q n x ∨ ¬¬ Q n x` throughout. `Steps.forward_iff_wem` uses hand arithmetic (`Steps.arriving`, `Steps.twice`), with an empty report. The Standing states the need. |
| 2 LPO not strongest | `Map.«后守之定则LPO»` (pointwise, on 后守) and `Map.«生成之定则WLPO»`; §10's form is now a corollary. The docstring states the Σ⁰₂ decision, with LPO as the part derived. |
| 3 the single-line readings | `Map.generates_iff_changes` and `Map.keepsAfter_iff_settles`, with `Map.step_reaches_of_le` and `Map.step_family`. |
| 4 exactly loss needs the premises | `Steps.keepsWidening_iff_generation_losing_nothing`. The bullet, the record and the documents name the premises. |
| 5 "keeps each, generates the whole" | Renamed `Web.kept_by_name_and_generation_on_moments`, with the reviewer's docstring, and recorded as a corollary in the record's World law. "Generates the whole" is dropped from the module, the record, 07 and D65's paragraph (now titled "on a course's moments"), and the board's history row says "two carriers". |
| 6 `kept` | `Steps.includes`, `buqiong_includes_iff`, `includesFrom_iff`, `same_includes`, `includes_refl`, `includes_trans` and `Arriving.includes`. |
| 7 twin of the landed chain law | `Steps.keepsWideningFrom_iff_shift`, from which `Web.keepsWidening_itself_iff` is derived through `Web.keepsWidening_iff_chain`. `keepsWidening_iff_from_zero` keeps its own proof: through the shift, the zero case needs `fun n => Q (0 + n)` read as `Q`, which takes function extensionality. |
| 8 wording | "in none of". |
| 9 wording | The leaf's reason is stated. |
| 10 `located` | `Steps.change_located` returns `n < S + d`, `¬ Q n x` and `¬¬ Q (n + 1) x`. |
| 11 name | `Steps.includes_not_back_of_generation`. |
| 12 `found` | Worded as asked, and the listing clause says "with what is held decided". Added `Steps.back_iff_em`, and `Steps.markov_of_keepsWidening_of_generation` from the reviewer's `rv_markov_of_converse`. Not taken: restricting `wdec` and `found` to `N ≤ n`. A course read from `N` is the chain shifted by `N` (`Steps.keepsWideningFrom_iff_shift`), where the premises already start at `N`. |
| 13 a preorder in the coarse place | Said so, with the reason, in the module, the record and 07. |
| 14 the held class | The Standing's last sentence as suggested. |
| 15 the instance claim | The clause is dropped from the module, the record and 07. |
| 16 `Growing` at 0 | Now takes `(N : Nat)`. |
| 17 duplicated lemmas | The docstring cites `Settling.OneWay.lpo_of_settles` and `Becoming.LPO`, and says the coding repeats Settling's first-hit search. The reach twins (`Map.step_reached_le`, `Steps.reached_le`, HeldPossible's local lemmas) are noted for the next rebuild of GrammarMap or Arising, on the board's history row. |
| 18 generic names | `Steps.reaches_of_buqiong`, `Steps.generation_includes_iff`, `Steps.change_located` and `Steps.new_in_list_or_none`; the LPO coding moved to `Map.Settles` (`seen`, `turning`, `sequence`). |
| 19 GrammarMap's stale sentence | Recorded on the history row for GrammarMap's next rebuild; GrammarMap is not changed. |
| 20 后守's docstring | "From a point of that branch reached from `x`", in the module, 02 and the record. |
