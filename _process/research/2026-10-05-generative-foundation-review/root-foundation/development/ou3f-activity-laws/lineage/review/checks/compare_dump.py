#!/usr/bin/env python3
"""Reviewer's script, not for landing: compare two dumps of Dump.lean constant by constant.

usage: python3 -I compare_dump.py dump-main.out dump-new.out
Prints constants gone, added and changed (type, or value for definitions), each with its kind."""
import re
import sys


def blocks(path):
    out, module, current = {}, None, None
    for line in open(path, encoding="utf-8"):
        line = line.rstrip("\n")
        m = re.match(r"^== module (\S+):", line)
        if m:
            module = m.group(1)
            continue
        m = re.match(r"^(theorem|def|axiom|opaque|inductive|ctor|rec|quot) (\S+) : ", line)
        if m:
            current = m.group(2)
            out[current] = {"kind": m.group(1), "module": module, "text": [line]}
        elif current:
            out[current]["text"].append(line)
    return out


a, b = blocks(sys.argv[1]), blocks(sys.argv[2])
gone = sorted(set(a) - set(b))
added = sorted(set(b) - set(a))
moved = sorted(n for n in set(a) & set(b) if a[n]["module"] != b[n]["module"])
changed = sorted(n for n in set(a) & set(b) if a[n]["text"] != b[n]["text"])
print(f"constants: {len(a)} -> {len(b)}")
print(f"gone ({len(gone)}):")
for n in gone:
    print("  ", a[n]["kind"], n, a[n]["module"])
print(f"added ({len(added)}):")
for n in added:
    print("  ", b[n]["kind"], n, b[n]["module"])
print(f"moved between modules ({len(moved)}):")
for n in moved:
    print("  ", n, a[n]["module"], "->", b[n]["module"])
print(f"changed ({len(changed)}):")
for n in changed:
    ta = a[n]["text"]
    tb = b[n]["text"]
    # which part differs: the type (before a line starting with '  := ') or the value
    def split(t):
        i = next((k for k, l in enumerate(t) if l.startswith("  := ")), len(t))
        return t[:i], t[i:]
    (ya, va), (yb, vb) = split(ta), split(tb)
    print("  ", a[n]["kind"], n, "type" if ya != yb else "", "value" if va != vb else "")
