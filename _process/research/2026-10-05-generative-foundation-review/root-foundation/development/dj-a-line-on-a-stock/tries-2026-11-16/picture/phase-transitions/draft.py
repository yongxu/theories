import json
out = {
"answer_in_one_paragraph": "The thresholds are already there. Almost all are one of three boundaries seen in several models: a level against a draw plus its root (H + y), a draw against a renewal (k ≤ r), a share against a critical mass. Each separates ending from never ending for one course, or one lock from its reverse. Closed regions are named elsewhere (生成/后守/退化, Viability.Kernel, RuleRebuilding's Within), and no threshold of the centre is stated between two of them. Lock to renewing is stated only as ending or not from a Locked start, the reading and the renewal given.",
"what_exists": [
 {"what": "Point of no return: a level, and the same as a step",
  "where": "RegimeMargin.lean:741; TurningInTime.lean:2100; ReadOffInTime.lean:661",
  "statement_in_plain_words": "A level comes to nothing exactly where it starts below H + y. A falling course's point of no return is its first step below that; a loss is readable in time exactly where the first step apart comes earlier.",
  "given": "A standing draw; giving a function of what is left."},
 {"what": "Turning in time; the lock on a stock",
  "where": "TurningInTime.lean:1070, :1633, :1817, :1232",
  "statement_in_plain_words": "The line never ends exactly where the level one step after the first marked level is at or above the corrected kind's H₂ + y₂; so too from a Locked start, whose region is closed.",
  "given": "The marks, what they set, the overdraw. Docstring :1615: nothing is concluded about whether what goes on is Locked."},
 {"what": "A line on a stock",
  "where": "LineOnAStock.lean:1239, :1840",
  "statement_in_plain_words": "Never ends exactly where the course reaches a state with every need met and the level at or above what the way takes plus its root. No threshold on the start: seven ends, six does not.",
  "given": "Offspring together take the same and need no more."},
 {"what": "Draw against renewal, with its deadline",
  "where": "Optimum.lean:2342, :2396",
  "statement_in_plain_words": "A level at its need stands for ever exactly where k ≤ r; over it, the need is still met at T exactly where the start is at least m + T(k − r).",
  "given": "Exactly r given at or above the need."},
 {"what": "Critical mass, between two locks",
  "where": "DrawnShaping.lean:227; ReadInTime.lean:292, :319; ChoiceCountCapture.lean:291, :343",
  "statement_in_plain_words": "Read from step N, a course is locked for the shapers for good or against them for good, by which side of a critical share it is on; one step is undecided.",
  "given": "Readers drawn from the selected; no stock."},
 {"what": "A rule rebuilt from its members",
  "where": "RuleRebuilding.lean:897, :1197, :698",
  "statement_in_plain_words": "From the steady state the rule is held for ever exactly inside a band of quotas; a region is closed with the level never falling; no holder stays no holder.",
  "given": "Steady state only (:55). Imports neither RegimeMargin nor RuleCapture."},
 {"what": "Two named regions against a stock",
  "where": "LineageRegimes.lean:1086; MapRegions.lean:128",
  "statement_in_plain_words": "At every stock one gated course generates and another degenerates: with giving free, the stock decides neither. Every point generates, keeps from some point on, or degenerates.",
  "given": "Excluded middle for the cover."}
],
"same_thing_under_two_names": [
 "H + y: RegimeMargin.ends_iff_below, TurningInTime.unending_iff_above (:958), recoverable_iff_above (:2087), joined. ReadOffInTime.recoverable_iff_regime (:1097) is the same boundary in a witness, not derived (TurningInTime.lean:294).",
 "k ≤ r, unjoined: Optimum.kept_iff_within, RuleRebuilding «恒取不逾生则存» (:493), RegimeMargin.ends_beyond_giving (:721). reread_deadline_iff is the exact form of RegimeMargin.not_before with falls_within (:875, :910).",
 "'Never ends' of a guarded step (GuardedStep.lean:143) is membership in Viability.Kernel (Viability.lean:55); no unending_iff says so.",
 "One window twice: ReadInTime's (the share passes critical mass before the reading) and turns_in_time_iff_before (:2289, T + 1 < N)."
],
"what_is_missing": [
 "A threshold stated between two named closed regions. RegimeMargin proves each side closed (holds :730, stays_ended :712) and names neither; the centre's modules never mention 生成, 守 or 退化.",
 "A lock-to-renewing boundary. The lock family's exits reach the reverse lock (ReadInTime.turned_iff); on a stock the far side is a fixed draw that a given regime meets, and a late reading ends corrected: three fates.",
 "In the atlas no transition's 'between' names a dynamic, and turning-in-time has no exit to margin-of-a-regime."
],
"outgrown_words_or_models": [
 "ONE-PAGE.md:30 says of 'a lock, once formed' the exact sentence that needs the corrected kind kept; Three.read_at_eight_ends (TurningInTime.lean:2638) refutes it for a lock.",
 "The plan's item 4 calls 'no exact point on a level where giving is free' argued on paper; LineageRegimes.stock_forces_neither is a Lean statement of it for gated pairs.",
 "'Four routes of transition, none a proved phase transition' (05-COLLECTIVES.md:365): a parameter change, and a correction too late or stopped, have exact theorems in RegimeMargin and TurningInTime; the atlas entry cites none.",
 "The atlas kind 'exact threshold' (31 of 105 transitions) means 'an iff'; it includes enabledness conditions (Revising.rebuild_enabled_iff)."
],
"candidate_links": [
 {"from": "RegimeMargin.ends_iff_below", "to": "Viability.Kernel", "kind": "a case",
  "statement_to_try": "The kernel of 'level positive, at most hi' is exactly [H + y, hi], and below H + y is closed; unending_iff_above is read off it.",
  "why_it_might_fail": "The guards differ (nothing left; need unmet). It may delete no proof."},
 {"from": "TurningInTime.locked_closed", "to": "share_corrected_stays, RegimeMargin.holds", "kind": "an exact boundary between two regions",
  "statement_to_try": "From a Locked start a course stays Locked until it ends, or enters and stays in 'share Low, rule kept, level at least H₂ + y₂', exactly where the level after the first reading is that high.",
  "why_it_might_fail": "A late reading is a third fate; the regions are not shown disjoint; the renewal stays given."},
 {"from": "Optimum.reread_deadline_iff", "to": "TurningInTime.noReturnAt_iff_first_below", "kind": "a case",
  "statement_to_try": "With r given while the need is met and k > r drawn, the point of no return is the step T with m + T(k − r) ≤ x₀ < m + (T + 1)(k − r).",
  "why_it_might_fail": "Optimum gives on the level before the draw, RegimeMargin on what is left."},
 {"from": "ReadInTime.kept_early_iff", "to": "ReadOffInTime.NoReturnAt", "kind": "a case",
  "statement_to_try": "The first step at which the late reading favours the shapers is the point of no return of the lock's share course.",
  "why_it_might_fail": "One step is undecided and opens a new round (Window.too_late); NoReturnAt is typed on levels."},
 {"from": "LineOnAStock.unending_iff_holds", "to": "MapRegions «三域之周»", "kind": "an exact boundary between two regions",
  "statement_to_try": "Short of a holding state the line degenerates; from one it keeps from some point on exactly where in the end every unit leaves only its like, and generates otherwise.",
  "why_it_might_fail": "Units are kinds without identity, so 'a part begins' may be empty; deciding 后守 is LPO."}
],
"what_ran": "AI-written. Read only: grep and sed over the Lean, short scans of theorem statements and of dynamics.json (scripts in /Users/ren/theories/tmp/r7/one-model/check/round10/phase-transitions/), git log for dates. No build, test or gate. Lean files: /Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/. Statements and docstrings read, not proofs."
}
def words(x):
    if isinstance(x,str): return len(x.split())
    if isinstance(x,list): return sum(words(v) for v in x)
    if isinstance(x,dict): return sum(words(v) for v in x.values())
    return 0
for k,v in out.items(): print(k, words(v))
print('total', words(out))
json.dump(out, open('tmp/r7/one-model/check/round10/phase-transitions/draft.json','w'), ensure_ascii=False, indent=1)
