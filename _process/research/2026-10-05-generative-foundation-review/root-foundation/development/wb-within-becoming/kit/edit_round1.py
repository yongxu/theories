#!/usr/bin/env python3
"""WB: the fixes from the readers' first round on the revision (review/readers/round1-fable.md, round1-astra.md).

Each replacement is exact and must match once (or the count given); one already applied is skipped, so the script
can be rerun. JSON files are edited as text, each string JSON-escaped, so their layout stays."""
import json
import pathlib
import sys

ROOT = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else '.')


def rep(path, pairs, js=False):
    p = ROOT / path
    s = p.read_text(encoding='utf-8')
    for item in pairs:
        a, b, n = item if len(item) == 3 else (*item, 1)
        if js:
            a, b = json.dumps(a, ensure_ascii=False)[1:-1], json.dumps(b, ensure_ascii=False)[1:-1]
        if s.count(a) == 0 and s.count(b) >= 1:
            continue
        if s.count(a) != n:
            raise SystemExit(f'{path}: {s.count(a)} of {a[:80]!r}, expected {n}')
        s = s.replace(a, b)
    if js:
        json.loads(s)
    p.write_text(s, encoding='utf-8')


B = 'theories/becoming/'
CH = B + 'chapters/'

# T8: the thesis and its refuter in one direction (both readers); T4 not claimed as its test (both readers).
T8_THESIS_OLD = "that a selection reading what a course draws on, and what ends with it, leaves a draw beyond a renewal its readers depend on more often than one that does not read it"
T8_THESIS_NEW = "that a selection reading what a course draws on, and what ends with it, selects a draw beyond a renewal its readers depend on less often than one that does not read it"
REF_OLD = "read a course's draw and what ends with it leaving a draw beyond the renewal their readers depend on no less often than selections that do not"
REF_NEW = "read a course's draw and what ends with it selecting a draw beyond the renewal their readers depend on no less often than selections that do not"
REF_OLD_CAP = "Selections reading a course's draw and what ends with it leaving a draw beyond the renewal their readers depend on no less often than selections that do not"
REF_NEW_CAP = "Selections reading a course's draw and what ends with it selecting a draw beyond the renewal their readers depend on no less often than selections that do not"
REF_ZH_OLD = "读取一进程之取用及随之终结者的选择，与不读取者相比，并不更少地离开越出其读者所依之更新的取用"
REF_ZH_NEW = "读取一进程之取用及随之终结者的选择，与不读取者相比，选取越出其读者所依之更新的取用并不更少"
STEP_OLD = "what that path does not reach is counted only by a standpoint taking the step"
STEP_NEW = "what that path does not reach, other scopes can count, the step of invariance among them"

rep(CH + '07-SIGNIFICANCE.md', [
    (T8_THESIS_OLD, T8_THESIS_NEW),
    ("T4 is its first, partial test: untold, no season kept the bed; told, with talk, one model of two kept it in 8 of 10.",
     "T4's frozen test was designed for T4, not for this thesis, and does not test it: the bed gives the fishers nothing, so keeping it is not forgoing a draw on a renewal they depend on."),
    (STEP_OLD, STEP_NEW),
    ("*Standing:* argued; its test beyond T4 named, not designed.", "*Standing:* argued; its test named, not designed."),
    (REF_OLD, REF_NEW),
    ("what that path does not reach, which only a standpoint taking the step counts;",
     "what that path does not reach, which other scopes can count, the step of invariance among them;"),
    ("These remain the step's.", "The step counts these; other scopes may count particular ones without it."),
    ("Whether that presupposition holds for actual selves is a further question (P3), since a presupposition can be false. It is not the condition: what §4.6 lists as not reached stays the step's,",
     "Whether actual selves hold that presupposition is a further question, a correspondence not shown, since a presupposition can be false. It is not the condition: what §4.6 lists as not reached is counted only by other scopes, the step among them,"),
    ("If P4 fails, one route toward part of scope is gone, and [T8](#theses)'s clause \"of whatever substrate\" loses its ground: it rests on P2 and P4, and for actors not themselves alive it would need another.",
     "If P4 fails, one route toward part of scope is gone, and so is [T8](#theses)'s reading that the line of any actor whose acts reach living lines runs through life; the makers' offer itself does not rest on this path."),
    ("Whether it holds for actual selves is P3, a correspondence; no warrant from outside is sought.",
     "Whether it holds for actual selves is a correspondence, not shown; no warrant from outside is sought."),
    ("With no condition, there is no \"should\" apart from what a center does.",
     "With no condition, a \"should\" is a reading a center forms and holds, real in what it conditions; holding or recognizing it does not guarantee acting on it."),
    ("No ending is ranked above keeping by retaining: a path retaining what has significance along another ends none of it (`Web.Retains.not_added`).",
     "Retaining adds no ending and ranks nothing: a path retaining what has significance along another ends none of it (`Web.Retains.not_added`)."),
    ("The ranking results rest on their two readings, the continuation condition for scope and C for order, each named where used.",
     "Each ranking result names what it ranks under, the continuation condition for scope and C for order, or the narrower order a self-concern result states."),
    ("Choices take more, following from neither the condition nor C: which reading of `living` (which events a course includes), the lifting L and the commitments J1–J4.",
     "The judgment of this section takes more, following from neither the condition nor C: which reading of `living` (which events a course includes), the lifting L and the commitments J1–J4; other constraints, undertakings and held orders can also organize a choice."),
    ("It goes through a formation's couplings when histories alike through them are selected alike, and then reaches exactly what couples into the selector",
     "It goes through a formation's couplings when histories alike through them are selected alike; each such selection is bounded by those couplings, and all of them together tell apart exactly what couples into the selector"),
    ("a ranking of a narrowing above its widening comes only from a valuation counting something negatively, a case misread or framed, or a loss the weighting does not list:",
     "a ranking of a narrowing above its widening comes only from a negative valuation or a misread or framed case:"),
    ("under two premises, keeping widening from a moment is 全生成", "under the two premises stated next (each point decided at each moment, and something new found after each step), keeping widening from a moment is 全生成"),
    ("So, under the two premises, keeping widening", "So, under those two premises, keeping widening"),
])
rep(CH + '08-METHOD.md', [
    ("argued; its test beyond T4 named, not designed;", "argued; its test named, not designed;"),
    (REF_OLD, REF_NEW),
    ("and what that path does not reach, counted only by a standpoint taking the step;",
     "and what that path does not reach, which other scopes can count, the step of invariance among them;"),
    ("Each item has one class: further proof, philosophical warrant or empirical.",
     "Each item has one class: further proof, philosophical, philosophical warrant or empirical."),
    ("The ranking results rest on their two readings either way, the continuation condition for scope and C for order.",
     "Either way, each ranking result names what it ranks under, the continuation condition for scope and C for order or a narrower order it states."),
    ("the ranking results rest on the continuation condition for scope and C for order,",
     "the ranking results name what they rank under, the continuation condition for scope and C for order or a narrower stated order,"),
])
rep(CH + '01-ROOT.md', [
    ("That asks more than renewal of lines ([07](07-SIGNIFICANCE.md));", "It is not renewal of lines alone ([07](07-SIGNIFICANCE.md));"),
])
rep(CH + '05-COLLECTIVES.md', [
    ("the last needs a ranking of courses, so C or a premise in its place (", "the last needs a ranking of courses, under C or another named order ("),
])
rep(B + 'ONE-PAGE.md', [
    ("Argued; binding no one; its test beyond T4 named, not designed", "Argued; binding no one; its test named, not designed"),
    (REF_OLD_CAP, REF_NEW_CAP),
])
rep(B + 'ONE-PAGE.zh.md', [
    ("已论证；不约束任何人；T4 以外的检验已指名，未设计", "已论证；不约束任何人；其检验已指名，未设计"),
    (REF_ZH_OLD, REF_ZH_NEW),
])
rep(B + 'THE-THEORY-OF-BECOMING.md', [
    ("argued; its test beyond T4 named, not designed;", "argued; its test named, not designed;"),
    (REF_OLD, REF_NEW),
])
rep(B + 'THE-THEORY-OF-BECOMING.zh.md', [
    ("已论证；T4 以外的检验已指名，未设计；", "已论证；其检验已指名，未设计；"),
    (REF_ZH_OLD, REF_ZH_NEW),
    ("因为那里的损失会经由其供给者回到它身上［AI 读法］；", "因为那里的损失会经由其供给者回到它身上，这是其回应的一个条件，不是其保证［AI 读法］；"),
])
rep(B + 'USES-EXAMPLES.md', [
    ("Its standing is argued; it binds no one, and its test beyond T4 is named, not designed.",
     "Its standing is argued; it binds no one, and its test is named, not designed."),
    ("Either way, a ranking rests on the two readings, the continuation condition for scope and C for order.",
     "Either way, a ranking result names what it ranks under, the continuation condition for scope and C for order or a narrower stated order."),
    ("Choosing takes further premises, J1–J4, proposed by the AI (",
     "This constructed judgment takes further premises, J1–J4, proposed by the AI; other constraints, undertakings and held orders can also organize a choice ("),
])
rep(B + 'USES-EXAMPLES.zh.md', [
    ("它不约束任何人，T4 以外的检验已指名，未设计。", "它不约束任何人，其检验已指名，未设计。"),
    ("无论哪种情况，排序之果都依于其两种读法，延续条件定范围，C 定次序。",
     "无论哪种情况，每一项排序之果都指名其所据：延续条件定范围、C 定次序，或它所陈述的一种更窄的次序。"),
    ("*构造的，不是观察到的：一条已证明的扩大之律的一个用法，与一个已论证的论题 T8 并列，两种不被断言的读法所排者，与一个已论证的论题 T8。*",
     "*构造的，不是观察到的：一条已证明的扩大之律的一个用法、两种不被断言的读法所排者，以及一个已论证的论题 T8。*"),
    ("关于抉择的结果还需要进一步的前提 J1–J4，由 AI 提出（",
     "这一构造的判断还需要进一步的前提 J1–J4，由 AI 提出；别的约束、承担与所持之序也可以组织抉择（"),
])
rep(B + 'ONE-ARGUMENT.md', [
    ("A reader who counts the seabirds and holds C ranks it so;",
     "Where restraint admits everything draining admits and the seabirds besides, a reader holding C ranks restraint higher; where each admits something the other does not, C alone gives no verdict;"),
    ("[a reason for C is open](chapters/07-SIGNIFICANCE.md#theses)", "[how C-like orders form is open](chapters/07-SIGNIFICANCE.md#open)"),
])
rep(B + 'review/PHILOSOPHY.md', [
    ("[P-04](#p-04) two premises, two roles;", "[P-04](#p-04) two readings, two roles;"),
    (T8_THESIS_OLD, T8_THESIS_NEW),
    ("argued; its test beyond T4 named, not designed.", "argued; its test named, not designed."),
])
rep(B + 'review/ALIGNMENT.md', [
    ("and one mixed case under the two premises.", "and one mixed case under the two readings."),
])
rep('_process/navigation/README-ZH.md', [
    ("**伦理。** 本论的伦理立在[两个不被断言的前提](../../theories/becoming/chapters/07-SIGNIFICANCE.md#scope-and-order)上，根据都还未决。*延续条件*：从每一个立场看，对任何东西，其延续到未来都有意义。它确定范围，即谁的损失算数，不给任何东西排序。*C*：扩大可形成者（一个进程让什么能够形成）更好，它给出次序。给进程排出好坏，需要 C 或一个代替它的前提。[论题 T8](../../theories/becoming/chapters/07-SIGNIFICANCE.md#theses) 论证这一伦理是对生命而言的道，但不主张任何裁断对一切可能的心智都有约束力。",
     "**伦理。** 本论的伦理不断言任何应当：凡它对进程排序之处，都指名[两种读法](../../theories/becoming/chapters/07-SIGNIFICANCE.md#scope-and-order)，二者都不被断言。*延续条件*：从每一个立场看，对任何东西，其延续到未来都被计数。它确定范围，即谁的损失算数，不给任何东西排序。*C*：扩大可形成者（一个进程让什么能够形成）更好，它给出次序。本论之作者提供一种看法，不是裁断（[论题 T8](../../theories/becoming/chapters/07-SIGNIFICANCE.md#theses)）。"),
])
rep('AGENTS.md', [
    ("Neither follows from a statement reading only the represented dynamics, with significance or order left free (",
     "Neither follows from a satisfiable statement reading only the represented dynamics, with significance or order left free and a standpoint, formation or extension given ("),
])
rep('tools/research/navigation.py', [
    ("'premises': (CH07, 'The ranking results rest on their two readings, the continuation condition for scope and C for order, each named where used.'),",
     "'premises': (CH07, 'Each ranking result names what it ranks under, the continuation condition for scope and C for order, or the narrower order a self-concern result states.'),"),
    ("'The ranking results rest on two readings, neither asserted: the condition fixes scope, whose losses count, and C, calling widening better, gives order; whoever ranks courses holds C or another order; '",
     "'The ranking results name what they rank under, none asserted: the condition fixes scope, whose losses count, C, calling widening better, gives order, and the self-concern results state a narrower order; whoever ranks courses holds C or another order; '"),
])
rep(B + 'results/completion/COVERAGE.json', [
    ('"further proof",\n      "philosophical warrant",\n      "empirical"', '"further proof",\n      "philosophical",\n      "philosophical warrant",\n      "empirical"'),
])
rep(B + 'results/data/spine.json', [
    ("已论证；T4 以外的检验已指名，未设计 … P2 与 P4", "已论证；其检验已指名，未设计 … P2 与 P4"),
], js=True)

# The opening (Ren's first person, revised in place on argument; its header names the passages).
O = B + 'OPENING.md'
rep(O, [
    ("where one fails, the law no longer guarantees the conclusions that used it, and a constructed world shows each can then fail.",
     "where one fails, the law no longer guarantees the conclusions that used it, and constructed worlds show each premise can fail while the others hold."),
    ("which, on a finite listing, anyone whose weighting counts each thing at stake as worth something already ranks as it does, is what I offer, for life, as a way of seeing: the way of every being whose own continuation runs through life.",
     "which, on a finite listing, every additive weighting counting each thing at stake as worth something ranks as it does, is what I offer, for life, as a way of seeing, not as every being's way."),
    ("Where all who count everything at stake must agree, the case lies on one side of this line; where they may differ, the law shows the case is mixed,",
     "Where every such weighting agrees, the case lies on one side of this line; where they may differ, the law shows the case is mixed,"),
    ("they draw more from what others need than it gives back,", "they draw more from what others need than they give back,"),
    ("*May life go on, generating, without ceasing.*", "*May life go on, life from life, without ceasing.*"),
    ("so where one fails only the conclusions using it go.",
     "so where one fails, only the conclusions using it lose their guarantee; whether a conclusion then fails needs its own counterexample."),
    ("**Open:** who holds the condition and its step, and C, and P2 and P4.", "**Open:** who holds the condition and its step, and C; and whether P2 and P4 hold."),
    ("what the work offers, life's stance, does not wait on one", "what the work offers, a way of seeing, does not wait on one"),
    ("The condition fixes scope, whose losses count, and orders nothing: ranking uses comparison by widening (C),",
     "The condition fixes scope, whose losses count, and orders nothing: where the work ranks, it uses comparison by widening (C),"),
    ("Judgment between conflicting continuations needs the disclosed practical premises ([the premise card](chapters/08-METHOD.md#premise-card)). That ethics for life rests on this basis is argued, not proved: T8 states the direction as life's, the way of any actor whose acts reach the living, under §4.6's open P2 and P4 ([T8](chapters/07-SIGNIFICANCE.md#theses));",
     "A judgment between conflicting continuations names its further premises ([the premise card](chapters/08-METHOD.md#premise-card)). T8 states what the makers offer for life, a way of seeing what each course draws on, from what renewal and at which grain, what ends, what goes on, and who bears it; it binds no one ([T8](chapters/07-SIGNIFICANCE.md#theses));"),
    ("*The second premise:* \"what keeps all there was and adds more is better\" is C.", "*The second reading:* \"what keeps all there was and adds more is better\" is C."),
    ("so anyone who counts everything at stake as worth something already holds C. A valuer who weighs some item at nothing need not hold it;",
     "so every such weighting ranks as C does; that a valuer is represented by one is not shown. A valuer who weighs some item at nothing need not rank so;"),
    ("(\"there is just is, \"no should\" beyond the becoming\")", "('there is just is, \"no should\" beyond the becoming')"),
    ("A closing is read at a grain: an ending within what the renewal it depends on gives closes nothing at the renewal's grain.",
     "A closing is read at a stated grain, and a draw within renewal at a step can still close what has not yet formed (`Preemption`, [07 §2](chapters/07-SIGNIFICANCE.md#r-the-run-classes-and-widening))."),
    ("so retaining orders neither, and ordering it needs a further measure the theory does not derive.",
     "so retaining orders neither; a further judgment names its criterion and who holds it, and the theory derives none."),
    ("With no premise, a selection through a formation's couplings selects alike exactly the histories alike through them;",
     "With no premise, histories are selected alike by every selection through a formation's couplings exactly when they are alike through them;"),
    ("C as what a weighting counting each thing ranks, on a finite listing; the ethics offered as a way of seeing,",
     "C as what an additive weighting counting each thing ranks, on a finite listing; the ethics offered as a way of seeing, not as every being's way,"),
])

# Records: the fields the readers named.
R = B + 'results/records/'
rep(R + 'self-concern-and-c-under-the-condition.json', [
    ("The ranking results rest on two readings with two roles: the continuation condition for scope and C (Comparison) for order. Whoever ranks courses still holds C or another order; this result locates where self-concern gives what C asks, one way: between two listed level paths, courses whose admissions end, where the de se condition holds and admission is decided.",
     "This result assumes self-concern and the continuation condition held de se, with admission decided and two listed level paths, courses whose admissions end; it concludes, one way, the extension rankings C asks between those paths. Whoever ranks courses still holds C or another order."),
    ("伦理依二前提，各有其职：延续条件定范围，C（Comparison）定序。凡对进程排序者，仍持 C 或别一种次序；此结果指出自关切单向给出 C 之所求之处：于自承之条件成立、接纳可判定之处，二所列且接纳有终之层径之间。",
     "此结果以自关切与自承之延续条件为假设，接纳可判定，二所列且接纳有终之层径；它单向推出 C 在这两条层径之间所求的扩展排序。凡对进程排序者，仍持 C 或别一种次序。"),
    ("That the condition holds, that self-concern is warranted, or that C is derived: the condition and C stay the ethics' premises and self-concern a hypothesis; C is a reading the account does not assert.",
     "That the condition holds, that self-concern is warranted, or that C holds without its stated hypotheses: each stays a hypothesis where used, and C is a reading the account does not assert."),
    ("条件成立、自关切有据，或 C 被推出：条件与 C 仍为伦理之前提，自关切为假设；C 之依据仍开放。",
     "条件成立、自关切有据，或 C 无须所述假设便成立：各自在用到之处仍是假设，C 是本论不断言的一种读法。"),
], js=True)
rep(R + 'one-root-to-its-edge.json', [
    ("That anyone must hold either reading the ranking results use: neither is entailed by statements of the dynamics (the condition given a standpoint and a formation, C given a frame with an extension), and no warrant from outside is sought.",
     "That anyone must hold either reading the ranking results use: neither is entailed by a satisfiable statement reading only the dynamics, with significance or order free (the condition given a standpoint and a formation, C given a frame with an extension), and no warrant from outside is sought."),
    ("伦理之二前提有其据：二者皆不为动力之陈述所蕴涵（条件于有立场与成形处，C 于框架有扩展处）；二者之据皆开放。",
     "任何人必须持有排序之果所用的任一读法：二者皆不为只读动力学、意义或次序自由之可满足陈述所蕴涵（条件于有立场与成形处，C 于框架有扩展处）；不求外来之根据。"),
    ("(chapter 7: its §3 for the condition, T8 in its §8 for the warrant)", "(chapter 7: its §3 for the condition, its §8 for what is offered)"),
], js=True)
for name in ('shaping-the-rule-selected-by-what-comes-back.json', 'shaping-read-by-readers-drawn-from-the-selected.json'):
    rep(R + name, [("生生, the continuation of life,, or", "生生, the continuation of life, or")], js=True)
print('done')
