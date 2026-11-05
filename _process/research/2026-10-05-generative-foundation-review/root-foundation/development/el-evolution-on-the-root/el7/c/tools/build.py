"""Build the import closure of the named modules from git main into the shared olean tree.

usage: python3 -B build.py [-j N] MODULE ...   (run under gate.py hold)

Sources are written from `git show main:` into /Users/ren/tmp/el7/olean at their package paths and
compiled there, as check_becoming.py's compile steps do (`lean -o Becoming/X.olean Becoming/X.lean`,
LEAN_PATH the tree), with the toolchain's own lean (v4.29.1). A module whose source and imports are
unchanged since its last build is skipped (a marker holds the hash). Each module is built under a
per-module lock (mkdir), so two sessions running this never build one module at once.
Scratch modules (paths given as FILE.lean:Module.Name) are compiled from the given file.
"""
import concurrent.futures as cf
import hashlib, os, re, subprocess, sys, time
from pathlib import Path

R = '/Users/ren/theories'
LEAN = 'experiments/integrated-correction/general-framework/generative-basis/lean'
FOUND = {'GenerativeCore': LEAN + '/GenerativeCore.lean',
         'RelationalRenewal': LEAN + '/deeper/RelationalRenewal.lean',
         'InquirySufficiency': LEAN + '/inquiry-root/sufficiency/InquirySufficiency.lean'}
TREE = Path('/Users/ren/tmp/el7/olean')
BIN = Path.home() / '.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean'


def repo_path(name):
    return FOUND.get(name) or LEAN + '/becoming/' + name.replace('.', '/') + '.lean'


def rel(name):
    return name.replace('.', '/') + '.lean'


def code_only(s):
    s = re.sub(r'/-.*?-/', '', s, flags=re.S)
    return re.sub(r'--.*', '', s)


def main():
    args = sys.argv[1:]
    jobs = 2
    if args[:1] == ['-j']:
        jobs, args = int(args[1]), args[2:]
    scratch = {}
    targets = []
    for a in args:
        if ':' in a:
            f, n = a.split(':')
            scratch[n] = Path(f).read_text()
            targets.append(n)
        else:
            targets.append(a)
    text = {}

    def source(name):
        if name not in text:
            if name in scratch:
                text[name] = scratch[name]
            else:
                text[name] = subprocess.run(['git', '-C', R, 'show', 'main:' + repo_path(name)],
                                            capture_output=True, text=True, check=True).stdout
        return text[name]

    imps, order, seen = {}, [], set()

    def visit(n):
        if n in seen:
            return
        seen.add(n)
        imps[n] = [m for m in re.findall(r'^import\s+(\S+)', code_only(source(n)), re.M) if m != 'Std']
        for i in imps[n]:
            visit(i)
        order.append(n)

    for t in targets:
        visit(t)
    digest = {}
    for n in order:
        h = hashlib.sha256(source(n).encode())
        for i in imps[n]:
            h.update(digest[i].encode())
        digest[n] = h.hexdigest()
    env = {**os.environ, 'LEAN_PATH': str(TREE)}
    futures = {}

    def build(n):
        for i in imps[n]:
            futures[i].result()
        src = TREE / rel(n)
        olean = src.with_suffix('.olean')
        marker = src.with_suffix('.sha')
        lock = src.with_suffix('.lock')
        src.parent.mkdir(parents=True, exist_ok=True)
        while True:
            try:
                lock.mkdir()
                break
            except FileExistsError:
                time.sleep(5)
        try:
            if olean.exists() and marker.exists() and marker.read_text() == digest[n]:
                return n, 'kept', 0.0
            src.write_text(source(n))
            tmp = src.with_suffix('.olean.tmp')
            started = time.time()
            p = subprocess.run([str(BIN), '-o', str(tmp.relative_to(TREE)), rel(n)], cwd=TREE, env=env,
                               capture_output=True, text=True)
            seconds = round(time.time() - started, 1)
            out = p.stdout + p.stderr
            if p.returncode != 0 or re.search(r'\b(?:error|warning):', out):
                (TREE / (rel(n)[:-5] + '.log')).write_text(out)
                raise RuntimeError(f'{n} failed ({p.returncode}) after {seconds}s:\n{out[:3000]}')
            os.replace(tmp, olean)
            marker.write_text(digest[n])
            return n, 'built', seconds
        finally:
            lock.rmdir()

    with cf.ThreadPoolExecutor(max_workers=jobs) as pool:
        # submit in order; a task blocks on its imports' futures, so keep workers > 0 for leaves
        for n in order:
            futures[n] = pool.submit(build, n)
        for n in order:
            name, how, secs = futures[n].result()
            print(name, how, secs, flush=True)


if __name__ == '__main__':
    main()
