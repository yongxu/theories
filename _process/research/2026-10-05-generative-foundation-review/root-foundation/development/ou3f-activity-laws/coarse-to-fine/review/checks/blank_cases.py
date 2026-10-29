"""Check 3d: blank_comments on Lean 4 lexical cases written by the reviewer (read-only). Each case gives the source and
the code that must survive (comments and string contents blanked, line breaks and length kept); a case marked
'gap' is one the function does not handle, shown with what it does."""
import importlib.util, sys
from pathlib import Path
sys.dont_write_bytecode = True
ROOT = Path.cwd()
spec = importlib.util.spec_from_file_location('s3b', ROOT / '_process/research/2026-10-05-generative-foundation-review/'
                                              'root-foundation/development/ou3b-master-laws-on-the-grammar/kit/signatures_ou3b.py')
s = importlib.util.module_from_spec(spec); spec.loader.exec_module(s)

def survive(t):
    return ' '.join(s.blank_comments(t).split())

cases = [
    ('nested block', 'a /- x /- y -/ z -/ b', 'a b'),
    ('docstring then def', '/-- doc\ndef fake -/\ndef real := 1', 'def real := 1'),
    ('module doc', '/-! # T\nclass constant x -/\nx', 'x'),
    ('docstring nesting /- inside', '/-- a /- b -/ c -/ d', 'd'),
    ('line comment after code', 'def x := 1 -- note /- not a comment opener\ny', 'def x := 1 y'),
    ('line comment holding -/', 'a -- -/ b\nc', 'a c'),
    ('-- inside a string', 'f "a -- b" c', 'f " " c'),
    ('/- inside a string', 'f "a /- b" c', 'f " " c'),
    ('escaped quote in string', 'f "a\\"b -- c" d -- e', 'f " " d'),
    ('escaped backslash ends string', 'f "a\\\\" -- c\nd', 'f " " d'),
    ('string gap (backslash newline)', 'f "a\\\n  b" c', 'f " " c'),
    ('quote in a comment', '/- " -/ a -- "\nb', 'a b'),
    ('-/ in a string inside a comment (Lean closes at the first -/, then a string opens)', '/- "-/" -/ a', '"'),
    ("char literal '\"'", "f '\"' -- c\nd", "f '\"' d"),
    ("char literal '\\''", "f '\\'' g", "f '\\'' g"),
    ("char literal '\\\\'", "f '\\\\' -- c\nd", "f '\\\\' d"),
    ("char literal '-'", "f '-' g", "f '-' g"),
    ("hex char literal '\\x22' (a quote)", "f '\\x22' g", "f '\\x22' g"),
    ("primed identifiers h' h'' a'b'", "fun h' h'' a'b' => h' -- c\nd", "fun h' h'' a'b' => h' d"),
    ("prime then quote: h'\"x\"", 'f h\' "s -- t" u', 'f h\' " " u'),
    ('«» name, plain', 'theorem «亡于粗则亡于细» := x', 'theorem «亡于粗则亡于细» := x'),
    ('gap: «» name holding --', 'theorem «a--b» := x\ny', 'theorem «a--b» := x y'),
    ('gap: «» name holding /-', 'theorem «a/-b» := x\ny', 'theorem «a/-b» := x y'),
    ('gap: raw string r"a\\"', 'f r"a\\" -- c\nd', 'f r" " d'),
    ('gap: raw string r#"a"b"#', 'f r#"a"b"# -- c\nd', 'f r#" "# d'),
    ('gap: /--/ (doc opener, body starting with /)', '/--/ x -/ y', 'y'),
]
bad = 0
for label, src, want in cases:
    out = s.blank_comments(src)
    kept = len(out) == len(src) and out.count('\n') == src.count('\n')
    got = survive(src)
    ok = kept and got == want
    bad += not ok and not label.startswith('gap')
    print(('ok  ' if ok else 'GAP ' if label.startswith('gap') else 'FAIL'), f'{label}: got {got!r}' +
          ('' if ok else f', Lean reads {want!r}'), '' if kept else '(length or lines not kept)')
print('unexpected failures:', bad)
