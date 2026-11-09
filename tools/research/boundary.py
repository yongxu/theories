"""MV's boundary field (architecture/mv/BOUNDARY-FIELD.md): each central declaration's standing on U4's edge.

One record, U4's boundary record, declares under `boundary` the standings of central declarations of COVERAGE.json:
derived (a case of grammar laws, through declared bridges and support), on the root under a stated hypothesis (a root
form, its hypotheses each with a countermodel and a fit, a recovery and a certificate), or a reading (a distance, or
counting, with its basis); and, listed apart, the premises (§3.3), the hypotheses ranking results take where their theorems take them. What the Lean cannot show is declared and
reviewed; the rest is computed.

This module holds the field's rules, which the check (registry.py) applies with the review's text and the generator
(shared_laws.py) without it, and the generator's part:
- the spec's terms (§3.0) on the checker cache's constants: generated auxiliaries, reaching, root constants by
  content, grammar laws, forwarders, the balance anchors;
- D1 to D5 of a derived entry on those constants, and D6 with the Lean's admission of each law from the Lean check;
- a reading's fact, where the rule computes its label (§3.4), and the premises' Q1 (§3.3);
- U4's rule for every row the record does not place (§3.5), with "unplaced" as its fallback;
- the Lean check, tools/research/boundary_check.lean, run in the core run's environment restored from the cache;
- the report (§4).
An entry that fails is written unverified, with what it fails, and its row takes the rule's label: nothing here stops
the generator. This is a measurement of Lean dependency and of what the Lean check tests, not a reading of any row.
"""
import collections
import copy
import hashlib
import importlib.util
import json
import os
import re
import subprocess
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
CHECK = ROOT / 'tools/research/boundary_check.lean'
TC = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY.py'

# The labels of §1, in the order of the spec's table, and their groups.
LABELS = ('derived', 'under a stated hypothesis', 'counting', 'connected', 'witnessed at its model',
          'balance in its statement', 'amounts', 'at a represented model', 'own carrier', 'at its model',
          'free significance', 'unplaced')
GROUPS = {'on the edge': LABELS[:2], 'below the grammar': LABELS[2:3], 'distances': LABELS[3:11], 'unplaced': LABELS[11:]}
EDGE = LABELS[:2]
STANDINGS = LABELS[:-1]  # what an entry may declare
COMPUTED = ('connected', 'balance in its statement', 'at a represented model', 'own carrier')  # a reading needs the fact
# F5's four classes of central_reach, which the standings divide.
F5_CLASSES = ('reaching the grammar', 'stated at a represented model', 'stated on its own carrier only', 'the rest')

FIELD_KEYS = ('standings', 'premises_of_the_ethics')
COMMON = ('declaration', 'standing', 'basis', 'review')
OWN_KEYS = {'derived': ('law', 'bridges', 'support'),
            'under a stated hypothesis': ('form', 'hypotheses', 'recovery', 'certificate', 'bridges'),
            'balance in its statement': ('relational_part',)}
REQUIRED = {'derived': ('law',), 'under a stated hypothesis': ('form', 'hypotheses', 'recovery', 'certificate')}
HYPOTHESIS_KEYS = ('hypothesis', 'countermodel', 'fit')
PREMISE_KEYS = ('role', 'name', 'premise', 'not_entailed', 'absent', 'basis', 'review')
PREMISE_ROLES = ('scope', 'order')
# What each role says on a page: the hypotheses the ranking results take, each where a theorem takes it. The data keys
# 'scope' and 'order' stay, since the generated shared-laws data and its checks carry them; neither names a premise the
# ethics adds (9 November 2026: C is no longer introduced as a second foundation of the ethics).
PREMISE_LABELS = {'scope': 'Whose losses count', 'order': 'How courses are ranked'}
FULL = re.compile(r'(?:Becoming|Generative)\.\S+')  # a full Lean name: a module root of the package, then the rest

# Lean's generated auxiliaries (§3.0; normative), each by the kinds of declaration (the dump's `k`) Lean generates it
# for. A name is generated when its last component is one of these under a declaration of such a kind, or when it is a
# constructor of a generated inductive (`below.cons`) or a part of a generated `brecOn` (or a nested type's `brecOn_N`)
# that is a definition (`go`, `eq`). So an auxiliary's own auxiliaries, such as `match_1.eq_1`, are generated, and a
# declaration written by hand under a name Lean also uses, such as `next.inj` on a definition `next`, `comm.elim` on a
# theorem or `op.eq_1` on an opaque, is not. A definition's names include those Lean realizes on use (its unfolding
# lemma, functional induction and cases, a matcher's congruence equations), and an inductive's those of a nested type.
AUX = ((re.compile(r'(_proof|proof)_\d+(_\d+)*'), ('def', 'opaque', 'thm', 'ind')),
       (re.compile(r'match_\d+(_\d+)*'), ('def', 'opaque', 'thm')),
       (re.compile(r'_unsafe_rec'), ('def', 'opaque')),
       (re.compile(r'eq_\d+|eq_def|eq_unfold|congr_eq_\d+|splitter|_sunfold|_aux_\d+|_default|_arg_pusher|'
                   r'(mutual_)?induct(_unfolding)?|fun_cases(_unfolding)?'), ('def',)),
       (re.compile(r'inj|injEq|sizeOf_spec|elim|_flat_ctor'), ('ctor',)),
       (re.compile(r'noConfusion'), ('ctor', 'ind')),
       (re.compile(r'_sizeOf_\d+(_eq)?|_sizeOf_inst|brecOn(_\d+)?|below(_\d+)?|binductionOn|casesOn|recOn|rec(_\d+)?|'
                   r'noConfusionType|ctorIdx|toCtorIdx|ofNat_ctorIdx|ctorElim|ctorElimType'), ('ind',)))
BRECON = re.compile(r'brecOn(_\d+)?')
FLOW = ('Becoming.Flow.Balances', 'Becoming.Flow.BalancesOn', 'Becoming.Flow.BalancesBetween')  # rule 1's anchors
WRITTEN_OUT = {'Becoming.Dependence.level', 'Becoming.Flow.taken', 'Becoming.Flow.given'}  # balance written out
REPRESENTED = {'occurrence', 'process'}


# The field's rules (§2).

def full(name):
    return isinstance(name, str) and bool(FULL.fullmatch(name))


def components(name):
    """A Lean name's components: split at the dots outside «»."""
    out, depth, part = [], 0, ''
    for ch in name:
        depth += (ch == '«') - (ch == '»')
        if ch == '.' and depth == 0:
            out.append(part)
            part = ''
        else:
            part += ch
    return out + [part]


def text(value):
    """A text of the field: an object of `en` and `zh` only, strings, at least one nonempty."""
    return (isinstance(value, dict) and bool(value) and set(value) <= {'en', 'zh'}
            and all(isinstance(v, str) for v in value.values()) and any(v.strip() for v in value.values()))


def names_in(review, name):
    """Whether a review's text names `name` in a code span: the full name, or the name less its first component."""
    return any(f'`{n}`' in review for n in (name, name.split('.', 1)[1]))


def given_names(s):
    """(given, introduced) for a standing: every name it gives besides its declaration, and those it introduces, which
    must be the record's own (§2). Only well-formed names are listed."""
    given, introduced = [], []
    label = s.get('standing')
    for key in ('law', 'bridges', 'support', 'hypotheses', 'form', 'recovery', 'certificate', 'relational_part'):
        if key not in OWN_KEYS.get(label, ()):
            continue
        v = s.get(key)
        if key == 'hypotheses':
            v = [h.get(x) for h in v if isinstance(h, dict) for x in HYPOTHESIS_KEYS] if isinstance(v, list) else []
        names = [x for x in (v if isinstance(v, list) else [v]) if full(x)]
        given += names
        if label == 'under a stated hypothesis' or key == 'relational_part':
            introduced += names
    return given, introduced


def field_findings(r, review_text=None):
    """The field's rules on record r, as (where, message): where is None for the field as a whole, ('standing', k) or
    ('premise', k) for an item (k counted from 0). With review_text, a function from a path to its text (None where
    unreadable), the check also reads whether each review names the item's names; the generator leaves that out, since
    the review's text is not among its inputs. Whether a declaration is a central one is the generator's to check."""
    if 'boundary' not in r:
        return []
    out = []
    if r.get('schema_version') != 2:
        out.append((None, 'the boundary field needs schema_version 2'))
    if isinstance(r.get('status'), str) and r['status'] in {'superseded', 'withdrawn'}:
        out.append((None, 'the boundary field is not allowed on a superseded or withdrawn record'))
    b = r['boundary']
    if not isinstance(b, dict):
        return out + [(None, 'boundary must be an object with the keys standings and premises_of_the_ethics')]
    if set(b) != set(FIELD_KEYS):
        out.append((None, 'boundary has exactly the keys standings and premises_of_the_ethics'))
    reviews, own = set(context(r)['reviews']), set(context(r)['laws'])

    def reviewed(where, review, names):
        if not isinstance(review, str) or review not in reviews:
            out.append((where, f'its review {review} is not a reference of role review in the record'))
        elif review_text is not None and (t := review_text(review)) is not None:
            unnamed = [n for n in dict.fromkeys(x for x in names if full(x)) if not names_in(t, n)]
            if unnamed:
                out.append((where, f'its review {review} does not name ' + ', '.join(unnamed)))

    standings = b.get('standings')
    if not isinstance(standings, list) or not standings:
        out.append((None, 'boundary standings must be a nonempty list'))
        standings = []
    where_of = collections.defaultdict(list)
    for k, s in enumerate(standings):
        where = ('standing', k)
        def fail(message, where=where):
            out.append((where, message))
        if not isinstance(s, dict):
            fail('a standing must be an object')
            continue
        label = s.get('standing')
        if label not in STANDINGS:
            fail('its standing must be one of ' + ', '.join(STANDINGS))
            continue
        extra = sorted(map(str, set(s) - set(COMMON + OWN_KEYS.get(label, ()))))
        if extra:
            fail(f'keys outside the standing {label}: ' + ', '.join(extra))
        missing = [x for x in COMMON + REQUIRED.get(label, ()) if x not in s]
        if missing:
            fail('missing keys: ' + ', '.join(missing))
        d = s.get('declaration')
        if not full(d):
            fail('its declaration must be a full Lean name')
        else:
            where_of[d].append(k)
        if not text(s.get('basis')):
            fail('its basis needs English or Chinese, and no other key')
        for key in OWN_KEYS.get(label, ()):
            v = s.get(key)
            if key not in s:
                continue
            if key in ('law', 'bridges', 'support'):
                if not isinstance(v, list) or not v:
                    fail(f'{key} must be a nonempty list')
                elif not all(full(x) for x in v):
                    fail(f'{key} must list full Lean names')
                elif len(set(v)) != len(v):
                    fail(f'{key} lists a name twice')
            elif key == 'hypotheses':
                if not isinstance(v, list) or not v:
                    fail('hypotheses must be a nonempty list')
                elif not all(isinstance(h, dict) and set(h) == set(HYPOTHESIS_KEYS) for h in v):
                    fail('a hypothesis has exactly the keys hypothesis, countermodel and fit')
                elif not all(full(h[x]) for h in v for x in HYPOTHESIS_KEYS):
                    fail('a hypothesis, its countermodel and its fit must be full Lean names')
                else:
                    for x in HYPOTHESIS_KEYS:
                        if len({h[x] for h in v}) != len(v):
                            fail(f'its hypotheses repeat a {x}')
            elif not full(v):
                fail(f'{key} must be a full Lean name')
        if label == 'derived':
            sets = {key: set(s[key]) for key in ('law', 'bridges', 'support') if isinstance(s.get(key), list)
                    and all(isinstance(x, str) for x in s[key])}
            for a, c in (('law', 'bridges'), ('law', 'support'), ('bridges', 'support')):
                both = sorted(sets.get(a, set()) & sets.get(c, set()))
                if both:
                    fail(f'{a} and {c} share ' + ', '.join(both))
        given, introduced = given_names(s)
        if d in given:
            fail('it names its own declaration among its names')
        outside = [x for x in dict.fromkeys(introduced) if x not in own]
        if outside:
            fail("names it introduces are not among the declarations of the record's laws: " + ', '.join(outside))
        reviewed(where, s.get('review'), [d, *given])
    for d, ks in where_of.items():
        if len(ks) > 1:
            out += [(('standing', k), f'{d} has more than one standing') for k in ks]

    premises = b.get('premises_of_the_ethics')
    roles = [p.get('role') for p in premises if isinstance(p, dict)] if isinstance(premises, list) else []
    if not isinstance(premises, list) or len(premises) != 2 or sorted(map(str, roles)) != sorted(PREMISE_ROLES):
        out.append((None, 'premises_of_the_ethics lists exactly two items, one of role scope and one of role order'))
    for k, p in enumerate(premises if isinstance(premises, list) else []):
        where = ('premise', k)
        if not isinstance(p, dict):
            out.append((where, 'a premise must be an object'))
            continue
        extra = sorted(map(str, set(p) - set(PREMISE_KEYS)))
        missing = [x for x in PREMISE_KEYS if x not in p and x != 'absent']
        if extra:
            out.append((where, 'unknown keys: ' + ', '.join(extra)))
        if missing:
            out.append((where, 'missing keys: ' + ', '.join(missing)))
        if p.get('role') not in PREMISE_ROLES:
            out.append((where, 'its role must be scope or order'))
        if not text(p.get('name')):
            out.append((where, 'its name needs English or Chinese, and no other key'))
        if not full(p.get('premise')):
            out.append((where, 'premise must be a full Lean name'))
        ne = p.get('not_entailed')
        if ne is not None and not full(ne):
            out.append((where, 'not_entailed must be a full Lean name or null'))
        if 'not_entailed' in p and ne is None and not text(p.get('absent')):
            out.append((where, 'absent must say why, in English or Chinese, beside a null not_entailed'))
        if ne is not None and 'absent' in p:
            out.append((where, 'absent is allowed only beside a null not_entailed'))
        if not text(p.get('basis')):
            out.append((where, 'its basis needs English or Chinese, and no other key'))
        reviewed(where, p.get('review'), [p.get('premise'), ne])
    return out


def context(r):
    """What the field's rules read of record r besides the field: its schema and status, its review references and its
    laws' declarations. The data keeps it, so that a change to any of them makes the field not matched (§3.6)."""
    refs = r.get('references') if isinstance(r.get('references'), list) else []
    laws = r.get('laws') if isinstance(r.get('laws'), list) else []
    return {'schema_version': r.get('schema_version'), 'status': r.get('status'),
            'reviews': sorted({x['path'] for x in refs if isinstance(x, dict) and x.get('role') == 'review' and isinstance(x.get('path'), str)}),
            'laws': sorted({d for law in laws if isinstance(law, dict) and isinstance(law.get('declarations'), list)
                            for d in law['declarations'] if isinstance(d, str)})}


def field_errors(r, review_text=None):
    """The check's messages for record r."""
    def item(where):
        b = r['boundary']
        x = b.get('standings' if where[0] == 'standing' else 'premises_of_the_ethics')[where[1]]
        name = (x.get('declaration') if where[0] == 'standing' else x.get('role')) if isinstance(x, dict) else None
        return f'boundary {where[0]} {where[1] + 1}' + (f' ({name})' if isinstance(name, str) else '')
    return [(item(w) if w else 'boundary') + ': ' + m for w, m in field_findings(r, review_text)]


def carriers(records):
    """The records carrying the field."""
    return [r for r in records if isinstance(r, dict) and 'boundary' in r]


# The terms (§3.0), on the constants of one run (THEOREM-CONNECTIVITY-DUMP.lean's dump: for each constant its module m,
# kind k, the constants its type t and value v name, the forwarded theorem f with its kind fk, and cv for a closed
# value). Init is not in the dump: the kinds of its declarations, where an auxiliary of one is realized in a package
# module, come from the Lean check (outside, supplied).

def hygienic(n):
    """A name without its macro scopes, and the scopes (`aux._proof_1._@.M._hyg.3`: `aux._proof_1` and `M._hyg.3`)."""
    base, _, scopes = n.partition('._@.')
    return base, scopes


def printed(c):
    """Components joined as the dump prints the name: a name with macro scopes (its last component `_hyg`, then
    numbers) unescaped, since Lean escapes none of its components (`halve._@.M._hyg.3`, the name before
    `halve.«_@».M._hyg.3.eq_1`)."""
    i = len(c)
    while i and c[i - 1].isdigit():
        i -= 1
    if i and c[i - 1] == '_hyg':
        c = [x[1:-1] if x[:1] == '«' and x[-1:] == '»' else x for x in c]
    return '.'.join(c)


def user_name(n):
    """A private name's user name (`_private.M.0.X.match_1`: `X.match_1`); any other name itself."""
    c = components(n)
    return '.'.join(c[c.index('0', 1) + 1:]) if c[0] == '_private' and '0' in c[1:] else n


def outside(C):
    """The dump's theorems whose standing as generated auxiliaries turns on the kind of a name the dump lacks, read as a
    private name's user name too: an auxiliary of a declaration of Init that Lean realizes in the package module that
    needs it (`Nat.fold.eq_def`, `_private.M.0.PSigma.casesOn._arg_pusher`). The name before it is read as the dump
    prints it (printed). A hygienic name with its macro scopes last is left out: the Lean check cannot read one listed,
    since `String.toName` does not read macro scopes (one with them before its last component it reads)."""
    def known(p):
        return p in C or user_name(p) in C
    out = set()
    for n, x in C.items():
        c = components(n)
        if x['k'] != 'thm' or len(c) < 2 or '._@.' in n:
            continue
        if (any(p.fullmatch(c[-1]) for p, _ in AUX) and not known(printed(c[:-1])) or
                c[-1] in ('go', 'eq') and len(c) > 2 and BRECON.fullmatch(c[-2]) and not known(printed(c[:-2]))):
            out.add(n)
    return out


class Terms:
    def __init__(self, C, balance_anchors):
        self.C = C
        self._aux, self.outside = {}, {}
        self.D = {n: [b for b in list(x['t']) + list(x['v']) if b in C] for n, x in C.items()}
        self.anchors = {a for a in balance_anchors if a in C and '«' not in a}
        located = {n for n, x in C.items() if x['m'] == 'Becoming.Prelude' or x['m'].startswith('Becoming.Grammar')}
        users = collections.defaultdict(set)
        for n, bs in self.D.items():
            for b in bs:
                users[b].add(n)
        off = set(C) - located
        stack = list(off)
        while stack:
            for u in users[stack.pop()]:
                if u not in off:
                    off.add(u)
                    stack.append(u)
        self.root = set(C) - off  # in the prelude or a grammar module, with everything it reaches
        self.laws = {n for n in C if self._grammar_law(n)}
        self._fw, self.kind = {}, {}
        for n, x in C.items():
            if x['k'] == 'thm':
                self._forwarder(n)
        self.forwarders = {n: g for n, g in self._fw.items() if g and n not in self.laws}

    def supplied(self, kinds):
        """These terms with the Lean check's kinds of names the dump lacks (its `kinds`), for D1 to D5: the
        measure's facts (grammar laws, forwarders, reaching) stay the dump's."""
        t = copy.copy(self)
        t._aux, t.outside = {}, {n: k for n, k in kinds.items() if isinstance(k, str) and k}
        return t

    def kind_of(self, n):
        """A constant's kind: the dump's; for a private name the dump lacks, its user name's (Lean makes an equation
        lemma or a matcher of another module's declaration private to the module that needs it); for a name the dump
        lacks, the kind supplied from the Lean check, if any."""
        for m in (n, user_name(n)):
            if m in self.C:
                return self.C[m]['k']
        return self.outside.get(n) or self.outside.get(user_name(n))

    def aux(self, n):
        """A generated auxiliary (AUX): its last component attaches to the kind of the declaration before it, or it
        is a constructor of a generated inductive or a part of a generated `brecOn` that is a definition. A hygienic
        name is read without its macro scopes, and the name before it with them; a name whose macro scopes come before
        its last component (`halve.«_@».M._hyg.3.eq_1`) is read under the name before it as the dump prints it."""
        if n not in self._aux:
            base, scopes = hygienic(n)
            c = components(base)
            prefix = printed(c[:-1]) + (f'._@.{scopes}' if scopes else '')
            self._aux[n] = len(c) > 1 and (
                any(p.fullmatch(c[-1]) and self.kind_of(prefix) in kinds for p, kinds in AUX) or
                self.aux(prefix) and (self.kind_of(n) == 'ctor' and self.kind_of(prefix) == 'ind' or
                                      bool(BRECON.fullmatch(c[-2])) and self.kind_of(prefix) == 'def' and c[-1] in ('go', 'eq')))
        return self._aux[n]

    def closure(self, names):
        """Everything the constants reach through types and values, all the way down."""
        seen, stack = set(), [b for b in names if b in self.C]
        while stack:
            b = stack.pop()
            if b not in seen:
                seen.add(b)
                stack += self.D[b]
        return seen

    def _grammar_law(self, n):
        """OU's location rule with the content tests: a theorem of a grammar module, not an auxiliary, on the root,
        whose statement reaches «际» or another «» term and no closed value of the run."""
        x = self.C[n]
        if x['k'] != 'thm' or not x['m'].startswith('Becoming.Grammar') or self.aux(n) or n not in self.root:
            return False
        reached = self.closure(x['t'])
        return any('«' in b for b in reached) and not any(self.C[b].get('cv') for b in reached)

    def walk(self, n):
        """The run's theorems a proof names: its value walked through definitions and generated auxiliaries, stopping
        at theorems, which are collected."""
        out, seen, stack = set(), {n}, list(self.C[n]['v'])
        while stack:
            b = stack.pop()
            if b not in self.C or b in seen:
                continue
            seen.add(b)
            if self.C[b]['k'] == 'thm' and not self.aux(b):
                out.add(b)
            else:
                stack += self.D[b]
        return out

    def _forwarder(self, n):
        """The grammar law n forwards to: its dump's f names a grammar law or another forwarder, and its proof names
        no other theorem of the run."""
        if n in self._fw:
            return self._fw[n]
        self._fw[n] = None
        g = self.C[n].get('f')
        if g and g in self.C and self.walk(n) <= {g}:
            self._fw[n] = g if g in self.laws else self._forwarder(g)
            self.kind[n] = self.C[n].get('fk')
        return self._fw[n]

    def law_of(self, n):
        return n if n in self.laws else self.forwarders.get(n)

    def reach(self, n):
        """The grammar laws n reaches by the measure's walk: through every constant its type and proof use, stopping
        only at «» names, with those forwarded to."""
        out, seen, stack = set(), {n}, list(self.D.get(n, ()))
        while stack:
            b = stack.pop()
            if b in seen:
                continue
            seen.add(b)
            if self.law_of(b):
                out.add(self.law_of(b))
            if '«' not in b:
                stack += self.D[b]
        return out

    def balance(self, n):
        """Where balance enters n: Flow's anchors in its statement's closure, balance written out in its own type,
        and the balance anchors reached only through its proof."""
        stated, whole = self.closure(self.C[n]['t']), self.closure([n])
        return {'anchor_in_statement': [a for a in FLOW if a in stated],
                'written_out': WRITTEN_OUT <= set(self.C[n]['t']),
                'proof_only': sorted(a for a in self.anchors if a in whole and a not in stated)}


def rule(dependence, balance, items):
    """U4's rule (§3.5), from the statement and the facts recorded apart: the measure's dependence and F5's verified
    items for the row."""
    if balance['anchor_in_statement'] or balance['written_out']:
        return 'balance in its statement'
    if dependence == 'grammar':
        return 'connected'
    models = {m for x in items for m in x['models']}
    if models & REPRESENTED:
        return 'at a represented model'
    return 'own carrier' if items else 'unplaced'


def has_fact(label, reached, balance, items):
    """Whether a reading of a label the rule computes has the rule's fact (§3.4)."""
    models = {m for x in items for m in x['models']}
    return {'connected': bool(reached), 'balance in its statement': bool(balance['anchor_in_statement'] or balance['written_out']),
            'at a represented model': bool(models & REPRESENTED), 'own carrier': bool(items) and not models & REPRESENTED}[label]


D2_UNDECLARED = 'D2: the proofs name theorems that are neither grammar laws, root theorems nor declared lemmas: '


def derived(T, row, e, central):
    """D1 to D5 of a derived entry on the dump. Returns (failures, report): the other grammar laws used, the root
    theorems named, and whether the row is a forwarder of one of its laws."""
    laws, lemmas = list(e['law']), set(e.get('bridges', [])) | set(e.get('support', []))
    failed = [f'D1: {y} is not a grammar law' for y in laws if y not in T.laws]
    failed += [f'D2: the lemma {x} is a central declaration' for x in sorted(lemmas & set(central))]
    used, helpers, reached, undeclared = set(), set(), set(), set()
    seen, stack = {row}, [row]
    while stack:
        for b in T.walk(stack.pop()):
            if b in seen:
                continue
            seen.add(b)
            if T.law_of(b):
                used.add(T.law_of(b))
            elif b in lemmas:
                reached.add(b)
                stack.append(b)
            elif b in T.root:
                helpers.add(b)
                stack.append(b)
            else:
                undeclared.add(b)
    if undeclared:
        failed.append(D2_UNDECLARED + ', '.join(sorted(undeclared)))
    failed += [f'D3: the walk does not reach {y}' for y in laws if y in T.laws and y not in used]
    failed += [f'D4: the lemma {x} is not reached' + (' as a lemma: it is a grammar law or a forwarder of one' if T.law_of(x) else '')
               for x in sorted(lemmas - reached)]
    balance = sorted(T.closure([row]) & T.anchors)
    if balance:
        failed.append('D5: balance enters its closure: ' + ', '.join(balance))
    g = T.forwarders.get(row)
    return failed, {'laws_used_also': sorted(used - set(laws)), 'root_theorems_named': sorted(helpers),
                    'forwarder': {'law': g, 'kind': T.kind.get(row)} if g in laws else None}


def q1(C, p):
    """Q1 (§3.3): the premise is a definition, and its not-entailed theorem a theorem whose type names it. Returns
    (result, failures): not entailed, not shown (a null not_entailed) or unverified."""
    premise, ne = p['premise'], p['not_entailed']
    failed = [] if premise in C and C[premise]['k'] == 'def' else [f'{premise} is not a definition of the run']
    if ne is not None:
        if ne not in C or C[ne]['k'] != 'thm':
            failed.append(f'{ne} is not a theorem of the run')
        elif premise not in C[ne]['t']:
            failed.append(f'the type of {ne} does not name {premise}')
    return ('unverified' if failed else 'not shown' if ne is None else 'not entailed'), failed


# The Lean check (§3.6).

def checker():
    """check_becoming, as THEOREM-CONNECTIVITY.py loads it."""
    spec = importlib.util.spec_from_file_location('theorem_connectivity_for_boundary', TC)
    tc = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(tc)
    return tc.cb


def run_check(work, imports, query, lean, timeout):
    """Run boundary_check.lean in work, whose compiled modules LEAN_PATH reaches, after the given imports. Returns its
    output; raises RuntimeError with Lean's output where Lean fails."""
    source = CHECK.read_text()
    if not source.startswith('import Lean\n'):
        raise RuntimeError(f'{CHECK.name} does not begin with import Lean, after which the imports are written')
    (work / 'BoundaryCheck.lean').write_text(source.replace('import Lean\n', 'import Lean\n' + ''.join(f'import {m}\n' for m in imports), 1))
    (work / 'boundary-in.json').write_text(json.dumps(query, ensure_ascii=False))
    out = work / 'boundary-out.json'
    env = {**os.environ, 'LEAN_PATH': str(work), 'BOUNDARY_CHECK_IN': str(work / 'boundary-in.json'), 'BOUNDARY_CHECK_OUT': str(out)}
    p = subprocess.run(lean + ['BoundaryCheck.lean'], cwd=work, env=env, text=True, stdout=subprocess.PIPE,
                       stderr=subprocess.STDOUT, timeout=timeout)
    if p.returncode != 0 or re.search(r'\berror:', p.stdout) or not out.is_file():
        raise RuntimeError(p.stdout[-2000:])
    return json.loads(out.read_text())


def local(message, work=None):
    """A failure's message as the data records it: one line, at most 500 characters, without the scratch folder or the
    home folder, so that a rerun in the same state writes the same data."""
    if work is not None:
        message = message.replace(str(work), '<scratch>')
    return ' '.join(message.replace(str(Path.home()), '~').split())[:500]


def lean_check(query, modules):
    """Restore the core run's modules from the checker's cache, with the same keys as THEOREM-CONNECTIVITY.py's dump and
    no recompile, and run the check after `import Becoming`, the periphery joins and the given modules. Returns
    (output or None, what the report records of the run). Where the checker cannot be set up, nothing is run and the
    reason is recorded: the generator never stops here."""
    try:
        cb = checker()
        index = cb.module_index()
        order = cb.closure(index)
        sources = {name: index[name][0].read_bytes() for name in order}
        binary = getattr(cb, 'DEFAULT_LEAN', Path.home() / '.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean')
        keys = cb.module_keys([cb.audit_support.TOOLCHAIN, cb.audit_support.digest(Path(binary).read_bytes())], sources, order)
        info = {'toolchain': cb.audit_support.TOOLCHAIN,
                'modules_sha256': hashlib.sha256(json.dumps(keys, sort_keys=True).encode()).hexdigest(),
                'check_sha256': hashlib.sha256(CHECK.read_bytes()).hexdigest()}
    except Exception as e:  # a missing binary, source or checker: the entries it would check are unverified with this
        return None, {'ran': False, 'reason': 'the checker could not be set up: ' + local(f'{type(e).__name__}: {e}')}
    with tempfile.TemporaryDirectory(prefix='boundary-check-') as scratch:
        work = Path(scratch)
        missing = []
        for name in order:
            target = work / cb.source_file(name)
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(sources[name])
            if not cb.reuse(keys[name], [work / (cb.source_file(name)[:-5] + '.olean')]):
                missing.append(name)
        if missing:
            return None, {**info, 'ran': False, 'reason': 'not in the cache for the current sources: ' + ', '.join(missing[:5])}
        imports = list(dict.fromkeys(['Becoming', *getattr(cb, 'PERIPHERY_JOINS', []), *(m for m in modules if m in order)]))
        try:
            out = run_check(work, imports, query, [str(Path.home() / '.elan/bin/lean'), '+' + cb.audit_support.TOOLCHAIN], cb.TIMEOUT)
        except subprocess.TimeoutExpired:
            return None, {**info, 'ran': False, 'reason': f'Lean timed out after {cb.TIMEOUT} s'}
        except (RuntimeError, OSError, subprocess.SubprocessError, ValueError) as e:
            return None, {**info, 'ran': False, 'reason': 'Lean failed: ' + local(str(e), work)}
    return out, {**info, 'ran': True}


# The report (§4).

def report(C, central, at_model, f5_class, carrier, balance_anchors, lean=lean_check):
    """The boundary report for the one record carrying the field. central: MV's central declarations, each with the
    measure's dependence; at_model: F5's verified items by row; f5_class: each central declaration's class in
    central_reach; lean: the runner of the Lean check, (query, modules) -> (output or None, info)."""
    T = Terms(C, balance_anchors)
    b = carrier['boundary'] if isinstance(carrier['boundary'], dict) else {}
    findings = field_findings(carrier)
    whole = ["its record breaks the check's rules: " + m for w, m in findings if w is None]
    per = collections.defaultdict(list)
    for w, m in findings:
        if w:
            per[w].append("its record breaks the check's rules: " + m)
    checks = []  # (item, standing, failures, report) in the record's order; an item that is no object is checked as {}
    for k, s in enumerate(b.get('standings', []) if isinstance(b.get('standings'), list) else []):
        failed = whole + per[('standing', k)]
        s = s if isinstance(s, dict) else {}
        d = s.get('declaration')
        if not failed:
            given, _ = given_names(s)
            if d not in central:
                failed.append('not a central declaration of COVERAGE.json')
            out = [x for x in [d, *given] if x not in C]
            if out:
                failed.append('not in the spine run: ' + ', '.join(dict.fromkeys(out)))
        rep = {}
        if not failed and s['standing'] in COMPUTED and not has_fact(s['standing'], T.reach(d), T.balance(d), at_model.get(d, [])):
            failed.append(f'the reading needs the rule\'s fact for {s["standing"]}, which does not hold')
        checks.append((k + 1, s, failed, rep))
    # The Lean check, before D1 to D5: the forms under a stated hypothesis, the derived rows' laws (the name test), their
    # bridges (D6), and the kinds of the names the dump lacks before the theorems of outside(C) (§3.0).
    lean_entries = [s for _, s, failed, _ in checks if not failed and s['standing'] == 'under a stated hypothesis']
    derived_ok = [s for _, s, failed, _ in checks if not failed and s['standing'] == 'derived']
    query = {'entries': [{'row': s['declaration'], **{k: s[k] for k in ('form', 'hypotheses', 'recovery', 'certificate')},
                          'bridges': s.get('bridges', [])} for s in lean_entries],
             'names': sorted({y for s in derived_ok for y in s['law']}),
             'equivalences': sorted({x for s in derived_ok for x in s.get('bridges', [])}),
             'generated': sorted(outside(C)) if derived_ok else []}
    output, info = (None, {'ran': False, 'reason': 'nothing to check'})
    if lean_entries or derived_ok:
        sent = [d for s in lean_entries + derived_ok for d in [s['declaration'], *given_names(s)[0]]]
        output, info = lean(query, sorted({C[x]['m'] for x in sent}))
    if output is not None and not (isinstance(output, dict) and isinstance(output.get('entries', []), list)
                                   and all(isinstance(x, dict) and isinstance(x.get('row'), str) for x in output.get('entries', []))
                                   and all(isinstance(output.get(k, {}), dict) for k in ('admitted', 'equivalence', 'kinds'))):
        output, info = None, {**info, 'ran': False, 'reason': 'the Lean check gave malformed output'}
    S = T.supplied(output.get('kinds', {}) if output is not None else {})
    lacking = set(query['generated'])
    for _, s, failed, rep in checks:
        if not failed and s['standing'] == 'derived':
            more, found = derived(S, s['declaration'], s, central)
            failed += more
            rep.update(found)
            # D2 refuses a theorem of outside(C) when the check, which gives the kind before it, did not run: say so
            if output is None and any(f.startswith(D2_UNDECLARED) and lacking & set(f[len(D2_UNDECLARED):].split(', '))
                                      for f in more):
                failed.append('the Lean check did not run, so the kinds of names the dump lacks are not known: '
                              + info.get('reason', ''))
    results = {}
    if output is not None:
        for x in output.get('entries', []):
            results.setdefault(x.get('row'), x)
    for _, s, failed, rep in checks:
        if failed or s['standing'] not in EDGE:
            continue
        if output is None:
            failed.append('the Lean check did not run: ' + info.get('reason', ''))
        elif s['standing'] == 'derived':
            failed += [f'D1: the Lean check does not admit {y}' for y in s['law'] if output.get('admitted', {}).get(y) is not True]
            failed += [f'D6: the bridge {x} is not an equivalence' for x in s.get('bridges', []) if output.get('equivalence', {}).get(x) is not True]
        else:
            x = results.get(s['declaration'])
            if x is None:
                failed.append('the Lean check gave no result')
            else:
                failures = [str(f) for f in x['failures']] if isinstance(x.get('failures'), list) else []
                failed += failures or ([] if x.get('passed') is True else ['the Lean check did not pass it'])
                rep.update({k: x[k] for k in ('statement_names', 'hypothesis_names', 'facts', 'recovery_uses') if k in x})
    entries = {}
    unverified = []
    for item, s, failed, rep in checks:
        d = s.get('declaration')
        entry = {**s, 'verified': not failed, **({'failed': failed} if failed else {}), **({'report': rep} if rep else {})}
        if failed:
            unverified.append({'item': item, 'declaration': d, 'standing': s.get('standing'), 'failed': failed})
        if isinstance(d, str) and d in central and d not in entries:
            entries[d] = entry
    rows, counts = {}, dict.fromkeys(LABELS, 0)
    against = {label: dict.fromkeys(F5_CLASSES, 0) for label in LABELS}
    by_forwarder = []
    for n in sorted(central):
        items = at_model.get(n, [])
        balance = T.balance(n) if n in C else {'anchor_in_statement': [], 'written_out': False, 'proof_only': []}
        reached = sorted(T.reach(n)) if n in C else []
        by_rule = rule(central[n]['dependence'], balance, items)
        e = entries.get(n)
        placed = ('checked entry' if e['standing'] in EDGE else 'reading') if e and e['verified'] else 'the rule'
        label = e['standing'] if placed != 'the rule' else by_rule
        row = {'label': label, 'placed': placed, 'rule': by_rule, 'f5': f5_class[n],
               'at_model': [{k: x[k] for k in ('record', 'law', 'declaration', 'models')} for x in items],
               'grammar_laws_reached': reached, 'balance': balance}
        if e:
            row['entry'] = e
            if e['verified'] and e.get('report', {}).get('forwarder'):
                by_forwarder.append({'declaration': n, **e['report']['forwarder']})
        rows[n] = row
        counts[label] += 1
        against[label][f5_class[n]] += 1
    premises = []
    for k, p in enumerate(b.get('premises_of_the_ethics', []) if isinstance(b.get('premises_of_the_ethics'), list) else []):
        failed = whole + per[('premise', k)]
        p = p if isinstance(p, dict) else {}
        result = 'unverified'
        if not failed:
            result, failed = q1(C, p)
        premises.append({'item': k + 1, **{x: p.get(x) for x in ('role', 'name', 'premise', 'not_entailed') if x in p},
                         **({'absent': p['absent']} if 'absent' in p else {}), 'result': result, **({'failed': failed} if failed else {})})
    return {'record': carrier['id'], 'declared': carrier['boundary'], 'context': context(carrier),
            'counts': counts, 'groups': {g: sum(counts[x] for x in labels) for g, labels in GROUPS.items()},
            'derived_by_forwarder': by_forwarder,
            'against_f5': against,
            'premises_of_the_ethics': premises, 'lean_check': info,
            **({'field_failures': whole} if whole else {}), 'unverified': unverified, 'rows': rows}
