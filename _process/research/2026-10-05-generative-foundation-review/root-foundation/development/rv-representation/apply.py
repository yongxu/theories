#!/usr/bin/env python3
"""RV: apply the drafters' edits (with the coordinator's changes) in the worktree. Each old string must occur once."""
import json, re, subprocess, sys
WT = '/Users/ren/tmp/rv/wt'
D = json.load(open('/Users/ren/tmp/rv/drafts/drafts.json'))
edits = []
for k in ('root', 'fronts', 'catalogues'):
    for i, e in enumerate(D[k]['edits']):
        edits.append((k, i, e['file'], e['old'], e['new']))

def change(key, i, new):
    for n, (k, j, f, o, _) in enumerate(edits):
        if k == key and j == i:
            edits[n] = (k, j, f, o, new); return
    raise KeyError((key, i))

# fronts[0]: the opening carries the note's standing and COLLECTIVE-DIRECTION's, nothing wider.
change('fronts', 0, "To achieve alignment, we need a foundation that makes coordination possible, and I hold that this foundation "
       "supplies that too: a thesis about how coordination forms, not a theorem, and no test yet has human participants.")
change('fronts', 2, "what an optimized selection draws down, the sentence that the selection laws restate the proxy problem, and the "
       "standing of the claim that this foundation supplies what makes coordination possible, a thesis and not a theorem (\"This is a foundation\")")
change('fronts', 5, "the note grows by 72 words, for the frozen tests as they fell. The body is unchanged.\n\n"
       "On 7 November one sentence of the body was revised in place, on argument, after a review of what the pages around the account "
       "tell a reader (board item RV) found the opening saying, as if settled, that this foundation supplies what makes coordination "
       "possible, where its own note on that sentence calls it a thesis about how coordination forms, not a theorem. The sentence now "
       "says \"I hold\" and carries that standing in the body, in the note's words and COLLECTIVE-DIRECTION §5's (no test has human "
       "participants) (the paragraph beginning \"This is a foundation\"). The notes are unchanged.")
# fronts[14]: the first screen names no AI (its test); the verdict is the method chapter's, with its search not exhaustive.
change('fronts', 14, "showing each Lean statement follows from its premises, not that they hold. By [the method chapter's verdict]"
       "(../../theories/becoming/chapters/08-METHOD.md#known-results), none of the central results is new mathematics: each is "
       "near-definitional or a known result restated, by a search that was not exhaustive.")
NOW = subprocess.run(['git', '-C', WT, 'rev-list', '--count', 'HEAD'], capture_output=True, text=True).stdout.strip()
change('fronts', 17, f"The repository's first commit is from 6 September 2026, and it holds {int(NOW):,} commits in all by 7 November 2026; "
       "the formal theory has been built since October 2026.")

# Folder banners: one template; the date is when the folder's own status paragraph last changed (else its last revision).
dates = {'alignment-selection-on-cognition': '29 September 2026', 'meta-attractor': '8 October 2026', 'relational-self-and-datong': '4 October 2026'}
design = {'wamotopia-and-the-wamo-protocol', 'evolving-community-swarms', 'human-solutions-museum', 'the-fork-and-cooperative-infrastructure',
          'architecture-for-a-living-earth'}
for e in D['folders']['edits']:
    f = e['file']; slug = f.split('/')[1]
    first = e['old']
    assert e['new'].endswith('\n\n' + first), f
    date = dates.get(slug, '25 September 2026')
    banner = ("<!-- Banner of 7 November 2026 (RV), AI-written navigation; the folder's text below it is unchanged. -->\n"
              f"> An earlier theory folder, first written before the live account, [the theory of becoming](../becoming/ONE-PAGE.md). "
              f"Its own assessments of standing and readiness are its view as of {date}, not the live account's. "
              + ("[Chapter 5](../becoming/chapters/05-COLLECTIVES.md#11-joint-plans-and-applications) counts it among applications "
                 "elsewhere: design programmes, not results; correspondence not established. " if slug in design else '')
              + f"What became of its claims is in [the crosswalk](../becoming/results/atlas/CROSSWALK.md#cxg-{slug}), where every entry "
              "is an AI reading with no person's behind it and not carried is an outcome, not a defect; [the index](../README.md) "
              "lists the sixteen earlier folders.")
    edits.append(('folders', 0, f, first, banner + '\n\n' + first))

# The coordinator's own: lines the drafters left outside their groups.
edits += [
 ('own', 0, '_process/REPOSITORY-LAYOUT.md', 'September syntheses, in place, with a generated status header',
  'September syntheses, in place, each under a banner; their index, theories/README.md, is generated from the crosswalk'),
 ('own', 1, '_process/REPOSITORY-LAYOUT.md', 'the argument in the canonical chapter or the live study',
  'the argument in its home section of the eight chapters, or the live study'),
 ('own', 2, 'tools/research/navigation.py',
  "What changes only through a proposal is the author\\'s own text and authorizations: '\n                      'the body of the opening, the curated generativity chain, the goal scopes and their states, and the licence. ",
  "What changes only through a proposal is the author\\'s authorizations: the goal scopes and their states, and the licence. '\n                      'The body of the opening and the curated generativity chain began as the author\\'s text and are revised on argument, each revision named where it is made. "),
 ('own', 3, 'tools/research/navigation.py', "the open programme of the canonical chapter, and what lies beyond the readings",
  "the open programme in method (chapter 8), and what lies beyond the readings"),
]

by_file = {}
for k, i, f, o, n in edits:
    by_file.setdefault(f, []).append((k, i, o, n))
bad = []
for f, es in by_file.items():
    p = f'{WT}/{f}'
    s = open(p, encoding='utf-8').read()
    for k, i, o, n in es:
        c = s.count(o)
        if c != 1:
            bad.append((f, k, i, c, o[:80])); continue
        s = s.replace(o, n, 1)
    if '--dry' not in sys.argv:
        open(p, 'w', encoding='utf-8').write(s)
print('files', len(by_file), 'edits', len(edits), 'bad', bad)
