# Formations that read: the designs of RF's tests (TR1 to TR9)

Board item RF, 31 October 2026. AI-written (a Claude Code session). **Nothing is frozen and nothing has run on a trained system, a model, data or people.** The designs and Stage 0 are done: exact values, simulated systems and the power checks. The runs wait for the freeze and for Ren's yes on their usage.

RF proved nine laws of formations that read, each a theorem in the pure core: what choices show of an order (RF1), what readings fix of the unread (RF2), readers reading readers (RF4), a revision that opens a correction (RF6.1), a reading kept by its update (RF3), a prediction read by what it predicts (RF6.3), complying when read (RF7), holding an act for a reading (RF-M.2), and informing and revaluing (RF-M.3). Their home sections are in [03 KNOWING](../../theories/becoming/chapters/03-KNOWING.md) and [05 COLLECTIVES](../../theories/becoming/chapters/05-COLLECTIVES.md#r-readers-reading-readers). No run refutes a theorem. Each test refutes at most a named correspondence or bridge, that a given system, mostly a language model, is the law's model, meets its premise, or chooses as its counts rank, and says what success cannot confirm. TR2 is a measurement: it locates where a cue breaks the chain to acts.

| File | What it is |
|---|---|
| [DESIGN.md](DESIGN.md) | The tests in ten minutes, the tests in an hour, and an index to the rest: usage, what the tests share, what changed in RF's plan and records, candidate core lemmas, provenance |
| [REST-TR1.md](REST-TR1.md), [REST-TR2-TR7.md](REST-TR2-TR7.md), [REST-TR3-TR6.md](REST-TR3-TR6.md), [REST-TR4-TR5.md](REST-TR4-TR5.md), [REST-TR8-TR9.md](REST-TR8-TR9.md) | Each test's full design: exact tables, power check, rivals, protocol, usage, choices left for the freeze, the plan's corrections and references |
| [REVIEW.md](REVIEW.md) | The two independent reviews of the designs in two rounds (five verified lenses and a cross-model reader), every finding and how it was taken |
| `trN.py`, `trN.json` (N = 1 to 9) | Stage 0 for each test: a mirror of the Lean's definitions checked against its evaluated witnesses and by enumeration, the simulated systems and rivals, and the power check; standard library only, deterministic |

To reproduce (Python 3.11, standard library only). Each script writes its JSON next to itself and takes from under a minute to about three minutes on one core; `tr9.py` imports `tr8.py`, so run them from this folder:

```bash
for n in 1 2 3 4 5 6 7 8 9; do python3 -B tr$n.py; done
```
