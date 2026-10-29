# Reader E: 文, the wisdom traditions and systems thinking (Claude Opus 5.5)

Part of the [twenty-first review](../BECOMING-TWENTY-FIRST-REVIEW.md); an AI report, read-only, kept as evidence. Its claims were checked by the cross-checker ([H](H-CROSS-CHECK.md)) and, where the review leans on them, by the synthesizing reviewer.

## Verdict
The classical line is the most carefully hedged part of the theory. Its best product is not "the texts confirm the theory". It is an exact ledger of three things: where a text and a checked law have the same structure, where a universal saying holds only under named conditions, and where the text asserts something the theory does not.

What is proved. The grammar is a standard relational calculus with Chinese names: constancy is bisimulation and the core (核) is the greatest bisimulation inside a class (类). The review cover says so itself: "名取自古文，不表示运算出自古文". Five groups of classical definitions (化, 成坏, 同, 复, 通) and 59 sentences read as candidate theorems were checked in the pure core. Of the 59, 38 are proved, 15 hold under one premise, 3 are refuted, 2 were misfiled and 1 cannot be expressed.

The premise ledger is the real gift back to the traditions. Symmetric 有无相生 is exactly double-negation elimination. 必或不当 is exactly weak excluded middle. 念念灭 holds exactly where nothing conditions itself. 「一切物皆從眾緣生」 is a premise about a model, not a law of the grammar. The Changes became a finite world on the spine, with censuses checked against the text. Wang Bi's 初上无位 fits all 28 place statements; no parity for the top place can. 文 is defined exactly as the course of a run through a map, and 文同 is proved to be the core (`Law.core_is_sameFuture`). That is Moore / Myhill–Nerode equivalence under a classical name.

What is not shown. No reading is shown to be faithful to the texts. Each of the 4,116 classified units was coded once, by AI. There is no agreement figure, and no human has read any of it. The blind recoding of 237 units is frozen but not yet coded, and sending the packet waits on you. The mappings of 248 passages and of 5,673 judgments are AI assessments, and their own third read found that 84 of 88 entries the reviser had kept needed correction. The evaluative sentences (619 plus 33, most of the Laozi) were set aside and only counted, so the high rates of agreement and scoping are over structural passages. Several theorems with weighty classical names are near-definitional: `«化之二说同形»` is `Iff.rfl`, and `«生生不息»` holds "by construction".

The traditions you named, one at a time:
- **道** is deliberately not a formal term.
- **道法自然 and 无为** are AI readings, backed by witness or definitional theorems.
- **生生之谓易** is scoped: 生生 is read as one conditional course within change. The review packet itself notes this may go against the sentence's syntax.
- **缘起** fits in its necessary direction and in "neither one nor different". But the theory's answer to the 中论 is the opponent position that Nāgārjuna refutes, and 「無自性故空」 cannot be expressed in the grammar.
- **仁** is excluded as a name and treated only through readings.
- **知行合一** is a loose reading.
- **Whitehead** is a named neighbour only. **Indigenous relational ontologies** are absent.

Systems thinking fits better than any tradition. The World model is a discrete stock-and-flow model. On that model there are exact theorems for:
- reinforcing loops;
- balancing with overshoot;
- delays;
- the commons and overshoot;
- success to the successful (capture through the rule);
- escalation (relative position is zero-sum).

Shifting the burden, eroding goals, fixes that fail, leverage points and Ostrom are not treated. The repository's own verdict is that none of these results is new mathematics, and I agree.

Fix two front-page overclaims: that the terms are "reconstructed from" the texts, and that `«因灭而续»` is "an answer" to the 中论. Split the two senses of 生生 and the two senses of 理. Then get the human recoding done; until it is, every claim about fidelity to the texts stays an AI reading. WRT2 landed during this review (commit 8882b7995). OU3f and DF3 are unrelated to these gaps.

## Shape
| Tradition / concept | Where in the theory | Standing of the mapping |
|---|---|---|
| 缘 (condition) | 01 §1; Mohist 故 「所得而後成」 + Buddhist usage | Definition (AI reading); the grammar's single relation |
| 类, 四同 | 01 §2; «同于为类», «同于不必传递» | Theorem (root) + reading D69 |
| 续, 生住异亡 | 01 §§2–3; source 'minimum grammar' | Definition; position-relative-to-class theorems (root) |
| 化 (墨经, 荀子) | «化之二说同形» (Iff.rfl) = «异» | Reading by definition |
| 复, 通 (老子, 系辞) | «复者住», «两向有常则通», «有常而不通» | Theorem (root) under the 往来 reading |
| 核 (core) | 01 §4 «根» | Standard bisimulation; no classical source |
| 文 / 文同 | 03 §7; Law.core_is_sameFuture | Exact theorem; the name is a reading (D63) |
| 理 | 03 §6 lumping; the grammar's names use it for the core | Exact laws; two senses drift |
| 道 | ch06 §九 | Deliberately not formal; rejected as a name |
| 道法自然 | 248-passage map: agreement; World.run_world | Reading; definitional backing |
| 无为 | TwoClocks.one_course_two_laws; ch06 §九 | Reading on an exact witness |
| 生生之谓易 | ch06 §5.7: scoped | Reading; syntax concern (C-13) |
| 生生 / 生生不息 | «生生», «息», «生生不息» (by construction); 07 T8 | Two senses: formal theorem + argued thesis |
| 仁 | 相人偶 (agreement); 一体之仁 (divergence of standing) | Readings; excluded as a name |
| 缘起 (necessary direction) | dependence; «非一非异», 无定性 family | Theorem (root), near-trivial |
| 中论 against 相续 | «因灭而续» restates the opponent | Divergence; co-presence open |
| 空, 無自性 | outcomes.tsv: not expressible | Gap |
| 知行合一 | 'law of experiment' (unanchored) | Loose reading |
| Whitehead | record mention ('not proved') | Loose analogy |
| Indigenous ontologies | — | Absent |
| Stocks and flows | World balance | Exact (model) |
| Reinforcing / balancing loops | gap_polynomial_iff_no_loop; LoopReturn; withinGap_iff_between | Exact (model); whole-number artefact |
| Delays | Regulation.no_narrower_band | Exact (model) |
| Commons, overshoot | joint_excess_ends (cites Meadows 1972) | Near-definitional |
| Success to the successful | share_rises, favouring_locks, lock_outlives_loss | Exact (model); archetype not named |
| Escalation | rise_needs_fall, aboveAll_never_rests | Exact (model) |
| Shifting the burden, eroding goals, fixes that fail | — | Absent |
| Leverage points | 'only a change of law, reading or selection leaves' | Loose (my analogy) |
| Ashby | 08 §8 claim; no Lean | Neighbour |
| Bateson | tower of rules | Loose |
| Ostrom | 05 Open only | Absent; opportunity |

Evidence pyramid for the classical line:
- 4,116 units classified (AI, single pass, no human)
- 248 passages and 5,673 atlas judgments (AI assessment, three AI reads)
- 59 candidate theorems in Lean (38 / 15 / 3 / 3); 5 definition groups
- Hexagram world with censuses (exact, script-checked)
- Human review: 0 (packet ready; recoding frozen, not coded)

## Answers
### (1) What do 文, 理, 道, 生生, 生生不息 mean exactly; how are the grammar's terms reconstructed from the Mohist canon, Xunzi, the Changes and Buddhist treatises; how strong is the fidelity evidence?
**The five words**
- **文** is a definition: the course of a run's states through a map, the value at each step (`Parting.course`). Any sequence of values is one. 文同 is two states whose courses agree at every step (`Law.SameFuture`). The root theorem places 文同 exactly as the core of the value class under the law's step (`Law.core_is_sameFuture`; it is also bisimulation likeness, `Law.alike_iff_core`). The name comes from 「通其变，遂成天下之文」 as an AI reading (D63). 「物相杂，故曰文」 is explicitly scoped, because classical 杂 is synchronic.
- **理** has two technical senses that drift apart:
  - 03 §6 and the glossary: "a lumping that models structure and change at once"; any lumping the step goes alike across (`Learning.goAlike_iff_lumped`).
  - The grammar's theorem names (`«守理则不穷»`, `«亡前理变»`) and ch06 §八 ("守值而承载律之最粗归并"): the core, i.e. the coarsest such lumping.
- **道** is deliberately not a formal term. Ch06 §九 says "理论从不把道等同于任何脊柱之词" and answers no to "是否就是唯一完整的道". 道 is among the 37 characters the name table rejects (as a prior ground).
- **生生** has two senses:
  - In the grammar it is renewal without end: the greatest family each member of which conditions a beginning whose line goes on and returns to the family (`«生生»`, Grammar.lean:253).
  - In the ethics it is "life in the whole and its continuing generation", compared by widening (07 §2, T8). Its second-order direction is open. "Generation generating generation" is AI reading D1.
- **生生不息** has three senses, kept apart in ch06 §十 (glossary-senses):
  - the corpus sense (conditions of the next round preserved, restored or created; the pattern re-realized through death and transmission);
  - the formal `Unceasing` (some formation arises at arbitrarily late steps), which is much weaker;
  - the theorem `«生生不息»` (renewal without end does not cease), true "by construction": the greatest fixed point against the inductive 息.

**How the terms were reconstructed**
- 缘 is the main relation. The word comes from Buddhist usage, read through the Mohist 「故，所得而後成也」, with 小故 as a necessary condition. The packet notes 大故 rests on an emended text and that the counterfactual sense needs a net of possibilities (C-01).
- 类 comes from the Mohist four samenesses: each is a class once its respect is fixed. 类同 is not transitive (`«同于不必传递»`, countermodel).
- 续 = 缘 ⊓ 类. The four marks are positions relative to a class. They come from the imported source text "minimum grammar" (生、存、变、亡, hence 亡 rather than 灭), checked against 起信论's 四相 and the 中论's debate on 相续.
- 化 joins the Mohist 「化，徵易也」 and Xunzi 「状变而实无别而为异者，谓之化」. That both are one form is `Iff.rfl`, a reading by definition.
- 成坏 is from the 金师子章, read synchronically against the 中论's 「成壞相違」.
- 复 is from 「復命曰常」.
- 通 is from 「往來不窮謂之通」, read as a relation and its converse after an earlier one-direction definition was corrected.
- The operators (而, 逆, 合, 非, 则, 谓, 一, 静, 及) are relation algebra named from classical sentence forms (PLAN §4.2).
- 核 and 广 (strict inclusion, with `«广非自»`, `«广不可逆»`, `«广之传递»`) have no classical source. 核 is Park/Milner bisimulation.

**Strength of the fidelity evidence**
- Strong for the formal side: derivations under stated readings are machine-checked, and the premises are surfaced.
- Weak for historical meaning. The 4,116 units (2,997 + 1,119) were classified by four Opus subagents, single-coded:
  - no agreement statistic;
  - no human review;
  - 22 glosses from memory (11 marked to check);
  - commentary coverage incomplete (no Xunzi or Zhuangzi commentaries; no 韩康伯 or 孔颖达 on 系辞下).
- Only 59 of 240 candidate theorems are tested. 40 of the 59 come from Buddhist texts and none from the 系辞. The 162 丙一 laws are not yet written as "Y iff Z".
- The blind recoding (237 units, kappa ≥ 0.6 fixed in advance) is frozen but not coded.
- The 中华本 fidelity count measures fidelity to the Lean statements, not to the texts. It was coded by the model family that wrote the 經, and controlled English ties with it.

Evidence: theories/becoming/chapters/03-KNOWING.md#wen (Definition: 文 = Parting.course; 文同 = Law.SameFuture); theories/becoming/chapters/03-KNOWING.md#r-wen-in-the-grammar (Law.core_is_sameFuture, Law.coarsest_iff_core); theories/becoming/chapters/03-KNOWING.md#li ('理 ... a lumping that models structure and change at once'); 01-ROOT.md#r-a-regularity-kept-and-changed («守理则不穷», «亡前理变» about the core); theories/becoming/chapters/06-CLASSICAL-TEXTS.md#dao ('理论从不把道等同于任何脊柱之词'); #zhonghua (37 rejected characters incl. 道 气 天 心 性 仁); experiments/.../Becoming/Grammar.lean:253 def «生生»; :626 inductive «息»; :632 theorem «生生不息» docstring 'The two exclude each other by construction'; theories/becoming/chapters/01-ROOT.md#renewal-and-grains (Reading D1: 'In the grammar 生生 names only renewal without end'); 07-SIGNIFICANCE.md line 73 and T8 line 628; theories/becoming/chapters/06-CLASSICAL-TEXTS.md#glossary-senses (corpus 生生不息 vs Unceasing vs «息»); experiments/.../Becoming/GrammarReadings.lean: «化之二说同形» := fun _ _ => Iff.rfl; «同于不必传递»; «通»; «非一非异»; «因灭而续»; theories/becoming/review/CLASSICAL-TEXTS.md C-01 (大故 emended text; 缘 from Buddhist usage); review/BUDDHIST-THOUGHT.md intro ('文法之运算是通行的关系演算……名取自古文，不表示运算出自古文'); theories/becoming/results/records/continuation-relative-to-a-class.md line 65 (constancy = bisimulation, Park 1981; Milner 1989); _process/research/2026-10-05-generative-foundation-review/root-foundation/development/one-unfolding-root/classify/REPORT.md (four Opus subagents; 2,997 units; 系辞 乙 = 0); _process/research/.../development/ou2-candidates/outcomes.tsv (38 proved, 15 conditional, 3 refuted, 2 misclassified, 1 not-expressible; ids JSZ 4 + QXL 10 + ZL 26 = 40 Buddhist); theories/becoming/review/recoding/FREEZE.md (237 units from 4,116, frozen 24 Oct, before any human coded); theories/becoming/review/CLASSICAL-TEXTS.md C-38 (22 rows from memory, 11 待核; 丁 deferred may bias); theories/becoming/chapters/06-CLASSICAL-TEXTS.md#r-fidelity-of-the-classical-statements and #r-fidelity-under-one-discipline (LLM-coded, provisional; controlled English +0.023 [−0.010, +0.055])

### (2) Mapping of Daoist 道法自然 and 无为, 生生之谓易, Confucian 仁, Buddhist 缘起 and emptiness, Wang Yangming 知行合一, Whitehead, Indigenous ontologies: exact, reading, or loose analogy?
**道法自然.** A reading (D54): the chain of 法 stops at 自然, with "no external commander". It is classed as agreement in the 248-passage map and tied to `World.run_world` (by definition) and `exists_law_iff`. The structure it cites is a definitional identity, so the match is thin.

**无为.** A reading. 「道常无为……而无不为」 is scoped to an exact witness: `TwoClocks.one_course_two_laws` shows one course admitted by a law of the part's move and by a law of the rest's move, so a course does not fix whose move it is. The theorem is exact; the reading of 无为 through it is AI's. Ch06 §九 reads 无为 as a challenge to over-control, not inaction, and rules out "less intervention is always better".

**生生之谓易.** Scoped (D47). Change includes generation and degeneration, which do not overlap, so 生生 is one conditional course within change. There is a theorem-level counterexample: the law admitting only broken lines makes 坤 absorbing, so possibility is lost. The theory takes 孔颖达's "後生次於前生" and drops his "劝戒". The packet admits that reading 易 as wider than 生生 may go against the sentence's copular syntax (C-13).

**仁.** Excluded as a name because it carries value. 郑玄's "相人偶" is read as a relational root (agreement for 谭嗣同, scoping for 郑玄). 程颢's and Wang Yangming's 一体之仁 is a "divergence of standing": they state as a recognized fact what the theory holds only as an unasserted condition plus the step of invariance. 亲亲之杀 (graded love) is a divergence; no law of graded order exists yet.

**缘起.** Two parts.
- The necessary direction matches exactly: "此无故彼无" is the spine's dependence. The sufficient direction ("此有故彼有") is not given, so the passage is scoped.
- Proved in the core: `«非一非异»` (continuation relative to a class is neither identity nor mere difference) and the 无定性 family, under the premise that nothing conditions itself (`«定性之判»`, `«念念灭当且仅当无自缘»`). Both are near-trivial. The theory concedes, quoting the plan: "本计划之续所站的位置，是《中论》所破的那一边". `«因灭而续»` restates the opponent's 「生滅故不常，相續故不斷」. Whether conditions must be co-present is open.

**Emptiness.** Not expressible. 「無自性故空」 is outside the grammar, and 假名 read as "designation relative to a class" is a partial reading whose "名" the grammar cannot say. 苦灭 read as release from continuing is a divergence, relative only to the unasserted continuation condition.

**知行合一.** A reading (D54). "行是知之成" is said to match "the law of experiment: a step taken is fixed, one not taken is not", but it links to chapter 03 with no anchor. 心外无事 is a divergence, answered from within the line by 王夫之 "目所不見非無色也". The `SituatedPractice` module is periphery and not cited.

**Whitehead.** A loose analogy, named only. The record says continuation relative to a class is "close to genidentity (Lewin 1922) and to Whitehead's enduring objects (1929) ... a correspondence not proved here". 08 §9 lists process philosophy among the neighbours of the one-unfolding thesis. Prehension and concrescence are not treated.

**Indigenous relational ontologies.** Not treated anywhere in the live theory. They appear only in the older meta-attractor README as examples of practices.

**Other traditions.** Outside Chinese sources, the only treatment is in OPENING (Ren's voice): its footnote reads the Golden Rule as "the one step", labelled "A reading".

Evidence: theories/becoming/history/CHINESE-SOURCES-AND-BECOMING.md row p-lao-25-dao-fa-zi-ran (相合; World.run_world, exists_law_iff) and row p-lao-37-wu-wei-er-wu-bu-wei (定域; TwoClocks.one_course_two_laws); experiments/.../Becoming/MoveFormation.lean:720 theorem one_course_two_laws ('The course does not fix whose move it is'); theories/becoming/chapters/06-CLASSICAL-TEXTS.md#residue (德与无为 reading D54); theories/becoming/chapters/06-CLASSICAL-TEXTS.md#yi-readings (「生生之謂易」 定域; Hexagram.allBroken_absorbing in #hexagram-world); theories/becoming/review/CLASSICAL-TEXTS.md C-13 ('“易比生生宽”可能与「生生之謂易」的等同句法相反'); theories/becoming/chapters/06-CLASSICAL-TEXTS.md#three-layer-verdict (郑玄 相人偶) and #divergences ('地位之相分' for 程颢, 阳明); #ro-gaps (亲亲之杀: no law); experiments/.../Becoming/GrammarReadings.lean «非一非异», «因灭而续»; GrammarCandidates.lean «定性之判», «念念灭当且仅当无自缘», «从缘生非文法之理»; theories/becoming/review/BUDDHIST-THOUGHT.md B-02 (quote of PLAN: '本计划之续所站的位置，是《中论》所破的那一边'), B-08 (「無自性故空」 表达不了), B-34 (此有故彼有 定域; 苦灭 相分); theories/becoming/chapters/06-CLASSICAL-TEXTS.md#wang-yangming ('“行是知之成”合于实验之律……（`[第三章](03-KNOWING.md)`）' — no anchor); theories/becoming/results/records/continuation-relative-to-a-class.md line 65 (Whitehead's enduring objects, 'a correspondence not proved here'); 08-METHOD.md line 544 (process philosophy as neighbour); grep of theories/becoming/chapters for 'Indigenous' and 'Whitehead': no matches; theories/meta-attractor/README.md:61 (Indigenous knowledge as a practice example); theories/becoming/OPENING.md [^sages] and [^dao] footnotes ('A reading')

### (3) Systems thinking: stocks and flows, reinforcing/balancing feedback, delays, Meadows' archetypes, leverage points; Ashby, Bateson; Ostrom — which results correspond, exactly or loosely?
**Stocks and flows: exact.** The World model is a discrete stock-and-flow model: levels, take and give, and balance (every change of a level is what is taken and given), in natural-number amounts on discrete steps. Balance is represented on the grammar as a pairing of units (`Flow.balances_iff_units`, `«守数当且仅当可对»`).

**Reinforcing feedback: exact, on the World model.**
- Faster than polynomial growth of the most difference that can arrive goes only through a loop of couplings (`gap_polynomial_iff_no_loop`, `carried_le_polynomial_from`).
- Around a loop acting at every step, growth is exponential both ways (`carried_pow_around`, `exponential_around`).
- How loops form, and that their formation is unforeseen in the amounts (`Closing.Onset.unforeseen`).
- These are worst-case bounds over laws, not predictions for one course.

**Balancing feedback: exact.**
- A loop closes a difference only through a link giving back less (`LoopReturn`).
- Two-sided regulation settles exactly where there is no overshoot (`Flow.withinGap_iff_between`); beyond it the level can oscillate forever.
- `LoopReturn.nothing_between` ("never closing gradually") is an artefact of the whole-number factors it assumes. A continuous-systems reader would misread it as a fact about real balancing loops.

**Delays: exact.** A rule reading ℓ steps late cannot keep a band narrower than 2(ℓ+1)d (`Regulation.no_narrower_band`, attained), and the relay threshold is exact (`Regulation.relay_threshold`). Readers who read a loss late give one horn of Collingridge's dilemma (`ReadInTime.kept_iff`, `turned_iff`).

**Archetypes.**
- **Tragedy of the commons and overshoot:** `Pair.own_not_joint` and `Flow.joint_excess_ends`, which explicitly cite Hardin and Meadows 1972 as "near-definitional arithmetic". The third part: under the gate, joint excess ends every dependent.
- **Limits to growth:** `Flow.Balances.doubling_needs`; "rises stop by exhaustion, not by enough" (`Flow.more_exhausted`); continuing needs feeding from beyond.
- **Success to the successful:** `share_rises`, `RuleCapture.favouring_locks` and `ClosedCapture.lock_outlives_loss`. They are exact in the model, and 08 §8 relates them to Arthur's increasing returns. The archetype's name is not used.
- **Escalation:** `RelativePosition.rise_needs_fall` (positions sum to zero), `Law.aboveAll_never_rests` and `Optimum.InTurn.position_keeps_nothing`. That a race for position produces joint excess is a premise, not derived.
- **Shifting the burden, eroding goals, fixes that fail, growth and underinvestment, accidental adversaries:** not treated. (`Flow.transmitted_along` on need drift is not eroding goals.)

**Leverage points: a loose correspondence, my analogy; the repository does not draw it.** "Only a change of the law, of how the rule reads or of the selection leaves" (`RuleCapture.favouring_locks`), and a reading of the loss made before the critical share (`ReadInTime`), resemble Meadows' high leverage points: rules, information flows, the goals and paradigm of the system.

**Ashby.** The repository claims a restatement: "Regulation restates deadbeat control and requisite variety" (08 §8), and the record readings-a-response-needs says "That a regulator must tell apart the disturbances needing different responses is requisite variety". No Lean declaration states a variety inequality, so this is a neighbour. The pool and selection laws (`Web.separates_all_iff_member`: a selection through couplings tells apart exactly what some member's couplings tell apart) are closer in spirit.

**Bateson.** Loose: "Bateson's levels of learning (1972) are the tower's scheme with no law of possibility" (08 §8). Also 03 §6: "the meta level is learning again, with no top".

**Ostrom.** Appears only in an Open item of 05 (a discriminating market study weighed against Ostrom's account). Some results resemble design principles, by my analogy only:
- division by exclusive footprints ~ clear boundaries and allocation;
- reading through a pool ~ monitoring;
- tolerance and giving first ~ graduated response;
- codes formed between formations ~ collective-choice arrangements.

None is claimed, and "how pools form, last and resist capture" is listed as open.

Evidence: theories/becoming/chapters/01-ROOT.md#r-master-laws-on-the-grammar (Balance: Flow.balances_iff_units, «守数当且仅当可对»); theories/becoming/chapters/02-MAP.md#r-how-a-carried-difference-grows (gap_polynomial_iff_no_loop), #r-what-a-cut-loses (carried_le_polynomial_from), #r-how-loops-form (Closing.Onset.unforeseen); theories/becoming/chapters/05-COLLECTIVES.md#r-mutual-dependence-and-its-pace (carried_pow_around, exponential_around, Flow.Balances.doubling_needs); theories/becoming/chapters/02-MAP.md#r-whether-a-loop-closes-a-difference ('With whole-number factors a loop closes at once, keeps, or exceeds every bound, never closing gradually (LoopReturn.nothing_between)'); theories/becoming/chapters/02-MAP.md#r-two-sided-regulation-and-late-reading (Flow.withinGap_iff_between; Regulation.no_narrower_band; Regulation.relay_threshold); theories/becoming/chapters/02-MAP.md#r-loss-read-in-time-by-the-others (ReadInTime.kept_iff, turned_iff; Collingridge reading); theories/becoming/chapters/05-COLLECTIVES.md#r-own-count-misses-joint-excess ('It restates the tragedy of the commons and overshoot (Lloyd 1833; Hardin 1968; Meadows and others 1972) in near-definitional arithmetic'); theories/becoming/chapters/02-MAP.md#r-target-capture (share_rises), #r-capture-through-the-rule (RuleCapture.favouring_locks: 'only a change of the law, of how the rule reads or of the selection leaves'), #r-closed-capture (lock_outlives_loss); theories/becoming/chapters/05-COLLECTIVES.md#r-relative-position-is-zero-sum (rise_needs_fall; 'That a race for position produces joint excess is a premise here'); #r-a-race-for-position-draws-everything; theories/becoming/chapters/03-KNOWING.md#r-seeking-boundary (Law.aboveAll_never_rests, Flow.more_exhausted); theories/becoming/chapters/08-METHOD.md#beyond-the-table (line 462 'Regulation restates deadbeat control and requisite variety'; line 475 Bateson; Arthur 1989 bullet); theories/becoming/results/records/readings-a-response-needs.md line 49 (requisite variety reading); grep of Becoming/*.lean for 'Ashby|requisite': no match; theories/becoming/chapters/05-COLLECTIVES.md#open (Ostrom only in a study item; 'How pools form, last and resist capture'); theories/becoming/chapters/04-LIFE.md#r-need-drift-along-a-lineage (not eroding goals)

### (4) What does the theory give back to these traditions that they lack?
Eight things, in rough order of weight.

1. **A premise ledger with logical calibrations.** It shows which classical sayings silently need a logical principle or a structural premise:
   - symmetric 有无相生, and 堅白 「不相外則相盡」, each hold for every carrier and mark exactly where ¬¬Q → Q holds (`«相待之还当且仅当双非可还»`). This shows where Wang Bi's asymmetry (本末) lives in a constructive logic;
   - 「不俱當，必或不當」 is exactly weak excluded middle;
   - 念念灭 is exactly that nothing conditions itself;
   - the Madhyamaka 不自生 is a premise about a model, not a law of the grammar (`«自缘则常»`, `«从缘生非文法之理»`).
2. **Exact scope (定域) instead of universal sayings.**
   - 穷则变 holds under 消息 and fails under the law admitting only broken lines (`Hexagram.allBroken_absorbing`), and 穷 can be ending.
   - 「为道日损」 has a floor: the coarsest lumping that keeps the values and carries the law.
   - 「其安易持」 is scoped: every loss of a returning configuration passes a juncture, and finding every lost juncture gives LPO.
   - 知彼知己 holds only within the coupling closure.
   - 大学's necessary side holds and its sufficient side generally does not.
3. **Countermodels.** The Mohist 攖 sentences are refuted (`«尺与尺可相尽»`). 類同 is shown not to be transitive (`«同于不必传递»`).
4. **Exhaustive, script-checked censuses on the Changes, with exceptions recorded.**
   - 26 place statements agree with parity, with two exceptions (需上六, 艮六五).
   - Wang Bi's 初上无位 holds for all 28 place statements; no parity for the top place can (`top_no_parity`).
   - The nuclear hexagram's 16/16/32 basins (`basin_iff`).
   - The six orbits of 消息 (`orbit_census`).
   - The received order is run only by the law its own table defines, and two tested rule families cannot run it.
   These could have failed and are exact. They are the most falsifiable contribution to traditional scholarship, though largely confirmatory of Wang Bi's own argument.
5. **A taxonomy of four non-relational layers.** The four are a prior ground, a nature or value fixed before relations, a single governing will, and contest and rank. Each comes with responses from inside the same tradition: 王夫之 against prior ground, 嵇康 against fixed value, 黄宗羲 against a single will, 老子's 人之道 against contest (AI reading D54). The traditions are not refuted from outside.
6. **Observations on the Laozi's variants.** The Guodian and Mawangdui texts lack several of the most universalizing lines: 知常曰明, 周行而不殆, 不争. This is an observation, not a dating claim.
7. **A function-word convention for 文言.** It fixes one structure each for 若, 则, 故, 必, 或, 皆, 莫, 莫不, 屡, 不, 未. In particular 不 is refutation, 未 is not-yet-decided, and 或 is constructive, which aligns the particles with a constructive logic. It is untested on historical sentences.
8. **Divergences recorded verbatim.** 73+15 戊 and 373+167 己; 59 of 248 passages; 200 of 1,300 entries. Nothing is harmonized away.

**In return, the texts gave the spine questions.** 62 of the atlas's 76 gap entries now read new laws, for example 「不患寡而患不均」 becoming least parts and equal shares, and 「治大国若烹小鲜」 becoming repeated disturbance. Most of these laws are near-definitional.

Evidence: theories/becoming/chapters/06-CLASSICAL-TEXTS.md#calibrations-of-the-corpus («相待之还当且仅当双非可还», «必或不当当且仅当弱排中», «不相外则相尽当且仅当双非可还»); theories/becoming/chapters/06-CLASSICAL-TEXTS.md#conditional-laws (不自缘, 无环, 同根, 诘之有常) and the three refuted («尺与尺可相尽», «从缘生非文法之理»); theories/becoming/chapters/06-CLASSICAL-TEXTS.md#yi-readings (穷变通久 定域) and #corpus ('穷则变是丙一之律，穷而息是其反例'); theories/becoming/chapters/06-CLASSICAL-TEXTS.md#three-layer-verdict (为道日损 has a floor; 其安易持 with LPO; 大学 necessary side); theories/becoming/chapters/06-CLASSICAL-TEXTS.md#r-place-relations-in-context (placeStatements_agree; xu_top_inPhase, gen_fifth_out_of_phase); theories/becoming/chapters/06-CLASSICAL-TEXTS.md#r-fixed-places-and-sole-lines (top_no_parity, placeStatements_hold: 28 statements); theories/becoming/chapters/06-CLASSICAL-TEXTS.md#r-hexagram-world-laws (basin_iff, orbit_census) and #r-hexagram-arrangements-and-laws (runsOrder_agrees, ringRule_not_runsOrder, rearrange_not_runsOrder); theories/becoming/chapters/06-CLASSICAL-TEXTS.md#four-layers (table of four layers with internal responses); theories/becoming/chapters/06-CLASSICAL-TEXTS.md#three-layer-verdict, paragraph 老子之异文 (Guodian/Mawangdui variants); theories/becoming/chapters/06-CLASSICAL-TEXTS.md#zhonghua (eleven function words: 「不 X」是由 X 推出矛盾，「未 X」…); theories/becoming/chapters/06-CLASSICAL-TEXTS.md#zh-gaps (76 gap entries; 62 read new laws; table of laws); theories/becoming/chapters/06-CLASSICAL-TEXTS.md#corpus (classification table: 戊 73/15, 己 373/167)

### (5) Risks of over-reading, or of smuggling a reading into a definition
(a) **Chinese names on standard mathematics.** The front pages say "The grammar's terms are reconstructed from classical Chinese texts" (ONE-PAGE; overview §6). The review cover says the operations are ordinary relational calculus and only the names come from the texts. A reader can take a Chinese name as evidence of classical origin. The core is the greatest bisimulation inside a class; nothing classical produced it.

(b) **Theorems named with weighty classical phrases whose content is by construction or near-trivial.**
- `«化之二说同形»` is `Iff.rfl`: both sentences were encoded by one definition.
- `«生生不息»`: "The two exclude each other by construction".
- `«非一非异»` and `«因灭而续»` follow in a few lines from an irreflexive net and the two-block class.
- The 中论 candidates are steps lifted out of reductio arguments, which the packet admits are near-trivial (B-12).

(c) **An overclaim about the 中论.** The overview calls `«因灭而续»` "an answer to the Middle Treatise's objection that a ceasing cause is annihilation". The plan and the packet say the theory stands where Nāgārjuna's opponent stands and that "定理……并不处理龙树'因断'之论证所依之前提". The co-presence premise is open.

(d) **One word, two senses.**
- 生生 is formal renewal without end and also the ethical direction. The glossary puts both in one row, against its own one-sense rule. The theorem name `«生生不息»` invites hearing the formal result as a claim about life in the whole.
- 理 is any law-carrying lumping (03 §6) and also the core (the grammar's theorem names).
- 窮, 通, 復, 位, 勢, 度 mean one thing in the name table and another in the grammar (ch06 §三 two name systems).
- 无明 and 明 are redefined from Buddhist avidyā into locked seeking (B-32).

(e) **Selection effects.**
- The 619+33 evaluative (丁) sentences were set aside and only counted. They are most of the Laozi and the Xici, and exactly where the traditions diverge from a value-neutral spine.
- The mapping favours passages with readable structure.
- 37 central characters are rejected as names (道, 气, 天, 心, 性, 仁).
- So "the relational start is a leading thread" and "81% agreement plus scoping" are rates over a filtered set. The chapter acknowledges the filtering, but the front-page summary of the counts does not carry it.

(f) **Agreement backed by definitional theorems.** 道法自然 is tied to `World.run_world` (by definition). A structural match with a definitional identity confirms little. The chapter's "相合不是印证" covers this formally, but readers may not take it in.

(g) **Choosing which sense of a source to keep.** The theory keeps 孔颖达's "後生次於前生" and drops his evaluative "劝戒", and reads 易 as wider than 生生 against the copula (C-13).

(h) **AI on AI.** The atlas itself was built with AI help; the mappers, revisers and checkers are AI; the 中华本 fidelity count was coded by the family of the model that wrote the 經. The third read found that 84 of the 88 entries the reviser had left unchanged needed correction. Entries that had only two reads are unreliable by the chapter's own statement.

(i) **Voice outrunning chapter.** OPENING (Ren's voice): "I take it to be the truth, the dharma, the Dao." Ch06 §九 answers no to "是否就是唯一完整的道". The footnotes label this a reading; a change would go through a proposal.

(j) **Modelling choices read as wisdom.** The whole-number artefact "a loop never closes gradually" and discrete steps (simultaneous mutual dependence, 唯识's 因果俱时, is not represented) can be read as substantive claims about systems or about the texts.

Evidence: theories/becoming/ONE-PAGE.md line 21 ('The grammar's terms are reconstructed from classical Chinese texts'); THE-THEORY-OF-BECOMING.md line 134; theories/becoming/review/BUDDHIST-THOUGHT.md intro ('文法之运算是通行的关系演算（复合、逆、交、补、传递闭包），名取自古文，不表示运算出自古文'); review/CLASSICAL-TEXTS.md cover ('这些运算是通行的关系代数，只是用汉字命名'); experiments/.../Becoming/GrammarReadings.lean «化之二说同形» (Iff.rfl); Grammar.lean:629-632 docstring of «生生不息» ('by construction'); theories/becoming/review/BUDDHIST-THOUGHT.md B-12 ('定理本身近乎平凡'), B-02 ('定理只说三者可以同时成立，并不处理龙树“因断”之论证所依之前提'); theories/becoming/THE-THEORY-OF-BECOMING.md line 136 ('an answer to the Middle Treatise's objection that a ceasing cause is annihilation'); GLOSSARY.md line 17 (生生 row with two senses) vs GLOSSARY.md intro ('each in one sense and with one home'); theories/becoming/chapters/06-CLASSICAL-TEXTS.md#two-name-systems (窮 通 復 位 勢 度 differ); theories/becoming/review/CLASSICAL-TEXTS.md C-38 ('丁类暂缓，使数量最多的句子（《老子》过半）不入检验，可能使检验偏向合于理论者'); classify/REPORT.md (老子 丁 263 of 482); theories/becoming/chapters/06-CLASSICAL-TEXTS.md#r-chinese-sources-on-the-spine ('映射偏向有结构可读的段落'); theories/becoming/chapters/06-CLASSICAL-TEXTS.md#r-civilization-thought-on-the-spine ('修订者原样保留的 88 条，第二位检查者读后 84 条要改正'; '只经两读的条目不可靠'); theories/becoming/OPENING.md line 21 ('I take it to be the truth, the dharma, the Dao'); 06-CLASSICAL-TEXTS.md#dao (answers 否); theories/becoming/chapters/06-CLASSICAL-TEXTS.md#ro-gaps (simultaneous mutual dependence not represented)

## Strengths
- [proved-core] Of the corpus's 59 candidate theorems, the pure core proves 38 for every carrier and relation and 15 under one named premise. It refutes 3 by countermodel, finds 2 misfiled and 1 inexpressible. Which sentence is read as which theorem is labelled AI reconstruction. — experiments/.../Becoming/GrammarCandidates.lean; _process/research/.../development/ou2-candidates/outcomes.tsv (outcome column: 38/15/3/2/1); theories/becoming/chapters/06-CLASSICAL-TEXTS.md#r-candidate-theorems-of-the-corpus
- [proved-core] The premise ledger turns classical sayings into calibrated statements. Symmetric 有无相生 holds exactly under double-negation elimination, 必或不当 exactly under weak excluded middle, and 念念灭 exactly where nothing conditions itself. That everything arises from conditions is a premise about a model, not a law of the grammar. — theories/becoming/chapters/06-CLASSICAL-TEXTS.md#calibrations-of-the-corpus; theories/becoming/chapters/06-CLASSICAL-TEXTS.md#conditional-laws; GrammarCandidates.lean «相待之还当且仅当双非可还», «必或不当当且仅当弱排中», «念念灭当且仅当无自缘», «从缘生非文法之理»
- [known-result-restated] 文 is defined exactly, and 文同 is proved to be the core of the value class under a law's step. This joins a classical name to Moore and Myhill–Nerode equivalence, and the chapter credits those known results. — theories/becoming/chapters/03-KNOWING.md#r-wen-in-the-grammar (Law.core_is_sameFuture, Law.coarsest_iff_core, TwoCourses.core_exact); theories/becoming/chapters/06-CLASSICAL-TEXTS.md#wenli (Reading D63: Fine–Wilf, Moore, Myhill–Nerode, Gold); _process/research/.../development/wl3-wen-grammar/MAPPING.md §2
- [proved-core] The Changes are written as a finite world meeting the pure core's conditions (six modules in the instance ring). Exhaustive script-checked censuses test textual statements against line positions and record the exceptions. Wang Bi's 初上无位 fits all 28 place statements, where no parity for the top place can. — theories/becoming/chapters/06-CLASSICAL-TEXTS.md#r-hexagrams-on-the-spine, #r-place-relations-in-context, #r-fixed-places-and-sole-lines (top_no_parity, placeStatements_hold), #r-censuses-of-the-xiang-and-tuan; check_becoming.py INSTANCES list includes Becoming.Hexagrams … HexagramSequences (archived copy in lean/regime/regime-reals-checks/20261021T102713.696033Z/check_becoming.py:91)
- [empirical] Divergences are recorded, not harmonized. 戊 and 己 units are counted in both rounds. The theory concedes its continuation stands on the side the 中论 refutes, lists four recurring non-relational layers with responses from inside each tradition, and sets out a 'does not show' list that disclaims historical meaning. — theories/becoming/chapters/06-CLASSICAL-TEXTS.md#corpus, #divergences, #four-layers, #does-not-show; theories/becoming/review/BUDDHIST-THOUGHT.md B-02 (quote of PLAN)
- [known-result-restated] The core systems-dynamics structures have exact theorems on the World model, each with stated hypotheses, and are honestly labelled restated or near-definitional against the literature. They cover stocks and flows (balance), reinforcing loops (polynomial growth exactly where no loop lies upstream), balancing with overshoot, regulation under delay, the commons and overshoot, lock-in through the rule, and zero-sum relative position. — theories/becoming/chapters/02-MAP.md#r-how-a-carried-difference-grows, #r-two-sided-regulation-and-late-reading, #r-capture-through-the-rule, #r-closed-capture; theories/becoming/chapters/05-COLLECTIVES.md#r-own-count-misses-joint-excess, #r-relative-position-is-zero-sum; theories/becoming/chapters/08-METHOD.md#known-results ('None of the central results is new mathematics')
- [empirical] The classical texts generated spine work: 62 of the atlas's 76 gap entries now read new laws, and 5 of the 7 gaps from the 248-passage map are proved. The laws are mostly near-definitional, but the questions came from the texts. — theories/becoming/chapters/06-CLASSICAL-TEXTS.md#zh-gaps; theories/becoming/chapters/06-CLASSICAL-TEXTS.md#ro-gaps
- [empirical] The human review is designed and ready: three dossiers (38, 35 and 29 items) and a blind recoding of 237 units with a fixed reading of kappa, frozen before any human coded. — theories/becoming/review/recoding/FREEZE.md; _process/BECOMING-WORKBOARD.md row RP ('Left: Ren's decisions (sender, purpose, consent, date, push)')

## Gaps
- [high/missing-test] No reading is checked for fidelity to the texts. All 4,116 units are single-coded by AI with no agreement statistic. The 248-passage and atlas mappings are AI on AI; the third read corrected 84 of the 88 entries the reviser had kept, and entries with two reads are unreliable by the chapter's own statement. The 237-unit recoding is frozen but uncoded; sending the packet waits on Ren's decisions. — _process/research/.../one-unfolding-root/classify/REPORT.md (四个 Opus 子代理; 每一行都是 AI 重构，无人审); theories/becoming/review/recoding/FREEZE.md; theories/becoming/chapters/06-CLASSICAL-TEXTS.md#r-civilization-thought-on-the-spine; _process/BECOMING-WORKBOARD.md row RP
- [medium/overclaim] Front-page overclaim of origin. ONE-PAGE and overview §6 say the grammar's terms are 'reconstructed from classical Chinese texts'. The review cover states the operations are standard relational calculus with names taken from the texts. — theories/becoming/ONE-PAGE.md line 21; theories/becoming/THE-THEORY-OF-BECOMING.md line 134; theories/becoming/review/BUDDHIST-THOUGHT.md intro; review/CLASSICAL-TEXTS.md cover
- [medium/overclaim] The overview calls «因灭而续» 'an answer to the Middle Treatise's objection'. The plan, the packet (B-02) and ch06 §十一 say it restates the opponent position Nāgārjuna refutes, does not engage the premise of his argument, and rests on an open co-presence question. — theories/becoming/THE-THEORY-OF-BECOMING.md line 136; theories/becoming/review/BUDDHIST-THOUGHT.md B-02; theories/becoming/chapters/06-CLASSICAL-TEXTS.md#divergences (中观破相续 … 仍是开放的)
- [medium/structural] Selection bias in the test set. The 619+33 evaluative (丁) sentences were set aside and only counted (老子 263 of 482). The mappings favour structurally readable passages. So the agreement-plus-scoping rates (81% in the atlas) describe a filtered set where traditions least diverge. — theories/becoming/review/CLASSICAL-TEXTS.md C-38 Q91; classify/REPORT.md count table; theories/becoming/chapters/06-CLASSICAL-TEXTS.md#r-chinese-sources-on-the-spine (此评估之限)
- [medium/missing-test] A large untested backlog: 181 second-round candidate theorems are untested, and 162 first-round 丙一 laws are not written as 'Y iff Z'. The 系辞 contributed no candidate theorem, so its use is entirely by reading and the hexagram world. — theories/becoming/chapters/06-CLASSICAL-TEXTS.md#open (丙一与新候选); _process/research/.../ou2-candidates/outcomes.tsv (no XCS ids); classify/REPORT.md (系辞 乙 0)
- [medium/missing-model] Systems-thinking coverage is partial and unassembled. Shifting the burden, eroding goals, fixes that fail and leverage points are not treated. Ostrom appears only in an open study item. Ashby's requisite variety is claimed restated, but no Lean declaration states it. No single assessment maps archetypes to laws with their hypotheses. — theories/becoming/chapters/08-METHOD.md#beyond-the-table line 462; theories/becoming/chapters/05-COLLECTIVES.md#open; grep of chapters for 'shifting the burden', 'eroding goal', 'leverage point': no matches
- [medium/readability] One word carries two technical senses. 生生 is renewal without end and also the ethical direction (one glossary row, against the glossary's one-sense rule). 理 is any law-carrying lumping (03 §6) and also the core (the grammar's theorem names). The name table and the grammar use 窮, 通, 復 and 位 differently. — GLOSSARY.md line 17 and intro; theories/becoming/chapters/03-KNOWING.md#li vs 01-ROOT.md#r-a-regularity-kept-and-changed; theories/becoming/chapters/06-CLASSICAL-TEXTS.md#two-name-systems
- [low/overclaim] Theorems carrying classical phrases are by construction or near-trivial («化之二说同形» is Iff.rfl; «生生不息» holds by construction; «非一非异», «因灭而续»). The Lean docstrings say so, but the chapter tables present them beside the original sentences as 所证 without flagging this. — experiments/.../Becoming/GrammarReadings.lean; experiments/.../Becoming/Grammar.lean:629-632; theories/becoming/chapters/06-CLASSICAL-TEXTS.md#r-classical-definitions-in-the-grammar table
- [medium/missing-model] Wisdom traditions beyond Chinese texts are untreated. Whitehead and process philosophy are named neighbours only. Indigenous relational ontologies are absent. Other traditions appear only in OPENING's footnote, which reads the Golden Rule as the step of invariance. — theories/becoming/results/records/continuation-relative-to-a-class.md line 65; theories/becoming/chapters/08-METHOD.md line 544; theories/becoming/OPENING.md [^sages]
- [low/overclaim] Fidelity counts measure the 中华本's agreement with the Lean statements, not with historical meaning, and are easily conflated with the latter. The main-set 經 were coded by the model family that wrote them, and controlled English ties. — theories/becoming/results/records/fidelity-of-the-classical-statements.md (Does not show); theories/becoming/chapters/06-CLASSICAL-TEXTS.md#r-fidelity-under-one-discipline
- [low/structural] The 中华本 is stated on the World model, not the grammar, and needs rewriting. WRT2 landed during this review (8882b7995: the World represented in the grammar both ways, its amounts not), which may make the rewrite tractable. The rewrite is not claimed. — theories/becoming/chapters/06-CLASSICAL-TEXTS.md#open (中华本之根基); git log -- GLOSSARY.md: 8882b7995 'WRT2 landed'
- [low/readability] A modelling artefact can read as wisdom. 'A loop never closes gradually' (LoopReturn.nothing_between) holds only for whole-number factors. Simultaneous mutual dependence (唯识 因果俱时) is unrepresented because steps are discrete. A systems or Buddhist reader could take either as a substantive claim. — theories/becoming/chapters/02-MAP.md#r-whether-a-loop-closes-a-difference; theories/becoming/chapters/06-CLASSICAL-TEXTS.md#ro-gaps (同时之依存未表示)
- [low/mechanical] Loose citation: Wang Yangming's '行是知之成合于实验之律' links to chapter 03 with no anchor and no declaration. — theories/becoming/chapters/06-CLASSICAL-TEXTS.md#wang-yangming
- [low/readability] The live jian-and-wenyan README opens with the nine-particle 'STLC-complete' programme. It has no top pointer saying the root grammar superseded that programme and that completeness is unproved, which ch06 §九 states. — theories/jian-and-wenyan-as-formal-language/README.md lines 9, 279; theories/becoming/chapters/06-CLASSICAL-TEXTS.md#pre-qin ('已为根之文法取代，其完备之说未证')
- [low/readability] Ren's voice outruns the chapter. OPENING says 'I take it to be the truth, the dharma, the Dao', while ch06 §九 answers no to whether the theory is the unique complete 道. This is legitimate as his voice and footnoted as a reading, but readers meet OPENING first. — theories/becoming/OPENING.md line 21; theories/becoming/chapters/06-CLASSICAL-TEXTS.md#dao

## Load-bearing claims
- The 59 first-round candidate theorems resolve as 38 proved, 15 conditional, 3 refuted, 2 misclassified, 1 not expressible. 40 of them come from Buddhist texts (JSZ 4, QXL 10, ZL 26) and none from the 系辞. (check: Count the outcome column and id prefixes in _process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou2-candidates/outcomes.tsv. Compare with the 乙 column of one-unfolding-root/classify/REPORT.md.)
- All 4,116 units were classified by AI with no agreement statistic and no human coding; the 237-unit blind recoding is frozen but not run. (check: Read one-unfolding-root/classify/REPORT.md (no agreement figure) and theories/becoming/review/recoding/FREEZE.md ('before any human coded a unit'). Check the RP row of _process/BECOMING-WORKBOARD.md for the 'Left: Ren's decisions' clause.)
- «化之二说同形» is definitional (Iff.rfl), and «生生不息» holds by construction (greatest family against the inductive least property). (check: Read Becoming/GrammarReadings.lean (theorem «化之二说同形» := fun _ _ => Iff.rfl) and Becoming/Grammar.lean lines 253 and 626–640.)
- 文同 is exactly the core of the value class under a determined law's step. (check: Lean declaration Law.core_is_sameFuture (and Law.alike_iff_core) cited in theories/becoming/chapters/03-KNOWING.md#r-wen-in-the-grammar; record theories/becoming/results/records/wen-in-the-grammar.md; the core receipt's audit list.)
- Wang Bi's 初上无位 reading makes all 28 place statements hold, while no parity for the top place does. (check: Becoming/HexagramSites.lean declarations top_no_parity and placeStatements_hold; record theories/becoming/results/records/fixed-places-and-sole-lines.md; the census script referenced from ch06 §5.2.)
- The overview presents «因灭而续» as an answer to the 中论, while the plan and packet say the theory's position is the refuted opponent's and the theorem does not engage the argument's premise. (check: Compare theories/becoming/THE-THEORY-OF-BECOMING.md line 136 with theories/becoming/review/BUDDHIST-THOUGHT.md B-02 and one-unfolding-root/PLAN.md (quoted there).)

## Recommendations
- P1 Decide the packet's sender and send it, or at least run the 237-unit blind recoding with two human coders. Report kappa and per-class confusion before adding further classical claims. — serves fidelity of every classical reading; human representability; Every claim about agreement with the texts is currently AI on AI. The recoding is designed and frozen, so the cost is small and it is the one test that could change the line's standing.
- P2 Correct two front-page sentences. ONE-PAGE line 21 and overview line 134 should say 'standard relation algebra, its terms named and read from classical texts'. Overview line 136 should say «因灭而续» 'restates the opponent's answer the 中论 refutes; whether conditions must be co-present stays open'. — serves honest representability for outside readers, including alignment readers who will not read the Chinese chapter; Both overstate what the chapter and the packet themselves say. The English summaries are what most readers see.
- P3 Give the formal 生生 its own mark (always «生生», gloss 'renewal without end') and keep plain 生生 for the direction. Split the glossary row. Fix 理 to one sense, the core, and rename the 03 §6 notion, or the reverse. — serves readability; preventing equivocation between the formal and the ethical; «生生不息», a by-construction theorem, currently reads as a claim about life in the whole, and 理 shifts between 'a' and 'the coarsest' lumping.
- P4 Write one assessment (no new Lean) mapping Meadows' archetypes and leverage points, Ashby, Bateson and Ostrom's design principles to existing laws with their exact hypotheses. Mark the absent ones as open: shifting the burden, eroding goals, fixes that fail. Make 'how pools form, last and resist capture' an Ostrom-anchored research item. — serves alignment for human institutions; human representability through a vocabulary practitioners already use; The theory already has exact versions of half the archetypes but never presents them as such. Ostrom's commons work is the empirical counterpart of its most open collective question.
- P5 Sample the deferred 丁 (evaluative) sentences and map them with the same three relations under the two premises: the continuation condition for scope, C for order. Report the divergence rate with them included. — serves removing selection bias from the 'relational thread' finding; The traditions most diverge from a value-neutral spine exactly in the deferred sentences.
- P6 Work through the 181 second-round candidates and write the 162 丙一 laws as 'Y iff Z'. For the 中论's co-presence horn, add a co-presence relation as an explicitly declared model choice and test the dilemma on it. — serves strength of the formal correspondence; engagement with the strongest critic of continuation; Only a quarter of the candidates are tested, and the open co-presence question is where the Madhyamaka challenge actually bites.
- P7 If 'other wisdoms' is in scope, do a bounded assessment of Whitehead (enduring objects against 续, prehension against coupling) and of one or two Indigenous relational ontologies, using the same three relations and divergence discipline. Present the Golden Rule reading in OPENING as an AI reading in a chapter rather than only a footnote. — serves breadth of the wisdom mapping Ren asked about; The live theory treats only Chinese sources; its neighbours in process philosophy are named but never compared.
- P8 In the ch06 tables, flag theorems that are definitional or near-trivial (for example with '依定义' or '近于定义', as the 化 row already partly does). Anchor the Wang Yangming 'law of experiment' citation. Add a supersession pointer at the top of the jian-and-wenyan README. — serves readability; guarding against over-reading; Small edits that keep the classical names from sounding like vindication.

## Not read
Read selectively, not in full:
- ch06: §5.2–5.6 tables were read but not checked against the Lean.
- 03 §§6–7 in full; 01 §§1–7 trimmed.
- 02 §§7–9 trimmed; 05 §§1, 3, 5, 8 and Open trimmed.
- 08 §8 in full.
- The review packet: CLASSICAL-TEXTS C-01, C-13, C-34, C-35 and C-38, and BUDDHIST-THOUGHT intro, B-02, B-08, B-12 and B-34.
- GrammarReadings.lean in full; the «生生» and «息» parts of Grammar.lean; headers of Hexagrams.lean; one theorem of MoveFormation.lean.
- WL3 MAPPING §§1–3 in part; the classify REPORT and recoding FREEZE; parts of the records for fidelity, civilization-thought and readings-a-response-needs.
- Grep only: OPENING, the jian-and-wenyan README and the 248-passage mapping chapter (CHINESE-SOURCES-AND-BECOMING.md, 407 KB).

Not read:
- the atlas chapter (CIVILIZATION-THOUGHT-AND-BECOMING.md), the 中华本 book, WENLI-AND-BECOMING.md, DAO-AND-GENERATIVITY, WANG-YANGMING and PRE-QIN history chapters;
- the zhonghua and wl2 study folders beyond file listings;
- PHILOSOPHY.md items; the remaining CLASSICAL-TEXTS and BUDDHIST-THOUGHT items;
- 04 and 07 beyond grep;
- the Lean of HexagramLaws, HexagramSites, GrammarCandidates and the systems laws (taken from chapter statements and records);
- the second-round classification files.

No checker, render or build was run; Lean claims rest on the chapters, records and the source files read. Outside literature (Meadows' archetypes and leverage points, Ostrom, Ashby, Whitehead) is from my prior knowledge.
