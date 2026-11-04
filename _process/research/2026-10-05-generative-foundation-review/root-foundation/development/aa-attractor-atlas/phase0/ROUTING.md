# AA Phase 0: the errata, verified and routed

*AI-written, 4 November 2026. Four read-only verifiers checked E1–E40 of the atlas plan's Appendix C against main at `3bf962941`; for each group with flags at the level of belief, an independent sceptic tried to refute them, and none was refuted. Every finding's file-and-line evidence is in [results-2026-11-04.json](results-2026-11-04.json). They go through the coordinator to each page's owner, belief-level first (AGENTS item 1). Owners are the verifiers' reading of the board and of git history. Links inside the quoted evidence and fixes are shown as code: they are written as they would read in their target pages.*

Verdicts: holds 32, partly 7, fixed 1. At the level of belief after verification: E5, E6, E8, E15, E3.

## LA4

### E5 (holds, belief; sceptic: stands)

**Evidence.** theories/becoming/THE-THEORY-OF-BECOMING.md:195: "The theses' tests still to run include T1 with a need measured in advance, T3 varying how near a trained system comes to its optimum, T4's transfer...". The same page at l.22 says "One frozen test varied how near small trained policies came to their reward's optimum". The home, 05-COLLECTIVES.md:227, says "its frozen test finds the drain rising with nearness ... (LA4's Stage A, below)". THE-THEORY-OF-BECOMING.zh.md:195 has the same error: "改变训练出的系统与其最优之距离以检验 T3". Blame puts l.195 at 368a8bde7 (OG2), which predates LA4's run 1c6a8733e (3 Nov 12:21) and its text commit 46b5af24b. 46b5af24b updated l.22 but not l.195. Only Stage B, on language models, is still to run, and it is not frozen yet (experiments/drain-beyond-the-reward/README.md:36: "of language models (Stage B)").

**The home says.** 05-COLLECTIVES.md:227: "On small policies trained by gradient, its frozen test finds the drain rising with nearness, as policy gradient's update rule largely gives, and leaves its locus unresolved (LA4's Stage A, below)."

**Fix.** In THE-THEORY-OF-BECOMING.md:195, replace "T3 varying how near a trained system comes to its optimum" with "T3 on language models (LA4's Stage B, not yet frozen; its Stage A, on small policies trained by gradient, found the drain rising with nearness, as policy gradient's update rule largely gives, and left its locus unresolved)". The parenthesis uses the home's words from 05:227. In THE-THEORY-OF-BECOMING.zh.md:195, replace "改变训练出的系统与其最优之距离以检验 T3" with "以语言模型检验 T3（LA4 的第二阶段，尚未冻结；其第一阶段在以梯度训练的小型策略上发现耗竭随接近而上升，这大体出自策略梯度的更新规则，其所在未能判定）".

**Owner, as read.** LA4 board row ("LA4: the drain beyond the reward"; its state lists the texts of 05 §7, 08 and the overview as its own). The line was last touched by OG2 (368a8bde7, landed; no row).

**Sceptic.** I could not refute it. THE-THEORY-OF-BECOMING.md:195 lists, among "The theses' tests still to run", "T3 varying how near a trained system comes to its optimum". The same page at l.22 says "One frozen test varied how near small trained policies came to their reward's optimum", and the home, 05-COLLECTIVES.md:227, says "its frozen test finds the drain rising with nearness ... (LA4's Stage A, below)". So l.195 tells a reader that a test which has run is still to run, and l.22 sits in another section, too far away to qualify it. What is left is Stage B, on language models. experiments/drain-beyond-the-reward/README.md:3 says "Stage B is not frozen: its pilot needs model downloads". DESIGN.md:127 confirms that Stage B also varies nearness (ν). The zh l.195 has the same error. Nothing on main fixes it: the last commits touching the file are 45f61a167 and 67080777c, and neither changes l.195. The verifier's fix is correct and copies 05:227's words with their qualifiers. Restating Stage A's finding in a list of what is still to run is redundant with l.22, though, and adds a second restatement that has to be kept in sync with the home. A shorter fix drops nothing.

### E6 (holds, belief; sceptic: stands)

**Evidence.** 08-METHOD.md:570, Forbids column: "with outcomes, couplings and reward fixed and the optimality gap measured: a system nearer its optimum leaving a room-giving condition beyond its couplings higher; a drive on a choice whose values nothing rewarded and nothing the learner reads tells apart; ... or a constraint at the need leaving a margin; an instruction not bringing a dependent into what learners couple into yet keeping it more often". The home, 05-COLLECTIVES.md:228, reads "with eligible outcomes ... higher, on average, than one further from it; a systematic drive ...". The 08 copy drops six things: "eligible", "reward's", "on average, than one further from it" (so the comparison has no second term), "systematic", "above it" and "than the same learners without the instruction". Without "on average" and "systematic", one pair or one noisy drift would fall under the forbidden case. That is stronger than the home, and it bears on LA4's P3, which the home reads "on average". 08's own §9 preamble (l.564) says the table "copies ... what it forbids". Blame: a396d8bce (LA4).

**The home says.** 05-COLLECTIVES.md:228: "*Forbids*, with eligible outcomes, couplings and reward fixed and the optimality gap measured: a system nearer its reward's optimum leaving a room-giving condition beyond its couplings higher, on average, than one further from it; a systematic drive on a choice whose values nothing rewarded and nothing the learner reads tells apart; ..."

**Fix.** Replace 08-METHOD.md:570's Forbids cell with the home's words verbatim: "with eligible outcomes, couplings and reward fixed and the optimality gap measured: a system nearer its reward's optimum leaving a room-giving condition beyond its couplings higher, on average, than one further from it; a systematic drive on a choice whose values nothing rewarded and nothing the learner reads tells apart; where room exists, a side-effect term ranked after the reward protecting a condition, or a constraint at the need leaving a margin above it; an instruction that does not bring a dependent into what the learners couple into, yet keeps it more often than the same learners without the instruction".

**Owner, as read.** LA4 board row. The cell was last committed in a396d8bce (LA4).

**Sceptic.** I could not refute it. 08-METHOD.md:564 says "the table copies its standing, what it forbids and its evidence". The T3 row at 08:570 reads "a system nearer its optimum leaving a room-giving condition beyond its couplings higher; a drive on a choice ...; or a constraint at the need leaving a margin; an instruction not bringing a dependent into what learners couple into yet keeping it more often". The home, 05:228, reads "nearer its reward's optimum ... higher, on average, than one further from it; a systematic drive ... a margin above it; ... more often than the same learners without the instruction". Dropping "on average" and "systematic" makes the forbidden case stricter, so a single pair or a noisy drift would count as a refuter. That matters for reading LA4's P3, where the seeds spread widely (README: "by update the lower bounds reach −1.5 fish"). Nothing nearby in 08 supplies these qualifiers. The overview row, THE-THEORY-OF-BECOMING.md:168, keeps "on average" but drops "systematic" and "eligible". The verifier's fix, a verbatim copy of 05:228's Forbids, is right. The page is hand-written.

### E7 (holds, med)

**Evidence.** The fronts state the caveat. THE-THEORY-OF-BECOMING.md:168: "the first five tests read as its evidence ran before its first wording, their frozen predictions their own". ONE-PAGE.md:19: "earlier tests later read as evidence". ONE-ARGUMENT.md:68: "T3 was first worded (commit `224944238`) after CG1, CG2, MQ1, SE1, both of IN1's rounds and CG3's first three rounds ran, and before CG3's fourth, EM1 and the LA tests". The home, 05-COLLECTIVES.md:227-243 (Standing and Evidence so far), has no such sentence. Its only "first worded" (l.227) concerns the second forbidden case's wording, not T3's. 08-METHOD.md:570's Evidence lacks the caveat too. I checked the dates: 224944238 is dated 2026-10-21 03:58 +0700, IN1 round 2 ran at ddd227062 (21 Oct 02:30) and EM1 was frozen at 42cf03228 (22 Oct). The order the fronts state holds.

**The home says.** 05-COLLECTIVES.md:227: "The law for optima is proved; the clause on trained systems is conjectured, with partial support." It has no sentence on when T3 was worded. The fact is stated at ONE-ARGUMENT.md:68.

**Fix.** In 05-COLLECTIVES.md:227, after "the clause on trained systems is conjectured, with partial support.", insert ONE-ARGUMENT's words: "T3 was first worded (commit `224944238`) after CG1, CG2, MQ1, SE1, both of IN1's rounds and CG3's first three rounds ran, and before CG3's fourth, EM1 and the LA tests; each test's predictions were its own, though LA1b and LA1c froze what each outcome would mean for T3's clause." Then add to 08:570's Evidence cell, before "CG1:": "the first tests ran before T3's first wording, their frozen predictions their own;".

**Owner, as read.** LA4 board row (it holds 05 §7 and 08's T3 row). The last commits there are LA4 and LA4s (208fe90e9, a396d8bce).

## AJ

### E8 (holds, belief; sceptic: stands)

**Evidence.** GOALS.md:114 (generated; header: "Edit records or scoped goals, not this view"; README.md:186 carries the same sentence): "the direction's formal part is a core theorem: a chosen move keeps the basic admissions some move keeps, and a move whose outcome another's widens is not chosen." The Lean says less. Direction.lean:99-104, `chosen_keeps_basic`, concludes `¬ ¬ W.Admits (l e.2) e.2 e.1` under `Priority` (J1/J2), and only where a single move `u` keeps every basic admission any move's outcome admits (`keeps`). The positive form, `kept_required` (l.111), needs the outcomes listed, the comparison weakly decided and the admission decided. `narrowed_not_chosen` (l.127) needs `decided : Decided (Included ...)`. The goal's sentence drops the double negation, the one-move hypothesis and both decision hypotheses. It dates from 7161482b0 (22 Oct). AJ8 (1dba53bf8) narrowed this goal's conditions but left this sentence alone.

**The home says.** 07-SIGNIFICANCE.md:560: "On a web's moves, where one move's outcome admits every basic admission any move's outcome admits, a basic admission it makes is not refuted at any chosen option, a double negation (`Direction.chosen_keeps_basic`)". 07:694: "under J1/J2 a move whose outcome another's widens is not chosen, wherever it is decided whether the widening adds a basic admission". 07:690: "Its formal part is a schema in the pure core".

**Fix.** Edit the source, _process/goals/generative-alignment.json:52, overview.summary.en, not GOALS.md or README.md. Replace "the direction's formal part is a core theorem: a chosen move keeps the basic admissions some move keeps, and a move whose outcome another's widens is not chosen." with "the direction's formal part is a schema in the pure core: under J1/J2, where one move's outcome admits every basic admission any move's outcome admits, a basic admission it makes is not refuted at any chosen option, a double negation, and a move whose outcome another's widens is not chosen, wherever it is decided whether the widening adds a basic admission." In overview.summary.zh, replace "方向的形式部分是核心定理：所选之动保有某一动所保有的基本容纳，结果被另一动之结果拓宽之动不被选。" with "方向的形式部分是纯核心中的一个图式：在 J1/J2 之下，凡一动之结果容纳任何一动之结果所容纳的每一基本容纳之处，它所作的基本容纳在任何所选选项处不被否定（双重否定）；凡已判定拓宽是否添加基本容纳之处，结果被另一动之结果拓宽之动不被选。" Then re-render.

**Owner, as read.** AJ board row ("AJ: alignment of the joint selection"; the generative-alignment goal is its own). The goal file was last edited by AJ8 (1dba53bf8) and LA4 (a396d8bce, next_step only).

**Sceptic.** I could not refute it. GOALS.md:114 and README.md:186 both say "the direction's formal part is a core theorem: a chosen move keeps the basic admissions some move keeps, and a move whose outcome another's widens is not chosen". GOALS.md is generated ("Edit records or scoped goals, not this view"). The Lean in Direction.lean says less on both counts. `chosen_keeps_basic` concludes `¬ ¬ W.Admits ...`, and only under `Priority` with one move `u` whose outcome keeps every basic admission (`keeps`). `narrowed_not_chosen` needs `decided : Decided (Included ...)`. The home, 07:560, says "a double negation"; 07:690 says "a schema in the pure core"; 07:694 says "wherever it is decided whether the widening adds a basic admission". So the goal's sentence drops the double negation, the one-move hypothesis and the decision hypothesis. A reader would take it to claim more than is proved. The source is _process/goals/generative-alignment.json, at .overview.summary.en and .overview.summary.zh. The verifier's fix edits the source, not the generated views, and builds the replacement from 07's own words.

### E15 (holds, belief; sceptic: stands)

**Evidence.** The flag holds. 02-MAP.md:436 ("So the third forbidden case occurs in this system at that reading"), 08-METHOD.md:574 ("so 02's third forbidden case occurs at that reading, though the frozen rule for it ... did not support it") and ONE-PAGE.md:20 ("another case T7 forbids") never say whether the occurrence counts against T7 or falls outside its premise. The pages do say the bridge failed (02:436: "the conjecture failed for this judge"). I also found a worse error: the numbering is now wrong. LA2's frozen predictions (experiments/self-rewarding-lock/PREDICTIONS-2026-10-25.md:97) define "T7's third forbidden case: a measure whose loss only those it disfavours read, dropped once the selection has left them no more than its carriers". At the time, 02's Forbids had three items (git show 1dba53bf8^:theories/becoming/chapters/02-MAP.md). AJ8 (1dba53bf8, 3 Nov) inserted a new second item ("such a metric, its selectors many ... left with nothing read changed more often than the drawn model's bound ... allows"). 02:434 now lists four, and its third is "a reform of the reading alone outlasting the next reading". So 02:436 and 08:574 now name the wrong case. In 08's row this is acute: its Forbids column lists "a reform of the reading alone outlasting the next reading" third, so a reader takes that to be what LA2 observed. 08:574's "and two more in [02]" is also off by one: it lists three of 02's four.

**The home says.** 02-MAP.md:434, the fourth Forbids item: "a metric whose loss is read only by those it disfavours, dropped once the selection has left them no more than its carriers among its readers, with nothing else changed, more often than drift alone would allow." 02:436: "In one trained system it tests the conjecture that a judge formed from what it selected is a pool of readers counted by kind ... the conjecture failed for this judge."

**Fix.** Land only the numbering fixes, using the home's words. (1) In 02-MAP.md:436, replace "So the third forbidden case occurs in this system at that reading;" with "So the fourth forbidden case above, a metric whose loss is read only by those it disfavours dropped once the selection has left them no more than its carriers among its readers (the third in LA2's frozen predictions, written before the drawn model's case was added), occurs in this system at that reading;". (2) In 08-METHOD.md:574, change "and two more in [02]" to "and one more in [02]". Change "so 02's third forbidden case occurs at that reading" to "so 02's fourth forbidden case, a loss read only by those it disfavours dropped once they are no more than its carriers, occurs at that reading". (3) Leave ONE-PAGE.md:20 and its zh edition unchanged; they carry no number. (4) Optionally, after "T7's third forbidden case" in experiments/self-rewarding-lock/README.md:12, add the note "(02's fourth since AJ8, 3 November)". Do not edit the frozen PREDICTIONS file. review/ALIGNMENT.md:589 defines the case it names ("T7's third forbidden case is a single reading turning the lock"), so leave it unless the packet is re-cut. (5) Do not land a sentence saying whether the occurrence counts against T7. List that question for the AJ owner (AJ3/LA2) to decide on argument, noting that the judge was formed from what it selected, so T7's premise appears to be met, while the *Refuted by* clause is not. Owner: the AJ row. The renumbering came in AJ8 (1dba53bf8).

**Owner, as read.** AJ board row (AJ3/LA2 for T7). AJ8 (1dba53bf8, 56402499e, landed) introduced the renumbering. ONE-PAGE goes through the fronts' owner, with ED2 ("edition 2 of the reader edition", claimed on main d14de40d5) told, since its edition carries ONE-PAGE and 08.

**Sceptic.** The renumbering part holds. Before AJ8, 02's T7 Forbids listed three items (1dba53bf8^:02-MAP.md:428), and the third was "a metric whose loss is read only by those it disfavours ...". LA2's predictions (PREDICTIONS-2026-10-25.md:97) define its "third forbidden case" by that same text. 02:434 now lists four items, with the drawn model's case inserted second, so the third is now "a reform of the reading alone outlasting the next reading". So 02:436 ("So the third forbidden case occurs in this system at that reading") and 08:574 ("so 02's third forbidden case occurs at that reading") now name the wrong case. In 08 the row's own Forbids column lists "a reform of the reading alone outlasting the next reading" third, so a reader would believe LA2 observed a reform outlasting the next reading. 08:574's "and two more in [02]" is also wrong: the column lists three of 02's four items, so one remains. ONE-PAGE.md:20 ("another case T7 forbids") uses no number and is correct as it stands. The verifier's proposed classification sentence is not supported by the home, and may be wrong. It says the occurrence falls "outside T7's premise ... since the judge's reading is not a pool counted by kind". But T7's premise (02:433) is "a metric whose rule and reading are formed from the share it selects", and 02:436 says the judge is "formed from what it selected", with the reference set "counted from the loop's earlier selections". What failed is the narrower conjecture that such a judge is a pool of readers counted by kind. Whether the occurrence counts against T7's Forbids is therefore open. The *Refuted by* clause (a documented-in-advance case with the drawn bound) is narrower and is not met. Adding "outside its premise" to 02, 08 and ONE-PAGE would put an un-homed and doubtful claim on three fronts, against the rule to copy the home's words first. That question should go to the owner as a decision, not be landed. Part (1) of the fix is also longer than it needs to be.

### E9 (partly, med)

**Evidence.** COLLECTIVE-DIRECTION.md:76: "What that path does not reach, future beings in no one's line among it, still needs the step." Grammatically this does not narrow. "among it" offers future beings as one member of what the path does not reach. But it is the only member named, and it is not one of 07's four as worded. 07-SIGNIFICANCE.md:453 gives four: "Each center counting from another's standpoint beyond its part as a condition. What affects one's conditions without being fed by them, counted as more than a cause. Present beings beyond every closure. Whatever no chain joins. These remain the step's." CD hides the other three, notably present beings beyond every closure. The same CD sentence bounds the reach to "everything downstream of what one conditions", so most of the complement can be inferred, but the standpoint item cannot. Blame: 50655604a (the collective page's text-review revision, 1 Nov).

**The home says.** 07-SIGNIFICANCE.md:453: "*What the path does not reach.* Each center counting from another's standpoint beyond its part as a condition. What affects one's conditions without being fed by them, counted as more than a cause. Present beings beyond every closure. Whatever no chain joins. These remain the step's."

**Fix.** In COLLECTIVE-DIRECTION.md:76, replace "What that path does not reach, future beings in no one's line among it, still needs the step." with "What that path does not reach still needs the step: each center counting from another's standpoint beyond its part as a condition; what affects one's conditions without being fed by them, counted as more than a cause; present beings beyond every closure; and whatever no chain joins, future beings in no one's line among it."

**Owner, as read.** AJ board row (AJ5's collective page; the row lists the page's retitling and revision). Recent committers to the page are US (dda2ecfbe), T1FP2 (cf56b2bb7) and T1FP (3d2585707), none of which touched l.76.

### E10 (holds, med)

**Evidence.** COLLECTIVE-DIRECTION.md:125, under "What this page does not show": "The noisy and long-run case of the capture loop, and how pools form, last and resist capture (`[05](chapters/05-COLLECTIVES.md#open)`)." The same page at l.55 says "Drawn one member at a time, the critical mass's locks are left by drift ... (`[02 §9](chapters/02-MAP.md#r-drawn-shaping-drawn-one-at-a-time)`)". 02-MAP.md:420 proves that case ("Noise leaves either lock ... `DrawnReplacement.lost_ge`, `DrawnReplacement.fixed_ge`") and states it as cited only that "under rare mutation the long-run state is the one with the larger fixation weight (Fudenberg and Imhof 2006) is cited, not proved". The drawn model reads the rule "at every step at the current count (no reading schedule, no rule in force lagging the share)", and no Lean module joins DrawnReplacement with ReadInTime (their imports: Drift, DrawnShaping, and DrawnShaping only). Also, 05's Open (05:423-433) no longer lists the capture loop's noisy case. 02's Open (02-MAP.md:476) does: "drift in sampled generations and for counts that accumulate, the rare-mutation limit and the time to leave a lock". l.125 comes from AJ5 (aa098f254, 29 Oct). l.55 was added by AJ8 (1dba53bf8, 3 Nov), which left l.125 as it was.

**The home says.** 02-MAP.md:420: "Noise leaves either lock ... So, drawn, neither lock holds for good ... that under rare mutation the long-run state is the one with the larger fixation weight (Fudenberg and Imhof 2006) is cited, not proved". 02-MAP.md:476 (Open): "drift in sampled generations and for counts that accumulate, the rare-mutation limit and the time to leave a lock".

**Fix.** Replace COLLECTIVE-DIRECTION.md:125 with: "- The capture loop under noise beyond its one proved case (drawn one member at a time, the rule read at every step at the current count, with no reading schedule: `[02 §9](chapters/02-MAP.md#r-drawn-shaping-drawn-one-at-a-time)`): drift in sampled generations and for counts that accumulate, the rare-mutation limit and the time to leave a lock (`[02, Open](chapters/02-MAP.md#open)`), the long-run state under rare mutation being cited, not proved; a loss read in time under drift; and how pools form, last and resist capture (`[05](chapters/05-COLLECTIVES.md#open)`)."

**Owner, as read.** AJ board row (AJ5 wrote l.125; AJ8, landed, added l.55).

### E14 (holds, med)

**Evidence.** 02-MAP.md:434 (T7's home) ends: "*Evidence*: none frozen; a test needs a coding of reform events fixed before the cases are read." It is followed at once, at 02:436, by "*Frozen test* (frozen 25 October 2026, run 25 and 26 October): LA2 ... frozen at `36c8b79cb`". The intended sense appears only at the end of l.436: "It is not the field test of reform events above, which stays open." 02's Open (02-MAP.md:478) reads "a frozen test of T7", which repeats the ambiguity. The "Evidence: none frozen" text dates from RA (0d7a397a5, 23 Oct), before LA2. The T7 paragraph was last edited by AJ8 (56402499e).

**The home says.** 02-MAP.md:436: "It is not the field test of reform events above, which stays open." 02:434: "a test needs a coding of reform events fixed before the cases are read".

**Fix.** In 02-MAP.md:434, replace "*Evidence*: none frozen; a test needs a coding of reform events fixed before the cases are read." with "*Evidence*: no frozen field test of reform events, which needs a coding of reform events fixed before the cases are read; one frozen test in one trained system, LA2, below." In 02-MAP.md:478, replace "a frozen test of T7" with "a frozen field test of T7's reform events".

**Owner, as read.** AJ board row (AJ3 is LA2, for T7). The most recent committer to T7's paragraph is AJ8 (56402499e, landed).

### E34 (holds, low)

**Evidence.** 07-SIGNIFICANCE.md:665: "Listed in groups whose shapers give the group's shared part, the condition is Hamilton's rule with what comes back alone added: over the rationals `c < s + m q ρ`, with `ρ` the assortment". `m` is never defined, and no size is stated. The home, 02-MAP.md:414, begins "List the members in groups of `m`" and says the form holds there. At unequal sizes the verdict instead goes through a covariance, and the spreads do not decide it (`RuleShaping.grouped_rises_iff_sized`, `RuleShaping.Sized.either_verdict`). US (dda2ecfbe) fixed three other restatements of this law (CD, the meta-attractor note, 02's second order) but not this one. It is also not on the board's batched precision pass (board l.81 and l.84 batch only the alignment front's groups sentence and A-14). Blame: AJ8 (1dba53bf8).

**The home says.** 02-MAP.md:414: "List the members in groups of `m` ... read over the rationals where shaping varies, with the assortment `ρ` the share of the spread among groups, exactly where `c < s + m q ρ` ... With unequal sizes that is not a function of the whole's spread and the size-weighted spread of the group means ..."

**Fix.** In 07-SIGNIFICANCE.md:665, replace "Listed in groups whose shapers give the group's shared part, the condition is Hamilton's rule with what comes back alone added: over the rationals `c < s + m q ρ`, with `ρ` the assortment," with "Listed in groups of `m` whose shapers give the group's shared part, the condition is Hamilton's rule with what comes back alone added: read over the rationals where shaping varies, with the assortment `ρ` the share of the spread among groups, exactly where `c < s + m q ρ`; in groups of any sizes it goes through the covariance, member by member, of a member's group's shapers with its group's share of them, which the spreads do not decide,". Keep the rest of the sentence as it is.

**Owner, as read.** AJ board row (07 §6 is AJ2's, D68). The most recent committer is AJ8 (1dba53bf8, landed). US's restatement fixes (dda2ecfbe) left this line unchanged.

## RA

### E3 (holds, belief; sceptic: stands)

**Evidence.** Chapter paths:
- DEV/ro-relational-sources/verify_ro.py:38 `CHAPTER = ROOT / 'theories/becoming/chapters/CHINESE-SOURCES-AND-BECOMING.md'`. When that file is missing, l.287 and l.299 add `failures.append(f'no chapter at {args.chapter}')`.
- DEV/zhonghua/verify_zh.py:28-30 point at chapters/THE-THEORY-OF-BECOMING-ZHONGHUA.md, CIVILIZATION-THOUGHT-AND-BECOMING.md and WENLI-AND-BECOMING.md. At l.166-168 a missing chapter is skipped (`if not ch.exists(): continue`), so check 5 does not run and says nothing.
- All four chapters are in theories/becoming/history/. RA's retirement move put them there (0d7a397a5, 23 Oct). The last verify_zh pass recorded before that move is WL's 2cceb9cfc (22 Oct).
- DF1 recorded the RO break without fixing it. _process/research/2026-10-05-repository-reconciliation/architecture/df/reports/edit-nonrec.json:138 says: "Default chapter path: FAIL no chapter at …". With --chapter pointed at history/, "It still reports FAIL for the 文字 and 佛教 tables against the frozen file".

Test wiring:
- Makefile:19-20 `research-test:` runs only `unittest discover -s tools/research/tests`.
- No file under tools/, and no Makefile target, references verify_ro or verify_zh. Only past landing scripts do.

The present-tense claims:
- 06-CLASSICAL-TEXTS.md:371 says: "检查脚本核对每一片段逐字见于所存文本，所引之声明皆在纯核回执之审计清单中，所引之记录皆存在。"
- Record civilization-thought-on-the-spine.json:53 says "verify_zh.py passes: … 1495 declarations in the current receipt, 196 records, … and both chapters' quotations, declarations, links, 对照 kinds and tables" (zh at l.54).
- chinese-sources-on-the-spine.json:53 says the same of RO: "verify_ro.py passes: … 604 declarations in the current receipt, 122 records, … and the chapter's tables".
- By E1 and E2, these checks would now fail: RO on 10 records and 2 declarations, ZH on 27 records and 7 declarations. The RO chapter check has failed since 23 October in any case.
- verify_zh.py:220 also rewrites a tracked file, work/verify-failures.txt, on every run.

**The home says.** verify_ro.py docstring: "4. every declaration a passage names is in the audited declaration list of a core receipt … 5. every record a passage names exists … 6. the chapter's passage tables, between their markers, are the tables printed by --table"

**Fix.** The structure is right: one landing with E1/E2's data, retarget both verifiers to 06, make a missing chapter a failure, join research-test, then re-scope the records. Three corrections. (a) Step 5's numbers ("1,603 declarations", "234 records") come from no run. Take them from the passing run's printed summary on the merged tree, and say so in the history note. (b) The interim sentence says "故此检查于 11 月 4 日不通过", but no one ran the check on 4 November. Under AGENTS ("say exactly what was done"), state the drift itself instead: "检查脚本核对每一片段逐字见于所存文本、所引之声明在纯核回执之审计清单中、所引之记录存在；其所引之一声明（`Pool.difference_belongs_to_the_joint`，今名 `Pool.difference_only_together`）与一记录（whole-first-and-bounded-centers，今为 whole-and-regions-and-bounded-centers）已于 11 月更名而未写入此对应，对应之章自 2026 年 10 月 23 日移入 history/ 后，其表亦未再核。" Write "不通过" only after an actual run shows it. (c) Add "（随 research-test 运行）" only in the same landing that wires the test. Keep "and the chapter's tables" in the records as dated ("of 23 October 2026"), not deleted, because the validation_scope is a dated record of a run. Do not regenerate the history chapter's tables. 06 is hand-written, not generated, so editing it directly is fine.

**Owner, as read.** RA for the path break: its retirement move 0d7a397a5 caused it, its row is still open and says "the tools and front pages repointed", and DF1 noted the failure without fixing it. The text in 06 §六 and §七 and both records is held by no one (the RO and ZH rows are closed). AA's plan Phase 3 already plans "mend the verifiers", and GT holds the gate the verifiers would join.

**Sceptic.** I tried to refute it and it survives. (1) verify_ro.py:38 points CHAPTER at theories/becoming/chapters/CHINESE-SOURCES-AND-BECOMING.md. That file is absent; it is at theories/becoming/history/ since RA's 0d7a397a5. As a result, l.299 `failures.append(f'no chapter at {args.chapter}')`. verify_zh.py:28-30 point at the three moved chapters, and l.166-168 `if not ch.exists(): continue` skips check 5 without a word. (2) Makefile:19-20 research-test runs only `unittest discover -s tools/research/tests`. `git grep verify_ro|verify_zh -- tools Makefile` finds nothing. (3) The data has drifted. RO passages.json cites Becoming.Pool.difference_belongs_to_the_joint 4 times, and it is not in the newest core receipt, 20261103T211917.845905Z/verification.json (0 hits; difference_only_together has 2). RO also cites record whole-first-and-bounded-centers, which has only a generated rename stub .md and no .json. verify_ro.py l.283 tests `RECORDS / f'{r}.json'`, and verify_zh l.85 globs *.json, so both checks would fail. A small read-only Python count found exactly one distinct missing declaration and one distinct missing record in RO; the verifier's 10/2 are counts of citations. (4) 06-CLASSICAL-TEXTS.md:371 says in the present tense "检查脚本核对每一片段逐字见于所存文本，所引之声明皆在纯核回执之审计清单中，所引之记录皆存在". Nothing nearby qualifies it. The nearby link to ../history/CHINESE-SOURCES-AND-BECOMING.md shows the chapter is historical, but it does not say the check is stale. "所对之声明与记录照其现状" does not date the check either. The records' validation_scope ("verify_zh.py passes … 1495 declarations in the current receipt … both chapters' … tables"; RO: "and the chapter's tables") can be defended as a record of what was validated when it ran. But "current receipt" read today is wrong, and the chapter-table part has been unrunnable since 23 Oct. Severity: belief, but narrow. A reader would believe the map is machine-checked against today's Lean and records. The underlying content is unchanged, because the two items were renamed, not removed. Owner: RA (row l.48 still open; its move caused the path break). AA's PLAN l.31 already schedules mending the verifiers and joining them to research-test. GT holds the gate.

### E11 (partly, low)

**Evidence.** 04-LIFE.md:276 reads "**Theorem** (one declared process; witness; pre-spine module, empty axiom report)" and says nothing about the record's standing. The record recurrence-without-selector-revision.json has status `reviewed-scoped`, `proof_bindings: []`, and validation_scope says "no passing receipt binds the current bytes and the record is reviewed, not receipt-bound, until a checker run does". It is the only theorem record with that status. No file under the lean folder holds the current hash 3ca0b210… (grep). That part of the flag holds. The 'belief' severity does not. `diff verification-runs/1791274297069388000/sources/BoundaryModels.lean BoundaryModels.lean` shows one difference, line 1: `import Std` against `import Std -- 脊柱上 / On the spine (I4, 2026-10-16): …`. That is a comment, so the theorems proved are the ones the 6 October run checked with empty axiom reports. What a reader is told is shown does not change; only the receipt binding is missing.

**The home says.** Record validation_scope: "On 16 October a comment was added to the file's first line, so no passing receipt binds the current bytes and the record is reviewed, not receipt-bound, until a checker run does." next_delta: "A checker run binding the current bytes".

**Fix.** Preferred: do the record's own next_delta, a checker run on BoundaryModels that binds the current bytes, then status recorded-checked with a proof binding; 04 then needs no change. Until then, replace 04:276's label with: "**Theorem** (one declared process; witness; pre-spine module; empty axiom report at the bytes checked on 6 October 2026, changed since only by a comment on the first line, so the record is reviewed, not receipt-bound, until a checker run does)."

**Owner, as read.** RA row (DF under RA): DF2 added the record and 04's sentence (17ee7fbf4, 27 Oct).

### E37 (partly, low)

**Evidence.** correction-is-not-calibration: holds. 03-KNOWING.md:146 opens "**Assessment** (argument without Lean), *correction is not calibration*." and only then "**Theorem** (periphery …)". The record is kind theorem, recorded-checked, and its statement is the theorem part. It is the only theorem record led as Assessment, and 08:67 defines Assessment as "a scoped evaluation with evidence and no Lean". wisdom-root-without-axiom: the flag is wrong. 03:474 "**Reading** [AI reading, D26]. The checked laws … match aspects of wisdom" fits 08:66's Reading, "an interpretation of checked content". 08 §2 has no label for kind argument; the other four argument records are led as Conditional.

**The home says.** 08:66 Reading: "an interpretation of checked content"; 08:67 Assessment: "a scoped evaluation with evidence and no Lean".

**Fix.** Reorder 03:146 so it opens with the record's kind: "**Theorem** (periphery: pre-spine updater constructions; `propext`, `Quot.sound`, `Classical.choice`, as `[the receipt](…)` reports), *correction is not calibration*. Zero/one reference readings … `CalibrationRenewal.late_change_still_fails`. **Assessment** (argument without Lean). Where a faithful sensor and one reversing success and failure report alike after every action, … so revising beliefs does not certify that signals correspond to their objects. `[record](…)` (`[study](…)`)." The owner may relabel the argument "**Reading** [AI reading, new]" by 08 §2. No change for wisdom-root-without-axiom.

**Owner, as read.** RA row (DF2 last touched 03:146, 06e249401).

### E40 (holds, low)

**Evidence.** regions.json has 528 record entries for 533 records. Unassigned: a-cascade-at-the-histories-reached (home 05), coupled-drawers-keep-a-need-only-where-the-coupling-reaches-it (05), drawn-shaping-drawn-one-at-a-time (02), shaping-selected-among-groups (02), unequal-groups-not-decided-by-the-spread-among-groups (04). Also unassigned: modules Becoming.CoupledDrawers, Becoming.ReachedCascade and Becoming.GrammarPath. registry.py has no regions check. tools/research/tests/test_theory_graph.py:24-27 test_regions_are_known checks only that the regions present are known.

**The home says.** regions.json about: "Regions follow the chapter that states each result (its anchor)".

**Fix.** Add records: a-cascade-at-the-histories-reached {region collective, base general}; coupled-drawers-keep-a-need-only-where-the-coupling-reaches-it {collective, general, as drawers-in-turn; RA to confirm against Optimum's old-base}; drawn-shaping-drawn-one-at-a-time {map, general}; shaping-selected-among-groups {map, general}; unequal-groups-not-decided-by-the-spread-among-groups {life, general}. Modules: Becoming.ReachedCascade {collective, general}, Becoming.CoupledDrawers {collective}, Becoming.GrammarPath {root, grammar}. Add a test that every record id and core module is assigned and each record's region matches its home anchor's chapter.

**Owner, as read.** RA row (owns regions.json and theory_graph.py). Records from TRL 4d65a680e, CDR c9ca32f31, AJ8 5170760b7, US abca34060.

## OU

### E20 (holds, med)

**Evidence.** OU row, board l.47 (state cell): "left after the gate (WHAT-REMAINS): plan §十三 item 6 ..., item 8 ..., item 9's institution (OG having given the organism its model, §497) and item 11 (the three minimalities' report, MDL and Pareto), each to be claimed as an item of its own on Ren's word to go past the gate".
WHAT-REMAINS.md:459, written at 368a8bde7, says: "the test systems of plan §六, each with its model (9) ... OG2 landed (study §501): one kind of institution, a rule of entry rebuilt from the members it limits; other kinds and purposes stay open".
AGENTS.md:42 says: "Still his: pushing to the public remote, the licence, who is sent what, and money or machine time for runs ... only he changes this list." Going past the gate is not on it, and it was not on the list before AGENTS' review either (AGENTS-before-review.md:29). Board l.36 orders post-gate work as "Behind these in the queue, unless it changes what a reader is told or what could fail".
OG2's own history row (history l.787) was claimed "on Ren's yes to go past the gate", but no source under sources/ records such a word (grep "past the gate"). The phrase traces only to the kit close_rows.py:51. OU's row was last edited at bfa1f8cdf (2 Nov 02:58), before AGENTS' rewrite landed at 574a1cb83 (3 Nov).

**The home says.** WHAT-REMAINS.md:459: "the test systems of plan §六, each with its model (9) ... OG2 landed (study §501): one kind of institution, a rule of entry rebuilt from the members it limits; other kinds and purposes stay open"

**Fix.** In OU's state cell, replace "item 9's institution (OG having given the organism its model, §497) and item 11 (the three minimalities' report, MDL and Pareto), each to be claimed as an item of its own on Ren's word to go past the gate" with "item 9 (the test systems of plan §六, each with its model: OG gave the organism one, §497, and OG2 one kind of institution, §501; other kinds and purposes stay open) and item 11 (the three minimalities' report, MDL and Pareto), each to be claimed as an item of its own, behind the way now's items unless it changes what a reader is told or what could fail". Leave close_rows.py unchanged: it is the kit's record.

**Owner, as read.** The OU row's owner, the Claude Code desktop session "Unification and coherence progress" (holder since 28 October).

### E22 (holds, med)

**Evidence.** 08-METHOD.md:431 has "| Closure | … | 41 |" and 08:432 has "| Balance | … | 55 |". 08:437 says "86 rest on at least one (`[report](…COMPLETION.md#master-laws)`); the report lists the other 40 by row" and later "all 41 on closure, all 14 on finite runs, 16 of 54 on balance … and 4 on no anchor: three through the laws of steps counted, and, since U4c, `Listed.coming_of_ceasing` through the root's census of a run". COMPLETION.md is generated at core receipt 20261103T211917.845905Z, the receipt 08:162 names. It has l.104 "87 of 126", l.108 Closure 42, l.109 Balance 54 and l.114 "Resting on no shared law (39)". The history: OU7 (e5951932b) moved `Listed.coming_of_ceasing` off balance (55→54, no-law 39→40), and U4d (631762ba2) put it on closure (41→42, 86→87, no-law 40→39). U4d's message says "08 §7's figures unchanged". 08 contradicts itself: 55 in the table, "16 of 54 on balance" in the prose.

**The home says.** COMPLETION.md l.104 "Counted per row: 87 of 126 central declarations rest on at least one shared law"; l.108 Closure 42; l.109 Balance 54; l.114 "Resting on no shared law (39), by row".

**Fix.** 08:431: 41 → 42. 08:432: 55 → 54. In 08:437 replace "86 rest on at least one (…); the report lists the other 40 by row" with "87 rest on at least one (…); the report lists the other 39 by row". Replace "all 41 on closure, all 14 on finite runs, 16 of 54 on balance, 1 of 8 on widening, 1 of 2 on lumping, and 4 on no anchor: three through the laws of steps counted, and, since U4c, `Listed.coming_of_ceasing` through the root's census of a run" with "all 42 on closure, among them, since U4d, `Listed.coming_of_ceasing` through the root's census of a run; all 14 on finite runs, 16 of 54 on balance, 1 of 8 on widening, 1 of 2 on lumping, and 3 on no anchor, through the laws of steps counted". The 42/3 split in the measure's own sentence follows from COMPLETION's data; confirm it with measure_grammar.py, which restores constants from the checker cache and compiles nothing. To stop this recurring, the column could cite COMPLETION's table instead of copying it.

**Owner, as read.** OU row (Unification and coherence progress session: the shared laws on the grammar and OU3b's measure). The counts were last moved by OU7 e5951932b and U4d 631762ba2; U4 is closed. No row holds 08 §7 by name.

### E38 (holds, low)

**Evidence.** theories/becoming/chapters/05-COLLECTIVES.md:392-393: `<a id="not-shown"></a>` / "## 12. One kind of institution". "## What this chapter does not show" at 05:415 has no anchor. Blame shows that OG2's commit ef87160b9 (2 Nov) put §12 between the anchor (from 0d7a397a5) and its heading. Chapters 01, 03, 04, 06, 07 and 08 use `does-not-show`; 02 uses `not-shown`. No .md, .py or .json in the repository links to 05#not-shown. The fix is on branch `ch05-not-shown-anchor`, commit 4aa7c1cd1 (3 Nov 10:44, "05: the not-shown anchor back above What this chapter does not show"), checked out in worktree og2-institution. It is NOT on main (merge-base --is-ancestor fails), and its parent b8e2cf264 is behind main.

**The home says.** 05-COLLECTIVES.md:415 "## What this chapter does not show"

**Fix.** Move `<a id="not-shown"></a>` from 05:392 to the line directly above "## What this chapter does not show" (now 05:415). That is exactly what 4aa7c1cd1 does. Its context lines ("## 12. One kind of institution", "**Reading** [AI reading, new]. The member taught by members ...") are unchanged on main, so cherry-pick or merge that commit.

**Owner, as read.** OU's owner, "Unification and coherence progress". It is OG2's owner (history row: "OU's owner"), and its og2-institution worktree holds the unlanded branch.

## CD

### E33 (holds, low)

**Evidence.** grep finds no `ReadsNoOrder` anywhere in 07-SIGNIFICANCE.md. The law's home is 08-METHOD.md:448 (#r-premises-met-and-failed). CD:72 and AGENTS.md:30 also cite it. 07 does cite the parallel for the condition, `ReadsOnlyDynamics.not_entails` (07:21). C's role is stated at 07:233 without the not-entailed law: "A ranking of courses needs C or a premise in its place: C gives order, in general alone, and an order rising with one's own continuation ranks one case with no C". Blame: PF3 (bc754b4da).

**The home says.** 08-METHOD.md:448: "If such a statement entails C (`Comparison`) at a datum on a frame with an extension, it fails at that datum for every order (`ReadsNoOrder.not_entails`). This is immediate, since 'better' is free: it shows that a frame fixes no order."

**Fix.** In 07-SIGNIFICANCE.md:233, after "...ranks one case with no C (`[§4.4](#r-what-self-concern-alone-ranks)`).", add 08's words: "Nor can C come from a statement reading no order: one that entails C (`Comparison`) at a datum on a frame with an extension fails at that datum for every order (`ReadsNoOrder.not_entails`, `[08](08-METHOD.md#r-premises-met-and-failed)`); this is immediate, since 'better' is free: a frame fixes no order."

**Owner, as read.** CD board row ("CD: C as a direction", session "Theory status and claims"; its next edition is C's statement in pairwise form). The line's last committer is PF3 (bc754b4da, landed).

## the coordinator

### E16 (holds, med)

**Evidence.** _process/BECOMING-WORKBOARD.md:32 (the way now, item 1) reads: "Left: the sciences dossier's re-sync, by \"Names and identity discussion\"; ...; and, if ready before the freeze, OG2, since the fronts say an institution has no model yet and OG2 gives one." OG2 landed at 368a8bde7 (3 Nov 09:53 +0700), before the freeze 13ea8ddb6 (16:15), and both are on main. The sciences re-sync named in the same clause also landed, at 45b2538d7 (3 Nov 05:07). The fronts now read "An organism and one kind of institution each have one minimal model [AI reading]" (ONE-PAGE.md:38; THE-THEORY-OF-BECOMING.md:195). CD's landing 4db31d24e (3 Nov 11:54) last touched l.32, after both had landed.

**The home says.** 05-COLLECTIVES.md:395 (OG2's home): "This section gives a minimal model of one kind, an entry rule on a shared stock, passed through members who also keep it"

**Fix.** In board l.32, replace everything from "Left: the sciences dossier's re-sync" to "and OG2 gives one." with: "Done since: the sciences dossier's re-sync (`45b2538d7`); the two items carried from 2 November, a name given as the ground of a step by GC3 (`6606c273a`) and the stale counts by OU's closures (`bfa1f8cdf`); and OG2, before the freeze (`368a8bde7`, §501), so the fronts now say one kind of institution has one minimal model [AI reading]. Left: the errata the readers of 4 November found, each verified and sent to its page's owner (AA's row, Phase 0)." Keep the sentence "An error found by any reader goes to the owner of the page it is on." Change the heading date "(3 November 2026)" to the date of the edit.

**Owner, as read.** The coordinator, "Merge coordination and main branch maintenance". Board l.30 says it "keeps 'The way now' below current". No row holds the bullet.

### E17 (holds, med)

**Evidence.** _process/BECOMING-WORKBOARD.md:28 reads "the latest core receipt is HE2's `20261031T054654.692180Z` (31 October 2026)". On main, lean/becoming/becoming-verification.json has "utc": "20261103T211917.845905Z", committed at e0f3fa2c3 ("TRL: the core receipt 20261103T211917.845905Z", 4 Nov 04:21 +0700). That is also the newest folder in becoming-checks/. The same bullet says "the landing queue below names each landing since 17 October with its core receipt", which is false too: that section's list stops at MA2, 25 October (`20261025T045617.350224Z`). The line was last edited at HE2's 467f075ec (31 Oct).

**The home says.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-verification.json: "utc": "20261103T211917.845905Z"

**Fix.** Replace board l.28 with: "- **Main and receipts:** each landing's core receipt is named in its landed clause on the Queue line and in its row in the history file (the Landing queue section below names those to 25 October); the latest core receipt is TRL's `20261103T211917.845905Z` (4 November 2026), the one `becoming-verification.json` names. This page was rewritten on 17 October 2026 at `1d18d005c`."

**Owner, as read.** The coordinator. No row holds the Now bullets. The line was last edited by HE2's landing (467f075ec).

### E18 (holds, med)

**Evidence.** _process/BECOMING-WORKBOARD.md:63-66: `<a id="落地队列--landing-queue"></a>` / "## Landing queue" / "In the queue (19 October 2026; ...MA2, readers drawn from the selected, landed 25 October 2026 ...): PF is at the head of the queue. Hold commits that touch the package, the chapter or records until the item at the head of the queue is on main, and add your item below them." PF landed at d3e6688fe (25 Oct), which is on main. AGENTS.md:47 links "`[Queue line](_process/BECOMING-WORKBOARD.md#落地队列--landing-queue)`" to this stale text. The live line is l.39, "- **Queue:** RFZ's fourth freeze landed ...", under ## Now. l.66 was last edited at 7bdacfc28 (25 Oct).

**The home says.** Board rule 5, l.19: "A lander claims the head with a clause on the Queue line, behind every earlier claim"

**Fix.** Insert a paragraph directly after the heading at l.64: "The live Queue line is the **Queue** bullet under `[Now](#now)`; a lander claims the head there, behind every earlier claim (rule 5). What follows is the queue's record from 15 to 25 October, kept as history." In l.66, replace "PF is at the head of the queue. Hold commits that touch the package, the chapter or records until the item at the head of the queue is on main, and add your item below them." with "PF landed after them (`d3e6688fe`, 25 October)." Keep the anchor where it is. AGENTS.md:47, RESEARCH-DIRECTIVES and tools/research/tests/test_links.py:13 use the id. The landing kits (claim_head.py, board_part.py) match lines that start with "- **Queue:** ", so an inline anchor on l.39 would break them.

**Owner, as read.** The coordinator. None held.

### E19 (partly, low)

**Evidence.** Three parts hold and one is fixed.
(1) Done rows are still open. TR45 at l.55 reads "...TR2's Stage B frozen `24a330677` (FREEZE-7, eight reading rounds; no download, no model run); done". Three more rows now also read "done": RFZ at l.54 ("...TR9 `18ed73b7e` (FREEZE-8); done"), TR71 at l.56 and TR1 at l.57. All four are still in Open claims, against rule 4 at l.17: "Landed rows move to the history file in the landing commit; the open-claims table holds only open items." None of the four has a row in the history file.
(2) TR71's title at l.56 is still "**TR71: TR7, then TR1, frozen on freeze 1's harness**" and still has "TR7 lands before TR1 opens.", even though its state cell says "TR1 passed to its own row".
(3) RF's row at l.50 was last edited at 669fc33e7 (31 Oct 19:01). RFZ's own row calls RF's owner "inactive since 31 October", and rule 4 says "A claim whose owner has been inactive for three days lapses".
(4) Fixed: RFZ's state cell read only "claimed 4 November 2026 on `efe3ba2cf`" up to acb3dc87a. Since 1e9bc6b85 it lists FREEZE-1, -3, -6 and -8 and ends "done".

**The home says.** Board rule 4, l.17: "the open-claims table holds only open items. A claim whose owner has been inactive for three days lapses: any session may move it to the history file, marked lapsed"

**Fix.** Move the RFZ, TR45, TR71 and TR1 rows to the history file, each titled done and keeping its freeze commits. In the moved TR71 row, use the title "TR71: TR7 frozen on freeze 1's harness (TR1 passed to its own row)" and drop "TR7 lands before TR1 opens." Move RF's row there marked "lapsed (owner inactive since 31 October; RF's laws landed and its tests frozen by RFZ, TR45, TR71 and TR1)". It stays open to reclaim for its periphery debts ("a noisy answer and continuous beliefs").

**Owner, as read.** The coordinator. Board l.30 says it "moves finished or lapsed rows to history". If TR71's row stays open, its title belongs to its owner, "Names and identity discussion" (rule 4).

## GT (this session)

### E30 (holds, med)

**Evidence.** registry.py (HEAD) l.137-158 scoped_drift: `anchors = cited_headings(record, path)`, `located = bool(anchors) or links_record(...)`. A change bears only if `anchors & anchors_from_text(heading)`, where heading is the `##` line (sections(), l.93-101). anchors_from_text (reading_catalogue.py:147) reads only that line, so an explicit `<a id>` on its own line or a `###` anchor never matches. It still makes `located` true, so the 'any rewritten line counts' fallback is switched off: such a citation protects less than none. Recount: 56 cited `##` anchors and 39 others, in 9 records (wisdom-root 16, universal-practical-warrant 7, theory-of-becoming-foundation 6, …), none with its enclosing `##` also cited. tools/research/tests/test_scoped_drift.py tests only heading-slug citations (l.74-77). RESULT-WORKFLOW.md:61 says a line counts if it "lies in a `##` section the record cites by anchor" and "A record that wants this precision for a long source cites its sections by anchor".

**The home says.** RESULT-WORKFLOW.md:61 "lies in a `##` section the record cites by anchor".

**Fix.** In scoped_drift, before the loop, widen `anchors` by the anchors of each `##` section holding a cited anchor. An `<a id>` line whose next non-blank line is a `##` heading belongs to that heading (e.g. ZERO-AXIOM-…md l.776 above `## 21.` at l.779); any other `<a id>` or deeper heading belongs to the enclosing `##`. Add tests for an explicit-anchor citation and a `###` citation. Dry-run on all records first, because the 9 records may start to report drift and need their owners' rebinding. RESULT-WORKFLOW.md:61 then says: "lies in a `##` section the record cites by anchor (the heading's own, an explicit anchor just above it, or any anchor within it such as a `###` heading)".

**Owner, as read.** GT row: its session holds uncommitted edits to registry.py here, and GT part (1) is a persistent cache of the drift comparisons. scoped_drift dates from f6816a74e (15 Oct); the reader tags it RA.

## none held: AA takes it

### E1 (holds, med)

**Evidence.** Read in the worktree at 3bf962941. Main is now at d7aab6cd1, which touches only the board, so nothing here is fixed. DEV below = _process/research/2026-10-05-generative-foundation-review/root-foundation/development.
- DEV/ro-relational-sources/passages.json cites "whole-first-and-bounded-centers" 10 times, all in `records`: lines 4850, 5552, 5955, 6138, 6317, 6345, 6678, 6727, 8628, 8984. The passages are ru-zhongyong-qinqin-zhi-sha, ru-mengzi-qinqin-renmin-aiwu, ru-liyun-da-tong-xiao-kang, ru-chenghao-yi-ti, ru-zhuxi-wu-xin-zhi-xin, ru-zhuxi-li-yi-fen-shu, ru-huangzongxi-tianxia-wei-zhu, ru-dongzhongshu-tian-yi, zhuangzi-qiushui-yi-dao-guan-zhi and mozi-jianai-zhong-shi-ren-ruo-ji.
- DEV/zhonghua/passages.json cites it 27 times, all in entries' `records`, from line 29714 to line 56737: C09 2, C13 7, C14 17, C17 1.
- Commit 603ce1722 (3 Nov, CD, research.py rename-id) renamed the record. Its receipt, _process/architecture/renames/cd-ranking-names.json, reads "old": "whole-first-and-bounded-centers", "new": "whole-and-regions-and-bounded-centers".
- theories/becoming/results/records/ holds whole-and-regions-and-bounded-centers.json. Under the old id there is only the generated redirect whole-first-and-bounded-centers.md ("this page keeps old links resolving"), and no .json.
- I re-ran both verifiers' record tests on the data in a read-only script: verify_ro.py:281-285 `(RECORDS / f'{r}.json').exists()` and verify_zh.py:85 `records = {p.stem for p in RECORDS.glob('*.json')}`. Exactly these 10 and 27 fail, and no other record does.
- y1-changes/passages.json, zhonghua/clusters.json, coverage.json and work/names-decisions.tsv have 0 occurrences.

**The home says.** cd-ranking-names.json: "\"the whole first\" (优先) states a priority the record does not show; it shows that under the continuation condition what retains in the whole retains in every region, not conversely"

**Fix.** Replace "whole-first-and-bounded-centers" with "whole-and-regions-and-bounded-centers" in `records` fields only.
- RO: do not edit passages.json by hand, because verify_ro check 7 says passages.json changes only through build_passages.py's FIXES. Rebuild it with DEV/ro-relational-sources/build_passages.py where the archives are present. Its renamed_records() (l.668-673) already reads every receipt in _process/architecture/renames/, cd-ranking-names.json included. So the 10 ids follow on the rebuild, with RECORDS_RENAMED_WHY added to each `corrected`. Then run build_passages.py --check.
- ZH: zhonghua/passages.json has no build guard. Rename the 27 `records` values with a dated script, noting each entry "record ids follow the renamed records (cd-ranking-names, 3 November 2026), claims unchanged", as RO's note reads.
- The distinct record counts stay 122 (RO) and 234 (ZH), since neither file cites the new id yet.
- So it does not happen again: either make tools/research/rename_ids.py (research.py rename-id) also rewrite these two kit data files, or join the verifiers to the gate (see E3).

**Owner, as read.** none held. The RO and ZH kit rows are closed. The rename is CD's (603ce1722; the CD row is open, owner "Theory status and claims"), and its rename-id did not reach kit data. The last data commits are 64c11b8ed (DF1 under RA) for RO and 2cceb9cfc (WL) for ZH. AA's Phase 0 takes it as unheld.

### E2 (holds, med)

**Evidence.** - DEV/ro-relational-sources/passages.json has 4 occurrences (lines 3320, 3353, 4743, 4766). Two are in the `declarations` of lao-51-sheng-er-bu-you (id at l.3307) and sz-51-ji-er-wei-shi (l.4733); two are in their `reading`, e.g. "一个部分造成的差别属于共同活动（`Pool.difference_belongs_to_the_joint`）".
- DEV/zhonghua/passages.json has 18: 7 in `declarations`, 7 in `reading`, 3 in `notes` and 1 in `proposal`. The 7 declaration lists are C06/laozi-02-fu-wei-fu-ju-shi-yi-bu-qu, C06/laozi-51-sheng-er-bu-you, C13/xici-er-ren-tong-xin, C14/kongshu-wei-er-bu-zai, C17/hanfei-nanshi-shi-yu-ren, C17/hanfei-nanshi-renshe and C17/laozi-sz-ji-er-wei-shi.
- The Lean: experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Joint.lean:472 reads "theorem difference_only_together :", in `namespace Pool` (l.361). It was renamed in OU7 (e5951932b, 1 Nov) by ND's table, DEV/nd-nondual-names/part2/nd_rename.py:21: 'difference_belongs_to_the_joint': 'difference_only_together'.
- The newest core receipt, becoming-checks/20261103T211917.845905Z/verification.json, lists "Becoming.Pool.difference_only_together" and not the old name.
- I recomputed verify_ro check 4 (l.262-276) and verify_zh's decl_ok (periphery included) on the data. Exactly these 2 (RO) and 7 (ZH) declaration lists fail, and no other declaration does.
- 06-CLASSICAL-TEXTS.md:412 already reads (`Pool.difference_only_together`).

**The home says.** 06:412: "有一个其他汲取者时造成差别，有两个时不造成（`Pool.difference_only_together`）：差别可以只由共同者造成"

**Fix.** Replace Becoming.Pool.difference_belongs_to_the_joint with Becoming.Pool.difference_only_together, and the short form Pool.difference_belongs_to_the_joint with Pool.difference_only_together in prose.
- RO: build_passages.py's renamed() (l.608-613) reads only the R22 and R30 tables, and ND keeps its renames only as the NAMES dict in nd_rename.py:14-22, with no RENAME-TABLE.json. Add the pair 'Becoming.Pool.difference_belongs_to_the_joint' -> 'Becoming.Pool.difference_only_together' to renamed(), and extend RENAMED_WHY to name ND (OU7, e5951932b). Then rebuild. rename_text (l.650-656) rewrites the dotted `Pool.x` form, so the 2 declarations and the 2 readings follow.
- ZH: rename the 18 occurrences in place, with the same dated note.
- Companion change: RO sz-51-ji-er-wei-shi's reading still states the ownership that ND renamed away: '一个部分造成的差别属于共同活动'. Add a FIXES reading_sub using the home's words at 06:412, "差别可以只由共同者造成".

**Owner, as read.** none held. The RO and ZH kit rows are closed. The rename came with ND in OU7's rebuild (e5951932b; the OU row is open, owner "Unification and coherence progress"), which did not reach kit data. AA's Phase 0 takes it as unheld.

### E4 (holds, med)

**Evidence.** The claims:
- 06-CLASSICAL-TEXTS.md:440 says: "3,499 条涉及其结构，各自恰好落在一处（归入一个条目、与一条目并列、或读后不取）".
- Record civilization-thought-on-the-spine.json:13 says "3,499 bear on its structures, each placed once" (l.14: "各落一处").
- Its validation_scope at l.53 says "each flagged one placed once" (l.54: "每条所标判断恰落一处").

What the check does:
- verify_zh.py:8 states the narrower thing: "every judgment the sweep flagged for a cluster lies in exactly one place there".
- The code resets `placed = {}` for each cluster (l.112) and tests `if v['c'] == c and len(placed.get(r, [])) != 1` (l.140-141). So it checks the judgment's own cluster only.

My recount from coverage.json and passages.json:
- 3,499 judgments are flagged. Across all clusters, 3,403 are placed once and 96 are placed in more than one cluster (3,600 placements). Each is exactly once in its own cluster.
- For only 26 of the 96 are all the other placements in clusters the triage listed as secondary (`s`).
- 6 are kept in one cluster and rejected in another: WP-XCS-C01-S01-R04 (C01 entry, C08 rejected); LE-R020 and LE-R021 (C06 entry, C02 rejected); LL-R015 (C06 entry, C11 rejected); TP-H22-X4-R01 (C17 parallel, C07 rejected); RU1-LY-18-10-R02 (C11 entry, C13 rejected).
- The entry counts agree with the data: 1,300 entries, 453/647/200.

**The home says.** verify_zh.py:8: "every judgment the sweep flagged for a cluster lies in exactly one place there (an entry, a parallel or a rejection)"

**Fix.** Replace the text in the home and the record together. Use the verifier's own scope, and the counts as the data gives them.
- 06:440: "3,499 条涉及其结构，各自在所标之簇中恰好落在一处（归入一个条目、与一条目并列、或读后不取），其中 96 条另落于他簇，6 条在一簇取而在他簇不取；条目共 1,300 个，…"
- Record statement en: "3,499 bear on its structures, each placed once in the cluster it was flagged for (96 also placed in another cluster), in 1,300 checked entries (453 agreements, 647 exact scopes, 200 divergences)." zh: "3,499 条关乎其结构，各在所标之簇恰落一处（其中 96 条另落他簇），成 1,300 个已检查条目（…）".
- validation_scope en: "each flagged one placed once in its flagged cluster (placements in other clusters not checked: 96 judgments)". zh: "每条所标判断在所标之簇恰落一处（他簇之落处未查：96 条）".
- Add a history note.
- A stronger fix, owner's choice: decide the 6 keep-and-reject conflicts, and make verify_zh count placements in other clusters.

**Owner, as read.** none held. The 06 §7.1 text and the record come from the closed ZH (中华) row. The last 06 commit is 0994d6816 (the dossiers' readers' corrections); the record was last edited in 0d7a397a5 (RA). AA's Phase 0 takes it as unheld.

### E12 (partly, med)

**Evidence.** - 05-COLLECTIVES.md:174 says: "The account adds four limits their model has no place for: the drain falls only where units are shared, so not on a condition sharing none (`[T3](#t3)`'s locus and F2)". The sentence came in with ZH-proxy commit 0d7380fa1 (landed 89165c6b6).
- Where the flag is wrong: the account does prove an 'only' over one step of exchange.
  - Optimum.lean:1665-1667: "**The drain, exactly where units are shared.** Every optimum among the outcomes open to a part lowers a condition beyond below where the rest leaves it exactly where the part has some capacity there and the rest leaves something there" (`optimum_lowers_iff`).
  - Optimum.lean:1652: "No drive where no units are shared" (`optimum_untouched`).
  - Both are law 5 of the record room-read-off-the-exchange, whose home is the row at 05:206.
- Where the flag holds, part 1: the law the reading follows (05:170, any set of outcomes) gives only sufficiency: "*shared units* … give room (`Optimum.Shared.room`)". Lean `Shared.room` is a one-way implication, and room is the hypothesis. The record's does-not-show says "room is a hypothesis (derived for one step in room-read-off-the-exchange)".
- Where the flag holds, part 2: the pointer to T3 and F2 is wrong.
  - T3 (05:226) is a conjecture about trained systems: "the drain lying where what lies beyond shares units with what is rewarded". 05:241 says "The locus is unresolved (P3)", and 05:227 says "It was first worded for any condition sharing no units … So worded it fails".
  - ONE-ARGUMENT.md:90 records that the locus "lost 'and not where it shares none'" and that F2 was revised from "a condition sharing no units". F2 now reads (ONE-ARGUMENT.md:58) "a systematic drive on a choice whose values nothing rewarded and nothing the learner reads tells apart".
  - "F2" is not defined anywhere in 05.

**The home says.** room-read-off-the-exchange law 5: "Where no member may take from a condition beyond, every optimum leaves it where the rest leaves it; an optimum lowers it below that exactly where the part has some capacity there and the rest leaves something there"; 05:226: "the drain lying where what lies beyond shares units with what is rewarded"

**Fix.** Replace the first of the four limits at 05:174 with: "The account adds four limits their model has no place for: over one step of exchange, every optimum lowers a condition beyond exactly where the part has some capacity there and the rest leaves something there, and leaves it where the rest leaves it where no member may take (`[the case](#r-room-read-off-the-exchange)`; on trained systems this locus is `[T3](#t3)`'s conjecture, unresolved); a reader reaches only what couples into some reader …". The rest of the sentence stays as it is.

This drops the undefined "F2" and the sharing-none wording that T3 withdrew. It does not touch any record, since no record carries the phrase. The study's DEV/zh-proxy-problem/NOTE.md:86 already scopes the point to the exchange laws, and can stay.

**Owner, as read.** none held. The ZH proxy item landed (89165c6b6) and its row is in history. Tell LA4 (open row, which tests T3's locus) when this lands.

### E13 (holds, low)

**Evidence.** theories/becoming/chapters/05-COLLECTIVES.md:98 "| Forming the next members | a pattern outlasting its carriers lasts only through passing | `[04](04-LIFE.md#r-a-pattern-lasts-through-passing)` |". The 05 cell adds "only" and drops the premise. The home's own words, 04-LIFE.md:60, are "lasts only while carriers keep beginning, and under a premise of passing only while carriers pass it on". The theorem at 04-LIFE.md:63 has no "only" in its title ("*A pattern outlasting its carriers lasts through passing.*"). Without the premise it gives only "a double-negation form that, with activity undecided, names no carrier". The rest it gives "Under the **passing premise** (`Web.ByPassing` ...)". The Limits line at 05:102 ("regulation and passing are supplied") covers this only in part. The line has not changed since RA's landing 0d7a397a5 (23 Oct).

**The home says.** 04-LIFE.md:60: "A pattern whose carriers are brief lasts only while carriers keep beginning, and under a premise of passing only while carriers pass it on."

**Fix.** In 05-COLLECTIVES.md:98, replace the middle cell with "a pattern whose carriers are brief lasts only while carriers keep beginning, and under a premise of passing (`Web.ByPassing`) only while carriers pass it on", which is the home's sentence. 02-MAP.md:186 has the same gloss, "a pattern outlasting its carriers lasts only through passing", also from 0d7a397a5. Make the same replacement there in the same commit.

**Owner, as read.** None held. The line comes from RA's landing 0d7a397a5. RA's row (board l.48) is nominally open, but its owner is the original one-unfolding-root session, which OU's row calls inactive since 25 October, so the row has lapsed under rule 4. No row holds 05 §4. The latest committer to 05 is TRL (47669175a). Route it through AA's Phase 0 or the coordinator.

### E23 (holds, low)

**Evidence.** 08-METHOD.md:167 reads "discrete steps occur in 112, natural-number amounts in 74, supplied observation in 10, a fixed type of formations in 9, decidedness in 8 and naming in 1 (`[report, K4](…COMPLETION.md)`)". COMPLETION.md:63 reads "natural-number amounts (73); supplied observation (10); decidedness (8); a fixed type of formations (8)". DU (756eb1e84, 1 Nov) changed 74→73 and 9→8. 08:167 was last touched at RA (0d7a397a5).

**The home says.** COMPLETION.md:63 "discrete steps (112); natural-number amounts (73); supplied observation (10); decidedness (8); a fixed type of formations (8); naming (1)".

**Fix.** 08:167: "In the central statements of the completion coverage, discrete steps occur in 112, natural-number amounts in 73, supplied observation in 10, decidedness in 8, a fixed type of formations in 8 and naming in 1 (`[report, K4](../results/completion/COMPLETION.md)`); …". A more lasting form drops the counts: "the `[report, K4](…)` counts, at each core run, the central statements each choice occurs in".

**Owner, as read.** None held. RA wrote the sentence (0d7a397a5); DU moved the counts (756eb1e84, landed).

### E24 (holds, low)

**Evidence.** 08-METHOD.md:660 reads "Twenty numbered reviews and three others checked existing results (`[ledger](…REVIEWS.md)`)". It was written at RA on 23 Oct. REVIEWS.md:17 lists "BECOMING-TWENTY-FIRST-REVIEW.md" (29 Oct, "This is an AI review"), and 08:559 cites it. 08:745 reads "numbered D1–D66 in the [decision register]". The register has D67 and D68 (DELEGATED-CHOICES.md:106-107), used at 02:440 and 07:671-677. D69 is also used, at 01:54, 01:332 and 01:424; its section is DELEGATED-CHOICES.md:997 (anchor d69, heading "The grammar's readings" with no number). Neither edition's summary table has a D66 row (section at l.936) or a D69 row.

**The home says.** REVIEWS.md: "Twenty-first review: the unification, its shape, …"; DELEGATED-CHOICES.md sections d66…d69.

**Fix.** 08:660: "Twenty-one numbered reviews and three others checked existing results (`[ledger](…)`)". 08:745: "numbered D1–D69 in the `[decision register](…)`". Register (DELEGATED-CHOICES.md and .zh.md): add the D66 and D69 rows to the summary table, and number D69's English heading ("### D69. The grammar's readings").

**Owner, as read.** None held. 08:660 is from RA (0d7a397a5), 08:745 from WR (74347ce26). D69 comes from DF2 under RA's row: its land_df2.py says "D69 in DELEGATED-CHOICES (both editions)".

### E25 (holds, med)

**Evidence.** 08-METHOD.md:725 reads "4. **The alignment direction on the spine** (further proof). Landed: … *Open:* no formal part; the premises the chain names (the rest reading through coupling, the acts agreeing within the closure, a comparison meeting J1/J2) are questions of warrant and correspondence." completion.py k7 (HEAD l.523-546) takes the class from the parenthesis and only checks that '*Open:*' is present, so it passes. COMPLETION.md:96 repeats "4 (further proof)". A reader counting the register is told eleven items await proof, though this one has nothing formal left.

**The home says.** 08:725 "*Open:* no formal part; … are questions of warrant and correspondence"; 08:720 "Each item has one class: further proof, philosophical warrant or empirical."

**Fix.** 08:725 parenthesis: "(philosophical warrant; its formal part landed, its correspondence empirical)". K7 reads the class before ';', and COMPLETION's K7 line follows on render. Keep the number, so COVERAGE's Alignment row (open_items [4]) still resolves. The alternative is the class 'empirical', if the owner judges correspondence the larger part.

**Owner, as read.** None held. Written at RA (0d7a397a5); the ranking is the AI's, from the twentieth review §5.

### E26 (partly, low)

**Evidence.** The counts are exact. Bare labels at 08:515, 516, 526, 528 (×2), 529, 730; 05:133, 136, 222, 227; 06:192, 635, 640; 07:460, 461 (×2), 705, 718 (×2), 766; ONE-PAGE:9, 22, 26, 28, 38. The overview, not named in the flag, has 14 (l.20 … 195). 08:66's rule, "a reading not yet registered is written `[AI reading, new]` until the register gives it a number", governs the chapters (08:49 "Every result statement in the chapters"), so the 21 chapter tags break it. Every one of those lines was last touched after D65 (23 Oct): UE9, UE10, RF7, RF-M.2, RF-M.3, RR, PF3, EL, LN2, LA4, 06's dossier fixes. ONE-PAGE and the overview are fronts, outside 08 §2. There AGENTS asks only that AI-written text keep its label, and it does.

**The home says.** 08:66 "a reading not yet registered is written `[AI reading, new]` until the register gives it a number".

**Fix.** In 05, 06, 07 and 08, change each bare "[AI reading]" to "[AI reading, new]" (21 places), then register them (D70 onward, or the covering D-number where one exists) and write the Dn. The fronts need no change.

**Owner, as read.** None held as a group. Each line belongs to its landing item: RF row (RF7, RF-M.2, RF-M.3; owner inactive), UE9/UE10, LN2/EL, the LA4 row (05:227), PF3, RR, CD's Ranking commits (ONE-PAGE).

### E27 (holds, low)

**Evidence.** COVERAGE.json rows[].sections still use the canonical chapter's numbers. Generation is ["2.2","2.6"] (COVERAGE.json:13-16); Alignment is ["7.1",…,"7.5"]. completion.py:598 prints them as '§'+s, so COMPLETION.md:21 shows "§2.2, §2.6". COVERAGE.json:834 says "chapter section 0, block A", :907 says "chapter section 0" twice, and :983 says "open item of chapter 8.1". completion.py:643 writes "Section 8.1 has {n} items", rendered at COMPLETION.md:96.

**The home says.** Home anchors of each row's records (computed from the chapters' r- anchors).

**Fix.** Set rows[].sections from the records' home sections: Generation ["02 §3","02 §4","02 §7","04 §1"]; Maintenance ["02 §3","05 §4","05 §5"]; Transformation ["01 §9","02 §2","02 §8"]; Degeneration ["02 §2","02 §3","02 §5","02 §6","02 §9","05 §1","05 §7"]; Dissolution ["01 §9","02 §4","02 §8"]; Actor ["01 §9","02 §7","04 §1","05 §1"]; Patient ["01 §9","02 §6","02 §7","04 §1"]; Knowing ["01 §8","03 §2","03 §3","03 §5","03 §6"]; Evaluation ["02 §3","07 §3","07 §4"]; Capacity ["02 §2","02 §3","07 §2","07 §4","07 §6"]; Responsibility ["05 §1","07 §2","07 §4","07 §6"]; Life ["02 §3","04 §1"]; Evolution ["04 §2","04 §3","04 §4","04 §5","04 §6"]; Learning ["03 §5","03 §6"]; Collective ["02 §9","05 §1","05 §2","05 §3","05 §5","05 §9"]; Significance ["07 §2","07 §3","07 §4"]; Alignment ["03 §1","05 §7","05 §8","07 §6","07 §7"]. completion.py:598 then prints s as is, without the '§' prefix. COVERAGE :834, :907 and :983 become "08 §4 (premise card), its first table", "08 §4" and "08 §12, open items ranked". completion.py:643 becomes f'08 §12, open items ranked, has {n} items: '. Render; never hand-edit COMPLETION.md.

**Owner, as read.** None holds COVERAGE.json (last committed by CD, 106f1dfe8). completion.py has uncommitted edits by GT's session in this worktree (branch gate-tiers), so coordinate with GT.

### E28 (holds, low)

**Evidence.** COVERAGE.json rows' open_items: Generation [5], Transformation [8], Degeneration [10], Dissolution [6], Actor [7], Knowing [3], Evaluation [3], Capacity [5], Responsibility [11], Evolution [9], Learning [7], Collective [7], Significance [2,12], Alignment [4]; Maintenance, Patient and Life []. No row lists 1. 08:723 item 1's Open: "lifting the World and process laws onto the grammar (§6), which law holds (item 7) and the representation (item 6)". k7 checks only that the items rows name exist, not that every item is named.

**The home says.** 08:723 "*Open:* lifting the World and process laws onto the grammar".

**Fix.** Add 1 to open_items of each row whose central declarations do not all reach the grammar (item 1's Open is exactly that lifting; measure_grammar.py's per-declaration category picks the rows). The minimal alternative: COVERAGE.json open_register.about adds "Item 1, the base, bears on every row and is listed in none."

**Owner, as read.** None held (COVERAGE.json last committed by CD).

### E29 (holds, low)

**Evidence.** Seven records have status superseded, and each has a non-empty next_delta, six asking for "an independent review". a-law-through-changing-coupling-along-one-run and a-law-through-coupling-along-one-run → a-law-through-a-projection-along-one-run; any-number-of-drawers-in-turn, drawers-in-turn-draw-everything, drawers-in-turn-within-capacities, revision-comes-to-drawing-everything → drawers-in-turn; conditional-foundation-assessment → theory-of-becoming-foundation ("Reuse the completed candidate; …"). registry.py:1222 renders next_delta under "## Next" whatever the status; e.g. drawers-in-turn-draw-everything.md:46-48 "Drawing at once; noisy or partial revision; an independent review."

**The home says.** RESULT-WORKFLOW.md:105 next_delta: "The next substantive step, stated positively."

**Fix.** In each of the seven records set next_delta.en to "Superseded by <superseded_by>; its record carries the next step." and next_delta.zh to "已为 <superseded_by> 所取代；下一步在其记录中。". Or change the render at registry.py:1222 so a superseded or withdrawn record's Next section reads that line and keeps the old text as history. The atlas reads superseded_by before next_delta either way.

**Owner, as read.** None held (supersessions by UM, 22 Oct, and the foundation target).

### E31 (holds, med)

**Evidence.** - GLOSSARY.md:39: "| meta-attractor (元吸引子) | closed capture: a lock through the rule that outlives its loss | `[02](…#capture)` |". It came in with RA (0d7a397a5).
- 02-MAP.md:402: "元吸引子 … a loop of selection whose rule and whose reading of the rule are both formed from the share it selects, nothing in it reading what lies beyond the share".
- theories/meta-attractor/GENERATIVE-REGIMES.md:7-9, under "Ren selected the following working definition": "A meta-attractor is a recurrent organization of activity whose consequences help reproduce the conditions selecting that organization, across changes in its particular carriers."
- _process/research/2026-10-05-generative-foundation-review/root-foundation/META-ATTRACTOR-RECONCILIATION.md:11: "the old proposal to reserve the word exclusively for pathology is superseded". At :46: "Use **meta-attractor** for the adopted neutral … concept. Specify **destructive capture regime** where shrinking corrective possibilities is established."
- 02 itself records both senses. 02:453 [D65]: "The corpus's meta-attractor is wider: an organization whose consequences take part in rebuilding the conditions that select it, continuing across changes of its carriers … the formal 元吸引子 says nothing of carriers". But 02:438 says "The corpus's meta-attractor is the closed loop".
- OPENING.md:29 adds a third, informal sense: "a selection in which winning buys more power to win".
- The glossary, which AGENTS makes the one sense of each word, gives only the capture sense.

**The home says.** 02:402 (the definition) and 02:453: "The corpus's meta-attractor is wider: an organization whose consequences take part in rebuilding the conditions that select it, continuing across changes of its carriers"

**Fix.** Replace GLOSSARY.md:39 with two rows, each with one sense, built from 02's own words.
- "| meta-attractor (元吸引子), the spine's | closed capture: a loop of selection whose rule and whose reading of the rule are both formed from the share it selects, nothing in it reading what lies beyond the share; its lock outlives its loss | `[02 §9](theories/becoming/chapters/02-MAP.md#capture)` |"
- "| meta-attractor, the corpus's | an organization whose consequences take part in rebuilding the conditions that select it, continuing across changes of its carriers; wider than the spine's, which says nothing of carriers (whether a capture loop is 生成 at some pair of classes is open) | `[02 §9](theories/becoming/chapters/02-MAP.md#capture)`; `[the corpus](theories/meta-attractor/README.md)` |"

Also change 02:438's "The corpus's meta-attractor is the closed loop:" to "The corpus's meta-attractor as the opening states it is the closed loop:", so that it agrees with 02:453.

The alternative is for the owner to argue: the reconciliation's rule (:46) would rename the spine's term (for example 闭捕, closed capture) and keep 元吸引子 for the neutral sense. AA's WM item (the meta-attractor in the corpus's wide sense) is where that sense gets its Lean.

**Owner, as read.** none held. The glossary row came with RA (0d7a397a5); the last GLOSSARY commit is IGF2 (7e600a2c9), now closed. AA routes the text change, and AA's WM item holds the wide sense.

### E32 (holds, low)

**Evidence.** 07-SIGNIFICANCE.md:289 (§4.2, the strongest argument for the step) labels its premises "(P1) Acting for a continuation presupposes that some continuation has significance. (P2) What is 'one's own' is a region drawn ... (P3) ... (P4) ...". 07:441-445 (§4.6, the path) labels four different premises P1-P4 ("(P1) Held de se, acting presupposes ..."). §4.7 already disambiguates in one direction (07:471: "P1 to P4 here are §4.6's, not those of §4.2's argument for the step."). Every outside citation I found qualifies the labels as §4.6's: CD:76, 08:575, 08:759, GOALS:312, T8 at 07:751. review/PHILOSOPHY.md:250 quotes §4.2's P1-P4 under "07 §4.2". So the collision is real but contained.

**The home says.** 07-SIGNIFICANCE.md:471: "P1 to P4 here are §4.6's, not those of §4.2's argument for the step."

**Fix.** No rename, since the names state no wrong meaning (AGENTS: rename only one that does). Add disambiguations instead. At 07:289, after the four premises, add: "(These P1–P4 are the step's; §4.6's P1–P4 are the premises of another argument, the path.)" At 07:440, change "Premises:" to "Premises (the path's, not §4.2's P1–P4 for the step):". The atlas should give the two sets distinct ids, for example step.P1-P4 and path.P1-P4.

**Owner, as read.** none held. §4.2 was last committed by RA (0d7a397a5), §4.6's premises by PW (61db89224), and the §4.7 note by PF3 (a25c149f7), all landed.

### E35 (holds, low)

**Evidence.** 08-METHOD.md:575 Standing: "argued; open: P2 and P4 of `[07 §4.6](07-SIGNIFICANCE.md#future-path)` (one's line a regularity of its own; its class holding one's effects), the step beyond that path, a reason for C". The home, 07-SIGNIFICANCE.md:751, reads: "Open: P2 and P4, the crux of §4.6's path, with P3, a correspondence not shown for actual selves; the step of invariance, for what that path does not reach; and a reason for C." Both were written in LW (64184668b, 30 Oct), and P3 was dropped in 08 from the start.

**The home says.** 07-SIGNIFICANCE.md:751: "*Standing:* argued. Open: P2 and P4, the crux of §4.6's path, with P3, a correspondence not shown for actual selves; the step of invariance, for what that path does not reach; and a reason for C."

**Fix.** Replace 08-METHOD.md:575's Standing cell with: "argued; open: P2 and P4 of `[07 §4.6](07-SIGNIFICANCE.md#future-path)` (one's line a regularity of its own; its class holding one's effects), the crux of that path, with P3, a correspondence not shown for actual selves; the step of invariance, for what that path does not reach; and a reason for C".

**Owner, as read.** none held. The most recent committer to the row is LW (64184668b, landed).

### E36 (partly, low)

**Evidence.** The flag holds for both records, but both homes are in 02, not 03. 02-MAP.md:147 says "Arising is activity starting, not §1's generation; the records `unceasing-generation-needs-renewal` and `whole-persists-through-generation` are laws of arising that keep \"generation\" only in their names"; the homes are 02:149 (§3.2) and 02:177 (§3.3). GLOSSARY.md:32: "\"Generation\" never means arising". Not only the name: unceasing-generation-needs-renewal's statement reads "unceasing generation needs renewal to recur; renewal does not imply generation" (zh "不息的生成…不蕴含生成"), and its titles are "Unceasing generation needs renewal" and "不息的生成需要更新". It is also listed in COVERAGE's Generation and Life rows, and 04:42, 05:91 and OPENING.md:69 link one or the other.

**The home says.** 02:150 "unceasing arising is strictly stronger than recurring renewal"; 02:178 "A whole arises only as a part arises".

**Fix.** Rename with `research.py rename-id --plan` (dry run first): unceasing-generation-needs-renewal → unceasing-arising-needs-renewal, titles "Unceasing arising needs renewal" / "不息的生起需要更新", statement "Where arising depletes finitely many conditions, unceasing arising needs renewal to recur; renewal does not imply arising." / "生起消耗有限条件时，不息的生起需要更新复现；更新却不蕴含生起。"; whole-persists-through-generation → whole-persists-through-arising-parts, titles "A whole persists through the arising of its parts" / "整体经由部分的生起而持续". Then 02:147 keeps only "Arising is activity starting, not §1's generation." Each rename states a wrong meaning under GLOSSARY, as AGENTS requires.

**Owner, as read.** None held. 02:147 was written at RA (0d7a397a5).

### E39 (holds, low)

**Evidence.** _process/REPOSITORY-LAYOUT.md:19-23, the target tree, lists under theories/becoming/ only "OPENING.md", "chapters/ THE-THEORY-OF-BECOMING.md, current studies, generated README index", "results/" and "history/". On main, THE-THEORY-OF-BECOMING.md (with .zh.md) sits at theories/becoming/, and chapters/ holds 01-ROOT.md … 08-METHOD.md, CLAIMS.md and a generated README. The tree omits review/ (the cover README/.zh.md, the six dossiers and recoding/) and the fronts (ONE-PAGE.md/.zh.md, COLLECTIVE-DIRECTION.md, FREE-ENERGY-PRINCIPLE.md, ONE-ARGUMENT.md). Two more lines are stale in the same way. l.57 says "the canonical chapter, the current studies", but RA moved the canonical chapter to theories/becoming/history/. l.48 says "output/ exports + README", but output/ has no README.md. Lines 21 and 48 come from 987506884/9875068849 (17 Oct). The file was last changed at 9b45c889f (18 Oct), before RA (0d7a397a5, 23 Oct).

**The home says.** Board l.29 (RA landed): "the one page and the overview (`theories/becoming/ONE-PAGE.md`, `THE-THEORY-OF-BECOMING.md`, each with a Chinese edition), the eight chapters (`theories/becoming/chapters/01-ROOT.md` … `08-METHOD.md`) ... the canonical chapter ... moved to `theories/becoming/history/`"

**Fix.** Replace tree lines 19-23 with:
"theories/becoming/            the canonical theory, in four layers
  ONE-PAGE.md                 the one page (with ONE-PAGE.zh.md)
  THE-THEORY-OF-BECOMING.md   the overview, the canonical entry (with .zh.md)
  OPENING.md                  Ren's text
  COLLECTIVE-DIRECTION.md, FREE-ENERGY-PRINCIPLE.md, ONE-ARGUMENT.md   pages off the reading path
  review/                     the cover (README, .zh.md) and the dossiers for reviewers; recoding/ the codebook and frozen sample
  chapters/                   01-ROOT.md … 08-METHOD.md, CLAIMS.md (stub), generated README index
  results/                    records/, data/, generated views
  history/                    retired chapters (the canonical chapter among them), verification/, lineage/, lean-declarations/"
In l.57, replace "Ren's opening, the canonical chapter, the current studies, and the result records with their generated views" with "Ren's opening, the one page, the overview, the eight chapters, the review packet and the result records with their generated views". l.48 and l.69 need either an output/README.md or the word "README" dropped.

**Owner, as read.** None held in practice. RA's row (board l.48) nominally holds the layout. Its owner, the original one-unfolding-root session, is inactive since 25 October per OU's row, so the row has lapsed under rule 4. Last committer to the file: K1, 9b45c889f. Route it to the coordinator.

## fixed on main

### E21 (fixed, low)

**Evidence.** experiments/README.md:29 now reads "TR8, TR4, TR5, TR3, TR1, TR7, TR6, TR9 and TR2's Stage B frozen 4 Nov 2026, not run, ... TR2's Stage B in `[FREEZE-7](formations-that-read/FREEZE-7.md)`". TR71's commit 3229fd207 (4 Nov 19:37) replaced "TR8, TR4, TR5, TR3 and TR6 frozen ... the rest not frozen" with a list that includes "TR2's Stage B" and FREEZE-7. b8de44bfd (RFZ, 21:31) last edited the line.

**The home says.** formations-that-read/FREEZE-7.md (TR2's Stage B), commit 24a330677

**Fix.** Nothing left. The line also says the Stage A of TR1, TR7 and TR2 stays a design, which matches the freezes.

**Owner, as read.** Fixed by TR71 ("Names and identity discussion") at 3229fd207. The latest edit is RFZ's b8de44bfd.
