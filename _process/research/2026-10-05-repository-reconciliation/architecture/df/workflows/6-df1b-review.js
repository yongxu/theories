export const meta = {
  name: 'df1b-review',
  description: 'Verify DF1b corrections against Lean and sources; find remaining instances elsewhere',
  phases: [{ title: 'Review', detail: 'skeptic on the diff, completeness critic on the live account' }],
}
const W = '/private/tmp/claude-501/-Users-ren-theories/4cd2c9b9-8aca-4fd1-99bb-ff1a3f9d1698/scratchpad/wt-df'
const CONTEXT = `You are reviewing board item DF1b in the theory repository, in the git worktree ${W} (branch df1b, based on main 04c7f93ae). Work read-only: do not edit, stage or commit anything; report findings only. Run commands with absolute paths or cd into ${W} in the same command.

DF1b corrects ten weak points that a drafting session (UE8) found in the live account; the list, with what was done for each, is the last section of _process/research/2026-10-05-repository-reconciliation/architecture/DEFECTS-FOUND.md ("Found while drafting the sciences dossier"). The edits were made by _process/research/2026-10-05-repository-reconciliation/architecture/df/df1b_edits.py plus a comment-only change to experiments/integrated-correction/general-framework/generative-basis/lean/physics/EntropyProduction.lean. See all changes with: git -C ${W} diff main. Sources you may need: study section 314 of _process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md (MQ6's verdicts), the Lean files under experiments/integrated-correction/general-framework/generative-basis/lean/ (Becoming/Closing.lean, Becoming/Drift.lean, physics/EntropyProduction.lean, Becoming/Flow.lean for Flow.Gainless), the UE6 finding in _process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue6-beyond-the-sciences/ASTRA-NOVELTY.md item 8, and the UE8 kit README in development/ue8-sciences-dossier/README.md. Record JSON caps: statement 300 chars EN / 150 ZH, laws 420/190, related details and other fields as research.py lint reports (run: cd ${W} && python3 -B tools/research/research.py lint --ids <id>). Claims must say exactly what the Lean proves: no witness read as a general law, no limit where only finite bounds are proved. Chinese text must say the same as the English.`

const FINDING = {
  type: 'object',
  properties: {
    findings: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          file: { type: 'string' },
          where: { type: 'string', description: 'line, field or quoted sentence' },
          severity: { type: 'string', enum: ['error', 'overclaim', 'imprecise', 'missed-instance', 'style'] },
          problem: { type: 'string' },
          evidence: { type: 'string', description: 'file:line or source quote that shows it' },
          fix: { type: 'string', description: 'exact replacement text, EN and ZH where both apply' },
        },
        required: ['file', 'where', 'severity', 'problem', 'evidence', 'fix'],
      },
    },
    checked: { type: 'string', description: 'what you checked and found sound' },
  },
  required: ['findings', 'checked'],
}

phase('Review')
const [skeptic, critic] = await parallel([
  () => agent(`${CONTEXT}

Your task: try to refute each DF1b change. For every changed sentence in the diff (chapters 01, 02, 04, 08, the overview in both editions, GLOSSARY.md, the two experiment READMEs, theories/becoming/review/ALIGNMENT.md, the nine changed records and the EntropyProduction.lean header), check it against the Lean statement or the source it rests on. In particular: (a) MQ6's verdicts as study §314 gives them (which bear on T1, which on T2, what "3 of 10", "five of six on the time to break", A1 and A2's numbers are), and whether T2's refutation clause in 02 really excludes MQ6; (b) Closing.Onset.unforeseen's exact statement; (c) Drift.fixation and Drift.varied_vanishes's exact bounds versus the new fixation-by-drift statement (is ((N^N − 2)/N^N)^k right, and is "those fixing a kind its starting share to within that" exact?); (d) whether the new Landauer sentences are physically correct and fairly attribute Sagawa 2014, and whether the EntropyProduction header still matches its theorems; (e) whether every remaining "first law" in the changed files is in one sense, the spine's Flow.Gainless, unless named "thermodynamics' first law"; (f) the citation years and works (Hordijk and Steel 2004, J. Theor. Biol. 227:451-461; Nei 1971 Genetics 68 and Felsenstein 1971 Am. Nat. 105; Gao, Schulman and Hilton ICML 2023); (g) EN/ZH agreement and lint caps on each changed record (run research.py lint --ids for them); (h) links: run cd ${W} && python3 -B tools/research/research.py links and report any broken link in a changed file. Default to reporting a finding when unsure, with your evidence; give an exact fix.`, { label: 'skeptic', phase: 'Review', schema: FINDING }),
  () => agent(`${CONTEXT}

Your task: completeness. Search the live account for remaining instances of the same ten errors that DF1b did not change. The live account is: theories/becoming/ (ONE-PAGE.md and .zh.md, THE-THEORY-OF-BECOMING.md and .zh.md, chapters/*.md, review/*.md), GLOSSARY.md, the record JSON files theories/becoming/results/records/*.json (every field except history and references; the .md files beside them are generated from the JSON and need no separate report), and the README.md of each folder under experiments/. Frozen material is not live: theories/becoming/history/, any PREDICTIONS-*.md, sources/, and _process/ studies. Look for: MQ6 counted as a test of T2; T1's MQ6 evidence naming only the timing; Hordijk and Steel 2012 for food-generated or RAF sets; a namespace cited as if it were a theorem where a witness is meant, in the Closing module or similar (e.g. "Closing.Onset" alone); limits claimed where Lean gives finite bounds, especially in fixation-with-selection, drift-offspring-sampled and other drift or fixation records and their chapter rows; "Nei and Felsenstein (1971)" as one work; Landauer's bound read as a floor of exergy destroyed, of entropy produced or of DestroysAtLeast; "first law" meaning thermodynamics' first law without saying so (the spine's sense, Flow.Gainless, needs no qualifier); links from live text to theories/becoming/history/THE-THEORY-OF-BECOMING.md for theses T1-T8; Gao, Schulman and Hilton with year 2022. For each instance give the file, the exact quote, and an exact fix in the account's style (EN and ZH where both exist). Also say which places you searched and found clean.`, { label: 'completeness', phase: 'Review', schema: FINDING }),
])
return { skeptic, critic }
