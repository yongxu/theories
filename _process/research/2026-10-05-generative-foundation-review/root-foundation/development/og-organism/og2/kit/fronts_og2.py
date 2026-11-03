"""The status sentence on every front, at the landing, after main is merged: 'an institution has no model' becomes one
minimal model of one kind, as written on main at that moment (with or without the fronts' revision's words). Stops if
a front's sentence is not found once, or if any live front still says it after. Run from the checkout root."""
import re, subprocess
from pathlib import Path
L = "r-a-rule-rebuilt-from-the-members-it-limits"
ONE = f"[05 §12](chapters/05-COLLECTIVES.md#{L})"
edits = {
 "theories/becoming/ONE-PAGE.md": (r"An institution has no model yet, an organism one minimal model((?:(?:, read as such)? \[AI reading\])?) \((\[04 §8\]\([^)]*\))\)",
    lambda m: f"An organism and one kind of institution each have one minimal model{m.group(1)} ({m.group(2)}, {ONE})"),
 "theories/becoming/ONE-PAGE.zh.md": (r"一个制度尚无模型，一个有机体有一个最小模型((?:(?:，这是如此读出的)?［AI 读法］)?)（(\[04 §8\]\([^)]*\))）",
    lambda m: f"一个有机体与一种制度各有一个最小模型{m.group(1)}（{m.group(2)}、{ONE}）"),
 "theories/becoming/THE-THEORY-OF-BECOMING.md": (r"an institution has no model yet and an organism one minimal model((?:(?:, read as such)? \[AI reading\])?) \((\[04 §8\]\([^)]*\))\)",
    lambda m: f"an organism and one kind of institution each have one minimal model{m.group(1)} ({m.group(2)}, {ONE})"),
 "theories/becoming/THE-THEORY-OF-BECOMING.zh.md": (r"一个制度尚无模型，一个有机体有一个最小模型((?:(?:，这是如此读出的)?［AI 读法］)?)（(\[04 §8\]\([^)]*\))）",
    lambda m: f"一个有机体与一种制度各有一个最小模型{m.group(1)}（{m.group(2)}、{ONE}）"),
}
for f, (pat, rep) in edits.items():
    p = Path(f)
    t = p.read_text(encoding="utf-8")
    t2, n = re.subn(pat, rep, t)
    assert n == 1, (f, n)
    p.write_text(t2, encoding="utf-8")
    print("front:", f)
left = subprocess.run(["git", "grep", "-n", "-i", "-E", "institution has no model|制度尚无模型", "--", "theories/becoming", "README.md", "README.zh.md"], capture_output=True, text=True).stdout
assert not left, left
