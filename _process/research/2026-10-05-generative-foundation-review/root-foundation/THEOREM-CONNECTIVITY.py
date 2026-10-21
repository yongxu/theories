#!/usr/bin/env python3
"""How the spine's theorems connect to its base definitions: python3 -B THEOREM-CONNECTIVITY.py [--write] [--check]

Three steps, none of which writes to the repository unless `--write` is given:

1. Restore. The compiled modules of the spine run (foundation, core, bridge, inherited) are restored from the
   checker's shared cache into a temporary folder, under the keys `check_becoming.py` itself computes for the current
   sources. Nothing is compiled; a module missing from the cache stops the run (run the checker first).
2. Dump. `THEOREM-CONNECTIVITY-DUMP.lean` writes, for every constant of those modules, the tracked constants its
   type and its value use.
3. Analysis. The base is two families of definitions: Process/Trace (GenerativeCore) with Frame/Run, and World with
   the Flow and Web it is built from. Since R28 (20 October 2026) a World is a run by its type (its history is a Run),
   so the World family reaches the Process family by definition and a statement on World counts as on both; Flow and
   Web (Dependence Nat) are records over the step index and reach neither, and a process need not be a world, so the
   families are still named separately. Each spine theorem is placed in the first class that fits:
   * its statement reaches the base only through the determined-law vocabulary (`Law.*`, `Assurance.ofMap`,
     `Assurance.ofPartial`) and the fields of the run or process it makes (`Run.state`, `Run.act`, `Process.step`),
     applied to a law defined in the theorem's own module: the module's own carrier read through `Law.run` (R32, the
     twentieth review's G3; reported apart from the statement classes);
   * its statement uses a constant that reaches both families, only the first, or only the second;
   * its proof goes through a family although its statement does not;
   * it is used, directly or through other constants, by some constant that reaches the base, where a pure forwarder
     on the base (a theorem whose whole proof applies another theorem to its own binders, dump field `f`) does not
     count as using its target;
   * its instance on the base is recorded: a pure forwarder on the base applies it, the register's `instances` list
     names it, or a Lean `example` on the base applies it (an example makes no constant; R32, the twentieth
     review's B8), or it is used by such a law; a named one-line restatement then adds nothing to its class;
   * otherwise it stands apart: its statement uses its own definitions, or no tracked constant at all.
   Also reported: whether the two families reach each other, where statements use both, the connected components
   of the undirected dependency graph, and, for each result record naming spine theorems (in its aliases, or in the
   declarations and witnesses of its laws, limits and counterexamples), the best class among them; and the apart
   theorems split into general structure by design (every apart root above it registered `general-structure`) and
   the rest.

The periphery within the run (the foundation and the inherited modules the bridge imports) is measured the same
way and reported under `periphery`; its apart roots are held to the same register (U2, 17 October 2026).

Also reported: the roots among the apart theorems (used by no other apart theorem) and, from
THEOREM-CONNECTIVITY-APART.json, each root's category and reason (support, logical strength, model witness, restates,
general structure, bridge interface); `--check` exits with an error where an apart root has no entry or an entry is no
longer an apart root, so a new theorem cannot stand apart unremarked, or where an entry of the register's `instances`
names a law or a base constant the run does not have.

Prints a summary as JSON; `--write` also saves it, with every spine theorem's class, to THEOREM-CONNECTIVITY.json.
A measurement, not a check: it reads dependencies in the compiled environment and judges no statement's meaning.
A theorem standing apart has no Lean dependency on the base; a law stated for every type still covers runs and
worlds once instantiated, and what is missing is the theorem that instantiates it."""
import collections
import glob
import json
import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]
SPINE_DIR = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
DUMP = HERE / 'THEOREM-CONNECTIVITY-DUMP.lean'
RECORDS = ROOT / 'theories/becoming/results/records'
APART_REGISTER = HERE / 'THEOREM-CONNECTIVITY-APART.json'
sys.path.insert(0, str(SPINE_DIR))
import check_becoming as cb  # noqa: E402

PROCESS = ['Generative.Process', 'Generative.Trace', 'Becoming.Frame', 'Becoming.Run']
WORLD = ['Becoming.World', 'Becoming.Flow', 'Becoming.Web']
CLASSES = [
    'statement on both families',
    'statement on Process/Frame/Run/Trace',
    'statement on World/Flow/Web',
    'statement on the base only through a law of its own module',
    'proof through a base family',
    'used by a theorem on the base',
    'instance on the base recorded',
    'apart: own vocabulary',
    'apart: prelude-only statement',
]
APART = set(CLASSES[7:])
# The determined-law vocabulary, which makes a process or a run of any law `next : S → S` (R28), and the fields of
# what it makes: a statement reaching the base only through these reads the law's own carrier (G3).
LAW_WRAPPERS = ('Becoming.Assurance.ofMap', 'Becoming.Assurance.ofPartial')
SHELL = {'Becoming.Run.state', 'Becoming.Run.act', 'Generative.Process.step'}


def law_wrapper(name, constants):
    return (name.startswith('Becoming.Law.') and constants[name]['k'] in ('def', 'opaque')) or name in LAW_WRAPPERS


EXAMPLE = re.compile(r'^example\b(.*?)(?=^\S)', re.M | re.S)
IDENT = re.compile(r"[A-Za-z_][\w'.!?]*")


def examples(index, constants):
    """The `example`s of the run's modules (an example makes no constant): for each, the tracked constants its
    statement and its proof name, resolved through the namespaces and `open`s in scope at it."""
    found = []
    for name in sorted(index):
        text = re.sub(r'/-.*?-/', ' ', index[name][0].read_text(), flags=re.S)
        text = re.sub(r'--[^\n]*', ' ', text)
        for m in EXAMPLE.finditer(text + '\nend\n'):
            before = text[:m.start()]
            stack = []
            for kw, ns in re.findall(r'^(namespace|end|section)\b[ \t]*(\S*)', before, re.M):
                if kw == 'end':
                    if stack:
                        stack.pop()
                else:
                    stack.append(ns if kw == 'namespace' else '')
            spaces = ['.'.join(x for x in stack[:i] if x) for i in range(len(stack) + 1)]
            opened = [o for line in re.findall(r'^open\s+([^\n]+)', before, re.M) for o in line.split()
                      if not o.startswith('(')]
            prefixes = {p for p in spaces} | {(p + '.' if p else '') + o for p in spaces for o in opened}

            def resolve(tok):
                for prefix in sorted(prefixes, key=len, reverse=True):
                    full = (prefix + '.' if prefix else '') + tok
                    if full in constants:
                        return full
                return tok if tok in constants else None

            body = m.group(1)
            depth, cut = 0, None
            for i, ch in enumerate(body):
                depth += ch in '([{⟨'
                depth -= ch in ')]}⟩'
                if depth == 0 and body.startswith(':=', i):
                    cut = i
                    break
            if cut is None:
                continue
            statement = {resolve(t) for t in IDENT.findall(body[:cut])} - {None}
            proof = {resolve(t) for t in IDENT.findall(body[cut + 2:])} - {None}
            found.append({'module': name, 'statement': sorted(statement), 'proof': sorted(proof)})
    return found


def imports_of(path):
    return re.findall(r'^import\s+(\S+)', path.read_text(), re.M)


def dump_constants():
    """Restore the run's compiled modules from the cache and return the dump's constants and the source registry."""
    index = cb.module_index()
    order = cb.closure(index)
    dumped = set(imports_of(DUMP)) - {'Lean'}
    covered = dumped | set(imports_of(SPINE_DIR / 'Becoming.lean'))
    assert set(cb.SPINE) <= covered, ('the dump does not import every spine module', set(cb.SPINE) - covered)
    sources = {name: index[name][0].read_bytes() for name in order}
    binary = Path.home() / '.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean'
    context = [cb.audit_support.TOOLCHAIN, cb.audit_support.digest(binary.read_bytes())]
    keys = cb.module_keys(context, sources, order)
    with tempfile.TemporaryDirectory(prefix='theorem-connectivity-') as scratch:
        work = Path(scratch)
        missing = []
        for name in order:
            target = work / cb.source_file(name)
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(sources[name])
            if not cb.reuse(keys[name], [work / (cb.source_file(name)[:-5] + '.olean')]):
                missing.append(name)
        if missing:
            sys.exit(f'not in the cache for the current sources (run check_becoming.py first): {missing}')
        # The periphery joins (U2) are imported by nothing in the spine; the dump imports them too.
        dump = DUMP.read_text()
        joins = ''.join(f'import {n}\n' for n in getattr(cb, 'PERIPHERY_JOINS', []) if f'import {n}\n' not in dump)
        (work / DUMP.name).write_text(dump.replace('import Lean\n', 'import Lean\n' + joins, 1))
        out = work / 'dump.jsonl'
        env = {**os.environ, 'LEAN_PATH': str(work), 'THEOREM_CONNECTIVITY_OUT': str(out)}
        lean = [str(Path.home() / '.elan/bin/lean'), '+' + cb.audit_support.TOOLCHAIN]
        p = subprocess.run(lean + [DUMP.name], cwd=work, env=env, text=True,
                           stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=cb.TIMEOUT)
        assert p.returncode == 0 and not re.search(r'\berror:', p.stdout), p.stdout
        version = subprocess.run(lean + ['--version'], text=True, stdout=subprocess.PIPE).stdout.strip()
        constants = {}
        for line in out.read_text().splitlines():
            x = json.loads(line)
            constants[x['n']] = x
    # The spine's modules and the inherited (periphery) modules of the same run, which the bridge imports.
    registry = {name: cb.declarations(sources[name]) for name in order if name in sources}
    paths = [str(index[name][0].resolve().relative_to(ROOT)) for name in order]
    clean = subprocess.run(['git', 'diff', '--quiet', 'HEAD', '--', *paths]).returncode == 0
    return constants, registry, len(order), version, clean, {n: index[n] for n in order}


def reaching(constants, deps, base):
    """Constants whose type or value reaches one of `base`, directly or through other constants."""
    found = {n: n in base for n in constants}
    changed = True
    while changed:
        changed = False
        for n in constants:
            if not found[n] and any(found[d] for d in deps[n]):
                found[n] = changed = True
    return found


def main():
    os.chdir(ROOT)
    constants, registry, modules, version, clean, index = dump_constants()
    for name in PROCESS + WORLD:
        assert name in constants, ('base definition not found', name)
    deps = {n: set(x['t']) | set(x['v']) for n, x in constants.items()}
    on_process, on_world = reaching(constants, deps, set(PROCESS)), reaching(constants, deps, set(WORLD))
    on_base = {n: on_process[n] or on_world[n] for n in constants}
    # A pure forwarder on the base (dump field `f`) records its target's instance; it does not use the target.
    forwards = {n: x['f'] for n, x in constants.items() if 'f' in x and x['f'] in constants}
    reached, stack = set(), [(n, False) for n in constants if on_base[n]]
    seeded = set()
    while stack:
        n, by_edge = stack.pop()
        if (n in reached) or (not by_edge and n in seeded):
            continue
        if by_edge:
            reached.add(n)
        else:
            seeded.add(n)
        skip = forwards.get(n) if not by_edge else None
        for d in deps[n]:
            if d != skip:
                stack.append((d, True))
    feeds = reached
    # Recorded instances: the targets of forwarders on the base, the register's `instances`, and the laws an
    # example on the base applies; with what they use.
    register_file = json.loads(APART_REGISTER.read_text()) if APART_REGISTER.exists() else {}
    instances = register_file.get('instances', {})
    bad_instances = sorted(n for n, entry in instances.items()
                           if n not in constants or not entry.get('base')
                           or not all(b in constants and on_base[b] for b in entry['base']))
    found_examples = examples(index, constants)
    example_laws = set()
    for e in found_examples:
        if any(on_base[n] for n in e['statement']):
            example_laws |= {n for n in e['proof'] if constants[n]['k'] == 'thm'}
    seeds = ({forwards[n] for n in forwards if on_base[n]} | set(instances) | example_laws) & set(constants)
    recorded, stack = set(), list(seeds)
    while stack:
        n = stack.pop()
        if n in recorded or n in feeds:
            continue
        recorded.add(n)
        stack.extend(deps[n])
    # Reach of the base other than through the determined-law vocabulary and the fields of what it makes (G3).
    blocked = {n for n in constants if law_wrapper(n, constants)} | (SHELL & set(constants))
    deps_cut = {n: (set() if n in blocked else deps[n]) for n in constants}
    base_cut = {n: (n in PROCESS or n in WORLD) for n in constants}
    changed = True
    while changed:
        changed = False
        for n in constants:
            if not base_cut[n] and n not in blocked and any(base_cut[d] for d in deps_cut[n]):
                base_cut[n] = changed = True
    own_law = {}

    def law_of_module(n):
        """A definition whose value gives a law of its own module to the determined-law vocabulary, or uses
        such a definition of its module."""
        if n not in own_law:
            own_law[n] = False
            x = constants[n]
            own_law[n] = (any(constants.get(h, {}).get('m') == x['m'] for h in x.get('w', [])) or
                          any(constants[d]['m'] == x['m'] and constants[d]['k'] == 'def' and law_of_module(d)
                              for d in x['v'] if d != n))
        return own_law[n]

    def through_own_law(n):
        x = constants[n]
        if not any(on_base[d] for d in x['t']) or any(base_cut[d] for d in x['t']):
            return False
        return (any(constants.get(h, {}).get('m') == x['m'] for h in x.get('w', [])) or
                any(constants[d]['m'] == x['m'] and constants[d]['k'] == 'def' and law_of_module(d) for d in x['t']))
    used = collections.Counter(d for n in constants for d in deps[n])

    def classify(n):
        if through_own_law(n):
            return CLASSES[3]
        process = any(on_process[d] for d in constants[n]['t'])
        world = any(on_world[d] for d in constants[n]['t'])
        if process and world:
            return CLASSES[0]
        if process:
            return CLASSES[1]
        if world:
            return CLASSES[2]
        if on_base[n]:
            return CLASSES[4]
        if n in feeds:
            return CLASSES[5]
        if n in recorded:
            return CLASSES[6]
        return CLASSES[7] if constants[n]['t'] else CLASSES[8]

    theorems = [(item['name'], module) for module in cb.SPINE for item in registry.get(module, [])
                if item['kind'] == 'theorem']
    # The inherited modules of the run (the foundation and the earlier modules the bridge imports): the periphery
    # within the checker's environment, measured the same way and held to the same register.
    periphery = [m for m in registry if m not in cb.SPINE]
    periphery_theorems = [(item['name'], module) for module in periphery for item in registry[module]
                          if item['kind'] == 'theorem']
    absent = [n for n, _ in theorems if n not in constants]
    assert not absent, ('source theorems missing from the dump', absent[:10])
    cls = {n: classify(n) for n, _ in theorems}
    module_of = dict(theorems)
    apart = [n for n, _ in theorems if cls[n] in APART]
    periphery_cls = {n: classify(n) for n, _ in periphery_theorems if n in constants}
    periphery_module_of = dict(periphery_theorems)
    periphery_apart = [n for n, _ in periphery_theorems if periphery_cls.get(n) in APART]
    total = collections.Counter(module_of.values())
    apart_by_module = collections.Counter(module_of[n] for n in apart)
    # Roots: apart theorems used by no other apart theorem (nor by a definition off the base). A theorem on the base
    # using a root makes it, and every apart theorem it uses, feed the base. The register gives each root's reason.
    apart_set = set(apart) | set(periphery_apart)
    users = collections.defaultdict(set)
    for n in constants:
        for d in deps[n]:
            if d in apart_set and d != n:
                users[d].add(n)
    def is_root(n):
        return not any(u in apart_set or (constants[u]['k'] == 'def' and u not in feeds and not on_base[u])
                       for u in users[n])
    roots = sorted(n for n in apart if is_root(n))
    periphery_roots = sorted(n for n in periphery_apart if is_root(n))
    register = register_file.get('roots', {})
    unclassified = [n for n in roots + periphery_roots if n not in register]
    stale = sorted(n for n in register if n not in set(roots) | set(periphery_roots))

    # Apart theorems by design: every apart root above (or at) the theorem registered as general structure.
    above = {}

    def roots_above(n):
        if n not in above:
            above[n] = set()
            ups = {u for u in users[n] if u in apart_set}
            above[n] = {n} if not ups else set().union(*(roots_above(u) for u in ups))
        return above[n]
    by_design = [n for n in apart
                 if all(register.get(r, {}).get('category') == 'general-structure' for r in roots_above(n))]
    forwarders_on_base = sorted(n for n in forwards if on_base[n] and n in cls)

    # Undirected components over every tracked constant.
    neighbours = collections.defaultdict(set)
    for n in constants:
        for d in deps[n]:
            neighbours[n].add(d)
            neighbours[d].add(n)
    component, count = {}, 0
    for n in constants:
        if n in component:
            continue
        component[n], stack = count, [n]
        while stack:
            for y in neighbours[stack.pop()]:
                if y not in component:
                    component[y] = count
                    stack.append(y)
        count += 1
    main_component = component[PROCESS[0]]
    outside = sorted(n for n, _ in theorems if component[n] != main_component)

    records, apart_records = collections.Counter(), []
    for path in sorted(glob.glob(str(RECORDS / '*.json'))):
        record = json.loads(Path(path).read_text())
        named = set(record.get('aliases', []))
        for field in ('laws', 'does_not_show', 'counterexamples'):
            for item in record.get(field) or []:
                if isinstance(item, dict):
                    named.update(item.get('declarations') or [])
                    if isinstance(item.get('witness'), str):
                        named.add(item['witness'])
        every = {**cls, **periphery_cls}
        where = {**module_of, **periphery_module_of}
        aliases = sorted(a for a in named if a in every)
        if aliases:
            best = min((every[a] for a in aliases), key=CLASSES.index)
            records[best] += 1
            if best in APART:
                apart_records.append({'id': record['id'], 'modules': sorted({where[a] for a in aliases})})

    # The master laws (board item EC, not a criterion): for each central declaration of the coverage file, the laws
    # whose anchors its type or value reaches, directly or through other constants.
    coverage_path = ROOT / 'theories/becoming/results/completion/COVERAGE.json'
    coverage = json.loads(coverage_path.read_text()) if coverage_path.exists() else {}
    master_laws = None
    if coverage.get('master_laws'):
        law_anchors = {law['id']: set(law['anchors']) for law in coverage['master_laws']}

        def reasons(n):
            seen, stack = {n}, [n]
            while stack:
                for d in deps.get(stack.pop(), ()):
                    if d in constants and d not in seen:
                        seen.add(d)
                        stack.append(d)
            return seen
        master_rows = []
        for row in coverage.get('rows', []):
            master_rows.append({'row': row['id'], 'declarations': [
                {'declaration': n, 'laws': sorted(k for k, a in law_anchors.items() if reasons(n) & a)
                 if n in constants else None} for n in row['declarations']]})
        entries = [e for r in master_rows for e in r['declarations']]
        master_laws = {'central_declarations': len(entries),
                       'resting_on_no_master_law': sum(1 for e in entries if not e['laws']),
                       'by_law': {k: sum(1 for e in entries if e['laws'] and k in e['laws']) for k in law_anchors},
                       'rows': master_rows}

    head = subprocess.run(['git', 'rev-parse', 'HEAD'], text=True, stdout=subprocess.PIPE).stdout.strip()
    # The receipt the commit holds; a later run in the working tree is not this commit's.
    committed = subprocess.run(['git', 'show', 'HEAD:' + str((SPINE_DIR / 'becoming-verification.json').relative_to(ROOT))],
                               text=True, stdout=subprocess.PIPE).stdout
    summary = {
        'commit': head, 'sources_match_commit': clean,
        'core_receipt_at_commit': json.loads(committed).get('utc') if committed else None, 'lean': version,
        'tracked_modules': modules, 'constants': len(constants), 'spine_theorems': len(theorems),
        'base': {'Process family': PROCESS, 'World family': WORLD},
        'families_reach_each_other': {
            'Flow reaches Process family': on_process['Becoming.Flow'],
            'Web reaches Process family': on_process['Becoming.Web'],
            'World reaches Process family': on_process['Becoming.World'],
            'Process reaches World family': on_world['Generative.Process'],
        },
        'classes': {c: sum(1 for v in cls.values() if v == c) for c in CLASSES},
        'apart': len(apart),
        'apart_general_structure_by_design': len(by_design),
        'apart_otherwise': len(apart) - len(by_design),
        'pure_forwarders': {
            'spine theorems that are pure forwarders': sum(1 for n in cls if n in forwards),
            'of them on the base': len(forwarders_on_base),
            'their targets, by class': dict(collections.Counter(
                cls[forwards[n]] for n in forwarders_on_base if forwards[n] in cls)),
        },
        'recorded_instances': {
            'register entries': len(instances), 'examples': len(found_examples),
            'examples on the base': sum(1 for e in found_examples if any(on_base[n] for n in e['statement'])),
            'register entries naming what the run lacks': bad_instances,
        },
        'statement_through_own_law_by_module': dict(collections.Counter(
            module_of[n] for n in cls if cls[n] == CLASSES[3]).most_common()),
        'apart_used_by_nothing': sum(1 for n in apart if used[n] == 0),
        'apart_roots': len(roots),
        'apart_roots_by_category': dict(collections.Counter(register[n]['category'] for n in roots if n in register)),
        'apart_roots_unclassified': unclassified,
        'register_entries_not_apart_roots': stale,
        'statements_on_both_by_module': dict(collections.Counter(
            module_of[n] for n in cls if cls[n] == CLASSES[0]).most_common()),
        'apart_by_module': {m: [k, total[m]] for m, k in apart_by_module.most_common()},
        # The instance and applications ring (R35b): the same classes, split by the checker's rings.
        'rings': {ring: {'modules': len(ms), 'theorems': sum(total[m] for m in ms),
                         'apart': sum(apart_by_module[m] for m in ms),
                         'classes': {c: sum(1 for n, v in cls.items() if v == c and module_of[n] in ms) for c in CLASSES}}
                  for ring, ms in (('core', [m for m in cb.SPINE if m not in getattr(cb, 'RING', [])]),
                                   ('instances', getattr(cb, 'INSTANCES', [])),
                                   ('applications', getattr(cb, 'APPLICATIONS', [])))},
        'components': {'count': count, 'theorems_outside_the_main_component': outside},
        'periphery': {
            'modules': len(periphery), 'theorems': len(periphery_cls),
            'classes': {c: sum(1 for v in periphery_cls.values() if v == c) for c in CLASSES},
            'apart': len(periphery_apart), 'apart_roots': len(periphery_roots),
            'apart_roots_by_category': dict(collections.Counter(
                register[n]['category'] for n in periphery_roots if n in register)),
            'apart_by_module': {m: [k, sum(1 for _, mm in periphery_theorems if mm == m)] for m, k in
                                collections.Counter(periphery_module_of[n] for n in periphery_apart).most_common()},
            'theorems_outside_the_main_component': sorted(
                n for n in periphery_cls if component.get(n) != main_component),
        },
        'records_by_best_alias_class': {c: records[c] for c in CLASSES if records[c]},
        'records_resting_only_on_apart_theorems': apart_records,
        'master_laws': master_laws,
    }
    print(json.dumps(summary, ensure_ascii=False, indent=1))
    if '--check' in sys.argv[1:] and (unclassified or stale or bad_instances):
        sys.exit(f'apart roots without a reason in {APART_REGISTER.name}: {unclassified}; register entries no longer apart '
                 f'roots: {stale}; instances naming a law or base constant the run lacks: {bad_instances}')
    if '--write' in sys.argv[1:]:
        (HERE / 'THEOREM-CONNECTIVITY.json').write_text(json.dumps(
            {**summary, 'theorems': {n: cls[n] for n, _ in theorems},
             'periphery_theorems': dict(sorted(periphery_cls.items()))}, ensure_ascii=False, indent=1) + '\n')


if __name__ == '__main__':
    main()
