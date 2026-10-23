"""NR, second round: the line of the argument, each law's point first, a running example, gate in the glossary.

Each edit is an exact replacement that must match once. `apply(text, path)` is used on the working
files and again on HEAD's text at commit time, so that another session's uncommitted lines in the
same pages stay out of this item's commit. Run: python3 nr2_edits.py [--check] (from the repository root).
"""
import sys
from pathlib import Path

ONE_EN_ARC = (
    "**The line of the argument** (how the results connect, an AI reading). Anything goes on only as continuation, "
    "and a pattern, a life among them, outlasts its parts by renewal: old parts end and new ones begin. Renewal can be "
    "drawn down: takers each within what is renewed can together exceed it, and end it with everything that depends on it. "
    "What ends it can lie beyond what couples into any of them, and a selection, whether a knower, a training run, a market "
    "or an optimizer, reaches only what couples into it; with room, an optimum drains what lies beyond as far as any choice "
    "it has would. So whose losses count turns on a question about relations, how far what each continues with reaches, "
    "which the dynamics leave open; and calling the wider course better is a further premise. The ethics "
    "names both premises and asserts neither; under them it argues for one direction, 生生, life in the whole and its "
    "continuing generation, compared by widening. The proofs carry the account exactly to that edge, so that any reader, "
    "human or machine, can check how far it reaches."
)

ONE_ZH_ARC = (
    "**论证的主线**（各结果如何相连，一种 AI 读法）。任何东西都只作为续而继续下去；一个样式，生命也在其中，经由更新而比它的部分"
    "活得更久：旧的部分终止，新的部分开始。更新可以被耗尽：各个取用者各自都在所更新者之内，合起来却可以超出它，并终结它以及依存于它的一切。"
    "终结它的东西，可以位于耦合进任何一个取用者的东西之外；而一个选择，无论是认知者、一次训练、一个市场还是一个优化者，只到达耦合进它的东西；"
    "有余地时，一个最优解把这之外者耗竭到它所能作的任何选择所耗竭的程度。所以，谁的损失算数，归结为一个关于关系的问题：每一者与之一同继续的东西延伸多远，"
    "而动力学让这一点保持开放；把较广的进程称为更好，则是另一个前提。伦理写明这两个前提，对二者都不断言；在它们之下，它论证一个方向："
    "以扩大来比较的生生，即整体之中的生命及其不断的生成。诸证明把这一说明恰好带到这条边界，使任何读者，人或机器，都能检验它到达多远。"
)

OV_EN_ARC = (
    "## The line of the argument\n\n"
    "How the results connect, read as one line [AI reading]. Anything goes on only as continuation relative to a class, and "
    "a pattern outlasts its parts by renewal (§1). At two grains a course generates, keeps or degenerates, and a renewal can "
    "be drawn down: takers each within what is renewed can together end it and what depends on it (§2, §5). Whether anything "
    "sees this coming depends on what couples into it: a selection, whether a knower, a training run, a market or an "
    "optimizer, reaches only what couples into its selector (§3), and with room an optimum drains what lies beyond as far as "
    "any choice it has would (§5). Life is where continuation renews its own conditions, and descent selects through the same "
    "flow (§4). So whose losses count turns on how far what each continues with reaches, which the dynamics leave open, "
    "and calling the wider course better is a further premise; the ethics names both and asserts neither (§7). The classical texts are where the grammar's terms "
    "come from (§6), and the method says what each standing means and where proof stops (§8). The proofs carry the account "
    "exactly to the edge where the dynamics stop deciding, so that any reader, human or machine, can check how far it "
    "reaches. A fished stock runs through §§2, 3, 5 and 7 as an illustration; it proves nothing, and the frozen tests of T2 "
    "are on fish stocks."
)

OV_ZH_ARC = (
    "## 论证的主线\n\n"
    "各结果如何相连，读作一条线［AI 读法］。任何东西都只作为相对于一个类的续而继续下去，一个样式经由更新而比它的部分活得更久（§1）。"
    "以两种粒度去读，一个进程生成、守或退化；一个更新可以被耗尽：各个取用者各自都在所更新者之内，合起来却可以终结它以及依存于它者（§2，§5）。"
    "是否有什么能预见这一点，取决于什么耦合进它：一个选择，无论是认知者、一次训练、一个市场还是一个优化者，只到达耦合进其选择者的东西（§3）；"
    "有余地时，一个最优解把外部耗竭到它所能作的任何选择所耗竭的程度（§5）。生命是续更新其自身之缘的地方，而世系经由同一个流进行选择（§4）。"
    "所以谁的损失算数，取决于每一者与之一同继续的东西延伸多远，而动力学让这一点保持开放；把较广的进程称为更好，是另一个前提；伦理写明二者，对二者都不断言（§7）。"
    "古文是文法术语的来源（§6），方法说明每一种地位意味着什么、证明止于何处（§8）。诸证明把这一说明恰好带到动力学不再作出决定的那条边界，"
    "使任何读者，人或机器，都能检验它到达多远。一个被捕捞的鱼类种群作为例示贯穿 §§2、3、5 与 7；它不证明任何东西，而 T2 的冻结检验正是在鱼类种群上进行的。"
)

EDITS = {
    'theories/becoming/ONE-PAGE.md': [
        ("**The ethics.** No statement that reads only the represented dynamics entails that anything's continuation has significance: how things go, as represented, does not settle what matters. With no premise,",
         "**The ethics.** Read as lying within what a center continues with along a relation, the continuation condition (for anything, its continuation has significance) is a statement about relations: it holds exactly where every center's closure along that relation is the whole. What the represented dynamics leave open is which relation is a center's own; supplied instead as a free predicate that nothing else reads, significance is fixed by no statement about the dynamics, by construction. With no premise,"),
        ('*the continuation condition* (for anything, its continuation has significance) fixes whose losses count',
         '*the continuation condition* fixes whose losses count'),
        ("without first assuming that becoming is good. Its laws are proved in Lean; its readings, conjectures and premises are labelled as such.\n\n",
         "without first assuming that becoming is good. Its laws are proved in Lean; its readings, conjectures and premises are labelled as such.\n\n"
         + ONE_EN_ARC + "\n\n"),
        ("read at two grains, a pattern's course",
         "read at two grains (a fine class for the parts, a coarse one for the pattern), a pattern's course"),
        ("a web of conditions with amounts and discrete steps, each law with its own hypotheses:",
         "a web of conditions with amounts and discrete steps. Each item gives its point first, then the laws, each with its own hypotheses:"),
        ("- *Change and return.* Arising and ceasing are one change read three ways, and for a decided property of a finite family, coming to be recurs exactly when ceasing does. Within finitely many configurations a law loses nothing exactly where every configuration comes back;",
         "- *Change and return.* **Coming to be and ceasing keep pace, and in a finite world a law that merges nothing brings every state back.** Arising and ceasing are one change, read of activity, dependence and standing, and for a property settled yes or no at each member of a finite family, coming to be recurs exactly when ceasing does. Within finitely many configurations a law merges no two of them exactly where every configuration comes back;"),
        ("- *What ends a pattern.* Continued arising needs renewal. Takers each within what is given can together exceed it, and where the renewal depends on what it renews, the excess ends the renewal and whatever depends on it. Under a standing draw, a condition whose giving is read off its level holds exactly from a least level up, within the levels the law states: the regime's point of no return; around loops of couplings acting at every step, the most difference that can arrive grows exponentially; a rule can capture what it governs, and in a stated model the lock survives the loss that accrues under it",
         "- *What ends a pattern.* **A renewal can be drawn past its point of no return by takers none of whom overdraws.** Continued arising needs renewal. Takers each within what is given can together exceed it, and where the renewal depends on what it renews, the excess ends the renewal and whatever depends on it. A condition whose giving depends on its own level has a point of no return: under a standing draw it holds exactly from a least level up, within the levels the law states. Around loops of couplings acting at every step, the most difference that can arrive grows exponentially; and a rule read from the share it raises can lock onto it, the lock outlasting, in a stated model, the loss that accrues under it"),
        ("- *Knowing.* A selection reaches exactly",
         "- *Knowing.* **A knower is part of what it knows, and nothing reaches it except along its relations.** A selection reaches exactly"),
        ("a model of structure and change is one lumping of states ([knowing]",
         "a model of structure and change is one lumping of states, a map that treats some states as the same ([knowing]"),
        ("- *Life and evolution.* Arising replenishes;",
         "- *Life and evolution.* **Evolution's classical laws hold, bounded by the flow that feeds life.** Arising replenishes;"),
        ("- *Optimization.* Where there is room, an optimum lowers",
         "- *Optimization.* **An optimizer drains what lies beyond its couplings, as far as any choice it has would.** Where there is room (every eligible outcome that stands higher beyond is beaten, on what couples in, by another eligible one), an optimum lowers"),
    ],
    'theories/becoming/ONE-PAGE.zh.md': [
        ('**伦理。** 凡只读所表示之动力学的陈述，都不蕴涵任何东西的延续有意义：事物如何进行（就其被表示者而言）并不决定什么要紧。不需任何前提，',
         '**伦理。** 读作位于一个中心沿某个关系与之一同继续的东西之内，延续条件（对任何东西，其延续都有意义）就是一个关于关系的陈述：它恰在每一个中心沿该关系的闭包都是整体之处成立。所表示的动力学让什么保持开放，是哪一个关系是一个中心自己的；若作为一个没有任何别的东西读取的自由谓词来提供，意义便不被任何关于动力学的陈述所确定，这是由构造决定的。不需任何前提，'),
        ('*延续条件*（对任何东西，其延续都有意义）定谁的损失算数',
         '*延续条件*定谁的损失算数'),
        ("它不预先假定生灭变化本身是好的。其诸律在 Lean 中证明；其读法、猜想与前提都标明为读法、猜想与前提。\n\n",
         "它不预先假定生灭变化本身是好的。其诸律在 Lean 中证明；其读法、猜想与前提都标明为读法、猜想与前提。\n\n" + ONE_ZH_ARC + "\n\n"),
        ("以两种粒度去读，一个样式的进程",
         "以两种粒度去读（细的类读部分，粗的类读样式），一个样式的进程"),
        ("即一张带有量与离散步的缘之网，每条律各有其假设：",
         "即一张带有量与离散步的缘之网。每一项先说要点，再说诸律，每条律各有其假设："),
        ("- *变化与回返。* 生起与止息是同一个变化的三种读法；对有限族的一个可判定的性质，生起恰在止息反复出现之处反复出现。在有限多个构形之中，一条律恰在每个构形都会回返之处不失去任何东西；",
         "- *变化与回返。* **生起与止息步调一致；在一个有限的世界中，一条不合并任何东西的律使每个状态都回来。** 生起与止息是同一个变化，分别就活动、依存与存立来读；对有限族中在每个成员上都可判定为是或否的性质，生起恰在止息反复出现之处反复出现。在有限多个构形之中，一条律恰在每个构形都会回返之处不合并任何两个构形；"),
        ("- *什么使一个样式终止。* 持续的生起需要更新。各个取用者各自都在所给之内，合起来却可能超出所给；在更新依赖其所更新者之处，这一超出终止那更新以及依赖它者。在持续的取用之下，一个其给出由自身水平读出的缘，在该律所述的水平范围内，恰好从某个最低水平往上得以维持，这就是该体制的不可回返之点；沿着每一步都起作用的耦合之环，能够到达的最大差异呈指数增长；一条规则可以捕获它所支配者，而在一个陈明的模型中，这种锁定在其下累积的损失之中依然存续",
         "- *什么使一个样式终止。* **一个更新可以被耗过不可回返之点，而其中没有一个取用者超取。** 持续的生起需要更新。各个取用者各自都在所给之内，合起来却可能超出所给；在更新依赖其所更新者之处，这一超出终止那更新以及依赖它者。一个其给出取决于自身水平的缘有一个不可回返之点：在持续的取用之下，它在该律所述的水平范围内，恰好从某个最低水平往上得以维持。沿着每一步都起作用的耦合之环，能够到达的最大差异呈指数增长；一条从它所提升的份额读出的规则，可以锁定于该份额，而在一个陈明的模型中，这种锁定在其下累积的损失之中依然存续"),
        ("- *认知。* 一个选择恰好达到",
         "- *认知。* **认知者是它所认知者的一部分，除了沿它的关系，没有什么能到达它。** 一个选择恰好达到"),
        ("一个关于结构与变化的模型（理）是状态的一种归并（[认知]",
         "一个关于结构与变化的模型（理）是状态的一种归并，即把某些状态当作相同的一个映射（[认知]"),
        ("- *生命与演化。* 生起带来补充；",
         "- *生命与演化。* **演化的经典定律成立，并受供给生命之流的限定。** 生起带来补充；"),
        ("- *优化。* 只要有余地，一个最优解就把",
         "- *优化。* **一个优化者把其耦合之外者耗竭到它所能作的任何选择所耗竭的程度。** 只要有余地（每一个在外部处于更高水平的合格结果，都在耦合进来者上被另一个合格结果胜过），一个最优解就把"),
    ],
    'theories/becoming/THE-THEORY-OF-BECOMING.md': [
        ('the one evaluative parameter supplied ([evaluation](chapters/07-SIGNIFICANCE.md#evaluation)).\n\nProved for every type: a statement that reads only the dynamics',
         "the one evaluative parameter supplied ([evaluation](chapters/07-SIGNIFICANCE.md#evaluation)).\n\nRead as lying within what a center continues with along a relation, the continuation condition is a statement about relations: held de se, it holds exactly where every center's closure along that relation is the whole (proved for every type, near-definitionally; [decomposition](chapters/07-SIGNIFICANCE.md#r-continuation-condition-decomposition)). What the represented dynamics leave open is which relation is a center's own, the step below. Supplied instead as a free predicate that nothing else reads, significance is fixed by no statement about the dynamics, by construction, as the next result states.\n\nProved for every type: a statement that reads only the dynamics"),
        ("([calibrations](chapters/08-METHOD.md#calibrations)).\n\n## 1. ",
         "([calibrations](chapters/08-METHOD.md#calibrations)).\n\n" + OV_EN_ARC + "\n\n## 1. "),
        ("A *regime* is a condition whose giving is a law of what a standing draw leaves. Proved",
         "A *regime* is a condition whose giving is a law of what a standing draw leaves, and it has a point of no return. Proved"),
        ("(that sum positive), its point of no return. Under hypotheses the chapter states,",
         "(that sum positive), its point of no return. A fished stock is the case to keep in mind: its growth is its giving and the catch its draw, so, held to the same catch, a stock starting below that point ends and one starting at or above it, within the levels the law states, lasts (an illustration). Under hypotheses the chapter states,"),
        ("## 3. Knowing, learning and testing\n\nKnowing is a relation",
         "## 3. Knowing, learning and testing\n\nWhat ends a renewal can lie where none of its takers looks (§2); what can reach a formation at all is the question here. Knowing is a relation"),
        ("while a dependent's need enters neither statistic. Thesis T6",
         "while a dependent's need enters neither statistic. A fishery taking a fixed catch couples to its stock by threshold and learns of the fold when the catch fails; one reading the stock's level sees the variance and the lag-one autocorrelation rise as the fold nears (an illustration). Thesis T6"),
        ("## 4. Life and evolution\n\nRead with one kind",
         "## 4. Life and evolution\n\nLife brings the laws so far together: renewal, the flow that feeds it, and selection through descent. Read with one kind"),
        ("## 5. Joint activity and selection\n\nJoint activity is explained",
         "## 5. Joint activity and selection\n\nMany formations draw on one renewal, each selecting through its own couplings: here the excess of §2 and the limit of §3 meet. Joint activity is explained"),
        ("This restates the tragedy of the commons in near-definitional arithmetic, not who ought to take less.",
         "This restates the tragedy of the commons in near-definitional arithmetic, not who ought to take less. In the fishery, boats each within what the stock renews can together take more, and where its renewal depends on the stock itself, enough seasons of that from a low enough stock end the stock and the boats that depend on it (an illustration)."),
        ("## 7. Significance, ethics and alignment\n\nPositions and standards",
         "## 7. Significance, ethics and alignment\n\nSections 1–5 say how things go; this section says what that leaves open and what the ethics adds. Positions and standards"),
        ("\n\nA self acting for its own continuation presupposes",
         "\n\nIn the fishery, the boats' own continuation already ranks the stock's collapse, which ends them too, below a course that keeps the stock, with no C; what the condition adds is a loss that returns to no boat, such as the seabirds' that feed on the same fish; and ranking courses where the boats' own continuation is not at stake needs C (an illustration).\n\nA self acting for its own continuation presupposes"),
    ],
    'theories/becoming/THE-THEORY-OF-BECOMING.zh.md': [
        ('是所提供的唯一一个评价参数（[评价](chapters/07-SIGNIFICANCE.md#evaluation)）。\n\n对一切类型证明：一个只读取动力学的陈述',
         '是所提供的唯一一个评价参数（[评价](chapters/07-SIGNIFICANCE.md#evaluation)）。\n\n读作位于一个中心沿某个关系与之一同继续的东西之内，延续条件就是一个关于关系的陈述：以从己方式持有，它恰在每一个中心沿该关系的闭包都是整体之处成立（对一切类型证明，近乎依定义；[分解](chapters/07-SIGNIFICANCE.md#r-continuation-condition-decomposition)）。所表示的动力学让什么保持开放，是哪一个关系是一个中心自己的，即下文的那一步。若作为一个没有任何别的东西读取的自由谓词来提供，意义便不被任何关于动力学的陈述所确定，这是由构造决定的，下一个结果陈述的正是这一点。\n\n对一切类型证明：一个只读取动力学的陈述'),
        ("（[标定](chapters/08-METHOD.md#calibrations)）。\n\n## 1. ",
         "（[标定](chapters/08-METHOD.md#calibrations)）。\n\n" + OV_ZH_ARC + "\n\n## 1. "),
        ("*体制*是这样一个缘：它的给予是持续取用所留下者的一条律。",
         "*体制*是这样一个缘：它的给予是持续取用所留下者的一条律，而它有一个不可回返之点。"),
        ("这个和就是它的不可回返之点。在该章所述的假设之下",
         "这个和就是它的不可回返之点。一个被捕捞的鱼类种群是值得记住的情形：它的增长是它的给予，渔获是它的取用；所以在同样的渔获之下，起始于该点之下的种群终止，而起始于该点或其上（在该律所述的水平范围内）的种群得以持续（例示）。在该章所述的假设之下"),
        ("## 3. 认知、学习与检验\n\n认知是展开之中的一个关系",
         "## 3. 认知、学习与检验\n\n终结一个更新的东西，可以位于它的取用者都不看的地方（§2）；这里的问题是，究竟什么能到达一个形成。认知是展开之中的一个关系"),
        ("而依存者的需要不进入这两个统计量中的任何一个。论题 T6",
         "而依存者的需要不进入这两个统计量中的任何一个。一个取固定渔获的渔业以阈耦合于它的种群，在渔获失败时才得知折叠；一个读取种群水平的渔业，会看到方差与一阶滞后自相关随折叠临近而上升（例示）。论题 T6"),
        ("## 4. 生命与演化\n\n以同一种关系项来读",
         "## 4. 生命与演化\n\n生命把到此为止的诸律聚在一起：更新、供给它的流，以及经由世系的选择。以同一种关系项来读"),
        ("## 5. 联合活动与选择\n\n联合活动从实际的关系来说明",
         "## 5. 联合活动与选择\n\n许多形成取用同一个更新，每一个都经由自己的耦合进行选择：§2 的超出与 §3 的界限在这里相遇。联合活动从实际的关系来说明"),
        ("这是以近乎依定义的算术重述公地悲剧，而不是说谁应当少取。",
         "这是以近乎依定义的算术重述公地悲剧，而不是说谁应当少取。在渔业中，各条渔船各自都在种群所更新者之内，合起来却可以取得更多；在其更新依存于种群自身之处，从足够低的种群起足够多个季节的这种情形，终结种群以及依存于它的渔船（例示）。"),
        ("## 7. 意义、伦理与对齐\n\n位置与标准",
         "## 7. 意义、伦理与对齐\n\n第 1–5 节说事物如何进行；本节说这让什么保持开放，以及伦理增加了什么。位置与标准"),
        ("\n\n一个为自身延续而行动的自我，预设了某个延续有意义。",
         "\n\n在渔业中，渔船自身的延续已经把种群的崩溃（它也终结渔船）排在保持种群的进程之下，无需 C；延续条件所增加的，是一个不回到任何渔船身上的损失，例如以同样的鱼为食的海鸟的损失；而在渔船自身的延续不受影响之处对进程排序，需要 C（例示）。\n\n一个为自身延续而行动的自我，预设了某个延续有意义。"),
    ],
    'GLOSSARY.md': [
        ('whether that continuation has significance: a proposition, not a number |',
         'whether that continuation has significance: a proposition, not a number; read de se, that it lies within what the center continues with along a relation | '),
        ("| reach (及) |",
         "| gate (on moves) | a decided mark on a process's moves; it locates where change can enter a line. Not the gate of a renewal | [01](theories/becoming/chapters/01-ROOT.md#r-every-origin-passes-the-gate) |\n| reach (及) |"),
        ("| optimum, drawer, pool, shared code |",
         "| the gate (of a renewal), gated renewal | every formation giving to a condition depends on it at a need of at least `m`, so the renewal depends on what it renews. Not the gate on moves | [05](theories/becoming/chapters/05-COLLECTIVES.md#collectives) |\n| optimum, drawer, pool, shared code |"),
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
