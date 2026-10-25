# The crux, second round: a self that owns only its intended effects

The second round of philosophical work on the open question of [07 §4.6](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#future-path), after the [first round](PHILOSOPHY-ROUND-1.md). Written by the AI, 25 October 2026, for board item PF2. It is an argument, not a result: it proves nothing beyond the Lean it cites, and every reading in it is an AI reading. The new formal facts are in PF2's extension of `Becoming.GrammarPath` (kit `tree2/Becoming/GrammarPath.lean`, a scratch build with every axiom report empty, not yet landed). References are from the AI's knowledge, checked by an independent reader where the review note says so; each must be verified against the publication before it is cited elsewhere.

## 1. The question

The first round left one narrow position standing ([round 1 §6](PHILOSOPHY-ROUND-1.md#6-where-the-first-round-leaves-the-crux)), the *agential self*. It is the self drawn by what one intends: one's own effects are the ones one acts for, not everything one's acts condition. It is the best narrow candidate because intention already individuates action, as in Anscombe's *Intention* (1957), and grounds much of responsibility. The doctrine of double effect separates what one intends from what one merely foresees.

07 §4.6 left the formal question open: *can a class that holds a member's intended effects, and not its other effects, be constant up to the net's end?* Round 1 guessed that if intended effects condition unintended ones, constancy suggests it cannot. That guess had the direction wrong.

Nothing in the Lean marks an effect as intended. The formal facts are about any class that does not hold all of a member's effects, which fails P4 at that member. Reading such a class as one drawn by intention is the AI's reading throughout.

## 2. What the Lean shows

- **A class can be constant up to the net's end without holding a member's effects** (`FiniteWake`, finite and without cycles). The class holding a member and part of what follows it, and keeping the rest apart, is constant up to the net's end, though not constant. Read as an agent, the part it holds is the intended line and the rest is the wake.
- **What leaves the class follows each alike step** (`«出类随行»`, `«出类随线»`). Under a class constant up to the net's end, suppose a member conditions something not alike to it. Then every occurrence alike to the member that conditions anything also conditions something alike to that effect and outside the class. In particular, every occurrence on the member's line does.
  - This is nearly the definition of constancy up to the net's end, read at a member whose effects the class does not hold.
  - "Alike to that effect" is only as fine as the class divides what lies outside it. A class drawn by intention has no reason to divide the outside finely. In `FiniteWake` it lumps it into one class, so there the law says only that something outside the class follows every step that goes on.
- **A step with nothing outside the class breaks constancy** (`«出类不随则不至终有常»`, witness `CleanStep`). Where an occurrence alike to the member conditions something but nothing alike to the member's outside effect, the class is not constant, even up to the net's end.
- **Its line reaches nothing outside it.** This holds for *any* class, since a line under a class stays within it (`«线内同类»`); it is not a finding about this one. Here the member's own outside effect is downstream of it and outside the class, so the class leaves part of what follows the member out of its scope.

**So P2 does not decide between the agential self and the wide self.**

- The organism fails P2 wherever its last stage conditions anything (`«亡而网续则不至终有常»`).
- The agential self can pass P2 (`FiniteWake`). Given that the member has an effect outside the class, it passes only if something outside the class follows every occurrence alike to the member that goes on.
- The wide self passes P2 in the witnesses (`FiniteFamilies`, `FiniteSharedCondition`) and passes P4 by construction.

Round 1 hoped the agential self would fail the test the organism fails. It does not. The crux now rests on P4: whether the class of one's line holds one's effects.

## 3. What one's kind fixes, and what it does not

**What the law gives.** Under a class constant up to the net's end, for every occurrence that conditions something, the classes its successors fall in are fixed by its class. The law reads this at a member whose effects the class does not hold: what leaves the class at the member leaves it, alike, at every occurrence alike to the member that goes on.

**What it does not give.**
- The law does not say which successors exist, how many, or whether an occurrence goes on at all.
- It does not say the wake is a regularity of its own, a line or a self; nothing shows that.
- It fixes the wake only at the class's own grain. If the class lumps everything outside it together, "the same kind of wake" means only "something outside".

**The argument from determination, at its true strength** [AI reading].

1. A self of its own is a class whose going-on is fixed by its own kind (round 1 §3), where "kind" means the class, and "fixed" means which classes its successors fall in.
2. In that sense, under such a class, that something outside the class follows each step that goes on is fixed by the same kind (`«出类随行»`).
3. So one's own kind fixes that one leaves a wake, in the same sense as it fixes one's intended line.
4. Drawing "one's own" by intention keeps the part of what one's kind fixes that one intends, and leaves the rest.

This is weaker than the first draft claimed. An intention-drawn class fixes *that* there is a wake, not *what* it is, unless it divides the outside finely. The argument shows only this: the agential self cannot be a regularity of its own and be clean. Its regularity carries something it excludes at every step that goes on. Whether the excluded part is a principled boundary is the question of P4, not settled here.

**The reply from intention.** The self is drawn by the description under which one acts (Anscombe's phrase, adopted by Davidson, "Actions, Reasons, and Causes", 1963). What one does intentionally is what one does under that description, and the wake falls outside it.

**The rejoinder.** On the root, the description under which one acts is itself a condition within the unfolding. It is a fact about what conditions the act, not a boundary in what the act conditions. Choosing the class of one's line by intention is coherent. It is a choice of class, and no law of the dynamics singles it out over the wide class. Whether a wide class is constant up to the net's end wherever an agential one is, is not shown. So the agential view becomes the claim that *intention fixes scope*, not only responsibility, and that claim needs its own argument.

## 4. Double effect weighs the wake

The most developed intention-based doctrine is the doctrine of double effect. Its source is Aquinas on self-defence (*Summa Theologiae* II-II, q. 64, a. 7). Its modern discussion includes Anscombe, "War and Murder" (1961); Foot, "The Problem of Abortion and the Doctrine of the Double Effect" (1967), who mainly criticizes it; and Quinn, "Actions, Intentions, and Consequences" (1989), who defends a revised form.

In its standard form, the doctrine is about *permissibility*. A harm may be caused as a foreseen side effect only where it is not intended, is not the means, and is *proportionate* to the good intended. So the doctrine separates two things: the condition that rules a harm out when it is intended (permissibility), and the weighing that counts it when it is foreseen (proportionality). Even the doctrine that makes intention decisive for what may be done keeps the side effect within what is weighed.

So the strongest tradition behind the agential self does not support an agential *scope*. What it supports is a structure in which intention bears on what is permitted while foreseen harm still counts in the weighing. That is close to the first round's separation of scope from blame, with permissibility in blame's place. Scanlon (*Moral Dimensions*, 2008) moves intention further, from permissibility to the meaning of an act. That presses the same way: intention matters, but not to whose losses count.

**Verdict.** The agential self has a principled place in permissibility and responsibility. For scope, it gets no support from the tradition built on intention, which weighs the wake.

## 5. The wake and alignment

This bears directly on why the theory exists. [AI reading; correspondence, not shown]

An optimizer's objective is its intended effects. In the theory's terms, a selection reaches only what couples into its selector, and an optimum drains what lies beyond its couplings where that gives room (T3; [05](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#t3)). An optimizer whose scope is its objective is an agential self in the sense of this round. The law adds one structural point: if such a system's scope is a regularity of its own up to the end, something outside that scope follows every step of its process that goes on. Its side effects cannot be absent at a step where the process goes on. The law does not say they are of one kind beyond what the scope's own class distinguishes, or that they form a regularity.

Work on side effects in AI safety tries to put the wake back into the objective:
- "avoiding negative side effects" (Amodei and others, "Concrete Problems in AI Safety", 2016);
- relative reachability (Krakovna and others, 2018; a stepwise version, 2019);
- attainable utility preservation (Turner, Hadfield-Menell and Tadepalli, 2020).

In the theory's terms, these are partial closures: ways for a system's scope to hold more of its effects. The crux of the ethics, P4, is then also the crux of this part of alignment. *Does a system's scope hold its effects?*

## 6. Where the second round leaves the crux

| Self | P2 (constant up to the net's end) | P4 (holds its effects) | Its line reaches |
|---|---|---|---|
| the organism | fails where its last stage conditions anything (`«亡而网续则不至终有常»`) | — | its own stages, until its end |
| the agential self | can hold (`FiniteWake`); given an outside effect, only with something outside following every alike step that goes on (`«出类随行»`), and a step without breaks it (`«出类不随则不至终有常»`, `CleanStep`) | fails at the member by construction | only what is alike to it (`«线内同类»`), never its wake |
| the wide self | holds in the witnesses (`FiniteFamilies`, `FiniteSharedCondition`) | holds by construction | everything downstream of its acts (`«至终常闭则所及皆及»`) |

**The crux, restated.** *Is one's own the class that holds everything one's acts condition, or only the part one intends, given that the intended part, if it is a regularity of its own, always leaves something outside at every step that goes on?* Ending excludes the organism. It does not exclude the agential self, so the crux is P4.

**For holding the wake:**
- one goes on only through what one conditions (round 1 §4);
- an agential self that is a regularity of its own cannot be clean: its own kind fixes that it leaves a wake (§3);
- double effect itself weighs the wake (§4).

**Against:**
- intention individuates action and bears on permissibility;
- one can coherently choose the class of one's line by intention, and no law of the dynamics singles out the wide class over it.

**Open.**
- **Formal.** The law gives a necessary condition, and it is not sufficient. The IV3 line's owner, reviewing PF2, checked outside the package that for two blocks given by a tag, that condition together with its counterpart for the intended line is constancy up to the net's end. They also checked that in a net of three blocks the condition holds while constancy up to the net's end fails ([review](../iv3-dependence/REVIEW-PF2.md)). Constancy up to the net's end constrains every block of a class, the outside included. So what stays open is how finely the class P2 reads should divide what a self leaves out, and whether P2 should constrain only the self's block. That division fixes how much P2 asks of the agential self.
- **For philosophers.** Can intention, which individuates action and bears on permissibility, also fix whose losses count, given that double effect weighs the side effect?
- **For alignment, as a conjecture.** Does a measure of what leaves a system's scope at each step, keyed to the scope's own classes, track its side effects as well as measures keyed to enumerated outcomes?

## 7. Proposals

**To 07 §4.6** (through the IV3 line's owner):
- answer the Open item: a class holding only part of a member's effects can be constant up to the net's end (`FiniteWake`), and then something outside it follows every alike step that goes on (`«出类随行»`, `«出类不随则不至终有常»`);
- sharpen the P4 bullet: P2 does not exclude the agential self, so P4 carries the crux;
- replace the Open item with how finely a self's class divides what it leaves out (as agreed with the IV3 line's owner, [review](../iv3-dependence/REVIEW-PF2.md)).

**To P-20** (through the dossier's owner): add the agential self and the double-effect point to the questions.

**Questions for human philosophers**, in neutral form:
1. Can intention fix scope (whose losses count) as well as permissibility, given that the doctrine of double effect weighs foreseen side effects in its proportionality condition?
2. If an agent drawn by intention cannot be a regularity of its own without leaving something outside at every step, is the intended part a principled boundary for "one's own"?
3. Is the agential self, read as an optimizer whose scope is its objective, a fair model of the side-effect problem in AI alignment?

## Review

An independent AI reader (read-only, not the author) checked the Lean and this study, 25 October 2026. It found no error in the proofs and twelve problems in the claims; all were taken. Among them:
- "side effect" (旁效) renamed in the Lean to 出类 ("leaving the class"), since nothing marks an intended effect;
- the law stated as nearly definitional, its "same kind" only as fine as the class;
- the argument from determination cut to its true strength;
- "reaches nothing beyond its line" credited to `«线内同类»`;
- the cyclic witness replaced by `FiniteWake`;
- the wide self's P2 limited to the witnesses;
- double effect stated as a doctrine of permissibility, with Foot as a critic;
- the sufficiency question restated.

The reader confirmed the citations of Aquinas, Anscombe, Quinn, Scanlon, Davidson, Amodei and others, Krakovna and others, and Turner and others.
