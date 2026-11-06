<!-- AI-written, 7 November 2026, for the crosswalk's repair read. It adds no result. -->

# The repair read

The critic ([reads/CRITIC.md](reads/CRITIC.md)) found that the readings are good and the labels overstate them: `carried-in-part` mixes what the account states with joins a reader proposed, `agreement` goes beyond the form of a checked law, like claims get different verdicts in different items, some entries are word matches, and one summary contradicts its entries. A reader who takes the totals would believe the account states more, and has laws for more, than the entries themselves say. You repair one item so that the labels say what the readings say.

You are not asked to re-read the sources or redo the mapping. The check read has tested the readings, and the critic confirmed that the quotations of targets hold. Change a reading's words only where a label change or a named fix needs it. Open a target's home where a verdict turns on it, and for every entry the critic names.

## Rules

Read [BRIEF.md](BRIEF.md) as amended, then this, then the critic's report. Run only `grep`, reads, `check_entries.py`, `digest.py`, and short Python that reads files and writes your own output file (start from a copy of your check file and patch it). No tests, gates, renders, builds, Lean or `research.py`; this machine is under heavy load. Edit nothing outside your own output file. Commit nothing. Download nothing.

Keep every entry's `id`; they are referenced across items. Add an entry only where the critic or this page names one, or where your pass finds a claim the file omits. Drop an entry only with a reason in `changes`.

## What you do to every entry

1. **`carried`.** For each `carried-in-part`: can you point at a sentence of the account whose words state part of this claim? If so it stays, and `source_adds` says what is not stated, leading with what the source cares about most. If what connects them is a reader's reading (the law has a like form, and no live text draws the link), it is `fresh-reading`. A self-declared join in the reading ("is mine", "my reading", "my composition", "no live text") is a signal to look, and the checker warns on it. It may be one link in an otherwise carried claim, and then it stays. Where the join is the whole connection, it moves. If no form exists at all, it is `not-carried`, with `relation` null, `targets` empty and `absence` filled, and the proposal may stay in `reading`, marked a proposal.
2. **`agreement_of`.** On every agreement, by BRIEF's definition. `law` only where a carrying target is a checked theorem and the source's mechanism has its form. `thesis-or-method` where the targets are only a thesis, a method section, a Reading or a front. `reading` where the join is a reader's, or where the reading descends from this source or a sibling (07's D68 of the imperial examination "as read in the meta-attractor line", 02's D26 and D67 reading the corpus's meta-attractor and "selecting the selectors"): a folder cannot gain independent agreement from a reading made of itself, so the entry says "by descent". Laws in Lean do not descend. If the reading says the form fails ("same words, not the same reference", "the mechanism parts", "not a share"), it is not agreement: use `divergence`, or `scope` if the source states it universally.
3. **`scope` before `agreement`.** Where the source states it universally and the target conditions it, the relation is `scope`, in every item.
4. **`role` on every target.** `carries`, `neighbour` or `limit`, by BRIEF. A target that adds nothing to the connection goes; one whose `says` only reports that the account does not state the thing goes to `source_adds`, unless the limit is itself a live statement worth citing (then `limit`). Thin to the targets that do the work: an entry with six or more targets almost always has neighbours.
5. **`part`.** Required on 07's `#alignment-without-premise`: name the statement (D25, D26, D45, D65, D68, or the theorem's `r-` anchor). The sentence "Alignment is first what each one's selections reach…" is a general stance and not a mechanism: drop it where it is not the entry's mechanism. Do the same for other sections holding several statements where it matters (08's `#one-relational-unfolding`, 02's `#t7`, 05's `#markets`).
6. **The ethics.** Any entry with a target in the ethics (T8, `#scope-and-order`, `#condition`, the widening law) names both premises, the continuation condition for scope and C for order, neither asserted and their warrant open; or it points to the narrower anchor actually meant. Never write that the ethics derives from the condition.
7. **Quotation marks.** English in quotes for a Chinese page reads as verbatim. Quote the Chinese, or drop the marks (L2).
8. **`same_as`.** Null unless the same claim of the same source stands in another item. Known: Sen's intersection, capability and Paretian liberal (`economics-politics-sociology`, `modern-philosophy`); Goodhart (`economics-politics-sociology`, `psychology-alignment-logic`); Ibn Khaldun (`abrahamic-islamic`, `economics-politics-sociology`). `digest.py` and grep find the sibling's ids; ids do not change in this pass.

## The group

- `summary`: what the item holds and where it stands, in words, with no counts by `carried` or `relation`, and nothing the entries now contradict (for example "two agreements in form only", or "25 agreement"). If there is no agreement of `law` in the item, or no divergence, saying so is welcome.
- `read`, `skimmed`, `searched`: what this file rests on, with no trace of attempts or runs (L6). Say what the file rests on as a whole, and keep every disclosure of what was only searched or not read.
- `not_mapped`: remove anything your pass has now mapped.

## The file's other top-level fields

- `changes`: `[{"id", "what": "kept|changed|added|dropped", "why"}]`, covering every entry, against the check file. For `kept`, `why` may be empty. Where you decline a ruling or a critic's fix, `why` starts `DISPUTE:` and says what you read.
- `live_flags`: `[{"where": "path#anchor or path:line", "what": "…"}]`: places where the live account seems false, stale or inconsistent, as found by any read of this item (look in `group.not_mapped`, and in your own reading). They are for the coordinator, who checks each and fixes or lists it. Empty if none.

## Rulings across items

Like claims get one verdict. The coordinator rules as below, on the critic's comparison. Apply each one for your item; if the text in front of you shows it false, say `DISPUTE:` in `changes`.

| Claim | Ruling |
|---|---|
| Believed survival pressure | `cx-asc-survival-belief` to `not-carried`, as `cx-drives-survival-meta-attractor` and `cx-ma-survival-belief` are; set-point forms stay in `reading`, marked a proposal |
| Commons or collar | `cx-fork-commons-or-collar` to `not-carried`, as `cx-kpso-abundance-commons-or-collar` is; "ownership is no variable" stays in `reading` |
| Do not use AI to compete | `cx-asc-pragmatic-minimum`, `cx-kpso-stop-using-ai-to-compete`, `cx-fork-one-rule`, `cx-wamo-ai-out-of-the-game`, `cx-rsd-ai-not-for-struggle`, `cx-zhishan-do-not-fight-for-us`: all `changed`/`divergence`, with `alignment-direction-under-widening` and COLLECTIVE-DIRECTION §8 as carrying targets, as zhishan has it: the account takes up the topic and gives only a conditional direction. Each says so in its own terms |
| The guardian test | `cx-zhishan-guardian-test` to `scope`, as `cx-ma-guardian-test` is |
| A counter-rule becoming the capture it opposed | `cx-kpso-governance-paradox` and `cx-drives-virtue-does-not-self-install` to `scope`, as `cx-ma-anti-attractor` and `cx-drives-confucian-engineering` are; `cx-rsd-kernel-degenerations` to `not-carried` |
| Reform absorbed | `cx-econ-acemoglu-persistence` to `scope`, as `cx-ma-partial-reform` is; substitution of power in `source_adds` |
| Practical and epistemic closure | `cx-asc-closure-of-correction` to `scope`, as `cx-ma-epistemic-closure` is |
| Open ontology | `cx-sty-open-ontology-define-kinds` to `scope`, as `cx-ctxrt-open-ontology-worlds` is |
| Obedient assistant in a race | `cx-zhishan-two-body-problem` to `agreement`, as `cx-kpso-game-between-principals` is, each with `agreement_of` by its targets; `cx-kpso-game-between-principals` adds `several-optimizers-drain-by-their-joint-capacity` |
| AI raises the gain | `cx-kpso-ai-raises-the-gain` to `scope`, as `cx-wamo-amplifier` is |
| Hysteresis and rate-induced tipping | `cx-dpc-hysteresis` and `cx-dpc-rate-tipping` to `not-carried`, with the compositions kept in `reading` as proposals; `cx-dpc-hopf-cycles`, `cx-dpc-noise-tipping`, `cx-dpc-transcritical`, `cx-dpc-chaos` and `cx-dpc-dependence-cascades` re-read by point 1 |
| Multipolar traps | `psychology-alignment-logic` adds `cx-pal-multipolar-traps` (the field's own statement), removes "cap" from `not_mapped`, and adds Hendrycks's and Christiano's claims where they are distinct |

Then apply the critic's H4 table, H1's named list and M2, M3, M5, L2, L3 and L5 for the entries in your item. Where H4 gives a choice ("`not-carried`, or `changed`…"), take the one the reading supports.

## What you return

Only the short summary your prompt's schema asks for.
