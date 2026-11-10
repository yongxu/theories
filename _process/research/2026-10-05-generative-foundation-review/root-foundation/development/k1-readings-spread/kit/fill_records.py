#!/usr/bin/env python3
"""Write K1's three records with the current hashes (AI-written kit, 10 November 2026).

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
SPREAD = f"{LEAN}/Becoming/ReadingsSpread.lean"
PERSIST = f"{LEAN}/Becoming/ReadingsPersist.lean"
CH07 = "theories/becoming/chapters/07-SIGNIFICANCE.md"
STUDY = "_process/research/2026-10-05-generative-foundation-review/root-foundation/development/k1-readings-spread"
NOTE = f"{STUDY}/NOTE.md"
REVIEW = f"{STUDY}/READER.md"
SOURCES = ["sources/15-codex-theory-conversations/2026-11-09-route-b-ethics-forms.md",
           "sources/15-codex-theory-conversations/2026-11-08-within-becoming-no-should.md"]
RECORDS = ROOT / "theories/becoming/results/records"
MODULES = {SPREAD: "Becoming.ReadingsSpread", PERSIST: "Becoming.ReadingsPersist"}


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def B(name):
    return f"Becoming.{name}"


def G(name):
    return f"Becoming.SelectionTerm.Generations.{name}"


def C(name):
    return f"Becoming.ReadingsSpread.Commons.{name}"


def T(en, zh):
    return {"en": en, "zh": zh}


def law(en, zh, decls):
    return {"en": en, "zh": zh, "declarations": decls}


# Declarations proved in ReadingsPersist (the rule-9 move); every other is ReadingsSpread's.
IN_PERSIST = {G("descentFrom"), G("reached_from"), G("kept_iff"), G("kept_of_descent"), B("Flow.lineOf_carries")}


def refs(decls, ts):
    out, bindings = [], []
    by_module = {SPREAD: sorted({d for d in decls if d not in IN_PERSIST}),
                 PERSIST: sorted({d for d in decls if d in IN_PERSIST})}
    for path, ds in by_module.items():
        if ds:
            out.append({"path": path, "role": "proof", "declarations": ds, "sha256": sha(path)})
    if ts:
        receipt = f"{LEAN}/becoming-checks/{ts}/verification.json"
        assert (ROOT / receipt).exists(), receipt
        out.append({"path": receipt, "role": "receipt", "sha256": sha(receipt)})
        for path, ds in by_module.items():
            if ds:
                bindings.append({"source": path, "receipt": receipt,
                                 "sha256_pointer": f"/source_sha256/{MODULES[path]}",
                                 "success_pointer": "/status", "success_value": "passed"})
    out.append({"path": NOTE, "role": "integration", "sha256": sha(NOTE)})
    if (ROOT / REVIEW).exists():
        out.append({"path": REVIEW, "role": "review", "sha256": sha(REVIEW)})
    out.append({"path": CH07, "role": "statement", "sha256": sha(CH07)})
    for s in SOURCES:
        out.append({"path": s, "role": "provenance", "sha256": sha(s)})
    return out, bindings


def dep(id_, relation, en, zh, out_en, out_zh, in_en, in_zh, cond_en, cond_zh, evidence=SPREAD):
    return {"id": id_, "relation": relation, "detail": T(en, zh),
            "interface": {"output": T(out_en, out_zh), "input": T(in_en, in_zh),
                          "conditions": T(cond_en, cond_zh), "evidence": evidence}}


HISTORY = T(
    "10 November 2026, route (b)'s piece K1, on Ren's words of 9 and 8 November kept in sources "
    "(2026-11-09-route-b-ethics-forms.md, 2026-11-08-within-becoming-no-should.md) and his word of 10 November that "
    "the dynamics be made connected, mapped and unified: added. J2 asked which readings persist where a line carries an "
    "inherited reading; this record lets the reading vary at descent, several lines share one world, and the pool is read "
    "off the course. The design was read once by Fable before any Lean (the study's DESIGN.md); the closure law on dated "
    "descent moved into ReadingsPersist with Flow.lineOf_carries its case (board rule 9).",
    "2026年11月10日，路线 (b) 之 K1，依 Ren 11月9日、8日之言（存于 sources 的 2026-11-09-route-b-ethics-forms.md、"
    "2026-11-08-within-becoming-no-should.md）及其10日使诸动力相连、成图、统一之言：新增。J2 问一系携所传读法时何种读法存续；"
    "本记录令读法于传承时变，多系同在一世界，池读自其程。设计于任何 Lean 之前经 Fable 一读（研究目录 DESIGN.md）；"
    "有时日之传承上之闭律移入 ReadingsPersist，Flow.lineOf_carries 为其特例（看板规则 9）。")

COMMON_BOUNDS = ["no-ethical-premise", "names-provisional", "formal-not-empirical", "discrete-steps"]


def record_revised(ts):
    laws = [
        law("Revision at descent: each kid carries its parent's reading updated by what the parent sensed at the step it "
            "gave, the reading loop's update read across descent. The reading is carried by the slot a member stands in. "
            "Inheritance is the update that keeps the reading, and the line read off a flow revises as the flow does.",
            "传承时之修订：每一后裔携其亲之读法，依亲于所给之步所感者更新，即读之环之更新读于传承之上。读法由成员所立之位所携。继承即保持读法之更新；读自一流之系依流之修订而修订。",
            [G("RevisesBy"), B("Flow.RevisesBy"), B("Flow.inheritsReading_iff"), B("Flow.RevisesBy.lineOf")]),
        law("The share of a region of readings moves by Price's equation: counted one at each carrier, the revisions into "
            "and out of the region across a step are exactly the transmission terms, so the count moves by selection proper "
            "on carrying the region and by revision together.",
            "一读法区域之份额依 Price 方程而动：于每一携者计一，一步中入、出此区域之修订恰为传递项，故计数共依携此区域之选择本项与修订而动。",
            [G("withAmount"), G("withAmount_family"), G("carrying"), G("revisedIn"), G("revisedOut"),
             G("excess_indicator"), G("carrying_family"), G("carrying_size"), G("carrying_raisedAt"),
             G("carrying_loweredAt"), G("share_step")]),
        law("With inheritance nothing is revised and the share moves by selection proper alone. Where every member carries "
            "the region, selection proper is none, and the carriers at the next step are the next cohort less the "
            "revisions out; where none carries it, selection proper is none and the next carriers are the revisions in.",
            "有继承时无修订，份额只依选择本项而动。每一成员皆携此区域处，选择本项为零，下一步之携者为下一代减去出之修订；无一携之处，选择本项为零，下一步之携者为入之修订。",
            [G("revised_none_of_inherits"), G("total_congr_mem"), G("fixed_step"), G("absent_step")]),
        law("In generations of descent in a flow where only active formations give and activity needs support, a region "
            "every supported member carries is not selected against; where no carrier is active, or, under balance, every "
            "carrier at a stretch's end requires a family drawn over the stretch below its need, the next cohort's "
            "carriers are exactly the revisions into it.",
            "于一流中相传之诸代，唯活者给、活需支撑处，每一受支撑成员皆携之区域不被逆选；无携者活、或在平衡下段末每一携者所需之族于此段中被汲至其所需之下处，下一代之携者恰为入此区域之修订。",
            [B("Flow.indicator_le_one"), B("Flow.supported_carriers_not_against"), B("Flow.carriers_inactive_step"),
             B("Flow.carriers_drawn_down")]),
        law("Read off the slots standing, the share selects no reading beyond the lines' coupling closure: under Bound's "
            "premises, with every listed slot within the closure and its own standing coupled into it, the listed slots "
            "standing and carrying any region are as many at every step in the one course as in the other.",
            "读自所立之位，份额不选系之耦合闭包之外之读法：在 Bound 之前提下，所列之位皆在闭包内、其自身之立耦合入之，则每一步中所立且携任一区域之所列之位，在一程与另一程中一样多。",
            [B("standingCount"), B("standingCount_unselected")]),
        law("Witness, descent supplied: a share rises from one of two to two of two by selection proper with nothing "
            "revised; the region is then fixed, selection proper is none, and one revision out lowers it to one of two.",
            "见证，传承为给定：一份额由二之一升至二之二，依选择本项而无修订；此区域遂定，选择本项为零，一次出之修订使之降至二之一。",
            [B("ReadingsSpread.Revised.read"), B("ReadingsSpread.Revised.generations"),
             B("ReadingsSpread.Revised.rises_then_revised")]),
    ]
    decls = [d for l in laws for d in l["declarations"]]
    references, bindings = refs(decls, ts)
    return {
        "schema_version": 2,
        "id": "readings-revised-at-descent",
        "title": T("Readings revised at descent, and how their share moves", "传承时修订之读法及其份额之动"),
        "kind": "theorem",
        "status": "recorded-checked",
        "family": "F07",
        "reviewed_at_utc": NOW,
        "statement": T(
            "Revision at descent is the reading loop's update across a step, and a reading's share moves by Price's "
            "equation with revision as its transmission term; spread by selection needs what feeds the carriers and, read "
            "off the slots standing, is blind beyond the lines' coupling closure.",
            "传承时之修订即读之环跨一步之更新；读法之份额依 Price 方程而动，修订为其传递项；依选择之传布需养其携者者，读自所立之位时不见系之耦合闭包之外。"),
        "laws": laws,
        "hypotheses": [
            T("No axiom. Discrete steps and natural levels; one kind of relatum; generations given by a first family and "
              "each member's kids, or read off a flow from founders and a listing.",
              "不加公理。离散步与自然数水平；一种关系项；诸代由首代与每一成员之后裔给出，或由始祖与一列读自一流。"),
            T("What a member senses and the update are supplied; the reading is carried by the slot, so revision while a "
              "member goes on standing is not represented.",
              "成员所感者与更新为给定；读法由位所携，故成员持续立时之修订不表示。"),
            T("The support laws take generations of descent in the flow, only active formations giving and, but for the "
              "inactive-step law, activity needing support; the drawn-down law takes balance and the ledger's inequality "
              "over a stretch, its conclusion at the stretch's end.",
              "支撑之律取于流中相传之诸代、唯活者给，及（不活一步之律除外）活需支撑；汲尽之律取平衡及一段上之账目不等式，其结论在段末。"),
            T("The blindness law takes Bound's premises: the rest a law of what has stood reading through coupling; both "
              "acts laws of what has stood, the first reading through its members' coupling, the two agreeing on what "
              "couples into the closure under every level history; both courses feasible.",
              "盲之律取 Bound 之前提：其余为读已成者、经耦合而读之律；二举皆读已成者，前者经其成员之耦合而读，二举于每一水平史下于耦合入闭包者一致；二程皆可行。"),
        ],
        "does_not_show": [
            {**T("How a reading's act comes to be what it is: the acts are supplied, as is what is sensed.",
                 "读法之举如何成其所是：举为给定，所感者亦然。"), "kind": "scope"},
            {**T("That a reading's share rises: Price's equation is an identity; whether concordance and revision in exceed "
                 "discordance and revision out is the course's.",
                 "读法之份额上升：Price 方程为恒等式；协同与入之修订是否超过不协与出之修订，在于程。"), "kind": "non-implication"},
            {**T("That the share read off a line's cohorts is blind beyond the closure: the blindness law reads the slots "
                 "standing, not who descends from whom.",
                 "读自系之诸代之份额不见闭包之外：盲之律读所立之位，不读谁传自谁。"), "kind": "scope"},
            {**T("Any order among readings: only the counts' dynamics are stated.", "读法间之任何次序：只陈计数之动力。"),
             "kind": "non-implication"},
        ],
        "counterexamples": [],
        "standard_boundaries": COMMON_BOUNDS,
        "validation_scope": T(
            "Pure core, axiom report empty; a leaf. Every law is near-definitional, the witness computed on supplied "
            "generations. Written by an AI; one reader of another model read the statements cold against this record and "
            "its home (READER in the study folder); no human audit.",
            "纯核心，公理报告为空；叶模块。诸律皆近于定义，见证于给定之诸代上计算。AI 所写；另一模型之读者对照本记录及其所在冷读诸陈述（见研究目录 READER）；无人类审计。"),
        "next_delta": T(
            "Readings whose acts are themselves revised by what returns, so that how an act comes to read what it reads is "
            "on the model, and the share read off cohorts shown blind beyond the closure.",
            "其举本身依所返者而修订之读法，使举如何成其所读者在模型之上；并证读自诸代之份额不见闭包之外。"),
        "correspondence": T(
            "Reading (the AI's, from its knowledge): the share law is Price's equation with mutation as transmission bias "
            "(Price, 1970); revision at descent read as an update from what is sensed is cultural transmission with guided "
            "variation (Boyd and Richerson, 1985).",
            "解读（AI 据其知识）：份额之律即以突变为传递偏差之 Price 方程（Price，1970）；读为依所感而更新之传承时修订，即带引导变异之文化传递（Boyd 与 Richerson，1985）。"),
        "canonical_source": SPREAD,
        "aliases": ["readings revised at descent", "the share of a reading", "传承时修订之读法",
                    G("share_step"), G("fixed_step"), B("Flow.carriers_drawn_down")],
        "dependencies": [
            dep("selection-term-over-generations", "formal-reuse",
                "Reads Price's equation over cohorts (Generations.mean_step, price) and support's law "
                "(SelectionTerm.Flow.support_not_against) for a region's count.",
                "以一区域之计数读诸代上之 Price 方程（Generations.mean_step、price）及支撑之律（SelectionTerm.Flow.support_not_against）。",
                "The mean amount's step by selection proper and transmission; support never selects against the top reading.",
                "平均量依选择本项与传递之一步；支撑从不逆选最高之读法。",
                "A region's count, revision at descent its transmission.", "一区域之计数，传承时之修订为其传递。",
                "Exact arithmetic on natural numbers; only active formations give and activity needs support, for the support law.",
                "自然数上之精确算术；支撑之律取唯活者给、活需支撑。"),
            dep("readings-carried-on-their-course", "formal-reuse",
                "Builds on the line read off a flow (Flow.lineOf, Flow.mem_lineOf_kids) and inheritance (Flow.InheritsReading), "
                "now a case of revision.",
                "建于读自一流之系（Flow.lineOf、Flow.mem_lineOf_kids）及继承（Flow.InheritsReading）之上，继承今为修订之特例。",
                "The line read off a flow and its kids.", "读自一流之系及其后裔。",
                "Revision read along the line's descent.", "沿系之传承读修订。",
                "The founders and the listing supplied.", "始祖与列为给定。"),
            dep("ending-laws-as-regimes-on-a-lineage", "formal-reuse",
                "Restricts the ledger of a lineage drawn below its need (LineageDrawdown.below_iff) to a region's carriers.",
                "把汲至所需之下之谱系之账目（LineageDrawdown.below_iff）限于一区域之携者。",
                "A family's stock below a need from the ledger over a stretch.", "由一段上之账目得一族之存低于所需。",
                "The carriers' inactivity at the stretch's end.", "段末携者之不活。",
                "Balance; activity needing support.", "平衡；活需支撑。"),
            dep("a-selection-removing-its-readers", "formal-reuse",
                "Counts J2's reader_kept_alike over listed slots.", "于所列之位上计 J2 之 reader_kept_alike。",
                "A reader within the closure stands alike at every step.", "闭包内之读者每步立同。",
                "The listed slots' standing count.", "所列之位之立计。",
                "Bound's premises; each slot within the closure, its own standing coupled into it.",
                "Bound 之前提；每一位在闭包内，其自身之立耦合入之。"),
        ],
        "related": [
            {"id": "a-reading-kept-by-its-update",
             "detail": T("The reading loop's update, here read across descent.", "读之环之更新，此处读于传承之上。")},
            {"id": "where-a-reading-locks", "detail": T("Where a region of readings is closed under revision.",
                                                         "一读法区域于修订下闭之处。")},
            {"id": "a-narrow-reading-in-a-commons", "detail": T("The share's course on a generated world.",
                                                                 "所生之世界上份额之程。")},
        ],
        "references": references,
        "proof_bindings": bindings,
        "history": [HISTORY],
    }


def record_locks(ts):
    laws = [
        law("What holds of every member of a cohort holds of every member of every later cohort exactly where descent from "
            "that step keeps it: the grammar's closure law on dated descent. The line read off a flow carrying its founders' "
            "inherited reading is its case at the first cohort.",
            "一代之每一成员所具者，具于其后每一代之每一成员，恰在自该步之传承保之处：文法之闭律于有时日之传承上。读自一流之系携其始祖所传之读法，为其于首代之特例。",
            [G("descentFrom"), G("reached_from"), G("kept_iff"), G("kept_of_descent"), B("Flow.lineOf_carries")]),
        law("A region of readings holding every member at a step, and closed under revision on the course from that step on, "
            "holds every member at every later step; a carrier whose update leaves it, with a kid, puts a non-carrier into "
            "the next cohort.",
            "一读法区域于某步具于每一成员、且自该步起于程上之修订下闭，则于其后每一步具于每一成员；其更新离之之携者，有后裔则置一非携者于下一代。",
            [G("ClosedFrom"), G("fixed_of_closedFrom"), G("revised_out")]),
        law("Variation drawn from what is present: where each member senses the reading of a member of its own cohort and "
            "the update keeps the region wherever both lie in it, a region fixed at a step stays fixed at every later step.",
            "取自所在者之变异：每一成员感其本代某成员之读法、且二者皆在区域内处更新保此区域，则于某步定之区域于其后每一步皆定。",
            [G("fixed_of_present")]),
        law("Standing read off a web's levels, where each member senses the reading of a relatum standing then, the update "
            "keeps the region wherever both lie in it, and from a step on every relatum standing carries the region, the "
            "region is closed under revision on the course from that step on.",
            "立读自网之水平，每一成员感其时所立之某关系项之读法、二者皆在区域内处更新保之、且自某步起每一所立之关系项皆携此区域，则此区域自该步起于程上之修订下闭。",
            [B("Flow.closedFrom_of_standing")]),
        law("Witnesses, descent and what is sensed supplied: the wide reading's one carrier leaving no kid and every member "
            "sensing only its own cohort, the narrow reading is carried by every member at every later step; a narrow "
            "carrier sensing a wide one, revision copying what it senses, puts a wide kid into the next cohort.",
            "见证，传承与所感者为给定：宽读法之唯一携者无后裔、每一成员只感其本代，窄读法于其后每一步为每一成员所携；一窄携者感一宽携者、修订抄其所感，则置一宽后裔于下一代。",
            [B("ReadingsSpread.Contact.copy"), B("ReadingsSpread.Contact.read"), B("ReadingsSpread.Contact.removed"),
             B("ReadingsSpread.Contact.senseSelf"), B("ReadingsSpread.Contact.removed_family"),
             B("ReadingsSpread.Contact.removed_revises"), B("ReadingsSpread.Contact.removed_locked"),
             B("ReadingsSpread.Contact.met"), B("ReadingsSpread.Contact.senseOther"), B("ReadingsSpread.Contact.readMet"),
             B("ReadingsSpread.Contact.met_revises"), B("ReadingsSpread.Contact.met_replaced")]),
    ]
    decls = [d for l in laws for d in l["declarations"]]
    references, bindings = refs(decls, ts)
    return {
        "schema_version": 2,
        "id": "where-a-reading-locks",
        "title": T("Where a reading locks", "读法于何处锁定"),
        "kind": "theorem",
        "status": "recorded-checked",
        "family": "F07",
        "reviewed_at_utc": NOW,
        "statement": T(
            "A region of readings fixed at a step and closed under revision on the course stays fixed; with variation drawn "
            "from what is present fixation is a lock, and a course on which every relatum standing carries the region "
            "closes it under copying.",
            "于某步定且于程上之修订下闭之读法区域保持定；变异取自所在者时，定即锁；每一所立之关系项皆携此区域之程，于抄写下闭之。"),
        "laws": laws,
        "hypotheses": [
            T("No axiom. Generations given by a first family and each member's kids, or read off a flow; descent dated by "
              "step.", "不加公理。诸代由首代与每一成员之后裔给出，或读自一流；传承以步记时。"),
            T("What a member senses and the update are supplied; the copying cases take what is sensed to be a reading of a "
              "cohort member, or of a relatum standing then.",
              "成员所感者与更新为给定；抄写诸例取所感者为本代成员之读法，或其时所立之关系项之读法。"),
            T("The witnesses supply their descent and what each member senses.", "诸见证给定其传承与每一成员所感者。"),
        ],
        "does_not_show": [
            {**T("That a course generated by acts removes the other readings' carriers while revision copies what stands: "
                 "the commons witness's readings are inherited.",
                 "由诸举所生之程在修订抄所立者时移除其他读法之携者：公地见证之读法为继承。"), "kind": "scope"},
            {**T("That a fixed region stays fixed under variation from beyond the population: the present-variation law "
                 "takes what is sensed from the cohort.",
                 "定之区域于来自群体之外之变异下保持定：所在变异之律取所感者于本代。"), "kind": "scope"},
            {**T("The lock of a rule reading the share it selects: that is RuleCapture's, a different loop.",
                 "读其所选份额之规则之锁：此为 RuleCapture 之所述，另一环。"), "kind": "non-implication"},
            {**T("That a closed region is right or wanted: the law states what descent keeps.",
                 "闭之区域为对或为所欲：此律只陈传承所保者。"), "kind": "non-implication"},
        ],
        "counterexamples": [],
        "standard_boundaries": COMMON_BOUNDS,
        "validation_scope": T(
            "Pure core, axiom report empty; the closure law lies in ReadingsPersist, the rest in ReadingsSpread, a leaf. "
            "Every law is near-definitional, the witnesses computed on supplied generations. Written by an AI; one reader "
            "of another model read the statements cold (READER in the study folder); no human audit.",
            "纯核心，公理报告为空；闭律在 ReadingsPersist，余在叶模块 ReadingsSpread。诸律皆近于定义，见证于给定之诸代上计算。AI 所写；另一模型之读者冷读诸陈述（研究目录 READER）；无人类审计。"),
        "next_delta": T(
            "A course generated by acts on which revision copies what stands and a reading's act removes the other "
            "readings' carriers before their contact revises it, with the course where the contact comes first.",
            "一由诸举所生之程，其上修订抄所立者、一读法之举在其他读法之携者之接触修订之前移除之；及接触在先之程。"),
        "correspondence": T(
            "Reading (the AI's, from its knowledge): fixation under copying is absorbing as in the neutral models of "
            "population genetics and cultural evolution (Kimura, 1983; Cavalli-Sforza and Feldman, 1981); a region kept by "
            "descent is the reading loop's kept reading across generations.",
            "解读（AI 据其知识）：抄写下之固定为吸收态，如群体遗传学与文化演化之中性模型（Kimura，1983；Cavalli-Sforza 与 Feldman，1981）；为传承所保之区域即读之环所保之读法跨诸代者。"),
        "canonical_source": SPREAD,
        "aliases": ["where a reading locks", "a region closed under revision", "读法于何处锁定",
                    G("kept_iff"), G("fixed_of_closedFrom"), G("fixed_of_present")],
        "dependencies": [
            dep("readings-carried-on-their-course", "formal-reuse",
                "The line carrying its founders' reading (Flow.lineOf_carries) is now the closure law's case at the first cohort.",
                "携始祖读法之系（Flow.lineOf_carries）今为闭律于首代之特例。",
                "Every member of every cohort of the line carries the founders' reading.", "系之每一代之每一成员皆携始祖之读法。",
                "The closure law on dated descent.", "有时日之传承上之闭律。",
                "Inheritance along descent; founders carrying the reading.", "沿传承之继承；始祖携此读法。", evidence=PERSIST),
            dep("readings-revised-at-descent", "formal-reuse",
                "Reads revision at descent (Generations.RevisesBy, Flow.RevisesBy) for the lock.",
                "为锁读传承时之修订（Generations.RevisesBy、Flow.RevisesBy）。",
                "Each kid's reading is its parent's updated by what it sensed.", "每一后裔之读法为其亲依所感者更新者。",
                "A region closed under the update on the course.", "程上于更新下闭之区域。",
                "What is sensed and the update supplied.", "所感者与更新为给定。"),
        ],
        "related": [
            {"id": "a-reading-kept-by-its-update",
             "detail": T("The reading loop's kept region, the same closure law; here across descent.",
                         "读之环所保之区域，同一闭律；此处跨传承。")},
            {"id": "a-goal-along-a-lineage",
             "detail": T("A goal carried along one lineage: the closure law's form along a single line.",
                         "沿一谱系所携之目标：闭律沿单一系之形。")},
            {"id": "capture-through-the-rule",
             "detail": T("A different lock: a rule reading the share it selects.", "另一种锁：读其所选份额之规则。")},
            {"id": "a-selection-removing-its-readers",
             "detail": T("Removing one's readers, here read as removing the variation that could revise one.",
                         "移除其读者，此处读为移除可修订己者之变异。")},
        ],
        "references": references,
        "proof_bindings": bindings,
        "history": [HISTORY],
    }


def record_commons(ts):
    laws = [
        law("A focal, a wide and a dweller's line: the focal and wide lines draw on one source, renewed by itself or by the "
            "dweller's line, the dweller requires a habitat; the focal line reads its own line only, its line and its "
            "source, or everything. Every course is the one the acts generate, each relatum acting by its reading.",
            "一焦点系、一宽系与一栖者之系：焦点与宽系汲于一源，源或自续或由栖者之系续，栖者需一栖地；焦点系只读其自身之系、其系及其源、或一切。每一程皆诸举所生之程，各关系项依其读法而行。",
            [C("Rel"), C("Reading"), C("drawS"), C("clears"), C("stands"), C("fed"), C("conduct"), C("act"),
             C("isFocal"), C("readOf"), C("restLaw"), C("world"), C("world_byReading"), C("members"), C("requires"),
             C("need"), C("webOf"), C("flowOf"), C("flowOf_follows"), C("fed_of_agree"), C("act_nonanticipating"),
             C("world_nonanticipating"), C("evenLate"), C("keep"), C("cleared"), C("overSource"), C("overdrawn"),
             C("clearedBack"), C("overdrawnBack"), C("start"), C("present"), C("keep_balances"),
             C("cleared_balances_late"), C("cleared_balances"), C("overdrawn_taken_late"), C("overdrawn_balances_late"),
             C("overdrawn_balances"), C("clearedBack_balances"), C("overdrawnBack_balances"), C("generated")]),
        law("The population is the descent the flow shows from the three founders, readings inherited along it; the narrow "
            "readings are those that do not read the dweller. Reading everything, either world: no narrow carrier at any "
            "step, every line persisting.",
            "群体为流自三始祖所示之传承，读法沿之而继；窄读法为不读栖者者。读一切时，任一世界：无一步有窄携者，每一系存续。",
            [C("pop"), C("isNarrow"), C("narrow"), C("narrow_sum"), C("inherits"), C("flatMap_congr"),
             C("keep_shift"), C("keep_unmoved"), C("Line"), C("isWide"), C("isDweller"), C("slotsOf"),
             C("profile_late"), C("removes_of_gone"), C("standsLate_alt"), C("keep_persists")]),
        law("Reading its line and its source, nothing coming back: the narrow count is one of three, two of four, then two "
            "of three at every later step, selection proper positive across the first two steps and none at the two "
            "after, nothing revised; the dweller's line is removed, the focal and wide lines persist.",
            "读其系及其源、无所返：窄者之计为三之一、四之二，其后每一步为三之二，于首二步依选择本项而升，无修订；栖者之系被移除，焦点与宽系存续。",
            [C("cleared_shift"), C("cleared_family_late"), C("cleared_spreads")]),
        law("The same reading where the dweller renews the source: the same counts over three steps, selection proper "
            "positive across the first two; then the focal line is removed from the third step, the wide line from the "
            "sixth, and the population is empty from then on.",
            "栖者续源时同一读法：三步上同样之计，首二步选择本项为正；然后焦点系自第三步被移除，宽系自第六步，群体自此为空。",
            [C("clearedBack_ends")]),
        law("Reading its own line only, nothing coming back: the same counts over three steps, selection proper positive "
            "across the first two, then no narrow carrier and the wide line's one member at every step, the focal line "
            "removed; where the dweller renews the source, the same counts and selection proper, every line removed by "
            "the third step.",
            "只读其自身之系、无所返：三步上同样之计，首二步选择本项为正，然后每一步无窄携者、只宽系之一成员，焦点系被移除；栖者续源时同样之计与选择本项，每一系至第三步皆被移除。",
            [C("overdrawn_kids_shift"), C("overdrawn_shift"), C("overdrawn_family_late"),
             C("overdrawn_spreads_then_ends"), C("overdrawnBack_ends")]),
    ]
    decls = [d for l in laws for d in l["declarations"]]
    references, bindings = refs(decls, ts)
    return {
        "schema_version": 2,
        "id": "a-narrow-reading-in-a-commons",
        "title": T("A narrow reading in a commons, with and without return", "公地中之窄读法，有返与无返"),
        "kind": "theorem",
        "status": "recorded-checked",
        "family": "F07",
        "reviewed_at_utc": NOW,
        "statement": T(
            "On a world whose courses its acts generate, a reading that draws on a dweller's habitat spreads by selection "
            "and keeps its share where nothing comes back, spreads and then ends with every line where the dweller renewed "
            "the source, and spreads and then ends where it overdraws its own source.",
            "于其程为诸举所生之世界上，汲于栖者之栖地之读法：无所返时依选择而布并保其份额；栖者曾续其源时布而后与每一系同终；透支其自身之源时布而后终。"),
        "laws": laws,
        "hypotheses": [
            T("No axiom. A finite world: ten relata, natural levels, discrete steps; each member stands one step and, fed, "
              "passes its standing on.", "不加公理。一有限世界：十个关系项，自然数水平，离散步；每一成员立一步，得养则传其立。"),
            T("The acts each reading gives are assigned by design (what each draws, whether it takes the habitat, the "
              "second slot), as are the needs, the renewal and the starting levels.",
              "各读法所给之举依设计指定（各汲多少、是否取栖地、第二位），所需、续与起始水平亦然。"),
            T("Readings are inherited along descent; nothing is revised in this world.", "读法沿传承而继；此世界中无修订。"),
        ],
        "does_not_show": [
            {**T("That a narrow reading spreads in general: the rise comes from the acts assigned, which draw on what the "
                 "dweller requires.", "窄读法一般而布：此升来自所指定之举，其汲于栖者所需者。"), "kind": "scope"},
            {**T("A lock in this world: its readings are inherited, so no revision occurs to be closed against.",
                 "此世界中之锁：其读法为继承，故无修订可闭。"), "kind": "scope"},
            {**T("That the wider reading is selected: reading everything, the focal line leaves one kid where the narrow "
                 "reading leaves two.", "较宽之读法被选：读一切时焦点系留一后裔，窄读法留二。"), "kind": "non-implication"},
            {**T("Any correspondence with actual populations or trained systems.", "与实际群体或已训练系统之任何对应。"),
             "kind": "correspondence"},
        ],
        "counterexamples": [],
        "standard_boundaries": COMMON_BOUNDS,
        "validation_scope": T(
            "Pure core, axiom report empty; a leaf. Six courses, each shown to be the one the acts generate, their balance "
            "proved for all steps; the population, counts and selection terms computed. Written by an AI; one reader of "
            "another model read the statements cold (READER in the study folder); no human audit.",
            "纯核心，公理报告为空；叶模块。六程，各证为诸举所生之程，其平衡证于每一步；群体、计数与选择项皆计算。AI 所写；另一模型之读者冷读诸陈述（研究目录 READER）；无人类审计。"),
        "next_delta": T(
            "The same commons with revision built into the acts, so that the narrow reading's removal of the dweller and "
            "the dweller's contact revising it race on one generated course.",
            "同一公地而修订入于诸举，使窄读法之移除栖者与栖者之接触修订之于一所生之程上相竞。"),
        "correspondence": T(
            "Reading (the AI's, from its knowledge): a commons drawn by a heritable strategy that takes more, its spread "
            "while the stock lasts and the collapse where the loss feeds back, is the tragedy of the commons read as "
            "selection (Hardin, 1968; Rankin, Bargum and Kokko, 2007).",
            "解读（AI 据其知识）：为一取更多之可遗传策略所汲之公地，存在时其布、损失反馈时之崩，即读为选择之公地悲剧（Hardin，1968；Rankin、Bargum 与 Kokko，2007）。"),
        "canonical_source": SPREAD,
        "aliases": ["a narrow reading in a commons", "the commons witness", "公地中之窄读法",
                    C("cleared_spreads"), C("clearedBack_ends"), C("overdrawn_spreads_then_ends")],
        "dependencies": [
            dep("readings-carried-on-their-course", "formal-reuse",
                "Uses the generated course (ExchangeLaw.levels_of_follows), the world acting by its readings "
                "(ExchangeLaw.byReading) and the line read off a flow (Flow.lineOf).",
                "用所生之程（ExchangeLaw.levels_of_follows）、依其读法而行之世界（ExchangeLaw.byReading）及读自一流之系（Flow.lineOf）。",
                "A balanced flow following its law has the generated levels; the line read off it.",
                "依其律之平衡之流有所生之水平；读自其上之系。",
                "Six closed-form courses and their population.", "六个闭式之程及其群体。",
                "Balance proved for all steps.", "平衡证于每一步。"),
            dep("readings-revised-at-descent", "formal-reuse",
                "Counts the narrow region (Generations.carrying) and uses that inheritance revises nothing.",
                "计窄区域（Generations.carrying），并用继承无修订。",
                "A region's count and its revisions.", "一区域之计数及其修订。",
                "The population read off each course.", "读自每一程之群体。",
                "Readings inherited along descent.", "读法沿传承而继。"),
            dep("a-selection-removing-its-readers", "formal-reuse",
                "States removal and persistence as J2 does (RemovesLine, StandsLate) on the closed-form levels.",
                "于闭式水平上如 J2 陈移除与存续（RemovesLine、StandsLate）。",
                "A course removing a line; a line standing late.", "移除一系之程；晚立之系。",
                "The three lines of the commons.", "公地之三系。",
                "The lines' slots listed.", "诸系之位已列。"),
        ],
        "related": [
            {"id": "which-readings-persist",
             "detail": T("The same shape with one line carrying a reading; here three lines share one world and the share is read.",
                         "同一形而一系携一读法；此处三系同在一世界并读份额。")},
            {"id": "ending-laws-as-regimes-on-a-lineage",
             "detail": T("A lineage drawn past renewal; here the drawing line spreads first.", "被汲过续之谱系；此处汲者之系先布。")},
            {"id": "capture-through-the-rule",
             "detail": T("A target's share rising where winning buys more power to win; here the share rises by drawing beyond.",
                         "胜者得更多胜之力处目标份额之升；此处份额依汲于外而升。")},
        ],
        "references": references,
        "proof_bindings": bindings,
        "history": [HISTORY],
    }


NOW = datetime.now(timezone.utc).replace(microsecond=0).isoformat()


def main():
    ts = sys.argv[1] if len(sys.argv) > 1 else None
    for rec in (record_revised(ts), record_locks(ts), record_commons(ts)):
        path = RECORDS / f"{rec['id']}.json"
        path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print("wrote", path.relative_to(ROOT))


if __name__ == "__main__":
    main()
