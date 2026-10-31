# Reading budgets: each layer sized for a person

*AI-written, 31 October 2026, from AJ4 to OU's owner, for the release gate's item 6 ([WHAT-REMAINS](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md#the-release-gate-30-october-2026)), and [adopted](#adopted) with four amendments. Not reviewed by a person. Figures from [the kit's measure](kit/measure_layers.py) on main at `1ec20513d`; the worked example's on main at `1721c70ef`, after RR2 landed, and on branch `aj4-human` merged with it. About ten minutes to read.*

## Why

Every landing and review adds to the layers, and none keeps a size: the one page takes 16 to 21 minutes, the overview nearly two hours, and the README describes its reading layers about 12,800 words in. A person who cannot finish a layer judges it unread or puts it down. Much of the length carries checks a machine can run (quotations, links, Lean names, a reading against the records), so the machine runs them. A person then gets a part to finish in ten minutes, a path of an hour, and the rest if they want it. Asked for on 31 October ([source](../../../../../../sources/15-codex-theory-conversations/2026-10-31-ready-for-human-readers.md)), for that reason.

## Item 6, proposed

> 6. **The front pages current, and sized so a person can finish them.** The one page's counts are brought up to date (on `160a0f780` it says 481 registered results, and RESULTS registers 498). The twenty-first review's remaining §6 fixes go in the same pass. Each layer in [the reading budgets](../aj4-alignment-readers/READING-BUDGETS.md#the-budgets) states its reading time where it begins and is within its budget, by [the kit's measure](../aj4-alignment-readers/kit/measure_layers.py).

Its last sentence is new.

## How a time is measured

- **Counted:** visible prose, not code, Lean, comments, link targets, anchors or `Quote [path]:` prefixes.
- **Rate:** 100 to 130 words a minute, about half the 238 that Brysbaert (2019, *Journal of Memory and Language* 109, 104047) found for silent reading of English non-fiction, since these layers are read to be judged. For Chinese, with no norm found, 200 to 260 characters a minute, a working figure.
- **A budget** is in words, a Chinese character counting half: a screen is 150, ten minutes 1,100 (8.5 to 11 minutes), an hour 6,000 (46 to 60). "Where it begins" means within the first 150 words.
- **A person's time decides:** when a reader reports one, it replaces the estimate.

<a id="the-budgets"></a>
## The budgets

| Layer | On main today | Budget | What brings it within | Who |
|---|---|---|---|---|
| README's first screen (generated) | 36 words, no time; then the opening, in the first person (19 to 25 minutes), and its notes | A screen naming each layer with its time | A generated block ([below](#the-readmes-first-screen)), times computed at render; the opening untouched | RA's line |
| The opening's notes (AI-written, read one at a time) | 24 notes, 10,354 words; 15 over 300, the largest 1,094 | Three minutes each | Standing and link kept, detail to the section cited | the coordinator routes |
| One page (and Chinese) | 2,143 words, one block (16.5 to 21.5 minutes); Chinese 14 to 18 minutes | Ten minutes | What it claims, the ethics' two premises with their roles, where the evidence is, what is not done | the coordinator routes |
| Overview (and Chinese) | 13,429 words (103.5 to 134.5 minutes), §7 alone 2,604; Chinese 86 to 112 minutes | An hour | Half of each section, detail to the chapters it links; §10, what is not shown, whole | the coordinator routes |
| Packet cover (and Chinese) | 862 words (7 to 9 minutes), within; it gives each dossier's time and hour's path | Ten minutes | Its own time at its top | RP's owner |
| Each dossier's front, to its first item or the end of its labelled ten minutes | Within: classical texts, Buddhist thought, philosophy (8 to 11 minutes). Over: logic (13.5 to 17.5), alignment on main (24 to 31) | Ten minutes, with the whole's time and an hour's path | Logic: a third of its front moved later. Alignment: [below](#the-worked-example-the-alignment-dossier) | each dossier's owner |
| Failure-mode map (a study AJ4 cites) | 8,792 words; its table (§2, 574 words) comes after 1,150 words | Its first part within ten minutes; each row readable alone | A ten-minute section first, on its holder's branch | the map's holder |

Whole dossiers: classical texts 64 to 83 minutes, Buddhist thought 67 to 88, logic 89 to 115 (its four hours include 251 lines of Lean), philosophy 94 to 122, alignment 102 to 132 in the new edition. The cover's times are these or longer. Chapters, records and studies have no budget.

<a id="the-readmes-first-screen"></a>
## The README's first screen

Proposed navigation for the template (AI-written; links relative to this page):

> **Reading paths.** In ten minutes: [one page](../../../../../../theories/becoming/ONE-PAGE.md) ([中文](../../../../../../theories/becoming/ONE-PAGE.zh.md)). In an hour: [the overview](../../../../../../theories/becoming/THE-THEORY-OF-BECOMING.md) ([中文](../../../../../../theories/becoming/THE-THEORY-OF-BECOMING.zh.md)). To review one part: [the review packet](../../../../../../theories/becoming/review/README.md), where each dossier gives its time. The opening below, in the first person, takes about twenty minutes; its notes, for looking up, say how far each sentence is proved.

Until the layers are within budget, the template states their measured times.

## Never cut, cut first

- **Never cut:**
  - a deciding hypothesis;
  - the ethics' two premises and their roles where it is summarized (the condition for scope, C for order);
  - a failure as it fell;
  - a frozen rule's caveat;
  - a post hoc label;
  - an AI label on a reading;
  - what is not claimed.
- **Cut first:**
  - repetition across layers;
  - lists of lemmas;
  - chains of credit, keeping the record's sentence on what is new;
  - the history of landings and reviews, moved whole by `research.py move`.
- **One text, not two:** a summary copying its source drifts, so it is retired by move, as AJ4's draft page was.
- **The budget stays:** a landing that would exceed it moves detail down a layer (chapter, record, kit), and the measure is rerun.

## The worked example: the alignment dossier

| | On main | New edition |
|---|---|---|
| Whole | 13,868 words, 106.7 to 138.7 minutes | 14,076 words, 108.3 to 140.8 ("about two hours"); longer than on main, where RR2's result is one sentence, since here it is stated with its hypothesis, label, reading and limit |
| Before the first item | 3,481 words, 26.8 to 34.8 minutes | The dossier in ten minutes, 1,100 words with the title (8.5 to 11 minutes), then the tests, 358 words (2.8 to 3.6) |
| An hour's path | none | Those ten minutes, the tests and seven items, 5,357 words, 41.2 to 53.6 minutes |
| A separate "one page" | 5,503 words, called ten minutes | Retired to the kit's history |

Provenance moved whole to [the kit's README](README.md#the-edition-of-31-october-2026-sized-for-a-person), and the box on reading and revision became item A-20. A machine checked every quotation, link and Lean name: no faults. An independent reader then found 42 problems, 16 of them errors, mostly hypotheses the cut had dropped, all taken ([the kit](README.md#the-fourth-pass-taken)). Hypotheses are never cut, so the tests and the questions for the whole left the front, which stays within ten minutes.

## Adopted

OU's owner adopted it on 31 October 2026 with four amendments. The adopted text is [WHAT-REMAINS's](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md#the-release-gates-item-6-sized-for-a-person-31-october-2026), and where this page differs, that text governs.
