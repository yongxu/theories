# TT's landing kit: steps 6 to 10 (AI-written, Claude Opus 5.5, 13 November 2026)

The commands for the lander, in order, for this landing only. They follow section F of the landing checklist (`map/landing.md`, steps 6 to 10); steps 0 to 5 (claim, load check, scratch build, worktree, head clause, merge of main) and 11 to 14 (the gate, the landed clause, the fast-forward) are the checklist's. Nothing here has been run.

Run everything from the root of the clean landing worktree (`/Users/ren/tmp/tt/wt`, branch `tt-turning-in-time`), never the shared checkout, with the head clause standing and main merged in. Below, `LEAN` stands for `experiments/integrated-correction/general-framework/generative-basis/lean/becoming`; the commands write it out. The machine is shared: before each heavy step look at `uptime` and `ps` for other heavy runs, and run the step in the background with its log outside the repository (`/Users/ren/tmp/tt/logs/`), polling the log.

What must be final before step 7: the three Lean files (any byte changes the receipt); `NOTE.md`, `READER.md`, `DESIGN.md`, `DESIGN-R2.md` and `NEAR-WORK.md` in this study folder; `theories/becoming/chapters/02-MAP.md` with §11; `sources/15-codex-theory-conversations/2026-11-12-where-we-are-and-the-loop.md`. The records hash them, and a later edit drifts the records.

## 6. The core run

```sh
uptime; ps -Ao pid,etime,command | grep -E 'check_becoming|research.py render|gate.py run|scratch_build' | grep -v grep
python3 -B tools/research/gate.py status
mkdir -p /Users/ren/tmp/tt/logs
python3 -B tools/research/gate.py hold -- python3 -B experiments/integrated-correction/general-framework/generative-basis/lean/becoming/check_becoming.py > /Users/ren/tmp/tt/logs/core-run.log 2>&1
```

Never pass an argument to `check_becoming.py` (`--help` is a real run). It must end with status `passed`; a warning or a stray axiom fails it. Then find the run's folder and commit the receipt with it:

```sh
STAMP=$(python3 -c "import json; print(json.load(open('experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-verification.json'))['retained_run'].rsplit('/', 1)[-1])")
echo "$STAMP"
python3 -c "import json; d=json.load(open('experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-checks/$STAMP/verification.json')); print(d['status'], [m for m in ('Becoming.GrammarPath', 'Becoming.GuardedStep', 'Becoming.TurningInTime') if m in d['source_sha256']])"
git add experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-verification.json experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-checks/$STAMP
git commit -m "TT: the core run's receipt ($STAMP)"
```

The second line must print `passed` and all three modules.

## 7. Bind the new records; re-point the drifted ones

The kit fills both records (references' sha256, the receipt reference, the proof bindings, `reviewed_at_utc`), and refuses, writing nothing, if a referenced file is missing, the receipt did not pass or does not bind a proof source's current bytes, a declaration is not elaborated, or 02 lacks the anchor. A dry run first:

```sh
python3 -B _process/research/2026-10-05-generative-foundation-review/root-foundation/development/tt-turning-in-time/kit/fill_records.py "$STAMP" --dry-run
python3 -B _process/research/2026-10-05-generative-foundation-review/root-foundation/development/tt-turning-in-time/kit/fill_records.py "$STAMP"
```

Then one re-point, so that the landing writes one line of `_process/architecture/rebinds.jsonl`. Found by reading every record's references (13 November, on the branch at `3582ee38c`):

- **GrammarPath.lean by hash**, each with a proof binding to `becoming-checks/20261106T132906.779148Z/verification.json`: `constancy-read-at-a-members-class`, `what-a-line-holds-and-a-regularity-takes-in`, `what-leaves-a-class-follows-its-line`. GrammarPath changed by seven added laws and header sentences only; none of the three records names a declaration that changed, and none says anything about going alike or a cut step (checked by search), so nothing they say changes: rebound, no history note.
- **The live receipt file `becoming-verification.json` by hash** (role `receipt`), drifted by every core run: `confined-rise-within-a-whole`, `drift-offspring-sampled`, `fixation-by-drift`, `fixation-with-selection`, `groups-formed-by-descent`, `selection-with-returns-to-groupmates`, `selection-within-and-among-groups`, `selection-within-and-among-groups-of-any-sizes`, `shaping-read-by-readers-drawn-from-the-selected`, `shaping-the-rule-selected-by-what-comes-back`.

No record cites `GuardedStep.lean`, `TurningInTime.lean`, `Becoming.lean`, `check_becoming.py`, the Lean READMEs or `regions.json`. Read the GrammarPath diff against main first (`git diff main -- experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarPath.lean`), then a dry run, then the same with `--apply`:

```sh
python3 -B tools/research/repoint.py \
  --reason "TT: GrammarPath gained seven laws and header sentences after «有常则至终有常» (additions only, read against main); the three records citing it rebound to core run $STAMP, which binds its current bytes and passed; the records citing the receipt file re-pointed, hash only; nothing any record says changed" \
  --receipt experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-checks/$STAMP/verification.json \
  --lean experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarPath.lean \
  --paths experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarPath.lean experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-verification.json \
  --ids constancy-read-at-a-members-class what-a-line-holds-and-a-regularity-takes-in what-leaves-a-class-follows-its-line confined-rise-within-a-whole drift-offspring-sampled fixation-by-drift fixation-with-selection groups-formed-by-descent selection-with-returns-to-groupmates selection-within-and-among-groups selection-within-and-among-groups-of-any-sizes shaping-read-by-readers-drawn-from-the-selected shaping-the-rule-selected-by-what-comes-back
```

The dry run must list exactly those thirteen records, the first three with GrammarPath.lean rebound and the receipt added, the other ten with `becoming-verification.json` only. Add `--apply` and run it once. If main brought a record that cites either file, or the merge changed one of these, add or drop its id after reading it, and say so in the reason.

## 8. Shared laws

```sh
uptime
python3 -B tools/research/gate.py hold -- python3 -B tools/research/shared_laws.py > /Users/ren/tmp/tt/logs/shared-laws.log 2>&1
git diff --stat -- theories/becoming/results/data/shared-laws.json
```

If `shared-laws.json` changed, read the diff: `one-root-to-its-edge` cites it by hash. Where nothing that record says changed, re-point it (this adds a second rebinds line; the reason says why):

```sh
python3 -B tools/research/repoint.py --reason "TT: shared-laws.json regenerated after the core run $STAMP (the new laws of GrammarPath, GuardedStep and TurningInTime); read against main, nothing one-root-to-its-edge says changed; hash only" --paths theories/becoming/results/data/shared-laws.json --ids one-root-to-its-edge --apply
```

Commit the records, the rebinds line and `shared-laws.json` together with the rest of the landing's content (records, chapter, regions, registration, study folder) before the render.

## 9. Render

```sh
uptime
python3 -B tools/research/gate.py hold -- make research-render > /Users/ren/tmp/tt/logs/render.log 2>&1
git status --short
```

In the clean worktree only; the untracked files must be only the landing's own. The render writes the record pages of the two new records, the study `INDEX.md`, `_process/research/README.md`, `LEAN-INDEX.md` and `lean-index.json` (the held attempt is a `.txt` and is not catalogued as Lean), the theory graph and the other generated views. If its output lists `source_drift`, read each pair and re-point only with `repoint.py --drift-json <the render's JSON> --reason "…"` after reading; never to silence it. Commit the render's output with the landing.

## 10. Focused checks

```sh
python3 -B tools/research/research.py check --ids going-alike-up-to-the-nets-end turning-in-time constancy-read-at-a-members-class what-a-line-holds-and-a-regularity-takes-in what-leaves-a-class-follows-its-line
python3 -B tools/research/research.py lint --ids going-alike-up-to-the-nets-end turning-in-time
make research-links
make gate-plan
```

`check` must report no error and no drift for the two new records and the three rebound ones; `lint` should report nothing for the two (it was clean on the drafts). Then step 11 of the checklist: `make gate`, as a bare command, in the background with a log.
