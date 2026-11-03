# OG2: a rule rebuilt from the members it limits (AI-written design, fifth draft, 2 November 2026)

About ten minutes to read. The Lean is [`Becoming.RuleRebuilding`](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/RuleRebuilding.lean), and its statements are what stand; this draft takes the Lean's reading, [REVIEW-4](REVIEW-4.md). Earlier drafts are at commits `bdf09a1b4`, `72c83470e` and `4544cf2f2`; [REVIEW-1](REVIEW-1.md), [REVIEW-2](REVIEW-2.md) and [REVIEW-3](REVIEW-3.md) are their reviews, and §9 says how each changed the model.

## 1. What this answers

Plan §十三 item 9 asks for each test system of plan §六 with its model. OG gave the organism one ([04 §8](../../../../../../../theories/becoming/chapters/04-LIFE.md#r-the-stock-buys-time-where-the-rebuild-draws-on-it)). The fronts still say an institution has none, and 01 lists as open "an institution's identity through replaced people, rules and purposes". 01 §8.7 has one reading only: an institution kept by consent or by penalty is the thermostat witness with its occurrences renamed.

Three questions a reader would ask:

1. What must hold for a rule to outlive everyone who first held it?
2. What does the rule do, so that this is an institution and not any tradition? And how does it end?
3. Is it the same institution after its people and its rule have changed?

What ends a shared stock is already proved, on the World: takers each within what is renewed can together exceed it, and where the renewal depends on what it renews, that ends it (`Flow.joint_excess_ends`, `Flow.outrun_ends`, [05 §1](../../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#r-own-count-misses-joint-excess)). This model does not restate that as new. Its own questions are two, and they meet in one place:

- **Keeping and limiting.** Those who keep others from a stock draw on it too, so a rule can fail by keeping too few out as well as by letting too many in. This needs no passing: a guard force has the same band.
- **Passing.** A rule held only by members has to pass through them, and from no holder it does not come back.
- **Where they meet.** At the steady state they are two independent conditions. Where some cohorts are empty, passing needs only one held cohort, and the count of held cohorts sets on how many of the steps in a tenure the door is kept and the rule passed (Gaps). The first draft had passing alone, the second a switch, the third claimed a joining of the two that its re-check refuted, and the fourth claimed the count sets how many pass, which the Lean's reading refuted.

## 2. The rule

`Becoming.RuleRebuilding`, an instance of the ring on the grammar, its own leaf.

```lean
inductive Source where | members | outside | none   -- where the rule is taught from
structure Rule where tenure teachingAge renewal untaught strength : Nat; source : Source
structure St where quota level : Nat; holders others : List Nat   -- counts by cohort, youngest first
```

Write `s` tenure, `l` teaching age, `g` renewal, `f` untaught, `c` strength. A state holds a quota, a level the members draw on, and two lists of counts by age. One step, given whether the population offers entrants (`on`) and a revision (`rev : Option Nat`), both chosen at each step, in this order:

1. **The end, and the step stops.** `take` is the count of members, each drawing one unit. Where the level is `0`, or `take` exceeds `level + g`, the state becomes level `0` with no member, its quota kept. Nothing renews from empty.
2. **Draw and renew.** The level becomes `level + g − take`.
3. **Teachers.** `T` is the count of holders of age at least `l`, read before ageing.
4. **Enter**, as a new cohort of age `0` (zero in both lists without `on`):
   - others: `f − c·T`, truncated at `0`. Each teacher turns away `c` of those who would come untaught. One formula for every source.
   - holders: `quota`, where the source is `.outside`, or `.members` with `T > 0`; otherwise none. `.none` has no holder.
5. **Age.** Each list keeps its first `s` cohorts; the oldest leaves.
6. **Revise.** `rev = some r`, at least one holder before the step, and the source not `.outside`: the quota becomes `r`.

`net r` is the relation of all these choices. `Held x := 0 < sum x.holders`. `gone x :=` level `0`, no member. The **leak** at a quota: `e q := f − c·q·(s − l)`. `steady q L := ⟨q, L, replicate s q, replicate s (e q)⟩`, the state whose next step is itself with another level.

**The split and its basis.** Holder and other are not two kinds of thing. They differ in one relation: whether a member's cohort entered holding the rule. Taught by members, a cohort enters holding only where holders of at least the teaching age stand; no pair of teacher and pupil is modelled, only that count, and the same count sets the door. Both draw alike, so a keeper draws on what it keeps, added by nothing else. The quota is a fill and not a limit: holders enter at the quota wherever any teacher stands, even where no one would come untaught, and the door reads the teachers and never the quota. What limits is the teachers' count. The level is what the members share, read here only by how much of it is drawn. Nothing is a utility, and no interest is assumed, opposed or common.

**Modelling choices, stated where laws depend on them:** whole units, discrete steps, one unit a member a step, one quota in common, one tenure, **one age from which a holder both teaches and keeps the door** (split them, and the band and the window become plainly independent: REVIEW-3, run), a constant renewal while anything is left, the order above, all members leaving at the end, an entrant holding what it is taught at once, a rule limiting entry only. §5 says what each variant breaks.

## 3. The laws

Each was run on [sim/sim3.py](sim/sim3.py) with no counterexample, except where marked as a witness. Ranges and what each run covers are in its code. Statements are additive where Lean needs them (`r + k·d = L`, not `L / d`).

- **L1. The constant-take lemma.** Where a family of states has a constant `take` of `A` and is closed under the step while the step does not end: where `A ≤ g` and `1 ≤ L`, every step keeps the family and the level does not fall; where `A = g + d`, `1 ≤ d`, and `L = r + k·d`, `k` steps stay in the family with level `r`, and from `r < d` one more gives `gone`. `steady` at `A = (q + e q)·s`, full open entry at `A = f·s` and Gaps' strands are cases. It is `Flow`'s joint excess in this net, cited as such; a bridge to `Flow.joint_excess_ends` is the natural next statement and is not promised here.
- **L2. The band (the central law).** `.members`, every step on, no revision, `1 ≤ L`: from `steady q L` the rule is held at every step exactly where `l < s`, `1 ≤ q` and `(q + e q)·s ≤ g`. So teaching must fit a tenure, and the rule must admit few enough for the level to carry and enough to keep the rest away. This is the steady state's law, and it holds alike of `.outside` wherever `l < s`.
- **L3. The band without its truncation.** Write `C := c·(s − l)`, `l < s`. Then `(q + e q)·s ≤ g` exactly where `q·s ≤ g` and `(f + q)·s ≤ g + C·q·s`. The interval of quotas this solves to was run and is not proved (with `A := g / s`: at `C ≥ 2` the integers from `max(1, ⌈(f − A)/(C − 1)⌉)` to `A`; at `C = 1`, `[1, A]` if `f ≤ A` and nothing otherwise; at `C = 0`, `[1, A − f]`). A quota can be too small only at `C ≥ 2`: **a keeper must turn away more than itself** for a larger rule to hold where a smaller fails. `s − l` counts through `C`. Witnesses, to be decided in Lean: at `s,l,g,f,c = 1,0,2,4,2` only `q = 2`; at `4,2,20,6,1` every `q` in `[1,5]`; at `4,3,20,6,1` none, though `l < s`.
- **L4. The region.** `.members`, `l < s`, `1 ≤ P ≤ Q`, `E := f − c·P·(s − l)`, `(Q + E)·s ≤ g`: `Within P Q` (`s` holder cohorts each in `[P, Q]`, at most `s` other cohorts each at most `E`, quota in `[P, Q]`, level at least one) is closed under every on-step with a revision in `[P, Q]` (`«闭»`), and the level does not fall. This is what L2's steady state is a case of, and the revision is free inside it.
- **L5. The drain.** `.members`, no revision to a nonzero quota, holders of at most `s` cohorts: where `q = 0` or `s ≤ l`, no holder is left after `s` steps, on or off, from every level.
- **L6. No holder from no holder.** `.members`: no holder stays no holder under the whole net, and two such states differing only in quota have the same later levels and members. The quota then is a dead letter, read by nothing, and so no hidden entity.
- **L7. The end is closed.** Every source: `gone` is closed under the net. This is the model's choice that nothing renews from empty, and §5 says what depends on it.
- **L8. Open entry after the rule.** `.members`, no holder, every step on, `1 ≤ s`, `1 ≤ f`: where `f·s ≤ g` and `1 ≤ L`, from at most `s` other cohorts each at most `f`, others are present after every step and the level does not fall. Where `g < f·s`, it is `gone` at some step, from every level and any others.
- **L9. Two starts compared.** At `l < s`, `1 ≤ q`, `1 ≤ L`, compare `steady q L` with the state of no holder, `f` others in `s` cohorts and the same level. They are started separately; the second is not reached from the first by this course. The first's level goes on exactly where `(q + e q)·s ≤ g`, the second's exactly where `f·s ≤ g`, and otherwise each is `gone` at some step. So there are two tests, each its own, and each of the four combinations occurs:

  | | `f·s ≤ g` | `g < f·s` |
  |---|---|---|
  | `(q + e q)·s ≤ g` | both go on | only the steady state goes on |
  | `g < (q + e q)·s` | only open entry goes on | both end, each at its horizon |

  Neither the rule's being present nor its being held decides. Bottom left: `f < q`, or the door turns no one away (exactly: `f < q + e q` iff `f < q` or `C = 0`). Top right holds only at `C ≥ 2`, where a keeper turns away more than itself. Where both go on, the rule can vanish with nothing here to show it, and a tradition is the case with nothing to limit. An AI reading may call top right the rule saving the level and bottom left the rule ending it; those words are not in the Lean.
- **L10. Self-revision.** A revision in `[P, Q]` stays in L4's region. A revision to `0` with no revision after it empties the holders by L5, in `s` steps. So the rule can take itself out by the route of L5, and can be restored only while a holder stands. The band does not settle what follows a revision; the law is the region. Witnesses from the steady state at level one, one revision at the first step: at `1,0,2,4,2`, `q = 2` revised below the band to `1`, a smaller quota, reaches level `0` at step 5, and above it to `3` at step 3; at `2,1,10,2,1`, `q = 1` revised below to `0`, the level is still present at step 20; at `4,2,20,6,1`, `q = 1` revised to `5`, both in the band and making no region, reaches level `0` at step 4.
- **L11. The family, a table of three rows.** After an empty membership, `1 ≤ s`, `1 ≤ L`, `1 ≤ q`, on: `.outside` has holders after one step, `.members` and `.none` do not. At `s ≤ l`, with holders of at most `s` cohorts, `.outside` still enters holders at every step, and `.members` not. `.none` from no holder stays there, and is L8.
- **L12. Replaced (definitional, kept for question 3).** `1 ≤ s`: after `s` steps with no end, every holder cohort entered in those steps, at the quota then standing. With L4, the rule is held, nothing of the start is among the holders, and the quota may have moved anywhere in `[P, Q]`.
- **L13. Gaps: where passing and limiting meet.** L2 and L4 do not cover states with empty cohorts. At `l = s − 1`, each cohort teaches exactly the one that replaces it, so the holders form `k` separate strands, and the list of pairs (holders, others) only rotates. `.members`, every step on, no revision, `1 ≤ q`, `1 ≤ L`: from `k ≥ 1` strands with their others (a held cohort `(q, e)`, an empty one `(0, f)`, `e := f − c·q`), the rule is held at every step exactly where `k·(q + e) + (s − k)·f ≤ g`, and over that bound it is held to the last state before `gone`. Passing needs only `k ≥ 1`. `k` sets on how many of the `s` steps, in rotation, the door is kept and the rule passed, so the take is the steady state's on `k` cohorts and open entry's on the rest. Gaps hold where the steady state does not only where `f < q + e` and `f·s < g`: a cohort of the steady state exceeds open entry's, open entry would go on too, and the door has no part in it. The steady state goes on where gaps do not only where `q + e < f`, `g < f·s` and a keeper turns away more than itself. L2 is the steady state's law and not the rule's.
- **The same rule, read at a class (one sentence and one witness at one rule, no law).** On `«续»`, a step with a revision inside the region continues under the class "held or not" and not under the class "the same quota"; this is 01 §2's `«任一缘可为续»` with these occurrences.

## 4. Against the three questions

1. **Outliving.** L2 from the steady state and L4 from a region. Forbidden, in this net: a rule whose holders can teach only after a tenure outliving its founders, however many join (L5); a steady state outliving its level at a quota outside its band, on either side (L1). The statement is of the steady state and the region, not of every state (L13).
2. **What it does, and how it ends.** L9. The ends found so far, as a list and not a proved classification:

   | | the rule | the members | the level |
   |---|---|---|---|
   | Unpassed, `1 ≤ f`, `f·s ≤ g`, and no end on the way (`(q + f)·s ≤ g` suffices) | gone | others present | not falling |
   | Unpassed, `g < f·s` | gone | gone | gone |
   | Abandoned, `f = 0`, `1 ≤ g` | gone | none | rising |
   | Overdrawn, by keepers and leak together | held to the last state | gone | gone |
   | Gapped, within L13's bound | held on some cohorts | present | not falling |
   | Gapped, over it (reached by off-steps or a revision to `0` and back; at `3,2,6,4,2`, `q = 2`, `L = 30`, revised to `0` at the second step and back at the fourth, gone at step 18) | held to the last state | gone | gone |

   The fourth row says a rule can be kept and still be the wrong rule. It ends in the same form as OG's `.level` member: a stock spent, and an end closed under the net.
3. **Sameness.** Only the quota can change here; tenure, teaching age and source are fixed. So this answers for a rule's number and its people, not for purposes or for a rule of another form. With L12 and L4 a rule is still held, with nothing of its start among the holders and a moved quota. Whether that is "the same" is read at a class, which 01 §2 already says of everything; nothing new is claimed.

## 5. What it does not show, and what the laws depend on

Variants of the order, the end and the door were run against this rule by the re-check's scripts ([review3-scripts](review3-scripts/)).

- **Nothing renewing from empty.** Let it renew and only the excess leave, and L7, L1's end, L8's ruin and L9's bottom row fail. So the rule matters here only where an overdraw does lasting damage. L9 survives a rationed draw in place of all leaving at once.
- **The order.** `q·s` counts the cohorts that draw. Entering before the draw makes the threshold `(q + e)·(s + 1)`; ending after entering, or ageing before the draw, changes L1, L2, L3, L9 as stated; teaching after ageing narrows the window by one and makes `e` read `s − l − 1`. Revising before entering changes nothing tested. With a pupil's time `d` before holding, the first review found `l + d < s`. So `l` is the age from which a holder can teach and not the time it takes to learn, and the exact thresholds hold of these orders.
- **A door shut with no teacher** breaks L8's ruin and L9. **`c`.** The strength is given. Why a teacher turns anyone away, what it costs beyond its draw, and whether it would, are not here. Holder merges recognition, compliance and implementation, which AGENTS keeps distinct. So nothing here is normative: "holder" is a count, and the door is a formula. The fuller sense of a hollow institution, holders who do not comply, cannot be stated here; "no holder" is what is modelled.
- **Conduct other than entry.** The rule limits who enters. Rules on how much a member draws, on who decides, and on sanctions are not modelled, and the quota does not read the level.
- **Capture.** T7, MA3, MA4 read the rule's lock under selection; here the revision is a free branch, not chosen by those it favours.
- **Mixed tenures** (the first review: the window reads the longest stay), **schism, records, partial passing, purposes.** 01's open item keeps purposes.
- **That any actual institution meets the hypotheses.** A correspondence to be stated and checked; none is claimed.

## 6. How much of this is definitional

L6, L7 and L12 are close to the rule's definition and are stated as such. L11 is a table. L1 is one lemma, the same as `Flow`'s joint excess in another net, and L2, L8's tail, L9 and L13's take are it at other inflows. L3 is a closed form and L4 one sum bound. So the content is small, and it is this: enforcement drawing on what it guards (L3, L9), which needs no passing; and L13, where the count of held cohorts weighs the steady state's take against open entry's. L5 and L6 are the passing's own. L2's third conjunct, L1's end, L8's end, L9's tests and L13's forward direction all exist because of step 1's clause that all members leave at an overdraw. A hostile reader may say that L2 is one inequality and is right; what it adds to joint excess is that the inflow is set by the keepers' own count and tenure.

## 7. Correspondence and prior art, unproved here

AI reading, each a neighbour and none proved, from limited searches; nothing here claims new mathematics.

- Landed here: joint excess (05 §1), a stock buying time (04 §8), rule shaping and reader lock (MA3, MA4, T7).
- The overdraw threshold is the open-access stock's (Gordon 1954; Hardin 1968).
- The teaching window has the form of a Leslie-model replacement threshold, by the first review's derivation (https://aimspress.com/aimspress-data/mbe/2025/6/PDF/mbe-22-06-047.pdf), close to Enquist et al. 2010. Harrison and Carroll study hiring, socialization and turnover by simulation; Crémer 1986 finite-lived agents in a long-lived organization; Acemoglu, Egorov and Sonin 2012 current members setting who joins.
- Ostrom 1990 treats boundary rules on common pools as held by those they govern; this reading is of the entry rule only.
- Found by the second review, each as far as it was read (REVIEW-2 says how far): Kandori 1992; Mankat 2024, cultural transmission of norms in a common-pool game with a stock, which narrows any claimed absence to the entry rule; Brede and Boschetti 2009, costly obstruction of access; a study of nine Dutch commons, in which sanctioning rules were more frequent early in a common's life, which cuts against keepers being needed throughout; Flentge, Polani and Uthmann 2001.
- Neither search found the door whose strength is the keepers' own count. That is an absence in limited searches and no claim of priority.

## 8. What changes for a reader

- **The fronts' sentence.** The one page's last open bullet, both editions: "An organism and one kind of institution each have one minimal model (04 §8, 05 §12), and several theses' tests are still to run." The same sentence in overview §10, both editions, which says at present that an organism has none: that half is a slip from OG's landing, reported by the cold read of 2 November, which the fork's revision takes up; whichever lands second merges.
- **What a reader is told the model is.** "A minimal model of one kind of institution: an entry rule on a shared stock, passed through members who also keep it; no compliance, no records." Not a definition of an institution.
- 05 gains a new §12 before "What this chapter does not show", as the home; existing section numbers stay. 01's test-systems bullet moves one kind of institution from open to modelled, and keeps purposes and other kinds open.
- No root law is added. This is a model on the grammar, claimed as one.
- The cold read asks for the fishery gathered once. Where the fork's passage asks what a rule among boats can do, L9 is the place to link, once landed, as an AI reading.

## 9. How the reviews were taken

| Finding | Taken |
|---|---|
| R1: door built in; contrast with OG wrong | The door is `f − c·T`; §4's list replaces the contrast. |
| R1: `learning` not learning | `teachingAge`; §5. |
| R1: any tradition; quota one bit; quota held by nobody | R1's per-holder values not taken, since they would leave the rule limiting nothing; the rule limits draw through entry; L6 states the dead letter; L9 places a tradition. |
| R1: identity as a law; overclaims; module | One sentence and a witness; "entrenchment", Hart, "hollow institution" gone; own leaf, `.outside`. |
| R2 H1: `q·s > g` can outlive its level from gaps | L2 and §4.1 are now of the steady state; L13 is the law; L4 is the region. |
| R2 H2: table incomplete | §4's list, stated as a list and not a classification; the abandoned row added. Breach under a revision is L13's over-bound row. |
| R2 H3: one lemma and one bit | L1 is named as the lemma, and §6 counts it once. The door's strength taken; the re-check found it does not join passing to limiting (R3 H1). |
| R2 M1: L9 one quadrant | L9 is the 2×2. |
| R2 M2–M5: hypotheses, literal equality, order | L2, L5, L8, L11 corrected; `steady` has its others in full; the order is §5's. |
| R2 M6: "limiting their draw", "an institution" | §8's sentences. |
| R2 M7: "each was run" overclaims | R3 found this again of the third draft; now sim3 runs every law named, L10's witnesses included. |
| R3 H1: no join of passing and limiting at the steady state | §1, §2's choice of one age, §6, L13. |
| R3 M1, M2, M4–M6, Low | L3's closed form; L9's glosses; §4.1, L10; §5; §4's first row; L8, L11, L12, L13 hypotheses. |
| R2 Low | Step 1 stops the step; off-steps stated; §4.3 says only the quota changes. |
| R4 1, 3, 4, 6: "while held" not stated; a witness with no door; `k` as how many pass; a state with gaps not stated | `«隙过生持至尽»`; `rD` has a door; two laws of what each side of the gaps needs; §1 and L13 reworded; `«改而成隙则尽»` states the state with gaps and every step held. |
| R4 2: the witnesses' name stated a false law | `«带不定改后»`, with a witness that goes on and one inside the band; L10 says the law is the region. |
| R4 5, 7, 8: a revision outside the region; "turns no one away" not stated; "enters" proved only as held | `«同规随类»` at a region with its `«类»` conjuncts; `«入过来者之式»`; `«外授者即入»` states the new cohort. |
| R4 9, 10, 11, 12 and the smuggling list | Step 1's clause named at the laws it makes; `Flow` a form, no law using it; `«带之二式»`, the interval named unproved; the quota a fill; names and sentences that said saves, ends, cost, stricter or however large changed. |
| R4 stronger: L9 is two facts | `«稳开二试»` and `«存尽相斥»` replace the four conjuncts. |
| Landed laws (my own search after the second draft) | §1, L1, §7: joint excess is cited, not presented as new. |

## 10. No further review of the design

The re-check said none was needed if the statements changed only as listed, and they did. Its reviewer was the door's proposer, so an independent reading of the Lean came next, as for OG: REVIEW-4, every finding taken.
