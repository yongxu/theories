*Opus's reading (Claude Opus 5.5, AI-written), 10 November 2026, written on the fixed copy at `cee8d0e6c` before reading Fable's or astra's. Lean cited by declaration was read in the snapshot; nothing was built. Every statement of a dialectics source is from memory, unchecked: none of those texts is in the repository.*

# Traditions onto the map, so that they correct it: Opus's reading

## Summary

1. Map claims, not schools. A school is a bundle; its claims fall into five kinds that land in five different ways, and only some of those ways can change the map.
2. A mapping is worth keeping when it changes something checkable: a Lean question opened or closed, a premise named, a test that could fail, a blank named, or a tradition's universal form given its scope. A mapping that only finds likeness of form is a gloss and should be labelled so and counted apart.
3. Keep a **correction ledger**: each entry is one change, in either direction, with its status (wanted, claimed, proved, refuted, frozen, run). It is how a reader sees that the traditions corrected the map, and where the map corrected them.
4. Signifiers live in their own file, many to many, keyed by node id: coined names (文言 first, «»), traditions' terms (「」, with relation and residue), and statements (經, 說, 證). `dynamics.json`'s `name` becomes generated from it. 文言 first holds for coining and defining; display follows the reader.
5. The pilot's main yield: the lock, the turn, settling, crossing, oscillation and ending are each already proved somewhere in the Lean (ClosedCapture, Flow/Regulation, Continuation, RegimeMargin), scattered across two levels of description. Dialectics asks the question that joins them: **an extreme reverses only through a reading of what it drains** (the "only" is close to `reads_beyond_of_apart`), and a reading formed from the share is reabsorbed (`reading_absorbed`). That joined law, and hysteresis (CY b), are the pilot's Lean questions.
6. Two corrections the map already makes to dialectics: "contradiction is universal" is either trivial (`«能所相待»`) or false (`«二际可偏举»`); "grasp the principal contradiction" fails where joint draws are superadditive (`RegimeMargin.Peaked.together_ends`).

## 1. Method: which claims can be mapped, and how a mapping corrects the map

### The five kinds, and what each can produce

| Kind | What it says | What a mapping can produce | Can it change the map? |
|---|---|---|---|
| **Structure** | Relations, identity, part and whole, opposites, before and after | A statement over every carrier and relation, then: proved, proved under a named premise, or a countermodel (06 §四's method: 59 candidates, 38 proved, 15 with a premise, 3 refuted, `candidate-theorems-of-the-corpus`) | Yes: a new root theorem, or a premise the grammar does not assume (double-negation stability, no self-conditioning) made visible |
| **Dynamics** | How things change: reversal, cycles, thresholds, development, decline | A law with its scope from existing declarations, a new Lean question, or a test that could fail | Yes, most: a tradition's dynamic claim the map does not give marks a blank or a missing premise |
| **Evaluation** | Better, just, should | The form of a reading formed within becoming: whose continuation it speaks for, what it reads, what it opens and closes, who bears it | Rarely the laws; it can change what the map says about how a reading forms (07) |
| **Ground** | What all rests on: logos, Spirit, 道 as substance, the ground of being | Compatible with the one relational unfolding, excluded by its thesis (argued, not proved), or a shared word | Seldom; kept so the divergence is visible |
| **Practice** | Advice: 知止, 执两用中, 无为, grasp the principal contradiction | Situation → dynamic → advice → where the advice fails | Yes, through "where it fails": the failure is often a law the map has (or lacks) |

What is not mapped: what something is like to live, meaning carried in ritual and practice, and texts whose point is not to be stated. These go to `not_mapped` with the reason, as the crosswalk brief already allows. A not-mapped is not a judgment.

### What separates a mapping from a gloss

A mapping is worth keeping when at least one of these holds, and the entry names which:

- **It opens or closes a Lean question**: a statement precise enough to prove or refute.
- **It names a premise**: the tradition's claim holds exactly under P, and P is now a named object (the map-structures design wants premises as objects).
- **It gives scope**: the universal form is corrected to where it holds, with the declaration that bounds it.
- **It names a blank**: the tradition sees a dynamic the map has no law for, and the blank gets an id.
- **It proposes a test that could fail** (designed later, under Ren's hold of 6 November).

Everything else is a gloss: likeness of form, a shared image, a word. Glosses are kept, labelled `gloss`, and counted apart, so the 1,183 entries stop reading as 1,183 findings. The crosswalk's `agreement_of` (law / thesis / reading) is half of this; what it lacks is the forward pointer: what the entry did to the map.

### The correction ledger

One new file, `results/atlas/entries/corrections.json`, one entry per change:

```json
{
  "id": "cor-dialectics-reversal-only-through-reading",
  "direction": "tradition→map",            // or "map→tradition"
  "from": ["cx-dialectics-negation-of-extreme", "cx-kpso-every-extreme-closes"],
  "change": "lean-question",                // lean-question | premise | scope | blank | test | reading-form
  "statement": "An extreme reverses only through a reading of what it drains; ...",
  "map_refs": ["closed-capture", "two-sided-regulation-and-late-reading"],
  "status": "wanted",                       // wanted | claimed | proved | refuted | frozen | run | dropped
  "result": null,                           // the record or declaration, once there
  "by": "ai:opus-5.5", "date": "2026-11-10"
}
```

It is generated into a page: "where the traditions corrected the map" and "where the map corrected the traditions", each row linked both ways. Status is derived from records where a result exists (the atlas's rule: standing derived, never typed). A refuted or dropped entry stays: it is where a candidate failed.

### Why the traditions are worth this

A tradition's claim is a long observation of dynamics, kept by a long selection of what was worth saying. That selection is not truth, but it is evidence of where to look. The map-structures joint reading lists the blanks with no law: hysteresis, periodic cycles, noise-driven exits, higher-order capture. Dialectics, the 易, 老子 and systems thinking all speak most where the map is blank. That is the reason to map them first for correction, not for agreement.

## 2. Signifiers: many per node, 文言 first

### Three kinds, kept apart

- **Coined name (立名)**: a name the map gives a node. 文言 first, English second, then others. Defined by the node's Lean and record, written «…» in Chinese texts as 06's grammar names are. A coined name says nothing beyond its definition.
- **A tradition's term (传统之名)**: a word a tradition uses that points at the node, quoted 「…」, with its source, its relation to the node (`same`, `scope`, `divergence`, `word-only`) and its residue (what the source adds). This is what the crosswalk already holds, seen from the node.
- **Statement (陈述)**: 經 in plain 文言 using the eleven 虚词 conventions so its logical form mirrors the Lean (「不 X」 refuted, 「未 X」 not shown either way, 「莫不」 each decided); 說 in modern Chinese (mechanism, conditions, where it fails); 證, the Lean declaration and record. English statement beside them. The 中华本 already did 經/說/證 for sixteen chapters; this extends it to nodes.

Keeping these apart is the guard against the main risk of 文言 first: a 文言 word carries two thousand years of senses. 06 already met this (`two-name-systems`: 窮, 通, 復, 位 mean different things in the 中华本's 名表 and in the grammar). If 「物极必反」 were used as a coined name for a scoped law, a reader would read the old universal claim into it. So a tradition's term is never a coined name unless its relation is `same`, and even then it stays a tradition's term with its source; the coined name is a separate entry.

### The data

A separate file, `results/atlas/entries/signifiers.json`, many to many:

```json
{
  "id": "sig-lzh-nengsuo-xiangdai",
  "node": "law:grammar-candidates#能所相待",   // a dynamic, a record, a declaration, or a blank
  "kind": "coined",                            // coined | tradition | statement
  "lang": "lzh",                               // BCP 47: lzh, en, zh-Hans, sa, pi, bo, grc, la, de, ar, he, ja, ko ...
  "role": "name",                              // name | jing | shuo | statement
  "text": "能所相待",
  "relation": null,                            // for tradition: same | scope | divergence | word-only
  "residue": null,                             // for tradition: what the source adds
  "source": null,                              // for tradition: {work, locator, read: "text" | "memory"}
  "author": "ai:opus-5.5",                     // ren | ai:<model> | tradition
  "checked_by": []                             // who has read it against the text, if anyone
}
```

`dynamics.json`'s `name` dict is then generated from coined names (by language), so AA's files keep one source of truth. Many-to-many falls out: a word pointing at two nodes is two entries with the same text; a tradition seeing two nodes as one is itself a finding (often a coarse class under which they lump, 01's 理).

Language order is a field order, not a ranking of languages: `lzh`, then `en`, then the rest. 文言 and modern Chinese are different codes (`lzh`, `zh-Hans`); the six Chinese names now in `dynamics.json` mix them (退化 and 元吸引子 are modern; 消息之律 and 偏蔽，复通 are closer to 文言).

### Coining a 文言 name well, and when not to

- Prefer the grammar's names where one exists (`«通»`, `«复»`, `«息»`, `«生生»`): they are already defined in Lean.
- Prefer a word from the corpus whose relation to the node is `same` in the mapped passage, and cite the passage; otherwise coin from the corpus's own vocabulary and say so.
- Two to four characters; a 經 sentence whose 虚词 match the Lean's quantifiers and negations.
- Do not coin where the node is an amount law with no structural counterpart (the margin's superadditivity, step counts like `3 hi + 3`): record 「未立名」. Not yet is not a ban; a later reader may find the word.
- Every coined name is AI-written unless Ren coins it; it says so.

### What 文言 first is for

For coining and defining, 文言 first is a good choice: it is compact, its grammar already carries structure (the 間/文言 thesis argues this; 06 tests it), and the classical corpus is the most read domain on the map. For display it should not be first for every reader: the page leads with the reader's language and shows the 文言 name and 經 beside it. I think this is what Ren means by 首选, but it is my reading.

## 3. The pilot: materialist dialectics

None of Engels, Lenin or Mao is in the repository; every statement of them below is from memory, unchecked. The claims, split:

| # | Claim (from memory) | Kind | Where it lands now | Changes the map? |
|---|---|---|---|---|
| D1 | Opposites are interdependent: each is the condition of the other (identity of opposites) | Structure | Holds for the two ends of one relation: `«能所相待»`, `«因果互即»`; with a shared root `«同根则不可偏举»`; a mark gives its complement `«有相则非亦有相»`, the converse equivalent to double-negation stability `«相待之还当且仅当双非可还»` | Map → tradition: scope. Two relations given apart can be raised one alone, `«二际可偏举»` |
| D2 | Contradiction is universal: every thing contains contradiction (《矛盾论》) | Structure | If contradiction means a relation's two ends: trivial wherever there is a relation. If it means two opposed things: false in general (`«二际可偏举»`) | Map → tradition: the claim is trivial or false; its content lies in which relations a thing is made of |
| D3 | Struggle of opposites is absolute, identity relative | Dynamics / evaluation | Struggle is exact for relative position only: `RelativePosition.rise_needs_fall`; totals are not so bound; giving that waits on giving needs no strife (05) | Scope |
| D4 | Contradiction is the source of motion and development | Dynamics | No law has a contradiction moving anything (crosswalk, Hegel entries); under `Unread` a lock outlives any loss (`ClosedCapture.lock_outlives_loss`) | **Yes**: see §3.1 |
| D5 | An extreme turns into its opposite (物极必反, 反者道之动) | Dynamics | 物壮则老 on a bounded room (G03) reads 反 as 返, not as turning; maximizing is not closing as such (05's optimum laws) | **Yes**: §3.1 |
| D6 | Quantity passes into quality at a nodal point | Dynamics | An exact point of no return under a standing draw: `RegimeMargin.ends_iff_below`; within a band without rising giving a run need not rest (`RegimeMargin.Alternation.alternates`) | Scope; hysteresis is the blank: §3.2 |
| D7 | Negation of the negation: development as a spiral, return at a higher level | Dynamics | A carrying renewal is an alteration at two grains (`generation-and-degeneration-at-two-grains`); `«复»` is a line returning to its start | Weak: the spiral is a reading at two classes (returns under L, not under E); no law forces it. Keep as a reading, not a law |
| D8 | The principal contradiction decides; grasp it | Practice | Nearest: the condition nearest its point of no return. But joint draws are superadditive at the point (`RegimeMargin.rises_superadditive`), and `Peaked.together_ends`: two draws each held alone end the condition together | **Map → tradition**: the advice fails exactly where draws are superadditive; attending to one "principal" draw misses the joint one |
| D9 | The principal aspect decides a thing's nature, and the aspects change places | Dynamics | Nearest: which side holds the standing (`Resolution.Alternation`, a unit handed back and forth); no law of when aspects change places | Blank, minor |
| D10 | Antagonistic and non-antagonistic contradictions; one can turn into the other | Dynamics / practice | A race for position draws everything among two drawers or more (`a-race-for-position-draws-everything`); positions sum to zero while totals can rise | Reading; the turn between them is a blank |
| D11 | History moves by the contradiction of forces and relations of production, toward supersession | Dynamics / ground | Divergence (crosswalk `cx-modphil-marx-historical-tendency`): no such tendency; a lock leaves by a change of what is read | Keep the divergence; D4's law states what does turn a loop |
| D12 | Knowledge develops by practice, contradiction and sublation (实践论) | Practice / knowing | 03: knowing inside the unfolding; self-reference does not certify itself | Reading; not this pilot's core |

### 3.1 When an extreme reverses, locks, settles, oscillates or ends

What the Lean already has, in two levels of description:

- **Lock** (preorders, loops): where the share's law raises what it favours, the rule reads the share monotonically, favouring is upward closed, and every step adds at least one to what lies beyond, a locked course stays locked while the loss passes every bound (`ClosedCapture.lock_outlives_loss`). A changed reading is absorbed at the next reading step when the reading is formed from the share (`Readers.reading_absorbed`, `Readers.readers_uniform_locks`).
- **Turn**: where the rule read favours at no configuration whose loss is at least N, at the step after each reading step past N the course is not favoured (`ClosedCapture.turned_by_loss`). And conversely: courses alike in share and rule that come apart refute `Unread` (`reads_beyond_of_apart`); with `courses_alike_iff_unread`, nothing in the loop changes because of what it does not read.
- **Settle** (amounts, flows): within the gap and opposing, the level settles at m with no overshoot (`Flow.settles`, `Flow.restores_exactly`).
- **Cross and oscillate**: beyond the gap an opposing exchange crosses m (`Flow.crosses_of_above`, `Flow.crosses_of_below`); a balanced witness overshooting at every step oscillates about m and is never m (`Regulation.Overshooting`). Without giving rising with what is left, a run within a band alternates for ever (`RegimeMargin.Alternation.alternates`).
- **One side only**: regulation from one side holds a level from that side only; below m, never back (`Flow.never_returns_below`, `stays_below` gated).
- **End**: below the point of no return, a level ends (`RegimeMargin.ends_iff_below`).

So dialectics' question already has six answers in the Lean, and no statement says when which. The candidate law, stated for Lean (wanted, not proved):

> **The law of turning (反之律), candidate.** On a paced course with a share, what lies beyond it, and a rule read at reading steps: the course's rule changes in response to what lies beyond only if the reading reads it (from `reads_beyond_of_apart` and `courses_alike_iff_unread`: an extreme reverses only through a reading of what it drains). Where the reading reads it with a bound, the course turns past the bound (`turned_by_loss`). Where the correction is an amount opposing a departure from a level: within the gap it settles, beyond the gap it crosses, beyond the gap at every step it never rests; from one side only, a departure to the other side never returns. Where the condition's own giving is gated on a need, a departure past the point of no return ends rather than turns.

What it forbids: a reversal with nothing in the loop reading the drain ("the contradiction resolves itself"); a lock broken by a reading formed only from the share; a settled return after overshooting at every step; a return from below a one-sided regulation.

What it would generalize or join: it is a statement over two existing levels (`Pace`/`ClosedCapture` on preorders, `Flow`/`Regulation` on whole-number amounts). By rule 9 it must not land beside them as a second reason. The honest first step is to find whether a common form exists: a departure coordinate read or unread by the step, with the amount laws as the case where the reading is the level's gap. If a common form exists, it lands below both and they become its corollaries; if not, the classification is a leaf module that states the trichotomy from the existing declarations and says it adds no new reason. Either outcome is worth having; the second is honest about being a join.

Why it matters for alignment (§4): it answers "will an over-optimizing selection correct itself?" with the map's own laws: only through a reading of what it drains, and a reading formed from its own share is reabsorbed.

What the source adds that the law does not: the claim that reversal is necessary (物极必反 as law of all things), and that it is a movement of the thing itself. The map gives reversal as conditional on reading; the source's universal stays a divergence.

### 3.2 Quantity into quality, and hysteresis

`RegimeMargin.ends_iff_below` gives the nodal point in one form: the fate (ends or persists) is a threshold in the level, exact under the regime's premises. The richer dialectical claim, that the new quality does not simply undo when the quantity returns, is hysteresis: distinct collapse and recovery thresholds. The map has the one-sided case (`never_returns_below`) and no band; AA's PLAN §5 has it as CY (b). The pilot asks for CY (b) as stated there, with dialectics as one of its tradition signifiers; it should be claimed as CY with AA's owner told, not as a parallel item.

### 3.3 What this pilot already shows about the method

Two of twelve claims open Lean questions (D4/D5 joined, D6's hysteresis); three get scope from existing laws (D1, D3, D6); two are corrected by existing laws (D2, D8); the rest are readings or divergences. That ratio is a guess at what to expect elsewhere, and it is why the ledger counts changes, not entries.

## 4. Alignment

The map is first for alignment: what a selection reaches, what it drains beyond what it reads, how it locks. Traditions bear on this in two ways.

- **Their claims are hopes or warnings about selections.** 物极必反 and "contradiction drives development" are hopes that a runaway corrects itself. The law of turning says when that hope holds: only where the selection reads what it drains, from outside its own share. That is a design requirement for a joint selection of humans and AI, stated from the map's laws, not a value.
- **Their careers are selections too.** A doctrine selected and enforced by the institution it justifies reads its own share: dialectics became a doctrine that could not turn on itself in places where it was official. The map can describe that without judging it (closed capture; a code formed between formations), and the same description applies to this map. That is why the map is proved in Lean and held by no guardian.

## 5. Where it could go wrong, and what to do first

### Risks

- **The map's language wins by default.** Every entry keeps the source's own sense and residue, and the ledger has a `map→tradition` direction only beside a `tradition→map` one.
- **Word matches.** The check pass (assume wrong until both sides are read) stays.
- **AI memory standing in for texts.** 328 of 345 domain entries rest on AI knowledge. For the pilot, the dialectics texts should be read: Engels and Mao are public domain in many editions; fetching them is a download (asks Ren).
- **Agreement does not compose.** Two traditions each agreeing with one law do not agree with each other.
- **False precision in coined 文言 names.** 未立名 is allowed.
- **Rule 9.** The law of turning is a join; it lands below or as a stated leaf, never beside.

### Order

1. **Pilot, here (TM)**: dialectics' claims as crosswalk-shaped entries plus signifiers and ledger entries, in TM's own folder (not AA's files); the Lean question for the law of turning, investigated as a join first (does a common form exist). A claim on the board before any Lean.
2. **Schema to AA's owner**: `signifiers.json` and `corrections.json` as a proposal for step 5; AA decides whether its files take them.
3. **CY (b), hysteresis**: claimed as CY with AA's owner told; dialectics and the 易 are its tradition signifiers.
4. **Then by expected corrections**: systems thinking (Meadows's traps, Holling's cycles: the map's blanks), the 易 (cycles), Buddhism's 无明 (locked seeking), in that order.

What is Ren's: downloading the dialectics texts; any frozen test (held); pushing.
