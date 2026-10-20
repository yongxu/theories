"""Fine-tunes gpt-4.1-mini on data/direction.jsonl and data/control.jsonl
(OpenAI fine-tuning API, same hyperparameters for both) and writes
results/finetune-receipt.json with the job ids, file hashes and model ids.

python3 finetune.py submit   upload and start both jobs
python3 finetune.py status   poll; writes the receipt once both have succeeded
"""

from __future__ import annotations

import hashlib
import json
import os
import sys
import time
import urllib.request
import uuid
from pathlib import Path

BASE = "gpt-4.1-mini-2025-04-14"
HYPER = {"n_epochs": 3, "batch_size": 8, "learning_rate_multiplier": 1.0}
SEED = 20261021
API = "https://api.openai.com/v1"
KEY = os.environ["OPENAI_API_KEY"]
STATE = Path("results/finetune-jobs.json")


def call(method, path, body=None, files=None):
    headers = {"Authorization": "Bearer " + KEY}
    if files:
        boundary = uuid.uuid4().hex
        parts = []
        for k, v in body.items():
            parts.append(f"--{boundary}\r\nContent-Disposition: form-data; name=\"{k}\"\r\n\r\n{v}\r\n".encode())
        name, content = files
        parts.append(f"--{boundary}\r\nContent-Disposition: form-data; name=\"file\"; filename=\"{name}\"\r\n"
                     f"Content-Type: application/jsonl\r\n\r\n".encode() + content + b"\r\n")
        parts.append(f"--{boundary}--\r\n".encode())
        data = b"".join(parts)
        headers["Content-Type"] = f"multipart/form-data; boundary={boundary}"
    else:
        data = json.dumps(body).encode() if body is not None else None
        headers["Content-Type"] = "application/json"
    req = urllib.request.Request(API + path, data=data, headers=headers, method=method)
    with urllib.request.urlopen(req, timeout=120) as r:
        return json.load(r)


def submit():
    state = {}
    for name in ("direction", "control"):
        p = Path("data") / f"{name}.jsonl"
        content = p.read_bytes()
        f = call("POST", "/files", {"purpose": "fine-tune"}, (p.name, content))
        job = call("POST", "/fine_tuning/jobs", {
            "model": BASE, "training_file": f["id"], "seed": SEED, "suffix": f"in2-{name}",
            "method": {"type": "supervised", "supervised": {"hyperparameters": HYPER}}})
        state[name] = {"file_id": f["id"], "sha256": hashlib.sha256(content).hexdigest(), "job_id": job["id"],
                       "examples": content.count(b"\n")}
        print(name, job["id"], job["status"])
    STATE.parent.mkdir(exist_ok=True)
    STATE.write_text(json.dumps(state, indent=1))


def status():
    state = json.loads(STATE.read_text())
    done = True
    for name, s in state.items():
        j = call("GET", f"/fine_tuning/jobs/{s['job_id']}")
        s.update({"status": j["status"], "fine_tuned_model": j.get("fine_tuned_model"),
                  "trained_tokens": j.get("trained_tokens"), "error": j.get("error")})
        print(name, j["status"], j.get("fine_tuned_model"), j.get("trained_tokens"))
        done &= j["status"] == "succeeded"
    STATE.write_text(json.dumps(state, indent=1))
    if done:
        rec = {**state, "base": BASE, "hyperparameters": HYPER, "seed": SEED,
               "written": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())}
        Path("results/finetune-receipt.json").write_text(json.dumps(rec, indent=1))
        print("receipt written")


if __name__ == "__main__":
    {"submit": submit, "status": status}[sys.argv[1]]()
