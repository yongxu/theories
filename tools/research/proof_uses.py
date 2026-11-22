#!/usr/bin/env python3
"""The print of the uses between proofs: what Lean prints of the proof terms of one core run's theorems, as files.

python3 -B tools/research/proof_uses.py [--build] [--max-steps N]
python3 -B tools/research/proof_uses.py --check

AI-written (Claude Fable, for board row DJ), 22 November 2026.

What a line of the print is. One theorem, and the theorems that occur in its proof term as Lean holds it: the proof
of the one, as written, uses the others. Nothing more is read into it here or should be on a page: a proof may take
one part of what it uses, and what a used theorem's own proof uses is on that theorem's line, where it has one, not
on this one.

When to run it. Right after a passing core run of the same tree (check_becoming.py), when the checker's cache holds
every step, and before the render, so that the pages are rendered from the print of the Lean they are about. Run
before the core run, it refuses: for lack of cached steps ("the cache lacks N steps"), or, where the Lean changed
since the receipt was written, because the receipt does not bind the bytes. That refusal is not a fault of the tool
or of the tree; it says the core run has not been made for this tree yet. --build compiles what the cache lacks,
here, however many steps that is.

The default run needs Lean and is told as a Lean run. It is not part of the render and not part of the gate.

1. It reads the core receipt (becoming-verification.json) and refuses unless the receipt passed, binds the current
   bytes of every module it lists, and no Lean file it would compile differs from HEAD. So the print is of the bytes
   of one commit and of one core run, and both are written in the index.
2. It writes a stub that imports every module the receipt lists into tmp/.build/proof-uses-tree/ (one fixed directory this
   tool owns; tmp/ is git-ignored) and builds it with the package's scratch_build.py, so every import is restored
   from the checker's shared cache and only the stub and its audit are run. Before building it says how many steps
   the cache lacks and refuses more than a few (--max-steps, default 3) unless --build is given: a cold cache would
   compile the whole package.
3. It writes the printer (the Lean text below, PRINTER, with the receipt's module list written into it) beside the
   build and runs the checker's Lean on it once, in one of the checker's Lean slots. It waits on nothing by process
   name: the slots and the cache's locks are what keep runs apart.
4. Only after Lean exits 0, the last line printed is the count line and its counts are those of the lines read, and
   the sources are still the receipt's, it writes theories/becoming/results/atlas/proof-uses/: one file a module
   (<module>.jsonl, one line a theorem, sorted by name, {"name", "uses"}) and INDEX.json, each by a temporary file
   and os.replace, a file whose bytes would not change left untouched. A module file this tool wrote before whose
   module the receipt no longer lists is removed by name. Any failure before that stops with a message and writes
   nothing there. No index is written without the commit and the core run it was printed from.

A refusal says in its first words which it is: "the Lean tree differs from a commit"; "the receipt does not bind the
bytes"; "the cache lacks N steps"; "Lean failed or its output was short" (the scratch build or the printer did not
pass, Lean reported an error or a panic, the count line is missing or wrong, or a module has fewer rows than the
receipt counts theorems for it); "the tree moved while Lean ran". Any other refusal names its own cause.

--check runs no Lean and reads no Lean source. It compares the index with the receipt and with this file and prints
what status() returns: whether the index binds the receipt's sources (core_sources_sha256, computed as
shared_laws.py computes it), the receipt's toolchain, this tool's printer (printer_sha256, of PRINTER as it stands
in this file) and the format this tool writes (FORMAT), and the modules whose source hash differs or is missing on
either side. A later receipt of the same sources and toolchain (a core run made again, nothing changed) leaves the
print bound: nothing is printed again for it. It exits 0 when the index is bound and its files are the ones it
describes, 1 otherwise. gate.py imports status().

What the printer leaves out, so that no reader takes the print for more. Every declaration under a theorem's own
name is followed and what it uses is counted as the theorem's: that is Lean's auxiliary declarations (the matchers
among them are definitions), and also a theorem a person named under another theorem's name, which has a line of
its own as well and is not listed among the uses of the theorem it is named under. No other definition is followed,
so a use that passes through a definition's body does not show. The theorems Lean generates that the printer knows
by the form of their names (equation lemmas, injectivity lemmas, abstracted proofs under a definition, and any name
with a part beginning `_`, such as an abstracted proof under another theorem that Lean reuses) have no line, and
where one occurs among a theorem's uses it is a name with no line, counted in the index as uses_without_row.
Theorems of Lean files outside the core run have no line and are in no list.

What has a line though no person wrote it as a theorem (seen in the rows the earlier printer of 22 November 2026
gave, whose test for names this one keeps): the brecOn and brecOn.eq of an inductive proposition, the ofNat_ctorIdx
of an enumeration, and each field of a structure that is a proposition. A field's line has no uses; a proof that
takes the field from a structure it is given lists the field among its uses, and what it uses there is an
assumption the structure carries, not a proved theorem.

Disk: the tree keeps a copy of every compiled module (about 320 MB on 22 November 2026) until it is removed by hand.
"""
import argparse
import fcntl
import hashlib
import json
import os
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
# The package's folder, the core receipt in it, and the folder the receipt's source paths are relative to (lean/).
PACKAGE = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RECEIPT = PACKAGE + '/becoming-verification.json'
LEAN_ROOT = str(Path(PACKAGE).parent)
# Where the print is kept, and its index.
DIRECTORY = 'theories/becoming/results/atlas/proof-uses'
INDEX = 'INDEX.json'
# The one scratch directory this tool owns, and the stub module it builds there.
# Under a folder named .build, which the Lean catalogue and the gate's look at the worktree both skip: the stub and the
# printer are Lean files, and left anywhere else under tmp/ they make the gate refuse the tree as more than its commit
# (found by a replay on 22 November 2026, the first time the gate ran after the tool in one worktree).
TREE = 'tmp/.build/proof-uses-tree'
STUB = 'ProofUsesStub'
# Steps the cache may lack before the run refuses without --build: the stub's compile and its audit, and one spare.
MAX_STEPS = 3
# Seconds allowed for the printer's Lean run (23 s on an idle machine on 22 November 2026; this machine is shared).
TIMEOUT = int(os.environ.get('LEAN_TIMEOUT', '1800'))
# A module name this tool will write as a file name and into Lean text: dotted identifiers, nothing else.
MODULE_NAME = re.compile(r'[A-Za-z_][A-Za-z0-9_]*(\.[A-Za-z_][A-Za-z0-9_]*)*\Z')
COUNT_LINE = re.compile(r'COUNT rows=(\d+) uses=(\d+)\Z')
MODULES_PLACEHOLDER = '@MODULES@'
# The format of the print's files, written in the index as `format` and compared by status(). printer_sha256 binds
# the Lean text only; this number binds the Python that turns its output into files. Raise it with any change to
# what a print holds for the same Lean output: parse_output's reading, module_text, the index's keys, or ABOUT.
FORMAT = 1
# The first words of a run's refusal, one for each of the five cases a person who runs the tool has to tell apart.
# The third is cache_refusal(n), which gives the number of steps.
NOT_A_COMMIT = 'the Lean tree differs from a commit: '
NOT_THE_BYTES = 'the receipt does not bind the bytes: '
LEAN_SHORT = 'Lean failed or its output was short: '
MOVED = 'the tree moved while Lean ran: '

ABOUT = (
    'What Lean prints of the proof terms of the theorems of one core run, written by tools/research/proof_uses.py '
    '(AI-written tool, 22 November 2026). One file a module, one line a theorem declared in it, sorted by name; a '
    'private theorem has a line under the name Lean prints. `uses` lists the theorems declared in a module of this '
    'core run that occur in the proof term: a use between proofs as written, the proof of one theorem naming '
    'another, and no more than that. One call: what a used theorem\'s own proof uses is on that theorem\'s line, '
    'where it has one. '
    'The declarations under a theorem\'s own name are followed to any depth and what they use is counted as the '
    'theorem\'s: Lean\'s auxiliary declarations (matchers, abstracted proofs), and a theorem a person named under '
    'another theorem\'s name, which has a line of its own too and is not listed among the uses of the theorem it is '
    'named under. No other definition is followed, so a use that passes through a definition\'s body does not '
    'show. The theorems Lean generates that the printer knows by the form of their names (equation lemmas, '
    'injectivity lemmas, abstracted proofs under a definition, and any name with a part beginning `_`, such as an '
    'abstracted proof under another theorem that Lean reuses) have no line; such a name among a theorem\'s uses is a '
    'name with no line, and `uses_without_row` counts the distinct names of that kind. What Lean holds as a theorem '
    'and the printer does not know by its name has a line like any other: the `brecOn` of an inductive proposition, the '
    '`ofNat_ctorIdx` of an enumeration, and each field of a structure that is a proposition. Such a field\'s line has '
    'no uses, and a proof that takes the field from a structure it is given lists the field among its uses, though '
    'what it uses there is an assumption the structure carries and not a proved theorem. Theorems of Lean files '
    'outside the core run have no line and are in no list. Generated: edit nothing here and merge nothing by hand; '
    'rerun the tool after a core run.')

# The Lean printer, kept as text so that no tracked .lean file exists for the Lean catalogue and the validator to
# read. printer_sha256 in the index is the sha256 of this text exactly as it stands here, placeholder included; the
# module list that replaces the placeholder comes from the receipt, which the index binds separately. usedBy,
# valueOf, skipLast and jsonList are those of row DJ's AllProofHeads.lean (a session file, not tracked), run on 22
# November 2026.
# Changed from it, and not yet run when this was written: the modules come from a list and not from the prefix
# `Becoming`; a private theorem is kept (the test for Lean's own names looks past the private prefix); the head and
# the recursors are not printed; digitsAfter asks `s != pre` in place of a length that the toolchain deprecates; a
# count line is printed last.
PRINTER = r'''import Lean
import ProofUsesStub

/-! One line for every theorem declared in a module of one core run (the modules listed below): its module, its name
and the theorems declared in those modules that occur in its proof term. The declarations under a theorem's own name
(Lean's auxiliary declarations, such as matchers and abstracted proofs) are followed to any depth, so what they use
is counted as the theorem's. No other theorem and no other definition is followed. A private theorem has a line under the
name Lean prints. The last line counts the lines and the uses on them. Run by tools/research/proof_uses.py, which
keeps this text and writes the list of modules into it; after `AllProofHeads.lean` and row FM's `Rows.lean` of the
same day. AI-written (Claude Fable, for board row DJ), 22 November 2026. -/

open Lean

def receiptModules : List String := [
@MODULES@
]

def valueOf (ci : ConstantInfo) : Option Expr :=
  match ci with
  | .thmInfo t => some t.value
  | .defnInfo d => some d.value
  | .opaqueInfo o => some o.value
  | _ => none

/-- The constants in the proof term of `n`, following constants declared under `n`'s own name. -/
partial def usedBy (env : Environment) (n : Name) : NameSet :=
  let rec go (todo : List Name) (seen out : NameSet) : NameSet :=
    match todo with
    | [] => out
    | c :: rest =>
      if seen.contains c then go rest seen out else
      let seen := seen.insert c
      match (env.find? c).bind valueOf with
      | none => go rest seen out
      | some v =>
        let (more, out) := v.getUsedConstants.foldl (init := (rest, out)) fun (acc : List Name × NameSet) u =>
          if u != n && n.isPrefixOf u then (u :: acc.1, acc.2) else (acc.1, acc.2.insert u)
        go more seen out
  go [n] {} {}

def digitsAfter (s pre : String) : Bool :=
  s.startsWith pre && s != pre && (s.drop pre.length).all (fun ch => ch.isDigit || ch == '_')

/-- Lean's own generated names: equation lemmas, matchers, abstracted proofs and the like. -/
def skipLast (c : Name) : Bool :=
  match c with
  | .str _ s => digitsAfter s "eq_" || s == "eq_def" || s == "eq_unfold" || s == "injEq" || s == "inj"
      || s == "sizeOf_spec" || s == "noConfusion" || digitsAfter s "match_" || s.startsWith "_"
      || digitsAfter s "proof_"
  | .num _ _ => true
  | _ => false

def jsonList (xs : List String) : String := "[" ++ ", ".intercalate (xs.map String.quote) ++ "]"

#eval show CoreM Unit from do
  let env ← getEnv
  let mods := env.header.moduleNames
  let inReceipt : Array Bool := mods.map fun m => receiptModules.contains (toString m)
  let mut rows : Array (String × String) := #[]
  let mut total : Nat := 0
  for (c, ci) in env.constants.map₁.toList do
    match ci with
    | .thmInfo _ =>
      -- A private theorem is kept: only a name that is Lean's own once the private prefix is set aside is skipped.
      if skipLast c || (privateToUserName c).isInternal then continue
      match env.getModuleIdxFor? c with
      | none => continue
      | some idx =>
        if !(inReceipt[idx.toNat]!) then continue
        let m := mods[idx.toNat]!
        let used := (usedBy env c).toList
        let pkg := used.filter fun u => match env.find? u with
          | some (.thmInfo _) => (match env.getModuleIdxFor? u with
              | some j => inReceipt[j.toNat]!
              | none => false)
          | _ => false
        let srt := fun (l : List Name) => (l.map toString).toArray.qsort (· < ·) |>.toList
        total := total + pkg.length
        rows := rows.push (toString m ++ " " ++ toString c,
          "{\"module\": " ++ (toString m).quote ++ ", \"name\": " ++ (toString c).quote
            ++ ", \"uses\": " ++ jsonList (srt pkg) ++ "}")
    | _ => continue
  for (_, r) in rows.qsort (fun a b => a.1 < b.1) do
    IO.println ("ROW " ++ r)
  IO.println ("COUNT rows=" ++ toString rows.size ++ " uses=" ++ toString total)
'''


class Refused(Exception):
    """The run stops here with this message; nothing has been written to the print's directory."""


def cache_refusal(lack, max_steps):
    """The refusal for a cache that lacks more steps than the run may compile unasked: its first words give the
    number, and it says when the tool is to be run."""
    return (f'the cache lacks {lack} step{"" if lack == 1 else "s"}: more than {max_steps}, and this run would compile '
            'them here. That is no fault of the tool or of the tree. Run this tool right after a passing core run of the '
            'same tree (check_becoming.py), when the cache holds every step, and before the render; or give --build to '
            'compile what the cache lacks')


def digest(data):
    return hashlib.sha256(data).hexdigest()


def printer_sha256(printer=None):
    """The sha256 of the printer text embedded in this tool, which the index records and status() compares."""
    return digest((PRINTER if printer is None else printer).encode())


def sources_digest(receipt):
    """One hash of the core sources a receipt checked: the same value as shared_laws.sources_digest(receipt), which a
    test holds equal, kept here so that the gate can import this tool without the measure's tools."""
    return digest(json.dumps(receipt.get('source_sha256', {}), sort_keys=True).encode())


def receipt_modules(receipt):
    """The modules a receipt lists, sorted by name. Raises ValueError where its two maps disagree or a name could
    not be a file name and a Lean module name."""
    hashes, paths = receipt.get('source_sha256'), receipt.get('source_paths')
    if not isinstance(hashes, dict) or not hashes:
        raise ValueError('the receipt has no source_sha256 map')
    if paths is not None and set(paths) != set(hashes):
        raise ValueError('the receipt\'s source_paths and source_sha256 do not name the same modules')
    odd = sorted(m for m in hashes if not isinstance(m, str) or not MODULE_NAME.match(m))
    if odd:
        raise ValueError(f'the receipt lists module names this tool will not write as file names: {odd[:3]}')
    if STUB in hashes:
        raise ValueError(f'the receipt lists a module named {STUB}, which is the name of this tool\'s stub')
    return sorted(hashes)


def stub_text(receipt):
    """The stub module: one import for every module the receipt lists, in the order of their names, and a comment. It
    declares nothing, so the checker scans it as a root module."""
    return (''.join(f'import {m}\n' for m in receipt_modules(receipt))
            + '\n/-! A stub that imports every module of one core run, generated by tools/research/proof_uses.py for its '
              'print of the uses between proofs; it states nothing. AI-written. -/\n')


def printer_text(receipt, printer=None):
    """The Lean file that is run: the embedded printer with the receipt's module list written in place of its one
    placeholder."""
    printer = PRINTER if printer is None else printer
    if printer.count(MODULES_PLACEHOLDER) != 1:
        raise ValueError(f'the printer text must hold {MODULES_PLACEHOLDER} exactly once')
    return printer.replace(MODULES_PLACEHOLDER, ',\n'.join(f'  "{m}"' for m in receipt_modules(receipt)))


def parse_output(text, modules):
    """Read what the printer printed into {module: [{"name", "uses"}]}, every module of `modules` present (with no
    rows where it declares no theorem), rows sorted by name and uses sorted. Returns that and the lines that were
    neither a row nor the count (Lean's warnings). Raises Refused, beginning with LEAN_SHORT, where the output is
    not a whole print: an error or a panic from Lean (a panic prints its line, goes on with a default value and
    leaves the exit code 0), a last line that is not the count line, counts that are not those of the lines read, a
    row that is not of the expected shape, a row of a module outside `modules`, or a name printed twice."""
    lines = text.split('\n')
    while lines and not lines[-1].strip():
        lines.pop()
    if not lines:
        raise Refused(LEAN_SHORT + 'the printer printed nothing')
    last = COUNT_LINE.match(lines[-1])
    if not last:
        raise Refused(LEAN_SHORT + 'the last line the printer printed is not its count line, so the print may be cut '
                      'short: ' + lines[-1][:200])
    rows, notes = [], []
    for number, line in enumerate(lines[:-1], 1):
        if line.startswith('ROW '):
            try:
                row = json.loads(line[4:])
            except ValueError as error:
                raise Refused(f'{LEAN_SHORT}line {number} of the printer\'s output is not a row it can read ({error}): '
                              f'{line[:200]}')
            if not isinstance(row, dict) or set(row) != {'module', 'name', 'uses'} or not isinstance(row['module'], str) \
                    or not isinstance(row['name'], str) or not row['name'] or not isinstance(row['uses'], list) \
                    or any(not isinstance(u, str) or not u for u in row['uses']):
                raise Refused(f'{LEAN_SHORT}line {number} of the printer\'s output is not a row of module, name and uses: '
                              f'{line[:200]}')
            rows.append(row)
        elif COUNT_LINE.match(line):
            raise Refused(f'{LEAN_SHORT}line {number} of the printer\'s output is a count line before the last line')
        else:
            notes.append(line)
    errors = [n for n in notes if re.search(r'\berror:|PANIC', n)]
    if errors:
        raise Refused(LEAN_SHORT + 'Lean reported an error or a panic in the printer: '
                      + ' | '.join(e[:300] for e in errors[:3]))
    counted, used = int(last[1]), int(last[2])
    if counted != len(rows) or used != sum(len(r['uses']) for r in rows):
        raise Refused(f'{LEAN_SHORT}the printer counted {counted} rows and {used} uses; {len(rows)} rows and '
                      f'{sum(len(r["uses"]) for r in rows)} uses were read')
    by_module, seen = {m: [] for m in sorted(modules)}, set()
    for row in rows:
        if row['module'] not in by_module:
            raise Refused(f'{LEAN_SHORT}the printer gave a row for {row["name"]} in {row["module"]}, a module the '
                          'receipt does not list')
        if row['name'] in seen:
            raise Refused(f'{LEAN_SHORT}the printer gave two rows for {row["name"]}')
        seen.add(row['name'])
        by_module[row['module']].append({'name': row['name'], 'uses': sorted(set(row['uses']))})
    for found in by_module.values():
        found.sort(key=lambda r: r['name'])
    return by_module, notes


def short_of_the_receipt(receipt, by_module):
    """The modules for which the printer gave fewer rows than the receipt counts theorems (`theorems` of the
    receipt's entry for the module: the checker's count of the theorems in the source), sorted. The count line
    cannot see this: a module whose name the printer's own test for modules misses loses its rows inside Lean, and
    the count is then of the rows that were printed. A module may have more rows than the receipt counts (Lean
    holds as theorems some things no person wrote as one), so only fewer is a sign."""
    return sorted(m['module'] for m in receipt.get('modules', [])
                  if isinstance(m, dict) and m.get('module') in by_module and isinstance(m.get('theorems'), int)
                  and len(by_module[m['module']]) < m['theorems'])


def module_text(rows):
    """A module's file: one line a theorem, sorted by name (by code point, as Python sorts text), its uses sorted."""
    return ''.join(json.dumps({'name': r['name'], 'uses': sorted(set(r['uses']))}, ensure_ascii=False) + '\n'
                   for r in sorted(rows, key=lambda r: r['name']))


def names_without_row(by_module):
    """The names that occur in some uses list and have no row, sorted."""
    have = {r['name'] for rows in by_module.values() for r in rows}
    return sorted({u for rows in by_module.values() for r in rows for u in r['uses']} - have)


def receipt_theorems(receipt):
    """The names the receipt's scan of the sources gives as theorems, for the run's summary only."""
    return {d['name'] for m in receipt.get('modules', []) if isinstance(m, dict)
            for d in m.get('declarations', []) if isinstance(d, dict) and d.get('kind') == 'theorem' and 'name' in d}


def printed_from_problem(made):
    """Why `made` is not the commit and the core run a print was made from, or None: both must be there, as text."""
    if not isinstance(made, dict) or not all(isinstance(made.get(k), str) and made[k] for k in ('commit', 'core_run')):
        return 'no index is written without the commit and the core run it was printed from'
    return None


def index_object(receipt, by_module, printer=None, commit=None):
    """The index of a print: what it is in words, the format of its files, the printer's sha256, the toolchain, the
    commit and the core run it was printed from, the hash of the receipt's map of source hashes, each module's
    source hash and number of theorems, and the counts. `by_module` must have exactly the receipt's modules. The
    commit and the receipt's time (`utc`) are required: without either it raises ValueError."""
    modules = receipt_modules(receipt)
    if set(by_module) != set(modules):
        raise ValueError('the rows are not of exactly the modules the receipt lists')
    made = {'commit': commit, 'core_run': receipt.get('utc')}
    if printed_from_problem(made):
        raise ValueError(f'{printed_from_problem(made)} (commit {commit!r}, core run {receipt.get("utc")!r})')
    return {
        'about': ABOUT,
        'format': FORMAT,
        'printer_sha256': printer_sha256(printer),
        'toolchain': receipt.get('toolchain'),
        'printed_from': made,
        'core_sources_sha256': sources_digest(receipt),
        'modules': {m: {'source_sha256': receipt['source_sha256'][m], 'theorems': len(by_module[m])} for m in modules},
        'counts': {'modules': len(modules), 'theorems': sum(len(by_module[m]) for m in modules),
                   'uses_without_row': len(names_without_row(by_module))},
    }


def index_text(index):
    return json.dumps(index, ensure_ascii=False, indent=1) + '\n'


def replace_bytes(path, data):
    """Put `data` at `path` by a temporary file in the same directory and os.replace, so a reader never sees half a
    file. A file that already holds those bytes is left untouched. Returns whether the file changed."""
    if path.is_file() and path.read_bytes() == data:
        return False
    temporary = path.with_name(f'.{path.name}.{os.getpid()}.tmp')
    try:
        temporary.write_bytes(data)
        os.replace(temporary, path)
    finally:
        if temporary.exists():
            temporary.unlink()
    return True


def write_print(directory, index, by_module):
    """Write a print into `directory`: every module's file, then the removal of each module file the index that was
    there named and the new index does not, then the index last. Everything is checked before the first write, and a
    file whose bytes would not change is not written. A file the earlier index did not name is never removed. An
    index that does not say the commit and the core run it was printed from is refused, like rows that do not fit.
    Returns the module files changed and removed, whether the index changed, and the files left that are no part of
    the print."""
    directory = Path(directory)
    modules = index['modules']
    if printed_from_problem(index.get('printed_from')):
        raise ValueError(printed_from_problem(index.get('printed_from')))
    if set(modules) != set(by_module):
        raise ValueError('the index and the rows are not of the same modules')
    odd = sorted(m for m in modules if not MODULE_NAME.match(m))
    if odd:
        raise ValueError(f'module names that will not be written as file names: {odd[:3]}')
    wrong = sorted(m for m in modules if modules[m]['theorems'] != len(by_module[m]))
    if wrong:
        raise ValueError(f'the index does not give the number of rows of: {wrong[:3]}')
    texts = {m: module_text(by_module[m]).encode() for m in modules}
    before = set()
    try:
        before = set(json.loads((directory / INDEX).read_text(encoding='utf-8')).get('modules', {}))
    except (OSError, ValueError, AttributeError):
        pass  # no earlier index that can be read: this tool knows of no file it wrote, and removes none
    directory.mkdir(parents=True, exist_ok=True)
    changed = [m for m in sorted(modules) if replace_bytes(directory / (m + '.jsonl'), texts[m])]
    removed = []
    for m in sorted(before - set(modules)):
        if MODULE_NAME.match(m) and (directory / (m + '.jsonl')).is_file():
            (directory / (m + '.jsonl')).unlink()
            removed.append(m)
    index_changed = replace_bytes(directory / INDEX, index_text(index).encode())
    expected = {INDEX} | {m + '.jsonl' for m in modules}
    return {'changed': changed, 'removed': removed, 'index_changed': index_changed,
            'not_of_the_print': sorted(p.name for p in directory.iterdir() if p.name not in expected)}


def read_print(directory):
    """A print as written: its index and {module: [{"name", "uses"}]} for every module the index names."""
    directory = Path(directory)
    index = json.loads((directory / INDEX).read_text(encoding='utf-8'))
    return index, {m: [json.loads(line) for line in (directory / (m + '.jsonl')).read_text(encoding='utf-8').splitlines()]
                   for m in index['modules']}


def damage(directory, index):
    """Where a print's files are not the ones its index describes: a module's file missing or of another number of
    lines, counts that are not the sums, a module file the index does not name. It reads no line's content."""
    directory, found = Path(directory), []
    modules = index.get('modules') if isinstance(index.get('modules'), dict) else {}
    for m in sorted(modules):
        path = directory / (m + '.jsonl')
        told = modules[m].get('theorems') if isinstance(modules[m], dict) else None
        if not path.is_file():
            found.append(f'{m}.jsonl is missing')
        else:
            lines = path.read_bytes().count(b'\n')
            if lines != told:
                found.append(f'{m}.jsonl has {lines} lines; the index gives {told} theorems')
    counts = index.get('counts') if isinstance(index.get('counts'), dict) else {}
    if counts.get('modules') != len(modules):
        found.append(f'the index counts {counts.get("modules")} modules and names {len(modules)}')
    total = sum(v.get('theorems') or 0 for v in modules.values() if isinstance(v, dict))
    if counts.get('theorems') != total:
        found.append(f'the index counts {counts.get("theorems")} theorems; its modules sum to {total}')
    if directory.is_dir():
        for path in sorted(directory.glob('*.jsonl')):
            if path.name[:-len('.jsonl')] not in modules:
                found.append(f'{path.name} is a file of no module the index names')
    return found


def status(root=ROOT, printer=None):
    """Whether the print under `root` is of the sources and the toolchain the core receipt checked, of this tool's
    printer and in this tool's format. It runs no Lean and reads no Lean source: it reads the index, the receipt and
    the print's file sizes.

    Returns a dict. `bound` is true exactly when the index binds four things: the receipt's map of source hashes
    (core_sources_sha256), the receipt's toolchain, the printer text in this file (printer_sha256) and the format
    this file writes (FORMAT). The receipt's time does not enter it, so a later receipt of the same sources and
    toolchain leaves the print bound. `problems` says in sentences why it is not bound; `modules_behind` lists the
    modules whose source hash differs or is missing on either side, and `behind` the same by kind. `damage` says in
    sentences where the print's files are not what its index describes, an index that cannot be read among them; it
    is told beside `bound` and does not enter it. `kind` is one word for the whole, the first of these that holds:
    'no index'; 'damaged' (damage is not empty: files missing or cut, whatever else holds); 'not bound' (the index
    is there with its files and does not bind the receipt's sources, the toolchain, the printer or the format, or
    the receipt cannot be read: the landing left out the step of running this tool); 'bound'. So `kind` is 'bound'
    exactly when `bound` is true and `damage` is empty. Nothing is raised for a missing or unreadable index or
    receipt: that is a problem."""
    root = Path(root)
    out = {'present': False, 'bound': False, 'kind': 'no index', 'problems': [], 'modules_behind': [],
           'behind': {'changed': [], 'not_in_print': [], 'not_in_receipt': []},
           'sources_bound': False, 'printer_bound': False, 'toolchain_agrees': None, 'format_agrees': None,
           'printed_from': None, 'core_run': None, 'damage': []}
    index_path = root / DIRECTORY / INDEX
    if not index_path.is_file():
        out['problems'].append(f'there is no index at {DIRECTORY}/{INDEX}')
        return out
    out['present'] = True
    try:
        index = json.loads(index_path.read_text(encoding='utf-8'))
        if not isinstance(index, dict):
            raise ValueError('not a JSON object')
    except (OSError, ValueError) as error:
        out['problems'].append(f'{DIRECTORY}/{INDEX} cannot be read: {error}')
        out['damage'].append(f'{INDEX} cannot be read: {error}')
        out['kind'] = 'damaged'
        return out
    out['printed_from'] = index.get('printed_from')
    out['damage'] = damage(root / DIRECTORY, index)
    out['kind'] = 'damaged' if out['damage'] else 'not bound'
    try:
        receipt = json.loads((root / RECEIPT).read_text(encoding='utf-8'))
        sources = receipt['source_sha256']
        if not isinstance(sources, dict):
            raise ValueError('source_sha256 is not a map')
    except (OSError, ValueError, KeyError, TypeError) as error:
        out['problems'].append(f'the core receipt {RECEIPT} cannot be read: {error!r}')
        return out
    out['core_run'] = receipt.get('utc')
    modules = index.get('modules') if isinstance(index.get('modules'), dict) else {}
    printed = {m: (v.get('source_sha256') if isinstance(v, dict) else None) for m, v in modules.items()}
    behind = out['behind']
    behind['changed'] = sorted(m for m in printed if m in sources and printed[m] != sources[m])
    behind['not_in_print'] = sorted(m for m in sources if m not in printed)
    behind['not_in_receipt'] = sorted(m for m in printed if m not in sources)
    out['modules_behind'] = sorted(set(behind['changed']) | set(behind['not_in_print']) | set(behind['not_in_receipt']))
    out['sources_bound'] = index.get('core_sources_sha256') == sources_digest(receipt)
    out['printer_bound'] = index.get('printer_sha256') == printer_sha256(printer)
    out['toolchain_agrees'] = index.get('toolchain') == receipt.get('toolchain')
    out['format_agrees'] = type(index.get('format')) is int and index['format'] == FORMAT
    out['bound'] = out['sources_bound'] and out['printer_bound'] and out['toolchain_agrees'] and out['format_agrees']
    if not out['sources_bound']:
        out['problems'].append(
            f'the print is of other sources than the core run of {receipt.get("utc")} checked (core_sources_sha256 '
            f'differs): {len(behind["changed"])} module(s) changed, {len(behind["not_in_print"])} not printed, '
            f'{len(behind["not_in_receipt"])} printed and no longer in the receipt')
    if not out['toolchain_agrees']:
        out['problems'].append(f'the print was made with toolchain {index.get("toolchain")}; the core receipt is of '
                               f'{receipt.get("toolchain")}')
    if not out['printer_bound']:
        out['problems'].append('the print was made by another printer than the one in tools/research/proof_uses.py '
                               '(printer_sha256 differs)')
    if not out['format_agrees']:
        out['problems'].append(f'the print\'s files are in format {index.get("format")!r}; tools/research/proof_uses.py '
                               f'writes format {FORMAT}')
    if out['bound'] and not out['damage']:
        out['kind'] = 'bound'
    return out


# The run: everything below needs the checkout, git, the checker and Lean. The unit tests reach unbound_sources,
# dirty_lean and lacking, and they reach run() and run_printer() with git, the checker, the plan, the count of
# lacking steps, the scratch build and Lean's process each replaced by a stand-in, so what they hold is the order of
# the steps and that a refusal writes nothing. git_state, checker and plan were called once by hand on the checkout
# of 22 November 2026, starting no Lean (412 modules bound, no Lean file apart from HEAD, 414 steps of which the
# cache lacked the stub's two). build, run_printer with a real Lean, and the Lean text of PRINTER had not been run
# when this was written.

def unbound_sources(receipt, lean_root):
    """The modules of the receipt whose source file, at the receipt's path below `lean_root`, is missing or does not
    hold the bytes the receipt hashed."""
    lean_root, out = Path(lean_root), []
    for m in receipt_modules(receipt):
        path = lean_root / receipt.get('source_paths', {}).get(m, '')
        if not path.is_file() or digest(path.read_bytes()) != receipt['source_sha256'][m]:
            out.append(m)
    return out


def dirty_lean(porcelain, sources):
    """From `git status --porcelain -z --untracked-files=all` on the package's folder and the receipt's sources: the
    Lean files that keep the tree from being a commit's. A tracked .lean file reported in any state counts; an
    untracked one counts only where it is one of `sources` (the receipt's source paths, relative to the repository),
    so the copies a core run leaves in its untracked run folder do not."""
    entries, out, i = porcelain.split('\0'), [], 0
    while i < len(entries):
        entry = entries[i]
        i += 1
        if len(entry) < 4:
            continue
        state, paths = entry[:2], [entry[3:]]
        if 'R' in state or 'C' in state:  # a rename or copy is followed by the path it came from
            if i < len(entries):
                paths.append(entries[i])
                i += 1
        out += [p for p in paths if p.endswith('.lean') and (state != '??' or p in sources)]
    return sorted(set(out))


def lacking(plan, cache, runner, fresh=False):
    """The steps of a plan (check_becoming.lean_plan) the cache does not hold for this runner, read as
    check_becoming.reuse reads it but restoring nothing: the entry is there, this runner wrote it, and its output
    files are there with the hashes the entry gives. So a step whose kept file is missing or spoiled counts as
    lacking, as the build will find it."""
    cache, out = Path(cache), []
    for step in plan:
        try:
            entry = json.loads((cache / (step.key + '.json')).read_text())
            held = not fresh and entry.get('runner') == runner and 'log' in entry \
                and [digest((cache / step.key / Path(o).name).read_bytes()) for o in step.outputs] == entry.get('outputs')
        except (OSError, ValueError, TypeError, AttributeError):
            held = False
        if not held:
            out.append(step.task)
    return out


def git_state(root, receipt):
    """HEAD's commit, and the Lean files that differ from it among those the run would compile (dirty_lean)."""
    def git(*args):
        return subprocess.run(['git', *args], cwd=root, check=True, stdout=subprocess.PIPE,
                              stderr=subprocess.PIPE).stdout.decode()
    sources = {LEAN_ROOT + '/' + p for p in receipt.get('source_paths', {}).values()}
    outside = sorted(p for p in sources if not p.startswith(PACKAGE + '/'))
    commit = git('rev-parse', 'HEAD').strip()
    return commit, dirty_lean(git('status', '--porcelain', '-z', '--untracked-files=all', '--', PACKAGE, *outside), sources)


def checker(root):
    """The package's check_becoming module, loaded as its scratch_build.py loads it."""
    package = str(Path(root) / PACKAGE)
    if package not in sys.path:
        sys.path.insert(0, package)
    sys.dont_write_bytecode = True
    import check_becoming  # noqa: E402
    return check_becoming


def plan(cb, receipt, stub):
    """The steps scratch_build.py will take for the stub (the same calls, so the same keys) and the checker's Lean
    command. Raises Refused where the stub's import closure is not exactly the receipt's modules or a source the
    checker would compile is not the bytes the receipt hashed."""
    index = cb.module_index()
    index[STUB] = [stub]
    try:
        order = cb.closure(index, [STUB])
    except AssertionError as error:
        raise Refused(f'the checker could not order the stub\'s imports: {error}')
    modules = receipt_modules(receipt)
    apart = sorted((set(order) - {STUB}) ^ set(modules))
    if apart:
        raise Refused(f'the stub\'s import closure is not the receipt\'s modules; they differ on {apart[:5]}')
    sources = {name: index[name][0].read_bytes() for name in order}
    changed = [m for m in modules if digest(sources[m]) != receipt['source_sha256'][m]]
    if changed:
        raise Refused(f'{NOT_THE_BYTES}{len(changed)} source(s) the checker would compile are not the bytes the '
                      f'receipt hashed, e.g. {changed[:3]}: run check_becoming.py first')
    command, binary, _ = cb.resolve_lean()
    try:
        context = [cb.audit_support.TOOLCHAIN, cb.audit_support.digest(binary.read_bytes())]
    except OSError as error:
        raise Refused(f'the checker\'s Lean binary cannot be read: {error}')
    keys = cb.module_keys(context, sources, order)
    core = set(cb.closure(index, cb.CORE))
    steps, _ = cb.lean_plan(context, sources, keys, {STUB: cb.declarations(sources[STUB])}, order, audited=[STUB],
                            signed=[n for n in [STUB] if n in cb.CHECKED],
                            prelude=cb.closure(index, [n for n in [STUB] if n in core]))
    return steps, command


def build(root, tree):
    """Build the stub with the package's scratch_build.py, which restores every cached step and runs the rest in the
    machine's Lean slots. Returns its report. Raises Refused where it fails or a step is not clean."""
    done = subprocess.run([sys.executable, '-B', str(Path(root) / PACKAGE / 'scratch_build.py'), str(tree), STUB],
                          stdout=subprocess.PIPE, encoding='utf-8')
    try:
        report = json.loads(done.stdout)
    except ValueError:
        report = None
    if done.returncode != 0 or not isinstance(report, dict) or report.get('failed') or report.get('unclean'):
        raise Refused(f'{LEAN_SHORT}the scratch build of the stub did not pass (exit {done.returncode}): '
                      f'{done.stdout[-1500:]}')
    if not (tree / '.build' / (STUB + '.olean')).is_file():
        raise Refused(LEAN_SHORT + 'the scratch build passed and left no compiled stub in the tree')
    return report


def run_printer(cb, command, tree, receipt):
    """Write the printer beside the build and run the checker's Lean on it once, in one of the checker's Lean slots,
    with LEAN_PATH at the tree's .build. Returns what it printed, which is also kept in the tree. Raises Refused
    where Lean cannot be run, times out or exits other than 0."""
    work, built = tree / '.printer', tree / '.build'
    work.mkdir(exist_ok=True)
    source, kept = work / 'ProofUses.lean', work / 'output.txt'
    source.write_text(printer_text(receipt), encoding='utf-8')
    with cb.lean_slot():
        try:
            done = subprocess.run(command + [str(source)], cwd=built, env={**os.environ, 'LEAN_PATH': str(built)},
                                  stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=TIMEOUT)
        except subprocess.TimeoutExpired:
            raise Refused(f'{LEAN_SHORT}Lean did not finish the printer in {TIMEOUT} s (LEAN_TIMEOUT sets the limit)')
        except OSError as error:
            raise Refused(f'{LEAN_SHORT}Lean could not be started on the printer: {error}')
    text = done.stdout.decode('utf-8', errors='replace')
    kept.write_text(text, encoding='utf-8')
    if done.returncode != 0:
        raise Refused(f'{LEAN_SHORT}Lean exited {done.returncode} on the printer; its output is kept at {kept}; it '
                      'ends: ' + ' | '.join(text.strip().split('\n')[-5:])[-1500:])
    return text


def run(root=ROOT, build_all=False, max_steps=MAX_STEPS):
    """The default run (the module's docstring, 1 to 4). Returns the summary it prints. Raises Refused, having
    written nothing to the print's directory, wherever a step does not hold. A refusal begins with NOT_A_COMMIT,
    NOT_THE_BYTES, the words of cache_refusal, LEAN_SHORT or MOVED where it is one of those five; any other names
    its own cause."""
    root = Path(root)
    try:
        receipt = json.loads((root / RECEIPT).read_text(encoding='utf-8'))
        modules = receipt_modules(receipt)
    except (OSError, ValueError) as error:
        raise Refused(f'the core receipt {RECEIPT} cannot be used: {error}')
    if receipt.get('status') != 'passed':
        raise Refused(f'the latest core receipt ({receipt.get("utc")}) has status {receipt.get("status")!r}: run '
                      'check_becoming.py until it passes')
    if not isinstance(receipt.get('utc'), str) or not receipt['utc']:
        raise Refused(f'the core receipt {RECEIPT} does not give the time of its run (utc), and '
                      + printed_from_problem(None))
    lean_root = root / LEAN_ROOT

    def of_the_receipt_and_a_commit():
        changed = unbound_sources(receipt, lean_root)
        if changed:
            raise Refused(f'{NOT_THE_BYTES}the current Lean sources are not those the latest core receipt checked '
                          f'({len(changed)} module(s), e.g. {changed[:3]}): run check_becoming.py first, then this tool')
        try:
            commit, dirty = git_state(root, receipt)
        except (OSError, subprocess.CalledProcessError) as error:
            raise Refused(f'git could not say whether the Lean is a commit\'s: {error}')
        if dirty:
            raise Refused(f'{NOT_A_COMMIT}{len(dirty)} Lean file(s) differ from HEAD, e.g. {dirty[:3]}: commit them, so '
                          'that the print is of a commit')
        if not isinstance(commit, str) or not commit:
            raise Refused('git gave no commit for HEAD, and ' + printed_from_problem(None))
        return commit

    commit = of_the_receipt_and_a_commit()
    cb = checker(root)
    if receipt.get('toolchain') != cb.audit_support.TOOLCHAIN:
        raise Refused(f'the receipt\'s toolchain is {receipt.get("toolchain")!r} and the checker\'s is '
                      f'{cb.audit_support.TOOLCHAIN!r}')
    tree = root / TREE
    tree.mkdir(parents=True, exist_ok=True)
    with open(tree / '.lock', 'a') as lock:
        try:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except OSError:
            raise Refused(f'another run of this tool holds {TREE}')
        stub = tree / (STUB + '.lean')
        strays = sorted(str(p.relative_to(tree)) for p in tree.rglob('*.lean')
                        if p != stub and not any(part.startswith('.') for part in p.relative_to(tree).parts))
        if strays:
            raise Refused(f'{TREE} holds Lean files this tool did not write, which the scratch build would take as '
                          f'modules: {strays[:5]}')
        replace_bytes(stub, stub_text(receipt).encode())
        steps, command = plan(cb, receipt, stub)
        lack = lacking(steps, cb.CACHE, cb.RUNNER, cb.FRESH)
        print(f'the cache lacks {len(lack)} of the {len(steps)} steps' + (f': {", ".join(lack[:6])}' if lack else '')
              + (' ...' if len(lack) > 6 else ''), file=sys.stderr)
        if len(lack) > max_steps and not build_all:
            raise Refused(cache_refusal(len(lack), max_steps))
        report = build(root, tree)
        text = run_printer(cb, command, tree, receipt)
        by_module, notes = parse_output(text, modules)
        for note in notes[:20]:
            print('lean: ' + note[:300], file=sys.stderr)
        kept = f'the printer\'s output is kept at {TREE}/.printer/output.txt'
        if not any(by_module.values()):
            raise Refused(f'{LEAN_SHORT}the printer gave no row at all; {kept}')
        short = short_of_the_receipt(receipt, by_module)
        if short:
            raise Refused(f'{LEAN_SHORT}the printer gave fewer rows than the receipt counts theorems for {len(short)} '
                          f'module(s), e.g. {short[:3]}; {kept}')
        try:
            after = of_the_receipt_and_a_commit()
        except Refused as refusal:
            raise Refused(f'{MOVED}{refusal}. Nothing was written')
        if after != commit:
            raise Refused(f'{MOVED}HEAD was {commit} when the run began and is {after} now. Nothing was written: run '
                          'again')
        try:
            index = index_object(receipt, by_module, commit=commit)
            written = write_print(root / DIRECTORY, index, by_module)
        except ValueError as error:  # both check everything before the first write
            raise Refused(f'the print was not written: {error}')
    have = {r['name'] for rows in by_module.values() for r in rows}
    scanned = receipt_theorems(receipt)
    return {'modules': index['counts']['modules'], 'theorems': index['counts']['theorems'],
            'uses_without_row': index['counts']['uses_without_row'],
            'module_files_changed': len(written['changed']), 'module_files_removed': written['removed'],
            'index_changed': written['index_changed'], 'not_of_the_print': written['not_of_the_print'],
            'steps_the_cache_lacked': len(lack), 'steps_run': report.get('ran', []),
            'printed_from': index['printed_from'], 'lean_notes': len(notes),
            # The receipt's own scan of the sources, beside the print: a difference is told, not judged here.
            'receipt_theorems_without_row': len(scanned - have), 'the_first_of_them': sorted(scanned - have)[:5],
            'rows_the_receipt_scan_lacks': len(have - scanned)}


def argument_parser():
    """The tool's arguments. Its help is the module's docstring, which says when to run the tool."""
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('--check', action='store_true',
                        help='compare the index with the core receipt (its sources and toolchain) and with this tool '
                             '(its printer and format); run no Lean; exit 0 when the index is bound and its files are '
                             'the ones it describes')
    parser.add_argument('--build', action='store_true',
                        help='compile whatever steps the cache lacks, however many (without it the run refuses more '
                             'than --max-steps; right after a passing core run of the same tree the cache lacks only '
                             'the stub\'s)')
    parser.add_argument('--max-steps', type=int, default=MAX_STEPS,
                        help=f'steps the cache may lack before the run refuses without --build (default {MAX_STEPS})')
    return parser


def main(argv=None):
    args = argument_parser().parse_args(argv)
    if args.check:
        found = status(ROOT)
        print(json.dumps(found, ensure_ascii=False, indent=1))
        return 0 if found['kind'] == 'bound' else 1
    try:
        summary = run(ROOT, args.build, args.max_steps)
    except Refused as refusal:
        print(f'proof_uses: {refusal}', file=sys.stderr)
        return 1
    print(json.dumps(summary, ensure_ascii=False, indent=1))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
