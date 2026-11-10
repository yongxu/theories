# K4: the cold reader's rounds (AI-written, 10 November 2026)

One reader, Claude Fable, read the entries cold against the records, 07's home sections and the Lean. Round 1 was a full read; rounds 2 and 3 were the same reader on the diff of the fixes. The rounds stopped at the first with no high or medium finding. The reader's own files are kept as written: [round 1](reader-1.md), [round 2](reader-2.md), [round 3](reader-3.md).

| Round | Read | High | Medium | Low | Taken |
|---|---|---:|---:|---:|---|
| 1 | commit `9953e82fe` in full | 1 | 4 | 7 | the high, the four mediums and lows 7–11 (`3fb83fa96`); low 6 (family placement) and low 12 (a commit message's count) not taken |
| 2 | the fix diff `3fb83fa96` | 0 | 1 | 3 | all (`49723955d`) |
| 3 | the fix diff `49723955d` | 0 | 0 | 0 | — |

**What the reader found wrong, kept as failed candidates** ([NOTE.md](NOTE.md), "Kept"):
- Round 1, high: an exit from mutual dependence into the blindness beyond the coupling closure, by `Flow.returning_beyond_coupling`, was vacuous. Under mutual dependence every formation lies within every coupling closure, so the law's hypothesis that something lies beyond can never hold.
- Round 2, medium: the exit that replaced it, from the blindness to mutual dependence, stated a composition of two laws that no home and no record states. The atlas creates no result, so it was dropped too, and the one-line lemma is left as a follow-up.
- Round 1, mediums:
  - a name said "persistence" where the law is about standing late;
  - an open item reversed its study note;
  - an exit was ranked "sufficient" on a law of its destination alone;
  - an edge said a step had no lemma when `persists_of_alive` is that lemma.
