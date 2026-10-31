# OU7 part B: the landing pieces

AI-written, 31 October 2026, for the one OU7 kit that joins part A (its design on fork 1's branch `ou5-design`) and part B ([the design](../DESIGN.md), [its review and re-check](../review/FINDINGS.md)). Part B adds two leaves, one record and its home section, and one clause in `GrammarTesting`'s header. OU's owner decides what lands and when. Nothing here runs in the package until the owner gives the word; the core run is the near-full rebuild, last in the core round, after RV21c.

The landing scripts are part A's kit's (`kit/` beside `check/`). `make_record_ou7b.py` builds this record from `record-text.json`. `integrate_ou7.py` places the leaves, the bullets, the rows, the home section, the regions entries, the register entries and the study lines from the files here; it writes the scope sentences and the Chinese rows itself. Its `dry_run.py` passed every stage with these files on 1 November, on main at 753460b81, with no finding on either record.

## What OU's owner decided (31 October)

- The names: ten `«»` names, two renamed after the review (`«给过所取则生守相杂»`, `«有给之室以温不可分»`). The English names stay English in `Rooms`.
- Two modules: `Becoming.RoomNet` reads the grammar only, and `Becoming.RoomRuns` is the bridge.
- The items not done go into the record's next step and the home section's open lines, as they stand.
- Part A and part B merge into one kit branch.

## The pieces

| file | what it is | where it goes |
|---|---|---|
| `../scratch/Becoming/RoomNet.lean`, `../scratch/Becoming/RoomRuns.lean` | the two leaves (120 declarations with 94 theorems, and 27 with 24), every axiom report empty, no warning; built by the scratch builder (`../scratch-build.log`) | the package's `Becoming/`, byte for byte (`cmp`) |
| `record-text.json` | the record `rooms-tested-by-a-window`, every prose field in English and Chinese; laws, hypotheses, boundary, correspondence, counterexamples, next step, dependencies with interfaces, aliases | `theories/becoming/results/records/rooms-tested-by-a-window.json`, without the kit's keys `about`, `home` and `modules`, with the fixed fields added from the landing's receipt |
| `check_record_b.py`, `built-declarations.txt` | a check before landing: every declaration the record names was built (51 of 147), and the record, completed with stand-in fixed fields, passes `style.lint` and `registry.validate_v2_fields` with no finding | run from the repository root: `python3 -B <kit>/check_record_b.py` |
| `home-03-section-3.txt` | the home section | `theories/becoming/chapters/03-KNOWING.md`, §3: after the paragraph beginning `**Open.** That this converse`, before `<a id="r-testing-within-couplings"></a>` |
| `GrammarTesting.patch` | one clause in `GrammarTesting`'s header bullet on `«恒温与平衡»`, pointing to the derived model; against blob `3cb42ce` (main) | `git apply` before the run; OU's owner's edit |
| `apart-reasons.json` | the register entries for the leaves' apart roots (28 predicted) and the six register roots the leaves now use | the register stage (U1b's `REASONS` and `NOW_USED`) |
| `becoming-lean-bullets.txt`, `package-readme-rows.txt` | the two leaves' summary bullets and README rows | the package's `Becoming.lean` and `README.md` |
| `study-lines-b.md` | part B's lines for OU7's study section | `BECOMING-RENEWAL-READING.md`, section N |

## The leaves' places

Each of the two modules has four places, which the land script's prepare stage checks survive the merge once each (as U1b's do):
1. **The list** in `check_becoming.py`. As `UnitMatchings` does, the list is `CORE`; insert `"Becoming.RoomNet", "Becoming.RoomRuns"` after `"Becoming.RegimeMargin"` (compile order comes from the imports). The ring's `INSTANCES` would fit too: they read general laws on one named carrier (`Rooms.Occurrence`), as `Hexagrams` and `PlaceTransitionNets` do. Both meet the ring's conditions: no core module imports them, and neither imports an application. Which list they go in is OU's owner's decision.
2. **The import** in `Becoming.lean`: `import Becoming.RoomNet` and `import Becoming.RoomRuns` after `import Becoming.RegimeMargin`.
3. **The README row**: `package-readme-rows.txt`, after `Becoming.RegimeMargin`'s row.
4. **The kit's copy** equal to the package's.

The summary bullets in `becoming-lean-bullets.txt` go after `Becoming.RegimeMargin`'s bullet. `theories/becoming/results/data/regions.json` gains three entries:
- under `records`, `"rooms-tested-by-a-window": {"region": "knowing", "base": "grammar", "note": "RoomNet, RoomRuns OU7: rooms tested by a window, regulation and equilibrium on the net of the possible"}`;
- under `modules`, `"Becoming.RoomNet": {"region": "knowing", "base": "grammar", "note": "rooms on the net of the possible: one rule, testing, regions, a conditional law, the toy derived"}`;
- under `modules`, `"Becoming.RoomRuns": {"region": "knowing", "base": "frame", "note": "the rooms' window courses as RegimeMargin runs; the possible with warmth held"}`.

## What the run changes beyond the leaves

- **`GrammarTesting`'s bytes.** The clause changes a core source, so the run re-receipts it. `testing-within-the-net`'s reference hash and proof binding then move to the landing's receipt, with a line in its history saying why (its header gained a pointer to the derived model). This is a real change of bytes with a new receipt, not a refreshed hash.
- **The connectivity register.** RoomRuns reaches the base through `Law.run`, so what it uses is not apart. RoomNet's other theorems stand apart, and those no other apart theorem uses are roots: 28 predicted in `apart-reasons.json`, each a fact about one constructed family of models (`model-witness`, one `support`). Six register roots of the map, all `general-structure`, are now used by RoomNet and stop being roots: `«全守有终不并»`, `«全生成全守不并»`, `«守退化不并»`, `«有终则粗不有常»`, `«后守退化不并»`, `«守则后守»`. Their entries go. The rehearsal's `THEOREM-CONNECTIVITY.py --check` gives the exact lists, and any difference stops for reading.
- **MV's data.** `master_laws.py` is rerun on the landing's receipt; the new record's laws are read by it like any other.
- **The two step theorems nothing uses**, `Unheated.b1_b0` and `Matched.start_kept`, stay as steps of the models and are registered as roots: the review read them, and removing them would change the modules it read.

## Before landing

```bash
python3 -B _process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou7-conditional-laws/check/kit/check_record_b.py
```

The scratch build, from the repository root; it runs in the package folder in a subshell, builds nothing in the package and reuses the package's steps by content:

```bash
R=$PWD; ( cd experiments/integrated-correction/general-framework/generative-basis/lean/becoming && python3 -B scratch_build.py "$R/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou7-conditional-laws/check/scratch" Becoming.RoomNet Becoming.RoomRuns )
```
