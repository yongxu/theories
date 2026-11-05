"""Put the oleans of a module's import closure, as main has it, into the shared EL7 olean folder.

usage (from /Users/ren/theories, inside `gate.py hold`):
  python3 -B /Users/ren/tmp/el7/b/tools/build_closure.py Becoming.PairSelection [MORE ...]

For each module of the closure, in dependency order: its source is read from `git show main:`, written
to OUT at its package path (`Becoming/Foo.lean`), and its olean is taken, in this order, from OUT when
an earlier run of this script recorded the same step key there, from the checker's shared cache (the
checker's own `reuse`, so only a step the checker's runner stored and whose digest matches), or else
compiled with the checker's Lean (`lean -o Becoming/Foo.olean Becoming/Foo.lean`, cwd OUT,
LEAN_PATH OUT), as the checker's compile step does. The step keys are the checker's (`module_keys`), so a
restored olean is the one the checker compiled from exactly these bytes and imports. Nothing is written
outside OUT; a lock on OUT/.build.lock keeps two copies of this script from building at once. This is a
working build, not a receipt.
"""
import fcntl
import json
import os
from pathlib import Path
import subprocess
import sys
import time

sys.dont_write_bytecode = True
R = Path('/Users/ren/theories')
HERE = R / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
sys.path.insert(0, str(HERE))
import check_becoming as cb  # noqa: E402

OUT = Path(os.environ.get('EL7_OLEAN', '/Users/ren/tmp/el7/olean'))


def main_bytes(path):
    rel = path.resolve().relative_to(R)
    return subprocess.run(['git', '-C', str(R), 'show', f'main:{rel}'], capture_output=True, check=True).stdout


def main():
    targets = sys.argv[1:]
    assert targets, __doc__
    OUT.mkdir(parents=True, exist_ok=True)
    with open(OUT / '.build.lock', 'a+') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        index = cb.module_index()
        order = cb.closure(index, targets)
        sources = {name: main_bytes(index[name][0]) for name in order}
        command, binary, _ = cb.resolve_lean()
        context = [cb.audit_support.TOOLCHAIN, cb.audit_support.digest(binary.read_bytes())]
        keys = cb.module_keys(context, sources, order)
        manifest_path = OUT / 'MANIFEST.json'
        manifest = json.loads(manifest_path.read_text()) if manifest_path.is_file() else {}
        report = {'kept': 0, 'restored': [], 'compiled': {}, 'failed': None}
        for name in order:
            src = OUT / cb.source_file(name)
            olean = src.with_suffix('.olean')
            src.parent.mkdir(parents=True, exist_ok=True)
            if not src.is_file() or src.read_bytes() != sources[name]:
                src.write_bytes(sources[name])
            if olean.is_file() and manifest.get(name) == keys[name]:
                report['kept'] += 1
                continue
            if cb.reuse(keys[name], [olean], cb.RUNNER):
                report['restored'].append(name)
            else:
                tmp = olean.with_name(f'.{olean.name}.{os.getpid()}.tmp')
                started = time.perf_counter()
                run = subprocess.run(command + ['-o', str(tmp.relative_to(OUT)), cb.source_file(name)],
                                     cwd=OUT, env={**os.environ, 'LEAN_PATH': str(OUT)},
                                     capture_output=True, text=True)
                seconds = round(time.perf_counter() - started, 1)
                if run.returncode != 0:
                    report['failed'] = {'module': name, 'output': (run.stdout + run.stderr)[-4000:]}
                    break
                os.replace(tmp, olean)
                report['compiled'][name] = seconds
            manifest[name] = keys[name]
            manifest_path.write_text(json.dumps(manifest, indent=1, sort_keys=True))
        manifest_path.write_text(json.dumps(manifest, indent=1, sort_keys=True))
        (OUT / 'README.txt').write_text(
            'Oleans of the import closure of ' + ', '.join(targets) + ' as main has it, for the EL7 scratch work.\n'
            'Use: LEAN_PATH=' + str(OUT) + ' (with your own folder after it). Built by '
            '/Users/ren/tmp/el7/b/tools/build_closure.py, which restores from the checker cache by its step keys\n'
            'or compiles with lean -o as the checker does; MANIFEST.json gives each module\'s step key.\n'
            'main at build: ' + subprocess.run(['git', '-C', str(R), 'rev-parse', '--short', 'main'],
                                               capture_output=True, text=True).stdout.strip() + '\n')
        print(json.dumps({**report, 'restored': len(report['restored']), 'modules': len(order)}, indent=1))
        return 1 if report['failed'] else 0


if __name__ == '__main__':
    raise SystemExit(main())
