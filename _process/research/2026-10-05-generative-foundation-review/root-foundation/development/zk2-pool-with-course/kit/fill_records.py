#!/usr/bin/env python3
"""Write K2's three records with the current hashes (AI-written kit, 10 November 2026).

usage: python3 -B fill_records.py [RECEIPT_TIMESTAMP]

Run from the repository root. Without a receipt timestamp the records are written without a receipt
reference or proof binding (a draft for readers); with one, they are bound to that core run.
"""
import hashlib
import json
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path.cwd()
LEAN = "experiments/integrated-correction/general-framework/generative-basis/lean/becoming"
MODULE = f"{LEAN}/Becoming/PoolFromCourse.lean"
CH02 = "theories/becoming/chapters/02-MAP.md"
STUDY = "_process/research/2026-10-05-generative-foundation-review/root-foundation/development/zk2-pool-with-course"
NOTE = f"{STUDY}/NOTE.md"
DESIGN = f"{STUDY}/DESIGN.md"
REVIEW = f"{STUDY}/READER.md"
SOURCES = ["sources/15-codex-theory-conversations/2026-11-09-route-b-ethics-forms.md"]
RECORDS = ROOT / "theories/becoming/results/records"
NOW = datetime.now(timezone.utc).replace(microsecond=0).isoformat()


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def P(name):
    return f"Becoming.PoolFromCourse.{name}"


def T(en, zh):
    return {"en": en, "zh": zh}


def law(en, zh, decls):
    return {"en": en, "zh": zh, "declarations": decls}


def refs(decls, ts):
    out = [{"path": MODULE, "role": "proof", "declarations": sorted(set(decls)), "sha256": sha(MODULE)}]
    bindings = []
    if ts:
        path = f"{LEAN}/becoming-checks/{ts}/verification.json"
        assert (ROOT / path).exists(), path
        out.append({"path": path, "role": "receipt", "sha256": sha(path)})
        bindings.append({"source": MODULE, "receipt": path, "sha256_pointer": "/source_sha256/Becoming.PoolFromCourse",
                         "success_pointer": "/status", "success_value": "passed"})
    out.append({"path": NOTE, "role": "integration", "sha256": sha(NOTE)})
    out.append({"path": DESIGN, "role": "integration", "sha256": sha(DESIGN)})
    if (ROOT / REVIEW).exists():
        out.append({"path": REVIEW, "role": "review", "sha256": sha(REVIEW)})
    out.append({"path": CH02, "role": "statement", "sha256": sha(CH02)})
    for s in SOURCES:
        out.append({"path": s, "role": "provenance", "sha256": sha(s)})
    return out, bindings


def dep(id_, relation, en, zh, out_en, out_zh, in_en, in_zh, cond_en, cond_zh):
    return {"id": id_, "relation": relation, "detail": T(en, zh),
            "interface": {"output": T(out_en, out_zh), "input": T(in_en, in_zh),
                          "conditions": T(cond_en, cond_zh), "evidence": MODULE}}


BOUNDS = ["no-ethical-premise", "names-provisional", "formal-not-empirical", "discrete-steps"]

HISTORY = T(
    "10 November 2026, route (b)'s round K, on Ren's words of 9 November kept in sources "
    "(2026-11-09-route-b-ethics-forms.md) and of 10 November (the dynamics connected, mapped and unified): added. "
    "A design read cold by another model before the Lean replaced readers removed by a loss growing one a step "
    "whatever the selection did with a loss drawn off the course; that design is kept in the study's DESIGN.md.",
    "2026年11月10日，路线 (b) 第 K 轮，依 Ren 11月9日之言（存于 sources 的 2026-11-09-route-b-ethics-forms.md）"
    "及11月10日之言（诸动态相连、成图、统一）：新增。Lean 之前另一模型冷读设计，以由进程所取之损失，"
    "代替不论选择如何、每步增一之损失所除之读者；该设计存于研究之 DESIGN.md。")

VALIDATION = T(
    "Pure core, axiom report empty; a leaf. Short compositions of the lock laws of capture through the rule and of "
    "closed capture, near-definitional; the witnesses computed on small counts, their lasting outcomes by the laws. "
    "Written by an AI; readers of other models read it cold (READER); no human audit.",
    "纯核心，公理报告为空；叶模块。由规则之捕获与闭合捕获之锁律短组而成，近于定义；见证于小计数上算出，其持久之果由诸律。"
    "AI 所写；他模型之读者冷读（READER）；无人类审计。")


def record_pool(ts):
    decls = [P(n) for n in ("ReadsThroughPresent", "NotReadmitted", "liftShare", "twoShares", "read_absent",
                            "turn_locked_at", "rule_after", "locked_step", "locked_along", "closed_stays_closed",
                            "Borne.shapers_left")]
    references, bindings = refs(decls, ts)
    return {
        "schema_version": 2,
        "id": "a-pool-read-off-the-course",
        "title": T("A pool read off the course, and where a lock can be left", "读自进程之池，与锁可离之处"),
        "kind": "theorem",
        "status": "recorded-checked",
        "family": "F01",
        "reviewed_at_utc": NOW,
        "statement": T(
            "Where the rule is read through a pool whose readers of what lies beyond the share are present only "
            "where the course leaves them, a lock read off the share is kept along every stretch whose reading "
            "steps read as the share-readers do and whose share does not fall; closed, it stays closed.",
            "规则经一池而读、池中读份额之外者唯于进程留之处而在时，由份额而读之锁沿凡读步皆如份额读者所读、份额不降之段而保；已闭则常闭。"),
        "laws": [
            law("Where no reader of what lies beyond the share is present, the rule read is the share-readers' rule, "
                "read off the share alone; two such configurations alike in share give one rule read, whatever lies "
                "beyond.",
                "无读份额之外者在处，所读之规则即份额读者之规则，唯由份额而读；两此类构形份额相同，则所读之规则同一，无论其外为何。",
                [P("ReadsThroughPresent"), P("read_absent")]),
            law("One turn keeps a lock read off the share where the share does not fall and the rule read, if the "
                "step reads, is the share-readers': the one-step lock law applied at the two shares the step joins. So "
                "the lock is kept along a stretch whose reading steps read so and whose share falls at no step, and is "
                "left only along a stretch containing a reading step read otherwise or a step not keeping the share.",
                "一转保由份额而读之锁，凡其步份额不降、且若此步读则所读之规则为份额读者之规则：即规则之捕获之一步锁律，施于此步所接之二份额。沿凡读步皆如份额读者所读、份额无一步降之段，锁保而份额与规则皆不终于其始之下；故锁唯于含一异读之读步或一份额降之步之段而离。",
                [P("twoShares"), P("turn_locked_at"), P("rule_after"), P("locked_step"), P("locked_along")]),
            law("Where the selection raises the share under every favouring rule on the whole configuration and brings "
                "no reader of the beyond back once none is present, from a locked step with no reader present none is "
                "present again, the course is locked at every later step, and neither share nor rule falls below where "
                "it was.",
                "选择于整个构形上在每一偏向之规则下皆升份额、且无读者在后不复召之，则自一无读者在之锁步起，再无读者在，此后每步进程皆锁，份额与规则皆不降至其处之下。",
                [P("NotReadmitted"), P("liftShare"), P("closed_stays_closed")]),
        ],
        "hypotheses": [
            T("No axiom. Discrete steps; the two-level course with a fixed schedule of reading steps; the fast "
              "configuration the share and what lies beyond it.",
              "不加公理。离散步；带固定读步之两层进程；快构形为份额与其外者。"),
            T("Where a reader of what lies beyond is present is a supplied predicate on the configuration; that the rule "
              "read is the share-readers' where none is, and that none is brought back, are supplied.",
              "读份额之外者何处在，为构形上所给之谓词；无读者在处所读即份额读者之规则、且无读者复召，皆为所给。"),
            T("The share-readers' rule is monotone in the share, and favouring is kept upward.",
              "份额读者之规则于份额单调，偏向向上而保。"),
        ],
        "does_not_show": [
            {"en": "That a reader present and reading otherwise leaves the lock: the law gives where leaving can lie, not "
                   "that it does.", "zh": "在而异读之读者使锁离：此律示离可在何处，非示其必离。", "kind": "converse"},
            {"en": "That a fall of the share leaves the lock at once: the share can fall for steps while the course stays locked.",
             "zh": "份额一降锁即离：份额可连降数步而进程仍锁。", "kind": "non-implication",
             "witness": P("Borne.shapers_left")},
            {"en": "How many read and which lines: presence is one predicate.",
             "zh": "几者读、何系读：在与否只是一谓词。", "kind": "scope"},
            {"en": "That actual pools are read off courses so, or that their readers are removed so.",
             "zh": "实际之池如此读自进程，或其读者如此被除。", "kind": "correspondence"},
        ],
        "counterexamples": [
            {"path": MODULE, "detail": T(
                "Against reading the contrapositive as locating the exit: with a loss borne by the carriers the share "
                "falls across each of the three steps from step 1 to step 4 while the course is locked at steps 1 to 3; "
                "the lock is left at step 4 (Borne.shapers_turned, Borne.shapers_left).",
                "反对以逆否定离之所：损失由携者担时，份额自第1步至第4步之三步每步皆降，而进程于第1至3步仍锁；锁于第4步方离（Borne.shapers_turned、Borne.shapers_left）。")},
        ],
        "standard_boundaries": BOUNDS,
        "validation_scope": VALIDATION,
        "next_delta": T(
            "The pool's presence read off lines carrying readings under selection by share, so that how many read and "
            "variation at descent, a readmission, enter.",
            "以份额之选择下携读法之诸系读池之在，使几者读与传承之变（一种复召）得入。"),
        "correspondence": T(
            "Reading (the AI's, from its knowledge): a rule whose critics or auditors are removed by the course it "
            "favours, and then read by those who remain, as in regulatory capture once the regulated staff the "
            "regulator; for trained systems, an evaluation whose raters are drawn from the outputs it selects.",
            "解读（AI 据其知识）：一规则之批评者或审计者为其所偏向之进程所除、而后由余者读之，如受规管者为规管者配员后之规管俘获；就训练之系统，评分者取自其所选之输出之评估。"),
        "canonical_source": MODULE,
        "aliases": ["a pool read off the course", "where a lock read off the share can be left", "读自进程之池",
                    P("locked_along"), P("closed_stays_closed")],
        "dependencies": [
            dep("capture-through-the-rule", "formal-reuse",
                "Reuses the one-step lock law at the two shares a step joins.", "复用一步锁律，施于一步所接之二份额。",
                "One turn keeps a lock under a selection raising the share and a reading monotone in it.",
                "选择升份额、读于份额单调时，一转保锁。",
                "The share before and after one step, ordered; the share-readers' rule.", "一步前后之份额，有序；份额读者之规则。",
                "The share not falling at the step; the rule read the share-readers' at a reading step.",
                "此步份额不降；读步所读之规则为份额读者之规则。"),
        ],
        "related": [
            {"id": "closed-capture", "detail": T(
                "A lock outliving a loss nothing in the loop reads is the case with no reader of the beyond ever present.",
                "循环中无物读之损失为锁所越，乃无读外者曾在之情形。")},
            {"id": "a-selection-removing-its-readers", "detail": T(
                "The same shape with persistence as the selection; here selection by share through a rule.",
                "同一形，以存续为选择；此处为经规则之以份额之选择。")},
            {"id": "a-pool-that-recruits-through-itself", "detail": T(
                "Not readmitting a reader is an analogue of recruiting through the pool, supplied here.",
                "不复召读者类于经池而募，此处为所给。")},
        ],
        "references": references,
        "proof_bindings": bindings,
        "history": [HISTORY],
    }


def record_window(ts):
    names = ("windowRead", "Stands", "window_through", "window_unread", "stands_not_readmitted", "joint_raises",
             "window_past", "window_never_read", "window_past_course", "window_removed_unregistered",
             "window_locked_after_removal", "window_standing_thinned", "withBound", "boundRead", "boundOrder",
             "bound_course", "boundRead_reads", "window_order_kept",
             "Drained.eightToOne", "Drained.drain", "Drained.readLoss", "Drained.window", "Drained.clock",
             "Drained.drained", "Drained.drain_accrues", "Drained.clock_accrues", "Drained.outnumber_mono",
             "Drained.drawn_mono", "Drained.drain_mono", "Drained.lo_below", "Drained.premises",
             "Drained.clock_turned", "Drained.strong_undone", "Drained.weak_turned", "Drained.strong_not_below")
    decls = [P(n) for n in names]
    references, bindings = refs(decls, ts)
    return {
        "schema_version": 2,
        "id": "the-lock-draws-its-readers-out",
        "title": T("Readers a loss removes, and the lock drawing them out", "损失所除之读者，与锁之引其出"),
        "kind": "theorem",
        "status": "recorded-checked",
        "family": "F01",
        "reviewed_at_utc": NOW,
        "statement": T(
            "Readers of a loss who stand only while it is below a bound are removed by it, not readmitted; past it the "
            "course is the share's own loop, whatever they read. With selection, readings and drain monotone, a "
            "share not lower sends them no later, and their going sooner leaves it not lower.",
            "损失之读者唯于其在界下时立，为其所除且不复召；界后进程即份额自身之环，无论其所读。损失由份额单调而取时，份额不低则其去不迟；其去早则份额不低。"),
        "laws": [
            law("Let readers of a loss read it as one rule while it lies from one bound up to a second and be gone from "
                "the second on. Where the loss accrues they are not readmitted; where the second bound is not above the "
                "first, the loss removes them before they read it and a locked start stays locked while the loss passes "
                "every bound.",
                "设损失之读者于其自一界至二界之间读之为一规则，自二界起而去。损失累增时不复召；二界不在一界之上时，损失于其读之前除之，锁始常锁而损失越过每一界。",
                [P("windowRead"), P("Stands"), P("window_through"), P("window_unread"), P("stands_not_readmitted"),
                 P("joint_raises"), P("window_never_read")]),
            law("Past the second bound the course is the share's own loop from the configuration it has reached, and "
                "two readings of the removed readers give one course; a step locked there is locked for good. While "
                "they stand, read as the pool of readers drawn from the selected, the window is the others' late "
                "reading of the loss; past it the others read as before, their count unchanged.",
                "过二界后，进程即自所至之构形起份额自身之环，被除读者之二读法给同一进程；于彼处锁之步永锁。其立之时，以取自被选者之读者池读之，此窗即他者迟读损失；界后他者如前而读，其数不变。",
                [P("window_past"), P("window_past_course"), P("window_removed_unregistered"),
                 P("window_locked_after_removal"), P("window_standing_thinned")]),
            law("Where the readers read from when they stand, their own reading monotone in the share and the loss and "
                "never more favourably than the share-readers, and the selection, the share-readers' reading and the loss "
                "drawn at each step are monotone, two courses keep their order in share, loss and rule, the readers' "
                "bound reversed.",
                "读者自其立时即读、其读于份额与损失单调且从不比份额读者更偏，且选择、份额读者之读与每步所取之损失皆单调时，两进程于份额、损失与规则保其序，读者之界反之。",
                [P("withBound"), P("boundRead"), P("boundOrder"), P("bound_course"), P("boundRead_reads"),
                 P("window_order_kept")]),
            law("Witness: readers reading against the carriers while the loss is below 4, from eight carriers to one. "
                "With the loss one a step the course is turned for good from step 4; with "
                "forty more drawn where the carriers outnumber the others sixteen to one, the readers read twice and "
                "the lock is back for good from step 3. From two to one it is turned for good from step 4, and the "
                "course from eight to one is below it at no step.",
                "见证：同一读者，损失在4下时逆携者而读；同一始，八携者对一他者。损失每步增一时，自第4步永转；携者以十六比一胜他者之步多取四十时，读者只读二次，自第3步锁永归。自二比一，所取之进程自第4步永转；自八比一之进程无一步在其下。",
                [P("Drained.clock_turned"), P("Drained.strong_undone"), P("Drained.weak_turned"),
                 P("Drained.premises"), P("Drained.strong_not_below"), P("Drained.drain_mono")]),
        ],
        "hypotheses": [
            T("No axiom. Discrete steps; a loss growing by at least one a step; the readers' standing ending at a bound "
              "of the loss, supplied.", "不加公理。离散步；损失每步至少增一；读者之立止于损失之一界，为所给。"),
            T("For the laws before and past the bound: the share's selection raising it under a favouring rule, the "
              "share-readers' rule monotone in the share, favouring kept upward.",
              "就界前界后之律：份额之选择于偏向之规则下升之，份额读者之规则于份额单调，偏向向上而保。"),
            T("For the order law: the readers read from when they stand, their own reading monotone in the share and the "
              "loss and never more favourably than the share-readers; selection, the share-readers' reading and the drain "
              "monotone.",
              "就序律：读者自立即读，其读于份额与损失单调且从不比份额读者更偏；选择、份额读者之读与所取皆单调。"),
            T("In the witness, the drain stepping up where the carriers outnumber the others sixteen to one is chosen.",
              "见证中，携者以十六比一胜他者时所取跃升，为所择。"),
        ],
        "does_not_show": [
            {"en": "That actual readers of a loss are removed by it, or that any drain grows with a share.",
             "zh": "实际损失之读者为其所除，或任何所取随份额而增。", "kind": "correspondence"},
            {"en": "The order law where the readers start reading late: starting to read lowers the rule.",
             "zh": "读者迟始读时之序律：始读使规则降。", "kind": "scope"},
            {"en": "That the selection prefers the removal beyond the order the law keeps, or an optimizer aiming at it.",
             "zh": "选择于此律所保之序外偏向除去，或有优化者以之为的。", "kind": "non-implication"},
            {"en": "Noise, or the step from which a window can no longer turn the course.",
             "zh": "噪声，或自何步起窗不复能转进程。", "kind": "scope"},
        ],
        "counterexamples": [
            {"path": MODULE, "detail": T(
                "Against a reading of a loss that turns the rule while its readers stand holding the turn: from eight to "
                "one under the drain the rule in force favours the others at steps 1 and 2, and from step 3 the course is "
                "locked in the carriers' favour for good (Drained.strong_undone).",
                "反对损失之读于其读者立时转规则即保其转：自八比一于所取之下，所行之规则于第1、2步偏向他者，自第3步进程永锁于携者一方（Drained.strong_undone）。")},
        ],
        "standard_boundaries": BOUNDS,
        "validation_scope": VALIDATION,
        "next_delta": T(
            "The same read in time: when a reading of a loss reaches the rule before the lock draws its readers out, "
            "with readers who start reading late; and the readers counted by kind inside the window.",
            "同之及时而读：损失之读何时于锁引其读者出之前及于规则，读者迟始读；并于窗中按类计读者。"),
        "correspondence": T(
            "Reading (the AI's, from its knowledge): a resource capture whose rents fund the removal of those who "
            "bear and report its costs (an extractive regime's critics leaving or silenced as the extraction grows); "
            "for trained systems, a feedback channel staffed by those whose standing the deployment erodes. The "
            "window is Collingridge's dilemma with the readers' presence, not only their information, timed by the "
            "course.",
            "解读（AI 据其知识）：一资源之捕获以其租金去除担负并报告其代价者（采掘之制随采掘而增，其批评者离去或噤声）；就训练之系统，由部署所侵其立者所配之反馈渠道。此窗即 Collingridge 之困局，读者之在而非仅其信息为进程所定时。"),
        "canonical_source": MODULE,
        "aliases": ["readers a loss removes", "the lock drawing its readers out", "损失所除之读者",
                    P("window_order_kept"), P("window_past_course")],
        "dependencies": [
            dep("closed-capture", "formal-reuse",
                "Reuses readings alike past a bound giving one course, and the joined course's share and rule.",
                "复用界后读法相同给同一进程，及所接进程之份额与规则。",
                "One course past a bound; the joined course run by the share's law.", "界后同一进程；所接进程由份额之律而行。",
                "The window past its bound.", "过界之窗。",
                "The loss accruing; the readings agreeing past the bound.", "损失累增；界后读法一致。"),
            dep("capture-through-the-rule", "formal-reuse",
                "Reuses two courses of a monotone two-level law keeping their order.", "复用单调两层律之两进程保其序。",
                "Order kept at every step.", "每步序保。",
                "The configuration with the readers' bound carried.", "携读者之界之构形。",
                "Selection, reading and drain monotone; the bound reversed in the order.", "选择、读与所取单调；序中界反。"),
            dep("readers-drawn-from-the-selected", "formal-reuse",
                "The window while its readers stand is the others' late reading of the loss.", "窗于其读者立时即他者迟读损失。",
                "The loss pool.", "损失之池。",
                "The window read through the pool of readers drawn from the selected.", "经取自被选者之读者池而读之窗。",
                "The readers standing.", "读者立。"),
            dep("a-pool-read-off-the-course", "formal-reuse",
                "Reuses closed, it stays closed, with the readers' standing as presence.", "复用已闭则常闭，以读者之立为在。",
                "A lock kept for good with no reader present.", "无读者在时锁永保。",
                "The window past its bound.", "过界之窗。",
                "Not readmitted where the loss accrues.", "损失累增时不复召。"),
        ],
        "related": [
            {"id": "loss-read-in-time-by-the-others", "detail": T(
                "The loss read in time by readers who are never removed; here the loss removes them.",
                "由从不被除之读者及时读损失；此处损失除之。")},
            {"id": "a-selection-removing-its-readers", "detail": T(
                "The selection removing its readers with persistence as the selection; here the lock draws them out.",
                "以存续为选择之除其读者之选择；此处锁引之出。")},
        ],
        "references": references,
        "proof_bindings": bindings,
        "history": [HISTORY],
    }


def record_borne(ts):
    names = ("bear", "borneStep", "bear_shaped_shapers", "bear_shaped_others", "borne_by_shapers_favours_iff",
             "borne_by_others_favours_iff", "borne_by_others_raises", "borne_falls",
             "Borne.toll", "Borne.onShapers", "Borne.onOthers", "Borne.shapers_turned", "Borne.locked_hi",
             "Borne.shapers_left", "Borne.others_locked")
    decls = [P(n) for n in names]
    references, bindings = refs(decls, ts)
    return {
        "schema_version": 2,
        "id": "on-whom-the-loss-falls",
        "title": T("On whom the loss falls", "损失落于谁"),
        "kind": "theorem",
        "status": "recorded-checked",
        "family": "F01",
        "reviewed_at_utc": NOW,
        "statement": T(
            "Borne by the shapers, a loss is a cost in the lever of shaping; borne by the others, a return. Borne by "
            "the others a lock stays closed with no reader of the loss; borne by the shapers past what the rule gives "
            "them, the share falls with no reader of it.",
            "塑规者所担之损失为塑规之杠杆中之成本；他者所担则为回报。他者担时，无损失之读者锁亦常闭；塑规者担而过规则所给时，无读者份额亦降。"),
        "laws": [
            law("Written as the capacity to shape the rule writes a cost and a return, a loss borne by the shapers adds "
                "to the others' count and one borne by the others to the shapers'. On the rule after shaping it adds "
                "to the cost, or to what comes back to the shapers alone; the rule favours them exactly where the cost "
                "with the loss is at most what comes back, or the cost at most what comes back with it.",
                "依塑规之能力书成本与回报之式，塑规者所担之损失加于他者之数，他者所担加于塑规者之数。于塑后之规则，塑规者担则加于成本，他者担则加于唯归塑规者之所返；规则偏向塑规者，恰当成本加损失不过所返，或成本不过所返加损失。",
                [P("bear"), P("borneStep"), P("bear_shaped_shapers"), P("bear_shaped_others"),
                 P("borne_by_shapers_favours_iff"), P("borne_by_others_favours_iff")]),
            law("Borne by the others, the joint selection raises the share under every favouring rule, so a lock that "
                "is closed stays closed with no reader of the loss. Borne by the shapers past what the rule in force "
                "gives them, the share falls strictly, the shapers present.",
                "他者担时，合选在每一偏向之规则下皆升份额，故已闭之锁无损失之读者亦常闭。塑规者担而过所行之规则所给时，份额严格降，塑规者在。",
                [P("borne_by_others_raises"), P("borne_falls")]),
            law("Witness: carriers two to one under four to one, the threshold reading, no reader of the loss. Borne by "
                "the carriers at four a unit, the share falls across each step from 1 to 4 while the rule in force "
                "favours them, the course locked at steps 1 to 3 and not at 4, and the rule in force favours the others at step "
                "5; borne by the others, the course is locked at every step.",
                "见证：携者二比一，于四比一之下，阈读，无损失之读者。携者每单位担四时，份额自第1至4步每步皆降而所行之规则仍偏向之，进程于第1至3步锁、第4步不锁，第5步所行之规则偏向他者；他者担时，进程每步皆锁。",
                [P("Borne.toll"), P("Borne.onShapers"), P("Borne.onOthers"), P("Borne.shapers_turned"),
                 P("Borne.locked_hi"), P("Borne.shapers_left"), P("Borne.others_locked")]),
        ],
        "hypotheses": [
            T("No axiom. Natural counts; selection multiplying each kind by what the rule in force gives it, the loss "
              "borne added as the capacity to shape the rule writes a cost and a return.",
              "不加公理。自然数之计数；选择以所行之规则所给乘各类，所担之损失依塑规之能力书成本与回报之式而加。"),
            T("Whom the loss falls on is supplied, as a function of the loss.", "损失落于谁为所给，作为损失之函数。"),
        ],
        "does_not_show": [
            {"en": "Who actually bears the losses a shaping causes.", "zh": "实际上谁担塑规所致之损失。",
             "kind": "correspondence"},
            {"en": "A loss borne by readers beyond the share, which enters neither count; that is the window's case.",
             "zh": "由份额外之读者所担之损失，不入任一计数；此为窗之情形。", "kind": "scope"},
            {"en": "That a loss borne by the shapers turns the rule before it passes its point of no return.",
             "zh": "塑规者所担之损失于其过不可返之点前转规则。", "kind": "non-implication"},
        ],
        "counterexamples": [
            {"path": MODULE, "detail": T(
                "Against a loss entering the share always leaving the lock: borne by the others it enters the share on the "
                "side the rule disfavours and the course is locked at every step (Borne.others_locked).",
                "反对入份额之损失必使锁离：他者担时，它于规则所不偏之一方入份额，进程每步皆锁（Borne.others_locked）。")},
        ],
        "standard_boundaries": BOUNDS,
        "validation_scope": VALIDATION,
        "next_delta": T(
            "Who bears the loss read off the course too, the shaping choosing where its losses fall, joined to the "
            "capacity's selection across a stretch.",
            "谁担损失亦读自进程，塑规择其损失所落之处，接于该能力跨一段之选择。"),
        "correspondence": T(
            "Reading (the AI's, from its knowledge): liability and internalized externalities (a polluter-pays rule) "
            "turn the loss into a cost the shapers read; an externality borne by those the rule already disfavours "
            "strengthens the lock instead.",
            "解读（AI 据其知识）：责任与外部性之内化（污染者付费之规）使损失成塑规者所读之成本；由规则已不偏者所担之外部性反固其锁。"),
        "canonical_source": MODULE,
        "aliases": ["on whom the loss falls", "a loss borne by the shapers or the others", "损失落于谁",
                    P("bear_shaped_shapers"), P("borne_by_others_raises")],
        "dependencies": [
            dep("shaping-the-rule-selected-by-what-comes-back", "formal-reuse",
                "Reuses the rule after shaping, where it favours the shapers, and the strict fall of the share.",
                "复用塑后之规则、其偏向塑规者之处、与份额之严格降。",
                "The rule after shaping; the lever.", "塑后之规则；杠杆。",
                "The rule in force with the loss borne.", "担损失之所行规则。",
                "The loss added as a cost or a return.", "损失作为成本或回报而加。"),
            dep("a-pool-read-off-the-course", "formal-reuse",
                "Reuses closed, it stays closed, with no reader of the loss.", "复用已闭则常闭，无损失之读者。",
                "A lock kept at every step.", "每步锁保。",
                "The selection with the loss borne by the others.", "他者担损失之选择。",
                "Raising the share under every favouring rule.", "在每一偏向之规则下升份额。"),
        ],
        "related": [
            {"id": "closed-capture", "detail": T(
                "A loss entering the share is listed among the ways out of the lock; here, borne by the disfavoured alone "
                "it does not leave, and borne by the favoured past what the rule gives the share falls and in the "
                "witness the lock is left; mixed bearing is not stated.",
                "入份额之损失列于离锁之途；此处唯由不被偏者担时不离，由被偏者担而过规则所给时份额降、见证中锁离；兼担者未述。")},
        ],
        "references": references,
        "proof_bindings": bindings,
        "history": [HISTORY],
    }


def main():
    ts = sys.argv[1] if len(sys.argv) > 1 else None
    for rec in (record_pool(ts), record_window(ts), record_borne(ts)):
        path = RECORDS / f"{rec['id']}.json"
        path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print("wrote", path.relative_to(ROOT))


if __name__ == "__main__":
    main()
