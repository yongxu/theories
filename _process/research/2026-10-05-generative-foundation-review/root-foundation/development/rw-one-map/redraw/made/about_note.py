# AI-written, 12 November 2026. The page's note on how far it goes named two paths and no names; it now says how the
# three later paths, the names others gave and the later tests were written and checked. Edits the worktree's module.
M = '/Users/ren/tmp/rw/map2/wt/tools/research/map_sheet.py'
s = open(M, encoding='utf-8').read()


def sub(a, b):
    global s
    assert s.count(a) == 1, (s.count(a), a[:70])
    s = s.replace(a, b)


sub("'anchored': sum(1 for b in geo['boxes'].values() if b.get('anchors')), 'tests': len(tests), 'paths': len(paths),",
    "'anchored': sum(1 for b in geo['boxes'].values() if b.get('anchors')), 'tests': len(tests), 'paths': len(paths),\n"
    "              'names': sum(len(b.get('known_en') or []) + len(b.get('unlike_en') or []) for b in geo['boxes'].values()),\n"
    "              'named': sum(1 for b in geo['boxes'].values() if b.get('known_en') or b.get('unlike_en')),")
# English
sub("and these changes have not been set against the Lean again. '",
    "and these changes have not been set against the Lean again. The other %(later)d paths were each written by an AI reader from the arrows\\' sentences, and set by a second against those sentences and, where a step turns on the law, against the Lean. '")
sub("and then set against the record once by a second reader. '",
    "and then set against the record once by a second reader; the later ones were then shortened, and the short text was set against the record again. "
    "The %(names)d names at %(named)d boxes come from the account\\'s readings of other traditions and fields; a second reader set each against the reading it comes from and corrected most. "
    "Such a name says a place is close to what its source describes, or is told apart from it; it is not the source\\'s agreement. '")
sub("%(left)d of its 66 tests, and most of the names other traditions and fields gave these places.') % dict(c, left=66 - c['tests'])",
    "%(left)d of its 66 tests, and most of its readings of other traditions and fields.') % dict(c, left=66 - c['tests'], later=c['paths'] - 2)")
# Chinese
sub("但这些改动没有再对着 Lean 核过。'",
    "但这些改动没有再对着 Lean 核过。另外 %(later)d 条路，各由一位 AI 读者照着箭头的句子写成，再由第二位读者对着这些句子核过；哪一步取决于定律，就对着 Lean 核。'")
sub("再由第二位读者对着记录核过一遍。'",
    "再由第二位读者对着记录核过一遍；后来放上的几个随后改短了，短的文字又对着记录核了一遍。"
    "%(named)d 个方框上的 %(names)d 个名字，出自这套理论对别的传统和学科的解读；第二位读者把每一个对着它出自的那条解读核过，大多改正了。"
    "这样一个名字，说的是这个地方和出处讲的相近，或者有别；不是说出处赞同它。'")
sub("66 个检验里的 %(left)d 个，以及别的传统和学科给这些地方起的名字里的大部分。') % dict(c, left=66 - c['tests'])",
    "66 个检验里的 %(left)d 个，以及它对别的传统和学科的解读里的大部分。') % dict(c, left=66 - c['tests'], later=c['paths'] - 2)")
sub("    if kn: out += ['%s: %s.' % (s['known'], '; '.join(kn)), '']\n    out += [s['unmarked']",
    "    if kn: out += ['%s: %s%s' % (s['known'], '; '.join(kn), '。' if lang == 'zh' else '.'), '']\n    out += [s['unmarked']")
open(M, 'w', encoding='utf-8').write(s)
print('ok')
