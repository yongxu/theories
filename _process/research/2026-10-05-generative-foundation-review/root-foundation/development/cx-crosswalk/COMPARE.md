<!-- AI-written, 7 November 2026, for the crosswalk's comparison across items. It adds no result. -->

# The comparison across items

Each item's readers saw few of the sibling items, and no pass compared them. The [critic](reads/CRITIC.md) found the same claim with different verdicts in different items (H3), and the [repair](REPAIR.md) settled the ones it named. You read one cluster across all 28 items, by the targets its entries share or by the claim itself, and make like claims get one verdict.

Read [BRIEF.md](BRIEF.md) for the vocabularies, then read the target's home, then the entries.

## How to see the entries

`python3 -B digest.py --stage 4-repair --target <record-or-anchor-substring>[,...]` prints every entry citing the target, with its item, labels, the target's role, and the entry's sense and reading. `--ids a,b,c` prints the named entries the same way. `--stage 4-repair` alone prints one line per entry. The full entries are in `reads/<item>.4-repair.json`.

## What to compare

1. **Like claims, one verdict.** Group the entries that state the same or a like claim. Compare `carried`, `relation`, `agreement_of` and the target's `role`. If two like claims have different labels and nothing in their sources or in what they are read against justifies it, rule one verdict. If the difference is real, because the sources say different things, leave it, and say so in `clusters` in a line.
2. **Scope.** Where the source states it universally and the target conditions it, the relation is `scope`, in every item.
3. **Agreement.** Does the source's mechanism have the law's form, with the law's subject and premises? `law` only then. A reading made of this source or a sibling cannot give `law`: it is `reading`, "by descent". 08 on law: a law admitting every outcome explains nothing, and a near-definitional law read onto many sources explains little. Say so where it applies.
4. **`carries`.** Does the connection rest on this target, or is it a hub the entry reaches for? A general section or a stance is a `neighbour` unless the entry's mechanism is what it states.
5. **`carried`.** `carried-in-part` needs a sentence of the account stating part of this claim; a reader's join is `fresh-reading`. Check it where a cluster shows one entry claiming what its siblings call a join.

You are not asked to re-read the sources. Do not rewrite readings except where a changed label needs it. Keep divergence as prominent as agreement. Every reading stays labelled an AI reading.

## What you must not do

Run only `grep`, reads, `digest.py`, and short read-only Python. No tests, gates, renders, builds, Lean or `research.py`. Edit nothing but your own output file, and do not edit `reads/<item>.4-repair.json`. Commit nothing. Download nothing.

## The file you write

One JSON object at the path your prompt gives:

```json
{
  "key": "your cluster's name",
  "read": ["the homes and files you read"],
  "clusters": [{"claim": "…", "ids": ["cx-…"], "verdict": "same | ruled | differ-real", "why": "one line"}],
  "rulings": [{"id": "cx-…", "set": {"relation": "scope", "agreement_of": null}, "roles": [{"target": "record-id-or-anchor", "role": "neighbour"}], "why": "one line naming the sibling or the text"}],
  "live_flags": [{"where": "path#anchor or path:line", "what": "…"}]
}
```

`set` may hold `carried`, `relation`, `agreement_of`, `same_as`, `reading`, `source_adds`, `account_adds` and `absence`, with text fields as `{"en": "…"}`. Set `relation` to something other than `agreement` together with `"agreement_of": null`; to `agreement` together with an `agreement_of`. `not-carried` needs `"relation": null`, `"agreement_of": null`, `"targets": []` and `absence`. A ruling that changes nothing is not a ruling. `roles` changes a target's role by its `record` or, if it has none, its `anchor`.

Another reader may rule on the same entry from another cluster. If you know the entry belongs mainly to another cluster, say so in `why`, and rule only where you have compared it.

## What you return

Only the short summary your prompt's schema asks for.
