*TM's prototype of the correction ledger and the signifier layer (AI-written, Claude Opus 5.5, 10 November 2026), on Ren's word "接着做". It is a proposal to the atlas (AA) for its step 5, the wisdom matrix and Chinese names. AA agreed on 10 November 2026 that TM prototypes here and leaves `theories/becoming/results/atlas/entries/` as it is. Nothing here is a result.*

# The correction ledger and the signifiers: a prototype for AA

The design is in TM's joint reading, [§三](../readings/04-joint-reading.md) for the ledger and [§四](../readings/04-joint-reading.md) for the signifiers. This folder builds both from data the account already holds, so that AA can see the shapes on real entries before folding them into the atlas.

## Files

- `build.py` writes the four files below and reads only the account's data. `python3 -B build.py --check` exits 1 if a written file would change.
- `corrections.json` is the ledger: one entry per change, with its direction, source, kind of change, disposition, what was corrected, and the records that answered it. Statuses are read from the records, never typed.
- `LEDGER.md` is generated from it in three columns:
  - traditions moved the map;
  - the map scoped a tradition's universal form;
  - blanks a tradition named that no law answers.
- `signifiers.json` holds the signifiers in three kinds. The six Chinese names the atlas holds today are reclassified, and 矛盾 is a worked example of one term pointing at several nodes.
- `SIGNIFIERS.md` is generated from it.

## The ledger's entries

| Field | Values |
|---|---|
| `direction` | `tradition→map`, `map→tradition` |
| `source` | the corpus, the entry, the tradition, the work and locator, the first fragment; `text_read`: `read-in-repo`, `external-read`, `secondary`, `ai-knowledge` |
| `change` | `law`, `premise`, `scope`, `scope-note`, `blank`, `test` (a forbidden case named, no design), `wording` |
| `disposition` | `law-added`, `law-found` (the map already had the law), `model-extended`, `definition-revised`, `source-reading-narrowed`, `mapping-rejected`, `outside-scope`, `still-open` |
| `corrected` | `map`; `translation` (our reading of the source); `source-universal` (the source admits the domain); `divergence`; `none` |
| `result` | records (and, once AA's premises are entries, premise ids such as `closedcapture-unread`), with their statuses read from the records |
| `item`, `date`, `by` | the board item, the day, who wrote it (AI or a person's initials; no names on fronts) |

The second column is a view of the crosswalk's `scope` entries, not new data entry. Every crosswalk entry already carries its relation and its basis. A scope corrects the unrestricted reading of a source, and the source itself only where it admits the domain (joint reading §三, astra's point).

## The signifiers' entries

| Field | Values |
|---|---|
| `node` | `dynamic:<id>`, `record:<id>`, `law:<declaration>`, `premise:<id>`, or a list of them where one term points at several nodes |
| `kind` | `coined` (a name the map gives, defined by the Lean or the dynamic), `tradition` (a term a tradition uses, with `relation` and `residue`), `statement` (經, 說 or 證, at the record) |
| `lang` | BCP 47: `lzh` for 文言, `zh-Hans` and `zh-Hant` for modern Chinese, `en`, and others as terms need them; the bare `zh` is retired |
| `status` | `named`, `proposed`, `未立名` (with `reason`) |
| `anchor`, `basis`, `text_read`, `was` | what defines it, where it comes from, whether its text was read, and its old key |

AA could take these in three steps:
1. Copy `signifiers.json` into `entries/` as it stands.
2. Generate `dynamics.json`'s `name` from the coined names, by language.
3. Give records an `asked_by` back-link generated from the ledger's `result.records`.

## What building it found

- **76 gap notes in the 中华脉络, as 06 §7.2 says.**
  - 61 were answered by a law added to the map.
  - One, 《老子》 七十九章 (`lao-79-he-da-yuan`), was answered by laws the map already had. Its note says 现有之律, and its record is where-two-courses-rejoin.
  - 14 are scope notes that sought no law.

  06 §7.2's "62 个条目改读新律" (62 entries re-read as new laws) counts that one with the new laws. That wording is for 06's owner.
- **Every gap answered by a law has a recorded-checked record.** The builder found none without one.
- **The six Chinese names on the atlas's dynamics are of four kinds.**
  - 退化 and 生成、守、退化 are grammar names, defined in `GrammarMap.lean`, so they become coined `lzh` names with Lean anchors.
  - 元吸引子 is a modern coinage (`zh-Hans`). Its 文言 name is 未立名.
  - 无明 is a Buddhist term, not a coined name. It reads onto locked seeking as scope, and against 《起信论》's 无明 it diverges (06 §十一). Locked seeking's 文言 name is 未立名.
  - 偏蔽，復通 and 消息之律 are proposed 文言 coinages. Their quotations are not yet checked against the stored texts.
- **The second column holds 371 scope entries in 28 groups.** All 297 in the earlier folders' groups were read in the repository. In the domains' groups, 69 of 74 rest on AI knowledge; the other five, three Chinese classical and two Buddhist, were read in the repository.
- **The third column holds three blanks.** All three come from TM's dialectics pilot, from memory: when the principal aspect changes places; when antagonism turns into its other; why those who read a loss come to be many.

## What it does not do

It adds no result, and changes neither a record nor the atlas. The two laws asked by dialectics (where-a-run-turns, the-draws-before) and the three blanks rest on AI knowledge of sources that are not in the repository. No person's review of the prototype is recorded.

## AA's first readings of the fold-in (10 November 2026), which TM agrees with

1. Keep `zh` in the atlas entries' text fields, and put BCP 47 on the signifiers only, unless step 5 finds a reason to migrate.
2. The render takes names from `signifiers.json` by language; entries stay hand data, and no entries file is generated from another.
3. The `asked_by` back-link stays in the ledger until the research render's owner takes it up.

AA's step 5 comes after its steps 3 and 4. These supersede the three steps under "The signifiers' entries" above.

## Next

- **AA:** decides the shapes and folds them in at its step 5.
- **TM:** the dialectics pilot is in [`../pilot/`](../pilot/DIALECTICS.md): fifteen claims by one reader, from memory, each landing checked against the records.
