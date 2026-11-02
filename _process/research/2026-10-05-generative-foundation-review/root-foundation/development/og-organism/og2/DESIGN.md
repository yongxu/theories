# OG2: a rule rebuilt from the members it limits (AI-written design, third draft, 2 November 2026)

About ten minutes to read. Earlier drafts are at commits `bdf09a1b4` and `72c83470e`; [REVIEW-1](REVIEW-1.md) and [REVIEW-2](REVIEW-2.md) are their independent reviews, and §9 says how each changed the model.

## 1. What this answers

Plan §十三 item 9 asks for each test system of plan §六 with its model. OG gave the organism one ([04 §8](../../../../../../../theories/becoming/chapters/04-LIFE.md#r-the-stock-buys-time-where-the-rebuild-draws-on-it)). The fronts still say an institution has none, and 01 lists as open "an institution's identity through replaced people, rules and purposes". 01 §8.7 has one reading only: an institution kept by consent or by penalty is the thermostat witness with its occurrences renamed.

Three questions a reader would ask:

1. What must hold for a rule to outlive everyone who first held it?
2. What does the rule do, so that this is an institution and not any tradition? And how does it end?
3. Is it the same institution after its people and its rule have changed?

What ends a shared stock is already proved, on the World: takers each within what is renewed can together exceed it, and where the renewal depends on what it renews, that ends it (`Flow.joint_excess_ends`, `Flow.outrun_ends`, [05 §1](../../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#r-own-count-misses-joint-excess)). This model does not restate that as new. Its own question is a joining: **a rule has to pass through the members it limits, and the same members are what keep it in force, and what they draw on is what they guard.** The first draft had the passing alone, and the second had passing and limiting as two independent conditions, which the second review showed were one queue lemma beside one switch. A door of a strength per teacher couples them.

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
   - others: `f − c·T`, truncated at `0`. Each teacher turns away `c` of those who would come untaught. **One formula for every source.**
   - holders: `quota`, where the source is `.outside`, or `.members` with `T > 0`; otherwise none. `.none` has no holder.
5. **Age.** Each list keeps its first `s` cohorts; the oldest leaves.
6. **Revise.** `rev = some r`, at least one holder before the step, and the source not `.outside`: the quota becomes `r`.

`net r` is the relation of all these choices. `Held x := 0 < sum x.holders`. `gone x :=` level `0`, no member. The **leak** at a quota: `e q := f − c·q·(s − l)`. `steady q L := ⟨q, L, replicate s q, replicate s (e q)⟩`, the state whose next step is itself with another level.

**The split and its basis.** Holder and other are not two kinds of thing. They differ in one relation: whether the rule has passed to this member through another who held it, and that member then passes it and turns others away. The level is what they share, read here only by how much of it is drawn. Holders and others draw alike. A keeper's cost is its own draw on what it keeps, and that is added by nothing: it is only that keepers are members. Nothing is a utility, and no interest is assumed, opposed or common.

**Modelling choices, stated where laws depend on them:** whole units, discrete steps, one unit a member a step, one quota in common, one tenure, a constant renewal while anything is left, the order above, all members leaving at the end, an entrant holding what it is taught at once, a rule limiting entry only. §5 says what each variant breaks.

## 3. The laws

Each was run on [sim/sim3.py](sim/sim3.py) with no counterexample, except where marked as a witness. Ranges and what each run covers are in its code. Statements are additive where Lean needs them (`r + k·d = L`, not `L / d`).

- **L1. The inflow lemma.** At `l < s`, `1 ≤ q`, write `a := q + e q`. From `steady q L`: where `a·s ≤ g` and `1 ≤ L`, the next step is `steady q (L + g − a·s)`; where `a·s = g + d`, `1 ≤ d`, and `L = r + k·d`, `k` steps give `steady q r`, and from `r < d` one more gives `gone`. Every horizon below is this lemma at another `a`. It is `Flow`'s joint excess in this net, cited as such. A bridge to `Flow.joint_excess_ends` is the natural next statement and is not promised here.
- **L2. The band (the central law).** `.members`, every step on, no revision, `1 ≤ L`: from `steady q L` the rule is held at every step exactly where `l < s`, `1 ≤ q` and `(q + e q)·s ≤ g`. So teaching must fit a tenure, and the rule must admit few enough for the level to carry and enough to keep the rest away.
- **L3. The band is two-sided, and `s − l` counts.** Witnesses, decided: at `s,l,g,f,c = 1,0,2,4,2` only `q = 2` is admitted; at `4,2,20,6,1` every `q` in `[1,5]`, and at `4,3,20,6,1` none, though `l < s`, since those who can teach now keep the door for too little of a tenure. Cases, general: `c = 0` gives `(q + f)·s ≤ g`, no door at all; `f ≤ c·q·(s − l)` gives `q·s ≤ g`, a door that holds. A stricter rule can fail where a looser one holds, and a looser where a stricter holds. How often the middle case arises is a fact of the range and not claimed: of 3,640 parameter points run, 1,592 admit no quota, 1,938 admit one, and 110 admit only quotas above one.
- **L4. The region.** `.members`, `l < s`, `1 ≤ P ≤ Q`, `E := f − c·P·(s − l)`, `(Q + E)·s ≤ g`: `Within P Q` (`s` holder cohorts each in `[P, Q]`, at most `s` other cohorts each at most `E`, quota in `[P, Q]`, level at least one) is closed under every on-step with a revision in `[P, Q]` (`«闭»`), and the level does not fall. This is what L2's steady state is a case of, and the revision is free inside it.
- **L5. The drain.** `.members`, no revision to a nonzero quota: where `q = 0` or `s ≤ l`, from holders of at most `s` cohorts, no holder is left after `s` steps, on or off, from every level.
- **L6. No holder from no holder.** `.members`: no holder stays no holder under the whole net, and two such states differing only in quota have the same later levels and members. The quota then is a dead letter, read by nothing, and so no hidden entity.
- **L7. The end is closed.** Every source: `gone` is closed under the net. This is the model's choice that nothing renews from empty, and §5 says what depends on it.
- **L8. Open entry after the rule.** `.members`, no holder, every step on, `1 ≤ s`, `1 ≤ f`: where `f·s ≤ g` and `1 ≤ L`, from at most `s` other cohorts each at most `f`, others are present and the level does not fall at every step. Where `g < f·s`, it is `gone` at some step, from every level and any others.
- **L9. What the rule does.** At `l < s`, `1 ≤ q`, `1 ≤ L`, `1 ≤ f`, compare `steady q L` with the state of no holder, `f` others in `s` cohorts and the same level:

  | | `f·s ≤ g` | `g < f·s` |
  |---|---|---|
  | `(q + e q)·s ≤ g` | both go on | **the rule saves the level** |
  | `g < (q + e q)·s` | **the rule ends the level** | both end, each at its horizon |

  Neither the rule's being present nor its being held decides. A rule can end what open entry would have kept: it brings in more than the level carries, and keeps out too few to matter. Where both go on, the rule can vanish with nothing here to show it, and a tradition is the case with nothing to limit.
- **L10. Self-revision.** A revision in `[P, Q]` stays in L4's region. A revision to `0` with no revision after it drains by L5, in `s` steps. So the rule can take itself out by the route of L5 and return only while a holder of it stands. A general law for a revision above the band is not proved here; a witness shows it can end the level.
- **L11. The family, a table of three rows.** After an empty membership, `1 ≤ s`, `1 ≤ L`, `1 ≤ q`, on: `.outside` has holders after one step, `.members` and `.none` do not. At `s ≤ l`, `.outside` still enters holders at every step, and `.members` not. `.none` has no holder at all and is L8 from the start.
- **L12. Replaced (definitional, kept for question 3).** After `s` steps with no end, every holder cohort entered in those steps, at the quota then standing. With L4, the rule is held, nothing of the start is among the holders, and the quota may have moved anywhere in `[P, Q]`.
- **Gaps (a witness, and a law only run).** L2 and L4 do not cover states with empty cohorts. At `l = s − 1` an empty cohort stays empty, since each cohort teaches exactly the one that replaces it, so the holders form `k` separate strands. Run, not proved: from `k ≥ 1` strands with their others, held at every step exactly where `k·(q + e) + (s − k)·f ≤ g`, with `e := f − c·q`. So a rule can hold, on a fraction of its cohorts, at parameters where its steady state cannot. A witness is decided in Lean. L2 is the steady state's law and not the rule's.
- **The same rule, read at a class (one sentence and one witness, no law).** On `«续»`, a step with a revision inside the region continues under "held or not" and not under "the same quota"; this is 01 §2's `«任一缘可为续»` with these occurrences.

## 4. Against the three questions

1. **Outliving.** L2 from the steady state and L4 from a region. Forbidden, in this net: a rule whose holders can teach only after a tenure outliving its founders, however many join (L5); a steady state outliving its level at a quota above its band (L1). The statement is of the steady state and the region, not of every state (Gaps).
2. **What it does, and how it ends.** L9. The ends found so far, as a list and not a proved classification:

   | | the rule | the members | the level |
   |---|---|---|---|
   | Unpassed, `1 ≤ f`, `f·s ≤ g` | gone | others present | not falling |
   | Unpassed, `g < f·s` | gone | gone | gone |
   | Abandoned, `f = 0` or nobody comes | gone | none | rising |
   | Overdrawn, by keepers and leak together | held to the end, or gone first where a revision or gaps intervene | gone | gone |
   | Gapped | held on some cohorts, by a run law only | present | depends |

   The fourth row says a rule can be kept and still be the wrong rule. It ends in the same form as OG's `.level` member: a stock spent, and an end closed under the net.
3. **Sameness.** Only the quota can change here; tenure, teaching age and source are fixed. So this answers for a rule's number and its people, not for purposes or for a rule of another form. With L12 and L4 a rule is still held, with nothing of its start among the holders and a moved quota. Whether that is "the same" is read at a class, which 01 §2 already says of everything; nothing new is claimed.

## 5. What it does not show, and what the laws depend on

Variants of the door and the order were run by the second review's scripts ([review2-scripts](review2-scripts/)) against the second rule, and those of the end in `sim2.py`. The third rule's are not all re-run; §10 asks for that.

- **Nothing renewing from empty.** Let it renew and only the excess leave, and L7, L1's end, L8's ruin and L9's bottom row fail. So the rule matters here only where an overdraw does lasting damage. L9 survives a rationed draw in place of all leaving at once.
- **The order.** `q·s` counts the cohorts that draw. Entering before the draw makes the threshold `q·(s + 1)`; ending after entering, or ageing before the draw, changes L1, L2, L3, L9 as stated; teaching after ageing narrows the window by one. Revising before entering changes nothing tested. With a pupil's time `d` before holding, the first review found `l + d < s`. So `l` is the age from which a holder can teach and not the time it takes to learn, and the exact thresholds hold of these orders.
- **`c`.** The strength is given. Why a teacher turns anyone away, what it costs beyond its draw, and whether it would, are not here. Holder merges recognition, compliance and implementation, which AGENTS keeps distinct. So nothing here is normative: "holder" is a count, and the door is a formula. The fuller sense of a hollow institution, holders who do not comply, cannot be stated here; "no holder" is what is modelled.
- **Conduct other than entry.** The rule limits who enters. Rules on how much a member draws, on who decides, and on sanctions are not modelled, and the quota does not read the level.
- **Capture.** T7, MA3, MA4 read the rule's lock under selection; here the revision is a free branch, not chosen by those it favours.
- **Mixed tenures** (the first review: the window reads the longest stay), **schism, records, partial passing, purposes.** 01's open item keeps purposes.
- **That any actual institution meets the hypotheses.** A correspondence to be stated and checked; none is claimed.

## 6. How much of this is definitional

L6, L7 and L12 are close to the rule's definition and are stated as such. L11 is a table. L1 is one sum and one induction, and the same lemma as `Flow`'s joint excess in another net. L8 and L9 are L1 at other inflows, plus the ramp in L8's ruin. **The content is in L2, L3 and L4, which join the two sides through `e q`,** in L9's reading of the four quadrants, and in Gaps. A hostile reader may say that L2 is one inequality. It is; what it adds to joint excess is that the inflow is set by the keepers' own count and tenure.

## 7. Correspondence and prior art, unproved here

AI reading, each a neighbour and none proved, from limited searches; nothing here claims new mathematics.

- Landed here: joint excess (05 §1), a stock buying time (04 §8), rule shaping and reader lock (MA3, MA4, T7).
- The overdraw threshold is the open-access stock's (Gordon 1954; Hardin 1968).
- The teaching window has the form of a Leslie-model replacement threshold, by the first review's derivation (https://aimspress.com/aimspress-data/mbe/2025/6/PDF/mbe-22-06-047.pdf), close to Enquist et al. 2010. Harrison and Carroll study hiring, socialization and turnover by simulation; Crémer 1986 finite-lived agents in a long-lived organization; Acemoglu, Egorov and Sonin 2012 current members setting who joins.
- Ostrom 1990 treats boundary rules on common pools as held by those they govern; this reading is of the entry rule only.
- Found by the second review, each as far as it was read (REVIEW-2 says how far): Kandori 1992; Mankat 2024, cultural transmission of norms in a common-pool game with a stock, which narrows any claimed absence to the entry rule; Brede and Boschetti 2009, costly obstruction of access; a study of nine Dutch commons, in which sanctioning rules were more frequent early in a common's life, which cuts against keepers being needed throughout; Flentge, Polani and Uthmann 2001.
- Neither search found the door whose strength is the keepers' own count, with passing and limiting joined by it. That is an absence in limited searches and no claim of priority.

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
| R2 H1: `q·s > g` can outlive its level from gaps | L2 and §4.1 are now of the steady state; Gaps states the run law and a witness; L4 is the region. |
| R2 H2: table incomplete | §4's list, stated as a list and not a classification; the abandoned row added. Breach is now within `e q`; as a transient under a revision it is still not a row of its own. |
| R2 H3: one lemma and one bit | L1 is named as the lemma, and §6 counts it once; the door's strength joins the sides. Its own recommended change, tested by it from settled only, here re-run over all laws. |
| R2 M1: L9 one quadrant | L9 is the 2×2. |
| R2 M2–M5: hypotheses, literal equality, order | L2, L5, L8, L11 corrected; `steady` has its others in full; the order is §5's. |
| R2 M6: "limiting their draw", "an institution" | §8's sentences. |
| R2 M7: "each was run" overclaims | sim3 runs L9 and the region, and §5 says what is not re-run. |
| R2 Low | Step 1 stops the step; off-steps stated; §4.3 says only the quota changes. |
| Landed laws (my own search after the second draft) | §1, L1, §7: joint excess is cited, not presented as new. |

## 10. Questions for the short re-check

1. Reimplement §2 from the prose. Do L1–L12 and Gaps hold, including off-steps and over-long lists, under `f − c·T`?
2. Do the order variants, rationed draw and `door` variants still break what §5 says, under the third rule?
3. Is L9's table exact, and is "keeps out too few to matter" a fair gloss of its bottom-left, where `e q` may be `0`?
4. Is there another hidden queue lemma? Do L2 and L3 now say something a boundary on a commons with no passing would not?
