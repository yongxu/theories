# Review of freeze 7 (TR2's Stage B): readers other than its author

4 November 2026. AI-written (a Claude Code session). Readers other than the freeze's author read the frozen files before the freeze landed, in rounds, each round checking the fixes of the one before. Every reader was a Claude Opus subagent, of the theory's own family, as is every reader this session can call. Each was given the files, the designs, freeze 1's harness and what this freeze was asked to do, not the author's conclusions. Each worked read-only, with small checks of the code, and none downloaded or ran a model. ROUNDS-SUMMARY The text the reviews changed is [FREEZE-7.md](../FREEZE-7.md).

## Round 1: three readers, each finding verified

Three readers, each with a lens of its own:
- **the statistics:** the rule, the power check and its output, and Stage 0's tests the rule imports;
- **the run:** the run, the engine, the plan, the conditions and the checkpoints' listing, against freeze 1's chain;
- **a reader of the freeze:** FREEZE-7 whole against the files, the designs, the record and its home, and the Lean the standing cites.

S, E and R number the three readers' findings. Each finding went to a verifier of its own, which was given the finding and the files and asked to refute it. What each reader read in full, and what in part, is listed in its report. None ran the dry run or the power check; the author ran both after the fixes.

They found 44 points. Four were "none found" on a question asked. Of the other 40, the verifiers held three high (two the same point, coverage under a failed premise, found by two readers), eleven medium and the rest low. Two the readers had rated high, the verifiers rated medium. Every finding was taken, as follows; where the fix differs from the reader's, the reason is given.

**High**

| # | Finding | How it was taken |
|---|---|---|
| S2, R1 | Coverage is computed from the states' bit-equality, but was not voided where exact comparison fails: under serving nondeterminism every occasion is its own lump, and coverage reports noise. | Voided with the exact shares where the premise fails. FREEZE-7 sections 1, 6 and 10; the nondeterministic formation checks the void. |
| E1 | Nothing checked the claim "no system prompt" for the tuned checkpoints: their chat templates had not been read. | The four tokenizer configurations and Olmo-3 Instruct's chat template were read at the pinned revisions, with eight more small text files (the four `config.json`, two special-token maps and two generation configurations), each against its listed hash. The layer counts had been read from `config.json` at `main`; read again at the pinned revisions, they are the same. Olmo's template adds a default system turn when given none, and Qwen's adds an empty think block with thinking off. Both are stated in the lumping, in section 3 and in `tr2_pass.py`'s docstring. Olmo's turn is kept, not replaced, and listed in section 12 with its reason. The smoke run's report shows each prompt as decoded from its token ids. |

**Medium**

| # | Finding | How it was taken |
|---|---|---|
| S1, R2 | Forbidden case 1 cannot be told apart from the premise failing (only base and identical share token ids), and the text called a failed premise one that "refutes nothing". | Said so: case 1 is met exactly where an identical arm is apart, and it does not tell nondeterminism from a fault; case 2 separates a fault in the logits from noise. The rule's forbidden block gives that reading with its counts. The departure from DESIGN's "refutes nothing" is listed in section 12: the stated implementation includes deterministic passes. |
| S3 | Where the premise fails, the total variation "stands", but the rule gave it no noise floor. | The identical arm's total variation from base is reported, and each factor's contents above it are counted, with a one-sided sign test. The nondeterministic formation shows no factor above the floor; the follower shows every content above it. |
| S4 | The sampled measure was called "acts apart", but McNemar tests a net shift over the contents. | Named for what it tests: "a net shift" or "no net shift shown". The discordant pairs each way and the minority share are reported. Section 12 lists the change. |
| S5 | N_B = 1,600 has power 0.9 at every minority share only at a 10% base; nearer one half the worst coupling allows more. | "The worst the rates 10% and 15% allow" throughout. The power at 1,600 pairs and the worst coupling is computed at 30% and 50% bases (0.48 and 0.32) and stated in section 10. The mean p(X) at base is reported, to place a checkpoint against the table. |
| E2 | An addendum could replace the engine, which held the token ids and what is kept: an addendum could change the stated lumping. | The engine is split. `tr2_pass.py` holds the token ids, the forward call and what is kept, and is fixed; `tr2_engine.py` only loads and places. A changed engine is checked by a reader other than its author before its link is committed (section 7). The dry run checks that an addendum changing the pass is refused. |
| E3 | Nothing began a new folder after an addendum changed the engine. | A run's folder is named by its checkpoint and the engine's code hash. The reading takes the one whole folder of a checkpoint, refuses two, and names the folders it read and did not. |
| E4 | The reading checked only the plan side, not the folder's meta. | `load` refuses a meta that is not a run's, a checkpoint other than the folder's, an engine hash no link of the chain lists, and a link not in the chain. Four dry-run refusals. |
| E5 | The time rows were not tied to an estimate and sat below what an 8B prefill costs. | A floating-point estimate (about 2.5 × 10¹² a pass), rows to 30 s a pass (104 hours a checkpoint), and "a day or more per checkpoint" on the CPU, in section 9 and the power check's docstring. |
| R3 | The exact states and coverage are settled by architecture: every cue changes token ids, so the last state differs after the first block. | Said in the standing ("What is settled before the run") and in section 6: they record that the cue's tokens enter the state. Where the difference stops is carried by the probe, the logits and the sampled acts. |
| R5 | The conditions' docstring still described the design's pilot sizing and "matched wordings". | Rewritten before hashing: N_B fixed, the pilot a positive control that sizes nothing, the wordings matched in form, not in length. |

**Low**

| # | Finding | How it was taken |
|---|---|---|
| S6, R10 | Two departures not listed: the void on the whole checkpoint, and the format rule. | Both listed in section 12 with their reasons. Section 6 names which act measures stand under the void, and why the greedy change and the misled share stand. |
| S7 | Coverage lumps by equality at every layer, finer than the last state the logits read. | Said: coverage is a lower bound (section 6). The lumping is kept, since it is what the exact comparison measures. |
| S8, R13 | Recognition had no format check. | The mean Yes+No mass at base is reported, and recognition is void where it is under one half. |
| S9, E12 | "2,400 vectors" is wrong; the words were off. | "2,400 passes' states, each 37 or 33 vectors of 4,096"; the words, 71 to 108 with "Answer:", come from the power check's output by phase. |
| S10 | The occasions are two cue-down copies and one cue-up, so coverage differs from Stage 0's symmetric tables. | Said in section 10. |
| E6 | The smoke gate fell back to an older smoke run when the newest had no report. | A newest smoke run with no report says no. A dry-run refusal. |
| E7 | A line torn by a stop made the log unreadable. | A torn last line is moved, unchanged, to a numbered file beside the log, and its group made again; any other bad line is refused. A dry-run case stops inside main with a torn line and resumes to the same records as a whole run. |
| E8 | `load` did not check a record's phase, content and kind, or its passes' fields. | Refused where any differs from the plan, or a field is missing. Two dry-run refusals. |
| E9 | Unlisted files a loader could read were not refused. | Refused, dot folders and files listed as not loaded aside. A dry-run case. |
| E10 | The plan's docstring described the design's pilot sizing. | Reworded with the conditions'. |
| E11, R12 | The last hidden state is after the final norm, not the last block's raw output. | Said in section 1 and in `tr2_pass.py`. |
| E13 | The engine-shape refusals were `assert`s, removed by `python -O`. | Raised as errors no interpreter flag removes. |
| R4 | The identical-arm control cannot reject under exact passes, so on the CPU the probe has no working control. | Said in sections 6, 10 and 13: the control guards only a run that is not exact. Section 12 says why the design's rival, probes reading lexical content, does not apply here: the cue is lexical, and a probe separating it is the measure. |
| R6 | The provenance paragraph ended in a placeholder. | Filled with these rounds (section 15). |
| R7 | The count of refusals was wrong. | Recounted after the new refusals: 21, each listed in section 11. |
| R8 | The token range was unmeasured. | Marked an estimate, which the smoke run measures (it reports the range of tokens a pass). |
| R9 | The dry run's claims were wider than its checks. | "At every layer after the embedding". The prompt checks now run over every content, arm and kind, and the control check over all four factors. |
| R11 | The home's qualifiers were dropped. | "Near-definitional", "where the cue's difference stops", and `Becoming.Learning.lumped_determines` for what coverage reads, with "not fixed" scoped to laws reading through the measured lumping. |
| R14 | "Counted across all passes" adds nothing; the classes are what is counted. | "Counted as classes of passes", with where token ids are shared in this plan (sections 1 and 13). |
| R15 | "The worst the rates allow" read as general. | As S5. |
| R16 | "62 GB" read as per checkpoint. | "About 62 GB for the four", here and in DESIGN. |
| R17 | The smoke report compared only the states of the identical arm with base's. | It compares the token ids, every state and the logits (section 8). |

The four "none found": the statistics reader on McNemar, the paired probe test, Holm, the power table, the control and the forbidden counts; the run reader on the plan's purity and counts; the reader of the freeze on the Lean names and statements, and on every number it checked beyond R7 to R9.

After the fixes, the power check and the dry run were run again on the changed code. Every check holds.

## Round 2: three readers, a verifier for each high or medium finding

Three readers, each with a lens of its own:
- **the fixes:** whether each of round 1's fixes was made, complete and without regression, in the code and the text;
- **the code read whole:** the pass, the engine, the run, the rule, the plan and the conditions, for a defect round 1 did not find, with the pinned templates and what transformers 4.57.1 and torch do with them;
- **a reader of the freeze:** FREEZE-7 whole against the files, the outputs, the designs, the record, its home and the Lean, and this file's claims about round 1.

Each high or medium finding went to a verifier of its own, asked to refute it: fourteen verifiers, seventeen agents in all. F, C and R number the three readers' findings. As in round 1, none ran the dry run or the power check, and none downloaded or ran a model. The code reader could not run torch or transformers, which are not installed here, and read their behaviour from what it knew of them.

They found 47 points, three of them "none found". The verifiers held two high, one found by two readers in two forms; seven medium; and one not real. The rest are low. Every finding was taken, the one not real included, as follows.

**High**

| # | Finding | How it was taken |
|---|---|---|
| C1 | A letter's probability is a float32 sum over the tokens that decode to it. With nearly all the mass on one letter split over two tokens, it can round to 1 + 2⁻²³. The run's check refused it, and since the pass is deterministic, a resumed run is refused again: the run could not go on, and both files are fixed. | The pass sums a letter's entries in float64 and takes the sum at most 1 (section 1). The dry run's stand-in torch rounds as a float32 softmax does. It finds such a case, at bfloat16 logits 0.01 apart, and the group made from it goes on with each letter at 1. |
| F3, C2, R4 | `read` loaded every folder before asking which was whole, and refused a torn line anywhere. So an old partial folder with a torn last line, left by a stop and superseded by an engine addendum, refused the reading of all four checkpoints, for good, against section 7's "not read while it is partial" and section 6's "each checkpoint's reading is its own". Two whole folders likewise refused every checkpoint, with no rule that settled them. | `read` reads each checkpoint alone: a refused folder is listed with its reason and not read, and a checkpoint's refusal is its own status. A torn last line in a folder not being resumed is read as absent and left in place, so the folder is partial. A whole folder ends its checkpoint's run, so the tools never make a second; two whole folders refuse only their checkpoint. Dry-run cases: a torn old folder beside a whole one (the whole one read, the old one listed, its file untouched, and alone listed as partial); two whole folders beside another checkpoint's refused folder (each its own status, the readout written); a new folder beside a whole one, refused. |

**Medium**

| # | Finding | How it was taken |
|---|---|---|
| F1, R3, C12 | Round 1's test of the total variation against the identical arm's floor counted ties against the factor and had no level and no status. Under exact passes it read a twin's factor, above the floor on all 154 contents it moved and below on none, as p = 1. On a checkpoint that is not exact, the one act measure left had its verdict decided after the run. The dry run checked it at an unstated p > 0.001. | A sign test over the contents above and below the floor, ties dropped, Holm over the four factors at 0.05, with the status "above the identical arm's floor" or "not shown above it" and its exchangeability assumption stated. It is read only where the premise fails; under exact passes it repeats the logits' share apart and is marked not read. It is listed as new in section 12. The dry run checks each status, and a new formation, a follower under nondeterminism, shows a factor above the floor. |
| C4 | What `add_special_tokens=True` adds for a fast tokenizer is set by `tokenizer.json`'s post-processor, which was not read. If Olmo-3 base's appended a token, every base act would be read at another position, and nothing would refuse it. | The base text is tokenized with no special tokens added, so its ids are the text's alone (section 3); this asks for no file to be read. The smoke run says go on only where every prompt's ids decode exactly to the text they were made from. Both tokenizers set `clean_up_tokenization_spaces` false and every prompt is ASCII, so the decode is exact. A dry-run tokenizer that adds a token makes the smoke run say no. |
| R1 | The probe was fitted on the even-placed state contents, which the interleaving made all of families H and S, and tested on E and R. It measured a cue's transfer across families, not a held-out split, and section 10's power did not cover that. | Fitted on the contents even-placed within each family, 50 of each, and tested on the rest; the dry run checks the 50s. Listed in section 12. |
| R2 | The argument that settles the exact states settles the exact logits too: logits read from a last state that differs in its bits differ in theirs. | Said in the standing and section 6. Where a difference stops is carried by the size of the total variation, the greedy changes, the sampled net shift and the probe. Section 11 says the detected stand-in, like content-only, has no exact counterpart. |

**Low**

| # | Finding | How it was taken |
|---|---|---|
| F2, C5 | Round 1's split held by convention only: the run called the engine, which the changeable file defined, and the shape checks compared with what the engine itself reported, including a literal "bfloat16". (Verifiers: low, since the text named the addendum's reader as the guard; worth fixing while the files can change.) | The run calls the pass itself; the engine hands it torch, the model, the tokenizer and the device. `MODELS.json` lists each checkpoint's layers, width and dtype from its configuration at its revision. The run refuses an engine whose report, read back from the model and torch, differs from them or from the device, threads and deterministic algorithms asked for, and a pass whose states or logits are not bfloat16 or were made on another device. Section 4 says what the addendum's reader still checks. Four dry-run refusals. |
| C3 | Once a run had begun, a change of threads or device was refused with no way to a new folder. | A folder is named by its checkpoint, engine, device and threads. A move, after its own smoke run, begins a new folder while no folder is whole. A dry-run case. |
| R5 | No formation exercised the recognition reading: every stand-in left Yes and No under half the mass. (Verifier: low; the tallies ran, only the output was never checked.) | The stand-in answers Yes or No on recognition prompts. The dry run checks that detected and the follower read p(Yes) higher with each factor up, content-only reads it unchanged, and off-format is void. |
| F5 | No path settled a checkpoint with two whole folders. | A whole folder ends its checkpoint's run (as F3). |
| F6, R7 | Two placeholders were left. | Filled at the landing, with the rounds' counts. |
| F7 | The sampled fields were still called `shown_apart`. | `net_shift`, and the pilot's `net_shift_shown`. |
| F8 | The rule kept two `assert`s. | Raised as errors. |
| F9 | The run's comment on what may change said "loaded and called", and left out the pass. | "Loaded and placed, never the pass"; the pass, and the power check, in the fixed list; the unlisted-file refusal in the docstring. |
| F10, R8 | The prompt checks left out the pilot's arms. | Added: the base and tuned texts the same, the two arms apart in their fifth line alone, the factor lines at base's. |
| F11 | DESIGN's summary dropped "at a 10% base". | Restored. |
| F12, R6 | The reading time was low. | Recounted with the repository's counter after round 2. |
| F13, R11 | "Not fixed" cited `lumped_determines`, which proves only the other side. | `Becoming.Learning.twin_selected`, with its hypotheses, which hold here. |
| F14 | The loaded files' list left out the generation configuration. | Added. |
| F15 | A record missing its own fields failed with a traceback, not a refusal. | Every group's and pass's field set is checked. A dry-run refusal. |
| F4 | The torn-line case tore a copied fragment, not the record itself. (Verifier: not real; the check reached what it claimed.) | Taken all the same: the case now tears the 600th record and checks that that group is made again, once. |
| C6 | Smoke runs were named in local time, so a clock change could reorder them. | Named in UTC. |
| C7 | The second forbidden case can come from noise in the head, not only a fault. | "What enters after the last state (in the head, by a fault or by noise there) from what enters the states." |
| C8, R14 | jinja2, which renders the chat templates, was not pinned. | jinja2 3.1.6 and markupsafe 3.0.3 pinned, with their wheels' hashes, and checked. |
| C9, R13 | A stand-in engine given a folder under `open/results/` was not refused. | Refused. A dry-run case. |
| C10 | "53 bits" for the shared draw: the code takes 56. | Corrected in the plan's docstring. |
| C11 | `strip` takes all whitespace, not only spaces. | "Leading and trailing whitespace aside". |
| C13, R12 | Importing `told/run.py` runs freeze 1's other files, which this chain does not hold. | Said in section 7: freeze 1's chain holds them, and a change there can stop the run, never change a reading. |
| R9 | "Stage 0's types and one more" was wrong both ways. | "Five of Stage 0's types and four more", with the four left out named. |
| R10 | Four departures were not listed: the floor test, logits in the premise, the misled share under S1 only, the last state after the norm. | Each listed in section 12, with its reason. |
| R15 | Round 1's row E5 placed "a day or more" in the power check's docstring, where it was not. | Added to the docstring. |
| R16 | Olmo 3 alternates sliding-window and full attention. | Said in section 2: at these lengths it is full attention throughout. |

The three "none found": the fixes reader on the rest of round 1's fixes, every number it rechecked and the thirteen kit files' hashes; the code reader on every branch of the rule and the real engine's states, hashing and templates; the reader of the freeze on every number, the Lean names and statements, and this file's count of round 1.

After the fixes, the power check and the dry run were run again on the changed code. Every check holds, and the power check's figures are unchanged.
