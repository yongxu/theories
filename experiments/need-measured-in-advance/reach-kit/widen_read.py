"""T1N's and T1R's rules on R1 with GLIFWC's spring lake-years added: writes ../results/reach-with-glifwc.json.

    python3 -I -B reach-kit/widen_read.py GRID_FOLDER FALL_LISTED_CSV FALL_GENEROUS_CSV ARCHIVES GRANTED_OUT_CSV     # prints JSON

GRID_FOLDER is widen_struct.py's 'wide' folder (lake, year and label, with R5); its three other readings of GLIFWC's labels
are read from beside it. FALL_LISTED_CSV is its list of lake-years the fall tables list. GRANTED_OUT_CSV is written here:
that list with a fall survey added at every estimate from 1997, so that a need can be fitted where the list leaves it
short. T1N's worlds' values are then put on the grid by structdry.py. No value of any record is read.
"""

import csv
import hashlib
import json
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent))
import reach as RE    # noqa: E402
import t1n            # noqa: E402


def read_fall(path):
    with open(path, newline="", encoding="utf-8-sig") as f:
        return {(row["WBIC"].strip(), int(row["Year"])) for row in csv.DictReader(f)}


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def by_reading(grid, listed, union):
    """The fit by exact match and the ceiling on V1's lakes, by how GLIFWC's labels are read. R1's NATURAL is as it is in all."""
    out = {}
    for name, what in (("wide", "NR, C-NR and C- natural, a code not read natural (the grid above)"),
                       ("wide-unread-not", "NR, C-NR and C- natural, a code not read not natural"),
                       ("strict", "NR alone, T1N's own map, a code not read natural"),
                       ("strict-unread-not", "NR alone, T1N's own map, a code not read not natural")):
        folder = Path(grid).parent / name
        pairs = t1n.pairs(list(RE.skeletons(folder, listed).values()), labels=True)
        both = t1n.pairs(list(RE.skeletons(folder, union).values()), labels=True)
        out[what] = {"the fit by exact match: lake-years, lakes": [len(pairs), len({q[0] for q in pairs})],
                     "the fit with fall-generous.csv added: lake-years, lakes": [len(both), len({q[0] for q in both})],
                     "V1's lakes at most": RE.reach(folder)["T1N's V1"]["lakes that can be read so at most, whatever the values"]}
    return out


def worlds(grid, fall, archives):
    got = subprocess.run([sys.executable, "-I", "-B", str(HERE / "structdry.py"), str(HERE.parent), str(grid), str(fall), str(archives)],
                         capture_output=True, text=True, check=True)
    return json.loads(got.stdout)


def main():
    grid, listed_csv, generous_csv, archives, granted_csv = sys.argv[1:6]
    listed, generous = read_fall(listed_csv), read_fall(generous_csv)
    lakes = RE.skeletons(grid)
    # Every estimate from 1997 granted a fall survey, on top of what the tables list.
    granted = set(listed) | {(lk["id"], yr) for lk in lakes.values() for yr in lk["adults"] if yr >= 1997}
    with open(granted_csv, "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["WBIC", "Year"])
        for a, b in sorted(granted):
            w.writerow([a, b])
    union = listed | generous
    out = {
        "what": "T1N's and T1R's frozen rules on R1 with GLIFWC's spring lake-years added (grid-with-glifwc.csv: lake, year and "
                "label, read by OCR and not checked against the pages; GLIFWC's NR, C-NR and C- and a code not read as natural; "
                "a repeated lake-year natural if any row is), with no value of any record",
        "inputs": {"grid-with-glifwc.csv": sha(Path(grid) / "adult_estimates.csv"), "stocking.csv": sha(Path(grid) / "stocking.csv"),
                   "fall-with-glifwc.csv": sha(listed_csv), "fall-generous.csv": sha(generous_csv),
                   "fall-with-glifwc-granted.csv": sha(granted_csv)},
        "ceilings (reach.py)": {
            "a fall survey in every year of every lake": RE.reach(grid),
            "fall surveys where fall-with-glifwc.csv lists them": RE.reach(grid, listed)},
        "the fit where fall-with-glifwc.csv or fall-generous.csv lists them": (lambda p: [len(p), len({q[0] for q in p})])(
            t1n.pairs(list(RE.skeletons(grid, union).values()), labels=True)),
        "by how GLIFWC's labels are read, on fall-with-glifwc.csv": by_reading(grid, listed, union),
        "T1N's worlds on the grid, fall surveys as fall-with-glifwc.csv lists them": worlds(grid, listed_csv, archives),
        "T1N's worlds on the grid, with fall-with-glifwc-granted.csv": worlds(grid, granted_csv, archives),
    }
    print(json.dumps(out, indent=1))


if __name__ == "__main__":
    main()
