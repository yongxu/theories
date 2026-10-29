#!/bin/zsh
S=/private/tmp/claude-501/-Users-ren-theories/7e73c253-c642-4ddd-ad8f-cc6d011978ec/scratchpad
PR=$S/ue17build
P=$HOME/repos/生生不息/.lake/packages
LP=$PR:$S/ue17/work
for d in $P/*; do [ -d $d/.lake/build/lib/lean ] && LP=$LP:$d/.lake/build/lib/lean; done
cd $PR
LEAN_PATH=$LP $HOME/.elan/toolchains/leanprover--lean4---v4.30.0-rc2/bin/lean "$@"
