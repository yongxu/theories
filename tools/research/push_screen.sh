#!/bin/bash
# The push screen: what may not reach the public remote. Usage: push_screen.sh <base> <tip>
# base is the remote's main as last fetched or pushed, tip the commit to push. Exit 0 only if
# tip fast-forwards base and nothing below is found; every finding is printed.
set -u
o=$(git rev-parse --verify "${1:?base}^{commit}") || exit 2
s=$(git rev-parse --verify "${2:?tip}^{commit}") || exit 2
bad=0
if ! git merge-base --is-ancestor "$o" "$s"; then echo "not a fast-forward: $o is not an ancestor of $s"; bad=1; fi
# Private paths: chats, memories, a friend's conversation and its draft, scratch, guardian-anarchy, local config, Lean builds.
p=$(git diff --name-only "$o" "$s" | grep -E '^(sources/1[238]-|drafts/2026-10-02-friend|tmp/|work/|experiments/guardian-anarchy/|\.claude/)|(^|/)\.lake/')
[ -n "$p" ] && { echo "private paths:"; echo "$p"; bad=1; }
b=$(git diff --numstat "$o" "$s" | awk '$1=="-"{print $3}')
[ -n "$b" ] && { echo "binary files (look at each):"; echo "$b"; bad=1; }
# New files only for size: a generated index (lean-index.json, ~17 MB) changes at most landings and is already public.
l=$(git diff --name-only --diff-filter=A "$o" "$s" | while read -r f; do z=$(git cat-file -s "$s:$f" 2>/dev/null); [ -n "$z" ] && [ "$z" -gt 2000000 ] && echo "$f $z"; done)
[ -n "$l" ] && { echo "files over 2 MB:"; echo "$l"; bad=1; }
k=$(git diff "$o" "$s" | grep -E '^\+' | grep -E -i 'sk-or-v1-[a-z0-9]{10}|sk-ant-[a-z0-9-]{10}|hf_[A-Za-z0-9]{20}|(api[_-]?key|secret|token|password)\s*[:=]\s*["'"'"']?[A-Za-z0-9_\-]{16,}|-----BEGIN [A-Z ]*PRIVATE KEY|ghp_[A-Za-z0-9]{20}' | cut -c1-160)
[ -n "$k" ] && { echo "possible keys:"; echo "$k"; bad=1; }
[ $bad -eq 0 ] && echo "push screen clean: $(git rev-parse --short "$o")..$(git rev-parse --short "$s"), $(git diff --shortstat "$o" "$s")"
exit $bad
