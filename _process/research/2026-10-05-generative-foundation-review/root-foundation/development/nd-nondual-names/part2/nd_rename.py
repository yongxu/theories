"""ND part 2: rename the core's names that state a command, a value or ownership, in a tree (argv[1]).

Code: whole identifiers (a dotted name's last parts included) are renamed by NAMES; binders named obeys/obey become
marks, good becomes leads (the witness predicate good in ReadingLoop becomes avoids). Comments: names in backticks are
renamed the same way; prose "obey(s/ing)" of laws becomes "satisfy(ies/ing)", except HeldForReading, whose obeying is a
system obeying a stop; the prose edits in PROSE are made exactly once each."""
import re, sys
from pathlib import Path

T = Path(sys.argv[1])
PKG = T / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
B = PKG / 'Becoming'

NAMES = {
    'ListingObeys': 'ListingMarksHold', 'listingObeys_of_obeys': 'listingMarksHold_of_marksHold',
    'table_obeys': 'table_marks_hold', 'table_obeys_free': 'table_marks_hold_free',
    'census_table_obeys': 'census_table_marks_hold', 'census_table_obeys_free': 'census_table_marks_hold_free',
    'census_table_obeys₂': 'census_table_marks_hold₂', 'census_table_obeys₃': 'census_table_marks_hold₃',
    'CountsObey': 'CensusMarksHold', 'countsHold_of_obey': 'countsHold_of_marks',
    'StandsObey': 'StandingMarksHold', 'standsObey_iff': 'standingMarksHold_iff', 'DependsObey': 'DependenceMarksHold',
    'harms_superadditive': 'rises_superadditive', 'difference_belongs_to_the_joint': 'difference_only_together',
}
DOTTED = {'CountsHold.obey': 'CountsHold.marks'}   # a theorem in a structure's namespace
READING = {'Good': 'LeadsInto', 'GoodEnabled': 'LeadsIntoEnabled', 'keeps_of_good': 'keeps_of_leadsInto',
           'good_of_keeps': 'leadsInto_of_keeps', 'keeps_iff_good': 'keeps_iff_leadsInto',
           'everything_good_iff': 'everything_leadsInto_iff', 'nothing_good': 'nothing_leadsInto'}
ID = r"[A-Za-z0-9_'₀-₉!?]"


def spans(text):
    """(is_comment, piece) over the text: line comments, nested block comments, strings left as code."""
    out, i, n, start = [], 0, len(text), 0
    while i < n:
        if text.startswith('--', i):
            j = text.find('\n', i); j = n if j < 0 else j
            out += [(False, text[start:i]), (True, text[i:j])]; i = start = j
        elif text.startswith('/-', i):
            depth, j = 1, i + 2
            while j < n and depth:
                if text.startswith('/-', j): depth += 1; j += 2
                elif text.startswith('-/', j): depth -= 1; j += 2
                else: j += 1
            out += [(False, text[start:i]), (True, text[i:j])]; i = start = j
        elif text[i] == '"':
            j = i + 1
            while j < n and text[j] != '"':
                j += 2 if text[j] == '\\' else 1
            i = j + 1
        else:
            i += 1
    out.append((False, text[start:]))
    return [s for s in out if s[1]]


def rename_ids(piece, names):
    for old in sorted(names, key=len, reverse=True):
        piece = re.sub(rf"(?<!{ID}){re.escape(old)}(?!{ID})", names[old], piece)
    return piece


def in_ticks(piece, names):
    return re.sub(r'`[^`\n]*`', lambda m: rename_ids(m.group(0), names), piece)


def prose_obey(piece):
    piece = re.sub(r'\bobeys\b', 'satisfies', piece)
    piece = re.sub(r'\bobeying\b', 'satisfying', piece)
    piece = re.sub(r'\bObey\b', 'Satisfy', piece)
    return re.sub(r'\bobey\b', 'satisfy', piece)


def process(path, names, code_extra=None, obey_prose=True):
    text = path.read_text(encoding='utf-8')
    out = []
    for comment, piece in spans(text):
        if comment:
            piece = in_ticks(piece, names)
            if obey_prose:
                piece = prose_obey(piece)
        else:
            piece = rename_ids(piece, names)
            if code_extra:
                piece = code_extra(piece)
        out.append(piece)
    new = ''.join(out)
    if new != text:
        path.write_text(new, encoding='utf-8')
        return True
    return False


ALL = {**NAMES, **DOTTED}


def binders_obey(piece):
    return re.sub(rf"(?<!{ID})obeys?(?!{ID})", 'marks', piece)


changed = []
for p in sorted(B.glob('*.lean')):
    if p.name == 'ReadingLoop.lean':
        continue
    extra = binders_obey if p.name in ('CensusTable.lean', 'Counting.lean', 'CensusBinding.lean', 'Standing.lean') else None
    if process(p, ALL, extra, obey_prose=p.name != 'HeldForReading.lean'):
        changed.append(p.name)

# ReadingLoop: the witness predicate good (x ≠ w) becomes avoids; every other good is a binder, leads
p = B / 'ReadingLoop.lean'
text = p.read_text(encoding='utf-8')
w0 = text.index('/-- An act is good at a world where it is not the act that world names. -/')
w1 = text.index('theorem none_for_all')
w1 = text.index('\n\n', w1)


def reading_code(piece):
    return re.sub(rf"(?<!{ID})good(?!{ID})", 'leads', piece)


head, wit, tail = text[:w0], text[w0:w1], text[w1:]
p.write_text(head, encoding='utf-8'); process(p, {**READING, **ALL}, reading_code, False); head = p.read_text(encoding='utf-8')
p.write_text(tail, encoding='utf-8'); process(p, {**READING, **ALL}, reading_code, False); tail = p.read_text(encoding='utf-8')
p.write_text(wit, encoding='utf-8')
process(p, {'good': 'avoids'}, None, False); wit = p.read_text(encoding='utf-8')
p.write_text(head + wit + tail, encoding='utf-8')
changed.append('ReadingLoop.lean')
print('changed:', ' '.join(changed))
