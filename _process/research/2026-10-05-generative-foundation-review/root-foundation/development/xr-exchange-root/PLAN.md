# XR: the base re-rooted at one relation of exchange

**Superseded** by the [one-unfolding root plan](../one-unfolding-root/PLAN.md): exchange presupposes two parties, so rooting at a relation of exchange put the duality back at the root. Kept as the record of that step.

AI-written plan, 22 October 2026, drafted at Ren's request in the session "Theory status and claims". Not claimed on the board; nothing here is a result. Main at drafting: `018d2c263` (XL4 landed, core receipt `20261022T151214.034215Z`).

## 1. Why

The theory was set to begin from one relational unfolding: first how relations form, persist and change, then how actor, patient, knowing and evaluation differentiate within it; and to state the strongest laws with no premise, each as "Y iff Z" with Z a local fact about the world. The logic kept that discipline: the core imports only the prelude, every axiom report is empty, and the premises were localized into exact laws.

The base did not. A `World` is one kind of relatum with eight separately chosen fields: at each step `level`, `active`, `requires`, `need`, `draws` (`WebAt`), and across it `present`, `take`, `give` (`Exchange`). Levels and needs stand beside the relations as given numbers. The work since has shown that most of these fields are readings of one exchange:

- activity is exchanging, drawing is taking (`Flow.Exchanging`, `Flow.readOff`; P107, study §125);
- under a law, levels are the start carried by what is given and taken (`ExchangeLaw.levels`, `ExchangeLaw.course`), so balance holds by construction with the rest counted (`Flow.withImbalance_balances`, `World.withRest_balanced`);
- requirement is necessary response, and that is the weakest sound local reading (`ExchangeRelation.respondsBelow_weakest`, XL4, study §369);
- five of the eight World premises hold by construction and three are states of the law (`ExchangePremises`); the 33 central declarations that take a tying premise have forms over every relation of exchange (`Becoming.OverExchange`, XL1).

But these were built as readings and bridges beside `World`, and `World` stayed the base and the import root (W, study §180). So the theory is stated over eight fields while its own results say one relation suffices for most of them. The master laws (EC5, study §317) were then found by inspecting 127 results, the reverse of the order the theory set: origin, then laws, then corollaries. Meanwhile the central coverage grew with model families (regime margins, optimizer courses), so Degeneration carries 20 central declarations and Generation 5.

XR restates the theory in its intended order: one relation of exchange; what is defined from it; what stays a commitment of the representation; the master laws as theorems of that relation; the central results as their corollaries; applications in their own ring.

## 2. The root

**The relation.** `ExchangeRelation R R` over one kind of relatum: at each step, under a history of standings, which exchanges (what each relatum takes from and gives to each) are open (`admits`). It is the most general form the core has:

- a law of exchange is a relation leaving one exchange open (`ExchangeLaw.readWorld_readOffExchange`);
- a law with noise is a relation, every realization's course a run of it (`NoisyLaw.course_runs`, XL4);
- several open exchanges are branching, which a process reads (`Generative.Process`): the runs of a relation are a process whose configurations are standings and whose moves are exchanges.

**Defined from it** (each already in the core unless marked new):

| Field of `World` | Definition from the relation | Lean | Standing |
|---|---|---|---|
| `take`, `give`, `present` | the exchange of a run | `ExchangeRelation.Runs` | the relation's own |
| `level` | the start carried by what is given and taken | `ExchangeLaw.levels`; for a relation, a run's history (new: `Runs` with standings generated rather than supplied) | definitional; balance by construction with the rest counted |
| `active` | exchanging: takes part and takes or gives something | `Flow.Exchanging` | definitional |
| `draws` | takes from | `Flow.readOff` | definitional |
| `requires` | necessary response: under every history differing only in that condition's level, below the need, no open exchange has it exchange | `ExchangeRelation.RespondsBelow` | definitional; the weakest sound local reading (XL4) |
| `need` | **new**: the greatest level below which the exchange necessarily stops, where it exists; otherwise kept as the family `RespondsBelow … n` over `n` | — | definitional where decided; the family form needs nothing |
| standing as a condition | positive level | `Web.Embodied` reads it | definitional |
| formation, condition | two roles of one relatum | `Becoming.Roles` | definitional |
| the process and the frame | the runs of the relation | `Frame.world_fixes_run` | definitional |
| own region, scope | the closure along a sub-relation of the exchange | `WithinClosure`, `forced_iff_within` (EC4) | definitional |

**The start.** Two options, a decision for Ren (§7, D-b): (i) the start levels stay given, one supplied field; (ii) the start is what the rest of the whole gives at the first step, so every standing is carried by exchange and nothing stands that was not given. Option (ii) removes the last supplied number of the base and makes "nothing comes from nothing" exactly the rest being idle after the start.

**Irreducible commitments** (the representation; each disclosed in §0 block A, none an axiom):

1. *One kind of relatum and its naming.* Which relatum continues which is fixed by the type (`Becoming.Identity`); continuation across splits and merges is read where needed (R48–R50).
2. *Discrete steps on one index.* For local exchanges the index is read off each relatum's own steps (`Interleavings.LocalLaw.world_index`); what happens within a step is not shown.
3. *Whole amounts.* Rest and dissipation laws have forms in any amounts (`Becoming.InAmounts`, `Amounts.rests`), and the periphery represents real time and amounts for balance (XL2); the core keeps natural numbers.
4. *Finite support where counting is needed.* Exchanging is `∃ c, 0 < take ∨ 0 < give`, decided wherever what a relatum exchanges with is listed; the census becomes finite support of the exchange, a state, not a field.
5. *Locality of requirement.* The one warrant XL4 left: that requirement reads the exchange's response to the required condition alone.
6. *Which relation holds.* Not a commitment of the theory but the content of a particular becoming (§8.1 item 7): the laws hold over every relation, or over a stated class (laws, local relations, noisy laws).
7. *Logic.* Prelude only, empty axiom reports, classical principles as hypotheses (§8.6).

The ethics' parameters (`sig`, the continuation condition, C) stay supplied: no law of the dynamics fixes significance (`Web.significance_undetermined`), so no re-rooting changes that.

**The World premises become states of the relation.** With the readings definitional, the four tying premises (balance, only active giving, only active taking, activity needing support) are no longer premises. What remains are states of a relation or a run: the rest idle (closure; for a law, feasibility), dissipation (loss), embodiment (no dormancy), bounded transmission (heredity of response), finite support (the census).

## 3. The transfer: one theorem instead of eleven thousand

Re-rooting the import tree moved 203 declarations in W2 at large cost. XR does not move the 11,552 theorems. It proves that the worlds read off a relation are exactly the worlds the World laws already cover under the tying premises, so every World theorem transfers through one theorem.

- **Conjecture XR-T** (to check first, Lean): `w.ReadOffExchange ↔ w.withRest.Dependent`. Backward: the relation that admits, at the actual history only, the world's actual exchange; a requirement met wherever the relatum exchanges is then a necessary response of it. Forward: `World.ReadOffExchange.dependent`, landed.
- **What XR-T would show.** That *some* relation of exchange can be read off a world carries no more than "every relatum that exchanges meets its requirements". The content of the root lies in the class of relations a law ranges over (laws of exchange, local relations, noisy laws), not in the existence of a relation. The plan states the central laws over every relation and, where a law needs more, over a named class: that is where the substance of each law is located.
- With XR-T, a World law under balance, the two activity premises and activity needing support holds of every run of every relation with its rest counted, by `withRest` and XR-T; the 33 forms of `Becoming.OverExchange` become instances of one transfer rather than 33 restatements.

If XR-T fails, the gap is itself a result: a world whose requirements are met yet are no necessary response of any relation would show requirement carries content the exchange does not; the plan then states the root over the worlds it covers and records the remainder.

## 4. The master laws as theorems of the relation

Each master law is restated at the root, the existing anchor its instance (board rule 9: the general law lands below and proves the special one).

| Law | At the root | Status of the law there |
|---|---|---|
| Balance | a run's standings are the start carried by its exchange; across every stretch, by the stretch sum (`balance_over_stretch_on`) | definitional; what was a premise becomes the rest being idle, a state |
| Closure | the closures of the relation's sub-relations: giving (feeding), response (influence), response with reading (coupling), and their union (system); a run's reach is the closure of its steps | theorem with no premise (EC1's closure, now over sub-relations of one relation) |
| Finite runs | over finitely many standings, a run of a relation returns to every configuration or is drawn; rest where an amount's falls stop | theorem with no premise (pigeonhole on the relation's runs), finiteness stated in Z |
| Lumping | a family of relata carries a relation of its own exactly where the exchange restricted to it reads nothing beyond it | exact characterization (`GoAlikeUnder` restated for a sub-family of a relation) |
| Order | widening over what the relation's runs admit: retaining every admitted event and adding one | definitional order with no premise; the ethics adds the condition for scope and C for order |

Two questions XR settles or states, from the earlier reading of the master laws:

- *Are the five independent?* Finite runs may be closure on the relation's configuration graph with counting, and lumping the closure of "goes alike". XR states each at the root and either derives one from another (fewer master laws) or records why it does not reduce.
- *Is lumping a master law?* It carries one central declaration today. At the root, learning, selection's reach and capture are its cases; if fewer than three central declarations rest on it after Phase 3, it is stated as a law of the closure family, not a master law.

## 5. The central coverage: origin, laws, domains; applications apart

`COVERAGE.json` gains a tier for each row, and K1 checks the first three.

1. **Origin** (new rows): the relation and its readings (§2), the transfer (§3).
2. **Master laws**: the five, at the root (§4).
3. **Phases, differentiations and domains**: each central declaration is a law over every run of every relation, or over a named class, with its local condition inside it; each names the master law it instantiates or why it is definitional (the stopping rule of §6).
4. **Applications ring** (outside K1): laws of a particular model family, with their records and tests. They stay in the core with empty axiom reports and are checked as now; they leave the central count.

First classification, provisional (each confirmed when its step is claimed):

| To the applications ring | Central declarations now | Reason |
|---|---:|---|
| `RegimeMargin.*` | 7 | one family of stock-and-draw regimes, fitted to yeast and fish data |
| `Optimum.*`, `Web.optimum_broken_iff`, `Web.course_lost_iff`, `Web.frontier_*`, `Web.Next.frontier_ends_drawn_first` | about 10 | optimizer courses of the SG series; the general law they instance, selection through couplings (`Flow.unselected_beyond_coupling`), stays |
| `Drift.falls_back`, `SelectionLevels.levels_sized` | 2 | particular forms of the selection term; `SelectionTerm.covariation` stays as the general law |
| the hexagram, place/transition and valuer modules | 0 central today | already outside the coverage (the checker's `INSTANCES` ring); recorded as applications by name |

Stays central, with its master law to be named: the rest of Degeneration (consumption ends with feeders, dissipation opens, taking all excludes, outrun below), evolution's general laws (selection within support, transmission, the selection term), learning, the collective laws that hold over every run (mutual dependence as reach, relative position as balance, capture through the rule). After the move the rows are roughly even: Degeneration from 20 to about 6, Alignment from 18 to about 9.

## 6. Stopping rule

- The target is frozen at the commit where Phase 1 lands: the coverage list as reclassified by §5 and the master laws as stated by §4. Results landing later join the next round.
- Each central declaration ends in one of three states: derived through a master law at the root; definitional, with a one-line reason; or its own law, with a one-line reason why no master law carries it.
- A rederivation counts only if it removes a premise, shortens the statement or the proof, or replaces a direct proof by an instance. Routing a proof through an anchor to raise the measure does not count.
- A master law is kept only if at least three central declarations rest on it.
- XR is complete when every central declaration is in one of the three states and the chapter states the theory in this order. Elegance beyond that is a later item, not part of XR.

## 7. Decisions for Ren

- **D-a. Re-found the representation.** On 11 October re-founding the representation was kept as Ren's decision. XR makes `World` a reading of a relation rather than the base. The theorems are unchanged; the statement of the theory and §0 change.
- **D-b. The start.** Given (one supplied field), or what the rest gives at the first step (§2).
- **D-c. Scope of the root.** The theory stated over every run of every relation, with the narrowing exact by XR-T; or `World` kept as the general case and the relation its main instance. Recommended: the first, since XR-T would make the narrowing loss-free for every law under the tying premises.
- **D-d. Applications out of the central count.** K1 then measures the origin, the laws and the domains; the applications keep their records and receipts.
- **D-e. EC.** XR overlaps EC's remaining 63 declarations. Recommended: EC's owner (line D) and XR agree on the board that EC's remaining steps are taken at the root, under XR's stopping rule, rather than as a parallel route.

## 8. Phases

Each phase is claimed on the board before its Lean and lands through the queue. Estimates assume one session and the checker's reuse of passed steps; they are rough.

| Phase | Work | Output | Estimate |
|---|---|---|---|
| 0 | Read study §125 (P107), §180 (W), §364 and §369 (XL1, XL4) for what each decided and why `World` stayed the base; inventory each of the 127 central declarations: holds at the root directly, through the transfer, needs a state of the relation, or goes to applications | inventory table in this kit; study section | 1 day, no Lean |
| 1 | The root module below `Becoming.World`: `ExchangeRelation` and its runs moved down unchanged (board rule 8: original statements kept), standings generated by a run, `need` as the greatest responded level where decided, the start per D-b; prove XR-T | new module; XR-T or its counterexample | 1–2 days |
| 2 | The five master laws at the root, each existing anchor its instance; the independence question of §4 | one module or one section per law | 2–3 days |
| 3 | The central declarations through the transfer and the master laws, under the stopping rule; EC's remaining steps folded in (D-e) | records updated; connectivity measure | depends on the inventory; at EC's pace, about a week |
| 4 | `COVERAGE.json` tiers, the applications ring, `completion.py` and its tests | K1 over the first three tiers | 1 day, tools only |
| 5 | The chapter restated in order: §0 block A as the relation and its commitments, block C as states of the relation, the theorem map by master law, README's opening scope checked against the root | chapter (EN, ZH), README via its sources, render, check, links, test | 1–2 days |

Total: about two to three weeks of one session, most of it Phase 3, and less if XR-T holds and the inventory finds most declarations transfer directly.

## 9. What XR does not do

- It does not prove the necessity of the whole: that every actual becoming has a relation of exchange of this kind stays §8.1 items 1 and 7 and §8.5.
- It does not warrant locality of requirement, the continuation condition or C; it locates each at the root.
- It does not remove the representation's commitments of §2; it names them as the only ones.
- It moves no theorem file and renames nothing that states its meaning correctly; `World` and its laws stay, read as the root's instance.
- It does not reopen landed results: each keeps its scope and gains, where it applies, a statement at the root.
