# WRT: the independent review of the design

One independent reviewer, an Opus subagent working read-only and building nothing, read [DESIGN.md](DESIGN.md) as drafted on main at `155d53242`. It read the design against the Lean, the scratch check and the chapters; OU3d landed (`4fcfc7011`) while it read. Its report follows. It is lightly formatted: HTML entities are restored to `=>`, `<` and `>`, and the path abbreviations are kept as the reviewer defined them. The design's revision answers it. Until that revision is reviewed again, no item is proposed.

**Paths.** D = DESIGN.md; K = `check/tree/Becoming/WRTCheck.lean`; L = `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`; C = `theories/becoming/chapters/`.

**Head moved during the review.** OU3d landed (`4fcfc7011`), adding to GrammarLaws only. No statement the design cites changed; GrammarLaws line numbers below are at the new head.

**What checks out.**
- K states exactly what D claims for its 14 theorems. The check tree's sources match the package byte for byte.
- Checked by hand, not compiled:
  - `arisingRecurs_iff` and `ceasingRecurs_iff` as written, including the empty-world conjunct (a real catch);
  - `reidentify_carries` for its three relations;
  - `conserves_difunctional`.
- Every term in WRT1's list transports along a bijection. «核», «生生», «息» and «所及» need only the inverse laws, and none needs more than a bijection.
- The realizability remark is true, with the hypotheses noted in finding 5.

## Blocking

1. **The model holds classes, but the instance theorems and F3 read the predicates.**
   - *Where:* §1.2's table lists every determination as a "class"; §1.4(a) says "with a two-valued class"; F3 says "It fails at a grammar model with a fall everywhere. So it is an image condition" (D:180–181).
   - *Evidence:* the forward statements read the predicate: L/Arising.lean:713–714 (`W.active (t + 1) f ∧ «生» …`), D:249–253, and F3's hypothesis `falls : Falls w x` (K:103).
   - *Witness (hand-checked):* `ofActivity Unit (fun x => x.1 = 0)` and `ofActivity Unit (fun x => ¬ x.1 = 0)` agree pointwise on every relation of §1.2. The second arises across step 0; the first never arises.
   - *F3's counter-model lies in the image:* with Q := True, K:131–133 makes it ofActivity's activity model. It is also, pointwise, `World.idle`'s falls class: levels are t ↦ t (L/Space.lean:464), so nothing ever falls.
   - *Fix:* the model holds each determination as a predicate, a marked block or a coreflexive relation, as L/GrammarLaws.lean:122 reads what a path admits. WRT1 adds "e carries P to P′", and F3 is stated on the marked structure.

2. **The "name-free part" as defined still reads the names, and it leaves out the relations that are name-free.**
   - *Where:* D:64, "Without the names' step, it is the name-free part"; also D:25 and D:72.
   - *What still reads the names:*
     - `carrierClass` uses `sameFormation` (L/PatternPassing.lean:371, 375).
     - `dependenceClass c` fixes one condition across steps (L/ContinuedClasses.lean:820), while `World.reidentify` renames conditions at each step (L/Persistence.lean:499–506).
     - `Falls` compares one name at t and at t+1 (K:99–100), while the re-identified level at t+1 reads `σ.old (t+1)` (L/Persistence.lean:503).
     - The map (t, x) ↦ (t, σ.old t x) carries none of these. WRT2 proves carrying for three relations only (D:265–268).
   - *What is left out though name-free:* the same-step binary relations: requires, draws, need ≤ level, 0 < give and 0 < take.
     - These are carried, since both arguments are read through σ.old t (L/Persistence.lean:500–506).
     - §1.2 omits them, although "x is a condition of y" is the main reading of 缘 (L/Grammar.lean:31), and Arising records that it omits them (L/Arising.lean:610–611).
     - F1's `Relations` (K:62–69) is built from exactly these.
   - *Fix:*
     - List the name-free part explicitly: the same-step class, conservation's step, the per-snapshot predicates and the same-step relations. Prove carrying for all of it.
     - Move the carrier class, `dependenceClass c` and `Falls` to the full model.
     - Restrict the "grading" claim (D:88) to the step 缘: same-step dependence can loop (`requires t f f`).

3. **F1 contradicts the design's own model, and §1.4's "forgets the amounts (F1)" is unsupported.**
   - *Where:* D:35, "Two worlds alike in every relation … differ in balance"; D:95.
   - *Evidence:* the two worlds differ in conservation's step. `World.idle` is balanced (L/Space.lean:473), so (t,()) conserves into (t+1,()). On Unit, idleTwice's `Conserves t () ()` is its balance at t, which fails at every step (K:57–58). Balance is in fact a grammar statement at the model (D:123, D:255–256).
   - *Fix:* restate F1 as "balance is not determined by the model without conservation's step", and rename `Relations`.
   - *Witness for D:95 (hand-checked):* `World.of Unit Flow.still (Witnesses.unrequired (fun _ _ => 1) (fun _ _ => False))` and the same world with 2. They agree on every relation and predicate, conservation included (full in both), falls, standing and needs. Only the levels differ.

## Significant

4. **Transport does not make the forward direction uniform.**
   - *Where:* D:70, "Transport makes the direction uniform"; D:24, "carries every grammar term".
   - *The direction:* WRT1 (D:214–220) gives "term ⇒ invariant". The forward direction (D:70) needs the converse: relational ⇒ some term. With a shallow embedding there is no syntax of terms, so the direction is a schema, discharged notion by notion. Ψ (D:68) is not a grammar term.
   - *"Every term" outruns the list:*
     - Grammar's «位核», «粗», «粗复生», «自持», «相须», «因于», «足以定理», «因于核» and «相须核» (L/Grammar.lean:448–590);
     - GrammarMap's «延», «尽», «生成», «守», «退化», «新而有终», «新而尽», «阶全生成» and «阶生成» (L/GrammarMap.lean:85–318);
     - all of GrammarLaws' terms. GrammarTransport would import only GrammarMap.
   - *Fix:* call the forward direction a schema, and say WRT1's role is to make each instanced notion invariant under correspondence. Either cover all terms or say "the listed terms".

5. **The converse is not characterized.**
   - *Where:* D:95, "with its image characterized"; D:87, "exactly these"; D:84, "not proposed"; D:32 and D:91, "two conditions".
   - *Realizability:* it needs an inhabitant r0 and the labels as data: λ_t : R → Nat and μ_t : R → Option Nat.
     - Taken and given are totals over `present` (L/World.lean:76–81), so a partial μ needs some relatum present to take.
     - Construction: present := [r0], give := μ, take := level t g (plus 1 where μ g = none). Step 0 is free.
   - *A joint condition (hand-checked):* if g conserves into both f and f′ at t, and h into both at t+1, then Falls(t+1, f) ↔ Falls(t+1, f′), by K:47–51 twice and K:99–100. The design's projections do not express this.
   - *A missed condition:* `Conserves` is a Nat equation (L/Persistence.lean:510–511), so it is decided. `continuationStep (fun _ _ _ => Q)` on Nat × Unit is some World's conservation step iff Q ∨ ¬Q (hand-checked).
   - *Fix:* propose realizability with these hypotheses, add decidedness as an image condition, and scope "exactly". Until then, "closes" for OU's criterion 7 is not earned.

6. **«像» already maps carriers.**
   - *Where:* D:48, "states no map between carriers"; D:119 (M1), "No other term is transported".
   - *Evidence:* «像» (L/GrammarLaws.lean:1208) and «像定后当且仅当同行» (:1213), which 01 §7 cites (C/01-ROOT.md:163). 01 §8.6's own "no counting and no map of carriers" (C/01-ROOT.md:300) already contradicts §7's «对» (:160) and «像».
   - *Re-identification laws that exist:* `continuing_reidentify` (L/ContinuedClasses.lean:167), `metAboveAlong_reidentify` (:454), `widensAcross_reidentify` (:593) and `rename_*` (L/Identity.lean:241–270).
   - *Fix:* define «携» through «像» (e.«携» R R′ ↔ «谓» («像» e.to R) R′). Say that re-deriving these through WRT1 is rerouting (PLAN §十三's last line), not new results.

7. **The audit misses existing pieces.**
   - `World.balanced_reidentify_iff` (L/Persistence.lean:531, no premise) is M3's content for every naming, so `balanced_iff_within` is a respelling.
   - `World.conserves_iff` (:551) is (c)'s labelling for balanced worlds.
   - `World.of` (L/World.lean:124) builds a World from any web, so M5's "Nothing exists" (D:130) is overstated.
   - `conserves_reidentify` is pointwise `σ.carry w.Conserves` (L/ContinuedClasses.lean:140–141), which brings in the whole `_reidentify` family.
   - `Web.itself` (:197) is D:57's names continuation. No lemma relates it to `Steps.along`, and the audit's rows mix the two (L/Arising.lean:713 vs L/Persistence.lean:1231).

8. **F3 belongs with the rest master law.**
   - *Existing laws of this kind:*
     - `Amounts.falls_end` (L/Amounts.lean:195–196) is «尽» for courses of least falls, the input to «尽则不屡» (L/GrammarLaws.lean:1093; C/01-ROOT.md:162).
     - MapInstances' `consumed_held_not_endless` (:272) and `family_excess_not_endless` (:289) are amount laws concluding ¬«不穷», F3's kind.
     - 08 §12 item 6 asks about "the absence of an endless fall" (C/08-METHOD.md:645).
   - *A stronger F3:* «尽» is provable by induction on the level, and «尽则非不穷» (L/GrammarMap.lean:235) then gives F3.
   - *The reading over-reads:* at D:185 the coarse class is "alike in falling" itself. A resource falling under another pattern is `dissipation_arising_not_recurring`'s case (L/Arising.lean:208).
   - *Fix:* state F3 with «尽», link it to these laws, and reword the reading.

9. **F2 omits hypotheses and duplicates existing work.**
   - `balanced_reidentify_iff_alike` needs `balanced` (L/Persistence.lean:560); D:165 omits it.
   - D:167, "all distinct has its names as conservation's continuation", needs balance at that step.
   - The reading about the unfolding is already `World.fixed_iff` and `continues_as_alike` (L/Persistence.lean:720; L/ContinuedClasses.lean:488; C/08-METHOD.md:647).
   - `no_injection` follows from `Diagonal.claims_incomplete` (L/Diagonal.lean:103), with ψ n m := ∃ A, i A = n ∧ A m.
   - Constructively, F2 gives "not identity", not two relata alike.

10. **Results are over-counted.**
    - WRT1 is the invariance of definable terms under bijection, a fact of the definitional style: a lemma of the item that needs it, not a record.
    - Near-definitional:
      - `balanced_iff_within`;
      - `ofActivity_class`, proved by rfl and stated with `=` of relations, against L/Grammar.lean:36–37;
      - `sameStep_class`;
      - `reidentify_correspondence` and `reidentify_carries`;
      - `conserves_difunctional`;
      - converse (a) and (b);
      - D:271's "pattern for every other".
    - *Fix:* one record for the World's representation, with WRT1 as its lemma module.

11. **Two senses of "both ways".** 08 §7's "represented both ways" means each anchor ↔ its grammar term (C/08-METHOD.md:429–434). OU criterion 7's 两个方向 means forward plus converse (PLAN.md:447). D §1 and D:151 merge the two; name both.

12. **The landing text is inaccurate.**
    - D:329: the World's representation is shown not faithful, so 01 Open's entry (C/01-ROOT.md:540) should say so rather than drop it.
    - D:330: 08 §6's Open items concern pairing, power and Lean; the World item is in 08's Open list (C/08-METHOD.md:717).
    - Missing:
      - C/01-ROOT.md:535;
      - LOGIC L-21 (theories/becoming/review/LOGIC.md:639);
      - the overview (THE-THEORY-OF-BECOMING.md:46 and 224).
    - D:326, "change no existing file's Lean": `Becoming.lean`'s imports and the CORE list in `check_becoming.py` (line 72) must change.

## Minor

13. The passing row (D:110) says "yes" both ways, but PatternPassing has one way only (L/PatternPassing.lean:360, 430).
14. Audit rows omit hypotheses:
    - `abides_iff` needs `after` (L/Identity.lean:2172);
    - `held_iff_line` needs `held` (L/ContinuedClasses.lean:864);
    - `carries_iff` needs `start` (L/MapInstances.lean:138);
    - `passing_carries_iff` needs `carrier` (:153).
15. "Nothing supplied" (D:52) is false for `stateClass`, which takes h (L/Persistence.lean:1191, 1155). Fix h := `Web.Holds` (:117).
16. The census is not an amount. `World.Counted` (L/InAmounts.lean:333; `Listed`, L/Population.lean:446) is invariant under re-identification, so it belongs in the forward direction (D:125). Embodiment is missing from M3.
17. M3's title, "Balance at the name-free part", is wrong: its statement uses the names' step.
18. D:147, "two such models": there is a third, `World.withRest_closed_iff` (L/Reading.lean:403) with `Flow.balances_iff_idle` (L/Imbalance.lean:121).
19. Names:
    - «对应» names any correspondence; the structure is «一一对应».
    - «携» overlaps `σ.carry`, «传» and `carries_iff`.
    - `World.Falls` duplicates `Web.Falls` (L/Arising.lean:105).
    - `World.Relations` is inexact.
    - `World.no_injection_of_predicates` is not a World fact.
    - Relate `Reidentify` (L/Identity.lean:149) to «一一对应» at each step.
20. Importing Space is redundant: Persistence → Unfolding → Space (L/Unfolding.lean:3).
21. D:81: "in the image up to correspondence" is definitional, and "two-valued class" is never defined.
22. The recurrence forms spell reflexive reach two ways (D:249, D:252); «所闭» (L/GrammarLaws.lean:213) would serve both.
23. Q55 (D:95): its first half, whether audit, lifting and representation make a sound criterion, is unanswered. The interpretation is a faithful but not full functor on re-identifications.
24. Rebuild the scratch check at `4fcfc7011`.

## Verdict

Needs another pass. Before any item is proposed, §1–§3 need three fixes:
- the model holds the determinations' predicates and the same-step relations;
- the name-free part is redefined as exactly what re-identification carries;
- F1 and "forgets the amounts" are restated against conservation's step, with a faithfulness witness.

Once these are done, the rest follows fairly directly: F3 with its marked predicate, the converse's missing inclusion, decidedness, the joint conditions, and the record structure (WRT1 as lemmas).

## Second pass

The same reviewer, under the same rules (read-only, no builds), read the first revision, the second scratch file and the build log at main `80c4c40d6`. Its report follows, lightly formatted as before. Its D and K2 line numbers are those of the first revision. Every finding is taken, and DESIGN.md §6 says how.

**Overview.** The revision fixes all three blocking problems, the four checked statements named do prove what the design says, and nothing needs restructuring. It is still not ready to propose as written: five statements are false or overreach, and they would go straight into the record and the live text (findings 1–5). All five are local, and only one needs a Lean change and a rebuild.

**Question 2: the checked statements.** All of these state what D says, and scratch-9 audits all 28 theorems with no axioms.
- `falls_exhaust` (K2:43–60) really does come from `Amounts.falls_end` at `Amounts.whole` with least loss one, through `jin_pullback` (K2:22–33). Each step along the line is a reflexive «所闭» of "no rise" followed by one least fall, and `«尽则非不穷»` then gives `falls_not_endless`.
- `conservation_iff_decided` (K2:76–87) is exactly D:112.
- `ofExchange_conserves` (K2:174–188) is exact, given a relatum r₀.
  - Every World's conservation has the debit–credit form by definition (credit := level + given, debit := taken; L/Persistence.lean:510–511). That half is near-definitional, and should be called so, as balance's is.
  - The content is the other half: with one relatum exchanging, debit and credit are arbitrary.
- `withinStep_carried` (K2:118–125) is checked as a general lemma and applied only at requiring (K2:128–131). Drawing, a need met, giving and taking hold by definition (L/Persistence.lean:500–506); D:293 should say so.
- `present_carried`, `carries_iff_image`, and `no_injection` through `Diagonal.claims_incomplete` are as claimed.
- `standingAt_alike`'s Lean is what D shows, but its prose is false (finding 1).

**Question 1: findings 1–24.**
- Taken: 1, 4, 9, 11, 13–18 and 22.
- Taken, with a new problem:
  - 2 (findings 2, 6 and 7 below);
  - 3 (finding 1);
  - 5 (finding 8);
  - 6 (finding 4);
  - 8 (finding 12);
  - 10 and 20 (finding 13);
  - 12 (finding 14);
  - 23 (finding 11);
  - 24 (finding 9).
- Dropped or taken only in words, although §6 says every one was taken:
  - 7: `World.conserves_iff` (L/Persistence.lean:551) is cited nowhere;
  - 19: relating `Reidentify` to «一一对应» at each step is not done;
  - 21: "up to correspondence is definitional" appears only in §6 (D:349), never in §1.5.

### New findings

1. **[significant] F1's witness fails when one standing is 0.**
   - *Where:* D:188, "Every relation and mark of the occurrence model agrees"; also D:37.
   - *Evidence:* the standing mark `0 < level` is part of the name-free part (D:77), but `standingAt_alike` leaves it out (K2:96–110). For k = 0 and k′ = 1 that mark differs.
   - *Fix:* require 0 < k and 0 < k′, add the standing conjunct, and rebuild.
2. **[significant] "Exactly what every re-identification carries" is false** (D:27, D:69, D:336). That wording came from the first verdict, and it was too strong.
   - *What else is carried:* every field is read through σ.old t (L/Persistence.lean:499–506), so a re-identification also carries:
     - marks such as "level = k";
     - the order of two standings within one step;
     - comparisons between the standings of occurrences on either side of a step;
     - the step order itself (y.1 = x.1 + 1);
     - how often a relatum appears in the presence list.
   - *Why it matters:* F1 and the step-permutation example in the Q55 answer (D:132) hold only because the part leaves these out.
   - *Fix:* define the part as "reads no name at two steps", which is enough for re-identification to carry it. Then state the selection as a choice: amounts are read only by sign, against a need, and in conservation's equation; the index only through the same-step class.
3. **[significant] "The World's undecided part is its activity" is false** (D:113).
   - *Evidence:* requiring and drawing are propositions too (L/World.lean:90, 92). `law_iff_positions` (L/Space.lean:1113) concerns only activity's positions; "exactly excluded middle" is `law_iff_em` (:1017).
   - *Fix:* name activity, requiring and drawing as the undecided relations. Say that the finite-world law needs activity decided, and that embodiment supplies the decision (`World.Embodied.decided`, L/Standing.lean:107–109).
4. **[significant] Most of the "existing re-identification laws" are not cases of WRT2's re-identification** (D:102).
   - `World.balanced_reidentify_iff` is not an invariance law: balance reads the names, and the law says when a re-identification keeps it.
   - `metAboveAlong_reidentify`, `widensAcross_reidentify` and `rename_*` use `Web.reidentify`, which renames formations only and keeps conditions fixed (L/Identity.lean:183–189). WRT2's re-identification renames both roles.
   - Only `line_reidentify` and `continuing_reidentify` are cases.
   - *Fix:* split the list into these three groups.
5. **[significant] The step index is also a commitment.**
   - *Evidence:* 01 §9.6 says only the partial order of joined exchanges shows (C/01-ROOT.md:428), and §10 lists the shared index as a commitment (:519). UE15's record (theories/becoming/results/records/reorderings-as-courses-of-growth.md:43) calls the interleavings "one aspect" of this very theorem.
   - *Fix:* list reorderings and stuttering among the record's boundaries, and add that record (its JSON) to the landing list.
6. **[minor]** `reidentify_carries` (D:289–293) leaves out the standing mark.
7. **[minor] The requiring relation points the wrong way.** `withinStep requires` relates (t,f) to (t,c) (K2:115–116). Read as "x is a condition of y" (L/Grammar.lean:31), that reverses D:76's gloss "c a condition of f". Use «逆» of the relation as the 缘, or drop that reading.
8. **[minor]** D:126's "uses one of these" contradicts D:116's "the listed conditions do not exhaust the image".
9. **[minor] The build head is misreported.** The build ran at 16:02, after OU3e landed at 16:01, and its `Labelled.lean` equals `406ed1303`'s, not `ef7706a57`'s. No WRT statement depends on it; correct D:5 and D:13.
10. **[minor] "Mark" clashes** with 01 §3's "the four marks" (C/01-ROOT.md:70; GLOSSARY.md:14). 01 §7 already says "partial identity" (C/01-ROOT.md:164); use that. "Occurrence model" also needs a glossary line.
11. **[minor] The Q55 answer needs two corrections.**
    - D:132 should say "a correspondence *of the name-free part*": one that carries the names fixes the index.
    - D:134's "the three are independent" is not what F3 shows. F3 shows that the three, without the converse, do not make a grammar law.
12. **[minor] Small inaccuracies.**
    - D:232's F3 "reads that law" (the rest law); F3 reads `falls_end`.
    - K2:58–60 re-proves `Amounts.whole_within` (L/Amounts.lean:413) inline; use it.
    - `ceasingRecurs_iff` comes from `Web.ceases_iff_wang` (L/Change.lean:945), not from `unceasing_iff_late_beginnings` (D:286).
    - D:87's "the instance theorems use three" classes omits `dependenceClass c`, «一» and `Steps.alike p`.
    - WRT1's stated criterion (D:269) fits «延» and «复生至» poorly: no module outside the grammar reads them.
13. **[minor] Record and imports.** The record list (D:306–311) omits F2; add it as a witness to the labelling. Importing `Becoming.Amounts` is redundant (Persistence → Unfolding → Space → InAmounts → Amounts).
14. **[minor] The landing list misses three things.**
    - The Lean package README rows for both modules, in both languages. By the computed layers (README.md:361), GrammarTransport is L1, not L0.
    - The UE15 record (finding 5).
    - At C/01-ROOT.md:535, only the clause is replaced; the bullet's subject, "That no independent entity exists", stays not shown.

**The other questions.**
- **Question 3.** Nothing in the name-free part goes uncarried. What is carried but left out is finding 2.
- **Question 4.** The converse is right and scoped for the relational part: (a) is not checked, but it is immediate from `World.of`, and (c) is exact for an inhabited type of relata. Decidedness is right, but what it is said to show about the unfolding is not (finding 3). The Q55 answer holds once findings 1 and 11 are fixed.
- **Question 5.** F3 no longer overclaims, apart from finding 12's wording. F1′ is consistent with the model; F1 is not, at k = 0 (finding 1).
- **Question 6.** One item with WRT1 as its lemmas is the right size. The imports are free of cycles: GrammarLaws imports only Grammar, GrammarMap and Prelude, and both new modules are leaves. The landing list needs finding 14's additions.

### Verdict

Do not propose the item as written, but no third full review is needed. Fix findings 1–5, which correct statements, not structure; only finding 1 changes Lean (the hypotheses and the standing conjunct, then a rebuild). Take the minor findings with them. A read of the changed sentences and the new build log is then enough to propose the item on the board.

## The last read

The same reviewer read the changed sentences and the new build log (`check/scratch-10.log`), as the second pass asked. Its report follows, lightly formatted; its D lines are those of the second revision.

**Confirmed.**
- The build: the scratch tree's sources match the checkout, the package is unchanged since `80c4c40d6`, and scratch-10 audits 28 theorems in 44 declarations with no axioms.
- Every finding of the second pass is fixed:
  - 1: `standingAt_alike` now takes `pos`/`pos'` and has the standing conjunct (K2:96–111); D:40 and D:232 match it.
  - 2: D:27 and D:72–84 define the part as reading no name at two steps and state the selection.
  - 3: D:151–153.
  - 4: D:130–133.
  - 5: D:88, D:94, D:375 and D:386; `reordering_iff_course` exists (ReorderingGrowth.lean:198).
  - 6: D:352.
  - 7: D:91–92 and D:339.
  - 8: D:166.
  - 9: D:5 and D:13.
  - 10: no "mark" is left, and D:387 adds the glossary line.
  - 11: D:172 and D:174.
  - 12: D:283, K2:58–59, D:345, D:104–110 and D:322–328.
  - 13: D:334 and D:368.
  - 14: D:381, D:386 and D:388.
- The first review's findings taken only in words are fixed too: 7 at D:148, 19 at D:348 (K2:221–222), and 21 at D:158.

**Still wrong.**
1. **D:113, "no relation of the model holds … the step order", is false.**
   - The model includes the names' step, and the step order is the grammar term `«而» («及» Steps.along) sameStep` (`later_iff`, D:206, checked).
   - The sentence is true only of the name-free part, which is the part the Q55 example (D:172) uses.
   - *Fix:* "no relation of the name-free part".
2. **D:234**, "would need one of": the two are examples, not a proved exhaustive list. Write "for instance".
3. **D:125** puts standing under `withinStep_carried` "by definition". Standing is a partial identity, carried directly by `World.reidentify`'s definition, as D:352 says. Drop it from D:125.
4. **D:322**: «息» and «生生» are read neither by a World instance theorem nor by WRT2; only HeldPossible reads them (HeldPossible.lean:668). Move them to the rest, or widen the stated criterion.
5. **D:152**: `law_iff_positions` quantifies over every determination `p` (L/Space.lean:1113–1116), not activity alone. Write "deciding every position along the steps".

**Verdict.** Correct D:113, and the item can be proposed on the board. Fix the nits in the same edit; none of them needs another read.
