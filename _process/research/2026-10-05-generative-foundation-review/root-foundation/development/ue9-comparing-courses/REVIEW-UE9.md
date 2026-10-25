# UE9 review: comparing two courses on what they admit (26 October 2026)

This is an AI-authored independent review of board item UE9 as committed at `6acecdd20`. It covers three files:

- [NOTE.md](NOTE.md), sha256 `cd057917…599fabdd`;
- [tree/Becoming/ComparingCourses.lean](history/ComparingCourses.lean) (now in the kit's history), sha256 `5a952632…de3b55a9`;
- [scratch.log](scratch.log), sha256 `423e45ad…3a09f67d`.

They were read with [AGENTS](../../../../../../AGENTS.md); rules 8 and 9 and the UE9 row of the [work board](../../../../../BECOMING-WORKBOARD.md); [07 §2](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-eventual-widening) and [07's Open list](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#open); the [glossary](../../../../../../GLOSSARY.md); the [eventual-widening record](../../../../../../theories/becoming/results/records/eventual-widening.md) and [UE4's design](../ue4-second-order/DESIGN.md); and the package modules `Regions`, `Admission`, `Identity`, `ContinuedClasses`, `EventualWidening`, `EventualWideningInstances` and `OwnWidening`.

**How it was checked.**

- **Rebuild.** `python3 -B scratch_build.py <kit>/tree Becoming.ComparingCourses` was run twice.
  - The first run reused every step from the cache, so its inputs were those of the kit's own build (main at `c8bd66581`).
  - Main has since changed or added 14 modules in the kit's import closure, in the landings of OU3b and DF1 (among them `Regions`, `Admission` and the new `GrammarLaws`). So it was run again on main at `8460f56c0`. It compiled the module and its audit with no warning or error: 58 theorems in 70 declarations, every axiom report empty, 67 modules in the closure.
  - A byte-identical copy (same sha256) was compiled fresh with Lean 4.29.1 in the session scratchpad against that build (`fresh2/`, volatile), with no warning or error. An environment audit (`collectAxioms` over every constant the module adds, auxiliary ones included) found 95 constants, 58 of them theorems, none depending on any axiom. The source has 58 theorems and 12 definitions, as the NOTE says.
- **Probes.** One scratch module imports the kit and is given in full in the [appendix](#appendix-the-probes) (sha256 `4e01cc51…0451e267`). The same audit, on both builds, finds 196 constants, 86 of them theorems, none depending on any axiom.
- **Sources.** These were checked by standard web search only. No PDF was fetched, and no file was saved automatically. Several sources were seen only through abstracts or later papers; [check 5](#the-seven-checks) says which.
- No repository file other than this review was created or changed. The rebuild wrote only into `tree/.build` and the shared step cache. Nothing was committed.

## Verdict

The Lean is sound and the core stays pure:
- every statement the NOTE quotes is the module's;
- each witness meets its hypotheses together, so no law is vacuous;
- the module builds unchanged on current main, and nothing gets past the axiom report.

The three laws are near-definitional, as the NOTE grades them. What the NOTE draws from them goes further than the Lean in five places, and one inference is false:

- **The exchange (O1, O5).** Take the class law: no strict partial order containing widening ranks every course keeping widening above every static course that was wider at first and is mixed with it. It needs no invariance at all, because the mirrored pair is itself in the class. The exchange matters only for a single pair. Nor does it read "counting neither novelty nor scale": an order that counts scale meets every hypothesis.
- **Scope (O4).** The cycle needs a static course admitting infinitely many formations. With the static course's admissions listed, the ranking is consistent on every web.
- **The lag (O2, O3).** The lag can also be decided on the tail side, by an order containing eventual widening, so deciding it does not force the choice the NOTE names. The lag order is unchanged by renamings constant across steps, but it reads names across steps, where widening does not.
- **Silence (E1).** Law (1) forbids one verdict on its pair. The reverse verdict is consistent with every premise, so "by (1) it must be silent" is false; the lag order is silent for its own reason.

The uniform lag does not matter for laws (2) and (3) (I5), and four neighbours are misdescribed (I1–I4).

**Land after named fixes:** E1, O1–O5 and I1–I6 are required; the rest are recommended.

**Counts:** 1 error, 5 overclaims, 6 imprecisions, 7 suggestions.

## Findings

Each finding gives its location, what is wrong, and a fix. The wording of a fix may be taken as written or in words that say the same. Line numbers are those of the committed files. Parts A1 to G are those of the [appendix](#appendix-the-probes).

### Errors

**E1. Law (1) forbids one verdict on its pair, not both.**
- *Location.* NOTE §2, law (2), "Where it decides and where not", second bullet (line 49). The UE9 row of the board: "widening with a lag shown silent where the cycle forbids a verdict".
- *What is wrong.* The NOTE says: "By (1) it must be silent between the growing course and the other". Law (1) excludes only one verdict, the growing course ranked above the other. A strict partial order containing widening and unchanged by the exchange can rank the other course above the growing one. Part A2 builds one (`Sides.reverse_consistent`), and part G another (`Sides.scale_counts`). Widening or widening with a lag is silent both ways for its own reason. The growing course never admits `(false, 0)`, which the other admits at step 0, and the other never admits `(true, 1)`, which the growing course admits at step 1; so neither includes the other at any lag. `Sides.silent` proves this directly, and the module docstring (lines 29–30) states it without the inference.
- *Fix.* Write: "By (1) it cannot rank the growing course above the other. It is in fact silent both ways (`Sides.silent`), since neither includes the other at any lag. (1) does not require this: a strict partial order containing widening and unchanged by the exchange can rank the other course above the growing one." In the board row, write "where the cycle forbids one verdict".

### Overclaims

**O1. The class law holds without the exchange; only the one-pair law needs it.**
- *Location.*
  - NOTE §2, law (1): the sentence after the code (line 31) and "What each premise does" (lines 33–34).
  - NOTE §3: the first "Shows" bullet (line 62) and the third "Does not show" bullet (line 68).
  - NOTE §4, the Suzumura sentence (line 75), and §6, 07's Open item (line 95).
  - The module docstring (lines 16–19), and `Sides.no_order_ranks_keeping_over_alike` (lines 245–254), which takes `exchanged`.
  - The board row, statement (1).
- *What is wrong.* The mirrored pair, `swap growing` and `swap firstAndOther`, is itself in the class that `RanksKeepingOverAlike` quantifies over. It keeps widening by name from the first step, admits alike, is wider up to the first step, and is mixed (part A1). So ranking the whole class already supplies the second ranking that the exchange was used to produce. Irreflexivity, transitivity and containing widening then suffice: `Sides.no_order_ranks_keeping_over_alike'` proves the class law with no invariance hypothesis. The exchange is needed only by the one-pair law (`keeping_over_alike_cycles`), as `exchange_needed` shows. So the class law is not "cyclic under renaming"; it is cyclic. The third "Does not show" bullet is wrong for the class law, which holds for comparisons not invariant under renaming.
- *Fix.*
  - Drop `exchanged` from `no_order_ranks_keeping_over_alike`, taking part A1's proof and its lemmas on the mirrored pair. Keep the hypothesis in `keeping_over_alike_cycles`.
  - Restate: "No strict partial order containing widening ranks every course keeping widening by name from the first step above every course that admits alike, was wider up to the first step and is mixed with it. For one pair: a transitive relation containing widening and unchanged by exchanging the sides, which ranks the growing course above the other, ranks it above itself; without the exchange that one ranking is consistent (`exchange_needed`)."
  - Under "What each premise does", name irreflexivity, transitivity and containing widening for the class law, and the exchange for the one-pair law.
  - In §3, delete "and unchanged by renaming formations" from the first bullet, and "or not invariant under renaming" from the third. In §4, delete "and closed under renaming". In §6, write "is cyclic", with O4's scope.

**O2. The lag can be decided on the tail side; deciding it does not exclude eventual widening.**
- *Location.* NOTE §3, the second "Shows" bullet (line 63); §6, 07's Open item (line 95: "the lag is decided by widening with a lag, which excludes eventual widening"); the module docstring (lines 33–34).
- *What is wrong.* Law (3) shows that widening with a lag and eventual widening exclude each other. It does not show that deciding the lag forces counting early steps.
  - Take inclusion with a lag from some step on (part C, `Web.TailLag`): from some step `T`, every formation `l'` admits, `l` admits `d` steps later.
  - Join its strict part to widening or eventual widening. On every web the result is a strict partial order containing both widening and eventual widening (`Web.tailOrder_order`).
  - It ranks the lagging course above the travelling one, where neither eventually widens the other (`LagWitness.tailOrder_decides`).

  So the lag is decided on either side. "One renaming-invariant strict partial order containing widening decides UE4's lag: widening with a lag" is true only as "one such order is". The choice the NOTE names is real, but it is a choice between the two relations, and the lag does not make it. It matters for 07 §2. Calling the tail order better would inherit what calling eventual widening better does: every loss confined to a finite stretch ranked below one formation more at arbitrarily late steps. Calling widening with a lag better would not.
- *Fix.* Write: "Widening with a lag decides UE4's lag. So does the strict part of inclusion with a lag from some step on, joined to widening or eventual widening, which contains eventual widening (review, part C). Widening with a lag and eventual widening exclude each other (law 3). A comparison that counts what early steps admit and one that reads only tails part there, and the lag does not choose between them." Change §6 and the docstring to match, and see S4.

**O3. The lag order is unchanged by renamings constant across steps, but it reads names across steps.**
- *Location.* NOTE §3, the second "Shows" bullet (line 63: "One renaming-invariant strict partial order"); the board row, statement (2): "invariant under renaming". §2's "Invariance" (line 46) and the module docstring (line 26) are exact.
- *What is wrong.*
  - The kit proves invariance for one exchange on one web (`Sides.widensOrWithLag_swap`). The witness that decides the lag lies on another web, where nothing about invariance is proved.
  - On every web, re-identifying formations by a renaming constant across steps leaves the order unchanged (part F, `Web.widensOrWithLag_rename`, from part B's `Web.includesLater_rename`).
  - A re-identification that varies with the step can change it. On a web of two formations, `later` widens `once` with a lag. Once the two names are exchanged from step one on, it does not. Widening is unchanged by every re-identification (part B, `Relabel.lag_reads_names`, `Web.widens_reidentify`).
  - The reason: inclusion with a lag compares a formation at step `t` with the formation of the same name at step `t + d`. Identity across steps is read by name, as in keeping widening along `itself`. The package states comparisons across steps along a continuation (`IncludesAcross R`, `keepsWidening_reidentify`); the kit's lag is the by-name case without saying so.
- *Fix.* Write "unchanged by every renaming constant across steps". Add to §5's modelling list: "the lag compares formations across steps by name". Or state the lag along a continuation (S3).

**O4. Law (1)'s cycle needs a static course admitting infinitely many formations.**
- *Location.* NOTE §2, law (1) (lines 13–31); §3, the first "Shows" bullet (line 62); §5's modelling list (lines 86–89); §6 (line 95).
- *What is wrong.* `firstAndOther` admits every `(false, n)`. If the static course's admissions are held by a list, the ranking is consistent on every web (part A3).
  - `Web.ListedOrder` is widening, joined to one more ranking. For each pair of the class whose static course has listed admissions, every course that includes its keeping course is put above every course that its static course includes.
  - It is a strict partial order containing widening, and it ranks every such pair. Irreflexivity and transitivity come from the pigeonhole of `KeepsWidening.gathers`: a listed static course includes no course keeping widening by name.
  - On the two-sided web it ranks the growing course above `firsts` (the first formation of each side, at every step). There widening or eventual widening is silent both ways (`Sides.listed_consistent`).

  So "the second-order comparison 07 asks for cannot be 'a course that keeps widening is better than one that admits alike and was wider at first'" holds only where one merely wider now may admit infinitely many formations at once. Whether `ListedOrder` is unchanged by the exchange was not checked; by O1 the class law needs no exchange.
- *Fix.* Add the scope: "where the static course admits infinitely many formations; with its admissions listed, the ranking is a strict partial order containing widening on every web (review, part A3)". Add the same to §5's list. **[AI reading]** The cycle is driven by scale: an infinitely wide static course and a growing course each widen the other's mirror.

**O5. The exchange admits an order that counts scale; it does not read "counting neither novelty nor scale".**
- *Location.* NOTE §2, law (1), "Reading" (line 35); §3, the first "Shows" bullet (line 62).
- *What is wrong.* Renaming leaves counts unchanged, so a comparison by how many formations each course admits is unchanged by it. Part G makes this exact.
  - Say that `a` has at least the scale of `b` when, at every step, a map that is one to one on what `b` admits carries it into what `a` admits.
  - Widening joined to the strict part of this preorder is a strict partial order containing widening and unchanged by the exchange (`Sides.scale_counts`).
  - It ranks the other course above the growing one, by scale alone.

  **[AI reading]** Nor does the exchange bear on novelty: a renaming constant across steps maps what is new at each step to what is new at that step. What the exchange states is that no formation counts by its name: impartiality across formations, the relative anonymity of social choice (I1).
- *Fix.* Write: "Reading. The exchange states that no formation counts by its name (relative anonymity across formations). It does not exclude counting scale (review, part G), so 07's 'counting neither novelty nor scale' needs another reading (S6)." After O1, the exchange no longer appears in §3's class statement.

### Imprecisions

**I1. The symmetry is relative anonymity, not neutrality; Diamond and Basu–Mitra are distant.**
- *Location.* NOTE §4, second bullet (line 76).
- *What is wrong.*
  - In social choice, neutrality permutes the alternatives ranked. Anonymity permutes the coordinates of each alternative: voters, generations, locations.
  - Renaming formations permutes the coordinates of a course, so it is of the anonymity kind. Applied to both sides of a ranking (`R a b → R (σ a) (σ b)`), it is "relative anonymity" or "permutation invariance". Goodman and Lederman (2024, arXiv 2408.05851) use the second name, and report that Sen (1984) called it anonymity and Asheim and others (2010) relative anonymity.
  - Diamond (1965) and Basu and Mitra (2003, *Econometrica* 71(5): 1557–1563) use finite anonymity, an indifference axiom (a stream and its finite permutation are equally good), with Pareto. Their impossibility comes from continuity or real-valued representation. Neither concerns a required ranking or an incomplete order.
  - The closest statement found is Askell (2018, NYU thesis, *Pareto Principles in Infinite Ethics*), seen in its abstract and secondary summaries only. There the Pareto principle, transitivity, permutability of populations and invariance across qualitative duplicates jointly imply ubiquitous incomparability between infinite worlds. Law (1)'s one-pair form has that shape on admitted ranges, in one direction only (E1).
- *Fix.* "The exchange is relative anonymity (permutation invariance) across formations. Law (1)'s one-pair form has the shape of Askell's (2018) incomparability argument from Pareto, transitivity and invariance across qualitative duplicates. Diamond (1965) and Basu and Mitra (2003), on finite anonymity with continuity or representation, are distant."

**I2. Chichilnisky's dictatorships fit one of law (3)'s orders, not both.**
- *Location.* NOTE §4, second bullet (line 76).
- *What is wrong.* Eventual widening is decided by tails: paths that agree from some step on have the same verdicts (landed `EventuallyWidens.of_agree_left` and `.of_agree_right`). That is the analogue of a dictatorship of the future. **[AI reading]** Widening with a lag is not a dictatorship of the present. Its inclusion quantifies over every step, the tail included, so no finite stretch decides it. Chichilnisky's axioms (1996, *Social Choice and Welfare* 13(2): 231–257) concern complete, numerically represented orderings.
- *Fix.* "Chichilnisky (1996): eventual widening is decided by tails, like a dictatorship of the future; widening with a lag constrains every step and is not a dictatorship of the present."

**I3. Delayed simulation delays acceptance, not inclusion.**
- *Location.* NOTE §4, third bullet (line 77).
- *What is wrong.* Etessami, Wilke and Schuller (ICALP 2001; *SIAM J. Comput.* 34(5): 1159–1175, 2005) define delayed simulation as a game on Büchi automata.
  - Moves are matched step by step. Each visit to an accepting state must be answered by a visit to an accepting state at the same or a later step, with no bound.
  - It under-approximates language inclusion. Quotienting by it preserves the language, which fair simulation does not.

  The analogue of its unbounded delay for each obligation is a lag for each admission (part B, `Web.IncludesEachLater`). A uniform lag is closer to bounded lookahead in delay games (Hosch and Landweber 1972; Holtmann, Kaiser and Thomas, *LMCS* 2012).
- *Fix.* "Delayed simulation for Büchi automata (Etessami, Wilke and Schuller 2001) answers each acceptance at the same or a later step, without bound, like a lag for each admission. Delay games with bounded lookahead (Hosch and Landweber 1972) are closer to a uniform lag."

**I4. Overtaking and catching up are attributed to Atsumi and von Weizsäcker, and they compare sums.**
- *Location.* NOTE §4, third bullet (line 77).
- *What is wrong.* The sources found attribute both criteria to Atsumi (1965) and von Weizsäcker (1965, *Review of Economic Studies* 32: 85–104), refined by Gale (1967, *Review of Economic Studies* 34(1): 1–18) and Brock (1970). None states Gale's own definition. Both compare partial sums of utility from the first period over late horizons. They are scalar comparisons that count scale, distant from inclusion with a lag.
- *Fix.* "Overtaking and catching up (Atsumi 1965; von Weizsäcker 1965; refined by Gale 1967 and Brock 1970) compare partial sums over late horizons: scalar, and distant."

**I5. The lag's form does not matter for laws (2) and (3).**
- *Location.* NOTE §5, last bullet (line 89); the board row, statement (2): "inclusion with a fixed delay".
- *What is wrong.* Part B checks two other forms: a lag varying with the formation (`IncludesWithFormationLag`), and a lag for each admission (`IncludesEachLater`).
  - Each is again a preorder containing inclusion, and the strict part of any such preorder, joined to widening, is a strict partial order (`Web.strictJoin_trans`, `strictJoin_irrefl`).
  - Each decides the lag (`LagWitness.formationLag_decides`, `eachLag_decides`).
  - Each conflicts with eventual widening on the same witness (`TailAndLag.formationLag_conflict`, `eachLag_conflict`).

  The kit rightly takes some lag, not one fixed lag: composing two inclusions with lag `d` gives lag `d + d` (`IncludesLater.trans`). So the board row's "a fixed delay" does not describe the kit.
- *Fix.* In §5, write: "the lag's form: laws (2) and (3) hold as well for a lag varying with the formation or with each admission (review, part B)". In the board row, write "inclusion with some lag".

**I6. Law (3) is stated on one web.**
- *Location.* NOTE §2, law (3), "The law" (line 56); the module docstring (lines 31–33); the docstring of `TailAndLag.no_order_contains_both` (line 470).
- *What is wrong.* The theorem concerns the level paths of `OwnCondition.web`. Unqualified, "no strict partial order contains both" reads as a law of every web.
- *Fix.* "On the own-condition web, no strict partial order contains both eventual widening and widening with a lag."

### Suggestions

**S1. Reuse two statements that already exist.** `Delayed.rising_iff` (kit line 375) restates `OwnCondition.rising_iff` (EventualWideningInstances.lean:232) with the same proof, and `Delayed` already opens `OwnCondition`. `Sides.not_not_bool` (line 282) restates the prelude's `Bool.not_not`, whose axiom report is empty (checked). Dropping both gives 56 theorems in 68 declarations. `Sides.web` is `OwnCondition.web` on the carrier `Bool × Nat`; one own-condition web over any type would serve both, if the owner of `EventualWideningInstances` agrees.

**S2. One order lemma.** Part F's `Web.strictJoin_trans'` says: a transitive relation contained in a preorder, joined to the preorder's strict part, is transitive. Where the relation is widening, part B's `strictJoin_irrefl` gives irreflexivity.
- `WidensOrWithLag.trans` is its instance (`WidensOrWithLag.trans'`).
- So are the tail order (`TailOrder.trans'`), the other lag forms (part B), the lag along a continuation (part F) and the scale order (part G).

NOTE §4 already describes law (2) as "the strict part of a preorder joined to widening". Landing the lemma below (in `Prelude`, or beside `Widens` in `Regions`) and deriving the kit's transitivity from it gives law (2) one reason (rule 9).

**S3. The lag along a continuation.** Part F defines `IncludesLaterAlong R d l l'`: each formation `l'` admits at step `t` is linked along `R` to one that `l` admits at step `t + d`. It proves four things:
- with widening, its strict part gives a strict partial order containing widening (`widensOrWithLagAlong_order`);
- by name, it is the kit's order (`widensOrWithLagAlong_itself_iff`);
- it is unchanged by every re-identification carrying `R` (`widensOrWithLagAlong_reidentify`);
- the verdict lost in `lag_reads_names` returns along the carried continuation (`Relabel.along_restores`).

It needs `Linked.append'` (links compose), which the package lacks. This puts the lag on the footing of keeping widening (`KeepsWidening R`, `keepsWidening_reidentify`) and answers O3 at its source.

**S4. The tail order.** Part C's `TailOrder` is the order that extends UE4's `WidensOrEventually` and decides the lag. If the record or 07 is to say where the lag can be decided, land it with O2's wording. If not, leave the lag out of the choice between the two relations.

**S5. The cycle as a law.** Part D's `Web.cycle_of_mirrors` holds on any web, for any map `σ` of level paths. A transitive relation containing widening and unchanged by `σ` ranks `l` above `l'` only by ranking `l` above itself, where `l'` widens `σ l` and `σ l'` widens `l`. `Sides.keeping_over_alike_cycles` is its instance. Landing the law with the instance under it follows rule 9.

**S6. A reading closer to "counting neither novelty nor scale"** [AI reading]. Rank `l` above `l'` only where `l` keeps what `l'` keeps: every formation `l'` admits at every step from some step on, `l` admits at every step from some step on (part E, `Web.KeepsWhatKept`). Neither novelty nor scale can then outweigh a lasting loss.
- Every order here meets it: widening or widening with a lag, and the tail order (`WidensOrWithLag.keepsWhatKept`, `TailOrder.keepsWhatKept`).
- Under it, law (1)'s pair is unranked both ways with no exchange, and part A3's ranking is excluded (`Sides.keeping_reading`).
- It is a necessary condition, not an order. It reads lasting admissions, so a loss confined to a finite stretch does not violate it. By itself it does not meet 07 §2's objection to eventual widening.

**S7. The leaf.** NOTE §6 gives a sufficient reason: the module holds comparisons and witnesses that no module below uses, and that C does not adopt. Rule 9 asks the board row to state it, for example "a leaf: alternative comparisons and their witnesses". If S2 or S3 lands, the general lemma and link composition belong below (`Prelude`, `ContinuedClasses`), and the leaf imports them.

## The seven checks

1. **Build and pure core.** Confirmed on main at `8460f56c0`: 58 theorems in 70 declarations, every axiom report empty. The fresh compile and the audit of all 95 constants agree.
   - The module imports one package module, `EventualWideningInstances`. Its import closure (66 modules) lies in the checker's CORE and FOUNDATION lists.
   - The source has no `sorry`, `native_decide`, `set_option`, `opaque`, `unsafe`, `partial`, `extern`, `implemented_by`, `macro`, `elab`, `axiom` or `instance`, and no tactic block: every proof is a term.
   - Decisions come from pattern matching on constructors. `Nat.noConfusion` after a case split replaces `Nat.succ_ne_zero`, as §5 says.
   - What no report catches lies in the modelling: §5's list, with the lag read by name across steps (O3) and law (1)'s infinite width (O4) added.
   - UE7, which lands first, moves laws into `Admission` and `Population`, both in this closure. The landing run rebuilds after it; `check_becoming.py` (its environment audit, controls and prelude-only compile) waits for landing.
2. **Lean against the NOTE.**
   - Every quoted statement matches the module word for word, implicit arguments aside.
   - Each witness meets its hypotheses together. The growing course and the other meet all four conditions of `RanksKeepingOverAlike`, so the class law is not vacuous. `LagWitness`, `Delayed` and `TailAndLag` show what their docstrings say.
   - No hypothesis hides in a definition: "by name" is `itself`, and the class's conditions are the four the NOTE names.
   - Conclusions are as strong as stated, with three exceptions. One inference is false (E1), one hypothesis is superfluous (O1), and one witness is stated as a law without its web (I6).
   - "Unchanged by renaming" goes beyond the one exchange in §3 (O3).
   - Eventual widening: `LagWitness.decided` and `TailAndLag.disagree` are correct, and so is the use of the landed `WidensOrEventually.irrefl` and `.trans`. The inference drawn from them in §3 and §6 is not (O2).
3. **07's ask.** Law (1) correctly states what one candidate cannot be: ranking keeping widening over admitting alike wherever the two are mixed. It locates less than stated.
   - The class form needs no exchange (O1), but needs an infinitely wide static course (O4).
   - The one-pair form forbids one verdict only (E1).
   - The exchange fairly reads "no formation counts by its name", not "counting neither novelty nor scale" (O5). A closer reading is S6.

   Natural restricted comparisons the laws do not rule out, each compiled in the appendix:
   - the ranking with listed static courses (A3);
   - the reverse verdict on law (1)'s pair (A2, G);
   - orders that count scale (G);
   - lags varying with the formation or with each admission (B);
   - the tail order (C);
   - the lag along a continuation (F).
4. **The lag.** These are correct: the order laws; never reversing widening (`Widens.not_reversed_withLag`, which follows from irreflexivity, transitivity and containing widening); the exclusion of eventual widening (law 3), with its witness. The uniform lag is immaterial (I5). Two points go beyond the NOTE: the lag is decided on the tail side too (O2), and the order reads names across steps (O3).
5. **Grades and neighbours.** The three laws are near-definitional, as graded. Law (1)'s one-pair form has a close prior shape (Askell); laws (2) and (3) have no closer neighbour than the table gives. "Seen" says how far standard web search confirmed each source.

| Neighbour | Seen | Relation to UE9 | Grade |
|---|---|---|---|
| Suzumura (1976), *Economica* 43(172): 381–390 | catalogue record and abstract; the theorem through later papers | Consistency (every cycle involves indifference only; "Suzumura consistency" after Bossert 2008) is necessary and sufficient for an ordering extension. For a strict relation it is the absence of cycles. Law (1) exhibits a cycle and uses no extension theorem. | vocabulary |
| Szpilrajn (1930), *Fundamenta Mathematicae* 16: 386–389 | publisher record | Every partial order extends to a total one, with choice. Not used. | vocabulary |
| Diamond (1965); Basu and Mitra (2003); Svensson (1980), *Econometrica* 48(5): 1251–1256 | Basu–Mitra's abstract; Diamond and Svensson through later papers | Finite anonymity and Pareto, against continuity (Diamond) or real-valued representation (Basu–Mitra); an ordering exists through Szpilrajn's theorem (Svensson). | distant (I1) |
| Askell (2018), *Pareto Principles in Infinite Ethics* | abstract and summaries; the construction not seen | Pareto, transitivity, permutability and invariance across qualitative duplicates force incomparability. | closest to law (1)'s one-pair form, which is one-directional |
| Relative anonymity, or permutation invariance (Sen 1984; Asheim, d'Aspremont and Banerjee 2010; Goodman and Lederman 2024) | Goodman and Lederman's text | The kit's `exchanged`, across formations. | the right name (I1) |
| Chichilnisky (1996), *Social Choice and Welfare* 13(2): 231–257 | abstract and later papers | Dictatorships of the present and of the future. | half right (I2) |
| Overtaking and catching up (Atsumi 1965; von Weizsäcker 1965; Gale 1967; Brock 1970) | records and later papers; Gale's definition not found | Partial sums over late horizons. | distant (I4) |
| Delayed simulation (Etessami, Wilke and Schuller 2001; 2005) | abstract and later papers | Acceptance answered later, without bound. | misdescribed (I3) |
| Delay games (Hosch and Landweber 1972; Holtmann, Kaiser and Thomas 2012) | later papers | Bounded lookahead. | near a uniform lag |
| Pattanaik and Xu (1990) | abstract | Three axioms on opportunity sets force ranking by number of options. | neighbour for counting scale (O5, S6) |

6. **Rules 8 and 9, and names.**
   - Rule 8 does not apply: no module is joined.
   - Names are structural. "Course", "lag" and "keeping widening" are used in the senses the eventual-widening record gives.
   - Rule 9: the kit generalizes no landed law. Two statements restate existing ones (S1). The order laws (S2) and the cycle law (S5) have general forms that would land below.
   - The leaf is justified (S7).
7. **The record.** See the next two sections.

## The landing's texts

- **07's Open item** (chapter line 628). A narrowing the Lean supports once parts A1 and A3 are adopted: "On admitted ranges, no strict partial order containing widening ranks every course that keeps widening above every course that admits alike, was wider at first and is mixed with it, where the latter may admit infinitely many formations; where its admissions are listed, one does. UE4's lag is decided by widening with a lag; widening with a lag and eventual widening exclude each other. What a course keeps reachable and what carries its openings remain."
  - Without part A1, the first sentence adds "and unchanged by renaming formations"; without part A3, it drops its last clause.
  - If S4 lands, add: "The lag is also decided by a tail form of widening with a lag, which contains eventual widening, so the lag does not choose between the two."
- **08 §8.** The line beyond the table may cite Askell (2018) for law (1)'s shape, relative anonymity (permutation invariance) for the exchange, Chichilnisky (1996) for eventual widening as decided by tails, and delayed simulation (Etessami, Wilke and Schuller 2001) as the analogue of a lag for each admission.
- **UE4's record.** Its counterexample, "a lag defeats eventual widening", stays true, and its next delta can point here for the lag's decision.

## What the record should and should not claim

**It may claim:**
1. **Law 1, near-definitional.**
   - *The class form.* On the two-sided web, no strict partial order containing widening ranks every course keeping widening by name from the first step above every course that admits alike from the first step, was wider up to the first step and is mixed with it. With part A1 adopted, no invariance is assumed; as the kit stands, the exchange is a hypothesis.
   - *The one-pair form.* A transitive relation containing widening and unchanged by exchanging the sides, which ranks the growing course above the other, ranks it above itself. Without the exchange that one ranking is consistent. If part A2 or G is adopted: the reverse ranking is consistent with every premise.
   - *Scope.* The static course admits infinitely many formations. If part A3 is adopted: with its admissions listed, the ranking is a strict partial order containing widening on every web.
   - *Neighbours.* The shape of Askell's (2018) incomparability argument; the exchange is relative anonymity across formations.
2. **Law 2, near-definitional.**
   - Widening or widening with a lag is a strict partial order containing widening on every web. It never reverses widening, it decides UE4's lag, and it is silent both ways on law (1)'s pair.
   - Widening with a lag alone does not contain widening.
   - The order is unchanged by the exchange on the two-sided web, and by every renaming constant across steps if part F's lemma lands. It compares formations across steps by name.
3. **Law 3, near-definitional.** On the own-condition web, one course eventually widens another while the other widens it with a lag, so no strict partial order on that web contains both relations. If part C lands: the lag is also decided by an order containing eventual widening.
4. **Constructivity.** Every axiom report is empty, and decisions come from pattern matching. The modelling: discrete steps, whole-number levels, admission by name over a fixed type of formations, and the lag read by name across steps.
5. **Standing.** All three laws are near-definitional. None ranks a course better, and the second-order direction of 生生 stays open.

**It should not claim:**
- that the class law needs invariance under renaming, or fails only for comparisons invariant under it (O1);
- that law (1) forces silence on its pair (E1);
- that the exchange is 07's "counting neither novelty nor scale" (O5);
- that ranking keeping widening over admitting alike is cyclic, without "where the static course admits infinitely many formations" (O4);
- that deciding the lag requires counting early steps or excludes eventual widening, or that widening with a lag is the order that decides it (O2);
- "renaming-invariant" without "constant across steps" (O3);
- that a lag varying with the formation would change laws (2) and (3) (I5);
- law (3) without its web (I6);
- the NOTE's descriptions of its neighbours: neutrality, both of Chichilnisky's dictatorships, delayed simulation as inclusion with delay, catching up as Gale's (I1–I4).

## Appendix: the probes

This is scratch, not for landing as is. It imports the kit, and its names follow the kit's; a prime marks a statement the kit already has in another form. It was compiled with Lean 4.29.1 against the kit on both builds. The environment audit finds 196 constants, 86 of them theorems, none depending on any axiom. `#print axioms` gives "does not depend on any axioms" for each part's main theorem.

| Part | Main declarations | Finding |
|---|---|---|
| A1 | `Sides.no_order_ranks_keeping_over_alike'` | O1 |
| A2 | `Sides.reverse_consistent` | E1 |
| A3 | `Web.ListedOrder`, `Sides.listed_consistent` | O4 |
| B | `Web.strictJoin_trans`, `Web.IncludesWithFormationLag`, `Web.IncludesEachLater` and their witnesses; `Web.includesLater_rename`, `Relabel.lag_reads_names` | I5, O3 |
| C | `Web.TailOrder`, `Web.tailOrder_order`, `LagWitness.tailOrder_decides` | O2, S4 |
| D | `Web.cycle_of_mirrors` | S5 |
| E | `Web.KeepsWhatKept`, `Sides.keeping_reading` | S6 |
| F | `Web.strictJoin_trans'`, `Web.IncludesLaterAlong`, `Web.widensOrWithLagAlong_order`, `_itself_iff`, `_reidentify`, `Web.widensOrWithLag_rename`, `Relabel.along_restores` | S2, S3, O3 |
| G | `Sides.scale_counts` | O5, E1 |

```lean
import Becoming.ComparingCourses

/-! Reviewer's scratch checks for UE9 (not part of the kit; not for landing). -/

namespace Becoming

open Web

/-! ## A. Law (1): what the cycle needs -/

namespace Sides

theorem swap_false {l : Nat → Bool × Nat → Nat} {t n : Nat} :
    web.Admits (swap l t) t (false, n) ↔ web.Admits (l t) t (true, n) :=
  swap_admits

theorem swap_true {l : Nat → Bool × Nat → Nat} {t n : Nat} :
    web.Admits (swap l t) t (true, n) ↔ web.Admits (l t) t (false, n) :=
  swap_admits

theorem swap_growing_false {t n : Nat} : web.Admits (swap growing t) t (false, n) ↔ n ≤ t :=
  ⟨fun admitted => growing_true.mp (swap_false.mp admitted),
   fun le => swap_false.mpr (growing_true.mpr le)⟩

theorem not_swap_growing_true {t n : Nat} : ¬ web.Admits (swap growing t) t (true, n) :=
  fun admitted => not_growing_false (swap_true.mp admitted)

theorem swap_firstAndOther_true {t n : Nat} : web.Admits (swap firstAndOther t) t (true, n) :=
  swap_true.mpr firstAndOther_false

theorem swap_firstAndOther_false {t n : Nat} :
    web.Admits (swap firstAndOther t) t (false, n) ↔ n ≤ 0 :=
  ⟨fun admitted => firstAndOther_true.mp (swap_false.mp admitted),
   fun le => swap_false.mpr (firstAndOther_true.mpr le)⟩

/-- The mirror of the growing course keeps widening by name from the first step. -/
theorem swap_growing_keepsWidening : web.KeepsWidening itself (swap growing) 0 :=
  ⟨fun _ _ _ later => (includesAcross_itself_iff later).mpr fun f admitted => match f with
      | (false, _) => swap_growing_false.mpr (Nat.le_trans (swap_growing_false.mp admitted) later)
      | (true, _) => absurd admitted not_swap_growing_true,
   fun S _ => ⟨S + 1, Nat.le_succ S, (exceedsAcross_itself_iff (Nat.le_succ S)).mpr
      ⟨(false, S + 1), swap_growing_false.mpr (Nat.le_refl (S + 1)),
       fun admitted => Nat.not_succ_le_self S (swap_growing_false.mp admitted)⟩⟩⟩

theorem swap_firstAndOther_alike : web.AdmitsAlikeFrom (swap firstAndOther) 0 :=
  fun _ _ _ => Iff.rfl

theorem swap_wider_first : web.WidensUpTo 0 (swap firstAndOther) (swap growing) :=
  ⟨fun _ f within admitted => match f with
     | (false, _) => swap_firstAndOther_false.mpr
         (Nat.le_trans (swap_growing_false.mp admitted) within)
     | (true, _) => absurd admitted not_swap_growing_true,
   ⟨0, (true, 0), Nat.le_refl 0, swap_firstAndOther_true, not_swap_growing_true⟩⟩

theorem swap_mixed : web.Mixed (swap growing) (swap firstAndOther) :=
  ⟨⟨1, (false, 1), swap_growing_false.mpr (Nat.le_refl 1),
    fun admitted => Nat.not_succ_le_zero 0 (swap_firstAndOther_false.mp admitted)⟩,
   ⟨0, (true, 0), swap_firstAndOther_true, not_swap_growing_true⟩⟩

/-- **A1. The class law needs no exchange.** The mirrored pair meets the four hypotheses itself, so
ranking the whole class supplies what the exchange supplied. -/
theorem no_order_ranks_keeping_over_alike'
    {R : (Nat → Bool × Nat → Nat) → (Nat → Bool × Nat → Nat) → Prop}
    (irrefl : ∀ a, ¬ R a a) (trans : ∀ {a b c}, R a b → R b c → R a c)
    (widening : ∀ {a b}, web.Widens a b → R a b) : ¬ web.RanksKeepingOverAlike R :=
  fun ranks => irrefl growing
    (trans (ranks growing firstAndOther growing_keepsWidening firstAndOther_alike
        firstAndOther_wider_first growing_mixed)
      (trans (widening firstAndOther_widens_swapped)
        (trans (ranks (swap growing) (swap firstAndOther) swap_growing_keepsWidening
            swap_firstAndOther_alike swap_wider_first swap_mixed)
          (widening swapped_widens_growing))))

/-! ### A2. The reverse verdict is consistent with every premise of the one-pair law -/

theorem swap_swap_includes (l : Nat → Bool × Nat → Nat) : web.Includes (swap (swap l)) l :=
  fun _ _ admitted => swap_admits.mpr (swap_admits_back.mpr admitted)

theorem includes_swap_swap (l : Nat → Bool × Nat → Nat) : web.Includes l (swap (swap l)) :=
  fun _ _ admitted => swap_admits_back.mp (swap_admits.mp admitted)

/-- At least the other course or its mirror. -/
def Above (a : Nat → Bool × Nat → Nat) : Prop :=
  web.Includes a firstAndOther ∨ web.Includes a (swap firstAndOther)

/-- At most the growing course or its mirror. -/
def Below (b : Nat → Bool × Nat → Nat) : Prop :=
  web.Includes growing b ∨ web.Includes (swap growing) b

/-- Widening, with every course above the other course (or its mirror) put over every course below
the growing course (or its mirror). -/
def reverseOrder (a b : Nat → Bool × Nat → Nat) : Prop :=
  web.Widens a b ∨ (Above a ∧ Below b)

theorem not_below_above {a : Nat → Bool × Nat → Nat} (above : Above a) (below : Below a) : False :=
  match above, below with
  | .inl ab, .inl be => not_growing_false ((be.trans ab) 0 (false, 0) firstAndOther_false)
  | .inl ab, .inr be => not_growing_false
      (swap_true.mp ((be.trans ab) 0 (true, 0) (firstAndOther_true.mpr (Nat.le_refl 0))))
  | .inr ab, .inl be => Nat.not_succ_le_zero 0
      (growing_true.mp ((be.trans ab) 0 (true, 1) swap_firstAndOther_true))
  | .inr ab, .inr be => not_growing_false
      (swap_true.mp ((be.trans ab) 0 (true, 0) swap_firstAndOther_true))

theorem reverseOrder_irrefl (a : Nat → Bool × Nat → Nat) : ¬ reverseOrder a a
  | .inl widens => widens.not_reverse widens
  | .inr ⟨above, below⟩ => not_below_above above below

theorem Above.of_includes {a b : Nat → Bool × Nat → Nat} (includes : web.Includes a b) :
    Above b → Above a
  | .inl inc => .inl (includes.trans inc)
  | .inr inc => .inr (includes.trans inc)

theorem Below.of_includes {a b : Nat → Bool × Nat → Nat} (includes : web.Includes a b) :
    Below a → Below b
  | .inl inc => .inl (inc.trans includes)
  | .inr inc => .inr (inc.trans includes)

theorem reverseOrder_trans {a b c : Nat → Bool × Nat → Nat} :
    reverseOrder a b → reverseOrder b c → reverseOrder a c
  | .inl first, .inl second => .inl (first.trans second)
  | .inl first, .inr ⟨above, below⟩ => .inr ⟨Above.of_includes first.1 above, below⟩
  | .inr ⟨above, below⟩, .inl second => .inr ⟨above, Below.of_includes second.1 below⟩
  | .inr ⟨above, _⟩, .inr ⟨_, below⟩ => .inr ⟨above, below⟩

theorem Above.mirror {a : Nat → Bool × Nat → Nat} : Above a → Above (swap a)
  | .inl inc => .inr (includes_swap inc)
  | .inr inc => .inl ((includes_swap inc).trans (swap_swap_includes firstAndOther))

theorem Below.mirror {b : Nat → Bool × Nat → Nat} : Below b → Below (swap b)
  | .inl inc => .inr (includes_swap inc)
  | .inr inc => .inl ((includes_swap_swap growing).trans (includes_swap inc))

theorem reverseOrder_exchanged {a b : Nat → Bool × Nat → Nat} :
    reverseOrder a b → reverseOrder (swap a) (swap b)
  | .inl widens => .inl ⟨includes_swap widens.1, exceeds_swap widens.2⟩
  | .inr ⟨above, below⟩ => .inr ⟨Above.mirror above, Below.mirror below⟩

/-- **A2. The cycle forbids one verdict only.** A strict partial order containing widening and
unchanged by the exchange ranks the other course above the growing one. -/
theorem reverse_consistent :
    (∀ a, ¬ reverseOrder a a) ∧
      (∀ {a b c}, reverseOrder a b → reverseOrder b c → reverseOrder a c) ∧
      (∀ {a b}, web.Widens a b → reverseOrder a b) ∧
      (∀ {a b}, reverseOrder a b → reverseOrder (swap a) (swap b)) ∧
      reverseOrder firstAndOther growing :=
  ⟨reverseOrder_irrefl, reverseOrder_trans, fun widens => .inl widens, reverseOrder_exchanged,
   .inr ⟨.inl (Includes.refl firstAndOther), .inl (Includes.refl growing)⟩⟩

end Sides

/-! ### A3. With the static course's admissions listed, the ranking is consistent on every web -/

namespace Web

variable {F F' C : Type} {W : Web F C} {l l' l'' : Nat → C → Nat}

/-- The class of `RanksKeepingOverAlike`, with the static course's admissions held by a list. -/
def KeepingOverListedAlike (W : Web F C) (k s : Nat → C → Nat) : Prop :=
  W.KeepsWidening itself k 0 ∧ W.AdmitsAlikeFrom s 0 ∧ W.WidensUpTo 0 s k ∧ W.Mixed k s ∧
    ∃ xs : List F, ∀ f, W.Admits (s 0) 0 f → f ∈ xs

/-- A static course whose admissions a list holds includes no course keeping widening by name. -/
theorem not_listed_includes_keeping {k s : Nat → C → Nat} (keeps : W.KeepsWidening itself k 0)
    (alike : W.AdmitsAlikeFrom s 0) (listed : ∃ xs : List F, ∀ f, W.Admits (s 0) 0 f → f ∈ xs)
    (includes : W.Includes s k) : False :=
  match listed with
  | ⟨xs, within⟩ => match keeps.gathers (xs.length + 1) with
    | ⟨_, S, _, length, distinct, all⟩ =>
      Nat.not_succ_le_self xs.length
        (Eq.subst (motive := fun n => n ≤ xs.length) length
          (length_le_of_sub distinct fun f mem =>
            within f ((alike S f (Nat.zero_le S)).mp (includes S f (all f mem)))))

/-- Widening, with every course including a course that keeps widening put above every course
included in a listed static course of the class. -/
def ListedOrder (W : Web F C) (a b : Nat → C → Nat) : Prop :=
  W.Widens a b ∨ ∃ k s, W.Includes a k ∧ KeepingOverListedAlike W k s ∧ W.Includes s b

theorem ListedOrder.irrefl {a : Nat → C → Nat} : ¬ ListedOrder W a a
  | .inl widens => widens.not_reverse widens
  | .inr ⟨_, _, ak, ⟨keeps, alike, _, _, listed⟩, sa⟩ =>
      not_listed_includes_keeping keeps alike listed (sa.trans ak)

theorem ListedOrder.trans {a b c : Nat → C → Nat} :
    ListedOrder W a b → ListedOrder W b c → ListedOrder W a c
  | .inl first, .inl second => .inl (first.trans second)
  | .inl first, .inr ⟨k, s, bk, pair, sc⟩ => .inr ⟨k, s, first.1.trans bk, pair, sc⟩
  | .inr ⟨k, s, ak, pair, sb⟩, .inl second => .inr ⟨k, s, ak, pair, sb.trans second.1⟩
  | .inr ⟨_, _, _, ⟨_, alike, _, _, listed⟩, sb⟩, .inr ⟨_, _, bk, ⟨keeps, _, _, _, _⟩, _⟩ =>
      (not_listed_includes_keeping keeps alike listed (sb.trans bk)).elim

theorem ListedOrder.ranks {k s : Nat → C → Nat} (pair : KeepingOverListedAlike W k s) :
    ListedOrder W k s :=
  .inr ⟨k, s, Includes.refl k, pair, Includes.refl s⟩

end Web

namespace Sides

/-- At every step the first formation of each side. -/
def firsts (_ : Nat) : Bool × Nat → Nat
  | (_, 0) => 1
  | (_, _ + 1) => 0

theorem firsts_zero {t : Nat} {b : Bool} : web.Admits (firsts t) t (b, 0) :=
  admits_iff.mpr Nat.zero_lt_one

theorem not_firsts_succ {t n : Nat} {b : Bool} : ¬ web.Admits (firsts t) t (b, n + 1) :=
  fun admitted => Nat.lt_irrefl 0 (admits_iff.mp admitted)

theorem growing_over_firsts : KeepingOverListedAlike web growing firsts :=
  ⟨growing_keepsWidening, fun _ _ _ => Iff.rfl,
   ⟨fun _ f within admitted => match f with
      | (true, 0) => firsts_zero
      | (true, n + 1) => absurd (Nat.le_trans (growing_true.mp admitted) within)
          (Nat.not_succ_le_zero n)
      | (false, _) => absurd admitted not_growing_false,
    ⟨0, (false, 0), Nat.le_refl 0, firsts_zero, not_growing_false⟩⟩,
   ⟨⟨1, (true, 1), growing_true.mpr (Nat.le_refl 1), not_firsts_succ⟩,
    ⟨0, (false, 0), firsts_zero, not_growing_false⟩⟩,
   ⟨[(true, 0), (false, 0)], fun f admitted => match f with
      | (true, 0) => .head _
      | (false, 0) => .tail _ (.head _)
      | (_, _ + 1) => absurd admitted not_firsts_succ⟩⟩

/-- **A3.** Restricted to static courses with listed admissions, ranking keeping widening over
admitting alike is a strict partial order containing widening on every web; on this web it ranks
the growing course above the first formations of both sides, where widening or eventual widening is
silent both ways. -/
theorem listed_consistent :
    (∀ a, ¬ ListedOrder web a a) ∧
      (∀ {a b c}, ListedOrder web a b → ListedOrder web b c → ListedOrder web a c) ∧
      (∀ {a b}, web.Widens a b → ListedOrder web a b) ∧
      (∀ {k s}, KeepingOverListedAlike web k s → ListedOrder web k s) ∧
      ListedOrder web growing firsts ∧ ¬ web.WidensOrEventually growing firsts ∧
      ¬ web.WidensOrEventually firsts growing :=
  ⟨fun _ => ListedOrder.irrefl, ListedOrder.trans, fun widens => .inl widens, ListedOrder.ranks,
   ListedOrder.ranks growing_over_firsts,
   fun ranks => match ranks with
     | .inl widens => not_growing_false (widens.1 0 (false, 0) firsts_zero)
     | .inr eventually => match (eventuallyWidens_iff.mp eventually).1 with
       | ⟨T, inc⟩ => not_growing_false (inc T (false, 0) (Nat.le_refl T) firsts_zero),
   fun ranks => match ranks with
     | .inl widens => not_firsts_succ (widens.1 1 (true, 1) (growing_true.mpr (Nat.le_refl 1)))
     | .inr eventually => match (eventuallyWidens_iff.mp eventually).1 with
       | ⟨T, inc⟩ => not_firsts_succ
           (inc (T + 1) (true, T + 1) (Nat.le_succ T) (growing_true.mpr (Nat.le_refl (T + 1))))⟩

end Sides

/-! ## B. The lag: other lags, and renaming across steps -/

namespace Web

variable {F F' C : Type} {W : Web F C} {l l' l'' : Nat → C → Nat}

/-- **The strict part of a preorder containing inclusion, joined to widening, is transitive.** -/
theorem strictJoin_trans {P : (Nat → C → Nat) → (Nat → C → Nat) → Prop}
    (trans : ∀ {a b c}, P a b → P b c → P a c) (includes : ∀ {a b}, W.Includes a b → P a b)
    {a b c : Nat → C → Nat} :
    (W.Widens a b ∨ (P a b ∧ ¬ P b a)) → (W.Widens b c ∨ (P b c ∧ ¬ P c b)) →
      (W.Widens a c ∨ (P a c ∧ ¬ P c a))
  | .inl first, .inl second => .inl (first.trans second)
  | .inl first, .inr ⟨p, np⟩ =>
      .inr ⟨trans (includes first.1) p, fun back => np (trans back (includes first.1))⟩
  | .inr ⟨p, np⟩, .inl second =>
      .inr ⟨trans p (includes second.1), fun back => np (trans (includes second.1) back)⟩
  | .inr ⟨p, np⟩, .inr ⟨q, _⟩ => .inr ⟨trans p q, fun back => np (trans q back)⟩

theorem strictJoin_irrefl {P : (Nat → C → Nat) → (Nat → C → Nat) → Prop} {a : Nat → C → Nat} :
    ¬ (W.Widens a a ∨ (P a a ∧ ¬ P a a))
  | .inl widens => widens.not_reverse widens
  | .inr ⟨p, np⟩ => np p

/-- `l` includes `l'` with a lag that varies with the formation. -/
def IncludesLaterBy (W : Web F C) (d : F → Nat) (l l' : Nat → C → Nat) : Prop :=
  ∀ t f, W.Admits (l' t) t f → W.Admits (l (t + d f)) (t + d f) f

def IncludesWithFormationLag (W : Web F C) (l l' : Nat → C → Nat) : Prop :=
  ∃ d : F → Nat, W.IncludesLaterBy d l l'

theorem IncludesWithFormationLag.trans :
    W.IncludesWithFormationLag l l' → W.IncludesWithFormationLag l' l'' →
      W.IncludesWithFormationLag l l''
  | ⟨d, first⟩, ⟨e, second⟩ => ⟨fun f => e f + d f, fun t f admitted =>
      Eq.subst (motive := fun x => W.Admits (l x) x f) (Nat.add_assoc t (e f) (d f))
        (first (t + e f) f (second t f admitted))⟩

theorem IncludesWithFormationLag.of_includes (includes : W.Includes l l') :
    W.IncludesWithFormationLag l l' :=
  ⟨fun _ => 0, fun t f admitted => includes t f admitted⟩

/-- `l` includes `l'` with a lag for each admission: what `l'` admits at a step, `l` admits at that
step or a later one. -/
def IncludesEachLater (W : Web F C) (l l' : Nat → C → Nat) : Prop :=
  ∀ t f, W.Admits (l' t) t f → ∃ d, W.Admits (l (t + d)) (t + d) f

theorem IncludesEachLater.trans (first : W.IncludesEachLater l l')
    (second : W.IncludesEachLater l' l'') : W.IncludesEachLater l l'' :=
  fun t f admitted => match second t f admitted with
    | ⟨e, mid⟩ => match first (t + e) f mid with
      | ⟨d, last⟩ => ⟨e + d, Eq.subst (motive := fun x => W.Admits (l x) x f) (Nat.add_assoc t e d) last⟩

theorem IncludesEachLater.of_includes (includes : W.Includes l l') : W.IncludesEachLater l l' :=
  fun t f admitted => ⟨0, includes t f admitted⟩

end Web

namespace LagWitness

open OwnCondition

theorem formationLag_decides :
    OwnCondition.web.IncludesWithFormationLag lagging travelling ∧
      ¬ OwnCondition.web.IncludesWithFormationLag travelling lagging :=
  ⟨⟨fun _ => 1, fun t _ admitted => kept_later admitted (Nat.lt_succ_self t)⟩,
   fun ⟨d, includes⟩ =>
     have same : 0 = 1 + d 0 := travelling_iff.mp (includes 1 0 (lagging_iff.mpr Nat.zero_lt_one))
     match d 0, same with
     | 0, same => Nat.noConfusion same
     | _ + 1, same => Nat.noConfusion same⟩

theorem eachLag_decides :
    OwnCondition.web.IncludesEachLater lagging travelling ∧
      ¬ OwnCondition.web.IncludesEachLater travelling lagging :=
  ⟨fun t _ admitted => ⟨1, kept_later admitted (Nat.lt_succ_self t)⟩,
   fun includes => match includes 1 0 (lagging_iff.mpr Nat.zero_lt_one) with
     | ⟨d, admitted⟩ =>
       have same : 0 = 1 + d := travelling_iff.mp admitted
       match d, same with
       | 0, same => Nat.noConfusion same
       | _ + 1, same => Nat.noConfusion same⟩

end LagWitness

namespace TailAndLag

open OwnCondition

/-- **The conflict survives a lag varying with the formation, or with each admission**: the course
ahead never admits formation `0`, so no lag of any kind catches it up. -/
theorem formationLag_conflict {R : (Nat → Nat → Nat) → (Nat → Nat → Nat) → Prop}
    (irrefl : ∀ a, ¬ R a a) (trans : ∀ {a b c}, R a b → R b c → R a c)
    (eventual : ∀ {a b}, OwnCondition.web.EventuallyWidens a b → R a b)
    (lagged : ∀ {a b}, OwnCondition.web.IncludesWithFormationLag a b →
      ¬ OwnCondition.web.IncludesWithFormationLag b a → R a b) : False :=
  irrefl ahead (trans (eventual eventually)
    (lagged ⟨fun _ => 1, early_includes⟩ fun ⟨_, includes⟩ => not_ahead_zero (includes 0 0 early_zero)))

theorem eachLag_conflict {R : (Nat → Nat → Nat) → (Nat → Nat → Nat) → Prop}
    (irrefl : ∀ a, ¬ R a a) (trans : ∀ {a b c}, R a b → R b c → R a c)
    (eventual : ∀ {a b}, OwnCondition.web.EventuallyWidens a b → R a b)
    (lagged : ∀ {a b}, OwnCondition.web.IncludesEachLater a b →
      ¬ OwnCondition.web.IncludesEachLater b a → R a b) : False :=
  irrefl ahead (trans (eventual eventually)
    (lagged (fun t _ admitted => ⟨1, early_includes t _ admitted⟩)
      fun includes => match includes 0 0 early_zero with
        | ⟨_, admitted⟩ => not_ahead_zero admitted))

end TailAndLag

/-! ### Renaming across steps -/

namespace Web

variable {F F' C : Type} {W : Web F C} {l l' : Nat → C → Nat}

theorem includes_reidentify (σ : Reidentify F F') :
    (W.reidentify σ).Includes l l' ↔ W.Includes l l' :=
  ⟨fun includes t f admitted =>
     Eq.subst (motive := fun g => W.Admits (l t) t g) (σ.old_new t f)
       (includes t (σ.new t f)
         (Eq.subst (motive := fun g => W.Admits (l' t) t g) (σ.old_new t f).symm admitted)),
   fun includes t x admitted => includes t (σ.old t x) admitted⟩

theorem exceeds_reidentify (σ : Reidentify F F') :
    (W.reidentify σ).Exceeds l l' ↔ W.Exceeds l l' :=
  ⟨fun ⟨t, x, admitted, apart⟩ => ⟨t, σ.old t x, admitted, apart⟩,
   fun ⟨t, f, admitted, apart⟩ => ⟨t, σ.new t f,
     Eq.subst (motive := fun g => W.Admits (l t) t g) (σ.old_new t f).symm admitted,
     fun back => apart (Eq.subst (motive := fun g => W.Admits (l' t) t g) (σ.old_new t f) back)⟩⟩

/-- **Widening is unchanged by every re-identification across steps.** -/
theorem widens_reidentify (σ : Reidentify F F') :
    (W.reidentify σ).Widens l l' ↔ W.Widens l l' :=
  ⟨fun widens => ⟨(includes_reidentify σ).mp widens.1, (exceeds_reidentify σ).mp widens.2⟩,
   fun widens => ⟨(includes_reidentify σ).mpr widens.1, (exceeds_reidentify σ).mpr widens.2⟩⟩

/-- Inclusion with a lag is unchanged by a renaming constant across steps. -/
theorem includesLater_rename {old : F' → F} {new : F → F'} {old_new : ∀ f, old (new f) = f}
    {new_old : ∀ x, new (old x) = x} {d : Nat} :
    (W.reidentify (Reidentify.rename old new old_new new_old)).IncludesLater d l l' ↔
      W.IncludesLater d l l' :=
  ⟨fun includes t f admitted =>
     Eq.subst (motive := fun g => W.Admits (l (t + d)) (t + d) g) (old_new f)
       (includes t (new f) (Eq.subst (motive := fun g => W.Admits (l' t) t g) (old_new f).symm admitted)),
   fun includes t x admitted => includes t (old x) admitted⟩

end Web

namespace Relabel

/-- Two formations, each requiring its own condition at need one. -/
def web : Web Bool Bool :=
  ⟨fun _ _ => 0, fun _ _ => True, fun _ f c => c = f, fun _ _ _ => 1, fun _ _ _ => False⟩

def flip : Nat → Bool → Bool
  | 0, b => b
  | _ + 1, b => !b

theorem flip_flip : ∀ t b, flip t (flip t b) = b
  | 0, _ => rfl
  | _ + 1, true => rfl
  | _ + 1, false => rfl

/-- From step one on, the two formations exchange names. -/
def exchange : Reidentify Bool Bool := ⟨flip, flip, flip_flip, flip_flip⟩

/-- `true` at step 0 only. -/
def once : Nat → Bool → Nat
  | 0, true => 1
  | 0, false => 0
  | _ + 1, _ => 0

/-- `true` at every step from one on. -/
def later : Nat → Bool → Nat
  | 0, _ => 0
  | _ + 1, true => 1
  | _ + 1, false => 0

theorem admits_iff {m : Bool → Nat} {t : Nat} {f : Bool} : web.Admits m t f ↔ 0 < m f :=
  ⟨fun admitted => admitted f rfl,
   fun pos _ same => Eq.subst (motive := fun x => 0 < m x) same.symm pos⟩

theorem re_admits_iff {m : Bool → Nat} {t : Nat} {x : Bool} :
    (web.reidentify exchange).Admits m t x ↔ 0 < m (flip t x) :=
  ⟨fun admitted => admitted (flip t x) rfl,
   fun pos _ same => Eq.subst (motive := fun y => 0 < m y) same.symm pos⟩

theorem later_withLag : web.WidensWithLag later once :=
  ⟨⟨1, fun t f admitted => match t, f, admitted with
      | 0, true, _ => admits_iff.mpr Nat.zero_lt_one
      | 0, false, admitted => absurd (admits_iff.mp admitted) (Nat.lt_irrefl 0)
      | _ + 1, true, admitted => absurd (admits_iff.mp admitted) (Nat.lt_irrefl 0)
      | _ + 1, false, admitted => absurd (admits_iff.mp admitted) (Nat.lt_irrefl 0)⟩,
   fun ⟨d, includes⟩ => match d, includes 1 true (admits_iff.mpr Nat.zero_lt_one) with
     | 0, admitted => Nat.lt_irrefl 0 (admits_iff.mp admitted)
     | _ + 1, admitted => Nat.lt_irrefl 0 (admits_iff.mp admitted)⟩

theorem not_later_withLag_renamed : ¬ (web.reidentify exchange).IncludesWithLag later once :=
  fun ⟨d, includes⟩ => match d, includes 0 true (re_admits_iff.mpr Nat.zero_lt_one) with
    | 0, admitted => Nat.lt_irrefl 0 (re_admits_iff.mp admitted)
    | _ + 1, admitted => Nat.lt_irrefl 0 (re_admits_iff.mp admitted)

/-- **Widening with a lag reads names across steps.** On this web `later` widens `once` with a lag;
after the re-identification that exchanges the two names from step one on, it does not, while
widening is unchanged by every re-identification. -/
theorem lag_reads_names :
    web.WidensWithLag later once ∧
      ¬ (web.reidentify exchange).WidensWithLag later once ∧
      ((web.reidentify exchange).Widens later once ↔ web.Widens later once) :=
  ⟨later_withLag, fun widens => not_later_withLag_renamed widens.1, widens_reidentify exchange⟩

end Relabel

/-! ## C. Deciding the lag together with eventual widening -/

namespace Web

variable {F C : Type} {W : Web F C} {l l' l'' : Nat → C → Nat}

/-- From step `T` on, every formation `l'` admits, `l` admits `d` steps later. -/
def IncludesLaterFrom (W : Web F C) (T d : Nat) (l l' : Nat → C → Nat) : Prop :=
  ∀ t f, T ≤ t → W.Admits (l' t) t f → W.Admits (l (t + d)) (t + d) f

/-- Inclusion with a lag from some step on. -/
def TailLag (W : Web F C) (l l' : Nat → C → Nat) : Prop :=
  ∃ T d, W.IncludesLaterFrom T d l l'

theorem TailLag.trans : W.TailLag l l' → W.TailLag l' l'' → W.TailLag l l''
  | ⟨T, d, first⟩, ⟨T', e, second⟩ => ⟨T + T', e + d, fun t f from_ admitted =>
      Eq.subst (motive := fun x => W.Admits (l x) x f) (Nat.add_assoc t e d)
        (first (t + e) f
          (Nat.le_trans (Nat.le_add_right T T') (Nat.le_trans from_ (Nat.le_add_right t e)))
          (second t f (Nat.le_trans (Nat.le_add_left T' T) from_) admitted))⟩

theorem TailLag.of_widensOrEventually : W.WidensOrEventually l l' → W.TailLag l l'
  | .inl widens => ⟨0, 0, fun t f _ admitted => widens.1 t f admitted⟩
  | .inr eventually => match (eventuallyWidens_iff.mp eventually).1 with
    | ⟨T, inc⟩ => ⟨T, 0, inc⟩

/-- Widening or eventual widening, or the strict part of inclusion with a lag from some step on. -/
def TailOrder (W : Web F C) (l l' : Nat → C → Nat) : Prop :=
  W.WidensOrEventually l l' ∨ (W.TailLag l l' ∧ ¬ W.TailLag l' l)

theorem TailOrder.irrefl : ¬ W.TailOrder l l
  | .inl either => WidensOrEventually.irrefl either
  | .inr ⟨p, np⟩ => np p

theorem TailOrder.trans : W.TailOrder l l' → W.TailOrder l' l'' → W.TailOrder l l''
  | .inl a, .inl b => .inl (a.trans b)
  | .inl a, .inr ⟨p, np⟩ => .inr ⟨(TailLag.of_widensOrEventually a).trans p,
      fun back => np (back.trans (TailLag.of_widensOrEventually a))⟩
  | .inr ⟨p, np⟩, .inl b => .inr ⟨p.trans (TailLag.of_widensOrEventually b),
      fun back => np ((TailLag.of_widensOrEventually b).trans back)⟩
  | .inr ⟨p, np⟩, .inr ⟨q, _⟩ => .inr ⟨p.trans q, fun back => np (q.trans back)⟩

/-- **C. A strict partial order containing widening and eventual widening** (on every web). -/
theorem tailOrder_order :
    (∀ a, ¬ W.TailOrder a a) ∧ (∀ {a b c}, W.TailOrder a b → W.TailOrder b c → W.TailOrder a c) ∧
      (∀ {a b}, W.Widens a b → W.TailOrder a b) ∧
      (∀ {a b}, W.EventuallyWidens a b → W.TailOrder a b) :=
  ⟨fun _ => TailOrder.irrefl, TailOrder.trans, fun widens => .inl (.inl widens),
   fun eventually => .inl (.inr eventually)⟩

end Web

namespace LagWitness

open OwnCondition

/-- **C. It decides the lag**, though eventual widening does not. -/
theorem tailOrder_decides :
    OwnCondition.web.TailOrder lagging travelling ∧
      ¬ OwnCondition.web.EventuallyWidens lagging travelling ∧
      ¬ OwnCondition.web.EventuallyWidens travelling lagging :=
  ⟨.inr ⟨⟨0, 1, fun t _ _ admitted => kept_later admitted (Nat.lt_succ_self t)⟩,
     fun ⟨T, d, includes⟩ =>
       have same : 0 = T + 1 + d :=
         travelling_iff.mp (includes (T + 1) 0 (Nat.le_succ T) (lagging_iff.mpr (Nat.zero_lt_succ T)))
       match d, same with
       | 0, same => Nat.noConfusion same
       | _ + 1, same => Nat.noConfusion same⟩,
   not_eventually_lagging, not_eventually_travelling⟩

end LagWitness

/-! ## D. The cycle as a law -/

namespace Web

variable {F C : Type} {W : Web F C}

/-- **Each widens the other's mirror.** A transitive relation containing widening and unchanged by
a map `σ` of level paths ranks `l` above `l'` only by ranking `l` above itself, where `l'` widens
`σ l` and `σ l'` widens `l`. `Sides.keeping_over_alike_cycles` is its instance. -/
theorem cycle_of_mirrors {σ : (Nat → C → Nat) → (Nat → C → Nat)}
    {R : (Nat → C → Nat) → (Nat → C → Nat) → Prop}
    (trans : ∀ {a b c}, R a b → R b c → R a c) (widening : ∀ {a b}, W.Widens a b → R a b)
    (exchanged : ∀ {a b}, R a b → R (σ a) (σ b)) {l l' : Nat → C → Nat}
    (first : W.Widens l' (σ l)) (second : W.Widens (σ l') l) (ranks : R l l') : R l l :=
  trans ranks (trans (widening first) (trans (exchanged ranks) (widening second)))

end Web

/-! ## E. A reading of "counting neither novelty nor scale": keep what the other keeps -/

namespace Web

variable {F C : Type} {W : Web F C} {l l' : Nat → C → Nat}

/-- `l` keeps what `l'` keeps: every formation `l'` admits at every step from some step on, `l`
admits at every step from some step on. -/
def KeepsWhatKept (W : Web F C) (l l' : Nat → C → Nat) : Prop :=
  ∀ f, (∃ T, ∀ t, T ≤ t → W.Admits (l' t) t f) → ∃ T, ∀ t, T ≤ t → W.Admits (l t) t f

theorem KeepsWhatKept.of_includesFrom {T₀ : Nat} (includes : W.IncludesFrom T₀ l l') :
    W.KeepsWhatKept l l' :=
  fun f ⟨T, kept⟩ => ⟨T + T₀, fun t le =>
    includes t f (Nat.le_trans (Nat.le_add_left T₀ T) le)
      (kept t (Nat.le_trans (Nat.le_add_right T T₀) le))⟩

theorem KeepsWhatKept.of_includesLaterFrom {T₀ d : Nat} (includes : W.IncludesLaterFrom T₀ d l l') :
    W.KeepsWhatKept l l' :=
  fun f ⟨T, kept⟩ => ⟨T + T₀ + d, fun _ le => match le_dest le with
    | ⟨k, same⟩ =>
      have shifted : W.Admits (l (T + T₀ + k + d)) (T + T₀ + k + d) f :=
        includes (T + T₀ + k) f
          (Nat.le_trans (Nat.le_add_left T₀ T) (Nat.le_add_right (T + T₀) k))
          (kept (T + T₀ + k) (Nat.le_trans (Nat.le_add_right T T₀) (Nat.le_add_right (T + T₀) k)))
      Eq.subst (motive := fun x => W.Admits (l x) x f)
        ((Nat.add_right_comm (T + T₀) k d).trans same.symm) shifted⟩

theorem TailOrder.keepsWhatKept : W.TailOrder l l' → W.KeepsWhatKept l l'
  | .inl (.inl widens) =>
      KeepsWhatKept.of_includesFrom (T₀ := 0) (fun t f _ admitted => widens.1 t f admitted)
  | .inl (.inr eventually) => match (eventuallyWidens_iff.mp eventually).1 with
    | ⟨_, includes⟩ => KeepsWhatKept.of_includesFrom includes
  | .inr ⟨⟨_, _, includes⟩, _⟩ => KeepsWhatKept.of_includesLaterFrom includes

theorem WidensOrWithLag.keepsWhatKept : W.WidensOrWithLag l l' → W.KeepsWhatKept l l'
  | .inl widens =>
      KeepsWhatKept.of_includesFrom (T₀ := 0) (fun t f _ admitted => widens.1 t f admitted)
  | .inr ⟨⟨d, includes⟩, _⟩ =>
      KeepsWhatKept.of_includesLaterFrom (T₀ := 0) (d := d) (fun t f _ admitted => includes t f admitted)

end Web

namespace Sides

theorem not_keepsWhatKept_growing : ¬ web.KeepsWhatKept growing firstAndOther :=
  fun keeps => match keeps (false, 0) ⟨0, fun _ _ => firstAndOther_false⟩ with
    | ⟨T, kept⟩ => not_growing_false (kept T (Nat.le_refl T))

theorem not_keepsWhatKept_firstAndOther : ¬ web.KeepsWhatKept firstAndOther growing :=
  fun keeps => match keeps (true, 1) ⟨1, fun _ le => growing_true.mpr le⟩ with
    | ⟨T, kept⟩ => Nat.not_succ_le_zero 0 (firstAndOther_true.mp (kept T (Nat.le_refl T)))

theorem not_keepsWhatKept_firsts : ¬ web.KeepsWhatKept growing firsts :=
  fun keeps => match keeps (false, 0) ⟨0, fun _ _ => firsts_zero⟩ with
    | ⟨T, kept⟩ => not_growing_false (kept T (Nat.le_refl T))

/-- **E.** Under "rank only what keeps what the other keeps", law (1)'s pair is unranked both ways
with no exchange, and A3's ranking is excluded; widening with a lag and the tail order meet the
condition everywhere. -/
theorem keeping_reading :
    ¬ web.KeepsWhatKept growing firstAndOther ∧ ¬ web.KeepsWhatKept firstAndOther growing ∧
      ¬ web.KeepsWhatKept growing firsts :=
  ⟨not_keepsWhatKept_growing, not_keepsWhatKept_firstAndOther, not_keepsWhatKept_firsts⟩

end Sides

/-! ## F. One order lemma, and the lag along a continuation -/

namespace Web

variable {F F' C : Type} {W : Web F C} {R : Nat → F → F → Prop} {l l' l'' : Nat → C → Nat}

/-- **The strict part of a preorder, joined to a transitive relation inside it, is transitive.** -/
theorem strictJoin_trans' {α : Type} {S P : α → α → Prop}
    (sTrans : ∀ {a b c}, S a b → S b c → S a c) (pTrans : ∀ {a b c}, P a b → P b c → P a c)
    (within : ∀ {a b}, S a b → P a b) {a b c : α} :
    (S a b ∨ (P a b ∧ ¬ P b a)) → (S b c ∨ (P b c ∧ ¬ P c b)) → (S a c ∨ (P a c ∧ ¬ P c a))
  | .inl first, .inl second => .inl (sTrans first second)
  | .inl first, .inr ⟨p, np⟩ =>
      .inr ⟨pTrans (within first) p, fun back => np (pTrans back (within first))⟩
  | .inr ⟨p, np⟩, .inl second =>
      .inr ⟨pTrans p (within second), fun back => np (pTrans (within second) back)⟩
  | .inr ⟨p, np⟩, .inr ⟨q, _⟩ => .inr ⟨pTrans p q, fun back => np (pTrans q back)⟩

/-- The kit's `WidensOrWithLag.trans`, as an instance. -/
theorem WidensOrWithLag.trans' : W.WidensOrWithLag l l' → W.WidensOrWithLag l' l'' →
    W.WidensOrWithLag l l'' :=
  strictJoin_trans' (S := W.Widens) (P := W.IncludesWithLag) Widens.trans IncludesWithLag.trans
    (fun widens => IncludesWithLag.of_includes widens.1)

/-- Appendix C's `TailOrder.trans`, as an instance. -/
theorem TailOrder.trans' : W.TailOrder l l' → W.TailOrder l' l'' → W.TailOrder l l'' :=
  strictJoin_trans' (S := W.WidensOrEventually) (P := W.TailLag) WidensOrEventually.trans
    TailLag.trans TailLag.of_widensOrEventually

/-- Links compose. -/
theorem Linked.append' : ∀ {t : Nat} {g : F} {u : Nat} {h : F} {v : Nat} {k : F},
    Linked R t g u h → Linked R u h v k → Linked R t g v k
  | _, _, _, _, _, _, .here _ _, rest => rest
  | _, _, _, _, _, _, .next step first, rest => .next step (Linked.append' first rest)

/-- `l` includes `l'` with lag `d` along the continuation `R`: every formation `l'` admits at a
step is linked, `d` steps later, to one `l` admits. -/
def IncludesLaterAlong (W : Web F C) (R : Nat → F → F → Prop) (d : Nat) (l l' : Nat → C → Nat) :
    Prop :=
  ∀ t f, W.Admits (l' t) t f → ∃ g, Linked R t f (t + d) g ∧ W.Admits (l (t + d)) (t + d) g

theorem IncludesLaterAlong.of_includes (includes : W.Includes l l') :
    W.IncludesLaterAlong R 0 l l' :=
  fun t f admitted => ⟨f, .here t f, includes t f admitted⟩

theorem IncludesLaterAlong.trans {d e : Nat} (first : W.IncludesLaterAlong R d l l')
    (second : W.IncludesLaterAlong R e l' l'') : W.IncludesLaterAlong R (e + d) l l'' :=
  fun t f admitted => match second t f admitted with
    | ⟨g, linked, mid⟩ => match first (t + e) g mid with
      | ⟨h, linked', last⟩ =>
        ⟨h, Eq.subst (motive := fun x => Linked R t f x h) (Nat.add_assoc t e d)
              (Linked.append' linked linked'),
         Eq.subst (motive := fun x => W.Admits (l x) x h) (Nat.add_assoc t e d) last⟩

/-- By name, it is the kit's inclusion with a lag. -/
theorem includesLaterAlong_itself_iff {d : Nat} :
    W.IncludesLaterAlong itself d l l' ↔ W.IncludesLater d l l' :=
  ⟨fun includes t f admitted => match includes t f admitted with
     | ⟨_, linked, admitted'⟩ =>
       Eq.subst (motive := fun x => W.Admits (l (t + d)) (t + d) x)
         (Linked.itself_same linked).2.symm admitted',
   fun includes t f admitted =>
     ⟨f, Linked.itself_of_le (Nat.le_add_right t d), includes t f admitted⟩⟩

/-- **Along a continuation, inclusion with a lag is unchanged by every re-identification carrying
the continuation.** -/
theorem includesLaterAlong_reidentify (σ : Reidentify F F') {d : Nat} :
    (W.reidentify σ).IncludesLaterAlong (σ.carry R) d l l' ↔ W.IncludesLaterAlong R d l l' :=
  ⟨fun includes t f admitted =>
     match includes t (σ.new t f)
         (Eq.subst (motive := fun g => W.Admits (l' t) t g) (σ.old_new t f).symm admitted) with
     | ⟨y, linked, admitted'⟩ =>
       ⟨σ.old (t + d) y,
        Eq.subst (motive := fun g => Linked R t g (t + d) (σ.old (t + d) y)) (σ.old_new t f)
          (Linked.of_carry linked),
        admitted'⟩,
   fun includes t x admitted => match includes t (σ.old t x) admitted with
     | ⟨g, linked, admitted'⟩ =>
       ⟨σ.new (t + d) g,
        Eq.subst (motive := fun y => Linked (σ.carry R) t y (t + d) (σ.new (t + d) g))
          (σ.new_old t x) (Linked.to_carry linked),
        (Eq.subst (motive := fun h => W.Admits (l (t + d)) (t + d) h) (σ.old_new (t + d) g).symm
          admitted' : W.Admits (l (t + d)) (t + d) (σ.old (t + d) (σ.new (t + d) g)))⟩⟩

/-- Widening, or the strict part of inclusion with some lag along `R`. -/
def WidensOrWithLagAlong (W : Web F C) (R : Nat → F → F → Prop) (l l' : Nat → C → Nat) : Prop :=
  W.Widens l l' ∨ ((∃ d, W.IncludesLaterAlong R d l l') ∧ ¬ ∃ d, W.IncludesLaterAlong R d l' l)

/-- **F. Along any continuation, a strict partial order containing widening.** -/
theorem widensOrWithLagAlong_order :
    (∀ a, ¬ W.WidensOrWithLagAlong R a a) ∧
      (∀ {a b c}, W.WidensOrWithLagAlong R a b → W.WidensOrWithLagAlong R b c →
        W.WidensOrWithLagAlong R a c) ∧
      (∀ {a b}, W.Widens a b → W.WidensOrWithLagAlong R a b) :=
  ⟨fun _ => strictJoin_irrefl (P := fun a b => ∃ d, W.IncludesLaterAlong R d a b),
   strictJoin_trans' (S := W.Widens) (P := fun a b => ∃ d, W.IncludesLaterAlong R d a b)
     Widens.trans
     (fun first second => match first, second with
       | ⟨_, first⟩, ⟨_, second⟩ => ⟨_, first.trans second⟩)
     (fun widens => ⟨0, IncludesLaterAlong.of_includes widens.1⟩),
   fun widens => .inl widens⟩

/-- By name, it is the kit's order. -/
theorem widensOrWithLagAlong_itself_iff :
    W.WidensOrWithLagAlong itself l l' ↔ W.WidensOrWithLag l l' :=
  ⟨fun
    | .inl widens => .inl widens
    | .inr ⟨⟨d, inc⟩, apart⟩ => .inr ⟨⟨d, includesLaterAlong_itself_iff.mp inc⟩,
        fun ⟨e, back⟩ => apart ⟨e, includesLaterAlong_itself_iff.mpr back⟩⟩,
   fun
    | .inl widens => .inl widens
    | .inr ⟨⟨d, inc⟩, apart⟩ => .inr ⟨⟨d, includesLaterAlong_itself_iff.mpr inc⟩,
        fun ⟨e, back⟩ => apart ⟨e, includesLaterAlong_itself_iff.mp back⟩⟩⟩

/-- **F. Along a continuation, the order is unchanged by every re-identification carrying it.** -/
theorem widensOrWithLagAlong_reidentify (σ : Reidentify F F') :
    (W.reidentify σ).WidensOrWithLagAlong (σ.carry R) l l' ↔ W.WidensOrWithLagAlong R l l' :=
  ⟨fun
    | .inl widens => .inl ((widens_reidentify σ).mp widens)
    | .inr ⟨⟨d, inc⟩, apart⟩ => .inr ⟨⟨d, (includesLaterAlong_reidentify σ).mp inc⟩,
        fun ⟨e, back⟩ => apart ⟨e, (includesLaterAlong_reidentify σ).mpr back⟩⟩,
   fun
    | .inl widens => .inl ((widens_reidentify σ).mpr widens)
    | .inr ⟨⟨d, inc⟩, apart⟩ => .inr ⟨⟨d, (includesLaterAlong_reidentify σ).mpr inc⟩,
        fun ⟨e, back⟩ => apart ⟨e, (includesLaterAlong_reidentify σ).mp back⟩⟩⟩

/-- The kit's order is unchanged by every renaming constant across steps, on every web. -/
theorem widensOrWithLag_rename {old : F' → F} {new : F → F'} {old_new : ∀ f, old (new f) = f}
    {new_old : ∀ x, new (old x) = x} :
    (W.reidentify (Reidentify.rename old new old_new new_old)).WidensOrWithLag l l' ↔
      W.WidensOrWithLag l l' :=
  ⟨fun
    | .inl widens => .inl ((widens_reidentify _).mp widens)
    | .inr ⟨⟨d, inc⟩, apart⟩ => .inr ⟨⟨d, includesLater_rename.mp inc⟩,
        fun ⟨e, back⟩ => apart ⟨e, includesLater_rename.mpr back⟩⟩,
   fun
    | .inl widens => .inl ((widens_reidentify _).mpr widens)
    | .inr ⟨⟨d, inc⟩, apart⟩ => .inr ⟨⟨d, includesLater_rename.mpr inc⟩,
        fun ⟨e, back⟩ => apart ⟨e, includesLater_rename.mp back⟩⟩⟩

end Web

namespace Relabel

/-- **F.** Along the continuation the re-identification carries, the verdict `lag_reads_names` lost
comes back. -/
theorem along_restores :
    (web.reidentify exchange).WidensOrWithLagAlong (exchange.carry itself) later once :=
  (widensOrWithLagAlong_reidentify exchange).mpr (widensOrWithLagAlong_itself_iff.mpr (.inr later_withLag))

end Relabel

/-! ## G. The exchange does not exclude counting scale -/

namespace Sides

/-- The sides exchanged on a formation. -/
def flip (f : Bool × Nat) : Bool × Nat := (!f.1, f.2)

theorem flip_flip : ∀ f : Bool × Nat, flip (flip f) = f
  | (true, _) => rfl
  | (false, _) => rfl

/-- At every step a map, one to one on what `b` admits, carries what `b` admits into what `a`
admits: `a` admits at least as many formations at every step. -/
def ScaleAtLeast (a b : Nat → Bool × Nat → Nat) : Prop :=
  ∀ t, ∃ φ : Bool × Nat → Bool × Nat,
    (∀ f g, web.Admits (b t) t f → web.Admits (b t) t g → φ f = φ g → f = g) ∧
      ∀ f, web.Admits (b t) t f → web.Admits (a t) t (φ f)

theorem ScaleAtLeast.of_includes {a b : Nat → Bool × Nat → Nat} (includes : web.Includes a b) :
    ScaleAtLeast a b :=
  fun t => ⟨fun f => f, fun _ _ _ _ same => same, fun f admitted => includes t f admitted⟩

theorem ScaleAtLeast.trans {a b c : Nat → Bool × Nat → Nat} (first : ScaleAtLeast a b)
    (second : ScaleAtLeast b c) : ScaleAtLeast a c :=
  fun t => match first t, second t with
    | ⟨φ, φinj, φmaps⟩, ⟨ψ, ψinj, ψmaps⟩ =>
      ⟨fun f => φ (ψ f),
       fun f g fa ga same => ψinj f g fa ga (φinj (ψ f) (ψ g) (ψmaps f fa) (ψmaps g ga) same),
       fun f admitted => φmaps (ψ f) (ψmaps f admitted)⟩

theorem ScaleAtLeast.exchanged {a b : Nat → Bool × Nat → Nat} (scale : ScaleAtLeast a b) :
    ScaleAtLeast (swap a) (swap b) :=
  fun t => match scale t with
    | ⟨φ, inj, maps⟩ =>
      ⟨fun f => flip (φ (flip f)),
       fun f g fa ga same =>
         have once : φ (flip f) = φ (flip g) :=
           (flip_flip (φ (flip f))).symm.trans ((congrArg flip same).trans (flip_flip (φ (flip g))))
         have twice : flip f = flip g :=
           inj (flip f) (flip g) (swap_admits.mp fa) (swap_admits.mp ga) once
         (flip_flip f).symm.trans ((congrArg flip twice).trans (flip_flip g)),
       fun f admitted => swap_admits.mpr
         (Eq.subst (motive := fun x => web.Admits (a t) t x) (flip_flip (φ (flip f))).symm
           (maps (flip f) (swap_admits.mp admitted)))⟩

/-- Widening, or admitting strictly more formations in the sense of `ScaleAtLeast`. -/
def scaleOrder (a b : Nat → Bool × Nat → Nat) : Prop :=
  web.Widens a b ∨ (ScaleAtLeast a b ∧ ¬ ScaleAtLeast b a)

theorem growing_zero_eq : ∀ {f : Bool × Nat}, web.Admits (growing 0) 0 f → f = (true, 0)
  | (true, 0), _ => rfl
  | (true, n + 1), admitted => absurd (growing_true.mp admitted) (Nat.not_succ_le_zero n)
  | (false, _), admitted => absurd admitted not_growing_false

theorem scale_firstAndOther_growing : ScaleAtLeast firstAndOther growing :=
  fun _ => ⟨fun f => (false, f.2),
    fun f g fa ga same => match f, g, fa, ga with
      | (true, _), (true, _), _, _ => congrArg (Prod.mk true) (congrArg Prod.snd same)
      | (false, _), _, fa, _ => absurd fa not_growing_false
      | (true, _), (false, _), _, ga => absurd ga not_growing_false,
    fun _ _ => firstAndOther_false⟩

theorem not_scale_growing_firstAndOther : ¬ ScaleAtLeast growing firstAndOther :=
  fun scale => match scale 0 with
    | ⟨φ, inj, maps⟩ =>
      have zero : φ (false, 0) = (true, 0) := growing_zero_eq (maps (false, 0) firstAndOther_false)
      have one : φ (false, 1) = (true, 0) := growing_zero_eq (maps (false, 1) firstAndOther_false)
      have same : ((false, 0) : Bool × Nat) = (false, 1) :=
        inj (false, 0) (false, 1) firstAndOther_false firstAndOther_false (zero.trans one.symm)
      Nat.noConfusion (congrArg Prod.snd same)

/-- **G. The exchange admits counting scale.** Widening joined to the strict part of "at least as
many formations at every step" is a strict partial order containing widening and unchanged by the
exchange; it ranks the other course above the growing one. -/
theorem scale_counts :
    (∀ a, ¬ scaleOrder a a) ∧
      (∀ {a b c}, scaleOrder a b → scaleOrder b c → scaleOrder a c) ∧
      (∀ {a b}, web.Widens a b → scaleOrder a b) ∧
      (∀ {a b}, scaleOrder a b → scaleOrder (swap a) (swap b)) ∧
      scaleOrder firstAndOther growing :=
  ⟨fun _ => Web.strictJoin_irrefl (P := ScaleAtLeast),
   Web.strictJoin_trans' (S := web.Widens) (P := ScaleAtLeast) Widens.trans ScaleAtLeast.trans
     (fun widens => ScaleAtLeast.of_includes widens.1),
   fun widens => .inl widens,
   fun ranks => match ranks with
     | .inl widens => .inl ⟨includes_swap widens.1, exceeds_swap widens.2⟩
     | .inr ⟨scale, apart⟩ => .inr ⟨scale.exchanged, fun back =>
         apart ((ScaleAtLeast.of_includes (includes_swap_swap _)).trans
           (back.exchanged.trans (ScaleAtLeast.of_includes (swap_swap_includes _))))⟩,
   .inr ⟨scale_firstAndOther_growing, not_scale_growing_firstAndOther⟩⟩

end Sides

end Becoming
```
