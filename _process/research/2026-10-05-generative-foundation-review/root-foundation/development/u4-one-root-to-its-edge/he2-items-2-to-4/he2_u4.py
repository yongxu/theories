#!/usr/bin/env python3
"""HE2 items 2, 3 and 4, by U4's taker (31 October 2026), for HE2's one near-full rebuild (KIT.md):
  2. U4 lever 1's laws that hold over every pairing the counts admit, into `Becoming.GrammarLaws`: counting on a
     region («计»), the count kept on a region the relation does not cross, the count law of a class, what a pairing
     under continuation adds to equal count, and the census of a step, with their witnesses;
  3. «所闭之逆» into GrammarLaws' closure, with Response's `WithinClosure.converse` re-proved as it;
  4. «借步之所闭在二所闭» and «二所闭在借步之所闭» into GrammarLaws' closure, with SelectionPool's
     `WithinClosure.of_reads` and `WithinClosureOf.to_reads` re-proved through them.
Every statement in the package is kept; no name changes, so no record is rebound.

The Lean blocks are read from `tree/Becoming/HE2U4Laws.lean`, the file the outside check built, so what lands is
byte for byte what was checked (bar the kit's namespace `HE2U4`, which the target drops).

From the checkout root:
  python3 -B he2_u4.py --check                 every part's current text is found as expected; writes nothing
  python3 -B he2_u4.py --apply lean            GrammarLaws, Response and SelectionPool (before the checker run)
  python3 -B he2_u4.py --apply lean --to DIR   the same three files written below DIR at their package paths, for
                                               an outside build of GrammarLaws (KIT.md, "The check")
  python3 -B he2_u4.py --apply records N       the master-laws record, after the checker run; N is HE2's section
  python3 -B he2_u4.py --apply records N --no-notes   the same, printing the history clause instead of writing it
  python3 -B he2_u4.py --apply register LOG    the apart register, from THEOREM-CONNECTIVITY.py --check's log
  python3 -B he2_u4.py --list                  every edit: file or record, field, old and new
  python3 -B he2_u4.py --names                 writes tree/Becoming/HE2U4Names.lean, the laws under their target
                                               names below every module of the package (the clash check)
Each part checks all of its edits before it writes any file, and a part already applied checks as applied. Every
edit works by text, not by line, so the parts apply before or after HE2's other items in one pass: item 6 edits
GrammarLaws' lumping and its bullet, item 1 Grammar.lean, item 5 GrammarMap, item 7 names none of these."""
import json
import re
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/'
B = PKG + 'Becoming/'
REC = 'theories/becoming/results/records/'
STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
HERE = STUDY + 'development/u4-one-root-to-its-edge/he2-items-2-to-4/'
APART = STUDY + 'THEOREM-CONNECTIVITY-APART.json'
ML = 'master-laws-on-the-grammar'
GL, RESPONSE, POOL = B + 'GrammarLaws.lean', B + 'Response.lean', B + 'SelectionPool.lean'

LOG = []  # (where, field, old, new), for --list


def read(path):
    return (ROOT / path).read_text(encoding='utf-8')


def write(path, text, to=None):
    target = (Path(to) / path) if to else (ROOT / path)
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(text, encoding='utf-8')


def full(name):
    return 'Becoming.' + name


# The Lean blocks, from the checked file.
KIT = read(HERE + 'tree/Becoming/HE2U4Laws.lean')


def block(start, stop, keep_stop=False):
    i = KIT.index(start)
    j = KIT.index(stop, i)
    assert KIT.count(start) == 1, start
    return KIT[i:j + (len(stop) if keep_stop else 0)].strip() + '\n'


ITEM3 = block('/-- **The closure under the converse is the converse of the closure.**', '/-! ## Item 4')
ITEM4 = block('/-- **A closure through borrowed steps lies within two closures.**', '\nend Closure\n')
HELPERS = block('/-- The units a test keeps, in order. -/', '\nend GrammarLaws\n')
BALANCE = block('/-! ### Counting (计)', '\nend Balance\n')
CENSUS = block('/-! ## The census of a step (生, 亡)', 'end Census\n', keep_stop=True)

CLOSURE_LAWS = ['«所闭之逆»', '«借步之所闭在二所闭»', '«二所闭在借步之所闭»']
HELPER_NAMES = re.findall(r'^(?:theorem|def) (\S+)', HELPERS, re.M)
BALANCE_NAMES = re.findall(r'^(?:theorem|def) (\S+)', BALANCE, re.M)
CENSUS_NAMES = re.findall(r'^(?:theorem|def) (\S+)', CENSUS, re.M)
LIST_LEMMAS = ['GrammarLaws.' + n for n in HELPER_NAMES] + [n for n in BALANCE_NAMES + CENSUS_NAMES
                                                            if n.startswith('GrammarLaws.')]
BALANCE_LAWS = [n for n in BALANCE_NAMES + CENSUS_NAMES if not n.startswith('GrammarLaws.')] + \
    ['GrammarLaws.arising', 'GrammarLaws.ceasing']
LIST_LEMMAS = [n for n in LIST_LEMMAS if n not in BALANCE_LAWS]
NEW = CLOSURE_LAWS + LIST_LEMMAS + BALANCE_LAWS
assert len(NEW) == len(set(NEW)) == 38, (len(NEW), NEW)

# Insertions into GrammarLaws: (anchor, where, block), each anchor found once.
A3 = ("    (fun a b back related => «所闭之传递» («缘在所闭» (h a b related)) back) («所闭之自反» R x)\n\n")
INSERTS = [
    ('item 3, after «所闭之对称»', A3, 'after', ITEM3 + '\n'),
    ('item 4, before end Closure', '\nend Closure\n', 'before', '\n' + ITEM4),
    ('item 2, list helpers before end GrammarLaws', '\nend GrammarLaws\n', 'before', '\n' + HELPERS),
    ('item 2, counting before end Balance', '\nend Balance\n', 'before', '\n' + BALANCE),
    ('item 2, the census after end Runs', '\nend Runs\n', 'after', '\n' + CENSUS),
]

# GrammarLaws' module doc and the list block's doc: (label, old, new).
DOC = [
    ('the table: «计»',
     "| `«对»` | a perfect pairing of the places of two finite lists under a relation, each pair related |\n",
     "| `«对»` | a perfect pairing of the places of two finite lists under a relation, each pair related |\n"
     "| `«计»` | how many units of a list a test holds of: a region read as a test (`α → Bool`), a modelling choice; a "
     "region given as a proposition enters by `decide` |\n"),
    ('Closure: items 3 and 4',
     "  every step, grows with the relation, is symmetric for a symmetric relation, is itself closed,\n"
     "  nothing within it bears the relation beyond it, and a region is `x`'s closure exactly where it\n"
     "  holds `x`, is closed and lies within the closure (`«所闭之证»`). A region",
     "  every step, grows with the relation, is symmetric for a symmetric relation, read under the converse\n"
     "  is the closure read backward (`«所闭之逆»`), is itself closed, nothing within it bears the relation\n"
     "  beyond it, and a region is `x`'s closure exactly where it holds `x`, is closed and lies within the\n"
     "  closure (`«所闭之证»`). A closure through borrowed steps, every step of `R'` a step of `R` or a step\n"
     "  of `R` from `a` taken at `o`, lies within `o`'s or `a`'s closure under `R`\n"
     "  (`«借步之所闭在二所闭»`), and the two lie within `o`'s closure under `R'` where `R'` holds `R` and\n"
     "  `o` reaches `a` under it (`«二所闭在借步之所闭»`); Response's `WithinClosure.converse` and\n"
     "  SelectionPool's `WithinClosure.of_reads` and `WithinClosureOf.to_reads` are proved as these. A region"),
    ('Balance: item 2',
     "  natural-number balance, near-definitional under the one: the pairing is supplied, not derived from\n"
     "  the unfolding, and it establishes no trajectory of units.\n",
     "  natural-number balance, near-definitional under the one: the pairing is supplied, not derived from\n"
     "  the unfolding, and it establishes no trajectory of units. Counting a region's units (`«计»`, the\n"
     "  region read as a test), a pairing keeps the count on every region the relation does not cross\n"
     "  (`«对则不越域守数»`), so on every region closed under the relation and under its converse\n"
     "  (`«对则双闭域守数»`); closed one way is not enough (`«对而单闭域不守数之例»`). Under a class decided\n"
     "  by a test, a pairing is exactly equal count in every class (`«类之对当且仅当类类等数»`), and the\n"
     "  class does work: equal count pairs under the one and not under sameness (`«一对而静不对之例»`). So\n"
     "  a pairing under continuation relative to such a class keeps the count in every class\n"
     "  (`«续之对则类类等数»`). The census of a step (its own section, after the runs, whose fixed\n"
     "  successor and predecessor it reads): units listed once before and after a step, under a\n"
     "  continuation fixing successors and predecessors, pair those before with those arising to those\n"
     "  after with those ceasing (`«定后定前则前生对后亡»`), and on a listing closed at the step, arising\n"
     "  and ceasing are exactly beginning (`«生»`) and ending (`«亡»`) (`«步闭则所列生者生»`,\n"
     "  `«步闭则所列亡者亡»`). The listing and the test are supplied, as the pairing is.\n"),
    ('What is not shown: a pairing under continuation, now stated',
     "these); the n-step lines law for lines of different lengths; that a pairing under continuation\n"
     "(`«对» («续» R E)`) adds anything to equal count, which is not stated; any converse of the law of\n"
     "rest,",
     "these); the n-step lines law for lines of different lengths; that a pairing under continuation\n"
     "(`«对» («续» R E)`) adds anything to equal count beyond what is now stated: the count on every region\n"
     "it does not cross (`«对则不越域守数»`) and, where `E` is a class decided by a test, the count in every\n"
     "class (`«续之对则类类等数»`); any converse of the law of\n"
     "rest,"),
    ('the list block: the census helpers',
     "Lemmas on numbers and lists, not statements of the grammar: pigeonhole (`revisits_within`), the\n"
     "list surgery that pairings need, and the words that",
     "Lemmas on numbers and lists, not statements of the grammar: pigeonhole (`revisits_within`), the\n"
     "list surgery that pairings need, the filters and searches the census of a step needs (`keep`,\n"
     "`any_split`, `distinct_removed`), and the words that"),
]

# Response and SelectionPool: proofs re-proved through the laws, docstrings naming them; statements untouched.
MODELS = [
    (RESPONSE, 'WithinClosure.converse (docstring)',
     "`f`'s closure under the converse exactly when `f` lies within `g`'s closure under the relation. -/",
     "`f`'s closure under the converse exactly when `f` lies within `g`'s closure under the relation: the\n"
     "grammar's `«所闭之逆»` at the relation. -/"),
    (RESPONSE, 'WithinClosure.converse (proof)',
     "    WithinClosure (fun a b => rel b a) f g ↔ WithinClosure rel g f :=\n"
     "  ⟨fun within => within (fun x => WithinClosure rel x f)\n"
     "      (fun _ _ back related => (WithinClosure.of_rel (rel := rel) related).trans back)\n"
     "      (WithinClosure.refl f),\n"
     "   fun within => within (fun x => WithinClosure (fun a b => rel b a) x g)\n"
     "      (fun _ _ back related =>\n"
     "        (WithinClosure.of_rel (rel := fun a b => rel b a) related).trans back)\n"
     "      (WithinClosure.refl g)⟩\n",
     "    WithinClosure (fun a b => rel b a) f g ↔ WithinClosure rel g f :=\n"
     "  «所闭之逆»\n"),
    (POOL, 'WithinClosure.of_reads (docstring)',
     "lies within the closure of `o` and `a` under `rel`. -/",
     "lies within the closure of `o` and `a` under `rel`: the grammar's `«借步之所闭在二所闭»`, the pool\n"
     "of `o` and `a` read as their two closures. -/"),
    (POOL, 'WithinClosure.of_reads (proof)',
     "    (within : WithinClosure rel' o g) : WithinClosureOf rel (fun x => x = o ∨ x = a) g :=\n"
     "  within _ (fun g h inside related => match split g h related with\n"
     "      | .inl step => closedUnder_withinClosureOf g h inside step\n"
     "      | .inr ⟨_, step⟩ => closedUnder_withinClosureOf a h\n"
     "          (WithinClosureOf.of_member (.inr rfl) (WithinClosure.refl a)) step)\n"
     "    (WithinClosureOf.of_member (.inl rfl) (WithinClosure.refl o))\n",
     "    (within : WithinClosure rel' o g) : WithinClosureOf rel (fun x => x = o ∨ x = a) g :=\n"
     "  match «借步之所闭在二所闭» split within with\n"
     "  | .inl inside => ⟨o, .inl rfl, inside⟩\n"
     "  | .inr inside => ⟨a, .inr rfl, inside⟩\n"),
    (POOL, 'WithinClosureOf.to_reads (docstring)',
     "under `rel` lies within `o`'s under `rel'`. -/",
     "under `rel` lies within `o`'s under `rel'`: the grammar's `«二所闭在借步之所闭»`. -/"),
    (POOL, 'WithinClosureOf.to_reads (proof)',
     "    (within : WithinClosureOf rel (fun x => x = o ∨ x = a) g) : WithinClosure rel' o g :=\n"
     "  match within with\n"
     "  | ⟨_, .inl same, inside⟩ => same ▸ WithinClosure.mono larger inside\n"
     "  | ⟨_, .inr same, inside⟩ => reaches.trans (same ▸ WithinClosure.mono larger inside)\n",
     "    (within : WithinClosureOf rel (fun x => x = o ∨ x = a) g) : WithinClosure rel' o g :=\n"
     "  «二所闭在借步之所闭» larger reaches (match within with\n"
     "    | ⟨_, .inl same, inside⟩ => .inl (same ▸ inside)\n"
     "    | ⟨_, .inr same, inside⟩ => .inr (same ▸ inside))\n"),
]


def replace_once(text, old, new, where):
    """Replace `old` by `new` where `old` occurs once; where it is already applied, leave it."""
    if text.count(old) == 1:
        return text.replace(old, new)
    assert old not in text and text.count(new) == 1, (where, 'neither the old text once nor the new')
    return text


def lean(apply, to=None):
    gl = read(GL)
    applied = 'theorem «所闭之逆»' in gl
    for label, anchor, side, text in INSERTS:
        LOG.append((GL, label, '(new)', ', '.join(re.findall(r'^(?:theorem|def) (\S+)', text, re.M))))
        if applied:
            assert gl.count(text.strip()) == 1, (GL, label, 'applied in part')
            continue
        assert gl.count(anchor) == 1, (GL, label)
        gl = gl.replace(anchor, anchor + text if side == 'after' else text + anchor)
    for label, old, new in DOC:
        LOG.append((GL, 'doc: ' + label, old, new))
        gl = replace_once(gl, old, new, (GL, label))
    out = {GL: gl}
    for path, label, old, new in MODELS:
        text = out.get(path, read(path))
        LOG.append((path, label, old, new))
        out[path] = replace_once(text, old, new, (path, label))
    if apply:
        for path, text in out.items():
            if to or text != read(path):
                write(path, text, to)
    return len(out)


ML_EDITS = {  # law index: (the clause it follows, en, zh, declarations added)
    0: ("and a region is x's closure exactly where it holds x, is closed and lies within it.",
        " Under the converse it is the closure read backward; a closure through borrowed steps (each step of R′ a "
        "step of R, or a step of R from a taken at o) lies within o's or a's closure under R, and where R′ holds R "
        "and o reaches a under it, the two lie within o's closure under R′.",
        "一域恰在含 x、封闭且在闭包内时为 x 之闭包。",
        "逆关系下之闭包即闭包之逆读；借步之闭包（R′ 之每一步或为 R 之步，或为在 o 处所取、自 a 起之 R 之步）在 o 或 a 于 R 下之"
        "闭包内，而 R′ 含 R 且 o 于其下及 a 时，二者在 o 于 R′ 下之闭包内。",
        CLOSURE_LAWS),
    2: ("a value put in front of a sequence, and totals that agree pointwise.",
        None,
        "置于序列之前的一值、逐点相同之总和。",
        None,
        LIST_LEMMAS),
    3: ("are lengths of unit lists so paired under the one. Near-definitional.",
        " Counting a region's units (a region read as a test, a modelling choice), a pairing keeps the count on "
        "every region the relation does not cross, so on every region closed under it and its converse, closed one "
        "way not being enough; under a class decided by a test a pairing is exactly equal count in every class, and "
        "the class does work (equal count pairs under the one, not under sameness), so a pairing under continuation "
        "relative to such a class keeps the count in every class. The census of a step: units listed once before "
        "and after it, under a continuation fixing successors and predecessors, pair those before with those "
        "arising to those after with those ceasing, and on a listing closed at the step, arising and ceasing are "
        "beginning and ending. The listing and the test are supplied, as the pairing is.",
        "近乎定义。",
        "计一域之单位（域读作一判别，此为建模之择），配对守其关系所不越之每一域之数，故守对关系及其逆皆封闭之每一域之数，"
        "单向封闭不足；在由一判别所定之类下，配对恰是每一类中等数，而类有其用（等长者在「一」下配对，在「静」下不配对），"
        "故相对于此类之续下之配对守每一类之数。一步之清点：一步前后各列一次之单位，在定后定前之续下，前者并所生者与后者并"
        "所亡者一一配对；于该步封闭之列表上，所列之生与亡恰是生与亡。列表与判别皆为所给，如配对然。",
        BALANCE_LAWS),
}
ML_LIST_EN = ("a value put in front of a sequence, and totals that agree pointwise.",
              "a value put in front of a sequence, totals that agree pointwise, and the filters, searches and counts "
              "the census of a step and the count laws need.")
ML_LIST_ZH = ("置于序列之前的一值、逐点相同之总和。",
              "置于序列之前的一值、逐点相同之总和，及步之清点与计数之律所需之筛、查与计。")


def stamp_day():
    d = datetime.now(timezone.utc)
    return f"{d.day} {d:%B %Y}", f"{d.year}年{d.month}月{d.day}日"


def ml_note(study):
    day_en, day_zh = stamp_day()
    return {'en': f"{day_en}, board item HE2, items 2 to 4 (study section {study}): the closure law gains «所闭之逆» "
                  "and the two laws of a closure through borrowed steps («借步之所闭在二所闭», «二所闭在借步之所闭»), "
                  "which Response's WithinClosure.converse and SelectionPool's WithinClosure.of_reads and "
                  "WithinClosureOf.to_reads are now proved as; balance at one step gains counting on a region («计»), "
                  "the count kept where the relation does not cross, the count law of a class, what a pairing under "
                  "continuation adds to equal count and the census of a step, with two witnesses (U4's lever 1, "
                  "checked outside the package before); the list lemmas gain the helpers these use. No other law "
                  "changes.",
            'zh': f"{day_zh}，工作板条目 HE2 之第 2 至 4 项（研究第 {study} 节）：闭包之律增入 «所闭之逆» 及借步之闭包二律"
                  "（«借步之所闭在二所闭»、«二所闭在借步之所闭»），Response 之 WithinClosure.converse 与 SelectionPool 之 "
                  "WithinClosure.of_reads、WithinClosureOf.to_reads 今即由之证出；一步之平衡增入计一域之数（«计»）、"
                  "关系所不越之域守数、类之数律、续下配对于等数之所增与一步之清点，并二见证（U4 之第一杠杆，此前在包外核验）；"
                  "列表引理增入其所用之辅助。其余之律不变。"}


def records(apply, study=None, notes=True):
    raw = read(REC + ML + '.json')
    r = json.loads(raw)
    gl = [ref for ref in r['references'] if ref['path'] == GL]
    assert len(gl) == 1, ML
    done = full(CLOSURE_LAWS[0]) in r['laws'][0]['declarations']
    for i, (after_en, en, after_zh, zh, names) in ML_EDITS.items():
        law = r['laws'][i]
        LOG.append((ML, f'laws.{i} (declarations)', '(new)', ', '.join(full(n) for n in names)))
        if i == 2:
            pairs = [('en',) + ML_LIST_EN, ('zh',) + ML_LIST_ZH]
        else:
            pairs = [('en', after_en, after_en + en), ('zh', after_zh, after_zh + zh)]
        for lang, old, new in pairs:
            LOG.append((ML, f'laws.{i}.{lang}', old, new))
            if done:
                assert law[lang].count(new) == 1, (ML, i, lang, 'applied in part')
            else:
                assert law[lang].count(old) == 1, (ML, i, lang)
                law[lang] = law[lang].replace(old, new)
        if done:
            assert all(full(n) in law['declarations'] for n in names), (ML, i)
        else:
            assert not any(full(n) in law['declarations'] for n in names), (ML, i)
            law['declarations'] += [full(n) for n in names]
    LOG.append((ML, 'references (GrammarLaws.lean)', '(new)', f'{len(NEW)} declarations'))
    if not done:
        was_sorted = gl[0]['declarations'] == sorted(gl[0]['declarations'])
        gl[0]['declarations'] += [full(n) for n in NEW]
        if was_sorted:
            gl[0]['declarations'].sort()
        if apply:
            note = ml_note(study)
            if notes:
                r['history'].append(note)
            else:
                print(json.dumps(note, ensure_ascii=False, indent=1))
            write(REC + ML + '.json', json.dumps(r, ensure_ascii=False, indent=2) + '\n')
    return 1


GENERAL = ("a law of pairings under every relation on any carrier (U4's lever 1, HE2 item 2); the base reads balance "
           "in numbers and its consumers stay arithmetic, so nothing on the base uses it")
CENSUS_REASON = ("the census of a step on the grammar, a law of every continuation decided by a test on any carrier "
                 "(U4's lever 1, HE2 item 2); the models read arising and ceasing in their own terms, and nothing on "
                 "the base uses it")
APART_NEW = {
    '«对则不越域守数»': ('general-structure', 'the count kept on a region the relation does not cross: ' + GENERAL),
    '«对则双闭域守数»': ('general-structure', 'the count kept on a region closed both ways: ' + GENERAL),
    '«类之对当且仅当类类等数»': ('general-structure', 'the count law of a class: ' + GENERAL),
    '«续之对则类类等数»': ('general-structure', 'what a pairing under continuation adds to equal count, relative to '
                                         'a class decided by a test: ' + GENERAL),
    '«对而单闭域不守数之例»': ('model-witness', 'a fact about one constructed relation: a region closed one way where a '
                                          'pairing does not keep the count, so «对则双闭域守数» needs both ways '
                                          '(HE2 item 2)'),
    '«一对而静不对之例»': ('model-witness', 'a fact about one constructed relation: equal count pairs under the one '
                                       'and not under sameness, so the class in «类之对当且仅当类类等数» does work '
                                       '(HE2 item 2)'),
    '«定后定前则前生对后亡»': ('general-structure', CENSUS_REASON),
    '«步闭则所列生者生»': ('general-structure', CENSUS_REASON),
    '«步闭则所列亡者亡»': ('general-structure', CENSUS_REASON),
    'GrammarLaws.count_eq_countP': ('support', "a list lemma: the grammar's count is Lean's List.countP, proved with "
                                               "no axiom where Init's countP lemmas report propext (HE2 item 2)"),
}
assert set(APART_NEW) <= set(NEW)


def register(apply, log_path=None):
    """Register the kit's laws that the measure lists as roots without a reason. Textual edits, the rest of the file
    byte for byte (register_rr.py's pattern); roots that are not this kit's are printed for their owners."""
    t = read(APART)
    for n in APART_NEW:
        LOG.append((APART, 'roots (new, where listed)', '(new)', full(n)))
    if log_path is None:
        return 1
    log = Path(log_path).read_text(encoding='utf-8')
    m = re.search(r"apart roots without a reason in [^:]+: (\[[^\]]*\])", log)
    unclassified = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]
    mine = {full(n): v for n, v in APART_NEW.items()}
    block_ = ''
    for name in unclassified:
        if name in mine and json.dumps(name, ensure_ascii=False) not in t:
            cat, reason = mine[name]
            block_ += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "Becoming.GrammarLaws",\n'
                       '   "category": "' + cat + '",\n   "reason": ' + json.dumps(name.replace('Becoming.', '') + ': '
                                                                                  + reason, ensure_ascii=False)
                       + '\n  },\n')
    if block_:
        anchor = '  }\n },\n "instances": {'
        assert t.count(anchor) == 1
        t = t.replace(anchor, '  },\n' + block_.rstrip(',\n') + '\n },\n "instances": {')
    json.loads(t)
    others = [n for n in unclassified if n not in mine]
    if others:
        print('roots not this kit\'s, for their owners:', ', '.join(others))
    unlisted = [n for n in mine if n not in unclassified and json.dumps(n, ensure_ascii=False) not in t]
    if unlisted:
        print('this kit\'s laws the measure does not list as roots (not registered):', ', '.join(unlisted))
    if apply and t != read(APART):
        write(APART, t)
    return 1


def names():
    """The kit's laws under their target names, importing every module the package root imports: a name the package
    already declares fails there as already declared."""
    imports = [line for line in read(PKG + 'Becoming.lean').splitlines() if line.startswith('import ')]
    head, rest = KIT.split('\n', 1)
    assert head == 'import Becoming.GrammarLaws'
    assert rest.count('namespace HE2U4\n') == 1 and rest.count('end HE2U4\n') == 1
    rest = rest.replace('namespace HE2U4\n', '').replace('end HE2U4\n', '')
    doc = ("/-!\nHE2's items 2 to 4 under their target names, below every module of the package: a name the\n"
           "package already declares fails here as already declared. Generated from `HE2U4Laws.lean` by\n"
           "dropping its namespace `HE2U4` and importing the package root's imports (`KIT.md`).\n-/\n")
    write(HERE + 'tree/Becoming/HE2U4Names.lean', '\n'.join(imports) + '\n\n' + doc + rest.split('-/\n', 1)[1])
    return len(imports)


if __name__ == '__main__':
    if sys.argv[1] == '--names':
        print(f'written: tree/Becoming/HE2U4Names.lean ({names()} imports)')
    elif sys.argv[1] == '--list':
        lean(False), records(False), register(False)
        for where, field, old, new in LOG:
            print(f'{where}\t{field}\t{old}\t{new}')
    elif sys.argv[1] == '--check':
        print(f'checked: lean ({lean(False)} files), records ({records(False)} record), register ({register(False)} '
              f'file); each current text found as expected; {len(NEW)} new declarations')
    elif sys.argv[1] == '--apply':
        part = sys.argv[2]
        if part == 'lean':
            to = sys.argv[4] if len(sys.argv) == 5 and sys.argv[3] == '--to' else None
            assert len(sys.argv) == 3 or to, 'lean takes only --to DIR'
            print(f'applied: lean ({lean(True, to)} files{" below " + to if to else ""})')
        elif part == 'records':
            assert len(sys.argv) in (4, 5) and sys.argv[3].isdigit(), 'records needs HE2\'s study section number'
            print(f'applied: records ({records(True, sys.argv[3], notes="--no-notes" not in sys.argv)} record)')
        elif part == 'register':
            assert len(sys.argv) == 4, 'register needs the log of THEOREM-CONNECTIVITY.py --check'
            register(True, sys.argv[3])
            print('applied: register')
        else:
            sys.exit(f'unknown part {part}')
    else:
        sys.exit(__doc__)
