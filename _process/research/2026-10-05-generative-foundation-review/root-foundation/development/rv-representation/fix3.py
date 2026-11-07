#!/usr/bin/env python3
"""RV round-1 fixes from the English reader. Each old string must occur once."""
import json
WT = '/Users/ren/tmp/rv/wt'
def edit(path, pairs):
    p = f'{WT}/{path}'; s = open(p, encoding='utf-8').read()
    for a, b in pairs:
        assert s.count(a) == 1, (path, s.count(a), a[:90])
        s = s.replace(a, b, 1)
    open(p, 'w', encoding='utf-8').write(s)

# M1, L1: the label goes on the note's thesis; "untested here", not a clause lifted from the collective question.
edit('theories/becoming/OPENING.md', [
 ("and I hold that this foundation supplies that too: a thesis about how coordination forms, not a theorem, and no test yet has human participants. Coordination needs understanding to be shared first, and what anyone can check",
  "and I hold that this foundation supplies that too. Coordination needs understanding to be shared first, a thesis about how coordination forms, not a theorem, and untested here; and what anyone can check"),
 ("and the standing of the claim that this foundation supplies what makes coordination possible, a thesis and not a theorem (\"This is a foundation\")",
  "that this foundation supplies what makes coordination possible, now held in the first person, and that coordination needs understanding shared first, a thesis and not a theorem, untested here (\"This is a foundation\")"),
])
edit('drafts/2026-10-10-opening/README.md', [
 ("The sentence now says \"I hold\" and carries that standing in the body, in the note's words and COLLECTIVE-DIRECTION §5's (no test has human participants) (the paragraph beginning \"This is a foundation\"). The notes are unchanged.",
  "The sentence now says \"I hold\", and the next one gives the thesis that coordination needs understanding shared first its standing in the body, in the note's words (a thesis about how coordination forms, not a theorem), with \"untested here\": no test of the work has people in it (COLLECTIVE-DIRECTION §5) and no check run inside the work can show that it serves shared understanding and coordination (08 §12) (the paragraph beginning \"This is a foundation\"). The notes are unchanged."),
])
# M4: the screen's verdict sentence, as ONE-PAGE words it, without the word its test forbids.
edit('_process/navigation/README-FIRST-SCREEN.md', [
 ("By [the method chapter's verdict](../../theories/becoming/chapters/08-METHOD.md#known-results), none of the central results is new mathematics: each is near-definitional or a known result restated, by a search that was not exhaustive.",
  "A review that read each Lean statement against the literature it knew, not exhaustively, finds [none of the central results new mathematics](../../theories/becoming/chapters/08-METHOD.md#known-results): each is near-definitional or a known result restated."),
])
# M2: the link label in the config.
edit('_process/research-config.json', [
 ('"label": "Method, no reading open; the texts that change only by proposal"',
  '"label": "Method, no reading open; how the opening and the generativity chain are revised"'),
])
# L7: what waits on the author, as AGENTS lists it with the scopes; where each revision is named.
edit('tools/research/navigation.py', [
 ("What changes only through a proposal is the author\\'s authorizations: the goal scopes and their states, and the licence. '\n"
  "                      'The body of the opening and the curated generativity chain began as the author\\'s text and are revised on argument, each revision named where it is made. ",
  "What waits on the author is his authorizations and releases: the goal scopes and their states, the licence, pushing to the public remote, '\n"
  "                      'who is sent what, and money or machine time for runs. The body of the opening and the curated generativity chain began as the author\\'s text '\n"
  "                      'and are revised on argument, the opening\\'s revisions named under its heading and the chain\\'s in its maintenance record. "),
 # L8
 ("'; the opening, in its author\\'s first person and revised in place since (each revised passage named under its heading), is '",
  "'; the opening, in its author\\'s first person and revised in place since 1 November 2026 (each revised passage named under its heading), is '"),
])
# M6, L4, L5: MAP.
edit('MAP.md', [
 ("and it holds 6,074 commits in all by 7 November 2026;", "and it holds more than 6,000 commits by 7 November 2026;"),
 ("(the grammar's concepts, the results, the Lean modules and the corpus texts, with the edges between them)",
  "(the grammar's concepts, the results, the Lean modules, the corpus texts, the chapter sections that state results and the review dossiers, with the edges between them: a dependence, a citation or a registered reading, not an agreement in meaning)"),
 ("about twenty-five to thirty-five minutes,", "about twenty-eight to thirty-seven minutes,"),
])
edit('theories/becoming/ONE-ARGUMENT.md', [("*About twenty-five to thirty-five minutes to read.*", "*About twenty-eight to thirty-seven minutes to read.*")])
edit('theories/becoming/THE-THEORY-OF-BECOMING.md', [("(about twenty-five to thirty-five minutes)", "(about twenty-eight to thirty-seven minutes)")])
# L6: the Open items are some of 06's.
p = f'{WT}/_process/goals/chinese-sources-and-becoming.json'
g = json.loads(open(p, encoding='utf-8').read()); o = g['overview']
a, b = "Also open (06's Open):", "Also open, among others in chapter 6's Open:"
assert o['next_step']['en'].count(a) == 1; o['next_step']['en'] = o['next_step']['en'].replace(a, b)
a, b = "另有未决（见第六章未决）：", "另有未决（第六章未决中尚有他项）："
assert o['next_step']['zh'].count(a) == 1; o['next_step']['zh'] = o['next_step']['zh'].replace(a, b)
open(p, 'w', encoding='utf-8').write(json.dumps(g, ensure_ascii=False, indent=2) + '\n')
# L9: the stub's heading, its anchor kept.
edit('tools/research/registry.py', [("heading('#', 'Canonical result register', '成果登记表 Canonical result register')",
                                    "heading('#', 'The earlier result register', '成果登记表 Canonical result register')")])
# L10: a current home for revision.
edit('tools/research/reading_catalogue.py', [
 ("· [Organization within organisms](../chapters/04-LIFE.md#organization) |",
  "· [Organization within organisms](../chapters/04-LIFE.md#organization) · [Selection revising its lumping](../chapters/03-KNOWING.md#r-selection-when-the-lumping-changes) |"),
])
# M5: the re-point's reason names everything that changed in the files reread.
p = f'{WT}/_process/architecture/rebinds.jsonl'
lines = open(p, encoding='utf-8').read().split('\n')
last = [i for i, l in enumerate(lines) if l.strip()][-1]
r = json.loads(lines[last]); assert r['base'] == '804028391', r['base']
r['reason'] = ("RV, 7 November 2026, reread: 01-ROOT.md's paragraph before its first heading now says where the chapter sits exactly "
               "(its grammar imports no other module; the chapters are numbered for reading, not in an order of proof; about half its "
               "results use results homed later); in OPENING.md the header comment, the line under its heading and the dateline add 7 "
               "November to the dates of its in-place revisions, and one passage of the body (\"This is a foundation\") holds in the first "
               "person that the foundation supplies what makes coordination possible and gives the thesis that coordination needs "
               "understanding shared first its standing. Nothing these records say changes.")
lines[last] = json.dumps(r, ensure_ascii=False)
open(p, 'w', encoding='utf-8').write('\n'.join(lines))
print('ok')
