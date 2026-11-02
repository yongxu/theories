#!/usr/bin/env python3
"""UE30: which laws reach continuation itself (Becoming.«续» or Becoming.«相续») in Lean, through statements and proofs.

Constants come from THEOREM-CONNECTIVITY.py's dump_constants(), which restores the modules from the checker's cache and
runs one Lean process; the laws and their declarations from shared-laws.json. Reaching says what a proof as written
passes through, not that a law needs it: a definition can be unfolded. Run from a checkout root; the dump needs the
load gate, and a saved pickle of the dump can be passed instead.
usage: python3 -B walk_continuation.py [constants.pickle]"""
import collections
import importlib.util
import json
import pickle
import sys

STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
TARGETS = {'Becoming.«续»', 'Becoming.«相续»'}
# Each of these reads continuation at the one class «一», so continuation there is the relation itself (`«一之续»`):
# «尽则不或屡» and Amounts.falls_end state «尽» at «一», and «尽»'s constructor and recursor are how they reach «续».
AT_THE_ONE_CLASS = ('Becoming.«尽则不或屡»', 'Becoming.Amounts.falls_end', 'Becoming.«尽».mk', 'Becoming.«尽».rec')
NINE = ['closing-needs-net-draw', 'own-count-misses-joint-excess', 'what-an-optimum-does-beyond-what-couples-in',
        'what-bounds-offspring-numbers', 'identical-cells-under-a-descent-treating-them-alike',
        'risk-minimization-on-a-shared-renewal', 'the-rest-outruns-the-renewal', 'what-seeking-cannot-separate',
        'a-code-held-as-counts']


def constants():
    if len(sys.argv) > 1:
        with open(sys.argv[1], 'rb') as f:
            return pickle.load(f)
    spec = importlib.util.spec_from_file_location('tc', STUDY + 'THEOREM-CONNECTIVITY.py')
    tc = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(tc)
    return tc.dump_constants()[0]


C = constants()
users = collections.defaultdict(set)
for name, entry in C.items():
    for used in set(entry.get('t', [])) | set(entry.get('v', [])):
        users[used].add(name)


def reaching(skip=()):
    found, stack = set(TARGETS), list(TARGETS)
    while stack:
        for user in users[stack.pop()]:
            if user not in found and user not in skip:
                found.add(user)
                stack.append(user)
    return found


reach = reaching()
beside = reaching({n for n in C if n.startswith(AT_THE_ONE_CLASS) or n == 'Becoming.«尽»'})
with open('theories/becoming/results/data/shared-laws.json', encoding='utf-8') as f:
    data = json.load(f)
records, counts = data['records'], data['counts']


def reaches(law):
    return any(d in reach for d in law.get('declarations', []))


by_record = collections.Counter(r for r, laws in records.items() for law in laws if reaches(law))
print('laws read', counts['laws'] - counts['no_declarations'] - counts['outside'], 'reach the grammar', counts['grammar'])
print('laws reaching continuation', sum(by_record.values()), 'in records', len(by_record))
only = sum(1 for laws in records.values() for law in laws
           if reaches(law) and not any(d in beside for d in law.get('declarations', [])))
print('of those, reaching it only at the one class', only)
print('of the nine records', sum(len(records[r]) for r in NINE), 'laws,', sum(by_record[r] for r in NINE), 'reach it')
for record, n in by_record.most_common():
    print(f'  {record} {n} of {len(records[record])}')
