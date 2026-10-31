#!/usr/bin/env python3
"""HE2 items 6 and 7, from the twenty-first review's item 13, taken by OU's owner on 30 October 2026 for HE2's one
near-full rebuild (NOTE §8):
  6. the core and 理 into `Becoming.GrammarLaws`, beside «有常定后则同行»: the composition 01 §4 states, checked
     outside the package in `review/CoreAndLi.lean`, as four laws (no record of their own; the master-laws record's
     lumping law lists them);
  7. the core's names that wrote 理 renamed to 核, and «从缘生非文法之理» to «从缘生非文法之律», with no aliases kept:
     off a class or a fixed successor the core need not be a 理, so those names stated a wrong meaning; in the
     candidate's name 理 meant a law of the grammar, and the two conditions it names are conditions on a model.
The flame witnesses «两火以薪定理» and «两火同火不足以定理» keep their names: on their models the successor is fixed
and the alike relation is a class, so the core there is a 理 and the names state what they mean.

From the checkout root:
  python3 -B he2_core_li.py --check                  every part's current text is found as expected; writes nothing
  python3 -B he2_core_li.py --apply lean             the Lean files and the package READMEs (before the checker run)
  python3 -B he2_core_li.py --apply records N        the records, after the checker run; N is HE2's study section
  python3 -B he2_core_li.py --apply records N --no-notes   the same, printing the history clauses instead of
                                                     writing them, for one HE2 note per record
  python3 -B he2_core_li.py --apply register LOG     the apart register, from THEOREM-CONNECTIVITY.py --check's log
  python3 -B he2_core_li.py --apply texts            the chapters, the glossary, two review pages and the outside
                                                     check's header
  python3 -B he2_core_li.py --list                   every rebind and rewording, file or record, field, old and new
  python3 -B he2_core_li.py --scan                   live files still writing an old name that no part covers
Each part checks all of its edits before it writes any file, and a part already applied checks as applied. Every
part works by name or by text, not by line or position, so the parts apply before or after HE2's other items in one
pass (item 1 edits Grammar.lean at «两端分则中有标», which holds no name renamed here), and the records part scans
every record, so a record another item makes to cite an old name is rebound too and printed. NOTE §8 lists what the
landing runs besides these parts."""
import json
import hashlib
import re
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/'
B = PKG + 'Becoming/'
REC = 'theories/becoming/results/records/'
CH = 'theories/becoming/chapters/'
STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
HERE = STUDY + 'development/rv21-one-sense/'
APART = STUDY + 'THEOREM-CONNECTIVITY-APART.json'

RENAMES = {  # item 7: old name -> new name (the Lean names, written with guillemets in every file)
    '守理则不穷': '守核则不穷',
    '守理之线不亡': '守核之线不亡',
    '亡前理变': '亡前核变',
    '有亡之线两端理异': '有亡之线两端核异',
    '足以定理': '足以定核',
    '合有常则足以定理': '合有常则足以定核',
    '从缘生非文法之理': '从缘生非文法之律',
}
LAW_NAME = '从缘生非文法之理'  # the one rename whose 理 meant a law, not the core

# Item 6's four names. OU's owner named them «定后则类之核同行», «遍后则同行之类含于核», «定后遍后则核为最粗同行之类»
# and «后不定则核可不同行»; the second and third take `S` inside `E` («则» S E), which the names did not say, and read
# literally they are false (the whole relation goes alike under every step), so 其内 is proposed (HE2 kit review).
# A different choice changes these four lines only.
N_FIX = '定后则类之核同行'
N_IN = '遍后则其内同行之类含于核'
N_CO = '定后遍后则核为其内最粗同行之类'
N_WIT = '后不定则核可不同行'
NEW_LAWS = [N_FIX, N_IN, N_CO, N_WIT]


def names(text):
    return text.replace('@FIX@', N_FIX).replace('@IN@', N_IN).replace('@CO@', N_CO).replace('@WIT@', N_WIT)


# Each file's count of «old» tokens (exact, guillemets included: «两火同火不足以定理» and «合有常则足以定理» do not
# contain «足以定理»). History folders, receipts and studies are never touched.
LEAN_TOKENS = {
    PKG + 'Becoming.lean': {'守理则不穷': 1, '亡前理变': 1},
    PKG + 'README.md': {'守理则不穷': 1, '亡前理变': 1},
    PKG + 'README.zh.md': {'守理则不穷': 1, '亡前理变': 1},
    B + 'Grammar.lean': {'足以定理': 9, '合有常则足以定理': 3},
    B + 'GrammarRegularity.lean': {'守理则不穷': 3, '守理之线不亡': 4, '亡前理变': 4, '有亡之线两端理异': 3},
    B + 'GrammarScope.lean': {'守理则不穷': 4},
    B + 'GrammarCandidates.lean': {'从缘生非文法之理': 1},
}

# The names in docstring headings, written without guillemets, and the docstrings and README cells that wrote 理
# for a line's regularity (the core), where the English writes "regularity": 规律 in Chinese, "regularity" in English.
LEAN_PLAIN = [
    (B + 'Grammar.lean', 'regularity of `E₁` (足以定理):', 'regularity of `E₁` (足以定核):'),
    (B + 'Grammar.lean', 'and the core (核): whether a line has its own 理 -/',
     'and the core (核): whether a line has its own regularity -/'),
    (B + 'GrammarRegularity.lean', 'can always be kept (守理则不穷).', 'can always be kept (守核则不穷).'),
    (B + 'GrammarRegularity.lean', 'leaves the core (亡前理变).', 'leaves the core (亡前核变).'),
    (B + 'GrammarRegularity.lean', 'rules that change themselves (理之守与变)', 'rules that change themselves (规律之守与变)'),
    (PKG + 'README.zh.md', '故一条续之理是其类之核', '故一条续自身之规律是其类之核'),
    (PKG + 'README.zh.md', '| 理之守与离，及自改其则者', '| 规律之守与离，及自改其则者'),
    (PKG + 'README.zh.md', '可能之网中步不在「完与否」之理中', '可能之网中步不在「完与否」之规律中'),
    (PKG + 'README.zh.md', '一类下之线所必含者，与一理所纳者', '一类下之线所必含者，与一规律所纳者'),
]

LAWS_AFTER = "  («类有常当且仅当含于核» R hE).mp («同行遍后则有常» alike total)\n"
LAWS = names('''
/-- **With a fixed successor, the core of a class goes alike.** Where the step's successor is fixed, the
core of a class `E` is a class inside `E` that the step goes alike across. -/
theorem «@FIX@» {R E : «际» α} (hE : «类» E) (fixed : «定后» R) :
    «类» («核» R E) ∧ «则» («核» R E) E ∧ «同行» R («核» R E) :=
  ⟨«核为类» R hE, («根» R E).1, «有常定后则同行» («根» R E).2.1 fixed⟩

/-- **Where every occurrence has a successor, a class inside `E` going alike lies in the core of `E`.**
Neither a fixed successor nor `E` a class is needed. -/
theorem «@IN@» {R E : «际» α} (total : ∀ x, ∃ y, R x y) :
    ∀ S, «类» S → «则» S E → «同行» R S → «则» S («核» R E) :=
  fun S hS hSE alike => («根» R E).2.2.2 S hSE (fun _ _ h => hS.symm h) («同行遍后则有常» alike total)

/-- **With a fixed successor that every occurrence has, the core of a class is the coarsest class inside it
that the step goes alike across.** -/
theorem «@CO@» {R E : «际» α} (hE : «类» E) (fixed : «定后» R)
    (total : ∀ x, ∃ y, R x y) :
    («类» («核» R E) ∧ «则» («核» R E) E ∧ «同行» R («核» R E)) ∧
      ∀ S, «类» S → «则» S E → «同行» R S → «则» S («核» R E) :=
  ⟨«@FIX@» hE fixed, «@IN@» total⟩

/-- **Off a fixed successor the core of a class need not go alike (witness).** Where `0` steps to `1` and to
`2` and `E` is the identity, `E` is a class, the successor is not fixed, the core relates `0` to itself and
not `1` to `2`, and the step does not go alike across it. -/
theorem «@WIT@» : ∃ (R E : «际» Nat),
    R 0 1 ∧ R 0 2 ∧ (∀ x y, E x y ↔ x = y) ∧
      «类» E ∧ ¬ «定后» R ∧ «核» R E 0 0 ∧ ¬ «核» R E 1 2 ∧ ¬ «同行» R («核» R E) := by
  refine ⟨fun x y => x = 0 ∧ (y = 1 ∨ y = 2), «静», ?_⟩
  have hid : «核» (fun x y : Nat => x = 0 ∧ (y = 1 ∨ y = 2)) «静» 0 0 :=
    ⟨«静», fun _ _ h => h, fun _ _ h => h.symm, «静有常» _, rfl⟩
  have apart : ¬ «核» (fun x y : Nat => x = 0 ∧ (y = 1 ∨ y = 2)) «静» 1 2 := fun ⟨_, hS, _, _, h12⟩ => by
    have same : (1 : Nat) = 2 := hS 1 2 h12
    exact absurd same (by decide)
  refine ⟨⟨rfl, Or.inl rfl⟩, ⟨rfl, Or.inr rfl⟩, fun _ _ => Iff.rfl, ⟨fun _ => rfl, Eq.symm, Eq.trans⟩,
    fun fixed => ?_, hid, apart, fun h => ?_⟩
  · have same : (1 : Nat) = 2 := fixed 1 2 ⟨0, ⟨rfl, Or.inl rfl⟩, ⟨rfl, Or.inr rfl⟩⟩
    exact absurd same (by decide)
  · exact apart (h 1 2 ⟨0, ⟨0, ⟨rfl, Or.inl rfl⟩, hid⟩, ⟨rfl, Or.inr rfl⟩⟩)
''')
DOC_OLD = "  (`«有常定后则同行»`, `«同行遍后则有常»`) are corollaries."
DOC_NEW = names(
    "  (`«有常定后则同行»`, `«同行遍后则有常»`) are corollaries. With a fixed successor the core of a class is a\n"
    "  class inside it that the step goes alike across (`«@FIX@»`); where every occurrence has a\n"
    "  successor, every class inside a relation going alike lies in its core (`«@IN@»`), so with\n"
    "  both the core of a class is the coarsest such class (`«@CO@»`); off a fixed successor it\n"
    "  need not go alike (`«@WIT@»`).")

# The texts: (label, path, current, proposed); a current text may be a tuple of alternatives, the first found used.
CORE_OLD = (
    "**Theorem** (root; composed from the declarations it cites, with a witness, checked outside the package). "
    "*The core and 理.* Let `E` be a class. Where the step's successor is fixed (`«定后»`), the core of `E` is a class "
    "inside `E` (`«根»`, `«核为类»`) that the step goes alike across (`«有常定后则同行»`; going alike, `«同行»`, is "
    "[§7](#r-master-laws-on-the-grammar)'s): a 理 in [knowing's](03-KNOWING.md#li) sense, read relationally. Where every "
    "occurrence also has a successor, every class inside `E` that the step goes alike across lies inside the core "
    "(`«同行遍后则有常»` with `«根»`), so the core is the coarsest such class, the 理 of `E`. Off a fixed successor the core "
    "need not go alike: where one occurrence steps to two, the identity is a class whose core relates that occurrence "
    "to itself and not its two successors to each other, so the step does not go alike across it "
    "([check](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rv21-one-sense/review/CoreAndLi.lean), "
    "the composition a declaration proposed for `Becoming.GrammarLaws`). Of the names below that write 理, "
    "`«守理则不穷»`, `«守理之线不亡»`, `«亡前理变»` and the definition `«足以定理»` are stated for the core of every relation "
    "`E`, and `«有亡之线两端理异»` and `«合有常则足以定理»` for classes. Where `E` is a class and the successor is fixed they "
    "name a 理, with a successor everywhere the 理 of `E`; elsewhere their 理 is the core.")
CORE_NEW = names(
    "**Theorem** (root; with a witness). *The core and 理.* Let `E` be a class. Where the step's successor is fixed "
    "(`«定后»`), the core of `E` is a class inside `E` that the step goes alike across (`«@FIX@»`; going alike, "
    "`«同行»`, is [§7](#r-master-laws-on-the-grammar)'s): a 理 in [knowing's](03-KNOWING.md#li) sense, read relationally. "
    "Where every occurrence has a successor, every class inside `E` that the step goes alike across lies inside the "
    "core (`«@IN@»`), so with both the core is the coarsest such class, the 理 of `E` "
    "(`«@CO@»`). Off a fixed successor the core need not go alike: where one occurrence steps to two, "
    "the identity is a class whose core relates that occurrence to itself and not its two successors to each other, "
    "so the step does not go alike across it (`«@WIT@»`).")
T8_OLD = "For life, the way is 生生, life in the whole and its continuing generation, compared by widening what can form"
T8_NEW = ("For life, the way is 生生, life in the whole and its continuing generation [AI reading, D1], compared by "
          "widening what can form")
P26 = 'Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "'
TEXTS = [
    ("01 §4: the core and 理, cited from GrammarLaws, the names' residue gone", CH + '01-ROOT.md', CORE_OLD, CORE_NEW),
    ("01 §4: GS1's theorem, the renamed names", CH + '01-ROOT.md',
     "has a successor under the core (`«守理则不穷»`), and a line along which the core is kept leaves its last "
     "occurrence continued under `E` (`«守理之线不亡»`). A step into an end under `E` leaves the core, for every "
     "relation `E` (`«亡前理变»`)",
     "has a successor under the core (`«守核则不穷»`), and a line along which the core is kept leaves its last "
     "occurrence continued under `E` (`«守核之线不亡»`). A step into an end under `E` leaves the core, for every "
     "relation `E` (`«亡前核变»`)"),
    ("01 §4: GS1's theorem, the ends of a line", CH + '01-ROOT.md',
     "lie in different classes of the core (`«有亡之线两端理异»`)", "lie in different classes of the core (`«有亡之线两端核异»`)"),
    ("01 §5: the definition through the core", CH + '01-ROOT.md',
     "suffices for the regularity of `E₁` (足以定理) where", "suffices for the regularity of `E₁` (足以定核) where"),
    ("01 §5: the constancy forms imply the core forms", CH + '01-ROOT.md',
     "(`«合有常则足以定理»`, `«因于则因于核»`, `«相须则相须核»`)", "(`«合有常则足以定核»`, `«因于则因于核»`, `«相须则相须核»`)"),
    ("01 §7: the lumping bullet points to §4's theorem on the core", CH + '01-ROOT.md',
     "goes alike (`«像定后当且仅当同行»`). `GoAlikeUnder` is going alike at each move",
     "goes alike (`«像定后当且仅当同行»`). Where the successor is fixed a class's core goes alike, and with a successor "
     "everywhere too it is the coarsest class inside the class that does ([§4](#constancy-and-core)). `GoAlikeUnder` "
     "is going alike at each move"),
    ("the glossary's 理 row", 'GLOSSARY.md',
     "where every occurrence also has a successor, the coarsest one inside the class, its 理. The root's names on "
     "cores that write 理 (`«守理则不穷»`, `«亡前理变»`, `«足以定理»`; `«有亡之线两端理异»` takes a class) mean the core of "
     "the relation they are stated for, shown a 理 where it is a class and the successor fixed |",
     names("where every occurrence also has a successor, the coarsest one inside the class, its 理 (`«@FIX@»`, "
           "`«@CO@»`) |")),
    ("06: the three that do not hold", CH + '06-CLASSICAL-TEXTS.md',
     "都是对模型的前提，不是定理（`«从缘生非文法之理»`）", "都是对模型的前提，不是定理（`«从缘生非文法之律»`）"),
    ("07: GS1's law cited", CH + '07-SIGNIFICANCE.md',
     "by GS1's [`«守理则不穷»`](01-ROOT.md#r-a-regularity-kept-and-changed)",
     "by GS1's [`«守核则不穷»`](01-ROOT.md#r-a-regularity-kept-and-changed)"),
    ("07 §2: the gloss of 生生 labelled (RP2b's independent read)", CH + '07-SIGNIFICANCE.md',
     "names life in the whole and its continuing generation (生发, not 02's 生成). Widening compares",
     "names life in the whole and its continuing generation (生发, not 02's 生成) [AI reading, D1]. Widening compares"),
    ("07 §8: T8's gloss of 生生 labelled (RP2b's independent read)", CH + '07-SIGNIFICANCE.md', T8_OLD, T8_NEW),
    ("the philosophy dossier: P-26 quotes T8 with its label, the label once", 'theories/becoming/review/PHILOSOPHY.md',
     (P26 + T8_OLD + '" ([AI reading, D1] for the gloss of 生生)', P26 + T8_OLD + '"'), P26 + T8_NEW + '"'),
    ("the review page on Buddhist thought: the corpus candidate", 'theories/becoming/review/BUDDHIST-THOUGHT.md',
     "`«从缘生非文法之理»`", "`«从缘生非文法之律»`"),
    ("the review page on Buddhist thought: the definition named", 'theories/becoming/review/BUDDHIST-THOUGHT.md',
     "（足以定理：在二类之合下同者", "（足以定核：在二类之合下同者"),
    ("the outside check: where its laws went", HERE + 'review/CoreAndLi.lean',
     "Not a package declaration: proposed to the grammar's owner for `Becoming.GrammarLaws`.\n",
     names("Not a package declaration: proposed to the grammar's owner for `Becoming.GrammarLaws`, where HE2's items 6\n"
           "and 7 state it as «@FIX@», «@IN@», «@CO@» and «@WIT@».\n")),
]

# The records: declarations renamed wherever a record lists them; the Chinese and English that wrote 理 for a line's
# regularity (the core) where it need not be one; the lumping law of master-laws-on-the-grammar; one history note in
# each record touched, naming what changed in it.
RENAMED_RECORDS = ['a-regularity-kept-and-changed', 'candidate-theorems-of-the-corpus',
                   'continuation-relative-to-a-class', 'reach-past-ones-own-end']
WORDING = [  # (record, field path, current, proposed)
    ('a-regularity-kept-and-changed', ('title', 'zh'), '理之守与离', '规律之守与离'),
    ('a-regularity-kept-and-changed', ('statement', 'zh'), '故所守之理总可再守', '故所守之规律总可再守'),
    ('a-regularity-kept-and-changed', ('correspondence', 'en'), "the core is the plan's 理 of the class.",
     "the core is the plan's 理 of the class, a 理 in the glossary's sense where the successor is fixed."),
    ('a-regularity-kept-and-changed', ('correspondence', 'zh'), '核即计划所言类之理。',
     '核即计划所言类之理，步之后定处即词汇表所言之理。'),
    ('continuation-relative-to-a-class', ('statement', 'zh'), '一条线之理是其类之核', '一条线自身之规律是其类之核'),
    ('continuation-relative-to-a-class', ('laws', 3, 'zh'), '其理在其类之核', '其自身之规律在其类之核'),
    ('continuation-relative-to-a-class', ('laws', 10, 'zh'), '则另一类足以定此类之理', '则另一类足以定此类之核'),
]
ML = 'master-laws-on-the-grammar'
ML_AFTER = 'Becoming.«类同行遍后则含于核»'
ML_EN_OLD = "A class going alike lies in its core,"
ML_EN_NEW = ("With a successor everywhere, a class that goes alike inside a relation lies in the relation's core, and a "
             "class going alike in its own; with a fixed successor a class's core goes alike, so with both it is the "
             "coarsest class inside the class that does, and off a fixed successor it need not;")
ML_ZH_OLD = "同行之类含于其核；"
ML_ZH_NEW = "遍后，一关系内同行之类含于该关系之核，同行之类含于其己之核；定后，类之核同行，二者兼则为类内最粗之同行之类，后不定则未必；"
ML_REFS = [(HERE + 'NOTE.md', 'integration'), (HERE + 'review/REVIEW-HE2-KIT.md', 'review')]

# The apart register: the two renamed roots re-keyed, their reasons kept; item 6's laws registered where the measure
# lists them as roots without a reason.
APART_REKEY = ['有亡之线两端理异', '从缘生非文法之理']
# Entries that item 6's laws make no longer roots: «定后则类之核同行» uses «核为类», so the entry goes, where the measure
# reports it stale; the new roots carry the reasons.
APART_DROP = ['核为类']
APART_NEW = {
    N_FIX: ('general-structure', "with a fixed successor a class's core is a class inside it that the step goes alike "
            "across: a law of every relation and class on any carrier (HE2 item 6) joining lumping to the core; "
            "nothing on the base uses it"),
    N_IN: ('general-structure', "with a successor everywhere a class inside a relation that goes alike lies in its "
           "core: a law of every relation on any carrier (HE2 item 6); nothing on the base uses it"),
    N_CO: ('general-structure', "with a fixed successor that every occurrence has, a class's core is the coarsest "
           "class inside it that the step goes alike across, 01 §4's 理 of the class: a law of every relation and "
           "class on any carrier (HE2 item 6); nothing on the base uses it"),
    N_WIT: ('model-witness', "a fact about one constructed relation: one occurrence stepping to two, where the "
            "identity's core does not go alike, so off a fixed successor the core need not be a 理 (HE2 item 6)"),
}

LOG = []  # (where, field, old, new), for --list


def full(name):
    return 'Becoming.«' + name + '»'


def read(path):
    return (ROOT / path).read_text(encoding='utf-8')


def write(path, text):
    (ROOT / path).write_text(text, encoding='utf-8')


def lean(apply):
    out = {}
    for path, counts in LEAN_TOKENS.items():
        text = out.get(path, read(path))
        for old, n in counts.items():
            have, done = text.count('«' + old + '»'), text.count('«' + RENAMES[old] + '»')
            assert (have, done) in ((n, 0), (0, n)), (path, old, have, done)
            LOG.append((path, f'{n} use(s)', '«' + old + '»', '«' + RENAMES[old] + '»'))
            text = text.replace('«' + old + '»', '«' + RENAMES[old] + '»')
        out[path] = text
    for path, old, new in LEAN_PLAIN:
        text = out.get(path, read(path))
        assert text.count(old) == 1 or (old not in text and text.count(new) == 1), (path, old)
        LOG.append((path, 'docstring heading (name)' if any(o in old for o in RENAMES) else 'docstring or cell (wording)',
                    old, new))
        out[path] = text.replace(old, new)
    path = B + 'GrammarLaws.lean'
    LOG.append((path, 'after «类同行遍后则含于核»', '(new)', ', '.join('«' + n + '»' for n in NEW_LAWS)))
    text = out.get(path, read(path))
    if 'theorem «' + N_FIX + '»' not in text:
        assert text.count(LAWS_AFTER) == 1 and text.count(DOC_OLD) == 1, path
        text = text.replace(LAWS_AFTER, LAWS_AFTER + LAWS).replace(DOC_OLD, DOC_NEW)
    else:
        assert text.count(DOC_NEW) == 1 and all(text.count('theorem «' + n + '»') == 1 for n in NEW_LAWS), path
    out[path] = text
    if apply:
        for path, text in out.items():
            if text != read(path):
                write(path, text)
    return len(out)


def texts(apply):
    out = {}
    for label, path, olds, new in TEXTS:
        text = out.get(path, read(path))
        olds = olds if isinstance(olds, tuple) else (olds,)
        old = next((o for o in olds if text.count(o) == 1), None)
        assert old is not None or (not any(o in text for o in olds) and text.count(new) == 1), (label, path)
        old = old or olds[0]
        renamed = [n for n in RENAMES if '«' + n + '»' in old or '（' + n + '：' in old or '(' + n + ')' in old]
        for n in renamed:
            LOG.append((path, label, n, RENAMES[n] if RENAMES[n] in new else '(removed with the residue sentence)'))
        added = [n for n in NEW_LAWS if '«' + n + '»' in new and '«' + n + '»' not in old]
        if added:
            LOG.append((path, label, '(new citation)', ', '.join(added)))
        if not renamed and not added:
            LOG.append((path, label, '(wording)', '(no name)'))
        out[path] = text.replace(old, new)
    if apply:
        for path, text in out.items():
            if text != read(path):
                write(path, text)
    return len(TEXTS)


def stamp_day():
    d = datetime.now(timezone.utc)
    return f"{d.day} {d:%B %Y}", f"{d.year}年{d.month}月{d.day}日"


def note(study, renamed, worded):
    """The history note of one record: the renames it holds, with their reasons, and its rewordings."""
    day_en, day_zh = stamp_day()
    core = [o for o in RENAMES if o in renamed and o != LAW_NAME]
    en, zh = [], []
    if core:
        en.append('the core\'s name' + ('s' if len(core) > 1 else '') + ' ' + ', '.join(f'«{o}»' for o in core)
                  + ' renamed to ' + ', '.join(f'«{RENAMES[o]}»' for o in core) + ', with no alias kept, since off a '
                  'class or a fixed successor the core need not be a 理')
        zh.append('核之名 ' + '、'.join(f'«{o}»' for o in core) + ' 改为 ' + '、'.join(f'«{RENAMES[o]}»' for o in core)
                  + '，不留别名，因离类或离定后之步，核未必为理')
    if LAW_NAME in renamed:
        en.append(f'«{LAW_NAME}» renamed to «{RENAMES[LAW_NAME]}», with no alias kept: its 理 meant a law of the '
                  'grammar, and the two conditions it names are conditions on a model')
        zh.append(f'«{LAW_NAME}» 改为 «{RENAMES[LAW_NAME]}»，不留别名：其理意为文法之律，所言二者是对模型之条件')
    if worded:
        corr = any(w.startswith('correspondence') for w in worded)
        en.append('wording only in ' + ', '.join(worded) + ': 理 written for a line\'s regularity, the core, becomes '
                  '规律 or 核' + (', and the correspondence says where the core is a 理' if corr else ''))
        zh.append('仅措辞，' + '、'.join(worded) + '：写作理之一线之规律（核）改为规律或核' + ('，对应处言核于何处为理' if corr else ''))
    return {'en': f"{day_en}, board item HE2, items 6 and 7 (study section {study}): " + '; '.join(en) + '; no statement\'s '
                  'content changes.',
            'zh': f"{day_zh}，工作板条目 HE2 之第 6、7 项（研究第 {study} 节）：" + '；'.join(zh) + '；所述之义皆不变。'}


def ml_note(study):
    day_en, day_zh = stamp_day()
    return {'en': f"{day_en}, board item HE2, item 6 (study section {study}): the lumping law gains four laws on a "
                  f"class's core and going alike in GrammarLaws («{N_FIX}», «{N_IN}», «{N_CO}», and the witness "
                  f"«{N_WIT}»), the composition 01 §4 states under \"The core and 理\", checked outside the package "
                  "before; and a correction: the clause \"a class going alike lies in its core\" was false without the "
                  "successor everywhere that «类同行遍后则含于核» takes, and now carries it; no other law changes.",
            'zh': f"{day_zh}，工作板条目 HE2 之第 6 项（研究第 {study} 节）：归并之律增入 GrammarLaws 中言类之核与同行之四律"
                  f"（«{N_FIX}»、«{N_IN}»、«{N_CO}»，及见证 «{N_WIT}»），即第一章 §4「核与理」所述之组合，此前在包外核验；"
                  "并更正：「同行之类含于其核」一句无「类同行遍后则含于核」所设之遍后则不真，今带之；其余之律不变。"}


def rename_list(names_):
    new = [full(RENAMES[n[len('Becoming.«'):-1]]) if n.startswith('Becoming.«') and n[len('Becoming.«'):-1] in RENAMES
           else n for n in names_]
    return sorted(new) if names_ == sorted(names_) else new


def at(o, path):
    for k in path[:-1]:
        o = o[k]
    return o, path[-1]


HELD = {}  # record id -> its HE2 history note, filled by records(); read by the lander's he2_records.py


def records(apply, study=None, notes=True):
    olds = {full(o) for o in RENAMES}
    bare = {'«' + o + '»': '«' + n + '»' for o, n in RENAMES.items()}
    out = {}
    found = []
    held = HELD  # rid -> history note, written or printed
    held.clear()
    for path in sorted((ROOT / REC).glob('*.json')):
        rid = path.stem
        raw = path.read_text(encoding='utf-8')
        if rid not in RENAMED_RECORDS and not any('«' + o + '»' in raw for o in RENAMES):
            continue
        r = json.loads(raw)
        renamed = set()

        def walk(o, where):
            if isinstance(o, dict):
                for k, v in o.items():
                    if k == 'history':
                        continue
                    if isinstance(v, list) and all(isinstance(x, str) for x in v) and set(v) & olds:
                        for d in sorted(set(v) & olds):
                            renamed.add(d[len('Becoming.«'):-1])
                            LOG.append((rid, '.'.join(map(str, where + (k,))), d, full(RENAMES[d[len('Becoming.«'):-1]])))
                        o[k] = rename_list(v)
                    elif isinstance(v, str):
                        for a, b in bare.items():
                            if a in v:
                                renamed.add(a[1:-1])
                                LOG.append((rid, '.'.join(map(str, where + (k,))), a, b))
                                v = v.replace(a, b)
                        o[k] = v
                    else:
                        walk(v, where + (k,))
            elif isinstance(o, list):
                for i, x in enumerate(o):
                    walk(x, where + (i,))
        walk(r, ())
        worded = []
        for wrid, field, old, new in WORDING:
            if wrid != rid:
                continue
            o, k = at(r, field)
            assert o[k].count(old) == 1 or (old not in o[k] and o[k].count(new) == 1), (rid, field, old)
            if old in o[k]:
                o[k] = o[k].replace(old, new)
                worded.append('.'.join(map(str, field)))
            LOG.append((rid, '.'.join(map(str, field)), old, new))
        applied = not renamed and not worded and any(full(n) in raw or '«' + n + '»' in raw for n in RENAMES.values())
        assert renamed or worded or applied, rid
        if renamed and rid not in RENAMED_RECORDS:
            found.append(rid)
        changed = bool(renamed or worded)
        if changed:
            held[rid] = note(study, renamed, worded)
            if apply and notes:
                r['history'].append(held[rid])
        out[rid] = (raw, r, changed)
    assert ML not in out, 'the master-laws record holds a renamed name: fold its renames into the part below'
    raw = read(REC + ML + '.json')
    r = json.loads(raw)
    laws = [law for law in r['laws'] if ML_AFTER in law['declarations']]
    assert len(laws) == 1, ML
    law = laws[0]
    gl = [ref for ref in r['references'] if ref['path'] == B + 'GrammarLaws.lean']
    assert len(gl) == 1
    if full(N_FIX) not in law['declarations']:
        assert law['en'].count(ML_EN_OLD) == 1 and law['zh'].count(ML_ZH_OLD) == 1, ML
        assert law['declarations'].count(ML_AFTER) == 1, ML
        i = law['declarations'].index(ML_AFTER) + 1
        law['declarations'][i:i] = [full(n) for n in NEW_LAWS]
        law['en'] = law['en'].replace(ML_EN_OLD, ML_EN_NEW)
        law['zh'] = law['zh'].replace(ML_ZH_OLD, ML_ZH_NEW)
        was_sorted = gl[0]['declarations'] == sorted(gl[0]['declarations'])
        gl[0]['declarations'] += [full(n) for n in NEW_LAWS]
        if was_sorted:
            gl[0]['declarations'].sort()
        for p, role in ML_REFS:
            assert not any(ref['path'] == p for ref in r['references']), (ML, p)
            if apply:
                r['references'].append({'path': p, 'role': role,
                                        'sha256': hashlib.sha256((ROOT / p).read_bytes()).hexdigest()})
        held[ML] = ml_note(study)
        if apply and notes:
            r['history'].append(held[ML])
        n = r['laws'].index(law)
        LOG.append((ML, f'laws.{n} (declarations); references (GrammarLaws.lean)', '(new)',
                    ', '.join(full(n) for n in NEW_LAWS)))
        LOG.append((ML, f'laws.{n}.en', ML_EN_OLD, ML_EN_NEW))
        LOG.append((ML, f'laws.{n}.zh', ML_ZH_OLD, ML_ZH_NEW))
        for p, role in ML_REFS:
            LOG.append((ML, 'references', '(new ' + role + ')', p))
        out[ML] = (raw, r, True)
    else:
        assert law['en'].count(ML_EN_NEW) == 1 and law['zh'].count(ML_ZH_NEW) == 1, ML
    if found:
        print('records citing an old name beyond the five known, rebound the same way:', ', '.join(found))
    if apply:
        stamp = datetime.now(timezone.utc).replace(microsecond=0).isoformat()
        for rid, (raw, r, changed) in out.items():
            if changed:
                r['reviewed_at_utc'] = stamp
                write(REC + rid + '.json', json.dumps(r, ensure_ascii=False, indent=2) + ('\n' if raw.endswith('\n') else ''))
        if not notes:
            print('history clauses, for one HE2 note per record:')
            for rid, h in held.items():
                print(f'{rid}\n  en: {h["en"]}\n  zh: {h["zh"]}')
    return len(out)


def register(apply, log_path=None):
    """Re-key the two renamed roots, keeping module, category and reason; register item 6's laws that the measure
    lists as roots without a reason. Textual edits, the rest of the file byte for byte (register_rr.py's pattern);
    roots that are not this kit's are printed for their owners."""
    t = read(APART)
    for o in APART_REKEY:
        k_old, k_new = json.dumps(full(o), ensure_ascii=False), json.dumps(full(RENAMES[o]), ensure_ascii=False)
        assert (t.count(k_old + ': {'), t.count(k_new + ': {')) in ((1, 0), (0, 1)), (APART, o)
        LOG.append((APART, 'roots (key, reason kept)', full(o), full(RENAMES[o])))
        t = t.replace(k_old + ': {', k_new + ': {')
    for n in NEW_LAWS:
        LOG.append((APART, 'roots (new, where listed)', '(new)', full(n)))
    if log_path is None:
        return 1
    log = Path(log_path).read_text(encoding='utf-8')
    m = re.search(r"apart roots without a reason in [^:]+: (\[[^\]]*\])", log)
    unclassified = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]
    m = re.search(r"register entries no longer apart roots: (\[[^\]]*\])", log)
    stale = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]
    mine = {full(n): v for n, v in APART_NEW.items()}
    block = ''
    for name in unclassified:
        if name in mine and json.dumps(name, ensure_ascii=False) not in t:
            cat, reason = mine[name]
            block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "Becoming.GrammarLaws",\n'
                      '   "category": "' + cat + '",\n   "reason": ' + json.dumps(name.replace('Becoming.', '') + ': '
                                                                                 + reason, ensure_ascii=False) + '\n  },\n')
    if block:
        anchor = '  }\n },\n "instances": {'
        assert t.count(anchor) == 1
        t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
    json.loads(t)
    others = [n for n in unclassified if n not in mine and n not in {full(RENAMES[o]) for o in APART_REKEY}]
    for o in APART_DROP:
        key = json.dumps(full(o), ensure_ascii=False) + ': {'
        if full(o) in stale:
            entry = re.search(r'\n  ' + re.escape(key) + r'\n(   .*\n)+?  \},?(?=\n)', t)
            assert entry and t.count(key) == 1, (APART, o)
            LOG.append((APART, 'roots (entry dropped, no longer a root)', full(o), '(gone)'))
            t = t[:entry.start()] + t[entry.end():] if entry.group().endswith(',') else None
            assert t is not None, (APART, o, 'last entry of its block')
    json.loads(t)
    others += [n for n in stale if n not in {full(o) for o in APART_REKEY + APART_DROP}]
    if others:
        print('roots and entries not this kit\'s, for their owners:', ', '.join(others))
    if apply and t != read(APART):
        write(APART, t)
    return 1


SKIP = ('/history/', 'becoming-checks/', '_process/BECOMING-WORKBOARD.md',  # the board names the renames old -> new
        'root-foundation/development/', 'root-foundation/twenty-first-review/',
        'superseded', 'BECOMING-RENEWAL-READING', 'repository-reconciliation/architecture/')
GENERATED = ('results/data/', 'results/lean-declarations/', 'becoming-verification.json', 'THEOREM-CONNECTIVITY.json',
             'THEOREM-CONNECTIVITY.md', 'THEOREM-CONNECTIVITY.zh.md', 'THEOREM-CONNECTIVITY-DUMP.lean',
             'results/records/')  # regenerated by the checker, render, the measure and MV's generator; records by part


def scan():
    import subprocess
    pattern = '|'.join('«' + o + '»' for o in RENAMES) + '|[（(]足以定理[）):：]|[（(]守理则不穷[）)]|[（(]亡前理变[）)]'
    files = subprocess.run(['git', 'grep', '-lE', pattern], cwd=ROOT, capture_output=True, text=True).stdout.split()
    covered = set(LEAN_TOKENS) | {p for p, _, _ in LEAN_PLAIN} | {p for _, p, _, _ in TEXTS} | {APART}
    left = [f for f in files if not any(s in f for s in SKIP) and f not in covered and not any(g in f for g in GENERATED)]
    print('live files writing an old name that no part covers:', ', '.join(left) or 'none')
    return left


if __name__ == '__main__':
    if sys.argv[1] in ('--list', '--scan'):
        if sys.argv[1] == '--list':
            lean(False), texts(False), records(False), register(False)
            for where, field, old, new in LOG:
                print(f'{where}\t{field}\t{old}\t{new}')
        else:
            sys.exit(1 if scan() else 0)
    elif sys.argv[1] == '--check':
        print(f'checked: lean ({lean(False)} files), texts ({texts(False)} edits), records ({records(False)} records), '
              f'register ({register(False)} file); each current text found as expected')
    elif sys.argv[1] == '--apply':
        part = sys.argv[2]
        if part == 'records':
            assert len(sys.argv) in (4, 5) and sys.argv[3].isdigit(), 'records needs HE2\'s study section number'
            print(f'applied: records ({records(True, sys.argv[3], notes="--no-notes" not in sys.argv)} records)')
        elif part == 'register':
            assert len(sys.argv) == 4, 'register needs the log of THEOREM-CONNECTIVITY.py --check'
            register(True, sys.argv[3])
            print('applied: register')
        else:
            print(f'applied: {part} ({ {"lean": lean, "texts": texts}[part](True)} files or edits)')
