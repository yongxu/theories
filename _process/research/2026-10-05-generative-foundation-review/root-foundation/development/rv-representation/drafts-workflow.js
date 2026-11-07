export const meta = {
  name: 'rv-draft-fixes',
  description: 'Draft exact, home-checked corrections for what the pages around the account tell a reader (RV, plan step a)',
  phases: [{ title: 'Draft', detail: 'four read-only drafters, one per group of fixes' }],
}

const WT = '/Users/ren/tmp/rv/wt'
const COMMON = `You are drafting corrections for the theory repository, working read-only in the git worktree ${WT} (branch rv-representation, at main 804028391). Do NOT edit, create or delete any file, and do not commit; run no tests, builds, renders or gates. You may read files, grep, use git log/show, and run small python one-liners to count. Return the exact edits for the coordinator to apply.

Context: an AI review of how the repository presents itself found places around the account that tell a reader more than the account supports. The account's own homes (theories/becoming/ONE-PAGE.md, THE-THEORY-OF-BECOMING.md, chapters/01..08) are the authority; front and navigation text must say no more than they do.

Rules that bind every edit (from AGENTS.md):
- Restating a claim, copy its home's words first and shorten after; a gloss is where qualifiers and standings drop. Quote the home sentence you copied from in home_quote.
- Never hand-edit a generated page. The list of generated paths is the keys of _process/architecture/generated-manifest.json ('files'). For a generated page, edit its source (a goal JSON in _process/goals/, a file named in _process/research-config.json, or the generator in tools/research/). Say which.
- No person or AI is named in live front text (no "Ren", "Claude", "Codex"); "[AI reading]" style labels the pages already use are fine. AI-written text keeps its label.
- Keep the sense of what is there; correct only what is false or says more than its home, and keep every qualifier. Do not add new claims, results or uses.
- Live text is anything outside history/ folders, sources/, output/, drafts/ and _process/history/; frozen edition folders are not edited.
- Each edit's old string must occur exactly once in its file (check with grep -c or python), and must be copied byte for byte from the file, including punctuation such as curly quotes and non-breaking characters.

Write in plain English in the repository's style: short declarative sentences, no em-dash pile-ups, no marketing words.`

const SCHEMA = {
  type: 'object',
  properties: {
    summary: { type: 'string', description: 'what you found and what the edits do, 150-400 words' },
    edits: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          file: { type: 'string', description: 'repo-relative path' },
          old: { type: 'string', description: 'exact text now in the file, occurring once' },
          new: { type: 'string' },
          kind: { type: 'string', enum: ['text', 'source-of-generated', 'generator', 'data'] },
          why: { type: 'string' },
          home: { type: 'string', description: 'path:line or path#anchor of the home the new text follows' },
          home_quote: { type: 'string' },
        },
        required: ['file', 'old', 'new', 'kind', 'why'],
      },
    },
    new_files: {
      type: 'array',
      items: { type: 'object', properties: { path: { type: 'string' }, content: { type: 'string' }, why: { type: 'string' } }, required: ['path', 'content', 'why'] },
    },
    restatements: {
      type: 'array',
      description: 'every live sentence you checked for the same claim, whether you changed it or not',
      items: { type: 'object', properties: { file: { type: 'string' }, line: { type: 'integer' }, text: { type: 'string' }, verdict: { type: 'string', enum: ['changed', 'fine', 'frozen-or-history'] }, note: { type: 'string' } }, required: ['file', 'text', 'verdict'] },
    },
    data: { type: 'object', description: 'any structured facts the task asks for' },
    open: { type: 'array', items: { type: 'string' }, description: 'what you could not settle, and anything the coordinator must decide' },
  },
  required: ['summary', 'edits', 'restatements', 'open'],
}

const TASKS = [
  {
    key: 'folders',
    prompt: `${COMMON}

Your group: the sixteen earlier theory folders under theories/ (every folder there except theories/becoming/).

Problem found: their README.md files present their September self-assessments as current, for example keep-the-possibility-space-open/README.md:5 ("rigorous", "survived a 56-criticism adversarial review", "Near-publishable"), alignment-selection-on-cognition/README.md:9 ("Publishable now"), and "publishable today" in wamotopia-and-the-wamo-protocol, human-solutions-museum and zhishan-intelligence-must-be-good. None links the crosswalk (theories/becoming/results/atlas/CROSSWALK.md, generated; each folder has a section anchored cxg-<slug>), most do not link the live account, and theories/ has no README.md.

The plan: a short banner at the very top of each folder README (above the first line, every existing byte below it unchanged), the same wording for all sixteen with slots, and a theories/README.md index that the coordinator will generate from the crosswalk data (theories/becoming/results/atlas/entries/correspondence_groups.json and correspondences.json; atlas.json under results/data).

Do this:
1. For each folder: its slug; its title; the dates of its README's first and last commits (git log --follow --format=%ad --date=short -- theories/<slug>/README.md) and of the last commit that changed its substance (ignore commits that only re-pointed links or moved paths: read git log --stat -- theories/<slug>/ subjects); every sentence in its README (and only its README) that presents a standing, readiness or quality as current (publishable, rigorous, proved, established, complete, survived review, ready, validated, and the like), with line numbers and exact words; its crosswalk group id and how many entries it has there and their outcomes (from correspondences.json: carried / carried-in-part / changed / history-only / not-carried / fresh-reading). Put this in data.folders.
2. Read theories/becoming/chapters/05-COLLECTIVES.md around line 398 (the sentence on design programmes, "correspondence not established" or similar) and say which folders it names or covers, quoting it. Read the crosswalk page's opening paragraphs (lines 1-12 of CROSSWALK.md) for how it describes itself; the banner must not claim more than that page does (every entry is an AI reading; a shared word is not a correspondence; not carried is an outcome, not a defect).
3. Draft ONE banner template (at most 70 words, Markdown, a single blockquote paragraph starting with "> ") with slots {date} (the folder's last substantive revision) and {anchor}. It must say: this is an earlier theory folder, written before the live account; the live account is theories/becoming/ (link relative to the folder: ../becoming/ONE-PAGE.md); its own assessments of standing and readiness are its view as of {date}, not the live account's; what became of its claims, read by AI and by no person, is in the crosswalk (../becoming/results/atlas/CROSSWALK.md#{anchor}); the index of the earlier folders is ../README.md. Do not repeat any count in the banner. Give the template in data.banner_template, and the sixteen filled banners as edits whose old is the README's current first line and whose new is the banner, a blank line, then that same first line.
4. Draft the text of theories/README.md (the coordinator will generate it; give the lead paragraph and the column headings you propose, in data.index_lead and data.index_columns): what the folders are, that the live account is theories/becoming/, how far to trust the crosswalk (copy from CROSSWALK.md's own words), one row per folder.
Check that adding a line at the top of a README breaks no crosswalk quote check (atlas.py checks that each entry's quote is verbatim in its source file) and no record citing a line number of a folder README: grep records under theories/becoming/results/records/ and the atlas entries for line-number locators into theories/<slug>/README.md and list any in open.`,
  },
  {
    key: 'root',
    prompt: `${COMMON}

Your group: theories/becoming/chapters/01-ROOT.md line 5, which begins "**Where this chapter sits.** It takes nothing from the others and hands its grammar, classes and models to all of them", and every live restatement of the same claim.

Problem found: by the theory graph (theories/becoming/results/data/theory-graph.json, edges of type formal-reuse between result nodes whose region is root, map, knowing, life, collective, classical, significance, method), 45 of the root region's 86 results have a formal-reuse edge to a result of a later region; and Becoming.Courses, a root-region module, imports modules of the knowing region (reported, check it).

Do this:
1. Establish what is true, exactly, with counts you recompute yourself. Read tools/research/theory_graph.py to learn what a formal-reuse edge from A to B means (does A's proof use B, or the reverse?) and how regions are assigned (results/data/regions.json). Recount: root results, how many have a formal-reuse edge into a later region, and a few examples by name. From the Lean (the package is under experiments/integrated-correction/general-framework/generative-basis/lean/becoming/; find the Becoming/*.lean files), check what Becoming.Grammar imports (the pure core is said to import only Init) and which root-region modules import modules assigned to other regions. Put the facts in data.facts. If the direction of the edges means the claim is in fact true, say so and propose no edit.
2. Draft the corrected sentence for 01:5 in its own words: keep "hands its grammar, classes and models to all of them" where true, and limit "takes nothing from the others" to what is true (the grammar, the pure core), saying that the chapters' order is a reading order and that some of this chapter's results are proved with laws stated in later chapters, if the facts show that. Copy 08-METHOD.md's or the overview's own wording of the spine's structure where it states this (search 08-METHOD.md for the pure core, the spine, "the edge of one root", and THE-THEORY-OF-BECOMING.md and chapters/README.md for how the chapters' order is described).
3. Search by the claim, not by the word: every live sentence saying or implying that chapter 1 or the root depends on nothing else in the account, that later chapters derive from it in order, that the chapters' order is a derivation order, or that every chapter rests on the root. Look at least in: README.md's sources (_process/navigation/*.md, theories/becoming/OPENING.md), MAP.md, GOALS.md's sources (_process/goals/*.json), theories/becoming/ONE-PAGE.md and .zh.md, THE-THEORY-OF-BECOMING.md and .zh.md, ONE-ARGUMENT.md, COLLECTIVE-DIRECTION.md, FREE-ENERGY-PRINCIPLE.md, chapters/*.md (01 to 08 and README.md's source if generated), theories/becoming/review/*.md (the cover and dossiers), GLOSSARY.md, the Lean package's README. Chinese editions count: search their Chinese wording too (不取于其他, 不依赖, 根 etc.). Report each in restatements, and draft edits for those that say more than the facts. Chinese text must be corrected in Chinese, in the edition's own register.`,
  },
  {
    key: 'fronts',
    prompt: `${COMMON}

Your group: sentences on README.md (generated by tools/research/navigation.py from sources named in _process/research-config.json) and MAP.md (hand-written).

1. README.md:43 (from theories/becoming/OPENING.md, the paragraph beginning "This is a foundation for AI alignment") says "To achieve alignment, we need a foundation that makes coordination possible, and this foundation supplies that too." Its own note (README's note 13, around README.md:107, which is OPENING's footnote) calls this a thesis, not a theorem, and theories/becoming/COLLECTIVE-DIRECTION.md:87 says no test has human participants. OPENING's header comment (line 1) says its first-person body is revised in place on argument and the italic line under its heading names each passage revised; this sentence's paragraph ("This is a foundation") is already listed there. Draft the corrected sentence so that the main text carries the qualifier (in the opening's own first-person register, copying the note's and COLLECTIVE-DIRECTION's words for the standing), and the edit to the italic revised-passages line naming what this revision did, in its existing pattern. Read the whole paragraph and its notes first, and 07-SIGNIFICANCE.md and COLLECTIVE-DIRECTION.md on coordination, so the sentence says neither more nor less than they do.
2. README.md:156 and :158 come from _process/goals/chinese-sources-and-becoming.json. :156 says "The relational start holds across the lines; their universal forms mostly need …" and "91 agree, 98 hold within an exact scope, 59 diverge" without the chapter's own "agreement is not confirmation"; theories/becoming/chapters/06-CLASSICAL-TEXTS.md calls the relational start a main thread (主导线索 or its English) and lists what is not shown (06 near line 4 and near line 628). :158's "Next" lists open gaps; check each against 06 (one is reported answered near 06:466). Draft the corrected goal fields in the chapter's words.
3. README.md:188 comes from _process/goals/generative-alignment.json: "Still to do: AJ4's one page for alignment researchers, now in draft". That page was retired on 31 October 2026 and replaced by theories/becoming/review/ALIGNMENT.md's section "The dossier in ten minutes" (see the move receipt with aj4-page-retire in its name under _process/architecture/ or wherever move receipts are kept: _process/research-config.json move_receipts). Draft the corrected field.
   For 2 and 3: read how navigation.py renders goal fields (which keys appear on README and GOALS.md), check whether any record or check cites or hashes these goal fields (grep tools/research and records for the goal ids), and say whether GOALS.md is generated from the same fields.
4. The first screen (_process/navigation/README-FIRST-SCREEN.md; read its whole header comment, which explains its budget and what each point must carry) has no sentence of 08 §8's verdict: theories/becoming/chapters/08-METHOD.md near line 482, "None of the central results is new mathematics: each is near-definitional or a known result restated." ONE-PAGE.md near line 30 states it too. Draft one sentence for the first screen's "Lean receipts" point (or where it fits the header's four points), linking ../../theories/becoming/chapters/08-METHOD.md#known-results, copying the home's words, as short as the home allows. Find the check that bounds the first screen's words (WHAT-REMAINS item 6, amendment 1; grep tools/research for first_screen and for the word bound) and say whether the sentence keeps it, with the count before and after.
5. MAP.md: line 22 says the theory graph shows "every concept, result, Lean module and text, with how they connect" — THEORY-GRAPH.md shows tables of nodes and edges; check what it does show and correct the phrase only if it overstates. Line 32 says "in more than 1,550 commits (1,568 in all by 19 October 2026)"; main now has many more (count with git rev-list --count HEAD); draft a dated, true sentence. MAP's "What this is" section (find it): draft the same verdict sentence as in 4, in its words, if MAP lacks it. Check MAP's other counts and dated claims in its first 60 lines against the repository and report any stale one in restatements.`,
  },
  {
    key: 'catalogues',
    prompt: `${COMMON}

Your group: legacy catalogues shown under current names, and three small misleading lines.

1. theories/becoming/results/README.md (generated by tools/research/reading_catalogue.py; lines about 29-34 come from reading_catalogue.py near line 261) sends questions such as "What foundation has been established?" to frozen pages of 8 October 2026 (../history/ARGUMENTS-A-L-2026-10-08.md and similar). Read the page's top and those rows; decide for each row whether to re-route it to the current home (theories/becoming/ONE-PAGE.md, THE-THEORY-OF-BECOMING.md, chapters/0N-*.md anchors, RESULTS.md, THEORY-GRAPH.md) or to label it as the catalogue of 8 October. Check every anchor you propose exists (grep for '<a id="..."' or the heading). Draft the generator edits.
2. theories/becoming/results/GENERATIVITY-CHAIN.md (generated by tools/research/generative_chain.py from results/data/generativity-chain.json; its title is at generative_chain.py near line 134) is titled "Generativity, co-realization and ethics: the connected theory", uses G0, and carries "Content updated 2026-11-07". It is linked as "Curated generativity chain" from one generator line, tools/research/navigation.py near line 625, which writes the same nav line into README.md:212, RESULTS.md:575, theories/becoming/README.md:20 and theories/becoming/chapters/CLAIMS.md:18, beside "Full reading catalogue" (results/README.md). _process/research-config.json lists both under legacy_catalogues. Read the chain's maintenance record (grep tools/research/rename_ids.py and generative_chain.py for it) and the open claim CD on _process/BECOMING-WORKBOARD.md, which plans to change C's statement "through the generativity chain's maintenance record", to learn whether the chain is still maintained and by whom. Then draft: a title and a one-line lead for the chain's page that say what it is now (a curated chain of N entries kept since October, with its own vocabulary such as G0, beside the live account), not "the connected theory", in both of its languages as the page is bilingual; and the nav line's labels so that a reader sees the current homes first and the two legacy catalogues labelled as earlier catalogues. Draft the generator edits; do not change the chain's data.
3. experiments/README.md:5 calls theories/becoming/history/THE-THEORY-OF-BECOMING.md "the canonical chapter"; that copy is history since RA. Check whether experiments/README.md is generated; draft the fix (the spine's live description is in 08-METHOD.md; find the right anchor).
4. theories/becoming/chapters/06-CLASSICAL-TEXTS.md §7.3 (find it) links the 中华本 (a Chinese text edition the account made) without its date (2026-10-21) or the fact that it is superseded. Find the link, the page it points to, and the page's own header on its date and standing; draft the fix in 06's language and register (06 is in Chinese where that section is Chinese).
5. Also check, and report in restatements: theories/becoming/README.md (generated) — does it present itself or anything as current that is not (for example a line saying where the opening is, or lists that duplicate the nav)? Report; propose generator edits only for what is false or misleading.`,
  },
]

phase('Draft')
const results = await parallel(TASKS.map(t => () => agent(t.prompt, { label: `draft:${t.key}`, phase: 'Draft', schema: SCHEMA, effort: 'high' })))
const out = {}
TASKS.forEach((t, i) => { out[t.key] = results[i] })
log(`drafts returned: ${TASKS.filter((t, i) => results[i]).map(t => t.key).join(', ')}`)
return out
