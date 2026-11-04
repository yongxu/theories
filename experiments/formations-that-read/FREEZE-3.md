# TR3, frozen

*The folder's third freeze, and board item RFZ's second, after FREEZE-1; 4 November 2026. AI-written (a Claude Code session), not yet reviewed by a person. Frozen before any call to a model: no model has been called with any of these prompts. The run is Ren's. About 90 to 115 minutes to read, at 100 to 130 words a minute; the first part takes thirteen to sixteen.*

## What is frozen, and what it can refute

**The standing first.** This test refutes a bridge, never a theorem and never a thesis. The law it bears on, [readers reading readers](../../theories/becoming/chapters/05-COLLECTIVES.md#r-readers-reading-readers) (RF4), with its premise asked only at the histories a world reaches ([a cascade at the histories reached](../../theories/becoming/chapters/05-COLLECTIVES.md#r-a-cascade-at-the-histories-reached), board item TRL), is proved in the pure core, and no run can move it. Members act in turn, each by its law on what couples into it and on the acts before it. Where every member from member k on, k included, gives one act for the couplings of two worlds at the list of acts the first of them gives it, and the two are alike through the couplings of the members before k, they give the same acts (`Turns.acts_alike_along`). Its modelling choices: members indexed by the naturals, each acting by a deterministic law of what couples into it and the acts before it; within them the theorem is close to definitional, proved by induction on the members. The game's eight players are the first eight members, and the later members are fixed laws that ignore what couples into them, which meet the premise trivially and leave the first eight acts as they are. What a run can move is a correspondence: whether language-model members, each a fresh call shown a private light and the earlier guesses, meet that premise along the histories the test reaches. That each call is the law's member there, a function of its prompt alone, the harness secures and the run does not test: a request carries its prompt and nothing else a call could read. The one way a call can fall short of it is to answer identical requests differently, and that almost always leaves a cell void or a difference unresolved, with no verdict (the chances are in section 5). Judged apart, a run can also move whether a named probabilistic model, Bikhchandani, Hirshleifer and Welch's (BHW), with a tie broken toward the member's own light, places when such members stop reading their light. That timing is BHW's prediction, not RF4's, which predicts no timing.

**The test.** Eight players guess in turn whether a machine is set to X or Y, each seeing a private light (green or red, right with chance 3 in 5) and every earlier guess, at two priors (1:1, and 3:2 for X). Each player is one fresh call, at temperature 0 for the two pins that decide; Sonnet, reported apart, takes no temperature and is called at its default sampling, where identical requests may differ more often. Six scripted prefixes fix the first guesses, (X,X), (Y,Y), (X,X,X) and (Y,Y,Y) at 1:1, (X) and (Y,Y,Y) at 3:2. From there the test follows the members:
- At each member, the test asks five times with each light.
- Where all ten calls give one guess, the member ignores its light there, and its guess extends the path.
- Where every member to the last ignores along the path, eight fresh sequences of lights are run. Two are all one light and six are drawn by a frozen seed.
- RF4, in its reached-history form (`Turns.acts_alike_along`), forbids a sequence whose guesses differ from the path's. A difference is asked again, five times in its own context and five in the premise's. It is a *reproduced breach* only where the two blocks are unanimous for their own answers.

Beside that, 33 cells (a prior and a list of earlier guesses) are each asked five times with each light. BHW's timing is *placed* where every cell's class is BHW's and its probes restate the light and the counts, and *contradicted* where a resolved cell's class differs from BHW's.

**What each outcome would change.**
- *Passed*: these members, here, are an instance of RF4 along those histories. Each call is fresh and stateless, so where the premise is met at temperature 0 a pass follows from it, up to the endpoint's nondeterminism. The fresh sequences check that identical requests are answered alike across the run, at the histories and in the order the walk reaches them. The leak control (section 5) checks that the re-ask resolves a difference where a prompt carries more than the light and the guesses and a member's guess turns on it; a passed control reads nothing of the re-ask.
- *Premise not met*, some member reading its light along the path: with k at that prefix, RF4 says nothing of these members; a later k is not sought by this walk, though the prefixes (X,X,X) and (Y,Y,Y) at 1:1 measure k = 3 on one branch each. Met after no prefix, the cascade reading of language-model pools narrows for them.
- *Void*, a cell neither ignoring nor reading at unanimity: residual nondeterminism at temperature 0, or answers that are not guesses (declines, filtered or unreadable answers), beyond what the test resolves; no verdict. The non-guesses are counted by kind (section 3).
- *Breach reproduced*: outside the leak control, two unanimous blocks of byte-identical requests that differ. No request carries anything that could tell the blocks apart, so this is read as a fault of the harness, as DESIGN.md reads it, or chance (below one in ten billion a difference for independent flips of 1/100). It is not read as RF4's forbidden case, nor as a channel in the member, and no reading is taken from that pin's run until the harness is checked.
- *Unresolved difference*: a difference that did not reproduce: nondeterminism or a non-guess; no verdict.
- *BHW placed*: these members' classes are BHW's at every cell, and naive counting's, which agrees with BHW on every one (Stage 0). *Contradicted*: BHW's timing, its ties broken toward the own light, fails for them. Where it fails only at the five tie cells, those at one net light of public evidence, the reading counts them and reads the cells beyond them as their own outcome. Only where all five ignore the light toward the public belief is it read as *contradicted at all five ties, toward the public belief*: these members ignore their light at one net light, where BHW reads it, and, where the cells beyond the ties are placed, from there on: a cascade one net guess earlier, which no timing cell at precision 3/5 tells from BHW breaking its ties toward the public belief. X, the name the prompt lists first, is the public belief at three of the ties and Y at two. A member that answers X wherever its light ties with the public evidence (a red light at the X-side ties, a green one at the Y-side), toward the public belief at the first three and with its own light at the other two, is read as *X at every tie*, not toward the public belief: a lean toward X, the name listed first and the setting a green light indicates, which the cells do not tell apart; Y likewise; any other pattern is read as a count, by side (section 4). A contradiction is recorded under the probabilistic form's debt, not as RF4's forbidden case.

**What is frozen** (hashes in [`told-tr3/FROZEN.sha256`](told-tr3/FROZEN.sha256)):
- the game, the cells, the prompts and the plan ([`told-tr3/tr3_design.py`](told-tr3/tr3_design.py));
- the request and the reading of an answer ([`told-tr3/tr3_client.py`](told-tr3/tr3_client.py)), with the endpoint lists as read ([`told-tr3/ENDPOINTS.json`](told-tr3/ENDPOINTS.json));
- the rule: a cell's class, BHW's timing and the walk ([`told-tr3/tr3_rule.py`](told-tr3/tr3_rule.py));
- the run in rounds and its reading ([`told-tr3/tr3_run.py`](told-tr3/tr3_run.py));
- Stage 0 ([`tr3.py`](tr3.py), [`tr3.json`](tr3.json));
- the dry run and its output ([`told-tr3/tr3_dry_run.py`](told-tr3/tr3_dry_run.py), [`told-tr3/results/dry-run.json`](told-tr3/results/dry-run.json)), and the hash file's writer ([`told-tr3/write_frozen.py`](told-tr3/write_frozen.py)), which refuses a dry run made on other files;
- every file of [freeze 1](FREEZE-1.md) that TR3 imports: its run, reading, client, rule, conditions and prompts, the pins ([`told/PINS.json`](told/PINS.json)), and [`tr8.py`](tr8.py) and [`tr_rr.py`](tr_rr.py), which its conditions import;
- this file, by its commit (section 14).

**What Ren's yes would release.** First the smoke run, sixteen calls per pin (section 8). Then, per pin, TR3's run: 1,546 fixed calls and those the walk reaches. That is at most 2,766 calls by construction, and about 1,900 for BHW, through OpenRouter with his key. At the pins' listed prices that is about $1.2 to $2.2 a pin before reasoning tokens, and $3.6 to $6.4 for the three (section 9). Each run has a spend guard. Nothing is downloaded, and the logs are kept whatever they show.

**What changed from the design, in one line each.** The full list, with reasons, is in section 12.
- The walk follows the guess a member ignores with, not a path planned in advance.
- BHW's timing reads every one of its 33 cells, and a cell counts only where its two probes restate the light and the counts.
- An answer that is not a guess (a decline, a filtered or an unreadable answer) is off class. There is no extra re-ask for it.
- The five exploration cells are asked and reported, with no prediction.
- Every call of a pin is routed to one serving endpoint, with no fallback, and every response must name that endpoint's provider and the standard tier or none.
- The six seeded sequences of a prefix are distinct.
- The determinism pilot is reported, with no stop rule.
- BHW's five tie cells are read apart and counted, by side.
- A difference by an answer that is not a guess is never a reproduced breach.
- The re-ask is no backstop for a channel outside the log: a breach outside the leak control is read as a fault of the harness or chance.
- Freeze 1's chain is checked before TR3's.
- The premise's lemma is proved (TRL), so the verdict no longer rests on an inference.

## 1. The game and the cells

The game is the urn game of [REST-TR3-TR6](REST-TR3-TR6.md#where-the-textbook-member-meets-the-premise), told as a machine with lights, so that the urn game is not named. A setting X or Y is chosen by a prior; each light is right with chance 3 in 5, drawn afresh; each player is paid only if their own guess is right. X is the theory's A and green its draw a; Y is B and red b. The precision is 3/5, where every overweighting rival parts from BHW at two net guesses (Stage 0). Those rivals lean toward the own light; the mirror lean, a member that leaves its light unless the odds for it reach 3:2, parts from BHW, among the 33 timing cells, at exactly the five tie cells, where BHW breaking its ties toward the public belief parts too (section 4). The second prior is worth one light for X (odds 3:2).

**The 33 timing cells**, with BHW's class (ties to its own light; [`tr3.json`](tr3.json), and recomputed in the dry run):

| Prior | BHW reads its light | BHW ignores it, guessing X | BHW ignores it, guessing Y |
|---|---|---|---|
| 1:1 (17 cells) | (), (X), (Y), (X,Y), (Y,X) | (X,X) to seven X | (Y,Y) to seven Y |
| 3:2 (16 cells) | (), (Y), (Y,X), (Y,Y) | (X) to seven X | (Y,Y,Y) to seven Y |

"Reads" means it follows its light. **Five exploration cells**, off BHW's path, are asked the same way and reported with no prediction: (X,X,Y), (Y,Y,X) and (X,X,X,Y) at 1:1, and (X,Y) and (X,X,Y) at 3:2. Naive counting and BHW could part at (X,X,X,Y) at 1:1 and at (X,X,Y) at 3:2, where BHW fixes no belief.

**For each of the 38 cells**: five guesses with each light; one comprehension probe with each light, asking the light and how many earlier guesses were X and how many Y; and five guesses with no light shown, the no-draw control.

**The rest of the fixed calls**:
- the determinism pilot, ten prompts asked 30 times each;
- the sampled arm, six cells asked 50 times with each light at temperature 1, reported only, since no stochastic form of RF4 is proved.

The first round also makes the leak control's first cell, (X,X) at 1:1 with the next player's light shown as green: ten calls, 1,556 in all.

## 2. The prompts

Every call is fresh and stateless: one user message, no system message, structured output. A prompt is printed by `tr3_design.build` from the prior, the earlier guesses, the light (or none) and, in the leak control alone, the next player's light. Nothing else enters it, so the prompt is the member's input in `Turns`. The reading rebuilds every logged prompt from its call, which is the design's input diff. Here is the third player at 1:1 after (X,X), with a red light:

> This is a guessing game with several players.
>
> A machine has been set to one of two settings, X or Y. The setting was chosen by the toss of a fair coin: X and Y were equally likely.
>
> The players take turns, one at a time. On their turn, each player privately sees one light from the machine, green or red. When the setting is X, a light is green with chance 3 in 5 and red with chance 2 in 5; when the setting is Y, a light is red with chance 3 in 5 and green with chance 2 in 5. Each player's light is drawn afresh, independently of every other light. Then the player announces a guess of the setting, X or Y. Every player hears every guess announced before their turn, but sees no other player's light. Each player is paid only if their own guess is right.
>
> You are player 3. The guesses announced before yours, in order from the first player: X, X. Your light is red.
>
> Announce your guess of the setting. Answer in JSON, with "choice": "X" or "Y".

The other prior reads "The setting was chosen by drawing one token from a bag of five tokens, three marked X and two marked Y: X had chance 3 in 5, and Y chance 2 in 5." The first player is told "You are the first to guess: no guess has been announced before yours." With no light shown, the sentence on the light is "Your light was not shown to you: you know only the guesses announced before yours." The probe ends "Do not guess yet. Answer in JSON:" with the three fields, "light", "earlier_X" and "earlier_Y". In the leak control a line is added before the question: "By an accident of the game, you have also been shown the light of the player after you: it is red." The schema of a guess offers exactly "X" and "Y". The order of the two names is fixed and not shuffled, since a member's act is its guess of the setting, not a position in a list. The presentation of the list is frozen, as the design asks.

## 3. The call and the reading of an answer

**The request** (`tr3_client.request`). Each call has:
- the prompt as the one user message;
- strict JSON schema;
- freeze 1's limit of 4,000 output tokens and low reasoning effort;
- temperature 0 where the pin takes a temperature, 1 in the sampled arm;
- where the pin takes a seed, one fixed by the prompt's own hash, so identical prompts are identical requests; in the sampled arm, by the call's identity too;
- one endpoint of the pin's provider, with no fallback, and OpenRouter told that the endpoint must take every parameter sent (section 6).

Sonnet takes neither temperature nor seed. It runs at its default sampling, and is reported apart in any case (section 6).

**Why identical requests.** The five calls of one cell and light are byte-identical requests. So a flip among them is residual nondeterminism at the endpoint, and nothing in the prompt or the request can explain it. A fresh sequence's call at the path's history and light is the same request as the cell's (section 5). The seed is one per prompt, so the pilot measures how reproducible one request is, not whether a cell's class depends on the seed. Where a provider's decoding at temperature 0 is not greedy, a near-tie cell's class could be set by its seed. That is still a law in `Turns`, a function of the prompt, and is read as one.

**The reading** (`tr3_client.classify`). A guess is read exactly as freeze 1 reads a choice ([FREEZE-1 §3](FREEZE-1.md#3-a-decline)):
- the schema's letter, X or Y;
- the model's refusal field as a decline;
- a content filter's stop with no whole answer, or a moderation rejection, as filtered;
- anything else as invalid.

The text of a reason is never read. A probe is read where its light is "green" or "red" and both counts are integers, not booleans; otherwise it is unread. Whether it restates the call's light and counts is decided by the rule, not the parser.

**An answer that is not a guess** (a decline, a filtered or an invalid answer) is no act. In a cell it counts against the cell's class, like a flip. In a fresh sequence it is a difference from the path's guess, which can be left unresolved and is never reproduced (section 5). Freeze 1 separates a decline from an unreadable answer because there a decline bears on a reading. Here no outcome turns on which kind of non-guess it was: none can make a cell ignore or read, or place BHW. So they are counted together, and reported by kind: per arm, per cell over both lights, under no class rule, per walk and in the leak control (`non_guesses` in `verdicts.json`). They cost power. A prefix of k guesses passes only where all 10(8 − k) calls of its path's cells and 8(8 − k) fresh calls are guesses: at a rate r of non-guesses a call, in about (1 − r)^(18(8 − k)) of runs, 0.42 for (X,X) at r = 0.8%. In one draw of the dry run's code path, where 0.8% of the answers to guesses are non-guesses, BHW passed no prefix, three void and three unresolved, where about 2.7 of the six pass on average.

## 4. The classes and BHW's timing

**A cell's class** (`tr3_rule.cell_class`). It is read from the five answers with each light.
- *C0*, for RF4's verdict, exact. All ten answers one guess: the cell *ignores* its light, "ignores X" or "ignores Y". Each light's five answers one guess and the two apart: it *reads* its light, "reads (follows)" where each guess is its light's, "reads (inverted)" otherwise. Anything else: *flagged*.
- *C1*, for BHW's timing: the same, with one answer of each light's five allowed off its class.
- A cell with an answer not yet logged has no class.

**BHW's timing** (`tr3_rule.timing`) reads all 33 cells under C1. A cell is *resolved* where it is not flagged and its two probes restate the light and both counts. The timing is:
- *placed* where every cell is resolved and its class is BHW's;
- *contradicted* where a resolved cell's class is not BHW's;
- *unresolved* otherwise;
- *partial* where a cell or a probe is not yet read.

The cells that differ, and those left unresolved with why, are listed.

**The ties, read apart** (`tr3_rule.tie_reading`). At five cells BHW's posterior ties at one light, since the light exactly offsets the evidence before it: (X) and (Y) at 1:1; the empty history, (Y,X) and (Y,Y) at 3:2. These are the cells at one net light of public evidence, the prior counted as one light for X. With ties to its own light BHW reads there, and ignores its light from two net lights on. A member that ignores its light there, toward the public belief, cascades one net guess earlier, at one net light. BHW breaking its ties toward the public belief, the prior and the guesses, does so, and so does a member that leaves its light unless the odds for it reach 3:2, weighing its own light below a public one. At precision 3/5 the two have the same classes at the 33 timing cells, whether the second reads the earlier guesses as made by members like itself or as BHW does, and at all 38 cells in the first case; read as BHW reads, it differs at the five exploration cells (the dry run checks each). So no timing cell tells a tie convention from a lean toward the public; what the cells show is the timing, one net guess earlier. The timing is therefore also read over the 28 cells beyond the ties, at no net light and at two and more, where a cascade at one net light and one at two agree. Each tie cell is counted: toward the public belief, with the own light, flagged, its probes not restated, or otherwise, beside BHW's class and the class toward the public belief. The public belief is X, the name the prompt lists first and the setting a green light indicates, at three of the ties, (X) at 1:1, the empty history and (Y,X) at 3:2, and Y at two, (Y) at 1:1 and (Y,Y) at 3:2. A member that answers X wherever its light ties with the public evidence, a red light at the X-side ties and a green one at the Y-side, is toward the public belief at the first three and with its own light at the other two; one that answers Y there is the mirror. A member that answers X with both lights at every tie is read otherwise at the Y side, and so *not toward the public belief*. So the sides are counted apart, each with how many of its ties went toward the public belief and how many with the own light. Where the timing is contradicted, not beyond the ties, the reading is:
- *contradicted at all five ties, toward the public belief*, where every tie cell is resolved toward it: the member ignores its light at one net light, where BHW reads it, and, where the cells beyond the ties are placed, from there on, a cascade one net guess earlier;
- *contradicted at the ties, not toward the public belief*, with the counts, those otherwise among them, where a resolved tie cell is neither BHW's class nor the class toward the public belief;
- *contradicted at the ties, X at every tie, not toward the public belief*, where the three X-side ties are toward the public belief and the two Y-side ties with the own light: a lean toward X at the ties, which does not tell the name listed first from the setting a green light indicates; and *Y at every tie* for the mirror;
- else *contradicted at k of the five ties, toward the public belief*, with the counts: no cascade one net guess earlier is read. Where one side is toward the public belief and the other is unresolved, the pattern fits a lean toward the public belief as well as one toward that side's name.

Each gives the timing beyond the ties as its own outcome, and each is a contradiction of BHW's timing as the design names it. In the dry run, BHW with ties toward the public belief and the member that leaves its light unless the odds for it reach 3:2 are read at all five ties in every run, placed beyond the ties; BHW breaking its ties toward X is read as X at every tie in every run; and BHW with coin ties, whose tie cells are flagged more often than not, is read as a count short of five in 0.638 of runs and unresolved in nearly all the rest (section 10).

**Why C1 here and C0 for RF4.** This follows the design ([REST-TR3-TR6, the power check](REST-TR3-TR6.md#the-power-check)). C1 keeps BHW placeable under residual nondeterminism up to 1/100 a call, 0.94 placed. The price is placing a member that reads its light one time in ten, in the cells where BHW ignores, in 14% of runs. RF4's premise is exact, so its verdict keeps unanimity.

**Why the probe gates a cell.** A member that misreads its light or the counts is not a member that ignores them. The design scored the probe apart, so that a member that fails to parse is not counted as one that ignores. Here a cell whose probe does not restate is left unresolved: it can neither place BHW nor contradict it. That costs power. Each of the 66 probes must restate for a placement, so where probes fail at a rate q, a member BHW would place is placed in about (1 − q)^66 of runs: 0.52 at q = 1/100, and 0.036 in the dry run at q = 1/20. At temperature 0 a probe's failure is more likely systematic than random, a model that miscounts long lists say, and there the timing should stay unresolved.

**RF4's verdict reads no probe.** RF4 concerns acts given prompts. A member whose guess does not depend on its light meets the premise, whatever the reason. The probes' counts are reported beside it.

## 5. RF4's conditional verdict: the walk, and the leak control

`tr3_rule.walk` follows one prefix of k scripted guesses, from member k to the eighth and last.
1. **The path.** At each member, the cell at the history the path has reached, under C0. Where it ignores, its guess extends the path. Where it reads, the outcome is *premise not met*. Where it is flagged, it is *void: a flagged cell*.
2. **The premise.** Every member from k on ignores its light at the path's history, with both lights. Then any two assignments of lights after the prefix meet the premise of `Turns.acts_alike_along` (`Turns.LawAlikeAlong`, [`Becoming.ReachedCascade`](../integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReachedCascade.lean)). The first assignment reaches the path, member by member, and at each member's history on it the member gives one guess for either light. `Turns.acts_alike_along` then forbids lights whose guesses differ from the path's.
3. **The fresh sequences.** Eight sequences of lights for members k to the last: all green, all red, and six others drawn without replacement by a frozen seed, so that no two of a prefix are alike. Each is run one call a member and stops at its first answer that differs from the path's guess: the other guess, or no guess.
4. **The re-ask.** That member is asked five times more in the sequence's own context and five times in the premise's (the path's history and the same light). The difference is a *reproduced breach* only where the sequence's answer is a guess, X or Y, the first block is unanimous for it and the second for the path's guess. Otherwise it is an *unresolved difference*. A difference by a non-guess is never reproduced: inside the leak control the two blocks' prompts differ, and a member that declines on one of them is not one whose guess the shown light changes.
5. **The outcome**: *breach reproduced* where any difference reproduces; *unresolved difference* where some difference does not and none does; *passed* where no sequence differs; *partial* where a call it needs is not yet read.

**The two contexts are one request.** Outside the leak control, a fresh call and the premise's call at the same member are the same prompt: the path's history and the same light. So a reproduced breach there is ten byte-identical requests, made in one round and shuffled together, falling into two unanimous blocks that differ. A member in `Turns` that flips at random does that almost never: for independent flips at a rate η, about η⁵ a difference, below one in ten billion at 1/100. A request that flips half the time gives 2⁻¹⁰ a difference, but in most runs its cell is flagged before any sequence is run. Nor can anything outside the request line the blocks up with their labels. A change at the endpoint during the run, a cache or a swap of weights falls on both blocks alike and leaves the difference unresolved. So outside the leak control a reproduced breach is read as a fault of the harness, as DESIGN.md reads it and the first part says. The fresh sequences check something else: that identical requests are answered alike across the run, at the histories and in the order the walk reaches them. That the harness puts in a prompt only what its call names, the input diff checks (section 7).

**Why the walk follows the guess.** The design planned each prefix's path in advance: (X,X), then (X,X,X), and so on, the cells where BHW's guess copies the prefix. A member that ignores its light with the other guess, constant Y after (X,X) say, reaches cells the plan does not hold. A walk held to the planned cells could not read it. Following the guess the member ignores with reads RF4's premise where the member actually goes. In the dry run, constant Y after (X,X) passes in every replication. Where the path leaves the fixed cells, its cells are new calls of the plan (section 7).

**The leak control.** The walk for prefix (X,X) at 1:1 again, with the next player's light shown in every call of a member before the last:
- in the premise's cells and its re-asks, as green;
- in a fresh sequence, as the sequence's own next light.

A member that follows the shown light differs where the next light is red, and the re-ask reproduces it. A member that does not read it passes. So the control is a positive control of the re-ask only for a member whose guess the shown light changes. A member that weighs the shown light as one more light, as BHW weighs its own, changes its guess along (X,X) only where its own light and the shown one are both red and together offset the two guesses, and there only where it breaks the tie toward its own light; breaking it toward the public belief, it passes the control as it passes the walk. So a reproduced breach in the control shows that the re-ask resolves a difference the prompt carries, and a pass reads nothing of the re-ask. It shows nothing of a channel outside the prompt, which no request carries. The last member has no next player and is shown none, so its cell is the walk's own. Its outcome is reported, and it moves neither RF4's verdict nor BHW's timing. In the dry run, a member that follows the shown light is a reproduced breach in every replication, and so is one that weighs it and ties to its own light; one that weighs it and ties toward the public belief passes, as BHW does.

**What the walk cannot show.** A member deaf to its light from the empty history on meets RF4's premise trivially along every path, and is no cascade: it never read its light and then stopped. That is why the empty-history cells and BHW's timing are read beside it. A pass says nothing of the histories the walk does not reach.

## 6. The pins and the endpoints

**The pins are freeze 1's** ([FREEZE-1 §5](FREEZE-1.md#5-the-pins), [`told/PINS.json`](told/PINS.json)), unchanged, and freeze 1's rule decides who moves a reading. Two families that neither wrote nor read the theory decide: `google/gemini-4-argon` and `qwen/qwen3.8-max-0902`. The theory's own families are those whose models wrote or read it: Anthropic's Claude wrote it, OpenAI's models reviewed it, and DeepSeek's and xAI's models discussed its early argument. A pin of one of them, here `anthropic/claude-sonnet-5.5`, is reported apart and moves nothing alone. So no family that wrote or read the theory decides TR3's verdict alone. Every response must name the pin's model, and the provider of its endpoint. The catalog is read at the start, every 100 calls and at the end, and a record is read only between two reads naming the frozen snapshot (freeze 1's `served_ok`, `bracketed` and `resume`).

**One endpoint per pin.** Read from OpenRouter's public endpoint lists on 4 November 2026, with no key and no model call. The lists as read, and why each endpoint, are in [`told-tr3/ENDPOINTS.json`](told-tr3/ENDPOINTS.json).

| Pin | Endpoint | Its provider | It serves | Takes temperature and seed |
|---|---|---|---|---|
| `google/gemini-4-argon` | `google-vertex/global`, with `google-vertex/global/priority` ignored | Google | `google/gemini-4-argon-20261013` | yes |
| `qwen/qwen3.8-max-0902` | `alibaba`, with `alibaba/us-east-1` ignored | Alibaba | `qwen/qwen3.8-max-20260902` | yes |
| `anthropic/claude-sonnet-5.5` | `anthropic` | Anthropic | `anthropic/claude-sonnet-5.5-20260928` | no |

The request names the endpoint as the only provider, with fallbacks off, so a call the endpoint cannot serve fails rather than going elsewhere. Freeze 1 let OpenRouter route a pin among its providers. TR3 reads unanimity among identical requests, and requests spread across serving stacks would add their differences to the flips the test counts. Each one is the model's own provider's standard endpoint, not a flex or priority tier and not another host, and none lists implicit caching: a cache's hit or miss is a difference of serving that depends on order, the kind one endpoint is chosen to avoid. OpenRouter's routing page, read the same day, states the rule: a slug names every endpoint below it, but dropping a tier never names a tier endpoint; it also says some priority endpoints match their base slug. So each route ignores by name every tier endpoint below its slug, and names one endpoint under either reading. OpenRouter's slug `alibaba` names both of Qwen's Alibaba endpoints, and `alibaba/us-east-1` lists implicit caching, so Qwen's route orders `alibaba` and ignores `alibaba/us-east-1`. A base slug, Qwen's `alibaba` and Sonnet's `anthropic`, would also name an endpoint of that provider added after the lists were read, and one endpoint may itself be served from more than one place: a global endpoint may route among regions. No response shows either. So one endpoint narrows the serving stacks a pin's calls meet, without making them one. A difference of serving almost always makes a cell void or a difference unresolved, so it can cost a verdict and almost never make one: the calls are shuffled, and it would have to line up with the lights by chance. The dry run checks the lists against that rule, under both readings: each route names exactly one listed endpoint, serving the pin's dated snapshot, of the standard tier, listing no implicit caching, taking every parameter the request sends, and named by the provider the run checks. It checks the lists as read, not OpenRouter's behaviour, which only a call shows. The rule's pages are named in `ENDPOINTS.json`.

**What is checked of the endpoint, and what is not.** A response states two serving facts: the provider it names, and the tier it reports (`service_tier`, standard or none). The run stops at the first response another provider or another tier served and logs nothing for it; the smoke run's stop rule takes one, so no scored call is made; the reading refuses any logged record another provider or tier served; the verdicts report the providers, the tiers and the system fingerprints the responses give. The provider is read from the response's top-level `provider`, which OpenRouter's documented response schema, read on 4 November, does not list. If responses carry none, the smoke run's stop rule takes them, before any scored call. An addendum may then read each response's provider and tier from OpenRouter's generation record for it (`GET /api/v1/generation?id=`, whose documented `provider_name` is the provider that served the request, and `service_tier` its tier; read on 4 November with no key, and named in `ENDPOINTS.json`), one more request per call and no model call (section 8). Where that names none either, TR3 does not run on that pin. A response does not state the endpoint's region or caching, so the test cannot verify them: they rest on the route and on OpenRouter keeping to it.

**An endpoint withdrawn.** Before a pin's run, a withdrawn endpoint is a stop that comes back on every resume, and an addendum may then name another (section 8). During a pin's run it ends that pin's TR3, since an addendum naming another endpoint would change the requests the reading rebuilds for calls already made. The pin's folder is read as it stands, under the link it ran with, its verdicts partial where calls are missing.

## 7. The run and its reading

`told-tr3/tr3_run.py run --family PIN --max-usd N` refuses to start unless:
- the pin's latest TR3 smoke run passed on the same frozen files;
- freeze 1's own chain checks: its files are as freeze 1's newest link has them;
- every file the newest link of TR3's chain lists equals its hash and its commit, freeze 1's imported files among them.

Freeze 1's `run.execute` makes every call, with its stops ([FREEZE-1 §6](FREEZE-1.md#6-the-run)). It stops at a call no retry answers, at another model, at a catalog that names another snapshot, at a request whose messages are not the frozen prompt, and at a failed attempt returned as an answer. TR3's run also stops at a response another provider or another tier served (section 6). It pauses at 20 filtered answers in a row, and the spend guard stops it. The run writes only into `told-tr3/results/<pin>/`, and a folder holding another run's calls is refused.

**The plan in rounds.** The plan depends on answers: a path's next cell on the class before it, a fresh sequence's next call on its last answer, a re-ask on a difference. So the run makes it in rounds. Each round is `tr3_design.derive` on the answers of the records made between two good catalog reads, less the calls those records hold, in a seeded order. The run ends when a round has nothing to make: at most 14 rounds by construction, reached only by prefix (X) at 3:2: one for the fixed calls, which hold its first two path cells, five for the rest of its path, seven for a sequence's members and one for re-asks. The dry run took 1 to 13. The plan is at most 2,766 calls (section 9). The first round makes the 1,546 fixed calls and the leak control's first cell, interleaved.

**Which record a history reads.** Freeze 1 asks a later freeze whose calls carry earlier answers to say which record of a call made again its history reads ([FREEZE-1 §6](FREEZE-1.md#6-the-run)). Here a history reads only the latest record of a call, and only where that record was made between two good catalog reads. Each round derives its calls from such records alone, made before the round began, so a record outside good reads never enters a history. Where the pin moves and comes back, the calls made since the last good read are made again, as freeze 1's resume does. The plan then goes on from their new answers. The calls derived from them come in later rounds, so none was derived from the answers left unread. In the dry run, a pin that moved at the twelfth read and came back had its 100 calls made again, each guess among them answered with the other act, and the folder was read with the plan the later answers give.

**The reading.** `tr3_run.py verdicts <folder>` reads a folder through freeze 1's `verdicts.load`, given TR3's plan, prompt builder, parser and chain. So every refusal of freeze 1's reading holds here ([FREEZE-1 §6](FREEZE-1.md#6-the-run)). Among them:
- a record whose fields, prompt or request differ from those its id rebuilds: the input diff;
- a record whose answer the parser reads otherwise;
- a record another model answered;
- any logged record another provider or another tier served, read or not;
- a call logged again after a good record of it;
- a smoke or dry folder.

The plan it is given is `derive` on the folder's own good records. So a record the walk did not reach on those answers, a record left behind where a cell's records were dropped say, is refused as not in the plan. A run stopped partway leaves the verdicts that need its missing calls *partial* and the others read. `verdicts.json` gives, per pin with its role:
- BHW's timing, with each cell's class under C0 and C1, the cells that differ and those unresolved;
- the timing read at the ties and beyond them (`timing_at_the_ties`), with the five tie cells counted, the X side and the Y side apart;
- each prefix's outcome, with its path and its differences;
- the leak control's outcome;
- the pilot's flips, with the exact one-sided 95% upper bound on the flip rate;
- the probes restated;
- the non-guesses by kind, per arm, cell and walk;
- the providers and tiers that served the pin, and the system fingerprints its responses give;
- the no-draw answers;
- the sampled arm's shares and their difference with a 95% half-width, reported only.

## 8. The smoke run and an addendum

`told-tr3/tr3_run.py smoke --family PIN --max-usd 1` makes sixteen calls per pin at 1:1 after (X,Y,X), a history in no cell:
- a guess with each light;
- a probe;
- a guess with no light;
- a sampled guess;
- a guess with the next light shown;
- the first of these, a guess with a green light, asked ten times more.

It reads no outcome. Like `run`, it refuses to start unless the frozen files are as committed, and its meta keeps their hashes. Its report, `smoke-report.json`, records:
- the models the responses name, the providers and tiers that served them, and their system fingerprints;
- the snapshot the catalog names at each read;
- the declines;
- the eleven answers to one request, the first call and its ten repeats, and whether they are alike;
- the tokens and cost per call;
- a projection at the plan's bound: the first round's 1,556 calls and 1,210 reached.

**Its stop rule.** No scored call is made for a pin where any smoke call:
- is unanswered or rejected;
- names another model, another provider than its endpoint's, or a tier other than the standard one or none;
- comes where the catalog names another snapshot;
- is a guess that is not X, Y or a decline;
- is a probe without its three fields.

A decline does not stop it. Freeze 1's smoke run stops on no decline ([FREEZE-1 §8](FREEZE-1.md#8-the-smoke-run)), and here a decline is a non-guess, which the reading counts by kind (section 3); no addendum could change it, since the prompts are fixed. A pin that declines throughout is run: its walks are void and its timing unresolved. The ten repeats are reported and stop nothing: the full run is spent whatever they show (section 12).

**An addendum**, as freeze 1's ([FREEZE-1 §8](FREEZE-1.md#8-the-smoke-run)): a dated link of TR3's chain (`told-tr3/addenda/ADDENDUM-k.md` with `FROZEN-k.sha256`), read first by an independent reader, landed before the pin runs. It may change only these, and only for pins not yet run:
- `tr3_client.py`'s request mechanics and its reading of a provider's response shapes, a pin's endpoint among them;
- `ENDPOINTS.json`, read again where an endpoint changes;
- the dry run and its output, to show the change;
- freeze 1's client, where an addendum to freeze 1 changed it;
- in PINS.json, a pin's `served_as`, where an addendum to freeze 1 changed it.

`run.chain` refuses a link that changes any other file the link before lists, so nothing else can change: the game, a word a call shows, the cells, the sequences, the classes, the rule, the plan and the run. A change to a pin already run would change a rebuilt request or a re-read answer, and the reading would refuse its folder. The code fixes files, not what a changed client does. So an independent reader checks a changed client:
- it imports nothing new and assigns nothing in another module;
- the prompt and the schema reach the model unchanged;
- its request fields add no words a model reads;
- it still reads a guess as freeze 1 reads a choice;
- it returns the inner client's response unaltered;
- it still checks the provider and the tier of every response, from the response or, where it names none, from its generation record (section 6).

**Freeze 1's files are shared.** TR3 imports freeze 1's client: its token limit, its reasoning setting and its reading of a choice enter every TR3 request and reading. TR3's check takes freeze 1's files only as freeze 1's newest link has them, so an addendum to freeze 1 that changes the client or PINS.json leaves TR3's run refusing to start (section 7) until a TR3 addendum takes the change. A TR3 addendum takes it only where TR3's reading, with the change, still reads every TR3 folder already made without a refusal: a change to the token limit, the reasoning setting or how a logged response shape reads could otherwise refuse a pin already run. Where it would, either the change waits until TR3's runs are made and read, or TR3 does not take it, and TR3's remaining runs and its readings are made in a checkout of the commit of TR3's newest link, where both chains check.

## 9. Usage and what Ren's yes releases

Calls per pin, from `tr3_run.py plan` and the walk's bound. The tokens are an estimate: a guess's prompt is 1,085 to 1,234 characters with its schema, about 300 to 350 tokens in, and its answer about 8 tokens out, before reasoning.

| Part | Calls per pin |
|---|---|
| Cells: 38 × 2 lights × 5 | 380 |
| Probes: 38 × 2 | 76 |
| No-draw control: 38 × 5 | 190 |
| Determinism pilot: 10 prompts × 30 | 300 |
| Sampled arm: 6 cells × 2 lights × 50, reported only | 600 |
| Fixed, in all | 1,546 |
| The leak control's first cell, in the first round: 2 lights × 5 | 10 |
| Reached by the walk, for six prefixes and the leak control: path cells after each walk's first, fresh sequences, re-asks | at most 1,210 |
| In all | at most 2,766; 1,916 for BHW with no flips; 1,556 to 2,131 for the dry run's members |

**The cost per pin** at the pins' listed prices is about $1.2 to $2.2 before reasoning tokens, for about 1,900 to 2,766 calls, and $3.6 to $6.4 for the three pins. Reasoning at low effort could raise that several times; the smoke run measures it, and the spend guard is set from its projection. Each invocation's guard also stops after 3,092 calls more than the folder already holds, twice the fixed calls and above the plan's bound. A call stopped for another provider or tier is not logged and the guard does not count it: at most one per parallel worker, since the run stops there.

**What his yes releases, in order:**
1. The smoke run on each pin.
2. TR3's run on each pin that passed it.

The verdicts come per pin by sections 4 and 5, and nothing is downloaded. TR3 needs nothing of freeze 1's runs, and they need nothing of it, but the two share freeze 1's client (section 8). So the safe order is freeze 1's smoke runs first, so that any client addendum they force lands before TR3's smoke run; or else TR3's runs made and read before any such addendum lands. In either order the two can be released apart.

## 10. The dry run

`told-tr3/tr3_dry_run.py` sends Stage 0's simulated members through the frozen code, and no model is called. Its output is [`told-tr3/results/dry-run.json`](told-tr3/results/dry-run.json).

**The code path.** For each of eight members, `tr3_run.rounds` makes the whole plan through freeze 1's `run.execute` and a stub client: prompts built, responses in OpenRouter's shape. 0.4% of guesses are unreadable, 0.2% filtered, 0.2% declined, and 1% of probes are unreadable. The members:
- BHW;
- BHW flipping 1 call in 100;
- a hybrid reading its light 1 time in 10;
- constant X;
- constant Y;
- one that always guesses its light;
- one that reads a leak shown to it;
- one that guesses the next player's light where none is shown, from the call's labels. No endpoint could, since a request carries only its prompt: its rows show the rule's arithmetic, as Stage 0's leaky rows do, not a channel a real member could have.

The log is written to disk and read back through freeze 1's reading. In all eight, the logged calls are exactly the plan, and the verdicts equal the same rule's on the same answers without the harness. These runs took 1,556 to 2,131 calls in 1 to 13 rounds.

**Refused**:
- a planted leak in the harness, the next player's light in a fresh sequence's prompt, found by the input diff;
- a record's history edited;
- a logged answer the parser reads otherwise;
- a record another model answered;
- a record another provider served, or another tier;
- an unread record another provider served, where the same record with the endpoint's provider is read;
- a call not in the plan;
- a path cell's records dropped while the calls derived from them stay;
- a smoke folder.

**Read**:
- A run stopped in its last round leaves the verdicts that reach its missing calls partial and the rest as before.
- A round's closing read lost: the run stops, and a rerun's first catalog read closes the calls after the last good read, with nothing made again.
- A pin that moved and came back: section 7.
- A response another provider or another tier served: the run stops, and nothing is logged for it.

**Also checked**:
- 18 response shapes for the reading of a guess and a probe;
- BHW's classes at the 33 cells, recomputed from `tr3.py`'s `FilterType`, with the exploration cells off its path; BHW breaking its ties toward the public belief differs from them at exactly the five tie cells, with the classes `TIES` gives; and a member that leaves its light unless the odds for it reach 3:2 has that member's classes at all 38 cells, and, reading the earlier guesses as BHW does, at the 33 timing cells and at none of the exploration cells; and BHW breaking its ties toward X has the class toward the public belief at the three X-side ties and BHW's elsewhere;
- each pin's route against its list as read, under both readings of the slug rule (section 6);
- the smoke run's stop rule, through the stub: as planned and with a decline it goes on, with an unreadable guess, another provider or another tier it says to stop, and the ten repeats are reported;
- the sha-256 of every frozen file but the output, at the start and at the end of the run, equal; the hash file is written only where they equal the files it hashes;
- TR3's chain, in stand-in git repositories with freeze 1's folder and chain beside it, read as the run reads them, freeze 1's chain first. The base link is read. Refused: a freeze 1 file changed with no addendum; a TR3 addendum changing TR3's rule, freeze 1's run, or freeze 1's client where freeze 1's chain has not taken it; an addendum to freeze 1 changing its client, before TR3 takes it. Read: a TR3 addendum changing TR3's client; freeze 1's client changed by an addendum to freeze 1 and taken by a TR3 addendum.

**The shares**, beside Stage 0's ([REST-TR3-TR6, the power check](REST-TR3-TR6.md#the-power-check)), through the frozen walk and rule.

RF4's verdict, prefix (X,X), 4,000 replications per member:

| Member | Void: a flagged cell | Passed | Breach reproduced | Unresolved difference | Stage 0's largest difference |
|---|---|---|---|---|---|
| BHW | 0 | 1 | 0 | 0 | 0 |
| BHW, flips 1/1000 | 0.048 | 0.909 | 0 | 0.044 | 0.012 |
| BHW, flips 1/200 | 0.267 | 0.589 | 0 | 0.144 | 0.024 |
| BHW, flips 1/100 | 0.451 | 0.334 | 0 | 0.216 | 0.020 |
| BHW, flips 1/20 | 0.956 | 0.005 | 0 | 0.039 | 0.005 |
| Hybrid, its light w.p. 1/20 | 0.795 | 0.061 | 0 | 0.144 | 0.003 |
| Hybrid, 1/10 | 0.960 | 0.002 | 0 | 0.038 | 0.001 |
| Hybrid, 1/4 (premise not met 0.002) | 0.998 | 0 | 0 | 0.0003 | 0.001 |
| Majority copier; constant X | 0 | 1 | 0 | 0 | 0 |
| Guesses the next player's light, from the call's labels | 0 | 0 | 1 | 0 | 0 |
| The same, w.p. 1/2 | 0 | 0 | 0.159 | 0.841 | 0.005 |
| Always its light (premise not met 1) | 0 | 0 | 0 | 0 | 0 |

For BHW with flips the shares are exact: each call flips alone, 60 cell calls and then 48 fresh ones. The dry run's twelve shares lie within 2.92 standard errors of them, the largest the flagged share at 1/1000 (`z` in the output), and Stage 0's within 2.08.

BHW's timing, both priors, under C1, 2,000 replications per member, every probe restating:

| Member | Placed | Contradicted | Stage 0, placed and contradicted |
|---|---|---|---|
| BHW | 1 | 0 | 1, 0 |
| BHW, flips 1/100 | 0.936 | 0 | 0.937, 0 |
| BHW, flips 3/100 | 0.572 | 0 | 0.570, 0.0002 |
| Overweighting 2:1, flips up to 3/100 | 0 | 1 | 0, 1 |
| Hybrid 1/5 | 0.001 | 0.157 | 0.0007, 0.083 |
| Hybrid 1/10 | 0.139 | 0.012 | 0.130, 0.009 |
| BHW, ties toward the public belief | 0 | 1 | not run |
| BHW, coin ties | 0.0005 | 0.639 | not run |
| Leaves its light unless the odds for it reach 3:2 | 0 | 1 | not run |
| BHW, ties to X, the name listed first | 0 | 1 | not run |

Read at the ties (section 4), BHW with ties toward the public belief and the member that leaves its light unless the odds for it reach 3:2 are each read as contradicted at all five ties, toward the public belief, placed beyond the ties, in every run; at flips of 1/100, at all five in 0.986 and 0.990 of runs, 0.935 of each with the cells beyond the ties placed, the rest as a count. BHW breaking its ties toward X is read as X at every tie in every run, and in 0.987 at flips of 1/100, the rest as a count. BHW with coin ties is read as a count short of five in 0.638 of runs, at all five in 0.0005, and unresolved in 0.361. Every other member's contradiction is beyond the ties, and BHW with ties to its own light is placed as before.

**What the frozen readings move.**
- *Every cell read.* Stage 0 followed each path along BHW's prediction and stopped it at a flagged cell. The frozen rule asks every cell, since they are fixed calls, and reads each. So a hybrid is contradicted about twice as often, 0.157 against 0.083 at 1/5, with BHW's placement unchanged.
- *The walk follows the guess.* Constant Y after (X,X) passes in every replication. A walk held to the planned cells would read nothing of it.
- *The probe gate.* BHW with probes failing in 5% of calls is placed in 0.036 of 2,000 runs, and unresolved in the rest, never contradicted.
- *The leak control.* A member that follows the light shown to it is a reproduced breach in all 200 replications, and so is one that weighs it as one more light and ties to its own; one that weighs it and ties toward the public belief passes in all 200, as BHW does. One that declines where it is shown a red light differs by a non-guess, and is an unresolved difference in all 200, never a breach.
- *Distinct sequences.* This freeze's first draft drew the six sequences with replacement by its seed. For (X,X) it gave three alike, all red, so only six of eight differed. Drawn without replacement, the half-leaky member's breach share is 0.159, against Stage 0's 0.155, where Stage 0 drew fresh sequences each replication.

## 11. The lessons of earlier freezes, met

The six lessons in [experiments/README](../README.md#freezing-a-test-on-a-trained-system), and the two freeze 1 added there:

1. **A verdict only on a resolved difference.** RF4's verdict needs ten unanimous calls at every member of the path. A breach needs two unanimous blocks of five that differ. BHW's timing reads a cell only where it is not flagged under C1 and its probes restate.
2. **The law's own quantifier.** Every member from k to the last, with both lights, at the history the path reaches. A sequence counts at its first difference, which is what the forbidden case is. BHW's rule reads all 33 cells.
3. **The system the test may meet.** The dry run has:
   - BHW, with flips from 1/1000 to 1/20;
   - hybrids from 1/20 to 1/4;
   - overweighting;
   - copiers and constants;
   - one that always guesses its light;
   - leaks read in full and in half;
   - a reader of a light shown to it, members that weigh it as one more light, with either tie rule, and one that declines where shown a red light;
   - BHW with ties toward the public belief, toward X, the name listed first, and by a coin, and a member that leaves its light unless the odds for it reach 3:2;
   - a reader of the next light from the call's labels, which shows the rule's arithmetic.

   Stage 0's 22 member types stand behind them.
4. **Exploration apart from selection.** The five exploration cells, the no-draw control and the sampled arm are reported with no prediction; a walk may read them as path cells, as it reads any cell it reaches.
5. **Guard each support rule.** BHW's rule reads the empty and balanced cells, where fixed readers fail. RF4's pass is read beside them, since a member deaf at the empty history passes trivially. A cell counts for the timing only where its probes restate.
6. **A control wherever a rival passes every contrast.** Naive counting passes BHW's rule, so the bridge is to the class of BHW and naive counting. Fixed readers pass RF4's verdict, so the cells are read beside it. A member reading a channel the prompt carries passes the cells, so the leak control shows the re-ask resolves one where the member's guess turns on it; a channel outside the prompt, no request carries. The no-draw control shows what a member does with no light.
7. **The reading refuses a run it was not frozen for** (LA4's review). Freeze 1's chain and refusals hold here, with the imported files hashed in TR3's link. A record is read only within the plan its folder's own good records derive. The endpoint is fixed, its list as read is frozen with the code, every response must name its provider and the standard tier or none, and freeze 1's chain is checked before TR3's.
8. **The inputs can meet every rule's minimum** (UE31). Every cell has five calls with each light and a probe with each by construction. The run makes every call the walk reaches, round by round, until nothing is left. Only a model's answers and a provider's filters can fall short. How each is read is stated (sections 3 and 4): off class, so a cell is flagged or unresolved. So falling short voids a unit or leaves it unresolved, and is reported; it never decides one, since a difference by a non-guess is never reproduced (section 5).

## 12. What changed from the design, and what was chosen

- **The walk follows the guess a member ignores with** (section 5). The design planned the paths as the cells where the guess copies the prefix. A member that ignores with the other guess would then be read nowhere.
- **BHW's timing reads every cell** (section 4). Stage 0 stopped a path at its first flagged cell, so a contradiction after it went unseen. Every cell is a fixed call in any case, so reading all of them costs nothing and reads more.
- **A probe gates its cell** (section 4). The design scored the probe apart but left its use open. A cell whose probe does not restate can then neither place nor contradict.
- **An answer that is not a guess is off class, with no extra re-ask** (section 3). The design budgeted one re-ask per invalid answer. At temperature 0 the re-ask would be the same request with the same seed, and its use would make one call's record depend on an earlier answer of the same call. Read as off class, a non-guess can only flag a cell or leave a difference unresolved, which is the outcome the design's own minimum gives a cell that falls short.
- **The exploration cells are asked** (section 1): 50 guesses, 10 probes and 25 no-draw calls per pin, reported with no prediction.
- **One endpoint per pin** (section 6). The design named families, and freeze 1 let OpenRouter route among providers. Every response must name the endpoint's provider and the standard tier or none, and one that does not stops the run.
- **Distinct seeded sequences** (section 5). The design names no seed, and Stage 0 drew fresh sequences each replication. A frozen run draws once, so the seed is the freeze's, and it draws without replacement, so that no two sequences of a prefix are alike (section 10). The seed, `RFZ-freeze-2-tr3-2026-11-04`, names RFZ's second freeze, and the walks' 56 sequences, eight for each of the six prefixes and the leak control, two of one light and six it draws, are in the dry run's output (`sequences`); the files were numbered after it was drawn, and the label is kept, since another would draw other sequences.
- **BHW's ties are read apart** (section 4). The design's timing names BHW with ties to the own light. A contradiction at all five tie cells, each ignoring toward the public belief, is read as a cascade one net guess earlier, where the cells beyond the ties are placed, still a contradiction of that timing, not as a tie convention, which no timing cell at precision 3/5 tells from a lean toward the public. One name at every tie, toward the public belief on its side and with the own light on the other, is read as a lean toward that name; any other pattern short of all five is read as a count, by side. The timing beyond the ties is read on its own.
- **The re-ask is no backstop for a channel outside the log** (section 5). REST and Stage 0 called it one, catching a weak channel (1/2) in 0.155 of runs. Here the two contexts are one request, so a breach outside the leak control is read as a fault of the harness, as DESIGN.md reads it, or chance, and the leak control, a channel the prompt carries, is the re-ask's positive control for a member whose guess the shown light changes. REST's passage carries a dated note, and Stage 0's docstring says so.
- **A difference by a non-guess is never reproduced** (section 5). The design reproduced a difference where both blocks were unanimous; a block unanimous for a decline is not an act.
- **Freeze 1's chain is checked first** (sections 7 and 8). Freeze 1's client enters every TR3 request and reading, so TR3 takes it only as freeze 1's newest link has it.
- **The determinism pilot is reported, with no stop rule.** The design called it a screen. Its 300 calls exclude a flip rate above about 1/100 and do not measure the 1/1000 boundary, which each cell's unanimity and the flagged share carry in the verdicts, as the design says. A screen would save the run's cost where flips are common, and read nothing of the cells there; where nondeterminism falls, the cells are void and say so cell by cell, and where it does not, they are read. At about $2 a pin before reasoning, and several times that with it, the reading is still worth more than the saving, so the full run is spent whatever the pilot shows. The smoke run's ten repeats of one request give an early look, reported, which stops nothing.
- **Sonnet at its default sampling.** It takes no temperature and no seed. It is reported apart in any case.
- **The premise's lemma is proved.** The design's verdict rested on the reached-history form, "an inference from the proof term, not a Lean statement". Board item TRL stated and proved it in the pure core, `Turns.acts_alike_along` ([the record](../../theories/becoming/results/records/a-cascade-at-the-histories-reached.md)). The stopping-time form and the total-variation form stay candidates, and no verdict here uses them.
- **The wording** is chosen within the design's skeleton (section 2): a machine with lights, not urns; precision 3/5; payment for one's own right guess.
- **Not run.** TR3's judges variant, each judge with its own evidence in turn; a reanalysis of the laboratory data (Anderson and Holt 1997; Weizsäcker 2010), whose availability is still to be checked; a presentation of the list varied as a factor. A later freeze can add any of them.
- **RF's plan is left as written.** Its §10 still says nothing is frozen, and that TR3's lemma is to be stated first. It is the plan's text of 31 October, cited by eleven records. A dated note is added below that line, and the plan is not rewritten; the standing is in this file, the folder's README and the designs.

## 13. An expectation, stated before any call

[AI expectation. It is not a prediction of the account, which predicts nothing of these systems.]
- **RF4's verdict:** passed for both deciding pins at most prefixes; void where a pin's residual nondeterminism at temperature 0 flags a cell; no breach reproduced outside the leak control.
- **The leak control:** a reproduced breach for at least one deciding pin, since a model shown the next player's light is likely to follow it outright, as a hint to the answer. A model that weighed it as one more light and broke its ties toward the public belief, as the next expectation supposes at the ties, would pass; the two hold together only for a model that follows a shown light outright.
- **BHW's timing:** contradicted for at least one deciding pin, at a cell where the light exactly offsets the evidence before it: (X) and (Y) at 1:1; the empty history, (Y,X) and (Y,Y) at 3:2. There a model may follow the guesses or the prior, not its own light, ignoring its light one net guess earlier than BHW, read as contradicted at all five ties, toward the public belief (section 4). Beyond the ties, at no net light and at two and more, its classes are BHW's: placed beyond the ties.
- **The probes** restate at every cell for both deciding pins.

Whatever the run shows is kept, and this paragraph is not revised after it.

## 14. Provenance and the reading of the freeze

Written by the Claude Code session that holds board item RFZ, on the design of RF's owner and the lemma of TRL's owner. Before the freeze landed, independent readers read the frozen files in seven rounds, a fresh Claude Opus subagent each round, until nothing of high or medium severity remained. Each was given the files and the coordinator's requirements and, from the second round on, the review record of how earlier findings were taken, which it was asked to check, not to trust. Each worked read-only, with small checks of the code. The seventh, at the coordinator's word, read only the sixth round's fixes, with the sections they touch and the dry run's output beside the run before. The readers are of the theory's own family, as is every reader the session can call (section 6). The deciding pins' families have read nothing here. Their findings, and how each was taken, are in [`told-tr3/REVIEW-FREEZE.md`](told-tr3/REVIEW-FREEZE.md).

**How this file is frozen.** As freeze 1's ([FREEZE-1 §13](FREEZE-1.md#13-provenance-and-the-reading-of-the-freeze)): by the commit that adds `told-tr3/FROZEN.sha256`, written by `told-tr3/write_frozen.py`, after the render and every check pass on the merged tree. It is not hashed, so that a link it gives can be repaired. A later edit may only repair a link or a typo, is listed in a dated note at the end of this file, and changes no rule, threshold or reading. A fault found later can be fixed only by an addendum (section 8) or by a new freeze.

**A note on the input diff, 4 November 2026** (at TR6's freeze, at the coordinator's word). A note, not an edit: no sentence above changes. TR3's reading is freeze 1's `verdicts.load`, which checks each logged record against its call's rebuild by the prompt's hash, its letters and its request fields other than the messages, not by the logged prompt's text; TR3's own check adds the provider and the tier, not the text. So a prompt builder that returned other text under the frozen prompt's hash would pass the reading. No frozen run can reach this: `tr3_design`'s builder computes the hash from the text it returns, and the frozen check refuses to start a run, or to read a scored folder, where a builder's file differs from its hash ([FREEZE-1](FREEZE-1.md#13-provenance-and-the-reading-of-the-freeze), its note of the same day). TR6's reading compares the text too ([FREEZE-6 §7](FREEZE-6.md#7-the-run-and-its-reading)). Nothing else changed: no rule, threshold, reading or frozen file.

**A log cut short, or split by a line separator, 4 November 2026** (at TR6's freeze). A note, not an edit: this freeze's logs are written by freeze 1's sink and read by its readers, so a folder of this freeze whose last line is cut short, or whose line holds U+2028, U+2029 or U+0085, is handled by [FREEZE-1](FREEZE-1.md)'s dated note of the same name, before any run or reading. Nothing else changed: no rule, threshold, reading or frozen file.
