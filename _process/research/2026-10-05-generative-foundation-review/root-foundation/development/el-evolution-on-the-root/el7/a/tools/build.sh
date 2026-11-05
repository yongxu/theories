#!/bin/zsh
# Compile scratch modules of /Users/ren/tmp/el7/a against the shared EL7 oleans.
# The overlay /Users/ren/tmp/el7/a/olean holds symlinks to the shared oleans (read only) and the
# oleans built here (Typicality, EL7a*), since Lean resolves a package from the first search-path
# entry holding its root directory.
# usage: build.sh Module1 [Module2 ...]   (module names under Becoming/, e.g. EL7aCohorts)
set -e
LEAN=/Users/ren/.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean
A=/Users/ren/tmp/el7/a
cd $A
export LEAN_PATH=$A/olean
for m in "$@"; do
  echo "== compile Becoming.$m"
  rm -f $A/olean/Becoming/$m.olean
  /usr/bin/time -p $LEAN -o $A/olean/Becoming/$m.olean Becoming/$m.lean
done
