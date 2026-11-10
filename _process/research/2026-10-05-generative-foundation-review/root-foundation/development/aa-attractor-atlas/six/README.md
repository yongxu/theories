# The six-family pass: families A, B, E, F, G and H read for premises and exits

*AI-written, 11 November 2026. This is the evidence for AA's plan §13, "What comes next" ([PLAN.md](../PLAN.md#13-the-next-phase-the-maps-structures-9-november-2026)).*

Ren said on 10 November that the dynamics are to be connected, mapped and "unified". This pass reads the six families whose laws had no premise lists to the same rule as C and D. Every law's list names every hypothesis its Lean statement binds, and every exit gets the destination its law gives, so that routes cross families. It also proposes two fields. `case_of` says which general law a law is a case of, where the Lean derives it. `compose` says how two dynamics join, where one's state is another's rule, reading or pool.

It ran on Ren's yes to about fourteen agents ([his answer](../../../../../../../sources/15-codex-theory-conversations/2026-11-11-aa-six-family-pass-agents.md)).

## What ran

1. **A Lean script** ([lister.py](lister.py)) built an import closure and elaborated every declaration the atlas lists, 2,084 in the Becoming core. For each one it printed:
   - its kind;
   - every binder of its statement whose type is a proposition;
   - the head of its proof;
   - the theorems its proof term names.

   A second pass read every binder of type `Decidable`, `DecidableEq`, `DecidablePred` or `DecidableRel` on the six families' 1,530 core theorems. Of those, 83 have one ([decidable.json](decidable.json)).
2. **Six shares**, each about the same load ([inputs.py](inputs.py)): A; the first 14 dynamics of B; the last 12 of B with E; G; F with the first 20 of H; and the last 17 of H.
   - **An extractor per share** followed [the brief](BRIEF.md). It mapped each binder to a premise, gave each exit its destination and drops, and gave each transition its ends. It proposed `case_of` and `compose`.
   - **A checker per share** was set to refute its extractor ([check-A.json](check-A.json), [check-B1.json](check-B1.json), [check-B2E.json](check-B2E.json), [check-G.json](check-G.json), [check-FH1.json](check-FH1.json), [check-H2.json](check-H2.json)). It read in full:
     - every exit, transition, case and joining;
     - every new premise;
     - every binder mapped to a new premise, or mapped away from the script's guess.

     It sampled the rest and says in its file what it sampled.

   Twelve agents in all, about 7.2 million tokens. The extractors' files are in [extracts/](extracts/). Their inputs are not kept: [lister.py](lister.py) regenerates the lister's output, and [inputs.py](inputs.py) the inputs from it. Both must run before [integrate.py](integrate.py) reruns. It reads the extracts, the checks and [decidable.json](decidable.json) from this folder, and rebuilds the entries from the branch's base.
3. **This session folded them in** ([integrate.py](integrate.py), its report [integrate-report.txt](integrate-report.txt)). It applied the checkers' corrections, pooled their merges and took the decisions below. A fresh reader then read the result (below).

## What the entries now hold

- **Premise lists.** 1,655 laws of the six families list the premises they take: 1,504 read off the elaborated statements and 151 off the source in the periphery ([mapping.json](mapping.json), with 4,264 binders). 26 more, listed under both a six-family dynamic and C or D, keep C and D's list. The ledger grew from 362 to 1,669 premises. A law listed under two dynamics has one list on both.
- **Exits.**
  - All 267 exits of the six families end somewhere: 68 at a dynamic and 199 at a state in words. None is unread.
  - 56 of the 68 name the law placing the course there. The other 12 are exits no law shows, sent where the chapter they cite names.
  - 53 of the 68 leave for a dynamic of another family.
  - Across all eight families, 70 exits now name a dynamic and 55 of those cross families. Step 1 counted 22 exits naming a destination.
  - 179 exits name the premise they drop.
- **Transitions.** 71 of the 77 transitions name both ends.
- **Cases (`case_of`).** 122 cases, on 121 listings of 116 laws (five laws listed under two dynamics carry their case on both), of 104 general laws.
  - 60 of those general laws are listed under no dynamic. Some may be general laws the atlas lacks: for example `RuleRebuilding.drain_of`, of which two laws are cases, each listed under two dynamics, and `«自不复生则息»`, of which laws in families G and H are cases. Others are lemmas: `Hexagram.first_return_of`, `World.rests_unrefuted_of_after` and `nonrising_between`, among others. Each case's line says which.
  - 23 cases have a general law listed under another family.
  - [The terrain](../../../../../../../theories/becoming/results/atlas/TERRAIN.md#laws-given-as-cases-of-one-law) lists them.
- **Joins (`compose`).** 10 joins, each with how far it is seen:
  - 6 proved by a Lean law whose statement relates both sides;
  - 1 stated in words at a theorem's home, with no joint law;
  - 3 readings, proposed in a chapter's marked AI reading, with no joint law. By what the second dynamic receives: 4 a pool, 4 a reading, 2 a rule. [The terrain](../../../../../../../theories/becoming/results/atlas/TERRAIN.md#how-dynamics-join) and both dynamics' entries show them.
- **The premise ledger** is split by family: [PREMISES.md](../../../../../../../theories/becoming/results/atlas/PREMISES.md) holds the lead, the seeds and the premises taken across families, and `premises/<f>.md` holds the premises only one family's laws take. The single page had reached 1,002,086 bytes, against the render's limit of 1,048,576.

## Decisions this session took on the checkers' open questions

Each was read against the Lean before it was taken.

1. **Decidedness.** For the core laws it is read off the elaborated statements: a law with a `Decidable` binder takes `k3-decided`, as data, as step 2b listed it. The shares had done this three ways. A binder stating `P ∨ ¬ P` is k3-decided's proposition stated as a binder; two new premises for it were merged into k3-decided. For the periphery, the extractors' reading off the source stands.
2. **K3's grouped forms are kept apart.** K3's coverage patterns count a census of what stands (`Web.StandingCensus`, Locality.lean:150) under "a census", embodiment of what arises (`World.ArisingEmbodied`, InAmounts.lean:327) under "embodiment", and enclosure around what stands (`Flow.AroundStanding`, Openness.lean:195) under "enclosed". The Lean states each as another proposition: a census of the conditions standing, not of the relata active. `World.rest_needs_standing` shows the two censuses independent. So each is a premise of its own, by the ledger's first rule.
   - C and D's two binders of `StandingCensus`, in `Flow.more_needs_unrun` and `more_exhausted`, are re-pointed in their listings and in [step 2b's mapping](../step2b/mapping.json).
   - The reward-model situation's assessment of the census follows them. Its reason already said "no census of what stands".
3. **What counts as a case.** A general law listed under no dynamic but stated in a record of the law's own dynamic is an inner step of that dynamic, not a case. The shares had read this two ways. 53 proposed cases are left out by this rule and kept in [readings.json](readings.json). A case is read relative to the dynamic its law is listed under, so a law listed under two dynamics may be a case on one and an inner step on the other.
4. **One proposition, one id.**
   - The checkers' merges are applied.
   - Where one law's binder got two ids from two shares, the id fewer binders take merges into the other (8; three more were undone by decision 2).
   - Where two shares wrote lines for one id, one line is kept: the one naming the defining declaration, else the longer statement. Its `holds_in` and `fails_in` are united (114 pairs of shares, on 97 ids). Where the kept line named one form of several, its statement is said generally (the reader's round, below).
   - Where one law under two dynamics was given two lists, both carry their union (7; the differences were commitments).
5. **Routes into C, D and other shares.** 29 routes the extractors proposed were already so. Three were applied. In the first two, the exit's own law is a law of the destination:
   - two-sided regulation's exit 3 into loss of renewal for good (`Flow.never_returns_below`);
   - the witness of no finite part's exit 1 into closed cycle without dissipation (`Cycle.closed_more`);
   - D's selection when the lumping changes, exit 3, into a revision that opens a correction.

   The third applies through its `to_law`: D's exit names `Revising.opens_with_correction`, and the destination's law `OpenedCorrection.Linked.opens` concludes the opening on Revising's process from two units.

   One was not applied: C's shaping read by readers drawn from the selected, exit 2, into fixation by drift. Its law, `DrawnReplacement.lost_ge`, is a law of the source, not of fixation by drift, and its checker left it unsettled.
6. **An exit ending in words names no law placing it.** Some extractors wrote one. The exit's own law stays in `law`.
7. **A drop may be a bound.** Where an exit's law contradicts a bound that the dynamic's laws take as a premise, the bound is listed as dropped. Step 2's brief said a parameter crossing a bound drops nothing; that was before bounds were premises (step 2b).

## Where it is not uniform, and what is open

- **Two kinds of premise are not kept one way across the ledger.** One proposition stated at one step and at every step of a stretch is one premise in some places and two in others. A bound with the same symbols in two modules is likewise one premise in some places and two in others. The checkers named these, and the ledger's lead says so.
- **Two dynamics have nothing to read:** `four-routes-of-transition` and `cooperation-read-as-giving-that-waits` have no declarations, and their routes stay readings.
- **An exit that drops several premises** may have a law showing only that not all of them hold, not which fails (for example `Web.consumed_continues_transformed`). The ledger's lead says so; no field marks it.
- **The atlas's name check resolved some names to the wrong declaration.** It matched a name by its last component in any live Lean file. So it found the wrong `never_rests` for `Becoming.RegimeMargin.Drawn.Relaxation.never_rests`, and accepted `Becoming.Web.requires` (undeclared: `Web` abbreviates `Dependence`) and `Becoming.RelationalRenewal.*` (declared at the root). The extractors read each at its real site. *Repaired after the pass, the same day:* `atlas.Repository.declared` now resolves a name exactly, through the core receipt or a namespace-aware reading of the live Lean, and refuses prose. The entries' 21 names that no declaration is written as are corrected, and this folder's [mapping.json](mapping.json) with them.
- **Joins the readers saw but could not anchor** are in [readings.json](readings.json), with the cases left out by decision 3. They include:
  - an optimum read as the law a training settles on;
  - the threshold read as the margin's point;
  - the RenewingFormation joint laws with own count;
  - selection read off its own survivors into the lock.
- **The fields a situation still lacks,** from the slice, are not added here: time on couplings, the laws a dynamic meets, a standing for each coupling, and the dynamics left out. The reward-model situation can now list family B's dynamics, since B is read.

## The fresh readers

A fresh reader, a thirteenth agent, read the result against the Lean. It read in full every exit to a dynamic, every case, every join, the decisions, and the pages' leads and new sections. It sampled 45 exits in words, about 75 drops, 84 laws' lists (22 in the periphery), 82 new premises and 16 of the lines kept between shares. It found 1 high, 7 medium and 13 low, all fixed:

- **High: joins said more than their sources.** Three joins entered as stated rest on chapter paragraphs marked as AI readings. Joins now carry a third standing, a reading, and the terrain says each one's standing.
- **Medium: one proposition, two ids.** It found ten pairs of ids for one proposition in one module and role. A grouping of identical binder types per module found five more, merged with them. Bounds whose symbols play different roles are left apart (`0 < k`, drawers against a draw; `w + e < n + m`, a coupling in total against one a step; `c ≤ m` where m is a round).
- **Medium: statements said for one form.** The frontier, the optimum laws' law of what stands and a need's step had been stated for one form of several, and are said generally.
- **Medium: the regime margin's bounds.** Its start bound had absorbed the starts of every condition and the levels the others are held at. These are apart again, re-pointed by binder type.
- **Medium: two more forms kept apart from K3.** Enclosure around a family (`Flow.Around`) is now a premise of its own, as enclosure around what stands is. The seeds' Lean lists no longer name the forms kept apart.
- **Medium: counts and wording.** The README's and plan's counts of cases, and their word for the general laws under no dynamic, are corrected.
- **Low:**
  - two exit texts cut back to their law;
  - one drop the law does not show removed;
  - one source pointed at the destination's home;
  - the terrain picture's word of dashed boxes, shown now only where one is drawn;
  - the tests' missing refusals added;
  - this README's counts and wording.

A second fresh reader, the fourteenth agent, was given the first reader's findings and the fixes. It read:
- every fix against its finding;
- all 77 transitions and all 37 entries of family H;
- the 53 cases left out, checked by script against the rule;
- every binder of every merged id;
- a new sample of 30 exits in words and 40 premises.

It found 1 high, 1 medium and 10 low, all fixed:

- **High: one merge carried another law's binder with it.** A one-binder-two-shares merge had given `«恒取不逾生则存»` a constant take over the renewal beside a take within it, which contradict each other. A take of one constant amount is a premise of its own again. Both forms are re-pointed by their binder type.
- **Medium: the regime margin's starts were split across ids.** They are now read as the Lean derives them. On a web, `a ≤ hi` is the start of the condition whose end is read, as `x ≤ hi` is with two coupled conditions. The partner's start goes with it. The starts of the other conditions are their own premise.
- **Low:**
  - two pairs of step bounds and one horizon bound merged;
  - two drops the laws do not show removed, and one exit's text cut back;
  - two statements said generally;
  - every new premise's Lean list naming only laws rebuilt from the laws that bind it (69 changed);
  - the extractors' placeholder "M" in five cases' text named;
  - the new enclosure premise's kind;
  - the picture's description;
  - this README's counts;
  - the integration now reads the kept evidence.

The second round's fixes were checked by the atlas's validation, the tests, the render and a recount. No third reader read them: fourteen agents were what Ren's yes covered.
