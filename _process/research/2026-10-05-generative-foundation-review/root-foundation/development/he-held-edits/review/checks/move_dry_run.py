"""The history move's dry run, read-only: research.py move's own planner (tools/research/moves.Plan) on a checkout,
with the package pin dropped from the settings in memory (the config file is not edited) and `git status` replaced
by a byte comparison with HEAD (so no index refresh is written). Prints the planner's report.
usage: python3 -B move_dry_run.py CHECKOUT PLAN.tsv"""
import json, subprocess, sys
from pathlib import Path
root, plan_path = Path(sys.argv[1]).resolve(), Path(sys.argv[2])
sys.dont_write_bytecode = True
sys.path.insert(0, str(root))
from tools.research import moves, paths as path_roles
settings = path_roles.load_config(root)
PIN = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/**'
assert settings['move_pinned'].count(PIN) == 1
settings['move_pinned'] = [p for p in settings['move_pinned'] if p != PIN]
def status(self, olds):
    out = {'modified': set()}
    for old in olds:
        head = subprocess.run(['git', '-C', str(root), 'show', f'HEAD:{old}'], capture_output=True).stdout
        if (root / old).read_bytes() != head:
            out['modified'].add(old)
    return out
moves.Plan.status = status
entries = moves.Plan.read(plan_path)
plan = moves.Plan(entries, root=root, settings=settings, batch='HE-history', plan_name=plan_path.stem).analyse()
report = plan.report(full=True)
print(json.dumps(report, ensure_ascii=False, indent=1)[:6000])
