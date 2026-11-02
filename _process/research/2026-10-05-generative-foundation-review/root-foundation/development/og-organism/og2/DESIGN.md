# OG2: a rule rebuilt from the members it limits (AI-written design, second draft, 2 November 2026)

About ten minutes to read. The first draft is at commit `bdf09a1b4`; [REVIEW-1](REVIEW-1.md) is its independent review, whose three high findings changed the model and not only its wording. §9 says how each was taken.

## 1. What this answers

Plan §十三 item 9 asks for each test system of plan §六 with its model. OG gave the organism one ([04 §8](../../../../../../../theories/becoming/chapters/04-LIFE.md#r-the-stock-buys-time-where-the-rebuild-draws-on-it)). The one page still says "An institution has no model yet", and 01 lists as open "an institution's identity through replaced people, rules and purposes". 01 §8.7 has one reading only: an institution kept by consent or by penalty is the thermostat witness with its occurrences renamed.

Three questions a reader would ask:

1. What must hold for a rule to outlive everyone who first held it?
2. What does the rule do, so that this is an institution and not any tradition? And how does it end?
3. Is it the same institution after its people and its rule have all changed?

A rule that limits nothing is a tradition, and the first draft modelled only that: with teacher read as parent and quota as fecundity it was a population's replacement threshold, and its quota was one bit. Here the rule limits who may draw on what the members share, and the door is only as strong as those who keep it.

## 2. The rule

`Becoming.RuleRebuilding`, an instance of the ring on the grammar, its own leaf.

```lean
inductive Source where | members | outside | none   -- where the rule is taught from
structure Rule where tenure teachingAge renewal untaught : Nat; source : Source
structure St where quota level : Nat; holders others : List Nat   -- counts by cohort, youngest first
```

A state holds a quota, a level the members draw on, and two lists of counts by age. One step, given whether the population offers entrants (`on`) and a revision (`rev : Option Nat`), both chosen at each step:

1. **The end.** `take` is the count of members, each drawing one unit. Where the level is `0`, or `take` exceeds `level + renewal`, the state becomes level `0` with no member. An empty level renews nothing, so nothing can draw from it again.
2. **Draw and renew.** Otherwise the level becomes `level + renewal − take`.
3. **Teach.** A *teacher* is a holder of age at least `teachingAge` (a nonzero cohort at or past that index), read before ageing.
4. **Enter**, if `on`, as cohort `0`:
   - `.members` with a teacher: `quota` entrants become holders, and nobody else enters. The teacher keeps the door.
   - `.outside`: `quota` entrants become holders, with no teacher: a statute or an enforcer reads the rule from outside.
   - Otherwise (`.members` with no teacher, or `.none`): `untaught` entrants join `others`. Nobody stands at the door.
5. **Age.** Each list keeps its first `tenure` cohorts; the oldest leaves.
6. **Revise.** `rev = some r`, at least one holder before the step, and the source not `.outside`: the quota becomes `r`.

`net r` is the relation of all these choices; `run` takes a sequence. `Held x := 0 < sum x.holders`. `settled q L := ⟨q, L, replicate tenure q, []⟩`. `gone x := level = 0, no member`.

**The split and its basis.** Holder and other are not two kinds of thing. They differ in one relation: whether the rule has passed to this member through another who held it, and that member then enters others by it. The level is what they share, read here only by how much of it is drawn. Nothing is a utility, and no interest is assumed, opposed or common. Members who hold and those who do not draw alike.

**Modelling choices, stated where laws depend on them:** whole units, discrete steps, one unit a member a step, one quota in common (no schism), a constant renewal while anything is left and none from empty, all members leaving at once at the end (those served in the last partial draw would leave one step later), an entrant holding what it is taught at once, a rule limiting only entry. §5 says what each variant breaks.

## 3. The laws

Each was run on [sim/sim2.py](sim/sim2.py) with no counterexample (spans 1–4, teaching ages 0–5, renewal 0–8, quotas 0–3, untaught 0–3, levels up to 11). Write `s` tenure, `l` teaching age, `g` renewal, `f` untaught.

- **L1. Kept.** `.members`, `l < s`, `Q·s ≤ g`. The region `Within Q` (holders `s` cohorts each in `[1, Q]`, no other member, quota in `[1, Q]`, level at least one) is closed under every on-step with a revision in `[1, Q]` (`«闭»`), and the level does not fall. The revision is free inside the region.
- **L2. The window (the central law).** `.members`, level at least one: from `settled q L`, the rule is held at every step exactly where `l < s`, `1 ≤ q` and `q·s ≤ g`. Three things must hold together: teaching fits inside a tenure, the rule admits someone, and what it admits the level can carry.
- **L3. Its two ways out.**
  - **Unpassed.** Where `q = 0` or `s ≤ l`, no holder is left after `s` on-steps from any level.
  - **Overdrawn.** Where `l < s` and `q·s = g + d`, `d ≥ 1`: settled with level `L − k·d` for every `k ≤ L / d`, and gone at `L / d + 1`. The rule is held to the last step. A held rule does not save anything by being held. This is OG's stock buying time, in a different net.
- **L4. No holder from no holder.** `.members`: no holder stays no holder under the whole net, entrants or not, revision or not, and the quota stands unread: two such states differing only in quota have the same later levels and members. A quota with no holder is a dead letter here, which is why it is no hidden entity.
- **L5. The end is closed.** Every source: `gone` is closed under the net.
- **L6. Open access.** `.none`, from `others` in `s` full cohorts and level at least one: `f·s ≤ g` keeps every cohort and the level forever; `f·s = g + d`, `d ≥ 1`: gone at `L / d + 1`.
- **L7. Members with no holder.** `.members`, every step on, `1 ≤ f`:
  - Where a teacher is gone, the door has fallen: every on-step that does not end brings `f` others in.
  - `f·s ≤ g`: such a state keeps its members and its level from falling once its cohorts are full. No holder is present and nothing is lost.
  - `g < f·s`: from every level and any others, it is gone at some step (the ruin).
- **L8. What the rule does.** At `l < s`, `1 ≤ q`, `q·s ≤ g`, `1 ≤ L`, `.members`, compare `settled q L` and the state with the same level, no holder and full `others`:
  - `g < f·s`: the first is held at every step, the level never falling; the second is gone.
  - `f·s ≤ g`: both go on, the level never falling.

  So at these parameters the rule's presence decides the level's fate exactly where `g < f·s`. Where open entry would not overdraw, the rule can vanish with nothing here to show it. That is the sense in which this is an institution and a tradition its case with nothing to limit.
- **L9. Self-revision.** A revision can take the rule out by either way of L3: to `0`, unpassed, by `s` steps after it whatever the teaching age; or above what the level carries, overdrawn. `Within` is what remains. A revision in `[1, Q]` keeps it: L1. Whether the rule's holders would so revise is not here.
- **L10. The family law.** At `l < s`, `1 ≤ q`, `q·s ≤ g`, over the three sources: rebuilt from members exactly where it does not return after an empty membership; `.outside` holds at every teaching age and returns; `.none` has no holder and is L6. This is a table of three rows; `.outside` is what `s ≤ l` does not reach.
- **Replaced (a definitional step, kept for question 3).** After `s` on-steps from at most `s` cohorts, every holder cohort was admitted in the run, at the quota then standing. With L1, the rule is held, no founder is among the holders, and the quota may have moved anywhere in `[1, Q]`.
- **The same rule, read at a class (one sentence and one witness, no law of its own).** On `«续»`, a kept step with a revision continues under "held or not" and not under "the same quota"; this is 01 §2's `«任一缘可为续»` with these occurrences, and it is cited as that.

## 4. Against the three questions

1. **Outliving.** L2. Forbidden: a rule rebuilt from its members, under one tenure, passed whole and with no records, which takes as long as a tenure to be able to teach, outliving its founders however many join; and one admitting more than the level carries, outliving its level.
2. **What it does, and how it ends.** L8. Three ends, each its own theorem:

   | | the rule | the members | the level |
   |---|---|---|---|
   | Unpassed, `f·s ≤ g` | gone | present | kept |
   | Unpassed, `g < f·s` | gone, then | gone | gone |
   | Overdrawn | held to the last step | gone | gone |

   The second row is the failure of a kept commons, and the third that a rule can be kept faithfully and still be the wrong rule. `ReaderRebuilding.«读者绝则无储»` covers only its `.level` member; that member's end and the third row have one form (a stock spent, then an end closed under the net).
3. **Sameness.** Replaced and L1 give a rule still held, with no founder and a moved quota. Whether that is "the same" is read at a class, which 01 §2 already says of everything: nothing new is claimed.

## 5. What it does not show, and what the laws depend on

Each variant below is in `sim2.py`; counts of counterexamples are its printout.

- **Renewal from empty (`renew-at-zero`).** If an empty level renews and only the excess leave, L2's third condition, L3's end, L5, L6's end and the ruin all fail. So the rule matters here only where an overdraw does lasting damage, and the laws say nothing of resources that cannot be damaged.
- **Teaching after ageing (`teach-after-age`).** L1, L2, L3 change: the window narrows by one, `l + 1 < s`. With a time as a pupil `d` before holding, the first review found `l + d < s`, and L4 needs pupils to wait for a teacher. So `l` is the age from which a holder can teach, not the time it takes to learn, and the law is `l` against `s` only given these orders.
- **A door nobody keeps (`door-param`).** Keep the door shut with no teacher, and L7's ruin and the hollow states go. **A door that does not stand at all (`door-free`).** Others enter past any teacher, and L1 and L2 fail. So L7 and L8 depend on the choice that the door stands exactly while a teacher does. That choice is the model's, stated and not derived, and what makes a door hold is not here.
- **Why people comply.** A holder here teaches, keeps the door, admits by the quota and draws what a member draws, all by the rule's definition. "Holder" merges recognition, compliance and implementation, which AGENTS keeps distinct. So "no holder" is the state modelled, and the fuller sense of a hollow institution, holders who do not comply, cannot be stated here.
- **Conduct other than entry.** The rule limits who enters. Rules on how much a member draws, on who decides, and on sanctions are not modelled. Ostrom's terms for these are not earned by this model.
- **Capture.** T7, MA3, MA4 read the rule's lock under selection; here the revision is a free branch, not chosen by those it favours.
- **Mixed tenures** (the first review: the window reads the longest stay, not the typical one), **schism, records and partial passing.** With written records `.outside` is the nearest reading, and it is a whole-rule reading.
- **Purposes**, which regulate nothing here. 01's open item keeps them.
- **That any actual institution meets the hypotheses.** That is a correspondence to be stated and checked; none is claimed.

## 6. How much of this is definitional

L4, L5 and the door clause of L7 are close to the rule's definition and are stated as such. Replaced is definitional. L10 is a table. L1 is one sum bound and one arithmetic fact: with every cohort nonzero and `l < s`, the oldest cohort teaches. L2, L3's overdrawn branch, L6, the ruin and L8 are the content: an exact threshold, an exact horizon and a comparison between two members of a net.

## 7. Correspondence and prior art, unproved here

AI reading, each a neighbour and none proved, from a limited search:

- The overdraw threshold and horizon are the open-access stock's (Gordon 1954; Hardin 1968), and no new mathematics is claimed.
- The teaching window has the form of a Leslie-model replacement threshold, by the first review's derivation (for example https://aimspress.com/aimspress-data/mbe/2025/6/PDF/mbe-22-06-047.pdf), and is close to Enquist et al. 2010; Harrison and Carroll study hiring, socialization and turnover by simulation, and Crémer 1986 finite-lived agents in a long-lived organization; Acemoglu, Egorov and Sonin 2012 have current members setting who joins.
- Ostrom 1990 treats boundary rules on common pools as held by those they govern. That reading is of the entry rule only.
- March 1991 and Argote 1999 on organizational memory under turnover; Weber on routinization: neighbours for the window.
- What the review's search did not find is the pairing: one rule whose passing and whose limit are both needed, with a door falling with its last teacher. That is an absence in a limited search and no claim of priority.

## 8. What changes for a reader

- The one page's last open bullet, in both editions: "An organism and an institution each have one minimal model (04 §8, 05 §12), and several theses' tests are still to run." One word more; the one page's budget row stays honest about it.
- The model's reader-facing sentence: "a minimal model of a rule passing through members and limiting their draw on what they share; no compliance, no records, entry only."
- 05 gains a new §12 before "What this chapter does not show", as the home; existing section numbers stay. 01's test-systems bullet moves the institution from open to modelled and keeps purposes open.
- No root law is added. This is a model on the grammar, claimed as one.

## 9. How the first review was taken

| Finding | Taken |
|---|---|
| Door claim built in; contrast with OG wrong | The door now stands exactly while a teacher does; the "theorem about the door" and its bold sentence are gone; §4's table replaces the contrast; §5 states the door as a choice with both variants run. |
| `learning` is not learning | `teachingAge`; §5 states what a pupillage changes. |
| It models any tradition; quota one bit; quota held by nobody | The rule now limits draw on a shared level (the first review's other proposal, values per holder, would have left the rule limiting nothing); the quota's size now matters (`q·s ≤ g`); L4 states the quota at no holder is read by nothing; L8 says where a tradition is the case with nothing to limit. |
| Definitional laws | §6. |
| Variants | §5, with `sim2.py` printing counterexamples per variant; mixed tenures and disagreement carried from the first review's runs. |
| Corrected statements | L2 and L3 state their hypotheses; "gone by tenure from every level of entrants" is gone; L9 counts `s` from after the revision. |
| L8 (identity) as a law | One sentence and a witness. |
| Module, naming | Own leaf; `.outside`; OG's `older` not imported, since cohorts replace age lists. The structure stays `Rule`, but the text says "quota" for its content. |
| Overclaims | "Entrenchment", Hart and "hollow institution" removed; §4.1's hypotheses named; §8 names 05 §12. |
| Prior art | §7. |

## 10. Questions for the re-check

1. Is the level built in the way the door was? The end rule is one clause; does L8 follow from it and nothing else?
2. Does the rule now earn "institution", or is this any boundary on any commons with teaching added? Would dropping teaching (`.outside`) lose only L2's first condition and L7?
3. Is L8 stated at its best? Is its comparison between the right two states, and does "decides the level's fate exactly where" overclaim?
4. Do the three ends of §4 fail any run? Are there other ends at these parameters that the table hides?
5. Are L7's and L9's statements exact, and provable as stated from the listed hypotheses (for instance, L7's "from every level and any others", and cohorts longer than `s`)?
6. Does a reader's sentence in §8 overclaim?
