# AI-written (Fable), 16 November 2026: the reader's answer as data, to count its words before returning it.
import json
D = "/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/"
exact = [
 ("WayOfUnits.after", D+"WayOfUnits.lean", "147",
  "def after (w : List (Nat × Nat)) (x : Nat) : List (Nat × Nat) := GrammarLaws.keep (goes x) w"),
 ("WayOfUnits.unending_iff_holds", D+"WayOfUnits.lean", "450-455",
  "theorem unending_iff_holds {giving y : Nat → Nat} {hi : Nat} {w : List (Nat × Nat)} {x : Nat}\n    (needs : ∀ u, u ∈ w → 0 < need u) (nothing : RegimeMargin.FromNothing giving) (high : x ≤ hi)\n    (along : ∀ k, (∀ j, j ≤ k → Goes (course giving (w, x) j)) →\n      Regime giving y hi (course giving (w, x) k).1) :\n    «不穷» (net giving) «一» (w, x) ↔\n      ∃ k, (∀ j, j < k → Goes (course giving (w, x) j)) ∧ Holds y (course giving (w, x) k)"),
 ("GrammarLaws.keep_congr", D+"GrammarLaws.lean", "455-456",
  "theorem keep_congr {p q : α → Bool} : ∀ l : List α, (∀ x, x ∈ l → p x = q x) →\n    keep p l = keep q l"),
 ("SelectionTerm.Generations.born_eq", D+"SelectionTerm.lean", "448",
  "theorem born_eq (t : Nat) : born (G.family t) (G.kids t) = G.size (t + 1)"),
 ("SelectionTerm.Generations.reached_from", D+"ReadingsPersist.lean", "266-267",
  "theorem reached_from (G : Generations α) (T : Nat) :\n    ∀ n x, x ∈ G.family (T + n + 1) → ∃ y, y ∈ G.family T ∧ «及» (G.descentFrom T) (T, y) (T + n + 1, x)"),
 ("SelectionTerm.Generations.kept_of_descent", D+"ReadingsPersist.lean", "293-295",
  "theorem kept_of_descent {G : Generations α} {Q : α → Prop}\n    (keeps : ∀ t p k, p ∈ G.family t → k ∈ G.kids t p → Q p → Q k) (founders : ∀ x, x ∈ G.first → Q x) :\n    ∀ t x, x ∈ G.family t → Q x"),
 ("TurningInTime.agrees_until_marked", D+"TurningInTime.lean", "427-430",
  "theorem agrees_until_marked {marked : Nat → Prop} {alone : W → W} {after : W → Nat → W}\n    (outside : AloneOutside marked alone after) (left : W → Nat → Nat) (s : W × Nat) :\n    ∀ n, (∀ j, j < n → ¬ marked (Law.orbit (asItWas alone left) s j).2) →\n      Law.orbit (pair after left) s n = Law.orbit (asItWas alone left) s n"),
 ("TurningInTime.ends_with_net_regime", D+"TurningInTime.lean", "550-558",
  "theorem ends_with_net_regime {marked : Nat → Prop} {alone : W → W} {after : W → Nat → W}\n    (outside : AloneOutside marked alone after) {need : Nat} (needs : 0 < need)\n    (un : ∀ x, need ≤ x → ¬ marked x) {giving : Nat → Nat} {use : W → Nat} {H y : Nat}\n    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)\n    {w : W} {x : Nat} (uses : ∀ j, H ≤ use (Law.orbit alone w j)) (below : x < H + y) :\n    ∃ n t, n ≤ x ∧\n      «迭» (net need after (fun w x => RegimeMargin.step giving (use w) x)) n (w, x) t ∧\n      (∀ v, ¬ net need after (fun w x => RegimeMargin.step giving (use w) x) t v) ∧\n      t.1 = Law.orbit alone w n"),
]
findings = [
 ("(a) WayOfUnits is a leaf in Lean; what binds it lies outside Lean.",
  "grep 'import Becoming.WayOfUnits': only Becoming.lean:401; TurningInTime names it once, in a docstring (664). Record a-way-of-units.json: 40 declarations, proof_bindings to /source_sha256/Becoming.WayOfUnits of receipt 20261113T133009. Atlas dynamics.json, entry turning-in-time: 37 of 142 declarations. premises.json: 10 entries."),
 ("(a) Generalised in place, 55 of 85 declarations change statement (fit/wu_decls.py).",
  "Sections 1-4: all but all_iff_while, length_keep_le, length_keep_lt. Sections 5-8: twoWay, taken_twoWay, after_twoWay, goes_twoWay, course_twoWay, goes_iff_carrier, unending_iff_carrier, two_units_iff, unending_above, unending_needs_nothing, greater_need, more_use_on_first, goes_iff_alone, takes_nothing_iff_alone, takes_nothing_ends. Sections 9-10: all but GivenFromNothing.giving and .regime. Sections 5-9 stand on the literal way [(m, h), (n, H₂)]: re-instantiated, not generalised."),
 ("(a) Less mass for the same joins: a new module importing WayOfUnits and ReadingsPersist, its first theorem the bridge to kids u = [u].",
  "In place adds no join and costs a core run and re-pointing record, atlas and premise rows. TurningInTime's import closure (fit/imports.py) has SelectionTerm, Capture, Flow, RuleCapture, PoolFromCourse; not ReadingsPersist, LineageDrawdown, ReadingsSpread. Stated again at a general unit type: met_or_unmet (250), mem_after_iff (261), goesDecidable (313)."),
 ("(c) A met unit with no kids ends the net with every need met (try 1).",
  "B excludes it (use u < taken (kids u) forces kids u ≠ []); C, D, E do not."),
 ("(c) C's only-if is false as written; without its clause 'the way unchanged by the step' its if is false.",
  "Tries 2-4. The level reads the way only through taken (left, WayOfUnits.lean:155), so what must stand is taken, not the way."),
 ("(c) B1 fails for the empty way and holds at step 0 for a reason that is not growth. B2 held wherever tried, and fails without need v ≤ need u.",
  "Try 5: 1,647 of 15,675 starts already had an unmet need."),
 ("(c) B says nothing of WayOfUnits, and LineageDrawdown.Drain is not a case of it.",
  "At kids u = [u] the premise reads use u < use u. Drain: kidsP is step-indexed (LineageDrawdown.lean:306-312, '| 5 => bif t == 9 then [] else [7]'), its draw grows at one step only, member 2 is childless while active, and ungated the renewer gives three whatever the pool (giveOf, 250-252): read as L's giving, FromNothing fails."),
 ("(c) A1-A3 hold unchanged with the stock removed, the page's own criterion A(3).",
  "They speak only of after, which mentions neither giving nor left. A4 uses the stock, and is RegimeMargin.ends_iff_below (RegimeMargin.lean:741) on one unit (try 6)."),
 ("(c) E2 at one step is mem_after_iff (261); along a course it is false. D3's second half is the definition of alike. E3's last clause is false of the level.",
  "With.way = [(9, 4), (1, 1)] never ends (1022); Against.way = [(9, 1), (1, 4)] ends (1096): same needs and sum, uses differ. Try 7."),
 ("(d) reaches_holds (405) and unending_iff_holds reach a witness by bounded search.",
  "Law.stepWhile_unending_iff (GuardedStep.lean:143) turns «不穷» into ∀ n. reaches_holds recurses on a bound ℓ on the way's length; met_or_unmet and Nat.lt_or_ge decide each stage; below taken + y, falls (368) finds the first unmet step by first_of_decided (ReadOffInTime.lean:196) within the z steps RegimeMargin.ends_below (705) gives; length_keep_lt (234) lowers ℓ. Backward: Nat.lt_or_ge, le_dest, stays (356, on RegimeMargin.holds, 730)."),
 ("(d) Hardest: B2 where units are shed, and any only-if of C. flatMap has no length measure.",
  "A measure that survives: a bound on the needs in the way. With need v ≤ need u, after a step with an unmet need every need is at most the level, below the old bound. For C beyond a standing draw nothing decides at a step: reaches_holds decides by the level against taken + y of one fixed way."),
 ("(e) What could retire or become a one-line case.",
  "reaches_holds and unending_iff_holds: the case kids u = [u] of C for descent that keeps the draw; length_keep_le/lt then serve only after_eq_iff (268), which nothing uses. mem_course_iff's forward half: kept_of_descent. step_falls (671) and TurningInTime.held_above (665) are one fact proved twice; B needs it again. taken (150) is Prelude.total (Prelude.lean:760) at use, redefined. Three.lock_share_stays, rise_orbit, rise_above, rise_lock_ends (TurningInTime.lean:2110-2166) become one case once the use reads the share; now lockUse v = use v.2.1 (2058)."),
]
already = [
 "A1 at kids u = [u]: keep_congr.",
 "A2: born_eq, once the way is Generations.family (SelectionTerm.lean:421-423) with kids t u := kids u where need u ≤ the level at step t, else []. Generations.kids is step-indexed (413), so the generations depend on the start.",
 "A3: agrees_until_marked at marked := (· < M), alone := (·.flatMap kids), M bounding every need. It joins L to the pair's orbit without the guard.",
 "B with all needs equal to n: ends_with_net_regime at marked := (· < n), H := y := hi + 1 (Short follows from Keeps at use 0) from the step where taken passes hi; the rise from Flow.total_lt_of_mem (Flow.lean:138) and Generations.total_flatMap (SelectionTerm.lean:441). Lock form: locked_ends_with_net_regime (TurningInTime.lean:1222); its draws and below (1231-1232) then follow where the use reads the share.",
 "D1: kept_of_descent at Q := (· ∈ w). E1: reached_from, contraposed. E3: two_units_iff.",
]
hand = [
 ("1. need 1, use 1, kids [], Three.giving, from 12", "(['A'], 12), ([], 12): ended, every need met"),
 ("2. kids A = [B], kids B = [A], need 1, use 1, from 12", "level 12 throughout, way never unchanged, never ends"),
 ("3. need 1, use 0, kids [A, A], from 6", "lengths 1, 2, 4, …; never ends"),
 ("4. need 1, use 0, kids [], from 6", "Holds at step 0, ended at step 1"),
 ("5. Random models meeting B's premises", "with need v ≤ need u all 15,675 ended, within (greatest need)·(hi+3) steps; without it 36 of 18,363 had not after 400"),
 ("6. One unit (1, 5), kids u = [u], from 9 and from 10", "9, 8, 6, 2, 0 ends; 10, 10, … holds"),
 ("7. A = (1, 3), B = (9, 2), kids u = [u], from 9", "with B: 9, 8, then A alone at 6; A alone: 9, 12, …"),
]
obstacles = [
 "TurningInTime.net cuts at one need; WayOfUnits.Goes depends on the way (its header, 102-105). B with unequal needs does not go through ends_with_net_regime.",
 "Nothing was built (load average 111); the tries are computed, not Lean.",
]
suggested = [
 "Bridge: at kids u = [u] on Nat × Nat, L's after is WayOfUnits.after and its course WayOfUnits.course.",
  "One comparison, under need v ≤ need u and positive needs: use u < taken (kids u) ends; taken (kids u) = use u with kids u ≠ [] gives unending_iff_holds; WayOfUnits is the second.",
 "On the pair: AloneOutside, un, FromNothing, Keeps giving 0 hi, x ≤ hi and use rising along alone's orbit give ends_with_net_regime's conclusion with below and short concluded.",
 "The other end of A1: the level's course reads the way only through taken (step_same_sum, 870; carrier_level_zero, 956). With A1 it is one relation, and it uses the stock.",
]
out = {"exact": [dict(name=n, file=f, line=l, statement=s) for n, f, l, s in exact],
       "findings": [dict(claim=c, evidence=e) for c, e in findings],
       "already_there": already, "hand_tries": [dict(world=w, outcome=o) for w, o in hand],
       "obstacles": obstacles, "suggested_statements": suggested}
def words(o):
    if isinstance(o, str): return len(o.split())
    if isinstance(o, list): return sum(words(x) for x in o)
    if isinstance(o, dict): return sum(words(v) for k, v in o.items() if k not in ("file",))
    return 0
for k, v in out.items(): print(k, words(v))
print("total", words(out))
json.dump(out, open("/Users/ren/theories/tmp/r7/one-model/check/round9/readers/fit/answer.json", "w"), ensure_ascii=False, indent=1)
