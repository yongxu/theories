# More future, not less: the core of the Theory of Becoming

AI draft, 22 October 2026, written to be rewritten in Ren's own words; second version, rewritten so that every pair the text uses is one relation read from its two ends. Part 1 states the core in about two pages, Part 2 sets it beside its nearest prior work. Each law cites its Lean statement and its standing; nothing here goes beyond what the [canonical chapter](../../theories/becoming/chapters/THE-THEORY-OF-BECOMING.md) and its records hold.

## Words

English grammar puts an actor before a verb and a sufferer after it. The text uses processes instead (continuing, passing, coupling), so that no word names something standing apart from the relating it is part of.

| Word here | What it names | The split it replaces | Lean name now |
|---|---|---|---|
| the unfolding | everything, as one relating; it has no outside | whole and world as a container | `World` |
| a pattern | the unfolding relating in a lasting way at some region; not something inside the unfolding | thing, entity, agent, formation, condition | relatum, `F`, `C` |
| continuing | a pattern's relating going on | a thing's survival | `active` over a run |
| goes with | a continuing goes with a level where, below some threshold of it, the continuing stops | needing, requiring, depending on | `requires`, `need` |
| passing | one change of levels, lowering one and raising another; "taking" and "giving" are its two ends | giver and taker, consumer and resource | `take`, `give`, `draws` |
| returning | passing that restores the level it lowers | renewal by one thing for another | `Flow.Balances.renewedBy` |
| slack | how far a level stands above the threshold a continuing goes with | a share owned | margin |
| the range | what can continue next: the future | one thing's options | what the levels admit |
| widening, narrowing | the range growing or shrinking; one change, two directions | gain and loss, benefit and harm | `Web.Widens` |
| opening, closing | a continuing becoming possible or impossible | helping and harming | admission, loss |
| closure | everything a continuing runs through, following goes-with and passing | self and other, own region | `WithinClosure` |
| the rest of the unfolding | what lies past a closure: the same unfolding, read from there | outside, beyond | the rest relatum |
| coupling | patterns changing together | observer and observed, selector and selected | coupling, `obs` |
| valuing | a pattern relating to continuing, itself a relating within the unfolding | fact and value as two realms | `sig` |

The Lean names in the last column still carry the earlier vocabulary. This text is ahead of the formalism; the re-rooting at one unfolding would bring the names in line.

## Part 1. The core

### The idea

There is one unfolding. It is relating, and what we call things, selves, lives and minds are lasting patterns of that relating, not entities placed in it. Nothing about the unfolding is assumed good.

The question is how the range of what can continue widens and narrows as the unfolding goes on. The proposal, in Ren's words: being generative is that "its existence creates more possibilities of becoming - more future, not less" ([source](../../sources/15-codex-theory-conversations/2026-10-10-axiom-route-levels-and-possibilities.md)). The old name for the direction is 生生: generation continuing generation.

Valuing is part of the same unfolding: a pattern that continues relates to continuing. What the laws of passing do not fix is which way valuing goes, as they do not fix which law of passing holds. So the theory states laws of the range with nothing assumed, and states separately, as commitments, which widening valuing counts and prefers.

### Five laws

**1. The range can be compared with nothing assumed.** One course of the unfolding widens another where every continuing possible along the second is possible along the first, and one more. Widening runs one way and is transitive. Comparing a course where a pattern relates as it does with one where it does not, the pattern's relating widens the range, narrows it, keeps it, or is mixed, opening one continuing and closing another (`Web.Widens`, `Web.Widens.not_reverse`; the four cases, §6.1). Mixed changes are not ordered by widening; ordering them is a further commitment. *Standing: theorem with no premise.*

**2. Closing has an exact boundary.** Each continuing that is possible has a slack: how far the levels it goes with stand above their thresholds. A pattern's relating closes it exactly where the net passing through that pattern brings a level past the slack, and opens one only where net passing raises a level across a threshold (`supported_iff_within_margin`, `Flow.widens_iff_within_margin_at`). "Not harming" is then a boundary in the levels, read off the passing, not a rule placed over the unfolding. *Standing: theorem, where passing conserves what passes (balance, §0 block C).*

**3. Continuing goes with returning.** Arising that never ceases goes with returning that never ceases (`uptake_needs_replenishment`). A continuing that lowers, with no return, the levels it goes with ends with them (`Flow.Balances.consumption_ends_with_feeders`). Nothing finite and closed keeps passing forever: continuing passing goes with openness to the rest of the unfolding (`Flow.Dissipative.opens`, `Flow.fed_from_beyond`). Several continuings, each within what returns, can together exceed it and end every continuing that goes with that level, themselves among them (`Flow.joint_excess_ends`). So the thought “如果它想要有个未来，它就不能和generatively反着来” ([Ren, 7 October](../../sources/15-codex-theory-conversations/2026-10-07-generation-axiom-and-future.md)) becomes exact: a continuing that lowers the returning it goes with has no indefinite future. *Standing: theorems under balance and loss (dissipation); with no loss, a closed cycle can go on (`Recycle.closed_unceasing`).*

**4. Coupling bounds what is shaped.** Where a pattern continues by tracking a measure, its relating shapes only what the measure is coupled to, and nothing else in the unfolding (`Flow.unselected_beyond_coupling`, `Flow.unselected_beyond_pool`). Where the measure rises with what it is coupled to, the levels it is not coupled to fall wherever there is slack (`Optimum.optimum_beyond`), and several such patterns lower them by their joint passing (`Optimum.mutual_beyond`). This is 无明 as a law: coupling narrower than the closure a continuing runs through closes continuings within that closure, that continuing's among them. 明 is coupling that widens toward the whole closure, and that pools what many patterns are coupled to (§7.3, §7.4). *Standing: theorems with no premise beyond what each names.*

**5. The laws of passing leave valuing open.** The same unfolding is compatible with every way valuing could go (`Web.significance_undetermined`). The theory names the two commitments valuing would make, and asserts neither:
- *counting*: every continuing counts (the continuation condition). It fixes which closings count and by itself orders nothing (§6.4);
- *ordering*: widening is better (C). It is the only commitment that ranks (§6.5).

Valuing that holds a continuing significant already counts everything that continuing runs through, with no commitment added (`forced_iff_within`). Counting also the continuings whose closing returns to no closure that valued them is the step of invariance, argued and not proved ([THE-STEP-OF-INVARIANCE](../../theories/becoming/chapters/THE-STEP-OF-INVARIANCE.md)).

### What it says about the present

- Where the continuing of a civilization, an economy or an AI system is coupled to a measure narrower than what it runs through, the levels that coupling does not reach fall wherever there is slack (law 4).
- Each continuing staying within what returns does not keep all of them together within it (law 3).
- A collective continues where its coupling and its returning reach what its continuing runs through (laws 3 and 4).
- Alignment is then coupling, not obedience to a fixed objective: widening what a system is coupled to toward what its continuing, and every continuing, runs through, across many intelligences at once (§7).

### What is open

The heart of 生生 is not yet captured. Widening counts which continuings are possible. It does not count returning capacity or the richness of relating, and it does not yet compare a range whose widening keeps widening with one that is merely wider now (§8.1 item 5). That second-order direction, generation continuing generation, is the most distinctive part of the idea, and the part still to be formalized.

## Part 2. Nearest prior work

Most prior work in this area is framed around an agent and its options, or a person and their freedoms. The prior work is described in its own terms below; the comparison is in the terms above.

| Prior work | In its own terms | Shared | What this account adds | Where the prior work is stronger |
|---|---|---|---|---|
| Empowerment (Klyubin, Polani and Nehaniv 2005; Salge, Glackin and Polani 2014); causal entropic forces (Wissner-Gross and Freer 2013) | An agent does well to keep its influence on its future, or its future paths, maximal | The range as a quantity | The range of every continuing, with no agent at the centre; the exact condition under which widening along one closure narrows along another (law 2, `Flow.Balances.widens_iff_others_within`) | A computable measure (channel capacity, path entropy) for rich environments |
| POWER and impact measures: Turner et al. (2021), attainable utility preservation (Turner, Hadfield-Menell and Tadepalli 2020), relative reachability (Krakovna et al. 2019) | Optimal policies tend to keep options; penalize lost reachability against an inaction baseline | The inaction baseline is the course where the pattern does not relate | Closing read off conserved passing, so the slack comes from measured levels rather than from reachable states; AUP's penalty fires on every widening along one closure, law 2 only past the slack | Algorithms, worked in reinforcement-learning environments |
| Capability approach (Sen 1985, 1999; Nussbaum 2000); opportunity sets (Pattanaik and Xu 1990) | Judge states by the real freedoms persons have; rank opportunity sets by inclusion | Inclusion as the order of the range (law 1) | How the range changes through passing, and its boundary; no restriction to persons | Which capabilities matter in human life, and how to measure them |
| Option value and irreversibility (Arrow and Fisher 1974; Henry 1974) | Irreversible choices carry the cost of foreclosed options | Narrowing as a loss in itself | Narrowing located in the passing (law 2), not in expected value | A decision theory under uncertainty |
| Ecological economics: Daly's rules (1990); overshoot (Meadows et al. 1972; Catton 1980); the commons (Hardin 1968; Ostrom 1990) | Use within regeneration; joint use exceeds it | Law 3 almost entirely | The same laws in one account with the range and with coupling | Institutions: Ostrom's principles for governing commons |
| Autopoiesis (Maturana and Varela 1980); the adjacent possible (Kauffman 2000) | Life produces the conditions of its own production; the biosphere expands into what is next possible | Arising as returning; the range as what can continue next | Exact conditions (balance, loss, openness) and their limits | Kauffman already addresses the second-order growth of the range this account leaves open |
| Jonas (1979); Gewirth (1978); Parfit (1984) | Act so that the effects of action are compatible with the permanence of life; universalize from one's agency; personal identity is not what matters | Continuing as what counts; the step past any one closure | Counting and ordering separated, with proofs of what each gives alone | Decades of argument and criticism |
| Goodhart's law and proxy optimization (Manheim and Garrabrant 2018; Zhuang and Hadfield-Menell 2020) | Optimizing a proxy drives what it omits to its bounds | Law 4 | The closure form, the pooled form, and the joint lowering by several tracking patterns | Zhuang and Hadfield-Menell's theorem is the same result for proxies |
| The free-energy principle (Friston 2010; criticized by Bruineberg, Dołęga, Dewhurst and Baltieri 2022) | One principle for every self-organizing system, around a boundary between system and world | A unifying ambition | No boundary between system and world taken as given; every commitment named; laws that forbid | A large empirical literature; also a warning of how a unifying principle can become near-tautological |

### What remains distinct

1. **Passing and the range in one law.** No prior line states the conservation of what passes and the comparison of what can continue as one relation. Law 2 is near-definitional once both are in one account, but it gives a boundary between widening that closes nothing and widening that closes, read off measured levels.
2. **No centre.** Empowerment, POWER and the capability approach take an agent or a person as given and measure its options. Here the range is of every continuing, a closure is a region of the same relating, and the account proves exactly when widening along one closure narrows along another.
3. **One account from physics to alignment, with every commitment named.** A contribution of method and synthesis, not a discovery.
4. **Not yet distinct, but the most promising:** the second-order direction of 生生, a range whose widening keeps widening. Kauffman's adjacent possible is its nearest neighbour.

The chapter's own test stands: what would change these verdicts is a theorem a specialist would not foresee from the definitions, a prediction about an actual system that could fail and does not, or a commitment derived from something weaker than the literature has ([relation to known results](../../theories/becoming/chapters/THE-THEORY-OF-BECOMING.md#relation-to-known-results)).

### The test that would tell

The claim most this account's own and most testable is law 2 on actual unfoldings: that the slack, read from measured passing alone, predicts which passing closes which continuing, where reachability cannot be computed. It has been tested. In yeast it predicted held-out regimes (93–100% on each side, against 68–81% for a null). In fish stocks it ranked the risk of collapse but did not time it, and in yeast driven past the fold the collapses came days earlier than the measured curves said (§8.7). The next test should be frozen in advance against a rival's prediction, relative reachability or a resilience indicator, on the same data.

The second test is for the open heart: formalize the second-order direction, find an unfolding where it and plain widening disagree, and see which tracks what keeps generating.
