AI-written (Opus checker), 13 November 2026

# K1: what is said against what is proved (WU landing)

Read only. Nothing built, no check run; the scaffolder's lint and check runs are taken as reported. One Python run of a reader's counterexample against the Lean's premises (below).

Read: `Becoming/WayOfUnits.lean` (worktree copy, 902 lines), the record `a-way-of-units.json`, the coordinator's `landing/record-statement.md`, the diff of `02-MAP.md`, `Becoming.lean`, `check_becoming.py`, `README.md`, `README.zh.md`, the reader reports `v2-premises.md` and `r3-logic.md` for the counterexamples, and `TurningInTime.turns_in_time_iff`, `RegimeMargin.step/Short/Meets/Keeps`, `Flow.family_ends_below_at`.

## Verdict

Sound. All 15 record entries match their Lean statements clause by clause: no premise is added or dropped, and the quantifiers are right (`Regime` asked only at `k` with `Goes` at every `j ≤ k`, which is correct; `n ≤ X T < m`; one shared `y₁`, `hi` and start in `more_use_on_first`). The four `does_not_show` items are verbatim. The counterexamples are attributed correctly: With and Against to Lean, the rest to simulation, with the numbers matching the reports. The 66 declarations and 47 theorems are correct. The Chinese says the same as the English. No barred word is used for units, and "law" appears only for Lean's `Law` and the data key `laws`.

Checked and not a defect: the statement leaves out "the net going on until then". Proved premises make that clause redundant. If no unit goes on at step j, the way after it is `[]` and stays `[]`, and `Holds` needs a way that is not empty, so `Holds` at k already gives `Goes` before k. The r3-logic counterexample to `greater_need` without `below` (giving `[0,3,6,3,7,1,6,4,7,0,5,6,4,0]`, parts `(m,1)`, `(4,5)`, from 8) is outside the Lean's premises: for every `hi` ≤ 13, `y₂` and `y₁`, `Keeps`/`Meets` at `H₂` fail. So it does not contradict the header's "the bound below `h + H₂ + y₁`" being found unneeded by v2.

## Findings

1. **missing, chapter `Two units`.** The text says "from a start below the point of no return of what both take" and leaves out the start being at most `hi`. `two_units_iff` takes `high : x ≤ hi`. In TurningInTime's own chapter text, the start at most `hi` is a separate clause from "§5's premises", so "the regime premises of the theorem on turning in time above" does not carry it. Fix: "from a start below the point of no return of what both take and at most `hi`".

2. **overclaim (word), statement and claim, en and zh, record and coordinator text.** "the first needing more" / "第一个所需更多". The Lean has `n ≤ m`, so equal needs are included. Fix: "the first needing at least as much" / "第一个所需不少于第二个". The same applies to "a greater need of the first unit": `m ≤ m'` includes equal, but that case is trivial, so it can stand.

3. **overclaim (word), claim en and zh.** "with a first unit that takes nothing the line is the second unit's alone" / "这条线就只是第二个单元独自的线". What is proved is that the one line never ends exactly where the other never ends (`takes_nothing_iff_alone`), and inside the proof that the levels are the same (`carrier_level_zero`). The configurations differ while the first unit is present. Fix: "...the line never ends exactly where the second unit's line alone never ends". The chapter's and READMEs' wording is right already.

4. **minor, record `statement` field.** It holds only the middle sentence of the coordinator's statement. The full text is verbatim in `claim`. The split is forced by STATEMENT_CAP (300 / 150), and TT's record has no `claim`, so the coordinator should know that the record's `statement` is not their text. No change is needed unless they want another sentence chosen.

5. **word, chapter `What is given` (shared with TT).** Three problems:
   - The paragraph still opens "The marked levels, the need and the kept kind are given, not derived" with no scope. It now sits beside "For a way of units one source of a turn is derived" and `two_units_iff`, where the marks are proved for two units.
   - "The module lies in the Lean's second layer only through two theorems it imports" no longer has one referent, because the section now has four modules and WayOfUnits is in L2 through one import.
   - In "The marks of a way that conditions on a reading are not: there whether a level is marked is a property of levels", "there" has no antecedent. The header's form is "TurningInTime's `marked` is a property of levels".

   Fix: name TurningInTime in the first and third sentences ("In TurningInTime the marked levels ...", "`TurningInTime`'s `marked` is a property of levels"), and say "`TurningInTime` lies ...".

6. **minor, chapter `Two units`.** The list "proved for it, not assumed" gives AloneOutside, turns + kept, and uses. It leaves out `uses₁` (the way as it was takes at least `h + H₂`), which is proved trivially. The list can stand.

7. **missing (minor), record `related` groups-whose-conditions-are-coupled.** It drops the premise "where it is active only while supported" (`dependent : W.active t g → W.Supported t g` in `Flow.family_ends_below_at`). The Lean header keeps that premise. Fix: add it.

8. **missing (minor), record dependency turning-in-time `interface.output`.** It leaves out "the need met there and at every step before". Fix: "...at the first marked level of the course as it was, the need met there and at every step before, the level one step later ...".

9. **minor, `takes_nothing_ends` in `Becoming.lean`, `check_becoming.py` and `README.md`/`.zh`.** "below the second unit's own point of no return, nothing given from nothing and n positive" leaves the premise `Short giving H₂ y₁` to the phrase "point of no return". That is acceptable, but the record and chapter name it. Optional fix: "giving short of H₂ below y₁ and the start below H₂ + y₁".

10. **word (zh).** The title "由单元组成的方式：无需标记的、以终止为纠正" has a dangling 的. Suggest "由单元组成的方式：无需标记、以终止为纠正". "the regime's premises" is 体制前提 here but 调节律的前提 in TT's zh statement, and "exactly where" is 当且仅当 in the statement but 恰当 in law 5 and README.zh. Pick one for each.

11. **minor, chapter title.** The theorem's italic title is "A way of units: a turn with no mark given". The record, the board and the Lean all say "ending that corrects with no mark given". Since this is the coordinator's own text it may be intended, but say so if it is not.

Unchecked: atlas entries, the binder mapping rows, the kit. These are not in this share.
