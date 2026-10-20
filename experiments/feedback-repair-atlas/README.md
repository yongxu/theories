# Feedback and repair atlas

This is a checked Lean model of one working exchange, together with an offline page for exploring it. Alex hands back Maya's draft with four words: "This needs work." The model asks three linked questions:

1. **Reading one remark.** What can the wording settle about the situation behind it? There are two separate facts: whether the draft has an error, and whether the delivery was personal.
2. **Learning across exchanges.** How does each side's reading of the other change as exchanges add up? A reading has three parts: expectation, confidence and credibility.
3. **The link.** Maya's reply to the next remark comes from her reading. A guarded reply treats the remark as personal, and a constructive reply treats it as not personal. Can any history make that reply right in every situation?

Each part builds on the one before. Part 3 takes Part 1's question and asks it of the readings that Part 2 produces. The answer is no. For every reading, and so for every course of exchanges, the reply misreads some admitted situation. Learning changes which way the reply errs, not whether the remark alone can be read correctly.

Open [index.html](index.html) locally, or serve this directory:

```sh
python3 -m http.server 8000 --directory experiments/feedback-repair-atlas
```

The page is self-contained. It makes no network requests and loads no external scripts, and it stores nothing.

## The model

Everything is in a single module, [model/FeedbackAtlas.lean](model/FeedbackAtlas.lean), with 41 theorems and 83 audited declarations.

| Part | Main statements | What they show |
|-|-|-|
| §1 Reading one remark | `no_personal_judge_from_remark`, `task_error_does_not_settle_personal`, `task_judge_exists`, `request_without_verdict`, `confirmed_error_still_not_personal` | The wording settles neither fact. A checked finding settles the error, but not the delivery. Asking for specifics needs no verdict. |
| §2 Learning across exchanges | `defense_keeps_confidence_low`, `same_lapse_different_updates`, `responder_history_changes_reply`, `initiator_history_interrupts_returned_defense`, `same_explanation_different_effect`, `readings_evolve_without_record` | Under the supplied laws, the same lapse lands differently on different histories, and a run of defense never builds confidence above 2. |
| §3 The link | `every_reading_misreads_some_case`, `no_reading_settles_personal`, `every_course_misreads_some_case` | No reading, and so no course of exchanges, makes the reply right in every admitted situation. |

The update laws are stated in the docstring of `learn` and on the page. [model/EVIDENCE.md](model/EVIDENCE.md) records what each law draws on in trust-learning research, and what the studies do not support. Two choices follow the cited evidence directly:

- A defensive move lowers confidence (c′ = ⌊c/2⌋ + 1) as well as expectation. A reading built from defense therefore stays easy to revise, which matches Siegel et al. (2018). The superseded model raised confidence after every move.
- Credibility has its own evidence weight, so a checked explanation updates it by the same evidence-weighted form as expectation. The superseded model always moved credibility halfway.

**What the proofs say exactly.**

- `readings_evolve_without_record` shows that the readings evolve on their own: the update laws never read the records, which are kept only as a trace.
- Every expectation and credibility stays between 0 and 1 because each one is a `Share` by type. The content of that bound is `weighted_bound`.
- The examples are synthetic, and each number is checked by `decide`.

**What the model takes from the Becoming core.** It uses three core laws, and no other law of the theory is carried into this application:

- `Readout.no_judge_of_merged` (with `judges_iff_lumpedOn`): no reduction can judge between situations that it merges. §1 and §3 apply this.
- `wholeNext`: both ends change by the one move the whole forms. §2 builds each exchange with it.
- `Readout.foldl_semiconj`: a reduction that commutes with one move commutes with every course of moves. §2 applies it to the readings.

The module also uses the one-step inquiry (`judgeProcess`, `commonResponse_judge_iff`, `commonResponse_antitone`) and `Naturals.mul_right_comm`.

**Relational basis.** The joint state is the record of one exchange, read from its two ends. The two readings are not attributes of two independent people: both change through the same formed exchange, and only through what passes between the ends. The split stands for the two ends of that one relation. It leaves out everything else either end takes part in, how the ends came to be, and any change that no observed move carries.

**What is supplied.** The situations, the evidence functions, the update laws, the 2/3 decision probe and the example histories are all modelling choices. The proofs establish their consequences. They say nothing about anyone's actual motives, worth or safety, and they create no obligation to remain in an exchange.

## Verification

```sh
LEAN=/absolute/path/to/lean python3 -B experiments/feedback-repair-atlas/model/verify_atlas.py
python3 -B experiments/feedback-repair-atlas/build.py --check
node --test experiments/feedback-repair-atlas/tests/*.cjs
python3 -B -m unittest discover -s experiments/feedback-repair-atlas/tests -p 'test_*.py'
```

`verify_atlas.py` requires Lean 4.29.1. It compiles the module against the committed core, rejects compiler warnings, audits the axiom dependencies of every declaration, and writes [model/atlas-verification.json](model/atlas-verification.json). The record contains:

- the SHA-256 hashes of the application's own files (`FeedbackAtlas.lean` and `verify_atlas.py`);
- the core commit and tree the module was checked against.

It does not hash the core's files. A core landing therefore does not invalidate the record, and re-verification is a deliberate step rather than something CI forces. This is a local application check, not the core package's environment and purity audit, which only `check_becoming.py` runs.

`build.py` refuses to build the page in four cases:

- the record is not passing;
- an own file has changed since verification;
- an excerpt comes from an unverified file;
- a core excerpt comes from a commit other than the one checked.

Core excerpts are snapshots stored in [components.json](components.json). [bind_components.py](bind_components.py) writes them with `git show` at the checked commit, and a test compares them with that commit when the clone has it. After a re-verification, rerun `bind_components.py` and then `build.py`. [src/learning.js](src/learning.js) is the browser's copy of §2 and §3. Its tests reproduce every number that the Lean examples check. It is tested, not compiled from Lean.

The `Feedback atlas` CI job runs the page, binding and dynamics checks when this directory changes. It does not install Lean.

## History

The four earlier modules each built a new model rather than refining the one before, and they were joined only by imports. They were consolidated here on 20 October 2026: a Boolean situation model, a Boolean expectation history, a whole-number tally with thresholds, and the three-part fraction model. The six-level page and its unproved team and society views were retired at the same time. All of them are kept unchanged in [history/](history/INDEX.md). The frozen verification logs there contain a local build path from the machine that produced them.
