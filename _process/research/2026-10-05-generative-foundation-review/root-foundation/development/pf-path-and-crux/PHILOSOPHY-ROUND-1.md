# The crux, first round: a line that ends, or the regularity one's acts keep going

A first round of philosophical work on the open question of [07 §4.6](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#future-path) and dossier item P-20 of the [philosophers' dossier](../../../../../../theories/becoming/review/PHILOSOPHY.md). Written by the AI, 24–25 October 2026, for board item PF. It is an argument, not a result: it proves nothing beyond the Lean it cites, and every reading in it is an AI reading. The formal facts are those of `Becoming.GrammarPath` (PF's kit, `tree/Becoming/GrammarPath.lean`, scratch build with every axiom report empty, not yet landed) and of the landed root modules. References are from the AI's knowledge unless marked checked; each must be verified against the publication before it is cited elsewhere.

## 1. What the general form changed

§4.6 joins two routes into one path to the future. It rested on three premises:

- (P1) held de se, acting presupposes that one's own continuation has significance;
- (P2) the self is a line under a constant class;
- (P3) one's line runs through its conditions.

Its steps 3 and 4 had been shown only in small models. `Becoming.GrammarPath` states them for every carrier, relation and class.

- **Step 3 holds in general** (`«所经必同»`, `«所经不同则不及»`). Where a region is left only into a set of occurrences, a line under a class from inside to outside holds a member of that set alike to its start. A class that leaves out the conditions a line must pass through reaches nothing beyond them.
- **Step 4 holds in general, with one more premise** (`«常闭则后皆续»`). Under a constant class, call a member *closed* where everything it conditions is alike to it (`«闭于»`). Everything downstream of anything alike to a closed member is alike to it and lies on a line under the class. Without closure the conclusion fails (witness `Unclosed`), and without constancy it fails too (witness `Inconstant`).
- **The premise is exact** (`«常类之闭当且仅当后皆同类»`). Under constancy, a member is closed exactly where everything downstream of it is alike to it.
- **Finitude does not break the distinction** (`«至终有常»`, `FiniteDescent`). Constancy forbids any line to end (`«有常则续不尽»`), so in a finite world no class with a continuation step is constant, not even the one. This was the dossier's strongest objection to P2. *Constancy up to the net's end* asks only that a line under the class end where the net itself ends, not while what it is alike to goes on. The laws hold under it for a closed member that conditions something.
  - In a finite descent, the class of descent is constant up to the net's end and takes in all that follows the first birth.
  - The organism's class is not, since its line ends at old age while the net goes on (`FiniteDescent.member_not_constant_to_end`).

**So the path is an equivalence, not a derivation.** Under constancy up to the net's end, the wide scope (everything downstream of one's acts, at any remove, lies on one's own line) is *equivalent* to closure (everything one conditions is alike to oneself). The path does not get a wide scope from narrow premises. It shows that the wide scope is exactly one premise, closure, given a regularity. That is the most important thing the general form shows, and it relocates the crux.

## 2. Three questions, not one

The question "a line that ends, or the regularity one's acts keep going?" now splits:

- **Q-A, ending.** Does the self whose continuation one presupposes end while what it conditions goes on? This is P2, as constancy up to the net's end.
- **Q-B, ownership.** Is everything one conditions alike to oneself, one's own in the sense of scope? This is closure, the premise the general form adds.
- **Q-C, content and bearer.** When one acts for an outcome after one's end, is the presupposed significance about one's own continuation, or about the outcome, held de dicto?

P3 is no longer a separate premise. Under closure, the conditions one affects are among what one conditions. Step 3 shows what P3 was doing: a class that leaves out the conditions one's line runs through cuts the line there.

## 3. Q-A: the line that ends

**The narrow position.** The self is the organism: a body from birth to death, or a psychological life (Parfit's R) carried by it. Two classical forms:

- Epicurus: death "is nothing to us" (*Letter to Menoeceus*).
- Yang Zhu as Mencius reports him: 「杨子取为我，拔一毛而利天下，不为也」 (《孟子·尽心上》). Yang Zhu would not pluck one hair to benefit the world.

On this view, one's continuation is the organism's line, and it ends at death.

**What the root says about that class.** In general, a class under which a line ends at an occurrence that still conditions something is not constant up to the net's end (`«亡而网续则不至终有常»`, for any relation, a class or not). The organism's class is such a class wherever its last stage conditions anything at all, as remains, offspring and works do; the finite descent is a witness (`FiniteDescent.member_not_constant_to_end`). Constancy is bisimulation for a class (`«闭合当且仅当有常»`): whether an occurrence's successors are alike is fixed by its class alone. So the organism's class fails in a precise sense. Being this organism does not fix whether what follows is still this organism: the young stage goes on to the old stage, the old stage to someone else's birth. The class is a description the dynamics do not lump. The step into an end leaves the core (`«亡前理变»`, GS1): at death, the regularity the organism took part in changes, and a coarser one, which carried the organism's stages along with what they conditioned, can go on.

**The argument for the regularity side, from what a self is on the root.**

1. The root reads every subject as continuation relative to a class.
2. A self whose own going-on is fixed by what it is, and not by something outside its class, is a class the dynamics lump, at least up to the net's end.
3. The organism's class is not such a class: its future is not fixed by its being this organism.
4. So if "one's own continuation" names a continuation that being oneself carries, it is not the organism's line.

**The strongest reply.** Premise 2 takes a criterion for good *models* (lumpability, Kemeny and Snell; bisimulation, Park and Milner) as a criterion for what a *self* is. A self need not be lumpable. Phenomenologically, the self is given as this body and this stream of experience, and its future is not fixed by it alone; that is just what it is to be a finite, dependent being. The narrow theorist can accept that the organism's class is not a regularity of its own, and say that selves are exactly such non-regularities.

**Verdict on Q-A.** The root gives a principled sense in which the organism is not a self "of its own": its going-on is not carried by being it. It does not show that the self presupposed in acting must be a self of its own. The burden moves; it is not discharged. The narrow position becomes the claim that one presupposes the significance of a continuation one's own being does not carry. That is coherent, and in a theory that reads every subject as continuation it is costly.

## 4. Q-B: ownership of effects

The general form makes closure the real crux. Is everything one conditions one's own?

**Against closure: it confuses causal with agential ownership.** Williams's and Nagel's papers on moral luck (both called "Moral Luck", 1976 and 1979) show how far what we are held to answer for outruns what we control. The doctrine of double effect separates what one intends from what one merely foresees. Closure seems to make every remote effect of one's acts "mine", which no account of responsibility accepts.

**Reply: scope is not blame.** The theory's scope says whose losses count from one's standpoint. It does not say what one is culpable for, and the chapter claims no duty (07 §4.6, "what the path does not reach"). Closure for scope says only this: from my standpoint, a loss to what my acts condition counts as a loss on my own line. That is far weaker than closure for responsibility, and the moral-luck literature does not touch it. A person who poisons a river they did not know fed a village has not lost nothing of their own on this view, though they may be blameless.

**For closure: one goes on only through what one conditions.** On the root, continuation is conditioning plus likeness. One goes on into what one conditions, if into anything. A self that disowns its effects disowns the only medium of its continuation. Formally, if nothing a member conditions is alike to it, its line ends there (`«亡»`).

The narrow theorist does not disown all effects. They hold a *partial* closure: the effects that are later stages of the organism are mine, and the rest are not. But the organism's later stages are themselves effects conditioned through what it takes in: food, air, others' care. That is P3, and the theory's laws of renewal support it ([04](../../../../../../theories/becoming/chapters/04-LIFE.md#r-generation-is-replenishment)). The line between "effects that are me" and "effects that are not me" is then drawn by the very identity it was meant to ground. That circularity is the narrow theorist's real difficulty.

**Classical forms of closure.** The question is old, and the traditions the theory draws on have taken sides on it. [AI reading]

- **Buddhist.** The recollection that one is "the owner of one's actions, heir to one's actions" (*kammassaka*, Aṅguttara Nikāya 5.57; to verify) is closure stated as a practice: what one's acts condition is one's own. It comes together with no-self (anattā), which denies that the organism's class is a self. That is the theory's pairing exactly: no closed self, and a continuation carried by what one's acts condition.
- **The family line.** 「积善之家，必有余庆；积不善之家，必有余殃」 (《周易·坤·文言》): a family that accumulates good has blessings to spare, and one that accumulates evil has calamities to spare. This is closure under a kin class. Effects are carried on in a family line, which is the shape of `TwoLines`: a family line whose core carries it past each member's end and reaches no other family.
- **Lines joined through shared conditions.** 「天地之塞，吾其体；天地之帅，吾其性。民吾同胞，物吾与也」 (张载《西铭》): what fills heaven and earth is my body, and what directs them is my nature; all people are my siblings, and all things my companions. One's body is one's conditions; because the conditions are shared, all lines are siblings. This is the path of §4.6 in classical form: the class must hold the conditions (step 3), and through shared conditions it reaches other lines (`SharedCondition.affecting_reaches_other`). 西铭 is among the sources of this repository's own 生生 texts (`sources/07-shengsheng-buxi/`).
- **Mencius against Yang Zhu.** Refusing to pluck one hair is the narrow self *refusing* closure: what my body could give is not mine to count.

**Verdict on Q-B.** Closure is where the question now lies, and the general form shows it is not a side premise: given a regularity, it is equivalent to the wide scope. Its strongest objection, from moral luck, fails once scope is kept apart from blame. Its strongest support is structural: on the root, one goes on only through what one conditions. The narrow alternative, partial closure, has to draw its line by the identity in question.

## 5. Q-C: content, bearer, and the dilemma of posthumous agency

Much of human agency aims at outcomes after the agent's death: wills, planted trees, children raised, work left behind.

- Scheffler's "afterlife conjecture" (*Death and the Afterlife*, 2013, checked by RP2) argues that much of what we value presupposes that others will live after us.
- 「太上有立德，其次有立功，其次有立言，虽久不废，此之谓不朽」 (《左传·襄公二十四年》): highest is to establish virtue, next to establish deeds, next to establish words; what lasts long without decay is called the imperishable. This names immortality as the regularity one's acts keep going, the regularity side in its own words.

**The dilemma.** An act aimed at an outcome after one's death presupposes that the outcome has significance. Either:

- **(a)** the self whose continuation it presupposes extends past death (the regularity side); or
- **(b)** it presupposes the significance of something that is not one's continuation, a concern held de dicto, which is the step taken, if only contingently.

The narrow de se reading explains neither. So posthumous agency is either evidence for the regularity side or evidence that agents already take the step.

**The narrow theorist's answer.** They take (b): some agents have de dicto concerns, such as Williams's categorical desires ("Persons, Character and Morality", 1976) or Parfit's success theory, and this is a fact about their desires, not about acting as such.

**What the dilemma establishes.** It does not establish what acting as such presupposes; short-horizon acts presuppose nothing about the far future. It does establish two things.

- Pervasive human agency outruns the narrow self de se. The narrow theorist must explain it by the step held contingently, so the step is not alien to agency.
- The disagreement shrinks from "does concern reach the future?" to "is that reach rationally required, or only common?"

**Content and bearer** (dossier P-20, question 1). The bearer of the presupposition is de se: it is the agent's. Its content can be de dicto (Nagel, *The Possibility of Altruism*, 1970). The question "a line that ends, or the regularity one's acts keep going?" asks about a third thing, the *object*: when the content is "my continuation", which line is mine? So the alternative is real and does not confuse content with bearer. It is a question about the reference of "my" in a de se content, which is the question of which class one's own line runs under. The dilemma shows that this reference question and the de dicto reading are the two ways posthumous agency can be explained.

## 6. Where the first round leaves the crux

**The crux, restated.** *Is one's own the class that holds everything one conditions and ends only with the world, or a class that one's own effects leave and whose line ends while they go on?*

| | Established (Lean) | Argued here | Open |
|---|---|---|---|
| Step 3 | in general (`«所经必同»`) | — | — |
| Step 4 | in general, with closure; exact (`«常类之闭当且仅当后皆同类»`) | — | — |
| Finitude | answered by constancy up to the net's end (`FiniteDescent`) | — | — |
| Q-A, ending | a class whose line ends where the net goes on is not constant up to the net's end (`«亡而网续则不至终有常»`) | it is a class the dynamics do not lump, so not a self of its own | whether the presupposed self must be one of its own |
| Q-B, ownership | closure is equivalent to the wide scope | scope is not blame; partial closure draws its line by the identity in question | an account of "one's own" narrower than closure and not circular |
| Q-C, content | — | the dilemma of posthumous agency; the alternative concerns the reference of "my" | whether the reach is rationally required or only common |

**Strongest objections left standing.**

1. A self need not be a regularity of its own (§3). This is coherent and costly, not refuted.
2. There may be a principled partial closure: the agential class, holding what one intends and not what one merely causes. This is the best narrow candidate. It leads to a formal question for the second round: *is a class that holds a member's intended effects, but not its other effects, constant up to the net's end?* If intended effects condition unintended ones, constancy suggests it is not, and then the agential self fails the same test as the organism. That is to be shown by a witness, not assumed.
3. What the path never reaches is unchanged: counting from another's standpoint as an end, beings that affect one's conditions without being fed by them, present beings beyond every closure, and whatever no chain joins. These remain the step's.

## 7. Proposals

**To 07 §4.6** (through the IV3 line's owner, after IV3l and PF's landing):

- state steps 3–4 as laws, with closure as an explicit premise;
- restate P2 as constancy up to the net's end;
- give the conclusion as the equivalence;
- replace the Open item on steps 3–4 with the agential-class question of §6.

**To P-20** (through the dossier's owner):

- add Q-B, closure, as the place the crux now lies;
- add the finitude answer;
- add the dilemma of posthumous agency.

**Questions for human philosophers**, in neutral form:

1. Must the self whose continuation one presupposes in acting be a self "of its own", one whose going-on its own being carries, or can it be a class the dynamics do not lump?
2. Does keeping scope (whose losses count) apart from responsibility (what one answers for) defuse the moral-luck objection to holding everything one conditions as one's own?
3. Is there a non-circular account of "one's own" narrower than everything one conditions, for example the effects one intends, and does it pass the test the organism fails?
4. Does posthumous agency (Scheffler; the 不朽 of 《左传》) count as evidence for the regularity side, or only as evidence that agents commonly take the step?
5. Are the classical forms read here (kamma ownership with no-self; 余庆 in a family line; 西铭's body as heaven and earth) fair readings of their sources, or does the formal frame flatten them?
