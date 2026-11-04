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

They found 47 points, three of them "none found". The verifiers held two high (C1 and F3) and seven medium (F1, C2, C4, R1, R2, R3 and R4), of which C2 and R4 are F3's defect in other forms, so they share its row in the high table; and one not real (F4). C12, in F1's row, was a reader's low finding. The rest are low. Every finding was taken, the one not real included, as follows.

**High**

| # | Finding | How it was taken |
|---|---|---|
| C1 | A letter's probability is a float32 sum over the tokens that decode to it. With nearly all the mass on one letter split over two tokens, it can round to 1 + 2⁻²³. The run's check refused it, and since the pass is deterministic, a resumed run is refused again: the run could not go on, and both files are fixed. | The pass sums a letter's entries in float64 and takes the sum at most 1 (section 1). The dry run's stand-in torch rounds as a float32 softmax does. It finds such a case, at bfloat16 logits 0.01 apart, and the group made from it goes on, with A at 1 in each pass. |
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
| F13, R11 | "Not fixed" cited `lumped_determines`, which proves only the other side. | `Becoming.Learning.twin_selected`, with its hypotheses (restated in round 3, R9). |
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
| R16 | Olmo 3 alternates sliding-window and full attention. | Said in section 2: at these lengths it is full attention throughout (its pattern corrected in round 3, F9). |

The three "none found": the fixes reader on the rest of round 1's fixes, every number it rechecked and the thirteen kit files' hashes; the code reader on every branch of the rule and the real engine's states, hashing and templates; the reader of the freeze on every number, the Lean names and statements, and this file's count of round 1.

After the fixes, the power check and the dry run were run again on the changed code. Every check holds, and the power check's figures are unchanged.

## Round 3: three readers, a verifier for each lens

The same three lenses as round 2, each reader given round 2's fixes to check besides its own lens. The high and medium findings of each reader went to one verifier for that reader, asked to refute them: three verifiers, six agents in all. None ran the dry run or the power check, and none downloaded or ran a model.

They found 33 points, three of them "none found". There is no high finding. The verifiers held seven medium, which are five defects, each also found by a second reader and the first by three (F1, C1 and R2, all held medium); two sent as medium they held low (F2 and F3). The rest are low. Every finding was taken, as follows.

**Medium**

| # | Finding | How it was taken |
|---|---|---|
| F1, C1, R2 | The reading's isolation of each checkpoint held only for the refusals the code raised itself. A `meta.json` not whole (which a stop while it was rewritten could leave), a record without its group, or a line that is JSON but no record, raised another error: the reading of all four checkpoints stopped with no readout, and every later run of that checkpoint stopped too. | `load` checks `meta.json` and each record's fields before using them, and `written` refuses a line that is no record. `read` and the listing of folders take any other error as that folder's or checkpoint's refusal, its type and message the reason. `meta.json` is written to a temporary name, synced and moved into place. Dry-run cases: a torn `meta.json`, one without its links, a record without its group, a line that is no record, passes that are no list, each refused at loading and listed at the reading. |
| C2 (and F4) | The run's gate asked only whether another folder was whole. A refused folder counted as not whole, so a whole folder that the reading refuses let a second one begin; and the run never asked whether its own folder loaded, so it could add passes for days to a folder the reading would refuse. | The run refuses while any other folder of the checkpoint is whole or refused, and, after setting aside a torn last record, refuses unless its own folder loads as the reading loads it. Dry-run cases for both, the own folder left unchanged. |
| C3 (and R4) | "No run can be chosen by its outcome" claimed more than the code does. Partial folders can go on side by side, under other threads or devices, and their records can be read before one is finished; the readout listed an abandoned folder with its phases' whole or not, so a folder at 1,599 of 1,600 showed as "main: false". | Section 7, 12 and 13 now say what holds: no second whole run can be chosen between, and every folder not read is listed with its groups per phase against the plan's and the times of its first and last pass. A checkpoint whose folders are all refused has the status "refused: every folder refused". |
| C4 (and R3) | The kept states were written with no sync before their group's line, which was synced. After a machine stop the line could survive and a state file not: the reading would refuse the folder for good, and no new folder could begin under the same name. | Each state file is written to a temporary name, synced (with a full flush where the system has one) and moved into place before its group's line; the log's line is flushed the same way. On resuming, a last group whose state files differ from their hashes is moved aside like a torn line, the differing files kept beside it, and made again. A dry-run case stops a run after a group keeping states, damages one of its files, and resumes to a run equal to one made whole. |
| R1 (and F2, held low) | Section 4 said the smoke run's decode check catches a template that adds to the text. It cannot: the text the ids must decode to is built by that same template. | Said as it is: the check catches a tokenizer adding a token of its own, not what a template adds. A check was added that can: `MODELS.json` lists the sha256 of each tuned checkpoint's chat template, read at the pinned revision, and smoke and run refuse a tokenizer holding another text. Dry-run cases with a stand-in hash: the pinned text read, another or none refused, a base checkpoint not checked. |

**Low**

| # | Finding | How it was taken |
|---|---|---|
| F3 | The addendum reader's check was narrower than what an engine supplies: torch, the model and the tokenizer, any of which could be wrapped or hooked; eager attention was stated and not checked. (Verifier: low.) | The reader's check in sections 4 and 12 and the engine's docstring now names the model and tokenizer as loaded, with no wrapper, hook or replaced module. The engine reports its attention and its model's class, and the run refuses other than eager and `MODELS.json`'s class. Dry-run cases for each. |
| F5, C7 | Only the first state's dtype and the logits' device were checked. | The pass reports the dtypes and devices of every state and of the logits; the run requires bfloat16 throughout and the one device. Dry-run cases: one state in float16, one state on another device. |
| C6 | The stand-in made one position and named its device with no index. (Round 4, R5: torch too names a CPU device "cpu"; only an accelerator's carries an index.) | It makes two positions, the pass reading the last, and names its device with an index ("cpu:0"), as torch names Apple's GPU ("mps:0"), so the run's reading of a device by its type is exercised. |
| C5 | The dry run's docstring said it ran every refusal. | It names the refusals as those listed in its output, which now include the cases above. |
| C8 | A checkpoint whose folders are all refused was "partial". | "refused: every folder refused"; the dry run checks it. |
| C9 | A damaged last line ending in its newline was read as torn. | Torn means a last line with no newline at its end; any other line not whole is refused. A dry-run case. |
| R10 | Only the reading checked that the chain lists the engine. A link that left out a frozen file would let smoke and run go ahead. | Smoke and run refuse unless the newest link lists every file the freeze holds. Dry-run cases. |
| R5 | The list of what importing `told/run.py` runs left out TR8's and TR-RR's scripts and `PINS.json`. | Added in section 7. |
| R9 | `twin_selected`'s hypotheses were not stated as the Lean has them. | Section 6: for any selection through agreement on the readings that selects a law reading through the lumping, a selected twin takes every value there; the selection is a hypothesis the run does not measure. |
| F9 | Olmo 3 does not alternate its attention. | Three sliding-window layers in every four, full in the fourth. |
| F6, R6 | In the stand-in, only A and B decode from two tokens. | "A and B each decode from two tokens, and Yes and No from one". |
| F11 | The pilot check did not check that the line apart is the fifth. | It does. |
| F7, R7 | Round 2's counts did not say which findings the high row and the medium row hold. | Corrected. Round 3 first wrote "six medium", counting the IDs in the medium table; round 4 (R4) restored what the verifiers held, seven, and the summary now names them. |
| F8 | Round 2's row C1 said each letter is at 1. | "With A at 1 in each pass". |
| F10, R8 | The placeholders were still in the texts. | Filled at the landing, with every round's counts. |

The three "none found": the fixes reader on the rest of round 2's fixes; the code reader on the pass and engine against torch 2.9 and transformers 4.57.1 as it knew them; the freeze reader on every number in sections 2, 3, 5, 9, 10 and 11, the kit files' hashes, the Lean names and the departures.

After the fixes, the power check and the dry run were run again on the changed code. Every check holds, and the power check's figures are unchanged.

## Round 4: three readers, a verifier for each that found a high or medium

The same three lenses, on round 3's diff and on the whole. The fixes reader's and the code reader's high and medium findings went to one verifier each; the freeze reader sent none. Five agents in all. None ran the dry run or the power check, and none downloaded or ran a model.

They found 38 points, ten of them "none found". There is no high finding. The verifiers held three medium, which are two defects. The rest are low. Every finding was taken, as follows.

**Medium**

| # | Finding | How it was taken |
|---|---|---|
| F1, C2 | A refused folder stopped every later run of its checkpoint, and nothing frozen gave a way past: an engine addendum names a new folder, but the old one still loads to the same refusal. A last group whose state files a machine stop left differing was mended only in the run's own folder; in any other it refused that folder, and so stopped the checkpoint. Moving the folder out by hand would drop it from the listing. | A last group whose kept states are missing or differ is read as absent in every folder, as a torn last line is: the folder is partial, and the readout marks it. A new command, `set-aside`, moves a refused folder, unchanged, to `open/results/set-aside/` with the reason and the time beside it; only a refused folder is moved, nothing is deleted, and the reading lists it there with its reason then and now and its lines per phase. A run may then go on beside it. Sections 7 and 12. Dry-run cases: a folder that loads is not set aside; a refused folder blocks a run, is set aside unchanged, and the run then goes on and the reading lists it; another folder's last group missing a state file reads as partial and blocks no run. |
| C1 | Nothing stopped two runs of one checkpoint at once: two on different devices could both finish whole, refusing the checkpoint, and two with the same arguments would write each group twice, refusing the folder for good. | A run holds an exclusive lock on `results/<checkpoint>.lock` from its gate to its end, and is refused while another holds it. Sections 7 and 12 say partial folders go on one after another, never at once. Dry-run cases: refused while the lock is held, going on once it is let go. |

**Low**

| # | Finding | How it was taken |
|---|---|---|
| F2, C3, F3, C7, R8 | A damaged own folder could stop the run with a traceback (its `meta.json`, or a last line that is no record), and before the own folder was checked the run could add a link to its `meta.json` and move its torn line aside. | The run checks that its own folder loads before anything is written to it, and again after its repairs; any error is the refusal "the run's own folder is refused". Dry-run cases: a `meta.json` not whole, a last line that is a list, and a refused folder under a new link with a torn line, each refused with every file of the folder unchanged. |
| C8 | The smoke report was written with no sync, and a report not whole crashed the run's check. | Written durably; a report or meta not whole says no. A dry-run case. |
| C5 | Each refusal case counted any refusal. | Each case now names its reason, and holds only where the refusal's message gives it. The dry run found one real fault that way: `set-aside` read a loaded folder's entry wrongly and would have moved it. Fixed before the freeze. |
| C6 | No case removed a state file. | A case removes one: the folder reads as partial, blocks no run under other threads, and the resume keeps the line beside the log, has no file to keep, and makes the group once. |
| F5, R9 | A refused folder was listed with its reason only, a folder with no `meta.json` not at all, and the mixed status went unnamed. | A refused folder is listed with its lines per phase; any folder of the checkpoint is listed, `meta.json` or not; the status "partial" names how many folders are refused. |
| F6 | Groups made again were not in view. | Each folder's listing, and the read folder's readout, counts the lines and state files set aside. |
| F4, C4, R5 | Torch names a CPU device "cpu", not "cpu:0". | Section 11 and the dry run's docstring: the stand-in names its device with an index, as torch names Apple's GPU, and the run reads a device by its type. Round 3's C6 row corrected. |
| F7 | The rule's docstring kept round 3's old statement of `twin_selected`'s hypotheses. | Carried over from section 6. |
| R7 | The pass's docstring said only the logits' device is kept. | "The dtypes of every state and of the logits, and the devices they were made on". |
| F8 | The dry run's key said each letter is at 1. | "A at 1 in each pass". |
| R1 | The standing read as a three-way open outcome, with coverage measured. | It says how far the difference is expected to reach in exact bits, that coverage is then settled, and what is measured: the total variation, the greedy changes, the sampled net shift, and the probe's direction. |
| R2 | The probe was listed as if its outcome were open. | "What is settled before the run": under exact passes it is expected to reject for every factor, showing the cue's tokens readable along one direction, not recognition. |
| R3 | Round 3's summary miscounted who found the medium defects. | Corrected, and R1's row marks F2 held low. |
| R4 | Round 3's correction of round 2's count counted the table's rows, not what the verifiers held. | Round 2's summary names the two high and seven medium the verifiers held. |
| R6 | The time understated the CPU case and left out that float32 does not fit. | Up to about four days a checkpoint at 30 s a pass, over two weeks for the four; float32 does not fit, so a CPU too slow leaves the GPU, where the premise may fail. |
| R10 | Four smoke contents are made and not used. | Section 3: two a family set aside for the smoke run, which uses the first of each. |
| R11 | The states, 5.5 GB, would land in the working copy with no rule for them. | An ignore rule keeps the states and the lock files out of the history; the logs and the readout are committed after a run, each state hashed in them; where the states are archived is Ren's (section 7). |
| R12 | The record's page was not rendered, and the history entry's gloss of the lumping left out the shared draw. | Rendered at the landing; the entry adds the shared draw. |

The ten "none found": the template hashes recomputed, and what transformers 4.57.1 holds for each; the dtype and device lists and the engine's report against torch 2.9 and transformers 4.57.1; every stop point in the repairs, `held()` and the counts; the numbers; the Lean citations and the law's standing; what would make a reading wrong or stop the run; the totals; the departures; and round 3's fixes and counts.

After the fixes, the power check and the dry run were run again on the changed code. Every check holds, and the power check's figures are unchanged.

## Round 5: two readers on round 4's diff, a verifier for each

A code reader on what round 4 added (the lock, the own folder's checks, the last group read as absent, `set-aside` and the listings), read adversarially, with small scratch checks; and a reader of the text against the code. Each sent its high and medium findings to a verifier of its own: four agents. None ran the dry run or the power check, and none downloaded or ran a model.

They found 26 points, six of them "none found". There is no high finding. The verifiers held four medium, which are three defects, in round 4's `set-aside` and the listings it brought (one, C2, in the listing of refused folders in `results/` as well), and one sent as medium they held low. The rest are low. Every finding was taken, as follows.

**Medium**

| # | Finding | How it was taken |
|---|---|---|
| C1, R1 | `set-aside` opened a way to a second whole run: a whole folder damaged so it is refused could be set aside, and a run under other threads then made a second whole folder, which the reading would read, the first listed only as set aside. | `set-aside` refuses a folder whose log names every planned group: a whole folder ends its checkpoint's run, refused or not, so a whole folder refused ends that checkpoint's run under this freeze, and only a new freeze begins another (section 7). The reading refuses the checkpoint if a folder set aside names every planned group, in case one is moved there by hand. A dry-run case: a whole folder refused is not set aside. |
| R2 | A name refused a second time could not be set aside, since `set-aside/<name>` existed, and the checkpoint stopped for good. | Each folder set aside gets a numbered slot of its own, `set-aside/<k>/<name>/`, its `why.json` written there before the move. A dry-run case sets the same name aside twice. |
| C2 | A set-aside or refused folder whose log cannot be read stopped its checkpoint's whole reading. | Every listing is guarded: a folder that cannot be read is listed as unreadable, and the reading goes on. A dry-run case makes a set-aside folder's log unreadable. |

**Low**

| # | Finding | How it was taken |
|---|---|---|
| C3, R3 | A run's own folder holding records but no `meta.json` was not checked before the run wrote a new `meta.json` to it. (Verifier: low.) After the repairs a second differing group could stay read as absent. | The own folder is checked before any write unless it holds no record, no meta and no state; after the repairs the run refuses unless nothing is read as absent. A dry-run case. |
| C5 | A log ending in a blank line loaded, and the repair then failed on it. | Only the newline ending the last record is passed over; any other blank line is a line not whole, refused. A dry-run case. |
| C6 | A last group read as absent was not first checked for faults of its own. | It is read as absent only where every other check of it holds. A dry-run case: a last group with a wrong prompt hash and a missing state is refused. |
| C7 | `set-aside` raised a traceback on a name holding `/`, and wrote its reason after the move. | Such a name is refused; the reason is written first. A dry-run case. |
| C8 | Any error from the lock read as another run holding it, and the lock was taken after the checks and the model load. | Only a held lock reads so; any other error is said as it is. The run takes the lock first. |
| C9 | A temporary side file was counted as a group made again; a checkpoint whose only folders are set aside read "not run"; a stray file in `smoke/` could stop every run. | Temporary files are not counted; the status is "not run; N set aside"; only folders are read as smoke runs. |
| C10 | No cases for a folder with no `meta.json`, for the own folder with records and no `meta.json`, or for the status naming refused folders; the lock case made no group. | Each added; the lock case runs a partial folder and checks that it makes its groups. |
| C4 | A set-aside folder that loads listed all its records as its reason. | It lists that it loads, and whether it is whole. |
| R9 | A group made again overwrote the earlier attempt's state files. | No state file is overwritten: an earlier one is moved beside it as `<name>.torn-<k>` (section 7). |
| R4 | Section 7 named four commands. | Five, with `set-aside`; the run takes its lock first. |
| R5 | The rule's docstring and section 14 still treated the probe as open, or as rejecting for three factors. | Both now say what the standing says. |
| R6 | Three wording errors in round 3's and round 4's rows. | Corrected. |
| R7 | A group keeping states the plan does not was refused as "arms differ". | Its own message, "keeping of states differs from the plan's", and the case matches it. |
| R8 | The dry run's docstring left out four of its resume and folder cases. | Added. |
| R10 | The record's English entry had no verb. | "The stated lumping is the token ids, with batch size one and no cache, and, for a sampled act, the content's shared draw." |

The six "none found": the last-group rule against the plan (the last planned group of every phase keeps no state, so a whole folder cannot read as partial), a mid-log group still refused, the side line written before the cut, the ignore rules; the count of 49; round 4's counts; round 2's restated counts; the reading time; round 4's other claims.

After the fixes, the power check and the dry run were run again on the changed code. Every check holds, and the power check's figures are unchanged.


## Round 6: two readers on round 5's diff, a verifier for each

The same two lenses as round 5, on what round 5 added (the numbered slots, the whole-folder guard, the guarded listings, the own folder's checks, the last group read as absent, no state file overwritten) and on the text against the code. Each sent its medium findings to a verifier of its own: four agents. None ran the dry run or the power check, and none downloaded or ran a model.

They found 24 points, eight of them "none found". There is no high finding. The verifiers held four medium, which are two defects, each found by both readers. The rest are low. Every finding was taken, as follows.

**Medium**

| # | Finding | How it was taken |
|---|---|---|
| C1, R1 | Round 5's numbered slots put a folder set aside at `results/set-aside/<k>/<name>/`, one level deeper than the ignore rule, so its states (up to about 1.45 GB a checkpoint) were no longer kept out of the history section 7 says they are kept out of. Round 5's "none found" on the ignore rules was checked against round 4's layout. | The rule is `results/set-aside/*/*/states/`, checked with `git check-ignore` on a slot path, a state file and its `.torn-<k>` copy. `open/.gitignore` is not a held file. |
| C2, R2 | "A whole folder is never set aside" was tested by whether the log's lines name every planned group, so one line of a whole log made unparseable, or one group id changed, let it be set aside, and a second whole run could be made and read beside it. This is round 5's C1 by a damaged line instead of a damaged state. | A folder is whole by its lines where its log holds at least as many lines as the plan has groups, or names every planned group, or names the plan's last group (the log is written in plan order), or cannot be read. Such a folder is never set aside; no run goes on beside one, in `results/` or in `set-aside/`; and the reading reads no whole folder beside one. Dry-run cases: a whole folder with one line made unparseable is not set aside; a run beside a refused folder whole by its lines is refused; a whole folder moved into `set-aside/` by hand beside a whole one makes the reading refused, naming it. |

**Low**

| # | Finding | How it was taken |
|---|---|---|
| C3 | The run judged the other folders whole by `load`, not by their lines, and never looked in `set-aside/`, so a folder naming every group but with its last newline lost, or one moved there by hand, did not stop a run. | The run refuses beside any folder whole by its lines, in `results/` or `set-aside/<k>/` (C2's test). |
| C4, R5 | When a folder set aside was whole, the reading returned no listing of the folders in `results/`. | The listing is built first and returned with the refusal, with the folders in doubt named. |
| C5, R6 | `set-aside` raised a traceback, not a refusal, on an unreadable log, a group id that is not a string, a name differing only in case (APFS), or two checkpoints set aside at once taking the same slot. Nothing was moved in any of these. | An unreadable log counts as whole and is refused; only string ids are read; the name must be one of the listed folders; the slot is made in a loop that takes the next number if one is taken. |
| C6, R3 | Section 7, section 11, the module's and `repair_states`'s docstrings and the dry run's said only the differing state file is kept beside the log, with the line's number, though since round 5 every state file of the group made again is kept, each with its own first free number; and the count of groups made again counts lines and files. | Each now says the group's state files are kept, each as `<name>.torn-<k>`, k its own, and that the readout counts the lines and state files set aside. |
| C7, R4 | The module docstring did not say that a refused folder whole by its lines is never set aside, and so ends its checkpoint's run under this freeze. | Said, with the numbered slot. The run's message for a refused folder stands: a folder whole by its lines is refused one line before it, by its own message. |
| C8, R7 | The no-meta case did not check that the folder with no `meta.json` is listed as refused: the refused count in the status came from another folder. Section 11 said the status names the refused folders. | The case reads before the set-aside and checks the folder's listing and the status "refused: every folder refused"; the status counts the refused folders. |
| R8 | Round 5's summary put all three defects in round 4's `set-aside`, but C2 covered the listing of refused folders in `results/` too. | Corrected. |

The eight "none found": the lock (taken first, held across every phase, let go on any exit, only a held lock read as held); the last group read as absent only after its own checks, a whole folder unable to read as partial, the own folder checked before any write, no state file overwritten, a blank line refused; round 5's counts (twice); the count of 53 refusals then; the reading time; a set-aside folder never read, the names and slots, `why.json` written first, each new dry-run case against its key but the no-meta one (C8); and round 5's other claims, the record's entry and the probe's wording among them.

After the fixes, the power check and the dry run were run again on the changed code. Every check holds, the power check's figures are unchanged, and the dry run now meets 56 refusals.

## Round 7: two readers on round 6's diff, a verifier for each

The same two lenses, on round 6's diff: a code reader, with small scratch checks, and a reader of the text against the code and of round 6's record against its readers' reports. Each sent its medium findings to a verifier of its own: four agents. None ran the dry run or the power check, and none downloaded or ran a model.

They found 23 points, nine of them "none found". There is no high finding. The verifiers held three medium, which are two defects. The rest are low. Every finding was taken, as follows.

**Medium**

| # | Finding | How it was taken |
|---|---|---|
| C1, R1 | One byte could still make a whole folder look partial: the newline before the plan's last record, changed, merges the last two records into one line that does not parse, so the log has one line too few, names neither group, and round 6's three tests all fail. The folder could then be set aside and a second whole run made and read. Round 6's own verifier had pointed to a merged line; the fix did not cover a merge taking in the last record. | A folder is also whole by its lines where the record of the plan's last group is anywhere in its bytes, as the run writes it, not only in a line that parses. One byte changed, added or taken anywhere in the log, a newline included, leaves either the count of lines or those bytes, so it cannot make a whole folder look partial. Dry-run cases: the newline before the last record changed, and the last record's group changed (where only the count of lines holds), each not set aside, each for its own reason. |
| C2 | The listing judged "whole by its lines" inside a block that any error ended, so a line giving its phase as a list made a refused partial folder read "unreadable" there, though `set-aside` and the run, testing directly, read it as not whole. Such a folder could be set aside and a whole run made beside it that the reading would then refuse for good: a whole run's machine time spent for nothing. | The listing, the run and `set-aside` use one test (`raw_whole_why`), outside any block an error ends; a phase is counted only where it is a name. A dry-run case: such a folder is listed as not whole by its lines, with no error, and set aside. |

**Low**

| # | Finding | How it was taken |
|---|---|---|
| C3, R2 | A folder stopped while writing its last line counts that torn line among its lines, so it is whole by its lines, and a run under another engine, device or threads is refused beside it, though the folder loads as partial. | Kept, and said (section 7 and the module docstring): such a folder is made whole only by its own run, under the same engine, device and threads, and without that run ends its checkpoint's run under this freeze. Leaving the torn line out of the count would let one taken newline make a whole folder look partial. |
| C4 | A set-aside slot, or `set-aside/` itself, that could not be read was passed over as empty: the run went on, and the reading did not name it. | The slots are listed so that an error is not passed over: a run is refused while any cannot be read, and the reading names each such slot among the folders in doubt. A dry-run case. |
| C5, R4 | No case ran beside a whole folder in `set-aside/`, read a whole folder beside a refused one in `results/` whole by its lines, or isolated the count of lines. | Each added (with C1's and C4's cases): a run beside a whole folder moved into `set-aside/` by hand is refused, and the reading, with no folder left in `results/`, is "not run", naming it; a reading of a whole folder beside a refused one whole by its lines is refused, naming it; the last record's group changed leaves only the count of lines. |
| C6, R6 | Section 7 said "as many lines", the code "at least as many"; the messages called an unreadable log whole without saying why; a dry-run key still said the status names the refused; a "not run" status gave no folders in doubt. | "At least as many"; each refusal gives the reason the test found (the count, the names, the last group, or the error); the key says "counting"; the "not run" status names the folders in doubt. |
| R3 | The module docstring still said the readout lists the groups made again, and did not state the reading's refusal beside a folder in doubt. | Both said. |
| R5 | Section 7's "A run may then go on beside it" followed the reading's sentence, its "it" unclear; section 11's "the reading goes on" held only with no whole folder beside. | The sentence follows the set-aside's; section 11 says "with no whole folder beside it, the reading goes on as partial". |
| R7 | Section 11 said the dry run keeps the group's state files beside the log, but `states_resume` checked only the differing one. | It also checks that every state file of the group is kept. |
| R8 | The reading of a whole folder beside one moved into `set-aside/` by hand was listed among the refusals of a run. | Listed among those of a folder at the reading. |

The nine "none found": the ignore rules against every path a run or `set-aside` writes (twice); no normal path read as whole by its lines but C3's; `set-aside`'s name check and slot loop; the reading's listing, the own-refused case and the no-meta case; section 11's count of 56 and its groups; round 6's counts; the reading time; and round 6's other fixes.

After the fixes, the power check and the dry run were run again on the changed code. Every check holds, the power check's figures are unchanged, and the dry run now meets 61 refusals.
