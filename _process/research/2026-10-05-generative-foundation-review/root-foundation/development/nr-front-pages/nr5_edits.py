"""NR, fifth round: the overview's §7 summarizes IV3k (need and feeding read with time), GS4 (two lines
that share a condition) and GS5 (the class of being joined), in English and Chinese.

Exact replacements that must match once, applied to HEAD's text. Run from the repository root:
python3 nr5_edits.py [--check].
"""
import sys
from pathlib import Path

EN_NEW = (
    "Read with time, need reaches only what is active while the need lasts, never what comes only after. "
    "Proved on the World model: over flows in which only active formations give, a formation active at no step of a "
    "stretch is needed across it exactly where no such flow lets the consumer draw past the stock, so need reaches only "
    "what is active within the stretch and nothing active only after it, while a consumer drawing without end needs "
    "giving without end. A feeding closure read with time up to a step holds only what is active by then; read across "
    "every step it can run past the end of what it carries, holding a later feeder that the earlier formation never "
    "needs (a witness; [need and feeding with time](chapters/07-SIGNIFICANCE.md#r-need-and-feeding-read-with-time)).\n\n"
    "On the root, a line reaches another family through a condition its members affect, not through a cause they only "
    "share. Proved on the root, in witnesses: where two family lines share a condition that the members affect, the line "
    "under the full class from a member of the first family reaches the second family's member that the condition later "
    "feeds, while under the class \"a member or not\" it reaches no member of the second family; where the members only "
    "feed from a condition they do not affect, a common cause, no line reaches across "
    "([a shared condition](chapters/07-SIGNIFICANCE.md#r-reach-through-a-shared-condition)). Proved for every type: the "
    "class of being joined, defined from the net alone, has 缘 itself as its continuation, so its lines reach exactly what "
    "lines under the full class reach, and it is the finest class under which every condition is a continuation; a finer "
    "constant class can still reach as far (witnesses; "
    "[the class of being joined](chapters/07-SIGNIFICANCE.md#r-the-class-of-being-joined)). Held de se along such a "
    "line, the presupposition of one's continuation reaches what one conditions and what that conditions in turn, not "
    "what only conditions one, with no step of invariance; whether one's own line runs under such a class or an "
    "organism's is the de se question, and that the actual unfolding is joined is a correspondence, not shown "
    "[AI reading].\n\n"
)

ZH_NEW = (
    "以时间来读，需要只到达在需要持续之时活跃者，从不到达只在其后才出现者。在世界模型上证明：在只有活跃形成给予的流上，"
    "一个在一段之中任何一步都不活跃的形成，恰在没有这样的流让消耗者取用超过存量之处，才在这一段上被需要；所以需要只到达"
    "在这一段之内活跃者，而不到达只在其后活跃者；一个无尽取用的消耗者，需要无尽的给予。以时间来读、直到某一步的供给闭包，"
    "只含到那时为止活跃者；跨越每一步来读，它可以越过它所承载者的终结，含有一个较早的形成从不需要的较晚的供给者"
    "（一个见证；[以时间来读的需要与供给](chapters/07-SIGNIFICANCE.md#r-need-and-feeding-read-with-time)）。\n\n"
    "在根上，一条相续经由其成员所影响的一个缘到达另一个家族，而不经由它们只是共有的一个原因。在根上、以见证证明："
    "在两条家族相续共有一个成员们所影响的缘之处，从第一个家族的一个成员出发、在全类之下的相续，到达该缘后来所供给的"
    "第二个家族的成员；而在“是成员与否”这个类之下，它到达不了第二个家族的任何成员；在成员们只是取食于一个它们不影响的缘、"
    "即一个共同原因之处，没有任何相续越过去（[共有的缘](chapters/07-SIGNIFICANCE.md#r-reach-through-a-shared-condition)）。"
    "对一切类型证明：被联结之类（`«同族» R «一»`）只由网来定义，它的续就是缘本身，所以它的相续恰好到达全类之下的相续所到达者，"
    "而它是使每一个缘都是续的最细的类；一个更细的有常之类仍可以到达同样远（见证；"
    "[被联结之类](chapters/07-SIGNIFICANCE.md#r-the-class-of-being-joined)）。以从己方式沿这样一条相续持有，"
    "自身延续的预设到达自己所缘者以及它再所缘者，而不到达只是缘自己者，无需不变之步；自己的相续是在这样一个类之下进行，"
    "还是在一个有机体的类之下进行，是从己的问题；而实际的展开在此意义上是联结的，这是一个对应，尚未表明［AI 读法］。\n\n"
)

EDITS = {
    'theories/becoming/THE-THEORY-OF-BECOMING.md': [
        ("\n\nWidening is exactly what every valuer who counts everything positively ranks higher;",
         "\n\n" + EN_NEW + "Widening is exactly what every valuer who counts everything positively ranks higher;"),
    ],
    'theories/becoming/THE-THEORY-OF-BECOMING.zh.md': [
        ("\n\n扩大恰好就是每一个把一切都计为正的评价者都排得更高者；",
         "\n\n" + ZH_NEW + "扩大恰好就是每一个把一切都计为正的评价者都排得更高者；"),
    ],
}


def apply(text, path):
    for old, new in EDITS[path]:
        n = text.count(old)
        if n != 1:
            raise SystemExit(f'{path}: {n} matches for {old[:70]!r}')
        text = text.replace(old, new)
    return text


if __name__ == '__main__':
    check = '--check' in sys.argv
    for path in EDITS:
        p = Path(path)
        new = apply(p.read_text(), path)
        if not check:
            p.write_text(new)
        print(('checked ' if check else 'applied ') + path)
