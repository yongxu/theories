<!-- AI-written, 6 November 2026, amended 7 November 2026 after the critic (reads/CRITIC.md) for the repair read (REPAIR.md). It adds no result. -->

# The crosswalk: what each reader does

**The question.** Each earlier theory folder and each domain of thought: what did it claim, in its own terms, and where in the live account did that go? The answer has to be able to say "nowhere" and "the account says otherwise". You are one of three independent reads of one item (a folder or a domain). The design is [the atlas plan](../aa-attractor-atlas/PLAN.md) §3.2 (the correspondence kind), §3.3 (the relations) and §6.4 (the method). Three reads, because in [06 §7.1](../../../../../../theories/becoming/chapters/06-CLASSICAL-TEXTS.md#71-五千六百七十三条判断) a second checker changed 84 of the 88 entries a reviser had kept: two reads are not reliable.

## What is live

The **live account** is `theories/becoming/ONE-PAGE.md`, `THE-THEORY-OF-BECOMING.md`, `chapters/`, `COLLECTIVE-DIRECTION.md`, `FREE-ENERGY-PRINCIPLE.md`, `ONE-ARGUMENT.md`, `review/`, `GLOSSARY.md` and `results/records/`. Not live: `theories/becoming/history/`, `_process/`, `sources/`, `drafts/`, and the earlier folders themselves. A claim found only in those is `history-only`, not `carried`.

## How to search it

- [`record-index.tsv`](record-index.tsv) lists every result: id, status, kind, region, home anchor, title. Grep it first.
- The record pages are `theories/becoming/results/records/<id>.md`, and their JSON has `claim`, `hypotheses`, `does_not_show`, `correspondence`.
- Grep the chapters by the claim's mechanism and by the words the account would use, not only by the source's words: a word search misses a gloss. The account's vocabulary is in `GLOSSARY.md`. After a hit, read the section, and copy what it says with its qualifiers.
- `theories/becoming/results/data/theory-map.json` and `theories/becoming/history/THEORY-MAP-2026-10-08.md` hold readings of the folders dated 8 October, with `related_chapters` that are now retired. They are a dated lead, not evidence: check each against the live text.

## What you must not do

Run only `grep`, reads and `check_entries.py`. No tests, gates, renders, builds, Lean or `research.py`: this machine is under heavy load and other sessions are landing. Edit nothing outside your own output file. Commit nothing. Download nothing: no source text is fetched or stored, and a web search is not needed for this work.

## The file you write

One JSON object at the path your prompt gives, and validate it with `python3 -B <this folder>/check_entries.py <your file>` until it passes.

```json
{
  "group": {
    "id": "relational-self-and-datong",
    "domain": "earlier-folders",
    "title": {"en": "The relational self and 大同"},
    "kind": "theory",
    "summary": {"en": "Two or three sentences: what this folder or domain holds, in its own terms, and where it stands against the account."},
    "read": ["what you read in full"],
    "skimmed": ["what you only skimmed"],
    "searched": ["what you only searched, and for what"],
    "not_mapped": [{"en": "what you found and did not map", "why": "why"}],
    "coverage": null
  },
  "entries": [
    {
      "id": "cx-relational-self-action-centre",
      "name": {"en": "The I as an action-centre of gathered relations"},
      "domain": "earlier-folders",
      "group": "relational-self-and-datong",
      "source": {
        "work": "theories/relational-self-and-datong/README.md",
        "locator": "The theory in one paragraph",
        "basis": "read-in-repo"
      },
      "sense": {"en": "What the source claims, in its own terms and scope. Written before and apart from any reading."},
      "quote": "「我」非关系之外之原点",
      "carried": "carried-in-part",
      "relation": "scope",
      "agreement_of": null,
      "reading": {"en": "The structural reading: which mechanism in the account has this form, between which terms, under which premises. [AI reading]"},
      "targets": [
        {"record": "some-record-id", "anchor": "theories/becoming/chapters/07-SIGNIFICANCE.md#r-some-record-id", "role": "carries", "says": {"en": "What the target states, copied from it with its qualifiers, shortened afterwards."}}
      ],
      "account_adds": {"en": "What the account states that the source does not."},
      "source_adds": {"en": "What the source states that the account does not yet."},
      "absence": null,
      "same_as": null,
      "labels": ["AI reading"]
    }
  ]
}
```

`group.kind` is one of `theory`, `design`, `method`, `provenance`, `exploration`, `domain`. `group.coverage` is for domains only (below). `group.summary` says what the item holds and where it stands, in words: no counts of entries by `carried` or `relation`, which come from the entries, so that a summary cannot disagree with them.

### `carried`: what happened to it

| Value | Meaning | Requires |
|---|---|---|
| `carried` | The live account states this claim's content at the same scope. | `relation`, `targets` |
| `carried-in-part` | The live account itself states part of it: you can point at the sentence whose words state that part. A law of like form that you read onto the source is not this; it is `fresh-reading`. | `relation`, `targets`, and `source_adds` saying which part is not stated |
| `changed` | The account takes up the topic and says something else, or withdrew the claim. | `relation` (usually `divergence` or `scope`), `targets`; say why where the account says why |
| `history-only` | It stands only in `history/`, a study or `sources/`, not in the live account. | `absence`, and name where it does stand in `source_adds` or `reading`. A relation only if a structural reading is also proposed, saying it is one; any targets are neighbours |
| `not-carried` | You did not find it anywhere in the live account. | `absence`; `relation` null; `targets` empty |
| `fresh-reading` | For folders and domains alike: the account does not state this connection; it is proposed here, by a reader of this crosswalk. | `relation`, `targets`; for a domain `basis` is usually `ai-knowledge` |

`absence` is `{"searched": ["terms and places you searched"], "read": ["sections you actually read"]}`. An absence is a claim and needs this evidence. Searched is not read, and the file says which you did.

### `relation`: from [06's three relations](../../../../../../theories/becoming/chapters/06-CLASSICAL-TEXTS.md#three-relations), with contrary reading as a fourth

- `agreement` (相合): what the source says has the form of a checked law in the account. The law does not depend on the source, and the law does not exhaust the source's meaning. Every agreement says what it is agreement with in `agreement_of`: `law` (a carrying target is a checked theorem and the source's mechanism has its form), `thesis-or-method` (the targets are a thesis, a method section, a Reading or a front: real, but not 06's 相合) or `reading` (a law is cited, but the join is a reader's, or the reading descends from this source or a sibling, which then says "by descent"). A reading that says the form fails is not agreement.
- `scope` (定域): the source states it universally, and the account gives where exactly it holds, correcting the universal form. Scope is not denial.
- `divergence` (相分): the source asserts what the account does not. That can be a non-relational layer, something unconditional that the account gives only under a condition (such as calling a direction good), or what a checked law denies under its premises. Divergence does not say the source is wrong.
- `contrary-reading` (反读): the source argues against the form the account uses (as parts of 中论 argue against 相续), and is kept as the strongest test.

Where the source states a claim universally and the target conditions it, the relation is `scope`, in every item.

### A target's `role`, and `part`

- `carries`: the entry's connection rests on this target. It is what the reading says has the source's form, or what the source is read against.
- `neighbour`: near it, cited for comparison or to prevent a confusion; the connection does not rest on it.
- `limit`: cited for what it says is not shown or where the account stops.

Only `carries` counts in any total of what connects to what. `part` names which statement of a section is meant (a reading's D-number or a theorem's `r-` anchor); it is required for 07's `#alignment-without-premise`, which holds at least eight separate statements, and welcome wherever a section holds several.

### `same_as`

Null, or a list of ids of entries in other items that state the same claim of the same source, so that a total can count it once.

### `source.basis`

- `read-in-repo`: the source's text is in this repository and you read it. `work` is its repository path. Any `quote` must be verbatim from that file, and the checker compares it.
- `ai-knowledge`: known to you, not in the repository, not checked against the text. `work` is author and title; `locator` is the chapter, verse or passage as you recall it, or `"locator unverified"` if you are not sure. `quote` must be null, since there is no stored text to check it against. Paraphrase and never fabricate a citation; a locator you are unsure of is marked unverified, and an uncertain attribution is said to be uncertain in `sense`.

### Domains: `group.coverage`

```json
"coverage": {
  "present": [{"what": "what the account already holds", "where": "path#anchor or path", "extent": "how much, with counts you read off the file"}],
  "absent": [{"en": "what is not there", "searched": ["terms"]}]
}
```

Nothing already mapped is re-mapped: the 248 passages, the 1,300 entries of 《中华思想脉络》, the 90 passages of the Changes and the dossiers stay in their own files. Report their extent under `present`. New entries go to what is not yet reached.

## How to read

1. **The source's own sense first**, then the structural reading, then the relation. Same words are not the same reference, nor a line of descent (同语不等于同指，也不等于相承). A shared word is not a correspondence: name the mechanism, or there is no entry.
2. **Divergence is kept as prominently as agreement.** A map of only agreements is a false map. Look for what the account would not say, and for what the source would refuse in the account. If an item shows no divergence at all, say in `group.summary` that you looked.
3. **Never overstate a target.** Copy the home's words first and shorten after: a gloss is where qualifiers and standings drop. Say if it is proved on a model, conjectured, argued or a reading. "Theorem" says exactly what the Lean proves, and not more. Prefer a record and its home anchor. Cite a declaration only where it matters, since a rebuild in progress is merging helper lemmas (grammar concepts keep their names).
4. **Ethics.** Where a target is in the ethics, name both premises, the continuation condition for scope and C for order, neither asserted and their warrant open. Never write that the ethics derives from the condition, or that a law says a loss is a harm. No dynamic is good or bad here. "Better" is a relation formed by what compares, so say what it reads.
5. **No tradition is spoken for.** Do not write that a tradition "is" the account or the reverse, or that structural agreement is agreement in meaning. For Indigenous and African thought especially, keep to published work you can name and say how thin your knowledge is.
6. **Reduce nothing to fit.** What a folder holds that is not a claim (a design, a product, a practice, provenance) goes in `group.not_mapped` with why, or as `not-carried` if it is a claim the account simply does not take up. The account does not have to absorb everything, and "not carried" is not a defect by itself.

Each item gets as many entries as its distinct claims need: usually 8 to 20 for a folder and 6 to 15 for a domain. Entry ids start `cx-`, are lowercase with hyphens, and are unique across the whole crosswalk, so start them with a short form of your item's name. Keep each text field under about 80 words.

## The three reads

- **Map.** Read the source and write the entries.
- **Revise.** Do not trust the mapper. Read the source and the targets yourself. Correct, add what the mapper missed, drop what does not hold. Add a top-level `"changes": [{"id": "…", "what": "kept|changed|added|dropped", "why": "…"}]` covering every entry.
- **Check.** Try to refute every entry, by default assuming it is wrong until you have read both sides. Hunt for: a word match standing in for a structure; a `not-carried` that the account does carry under another name; a `carried` whose target says something narrower or different; a dropped qualifier or an inflated standing; a claim the source cares about most and the file omits; a missing divergence. Write the corrected file with its own `"changes"`.
- **Repair.** After the critic ([reads/CRITIC.md](reads/CRITIC.md)): one read per item by a new reader, by [REPAIR.md](REPAIR.md). Then a comparison across items by shared target, and a second critic on a random sample.

## What you return

Only the short summary your prompt's schema asks for. The entries go in the file, not in your reply.
