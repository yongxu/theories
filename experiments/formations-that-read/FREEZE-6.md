# TR6, frozen

*The folder's sixth freeze, and board item RFZ's third, after FREEZE-1 and FREEZE-3; 4 November 2026. AI-written (a Claude Code session), not yet reviewed by a person. Frozen before any call to a model: no model has been called with any of these prompts. The run is Ren's. About 55 to 70 minutes to read, at 100 to 130 words a minute; the first part takes eight to ten.*

## What is frozen, and what it can refute

**The standing first.** This test refutes a bridge, never a theorem and never a thesis. The law it bears on, [a prediction read by what it predicts](../../theories/becoming/chapters/03-KNOWING.md#r-a-prediction-read-by-what-it-predicts) (RF6.3, `Becoming.ReflexivePrediction`), is proved in the pure core, and no run can move it. A published prediction p, read by a response r before the outcome, is right exactly where r p = p. Publishing at each step the outcome of the step before is r's orbit. On the values 0 to n, under a response keeping them and their order, the orbit from 0 never falls, stays at or below every right value and is right by step n (`rises`, `below_right`, `bottom_rests`). A right value, once published, is published at every later step (`right_rests`), and where r moves every value none is right (`none_right_of_moves`). Its modelling choices: the response a function of the published value alone, read before the outcome; one value, no probability; the chain the natural numbers 0 to n.

**The test.** Ten neighbours, each one fresh call, decide whether to take part in something this Saturday, told a forecast of how many of the ten will. Each has a stated cost. In the *join* framing, taking part pays more the more take part (a shared work day); in the *lake* framing, going pays more the fewer go (a small lake). The two deciding pins are called at temperature 0. Sonnet, reported apart, takes no temperature and is called at its default sampling, where identical requests may differ more often.
- **The offline table.** Each member at each forecast 0 to 10 is asked once in each of five presentations (wording and option order). Its decision there is the one at least four of the five give, else it is *flagged*. The table is the count of those taking part at each forecast: the Lean's r, which maps 0 to 10 into itself by construction.
- **V1.** No decision is flagged; the table is neither constant nor the identity; then its shape: it keeps the order, reverses it, or neither. The readings predict that join keeps the order and lake reverses it. A framing's reading is read only where its comprehension probes all restate the forecast and the payoff.
- **The loops.** Republish the last count from 0 for eleven rounds, in each presentation. In arm A each call is fresh and memoryless. In arm B each member is shown its own course: the earlier forecasts, its own answers, the counts and its points.
- **V2.** The Lean's r is the count, not the members. A round *mismatches* where its count differs from the table's at the forecast it published. V2 is contradicted where arm B's mismatching rounds exceed arm A's by a one-sided Fisher exact test at 0.05: the public shown its course is then not a response of the forecast alone along the loop.
- **Beside them,** with no verdict: members departing from their own table decisions, a diagnostic of a stronger premise than the Lean's; the Lean's forbidden cases in each loop from 0; a no-forecast control; a payoffs-not-told control; a loop from the least right value; and a determinism pilot.

**What each outcome would change.**
- *V1 met with the join table keeping the order, and V2 not contradicted*: along these loops the join public is an instance of the chain law, and the bandwagon reading holds for these members, here.
- *V1 met with the lake table reversing the order, and V2 not contradicted*: only `right_rests`, and `none_right_of_moves` where every value moves, bear on it; no reaching is predicted.
- *A shape other than predicted*: that framing's reading, self-fulfilling under join or self-defeating under lake, narrows for these members.
- *V2 contradicted*: the reading of a published forecast as the input of a response narrows to memoryless publics, for these members. The theorems stand either way.
- *Void*, a decision flagged: these members' decisions move with the presentation, or the serving, beyond what the table resolves. The public is then not one response of the forecast, and the framing has no V2.
- *Not read*: a constant table, a public deaf to the forecast; the identity, each forecast met, as by members reading it as an instruction; or probes that do not restate, which leave the shape unread as a reading.
- *A harness fault*: one of the Lean's forbidden cases in a loop whose every count is the table's. Such a loop is the table's orbit, so the fault is the harness's, and no reading is taken from that pin until it is checked.

Freeze 1's pins decide: Google's `gemini-4-argon` and Qwen's `qwen3.8-max`, two families that neither wrote nor read the theory. Anthropic's Sonnet 5.5 is reported apart. So no family that wrote or read the theory decides the verdict alone.

**What is frozen** (hashes in [`told-tr6/FROZEN.sha256`](told-tr6/FROZEN.sha256)):
- the members, the framings, the prompts and the plan ([`told-tr6/tr6_design.py`](told-tr6/tr6_design.py));
- the rule: the table, V1, the loops, V2 and the reports ([`told-tr6/tr6_rule.py`](told-tr6/tr6_rule.py));
- the run in rounds and its reading ([`told-tr6/tr6_run.py`](told-tr6/tr6_run.py));
- the dry run and its result ([`told-tr6/tr6_dry_run.py`](told-tr6/tr6_dry_run.py), [`told-tr6/results/dry-run.json`](told-tr6/results/dry-run.json)) and the hash writer;
- Stage 0 ([`tr6.py`](tr6.py), [`tr6.json`](tr6.json));
- the files of freeze 1 and freeze 3 it imports: freeze 1's client, run, reading, rule, conditions, prompts and pins, with `tr8.py` and `tr_rr.py`, which they import; freeze 3's request and endpoint check with the endpoint lists it reads, and freeze 3's run, design and rule, whose chain check TR6's run calls.

The text is frozen by its commit. The run waits on Ren's yes, and nothing here has called a model.

**What changed from the design**, in section 12: the five offline calls are the five presentations; a decline is read as not taking part, and an unreadable answer ends its loop; loops run only where no decision is flagged; a second start where the orbit from 0 barely moves; the probes gate the reading, not V2; one set of costs for both framings; freeze 3's endpoint check; and a check of each logged prompt's text, which freeze 1's reading checks by its hash alone.

## 1. The members and the framings

Ten members, with costs of 5, 15, 25, 35, 35, 55, 65, 65, 85 and 95 points: the same ten in both framings. The two pairs that share a cost are shown identical prompts, so at temperature 0 they answer alike, and the count moves by two there. A member's points, as its prompt states them:
- *join*: if it takes part, 10 points for each person who takes part, itself included, less its cost; 0 if it stays out;
- *lake*: if it goes, 110 points less 10 for each person who goes, itself included, less its cost; 0 if it stays home.

Each member is told its own cost, not the others'. The forecast is all it is told of them.

**What a best reply would give**, reported only: no verdict reads it. A member reading the forecast must place itself in it, and two readings are natural. Taking the forecast as the others who take part, and adding itself, gives Stage 0's full climb under join and an alternation under lake. Taking it as the count, itself among it, gives a join table resting at 0 and a lake table with no right value.

| Framing, reading | r(0), …, r(10) | Shape | Right values | Orbit from 0 |
|---|---|---|---|---|
| join, the forecast as the others | 1 2 3 5 5 6 8 8 9 10 10 | keeps | 10 | 0 1 2 3 5 6 8 9 10 10 … |
| join, the forecast as the count | 0 1 2 3 5 5 6 8 8 9 10 | keeps | 0, 1, 2, 3, 5, 6, 8, 9, 10 | 0 0 … |
| lake, the forecast as the others | 10 9 8 8 6 5 5 3 2 1 0 | reverses | 5 | 0 10 0 10 … |
| lake, the forecast as the count | 10 10 9 8 8 6 5 5 3 2 1 | reverses | none | 0 10 1 10 1 … |

The costs were chosen for that: the join public's best replies then keep the order under both readings, and the lake public's reverse it under both. The table measured, not these, is what V1 reads. Its shape then turns on the framing, not the members, since the members are the same. The design asked for costs, not thresholds, written into the personas ([REST-TR3-TR6](REST-TR3-TR6.md#rivals-and-what-separates-them)): a member told a threshold would implement the order, and V1's shape would then check only comprehension.

## 2. The prompts

Every prompt is built from its call's identity alone: the framing, the member's cost, the forecast (or none), the presentation and, in arm B, the member's course. Verbatim, a member with cost 35 at forecast 3 in presentation 1:

> Ten neighbours on one street can each choose whether to take part in a shared work day this Saturday, building raised garden beds on the street's common ground. Each neighbour decides alone, without talking to the others, and all decide at the same time. The more people take part, the more is built for those who do: if you take part, you get 10 points for each person who takes part, you included, and you pay your own cost of taking part, 35 points. If you stay out, you get 0 points. Each neighbour has a cost of their own, which the others are not told.
>
> A forecast published this morning says that 3 of the 10 neighbours will take part.
>
> A: stay out.
> B: take part.
>
> Decide now. Answer in JSON, with "choice": "A" or "B".

The lake story, in place of the first paragraph:

> Ten neighbours on one street can each choose whether to go to a small lake nearby this Saturday morning. Each neighbour decides alone, without talking to the others, and all decide at the same time. The fewer people go, the better the morning is for those there: if you go, you get 110 points less 10 points for each person who goes, you included, and you pay your own cost of going, 35 points. If you stay home, you get 0 points. Each neighbour has a cost of their own, which the others are not told.

Its options are "go to the lake" and "stay home", and its forecast says how many "will go".

**The five presentations.** Presentation v shows the forecast in one of three wordings, v // 2, and lists the option of taking part first where v is even:
- "A forecast published this morning says that p of the 10 neighbours will take part." (0 and 1)
- "This morning's published forecast: p of the 10 neighbours will take part." (2 and 3)
- "The forecast published this morning is that p of the ten neighbours will take part." (4)

**Arm B's course** stands between the story and the forecast from round 1 on, one line a Saturday. Round 0's prompt is arm A's. For example:

> This choice comes every Saturday. On the earlier Saturdays, for you:
> - Saturday 1: the forecast said 0 of the 10 would go; you went; 10 of the 10 went; you got -25 points.
> - Saturday 2: the forecast said 10 of the 10 would go; you stayed home; 0 of the 10 went; you got 0 points.
> Now it is the next Saturday.

A decline shows as "you gave no choice, and so did not take part" (or "did not go"), with 0 points.

**The probe** replaces the options and the question: 'Do not decide yet. Answer in JSON: "forecast", the number of neighbours the forecast says will take part; and "points", the points you would get in all, your cost paid, if you took part and k of the 10 neighbours took part, you included.' Here k is the forecast, or 1 at forecast 0. It is asked of the members with the lowest and the highest cost at each forecast, in presentation 0.

**The controls.** The no-forecast control is the prompt without its forecast sentence. The payoffs-not-told control tells only the story's first two sentences, of "an activity", with neither points nor costs. Its members are then alike, so it is asked at each forecast in each presentation twice, and reported as the share taking part.

**The cover story** names neither El Farol nor a bandwagon, both well known to models. It is told in points, not money.

## 3. The call and the reading of an answer

**The request is freeze 3's** ([FREEZE-3 §3](FREEZE-3.md#3-the-call-and-the-reading-of-an-answer), `tr3_client.request`): the prompt as the one user message, a strict JSON schema, freeze 1's token limit and low reasoning effort, and one endpoint of the pin's provider with no fallback. A pin that takes a temperature gets 0, and a pin that takes a seed gets one fixed by the prompt's own hash, so identical prompts are identical requests. Arm A's prompts are the offline table's: arm A at forecast p in presentation v sends the request the table sent there. Sonnet takes neither and runs at its default.

**The reading is freeze 1's** reading of a choice ([FREEZE-1 §3](FREEZE-1.md#3-the-call-and-the-reading-of-an-answer)), through each presentation's letters. The schema's A or B is taking part or staying out. The model's refusal field is a *decline*: the system's answer. A content filter's stop with no answer, or a moderation rejection, is *filtered*, and anything else is *invalid*: neither is the system's answer. A probe is read where both of its fields are integers.

**A decline is read as not taking part**, and shows in arm B's course as no choice; declines are counted by arm and reported. **An unreadable answer**, filtered or invalid, counts toward neither decision in the table and ends its loop. Section 5 says why.

## 4. The table and V1

Each member's decision at each forecast is the one at least four of its five presentations give: taking part, or staying out (with declines). Otherwise it is flagged. The table r(p) is the number taking part at forecast p.

**Why the five offline calls are the five presentations.** With five identical requests at temperature 0, the flag rule would measure only the serving's nondeterminism, which the pilot measures. A member that chose the option listed first near its threshold would then go unflagged. It would raise both arms' mismatches alike and lower V2's power, and the table would be one presentation's. With five presentations, a decision two of five presentations move is flagged, and the framing is void: such a member answers the wording, not the forecast alone. Arm A in presentation v then sends the very request the table sent in it, so arm A's mismatches measure the serving's nondeterminism along the loop, beside any one presentation's dissent from the other four.

**V1, in order.**
1. A decision flagged: *void*, with the count of flagged decisions. The framing's loops are not run.
2. A constant table: *not read*, a public deaf to the forecast.
3. The identity: *not read*, each forecast met, as by members reading the forecast as an instruction.
4. The shape: *keeps the order*, *reverses the order*, or *neither*. A table that reverses the order and moves every value, as identical capacities would give, reverses it.

Constancy and the identity are read before the shape, since both keep the order and say nothing of a reading.

**The reading.** Join is predicted to keep the order and lake to reverse it. A framing's reading is read only where all 22 of its probes restate both the forecast and the points: the lowest-cost and highest-cost members at each of the 11 forecasts. It then *holds here* where the shape is the predicted one, and is *contradicted* otherwise. A probe that does not restate leaves the reading *not read*: such members may not have read the payoff the framing turns on. It leaves V2 as it is, since V2 asks only whether the count is a response of the forecast, whatever the members understood.

## 5. The loops and V2

For each framing whose table has no flagged decision, the loops run:
- **From 0**, arms A and B, in each of the five presentations: eleven rounds a seed, publications 0 to 10, 55 rounds per arm.
- **From a second start,** where the table's orbit from 0 moves in fewer than four of its eleven rounds: both arms again, five presentations each, from the least start whose orbit moves in the most rounds, if that is more than the orbit from 0 moves. It is fixed from the table before any loop runs.
- **From the least right value,** where the table has one: both arms, presentation 0, three rounds, the control `right_rests` speaks to.

A round publishes f_t, with f_0 the start. Its count is the number of the ten answers taking part, where all ten are readable, and that count is f_{t+1}. Each round's ten calls are derived from the rounds before it.

**Why a second start.** The Lean gives verdicts from 0 and from right values only, so the Lean's forbidden cases from a second start are reported against the candidate lemma, the orbit from any start under an order-keeping map ([REST-TR3-TR6](REST-TR3-TR6.md#candidate-core-lemmas-no-new-lean-is-written-here), lemma 4), and judged nowhere. V2 asks something else: whether the count is the table's at the forecast published, which any start shows. Where the orbit from 0 rests at once, as under join when members read the forecast as the count, arm B's course repeats one Saturday. Memory then has nothing to change, and V2 has no power against it: in Stage 0, inertia of strength 0.1 on a public whose orbit moves in three rounds was caught in 0.04 of runs. The second start gives V2 moving rounds where the table has them. Where it has none, it cannot: under join's best replies with the forecast read as the count, every start rests within one round, so the second start, 4, adds one moving round, and memory that changes no count on the orbit stays out of V2's reach (section 10). That is the law's own scope: along such an orbit the public is indistinguishable from a response of the forecast alone.

**V2.** A round mismatches where its count differs from the table's at its forecast. Over the loops from 0 and from the second start, arm B's mismatching rounds of its rounds read are compared with arm A's by a one-sided Fisher exact test. V2 is *contradicted* where p < 0.05, and *not contradicted* otherwise: no support is claimed for a theorem. The loops from 0 alone are reported beside it. With 55 rounds per arm, V2 needs at least 5 mismatching rounds in arm B where arm A has none, 7 where it has one, 8 for two and 13 for five.

**Declines and unreadable answers in the verdicts.** A decline is the system's answer, and it counts as not taking part: toward staying out in the table, and as one not taking part in a loop's count. The forecast is of who takes part, and a member that does not choose to take part does not. Read as no answer, a refusal would instead void a decision or end a loop, so a public that declined where shown its course would escape V2 rather than meet it. A public that declines throughout gives a constant table, not read. A filtered or invalid answer is not the system's. It counts toward neither decision in the table. A round holding one has no count, so its seed ends there and its earlier rounds are read. It ends a loop alike in either arm. So a filter that fell more often in arm B, on its longer prompts, shortens arm B's rounds read but never adds a mismatch, and each seed's end is reported per arm, so such a lean is seen.

**What carries no verdict.**
- *The individual diagnostic*: live answers departing from the member's own table decision, compared the same way. It tests a stronger premise than the Lean's, each member a function of the forecast alone. Members exchanging rules round by round depart from their own decisions while every count stays the table's: the public is then a response of the forecast alone in the Lean's sense, and a verdict on the diagnostic would reject it.
- *The Lean's forbidden cases* in each loop from 0: where the table keeps the order, a fall, a pass above the least right value, and no rest by round 10; in any table, a right value followed by another; where it moves every value, a right value. Stage 0 showed that one flip in a thousand decisions makes some seed show a fall in 13 to 16 percent of runs on the memoryless join publics, so these are reported, not judged. One in a loop whose every count is the table's is a harness fault (above); so is a loop from the least right value, in arm A, that matches the table and moves.
- *The second start's cases*, against the candidate lemma.
- *The moving rounds* and each seed's end, per arm.

## 6. The pins and the endpoints

As freeze 3's ([FREEZE-3 §6](FREEZE-3.md#6-the-pins-and-the-endpoints)), unchanged: freeze 1's pins and rule, `google/gemini-4-argon` and `qwen/qwen3.8-max-0902` deciding, `anthropic/claude-sonnet-5.5` reported apart; one endpoint per pin, read from OpenRouter's public endpoint lists on 4 November 2026 ([`told-tr3/ENDPOINTS.json`](told-tr3/ENDPOINTS.json)), with no fallback. Every response must name the pin's model, the endpoint's provider, and the standard tier or none. The run stops at the first that does not, logging nothing. The reading refuses any logged record another model, provider or tier served. A difference of serving can make a decision flagged or a round mismatch, in both arms alike. It can void a framing, and could contradict V2 only by lining up with arm B's rounds, which are interleaved with arm A's in a seeded order.

## 7. The run and its reading

`told-tr6/tr6_run.py run --family PIN --max-usd N` refuses to start unless the pin's latest TR6 smoke run passed on the same frozen files, and both of these check:
- freeze 3's chain, as freeze 3's run reads it, which checks freeze 1's first;
- this freeze's chain: every file its newest link lists equals its hash and its commit.

Freeze 1's `run.execute` makes every call, with its stops ([FREEZE-1 §6](FREEZE-1.md#6-the-run)), and freeze 3's wrapper stops it at a response another provider or another tier served ([FREEZE-3 §7](FREEZE-3.md#7-the-run-and-its-reading)). The run writes only into `told-tr6/results/<pin>/`.

**The plan in rounds.** Each round is `tr6_design.derive` on the answers of the records made between two good catalog reads, less the calls those records hold, in a seeded order that interleaves arms, framings and presentations. The first round makes the 1,654 fixed calls and the loops' round 0 waits for the table. So a run makes the plan in twelve rounds, more where calls are made again: the fixed calls, then the loops' eleven, every loop side by side. A history reads only the latest record of a call, made between two good catalog reads, before its round began. Where the pin moves and comes back, the calls made since the last good read are made again, and the loops go on from their new answers ([FREEZE-3 §7](FREEZE-3.md#7-the-run-and-its-reading), whose rule this is).

**The reading.** `tr6_run.py verdicts <folder>` reads a folder through freeze 1's `verdicts.load`, given TR6's plan, prompt builder, parser and chain, so every refusal of freeze 1's reading holds ([FREEZE-3 §7](FREEZE-3.md#7-the-run-and-its-reading) lists them). Two more are TR6's:
- any logged record another provider or another tier served, as freeze 3's;
- any record whose logged prompt text is not the one its call rebuilds. Freeze 1's reading compares a record's prompt hash with the rebuild's. This compares the text too, so a prompt sent under a stale hash is found.

A loop whose records are not whole leaves its framing's V2 *partial*, and the rest is read. `verdicts.json` gives, per pin with its role and per framing:
- the outcome; the table and the flagged decisions; the shape, the right values, the orbit from 0 and its moving rounds, and the second start;
- the reading; the probes restated;
- V2, pooled and from 0 alone, with the mismatching rounds and the rounds read per arm;
- the individual diagnostic;
- each seed's end and moving rounds;
- the forbidden cases from 0, those against the lemma from the second start, and the counts from the least right value;
- the harness faults.

Beside the framings it gives the pilot's flips with the exact one-sided 95% upper bound on the flip rate, the no-forecast answers per presentation, the payoffs-not-told shares, the non-choices by arm, and the providers, tiers and system fingerprints that served the pin.

## 8. The smoke run and an addendum

`told-tr6/tr6_run.py smoke --family PIN --max-usd 1` makes sixteen calls per pin:
- a join choice and a lake choice;
- a probe;
- a choice with no forecast;
- an arm B choice with a two-Saturday course;
- a payoffs-not-told choice;
- the first of these, the member with cost 35 at join's forecast 3, asked ten times more.

It reads no outcome. Its report and its stop rule are freeze 3's ([FREEZE-3 §8](FREEZE-3.md#8-the-smoke-run-and-an-addendum)), with TR6's answers: no scored call is made for a pin where any smoke call is unanswered or rejected; names another model, provider or tier; comes where the catalog names another snapshot; is a choice that is neither an option nor a decline; or is a probe without its two integers. A decline does not stop it. The projection is at the plan's bound, 6,174 calls.

**An addendum** is a dated link of TR6's chain (`told-tr6/addenda/ADDENDUM-k.md` with `FROZEN-k.sha256`), read first by an independent reader and landed before the pin runs. It may change only these, and only for pins not yet run:
- the dry run and its output, to show a change;
- freeze 1's client, freeze 3's client and the endpoint lists it reads, where an addendum to freeze 1 or freeze 3 changed them and this freeze takes the change.

Nothing else can change: the members, a word a call shows, the plan, the rule and the run. TR6 imports freeze 3's request and freeze 1's reading of a choice, and takes their files only as their newest links have them. So an addendum to either leaves TR6's run refusing to start until a TR6 addendum takes the change, after checking that TR6's reading still reads every TR6 folder already made ([FREEZE-3 §8](FREEZE-3.md#8-the-smoke-run-and-an-addendum) gives the rule and what the reader checks of a changed client).

## 9. Usage and what Ren's yes releases

Calls per pin, from `tr6_run.py plan`. The tokens are an estimate: a call's prompt is about 700 to 1,050 characters with its schema, about 200 to 270 tokens in, plus about 30 for each Saturday of arm B's course, and its answer about 8 tokens out, before reasoning: about 1.0 million tokens in for 3,974 calls, and about 1.7 million at the bound.

| Part | Calls per pin |
|---|---|
| Offline table: 2 framings × 10 members × 11 forecasts × 5 presentations | 1,100 |
| Probes: 2 × 2 members × 11 | 44 |
| No-forecast control: 2 × 10 × 5 | 100 |
| Payoffs-not-told control: 11 forecasts × 5 presentations × 2 | 110 |
| Determinism pilot: 10 prompts × 30 | 300 |
| Fixed, in all | 1,654 |
| Loops from 0: 2 framings × 2 arms × 5 seeds × 11 rounds × 10 | at most 2,200 |
| From the least right value: 2 × 2 arms × 3 rounds × 10 | at most 120 |
| From a second start, where one is given | at most 2,200 |
| In all | 3,974 with every loop but a second start; at most 6,174 |

**The cost per pin** at the pins' listed prices ($2 a million tokens in; $10 out for Gemini and Sonnet, $6 for Qwen) is about $2.3 for 3,974 calls and $4 at the bound, before reasoning tokens. The three pins together come to about $7 to $12. Reasoning at low effort could raise that several times. The smoke run measures it, and the spend guard is set from its projection. Each invocation's guard also stops after 12,348 calls more than the folder holds, twice the plan's bound.

**What his yes releases, in order:**
1. The smoke run on each pin, 16 calls, each held under $1 by its spend guard.
2. TR6's run on each pin that passed it.

The verdicts come per pin by sections 4 and 5, and nothing is downloaded. TR6 needs nothing of freeze 1's or freeze 3's runs. It shares their clients, so the safe order is their smoke runs first, so that any client addendum they force lands before TR6's smoke run; or else TR6's runs made and read before any such addendum lands.

## 10. The dry run

[`told-tr6/tr6_dry_run.py`](told-tr6/tr6_dry_run.py) runs simulated publics through the frozen code, with no model called, in about ten minutes on one core. It writes [`told-tr6/results/dry-run.json`](told-tr6/results/dry-run.json), with the sha-256 of every file the freeze fixes recorded at its start and its end, which must be equal. The simulated members are Stage 0's: thresholds, memory rules and flips, each call independent, a member in arm B reading its course as the prompt shows it.

**The code path.** Nine publics went through the whole harness: freeze 1's `execute`, freeze 3's endpoint wrapper and a stub client answering in OpenRouter's shape, with some answers unreadable, filtered or declined. Each logged folder was read back through `tr6_run.load`. In all nine, the logged calls were the plan, and the verdicts equal the rule's on the same answers without the harness. Each made 3,754 to 4,854 calls in twelve rounds, but one: the public with a presentation lean was void in both framings, so its loops were not run, and it made the 1,654 fixed calls in one round. The publics:
- a reader of best replies (the forecast as the others): with no memory; with momentum under join and regret after a crowded round under lake; with trend reading; with members exchanging rules;
- a reader of the forecast as the count, with inertia; its second start, 4, ran under join;
- a deaf public, constant under both framings;
- a presentation lean, choosing the option listed first within 5 points of its threshold: void, 19 and 20 decisions flagged;
- declines from forecast 8 on: join's table 1 2 3 5 5 6 8 8 0 0 0, *neither*, its reading contradicted;
- a filter at an arm B round, with probes that miscompute at forecast 3: that seed ended, and both readings were *not read*, 20 of 22 probes restated.

**Refused or stopped**, each as it should be:
- a record's course edited;
- a logged answer the parser reads otherwise;
- a record another model, another provider or another tier answered;
- a call not in the plan;
- the offline records of one forecast dropped while the loops derived from them stay;
- a smoke folder;
- a planted line in an arm A prompt, both with its hash recomputed and with the frozen prompt's hash kept. The second only the text check finds.

A response another provider or tier served stops the run, logging nothing. A run stopped in its last round leaves those loops partial, with no harness fault. A lost closing read stops the run with 55 calls unread; the rerun's first read closes them, nothing is made again, and the folder is read with the plan their answers give. A pin that moved and came back has its 100 calls since the last good read made again. The stub then answers each choice among them with the other option, and the folder is read with the plan the later answers give. The chain, in stand-in git repositories, is read at its base and refused wherever an earlier freeze's file or TR6's rule changes without an addendum that may take it. A TR6 addendum changing its dry run is read. An addendum to freeze 3 changing its client is refused until a TR6 addendum takes it. The smoke run goes on as planned and with a decline, and stops at an unreadable choice, another provider and another tier. Eighteen response shapes are read as section 3 says.

**The shares**, 300 replications a row, through the frozen rule, beside Stage 0's for the same memory on its own public: the full climb for join, which is this public's best-reply table, and spread congestion for lake, whose orbit alternates as this one's does. Flips η = 1/1000 unless stated.

| Public and memory | V2 contradicted (Stage 0) | Mismatching rounds A / B | Void |
|---|---|---|---|
| join, memoryless, η 0, 1/1000, 1/100 | 0, 0, 0.02 (0, 0, 0.02) | 0 / 0, 0.56 / 0.50, 4.5 / 4.7 | 0, 0.003, 0.09 |
| join, inertia 0.1, 0.3 | 0.45, 1.00 (0.48, 0.99) | 0.59 / 5.4, 0.60 / 16.8 | 0.003, 0 |
| join, momentum 0.3, 1 | 0.82, 1 (0.84, 1) | 0.50 / 7.5, 0.58 / 15.2 | 0.003, 0 |
| join, trend reader 0.5 | 0.98 (0.98) | 0.54 / 10.5 | 0 |
| join, members exchanging rules | 0 (0); the diagnostic resolved in 1.0 | 0.54 / 0.59 | 0 |
| lake, memoryless, η 0, 1/1000, 1/100 | 0, 0, 0.017 (0, 0, 0.03) | 0 / 0, 0.61 / 0.56, 4.7 / 4.6 | 0, 0, 0.12 |
| lake, inertia 0.1, 0.3 | 1, 1 (1, 0.997) | 0.48 / 18.9, 0.52 / 17.4 | 0 |
| lake, regret after a crowded round 0.3, 1 | 0, 0 (0.003, 0) | 0.53 / 0.53, 0.61 / 0.49 | 0, 0.003 |
| lake, trend reader 0.5 | 1 (1) | 0.53 / 43.5 | 0 |
| lake, members exchanging rules | 0 (0); the diagnostic resolved in 0.26 | 0.52 / 0.48 | 0.007 |
| deaf; identity; hybrid (join) | 0; 0.003; 0 (0; 0; 0) | about 0.5 / 0.6 | 0 |

V1 read the deaf public as constant, the identity as the identity, and the hybrid as keeping the order, in every run, and none was a harness fault. On the memoryless join public at η = 1/1000, some seed in arm A shows a fall in 0.17 of runs (Stage 0: 0.16), which is why the Lean's forbidden cases carry no verdict. V2's false rate stays at or below 0.02 to η = 1/100, where a tenth of the tables are void. As in Stage 0, V2 resolves memory only where it changes counts on the orbit: regret after a crowded round changes nothing on lake's alternation between 0 and 10, and members exchanging rules change no count at all.

**What the readings move.**
- *The second start.* Under the public that reads the forecast as the count (join's table 0 1 2 3 5 5 6 8 8 9 10), the orbit from 0 rests at once, and the second start was 4 in the 299 runs not void. V2 caught inertia 0.3 in 0.027 of runs with it, and 0.007 from 0 alone. It caught momentum 1 in 0.32 and 0.26. The start adds one moving round, so it adds little: no start of this table moves in more.
- *The five presentations offline.* The presentation lean is void by the flag rule. With five identical offline requests it would not be flagged, and would raise both arms' mismatches instead.
- *Declines as not taking part.* The public declining from forecast 8 has a table, read, and V2 not contradicted; read as no answer, its decisions there would be flagged and the framing void.
- *An unreadable answer ends its seed.* The filter ended one arm B seed at its third round, so 47 of arm B's 55 rounds were read. V2 was read on them, and the end was reported.
- *The probes gate the reading.* Two probes miscomputed left both readings not read, and V2 as it was.

V2 needs at least 5, 7, 8 and 13 mismatching rounds of 55 in arm B where arm A has 0, 1, 2 and 5.

## 11. The lessons of earlier freezes, met

From [experiments/README](../README.md#freezing-a-test-on-a-trained-system):
- **Resolved differences only.** Verdicts rest on V2's count mismatches and on V1's table, not on the Lean's forbidden cases, which noise produces (section 5).
- **The law's own quantifier.** V2 counts every round of every loop, and V1 reads every member at every forecast, not an end state or one aggregate.
- **The system the test may meet.** The dry run meets Stage 0's publics and memory rules, and five more: a public reading the forecast as the count, one moved by the presentation, one that declines at high forecasts, one that miscomputes its points, and a filter in arm B.
- **Exploration apart from selection.** The second start's cases against the candidate lemma, the individual diagnostic and the controls are reported with no verdict.
- **Guarded support rules.** V1 reads flags, constancy and the identity before the shape, and the reading needs its probes. No reading supports a theorem: V2 is contradicted or not contradicted.
- **A control where a rival passes everything.** Members exchanging rules pass V2 and are a response of the forecast alone in the Lean's sense, so only the diagnostic shows them, with no verdict. A hybrid of readers and deaf members passes V1 and V2 and meets the premise. A public reading the forecast as an instruction is the identity, which V1 sets apart and the payoffs-not-told control shows.

## 12. What changed from the design, and what was chosen

From the design ([DESIGN §TR6](DESIGN.md#tr6-rf63-a-prediction-read-by-what-it-predicts-the-premise-and-the-bridge), [REST-TR3-TR6](REST-TR3-TR6.md#tr6-rf63-exact-values-power-check-rivals-and-usage)):
1. **The five offline calls are the five presentations** (section 4). The design said five calls and five presentation variants for the loops, without saying which the offline calls are.
2. **A decline is read as not taking part**, and an unreadable answer ends its loop, in either arm alike (section 3). The design said nothing of them.
3. **Loops only where no decision is flagged.** The design ran them in every case and read V2 only where none was. Not running them saves 1,160 to 2,260 calls a framing where it is void, and loses nothing a verdict reads.
4. **The second start**, a choice the design left for the freeze: given where the orbit from 0 moves in fewer than four rounds, from the start whose orbit moves most (section 5). Both arms run from it, since V2 compares arms. The design named arm B alone.
5. **The probes gate the reading, not V2** (section 4). The design listed them as a control.
6. **The costs**, a choice left for the freeze: one set of ten for both framings, chosen so that the best replies under either reading keep the order under join and reverse it under lake (section 1).
7. **The cover story**, a choice left for the freeze: a work day and a lake, in points, naming neither El Farol nor a bandwagon (section 2).
8. **No sampled arm**, a choice left for the freeze: a random response is outside the law, and the arm would add calls no verdict reads.
9. **The families**, a choice left for the freeze: freeze 1's pins, freeze 3's endpoints and request (sections 3 and 6). The design said the same harness and pins as TR3.
10. **The payoffs-not-told control** is asked of members alike, since without costs nothing tells them apart: 11 forecasts × 5 presentations × 2, the design's 110 calls, reported as a share.
11. **The prompt's text is checked** in the reading, beside freeze 1's check of its hash (section 7). The dry run found that a prompt sent under a stale hash passes freeze 1's check alone, and so freeze 3's. It matters only for a faulty prompt builder that keeps a stale hash, which the frozen check refuses before any scored call, so neither freeze takes an addendum; a dated note at the end of [FREEZE-1](FREEZE-1.md) and of [FREEZE-3](FREEZE-3.md) says so, at the coordinator's word.

**Not tested**, as in the design: probabilistic forecasts, retraining with losses, forecasters choosing what to publish, and verdicts from starts other than 0 or a right value.

## 13. An expectation, stated before any call

AI-written, an expectation, not a prediction any verdict reads. The deciding pins will likely meet V1 under lake, with a table reversing the order and an orbit alternating between high and low counts. Under join I expect the order kept, but cannot say from which reading members place themselves in the forecast, so whether the orbit from 0 climbs or rests at once, and whether the second start runs. V2, at temperature 0, I expect not contradicted under join, since a course rarely moves a decision far from its threshold. Under lake, where arm B's course shows a member crowded out and then alone, it may be contradicted, as Stage 0's trend reading was. Flags from the option order are the outcome I would least like and think most likely to void a framing.

## 14. Provenance and the reading of the freeze

AI-written, 4 November 2026, in one Claude Code session that owns board item RFZ. It was frozen after the design (board item RF, 31 October) and freeze 3 (TR3, landed the same day), whose harness it shares. Before the freeze landed, a reader other than its author read the frozen files in ROUNDS-N rounds, until nothing of high or medium severity remained: a fresh Claude Opus subagent read them whole in the first round and, from the second on, at the coordinator's word, the same reader read the diff of the last round's fixes and the sections they touch. It was given the files and the coordinator's requirements, not this session's conclusions, and worked read-only, with small checks of the code. It is of the theory's own family, as is every reader the session can call, and the deciding pins' families have read nothing here. Its findings and how each was taken are in [`told-tr6/REVIEW-FREEZE.md`](told-tr6/REVIEW-FREEZE.md). The freeze lands only once a round finds nothing of high or medium severity. [`told-tr6/write_frozen.py`](told-tr6/write_frozen.py) writes `FROZEN.sha256` on the merged tree, refusing unless the dry run passed on the same files, and that link is committed last.
