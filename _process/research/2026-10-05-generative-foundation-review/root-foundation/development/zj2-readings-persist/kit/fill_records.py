#!/usr/bin/env python3
"""Write J2's three records with the current hashes (AI-written kit, 9 November 2026).

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
MODULE = f"{LEAN}/Becoming/ReadingsPersist.lean"
CH07 = "theories/becoming/chapters/07-SIGNIFICANCE.md"
STUDY = "_process/research/2026-10-05-generative-foundation-review/root-foundation/development/zj2-readings-persist"
NOTE = f"{STUDY}/NOTE.md"
REVIEW = f"{STUDY}/READER.md"
SOURCES = ["sources/15-codex-theory-conversations/2026-11-09-route-b-ethics-forms.md",
           "sources/15-codex-theory-conversations/2026-11-08-within-becoming-no-should.md"]
RECORDS = ROOT / "theories/becoming/results/records"


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def B(name):
    return f"Becoming.{name}"


def H(name):
    return f"Becoming.ReadingsPersist.Habitat.{name}"


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
        bindings.append({"source": MODULE, "receipt": path, "sha256_pointer": "/source_sha256/Becoming.ReadingsPersist",
                         "success_pointer": "/status", "success_value": "passed"})
    out.append({"path": NOTE, "role": "integration", "sha256": sha(NOTE)})
    if (ROOT / REVIEW).exists():
        out.append({"path": REVIEW, "role": "review", "sha256": sha(REVIEW)})
    out.append({"path": CH07, "role": "statement", "sha256": sha(CH07)})
    for s in SOURCES:
        out.append({"path": s, "role": "provenance", "sha256": sha(s)})
    return out, bindings


def dep(id_, relation, en, zh, out_en, out_zh, in_en, in_zh, cond_en, cond_zh):
    return {"id": id_, "relation": relation, "detail": T(en, zh),
            "interface": {"output": T(out_en, out_zh), "input": T(in_en, in_zh),
                          "conditions": T(cond_en, cond_zh), "evidence": MODULE}}


HISTORY = T(
    "9 November 2026, route (b)'s piece J2, on Ren's words of that day and of 8 November kept in sources "
    "(2026-11-09-route-b-ethics-forms.md, 2026-11-08-within-becoming-no-should.md): added. The join of route (b)'s four "
    "pieces found persisting a filter and the pool fixed across courses, and turned the next question from which order "
    "forms to which readings persist; this record answers part of it on a model of lines carrying inherited readings, on "
    "the course their acts generate.",
    "2026年11月9日，路线 (b) 之 J2，依 Ren 当日及11月8日之言（存于 sources 的 2026-11-09-route-b-ethics-forms.md、"
    "2026-11-08-within-becoming-no-should.md）：新增。路线 (b) 四部分之接合发现存续为一筛、池在诸程间固定，遂把下一问从何种次序形成转为何种读法存续；"
    "本记录在携传承读法之系、于其行为所生之程之模型上回答其一部分。")

COMMON_BOUNDS = ["no-ethical-premise", "names-provisional", "formal-not-empirical", "discrete-steps"]


def record_carried(ts):
    laws = [
        law("Each relatum exchanges as the act its reading gives. Where every member of a part carries one reading, the "
            "world is the rest acting by its readings and the part by that reading's act, by construction. Acts reading what "
            "has stood, or only what couples into their relatum, give a world that does too.",
            "各关系项依其读法所给之举交换。一部分之成员皆携同一读法处，此世界由构造即其余依其读法、此部分依该读法之举而行。读已成者、或只读耦合入其关系项者之举，所成之世界亦然。",
            [B("ExchangeLaw.byReading"), B("ExchangeLaw.ReadsThroughOwn"), B("ExchangeLaw.byReading_withAct"),
             B("ExchangeLaw.byReading_nonanticipating"), B("ExchangeLaw.byReading_through"),
             B("ExchangeLaw.ReadsThroughOwn.through_act")]),
        law("A balanced flow in which every formation exchanges as a law of what has stood gives, under the flow's own "
            "levels, has the levels the law generates at every step, and the law's course is feasible: balance gives the "
            "feasibility that the uniqueness of the generated course takes as a premise.",
            "一平衡之流中每一形成皆依一读已成者之律在流自身之水平下交换，则其水平每步即此律所生之水平，且此律之程可行：平衡给出所生之程之唯一性所取为前提之可行性。",
            [B("Flow.totals_of_follows"), B("ExchangeLaw.levels_of_follows"), B("ExchangeLaw.feasible_of_follows")]),
        law("From founders and a listing of the relata, the line read off a flow takes as a member's offspring across a "
            "step the listed relata descending from it then. It is descended in the flow by construction, its later members "
            "stand, and where readings are inherited along descent every member of every cohort carries the founders' reading.",
            "由始祖与关系项之列，读自一流之系以一步中自某成员而传之所列关系项为其后裔。此系由构造即在流中相传，其后之成员皆立；读法沿传承而继处，每一代之每一成员皆携始祖之读法。",
            [B("Flow.descendsB"), B("Flow.descendsB_iff"), B("Flow.lineOf"), B("Flow.mem_lineOf_kids"),
             B("Flow.lineOf_descended"), B("Flow.lineOf_stands"), B("Flow.InheritsReading"), B("Flow.lineOf_carries")]),
        law("Let a reading end where its world's course overdraws a family from a short stock. Where every occasion picks "
            "the reading the line carries and the world is the course it generates, G3's realization premise is the "
            "identity, ending being defined as that overdraw; under G3's "
            "remaining premises some strict order according with the choices puts every non-ending reading above every "
            "ending one met with it.",
            "读法终者，其世界之程自短存而透支一族。每一场合皆择此系所携之读法、且世界即其所生之程处，G3 之实现前提即为恒等（终即定义为此透支）；在 G3 其余前提下，有一与诸择相合之严格序，置每一不终之读法于与之同遇之每一终者之上。",
            [B("Flow.Overdraws"), B("Flow.lineOf_persists_never_overdraws"), B("Flow.carried_keeping_above_ending")]),
        law("A line is alive at a step where its cohort then has a member. It reaches a relatum before a step where a member "
            "of one of its cohorts, a member at that earlier step, exchanged with a condition the relatum then requires: reach "
            "before a step lifted to lines with membership dated, implying the time-blind form for every part holding the "
            "members, and lying within affecting.",
            "一系于某步有成员处为活。其某代之一成员、于先前一步为成员者，与一关系项此步所需之条件交换处，此系于此步前及之：步前之及提升至系、成员身份有时日，对含其成员之每一部分蕴含不计时之形，且在影响之内。",
            [B("Flow.LineAlive"), B("Flow.LineReachesBefore"), B("Flow.LinesReachBefore"),
             B("Flow.LineReachesBefore.reachesBefore"), B("Flow.LineReachesBefore.affects"), B("Flow.LinesReachBefore.alive")]),
        law("In the witness every course is the one the acts generate, each relatum acts by the reading it carries, readings "
            "are inherited along descent and the line carries its reading; the line reaches the dweller's line before the "
            "second step by clearing its habitat; with nothing coming back the dweller's line reaches nothing, and in the "
            "course where it renews the source it reaches the line.",
            "见证中每一程皆行为所生之程，各关系项依其所携读法而行，读法沿传承而继，此系携其读法；此系以清其栖地于第二步前及于栖者之系；无所返时栖者之系无所及，于其续源之程则及于此系。",
            [H("generated"), H("world_byReading"), H("inherits"), H("lineA_carries"), H("cleared_reaches_dweller"),
             H("lineD_slots"), H("cleared_dweller_reaches_nothing"), H("clearedBack_dweller_reaches_line"),
             H("cleared_standpoints_late")]),
    ]
    decls = [d for l in laws for d in l["declarations"]]
    references, bindings = refs(decls, ts)
    return {
        "schema_version": 2,
        "id": "readings-carried-on-their-course",
        "title": T("Lines carrying their readings, on the course their acts generate", "携其读法之系，于其行为所生之程"),
        "kind": "theorem",
        "status": "recorded-checked",
        "family": "F07",
        "reviewed_at_utc": NOW,
        "statement": T(
            "A world whose relata act by their carried readings is the course those acts generate; the line read off it is "
            "descended by construction and carries its founders' reading; with ending read as that course's overdraw, "
            "every occasion picking that reading, G3's realization premise is the identity.",
            "诸关系项依其所携读法而行之世界即此诸行为所生之程；读自其上之系由构造相传、携其始祖所传之读法；终读为此程之透支、且每一场合皆择所携之读法时，G3 之实现前提即为恒等。"),
        "laws": laws,
        "hypotheses": [
            T("No axiom. Discrete steps and natural levels; one kind of relatum, each a formation and a condition; a web, "
              "the relata present and the starting levels supplied.",
              "不加公理。离散步与自然数水平；一种关系项，各为形成亦为条件；网、在场之关系项与起始水平为给定。"),
            T("The act each reading gives is supplied, and so is which relata are listed and which founders start a line.",
              "各读法所给之举为给定，所列之关系项与起一系之始祖亦然。"),
            T("Inheritance of readings along descent is a premise of the law that a line carries its founders' reading; the "
              "witness proves it of its world.",
              "读法沿传承而继，是系携其始祖读法之律之前提；见证于其世界证之。"),
        ],
        "does_not_show": [
            {**T("That an act indexed by what a line carries reads it only within a closure: carrying the index gives nothing "
                 "of how the act reads it, so ActReadsWithin stays a premise.",
                 "以系所携者为索引之举只在闭包内读之：携索引不给出举如何读之，故 ActReadsWithin 仍为前提。"),
             "kind": "non-implication"},
            {**T("That an ending pick is realized as an overdraw where occasions pick different readings: that needs a run "
                 "made of the picks, not built here.",
                 "诸场合择不同读法处终止之择实现为透支：此需由诸择所成之一程，此处未建。"),
             "kind": "scope"},
            {**T("How a reading arises or changes: readings here are carried along descent, never varied or learned.",
                 "读法如何生或变：此处读法沿传承而携，从不变异或习得。"),
             "kind": "scope"},
            {**T("That reach before a step by a time-blind part gives a line's dated reach: the lift goes one way.",
                 "以不计时之部分于步前之及，给出系之有时日之及：提升只一向。"),
             "kind": "converse", "witness": B("Flow.LineReachesBefore.reachesBefore")},
        ],
        "counterexamples": [],
        "standard_boundaries": COMMON_BOUNDS,
        "validation_scope": T(
            "Pure core, axiom report empty; a leaf. Every law is near-definitional; the witness has finitely many relata, "
            "its courses' balance proved for all steps and shown to be the generated ones. Written by an AI; readers of two "
            "other models read the statements cold against this record and its home (READER in the study folder); no human audit.",
            "纯核心，公理报告为空；叶模块。诸律皆近于定义；见证之关系项有限，其诸程之平衡证于每一步，并证其即所生之程。AI 所写；另两模型之读者对照本记录及其所在冷读诸陈述（见研究目录 READER）；无人类审计。"),
        "next_delta": T(
            "A run made of the picks, so that occasions choosing different readings are realized on one course; and readings "
            "that vary along descent, so that how a reading arises, not only how it fares, is on the model.",
            "由诸择所成之一程，使择不同读法之诸场合实现于一程之上；及沿传承而变之读法，使读法如何生、不只如何存续，在模型之上。"),
        "correspondence": T(
            "Reading (the AI's, from its knowledge): a reading inherited along descent and acted on is a heritable trait with "
            "its phenotype, the world acting by it its extended phenotype in the sense of niche construction (Odling-Smee, "
            "Laland and Feldman, 2003); the line read off a flow is a lineage of replicators, a self with no member kept.",
            "解读（AI 据其知识）：沿传承而继并依之而行之读法，即可遗传之性状及其表型，依之而行之世界即生态位构建意义上之延伸表型（Odling-Smee、Laland、Feldman，2003）；读自一流之系为复制者之谱系，一无成员恒存之自。"),
        "canonical_source": MODULE,
        "aliases": ["lines carrying their readings", "the line read off a flow", "携其读法之系",
                    B("Flow.lineOf"), B("ExchangeLaw.levels_of_follows"), B("Flow.carried_keeping_above_ending")],
        "dependencies": [
            dep("what-persisting-shows-of-an-order", "formal-reuse",
                "Reuses the persisting line's laws (Flow.persists_never_overdraws, Flow.persisting_keeping_above_ending), with "
                "descent and the realization premise given by construction.",
                "复用存续之系之律（Flow.persists_never_overdraws、Flow.persisting_keeping_above_ending），传承与实现前提由构造给出。",
                "A line persisting through late cohorts never overdrew; some strict order according with its choices puts keeping above ending on the pairs met.",
                "存续至晚代之系从未透支；有一与其择相合之严格序，于同遇之对置守于终之上。",
                "The line read off the course its readings generate.", "读自其读法所生之程之系。",
                "Balance, acting, dependence, gated renewal, coupled cohorts, no cycle shown; every occasion picks the carried reading.",
                "平衡、唯活者给、活需支撑、门控之更新、诸代耦合、所示无环；每一场合皆择所携之读法。"),
            dep("counterfactual-is-the-course", "formal-reuse",
                "Reuses the generated course (ExchangeLaw.levels_succ, ExchangeLaw.totals_under) to show that a balanced flow "
                "following a law is its course, with no feasibility premise.",
                "复用所生之程（ExchangeLaw.levels_succ、ExchangeLaw.totals_under），以证依一律之平衡之流即其程，无须可行性前提。",
                "The generated levels and totals.", "所生之水平与总量。",
                "A balanced flow following a law of what has stood.", "依读已成者之律之平衡之流。",
                "The law reads what has stood; the formations present and the start fixed.", "律读已成者；在场之形成与起点固定。"),
        ],
        "related": [
            {"id": "selection-read-off-continuations",
             "detail": T("Its setting, the part acting by the act a significance gives, is met by construction where a line "
                         "carries the reading.", "其设定，即部分依一意义所给之举而行，于系携此读法处由构造满足。")},
            {"id": "feedback-and-reach",
             "detail": T("Reach before a step, here lifted to lines with membership dated.", "步前之及，此处提升至系、成员身份有时日。")},
            {"id": "which-readings-persist",
             "detail": T("Which readings persist on this model.", "在此模型上何种读法存续。")},
        ],
        "references": references,
        "proof_bindings": bindings,
        "history": [HISTORY],
    }


def record_persist(ts):
    model = [H(n) for n in ["Rel", "Reading", "stands", "fed", "draw", "clears", "first", "conduct", "act", "isA",
                            "readOf", "restLaw", "world", "members", "listed", "requires", "need", "webOf", "flowOf",
                            "flowOf_follows", "ble_congr", "fed_of_agree", "admits_iff", "fed_of_admits", "act_alike",
                            "act_nonanticipating", "act_readsThroughOwn", "world_nonanticipating"]]
    courses = [H(n) for n in ["alt", "alt'", "alt_or", "second", "keep", "cleared", "overSource", "overdrawn",
                              "clearedBack", "start", "present", "keep_balances", "cleared_balances_late",
                              "cleared_balances", "overdrawn_balances", "clearedBack_balances", "lineA", "lineD",
                              "keep_lineA_shift", "keep_lineD_shift", "cleared_lineA_shift", "keep_lineA_alive",
                              "keep_lineD_alive", "cleared_lineA_alive"]] + [
        B("SelectionTerm.Generations.family_nil_from"), B("SelectionTerm.Generations.not_persists_of_nil"),
        B("SelectionTerm.Generations.persists_of_alive")]
    laws = [
        law("Let a line carry one of two readings: the rest acts by a law of what has stood reading through coupling; the two "
            "acts are laws of what has stood, the first reading each slot's couplings only, agreeing under every history on "
            "what couples into the line's coupling closure drawn through both courses; both feasible; own standing coupled in. "
            "The slots stand late in the one course exactly when in the other.",
            "设一系携二读法之一：其余依读已成者、经耦合而读之律；二举为读已成者之律，前者只读各位之耦合，且于每一历史下在经两程所得之系耦合闭包内耦合入者上皆一致；两程可行；各位之自立耦合入。则诸位于一程中立至晚步，恰如于另一程。",
            [B("StandsLate"), B("Web.standsLate_readOffCouplings"), B("Flow.lineOf_standsLate"),
             B("line_standing_unselected"), B("line_standing_unselected_of_reads")]),
        law("A witness world: a line of two slots passing its standing on and drawing on a source; a dweller's line of two "
            "slots requiring a habitat; three readings (the line only, drawing two and clearing; the line and its source, "
            "drawing one and clearing; everything, drawing one and sparing). The acts read what has stood and only what "
            "couples into their relatum.",
            "见证世界：一系二位，传其立并取于一源；栖者之系二位，需一栖地；三读法（唯此系，取二而清；此系及其源，取一而清；一切，取一而留）。诸举读已成者，且只读耦合入其关系项者。",
            model),
        law("Its courses, by closed levels proved balanced at every step: both lines kept; the habitat cleared with nothing "
            "coming back; the source overdrawn; the habitat cleared where the dweller renews the source. The lines read off "
            "them persist or end as computed.",
            "其诸程，以闭式水平逐步证其平衡：二系皆存；无所返而清栖地；源被透支；栖者续源处清栖地。读自其上之诸系如所算或存或终。",
            courses),
        law("Where the source renews itself, the line reading only itself ends; the line reading its source persists and the "
            "dweller's line ends; the line reading everything persists with the dweller's line. The law holds there with every "
            "premise met by the model, so the line's standing late cannot tell clearing from sparing.",
            "源自续处，唯读自身之系终；读其源之系存续而栖者之系终；读一切之系与栖者之系同存续。此律于此成立、诸前提皆由模型满足，故此系之晚立不能分清与留。",
            [H("beyond_which_persist"), H("keep_persists"), H("cleared_persists"), H("overdrawn_ends"),
             H("beyond_standing"), H("standsLate_of_alt"), H("late_zero"), H("not_standsLate_of_gone"),
             H("beyond_standing_unselected"), H("inR"), H("quiet"), H("coupled_in_region"), H("not_exchanges"),
             H("region_closed"), H("closure_in_region")]),
        law("Where the dweller's line renews the source, the line reading its source clears the habitat and ends with the "
            "dweller's line; the line reading everything persists with it.",
            "栖者之系续源处，读其源之系清栖地而与栖者之系同终；读一切之系与之同存续。",
            [H("back_which_persist"), H("clearedBack_ends")]),
    ]
    decls = [d for l in laws for d in l["declarations"]]
    references, bindings = refs(decls, ts)
    return {
        "schema_version": 2,
        "id": "which-readings-persist",
        "title": T("Which readings persist", "何种读法存续"),
        "kind": "theorem",
        "status": "recorded-checked",
        "family": "F07",
        "reviewed_at_utc": NOW,
        "statement": T(
            "A line's standing late tells readings apart only by what their acts do within its coupling closure. In a witness "
            "where nothing comes back a line clearing a dweller's habitat persists as a sparing one does, an overdrawing "
            "one ends; where the dweller renews the source, the clearing line ends with it.",
            "系之晚立只以诸读法之举在其耦合闭包内所为分之。见证中，无所返处，清栖者之栖地之系与留之系同存续，透支之系终；栖者续此系之源处，清之系与之同终。"),
        "laws": laws,
        "hypotheses": [
            T("No axiom. Discrete steps and natural levels; one kind of relatum; a web, the relata present and the starting "
              "levels supplied; a coupling by level supplied, holding each slot's own standing.",
              "不加公理。离散步与自然数水平；一种关系项；网、在场之关系项与起始水平为给定；经水平之耦合为给定，含各位之自立。"),
            T("The two acts agree, under every level history, on everything coupled into the line's coupling closure drawn through both courses: a premise "
              "on the acts, met in the witness, not derived; where they differ there, the difference can be selected, as the "
              "witness's overdrawing reading shows.",
              "二举于每一水平史下在经两程所得之系耦合闭包内耦合入者上一致：对二举之前提，于见证中满足，非推出；若于此不同，差异可被选，如见证之透支读法所示。"),
            T("The rest acts by a law of what has stood reading through coupling, the first act reads each slot's couplings "
              "only, and both courses are feasible; the significance form needs every significance's course feasible.",
              "其余依读已成者、经耦合而读之律，前一举只读各位之耦合，两程皆可行；意义之形需每一意义之程皆可行。"),
            T("The act each reading gives is supplied; in the witness, which conduct each reading gives is designed.",
              "各读法所给之举为给定；见证中各读法给何行为为所设。"),
        ],
        "does_not_show": [
            {**T("That a wider reading persists where its loss returns because it is wider: a narrow reading whose act agrees "
                 "on everything coupled into the line's closure stands late as well, under the law's premises.",
                 "其失去返回处，较宽之读法因宽而存续：其举在系闭包内耦合入者上皆一致之窄读法亦晚立，在此律之前提下。"),
             "kind": "non-implication", "witness": B("line_standing_unselected")},
            {**T("Which readings persist among several lines competing for a share: selection here is persistence, all or "
                 "nothing.", "诸系争一份额时何种读法存续：此处之选择为存续，全有或全无。"),
             "kind": "scope"},
            {**T("That persistence implies a line's slots stand late and conversely: only the first direction is proved.",
                 "存续蕴含系之诸位立至晚步，及其逆：只证前一向。"),
             "kind": "converse", "witness": B("Flow.lineOf_standsLate")},
            {**T("That actual lineages, institutions or trained systems act by readings so carried.",
                 "实际之谱系、制度或训练之系统依如此所携之读法而行。"),
             "kind": "correspondence"},
        ],
        "counterexamples": [{"path": MODULE, "detail": T(
            "Against the reading that persistence selects the wider reading: where nothing comes back from the dweller, the line reading its source clears the habitat and persists as the line reading everything does, and the law holds there with every premise met (Habitat.beyond_which_persist, Habitat.beyond_standing_unselected).",
            "反对存续择较宽读法之读法：栖者无所返处，读其源之系清栖地而存续，如读一切之系然，且此律于此成立、诸前提皆满足（Habitat.beyond_which_persist、Habitat.beyond_standing_unselected）。")}],
        "standard_boundaries": COMMON_BOUNDS,
        "validation_scope": T(
            "Pure core, axiom report empty; a leaf. The law is act_courses_unselected_throughout with standing late as the "
            "selection, near-definitional; the witness has finitely many relata, balance and the lines' fates proved for all "
            "steps, every premise of the law discharged. Written by an AI; readers of two other models read it cold (READER); "
            "no human audit.",
            "纯核心，公理报告为空；叶模块。此律为以晚立为选择之 act_courses_unselected_throughout，近于定义；见证之关系项有限，平衡与诸系之终存证于每一步，此律诸前提皆证。AI 所写；另两模型之读者冷读（READER）；无人类审计。"),
        "next_delta": T(
            "Several lines carrying different readings under selection by share, read off the course, joined to RuleShaping's "
            "counts; and readings that vary along descent, so that which readings arise is on the model with which persist.",
            "携不同读法之诸系受份额之选择、读自其程，并接 RuleShaping 之计数；及沿传承而变之读法，使何种读法生与何种存续同在模型之上。"),
        "correspondence": T(
            "Reading (the AI's, from its knowledge): a trait whose content leaves the bearer's fitness unchanged has no "
            "covariance with it (Price 1970); a cost borne beyond the bearer's coupling is an externality the bearer's own "
            "persistence does not register (Pigou 1920); where the cost returns through the bearer's own source, it is the "
            "tragedy of the commons read on one line (Hardin 1968).",
            "解读（AI 据其知识）：内容不改承载者适应度之性状与之无协方差（Price 1970）；承载者耦合之外所承之代价为外部性，承载者自身之存续不记之（Pigou 1920）；代价经承载者自身之源返回处，即在一系上所读之公地悲剧（Hardin 1968）。"),
        "canonical_source": MODULE,
        "aliases": ["which readings persist", "standing late selects no reading beyond the coupling closure", "何种读法存续",
                    B("line_standing_unselected"), H("beyond_which_persist"), H("back_which_persist")],
        "dependencies": [
            dep("selection-read-off-continuations", "formal-reuse",
                "Reuses act_courses_unselected_throughout and significance_courses_unselected with standing late as the selection.",
                "复用 act_courses_unselected_throughout 与 significance_courses_unselected，以晚立为选择。",
                "Courses selected alike by every whole-run selection read off what couples in.",
                "遍及全程读自耦合入者之每一选择皆对两程选得相同。",
                "Standing late among the line's slots.", "系诸位之晚立。",
                "Laws of what has stood; the rest reading through coupling; feasible courses; acts agreeing on what couples in.",
                "读已成者之律；其余经耦合而读；进程可行；二举在耦合入者上一致。"),
            dep("readings-carried-on-their-course", "formal-reuse",
                "Reuses the generated course and the line read off it.", "复用所生之程与读自其上之系。",
                "The course the acts generate; the line read off it.", "行为所生之程；读自其上之系。",
                "The witness's courses and lines.", "见证之诸程与诸系。",
                "Balanced flows following the world's law.", "依世界之律之平衡之流。"),
        ],
        "related": [
            {"id": "what-persisting-shows-of-an-order",
             "detail": T("Persisting a filter on what was chosen; here the filter read on readings.", "存续为所择之筛；此处读于读法之上。")},
            {"id": "a-selection-removing-its-readers",
             "detail": T("The course clearing the habitat, read as removing its readers.", "清栖地之程，读为移除其读者。")},
        ],
        "references": references,
        "proof_bindings": bindings,
        "history": [HISTORY],
    }


def record_removing(ts):
    laws = [
        law("Among listed lines, the pool a course gives at a step is the lines alive in it then. Selection by persistence "
            "read off that pool holds where, from some step on, every line alive persists; read off a fixed pool, where every "
            "line persists. A course removes a line alive at the start and not from some step on; a selection removes its own "
            "readers where it holds at a course removing a line of readers.",
            "诸所列之系中，一程于某步所给之池为其时于程中活之诸系。读自此池之以存续之选择，于自某步起凡活之系皆存续处成立；读自定池者，于每系皆存续处成立。一程移去始活而自某步起不活之系；一选择于其成立之程移去一读者之系处，移除自身之读者。",
            [B("AliveIn"), B("SurvivorsPersist"), B("AllPersist"), B("RemovesLine"), B("RemovesItsReaders"),
             B("RemovesLine.not_standsLate")]),
        law("Read off the pool its course gives, selection by persistence registers no removal: every course in which, from "
            "some step on, each line persists or is not alive passes it, one removing every line included. Read off a fixed "
            "pool it is turned by every removal, and passing it there a course passes it read off its own pool.",
            "读自其程所给之池，以存续之选择不记移除：自某步起各系或存续或不活之每一程皆过之，移去诸系者亦然。读自定池则为每一移除所转；于彼过之之程，读自其自身之池亦过之。",
            [B("survivorsPersist_of_settled"), B("not_allPersist_of_removes"), B("AllPersist.survivors")]),
        law("A reader within a group's coupling closure drawn through two courses whose acts agree on everything coupled into "
            "that closure, its own standing coupled into it, stands at every step in the one course exactly when in the "
            "other: no selection between those acts removes it from the pool one course gives while the other keeps it.",
            "一读者在经两程所得之某组耦合闭包之内，两程之举在此闭包内耦合入者上皆一致，其自立耦合入之，则它于每步在一程中立恰如在另一程：此二举间无选择于一程所给之池移去之而另一程留之。",
            [B("reader_kept_alike")]),
        law("In the course where the line reads its source and nothing comes back, selection by persistence read off the "
            "course's pool holds while the course removes the dweller's line, read as a reader of the habitat; read off "
            "the fixed pool of both lines it fails there; in the course reading everything it holds read off either pool.",
            "于此系读其源且无所返之程，读自程之池之以存续之选择成立，而此程移去栖者之系（读作栖地之读者）；读自二系之定池则于此不成立；于读一切之程，读自二池皆成立。",
            [H("Line"), H("slotsOf"), H("cleared_dweller_gone"), H("cleared_removes_dweller"),
             H("cleared_removes_its_readers")]),
        law("Where the dweller's line renews the source, the course removing it removes the line too, and selection by "
            "persistence read off the course's pool still passes it: what turns there is the line's own persistence.",
            "栖者之系续源处，移去之之程亦移去此系，而读自程之池之以存续之选择仍过之：于此所转者为此系自身之存续。",
            [H("clearedBack_dweller_gone"), H("clearedBack_line_gone"), H("clearedBack_removes_both"),
             H("clearedBack_survivors_pass")]),
    ]
    decls = [d for l in laws for d in l["declarations"]]
    references, bindings = refs(decls, ts)
    return {
        "schema_version": 2,
        "id": "a-selection-removing-its-readers",
        "title": T("A selection removing its own readers", "移除自身读者之选择"),
        "kind": "theorem",
        "status": "recorded-checked",
        "family": "F04",
        "reviewed_at_utc": NOW,
        "statement": T(
            "With the pool read off the course, selection by persistence read off it passes every course whose lines settle, "
            "one removing every line included, while read off a fixed pool it is turned by every removal; a reader whose "
            "coupling closure the alternatives agree on is kept or removed alike.",
            "池读自其程时，诸系有定处读自其池之以存续之选择不记任何移除，移去诸系亦然；读自定池则为每一移除所转；诸选项于其耦合闭包皆一致之读者两程同留或同去。"),
        "laws": laws,
        "hypotheses": [
            T("No axiom. Discrete steps and natural levels; lines listed with their slots; a line alive where a slot stands.",
              "不加公理。离散步与自然数水平；诸系连其诸位列出；一系于其一位立处为活。"),
            T("For the reader kept alike: the premises of act_courses_unselected_throughout, the reader within the group's "
              "closure and its own standing coupled into it.",
              "就两程无别之读者：act_courses_unselected_throughout 之诸前提，读者在该组闭包之内且其自立耦合入之。"),
            T("In the witness, reading the dweller's line as a reader of the habitat is a reading: its continuation hangs on "
              "the habitat's level.", "见证中，把栖者之系读作栖地之读者是一种解读：其延续系于栖地之水平。"),
        ],
        "does_not_show": [
            {**T("The meta-attractor as a selection by share coming to select for control of its rule: RuleShaping's counts "
                 "are not joined here.", "作为以份额之选择渐选对其规则之控制之元吸引子：此处未接 RuleShaping 之计数。"),
             "kind": "scope"},
            {**T("That every course removing its readers is selected: survivorship read off the survivors holds at it where "
                 "the lines settle; nothing here makes a selection prefer it.", "每一移除其读者之程皆被选：诸系有定处，读自存者之存续于其成立；此处无使选择偏向之者。"),
             "kind": "non-implication"},
            {**T("That selection read off the course's own pool is turned where the loss returns to the selectors: it passes "
                 "the course removing both lines; what turns is the selecting line's own persistence.",
                 "读自程自身之池之选择于失去返回选择者处被转：它过移去二系之程；所转者为选择之系自身之存续。"),
             "kind": "non-implication", "witness": H("clearedBack_survivors_pass")},
            {**T("That a reader whose loss returns to the selectors is kept in general: the witness shows one world, where "
                 "the selecting line's own persistence turns.",
                 "其失去返回选择者之读者一般皆被留：见证只示一世界，于其中选择之系自身之存续被转。"),
             "kind": "scope", "witness": H("clearedBack_removes_both")},
            {**T("A reading in time, before a loss passes its point of no return.", "及时之读，于失去过其不可返之点之前。"),
             "kind": "scope"},
        ],
        "counterexamples": [{"path": MODULE, "detail": T(
            "Against the reading that selection by persistence turns against a course removing its readers: read off the pool the course gives it holds at the course clearing the habitat, which removes the dweller's line; only read off a fixed pool does it fail there (Habitat.cleared_removes_its_readers).",
            "反对以存续之选择转而反对移除其读者之程之读法：读自程所给之池，它于清栖地之程成立，而此程移去栖者之系；唯读自定池时于此不成立（Habitat.cleared_removes_its_readers）。")}],
        "standard_boundaries": COMMON_BOUNDS,
        "validation_scope": T(
            "Pure core, axiom report empty; a leaf. The laws are near-definitional; the reader kept alike is "
            "act_courses_unselected_throughout with a reader's standing as the selection; the witnesses have finitely many "
            "relata, their courses proved for all steps. Written by an AI; readers of two other models read it cold (READER); "
            "no human audit.",
            "纯核心，公理报告为空；叶模块。诸律近于定义；两程无别之读者为以读者之立为选择之 act_courses_unselected_throughout；见证之关系项有限，其诸程证于每一步。AI 所写；另两模型之读者冷读（READER）；无人类审计。"),
        "next_delta": T(
            "Selection by share among lines carrying different readings, read off the pool the course gives and joined to "
            "RuleShaping's counts, to state the meta-attractor as a rule coming to select for control; and the same read in "
            "time.", "携不同读法之诸系间以份额之选择，读自程所给之池并接 RuleShaping 之计数，以述元吸引子为渐选控制之规则；并及时读之。"),
        "correspondence": T(
            "Reading (the AI's, from its knowledge): survivorship read off the survivors is survivorship bias as a selection "
            "rule (Wald's armour problem, 1943); a regime that removes its critics and is then judged by those who remain is "
            "its institutional shape; for trained systems, an evaluation read off the outputs a policy still produces.",
            "解读（AI 据其知识）：读自存者之存续，即作为选择规则之幸存者偏差（Wald 之装甲问题，1943）；移除其批评者、而后由余者评判之体制，为其制度之形；就训练之系统，读自策略尚产生之输出之评估。"),
        "canonical_source": MODULE,
        "aliases": ["a selection removing its own readers", "the meta-attractor's shape, the pool read off the course",
                    "移除自身读者之选择", B("RemovesItsReaders"), B("survivorsPersist_of_settled"), B("reader_kept_alike")],
        "dependencies": [
            dep("selection-read-off-continuations", "formal-reuse",
                "Reuses act_courses_unselected_throughout with a reader's standing at a step as the selection.",
                "复用 act_courses_unselected_throughout，以读者于某步之立为选择。",
                "Courses selected alike by every whole-run selection read off what couples in.",
                "遍及全程读自耦合入者之每一选择皆对两程选得相同。",
                "A reader's standing at each step.", "读者每步之立。",
                "Laws of what has stood; the rest reading through coupling; feasible courses; acts agreeing on what couples in.",
                "读已成者之律；其余经耦合而读；进程可行；二举在耦合入者上一致。"),
            dep("which-readings-persist", "formal-reuse",
                "Reuses the witness's courses and the lines' persistence.", "复用见证之诸程与诸系之存续。",
                "The courses and which lines persist.", "诸程与何系存续。",
                "The pool read off the course.", "读自其程之池。",
                "The witness.", "见证。"),
        ],
        "related": [
            {"id": "readers-drawn-from-the-selected",
             "detail": T("Readers drawn from the selected; here, readers kept where the alternatives do not reach them.",
                         "读者取自被选者；此处，诸选项所不及处读者被留。")},
            {"id": "shaping-the-rule-selected-by-what-comes-back",
             "detail": T("Shaping selected by what comes back, on counts; here, removal with the pool read off the course.",
                         "以所返者选塑造，于计数之上；此处，池读自其程之移除。")},
        ],
        "references": references,
        "proof_bindings": bindings,
        "history": [HISTORY],
    }


NOW = datetime.now(timezone.utc).replace(microsecond=0).isoformat()


def main():
    ts = sys.argv[1] if len(sys.argv) > 1 else None
    for rec in (record_carried(ts), record_persist(ts), record_removing(ts)):
        path = RECORDS / f"{rec['id']}.json"
        path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print("wrote", path.relative_to(ROOT))


if __name__ == "__main__":
    main()
