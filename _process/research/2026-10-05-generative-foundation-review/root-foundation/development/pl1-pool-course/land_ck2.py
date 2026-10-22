#!/usr/bin/env python3
"""CK2 landing texts (after land_docs.py): record, study section, chapter section 5 and 8.1 item 3 (EN, ZH), overview.

usage: python3 -B land_ck2.py RECEIPT_TS   (from the checkout root; idempotent)
"""
import json
import re
import sys
from datetime import datetime, timezone

import land_docs as D


def main(ts):
    receipt = f'{D.LEAN}/becoming-checks/{ts}/verification.json'
    assert (D.ROOT / receipt).exists(), receipt
    now = datetime.now(timezone.utc).replace(microsecond=0).isoformat()
    title = 'How a center forms, and when the region it acts on is the region it can represent (CK2)'
    study = D.read(D.STUDY)
    m = re.search(r'^## (\d+)\. ' + re.escape(title), study, re.M)
    if m:
        n = int(m.group(1))
    else:
        n = max(int(x) for x in re.findall(r'^## (\d+)\. ', study, re.M)) + 1
        body = f"""*Delta.* After CK1, §8.1 item 3 left open how a center forms as a formation, and whether the region it acts for is the one it can represent. `Becoming.Feedback` had a formation's reach closure (what it can affect) and influence closure (what can affect it), and `Becoming.MutualDependence` the case where both are the whole. `Becoming.Centers` states where they meet in any flow.

*Laws.* Two formations lie in one loop where each can affect the other's continuation at some remove (`Flow.InOneLoop`): an equivalence, so loops partition the formations. A formation's acts return where whatever it can affect can affect it (`Flow.ReachReturns`). That holds exactly where everything it reaches lies in its loop (`Flow.reachReturns_iff_loop`) and exactly where its loop is closed under affecting (`Flow.reachReturns_iff_closed`); it is a property of the whole loop (`ReachReturns.of_loop`). Where a formation's acts return, everything it acts on lies within its coupling closure, what it can represent (CK1), for every coupling by level (`ReachReturns.represented`), and with coupling by threshold only the two coincide exactly (`Flow.reachReturns_iff_represented`). As exchange grows, loops only merge (`InOneLoop.mono`); returning is not monotone. In `Line`, a acts on b and b not back, so a's acts do not return and b's do; when b comes to exchange with what a depends on, a and b are one loop whose acts return. With finitely many formations listed and reach decided, every formation's reach holds a formation whose acts return (`Flow.exists_reachReturns`): following what a formation acts on and does not hear back from, the reach shrinks strictly until it closes.

*Reading* [AI reading]. A center, read as a formation-level object, is a loop of mutual reach whose acts return: a loop closed under affecting, a sink of the graph of loops. It forms where a link closes a loop, and wherever formations are finitely many there is one downstream of every formation. The region a center acts on is the region it can represent exactly where its acts return; otherwise some formation it acts on can never affect it, which is the gap for one's own act at that formation.

*Boundary.* A formation that affects nothing beyond itself counts as returning, trivially. Returning is a property of reach closures read off one flow, not of persisting along a run; whether a returning loop persists, and which loop a formation draws its own region along when several are read, are not derived.

*Premises.* Reach and influence read through dependence at some step and exchange at some step (`Becoming.Feedback`); finitely many formations and decided reach where stated. No axiom: 22 theorems, empty axiom reports, core receipt `{ts}`.

*Output → input.* Chapter §5 and §8.1 item 3; record [where-a-formations-acts-return](../../../../theories/becoming/results/records/where-a-formations-acts-return.md); the generative-alignment overview.
"""
        study = study.rstrip('\n') + f'\n\n## {n}. {title}\n\n' + body
        D.write(D.STUDY, study)
    anchor = f'{n}-' + D.slug(title)
    S = f'../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{anchor}'

    ch = D.read(D.CHAPTER)
    ch = D.replace_once(ch,
        "in `Relay` the bound is attained at two links. How a center forms as a formation, and whether the region it acts for is the one it can represent, are not derived.\n",
        f"in `Relay` the bound is attained at two links.\n- `Flow.reachReturns_iff_closed` (CK2, [study §{n}]({S})): how a center forms, and when the region it acts on is the region it can represent. Two formations lie in one loop where each can affect the other's continuation at some remove (`Flow.InOneLoop`, an equivalence). A formation's acts return where whatever it can affect can affect it, exactly where its loop is closed under affecting, a property of the whole loop. Then everything it acts on lies within what it can represent, for every coupling by level (`ReachReturns.represented`), exactly so with coupling by threshold only (`Flow.reachReturns_iff_represented`). Loops only merge as exchange grows (`InOneLoop.mono`); in `Line` closing one link makes one returning loop. With finitely many formations and reach decided, every formation's reach holds a formation whose acts return (`Flow.exists_reachReturns`). Read as a formation-level object [AI reading], a center is such a loop: it forms where a link closes it, and where its acts do not return, some formation it acts on can never affect it, the gap for one's own act there. A formation affecting nothing beyond itself returns trivially; whether a returning loop persists along a run is not derived.\n",
        'Flow.reachReturns_iff_closed` (CK2')
    ch = D.replace_once(ch,
        "*Open:* how a center forms as a formation and represents its boundary and dependence; whether the region it acts for is the one it can represent;",
        f"Landed (CK2, [study §{n}]({S})): a center is a loop of mutual reach whose acts return, closed under affecting; it forms where a link closes the loop, loops only merge as exchange grows, and over finitely many formations every formation's reach holds one; where its acts return, all it acts on lies within what it can represent, exactly so with coupling by threshold only (`Flow.reachReturns_iff_closed`, `Flow.reachReturns_iff_represented`, `Flow.exists_reachReturns`, §5). *Open:* whether a returning loop persists along a run;",
        'Landed (CK2')
    D.write(D.CHAPTER, ch)

    zh = D.read(D.CHAPTER_ZH)
    zh = D.replace_once(zh,
        "中心作为形成如何形成，仍开放。",
        "中心为相互所及之环，其行动回返恰当其环于影响下封闭，此为全环之性质；一链接闭环即成中心，有限多形成时每一形成之所及中皆有之；行动回返处，其所作用者皆在其能表示者之内，仅依阈值耦合时恰相合（CK2，`Flow.reachReturns_iff_closed`）。回返之环是否沿历程持续，仍开放。",
        '（CK2，')
    zh = D.replace_once(zh, "`TimedResponse.answer_alike_far`、`Web.significance_undetermined`",
        "`TimedResponse.answer_alike_far`、`Flow.reachReturns_iff_closed`、`Web.significance_undetermined`",
        '`Flow.reachReturns_iff_closed`、`Web.significance_undetermined`')
    D.write(D.CHAPTER_ZH, zh)

    mod = 'Centers'
    src = f'{D.LEAN}/Becoming/{mod}.lean'
    Fl = 'Becoming.Flow.'
    laws = [
        dict(en="Two formations lie in one loop where each can affect the other's continuation at some remove: an equivalence, so loops partition the formations; being in a formation's reach is that formation being in one's influence closure.",
             zh='两形成各能于某距影响对方之延续，则同在一环：此为等价，故诸环分割诸形成；在一形成之所及内，即该形成在己之影响闭包内。',
             declarations=[Fl + 'InOneLoop', Fl + 'InOneLoop.refl', Fl + 'InOneLoop.symm', Fl + 'InOneLoop.trans', Fl + 'withinReach_iff_influence']),
        dict(en="A formation's acts return where whatever it can affect can affect it: exactly where everything it reaches lies in its loop, and exactly where its loop is closed under affecting; returning is a property of the loop.",
             zh='一形成凡能影响者皆能影响之，则其行动回返：恰当其所及皆在其环内，亦恰当其环于影响下封闭；回返为环之性质。',
             declarations=[Fl + 'ReachReturns', Fl + 'reachReturns_iff_loop', Fl + 'reachReturns_iff_closed', Fl + 'ReachReturns.of_loop']),
        dict(en='Where acts return, everything acted on lies within the coupling closure, what can be represented, for every coupling by level; with coupling by threshold only, acts return exactly where everything acted on can be represented.',
             zh='行动回返处，所作用者皆在耦合闭包之内，即能表示者，对一切依水平之耦合皆然；仅依阈值耦合时，行动回返恰当所作用者皆能被表示。',
             declarations=[Fl + 'ReachReturns.represented', Fl + 'reachReturns_iff_represented']),
        dict(en="Loops only merge as exchange grows, while returning is not monotone: where one formation acts on another that does not act back, the first's acts do not return and the second's do; closing the link makes one loop whose acts return.",
             zh='交换增长时诸环只合并，而回返非单调：一形成作用于不回作用之另一形成，前者之行动不回返而后者回返；闭合此链接即成一回返之环。',
             declarations=[Fl + 'InOneLoop.mono', 'Becoming.Line.open_not_returns', 'Becoming.Line.open_b_returns',
                           'Becoming.Line.closed_one_loop', 'Becoming.Line.closed_returns']),
        dict(en="With finitely many formations listed and reach decided, every formation's reach holds a formation whose acts return.",
             zh='诸形成有限可列且所及已定，则每一形成之所及中皆有其行动回返之形成。',
             declarations=[Fl + 'exists_reachReturns', Fl + 'holdsCount_pos', Fl + 'holdsCount_lt', Fl + 'search']),
    ]
    decls = sorted({d for law in laws for d in law['declarations']})
    rec = dict(
        schema_version=2, id='where-a-formations-acts-return',
        title=dict(en="How a center forms: where a formation's acts return", zh='中心之形成：形成之行动回返之处'),
        kind='theorem', status='recorded-checked', family='F07', reviewed_at_utc=now,
        statement=dict(en="Two formations lie in one loop where each can affect the other. A formation's acts return, all it acts on lying within what it can represent, exactly where its loop is closed under affecting; loops form as links close them, and over finitely many formations every reach holds one.",
                       zh='两形成能互相影响则同在一环。一形成之行动回返，其所作用者皆在其能表示者之内，恰当其环于影响下封闭；诸环随链接闭合而成，有限多形成时每一所及中皆有之。'),
        laws=laws,
        hypotheses=[dict(en='No axiom. Reach and influence are read off one flow and one web through dependence at some step and exchange at some step (Becoming.Feedback). Finitely many formations listed and reach decided where stated.',
                         zh='不加公理。所及与影响经某步之依存与某步之交换读自一流一网（Becoming.Feedback）。所述处诸形成有限可列且所及已定。')],
        does_not_show=[dict(en='Whether a returning loop persists along a run: returning is a property of the reach closures of one flow.', zh='回返之环是否沿历程持续：回返为一流之所及闭包之性质。', kind='scope'),
                       dict(en='That a returning formation acts for anything: a formation that affects nothing beyond itself returns trivially.', zh='回返之形成为何者而行动：不影响自身以外者之形成平凡地回返。', kind='non-implication'),
                       dict(en='Which loop a formation draws its own region along when several relations are read.', zh='读多种关系时一形成沿何环划其自身之区域。', kind='scope')],
        counterexamples=[],
        standard_boundaries=['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical', 'names-provisional'],
        validation_scope=dict(
            en=f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {ts}): the {len(decls)} declarations cited here have empty axiom reports; the checker verifies core purity. Built and reviewed in one session; author review in study section {n}; not independently reviewed by a person.',
            zh=f'Lean 4.29.1 合并检查器实查（回执 {ts}）：本记录所引 {len(decls)} 项声明公理报告为空；检查器并核对核心纯净。在一个会话中构建并审查；作者审查见研究第 {n} 节；未经人的独立审查。'),
        next_delta=dict(en='Whether a returning loop persists along a run (with ContinuedClasses and Persistence); returning loops under several relations at once; an independent review.',
                        zh='回返之环是否沿历程持续（与 ContinuedClasses、Persistence）；多种关系同时之回返之环；独立审查。'),
        correspondence=dict(en='The strongly connected components of a directed graph and the sink components of its condensation (every finite directed graph has one, reachable from every vertex); in ecology, closed loops of interaction within a food web; in systems theory, operational closure.',
                            zh='有向图之强连通分量与其凝聚图之汇分量（每一有限有向图皆有之，自每一顶点可达）；生态学中食物网内交互之闭环；系统论中之运作封闭。'),
        canonical_source=src, aliases=decls,
        dependencies=[dict(id='what-a-center-can-know-by-a-step', relation='formal-reuse', detail=dict(en="The region a center can represent is its coupling closure (CK1); this record says when the region it acts on lies within it.", zh='中心能表示之区域为其耦合闭包（CK1）；本记录说其所作用之区域何时在其内。'))],
        related=[dict(id='whole-first-and-bounded-centers', detail=dict(en="Answers its Next, a model of how a center forms and represents its boundary, for the region acted on and the region represented.", zh='就所作用之区域与所表示之区域，答其下一步：中心如何形成并表示其边界之模型。')),
                 dict(id='the-gap-for-ones-own-act', detail=dict(en='Where acts do not return, some formation acted on can never affect the actor: that gap, at that formation.', zh='行动不回返处，所作用之某形成永不能影响行动者：即该处之差距。'))],
        references=[dict(path=src, role='proof', declarations=decls, sha256=D.sha(src)),
                    dict(path=receipt, role='receipt', sha256=D.sha(receipt)),
                    dict(path=D.STUDY, role='integration', sha256=D.sha(D.STUDY)),
                    dict(path=D.CHAPTER, role='statement', sha256=D.sha(D.CHAPTER))],
        proof_bindings=[dict(source=src, receipt=receipt, sha256_pointer=f'/source_sha256/Becoming.{mod}',
                             success_pointer='/status', success_value='passed')],
        history=[dict(en=f'22 October 2026: added (CK2), for chapter §8.1 item 3; study section {n}.', zh=f'2026年10月22日：新增（CK2），为章 §8.1 第 3 项；研究第 {n} 节。')])
    D.write(f"{D.RECORDS}/{rec['id']}.json", json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
    # refresh the CK1 record's chapter and study hashes, which this script's edits changed
    for rid in ('what-a-center-can-know-by-a-step', 'a-pool-that-recruits-through-itself', 'coupling-closures-of-training-pipelines'):
        p = f'{D.RECORDS}/{rid}.json'
        r = json.loads(D.read(p))
        for ref in r['references']:
            if ref['path'] in (D.CHAPTER, D.STUDY):
                ref['sha256'] = D.sha(ref['path'])
        D.write(p, json.dumps(r, ensure_ascii=False, indent=2) + '\n')

    g = json.loads(D.read(D.GOAL))
    o = g['overview']
    o['summary']['en'] = o['summary']['en'].replace(
        "and what a center can come to know of its reach grows by at most one coupling link a step. ",
        "what a center can come to know of its reach grows by at most one coupling link a step, and a center, a loop of mutual reach, can represent all it acts on exactly where its acts return. ")
    o['summary']['zh'] = o['summary']['zh'].replace(
        "中心对其所及能知者每步至多增一耦合链接。",
        "中心对其所及能知者每步至多增一耦合链接；中心为相互所及之环，恰当其行动回返时能表示其所作用者。")
    o['next_step']['en'] = o['next_step']['en'].replace(
        "Prove how a center forms as a formation, and whether the region it acts for is the one it can represent; state",
        "State whether a center's returning loop persists along a run; state")
    o['next_step']['zh'] = o['next_step']['zh'].replace(
        "证明中心作为形成如何形成，及其所为之区域是否即其能表示者；说明",
        "说明中心之回返之环是否沿历程持续；说明")
    D.write(D.GOAL, json.dumps(g, ensure_ascii=False, indent=2) + '\n')
    print('CK2 section', n)


if __name__ == '__main__':
    main(sys.argv[1])
