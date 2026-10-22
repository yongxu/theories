"""Register the apart root WL2 adds: SharedCodes.code_read_every, a law of every code on any type of senses and forms
and of courses of any values, reached by course_states_iff and course_read. Textual insertion at the end of the
roots, the rest of the file byte for byte.
usage (from the checkout root): python3 -B register.py"""
import json
from pathlib import Path
F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
t = F.read_text(encoding='utf-8')
name = 'Becoming.SharedCodes.code_read_every'
assert f'"{name}"' not in t
entry = ('  "' + name + '": {\n'
         '   "module": "Becoming.SharedCodes",\n'
         '   "category": "general-structure",\n'
         '   "reason": "A code whose every sequence of forms resolution reads back tells senses apart, and its course of '
         'forms is one state exactly where the course of senses is: a law of every code on any type of senses and forms '
         'and of courses of any values (with course_states_iff and course_read, which it uses). A course is the values of '
         'a run read through a map and every course is the course of a run of free branching (Parting.freeRun_course), '
         'so it holds of the courses of runs without naming one (WL2)."\n'
         '  }\n')
anchor = '  }\n },\n "instances": {'
assert t.count(anchor) == 1
t = t.replace(anchor, '  },\n' + entry + ' },\n "instances": {')
d = json.loads(t)
assert d['roots'][name]['category'] == 'general-structure'
F.write_text(t, encoding='utf-8')
print('register: 1 root added')
