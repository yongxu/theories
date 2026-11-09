*The brief given to Fable and astra, 10 November 2026 (AI-authored). Opus read the same material under the same questions before seeing either reading. The folder it names, `/Users/ren/tmp/tm/snap/`, held a fixed copy of main at `cee8d0e6c` (`git archive` of the paths the brief lists, with Ren's words), which are kept in [the source record](../../../../../../../sources/15-codex-theory-conversations/2026-11-10-traditions-onto-the-map.md).*

# Brief: traditions onto the map, so that they correct it

You are one of three readers (Claude Opus, Claude Fable, GPT astra) asked by Ren for an independent design on the same whole material. You are not given the others' designs, and they are not given yours. Read-only: do not edit, create or commit anything under `/Users/ren/theories`. You may write scratch scripts and notes only in `/Users/ren/tmp/tm/work-<you>/` (`work-fable` or `work-astra`). Your answer is your final message.

This Mac is shared by many sessions and heavily loaded: no builds, no test suites, no Lean runs. Reading Lean source, grep, and light Python over the JSON are fine.

## The situation

`/Users/ren/theories` holds Ren's theory of becoming. Its instruction file `AGENTS.md` says what the work is: "We are drawing a map of how anything forms, persists, changes and ends, so that humans and AI can see the way together. It is first a map for alignment … It is also a map of wisdom: what traditions, sciences, philosophies and systems thinking have seen of these dynamics, read onto one account, where they meet it and where they do not." The core is proved in Lean. Around it are eight chapters, about 550 result records, an atlas of 177 dynamics, a crosswalk of 1,183 correspondences (sixteen earlier theory folders and twelve domains of thought read onto the account), and pages generated from these.

Read only the fixed copy of main at `cee8d0e6c` (10 November 2026) in `/Users/ren/tmp/tm/snap/`; paths below are relative to it. Other sessions keep committing to main.

## What Ren asked (verbatim, with context, in `sources/15-codex-theory-conversations/2026-11-10-traditions-onto-the-map.md`)

In four messages tonight:

> 哲学中的各种理论 例如对立统一，是不是也可以在地图的一些位置找到？

> 我在思考对于这一类的哲学问题，哪些可以map上去，这种map有什么意义，你有什么好的想法吗

> 对于一个断言，或者对于所指的能指，不是只能有一个，可以有不同语言的，首选是文言文，其次英文，然后再其他语言与文化

> 你说的意义我都很认可，尤其是第一个，改正地图本身
>
> 请开始， 不太确定交给aa是什么意思，但是采取最优策略，同时启动fable和astra帮忙设计

The "AI-authored context" in that record is Opus's earlier answers in the conversation. Ren agreed with its account of what mapping is for, and above all with the first: **correcting the map itself** (a tradition's claim the map does not give is a premise not yet found, a world claim to test, or a mistake, and its residue should be able to change the map). Everything else there (five kinds of claim, three kinds of signifier, the pilot, the risks) is one reader's proposal: test it, improve it or replace it. We want your own design, and where you think the proposal or Ren's words are wrong or have holes, say so and argue it.

## The questions

1. **Method: which claims can be mapped, and how a mapping corrects the map.** For claims from philosophy, wisdom traditions, sciences, systems thinking and cultures: what kinds of claim are there, and for each kind what can a mapping produce (a Lean theorem, theorem under a stated premise, or countermodel; a scoped law; a test that could fail; the form of a reading; a named blank)? What separates a mapping worth having from a word match? How does what the source adds that the map lacks become a change to the map, and how is that recorded so a reader can see where traditions corrected the map and where the map corrected the traditions' universal forms? What should not be mapped, and how is that kept?

2. **Signifiers: many per node, 文言 first, then English, then other languages and cultures.** Design the data structure. Distinguish (or argue against distinguishing) names the map coins, a tradition's own terms that point at a node with their relation to it, and statements (06 §七's 中华本 had 經 in plain 文言, 說 in modern Chinese, 證 in Lean). Handle many-to-many (one word, several nodes; one node, many words), provenance (who wrote it; text read or from AI memory), and where it fits the atlas's existing files (`theories/becoming/results/atlas/entries/dynamics.json`, whose `name` is a language-keyed dict, 177 `en` and 6 `zh`; `correspondences.json`; the crosswalk brief's schema). How should a 文言 name be coined well, given 06's "two name systems" (§三, `two-name-systems`), the eleven 虚词 conventions, and the 中华本's 名表; and when should no name be coined? Is 文言 first a good choice, and for what (naming, defining, display)? Language codes.

3. **The pilot: materialist dialectics.** Engels's three laws (unity and struggle of opposites; quantity into quality; negation of the negation), Lenin's notes on dialectics, and Mao's 《矛盾论》 (universality and particularity of contradiction, the principal contradiction and its principal aspect, identity and struggle, antagonism), with neighbours: 老子's 反者道之动 and 有无相生, 物极必反, Heraclitus, Hegel. None of the dialectics sources is in the repository; say so wherever you state them from memory. Split them into claims; for each, where it lands on the map now (cite records, chapter anchors and Lean declarations you have checked in the snapshot), and which would change the map. Start from what exists: 06 §四's family 相待 (`GrammarCandidates.lean`: `«能所相待»`, `«二际可偏举»`, `«同根则不可偏举»`, `«相待之还当且仅当双非可还»`); the crosswalk entries for Hegel, Marx, Heraclitus and `cx-kpso-every-extreme-closes`; 02's closed-capture, two-sided regulation and late reading, margin of a regime, generation and degeneration at two grains, G03 物壮则老; 05's relative position; AA's planned CY (PLAN §5: when a regime cycles, hysteresis, tipping by rate). Above all: **when does an extreme reverse, when does it lock, when does it oscillate?** If you can, state a candidate law precisely enough to be proved or refuted in Lean (its statement, premises, what it forbids, which existing declarations it would generalize or sit below), or say why it cannot yet be stated. Do the same, if they have one, for quantity into quality and the negation of the negation.

4. **Alignment.** What this mapping gives the alignment the map is first for (a selection: what it reaches, what it drains beyond what it reads, how it locks; the joint selection of humans and AI; the meta-attractor). Briefly.

5. **Where it could go wrong, and what to do first.** Order, size, what touches other items (AA owns the atlas's data files and its step 5, the wisdom matrix; CY is AA's planned item), and what is Ren's (pushing, money and machine time; new test designs are held until the first human readers report, so a frozen test can be designed later, not now).

## How to read

- Start from `AGENTS.md`, `theories/becoming/ONE-PAGE.md` (and `.zh.md`), and `theories/becoming/chapters/08-METHOD.md` from its beginning (the one relational unfolding; §8's known results and containments).
- Then: `chapters/06-CLASSICAL-TEXTS.md` (§三, §四, §七); `chapters/02-MAP.md`; `chapters/05-COLLECTIVES.md`; `results/atlas/` (`ATLAS.md`, `CROSSWALK.md`, `JOINS.md`, `crosswalk/*.md`, `entries/*.json`); `results/records/`; the Lean under `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`.
- Process: `_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aa-attractor-atlas/PLAN.md` (§3, §4.4, §5, §6, §13), `…/map-structures/readings/` (00 to 04, the last study read three ways; its joint reading §2 and §5), `…/cx-crosswalk/BRIEF.md`, `…/ou2-candidates/`, `theories/becoming/history/THE-THEORY-OF-BECOMING-ZHONGHUA.md`, `theories/jian-and-wenyan-as-formal-language/README.md`.
- Read what you need; you need not read everything. Say what you read.

## How to answer

- Say what is there and how far it has been seen: proved (name the Lean declaration and its premises), tested, argued, a reading, or wanted. Never state a result the Lean does not have. Mark every statement of a source text that you did not read in the snapshot as from memory, unchecked.
- There is no should beyond becoming here: the account evaluates nothing, and ethics forms within it. Do not frame it as resting on premises whose warrant is open.
- Keep counterexamples and what would fail. A design that only finds agreements is a false map.
- Answer by the five questions, with a summary of at most ten lines at the top. About 3,000 to 6,000 words. English is fine; use Chinese and 文言 where the design needs them.
