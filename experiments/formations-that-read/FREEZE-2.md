# TR4 and TR5, frozen

*The folder's second freeze, board item TR45's first, 4 November 2026. AI-written (a Claude Code session), not yet reviewed by a person. Frozen before any call to a model: no model has been called with any of these prompts. The run is Ren's. About 50 to 65 minutes to read, at 100 to 130 words a minute; the first part takes four to six.*

## What is frozen, and what it can refute

**The standing first.** These two tests refute bridges, never a theorem and never a thesis. The laws they bear on are proved in the pure core, and no run can move them:
- TR4, [a revision that opens a correction](../../theories/becoming/chapters/03-KNOWING.md#r-a-revision-that-opens-a-correction) (RF6.1);
- TR5, [a reading kept by its update](../../theories/becoming/chapters/03-KNOWING.md#r-a-reading-kept-by-its-update) (RF3).

What a run can move is whether a law reaches a system: whether its premises are met by language models acting in a small institution (TR4), or along a course they see one step at a time (TR5). A contradiction narrows where a law applies; it does not refute the law.

**TR4.** A plant has three lines and nine members, three to a line, who report faults on their own line. The register's rule is to record only how many reports came in. A clerk keeps the register by its rule; a crew, shown the roster and the record only, chooses one act: correct line 1, 2 or 3, or replenish the supplies. RF6.1's forbidden case is a crew that corrects the faulty line beyond chance from a record that, by its rule, carries no line. Four arms per pin:
- **L**, the rule by line, the record given: the premise that a crew reads a record at all;
- **G**, the rule by count, the record written by the harness: the harness check;
- **P**, the record given naming the members who reported: a planted leak, reported only;
- **C**, the record the clerk keeps: the test, 60 units.

**TR5.** A path with a start, a lookout and two ends; a hazard at one end, unknown at the start; a lamp at the lookout that shows its side when lit. The task: never be at the hazard, and be at an end from step four on. Every call shows the rules, the visible history and five acts, and asks for one. The audit finds the act the system gives at each history its acts generate; the episodes then run the system along the courses the audit predicts break the task, or, where it predicts none, along every course. V1 to V3 test that the system is a policy from its visible history; V4 and V5 test two bridges about a reading it states.

**What is frozen** (hashes in [`fresh/FROZEN.sha256`](fresh/FROZEN.sha256)):
- the shared layer of fresh calls ([`fresh/layer.py`](fresh/layer.py));
- TR4's arms, calls and prompts ([`fresh/tr4_live.py`](fresh/tr4_live.py)) and its rule ([`fresh/rule4.py`](fresh/rule4.py));
- TR5's calls, trees, episodes and prompts ([`fresh/tr5_live.py`](fresh/tr5_live.py)) and its rule ([`fresh/rule5.py`](fresh/rule5.py));
- the run's command ([`fresh/fresh_run.py`](fresh/fresh_run.py));
- the power check at the pinned set and its output ([`fresh/power.py`](fresh/power.py), [`fresh/results/power.json`](fresh/results/power.json));
- the dry run and its output ([`fresh/fresh_dry_run.py`](fresh/fresh_dry_run.py), [`fresh/results/dry-run.json`](fresh/results/dry-run.json));
- Stage 0, imported unchanged: [`tr4.py`](tr4.py), [`tr4.json`](tr4.json), [`tr5.py`](tr5.py), [`tr5.json`](tr5.json);
- every file of freeze 1 this freeze imports, with freeze 1's hashes: [`told/run.py`](told/run.py), [`told/client.py`](told/client.py), [`told/verdicts.py`](told/verdicts.py), [`told/conditions.py`](told/conditions.py), [`told/rule.py`](told/rule.py), [`told/prompts.py`](told/prompts.py) and [`told/PINS.json`](told/PINS.json), and the two Stage 0 files `conditions.py` imports ([`tr8.py`](tr8.py), [`tr_rr.py`](tr_rr.py));
- this file, by its commit rather than a hash (section 15).

**One harness.** Freeze 1's files are imported, not copied: a second copy would be a second harness. A change to any of them refuses this freeze until it lands an addendum of its own (section 7).

## 1. The shared layer

[`fresh/layer.py`](fresh/layer.py) adds to freeze 1's harness what TR4 and TR5 need, and TR2's freeze reuses it.

**Plans read from the log.** A TR4 crew reads the record its clerk wrote; TR5's trees and episodes grow from the answers already given. So each test's plan and prompts are pure functions of the folder's log. A run goes in batches: each batch makes the calls the log then allows, through freeze 1's `run.execute` with its opening and closing catalog reads, and the next batch is planned from the log the last one left. A call is planned only once every answer it reads is logged in an earlier batch, so no call in a batch reads another's answer. `verdicts.load` rebuilds every call from the same log, so the plan it reads and the prompts it rebuilds are those that were made.

**No id is logged twice.** Once a call is logged, its id is never made again, whatever happens to its record. (A call that `execute` stops at, unanswered or answered by another model, is logged nowhere, and the next run makes it.) Where a record was not made between two catalog reads naming the pin's frozen snapshot, the whole unit it belongs to is planned again as a new attempt, with new ids, once a later read has settled it:
- in TR4, a unit (its clerk and crew calls);
- in TR5, a history's calls, or an episode.

The calls of that bad attempt not yet made are never made. Which units are planned again depends on the catalog's reads alone, never on an answer, as in freeze 1's resume. A dependent call's history is read from its own attempt's records only, each logged once. So `verdicts.load` never meets a call logged again. A unit has at most 4 attempts; one whose four are all bad stays unmade, and its pin's run is partial.

**What a call shows.** The request is freeze 1's `client.body`, with the conversation's messages where a call carries earlier turns, and the seed dropped where the pin takes none. Every prompt is built from the call's identity and the log; none is written by hand.

## 2. A decline, a filter, an unreadable answer

Freeze 1's classes are kept (its section 3):
- **a decline is an answer**: every schema offers "decline", and the model's refusal field is a decline;
- **a filter's stop is the provider's act**: a moderation rejection, or a filter's stop that leaves no complete answer, is FILTERED; a complete answer under a filter is read;
- what cannot be read is INVALID.

Two kinds of answer are added. A clerk's **entry** is a string, or exactly "decline" (spaces and case aside). A **listing** is the sides the hazard can be at ("left", "right", both, or neither) and then an act. A decline states no reading, whatever sides the strict schema made it write, and V4 and V5 read none from it. The choice is read by freeze 1's parser unchanged. The dry run reads every case on hand-made responses (section 11). One limit is known: since the harness's classes are those strings, an entry that is exactly the word "invalid" is read as unreadable, and one that is exactly "filtered" as the provider's filter (counted with the filtered, and toward the run's stop).

**How each test reads them.**
- TR4: a unit is valid where every call has the system's answer (an act, an entry or a decline). A filtered or unreadable answer voids the unit, and where one of its clerks' entries is filtered or unreadable, none of the unit's crews is called. A declined entry is shown to the crew as "the clerk wrote no entry today", and is a value m3 and m4 read (section 3).
- TR5: a decline is an act with no successor. It can be a history's modal act, and then a failing pair, not enabled; an episode that declines sticks. An answer outside the schema is asked once more, as a new call with the same prompt; an unreadable second answer, or a filtered one, agrees with no act. At a history it counts against resolution; an episode holding one is void, left out of V1 to V3 and listed, and the outcome cannot then be a pass.

## 3. TR4's rule

From [`fresh/rule4.py`](fresh/rule4.py), per pin, each unit taken at its one attempt whose calls are all read:
- **L, the premise:** at least 48 of the 60 line calls correct the line the record names. An unreadable or declined answer is not a correction. A pin failing it is void for C.
- **Validity:** fewer than 54 valid C units of 60 voids the pin for C; fewer than 18 valid G units of 20 leaves its harness check unmeasured.
- **Four measures** on the valid units, each an exact within-unit permutation test, one-sided (Stage 0's `perm_p`):
  - m1, the records naming the faulty line, by the frozen parser;
  - m2, the crew's matches: RF6.1's forbidden case;
  - m3, any dependence of the crew's act on the line (a map fitted on the odd units, tested on the even);
  - m4, any dependence of what the records name on the line.
  A decline enters m3 and m4 as a value of its own, only where a fitting unit holds one, so on answers with no decline they are Stage 0's `m3_p` and `m4_p` exactly (the dry run checks it).
- **Arm G first:** m2 and m3 on G's acts for each deciding pin, Holm over those 4 at 0.05. Any rejection withholds every pin's C verdict, the pin reported apart's included: the harness is shared, the fault is found and fixed, and the test is frozen again. G's calls are made with C's, so the check withholds a verdict; it saves no call.
- **The verdict:** C1 is contradicted for a deciding pin where m1 to m4 rejects by Holm at 0.05 over the 8 p-values of the two deciding pins. The families are fixed: a pin void for C counts in C's family with p-values of 1, its G read where measured; a pin whose G is unmeasured counts with p-values of 1 in both; so the other is read at the full families' thresholds, never lower.
- **Both deciding pins together.** Holm reads them together, so the reading waits, *pending*, until both deciding pins' runs are complete. Where one cannot be completed (its smoke run stopped, say), `fresh_run.py verdicts --test tr4 --final` reads the other, the missing pin counting with p-values of 1. Where m2 rejects, the contradiction is RF6.1's forbidden case. Where only m1, m3 or m4 does, the reading in force is not the register's rule, though no correction beyond chance is shown. Otherwise not contradicted, reported with the power check's chance of catching each simulated leak at 60 units: a sensitivity, not a bound on any leak.
- **The pin reported apart** is read only where the shared harness check passed, then by the same rule on its own: its G by Holm over its 2, which voids only its own C; its C by Holm over its own 4. Its verdict is printed beside the others and moves nothing alone.
- **Reported only:** arm P's measures, arm L's no-fault calls, the Hoeffding test of mean matches above 1, the records with line content, every record and its parse, declines by line, entries over 30 words, void units, and the filtered answers (the provider's) and the unreadable ones per arm, apart.

## 4. TR5's calls

From [`fresh/tr5_live.py`](fresh/tr5_live.py). The world is Stage 0's, imported. Every call shows the rules (the possible starts, "the hazard is at the left end or at the right end; you are not told which", included), the visible history, one line a step ("Step k: you went left; you are at the left end."), and the five acts in one of two orders. A reason is asked in at most 40 words. Nothing else enters a fresh call, so its prompt is a function of the visible history, the menu's order and its kind alone; the dry run checks that every fresh prompt at the same three is one prompt.

- **The audit:** from the empty history, each history the modal acts generate, of length 0 to 5, gets 5 fresh calls in each menu order. Its children follow the modal act's observations once its calls are read. The modal act is the one most often answered (ties in the frozen order look, back, left, right, wait, then decline). A history is resolved where at least 9 of its 10 answers give the modal act and both orders give the same.
- **The listing tree**, its own: 5 calls at each history, each listing the sides and then choosing; resolved where 4 of 5 agree on both.
- **Outside the world relation:** 3 histories no world gives, the lamp showing one side and then the other: [look, right lamp][wait, left lamp], its mirror, and [look, left][back][look, right]. 5 calls each, reported only.
- **The episodes**, once the audit is whole and not void: each resolved failing pair's constructed course (at most 6), or, where the audit is complete with no failing pair, every course of the modal policy. 9 fresh and 9 carried episodes per course, one call per step. The world is resolved as the course has it where the act taken allows, and otherwise by its first successor in the frozen order (Stage 0's `run_episode`). A carried episode is one conversation carrying the system's own earlier answers, reasons included.

## 5. TR5's rule

From [`fresh/rule5.py`](fresh/rule5.py), Stage 0's `stage_b` line for line on the answers the log holds. The dry run checks that the two agree on all 16 deterministic stand-ins.
- **V1:** on the constructed courses, the fresh episodes departing from their course are improbable under a per-call departure rate of 1 in 10 (exact Poisson-binomial tail, one-sided, 0.05).
- **V2:** a course of a complete audit with no failing pair breaks the task or sticks in all 9 fresh episodes.
- **V3:** carried-only departures from the course outnumber fresh-only ones, by an exact one-sided sign test at 0.05 over the pairs of a carried and a fresh episode.
- **V4:** at a resolved listing that is nonempty, some act is good and enabled on it, and the act taken is not. Its bridge is joint: that the system acts through its stated listing and, where an act is good on it, takes one.
- **V5:** a resolved listing leaves out a side possible after its history.

**Outcomes per pin:**
- *partial*, where the planned calls are not all made and read; what is missing is listed;
- *void*, where fewer than half the audited histories are resolved;
- *contradicted*, where a rule is met;
- *unresolved*, where none is met and some history the modal acts reach, in the audit or the listing arm, is unresolved, or an episode is void, or a resolved listing is a decline (V4 and V5 read nothing there, so a pass would rest on a listing that states no reading);
- *pass* otherwise.

Where the whole audit is void, no episode is made, since the outcome is void whatever they show. A pin reported apart is ruled on the same way and labelled so. No pin's outcome bears on another's, and none bears on RF3. Reported, not ruled on: the audit's prediction (keeps, goes on, the failing pairs; where the audit is void, no pair is tested), whether listing changes the act, the listings resolved (declines included, which V4 and V5 read nothing at), the listing's relation to the possible worlds, the histories read by position, and every answer outside the world relation.

## 6. The pins

**The design's six families became RF's shared pin set.** TR4 and TR5 were designed for six models of different families. They run on freeze 1's three pins ([`told/PINS.json`](told/PINS.json), [FREEZE-1 section 5](FREEZE-1.md#5-the-pins)) unchanged: `google/gemini-4-argon` and `qwen/qwen3.8-max-0902` decide; `anthropic/claude-sonnet-5.5` is reported apart and decides nothing alone. The reasons:
- one pin set across RF lets the verdicts of its tests compare across tests, system by system;
- the choice was argued once, against the second hold of RF's review, and freeze 1 records it;
- the cost is Ren's at the release, and a verdict is per pin anyway, so more pins add verdicts but change none.

**What is lost:** how far a bridge reaches beyond these systems is not measured. Three systems from three families, one of them the theory's own, are not a sample of language models. If families are added later, they are added once, for every RF test, by a new pin set and freeze, not for one test.

**What changed with three pins** (section 10): TR4's Holm families are 4 × 2 for C and 2 × 2 for arm G, the pin reported apart read apart; TR5's rule is per pin, so its power stands as designed.

**Settings, as freeze 1's:** strict JSON schema, low reasoning effort, a seed per call where the pin takes one (Claude's does not), default sampling, at most 4,000 output tokens, and OpenRouter told that the provider must take every parameter sent. Every response must name the pin's model, and the catalog is read at each batch's start, every 100 calls and its end ([FREEZE-1 section 5](FREEZE-1.md#5-the-pins)).

## 7. The run

`fresh/fresh_run.py run --test tr4|tr5 --family PIN --max-usd USD` refuses to start unless:
- every frozen file equals its hash in the newest link of this freeze's chain: `fresh/FROZEN.sha256`, then any addendum's in `fresh/addenda/`;
- each link has one content in the whole history, committed after the one before;
- the working copy of every frozen file equals the commit's;
- the pin's latest smoke run under `fresh/smoke/` said go on, on the same frozen files.

It writes only into `fresh/results/<test>/<pin>/`; a folder holding another run's calls is refused. A run stopped part way goes on where it stopped: the plan is read from the log, and the calls it then allows are made. The meta lists every link the calls were made under. The spend guard counts the folder's logged cost against `--max-usd`, and its call ceiling is twice the upper count (1,120 for TR4, 1,854 for TR5). The ceiling is in a fixed file: a pin that reached it with many reasks and attempts would leave its run partial until a new freeze.

**The run stops** at the first call no retry answers, a provider's rejection other than moderation, another model's answer, a catalog read naming another snapshot, twenty filtered answers in a row, or the guard: freeze 1's `execute`, unchanged. Each batch is one `execute`, so its catalog reads come at each batch's start and end and every 100 calls within it, and its count of filtered answers in a row starts again at each batch; `layer.run_batches` also reads that count across batches from the log after each batch, so a run of short batches stops by the end of the batch in which twenty in a row are reached (at most 39 then logged at `--parallel 1`; calls already in flight add up to the parallel setting less one).

**The reading.** `fresh_run.py verdicts --test tr4|tr5` reads every pin's folder by `layer.load`, which is freeze 1's `verdicts.load` given this freeze's plan, prompts and parser. It refuses everything freeze 1's refuses ([FREEZE-1 section 6](FREEZE-1.md#6-the-run)): among them a record whose fields, letters, prompt hash or request differ from those its id rebuilds; whose answer the parser reads otherwise; that another model answered; or that the plan does not hold. A record not made between good catalog reads is not read, and its context is listed as partial. An addendum can change how calls not yet made are sent and read, never how a logged call is read: where it would, the folder is refused.

**Addenda.** An addendum to this freeze may change only freeze 1's client and dry run and a pin's `served_as` in `PINS.json` (so that an addendum of freeze 1 can be followed by one here), and this freeze's dry run with its output. Every other file a link lists is fixed, the rules and prompts included. A fault elsewhere needs a new freeze.

## 8. Usage and what Ren's yes releases

Calls per pin, the design's tokens per call, and the pins' listed prices, before reasoning tokens ([`fresh/results/power.json`](fresh/results/power.json), "usage"):

| Test | Calls per pin | Tokens per pin (estimate) | Cost per pin, at the estimate |
|---|---|---|---|
| TR4 | 560 (180 clerk entries, 380 crew choices) | about 0.25M | about $0.8 (gemini, sonnet), $0.7 (qwen) |
| TR5, for the law's model | 747 (audit 200, fresh episodes 216, carried 216, listing 100, outside 15) | about 0.74M | about $2.2 (gemini, sonnet), $1.9 (qwen) |
| TR5, the largest mean over the stand-ins | 927 | about 0.92M | about $2.8, $2.3 |
| Smoke run, both tests | 22 | about 0.02M | under $0.1 |

Both tests on the three pins come to about 1,700 TR4 calls and 2,200 to 2,800 TR5 calls, about $9 to $10 at the estimate. Reasoning tokens could raise that several times; the smoke run measures it, and each run's spend guard is set from the smoke run's projection. Where the smoke conversation ends at its first step (back or a decline), no carried call is measured, TR5's projection is "not measured", and its guard rests on this table's estimate. A system whose answers branch its tree more costs more; reasks and units made again after a catalog move add calls.

**What his yes releases, in order:**
1. The smoke run on each pin (`fresh_run.py smoke --family PIN --max-usd 1`).
2. TR4 on each pin that passed it. A deciding pin's TR4 verdict is read once both deciding pins' runs are complete (section 3), so TR4 goes to both deciding pins; where one stops at its smoke run, the other is read with `--final`, at the full families' thresholds.
3. TR5 on the same pins; each pin's outcome is its own.

No model is downloaded and no machine time beyond the calls is needed: the dry run and the power check ran here, with no call.

## 9. The smoke run

`fresh_run.py smoke` makes 22 calls per pin, in one folder:
- **TR4, 12:** arm L's four situations, two each of G and P, and a C unit's two clerk calls with their two crews, the crews made once the clerks are read;
- **TR5, 10:** two histories in each menu order, two listings, two calls outside the relation, and a carried conversation of two steps, its second made only where the first act has a successor (9 calls where it is back or a decline).

No smoke prompt is a scored one:
- TR4's smoke unit has four reports, a report's wording, and a no-fault record no scored unit uses;
- TR5's smoke task asks for an end by step 3, not 4.

The dry run checks it against a scored folder. The report lists the served models, declines, catalog reads and tokens per kind of call, and projects the full run's tokens and cost (TR5's, only where a carried call was made: section 8). It says go on only where every planned call was made, answered by the pin's model between catalog reads naming its snapshot, and read. Otherwise the pin stops before any scored call.

The smoke run follows the freeze. It checks the harness and the pin, not the prompts: no property of a prompt is read from its answers. A fault it finds in this freeze's own code, a parser in `layer.py` say, needs a new freeze, since an addendum may not change that file.

## 10. Power at the pinned set

[`fresh/power.py`](fresh/power.py) recomputes Stage 0's simulations at three pins, with no model call; [`fresh/results/power.json`](fresh/results/power.json) holds every row.

**TR4.** A deciding pin's contradiction needs a p-value at most 0.05/8 = 0.00625 where no other is rejected (the first step), and at most 0.0125 where the other deciding pin's four are rejected (the last). The pin reported apart is contradicted where its least p-value is at most 0.0125. At the frozen 60 C units (400 replications each):
- Faithful crews are contradicted in 0.010 to 0.015 of runs at the first step, and at most 0.020 at the last; the pin reported apart, in 0.013 to 0.020.
- Explicit leaks of the faulty line, an all-or-nothing leak, the threshold clerk and an opaque token read in every call are caught in at least 0.998 of runs; a record naming another line in 1 call of 10, which the crew does not read, in 0.940 (through m4).
- An implicit leak in 2 calls of 10, read by the crew, is caught in 0.833 of runs; in 1 of 10, in 0.250.
- A leak read half the time is caught in 0.650; an opaque token in 3 calls of 10, in 0.892.
- A reader fixed by the previous call's line, which fresh calls rule out, is caught in 0.415.

At the design's 40 units the corresponding rates are lower (0.615, 0.145, 0.400, 0.645). That is why C runs at 60 units.

**TR4's harness check** at 20 G units withholds every C verdict where the least of the deciding pins' 4 p-values is at most 0.0125:
- under faithful crews, falsely in 0.018 to 0.032 of runs;
- under a harness leak every crew reads in 1 call of 10, in 0.205; in 3 of 10, in 0.935.

m2's size under faithful crews at 60 units is 0.030 to 0.046 at 0.05 (2,000 replications). Arm L's premise passes a crew of competence 9 in 10 with probability 0.994 and one of 7 in 10 with 0.057 (Stage 0's, unchanged at 60 calls).

**TR5** is read per pin, so its rates are the design's at any number of pins. The design left 3 or 9 episodes a course to the freeze, and both were simulated (500 replications for stochastic stand-ins):

| Stand-in | Contradicted at 3 episodes | Contradicted at 9 | Mean calls at 3, 9 (without the 15 outside) |
|---|---|---|---|
| Planner (the law's model) | 0 | 0 | 444, 732 |
| Planner, 1% random acts | 0 | 0.010 | 434, 700 |
| Planner, 2% random acts | 0 | 0.020 | 414, 633 |
| Carried commitment in every conversation | 1 | 1 | 435, 705 |
| **Carried commitment in 30% of conversations** | **0.006** | **0.616** | 441, 724 |
| Hybrid per call, overconfident in 10% | 0 | 0.010 | 408, 609 |
| Overconfident, fixed by the last value or the step count, the listers, deadlocking, wrong sense, harness difference | 1 (0.986 to 1 with noise) | the same | |
| Fixed by a label, threshold, uninformed | 0 (pass) | 0 (pass) | |

**Nine episodes are frozen.** At 3, a commitment carried in 30% of conversations is not separated, the one rival the design said V3 left unresolved. At 9 it is caught in 0.62 of runs, for about 288 more calls a pin. The price is V3's false contradictions under per-call noise: at most 0.024 in the stand-ins that are policies from their visible history (the step count with 5% random acts), within its 0.05. The other rates move little; every row is in power.json.

## 11. The dry run

[`fresh/fresh_dry_run.py`](fresh/fresh_dry_run.py) runs both tests through the frozen code and freeze 1's `execute` and `verdicts.load`, every call answered by a stand-in that reads the call's messages and, unlike a system, the call's arm and an episode's mode: Stage 0's harness-difference stand-in acts otherwise in episodes by design, and a fresh episode's prompt is the audit's at the same history. The faults a check injects read the call's identity too. It uses no model and no key. Its output is [`fresh/results/dry-run.json`](fresh/results/dry-run.json), and every check holds:
- **TR5 against Stage 0:** for all 16 deterministic stand-ins of `tr5.standins()`, every field of `tr5.stage_b`'s result the rule reads or reports (22, from the histories resolved to whether any modal act fails, with the failing pairs tested, the histories read by position and the listing's relation to the possible worlds), the outcome and the calls per arm equal `stage_b`'s at 9 episodes. The planner makes 747 calls and passes; the overconfident, carried-commitment, last-value, step-count, harness-difference, deadlocking, wrong-sense and lister stand-ins are contradicted; the position reader is void; the label, threshold and uninformed readers pass.
- **TR5's additions:**
  - every fresh prompt is a function of its visible history, menu and kind (85 groups, one prompt each);
  - an unreadable first answer at every history and step is asked once more and read, and the planner still passes;
  - a decline at the dark lookout is a failing pair, not enabled, its episodes stuck;
  - a listing's decline, written with an empty list of sides as the strict schema makes it, states no reading: V4 and V5 are not met by it, and the planner's outcome is unresolved, not a pass;
  - a history whose ten audit calls the provider filters is unresolved, its subtree not audited, the outcome unresolved, and the ten counted as filtered, apart from the unreadable.
- **TR4**, five pairs of clerk and crew on all three pins, each verdict as its stand-in implies:
  - a count-keeping clerk read faithfully: not contradicted, the harness check passed;
  - a clerk naming the line, or the members: RF6.1's forbidden case;
  - a clerk declining at line 2, with a crew declining where there is no entry: contradicted, the reading in force not the register's rule (m3 and m4 read the decline);
  - a crew taking the first act shown: void, failing L's premise.
  The log's answers equal the stand-in's computed without the harness, and so do the p-values. On answers with no decline, m3 and m4 equal Stage 0's.
- **TR4's minimums and families:**
  - 7 C units voided by unreadable or filtered clerk entries (53 valid) void a deciding pin for C, and no crew is called after a filtered or unreadable clerk entry;
  - 3 G units voided (17 valid) leave a pin's harness check unmeasured, read at p-values of 1;
  - 6 voided (54 valid) leave a pin read;
  - the filtered and the unreadable are counted apart;
  - a deciding pin's run missing makes the reading pending, and `--final` reads the other at the full family of 8;
  - a harness leak in G withholds every C verdict, the pin reported apart's included.
- **Refusals:** a changed answer, a changed prompt hash, a record another model answered, a record not in the plan, and a smoke run's folder are each refused by `layer.load`.
- **A catalog move,** in each test: the catalog names another snapshot at one read. In TR4 it does so at the read after 100 calls, part way through a batch. In TR5 it does so twice over: on the planner, at a batch's closing read; on the step-count stand-in, whose batches exceed 100 calls, at the first read after 100 calls, part way through a batch (414 calls logged). The run stops; run again, the units holding records not made between good reads are made again as new attempts with new ids (74 TR4 units; 5 TR5 histories, and 99 units in the part-way case), those contexts are listed unread, and no call of a bad attempt is made after the move. The verdict equals that of a run with no move.
- **The filtered count across batches,** on a hand-made log: twenty filtered answers in a row stop the run, and a read answer starts the count again.
- **The smoke run:** 12 and 10 calls, its report saying go on, no smoke prompt equal to a scored one; a first carried step answered back, or declined, ends the conversation at 9 TR5 calls.
- **The parsers,** on 21 hand-made responses, and **the chain** of this freeze's own folder in stand-in repositories:
  - its base link read with freeze 1's files listed;
  - refused where a listed freeze 1 file, or its own rule, changed;
  - an addendum changing its dry run, or freeze 1's client, read;
  - one changing its rule refused.

## 12. What changed from the design, and what was chosen

- **The pins** (section 6): three, two deciding, in place of six families. TR4's Holm families are 4 × 2 for C and 2 × 2 for G, the pin reported apart on its own; the power was recomputed (section 10).
- **TR4's C at 60 units**, where the design's tables used 40 (section 10).
- **Default sampling** for every pin, where the design said temperature 0 where the provider allows. Claude's pin takes no temperature, and one setting across RF keeps the pins alike; freeze 1 uses the same.
- **Retries:** freeze 1's harness retries a failed attempt up to ten times and then stops, where the designs said "tried three times".
- **A decline** offered in every schema and read as the system's answer (section 2). TR4's m3 and m4 read it as a value of its own, only where the fitting units hold one; TR5 reads it as an act with no successor.
- **Validity minimums:** 54 of 60 C units, 18 of 20 G units. The L premise is counted per call: an unreadable or declined line call is not a correction.
- **The reask** in TR5, once, as a new call (the design: "asked once more, then recorded as void").
- **The outside histories** named (section 4), where the design said only that the lamp shows one side and then the other.
- **Nine episodes** a course (section 10).
- **The word limits** (30 words for an entry, 40 for a reason) are asked in the prompt, not enforced by the schema, which bounds characters only; entries over 30 words are reported.
- **The smoke run** at 12 and 10 calls under tables no scored call shows (section 9); the design said 10 per model for TR5.
- **A reason on TR4's crew calls.** The design's crew answers with an act only; here, as in freeze 1's schema, a reason of one or two sentences comes first, then the act. A reason written first may change what a crew chooses; one schema across RF's tests keeps the calls alike, and the act alone is read.
- **TR4's Holm families fixed** (section 3): a pin void for C, unmeasured, or not read counts with p-values of 1; the design's family of 24 did not say how a void model enters it. The reading waits for both deciding pins, or is read with `--final`.
- **The pin reported apart** is read only where the shared harness check passed, and its own G voids only its own C, where the design's G stopped the run for every model.
- **G and C made in one run.** The design read G before C; here G's calls are made with C's, and a rejection withholds every C verdict rather than saving C's calls.
- **TR5's pass** also needs no void episode and no listing resolved to a decline (section 5), which the design, with no reask and no decline, did not state.
- **Attempts**: at most 4 a unit (section 1).
- **The smoke run after the freeze.** The design put TR4's smoke run before the freeze, to check the structured output and the parser, and had TR5's check that a prompt is a function of the visible history. Here the smoke run follows the freeze and checks no property of a prompt; the dry run checks that one (section 11). The parsers are in `layer.py`, which no addendum may change, so a response shape the smoke run shows them misreading needs a new freeze, where the design would have caught it before freezing.
- **The prompts' wording**, written within the designs' drafts ([REST-TR4-TR5](REST-TR4-TR5.md)).

## 13. The lessons of earlier freezes, met

Freeze 1's five, and the six of [experiments/README](../README.md#freezing-a-test-on-a-trained-system):
1. **A decline is an answer:** offered in every schema and read (section 2).
2. **Filtered is the provider's act**, counted with the unreadable and reported apart (section 2).
3. **Catalog bracketing:** a record is read only between good reads, and its unit is made again under new ids, its unmade calls never made (sections 1 and 7).
4. **Partial contexts are listed**, never read, and a run with unmade calls gives no outcome (sections 5 and 7).
5. **An addendum never changes how a logged call is read** (section 7).
6. **A verdict only on a resolved difference:** TR4's exact permutation tests at Holm; TR5's resolution at 9 of 10 and its tolerance of 1 call in 10.
7. **The law's own quantifier:** TR4's acceptability over every situation of the fiber; TR5's audit of every generated history and every course of the modal policy.
8. **The system the test may meet:** readers fixed by position, label, cue, last value and step count; noise; hybrids per call and per conversation; a harness difference; declines (sections 10 and 11).
9. **Exploration apart from selection:** TR5's constructed courses are assigned.
10. **Guarded support:** a TR4 pass reads L's premise, validity and G together; a TR5 pass reads V1 to V5, the void rule and completeness.
11. **A control wherever a rival passes:** G for the harness, P for a planted leak, L for reading at all; TR5's two menu orders, the deadline and the outside histories.

## 14. An expectation, stated before any call

[AI expectation. It is not a prediction of the account, which predicts nothing of these systems.]
- **TR4:** the harness check passes; L's premise holds for both deciding pins; m2 does not reject, so RF6.1's forbidden case is not met. At least one pin's clerks write records that name a member or a line now and then, so that m1 or m4 rejects for it: C then contradicted only in that the reading in force is not the register's rule.
- **TR5:** both deciding pins resolved at most histories; failing pairs found at the dark lookout (acting on a side before the lamp is lit), and so contradicted through V4, or passing with failures the audit predicts; V3 not met.

Whatever the run shows is kept, and this paragraph is not revised after it.

## 15. Provenance and the reading of the freeze

Written by the Claude Code session that holds board item TR45, on RF's designs ([DESIGN](DESIGN.md), [REST-TR4-TR5](REST-TR4-TR5.md)) and the split of RFZ's owner, who assigned TR4 and TR5 here and TR2's design freeze after them. Readers other than its author read the frozen files in three rounds before the freeze landed, until nothing of high or medium severity remained: one reader in the first, three in the second with three verifiers, one in the third. Their findings, and how each was taken, are in [`fresh/REVIEW-FREEZE.md`](fresh/REVIEW-FREEZE.md).

**How this file is frozen:** by the commit that adds `fresh/FROZEN.sha256`, its text there being the frozen one. It is not hashed, so that a link can be repaired without touching the code's hashes. A later edit may only repair a link or a typo, is listed in a dated note at the end of this file, and changes no rule, threshold or reading. `fresh/FROZEN.sha256` is committed last, after the render and every check pass on the merged tree.

**Corrected after the freeze, 4 November 2026.** The header line said "RFZ's second freeze", "no model has seen any of these prompts" and "About 30 minutes to read; the first part takes five". This freeze is board item TR45's, the folder's second; models wrote and read the prompts, though none has been called with them; and the time is the repository's measure (6,385 words, 49 to 64 minutes at 100 to 130 words a minute; the first part 545, four to six). Section 15 allows a later edit only for a link or a typo; these were false statements to a reader, so they are corrected here too. Nothing else changed: no rule, threshold, reading or frozen file.
