# What the gap scan missed

AI-written (the completeness critic of the integration scan, 3 November 2026; see [README](README.md)).

## Where the scan did not look

Each item has evidence I checked myself with read-only greps.

1. **Parts of the account no reader read.**
   - Front and chapter material:
     - `theories/becoming/FREE-ENERGY-PRINCIPLE.md` (123 lines).
     - Four review dossiers: `review/LOGIC.md` (977), `PHILOSOPHY.md` (691), `CLASSICAL-TEXTS.md` (706) and `BUDDHIST-THOUGHT.md` (602). Only ALIGNMENT.md was read.
     - 06 §5, the hexagrams.
     - 01 §8.6, §9.1–9.3 and §9.8–9.9 (headers only).
     - 07 §3.2–3.3, §4.5–4.6 and §6 (partly).
   - Studies: ue10–ue15, which include the causal-set and present studies and their probe Lean trees.
   - The `worldbuilding/` tree, which MAP calls "the constructive half". Only 2 Markdown files in it link to Becoming.

2. **The sixteen earlier theory folders under `theories/`.** No reader opened them, yet MAP.md:61 says each "now reads as a stratum the Theory of Becoming gathers". Links from the chapters, fronts and dossiers into each folder:
   - none for 10 folders (including keep-the-possibility-space-open, relational-self-and-datong and zhishan-intelligence-must-be-good);
   - 1 for five folders;
   - 6 for meta-attractor.

   See findings 2 and 3.

3. **Experiments that reach no chapter.** 15 of the roughly 40 folders under `experiments/` are not named by any chapter, front, dossier or record. These include `state-named-in-advance` (UE31, landed f287c54e8 on 3 November), `break-warnings`, `evaluator-succession`, `joint-formation` and `agentdojo-evidence-boundary`. UE31 matters most (finding 1). `direction-training` is unlinked rightly, since its README says it was dropped before any run.

4. **Proved Lean that never landed.** No reader swept the study trees for this. I listed every `*/Becoming/*.lean` file under development/ with no module of the same name in the package. Most are probes and checks. Three are substantive:
   - `ue6-beyond-the-sciences/tree/Becoming/CoupledDrawers.lean`: 57 theorems; 49 of its 56 theorem names do not appear in the package, and it is not on the work board. This confirms gap-map item 5.1 and makes it the only substantive unlanded module I found.
   - `U4Repairing.lean`: 10 of its 15 theorem names are absent. It was rejected on review (REVIEW-U4-L1.md:22, "The premise is the conclusion, restated"), so it is not a gap.
   - `UnitsApart.lean`: all 32 names are in the package, so it landed.

5. **Fields no sweep checked.** Each is absent from theories/becoming and from the root-foundation studies outside history/:
   - Simondon; relational quantum mechanics (Rovelli);
   - Leopold and the land ethic; Schweitzer;
   - Daly, strong sustainability, Hartwick, Brundtland;
   - Oyama and developmental systems theory;
   - Noether (one study mention only).

   Jonas appears only as a question in a dossier and in one record. Findings 4–6 cover these.

6. **The Chinese editions.** No reader checked them, but nothing is lost:
   - `ONE-PAGE.zh.md`, `THE-THEORY-OF-BECOMING.zh.md` and `review/README.zh.md` match their English editions in line count and were last changed in the same commit (368a8bde7). The zh ONE-PAGE names C and the condition with the same roles.
   - The CD branch now landing changes both editions of the overview together.

7. **Same names in different senses, and duplicate laws.** No reader checked these in Lean (finding 7). Two gap-map items also need correcting (finding 8).

## Findings I verified

**1. [high, cited-not-contained] A landed design has already argued that T2 as worded is defeated. Neither 02 nor 08 says so.**
- `experiments/state-named-in-advance/README.md:8` says: "T2's class as worded is defeated by a class of fewer variables". Its reason: "the pupae counted now are the next recruits" (the flour beetle's LPA life stages).
- The landing commit f287c54e8 adds that "with the field's delay T2's numbers are the field's own delay embedding". It also leaves "two proposals for T2's owner, not made here": "as far as anything in the condition's own course does" and "the lag at the delay of renewal".
- `theories/becoming/chapters/02-MAP.md:281` still claims T2's three numbers "for every renewable condition under a draw", fixing the next giving "as far as anything measured does", with standing "untested outside fisheries".
- Neither 02 nor 08 links UE31 or names it.
- This corrects gap-map item 4.1. The account has already identified T2 with a delay embedding, so the gap is that this identification and the defeat expected before the run never reached T2's statement. It is not that Takens is missing.

**2. [medium, unity-claimed-not-shown] MAP says the earlier theories are gathered, but no live text shows how.**
- MAP.md:61 says each folder "now reads as a stratum the Theory of Becoming gathers".
- The only branch-by-branch mapping is a dated catalogue in history/ (MAP.md:94, `history/THEORY-MAP-2026-10-08.md`), written before the current eight chapters.
- `theories/relational-self-and-datong/README.md:499` sends readers to Becoming's "第七章 …, 第八章 …, 第十五章 …, 第十八章" (chapters 7, 8, 15 and 18). The account now has eight chapters, and those Chinese chapter labels occur only in 06-CLASSICAL-TEXTS.
- zhishan's central claim, "competition that selects survivors hands winners the rule" (MAP.md:92), is the capture through the rule in 02 §9. No chapter links it.

**3. [medium, internal-split] The account's own earlier root value, 开 (keeping open), is set against "expansion", and C is never placed against it.**
- `theories/keep-the-possibility-space-open/README.md:236`: "开 replaces 'expanding the possibility space' as the root category, because 'expansion' sounds measurable, maximizable and optimizable".
- The same file at :238: "开 is a state of a process, not a quantity of it".
- The same file at :834: "becoming — same theory, other language … the possibility-side frame from which 生生不息 is derived". This is a derivation claim of the kind AGENTS rules out.
- C reads "widening what can form is better" (ONE-PAGE.md:24). The chapters never use 开 as a term.
- The account's answer exists: widening is a partial order, and GLOSSARY keeps maximization apart from direction. It is just never set against the lineage's own objection, or against 开's four aspects 未/可/应/转 (README :237).

**4. [medium, cited-not-contained] The scope of the continuation condition has known neighbours, and only history/ and a dossier question mention them.**
- `theories/becoming/history/THE-STEP-OF-INVARIANCE.md:44`: "The theory's step is not new … It is close to Johnston, and to a conatus reading of Spinoza".
- `review/PHILOSOPHY.md:166` asks how the condition compares with Taylor 1986 and Jonas, which leaves the question open.
- 07 and 08 contain no Spinoza, Johnston, Jonas, Taylor, biocentrism or Næss. 08:492 credits only "is–ought; Gewirth (1978); Parfit (1984); Sen (1977)".
- A reader of 07 is not told that "for anything" has earlier forms.

**5. [medium, missing-field] The weak- and strong-sustainability debate is absent where the account ranks keeping a condition over compensation.**
- ONE-PAGE.md:26 says C ranks keeping the mussel bed higher and that "widening does not weigh the lost catch". 05 rests "a take above renewal ends it" on five carriers (05:23 and others).
- Missing, from prior knowledge, not re-read: Daly's operating rule (harvest within regeneration), the Hartwick rule and Solow 1974's intergenerational equity with substitutable capital, and the strong-sustainability position that there is no second copy.
- 08:514's Solow is the 1956 growth model. Daly, strong sustainability, Hartwick and Brundtland have no hits; planetary boundaries appears once, in a study (BECOMING-SIGNIFICANCE-REVIEW.md:46).
- Weak sustainability is the main established rival to counting a loss "whether or not compensated".

**6. [low, missing-field] Two close neighbours of the one-relational-unfolding thesis are not named.**
- 08:607 lists the neighbours as "ontic structural realism (Ladyman and Ross 2007), process philosophy, dependent arising and the identity of indiscernibles".
- Missing: Simondon (individuation from pre-individual relation; "how things form" is his subject) and Rovelli's relational quantum mechanics. Both have zero hits in the account and the studies.
- 01:290 already reads quantum contextuality on a World, so the physical neighbour has a natural place.

**7. [low, internal-split] Lean uses one name in several senses, against "names are structural and exact".**
- `Admits`:
  - `Histories.lean:77` "A law admits a history where every step … is a step of the law";
  - `Admission.lean:378`, C's admission of a formation.
  - GLOSSARY has no "admit" entry (only widening at :61).
- `Unread`: `ReadingSchedule.lean:92` against `ClosedCapture.lean:131`. These are the two sides of the gap map's split 3.1, so the name collision hides the split.
- `Covers` in four senses: `MoveOutcomeProcesses.lean:62`, `ReachableRanges.lean:272` (07's covering), `Locality.lean:462`, `GuardHorizon.lean:422`.
- `Gated`: `PlaceTransitionNets.lean:138` against `RegimeMargin.lean:267` (consistent with gap-map 8.1).
- Checked and fine: the two `Widens` are joined (`ReachableRanges.lean:257`, "range widening of two courses is 07's widening").

**8. [low] Corrections to the gap map.**
- **Item 4.6 overstates.** A controlled viability kernel does exist. `GuardHorizon.lean:11-23` defines `Viable` as "the controlled reading of the core's viability law" and joins it to `Viability.Kernel` (`certificate_viable`, `kernel_viable`). The chapters cite it only at 03:422, 03:555 and 08:467. The remaining gap is only its join to 02 §1's 延 and §2's largest sub-process.
- **Item 2.4's "header is stale" is imprecise.** `Capture.lean:14-15` says that `Becoming.Evolution` "leaves its selection term unstated", which is true of that module. The fix is to add a pointer to `SelectionTerm`, not to correct the header.
- **Item 5.1 is confirmed.** CoupledDrawers is unlanded (49 of its 56 theorem names are absent from the package) and has no board clause.