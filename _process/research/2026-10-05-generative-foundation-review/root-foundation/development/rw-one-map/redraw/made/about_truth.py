# AI-written, 12 November 2026. The truth reader's nine repairs to the note on how far the map goes were written
# for the paragraph that the table has since replaced. This carries each of them into the table: the tests are
# counted by rows of the tests table (the fishers' two rounds are two), the names' sources are said to be mostly
# recalled and their Chinese forms unchecked, the part of the first path set against the Lean again is named, and
# the further sentences under the arrows and the sentences on staying are counted. Edits the worktree's module.
M = '/Users/ren/tmp/rw/map2/wt/tools/research/map_sheet.py'
s = open(M, encoding='utf-8').read()


def sub(a, b):
    global s
    assert s.count(a) == 1, (s.count(a), a[:80])
    s = s.replace(a, b)


# counts
sub("'kinds': dict(collections.Counter(p['kind'] for p in P)), 'ways': len(ways),",
    "'kinds': dict(collections.Counter(p['kind'] for p in P)), 'ways': len(ways),\n"
    "              'further': len(ways) - len(P), 'further2': sum(1 for p in P for w in p.get('more', []) if w.get('readers') == 2), 'further1': sum(1 for p in P for w in p.get('more', []) if w.get('readers') == 1),\n"
    "              'with_further': sum(1 for p in P if p.get('more')), 'records': len({rec for t in tests for rec in (t.get('records') or [t['test']])}),")
sub("    c.update(left=c['all_tests'] - c['tests'], later=c['paths'] - 2)\n", "    c.update(left=c['all_tests'] - c['records'], later=c['paths'] - 2)\n")
# English
sub("%(nolean)d have no Lean statement (they are readings, or say one box is a case of another)'],",
    "%(nolean)d have no Lean statement (they are readings, or say one box is a case of another). Under %(with_further)d of the arrows stand %(further)d further sentences, %(further2)d read twice and %(further1)d once, each marked. "
    "Who read the %(stays)d sentences on staying at a box was not recorded'],")
sub("    'the sentences they stand on, by further AI readers; not the Lean again'],",
    "    'the sentences they stand on, by further AI readers; not the Lean again, except the first six steps of the first path and the arrow from the lock to what is not counted, which one AI reader has since set against the Lean, correcting three of those steps and that arrow'],")
sub("   ['The %(tests)d tests laid on the map', 'AI readers, from each test\\'s own record or an earlier summary of it',",
    "   ['The %(tests)d tests laid on the map (%(records)d rows of the account\\'s table of tests: the two rounds with the fishers are two)', 'AI readers, from each test\\'s own record or an earlier summary of it',")
sub("   ['The sentence or two that opens each test; the names listed under each path; the cast of the first path', 'the coordinating AI',\n"
    "    'the records, the boxes\\' full names and the Lean, by a second AI reader'],",
    "   ['The sentence or two that opens each test; the names listed under each path; the opening paragraph; the cast of the first path', 'the coordinating AI',\n"
    "    'the records of the tests, the boxes\\' names with their readings, the first path with its arrows, and the Lean, by a second AI reader, who corrected most'],")
sub("   ['The %(names)d names others gave, at %(named)d boxes', 'taken from the account\\'s readings of other traditions and fields',\n"
    "    'the reading each comes from, by a second AI reader, who corrected most'],",
    "   ['The %(names)d names others gave, at %(named)d boxes', 'taken from the account\\'s readings of other traditions and fields, most of them AI readings of a source recalled, not reread',\n"
    "    'the reading each comes from, by a second AI reader, who corrected most. Their Chinese forms are the AI readers\\' and are not yet checked against Chinese editions'],")
sub("'rest': 'A name others gave says a place is close to what its source describes, or is told apart from it; it is not the source\\'s agreement.",
    "'rest': 'A name others gave says a place is close to what its source describes, sometimes only within limits its reading states, or is told apart from it; it is not the source\\'s agreement.")
# Chinese
sub("%(nolean)d 条没有 Lean 命题（它们是解读，或者说一个方框是另一个的特例）'],",
    "%(nolean)d 条没有 Lean 命题（它们是解读，或者说一个方框是另一个的特例）。其中 %(with_further)d 条箭头下面另有 %(further)d 句，%(further2)d 句两位读者核过，%(further1)d 句一位，各自标明。"
    "“留在某个方框”的 %(stays)d 句由哪些读者核过，没有记下'],")
sub("   ['箭头上的短标签、头两条路的每一步、一些方框和行的名字', '负责协调的 AI', '它们依据的句子，由另外的 AI 读者核过；没有再对着 Lean 核'],",
    "   ['箭头上的短标签、头两条路的每一步、一些方框和行的名字', '负责协调的 AI', '它们依据的句子，由另外的 AI 读者核过；没有再对着 Lean 核，只有第一条路的头六步，和从定局到“用掉的不在账上”的那条箭头，后来由一位 AI 读者对着 Lean 核过，其中三步和这条箭头改正了'],")
sub("   ['放在图上的 %(tests)d 个检验', 'AI 读者，照检验自己的记录或早先的一份摘要',",
    "   ['放在图上的 %(tests)d 个检验（在这套理论的检验表里占 %(records)d 行：渔民的两轮算两行）', 'AI 读者，照检验自己的记录或早先的一份摘要',")
sub("   ['每个检验开头的一两句；每条路下面列的说法；第一条路开头的“这条路上有什么”', '负责协调的 AI', '记录、方框上完整的说法和 Lean，由第二位 AI 读者核过'],",
    "   ['每个检验开头的一两句；每条路下面列的说法；这一页开头的那一段；第一条路开头的“这条路上有什么”', '负责协调的 AI', '检验的记录、方框上的说法和它们出自的解读、第一条路和它的箭头，还有 Lean，由第二位 AI 读者核过，大多改正了'],")
sub("   ['%(named)d 个方框上别处的 %(names)d 个说法', '取自这套理论对别的传统和学科的解读', '各自出自的那条解读，由第二位 AI 读者核过，大多改正了'],",
    "   ['%(named)d 个方框上别处的 %(names)d 个说法', '取自这套理论对别的传统和学科的解读，其中多数是 AI 凭对出处的记忆写的，没有重读原书', '各自出自的那条解读，由第二位 AI 读者核过，大多改正了。它们的中文写法出自 AI 读者，还没有对着中文版本核过'],")
sub("'rest': '别处的一个说法，说的是这个地方和出处讲的相近，或者有别；不是说出处赞同它。",
    "'rest': '别处的一个说法，说的是这个地方和出处讲的相近（有的只在解读写明的限度之内），或者有别；不是说出处赞同它。")
open(M, 'w', encoding='utf-8').write(s)
print('ok')
