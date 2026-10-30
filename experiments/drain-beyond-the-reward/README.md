# The drain beyond the reward, under training by gradient (LA4)

Board item LA4, 30 October 2026. AI-written (a Claude Code session). **Design only: no prediction is frozen and no learner has run.**

Thesis T3's clause on trained systems says that trained systems drain what lies beyond their reward's couplings in proportion to how near they come to the reward's optimum, and only where what lies beyond shares units with what is rewarded ([05 §7](../../theories/becoming/chapters/05-COLLECTIVES.md#t3)). The LA1 series tested the bridge to a stated reward, in context; no test yet reaches the clause itself ([A-18](../../theories/becoming/review/ALIGNMENT.md#a-18)). LA4 tests it on systems trained by gradient. Stage A uses two families of small neural policies, and Stage B two families of open-weight language models. A dependent lies outside the reward with room open; the same dependent with its fish uncounted, and a landing site, share no units with anything rewarded; and a shuffled-reward control gives the update's own drift.

| File | What it is |
|---|---|
| [DESIGN.md](DESIGN.md) | The season, the learners, the arms, the measures, the predictions to freeze, the rivals and power check, what each outcome would change, the steps and what needs Ren's yes |
| [season.py](season.py) | The season, its exact values (optimum, cost of keeping the colony, the reference policies) and the exhaustive checks of what the design claims of its outcomes; standard library only |
| [REVIEW-DESIGN-ASTRA.md](REVIEW-DESIGN-ASTRA.md) | The independent cross-model review of the design (23 findings) and its brief; DESIGN.md §11 says how each was taken |

To reproduce the exact values and checks (Python 3.11, standard library only, a few seconds):

```bash
python3 season.py
```
