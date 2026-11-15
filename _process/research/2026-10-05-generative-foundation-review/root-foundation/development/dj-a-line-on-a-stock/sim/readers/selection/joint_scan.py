# AI-written (reader "selection", 16 Nov 2026). Read-only scan: declarations whose statement
# (from the keyword up to ":=") names both a descent/count word and an alikeness word.
import re, os, sys
root = "/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming"
A = re.compile(r"\bkids\b|offspringCount|offspringNumber|Generations|DescendsAt|\bborn\b|concordAt|discordAt")
B = re.compile(r"SelectsThrough|AlikeThrough|ScoresThrough|AlikeThroughUpTo|GivesAlike|RespondsThroughCoupling")
start = re.compile(r"^(theorem|def|structure|abbrev|instance)\s+(\S+)")
hits = []
for fn in sorted(os.listdir(root)):
    if not fn.endswith(".lean"): continue
    lines = open(os.path.join(root, fn), encoding="utf-8").read().split("\n")
    i = 0
    while i < len(lines):
        m = start.match(lines[i])
        if m:
            j = i; buf = []
            while j < len(lines) and j < i + 60:
                buf.append(lines[j])
                if ":=" in lines[j] or lines[j].rstrip().endswith("where"): break
                j += 1
            s = "\n".join(buf)
            if A.search(s) and B.search(s):
                hits.append((fn, i + 1, m.group(2)))
            i = j + 1
        else:
            i += 1
for h in hits: print(*h)
print("total", len(hits))
