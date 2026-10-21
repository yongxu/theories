# EC: an elegant completion

Board item EC ([Ren, 21 October 2026](../../../../../../sources/15-codex-theory-conversations/2026-10-21-aim-elegant-completion.md)). AI-written plan.

## Aim

The theory is complete in the sense of K1–K7. It is elegant when few laws are each stated once, at the lowest layer that can hold them, and every central result follows from them. In the terms of board rule 9, the general law is the reason for each special one, and no second proof stands beside it.

## Measure

`measure.py` follows the Lean dependencies of every central declaration in `COVERAGE.json` and reports which master laws it rests on. Baseline on main `c03c85f00` (`baseline.json`):

| | Baseline |
|---|---:|
| Central declarations | 125 |
| Resting on no master law | 76 (75 with lumping) |
| Defined notions in their statements | 313 |

The candidate master laws, with their Lean anchors:

- **Closure.** What a relation carries reaches exactly its closure, and nothing beyond a closure bears the relation into it. Anchor: `WithinClosure`.
- **Balance.** A level changes by what is given and taken. Anchors: `Flow.Balances`, `Flow.BalancesOn`.
- **Return.** Within finitely many configurations a law returns every configuration or is drawn, and rest is a case of being drawn. Anchors: `Branching.Returns`, `Branching.Lossless`, `revisits_within`.
- **Lumping.** A part read alone carries a law exactly where the rest makes no difference to its next value. Anchor: `GoAlikeUnder`. Proposed by line A, whose LU1 is its first rule-9 step: `ClosedCapture.Unread` derived from `Law.sameFuture_of_goAlike`. Learning, selection's reach and capture are its cases.
- **Order.** Widening is retaining and adding. Anchor: `Web.Widens`. The ethics adds two premises to it, the continuation condition for scope and C for order.

## Steps

1. **EC1: one closure.**
   - `ClosedUnder` and `WithinClosure` move unchanged, with their names, from `Becoming.Feedback` to the frame.
   - A process's reach is the closure of its step.
   - The separately defined closures are that closure, by definition or by an exact theorem: the feeding closure, the closure across steps, the edge closure from a seed, and the closure of a group.
   - Their laws of what lies beyond are derived from the one closure, and the direct proofs go.
2. **EC2: one balance.** The level dynamics stated outside `Flow.Balances` are read as balance and derived through it: the next level of `Optimum`, the regime's draw, the counts across generations and relative position.
3. **EC3: one law of finite runs.** Rest, return and being drawn become one law of finitely many configurations.
4. **EC4: the ethics as closure and order** (line D). The scope is the closure the presupposition reaches (`forced_iff_within`). Significance spreads exactly through the connections' closure (`Valuation.significant_iff`). The order is what every positive weighting over the scope shares.
5. **EC5: the laws stated.**
   - The measure joins the connectivity run.
   - The chapter states the theory as these laws, with each row's central results as their consequences.
   - What still rests on no master law is named, with the reason.

Each step is claimed on the board before its Lean and lands through the queue.
