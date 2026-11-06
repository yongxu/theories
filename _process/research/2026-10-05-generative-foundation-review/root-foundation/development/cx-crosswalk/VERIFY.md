<!-- AI-written, 7 November 2026, for checking what the crosswalk's readers flagged in the live account. It adds no result. -->

# Checking the live flags

Readers of the crosswalk, whose job was something else, flagged places where the live account seems false, stale or inconsistent. A flag is a lead, not a finding: several rest on an AI's memory of a source, and a reader saw only part of the page. Check each one at its home, and prepare the correction only if it holds. This is first in the repository's order of work: "what is false or misleading in what a reader is told, where it would change what they believe".

For each flag:

1. **Read the line and its section whole**, and the page it is said to conflict with. Read what is live now: main has moved.
2. **Decide.** `holds`: a reader would believe something false or wider than the home says, or the page contradicts another live page. `no`: the flag is mistaken or the text is fine read in full. `cosmetic`: true, and it would change no belief; leave it. `person`: it turns on a judgment or a source no one here can check, and is listed, not changed. A flag resting only on an AI's memory of a source not stored here is `person` unless the page's own words already show the problem, or the point is widely established and you can say by whom.
3. **Prepare the correction** where it holds. Copy the home's words first and shorten after: a gloss is where qualifiers drop. Keep the page's voice, its language and its standing words. Change the least that makes it true. Never write that the ethics derives from the condition; where the ethics is summarized name both premises. A `Ren's words` passage is not changed. An AI reading keeps its label.
4. **Say where else it stands.** Search by the claim as well as by the words, in fronts, chapters, dossiers and `results/records/*.json`. List restatements that need the same change. Generated pages (`results/records/*.md`, `results/*.md`, `README`s marked generated) are not edited: name the JSON or chapter they come from.
5. **The edition to send.** `git grep -n "<a distinctive phrase>" review-packet-4 -- theories/` says whether the review packet carries the sentence. Report it either way. The packet itself is not edited.

## What you must not do

Run only `grep`, `git grep`, `git show`, reads and short read-only Python. No tests, gates, renders, builds, Lean or `research.py`. Edit nothing but your own output file. Commit nothing. Download nothing.

## The file you write

One JSON object at the path your prompt gives:

```json
{
  "cluster": "name",
  "flags": [{
    "where": "path:line or path#anchor",
    "flag": "the flag, in a line",
    "verdict": "holds | no | cosmetic | person",
    "why": "what you read, and why, in two sentences at most",
    "edits": [{"path": "repo-relative path", "old": "the exact text, unique in the file", "new": "the replacement", "region": "a phrase saying which section"}],
    "also_stands": ["other places, each with path:line and whether edited above"],
    "in_packet": "yes | no, with the phrase searched"
  }]
}
```

`old` must be an exact substring occurring once in the file, so that it can be applied by a script: copy it, and check by a read-only count.

## What you return

Only the short summary your prompt's schema asks for.
