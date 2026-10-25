# UE9 re-check: the fix round (26 October 2026)

This is an AI-authored independent re-check of the fix round of board item UE9, commit `ee795993a`. It checks the revision against the [first review](REVIEW-UE9.md) (sha256 `7852e1bb…dda36eb3`) and the [module as first reviewed](history/ComparingCourses.lean) (`5a952632…de3b55a9`). It covers three files:

- [NOTE.md](NOTE.md), sha256 `8b8d882a…33e32a26`;
- [tree/Becoming/ComparingCourses.lean](tree/Becoming/ComparingCourses.lean), sha256 `18066bba…51554a0d`;
- [scratch.log](scratch.log), sha256 `91f91c12…827afc04`.

They were read with:
- [AGENTS](../../../../../../AGENTS.md);
- rules 3, 4, 8 and 9 and the UE9 row of the [work board](../../../../../BECOMING-WORKBOARD.md);
- [07 §2](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-eventual-widening) and [07's Open list](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#open);
- the package modules `Prelude`, `Regions`, `Admission`, `Identity`, `ContinuedClasses`, `EventualWidening` and `EventualWideningInstances`;
- `KeepingWidening`, for `Web.Linked.snoc`, and `Selection`, for its `Relabel` namespace.

Another session's untracked landing drafts in this folder, [LANDING.md](LANDING.md) and `kit/`, were read but not reviewed. They are cited only where they repeat wording found here, so that a fix reaches them too.

**How it was checked.**

- **Rebuild.** `python3 -B scratch_build.py <kit>/tree Becoming.ComparingCourses` was run from the package folder.
  - It reported 141 theorems in 176 declarations over 67 modules, every axiom report empty.
  - Every step was reused from the cache, because the inputs were identical to the fix round's build (main `98d205302`). So this run compiled nothing.
  - Main has since moved to `66854dbf7`. In the Lean package, MA4b's landing (`8ab22de82`) added the leaf `Becoming.ReadInTime` and changed only the root module, the package READMEs, the checker and its receipts; the later commits changed no Lean. None of these is in the kit's closure, so the build stands.
- **Fresh compile.** A byte-identical copy (same sha256) was compiled with Lean 4.29.1 in the session scratchpad against the kit's build, with no warning or error. An environment audit ran `Lean.collectAxioms` over every constant the module adds, auxiliary ones included. It found 284 constants, 141 of them theorems, none depending on any axiom.
- **Source.**
  - **Import.** The module imports only `Becoming.EventualWideningInstances`. Its closure, 63 `Becoming` modules and the three FOUNDATION modules, lies in the checker's CORE and FOUNDATION lists.
  - **Counts.** There are 141 `theorem` lines and 35 `def` lines, as the NOTE says.
  - **Scan.** Outside comments there is no `sorry`, `native_decide`, `axiom`, `set_option`, `unsafe`, `partial`, `opaque`, `extern`, `implemented_by`, `macro`, `elab`, `instance`, `decide`, `Classical`, `propext` or `noncomputable`. There is no `by` either, so every proof is a term.
  - **Prelude lemmas.** In this Lean, `#print axioms Nat.succ_ne_zero` reports `propext`, as NOTE §5 says. `Bool.not_not` reports none.
- **Names.** Every declaration that the NOTE and the docstrings cite resolves in the module or the package. No full name in the kit is declared anywhere else in the package, `ReadInTime` included.
- **Probes.** One scratch module, given in full in the [appendix](#appendix-the-probes) (sha256 `48e3d126…ee7b4ac4`), imports the kit. It compiles with no warning or error. The same audit finds 125 constants, 50 of them theorems, none depending on any axiom. Its parts P1 to P6 are cited below.
- **Neighbours.** NOTE §4 was compared with the first review's I1–I4 and its check 5 table. No source was searched again.
- **What was written.** No repository file other than this one was created or changed. The rebuild wrote only into `tree/.build` and the shared step cache. Nothing was staged or committed.

## Verdict

The Lean is sound and the core stays pure:
- the counts and the axiom reports are confirmed;
- every statement the NOTE quotes is the module's;
- each witness meets its hypotheses together.

Every required finding of the first review is resolved in the kit. Three of them, O1, O3 and I5, reached the board row only in its status cell (R1).

The fix round took the first review's own proposed wordings, and four of those say more than the Lean.
- **"Keeps widening" without "by name" (A).** The proposed narrowing of 07's Open item says "every course that keeps widening". 07 §2 reads keeping widening along a continuation. Along a merging continuation, listed static courses close the cycle too (P1). So "where its admissions are listed, one does" is false unless it says "by name", as every statement in the module does.
- **The class law's web (B).** The narrowing and §3 state the class law without its web, so infinite width reads as sufficient. On another web, a static course admitting infinitely many formations is in the class, and the ranking is still a strict partial order containing widening (P3). Infinite width is necessary, not sufficient.
- **Which course widens which (C).** "Each course widens the other's mirror" is false of the growing course, which widens neither mirror (P2). The crossing is that the static course of each pair widens the keeping course of the other.
- **The exchange (D).** It is invariance under one permutation, the swap of the two sides. "No formation counts by its name" says more, and that reading carries no [AI reading] label.

Two more imprecisions are new in the fix round.
- **Link composition (E).** `Web.Linked.append` generalizes the landed `Web.Linked.snoc` (P5).
- **The tail order (F).** The module docstring drops "the strict part of" from the tail order.

**Land after named fixes:** A–F and R1 are required. Each can be met by a change of wording in the NOTE, the docstrings, the record or the board row; E can instead be met by moving a lemma, which its owners decide. The docstring changes (B, C, F) need a scratch rebuild. The suggestions are recommended.

**Counts:** 0 errors, 1 overclaim, 6 imprecisions, 10 suggestions.

## The first review's findings

| Finding | Status | Where it stands |
|---|---|---|
| E1 | resolved | §2 law 2, "Where it is silent", and `Sides.reverse_consistent`; the board row's status says only one verdict is forbidden. |
| O1 | partly: the board | `no_order_ranks_keeping_over_alike` takes no exchange; §2, §3 and §4 changed. The board row's statement (1) still says "invariant under renaming formations" (R1). |
| O2 | resolved | `Web.TailOrder`, `tailOrder_order` and `LagWitness.tailOrder_decides`. Law 3, §3, §7 and the docstring use the review's wording. |
| O3 | partly: the board | `Web.widensOrWithLag_rename`, `Relabel.lag_reads_names`, the lag along a continuation and §5's modelling item. The board row's statement (2) still says "invariant under renaming" (R1). |
| O4 | resolved, with B and C | `Web.ListedOrder`, `Sides.listed_consistent`, law 1's scope and §5. The scope wording the review proposed has defects of its own (B, C). |
| O5 | resolved, with D | `Sides.scale_counts`. Law 1's reading is rewritten in the review's words, which say more than the exchange does (D). |
| I1 | resolved | §4 as the review gave it; for "is relative anonymity", see D. |
| I2 | resolved | §4 as the review's fix gave it; the label the review put on part of it is not carried (S6). |
| I3 | resolved | §4. |
| I4 | resolved | §4. |
| I5 | partly: the board | `IncludesWithFormationLag`, `IncludesEachLater`, their decisions and conflicts, and §5. The board row's statement (2) still says "a fixed delay" (R1). §5's sentence now covers more than the Lean (S7). |
| I6 | resolved | Law 3, the module docstring and the docstring of `TailAndLag.no_order_contains_both` name the own-condition web. |

The suggestions S1–S7 were taken as NOTE §6 says. S1's two restatements are gone: the module uses `Bool.not_not` (line 624) and, in `Delayed`, the opened `OwnCondition.rising_iff`.

## The checks

1. **Build and pure core.** Confirmed as above. Decisions come from pattern matching, with `Nat.noConfusion` after a case split.
2. **The NOTE and the docstrings against the Lean.** Every claim was checked against the statement it cites. The ones the task names:
   - **`Web.ranks_self_of_crossed`** holds as stated, on every web. It needs only transitivity and containing widening; irreflexivity enters where the law is used.
   - **`Web.strictJoin_order`** holds as stated. `strictJoin_trans` needs `P` only to be transitive, so "the strict part of a preorder" claims less than the Lean shows. A relation containing inclusion is reflexive in any case.
   - **`Web.WidensOrWithLag.includesEachLater`** holds as law 3's last item states it.
   - **`TailAndLag.tailOrder_loses`** holds as stated. Its fourth conjunct gives "widening with a lag never does" for this pair, and `includesEachLater` gives it for every pair.
   - **Law 4.** `Web.KeepsWhatKept`, its two "meets" theorems and `Sides.keeping_reading` are as stated, and so is §2's "What it is not". The reverse ranking by scale and `reverseOrder` are excluded because `firstAndOther` does not keep what `growing` keeps.
   - **NOTE §3 and §7:** see A and B, and S8 and S9. **NOTE §4:** see D and S6.

   Everything else holds as stated, except where A–F and the suggestions say otherwise.
3. **Rule 9 and names.**
   - **Rule 9.** S1's restatements are dropped, and no landed law is restated beside the kit's. The kit does generalize one landed lemma, `Web.Linked.snoc` (E).
   - **Names.** They are structural. "Course", "lag", "keeping widening" and "admits alike" are used in the eventual-widening record's senses.
   - **The `Relabel` namespace.** The kit's `Relabel` is `Becoming.Relabel`, which `Selection` already uses for `Relabel.swap` and `Relabel.Equivariant`. No name clashes (S5).
4. **Neighbours.** §4 agrees with the first review's fixes for I1–I4 and with its check 5 table:
   - Askell (2018) is closest to the one-pair form;
   - relative anonymity is the right name;
   - Diamond and Basu–Mitra are distant;
   - Suzumura and Szpilrajn are vocabulary only;
   - Chichilnisky fits only eventual widening, a dictatorship of the future;
   - delayed simulation and delay games are described as the review describes them;
   - overtaking and catching up are distant;
   - Pattanaik and Xu are the neighbour for counting scale.

   Svensson (1980) is in the table but not in §4. That is an omission, not an error.

## Findings

Line numbers are those of the files above. The drafts in `kit/` and `LANDING.md` belong to another session and are not reviewed here. Where they carry the same wording, the finding says so.

### Overclaims

**A. The proposed narrowing of 07's Open item drops "by name".**
- *Location.*
  - NOTE §7, "07's Open item" (line 141): "no strict partial order containing widening ranks every course that keeps widening above every course that admits alike, was wider at first and is mixed with it, where the latter may admit infinitely many formations; where its admissions are listed, one does".
  - NOTE §3, the first "Shows" bullet (line 82). It speaks of "a course that keeps widening is better…" and ends "Where the static course's admissions are listed, the ranking is consistent".
  - The wording is the first review's own (its section "The landing's texts"), as is the phrase B concerns.
  - In the drafts: `kit/texts_ue9.py` lines 43, 57–59, 69 and 121; `kit/board_ue9.py` line 18; `kit/make_records_ue9.py` lines 234–235 (the record's statement).
- *What is wrong.*
  - 07 §2 defines keeping widening along a continuation (`Web.KeepsWidening R`). Keeping widening by name is the case `R = itself`. 07 §2 itself cites `MergedWitness.keeps_widening_along_merge`, in which a constant course keeps widening along a merging continuation.
  - Both clauses are proved by name only. `RanksKeepingOverAlike` and `KeepingOverListedAlike` take `KeepsWidening itself`, and `Web.ListedOrder` rests on the pigeonhole of `KeepsWidening.gathers`, which needs names.
  - Without names the positive clause is false. P1 works on the own-condition web, along the continuation that carries every formation into formation `0`:
    - two courses keep widening: `k1` admits formations 0 and 1 at step 0, then 0 and 2; `k2` admits 0 and 3, then 0 and 4;
    - two constant courses admit alike, are listed, are wider up to the first step and are mixed with them: `s1` admits {0, 1, 3, 4} and `s2` admits {0, 1, 2, 3};
    - `s1` widens `k2` and `s2` widens `k1`.

    So no strict partial order containing widening ranks every such pair (`no_order_ranks_along_listed`).
- *Fix.* Say "keeps widening by name" in both places. Preferably also say "from the first step" and "admits alike from it", as `Sides.no_order_ranks_keeping_over_alike` states. With B, for example:

  > On admitted ranges, ranking every course that keeps widening by name above every course that admits alike, was wider at first and is mixed with it is not a strict partial order containing widening on every web. On a web of formations on two sides, whose static course admits infinitely many formations, it closes a cycle. Where the static course's admissions are listed, it is one on every web.

### Imprecisions

**B. The class law is stated without its web, so infinite width reads as sufficient.**
- *Location.*
  - NOTE §7 (line 141): "where the latter may admit infinitely many formations".
  - NOTE §3's first bullet (line 82): "where the one merely wider now may admit infinitely many formations at once".
  - The docstring of `Sides.no_order_ranks_keeping_over_alike` (line 676), whose headline names no web.
  - Both NOTE phrases come from the first review: its proposed 07 wording, and O4's "What is wrong".
  - The drafts say more. "Closes a cycle where the latter admits infinitely many formations" is in `kit/make_records_ue9.py` lines 234–235, `kit/board_ue9.py` lines 18–19 and `kit/texts_ue9.py` line 121. "Wherever the two are mixed and the one wider now admits infinitely many formations" is in `kit/texts_ue9.py` line 43.
- *What is wrong.*
  - The class law is a theorem about `Sides.web`. The scope result gives only a necessary condition: where a static course's admissions are listed, the ranking is consistent on every web (`Web.ListedOrder`).
  - The two clauses of the 07 wording are parallel. If both are read as holding on any web, the first is false. P3 shows this on a web with two sides:
    - all formations of the first side need one condition at one, and the second side's `(false, m)` needs another condition at `m + 1`;
    - the course `rising` keeps widening by name;
    - the constant course `wide` admits every formation of the first side and `(false, 0)`; no list holds these admissions;
    - `wide` admits alike, is wider up to the first step and is mixed with `rising`.
  - On that web, no static course includes a course keeping widening by name. So widening joined to "every course that includes a keeping course is above every course its static course includes" is a strict partial order containing widening, and it ranks every pair of the class (`consistent_with_infinite`).
  - What the Lean shows is this: read as one comparison on every web, the ranking fails, on the two-sided web.
- *Fix.*
  - Name the web wherever the class law is stated or summarized ("on a web of formations on two sides", "on the two-sided web"), as A's wording does.
  - Of infinite width, say only that the cycle needs it.
  - In the theorem's docstring, write "On the two-sided web, no strict partial order …".
  - In §3: "On a web of formations on two sides, the second-order comparison 07 asks for cannot be 'a course that keeps widening by name is better than one that admits alike and was wider at first', applied wherever the two are mixed, if it is to be a strict partial order containing widening: a single growing course and a single fixed one, with their mirrors, already force the cycle. The fixed course admits infinitely many formations; where the static course's admissions are listed, the ranking is consistent on every web."
  - If the record is to say that infinite width does not suffice, fold P3 into the kit first (S10).

**C. The growing course widens neither mirror.**
- *Location.*
  - NOTE §2, law 1, "The two courses", third sub-bullet (line 22): "Each course widens the other's mirror".
  - Law 1's scope, in the [AI reading] (line 39): "an infinitely wide static course and a growing course each widen the other's mirror".
  - The docstring of `Sides.no_order_ranks_keeping_over_alike` (lines 676–678).
  - The NOTE's scope sentence comes from the first review (O4's fix).
  - In the drafts: `kit/texts_ue9.py` line 41, and `kit/make_records_ue9.py` line 89 with its Chinese line 91.
- *What is wrong.*
  - The two theorems named say that `firstAndOther` widens `swap growing` and that `swap firstAndOther` widens `growing`. So the static course of each pair widens the keeping course of the other.
  - The growing course does not widen the other's mirror, and its mirror does not widen the other (P2: `not_growing_widens_swapped`, `not_swapped_growing_widens`).
  - The [AI reading]'s "driven by scale" rests on the same sentence, and P3 shows that infinite width alone does not close the cycle.
- *Fix.*
  - Write "The static course of each pair widens the keeping course of the other: the other course widens the mirror of the growing one, and the mirror of the other widens the growing one."
  - For the reading, write "**[AI reading]** The cycle needs a static course wide enough to include a keeping course of another pair of the class, which no static course with listed admissions is (`Web.not_listed_includes_keeping`)."
  - Change the docstring to match, and rebuild.

**D. The exchange is one permutation, and its reading has no label.**
- *Location.*
  - NOTE §2, law 1, "Reading" (line 41): "The exchange states that no formation counts by its name: relative anonymity (permutation invariance) across formations."
  - NOTE §4 (line 97): "The exchange is relative anonymity, or permutation invariance, across formations".
  - Both follow the first review (O5, I1).
  - In the drafts: `kit/make_records_ue9.py` line 281 and `kit/texts_ue9.py` line 69.
- *What is wrong.*
  - The hypothesis `exchanged : R a b → R (swap a) (swap b)` is invariance under one permutation of the formations, `(b, n) ↦ (!b, n)`. "No formation counts by its name" would be invariance under every permutation.
  - The one-pair law holds a fortiori under the stronger principle, but the kit states and needs only the one swap.
  - The sentence is an interpretation, and AGENTS asks every reading to keep its label. The first review marked it [AI reading] where it argued for it (O5).
  - The swap moves every formation. Whether each cited form of relative anonymity covers permutations that move infinitely many coordinates was not checked here.
- *Fix.*
  - Write "**[AI reading]** The exchange is invariance under one permutation of the formations, the swap of sides, applied to both sides of a ranking: an instance of relative anonymity (permutation invariance) across formations."
  - In §4, write "The exchange is an instance of relative anonymity …".

**E. Link composition generalizes the landed `Web.Linked.snoc`.**
- *Location.* NOTE §5, third bullet (line 108): link composition stays in the leaf "as for UE7's `Web.Linked.snoc`". `LANDING.md` line 24 says the same.
- *What is wrong.*
  - `Web.Linked.snoc` (`KeepingWidening.lean` line 465, landed with UE7) is `Linked.append` with a one-link chain. P5 proves `snoc`'s exact statement as `Linked.append rest (.next r (.here _ _))`. So the two are not parallel cases of one choice.
  - The kit adds the general law beside its landed special case. Rule 9 asks to avoid exactly this: two proofs of one fact, the general law not being the reason for the special one.
  - `KeepingWidening` is not in the kit's closure, so the leaf cannot derive `snoc`. The general lemma belongs in `ContinuedClasses`, where `Linked` is defined, with `snoc` derived from it.
- *Fix.*
  - Say in §5 and in the record that `Web.Linked.append` generalizes `Web.Linked.snoc`.
  - Then either land `Linked.append` in `ContinuedClasses` and derive `snoc` from it, or state in the board row and the record that the general form sits in the leaf, beside its special case, until that move.
  - The move is for the owners of `ContinuedClasses` and `KeepingWidening` to decide (rule 3). It rebuilds the modules above `ContinuedClasses`.

**F. The module docstring describes the tail order without its strict part.**
- *Location.* The module docstring, law 2's fourth sub-bullet (lines 47–49): "the tail order, inclusion with a lag from some step on joined to widening or eventual widening". The draft's statement of the theorem for 07 §2 (`kit/texts_ue9.py` line 41) repeats it.
- *What is wrong.*
  - `Web.TailOrder` joins the strict part of `Web.TailLag` to widening or eventual widening.
  - Inclusion with a lag from some step on is reflexive, so the order as described would not be irreflexive.
  - NOTE §2 (line 59) states it correctly.
- *Fix.* Write "the tail order, the strict part of inclusion with a lag from some step on joined to widening or eventual widening", and rebuild.

**R1. The board row's statements predate both reviews.**
- *Location.* The UE9 row of the [work board](../../../../../BECOMING-WORKBOARD.md), statements (1) and (2). The first review named them for O1, O3 and I5.
- *What is wrong.*
  - The status cell records the fix round, but the statements do not:
    - statement (1) still says "invariant under renaming formations";
    - statement (2) still says "inclusion with a fixed delay" and "invariant under renaming".
  - The kit's class law takes no invariance, and the lag is any lag. The order is unchanged by every renaming constant across steps, but it reads names across steps.
- *Fix.* Rewrite both statements, at the latest in the row that moves to history at landing (rule 4):
  - (1): "on a web of formations on two sides, no strict partial order containing widening ranks every course keeping widening by name above every static course wider at first and mixed with it";
  - (2): "inclusion with some lag … unchanged by every renaming constant across steps, reading names across steps".

### Suggestions

**S1. "Can rank".** NOTE law 1, "One verdict only" (line 34), and the docstrings of `reverse_consistent` (lines 834–835) and `exchange_needed` (lines 712–713) say "a strict partial order … ranks". Read as a general statement, that is false: the Lean exhibits one such order. The first review's E1 fix wrote "can rank". The draft's statement of the theorem for 07 §2 (`kit/texts_ue9.py` line 41) repeats "ranks".

**S2. `listed_consistent`'s docstring.** It says "on every web" (lines 874–877), but its statement is on `Sides.web`. Cite `Web.ListedOrder.irrefl`, `.trans` and `.ranks` for every web, as the NOTE does (line 37).

**S3. Three laws or four.** The module docstring says "three laws locate" (line 9) above four bullets. §4 (line 102) calls law 4 "a condition, not a result", although three theorems check it. Write "three laws, and a condition with its checks".

**S4. One own-condition web.** `OwnCondition.web` (on `Nat`, landed), `Sides.web` (on `Bool × Nat`) and `Relabel.web` (on `Bool`) are one definition on three carriers, each with the same `admits_iff` proof. One own-condition web over any carrier would remove two copies, if the owner of `EventualWideningInstances` agrees. The first review's S1 named `Sides.web`.

**S5. The `Relabel` namespace.** The kit adds `Becoming.Relabel.web`, `.flip`, `.exchange` and others to the namespace that holds `Selection`'s `Relabel.swap` and `Relabel.Equivariant`. Nothing clashes, but two unrelated things share one name. A structural name for the kit's witness, for example `NamesAcrossSteps`, would keep them apart.

**S6. Label the Chichilnisky analogy.** In §4 (line 99), and in `kit/texts_ue9.py` line 69, the comparison with dictatorships of the future and of the present is an interpretation. The first review marked it [AI reading] (I2).

**S7. What holds for the other lags.** §5's last item (line 114) says "laws 2 and 3 hold as well for a lag varying with the formation or for each admission". This is the first review's I5 wording, from when law 2 had only its order and its decision.
- **What the Lean gives.** For both forms it gives:
  - the order, through `strictJoin_order`, though the module does not instantiate it (P4 instantiates both in one line each);
  - the decision;
  - law 3's conflict.

  Renaming, the exchange and silence are not checked for them.
- **Law 4 tells the forms apart.**
  - A lag for each admission can rank a course above one that keeps a formation the first drops. In P6 (`eachLag_not_keeping`), `alternate` admits formation 0 at even steps and formation 1 at step 0, and `steady` admits formation 0 at every step.
  - A lag varying with the formation keeps what the other keeps, on every web (P6, `formationLag_keeps`).
- **So:**
  - law 2's "The lag's form does not matter" (line 58) holds for the order and the decision;
  - law 4 holds of the uniform lag and of the lag varying with the formation, but not of a lag for each admission, which is the analogue of delayed simulation.

**S8. "The two".** §7 (line 141) says "so the lag does not choose between the two". Name them, counting early steps and reading only tails, as `kit/texts_ue9.py` lines 60–61 do.

**S9. "Exclude each other".** §3 (line 83) and §7 (line 141) sum up law 3 as "widening with a lag and eventual widening exclude each other". The conflict is on the own-condition web: no comparison defined on every web contains both. Saying "rank a pair oppositely (law 3)", as the drafts do, or "on the own-condition web", avoids reading it as true of every web.

**S10. Fold the probes in.** P1, P2, P3 and P6 are small, use the kit's definitions and have empty axiom reports. Folded into the module, they would put Lean behind four statements the record could then make:
- that "by name" is needed;
- which course widens which;
- that infinite width does not suffice;
- that law 4 separates the forms of the lag.

## What the record may and should not claim, amended

The first review's two lists stand, with these changes.

**It may also claim:**
- **Law 4.** Keeping what the other keeps is met by widening or widening with a lag and by the tail order. It excludes both rankings of law 1's pair, and the listed ranking above the first formations. It is a necessary condition, not an order.
- **The tail order.** It is a strict partial order containing widening and eventual widening on every web, and it decides UE4's lag. It ranks a course above one that admitted a formation the first never admits, which widening or widening with a lag never does.
- **The lag along a continuation.** It gives a strict partial order containing widening, unchanged by every re-identification that carries the continuation. By name, it is widening or widening with a lag.

**It should not claim:**
- the class law or its listed scope with "keeps widening" unqualified, rather than by name (A);
- the class law without its web, or that ranking keeping widening over admitting alike closes a cycle wherever the static course admits infinitely many formations (B);
- that each course widens the other's mirror (C);
- that the exchange states that no formation counts by its name, or that it is relative anonymity, without "an instance of" (D);
- that link composition is parallel to `Web.Linked.snoc` rather than its generalization (E);
- that every form of the lag meets law 4 (S7).

## Appendix: the probes

The module below was compiled in the session scratchpad with Lean 4.29.1, against the kit's build (its inputs unchanged on main `66854dbf7`), with no warning or error. `Lean.collectAxioms` over its 125 constants (50 theorems) finds no axiom. Its sha256 is `48e3d12671e10d475e4a1d6418fc051de3dcfb82ec4735af42b27b57ee7b4ac4`.

- **P1**, along a merging continuation: listed static courses close the cycle (A).
- **P2**: the growing course widens neither mirror (C).
- **P3**: a static course with infinitely many admissions in the class, and a consistent ranking (B, C).
- **P4**: the other lags' orders as instances of `strictJoin_order` (S7).
- **P5**: `Web.Linked.snoc`'s statement from `Web.Linked.append` (E).
- **P6**: a lag for each admission against law 4, and the lag varying with the formation meeting it (S7).

```lean
import Becoming.ComparingCourses

/-! Re-checker's scratch probes for UE9's fix round (not part of the kit; not for landing). -/

namespace Becoming
namespace ReCheckUE9

open Web

/-! ## P1. Keeping widening along a continuation: listing does not save the ranking

07 §2 reads "keeps widening" along a continuation (`Web.KeepsWidening R`). Along the continuation
that carries every formation into formation `0`, four courses on the own-condition web cross, the
static courses alike from the first step and listed. So the positive clause of the proposed 07
wording ("where its admissions are listed, one does") needs "by name". -/

namespace AlongMerge

open OwnCondition

/-- Every formation continues into formation `0`. -/
def merge0 : Nat → Nat → Nat → Prop := fun _ _ f => f = 0

/-- A chain along `merge0` stays put or ends at `0`. -/
theorem linked_cases : ∀ {s g u h : Nat},
    Linked merge0 s g u h → (s = u ∧ g = h) ∨ (s < u ∧ h = 0)
  | _, _, _, _, .here _ _ => .inl ⟨rfl, rfl⟩
  | s, _, _, _, .next step rest => match linked_cases rest with
    | .inl ⟨same, same'⟩ =>
      .inr ⟨Eq.subst (motive := fun x => s < x) same (Nat.lt_succ_self s), same'.symm.trans step⟩
    | .inr ⟨lt, zero⟩ => .inr ⟨Nat.lt_trans (Nat.lt_succ_self s) lt, zero⟩

/-- Every formation is linked to `0` at every later step. -/
theorem to_zero (s g : Nat) : ∀ k, Linked merge0 s g (s + (k + 1)) 0
  | 0 => .next rfl (.here (s + 1) 0)
  | k + 1 => Linked.append (to_zero s g k) (.next rfl (.here (s + (k + 1) + 1) 0))

/-- A formation other than `0` one step on is linked to nothing. -/
theorem not_linked_succ {s f g : Nat} (linked : Linked merge0 s f (s + 1) (g + 1)) : False :=
  match linked_cases linked with
  | .inl ⟨same, _⟩ => Nat.lt_irrefl s (Eq.subst (motive := fun x => s < x) same.symm (Nat.lt_succ_self s))
  | .inr ⟨_, zero⟩ => Nat.noConfusion zero

/-- A course admitting formation `0` at every step includes along `merge0` across every stretch. -/
theorem includesAcross_of_zero {l : Nat → Nat → Nat} (zero : ∀ t, 0 < l t 0) :
    web.IncludesAcrossFrom merge0 l 0 :=
  fun S U _ le f admitted => match exists_steps_between le with
    | ⟨0, same⟩ => ⟨f, Eq.subst (motive := fun x => Linked merge0 S f x f) same.symm (.here S f),
        Eq.subst (motive := fun x => web.Admits (l x) x f) same.symm admitted⟩
    | ⟨k + 1, same⟩ =>
      ⟨0, Eq.subst (motive := fun x => Linked merge0 S f x 0) same.symm (to_zero S f k),
       admits_iff.mpr (zero U)⟩

/-- One at step `0`, zero after. -/
def atFirst : Nat → Nat
  | 0 => 1
  | _ + 1 => 0

/-- Zero at step `0`, one after. -/
def afterFirst : Nat → Nat
  | 0 => 0
  | _ + 1 => 1

/-- Formations `0` and `1` at step `0`, `0` and `2` after. -/
def k1 (t : Nat) : Nat → Nat
  | 0 => 1
  | 1 => atFirst t
  | 2 => afterFirst t
  | _ + 3 => 0

/-- Formations `0` and `3` at step `0`, `0` and `4` after. -/
def k2 (t : Nat) : Nat → Nat
  | 0 => 1
  | 1 => 0
  | 2 => 0
  | 3 => atFirst t
  | 4 => afterFirst t
  | _ + 5 => 0

/-- Formations `0`, `1`, `3`, `4` at every step. -/
def s1 (_ : Nat) : Nat → Nat
  | 0 => 1
  | 1 => 1
  | 2 => 0
  | 3 => 1
  | 4 => 1
  | _ + 5 => 0

/-- Formations `0`, `1`, `2`, `3` at every step. -/
def s2 (_ : Nat) : Nat → Nat
  | 0 => 1
  | 1 => 1
  | 2 => 1
  | 3 => 1
  | _ + 4 => 0

theorem zero_not {m : Nat → Nat} {t f : Nat} (zero : m f = 0) : ¬ web.Admits m t f :=
  fun admitted => Nat.lt_irrefl 0 (Eq.subst (motive := fun x => 0 < x) zero (admits_iff.mp admitted))

theorem one_admits {m : Nat → Nat} {t f : Nat} (one : m f = 1) : web.Admits m t f :=
  admits_iff.mpr (Eq.subst (motive := fun x => 0 < x) one.symm Nat.zero_lt_one)

theorem k1_keeps : web.KeepsWidening merge0 k1 0 :=
  ⟨includesAcross_of_zero fun _ => Nat.zero_lt_one,
   fun S _ => ⟨S + 1, Nat.le_succ S, ⟨2, one_admits rfl, fun _ linked _ => not_linked_succ linked⟩⟩⟩

theorem k2_keeps : web.KeepsWidening merge0 k2 0 :=
  ⟨includesAcross_of_zero fun _ => Nat.zero_lt_one,
   fun S _ => ⟨S + 1, Nat.le_succ S, ⟨4, one_admits rfl, fun _ linked _ => not_linked_succ linked⟩⟩⟩

theorem s1_wider_first : web.WidensUpTo 0 s1 k1 :=
  ⟨fun t f le admitted => match t, f, le, admitted with
     | 0, 0, _, _ => one_admits rfl
     | 0, 1, _, _ => one_admits rfl
     | 0, 2, _, admitted => absurd admitted (zero_not rfl)
     | 0, 3, _, _ => one_admits rfl
     | 0, _ + 4, _, admitted => absurd admitted (zero_not rfl)
     | t + 1, _, le, _ => absurd le (Nat.not_succ_le_zero t),
   ⟨0, 3, Nat.le_refl 0, one_admits rfl, zero_not rfl⟩⟩

theorem s2_wider_first : web.WidensUpTo 0 s2 k2 :=
  ⟨fun t f le admitted => match t, f, le, admitted with
     | 0, 0, _, _ => one_admits rfl
     | 0, 1, _, _ => one_admits rfl
     | 0, 2, _, _ => one_admits rfl
     | 0, 3, _, _ => one_admits rfl
     | 0, 4, _, admitted => absurd admitted (zero_not rfl)
     | 0, _ + 5, _, admitted => absurd admitted (zero_not rfl)
     | t + 1, _, le, _ => absurd le (Nat.not_succ_le_zero t),
   ⟨0, 1, Nat.le_refl 0, one_admits rfl, zero_not rfl⟩⟩

theorem mixed1 : web.Mixed k1 s1 :=
  ⟨⟨1, 2, one_admits rfl, zero_not rfl⟩, ⟨0, 3, one_admits rfl, zero_not rfl⟩⟩

theorem mixed2 : web.Mixed k2 s2 :=
  ⟨⟨1, 4, one_admits rfl, zero_not rfl⟩, ⟨0, 1, one_admits rfl, zero_not rfl⟩⟩

theorem listed1 : ∃ xs : List Nat, ∀ f, web.Admits (s1 0) 0 f → f ∈ xs :=
  ⟨[0, 1, 3, 4], fun f admitted => match f with
    | 0 => .head _
    | 1 => .tail _ (.head _)
    | 2 => absurd admitted (zero_not rfl)
    | 3 => .tail _ (.tail _ (.head _))
    | 4 => .tail _ (.tail _ (.tail _ (.head _)))
    | _ + 5 => absurd admitted (zero_not rfl)⟩

theorem listed2 : ∃ xs : List Nat, ∀ f, web.Admits (s2 0) 0 f → f ∈ xs :=
  ⟨[0, 1, 2, 3], fun f admitted => match f with
    | 0 => .head _
    | 1 => .tail _ (.head _)
    | 2 => .tail _ (.tail _ (.head _))
    | 3 => .tail _ (.tail _ (.tail _ (.head _)))
    | _ + 4 => absurd admitted (zero_not rfl)⟩

/-- The static course of the first pair widens the keeping course of the second. -/
theorem s1_widens_k2 : web.Widens s1 k2 :=
  ⟨fun _ f admitted => match f with
     | 0 => one_admits rfl
     | 1 => absurd admitted (zero_not rfl)
     | 2 => absurd admitted (zero_not rfl)
     | 3 => one_admits rfl
     | 4 => one_admits rfl
     | _ + 5 => absurd admitted (zero_not rfl),
   ⟨0, 1, one_admits rfl, zero_not rfl⟩⟩

/-- The static course of the second pair widens the keeping course of the first. -/
theorem s2_widens_k1 : web.Widens s2 k1 :=
  ⟨fun _ f admitted => match f with
     | 0 => one_admits rfl
     | 1 => one_admits rfl
     | 2 => one_admits rfl
     | _ + 3 => absurd admitted (zero_not rfl),
   ⟨0, 3, one_admits rfl, zero_not rfl⟩⟩

/-- The class with "keeps widening" read along `merge0` and the static course listed. -/
def AlongListed (k s : Nat → Nat → Nat) : Prop :=
  web.KeepsWidening merge0 k 0 ∧ web.AdmitsAlikeFrom s 0 ∧ web.WidensUpTo 0 s k ∧ web.Mixed k s ∧
    ∃ xs : List Nat, ∀ f, web.Admits (s 0) 0 f → f ∈ xs

theorem pair1 : AlongListed k1 s1 :=
  ⟨k1_keeps, fun _ _ _ => Iff.rfl, s1_wider_first, mixed1, listed1⟩

theorem pair2 : AlongListed k2 s2 :=
  ⟨k2_keeps, fun _ _ _ => Iff.rfl, s2_wider_first, mixed2, listed2⟩

/-- **P1.** With keeping widening read along a continuation, no strict partial order containing
widening ranks every keeping course above every listed static course that admits alike from the
first step, was wider up to it and is mixed with it. -/
theorem no_order_ranks_along_listed {R : (Nat → Nat → Nat) → (Nat → Nat → Nat) → Prop}
    (irrefl : ∀ a, ¬ R a a) (trans : ∀ {a b c}, R a b → R b c → R a c)
    (widening : ∀ {a b}, web.Widens a b → R a b)
    (ranks : ∀ k s, AlongListed k s → R k s) : False :=
  irrefl k1 (ranks_self_of_crossed trans widening s1_widens_k2 s2_widens_k1
    (ranks k1 s1 pair1) (ranks k2 s2 pair2))

end AlongMerge

/-! ## P2. The growing course widens neither mirror -/

namespace MirrorDirection

open Sides

/-- The growing course does not widen the mirror of the other course. -/
theorem not_growing_widens_swapped : ¬ web.Widens growing (swap firstAndOther) :=
  fun widens => Nat.not_succ_le_zero 4 (growing_true.mp (widens.1 0 (true, 5) swap_firstAndOther_true))

/-- The mirror of the growing course does not widen the other course. -/
theorem not_swapped_growing_widens : ¬ web.Widens (swap growing) firstAndOther :=
  fun widens => not_swap_growing_true (widens.1 0 (true, 0) (firstAndOther_true.mpr (Nat.le_refl 0)))

end MirrorDirection

/-! ## P3. An infinitely wide static course in the class, and yet a consistent ranking

The proposed 07 wording's "where the latter may admit infinitely many formations" is not a
sufficient condition on every web. Here the first side is all or nothing and the second side is
an initial segment: a static course can admit every formation of the first side, but no static
course includes a course keeping widening by name, so the class ranking is a strict partial order
containing widening. -/

namespace AllOrSegment

/-- The first side's formations need condition `true` at one; formation `(false, m)` needs
condition `false` at `m + 1`. -/
def needOf : Bool × Nat → Nat
  | (true, _) => 1
  | (false, m) => m + 1

def web : Web (Bool × Nat) Bool :=
  ⟨fun _ _ => 0, fun _ _ => True, fun _ f c => c = f.1, fun _ f _ => needOf f, fun _ _ _ => False⟩

theorem admits_iff {m : Bool → Nat} {t : Nat} {f : Bool × Nat} :
    web.Admits m t f ↔ needOf f ≤ m f.1 :=
  ⟨fun admitted => admitted f.1 rfl,
   fun le _ same => Eq.subst (motive := fun x => needOf f ≤ m x) same.symm le⟩

theorem true_of_one {m : Bool → Nat} {t n n' : Nat} (admitted : web.Admits m t (true, n)) :
    web.Admits m t (true, n') :=
  (admits_iff (t := t) (f := (true, n'))).mpr ((admits_iff (t := t) (f := (true, n))).mp admitted)

/-- An opening on the second side after every step. -/
theorem false_opening {k : Nat → Bool → Nat} (keeps : web.KeepsWidening itself k 0) (S : Nat) :
    ∃ U, S ≤ U ∧ ∃ m, web.Admits (k U) U (false, m) ∧ ¬ web.Admits (k S) S (false, m) :=
  match keeps.2 S (Nat.zero_le S) with
  | ⟨U, le, exceeds⟩ => match (exceedsAcross_itself_iff le).mp exceeds with
    | ⟨(false, m), admitted, before⟩ => ⟨U, le, m, admitted, before⟩
    | ⟨(true, _), admitted, _⟩ => match keeps.2 U (Nat.zero_le U) with
      | ⟨U', le', exceeds'⟩ => match (exceedsAcross_itself_iff le').mp exceeds' with
        | ⟨(true, _), _, before'⟩ => absurd (true_of_one admitted) before'
        | ⟨(false, m), admitted', before'⟩ =>
          ⟨U', Nat.le_trans le le', m, admitted', fun earlier =>
            before' ((includesAcross_itself_iff le).mp (keeps.1 S U (Nat.zero_le S) le) _ earlier)⟩

/-- A course keeping widening by name admits every formation of the second side at some step. -/
theorem reaches {k : Nat → Bool → Nat} (keeps : web.KeepsWidening itself k 0) :
    ∀ n, ∃ S, web.Admits (k S) S (false, n)
  | 0 => match false_opening keeps 0 with
    | ⟨U, _, m, admitted, _⟩ =>
      ⟨U, admits_iff.mpr (Nat.le_trans (Nat.succ_le_succ (Nat.zero_le m)) (admits_iff.mp admitted))⟩
  | n + 1 => match reaches keeps n with
    | ⟨S, at_S⟩ => match false_opening keeps S with
      | ⟨U, _, m, admitted, before⟩ =>
        have below : k S false < m + 1 :=
          Nat.gt_of_not_le fun le => before (admits_iff.mpr le)
        have lt : n + 1 < m + 1 := Nat.lt_of_le_of_lt (admits_iff.mp at_S) below
        ⟨U, admits_iff.mpr (Nat.le_trans lt (admits_iff.mp admitted))⟩

/-- No static course includes a course keeping widening by name. -/
theorem not_static_includes {k s : Nat → Bool → Nat} (keeps : web.KeepsWidening itself k 0)
    (alike : web.AdmitsAlikeFrom s 0) (includes : web.Includes s k) : False :=
  match reaches keeps (s 0 false) with
  | ⟨S, admitted⟩ =>
    Nat.not_succ_le_self (s 0 false)
      (admits_iff.mp ((alike S (false, s 0 false) (Nat.zero_le S)).mp (includes S _ admitted)))

/-- The class of `RanksKeepingOverAlike`. -/
def InClass (k s : Nat → Bool → Nat) : Prop :=
  web.KeepsWidening itself k 0 ∧ web.AdmitsAlikeFrom s 0 ∧ web.WidensUpTo 0 s k ∧ web.Mixed k s

/-- Widening, with every course including a keeping course put above every course its static
course includes. -/
def classOrder (a b : Nat → Bool → Nat) : Prop :=
  web.Widens a b ∨ ∃ k s, web.Includes a k ∧ InClass k s ∧ web.Includes s b

theorem classOrder_irrefl (a : Nat → Bool → Nat) : ¬ classOrder a a
  | .inl widens => widens.not_reverse widens
  | .inr ⟨_, _, ak, ⟨keeps, alike, _, _⟩, sa⟩ => not_static_includes keeps alike (sa.trans ak)

theorem classOrder_trans {a b c : Nat → Bool → Nat} :
    classOrder a b → classOrder b c → classOrder a c
  | .inl first, .inl second => .inl (first.trans second)
  | .inl first, .inr ⟨k, s, bk, pair, sc⟩ => .inr ⟨k, s, first.1.trans bk, pair, sc⟩
  | .inr ⟨k, s, ak, pair, sb⟩, .inl second => .inr ⟨k, s, ak, pair, sb.trans second.1⟩
  | .inr ⟨_, _, _, ⟨_, alike, _, _⟩, sb⟩, .inr ⟨_, _, bk, ⟨keeps, _, _, _⟩, _⟩ =>
      (not_static_includes keeps alike (sb.trans bk)).elim

/-- The second side rising: `(false, m)` admitted at step `t` for `m ≤ t`. -/
def rising (t : Nat) : Bool → Nat
  | true => 0
  | false => t + 1

/-- Every formation of the first side, and `(false, 0)`, at every step. -/
def wide (_ : Nat) : Bool → Nat
  | true => 1
  | false => 1

theorem rising_keeps : web.KeepsWidening itself rising 0 :=
  ⟨fun _ _ _ le => (includesAcross_itself_iff le).mpr fun f admitted => match f with
      | (true, _) => absurd (admits_iff.mp admitted) (Nat.not_succ_le_zero 0)
      | (false, _) => admits_iff.mpr (Nat.le_trans (admits_iff.mp admitted) (Nat.succ_le_succ le)),
   fun S _ => ⟨S + 1, Nat.le_succ S, (exceedsAcross_itself_iff (Nat.le_succ S)).mpr
      ⟨(false, S + 1), admits_iff.mpr (Nat.le_refl _),
       fun admitted => Nat.not_succ_le_self (S + 1) (admits_iff.mp admitted)⟩⟩⟩

theorem pair : InClass rising wide :=
  ⟨rising_keeps, fun _ _ _ => Iff.rfl,
   ⟨fun _ f le admitted => match f with
      | (true, _) => absurd (admits_iff.mp admitted) (Nat.not_succ_le_zero 0)
      | (false, _) => admits_iff.mpr (Nat.le_trans (admits_iff.mp admitted) (Nat.succ_le_succ le)),
    ⟨0, (true, 0), Nat.le_refl 0, admits_iff.mpr (Nat.le_refl 1),
     fun admitted => Nat.not_succ_le_zero 0 (admits_iff.mp admitted)⟩⟩,
   ⟨⟨1, (false, 1), admits_iff.mpr (Nat.le_refl 2),
     fun admitted => Nat.not_succ_le_self 1 (admits_iff.mp admitted)⟩,
    ⟨0, (true, 0), admits_iff.mpr (Nat.le_refl 1),
     fun admitted => Nat.not_succ_le_zero 0 (admits_iff.mp admitted)⟩⟩⟩

/-- The first side's formations below `n`. -/
def trues : Nat → List (Bool × Nat)
  | 0 => []
  | n + 1 => (true, n) :: trues n

theorem trues_below : ∀ {n : Nat} {f : Bool × Nat}, f ∈ trues n → f.2 < n
  | 0, _, mem => nomatch mem
  | n + 1, _, mem => match mem_cons_cases mem with
    | .inl same => Eq.subst (motive := fun x => Prod.snd x < n + 1) same.symm (Nat.lt_succ_self n)
    | .inr rest => Nat.lt_trans (trues_below rest) (Nat.lt_succ_self n)

theorem trues_distinct : ∀ n, Distinct (trues n)
  | 0 => trivial
  | n + 1 => ⟨fun mem => Nat.lt_irrefl n (trues_below mem), trues_distinct n⟩

theorem trues_length : ∀ n, (trues n).length = n
  | 0 => rfl
  | n + 1 => congrArg Nat.succ (trues_length n)

theorem trues_fst : ∀ {n : Nat} {f : Bool × Nat}, f ∈ trues n → f.1 = true
  | 0, _, mem => nomatch mem
  | _ + 1, _, mem => match mem_cons_cases mem with
    | .inl same => congrArg Prod.fst same
    | .inr rest => trues_fst rest

/-- The wide course admits every formation of the first side: no list holds its admissions. -/
theorem wide_not_listed : ¬ ∃ xs : List (Bool × Nat), ∀ f, web.Admits (wide 0) 0 f → f ∈ xs :=
  fun ⟨xs, within⟩ =>
    Nat.not_succ_le_self xs.length
      (Eq.subst (motive := fun n => n ≤ xs.length) (trues_length (xs.length + 1))
        (length_le_of_sub (trues_distinct (xs.length + 1)) fun f mem => match f, trues_fst mem with
          | (true, _), _ => within _ (admits_iff.mpr (Nat.le_refl 1))
          | (false, _), same => Bool.noConfusion same))

/-- **P3.** On this web some pair of the class has a static course no list holds, and yet a
strict partial order containing widening ranks every pair of the class. -/
theorem consistent_with_infinite :
    InClass rising wide ∧ (¬ ∃ xs : List (Bool × Nat), ∀ f, web.Admits (wide 0) 0 f → f ∈ xs) ∧
      (∀ a, ¬ classOrder a a) ∧ (∀ {a b c}, classOrder a b → classOrder b c → classOrder a c) ∧
      (∀ {a b}, web.Widens a b → classOrder a b) ∧ web.RanksKeepingOverAlike classOrder :=
  ⟨pair, wide_not_listed, classOrder_irrefl, classOrder_trans, fun widens => .inl widens,
   fun l l' keeps alike wider mixed => .inr ⟨l, l', Includes.refl l, ⟨keeps, alike, wider, mixed⟩,
     Includes.refl l'⟩⟩

end AllOrSegment

/-! ## P4. The other lags' orders are instances of the one order lemma -/

section OtherLags

variable {F C : Type} {W : Web F C}

/-- Widening joined to the strict part of `P`. -/
def Join (P : (Nat → C → Nat) → (Nat → C → Nat) → Prop) (W : Web F C) (a b : Nat → C → Nat) : Prop :=
  W.Widens a b ∨ (P a b ∧ ¬ P b a)

theorem formationLagOrder :
    (∀ a, ¬ Join W.IncludesWithFormationLag W a a) ∧
      (∀ {a b c}, Join W.IncludesWithFormationLag W a b → Join W.IncludesWithFormationLag W b c →
        Join W.IncludesWithFormationLag W a c) ∧
      (∀ {a b}, W.Widens a b → Join W.IncludesWithFormationLag W a b) :=
  strictJoin_order (W := W) (P := W.IncludesWithFormationLag) IncludesWithFormationLag.trans
    IncludesWithFormationLag.of_includes

theorem eachLagOrder :
    (∀ a, ¬ Join W.IncludesEachLater W a a) ∧
      (∀ {a b c}, Join W.IncludesEachLater W a b → Join W.IncludesEachLater W b c →
        Join W.IncludesEachLater W a c) ∧
      (∀ {a b}, W.Widens a b → Join W.IncludesEachLater W a b) :=
  strictJoin_order (W := W) (P := W.IncludesEachLater) IncludesEachLater.trans
    IncludesEachLater.of_includes

end OtherLags

/-! ## P5. The landed `Web.Linked.snoc` (KeepingWidening) is a case of the kit's `Web.Linked.append`

The statement below is `Web.Linked.snoc`'s, copied; the proof is one use of `Linked.append`. -/

theorem snoc_of_append {F : Type} {R : Nat → F → F → Prop} :
    ∀ {s : Nat} {f : F} {t : Nat} {g h : F}, Linked R s f t g → R t g h → Linked R s f (t + 1) h :=
  fun rest r => Linked.append rest (.next r (.here _ _))

/-! ## P6. A lag for each admission can rank a course above one whose lasting admission it drops

On the own-condition web `steady` admits formation `0` at every step; `alternate` admits it at even
steps only, and formation `1` at step `0`. The per-admission lag's order ranks `alternate` above
`steady`, yet `alternate` does not keep what `steady` keeps. A lag varying with the formation does
keep it, as the uniform lag does (`WidensOrWithLag.keepsWhatKept`). So law 4 tells the lag's forms
apart. -/

namespace EachLagKeeps

open OwnCondition

/-- One at even steps, zero at odd ones. -/
def evenLevel : Nat → Nat
  | 0 => 1
  | 1 => 0
  | n + 2 => evenLevel n

theorem even_or_next : ∀ t, 0 < evenLevel t ∨ 0 < evenLevel (t + 1)
  | 0 => .inl Nat.zero_lt_one
  | 1 => .inr Nat.zero_lt_one
  | n + 2 => even_or_next n

theorem odd_or_next : ∀ t, evenLevel t = 0 ∨ evenLevel (t + 1) = 0
  | 0 => .inr rfl
  | 1 => .inl rfl
  | n + 2 => odd_or_next n

/-- One at step `0`, zero after. -/
def atZero : Nat → Nat
  | 0 => 1
  | _ + 1 => 0

/-- Formation `0` at every step. -/
def steady (_ : Nat) : Nat → Nat
  | 0 => 1
  | _ + 1 => 0

/-- Formation `0` at even steps, and formation `1` at step `0`. -/
def alternate (t : Nat) : Nat → Nat
  | 0 => evenLevel t
  | 1 => atZero t
  | _ + 2 => 0

theorem steady_zero {t : Nat} : web.Admits (steady t) t 0 :=
  admits_iff.mpr Nat.zero_lt_one

theorem steady_only {t f : Nat} (admitted : web.Admits (steady t) t f) : f = 0 :=
  match f, admitted with
  | 0, _ => rfl
  | _ + 1, admitted => absurd (admits_iff.mp admitted) (Nat.lt_irrefl 0)

theorem not_steady_one {t : Nat} : ¬ web.Admits (steady t) t 1 :=
  fun admitted => Nat.lt_irrefl 0 (admits_iff.mp admitted)

theorem alternate_one : web.Admits (alternate 0) 0 1 :=
  admits_iff.mpr Nat.zero_lt_one

/-- Each admission of `steady` is answered by `alternate` at the same step or the next. -/
theorem includesEachLater : web.IncludesEachLater alternate steady :=
  fun t _ admitted =>
    Eq.subst (motive := fun g => ∃ d, web.Admits (alternate (t + d)) (t + d) g)
      (steady_only admitted).symm
      (match even_or_next t with
       | .inl pos => ⟨0, admits_iff.mpr pos⟩
       | .inr pos => ⟨1, admits_iff.mpr pos⟩)

/-- `steady` never answers `alternate`'s admission of formation `1`. -/
theorem not_back : ¬ web.IncludesEachLater steady alternate :=
  fun includes => match includes 0 1 alternate_one with
    | ⟨_, admitted⟩ => not_steady_one admitted

/-- `alternate` does not keep what `steady` keeps. -/
theorem not_keeps : ¬ web.KeepsWhatKept alternate steady :=
  fun keeps => match keeps 0 ⟨0, fun _ _ => steady_zero⟩ with
    | ⟨T, kept⟩ => match odd_or_next T with
      | .inl zero => Nat.lt_irrefl 0 (Eq.subst (motive := fun x => 0 < x) zero
          ((admits_iff (m := alternate T)).mp (kept T (Nat.le_refl T))))
      | .inr zero => Nat.lt_irrefl 0 (Eq.subst (motive := fun x => 0 < x) zero
          ((admits_iff (m := alternate (T + 1))).mp (kept (T + 1) (Nat.le_succ T))))

/-- **P6.** The per-admission lag's order ranks `alternate` above `steady`, which keeps a formation
`alternate` does not keep; widening or widening with a lag does not rank them so. -/
theorem eachLag_not_keeping :
    Join web.IncludesEachLater web alternate steady ∧ ¬ web.KeepsWhatKept alternate steady ∧
      ¬ web.WidensOrWithLag alternate steady :=
  ⟨.inr ⟨includesEachLater, not_back⟩, not_keeps, fun ranks => not_keeps ranks.keepsWhatKept⟩

end EachLagKeeps

/-- A lag varying with the formation keeps what the other keeps, on every web. -/
theorem formationLag_keeps {F C : Type} {W : Web F C} {l l' : Nat → C → Nat}
    (lagged : W.IncludesWithFormationLag l l') : W.KeepsWhatKept l l' :=
  match lagged with
  | ⟨d, includes⟩ => fun f ⟨T, kept⟩ => ⟨T + d f, fun _ le => match le_dest le with
    | ⟨k, same⟩ =>
      have shifted : W.Admits (l (T + k + d f)) (T + k + d f) f :=
        includes (T + k) f (kept (T + k) (Nat.le_add_right T k))
      Eq.subst (motive := fun x => W.Admits (l x) x f)
        ((Nat.add_right_comm T k (d f)).trans same.symm) shifted⟩

end ReCheckUE9
end Becoming

#print axioms Becoming.ReCheckUE9.AlongMerge.no_order_ranks_along_listed
#print axioms Becoming.ReCheckUE9.MirrorDirection.not_growing_widens_swapped
#print axioms Becoming.ReCheckUE9.MirrorDirection.not_swapped_growing_widens
#print axioms Becoming.ReCheckUE9.AllOrSegment.consistent_with_infinite
#print axioms Becoming.ReCheckUE9.formationLagOrder
#print axioms Becoming.ReCheckUE9.eachLagOrder
#print axioms Becoming.ReCheckUE9.snoc_of_append
#print axioms Becoming.ReCheckUE9.EachLagKeeps.eachLag_not_keeping
#print axioms Becoming.ReCheckUE9.formationLag_keeps
#print axioms Nat.succ_ne_zero
#print axioms Bool.not_not
```
