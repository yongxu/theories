# WU's landing kit: steps 6 to 10 (AI-written, 13 November 2026)

The commands for the lander, in order, for this landing only, adapted from TT's kit (`../tt-turning-in-time/kit/README.md`). They follow section F of TT's landing checklist (`../tt-turning-in-time/map/landing.md`, steps 6 to 10). Steps 0 to 5 (claim, load check, scratch build, worktree, head clause, merge of main) and 11 to 14 (the gate, the landed clause, the fast-forward) are the checklist's. Nothing here has been run.

Run everything from the root of the clean landing worktree (`/Users/ren/tmp/wu/wt`, branch `wu-way-of-units`), never the shared checkout, with the head clause standing and main merged in. The machine is shared. Before each heavy step, look at `uptime` and `ps` for other heavy runs. Run the step in the background with its log outside the repository (`/Users/ren/tmp/wu/logs/`), and poll the log.

What must be final before step 7: `WayOfUnits.lean` (any byte changes the receipt); `NOTE.md`, `READER.md`, `DESIGN.md`, `DESIGN-attacked.md`, `readers/r3-logic.md` and `readers/v2-premises.md` in this study folder; `theories/becoming/chapters/02-MAP.md` with its section 11; `sources/15-codex-theory-conversations/2026-11-12-where-we-are-and-the-loop.md`. The record hashes them, and a later edit drifts it.

## 6. The core run

```sh
uptime; ps -Ao pid,etime,command | grep -E 'check_becoming|research.py render|gate.py run|scratch_build' | grep -v grep
python3 -B tools/research/gate.py status
mkdir -p /Users/ren/tmp/wu/logs
python3 -B tools/research/gate.py hold -- python3 -B experiments/integrated-correction/general-framework/generative-basis/lean/becoming/check_becoming.py > /Users/ren/tmp/wu/logs/core-run.log 2>&1
```

Never pass an argument to `check_becoming.py` (`--help` is a real run). It must end with status `passed`; a warning or a stray axiom fails it. Then find the run's folder and commit the receipt with it:

```sh
STAMP=$(python3 -c "import json; print(json.load(open('experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-verification.json'))['retained_run'].rsplit('/', 1)[-1])")
echo "$STAMP"
python3 -c "import json; d=json.load(open('experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-checks/$STAMP/verification.json')); print(d['status'], [m for m in ('Becoming.TurningInTime', 'Becoming.WayOfUnits') if m in d['source_sha256']])"
git add experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-verification.json experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-checks/$STAMP
git commit -m "WU: the core run's receipt ($STAMP)"
```

The second line must print `passed` and both modules.

## 7. Bind the new record; rebind TT's two; re-point the drifted ones

This kit fills the record `a-way-of-units`: the references' sha256, the receipt reference, the proof binding and `reviewed_at_utc`. It writes nothing if a referenced file is missing, if the receipt did not pass or does not bind `WayOfUnits.lean`'s current bytes, if a declaration the record names was not elaborated, or if 02 has no anchor `r-a-way-of-units`. A dry run first:

```sh
python3 -B _process/research/2026-10-05-generative-foundation-review/root-foundation/development/wu-a-way-of-units/kit/fill_records.py "$STAMP" --dry-run
python3 -B _process/research/2026-10-05-generative-foundation-review/root-foundation/development/wu-a-way-of-units/kit/fill_records.py "$STAMP"
```

**TT's kit must be run again too.** This landing changes `theories/becoming/chapters/02-MAP.md`, which TT's two records, `going-alike-up-to-the-nets-end` and `turning-in-time`, cite by hash. TT's kit rebinds both to this run. The run binds `GrammarPath.lean`, `GuardedStep.lean` and `TurningInTime.lean` at their unchanged bytes, and the kit rehashes every file the records cite. Read the diff of section 11 against main first: the section gains WayOfUnits' theorems and words, and its sentences on TurningInTime's keep what they say, with "law" now "theorem" where the account proves it.

```sh
git diff main -- theories/becoming/chapters/02-MAP.md
python3 -B _process/research/2026-10-05-generative-foundation-review/root-foundation/development/tt-turning-in-time/kit/fill_records.py "$STAMP" --dry-run
python3 -B _process/research/2026-10-05-generative-foundation-review/root-foundation/development/tt-turning-in-time/kit/fill_records.py "$STAMP"
```

`turning-in-time`'s `validation_scope` called the module "a leaf", which stopped being so once `Becoming.WayOfUnits` imported it. It is corrected in the worktree ("imported by Becoming.WayOfUnits", and "theorems" for the account's proved statements in that sentence), as the root's bullet already says. Read that one-line diff of the record before running TT's kit.

Then re-point the records that cite the live receipt file `becoming-verification.json` by hash, since every core run drifts it. On main at this branch's base there are ten: `confined-rise-within-a-whole`, `drift-offspring-sampled`, `fixation-by-drift`, `fixation-with-selection`, `groups-formed-by-descent`, `selection-with-returns-to-groupmates`, `selection-within-and-among-groups`, `selection-within-and-among-groups-of-any-sizes`, `shaping-read-by-readers-drawn-from-the-selected`, `shaping-the-rule-selected-by-what-comes-back`. First a dry run, then the same command with `--apply`:

```sh
python3 -B tools/research/repoint.py \
  --reason "WU: the core run $STAMP rewrote the live receipt file; the records citing it re-pointed, hash only; nothing any record says changed" \
  --paths experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-verification.json \
  --ids confined-rise-within-a-whole drift-offspring-sampled fixation-by-drift fixation-with-selection groups-formed-by-descent selection-with-returns-to-groupmates selection-within-and-among-groups selection-within-and-among-groups-of-any-sizes shaping-read-by-readers-drawn-from-the-selected shaping-the-rule-selected-by-what-comes-back
```

If main brought a record that cites the file, add its id after reading it, and say so in the reason. No record cites `WayOfUnits.lean`, `Becoming.lean`, `check_becoming.py`, the Lean READMEs, `regions.json`, the atlas entries or the binder mapping.

## 8. Shared laws

```sh
uptime
python3 -B tools/research/gate.py hold -- python3 -B tools/research/shared_laws.py > /Users/ren/tmp/wu/logs/shared-laws.log 2>&1
git diff --stat -- theories/becoming/results/data/shared-laws.json
```

If `shared-laws.json` changed, read the diff: `one-root-to-its-edge` cites it by hash. Where nothing that record says changed, re-point it (`repoint.py --paths theories/becoming/results/data/shared-laws.json --ids one-root-to-its-edge --apply`, with a reason saying why).

## 9. Render

```sh
uptime
python3 -B tools/research/gate.py hold -- make research-render > /Users/ren/tmp/wu/logs/render.log 2>&1
git status --short
```

Run it in the clean worktree only. The untracked files must be only the landing's own. Besides TT's two, twelve other records cite `02-MAP.md` by hash, among them `a-pool-read-off-the-course` and `the-lock-draws-its-readers-out`. Only section 11 changed, so their drift should be scoped and not bearing. If the render's output lists `source_drift` for any of them, read each pair. Re-point only with `repoint.py --drift-json <the render's JSON> --reason "…"`, after reading, and never to silence it. Commit the render's output with the landing.

## 10. Focused checks

```sh
python3 -B tools/research/research.py check --ids a-way-of-units going-alike-up-to-the-nets-end turning-in-time
python3 -B tools/research/research.py lint --ids a-way-of-units going-alike-up-to-the-nets-end turning-in-time
python3 -B -m unittest tools.research.tests.test_atlas
make research-links
make gate-plan
```

`check` must report no error and no drift for the three records. `lint` reports one warning for `a-way-of-units`, `status-restatement` on the second item of `does_not_show`, which is the coordinating session's own sentence. Then step 11 of the checklist: `make gate`, as a bare command, in the background with a log.
