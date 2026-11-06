<!-- AI-written, 7 November 2026, for the crosswalk's second critic. It adds no result. -->

# The second critic: a random sample

The [first critic](reads/CRITIC.md) aimed its sample at suspects, so its 15 failures of 59 are not an error rate. After the repair and the comparison, this read draws a random sample, stratified by what an entry claims, so that what it finds is an estimate of how often each label is wrong. `sample.py` draws it with a fixed seed and writes `reads/sample.json`; the seed and the strata are in that file, so anyone can draw it again.

## What you do with each sampled entry

Read [BRIEF.md](BRIEF.md) as amended, then for each entry in your share of the sample:

1. **The source side.** For `read-in-repo`, open the cited work at the locator and read enough to judge the `sense`. For `ai-knowledge`, judge against what you know, and say that this is memory against memory.
2. **The account side.** Open every target whose `role` is `carries`, at its home, and read the section the anchor names. Is the `says` faithful, with its qualifiers and standing?
3. **The labels.** Does `carried` hold (for `carried-in-part`, is there a sentence of the account stating part of the claim)? Does `relation` hold (for `scope`, does the source state it universally and the target condition it)? For agreement, does `agreement_of` hold (`law` only if a carrying target is a checked theorem with the source's mechanism in its form)? For `not-carried`, search the live account yourself by mechanism and by words.
4. **Verdict.** `holds`, `label` (the reading stands and a label or a target role is wrong; say which and to what), or `fails` (the reading itself is wrong, or a word match stands in for a structure). Give the reason in two sentences at most.

## What you must not do

Run only `grep`, reads, `digest.py` and short read-only Python. No tests, gates, renders, builds, Lean or `research.py`. Edit nothing but your own output file. Commit nothing. Download nothing.

## The file you write

```json
{"share": "your share's name", "verdicts": [{"id": "cx-…", "verdict": "holds | label | fails", "fix": {"field": "value"} , "why": "…"}], "read": ["homes and files you read"], "live_flags": []}
```

`fix` is null for `holds`. It uses the fields of `apply_rulings.py`'s `set`.

## What you return

Only the short summary your prompt's schema asks for.
