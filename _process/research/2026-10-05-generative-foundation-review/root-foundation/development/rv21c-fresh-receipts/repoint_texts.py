#!/usr/bin/env python3
"""RV21c: re-point the records drifting by RV21c's own edits only (repoint_ue25.py's pattern).

RV21c changes, besides the run folders and the records `repoint_all.py` and `swap_stamps.py` handle: 08 §3's receipt
sentence (`texts.py`), the study (one section appended), the core pointer, the periphery pointers and the generated
data the core receipt feeds (shared-laws.json, the connectivity, if they change). `research.py check`'s drift list is
filtered to those paths, so another session's drift stays with its owner and is printed for it. Every drifting pair is
listed with its changed sections first; in 08 the only section that may change is §3, in the study only the new
section, and in a chapter whose home section axiom_texts.py brought to a renewed receipt (out/axiom_texts.json) only
that section; a pair outside them stops the script, to be read and settled by hand. Then `tools/research/repoint.py
--drift-json` re-points exactly the kept pairs.

usage (from the checkout root, after texts.py): repoint_texts.py [--apply]
"""
import json
from pathlib import Path
import subprocess
import sys
import tempfile

from kit import CHAPTER, MINE, OUT, RECEIPTS, REPO, STUDY, stem

APPLY = "--apply" in sys.argv
EXPECTED = {CHAPTER: {"3. The pure core and the periphery", "3-the-pure-core-and-the-periphery",
                      "pure-core-and-periphery"}}
AXIOMS = json.loads((OUT / "axiom_texts.json").read_text()) if (OUT / "axiom_texts.json").exists() else {}
for _v in AXIOMS.values():
    for _c in _v["chapter"]:
        assert _c["file"] != CHAPTER, "a home section in 08: decide by hand which sections may change"
        EXPECTED.setdefault(_c["file"], set()).add(_c["heading"])


def reason():
    status = json.loads((OUT / "status.json").read_text())
    texts = json.loads((OUT / "texts.json").read_text())
    passed = sum(1 for p in RECEIPTS if status[stem(p)]["passed"])
    sentence = ("the receipt only, every count the same" if not texts["stale_08"] else
                f"it named {texts['named']}, from before a core landing that did not rewrite it; now the fresh "
                "receipt with its counts, the same as the core receipt at the run base")
    return (f"RV21c: the fresh core receipt and {passed} of the {len(RECEIPTS)} periphery receipts renewed; 08 §3's "
            f"receipt sentence ({sentence}); a study section appended; the core and periphery pointers rewritten by "
            "their checkers; the generated data the core receipt feeds"
            + (f"; the axiom sentences of {len(AXIOMS)} records brought to their renewed receipts' reports, with the "
               "home sections that state them" if AXIOMS else "")
            + "; repoint_texts.py checked, section by section, that only 08 §3, the new study section"
            + (" and those home sections" if any(v["chapter"] for v in AXIOMS.values()) else "")
            + " changed in the texts")


def main():
    out = subprocess.run([sys.executable, "-B", "tools/research/research.py", "check"], cwd=REPO,
                         capture_output=True, text=True).stdout
    data = json.loads(out[out.index("{"):out.rindex("}") + 1])
    drift = data.get("source_drift", [])
    kept = [x for x in drift if x["path"] in MINE]
    left = [(x["id"], x["path"]) for x in drift if x["path"] not in MINE]
    unexpected = []
    for x in kept:
        sections = {s.lstrip("#").strip() for s in (x.get("changed_sections") or [])}
        if x["path"] in EXPECTED and (not sections or not sections <= EXPECTED[x["path"]]):
            unexpected.append((x["id"], x["path"], sorted(sections)))
        if x["path"] == STUDY and sections and not all("RV21c" in s or "rv21c" in s for s in sections):
            unexpected.append((x["id"], x["path"], sorted(sections)))
    print(f"re-pointing {len(kept)} pairs in {len({x['id'] for x in kept})} records:")
    for x in kept:
        print("  ", x["id"], x["path"], x.get("changed_sections"))
    print("left to their owners:", left)
    assert not unexpected, ("drift outside the sections RV21c writes: read it, then settle it by hand", unexpected)
    # The records the study names as re-pointed for the rewritten home sections are exactly these.
    homes = {c["file"] for v in AXIOMS.values() for c in v["chapter"]}
    if homes:
        named = json.loads((OUT / "texts.json").read_text()).get("home_drift", [])
        found = sorted({x["id"] for x in kept if x["path"] in homes})
        assert found == named, ("the home-section drift is not the one the study lists", found, named)
    if not kept:
        print("repoint (texts): nothing to re-point")
        return
    with tempfile.NamedTemporaryFile("w", suffix=".json", delete=False) as f:
        json.dump({"source_drift": kept}, f)
    result = subprocess.run([sys.executable, "-B", "tools/research/repoint.py", "--reason", reason(), "--drift-json",
                             f.name] + (["--apply"] if APPLY else []), cwd=REPO, capture_output=True, text=True)
    Path(f.name).unlink()
    print(result.stdout[-4000:], result.stderr[-2000:])
    assert result.returncode == 0, result.returncode
    print("repoint (texts):", json.loads(result.stdout)["records"], "records", "written" if APPLY else "(dry run)")


if __name__ == "__main__":
    main()
