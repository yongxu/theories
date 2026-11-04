"""Run `research.py <args>` in the worktree with the original registry.py and completion.py (copied aside
before the change) in place of the changed ones. Each is compiled under its worktree path, so ROOT and
every constant derived from __file__ are what they were.

usage: python3 -B run_original.py <worktree> <dir holding the original files> <research.py args...>
"""
import runpy
import sys
import types
from pathlib import Path

worktree, originals = Path(sys.argv[1]).resolve(), Path(sys.argv[2])
sys.path.insert(0, str(worktree))
import tools.research  # noqa: E402

for name in ('registry', 'completion'):
    target = worktree / 'tools/research' / f'{name}.py'
    module = types.ModuleType(f'tools.research.{name}')
    module.__file__, module.__package__ = str(target), 'tools.research'
    sys.modules[module.__name__] = module
    exec(compile((originals / f'{name}.py').read_text(), str(target), 'exec'), module.__dict__)
    setattr(tools.research, name, module)
assert 'rewrites' not in vars(sys.modules['tools.research.registry'])
sys.argv = [str(worktree / 'tools/research/research.py'), *sys.argv[3:]]
runpy.run_path(sys.argv[0], run_name='__main__')
