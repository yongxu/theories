#!/usr/bin/env python3
"""OU3f's coarse-to-fine pair: OU3b's blank_comments on Lean 4 lexical cases, after the review (REVIEW-CTF finding 7).
The review's cases (review/checks/blank_cases.py) expected string contents blanked; the scanner now keeps strings, so
an edit inside a string in a definition's body is seen. Each case gives the source and the code that must survive
(comments blanked, strings, «» names and character literals kept, length and line breaks kept). The review's five gaps
are cases here, and text left open at the end must stop the scan, naming where.
usage (from the checkout root): python3 -B <kit>/scanner_cases.py"""
import importlib.util
import sys
from pathlib import Path

sys.dont_write_bytecode = True
spec = importlib.util.spec_from_file_location('s3b', Path.cwd() / '_process/research/2026-10-05-generative-foundation-'
                                              'review/root-foundation/development/ou3b-master-laws-on-the-grammar/kit/signatures_ou3b.py')
s = importlib.util.module_from_spec(spec)
spec.loader.exec_module(s)

cases = [
    ('nested block', 'a /- x /- y -/ z -/ b', 'a b'),
    ('docstring then def', '/-- doc\ndef fake -/\ndef real := 1', 'def real := 1'),
    ('module doc', '/-! # T\nclass constant x -/\nx', 'x'),
    ('docstring nesting /- inside', '/-- a /- b -/ c -/ d', 'd'),
    ('line comment after code', 'def x := 1 -- note /- not a comment opener\ny', 'def x := 1 y'),
    ('line comment holding -/', 'a -- -/ b\nc', 'a c'),
    ('-- inside a string', 'f "a -- b" c', 'f "a -- b" c'),
    ('/- inside a string', 'f "a /- b" c', 'f "a /- b" c'),
    ('escaped quote in string', 'f "a\\"b -- c" d -- e', 'f "a\\"b -- c" d'),
    ('escaped backslash ends string', 'f "a\\\\" -- c\nd', 'f "a\\\\" d'),
    ('string gap (backslash newline)', 'f "a\\\n  b" c', 'f "a\\ b" c'),
    ('quote in a comment', '/- " -/ a -- "\nb', 'a b'),
    ("char literal '\"'", "f '\"' -- c\nd", "f '\"' d"),
    ("char literal '\\''", "f '\\'' g", "f '\\'' g"),
    ("char literal '\\\\'", "f '\\\\' -- c\nd", "f '\\\\' d"),
    ("char literal '-'", "f '-' g", "f '-' g"),
    ("char literal '«'", "f '«' -- c\nd", "f '«' d"),
    ("hex char literal '\\x22' (a quote)", "f '\\x22' g", "f '\\x22' g"),
    ("primed identifiers h' h'' a'b'", "fun h' h'' a'b' => h' -- c\nd", "fun h' h'' a'b' => h' d"),
    ("prime then quote: h'\"x\"", 'f h\' "s -- t" u', 'f h\' "s -- t" u'),
    ('«» name, plain', 'theorem «亡于粗则亡于细» := x', 'theorem «亡于粗则亡于细» := x'),
    ('«» name holding --', 'theorem «a--b» := x\ny', 'theorem «a--b» := x y'),
    ('«» name holding /-', 'theorem «a/-b» := x\ny', 'theorem «a/-b» := x y'),
    ('«» name holding "', 'theorem «a"b» := x -- c\ny', 'theorem «a"b» := x y'),
    ('raw string r"a\\"', 'f r"a\\" -- c\nd', 'f r"a\\" d'),
    ('raw string r#"a"b"#', 'f r#"a"b"# -- c\nd', 'f r#"a"b"# d'),
    ('identifier ending in r, then a string', 'f xr"a -- b" c', 'f xr"a -- b" c'),
    ('/--/ (doc opener, body starting with /)', '/--/ x -/ y', 'y'),
    ('/---/ (doc opener, then the closer)', '/---/ y', 'y'),
    ('/--/ inside a comment opens and closes', '/- a /--/ b -/ c', 'c'),
]
open_at_end = [
    ('string', 'f "a'),
    ('comment', 'a /- b'),
    ('nested comment', 'a /- b /- c -/'),
    ('«» name', 'theorem «a := x'),
    ('raw string', 'f r#"a"b'),
    ('-/ in a string inside a comment (Lean closes at the first -/, then a string opens)', '/- "-/" -/ a'),
]
bad = 0
for label, src, want in cases:
    out = s.blank_comments(src, label)
    kept = len(out) == len(src) and out.count('\n') == src.count('\n')
    got = ' '.join(out.split())
    ok = kept and got == want
    bad += not ok
    print('ok  ' if ok else 'FAIL', f'{label}: got {got!r}' + ('' if ok else f', Lean reads {want!r}'),
          '' if kept else '(length or lines not kept)')
for label, src in open_at_end:
    try:
        s.blank_comments(src, f'case {label}')
        bad += 1
        print('FAIL', f'open at the end, {label}: not stopped')
    except AssertionError as e:
        named = f'case {label}' in str(e)
        bad += not named
        print('ok  ' if named else 'FAIL', f'open at the end, {label}: stopped' + ('' if named else ', without naming it'))
print('failures:', bad)
sys.exit(1 if bad else 0)
