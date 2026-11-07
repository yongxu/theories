export const meta = {
  name: 'lineage-research',
  description: 'Gather dated turning points of how the account grew, each with evidence and a label, then adversarially verify each stratum',
  phases: [{ title: 'Gather', detail: 'six strata read from the repository' }, { title: 'Verify', detail: 'one skeptic per stratum checks every point against its evidence' }],
}

const WT = '/Users/ren/theories/.claude/worktrees/rw-spine'
const COMMON = `You are helping build theories/LINEAGE.md, a generated page on how the account in this repository grew: from the earlier theory folders and writings (2021 onward) to the live account, the theory of becoming (theories/becoming/), up to 8 November 2026. Work READ-ONLY in ${WT} (a git worktree of main). Do not edit, create or delete any file; do not run tests or builds; git log/show/grep and reading files are fine.

Privacy: never open /Users/ren/theories/sources/12-*, sources/13-*, sources/18-* or drafts/2026-10-02-friend-conversation (private, gitignored, not in this worktree; do not reach them by absolute path). When public text cites private material, report only what the public text says, and label the point accordingly.

Every turning point you report must carry:
- date: as exact as the evidence allows (YYYY-MM-DD, or YYYY-MM, or YYYY), with date_basis saying where the date comes from (the source's own date, a file's dated name, a commit's date via git log, or a public text that dates it);
- title_en: a short noun phrase (at most 12 words);
- what_en: one to three plain sentences on what changed, copying the source's words for any claim (no claim stronger than the source; a standing word such as proved, conjectured, failed, frozen kept exactly);
- evidence: one to four items {path (repository-relative, must exist in the worktree, or a cited private path), locator (heading, line or anchor), quote (at most 25 words copied exactly from the file)};
- label, exactly one of: "public" (the evidence is a tracked file in this repository that states it), "private" (the only primary evidence is private and unpublished, such as sources/12, 13 or 18, or material not stored here, which a public text cites; say which public text cites it), "reconstruction" (no source states it; it is inferred, by an AI or by a public synthesis such as TIMELINE.md that itself reconstructs from material). TIMELINE.md was written in September and October 2026 by an AI synthesis from the corpus: a point whose only evidence is TIMELINE's own narrative is "reconstruction" unless TIMELINE quotes a dated primary file that is in this repository.
- label_why: one sentence.
Name no person in title_en or what_en (no author's name, no AI or model names except where a test's system is the subject, e.g. "a language model (Claude Haiku)" in a test). Prefer fewer, real turning points (where vocabulary, method, structure or standing changed) over many small ones.`

const POINT = {
  type: 'object',
  properties: {
    id: { type: 'string' }, date: { type: 'string' }, date_basis: { type: 'string' },
    title_en: { type: 'string' }, what_en: { type: 'string' },
    evidence: { type: 'array', items: { type: 'object', properties: { path: { type: 'string' }, locator: { type: 'string' }, quote: { type: 'string' } }, required: ['path', 'locator', 'quote'] } },
    label: { type: 'string', enum: ['public', 'private', 'reconstruction'] }, label_why: { type: 'string' },
    thread: { type: 'boolean', description: 'true only for points on the selection thread' },
  },
  required: ['id', 'date', 'date_basis', 'title_en', 'what_en', 'evidence', 'label', 'label_why', 'thread'],
}
const RENAME = {
  type: 'object',
  properties: { date: { type: 'string' }, from: { type: 'string' }, to: { type: 'string' }, where_en: { type: 'string' }, evidence_path: { type: 'string' }, quote: { type: 'string' } },
  required: ['date', 'from', 'to', 'where_en', 'evidence_path', 'quote'],
}
const GATHER = {
  type: 'object',
  properties: {
    points: { type: 'array', items: POINT },
    renames: { type: 'array', items: RENAME },
    papers: { type: 'array', items: { type: 'object', properties: {
      id: { type: 'string' }, title: { type: 'string' }, date: { type: 'string' }, paths: { type: 'array', items: { type: 'string' } },
      kind_en: { type: 'string' }, claimed_en: { type: 'string' }, stands_en: { type: 'string' }, stands_basis: { type: 'array', items: { type: 'string' } },
      label: { type: 'string', enum: ['public', 'private', 'reconstruction'] } },
      required: ['id', 'title', 'date', 'paths', 'kind_en', 'claimed_en', 'stands_en', 'stands_basis', 'label'] } },
    output_readme_en: { type: 'string' },
    gaps: { type: 'array', items: { type: 'string' }, description: 'what you could not date or evidence, and why' },
  },
  required: ['points', 'renames', 'gaps'],
}

const STRATA = [
  { key: 'early', prompt: `Stratum: 2021-05 to 2025-12 (compressed on the page). Read _process/history/2026-09-consolidation/TIMELINE.md sections from "2021-05" through "2025-09 → 2026-02-06", and its "Where the vocabulary turned" section for renames in this span. Check what you can against the primary files TIMELINE cites that are tracked here (sources/00-early-2021-2022, 01-writings-2025, 02-wamotopia, 03-meta-attractor, 04-speculative-future, 05-alignment-and-moloch, the earlier folders under theories/ and their banners). Return 6 to 12 turning points and the renames of this span (renames: a term replaced by another, with the dated evidence). Mark thread:true only for the selection mechanism's points (see TIMELINE's 2024-03 → 2024-08 seedbed and 2025-05 → 2025-08 meta-attractor).` },
  { key: 'pre-becoming', prompt: `Stratum: 2026-01 to 2026-10-04. Read TIMELINE.md from "2026-02-07 → 2026-04-30" to "2026-10-03 → 2026-10-04", its "Where the vocabulary turned" and "The shape of the arc"; the earlier folders' READMEs and banners under theories/ (not theories/becoming/), drafts/ folder names and READMEs, and git log for when folders were first committed (git log --diff-filter=A --format='%ad' --date=short -- <path> | tail -1). Return 8 to 14 turning points and this span's renames.` },
  { key: 'becoming-october', prompt: `Stratum: 2026-10-05 to 2026-10-31, the Becoming era's first month. Read _process/BECOMING-WORKBOARD.md (Now, the way now), its history file (find it: _process/history or a BECOMING-WORKBOARD history page linked from the board), sources/15-codex-theory-conversations/ file names and first lines (dated words), GLOSSARY.md, theories/becoming/chapters/08-METHOD.md (§3 pure core, §6, §7, §8 known results, §12), the records' history arrays (theories/becoming/results/records/*.json, field history[].en, which start with a date), and git log --format='%ad %s' --date=short main for 2026-10-05..2026-10-31 (grep "landed"). Find: the pure core and the Lean package Becoming; the restructure into the one page, overview and eight chapters (RA, about 23 October); one-unfolding root and the grammar (OU, from 23 October); the release gate (30 October); the ethics for life; the coordinator and one head (25 October); and renames of this span (terms of the account renamed; the canonical chapter retired to history; record ids renamed by rename_ids, see _process for rename logs). Return 8 to 14 turning points and this span's renames.` },
  { key: 'november', prompt: `Stratum: 2026-11-01 to 2026-11-08. Read the board's Now section and Queue line (_process/BECOMING-WORKBOARD.md), the freeze steps (_process/research/2026-10-05-generative-foundation-review/root-foundation/development/review-packet/FREEZE-STEPS.md: editions 1 to 5 with their dates and D commits), the experiments index (experiments/README.md) and each run's README result section for runs in November (UE31b, UE32, LA4 Stage A, RUN6, RUN7: T1N and T1R refused), the atlas (theories/becoming/results/atlas/), the crosswalk (CROSSWALK.md's opening), and git log --format='%ad %s' --date=short main since 2026-11-01 (grep "landed"). Find: the freeze and editions 1 to 5 (and why each superseded the last), the tests run in November and their outcomes in the words of their READMEs, the hold on paid runs and new test designs (6 November), the atlas, the crosswalk and connection map, the Lean made whole (LM), the representation review (RV) and its later steps. Return 8 to 14 turning points and any renames.` },
  { key: 'thread', prompt: `Trace ONE thread end to end: the selection mechanism, from its first statement (TIMELINE dates the seedbed 2024-03 → 2024-08; find the 2024-07 point and its primary file if tracked, e.g. sources/05-alignment-and-moloch or sources/03-meta-attractor), through the meta-attractor (theories/meta-attractor/README.md, sources/03-meta-attractor, 2025-05 → 2025-08), to closed capture on the spine (the board and records name closed capture; find the 20 October 2026 landing: git log --format='%ad %h %s' --date=short main | grep -i -E "capture|closed"), to T7's failed bridge (experiments/self-rewarding-lock/README.md; 08-METHOD.md §9's T7 row: "every frozen verdict passed and the bridge failed"; 02-MAP.md#t7). Return 4 to 7 points, all thread:true, in order, each with its evidence and label; in what_en say what changed in the mechanism's statement at that point, in the sources' words.` },
  { key: 'papers', prompt: `The papers stratum, and output/. List every paper or paper-like draft: drafts/* folders (notably drafts/2026-10-02-iaseai-selecting-the-selectors, drafts/2026-09-26-community-mission, drafts/2026-10-02-shengsheng-en, drafts/2026-10-04-no-safe-way-to-win, drafts/2026-09-28-capability-outruns-correction, drafts/2026-10-03-the-game-of-winning), output/pdf/*.pdf and output/pdf/history, the review-packet editions under output/pdf/review-packet and output/pdf/history. For each paper: its title, date, paths, kind, what it claimed (its own words, from its README or text; for a PDF with a .md source, read the .md; pdftotext may be absent, so prefer sources), and what of it stands in the live account: read the crosswalk (theories/becoming/results/atlas/CROSSWALK.md and entries/correspondences.json) where it reads that paper's folder, and the live chapters, and say it in their words, marked as an AI reading in stands_en ("[AI reading]") where you judged it. If the IASEAI line has versions (v2 to v6.2, v3.1 draft), list the versions found and their dates. Also write output_readme_en: a neutral README for output/ (what each subfolder and file is, its date, that edition PDFs are frozen reader editions and which edition is current per the board's "Which edition to send" line; feature none as recommended reading; say what is history). Return papers, output_readme_en, and points for when papers were made (label each).` },
]

const VERIFY = {
  type: 'object',
  properties: {
    verdicts: { type: 'array', items: { type: 'object', properties: {
      id: { type: 'string' }, keep: { type: 'boolean' }, problems: { type: 'array', items: { type: 'string' } },
      corrected: { type: 'object', description: 'the corrected point (same fields as the input point, all present) when keep is true and anything needed correcting; omit when nothing changed' },
    }, required: ['id', 'keep', 'problems'] } },
    rename_problems: { type: 'array', items: { type: 'string' } },
    paper_problems: { type: 'array', items: { type: 'string' } },
    missing: { type: 'array', items: { type: 'string' }, description: 'real turning points in this stratum the gatherer missed, each with its evidence path' },
  },
  required: ['verdicts', 'rename_problems', 'missing'],
}

const results = await pipeline(
  STRATA,
  s => agent(`${COMMON}\n\n${s.prompt}`, { label: `gather:${s.key}`, phase: 'Gather', schema: GATHER, effort: 'high' }),
  (g, s) => g ? agent(`${COMMON}\n\nYou are an adversarial verifier. Another reader gathered the points below for the stratum "${s.key}". For EVERY point: open each evidence path and check the quote is there verbatim at the locator; check the date against the evidence (and git log where a landing is dated); check what_en says no more than the evidence (a standing word changed, a qualifier dropped, a claim widened, a person named: each is a problem); check the label by the rules above (in particular: TIMELINE-only narrative is "reconstruction"; a private source cited by public text is "private"). keep=false only if the point is wrong or unsupported and cannot be repaired from the repository; otherwise repair it in "corrected". Check the renames the same way, and the papers (if any): each "stands_en" against the crosswalk entry or chapter it cites. List real turning points the gatherer missed in "missing".\n\nThe gathered data:\n${JSON.stringify(g)}`, { label: `verify:${s.key}`, phase: 'Verify', schema: VERIFY, effort: 'high' }).then(v => ({ key: s.key, gathered: g, verified: v })) : null,
)
return results
