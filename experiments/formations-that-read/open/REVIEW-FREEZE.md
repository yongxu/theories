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
