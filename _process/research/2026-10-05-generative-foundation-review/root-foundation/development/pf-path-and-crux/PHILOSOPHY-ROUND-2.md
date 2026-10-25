# The crux, second round: a self that owns only its intended effects

The second round of philosophical work on the open question of [07 §4.6](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#future-path), after the [first round](PHILOSOPHY-ROUND-1.md). Written by the AI, 25 October 2026, for board item PF2. It is an argument, not a result: it proves nothing beyond the Lean it cites, and every reading in it is an AI reading. The new formal facts are in PF2's extension of `Becoming.GrammarPath` (kit `tree2/Becoming/GrammarPath.lean`, a scratch build with every axiom report empty, not yet landed). References are from the AI's knowledge unless marked checked; each must be verified against the publication before it is cited elsewhere.

## 1. The question

The first round left one narrow position standing ([round 1 §6](PHILOSOPHY-ROUND-1.md#6-where-the-first-round-leaves-the-crux)), the *agential self*. It is the self drawn by what one intends: one's own effects are the ones one acts for, not everything one's acts condition. It is the best narrow candidate because intention already individuates action, as in Anscombe's *Intention* (1957), and grounds much of responsibility. The doctrine of double effect separates what one intends from what one merely foresees.

07 §4.6 left the formal question open: *can a class that holds a member's intended effects, and not its other effects, be constant up to the net's end?* Round 1 guessed that if intended effects condition unintended ones, constancy suggests it cannot. That guess had the direction wrong.

## 2. What the Lean shows

- **Side effects follow the line** (`«旁效随行»`, `«旁效随线»`). Take a class constant up to the net's end, and a member that conditions something not alike to it, a side effect in the class's terms. Then every occurrence on its line under the class that conditions anything also conditions something alike to that side effect and outside the class.
- **A clean intended step breaks the regularity** (`«旁效不随则不至终有常»`, witness `CleanStep`). Where an occurrence on the intended line goes on without a side effect of that kind, the class is not constant, even up to the net's end.
- **The agential class can be a regularity of its own.** In `Unclosed`, read in `AgentWithWake`, the class holding a member with its intended effect and not its side effects is constant. Its line never reaches a side effect, and every step of it that goes on carries one.
- **It reaches nothing beyond its intended line.** It does not hold its effects. So by PF's exact law (`«常类之闭当且仅当后皆同类»`) something downstream lies outside it, and its line does not take in what its intended effects feed (`Unclosed.not_taken_in`).

**So P2 does not decide between the agential self and the wide self.**

- The organism fails P2: its line ends while what it conditions goes on.
- The agential self can pass P2, but only with a *wake*: side effects of one kind at every step of its line that goes on.
- The wide self passes P2 and P4.

Round 1 hoped the agential self would fail the test the organism fails. It does not. The whole crux now rests on P4, whether the class of one's line holds one's effects.

## 3. The wake is fixed by the same regularity

**What the side-effect law says.** An agential self that is a regularity of its own is never without its wake. The wake is not scattered or accidental. At every step that goes on, a side effect *of the same kind* follows. Constancy is bisimulation for a class (`«闭合当且仅当有常»`): which classes an occurrence's successors fall in is fixed by its class alone. Under such a class, the agent's kind fixes the kind of its wake as fully as it fixes its intended line.

**The argument from determination** [AI reading].

1. A self of its own is a class whose going-on is fixed by its own kind (round 1 §3).
2. Under such a class, the kind of side effect at each step that goes on is fixed by the same kind (`«旁效随线»`, with constancy).
3. So one's own kind fixes one's wake as fully as one's intended line.
4. Drawing "one's own" by intention therefore splits what one's own kind fixes into two parts and keeps one.

The agential theorist needs a reason why what one's own kind fixes is not one's own.

**The reply from intention.** Intention supplies such a reason: the self is drawn by the description under which one acts (Anscombe; Davidson, "Actions, Reasons, and Causes", 1963). What one does intentionally is what one does under that description. The wake falls outside it.

**The rejoinder.** On the root, the description under which one acts is itself a condition within the unfolding. It is a fact about what conditions the act, not a boundary in what the act conditions. Choosing the class of one's line by intention is coherent. It is a choice of class, and no law of the dynamics singles it out over the wide class. Whether the wide class is a regularity wherever the agential one is, is not shown; in `Unclosed` it is. So the agential view becomes the claim that *intention fixes scope*, not only responsibility. That claim needs its own argument.

## 4. Double effect counts the wake

The most developed intention-based doctrine is the doctrine of double effect. Its sources are Aquinas on self-defence (*Summa Theologiae* II-II, q. 64, a. 7) and its modern formulations: Anscombe, "War and Murder" (1961); Foot, "The Problem of Abortion and the Doctrine of the Double Effect" (1967); Quinn, "Actions, Intentions, and Consequences" (1989).

In its standard form, the doctrine permits causing a harm as a foreseen side effect only where the harm is not intended, is not the means, and is *proportionate* to the good intended. The proportionality condition weighs the side effect. Even the doctrine that makes intention decisive for permissibility keeps the wake within what is weighed. It distinguishes the side effect's standing in *blame* (not intended) from its standing in *scope* (counted in the weighing).

So the strongest tradition behind the agential self does not support an agential *scope*. It supports exactly the separation the first round drew: scope is not blame. Scanlon (*Moral Dimensions*, 2008) argues that intention bears on the meaning of an act, not on its permissibility. That presses the same way: intention matters, but not to whose losses count.

**Verdict.** The agential self has a principled place in responsibility. For scope it has no support from the tradition built on it, since that tradition weighs the wake. Holding the wake in scope while not intending it is the doctrine's own structure.

## 5. The wake and alignment

This bears directly on why the theory exists. [AI reading; correspondence, not shown]

An optimizer's objective is its intended effects. In the theory's terms, a selection reaches only what couples into its selector, and an optimum drains what lies beyond its couplings where that gives room (T3; [05](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#t3)). An optimizer whose scope is its objective is an agential self in the sense of this round. The side-effect law adds a structural point: if such a system is a regularity of its own, its wake is a regularity too, of one kind at every step. Its side effects are not occasional accidents of an otherwise clean process; they recur with the process.

Work on side effects in AI safety tries to put the wake back into the objective:

- "avoiding negative side effects" (Amodei and others, "Concrete Problems in AI Safety", 2016);
- relative reachability (Krakovna and others, 2018–2019);
- attainable utility preservation (Turner and others, 2020).

In the theory's terms, these are partial closures: ways for a system's scope to hold more of its effects. The crux of the ethics, P4, is then also the crux of this part of alignment. *Does a system's scope hold its effects?* A conjecture worth testing, not a result: since a regular agent's wake has one kind at every step, a side-effect measure keyed to kinds of effect, rather than to enumerated outcomes, would follow it.

## 6. Where the second round leaves the crux

| Self | P2 (a regularity of its own, up to the net's end) | P4 (holds its effects) | Reaches |
|---|---|---|---|
| the organism | fails where its last stage conditions anything (`«亡而网续则不至终有常»`) | — | its own line, until its end |
| the agential self | can hold, only with a wake at every step that goes on (`«旁效随线»`, `Unclosed`); a clean step breaks it (`CleanStep`) | fails by construction | its intended line, never its wake |
| the wide self | holds in the witnesses (`FiniteFamilies`, `FiniteSharedCondition`) | holds | everything downstream of its acts (`«至终常闭则所及皆及»`) |

**The crux, restated.** *Is one's own the class that holds everything one's own kind fixes, wake included, or only the part one intends?* The first round's two questions (ending, ownership) reduce to the second. Ending excludes the organism; it does not exclude the agential self.

**For holding the wake:**
- one goes on only through what one conditions (round 1 §4);
- one's kind fixes one's wake as fully as one's intended line (§3);
- the doctrine of double effect itself weighs the wake (§4).

**Against:**
- intention individuates action;
- one can coherently choose the class of one's line by intention, and the dynamics do not single out the wide class over it.

**Open.**
- **Formal.** Is "side effects of the member's kind follow every step that goes on" also sufficient for constancy up to the net's end, under some further condition? Only necessity is shown.
- **For philosophers.** Can intention, which individuates action and grounds responsibility, also fix whose losses count, given that double effect weighs the side effect?
- **Empirical, for alignment.** Does a side-effect measure keyed to kinds of effect follow an optimizer's wake better than one keyed to outcomes?

## 7. Proposals

**To 07 §4.6** (through the IV3 line's owner):
- answer the Open item: the agential class can be constant up to the net's end, only with a wake (`«旁效随线»`, `CleanStep`, `AgentWithWake`);
- sharpen the P4 bullet: P2 does not exclude the agential self, so P4 carries the crux;
- replace the Open item with the sufficiency question.

**To P-20** (through the dossier's owner): add the agential self and the double-effect point to the questions.

**Questions for human philosophers**, in neutral form:
1. Can intention fix scope (whose losses count) as well as responsibility, given that the doctrine of double effect weighs foreseen side effects in its proportionality condition?
2. If an agent's kind fixes its side effects as fully as its intended effects, is the intended part a principled boundary for "one's own"?
3. Is the agential self, read as an optimizer whose scope is its objective, a fair model of the side-effect problem in AI alignment?
