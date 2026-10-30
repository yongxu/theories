#!/usr/bin/env python3
"""LW's texts: each live passage the item changes, its current words and the words that replace them. One list serves
both uses, so the note and the edits cannot drift apart:
  python3 -B lw_texts.py --check    (from the checkout root) every current passage occurs exactly once; writes nothing
  python3 -B lw_texts.py --apply    applies every edit, after the same check
  python3 -B lw_texts.py --doc      prints the texts as Markdown, for TEXTS.md
The texts follow the review recorded in TEXTS.md: five lenses, each finding verified adversarially, and GPT astra's
reading of the first draft. Nothing proved changes; the condition (scope) and C (order) stay named premises."""
import sys
from pathlib import Path

ROOT = Path.cwd()
B = 'theories/becoming/'
CH7 = B + 'chapters/07-SIGNIFICANCE.md'
CH8 = B + 'chapters/08-METHOD.md'
OV, OVZ = B + 'THE-THEORY-OF-BECOMING.md', B + 'THE-THEORY-OF-BECOMING.zh.md'
OP, OPZ = B + 'ONE-PAGE.md', B + 'ONE-PAGE.zh.md'

EDITS = [
    # (label, path, current, proposed)
    ("T8, 07 §8", CH7,
     "**Thesis T8. 生生 as the direction.** The good is 生生, life in the whole and its continuing generation, compared by "
     "widening what can form, counted for everything (scope: the continuation condition) and ranked by what every valuer "
     "who counts everything shares (order: C). Beneath it is the finite theorem of "
     "[§4.4](#r-widening-as-what-every-weighting-ranks) (`Weighting.widens_iff_every_of_class`); that these are the "
     "valuers who count everything, and that their shared verdict binds, is the thesis. *Standing:* argued; both "
     "warrants are open. *Forbids and refuted by:* a mixed case argued better from every standpoint counting everything "
     "positively, with no further premise; a good that is a pure closing.",
     "**Thesis T8. 生生 as the direction.** For life, the way is 生生, life in the whole and its continuing generation, "
     "compared by widening what can form, counted for everything (scope: the continuation condition) and ranked by what "
     "every valuer who counts everything shares (order: C). *For life* says whose way it is, not whose losses count: "
     "every continuation's still does. It is the way of those whose own line runs through life, of whatever substrate: "
     "under P2 and P4 of [§4.6](#future-path) everything downstream of one's acts lies on one's line, so the line of any "
     "actor whose acts reach living lines runs through life. This stance starts from what acting presupposes, held de se "
     "([§4.6](#future-path), P1), not from a wish that life go on; P1 is not a third premise, being the self's "
     "presupposition, which the condition contains ([§4.1](#decomposition)). A wish that life go on motivates avoiding "
     "degeneration, ending on every branch, which keeping excludes as well as generation does "
     "([02](02-MAP.md#r-generation-and-degeneration-at-two-grains)). Neither P1 nor the wish gives that the wider course "
     "is better: that is C's. Without the step of invariance, §4.6's path carries one's concern for one's own "
     "continuation, under P1–P4, to everything downstream of one's acts, part of the condition's scope; what that path "
     "does not reach is the step's. Beneath it is the finite theorem of "
     "[§4.4](#r-widening-as-what-every-weighting-ranks) (`Weighting.widens_iff_every_of_class`); that these are the "
     "valuers who count everything, and that their shared verdict binds those whose own line runs through life, is the "
     "thesis. No verdict binding every possible mind is claimed. With significance supplied as the free predicate of "
     "[§1](#r-what-the-dynamics-leave-open), where there is a standpoint and a formation, neither logic alone nor a "
     "satisfiable statement reading only the represented dynamics entails the continuation condition, and "
     "`bounded_rival` gives a consistent denial of it; whether a stronger warrant exists stays "
     "[open](#r-universal-practical-warrant). "
     "*Standing:* argued. Open: P2 and P4, the crux of §4.6's path, with P3, a correspondence not shown for actual "
     "selves; the step of invariance, for what that path does not reach; and a reason for C. *Forbids and refuted by:* "
     "a mixed case argued better from every standpoint counting everything positively, with no further premise; a pure "
     "closing argued good for life."),
    ("07, the thesis paragraph", CH7,
     "Open: the warrant of the condition, of C and of the step;",
     "Open: what still needs argument, with no warrant binding every possible mind claimed (T8, [§8](#theses)): P2 "
     "and P4, the crux of [§4.6](#future-path)'s path, which carries one's concern for one's own continuation past "
     "one's own end without the step; the step, for what that path does not reach; and a reason for C;"),
    ("07, What this chapter does not show", CH7,
     "- That the continuation condition, C or the step of invariance is warranted.",
     "- That the continuation condition, C or the step of invariance is warranted. No warrant binding every possible "
     "mind is claimed; what still needs argument is named under T8 ([§8](#theses))."),
    ("07, Open: a universal practical warrant", CH7,
     "supplied local norms, behavioural convergence or fuller description do not substitute for it. Since, where there "
     "is a standpoint and a formation, no satisfiable statement reading only the dynamics entails the condition "
     "([§1](#r-what-the-dynamics-leave-open)), such a warrant, where it would ground the condition, cannot come from "
     "the laws of the dynamics alone.",
     "supplied local norms, behavioural convergence or fuller description do not substitute for it. The ethics does not "
     "wait on it ([T8](#theses)). Since, where there is a standpoint and a formation, no satisfiable statement reading "
     "only the dynamics entails the condition ([§1](#r-what-the-dynamics-leave-open)), and a perspectivist denies the "
     "condition consistently (`bounded_rival`), such a warrant, where it would ground the condition, comes neither from "
     "the laws of the dynamics alone nor from logic alone; neither shows that none exists."),
    ("The one page, What is not yet done", OP,
     "- Whether either premise of the ethics can be warranted is open.",
     "- The ethics claims no warrant binding every possible mind, and it does not wait on one: a warrant grounding the "
     "continuation condition comes neither from the laws of the dynamics alone nor from logic alone. Its laws are "
     "proved, each on the base and under the hypotheses it states; its direction is life's, the way of those whose own "
     "line runs through life, of whatever substrate. What still needs argument: that the class of one's own line holds "
     "the effects of oneself and of each stage of that line, in the sense of whose losses count, not of what one answers "
     "for, which carries concern for one's own continuation past one's own end with no step of invariance "
     "([07 §4.6](chapters/07-SIGNIFICANCE.md#future-path)); the step, for what that does not reach; and why the wider "
     "course is better (C)."),
    ("The one page (Chinese), What is not yet done", OPZ,
     "- 伦理的两个前提中任何一个能否得到根据，尚属未决。",
     "- 伦理不主张对一切可能的心智都有约束力的根据，也不等待它：为延续条件奠基的根据既不单从动力学之律而来，也不单从逻辑而来。"
     "其律各在其所述之基与假设之下得证；其方向是生命的方向，即自身之相续经由生命者的方向，不论其基质。尚需论证的是：自身相续之类涵摄"
     "自己及该相续每一阶段的后果（就谁的损失算数而言，不是就自己须为何负责而言），这使对自身延续的关切越过自己的终结，而无需不变之步"
     "（[07 §4.6](chapters/07-SIGNIFICANCE.md#future-path)）；对其所不及者，不变之步；以及为什么更广的进程更好（C）。"),
    ("The one page, The ethics", OP,
     "The ethics adds two premises with two roles, and the theory asserts neither.",
     "The ethics adds two premises with two roles, and the theory asserts neither. Wanting life to continue motivates "
     "inquiry into the direction the ethics argues for, 生生, and avoiding courses that end on every branch; it does not "
     "by itself establish either premise."),
    ("The one page (Chinese), The ethics", OPZ,
     "伦理加上两个各有其用的前提，本理论对二者都不断言。",
     "伦理加上两个各有其用的前提，本理论对二者都不断言。希望生命延续，促使人探究伦理所论证的方向即生生，并促使人避开在每一分支上都"
     "终止的进程；它本身并不确立任何一个前提。"),
    ("The overview, the theses table", OV,
     "| T8 | 生生, compared by widening, counted for everything (scope: the continuation condition) and ranked by what "
     "every valuer counting everything shares (order: C), is the direction | argued; both warrants open |",
     "| T8 | For life, the way is 生生, compared by widening, counted for everything (scope: the continuation condition) "
     "and ranked by what every valuer counting everything shares (order: C); no verdict binding every possible mind is "
     "claimed | argued; open: P2 and P4 of [07 §4.6](chapters/07-SIGNIFICANCE.md#future-path) (one's line a regularity "
     "of its own; its class holding one's effects), the step beyond that path, a reason for C |"),
    ("The overview (Chinese), the theses table", OVZ,
     "| T8 | 以扩大来比较、对一切都计数（范围：延续条件）、并按每一个对一切都计数的评价者所共有者排序（次序：C）的生生，就是方向 | "
     "已论证；两项根据都未决 |",
     "| T8 | 对生命而言，方向是以扩大来比较、对一切都计数（范围：延续条件）、并按每一个对一切都计数的评价者所共有者排序（次序：C）的"
     "生生；不主张对一切可能的心智都有约束力的裁断 | 已论证；未决：[07 §4.6](chapters/07-SIGNIFICANCE.md#future-path) 的 P2 与 "
     "P4（自身之相续是其自身的一种常规；其类涵摄自己的后果）、该路以外的不变之步、C 的理由 |"),
    ("The overview, Warrant", OV,
     "- **Warrant.** Whether the condition, C and the step of invariance are warranted; whether the self's "
     "presupposition is held de se; whether status is invariant and equal. No formal work settles these, and a warrant "
     "grounding the condition cannot come from the laws of the dynamics alone (",
     "- **Warrant.** No warrant binding every possible mind is claimed, and the ethics does not wait on one: a warrant "
     "grounding the condition comes neither from the laws of the dynamics alone nor from logic alone, since a "
     "perspectivist denies the condition consistently. What still needs argument: P2 and P4 of "
     "[07 §4.6](chapters/07-SIGNIFICANCE.md#future-path) (that one's own line is a regularity of its own, and that its "
     "class holds one's effects), which carry concern for one's own continuation past one's own end with no step of "
     "invariance; the step, for what that does not reach; a reason for C; whether the self's presupposition is held de "
     "se; whether status is invariant and equal. No formal work settles these ("),
    ("The overview (Chinese), Warrant", OVZ,
     "- **根据。** 该条件、C 与不变之步是否有根据；自我的预设是否以从己方式持有；道德地位是否不变且平等。没有任何形式工作能了结这些"
     "问题，而为该条件奠基的根据不能单从动力学之律而来（",
     "- **根据。** 不主张对一切可能的心智都有约束力的根据，伦理也不等待它：为该条件奠基的根据既不单从动力学之律而来，也不单从逻辑"
     "而来，因为一个视角主义者可以一致地否认该条件。尚需论证的是：[07 §4.6](chapters/07-SIGNIFICANCE.md#future-path) 的 P2 与 "
     "P4（自身之相续是其自身的一种常规；其类涵摄自己的后果），它们使对自身延续的关切越过自己的终结而无需不变之步；对其所不及者，不变"
     "之步；C 的理由；自我的预设是否以从己方式持有；道德地位是否不变且平等。没有任何形式工作能了结这些问题（"),
    ("08, the theses table", CH8,
     "| T8. 生生 as the direction | [07](07-SIGNIFICANCE.md#theses) | argued; both warrants open | a mixed case argued "
     "better from every standpoint counting everything positively, with no further premise; a good that is a pure "
     "closing |",
     "| T8. 生生 as the direction | [07](07-SIGNIFICANCE.md#theses) | argued; open: P2 and P4 of "
     "[07 §4.6](07-SIGNIFICANCE.md#future-path) (one's line a regularity of its own; its class holding one's effects), "
     "the step beyond that path, a reason for C | a mixed case argued better from every standpoint counting everything "
     "positively, with no further premise; a pure closing argued good for life |"),
    ("08, item 12", CH8,
     "*Open:* both warrants; no formal work settles them ([below](#philosophical-warrant)).",
     "*Open:* P2 and P4 of [07 §4.6](07-SIGNIFICANCE.md#future-path), the step for what that path does not reach, a "
     "reason for C, and whether a stronger practical warrant exists, with no warrant binding every possible mind "
     "claimed (T8); no formal work settles them ([below](#philosophical-warrant))."),
    ("08, Philosophical warrant: a stronger practical warrant", CH8,
     "- **A stronger universal practical warrant**: grounding reasons without an externally supplied end.",
     "- **A stronger universal practical warrant**: grounding reasons without an externally supplied end; the ethics "
     "does not wait on it ([07](07-SIGNIFICANCE.md#r-universal-practical-warrant), T8)."),
    ("08, Philosophical warrant: C and the step", CH8,
     "- **Calling widening better and the step of invariance** (item 12; [07](07-SIGNIFICANCE.md#scope-and-order)): C's "
     "no-loss extension is widening by definition, so the definition carries no warrant.",
     "- **Calling widening better, P2 and P4 of 07 §4.6, and the step of invariance** (item 12; "
     "[07](07-SIGNIFICANCE.md#scope-and-order), [§4.6](07-SIGNIFICANCE.md#future-path)): C's no-loss extension is "
     "widening by definition, so the definition carries no warrant; P2 and P4 are the crux of the path that carries "
     "concern for one's own continuation past one's own end without the step."),
    ("The review packet, P-26: T8", B + 'review/PHILOSOPHY.md',
     "Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: \"The good is 生生, life in the whole and its continuing "
     "generation, compared by widening what can form\".",
     "Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: \"For life, the way is 生生, life in the whole and its "
     "continuing generation, compared by widening what can form\"; \"for life\" says Quote "
     "[theories/becoming/chapters/07-SIGNIFICANCE.md]: \"whose way it is, not whose losses count: every continuation's "
     "still does\"."),
    ("The review packet, P-26: the thesis", B + 'review/PHILOSOPHY.md',
     "\"that these are the valuers who count everything, and that their shared verdict binds, is the thesis\"",
     "\"that these are the valuers who count everything, and that their shared verdict binds those whose own line runs "
     "through life, is the thesis\""),
    ("The review packet, P-26: the standing", B + 'review/PHILOSOPHY.md',
     "\"argued; both warrants are open.\"",
     "\"argued. Open: P2 and P4, the crux of §4.6's path, with P3, a correspondence not shown for actual selves; the "
     "step of invariance, for what that path does not reach; and a reason for C.\""),
    ("The review packet, P-26: question 1", B + 'review/PHILOSOPHY.md',
     "1. Is T8's claim that the shared verdict of valuers who count everything binds defensible, and what would refute "
     "it beyond the chapter's own criteria?",
     "1. Is T8's claim that the shared verdict of valuers who count everything binds those whose own line runs through "
     "life defensible, with no verdict binding every possible mind claimed, and what would refute it beyond the "
     "chapter's own criteria?"),
    ("The collective page, \"Toward generation\"", B + 'COLLECTIVE-DIRECTION.md',
     "生生 as the direction is thesis T8, argued ([07 §8](chapters/07-SIGNIFICANCE.md#theses)).",
     "生生 as life's direction, every continuation's losses still counted, is thesis T8, argued, with no verdict binding "
     "every possible mind claimed ([07 §8](chapters/07-SIGNIFICANCE.md#theses))."),
    ("The collective page, Scope", B + 'COLLECTIVE-DIRECTION.md',
     "Without the step of invariance, concern for one's own continuation reaches successors in one's own line and "
     "members fed by conditions one affects, on witnesses "
     "([07 §4.5](chapters/07-SIGNIFICANCE.md#r-reach-through-a-shared-condition), "
     "[§4.6](chapters/07-SIGNIFICANCE.md#future-path)); future beings in no one's line still need the step.",
     "Without the step of invariance, under P1–P4 of [07 §4.6](chapters/07-SIGNIFICANCE.md#future-path), concern for "
     "one's own continuation reaches everything downstream of what one conditions, past one's own end and across lines "
     "fed by conditions one affects ([07 §4.5](chapters/07-SIGNIFICANCE.md#r-reach-through-a-shared-condition)); that "
     "is a law, not only a reading of witnesses. What that path does not reach, future beings in no one's line among "
     "it, still needs the step."),
    ("OPENING, footnote [^ethics] (AI-written; README re-rendered)", B + 'OPENING.md',
     "That all ethics rests on this ground is not proved.",
     "That all ethics rests on this ground is not proved, and the theory claims no verdict binding every possible mind: "
     "T8 states the direction as life's ([T8](chapters/07-SIGNIFICANCE.md#theses))."),
    ("AGENTS.md, the ethics paragraph: the condition", 'AGENTS.md',
     "living significance and the other ethical results are theorems under it, and its warrant and necessity are open.",
     "living significance and the other ethical results are theorems under it, and its warrant and necessity are open: "
     "no warrant binding every possible mind is claimed (one grounding the condition comes neither from the laws of the "
     "dynamics alone nor from logic alone); for the path of chapter 7 §4.6, P2 and P4 still need warrant, and the step "
     "of invariance stays open for what that path does not reach."),
    ("AGENTS.md, the ethics paragraph: C", 'AGENTS.md',
     "What ranks lies in calling widening better (C) alone.",
     "What ranks lies in calling widening better (C) alone, and a reason for C is open apart."),
    ("AGENTS.md, the header", 'AGENTS.md',
     "([before](_process/history/2026-10-23-instructions/AGENTS-before-repository-architecture.md)).",
     "([before](_process/history/2026-10-23-instructions/AGENTS-before-repository-architecture.md)); revised 30 October "
     "(board item LW, [texts](_process/research/2026-10-05-generative-foundation-review/root-foundation/development/"
     "lw-the-way-for-life/TEXTS.md)) so that the ethics claims no warrant binding every possible mind and names what "
     "still needs argument ([before](_process/history/2026-10-30-instructions/AGENTS-before-the-way-for-life.md))."),
]

AGENTS_BEFORE = '_process/history/2026-10-30-instructions/AGENTS-before-the-way-for-life.md'


def check():
    for label, path, old, new in EDITS:
        text = (ROOT / path).read_text(encoding='utf-8')
        n = text.count(old)
        assert n == 1 or (n == 0 and new in text), (label, path, n)


def apply():
    check()
    before = ROOT / AGENTS_BEFORE
    if not before.exists():
        before.parent.mkdir(parents=True, exist_ok=True)
        before.write_bytes((ROOT / 'AGENTS.md').read_bytes())
    by_path = {}
    for label, path, old, new in EDITS:
        by_path.setdefault(path, []).append((label, old, new))
    for path, edits in by_path.items():
        p = ROOT / path
        text = p.read_text(encoding='utf-8')
        for label, old, new in edits:
            if old in text:
                text = text.replace(old, new, 1)
        p.write_text(text, encoding='utf-8')
    print(f'applied: {len(EDITS)} edits in {len(by_path)} files; AGENTS.md before kept at {AGENTS_BEFORE}')


HERE = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/lw-the-way-for-life'


def rebase(passage, path):
    """The passage's relative links, written for the page at `path`, rewritten to resolve from TEXTS.md's folder."""
    import os.path
    import re

    def one(m):
        target = m.group(2)
        if re.match(r'[a-z]+:', target):
            return m.group(0)
        file, _, anchor = target.partition('#')
        where = os.path.normpath(os.path.join(os.path.dirname(path), file)) if file else path
        return f'{m.group(1)}({os.path.relpath(where, HERE)}{"#" + anchor if anchor else ""})'
    return re.sub(r'(\[[^\]]*\])\(([^)\s]+)\)', one, passage)


def doc():
    out = []
    for label, path, old, new in EDITS:
        link = '../../../../../../' + path
        out += [f'### {label}', '', f'[{Path(path).name}]({link}). Current:', '', '> ' + rebase(old, path), '',
                'Proposed:', '', '> ' + rebase(new, path), '']
    print('\n'.join(out))


if __name__ == '__main__':
    {'--check': check, '--apply': apply, '--doc': doc}[sys.argv[1]]()
    if sys.argv[1] == '--check':
        print(f'checked: {len(EDITS)} edits, each current passage found exactly once')
