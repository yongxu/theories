#!/bin/sh
# U4, the boundary record (scratch): build the forms, run the check and its negative controls.
#
# 1. scratch_build.py builds Becoming.U4Boundary from the checker cache and audits its axioms
#    (scratch-build.log).
# 2. Lean compiles Becoming.U4BoundaryCheck, which imports Lean, so scratch_build.py cannot build it.
#    Its #eval runs the tests on the two forms (check-run.log).
# 3. Lean runs the controls, each of which must fail (controls-run.log).
#
# Run from the repository root of a worktree.
set -eu
here=$(cd "$(dirname "$0")" && pwd)
lean_dir=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
toolchain=${LEAN_TOOLCHAIN:-$HOME/.elan/toolchains/leanprover--lean4---v4.29.1}

python3 "$lean_dir/scratch_build.py" "$here" Becoming.U4Boundary > "$here/scratch-build.log"

cd "$here/.build"
export LEAN_PATH="$PWD:$toolchain/lib/lean"
"$toolchain/bin/lean" -R .. -o Becoming/U4BoundaryCheck.olean ../Becoming/U4BoundaryCheck.lean \
  > ../check-run.log 2>&1 || { cat ../check-run.log; exit 1; }
"$toolchain/bin/lean" -R .. ../controls/U4BoundaryControls.lean \
  > ../controls-run.log 2>&1 || { cat ../controls-run.log; exit 1; }
echo "check and controls passed"
