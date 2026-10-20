"""R52: bind the landing receipt in the records citing Becoming.JointDraw. usage: bind_receipt.py RUN"""
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[6]
LEAN = "experiments/integrated-correction/general-framework/generative-basis/lean/becoming"
SRC = f"{LEAN}/Becoming/JointDraw.lean"
run = sys.argv[1]
receipt = f"{LEAN}/becoming-checks/{run}/verification.json"
sha = lambda p: hashlib.sha256((ROOT / p).read_bytes()).hexdigest()
v = json.loads((ROOT / receipt).read_text())
assert v["status"] == "passed" and v["source_sha256"]["Becoming.JointDraw"] == sha(SRC)
for name in ["what-a-rise-draws-from-beyond", "ranking-under-readings"]:
    p = ROOT / f"theories/becoming/results/records/{name}.json"
    d = json.loads(p.read_text())
    for r in d["references"]:
        if r.get("path") == SRC and r.get("role") == "proof":
            r["sha256"] = sha(SRC)
    if not any(r.get("path") == receipt for r in d["references"]):
        d["references"].append({"path": receipt, "role": "receipt", "sha256": sha(receipt)})
    d["proof_bindings"] = [b for b in d["proof_bindings"] if b["source"] != SRC] + [{
        "source": SRC, "receipt": receipt, "sha256_pointer": "/source_sha256/Becoming.JointDraw",
        "success_pointer": "/status", "success_value": "passed"}]
    p.write_text(json.dumps(d, indent=2, ensure_ascii=False) + "\n")
    print("bound", name)
