#!/usr/bin/env python3
"""SG4 landing text: the study section, the significance review's course check, the chapter (EN, ZH: section 3.4's
statement and records, section 7.1's course against the prior result, T1's and T3's standing, section 8.1 item 10,
the relation-to-known-results row 6, the record table and section 9's receipt, counts and audit sentence) and the
board row moved to the history file with the queue and receipt sentences. Every edit must match exactly once.

usage (from the checkout root to edit): python3 -B apply_text.py RECEIPT CONNECTIVITY_LOG BASE PREVIOUS_RECEIPT
Prints the study section number."""
import json
import re
import sys
from collections import Counter
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
REVIEW = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-SIGNIFICANCE-REVIEW.md'
CH = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
ZH = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.zh.md'
BOARD = '_process/BECOMING-WORKBOARD.md'
HISTORY = '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
MOD = 'Becoming.Optimum'
RID = 're-optimizing-above-a-renewal-ends-it'
SG3 = 'several-optimizers-drain-by-their-joint-capacity'
SA290 = ('../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
         '#290-several-optimizers-at-a-mutual-best-response-sg3')
receipt_id, conn_log, base, previous = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]


def edit(path, pairs):
    p = ROOT / path
    text = p.read_text(encoding='utf-8')
    for old, new in pairs:
        k = text.count(old)
        if k != 1:
            sys.exit(f'{path}: expected one match, found {k}: {old[:100]!r}')
        text = text.replace(old, new)
    p.write_text(text, encoding='utf-8')
    print('edited', path, len(pairs))


def line_from(text, start):
    i = text.index(start)
    assert text.count(start) == 1, start
    return text[i:text.index('\n', i)]


R = json.loads((ROOT / PKG / 'becoming-checks' / receipt_id / 'verification.json').read_text())
assert R['status'] == 'passed' and R['core_compiles_from_prelude'] and R['source_unchanged_during_check']
assert not any(v for m in R['modules'] for v in m['axiom_dependencies'].values())
P = json.loads(Path(previous).read_text())
om = next(m for m in R['modules'] if m['module'] == MOD)
pm = next(m for m in P['modules'] if m['module'] == MOD)
old_names = {d['name'] for d in pm['declarations']}
new_decls = [d for d in om['declarations'] if d['name'] not in old_names]
assert old_names <= {d['name'] for d in om['declarations']}, 'a declaration was removed'
n_new_thms = om['theorems'] - pm['theorems']
mods, thms = Counter(), Counter()
for m in R['modules']:
    mods[m['layer']] += 1
    thms[m['layer']] += m['theorems']
spine_decls = sum(len(m['declarations']) for m in R['modules'] if m['spine'])
spine_thms = sum(m['theorems'] for m in R['modules'] if m['spine'])
closure = len(R['core_closure'])
closure_thms = sum(m['theorems'] for m in R['modules'] if m['module'] in R['core_closure'])
injeq = len(R.get('generated_axiom_dependencies', {}))
ran, reused = len(R['lean_steps']['ran']), len(R['lean_steps']['reused'])
fmt = lambda n: f'{n:,}'
t = Path(conn_log).read_text() if conn_log.startswith('/') else (ROOT / conn_log).read_text()
conn = json.loads(t[t.index('{'):t.rindex('}') + 1])
apart = sum(v for k, v in conn['classes'].items() if k.startswith('apart'))
assert conn['spine_theorems'] == spine_thms, (conn['spine_theorems'], spine_thms)
assert not conn['apart_roots_unclassified'] and not conn['register_entries_not_apart_roots']

# Study section: after the last.
stext = (ROOT / STUDY).read_text(encoding='utf-8')
N = max(int(x) for x in re.findall(r'^## (\d+)\. ', stext, re.M)) + 1
core_line = (f'Core {mods["core"]} modules and {fmt(thms["core"])} theorems, instances {mods["instance"]} and '
             f'{thms["instance"]}, applications {mods["application"]} and {thms["application"]}; {ran} Lean steps ran, '
             f'{fmt(reused)} reused')
apart_text = (f'{apart} of {fmt(spine_thms)} apart, unchanged; no new apart root, every new law stated on the flow and '
              'the web or used by one that is, the witness through the general laws; register check passes')
study = (HERE / 'study_sg4.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{THEOREMS}': n_new_thms, '{DECLS}': len(new_decls),
             '{OLD}': len(pm['declarations']), '{TOTAL}': len(om['declarations']),
             '{APART}': apart_text, '{CORE_LINE}': core_line}.items():
    study = study.replace(k, str(v))
assert not re.search(r'\{[A-Z_]+\}', study), 'placeholder left'
(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
sys.path.insert(0, str(ROOT))
from tools.research.moves import github_slug
SLUG = github_slug(study.split('\n', 1)[0].lstrip('# ').strip())
assert SLUG == f'{N}-a-course-of-re-optimizing-steps-against-a-renewal-sg4', SLUG
SA = f'../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{SLUG}'
REC = f'[{RID}](../results/records/{RID}.md)'
SREC = f'[{SG3}](../results/records/{SG3}.md)'

# Significance review: the course check, at the end.
rtext = (ROOT / REVIEW).read_text(encoding='utf-8')
assert 'id="course-check"' not in rtext
(ROOT / REVIEW).write_text(rtext.rstrip('\n') + '\n\n' + (HERE / 'check_sg4.txt').read_text(encoding='utf-8').rstrip('\n')
                           + '\n', encoding='utf-8')
print('appended', REVIEW)

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD34 = '`Optimum.TwoTakers.joint_drains`). Where the eligible outcomes are supplied otherwise,'
NEW34 = ('`Optimum.TwoTakers.joint_drains`). Over a course in which the part chooses again at every step, each step\'s '
         'level beyond is read off the one before by that law (`Optimum.course_beyond`; for several optimizers at mutual '
         'best responses, `Optimum.mutual_course_beyond`). Where the rest renews the condition by exactly `r` a step at '
         'a positive need and by at most `r` below, and takes there with the capacity `k` at every step, a dependence at '
         'that need, met at the start, is lost exactly where `r < k`, for good, and where `k ≤ r` the condition stays '
         'at its need (`Web.course_lost_iff`, `Web.course_kept_iff`); nothing is drawn beyond the starting level with '
         '`r` a step (`Web.course_drawn_within`). What the renewal does below the need decides only what is drawn: '
         'where it stops there, a course above the renewal draws a bounded amount (`Web.course_ended_drawn`), a '
         'positive draw is bounded exactly where `r < k`, and over a long course keeping draws more '
         '(`Optimum.drawn_bounded_iff`, `Optimum.keeping_draws_more`); where at least `a` is given at every step, '
         'everything given is drawn, at least `a` a step, without bound, the dependence lost all the same '
         '(`Web.course_drawn_unbounded`). Several optimizers jointly above the renewal lose it, however small each '
         'one\'s capacity (`Web.mutual_course_lost`; in `Optimum.Renewing` a store optimizer above the renewal ends '
         'with less in its store than one at it, `keeping_holds_more`, and two takers at mutual best responses with '
         'less than a restrained course none of whose steps is one, `restraint_holds_more`). Where the eligible '
         'outcomes are supplied otherwise,')
OLD34R = f'{SREC}, [selection-under-registration-revision]'
NEW34R = f'{SREC}, {REC}, [selection-under-registration-revision]'
OLD71 = f'SG3, [study §290]({SA290}));'
NEW71 = (f'SG3, [study §290]({SA290})); over a course of re-optimizing steps against a renewal, a capacity there above '
         'the renewal ends what depends on it for good, whatever the renewal does below the need, while several '
         'optimizers each within the renewal end it together; whether the optimizer\'s own measure registers the loss '
         'turns on what the renewal does below the need: where it stops below the need, more capacity gathers less over a long course '
         'than a capacity at the renewal, and where it does not, the drawers go on taking at least the renewal a step '
         '(`Web.course_lost_iff`, `Web.mutual_course_lost`, `Optimum.Renewing.keeping_holds_more`, '
         f'`Web.course_drawn_unbounded`, SG4, [study §{N}]({SA}));')
OLDT1S = 'each drawer within renewal does not keep the joint draw within it (`Pair.own_not_joint`, constructed);'
NEWT1S = ('each drawer within renewal does not keep the joint draw within it (`Pair.own_not_joint`, constructed; '
          'derived for optimizers at mutual best responses along a course, `Web.mutual_course_lost`); over a course of '
          're-optimizing steps the joint excess these laws take as given follows from the optimum and the capacity, '
          'and persistence is exact: a dependence beyond is lost exactly where the draw exceeds the renewal, and for a '
          'draw the same at every step without the claim\'s premise that renewal stops below the need '
          f'(`Web.course_lost_iff`, `Web.course_kept_iff`, [study §{N}]({SA}));')
OLDT3S = ('the drain beyond every one\'s family being their joint capacity (`Optimum.mutual_beyond`, '
          '`Optimum.MutualBest.full`);')
NEWT3S = ('the drain beyond every one\'s family being their joint capacity (`Optimum.mutual_beyond`, '
          '`Optimum.MutualBest.full`), and along a course of such steps, a dependence beyond lost exactly where the '
          'draw exceeds the renewal (`Optimum.course_beyond`, `Web.course_lost_iff`, `Web.mutual_course_lost`);')
OLD10 = line_from(ch0, '10. **What a rise draws from beyond** (further proof).')
OLD10a = '*Open:* an optimizer choosing again at each step of a course, with the rest responding;'
NEW10a = (f'Landed (SG4, [study §{N}]({SA})): an optimizer choosing again at each step of a course, the rest '
          'exchanging as it does: each step\'s level beyond is read off the one before, a dependence there renewed by '
          '`r` at its need and by at most `r` below is lost exactly where the draw exceeds `r`, for good, and kept '
          'within it; the renewal below the need decides only the drawers\' take, bounded where it stops there, so '
          'that over a long course keeping draws more, and at least the renewal a step where it does not; several '
          'optimizers jointly above the renewal lose it at mutual best responses (`Optimum.course_beyond`, '
          '`Web.course_lost_iff`, `Optimum.drawn_bounded_iff`, `Web.course_drawn_unbounded`, '
          '`Web.mutual_course_lost`). *Open:* a renewal growing with the level, an optimizer ranking courses rather '
          'than steps, and how optimizers come to a mutual best response;')
OLD10c = f'{SREC}.'
NEW10c = f'{SREC}, {REC}.'
for part in (OLD10a, OLD10c):
    assert OLD10.count(part) == 1, part
NEW10 = OLD10.replace(OLD10a, NEW10a).replace(OLD10c, NEW10c)
OLD6K = 'the tragedy of the commons and open access (Hardin 1968; Gordon 1954) |'
NEW6K = ('the tragedy of the commons and open access (Hardin 1968; Gordon 1954); open access over a renewing stock, '
         'pumping above recharge and the dynamic commons (Clark 1976; Theis 1940; Levhari and Mirman 1980) |')
OLD6 = '(`Optimum.mutual_beyond`, `Optimum.mutual_as_one`) |'
NEW6 = ('(`Optimum.mutual_beyond`, `Optimum.mutual_as_one`), and over a course a draw above the renewal losing what '
        'depends on it, exactly, the renewal below the need deciding only the drawers\' take (`Web.course_lost_iff`, '
        '`Web.course_drawn_unbounded`, `Web.mutual_course_lost`) |')
OLD_ROW = line_from(ch0, f'| [Several optimizers drain by their joint capacity](../results/records/{SG3}.md) |') + '\n'
NEW_ROW = (f'| [Re-optimizing above a renewal ends it](../results/records/{RID}.md) | theorem under stated premises | a '
           'course of re-optimizing steps or of mutual best responses; the condition beyond; a renewal of `r` at or above '
           'a positive need, at most `r` below; the draw `k` at every step; a dependence at that need; for the draw, the '
           'renewal below the need | §3.4, §7.1, §8.1 |\n')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with SG4 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
               "check and the core with the ring compiled from the prelude.")
i = ch0.index('| Core modules (with the root `Becoming`, 0 theorems) |')
j = ch0.index('\n', ch0.index('| Generated `injEq` lemmas on `propext` |', i))
OLD_TABLE = ch0[i:j]
NEW_TABLE = f"""| Core modules (with the root `Becoming`, 0 theorems) | {mods['core']} modules, {fmt(thms['core'])} theorems |
| Instance modules | {mods['instance']} modules, {fmt(thms['instance'])} theorems |
| Application modules | {mods['application']} modules, {fmt(thms['application'])} theorems |
| Foundation modules | {mods['foundation']} modules, {thms['foundation']} theorems |
| Closure (core, ring and foundation) | {closure} modules, {fmt(closure_thms)} theorems |
| Spine (the core and the ring; no bridge since F3) | {fmt(spine_thms)} theorems |
| Audited spine declarations | {fmt(spine_decls)} |
| Inherited modules bound to passed receipts by hash | 3 (the foundation) |
| Superseded periphery modules (out of the run, bytes kept) | {len(R['superseded_modules'])} |
| Modules in the compile order | {len(R['compile_order'])} |
| Generated `injEq` lemmas on `propext` | {injeq} in the closure |"""
OLD_STEPS = re.search(r'The run reused [\d,]+ cached Lean steps from `~/.cache/becoming-lean` and ran \d+;', ch0).group(0)
NEW_STEPS = f'The run reused {fmt(reused)} cached Lean steps from `~/.cache/becoming-lean` and ran {ran};'
edit(CH, [(OLD34, NEW34), (OLD34R, NEW34R), (OLD71, NEW71), (OLDT1S, NEWT1S), (OLDT3S, NEWT3S), (OLD10, NEW10),
          (OLD6K, NEW6K), (OLD6, NEW6), (OLD_ROW, OLD_ROW + NEW_ROW),
          (OLD_CORE, f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."),
          (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)])

exec((HERE / 'section9_audit.py').read_text(), {'ROOT': ROOT, 'CH': CH, 'R': R})

# Chapter, Chinese.
z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZ34 = '`Optimum.mutual_as_one`）、'
NEWZ34 = (OLDZ34 + '`Web.course_lost_iff`（部分在一个过程的每一步重新优化、其余者照常交换时，每步之外的水平由前一步按一步之律读出，'
          '`Optimum.course_beyond`；其余者在正的需要处每步更新 `r`、其下至多 `r`、所取连同容量每步为 `k` 时，该需要处的依存恰在 '
          '`r < k` 时永久丧失，`k ≤ r` 时条件留在其需要处，`Web.course_kept_iff`；需要之下的更新只决定所汲取的：在那里停止时所汲取的'
          '有界，`Web.course_ended_drawn`，每步至少给予 `a` 时所给的全被汲取，无界，`Web.course_drawn_unbounded`；合计超出更新的多个'
          '优化者一起使其丧失，`Web.mutual_course_lost`）、')
OLDZ34R = f'{SREC}、'
NEWZ34R = f'{SREC}、{REC}、'
OLDZ71 = f'SG3，[研究第 290 节]({SA290})）；'
NEWZ71 = (OLDZ71 + '在对更新的重新优化过程中，那里超出更新的容量使依存于它者永久终结，无论需要之下的更新如何，多个各在更新之内的优化者'
          '也一起使其终结；优化者自己的度量是否记录这一丧失取决于需要之下的更新：更新在需要之下停止时，更多容量在长过程中所得少于处于更新的容量，'
          '不停止时汲取者每步仍至少取得更新（`Web.course_lost_iff`、`Web.mutual_course_lost`、'
          f'`Optimum.Renewing.keeping_holds_more`、`Web.course_drawn_unbounded`，SG4，[研究第 {N} 节]({SA})）；')
OLDZT1 = '`Pair.own_not_joint`（构造的）、'
NEWZT1 = ('`Pair.own_not_joint`（构造的；对沿过程处于相互最优回应的优化者为导出的，`Web.mutual_course_lost`）、'
          '`Web.course_lost_iff`（重新优化的过程中，这些律所给定的联合超出由最优与容量得出，存续是确切的：之外的依存恰在汲取超出更新时丧失，'
          f'每步汲取相同时不需要“更新在需要之下停止”这一前提，`Web.course_kept_iff`，[研究第 {N} 节]({SA})）、')
OLDZT3 = '（`Optimum.mutual_beyond`、`Optimum.MutualBest.full`）；'
NEWZT3 = ('（`Optimum.mutual_beyond`、`Optimum.MutualBest.full`），沿这样的步组成的过程也成立：之外的依存恰在汲取超出更新时丧失'
          '（`Optimum.course_beyond`、`Web.course_lost_iff`、`Web.mutual_course_lost`）；')
OLDZ10a = '*开放：*优化者在一个过程的每一步重新选择、其余者回应；'
NEWZ10a = (f'已落地（SG4，[研究第 {N} 节]({SA})）：优化者在一个过程的每一步重新选择、其余者照常交换：每步之外的水平由前一步读出，'
           '在其需要处更新 `r`、其下至多 `r` 的依存恰在汲取超出 `r` 时永久丧失，在其内则保持；需要之下的更新只决定汲取者所取：在那里停止时'
           '有界，故长过程中保持者汲取更多，不停止时每步至少为更新；合计超出更新的多个优化者在相互最优回应中使其丧失'
           '（`Optimum.course_beyond`、`Web.course_lost_iff`、`Optimum.drawn_bounded_iff`、`Web.course_drawn_unbounded`、'
           '`Web.mutual_course_lost`）。*开放：*随水平增长的更新、对过程而非对步排序的优化者、优化者如何达到相互最优回应；')
OLDZ6K = '公地悲剧与开放进入（Hardin 1968；Gordon 1954） |'
NEWZ6K = ('公地悲剧与开放进入（Hardin 1968；Gordon 1954）；更新存量上的开放进入、超出补给的抽取与动态公地（Clark 1976；Theis 1940；'
          'Levhari and Mirman 1980） |')
OLDZ6 = '与一个相同（`Optimum.mutual_beyond`、`Optimum.mutual_as_one`） |'
NEWZ6 = ('与一个相同（`Optimum.mutual_beyond`、`Optimum.mutual_as_one`），过程中超出更新的汲取恰使依存于它者丧失，需要之下的更新只决定'
         '汲取者所取（`Web.course_lost_iff`、`Web.course_drawn_unbounded`、`Web.mutual_course_lost`） |')
OLDZROW = line_from(z, f'| [多个优化者以合计容量抽干](../results/records/{SG3}.md) |') + '\n'
NEWZROW = (f'| [在更新之上重新优化将其终结](../results/records/{RID}.md) | 在所述前提下的定理 | 重新优化的过程或相互最优回应的过程；'
           '条件在之外；在正的需要处或其上更新 `r`、其下至多 `r`；每步汲取 `k`；该需要处的依存；对汲取而言，需要之下的更新 | '
           '§3.4、§7.1、§8.1 |\n')
OLDZR = line_from(z, '**当前回执**是运行 [`')
NEWZR = (f"**当前回执**是运行 [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json)"
         f"（[当前指针](../../../{PKG}/becoming-verification.json)），以 Lean 4.29.1 检查（[研究第 {N} 节]({SA})）。")
i = z.index('| 核心模块（含根 `Becoming`） |')
j = z.index('\n', z.index('| 被取代的外围模块', i))
OLDZT = z[i:j]
NEWZT = f"""| 核心模块（含根 `Becoming`） | {mods['core']} 个模块，{fmt(thms['core'])} 条定理 |
| 实例模块 | {mods['instance']} 个模块，{fmt(thms['instance'])} 条定理 |
| 应用模块 | {mods['application']} 个模块，{fmt(thms['application'])} 条定理 |
| 根基模块 | {mods['foundation']} 个模块，{thms['foundation']} 条定理 |
| 闭包（核心、环与根基） | {closure} 个模块，{fmt(closure_thms)} 条定理 |
| 审计的脊柱声明 | {fmt(spine_decls)} |
| 在 `propext` 上的生成的 `injEq` 引理 | 闭包中 {injeq} 条 |
| 被取代的外围模块（不在运行中，字节保留） | {len(R['superseded_modules'])} |"""
edit(ZH, [(OLDZ34, NEWZ34), (OLDZ34R, NEWZ34R), (OLDZ71, NEWZ71), (OLDZT1, NEWZT1), (OLDZT3, NEWZT3),
          (OLDZ10a, NEWZ10a), (OLDZ6K, NEWZ6K), (OLDZ6, NEWZ6), (OLDZROW, OLDZROW + NEWZROW), (OLDZR, NEWZR),
          (OLDZT, NEWZT)])

# Board: the row moves to the history file; the queue and receipt sentences name the landing.
exec((HERE / 'board_part.py').read_text(), {'ROOT': ROOT, 'BOARD': BOARD, 'HISTORY': HISTORY, 'RID': RID,
                                           'receipt_id': receipt_id, 'N': N, 'n_new': n_new_thms,
                                           'd_new': len(new_decls)})
print('new declarations', len(new_decls), 'new theorems', n_new_thms, 'apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
