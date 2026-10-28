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
