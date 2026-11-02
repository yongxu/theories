# UE4: what lands, and what stays design

25 October 2026. AI-authored landing note for board item UE4, following [DESIGN.md](DESIGN.md) §5 and the recommendation of [REVIEW-UE4](REVIEW-UE4.md). It lists what lands, its home section, and what stays design. It writes no landing script and changes no chapter, record or board row; the lander does that through the queue.

**The decision.** Land eventual widening and the carrier witness as one near-definitional record, with its home in 07 §2, beside [widening along a reading](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-widening-along-a-reading). The coordinator decided this with the review, 25 October.

The UE plan's purpose for item 7, a result no neighbouring field states, is not met by this record. It waits on the gain bridge or the givers law (DESIGN §3.1, §3.3). The second-order direction of 生生 stays open, and so does 02's open item, a law relating 生成 to widening.

## What lands

**The record.**
- Id `eventual-widening`.
- Title: *Widening on late tails, and what carries a widening*.
- Standing: theorem, near-definitional.

**The modules**, from [`tree/Becoming/`](tree/Becoming/). The scratch build is 25 October 2026 ([log](scratch.log)); every axiom report is empty and the core is pure.

| Module | Theorems | Declarations | Imports |
|---|---|---|---|
| `Becoming.EventualWidening` | 24 | 36 | `Becoming.Regions`, `Becoming.ContinuedClasses`, `Becoming.Population` |
| `Becoming.EventualWideningInstances` | 82 | 106 | `Becoming.EventualWidening`, `Becoming.Verification`, `Becoming.Weightings` |

**Laws** (draft of the record's list).
1. **Widening on late tails.** One level path eventually widens another where, from some step on, it widens it on every tail, each read on the web from its first step (`Web.after`, `Web.tailFrom`, `Web.EventuallyWidens`).
   - Read pointwise, this is inclusion from some step on with exceeding at arbitrarily late steps (`Web.IncludesFrom`, `Web.ExceedsLate`, `Web.eventuallyWidens_iff`).
   - It is irreflexive, transitive and one-way, by widening's laws on tails (`Web.EventuallyWidens.irrefl`, `.trans`, `.not_reverse`).
2. **It never reverses widening.** A level path included by another at every step does not eventually widen it (`Web.EventuallyWidens.not_included`, `Web.Widens.not_eventually_reversed`).
   - Inclusion composes with it on either side (`Web.Includes.after`, `Web.Includes.trans_eventually`, `Web.EventuallyWidens.trans_includes`), so widening or eventual widening is irreflexive and transitive (`Web.WidensOrEventually`, `.irrefl`, `.trans`).
   - Widening that exceeds at arbitrarily late steps is eventual widening (`Web.WidensWithoutEnd`, `.widens`, `.eventually`).
3. **It reads only tails.** Paths agreeing from some step on eventually widen, and are eventually widened, alike (`Web.EventuallyWidens.of_agree_left`, `.of_agree_right`). A course admitting at arbitrarily late steps eventually widens one admitting nothing from some step on (`Web.eventually_of_vanishing`).
   - Read as runs of the process of all sequences of levels: where some path eventually widens `l'`, eventually widening `l'` and its complement are both dense (`Web.eventually_dense`, `Web.not_eventually_dense`). So it is neither verifiable nor refutable, and a practice fixed by the record can keep the verdict against every record (`Web.eventually_neither`, `Web.eventually_insulated`).
   - A path whose admissions a list holds eventually widens nothing (`Web.not_eventually_of_listed`).
4. **Keeping widening.** Along a continuation, from a step on, nothing admitted is lost and something keeps being opened (`Web.IncludesAcrossFrom`, `Web.KeepsOpening`, `Web.KeepsWidening`). It holds from every later step and is unchanged by every re-identification carrying the continuation (`Web.KeepsWidening.later`, `Web.keepsWidening_reidentify`).
   - By name over a listed type no range keeps widening (`Web.KeepsWidening.gathers`, `Web.KeepsWidening.not_listed`).
   - A course keeping widening by name eventually widens a range admitting alike from some step on what it admits at some step (`Web.AdmitsAlikeFrom`, `Web.KeepsWidening.eventually_widens_of_within`; the lemma `Web.KeepsOpening.eventually_widens`).
5. **What carries a widening** (in the instances module, beside its witnesses). A flow's range is opened by the opened from a step where gains of support recur and every later gain is given, on a rising condition the gainer requires, by a supported formation that itself gained support later than that step (`Flow.OpenedByOpened`). The definition is provisional: its proposed first law would reach the giver only up to double negation, and that law fixes the form. Where nothing is supported from some step on, no flow is opened by the opened (`Flow.OpenedByOpened.not_of_unsupported`).
6. **Witnesses.**
   - A burst widens a rising course up to step 0, the two are mixed over every step, and the rising course eventually widens the burst and keeps widening (`OwnCondition.disagreement`).
   - A saturated course widens and eventually widens the rising one and keeps widening from no step (`OwnCondition.not_monotone`, `OwnCondition.full_eventually_widens_rising`).
   - A course keeping every formation of another from one step later is mixed with it in every tail (`LagWitness.lag`).
   - Ranking by opened by the opened reverses widening: the relay is opened by the opened, a flow giving nothing on a saturated web is not, and the saturated levels widen the rising ones (`Saturated.reverses`).
   - Along a merging continuation a constant course keeps widening (`MergedWitness.keeps_widening_along_merge`).
   - One range is carried by a relay or by one giver with every admission the same (`OpeningChain.carried`).
   - A closed cycle is opened by the opened with no widening (`ClosedCycle.cycle`).
   - On a web where nothing is supported, no flow is opened by the opened (`OwnCondition.not_opened`).

**Conditions.** No axiom, and no premise beyond the representation: discrete steps on one unbounded index, natural-number levels, one web for both courses. The frame laws hold where some path eventually widens the second course; they vary the first course only. Keeping widening reads a supplied continuation, or names. The witnesses are constructions; the carrier witnesses do not meet the first law, each unit being given from nothing.

**Does not show.**
- The second-order direction of 生生: eventual widening is first-order widening read on late tails, needs no growth, and is silent on a lag.
- That calling eventual widening better (C∞) is warranted. It is a premise beyond C, named and not asserted; its cost is in DESIGN §3.1.
- Any gain, renewal or giver law, any comparison over branching courses, or a law relating 生成 to widening.
- Which actual courses meet any of these readings.

**Standing for 08 §8** (known results). Near-definitional:
- eventual widening is widening on late tails, the inclusion form of a tail criterion. That, counting finitely many admissions at each step, it entails overtaking (von Weizsäcker 1965; Gale 1967) and not conversely is an argument, not proved in Lean; the record does not cite it as a law;
- the frame laws are the density of a tail reading (liveness in Alpern and Schneider's sense);
- `not_listed` is the pigeonhole;
- the joining law uses its hypotheses directly.

**Dependencies** (formal reuse).
- The widening records: `Web.Widens`, its laws, and `Web.IncludesAcross` and `Web.ExceedsAcross` from [widening along a reading](../../../../../../theories/becoming/results/records/widening-along-a-reading.md).
- [What a finite stretch verifies](../../../../../../theories/becoming/results/records/what-a-finite-stretch-verifies.md): `Dense`, `insulates_iff_dense`, and from `Becoming.Horizon`, `not_verifiable_of_adheres` and `not_refutable_of_adheres`.
- [Widening as what every weighting ranks](../../../../../../theories/becoming/results/records/widening-as-what-every-positive-weighting-ranks.md): `Web.ListsAdmitted`.
- The support laws for `Flow.OpenedByOpened`'s vocabulary (`Web.GainsSupport`, `Web.Rises`).

**Draft text for the home section, 07 §2** (for the lander to adapt; the chapter is not edited here).

> **Theorem** (World). *Widening on late tails, and what carries a widening.*
> - One level path *eventually widens* another where, from some step on, it widens it on every tail (`Web.EventuallyWidens`). This is first-order widening read on late tails, not a comparison of growth.
> - Its order laws are widening's. It never reverses widening, and widening or eventual widening is transitive (`Web.Widens.not_eventually_reversed`, `Web.WidensOrEventually.trans`).
> - It reads only tails (`Web.EventuallyWidens.of_agree_left`). Where some path eventually widens a course, eventually widening it and its complement are both dense (the first course varied, the second fixed), so the verdict is neither verifiable nor refutable and can be insulated from every record (`Web.eventually_neither`, `Web.eventually_insulated`).
> - A path whose admissions a list holds eventually widens nothing (`Web.not_eventually_of_listed`).
> - A course *keeps widening* along a continuation where nothing admitted is lost and something keeps being opened (`Web.KeepsWidening`). By name over a listed type none does, and a course wider at every step can fail to (`Web.KeepsWidening.not_listed`, `OwnCondition.not_monotone`).
> - A course keeping widening eventually widens a range that admits alike on what it admits at some step (`Web.KeepsWidening.eventually_widens_of_within`). A course keeping every formation of another from one step later is mixed with it in every tail (`LagWitness.lag`).
> - One range can be carried by a relay of openings or by one giver, every admission the same (`OpeningChain.carried`), and a closed cycle is opened by the opened with no widening (`ClosedCycle.cycle`); the property, opened by the opened, is provisional (`Flow.OpenedByOpened`).
> - Calling eventual widening better is a premise beyond C, not asserted.
> - It does not capture the second-order direction of 生生, a range whose widening keeps widening against one merely wider now, which stays open, as does a law relating 生成 to widening (02).
>
> (record: `eventual-widening`, to be linked when it exists)

## Rule 9

- **`Becoming.EventualWidening`.** Its order laws are derived from `Web.Widens`'s (`Widens.not_reverse`, `Widens.trans`) on shifted webs: below, not beside, with no second proof of a strict partial order. Keeping widening is built on `Web.IncludesAcross` and `Web.ExceedsAcross`. `Web.after` is new: the package has `World.after` and no shift of a web, and it reads a web from step `S` as `World.after` reads a world. It holds eventual widening and keeping widening only; candidate C's property is in the instances module (the re-check's R3). No existing module imports this one. Its row should say it is a leaf as a tool, the long-run reading of widening, until the gain bridge or the givers law imports it.
- **`Becoming.EventualWideningInstances`.** A leaf as an instance module and models:
  - its frame laws are instances of 03's (`not_verifiable_of_adheres`, `not_refutable_of_adheres`, `insulates_iff_dense`);
  - its listing law reads the weighting characterization's hypothesis (`Web.ListsAdmitted`);
  - it states the property of what carries a widening (`Flow.OpenedByOpened`, provisional) beside its witnesses;
  - the rest are witnesses.
- **At landing**, register the apart roots in the connectivity run, as UE1 did.

## What stays design

None of this is in the landing modules. Each item is in DESIGN.md and would be claimed and reviewed on its own:
- **Candidate C's laws** (DESIGN §3.3): the uniform form of support passing on; givers multiply, under upkeep; the map law relating 全生成 to gains of support.
- **Candidate B** (DESIGN §3.2): widening of what can be reached, its determined case, the possible narrowing along a course, the exhaustion witness, and C◇.
- **The gain bridge** (DESIGN §3.1): keeping widening on the actual levels, with requirements in a finite family, passing every bound and fed from beyond. The gain bridge or the givers law is the first candidate for a result no neighbouring field states.
- **Eventual widening along a reading**, for growth by new kinds (DESIGN §3.1).
- **The rate reading** (DESIGN §3.5), deferred.
- **C∞**, named with its cost and not proposed (DESIGN §3.1).
- **The neighbours' containment** in UE's sense (DESIGN §4), which has no third part yet.

## Landing (for the lander)

The scripts are in this kit, modelled on UE1's landed kit. Run them from the checkout root of a clean landing worktree, against the then-current main. Each asserts that every edit applies exactly once. None has been run; each parses, and each anchor occurs exactly once in the files as they stand today.

1. `python3 -B <kit>/integrate_ue4.py`. It copies both modules into the package and imports them in the root module after `Becoming.Regions`, each with an L1 bullet after Regions' bullet. It also adds them to the checker's core list after `"Becoming.Regions"` and to its SCOPE text before the `Standpoints` entry, and adds their README rows (EN, ZH) after Regions' row.
2. The checker (`check_becoming.py`), for a fresh core receipt `RECEIPT`.
3. `python3 -B <kit>/texts_ue4.py RECEIPT N`. It edits:
   - 07 §2: the home paragraph `r-eventual-widening`, with the labelled reading [AI reading, D45] that the second-order direction stays open, inserted before `r-comparison-content-under-regrouping`, that is, right after `r-widening-along-a-reading` and in the section of `r-four-cases-of-a-part`;
   - 07's Open list: an item before `r-universal-practical-warrant`;
   - 08 §8, `beyond-the-table`: a bullet at the end of the list, before the market model's assessment;
   - 08's receipt counts (UE1's regex block);
   - the study section `N` (from `study_ue4.txt`) and regions.
4. `python3 -B <kit>/make_records_ue4.py RECEIPT N`. It writes the record `eventual-widening`, citing all 142 declarations, and asserts the receipt's hashes and empty axiom reports for both modules.
5. The renders and checks AGENTS asks for: `research-render`, `research-check`, `research-links`, `research-test`.
6. The connectivity run, then `python3 -B <kit>/register_ue4.py CONNECTIVITY_LOG` for the apart roots.
7. `python3 -B <kit>/board_ue4.py land UE4 RECEIPT N QUEUE STATE`.

The reviewer's re-check found the revision ready to land after small text fixes; they are made (DESIGN §7). DESIGN.md and this note stay as the study.
