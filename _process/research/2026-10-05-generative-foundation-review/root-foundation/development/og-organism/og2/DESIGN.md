# OG2: a rule rebuilt from the members it regulates (AI-written design, 2 November 2026)

About eight minutes to read.

## 1. What this answers

Plan §十三 item 9 asks for each test system of plan §六 with its model. OG gave the organism one ([04 §8](../../../../../../../theories/becoming/chapters/04-LIFE.md#r-the-stock-buys-time-where-the-rebuild-draws-on-it)). The one page still says "An institution has no model yet", and 01 lists as open "an institution's identity through replaced people, rules and purposes". 01 §8.7 has one reading only: an institution kept by consent or by penalty is the thermostat witness with its occurrences renamed.

Three questions a reader would ask, and a model should answer:

1. What must hold for a rule to outlive everyone who first held it?
2. How does an institution differ from an organism, and how does it end?
3. Is it the same institution after its people and its rules have all changed?

The aim is laws that forbid something and could be read against actual institutions, not a renaming of OG. OG's family could be read as offices rebuilt from a membership, with its theorems unchanged. That reading is free and is stated below, but it has no answer to any of the three questions: its reader has no content, is not taught, and can end only with the stock empty.

## 2. The rule

`Becoming.RuleRebuilding`, an instance of the ring importing `Becoming.ReaderRebuilding` for `older`, so that both families share one ageing.

```lean
inductive Source where | members | given | none     -- where the rule is held
inductive Door   where | ruled | open               -- whether anyone enters without the rule
structure Rule where tenure : Nat; learning : Nat; door : Door; source : Source
structure St where quota : Nat; holders : List Nat; others : List Nat   -- ages
```

A state holds one quota, the rule's content here: how many a teacher admits. `holders` are the members who hold the rule, `others` those who do not. One step, given whether the population offers entrants (`on`) and a revision (`rev : Option Nat`), both chosen at each step:

1. **Teach.** A *teacher* is a holder of age at least `learning`. This reads the state before ageing.
2. **Age.** Holders and others age by `older tenure`; a member reaching the tenure leaves.
3. **Enter**, if `on`:
   - `.members`: where there is a teacher and the quota is at least one, `quota` entrants of age `0` become holders.
   - `.given`: where the quota is at least one, `quota` entrants become holders, with no teacher: the rule is read from outside, as a statute, an enforcer or a charter.
   - Otherwise, or `.none`: with an open door one entrant joins `others`; with a ruled door nobody enters.
4. **Revise.** `rev = some q'`, and at least one holder before the step and the source not `.given`: the quota becomes `q'`.

`net r` is the relation of all these choices; `run` takes a sequence.

**Modelling choices, stated where laws depend on them:** whole units, discrete steps, one value held in common (no schism), teaching only on entry, an entrant holding what it is taught at once, the count of untaught entrants fixed at one, and no cap on size. The quota is the only content, because it is the content that regulates the loop: rule → who enters → who holds the rule. A rule regulating nothing could change with no trace in this net.

## 3. The laws

Each was run on `sim/sim.py` over small parameters with no counterexample (spans 1–5, learning 0–6, quota 0–2, both doors, all sources). `Present x := x.holders ≠ []`; `Kept x := 1 ≤ x.quota ∧ Present x`; `founders q n := ⟨q, replicate n 0, []⟩`.

- **L1. Kept while there are entrants.** `.members`, `learning < tenure`: `Kept` is closed under every step with `on` and a revision keeping the quota at least one (`«闭»`). The last holder to leave has served at least `learning`, so it teaches on its way out. The revision is free inside the region: any quota of at least one.
- **L2. All replaced.** After `k` steps, holders are those made in the run followed by `older^k` of the starting holders, and `older^tenure` of any list is `[]`. So at `tenure` steps with L1, the rule is held and no founder is among its holders, whatever quota it now has.
- **L3. The window (the central law).** `.members`, `1 ≤ n`, `1 ≤ tenure`, every step `on`: the rule is held at every step from founders exactly where `learning < tenure` and `1 ≤ quota`. Where learning takes at least a tenure nobody ever teaches, however many enter; where the quota is zero nobody is admitted. Both gone by `tenure` from every level of entrants.
- **L4. The end.** `.members`: `holders = []` with its quota is closed under the whole net, entrants or not, revision or not. No holder can come from no holder.
- **L5. It can end with everyone there.**
  - Open door: from a state with no holder, with entrants at every step, `others ≠ []` and `holders = []` at every later step.
  - That state is reached from founders on every parameter: a cut of `tenure` steps then one entrant, or, with no cut at all, a revision to quota zero where `learning < tenure`.
  - Ruled door: from founders `others = []` on every course, so nobody is present without the rule.
  - Family law: a state with members present and no holder is reachable from founders exactly where the door is open.
- **L6. Self-revision.** A revision to quota zero leaves the region of L1: with entrants at every step, every holder is gone by `tenure` unless a holder revises it back first. So the rule regulates its own rebuild, and what L1 keeps closed is the region where it does not revise that away. That is an entrenchment clause's exact content here: the revisions it excludes are those out of `1 ≤ quota`.
- **L7. The family law.** At `learning < tenure`, `1 ≤ quota`, over the three sources, the rule is rebuilt from its members exactly where it outlives its founders and does not return after a gap (`step` from no member at all gives no holder). `.given` outlives them and returns; `.none` does neither.
- **L8. Identity is relative to the class.** On `«续» net E`, two classes of the grammar:
  - `samePresence`: both have a holder or neither does; `sameQuota`: the same quota.
  - A revision step continues under `samePresence` and not `sameQuota`. So under `.members` the rule's line goes on through a replaced rule.
  - Under `.given`, a gap continues under `sameQuota` (the quota kept, no member) and not `samePresence`. A refounding from a charter goes on as the same rule with no line.
  - So neither continuation contains the other. "The same institution" names no one fact: it is read at a class, as 01 §4 says of everything.

## 4. Against the three questions

1. **Outliving.** L3: teaching must fit inside a tenure, and the rule must admit someone. It forbids an institution rebuilt from its members, whose rule takes longer to learn than members stay, outliving its founders, however many join.
2. **Organism and institution.** `ReaderRebuilding.«读者绝则无储»` says the organism ends with its stock empty. L5 says the institution, with an open door, ends with every member present. What separates them is whether the rule stands in the way of everyone entering: a ruled door gives the organism's form of end, nobody there without the rule. **The hollow institution is therefore a theorem about the door, not a failure of the members.**
3. **Sameness.** L2 and L1 give a rule still held with no founder left and any quota. L8 says whether that is "the same" depends on the class read, and a charter's refounding comes apart from a line of teaching the other way.

## 5. What it does not show

- Why people comply. Compliance, motivation and warrant stay distinct: here a holder teaches and admits by the rule's definition, so nothing here explains any of them.
- The consent/penalty pair. `.given` is an outside holder; withdrawing it is not in this net. 01 §8.7's reading stands apart. What the family adds: a gap in members separates the pair the other way, the given rule returning and the members' not.
- Capture and revision by interest. T7, MA3 and MA4 read the rule's lock under selection, and none of it is here: entrants are not selected, and the revision is a free branch, not chosen by those it favours. Joining them is the next model's work.
- Schism, drift between holders, or a rule read differently by different holders.
- Size, amounts of anything, or any law of how many hold the rule. Quota is a whole number with no cap.
- Purposes that regulate nothing, and an institution's identity on the map of 02 (`«生成»` and its rows). A fine class that makes a renewal at the step would have to be chosen, and the review of 1 November warned against near-trivial fine classes. L8 stays on `«续»`.
- That any actual institution meets the hypotheses. That is a correspondence to be stated and checked, and none is claimed.

## 6. Correspondence, unproved here

AI reading, each a neighbour and none proved: Hart's rule of recognition (the door and the teaching ruled by the rule itself); North's and Ostrom's rules-in-use as held by those they govern; organizational memory under turnover (March 1991; Argote 1999), for the window; Weber's routinization, for the rule outliving its founders. L3's form may be known in overlapping-generations models of cultural transmission (Boyd and Richerson 1985; Cavalli-Sforza and Feldman 1981), and the review should search for it. If it is known, the record says so, as it must in any case: nothing here claims new mathematics.

## 7. What changes for a reader

- The one page's open item: "An institution has no model yet" goes, in both editions, at the smallest cost in words.
- 05's section on institutions gains the home section, since an institution is a collective; 01's test-systems bullet moves the item from open to modelled, and keeps purposes open.
- No root law is added. This is a model on the grammar, and it is claimed as one.

## 8. Questions for the review

1. Is any law definitional, as OG's first T4 was? L1 and L3 hang on one arithmetic fact; L4, L7 and the ruled half of L5 look close to the rule's definition. Does the family earn its statements?
2. Does the rule build in its results, in the choice of teaching before ageing, teaching only on entry, or one value held in common? Try each the other way in `sim/`.
3. L5's "reachable" uses a cut or a revision to zero: is there a more natural route, and does it weaken the claim?
4. Is `learning` the right parameter, and does L3 hold of the institution rather than of any tradition? The quota is what makes it regulate. Is that enough?
5. Is L8 worth stating, or does 01 §4 already say it with these occurrences renamed?
6. Should the module extend ReaderRebuilding instead, with holders as its reader?
