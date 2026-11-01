"""RV21c's shared list and helpers: the core receipt and the periphery receipts renewed after it, in run order.

The periphery receipts are decided at run time by `plan_receipts.py` (out/receipts.json): every checker whose
record-bound runs bind core bytes that differ from the run base. Without that file (before the runs) the list is the
25 found on main on 31 October: PE2's (`pe2-propext-uses/uses.py` RECEIPTS, the core's excluded), the ones PR1 renewed
on 20 October, then regime-reals and representation. Each receipt is named by its pointer, the `*-verification.json`
its checker rewrites at every run; the checker is the first file the pointer's `checker_sha256` names, beside it.
"""
import json
from pathlib import Path
import subprocess
import sys

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[5]
LEAN = "experiments/integrated-correction/general-framework/generative-basis/lean/"
PKG = LEAN + "becoming"
CORE_POINTER = PKG + "/becoming-verification.json"
CORE_RUNS = PKG + "/becoming-checks"
RECORDS = "theories/becoming/results/records"
OUT = HERE / "out"
KIT_PATH = str(HERE.relative_to(REPO))

sys.path.insert(0, str(HERE.parent / "pe2-propext-uses"))
from uses import RECEIPTS as PE2  # noqa: E402

assert PE2[-1] == CORE_POINTER
DEFAULT = PE2[:-1] + [
    LEAN + "regime/regime-reals-verification.json",
    LEAN + "representation/representation-verification.json",
]
PLAN = OUT / "receipts.json"
RECEIPTS = json.loads(PLAN.read_text())["receipts"] if PLAN.exists() else DEFAULT
assert RECEIPTS and len(set(RECEIPTS)) == len(RECEIPTS) and CORE_POINTER not in RECEIPTS
RF = "_process/research/2026-10-05-generative-foundation-review/root-foundation"
STUDY = RF + "/BECOMING-RENEWAL-READING.md"
CHAPTER = "theories/becoming/chapters/08-METHOD.md"
# Every path RV21c rewrites that a record may pin: its texts, the pointers its checkers rewrite, the generated data.
MINE = {CHAPTER, STUDY, CORE_POINTER, *RECEIPTS, "theories/becoming/results/data/shared-laws.json",
        RF + "/THEOREM-CONNECTIVITY.json", RF + "/THEOREM-CONNECTIVITY-APART.json"}
# The home sections axiom_texts.py brought to a renewed receipt's reports are RV21c's edits too.
if (OUT / "axiom_texts.json").exists():
    MINE |= {c["file"] for v in json.loads((OUT / "axiom_texts.json").read_text()).values() for c in v["chapter"]}
# The helpers a receipt's checker_sha256 names besides its own checker, by name.
HELPERS = {"check_becoming.py": PKG + "/check_becoming.py",
           "check.py": LEAN + "universal-ethics/generative-capacity/check.py"}


def helper_path(pointer, name):
    """Where a file named in a receipt's checker_sha256 lives: the shared helpers, or beside the pointer."""
    return HELPERS.get(name) or str(Path(pointer).parent / name)


def stem(pointer):
    return Path(pointer).stem


def load(pointer, rev=None):
    """A receipt as the working tree holds it, or at a git revision."""
    if rev:
        return json.loads(subprocess.check_output(["git", "show", f"{rev}:{pointer}"], cwd=REPO))
    return json.loads((REPO / pointer).read_text())


def checker(pointer, rev="HEAD"):
    """The checker that writes this pointer: the first file its checker_sha256 names, beside it."""
    return str(Path(pointer).parent / next(iter(load(pointer, rev)["checker_sha256"])))


def runs_folder(pointer, d):
    """The folder holding this checker's retained runs (`<name>-checks`)."""
    return str(Path(pointer).parent / d["retained_run"].split("/")[0])


def run_receipt(pointer, d):
    """The retained run's own verification.json for the receipt `d` that this pointer held."""
    return str(Path(pointer).parent / d["retained_run"] / "verification.json")


def bound_here(path, pointer, folder):
    """Whether a record's receipt path names this checker: its pointer, or any of its retained runs."""
    return path == pointer or path.startswith(folder + "/")


def source_drift():
    """research.py check's source_drift list: the (record, path) pairs whose cited part of a source changed."""
    out = subprocess.run([sys.executable, "-B", "tools/research/research.py", "check"], cwd=REPO,
                         capture_output=True, text=True).stdout
    return json.loads(out[out.index("{"):out.rindex("}") + 1]).get("source_drift", [])


def git(*args, check=True):
    return subprocess.run(["git", *args], cwd=REPO, text=True, capture_output=True, check=check).stdout


def copies():
    """Core-bound bindings whose source is a copy kept inside an old run folder, not a package file on main:
    (record id, `<stamp>/<file>`)."""
    out = []
    for path in sorted((REPO / RECORDS).glob("*.json")):
        rec = json.loads(path.read_text())
        for b in rec.get("proof_bindings", []):
            r = b.get("receipt", "")
            if (r == CORE_POINTER or "/becoming-checks/" in r) and "/becoming-checks/" in b.get("source", ""):
                out.append((rec.get("id", path.stem), b["source"].split("/becoming-checks/")[1]))
    return out
