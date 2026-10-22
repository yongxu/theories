#!/usr/bin/env python3
"""VT1: the valuer tests as theorems. Chapter T5 (EN, ZH), the relation to known results and the record
table; THE-STEP-OF-INVARIANCE §5; OPENING [^good-evil]; the significance review's new section and its list of
later outcomes; the study section; the valuer-agreement README; the package README row (EN, ZH) and the root
module's doc.
usage (from the checkout root): python3 -B apply_text.py STUDY_SECTION RECEIPT"""
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
N, RECEIPT = int(sys.argv[1]), sys.argv[2]
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = ROOT / (RF + 'BECOMING-RENEWAL-READING.md')
REVIEW = ROOT / (RF + 'BECOMING-SIGNIFICANCE-REVIEW.md')
EN = ROOT / 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
ZH = ROOT / 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.zh.md'
STEP = ROOT / 'theories/becoming/chapters/THE-STEP-OF-INVARIANCE.md'
OPENING = ROOT / 'theories/becoming/OPENING.md'
VALUERS = ROOT / 'experiments/valuer-agreement/README.md'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
A, W = 'a-narrowing-above-its-widening', 'weights-within-a-ratio-agree-past-it'
ANCHOR = f'#{N}-the-valuer-tests-as-theorems-vt1'
CH = '../../../' + RF  # from theories/becoming/chapters
SLINK = CH + 'BECOMING-RENEWAL-READING.md' + ANCHOR
CHECK = CH + 'BECOMING-SIGNIFICANCE-REVIEW.md#valuer-theorems-check'
REC = '../results/records/'

PENDING = {}


def edit(path, pairs):
    s = PENDING.get(path, path.read_text())
    for old, new in pairs:
        assert s.count(old) == 1, (path.name, old[:80], s.count(old))
        s = s.replace(old, new)
    PENDING[path] = s


# ---- chapter, English ------------------------------------------------------------------------------------
edit(EN, [
    ("comes from a negative valuation (spite, envy, inequity aversion, positional concern) or from a misread case. "
     "That is a bound on where disagreement can fall, not a prediction of where it falls: valuers who also count (equal "
     "weights) agree on every mixed comparison with a larger side, and their disagreement gathers where the counts tie.",
     "comes from a negative valuation (spite, envy, inequity aversion, positional concern) or from a misread or framed "
     "case, and from nothing else. That is a bound on where disagreement can fall, not a prediction of where it falls. "
     "Valuers whose weights stand within a ratio `r` of each other agree on every mixed comparison whose larger side "
     "alone keeps more than `r` times what the other alone keeps; valuers who count (equal weights, `r = 1`) agree on "
     "every mixed comparison with a larger side, and their disagreement gathers where the counts tie."),
    ("That valuers value positively is C's premise relocated, not warranted (§8.5). The empirical claim has two parts "
     "with different standings. *The locus prediction*, that structure predicts where disagreement falls (mixed "
     "comparisons disputed, widenings not), was tested by VD1 on 96 AI valuers and refuted for them; it is withdrawn "
     "from the thesis, since these valuers count and decide size-matched mixed comparisons almost as uniformly as "
     "widenings. *The bound*, that no valuer who counts everything at stake positively and reads the case right ranks "
     "a narrowing above its widening, is supported for 96 AI valuers by VD2. VD2 measured each valuer's sign on each "
     "formation apart from the ranking. Where that sign was strongly positive, no model chose the narrower plan in more "
     "than 0.7% of right-read cases. Within each valuer, violations ran about twelve times as often where its own sign "
     "was not positive. But the bound's full form held for five of six models, a measured gain was not reliably acted "
     "on, and two standpoints not named in advance also gave gains. VD1, which found the negative valuations only post "
     "hoc, had failed the bound's rules (A1, A2, R1). The bound stays conjectured for valuers in general; its exception "
     "now has measured content for these valuers (evidence below; ",
     "That valuers value positively is C's premise relocated, not warranted (§8.5). The empirical claim is now three "
     f"theorems and three premises to measure (VT1, [study §{N}]({SLINK}), [a narrowing above its widening]({REC}{A}.md), "
     f"[weights within a ratio]({REC}{W}.md)). VD1 and VD2 tested on AI personas what these theorems fix once the "
     "premises hold.\n"
     "  - *The exception is a theorem.* Take a valuer's judgment as a ranking of presentations: plans with their "
     "wording and order, each keeping a set of formations. Suppose it ranks a narrowing above its widening by one "
     "formation. Then either it does not rank that pair as its own order on the kept sets does (a misread or a "
     "framing: presentation invariance fails on the pair), or the formation weighs at zero or below for it "
     "(`Weighting.narrower_above_net`; for any order increasing at the added formation, `Weighting.reads_increasingAt`). "
     "Read right, it ranks the narrowing above exactly where the formation weighs below zero, and at zero it ranks "
     "neither above (`Weighting.reads_ranksNet`, `Weighting.ranksNet_ties`). Either cause suffices alone: a framing "
     "does even where the formation weighs above zero (`Framed.framing_alone`). An additive valuation ranks a widening "
     "by one formation as that formation weighs, whatever else either plan keeps (`Weighting.ranksNet_widensBy`). Read "
     "right with every formation above zero, it ranks no widening below, by one formation or by many "
     "(`Weighting.reads_ranksNet_widens`).\n"
     "  - *A sign measured apart predicts the ranking under one premise.* Read right, the sign of the order's increment "
     "from the narrower plan to the wider fixes the verdict (`Weighting.reads_increment`). So a sign measured with no "
     "plan shown predicts the ranking exactly where it is the sign of that increment in the pair's context. An "
     "additive valuation carries the sign from one context to every other (`Weighting.ranksNet_increment_alike`). An "
     "interacting one need not: in `Interacting` a formation's ending is a loss alone and a gain beside another, and a "
     "valuer that reads the sets exactly ranks the narrowing above (`Interacting.increment_differs`; no additive "
     "valuation gives that order, `Interacting.not_net`). This premise is where separate and joint evaluation part "
     "(Hsee 1996). VD2's rules measured it: X1s and X2 passing say it held where the sign was strongly positive, and X3 "
     "failing says it did not hold for gains.\n"
     "  - *The locus holds where weights are not dispersed.* Take two plans, one keeping `p` formations the other does "
     "not and the other keeping `q`. Every positive weighting whose weights stand within a ratio `r` of each other ranks "
     "the first higher exactly where `p > r q`, and on the boundary the weighting tilted toward the second ties "
     "(`Weighting.every_within_iff`, `Weighting.tilted_ties`). Two such valuers rank a mixed pair opposite ways exactly "
     "where `r` exceeds both `p / q` and `q / p` (`Weighting.opposite_within_iff`); equal weights (`r = 1`) never do "
     "(`Weighting.neutral_ranks_by_number`). VD1's mixed pairs keep `p : q` of 2 : 1 (M1), 3 : 1 (M2) and 1 : 1 (M0), "
     "so disagreement on them needs weights dispersed past 2, 3 and 1. Read after the run, VD1's mean disagreement "
     "follows these thresholds: 0.27 on M0, 0.10 on M1, 0.08 on M2. A right-read choice of the smaller plan in M1, every "
     "weight positive, needs weights dispersed past twofold, so \"valuers count\" says that their weights were mostly "
     "dispersed less than that, not that structure failed to bound where disagreement falls.\n"
     "  - *What stays empirical* is whether actual valuers meet the three premises. Presentation invariance is measured "
     "by each judgment's own reading lists and by rewording or reordering one pair. The link is measured by ranking the "
     "one-formation pair in a transparent presentation beside the sign measured apart. Dispersion is measured by graded "
     "signs, a slight against a serious loss. VD1 and VD2 measured these for 96 AI valuers, whose judgments under "
     "standpoint prompts are role-play rather than valuations of their own. The bound stays conjectured for valuers in "
     "general; its exception has measured content for these valuers (evidence below; "),
    ("[sign check](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/"
     "BECOMING-SIGNIFICANCE-REVIEW.md#sign-check), [study §297]",
     "[sign check](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/"
     f"BECOMING-SIGNIFICANCE-REVIEW.md#sign-check), [valuer-theorems check]({CHECK}), [study §297]"),
    ("- *Forbids.* A valuer whose valuations of everything at stake are measured positive, who reads the case correctly, "
     "ranking a narrowing above its widening; disagreement on widening comparisons as robust as on mixed ones.",
     "- *Forbids.* A valuer whose valuations of everything at stake are measured positive, who reads the case correctly, "
     "ranking a narrowing above its widening; disagreement on widening comparisons as robust as on mixed ones; valuers "
     "whose weights are measured within a ratio `r` of each other ranking a mixed pair opposite ways where one side alone "
     "keeps more than `r` times what the other alone keeps."),
    ("- *Refuted by.* Such rankings at more than the rate of misreading, with no negative valuation found in a task apart "
     "from the ranking. The exception",
     "- *Refuted by.* Such rankings at more than the rate of misreading, with no negative valuation found in a task apart "
     "from the ranking. By the theorems such a ranking breaks no law: the case was misread or framed, or the sign measured "
     "apart is not the sign of the joint increment. So it would refute the thesis's claim that valuers who count everything "
     "at stake meet the premises, not the reduction. The exception"),
    ("  - *Open.* Human valuers; a test where the sign is measured in the same comparison's terms; the cross-framed "
     "widenings on which Claude Haiku's VD1 rankings break its VD2 signs (a secondary rule, X1s′, failed only there).",
     "  - *Open.* Human valuers, with the three premises measured; a test where the sign is measured in the same "
     "comparison's terms; the cross-framed widenings on which Claude Haiku's VD1 rankings break its VD2 signs (a "
     "secondary rule, X1s′, failed only there); the share of valuers who disagree as a function of how dispersed their "
     "weights are, a probabilistic form over exchangeable weights."),
    ("| reduction proved; the locus prediction tested by VD1 and refuted for its valuers, who count; the bound conjectured,",
     "| reduction proved; the exception and the locus proved on three measurable premises (presentation invariance, the "
     "sign measured apart linked to the joint increment, weight dispersion; VT1); the locus prediction, made without a "
     "premise on dispersion, tested by VD1 and refuted for its valuers, who count; the bound conjectured,"),
    ("| [Graded significance and priority](../results/records/graded-significance-and-priority.md) | theorem under stated "
     "premises | finite listing; levels as steps admitted | §6.5 |",
     "| [Graded significance and priority](../results/records/graded-significance-and-priority.md) | theorem under stated "
     "premises | finite listing; levels as steps admitted | §6.5 |\n"
     f"| [A narrowing above its widening]({REC}{A}.md) | theorem under stated premises | finite listing; admission "
     "decided | §6.5 |\n"
     f"| [Weights within a ratio agree past it]({REC}{W}.md) | theorem under stated premises | finite listing; admission "
     "decided | §6.5 |"),
])

# ---- chapter, Chinese ------------------------------------------------------------------------------------
edit(ZH, [
    ("来自负的评价（恶意、嫉妒、不平等厌恶、位置关切）或误读了情形。这是分歧能落在哪里的界限，不是它落在哪里的预测：同时计数（等权重）的"
     "评价者，在每个有较大一方的混合比较上都一致，他们的分歧聚在数目相等处。",
     "来自负的评价（恶意、嫉妒、不平等厌恶、位置关切），或误读、被框定的情形，别无其他。这是分歧能落在哪里的界限，不是它落在哪里的预测。"
     "权重彼此在比值 `r` 之内的评价者，在较大一方独有者多于另一方独有者 `r` 倍的每个混合比较上都一致；计数（等权重，`r = 1`）的评价者，"
     "在每个有较大一方的混合比较上都一致，他们的分歧聚在数目相等处。"),
    ("评价者正地评价，是 C 的前提挪了位置，不是得到根据（§8.5）。经验主张分两部分，地位不同。*落点预测*，即结构预测分歧落在哪里"
     "（混合比较有争议，扩大没有），由 VD1 在 96 个 AI 评价者上检验，对他们被驳倒；它从论题中撤回，因为这些评价者计数，裁定大小配齐的混合"
     "比较几乎与扩大一样一致。*界限*，即正地计入所涉一切、正确读了情形的评价者不把缩小排在其扩大之上，对 96 个 AI 评价者得到 VD2 的支持。"
     "VD2 与排序分开地测量每个评价者对每个形成的正负号。在该正负号强为正之处，没有一个模型在超过 0.7% 的读对情形中选较窄方案。在每个评价者"
     "之内，违反在其自己的正负号不为正之处约为强为正之处的十二倍。但界限的完整形式只对六个模型中的五个成立，测得的收益并不可靠地付诸排序，"
     "且两个事先未点名的立足点也给出收益。VD1 只在事后找到负评价，其界限规则（A1、A2、R1）失败。界限对一般的评价者仍是猜想；其例外对这些"
     "评价者已有测得的内容（证据见下；[实验](../../../experiments/valuer-agreement/README.md)，",
     "评价者正地评价，是 C 的前提挪了位置，不是得到根据（§8.5）。经验主张现在是三条定理与三个有待测量的前提"
     f"（VT1，[研究 §{N}]({SLINK})，[缩小排在其扩大之上]({REC}{A}.md)，[比值之内的权重越过它即一致]({REC}{W}.md)）。"
     "VD1 与 VD2 在 AI 角色上检验的，正是前提成立时这些定理所定者。\n"
     "  - *例外是定理。* 把评价者的判断看作对表述的排序：表述是带着措辞与次序的方案，各保住一组形成。设它把一个缩小排在其仅多一个形成的"
     "扩大之上。那么，要么它没有按自己对所保集合的次序来排这一对（误读或框定：表述不变在这一对上不成立），要么该形成对它的权重为零或以下"
     "（`Weighting.narrower_above_net`；对在所加形成处递增的任何次序，`Weighting.reads_increasingAt`）。读对时，它恰在该形成权重低于零"
     "处把缩小排在上面，为零则两者都不在上（`Weighting.reads_ranksNet`、`Weighting.ranksNet_ties`）。两个原因各自都足够：即使该形成"
     "权重高于零，框定也足以造成（`Framed.framing_alone`）。可加的评价按所加形成的权重来排仅多一个形成的扩大，不论两方案另外保住什么"
     "（`Weighting.ranksNet_widensBy`）。读对且每个形成都高于零时，它不把任何扩大排在下面，不论多一个形成还是多个"
     "（`Weighting.reads_ranksNet_widens`）。\n"
     "  - *分开测得的正负号在一个前提下预测排序。* 读对时，次序从较窄方案到较宽方案的增量的正负号决定裁定（`Weighting.reads_increment`）。"
     "所以不出示方案而测得的正负号，恰在它是这一对语境中该增量的正负号时预测排序。可加的评价把正负号从一个语境带到每个语境"
     "（`Weighting.ranksNet_increment_alike`）。相互作用的评价则不必：在 `Interacting` 中，一个形成的终止单独看是损失，与另一个并存时是"
     "收益，恰按集合读的评价者就把缩小排在上面（`Interacting.increment_differs`；没有可加的评价给出这一次序，`Interacting.not_net`）。"
     "分开的评价与联合的评价正是在这一前提上分开（Hsee 1996）。VD2 的规则测的就是它：X1s 与 X2 通过，说明它在正负号强为正之处成立；"
     "X3 失败，说明它对收益不成立。\n"
     "  - *落点在权重不分散之处成立。* 设两个方案，一个保住另一个没有的 `p` 个形成，另一个保住 `q` 个。权重彼此在比值 `r` 之内的每个"
     "正加权，恰在 `p > r q` 时把前者排得更高；在边界上，偏向后者的加权使两者持平（`Weighting.every_within_iff`、"
     "`Weighting.tilted_ties`）。两个这样的评价者把一对混合比较排成相反方向，恰当 `r` 同时超过 `p / q` 与 `q / p`"
     "（`Weighting.opposite_within_iff`）；等权重（`r = 1`）从不如此（`Weighting.neutral_ranks_by_number`）。VD1 的混合对中 `p : q` "
     "为 2 : 1（M1）、3 : 1（M2）与 1 : 1（M0），所以其上的分歧需要权重分散超过 2、3 与 1。运行之后读，VD1 的平均分歧依这些阈值排列："
     "M0 为 0.27，M1 为 0.10，M2 为 0.08。在 M1 中读对而选较小方案、且每个权重都为正，需要权重分散超过两倍，所以“评价者计数”说的是"
     "他们的权重大多分散不到两倍，不是结构没能界定分歧落在哪里。\n"
     "  - *仍属经验的*，是实际的评价者是否满足三个前提。表述不变由每个判断自己的读出列表、并对同一对改写措辞或次序来测。联系由在透明的"
     "表述中对仅差一个形成的一对排序、与分开测得的正负号并列来测。分散由分级的正负号（轻微损失对严重损失）来测。VD1 与 VD2 对 96 个 AI "
     "评价者测了这些；它们在立足点提示下的判断是角色扮演，不是自己的评价。界限对一般的评价者仍是猜想；其例外对这些评价者已有测得的内容"
     f"（证据见下；[实验](../../../experiments/valuer-agreement/README.md)，[核查]({CHECK})，"),
    ("- *禁止。* 对所涉一切的评价测得为正、正确读了情形的评价者，把缩小排在其扩大之上；扩大比较上的分歧与混合比较上一样稳固。",
     "- *禁止。* 对所涉一切的评价测得为正、正确读了情形的评价者，把缩小排在其扩大之上；扩大比较上的分歧与混合比较上一样稳固；权重测得"
     "彼此在比值 `r` 之内的评价者，在一方独有者多于另一方独有者 `r` 倍处，把一对混合比较排成相反方向。"),
    ("- *驳倒它的观察。* 这样的排序多于误读率，且在与该排序分开的任务中测不到负的评价。",
     "- *驳倒它的观察。* 这样的排序多于误读率，且在与该排序分开的任务中测不到负的评价。按这些定理，这样的排序不违反任何规律：情形被误读"
     "或框定了，或分开测得的正负号不是联合增量的正负号。所以它驳倒的是论题关于计入所涉一切的评价者满足这些前提的主张，不是归约。"),
    ("  - *开放。* 人类评价者；在同一比较的用语中测量正负号的检验；Claude Haiku 在 VD1 中的排序与其 VD2 正负号相悖之处的交叉表述扩大"
     "（次要规则 X1s′ 只在那里失败）。",
     "  - *开放。* 人类评价者，并测其三个前提；在同一比较的用语中测量正负号的检验；Claude Haiku 在 VD1 中的排序与其 VD2 正负号相悖之处的"
     "交叉表述扩大（次要规则 X1s′ 只在那里失败）；分歧的评价者所占比例与其权重分散程度的关系，即在可交换的权重上的概率形式。"),
    ("| 归约已证；落点预测由 VD1 检验，对其评价者被驳倒（他们计数）；",
     "| 归约已证；例外与落点在三个可测的前提下已证（表述不变、分开测得的正负号与联合增量相联、权重分散；VT1）；不带分散前提的落点预测由 "
     "VD1 检验，对其评价者被驳倒（他们计数）；"),
    ("| [分级的意义与优先](../results/records/graded-significance-and-priority.md) | 在所述前提下的定理 | 有限列举；层级为所接纳的步 | §6.5 |",
     "| [分级的意义与优先](../results/records/graded-significance-and-priority.md) | 在所述前提下的定理 | 有限列举；层级为所接纳的步 | §6.5 |\n"
     f"| [缩小排在其扩大之上]({REC}{A}.md) | 在所述前提下的定理 | 有限列举；接纳可判定 | §6.5 |\n"
     f"| [比值之内的权重越过它即一致]({REC}{W}.md) | 在所述前提下的定理 | 有限列举；接纳可判定 | §6.5 |"),
])

# ---- the step of invariance ------------------------------------------------------------------------------
edit(STEP, [
    ("- **A weighting the same for every item counts numbers.** One positive weight for all items ranks a course higher "
     "exactly when it admits more items (`Weighting.neutral_ranks_by_number`).",
     "- **A weighting the same for every item counts numbers.** One positive weight for all items ranks a course higher "
     "exactly when it admits more items (`Weighting.neutral_ranks_by_number`).\n"
     "- **Weightings nearly alike agree past their ratio.** Take two courses, one admitting `p` items the other does not "
     "and the other `q`. Every positive weighting whose weights stand within a ratio `r` of each other ranks the first "
     "higher exactly where `p > r q`, and the weighting tilted toward the second ties on the boundary "
     "(`Weighting.every_within_iff`, `Weighting.tilted_ties`). Two such weightings rank the pair opposite ways exactly "
     "where `r` exceeds both `p / q` and `q / p` (`Weighting.opposite_within_iff`). Equal weights are `r = 1`, and the "
     "weighting that decides a mixed comparison either way has its ratio past the pair's (`Weighting.outweighs`).\n"
     "- **A narrowing above its widening is a misread, a framing or a weight below zero.** A net weighting may count an "
     "item against a course that admits it (`Weighting.ranksNet`). Take a ranking of presentations, plans with their "
     "wording and order. Where it ranks a narrowing above its widening by one item, it does not rank the pair as the "
     "sets are ranked, or the item weighs at zero or below; read right, the item weighs below zero "
     "(`Weighting.narrower_above_net`, `Weighting.reads_ranksNet`). A sign measured apart predicts the ranking exactly "
     "where it is the sign of the increment in the pair's context (`Weighting.reads_increment`). Thesis T5 of the "
     "[canonical chapter](THE-THEORY-OF-BECOMING.md#t5-the-order-of-the-ethics-is-shared-by-every-valuer) reads both."),
    ("| Zero weight ties; equal weights count | `Weighting.weighed_eq_of_unweighted`, `Weighting.neutral_ranks_by_number` "
     "| `Becoming.Weightings` | landed |",
     "| Zero weight ties; equal weights count | `Weighting.weighed_eq_of_unweighted`, `Weighting.neutral_ranks_by_number` "
     "| `Becoming.Weightings` | landed |\n"
     "| Weightings within a ratio agree past it; the tilted weighting ties on the boundary | `Weighting.every_within_iff`, "
     "`Weighting.some_within_reverses_iff`, `Weighting.opposite_within_iff`, `Weighting.tilted_ties` | "
     "`Becoming.Weightings` | landed |\n"
     "| A narrowing above its widening is a pair not read right or an item at zero or below; a sign measured apart "
     "predicts under its link | `Weighting.narrower_above_net`, `Weighting.reads_ranksNet`, `Weighting.reads_increment`, "
     "`Weighting.ranksNet_increment_alike`, `Framed.framing_alone`, `Interacting.not_net` | `Becoming.Weightings` | "
     "landed |"),
    ("[widening-as-what-every-weighting-ranks](../results/records/widening-as-what-every-weighting-ranks.md) and "
     "[graded-significance-and-priority](../results/records/graded-significance-and-priority.md).",
     "[widening-as-what-every-weighting-ranks](../results/records/widening-as-what-every-weighting-ranks.md), "
     "[graded-significance-and-priority](../results/records/graded-significance-and-priority.md), "
     f"[{A}](../results/records/{A}.md) and [{W}](../results/records/{W}.md)."),
])

# ---- OPENING [^good-evil] (an AI-written note) --------------------------------------------------------------
G = '../../' + RF
edit(OPENING, [
    ("So the line bounds where disagreement can fall; it does not predict where it falls (thesis T5). That no valuer "
     "who counts everything at stake positively and reads the case right ranks a narrowing above its widening is "
     "conjectured: in a frozen test on 96 AI valuers (six models under sixteen standpoints) its rules failed, the "
     "violations falling mostly under two standpoints set up to count something at stake as worth less than nothing, "
     "as the exception says, though that valuation was read from prompts and reasons, not measured apart. That "
     "disagreement gathers on mixed cases was refuted for those valuers and withdrawn: they count "
     "(`Weighting.neutral_ranks_by_number`), and decided mixed cases with a larger side almost as uniformly as "
     "widenings ([T5](chapters/THE-THEORY-OF-BECOMING.md#theses-and-conjectures), [study §297]("
     "../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md"
     "#297-where-valuers-agree-and-disagree-vd1)).",
     "So the line bounds where disagreement can fall; it does not predict where it falls (thesis T5). The bound is a "
     "theorem on premises that can be measured. A valuer that ranks two plans as its own valuation of what they keep "
     "ranks a narrowing above its widening by one formation exactly where that formation counts below zero for it, and "
     "ties them at zero; otherwise the case was misread or framed (`Weighting.narrower_above_net`, "
     "`Weighting.reads_ranksNet`). A sign measured apart predicts the ranking where it is the sign of what the formation "
     "adds in that pair's context (`Weighting.reads_increment`). Valuers whose weights stand within a ratio `r` of each "
     "other agree on every mixed case whose larger side alone keeps more than `r` times what the other alone keeps "
     "(`Weighting.every_within_iff`). Whether valuers meet these premises is measured, not derived. In frozen tests on 96 "
     "AI valuers (six models under sixteen standpoints), the violations fell mostly under two standpoints set up to "
     "count something at stake as worth less than nothing. With each valuer's sign measured apart, a strongly positive "
     "sign was not ranked against outside misreading, while a sign of gain was not reliably acted on. They decided mixed "
     "cases with a larger side almost as uniformly as widenings: their weights were mostly dispersed less than twofold "
     "([T5](chapters/THE-THEORY-OF-BECOMING.md#theses-and-conjectures), "
     f"[study §297]({G}BECOMING-RENEWAL-READING.md#297-where-valuers-agree-and-disagree-vd1), "
     f"[study §330]({G}BECOMING-RENEWAL-READING.md#330-the-sign-measured-apart-from-the-ranking-vd2), "
     f"[study §{N}]({G}BECOMING-RENEWAL-READING.md{ANCHOR}))."),
])

# ---- significance review ----------------------------------------------------------------------------------
review = REVIEW.read_text()
start = review.index('*On 22 October:* VD2 measured each valuer')
end = review.index('\n', start)
edit(REVIEW, [(review[start:end] + '\n',
               review[start:end] + '\n\n'
               '*Later on 22 October:* VT1 proved what VD1 and VD2 tested, leaving three premises to measure: presentation '
               'invariance, the link of a sign measured apart to the joint increment, and how dispersed the weights are '
               f'([valuer-theorems check](#valuer-theorems-check), [study §{N}](BECOMING-RENEWAL-READING.md{ANCHOR})).\n')])
PENDING[REVIEW] = PENDING[REVIEW].rstrip('\n') + '\n' + (HERE / 'review_vt1.md').read_text().replace('{N}', str(N))

# ---- study section ----------------------------------------------------------------------------------------
study = STUDY.read_text()
assert f'\n## {N}. ' not in study and f'\n## {N - 1}. ' in study, N
PENDING[STUDY] = study.rstrip('\n') + '\n\n' + (HERE / 'study_vt1.txt').read_text().replace('{N}', str(N)).replace(
    '{RECEIPT}', RECEIPT)

# ---- the valuer-agreement README ----------------------------------------------------------------------------
edit(VALUERS, [
    ("VD1 tested where valuers agree and disagree; VD2, [below](#vd2-the-sign-measured-apart-from-the-ranking), tests "
     "T5's exception, which VD1 left untested.",
     "VD1 tested where valuers agree and disagree; VD2, [below](#vd2-the-sign-measured-apart-from-the-ranking), tests "
     "T5's exception, which VD1 left untested.\n\n"
     "**After both runs (22 October 2026, VT1).** What the two tests checked on AI personas is now proved in "
     "`Becoming.Weightings`, with three premises left to measure: presentation invariance (the case ranked as its sets), "
     "the link of a sign measured apart to the joint increment, and how dispersed a valuer's weights are. A right-read "
     "narrowing above its widening is exactly a formation weighing below zero; valuers whose weights stand within a ratio "
     "`r` agree on every mixed pair whose larger side alone keeps more than `r` times what the other alone keeps "
     f"([{A}](../../theories/becoming/results/records/{A}.md), [{W}](../../theories/becoming/results/records/{W}.md), "
     f"[study §{N}](../../{RF}BECOMING-RENEWAL-READING.md{ANCHOR}))."),
])

# ---- package README (EN, ZH) and the root module's doc -------------------------------------------------------
edit(PKG / 'README.md', [
    ("sufficiency ties above its threshold (`Weighting.prior_lt_of_widens`, `Weighting.prior_transfer`, "
     "`Weighting.sufficient_ties`); the readings are the AI's (D59, D60) |",
     "sufficiency ties above its threshold (`Weighting.prior_lt_of_widens`, `Weighting.prior_transfer`, "
     "`Weighting.sufficient_ties`); under a net weighting a ranking of presentations puts a narrowing above its widening "
     "by one item only where it does not read the pair as the sets or the item weighs at zero or below, and read right "
     "exactly where it weighs below zero (`Weighting.narrower_above_net`, `Weighting.reads_ranksNet`; a sign measured "
     "apart predicts it under its link, `Weighting.reads_increment`; witnesses `Framed`, `Interacting`; record "
     f"[{A}](../../../../../../theories/becoming/results/records/{A}.md)); weightings within a ratio `n / d` rank `a` above "
     "`b` exactly where `n q < d p`, the tilted weighting tying on the boundary (`Weighting.every_within_iff`, "
     "`Weighting.opposite_within_iff`, `Weighting.tilted_ties`; record "
     f"[{W}](../../../../../../theories/becoming/results/records/{W}.md)); the readings are the AI's (D59, D60) |"),
])
edit(PKG / 'README.zh.md', [
    ("充足在阈值之上持平（`Weighting.prior_lt_of_widens`、`Weighting.prior_transfer`、`Weighting.sufficient_ties`）；读法是 AI 的"
     "（D59、D60） |",
     "充足在阈值之上持平（`Weighting.prior_lt_of_widens`、`Weighting.prior_transfer`、`Weighting.sufficient_ties`）；在净加权下，对表述的"
     "排序只在未按集合读这一对、或所加项权重为零或以下处，把缩小排在其仅多一项的扩大之上，读对时恰在该项权重低于零处"
     "（`Weighting.narrower_above_net`、`Weighting.reads_ranksNet`；分开测得的正负号在其联系之下预测之，`Weighting.reads_increment`；"
     "见证 `Framed`、`Interacting`）；比值 `n / d` 之内的加权恰在 `n q < d p` 时把 `a` 排在 `b` 之上，偏向的加权在边界上持平"
     "（`Weighting.every_within_iff`、`Weighting.opposite_within_iff`、`Weighting.tilted_ties`）；读法是 AI 的（D59、D60） |"),
])
edit(PKG / 'Becoming.lean', [
    ("  transfers C leaves mixed, and a threshold of sufficiency ties above it. The readings are the AI's\n  (D59, D60).",
     "  transfers C leaves mixed, and a threshold of sufficiency ties above it. Under a net weighting, which\n"
     "  may count an item against a course, a ranking of presentations puts a narrowing above its widening by\n"
     "  one item only where it does not read the pair as the sets or the item weighs at zero or below, and,\n"
     "  read right, exactly where it weighs below zero; a sign measured apart predicts it exactly where it is\n"
     "  the sign of the increment in the pair's context (`Interacting`: not so for an interacting order).\n"
     "  Weightings within a ratio `n / d` rank `a` above `b` exactly where `n q < d p`, `p` and `q` the items\n"
     "  each alone admits, the tilted weighting tying on the boundary; two disagree exactly where the ratio\n"
     "  exceeds both `p / q` and `q / p`. The readings are the AI's (D59, D60)."),
])

for path, text in PENDING.items():
    path.write_text(text)
    print('edited', path.relative_to(ROOT))
