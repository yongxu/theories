"""The kit's stage handling, tested in a dry run's tree once the dry run is done (dry_run.py prints its path):

  python3 -B <kit>/stage_check.py TREE

Two throwaway stages, after any real ones: 90-test-a, two patches that change one file (the second's context is the
first's line), with its EXPECTED.json; 91-test-b, first empty, then with a patch that does not apply, then skipped.
apply must take 90-test-a patch by patch and find it in place when run again; the audit must pass with its EXPECTED;
91-test-b must stop apply with nothing written, both times, and SKIP must leave it out; OU7_STAGES must select, a
stage applied but not taken must fail the audit, and a name with no stage must stop. It writes only inside TREE, and
leaves 90-test-a applied and both test stages in place; the tree is a throwaway."""
import difflib, hashlib, os, re, subprocess, sys
from pathlib import Path

T = Path(sys.argv[1])
KIT = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou7-conditional-laws/kit/'
GL = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarLaws.lean'
ST = T / KIT / 'stages'


def run(*args, env=None):
    return subprocess.run(list(args), cwd=T, capture_output=True, text=True, env={**os.environ, **(env or {})})


def integrate(*args, env=None):
    return run('python3', '-B', KIT + 'integrate_ou7.py', *args, env=env)


def state():
    d = run('git', 'diff', 'HEAD').stdout + run('git', 'status', '--porcelain', '--untracked-files=all').stdout
    return hashlib.sha256(d.encode()).hexdigest()


def in_place(out):
    """The stages the audit names in place, last."""
    return re.findall(r'stages in place: ([^;\n]*)', out)[-1].split()


def udiff(path, old, new):
    return ''.join(difflib.unified_diff(old.splitlines(True), new.splitlines(True), 'a/' + path, 'b/' + path))


def check(name, cond, detail=''):
    print(('PASS ' if cond else 'FAIL ') + name + ('' if cond else '\n' + detail[-1500:]))
    if not cond:
        sys.exit(1)


src = (T / GL).read_text(encoding='utf-8')
assert src.count('\nend Becoming\n') == 1
one = src.replace('\nend Becoming\n', '\n/-- A stage test\'s first law. -/\ntheorem «试甲» : True := trivial\n\nend Becoming\n')
two = one.replace('theorem «试甲» : True := trivial\n',
                  'theorem «试甲» : True := trivial\n\n/-- A stage test\'s second law, after the first. -/\n'
                  'theorem «试乙» : True := trivial\n')
a = ST / '90-test-a'
a.mkdir(parents=True)
(a / '01-first.patch').write_text(udiff(GL, src, one), encoding='utf-8')
(a / '02-second.patch').write_text(udiff(GL, one, two), encoding='utf-8')
(a / 'EXPECTED.json').write_text('{"added": {"Becoming.GrammarLaws": ["Becoming.«试甲»", "Becoming.«试乙»"]}}\n',
                                 encoding='utf-8')
whole = run('git', 'apply', '--check', str(a / '01-first.patch'), str(a / '02-second.patch'))
print('git apply --check over the whole series (two patches, one file):', 'passes' if not whole.returncode else
      'fails, as U4c found: ' + whole.stderr.strip().splitlines()[-1])

p = integrate('apply')
check('apply takes the two patches on one file, in order', not p.returncode and 'stage 90-test-a (2 patches): applied' in p.stdout,
      p.stdout + p.stderr)
check('the file is the second patch\'s', (T / GL).read_text(encoding='utf-8') == two)
p = integrate('audit')
check('the audit passes with the stage\'s EXPECTED', not p.returncode and in_place(p.stdout)[-1:] == ['90-test-a'],
      p.stdout + p.stderr)
p = integrate('apply')
check('apply again: the stage already in place', not p.returncode and 'stage 90-test-a: already in place' in p.stdout,
      p.stdout + p.stderr)

b = ST / '91-test-b'
b.mkdir()
before = state()
p = integrate('apply')
check('an empty stage stops apply', p.returncode and 'stage 91-test-b has no patch' in p.stderr, p.stdout + p.stderr)
check('nothing written', state() == before)
(b / '01-stale.patch').write_text(udiff(GL, src.replace('end Order', 'end Order\n-- a line main never had'),
                                        src.replace('end Order', 'end Order\n-- its replacement')), encoding='utf-8')
before = state()
p = integrate('apply')
check('a stage that does not apply stops apply', p.returncode and 'stage 91-test-b: 01-stale.patch does not apply' in p.stderr
      and 'nothing of the stage was written' in p.stderr, p.stdout + p.stderr)
check('nothing written', state() == before)
(b / 'SKIP').write_text('')
p = integrate('apply')
check('SKIP leaves it out', not p.returncode and 'stage 90-test-a: already in place' in p.stdout and '91-test-b' not in p.stdout,
      p.stdout + p.stderr)
p = integrate('audit')
check('the audit passes, the skipped stage named nowhere', not p.returncode and in_place(p.stdout)[-1:] == ['90-test-a']
      and '91-test-b' not in p.stdout, p.stdout + p.stderr)
(b / 'SKIP').unlink()
p = integrate('stages', env={'OU7_STAGES': '90-test-a'})
check('OU7_STAGES names the stages taken', not p.returncode and 'stages selected: 90-test-a' in p.stdout, p.stdout + p.stderr)
p = integrate('audit', env={'OU7_STAGES': 'none'})
check('a stage applied but not taken fails the audit', p.returncode != 0, p.stdout + p.stderr)
p = integrate('stages', env={'OU7_STAGES': '99-none-such'})
check('OU7_STAGES naming no stage stops', p.returncode and 'OU7_STAGES names no stage' in p.stderr, p.stdout + p.stderr)
print('stage handling: every check passed')
