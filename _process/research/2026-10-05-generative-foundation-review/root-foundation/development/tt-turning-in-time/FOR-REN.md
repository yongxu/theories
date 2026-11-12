*AI-written, 13 November 2026, for Ren: what now stands after board item TT, and what waits for you. Ten minutes. Read [the one page of the centre](TURNING-IN-TIME.md) first ([中文](TURNING-IN-TIME.zh.md)); this page is about the work.*

# For Ren, after TT

## What now stands

**The centre, in the root's words.** A line that stays alike in a respect ends in one of two ways: where the net ends (nothing follows), or while the net goes on (something follows, no longer alike). The first is being used up as it was. The second is a turn. The root already said this and had an example, an organism's line ending at old age. What it could not say is which of the two happens, because that takes an amount.

**What was added.** Three small things. No existing name was changed and no existing module was rewritten.

1. **A tie in the root.** It had two names for one gap and no theorem relating them. Seven short laws now do.
2. **A law's step that has a next only while it can go on.** Before this, a law's step (`Law.step`) always had a next, and a step cut short appeared only inside one witness, so no general law let a line on a law end where the net ends.
3. **One model: a way of going on and a level it needs.** On it:
   - the way stays as it was at every level except the marked ones;
   - with no marked level that still meets the need, the line runs the level down and ends where the net ends, the same from every level;
   - under the regime's premises listed in 02 §11, it never ends exactly where the level is first marked while the need is still met and the level that step leaves is enough under the new use;
   - the earlier lock's courses are courses of this model where nothing is needed, and they go on for ever; where the going on needs a level and no marked level is reached while the need is met, a locked start ends still locked, where the net ends.

All of it passed the core run with no axioms, and is on main as content tip `65543cc60`: two core runs, the render and the landing gate passed; the full gate is left for the push; nothing is pushed. Home: [02 §11](../../../../../../theories/becoming/chapters/02-MAP.md#turning-in-time).

## What is given, not shown

- The marked levels, the need and the way it turns into are premises. How what brings a level's difference to a way comes to stand is still the heaviest hole.
- No test trains a system. Several near papers were read only in part, one from its abstract, so nothing is called new ([near work](NEAR-WORK.md)).

## What I got wrong on the way

- My first module restated laws the root already had: I had not read the root far enough. It is kept in `held/`.
- One theorem I designed was true of every relation and said nothing. Removed.
- I wrote that no guarded law existed in the package. One did; it is now tied to the new one.
- I wrote log times from memory and they ran ahead of the clock.

## Names

I changed one name in the new work that read as a doer. I did not rename the older lock modules. About a thousand files cite those names, and names I choose at night would be my vocabulary, not yours. For the first four rows below, what the old name is in the root's terms is a theorem. The last row is a reading.

| Old name | What it is | Proved by |
|---|---|---|
| `GoAlike` | going alike (同行) at each move, for sameness of the description | `goAlikeUnder_iff_alike` |
| `Unread` | the loop's class goes alike along every schedule of reading steps, and is constant (有常) | `identifiesAlike_iff_unread`, `constant_iff_unread` |
| `Locked` configurations | a region closed under the step (闭) | `TurningInTime.locked_closed` |
| the window `[N, K)` | marked levels | `TurningInTime.window_alone_outside` |
| a lock outliving its loss | read beside: a locked line that ends where the net ends | `TurningInTime.locked_ends_with_net`; a reading of the two side by side, neither derived from the other, and in the lock's own models no line ends where the net ends |

Another session measured the word "law" on the reading path the same night and will bring you its own page. As it reports, and I have not checked: chapter 08 and the glossary define a "law of the theory" as a proved statement on purpose, and in one chapter piece 14 of 62 bare uses mean a proved statement while 43 mean the Lean's `Law`, a model's step. It changed nothing in the chapters.

If you want new names for the old ones, these are the words I would try on you: *way* for rule, *level* for what is used up, *marked* for read, *kept as it was* for locked.

## What waits for you

1. **The statement.** The one page is my candidate. Your words decide.
2. **AGENTS.md's second paragraph.** Proposed wording in `drafts/FOR-RENS-READ.md`. Not applied.
3. **The one page of the theory.** I did not edit it. If the candidate reads right, its statement can replace the sentence beginning "Its centre:" there, and one table row can point to 02 §11.
4. **A live set of about ten pages.** Candidates, each with a reason, in `map/texts.md`. Nothing is marked archive.
5. **The push.** Main is ahead of the public remote.
6. **One paper** behind a browser check that I may not pass ("Self-Sealing Reward Models", on OpenReview).

## Where things are

- Lean: `Becoming/GrammarPath.lean` (seven laws added), `Becoming/GuardedStep.lean`, `Becoming/TurningInTime.lean`.
- This folder: the plan and its log (`drafts/PLAN.md`), the design (`DESIGN.md`, `DESIGN-R2.md`), the maps of what exists (`map/`), every reader's report (`readers/`, in short in `READER.md`), the near work, the first attempt (`held/`).
