#!/usr/bin/env python3
"""WB: the live lines a search after the revision found still saying the old formula ("two premises", "a ranking
needs C or a premise in its place", "warrant open"), re-said in the revision's words. Each replacement is exact and
must match once (or the count given)."""
import json
import pathlib
import sys

ROOT = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else '.')


def rep(path, pairs):
    p = ROOT / path
    s = p.read_text(encoding='utf-8')
    for item in pairs:
        a, b, n = item if len(item) == 3 else (*item, 1)
        if s.count(a) == 0 and s.count(b) >= n:
            continue  # already applied
        if s.count(a) != n:
            raise SystemExit(f'{path}: {s.count(a)} of {a[:70]!r}, expected {n}')
        s = s.replace(a, b)
    p.write_text(s, encoding='utf-8')


C07 = '07-SIGNIFICANCE.md#scope-and-order'

rep('MAP.md', [
    ("Its ethics adds two premises it does not assert; for AI alignment",
     "Its ethics asserts no should: where it ranks courses it names two readings it does not assert, and its makers offer a way of seeing, not a verdict; for AI alignment"),
    ("The ethics rests on two premises with two roles, neither asserted: the continuation condition (from every standpoint, for anything, its continuation into the future has significance) fixes whose losses count, and calling widening better orders; whether either can be warranted is open.",
     "Where the account ranks courses it names two readings with two roles, neither asserted: the continuation condition (from every standpoint, for anything, its continuation into the future is counted) fixes whose losses count, and C, calling widening better, orders; no warrant from outside is sought."),
    ("then the ethics' two premises, the open question,", "then the ethics' two readings and its makers' offer, the open question,"),
])
rep('theories/becoming/chapters/08-METHOD.md', [
    ("The ethics rests on two premises with two roles, listed apart:", "Where a result ranks courses it names two readings with two roles, listed apart:"),
    ("The ethics' two premises, the continuation condition for scope and C for order, supply the scope-and-order row's input",
     "The two readings, the continuation condition for scope and C for order, supply the scope-and-order row's input"),
])
rep('theories/becoming/USES-EXAMPLES.md', [
    ("The ethics rests on its two premises either way, the continuation condition for scope and C for order.",
     "Either way, a ranking rests on the two readings, the continuation condition for scope and C for order."),
])
rep('theories/becoming/COLLECTIVE-DIRECTION.md', [
    ("it is the question's generative direction only under the two premises", "it is the question's generative direction only under the two readings"),
])
rep('theories/becoming/ONE-ARGUMENT.md', [
    ("| two premises, neither asserted; neither ranks a mixed case;", "| two readings, neither asserted; neither ranks a mixed case;"),
])
rep('theories/becoming/chapters/02-MAP.md', [
    ("nothing here ranks open rule-making above capture: that needs C or a premise in its place.",
     f"nothing here ranks open rule-making above capture: the account ranks only under a reading it names ([07 §4]({C07}))."),
    ("nothing here ranks a course: that needs C or a premise in its place.",
     f"nothing here ranks a course: the account ranks only under a reading it names ([07 §4]({C07}))."),
    ("Nothing here ranks a course: that needs C or a premise in its place.",
     f"Nothing here ranks a course: the account ranks only under a reading it names ([07 §4]({C07}))."),
])
rep('theories/becoming/chapters/03-KNOWING.md', [
    ("It pursues morality as appraisal of becoming under two premises, the continuation condition for scope and C for order ([07](07-SIGNIFICANCE.md));",
     "It pursues morality as appraisal of becoming, formed within it, ranking only under the readings it names, the continuation condition for scope and C for order ([07](07-SIGNIFICANCE.md));"),
])
rep('theories/becoming/chapters/05-COLLECTIVES.md', [
    ("[AI reading, D65; scope by the continuation condition, and a ranking needs C or a premise in its place (07 §4)]",
     "[AI reading, D65; scope by the continuation condition, and a ranking only under C or another named order (07 §4)]"),
])
rep('theories/becoming/chapters/06-CLASSICAL-TEXTS.md', [
    ("[第七章](07-SIGNIFICANCE.md)之意义与两个前提", "[第七章](07-SIGNIFICANCE.md)之意义与两种读法"),
    ("伦理的两个前提，延续之条件定范围、以广为愈定次序，都不断言", "排序所据的两种读法，延续之条件定范围、以广为愈定次序，都不断言"),
])
rep('tools/research/spine.py', [
    ("两个方框是伦理的两个'", "两个方框是排序结果所用的两种'"),
    ("f'前提，各在所用之处为假设，二者都不断言。徽标", "f'读法，各在所用之处为假设，二者都不断言。徽标"),
])
rep('theories/becoming/review/README.md', [
    ("whether the ethics' premises are located and stated at their strength,",
     "whether the two readings the ethics ranks under are located and stated at their strength,"),
])
rep('theories/becoming/review/README.zh.md', [
    ("伦理之诸前提是否放对了位置、放在恰当的强度上", "伦理排序所据的两种读法是否放对了位置、放在恰当的强度上"),
])
rep('theories/becoming/review/PHILOSOPHY.md', [
    ("the free parameter and the ethics' premises, supplied, which means entering as hypotheses;",
     "the free parameter and the readings a ranking names, supplied, which means entering as hypotheses;"),
    ("needs no step of invariance; ranking courses still needs C or a premise in its place (P-16).",
     "needs no step of invariance; P2 and P4 rank nothing, and a ranking of courses is under C or another named reading (P-16)."),
])
rep('theories/becoming/review/SCIENCES.md', [
    ("The account's ethics, which rests on two premises it does not assert, the continuation condition (for anything, its continuation has significance) for scope and C (widening what can form is better) for order, is not treated here",
     "The account's ethics, which asserts no should and ranks only under two readings it does not assert, the continuation condition (for anything, its continuation is counted) for scope and C (widening what can form is better) for order, is not treated here"),
    ("- **Premises of the ethics.** The theory names two premises for its ethics, the continuation condition (whose losses count) and C (that widening is better), and asserts neither.",
     "- **The readings the ethics ranks under.** The theory names two readings, the continuation condition (whose losses count) and C (that widening is better), and asserts neither; its ethics is its makers' offer, a way of seeing, not a verdict."),
])
rep('theories/becoming/review/CLASSICAL-TEXTS.md', [
    ("相当于理论的另一前提 C（以广为愈：能形成者更广，即为更好；它给出次序，对进程的排序需要它或一个代替它的前提；理论也不断言它）",
     "相当于理论的另一读法 C（以广为愈：能形成者更广，即为更好；它给出次序，凡排序者，以它或别一种所指名的次序排序；理论也不断言它）"),
    ("从“不宰”到“应当不宰”须两个前提：延续之条件定范围（谁的损失算数），以广为愈（C）定次序；经文与脊柱都没有给出，理论也不断言。",
     "从“不宰”到“应当不宰”，本论不走：它不断言任何应当；若要排序，须两种读法：延续之条件定范围（谁的损失算数），以广为愈（C）定次序；经文与脊柱都没有给出，理论也不断言。"),
])
rep('theories/becoming/review/BUDDHIST-THOUGHT.md', [
    ("- **延续条件与 C**：理论之伦理依两个前提，都不断言：延续条件（凡物向未来之延续皆有意义）定范围，即谁的损失算数；以广为愈（C）给出次序；对进程的排序需要它，或一个代替它的前提。",
     "- **延续条件与 C**：理论不断言任何应当；凡它排序之处，指名两种读法，都不断言：延续条件（凡物向未来之延续皆被计数）定范围，即谁的损失算数；以广为愈（C）给出次序。其伦理是作者所提供的一种看法，不是裁断。"),
    ("理论把续当作中性之结构，把评价留给两个前提（延续条件定范围，以广为愈 C 定次序，都不断言）；",
     "理论把续当作中性之结构，评价形成于续之中，排序只在两种读法之下（延续条件定范围，以广为愈 C 定次序，都不断言）；"),
    ("理论之伦理依两个前提：延续条件定谁之损失算数，以广为愈（C）定次序；二者都不断言。",
     "理论排序所据的两种读法：延续条件定谁之损失算数，以广为愈（C）定次序；二者都不断言。"),
])
rep('theories/becoming/THE-THEORY-OF-BECOMING.md', [
    ("That places C's premise more narrowly in this case and does not derive it; whoever ranks courses holds C or another order (",
     "That places C's premise more narrowly in this case and does not derive it ("),
])
rep('theories/becoming/THE-THEORY-OF-BECOMING.zh.md', [
    ("这是在这一情形中把 C 的前提更窄地安放，而不是使它得到根据；对进程的排序需要 C，或一个代替它的前提（",
     "这是在这一情形中把 C 的前提更窄地安放，而不是使它得到根据（"),
])
rep('theories/becoming/results/completion/COVERAGE.json', [
    ("the ethics adds two premises, the continuation condition for scope and C for order",
     "a ranking is under two named readings, the continuation condition for scope and C for order"),
])

# The lineage: its cut is 8 November; what came after is said as after the cut, and the one AI reading of the live
# account is re-said in its current words.
LIN = ROOT / 'theories/becoming/results/data/lineage.json'
d = json.loads(LIN.read_text(encoding='utf-8'))
AFTER_EN = (" After the cut, on 9 November 2026, the account set the warrant aside: its ethics asserts no should and ranks"
            " only under the readings a result names, and T8 became its makers' offer, a way of seeing, binding no one"
            " ([07 §8](becoming/chapters/07-SIGNIFICANCE.md#theses)).")
AFTER_ZH = ("截取之后，2026 年 11 月 9 日，本论把根据之问放下：其伦理不断言任何应当，只在一项结果所指名的读法之下排序；"
            "T8 成为本论之作者所提供的一种看法，不约束任何人（[07 §8](becoming/chapters/07-SIGNIFICANCE.md#theses)）。")
n = 0
for t in d['threads']:
    intro = t.get('intro', {})
    if intro.get('en', '').startswith('How the ethics came to its two premises'):
        intro['en'] += AFTER_EN
        intro['zh'] += AFTER_ZH
        n += 1
assert n == 1, n
OLD_EN = ("[AI reading] The live account keeps the move of declaring rather than deriving the normative step, in a different"
          " form: two premises stated and not asserted (the continuation condition for scope, C for order). The glossary"
          " gives 生生 one sense, \"life in the whole and its continuing generation\", and keeps it apart from generation"
          " (生成) and the grammar's «生生».")
NEW_EN = ("[AI reading] Until 9 November 2026 the live account kept the move of declaring rather than deriving the"
          " normative step, in a different form: two premises stated and not asserted (the continuation condition for"
          " scope, C for order). Since then it asserts no should and ranks only under readings a result names, and the"
          " glossary gives 生生 one sense, \"the continuation of life\", and keeps it apart from generation (生成) and the"
          " grammar's «生生».")
OLD_ZH = ("［AI 读法］现行之论以另一种形式保留了宣示而非推导规范一步的做法：两个陈述而不断言的前提（延续条件定范围，C 定次序）。"
          "术语表给生生一个意义，「life in the whole and its continuing generation」（整体中的生命及其持续的生发），并把它与生成、与文法的 «生生» 分开。")
NEW_ZH = ("［AI 读法］直到 2026 年 11 月 9 日，现行之论以另一种形式保留了宣示而非推导规范一步的做法：两个陈述而不断言的前提（延续条件定范围，C 定次序）。"
          "自那以后，它不断言任何应当，只在一项结果所指名的读法之下排序；术语表给生生一个意义，「the continuation of life」（生命之延续），并把它与生成、与文法的 «生生» 分开。")
s = json.dumps(d, ensure_ascii=False, indent=1)
raw = LIN.read_text(encoding='utf-8')
# keep the file's own layout: edit the text, not a re-serialization
raw2 = raw
for a, b in ((json.dumps(OLD_EN, ensure_ascii=False)[1:-1], json.dumps(NEW_EN, ensure_ascii=False)[1:-1]),
             (json.dumps(OLD_ZH, ensure_ascii=False)[1:-1], json.dumps(NEW_ZH, ensure_ascii=False)[1:-1])):
    assert raw2.count(a) == 1, a[:60]
    raw2 = raw2.replace(a, b)
for t in json.loads(raw)['threads']:
    intro = t.get('intro', {})
    if intro.get('en', '').startswith('How the ethics came to its two premises'):
        for lang, add in (('en', AFTER_EN), ('zh', AFTER_ZH)):
            old = json.dumps(intro[lang], ensure_ascii=False)[1:-1]
            assert raw2.count(old) == 1, lang
            raw2 = raw2.replace(old, json.dumps(intro[lang] + add, ensure_ascii=False)[1:-1])
json.loads(raw2)
LIN.write_text(raw2, encoding='utf-8')
print('done')
