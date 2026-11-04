"""TR2 Stage B, the run: checks, the smoke run, the phases and the reading. No model call through an
API; each checkpoint is run locally from files that Ren's yes downloads.

    python3 -B tr2_run.py check --checkpoint ID --folder DIR
    python3 -B tr2_run.py smoke --checkpoint ID --folder DIR [--device cpu|mps] [--threads N]
    python3 -B tr2_run.py run   --checkpoint ID --folder DIR [--device ...] [--threads N]
    python3 -B tr2_run.py read

ID is one of MODELS.json's checkpoints (qwen-base, qwen-tuned, olmo-base, olmo-tuned); DIR the folder
holding its files, downloaded at its revision. Before any pass, smoke and run refuse unless:
- every frozen file equals its hash in the newest link of this freeze's chain (open/FROZEN.sha256,
  then any addendum's in open/addenda/), each link committed once, and the working copy clean;
- every file MODELS.json lists for the checkpoint is in DIR with its size and hash, and no other file a
  loader could read is there;
- Python is 3.11 and every package MODELS.json pins is at its version;
- the engine reports the checkpoint's layers and width (MODELS.json's), bfloat16, the device and
  threads asked for, and deterministic algorithms;
- for run, the checkpoint's newest smoke run said go on, under the same link, device and threads (a
  newest smoke run with no report, stopped before its end, says no), and no folder of the checkpoint is
  whole: a whole folder ends that checkpoint's run.
The run calls the pass (tr2_pass.py) itself; the engine supplies torch, the model, the tokenizer and
the device. Each pass's states and logits must be bfloat16, made on that device.
A run writes only into results/<checkpoint>-<engine>-<device>-t<threads>/, <engine> the first 12 hex
digits of the engine file's hash, so passes made under two engines, devices or thread counts never
share a folder: meta.json (fixed at its first pass: the checkpoint, the device, the threads, what the
engine reports and its code's hash; the links listed as they come), groups.jsonl (one line per group,
written whole once its passes are made), and states/ (the kept states, each named in its pass's record
with its hash). A run stopped part way goes on at the first group not written; a last line torn by the
stop is moved, unchanged, to groups.jsonl.torn-<k> beside it and the group made again. The phases go
pilot, main, recognition, and nothing in one moves another's plan.
read reads each checkpoint alone, and writes results/readout.json whatever any one checkpoint gives. A
checkpoint is read from the one folder whose phases are all whole. A folder is refused, listed with
why and not read, where its meta is not a run of that checkpoint under an engine and links of this
freeze's chain, or a record is one the plan does not hold, differs from the plan in its phase,
content, kind, arms or keeping of states, has a field missing or a prompt hash other than the one its
group rebuilds, names a state file that differs from its hash, or is not one whole line (a torn last
line aside: it leaves the folder partial, read as absent and left in place). A checkpoint with two
whole folders is refused (the run never makes a second); one with no whole folder is listed as
partial, with what is whole. The folders not read are named.
"""

import argparse
import hashlib
import importlib.metadata
import importlib.util
import inspect
import json
import os
import sys
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
TOLD_DIR = HERE.parent / "told"


def _freeze1_run():
    """Freeze 1's run.py, unchanged, for its frozen chain (chain, frozen_check, git); loaded with told/
    on the path so that its own imports are its own."""
    sys.path.insert(0, str(TOLD_DIR))
    try:
        spec = importlib.util.spec_from_file_location("told_run", TOLD_DIR / "run.py")
        mod = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(mod)
    finally:
        sys.path.remove(str(TOLD_DIR))
    return mod


R = _freeze1_run()
sys.path.insert(0, str(HERE))
import tr2_conditions as C      # noqa: E402
import tr2_pass as PASS         # noqa: E402
import tr2_plan as P            # noqa: E402
import tr2_rule as RU           # noqa: E402

REPO = R.REPO
OPEN = HERE.relative_to(REPO)                    # experiments/formations-that-read/open
MODELS = json.loads((HERE / "MODELS.json").read_text(encoding="utf-8"))
CHECKPOINTS = {c["id"]: c for c in MODELS["checkpoints"]}
# What an addendum to this freeze may change: the engine (how a checkpoint is loaded and placed, never
# the pass) and the dry run with its output. Every other file a link lists is fixed: the models and
# their hashes, the conditions, the plan, the pass, the rule, the power check, this run and its checks.
MAY_CHANGE = frozenset(str(OPEN / f) for f in ("tr2_engine.py", "tr2_dry_run.py", "results/dry-run.json"))
RESULTS = HERE / "results"
SMOKE_DIR = RESULTS / "smoke"


def frozen():
    return R.frozen_check(REPO, OPEN, MAY_CHANGE)


def refuse(ok, why):
    """A refusal that no interpreter flag removes."""
    if not ok:
        raise SystemExit(f"refused: {why}")


ENGINE = str(OPEN / "tr2_engine.py")


def engine_hashes(link):
    """The engine file's hash in every link of the chain: the engines a folder may be made under."""
    return {h[ENGINE] for h in link["chain"].values() if ENGINE in h}


def sha_file(p, chunk=1 << 24):
    h = hashlib.sha256()
    with open(p, "rb") as f:
        while True:
            b = f.read(chunk)
            if not b:
                return h.hexdigest()
            h.update(b)


def git_blob(p):
    data = Path(p).read_bytes()
    return hashlib.sha1(b"blob %d\0" % len(data) + data).hexdigest()


def check_files(spec, folder):
    """Every file the checkpoint lists, with its size and hash, and no other file a loader could read
    (the repository's files MODELS.json lists as not loaded aside, and anything under a dot folder,
    such as a download's .cache/); the problems found."""
    bad = []
    listed = {f["path"] for f in spec["files"]}
    skip = set(MODELS["not_loaded"])
    if Path(folder).is_dir():
        for q in sorted(Path(folder).rglob("*")):
            rel = q.relative_to(folder)
            if q.is_file() and not any(part.startswith(".") for part in rel.parts) \
                    and str(rel) not in listed and rel.parts[0] not in skip:
                bad.append(f"{rel}: not listed")
    for f in spec["files"]:
        p = Path(folder) / f["path"]
        if not p.is_file():
            bad.append(f"{f['path']}: missing")
            continue
        if p.stat().st_size != f["size"]:
            bad.append(f"{f['path']}: size {p.stat().st_size}, not {f['size']}")
            continue
        got = sha_file(p) if "sha256" in f else git_blob(p)
        if got != f.get("sha256", f.get("git_blob")):
            bad.append(f"{f['path']}: hash differs")
    return bad


def check_packages(version=importlib.metadata.version, python=sys.version_info):
    bad = [] if tuple(python[:2]) == (3, 11) else [f"python {python[0]}.{python[1]}, not 3.11"]
    for name, pin in MODELS["packages"].items():
        try:
            v = version(name)
        except importlib.metadata.PackageNotFoundError:
            v = None
        if v != pin["version"]:
            bad.append(f"{name} {v}, not {pin['version']}")
    return bad


def preflight(ckpt, folder, packages=True):
    link = frozen()
    if ckpt not in CHECKPOINTS:
        raise SystemExit(f"no checkpoint {ckpt}")
    bad = check_files(CHECKPOINTS[ckpt], folder) + (check_packages() if packages else [])
    if bad:
        raise SystemExit("refused: " + "; ".join(bad))
    return link


# --- making passes ------------------------------------------------------------------------------

FIELDS = {"input_sha256", "n_tokens", "layer_sha256", "logits_sha256", "p", "greedy", "state", "dist",
          "dtype", "logits_dtype", "device"}
KEPT = FIELDS - {"state", "dist"}
RECORD = KEPT | {"arm", "prompt_sha256", "t0", "t1", "tv_vs_base"}
GROUP = {"group", "phase", "content", "kind", "keep_state", "passes"}
BF16 = "torch.bfloat16"


def letter_maps(engine):
    """For each kind's letters, the token ids that decode to each (the vocabulary decoded once)."""
    out, decoded = {}, None
    for names in C.LETTERS.values():
        out[tuple(names)], decoded = PASS.letters(engine.tok, names, decoded)
    return out


def check_engine(desc, ckpt, device, threads, real=True):
    """What the engine reports, against MODELS.json (for a real engine) and against what was asked."""
    spec = CHECKPOINTS[ckpt]
    refuse(desc["dtype"] == BF16, f"the engine holds {desc['dtype']}, not bfloat16")
    refuse(desc["device"] == device and desc["threads"] == threads and desc["deterministic"] is True,
           f"the engine reports {desc['device']}, {desc['threads']} threads, deterministic "
           f"{desc['deterministic']}, not {device}, {threads}, True")
    if real:
        refuse((desc["layers"], desc["hidden"]) == (spec["layers"], spec["hidden"]),
               f"the engine reports {desc['layers']} layers of {desc['hidden']}, not MODELS.json's")


def prompt_sha(prompt):
    return hashlib.sha256(json.dumps(prompt, sort_keys=True).encode()).hexdigest()


def make_group(engine, g, role, desc, states_dir, lmap):
    """Every pass of a group in its arms' order, each made by the fixed pass, then the total variation of
    each arm against the group's reference arm (base, or the pilot's cue down). Returns its record."""
    names = P.letters_of(g)
    out, dists = [], {}
    for arm in g["arms"]:
        pr = P.prompt_of(g, arm, role)
        t0 = time.time()
        r = PASS.forward(engine.torch, engine.model, engine.tok, pr, engine.spec["family"], engine.device,
                         lmap[tuple(names)], g["keep_state"])
        t1 = time.time()
        refuse(set(r) == FIELDS, f"the pass returned {sorted(r)}")
        refuse(r["dtype"] == BF16 and r["logits_dtype"] == BF16, f"the pass made {r['dtype']}, {r['logits_dtype']}")
        refuse(r["device"].split(":")[0] == desc["device"], f"the pass was made on {r['device']}")
        refuse(len(r["layer_sha256"]) == desc["layers"] + 1, "the pass returned another number of states")
        refuse(set(r["p"]) == set(names) | {"other"} and all(0.0 <= v <= 1.0 for v in r["p"].values()),
               "the pass returned other probabilities")
        rec = {"arm": arm, "prompt_sha256": prompt_sha(pr), **{k: r[k] for k in KEPT},
               "t0": round(t0, 3), "t1": round(t1, 3)}
        if g["keep_state"]:
            refuse(len(r["state"]) == (desc["layers"] + 1) * desc["hidden"] * 4, "the state's length differs")
            name = f"{g['id'].replace('/', '_')}_{arm}.f32"
            (Path(states_dir) / name).write_bytes(r["state"])
            rec["state_file"], rec["state_sha256"] = name, hashlib.sha256(r["state"]).hexdigest()
        dists[arm] = r["dist"]
        out.append(rec)
    ref = "pilot-down" if g["kind"] == "pilot" else "base"
    for rec in out:
        rec["tv_vs_base"] = None if rec["arm"] == ref else PASS.tv(dists[rec["arm"]], dists[ref])
    return {"group": g["id"], "phase": g["phase"], "content": g["content"], "kind": g["kind"],
            "keep_state": g["keep_state"], "passes": out}


def torn_last(raw):
    """Where a last line torn by a stop begins (no newline at its end, or not whole JSON), or None."""
    if not raw:
        return None
    body = raw[:-1] if raw.endswith(b"\n") else raw
    start = body.rfind(b"\n") + 1
    last = raw[start:]
    try:
        whole = raw.endswith(b"\n") and (not last.strip() or json.loads(last) is not None)
    except json.JSONDecodeError:
        whole = False
    return None if whole else start


def written(folder, torn_ok=False):
    """The folder's group records. With torn_ok, a torn last line is read as absent (the folder is then
    partial; the file is not touched); any other line that is not one whole record is refused."""
    p = Path(folder) / "groups.jsonl"
    if not p.exists():
        return []
    raw = p.read_bytes()
    cut = torn_last(raw) if torn_ok else None
    out = []
    for k, x in enumerate((raw if cut is None else raw[:cut]).decode("utf-8").splitlines()):
        if not x.strip():
            continue
        try:
            out.append(json.loads(x))
        except json.JSONDecodeError:
            raise SystemExit(f"refused: {p} line {k + 1} is not a whole record")
    return out


def repair_torn(folder):
    """A last line torn by a stop is moved, unchanged, to groups.jsonl.torn-<k>, kept, and cut from the
    log, so its group is made again. Any other bad line is left for written() to refuse. Returns the
    side file, or None."""
    p = Path(folder) / "groups.jsonl"
    if not p.exists():
        return None
    raw = p.read_bytes()
    start = torn_last(raw)
    if start is None:
        return None
    k = 0
    while (Path(folder) / f"groups.jsonl.torn-{k}").exists():
        k += 1
    side = Path(folder) / f"groups.jsonl.torn-{k}"
    with open(side, "wb") as f:
        f.write(raw[start:])
        f.flush()
        os.fsync(f.fileno())
    with open(p, "r+b") as f:
        f.truncate(start)
        f.flush()
        os.fsync(f.fileno())
    return side


def append(folder, rec):
    with open(Path(folder) / "groups.jsonl", "a", encoding="utf-8") as f:
        f.write(json.dumps(rec, sort_keys=True) + "\n")
        f.flush()
        os.fsync(f.fileno())


def open_folder(folder, meta):
    """The folder's meta, written at the first pass and the same at every later run."""
    folder = Path(folder)
    (folder / "states").mkdir(parents=True, exist_ok=True)
    mp = folder / "meta.json"
    if mp.exists():
        old = json.loads(mp.read_text(encoding="utf-8"))
        fixed = ("checkpoint", "device", "threads", "engine", "kind")
        if any(old[k] != meta[k] for k in fixed):
            raise SystemExit(f"refused: {folder} was begun under {[(k, old[k]) for k in fixed]}")
        if meta["link"] not in old["links"]:
            old["links"].append(meta["link"])
            mp.write_text(json.dumps(old, indent=1) + "\n", encoding="utf-8")
        return old
    m = {k: v for k, v in meta.items() if k != "link"}
    m["links"] = [meta["link"]]
    mp.write_text(json.dumps(m, indent=1) + "\n", encoding="utf-8")
    return m


def run_phase(engine, folder, phase, role, desc, lmap, stop_after=None):
    """Makes the phase's groups not yet written, stopping after stop_after of them; the number made."""
    done = {r["group"] for r in written(folder)}
    made = 0
    for g in P.phase_groups(phase):
        if stop_after is not None and made >= stop_after:
            return made
        if g["id"] in done:
            continue
        append(folder, make_group(engine, g, role, desc, Path(folder) / "states", lmap))
        made += 1
    return made


def code_sha(engine):
    return sha_file(inspect.getfile(type(engine)))


def folder_name(ckpt, code, device, threads):
    return f"{ckpt}-{code[:12]}-{device}-t{threads}"


def run_folder(root, ckpt, code, device, threads):
    return Path(root) / folder_name(ckpt, code, device, threads)


def stand_in_root(engine_cls, root):
    """A stand-in engine, as in the dry run, must be given a root outside results/."""
    refuse(engine_cls is None or (root is not None and RESULTS.resolve() not in
                                  (Path(root).resolve(), *Path(root).resolve().parents)),
           "a stand-in engine writes only outside results/")


def meta_of(ckpt, engine, link, kind):
    """The folder's meta; the engine is what it reports and the hash of the file its code is in, so a
    folder is made under one engine's code (an addendum changing the engine begins a new folder)."""
    d = {**engine.describe(), "code_sha256": code_sha(engine)}
    return {"kind": kind, "checkpoint": ckpt, "spec": {k: CHECKPOINTS[ckpt][k] for k in ("repo", "revision")},
            "device": d["device"], "threads": d["threads"], "engine": d, "link": link_name(link),
            "seed": C.SEED}


def link_name(link):
    return {"link": link["link"], "commit": link["link_commit"], "freeze_commit": link["freeze_commit"]}


def smoke(ckpt, folder, device, threads, engine_cls=None, root=None):
    stand_in_root(engine_cls, root)
    link = preflight(ckpt, folder) if engine_cls is None else frozen()
    engine = (engine_cls or _engine_cls())(folder, CHECKPOINTS[ckpt], device, threads)
    check_engine(engine.describe(), ckpt, device, threads, real=engine_cls is None)
    root = Path(root or SMOKE_DIR)
    stamp = f"{ckpt}-{time.strftime('%Y%m%dT%H%M%SZ', time.gmtime())}"
    k = 0
    while (root / f"{stamp}-{k:02d}").exists():
        k += 1
    out = root / f"{stamp}-{k:02d}"
    out.mkdir(parents=True)
    meta = open_folder(out, meta_of(ckpt, engine, link, "smoke"))
    desc = meta["engine"]
    role, family = CHECKPOINTS[ckpt]["role"], CHECKPOINTS[ckpt]["family"]
    lmap = letter_maps(engine)
    run_phase(engine, out, "smoke", role, desc, lmap)
    tokens = {k: len(v) for m in lmap.values() for k, v in m.items()}
    prompts = [(g, arm, P.prompt_of(g, arm, role)) for g in P.phase_groups("smoke") for arm in g["arms"]]
    unlike = [f"{g['id']} {arm}" for g, arm, pr in prompts
              if PASS.rendered(engine.tok, pr, family) != PASS.expected(engine.tok, pr, family)]
    shown = {g["kind"]: PASS.rendered(engine.tok, P.prompt_of(g, g["arms"][0], role), family)
             for g in reversed(P.phase_groups("smoke"))}
    report = smoke_report(out, desc, tokens, shown, unlike)
    (out / "smoke-report.json").write_text(json.dumps(report, indent=1) + "\n", encoding="utf-8")
    return report


def smoke_report(folder, desc, tokens, shown, unlike):
    gs = written(folder)
    passes = [r for g in gs for r in g["passes"]]
    secs = [r["t1"] - r["t0"] for r in passes]
    planned = P.passes("smoke")
    letters_found = all(n > 0 for n in tokens.values())
    choice = [g for g in gs if g["kind"] == "choice"]
    def same(g):
        a = {r["arm"]: r for r in g["passes"]}
        return all(a["identical"][k] == a["base"][k] for k in ("input_sha256", "layer_sha256", "logits_sha256"))
    identical_equal = all(same(g) for g in choice)
    mass = [r["p"]["A"] + r["p"]["B"] for g in choice for r in g["passes"]]
    mean = sum(secs) / len(secs) if secs else None
    per = {"pilot": P.passes("pilot"), "main": P.passes("main"), "recognition": P.passes("recognition")}
    per["all"] = sum(per.values())
    hours = {k: round(v * mean / 3600, 1) for k, v in per.items()} if mean else None
    return {"checkpoint": json.loads((Path(folder) / "meta.json").read_text())["checkpoint"],
            "passes": len(passes), "planned": planned, "seconds_per_pass": round(mean, 3) if mean else None,
            "projected_hours": hours, "identical_arm_exactly_equal": identical_equal,
            "mean_letter_mass": round(sum(mass) / len(mass), 4) if mass else None, "letter_tokens": tokens,
            "tokens_per_pass": [min(r["n_tokens"] for r in passes), max(r["n_tokens"] for r in passes)] if passes else None,
            "shown": shown, "ids_not_decoding_to_their_text": unlike,
            "engine": desc, "go_on": len(passes) == planned and letters_found and not unlike,
            "reading": ("go on where every planned pass was made, every letter is a token, and every prompt's "
                        "token ids decode exactly to the text they were made from (the base text, or the "
                        "template's text and 'Answer:'), so no token is added; the identical arm and the letters' "
                        "mass are reported, not read: a run that is not exact is read by the probe, and one that "
                        "does not answer in the format has its sampled acts void; 'shown' is the text of the "
                        "first pass of each kind as the checkpoint is shown it, decoded from its token ids")}


def latest_smoke(ckpt, link, device, threads, root=None):
    root = Path(root or SMOKE_DIR)
    for d in sorted(root.glob(f"{ckpt}-*"), reverse=True):
        rp = d / "smoke-report.json"
        if not rp.exists():
            return False                    # the newest smoke run stopped before its report
        m = json.loads((d / "meta.json").read_text())
        rep = json.loads(rp.read_text())
        return (rep["go_on"] and m["links"][-1] == link_name(link) and m["device"] == device
                and m["threads"] == threads)
    return False


def run(ckpt, folder, device, threads, engine_cls=None, root=None, stop_after=None):
    """The checkpoint's run, phase by phase; with stop_after, it stops after that many groups made."""
    stand_in_root(engine_cls, root)
    link = preflight(ckpt, folder) if engine_cls is None else frozen()
    if not latest_smoke(ckpt, link, device, threads, root=(Path(root) / "smoke") if root else None):
        raise SystemExit("refused: no smoke run said go on under this link, device and threads")
    engine = (engine_cls or _engine_cls())(folder, CHECKPOINTS[ckpt], device, threads)
    check_engine(engine.describe(), ckpt, device, threads, real=engine_cls is None)
    out = run_folder(root or RESULTS, ckpt, code_sha(engine), device, threads)
    for d, (_, _, whole, _) in folders_of(Path(root or RESULTS), ckpt, link).items():
        refuse(d == out.name or not (whole and all(whole.values())),
               f"{ckpt} has a whole folder, {d}: a whole folder ends a checkpoint's run")
    meta = open_folder(out, meta_of(ckpt, engine, link, "run"))
    repair_torn(out)
    desc, role = meta["engine"], CHECKPOINTS[ckpt]["role"]
    lmap = letter_maps(engine)
    made = 0
    for ph in ("pilot", "main", "recognition"):
        left = None if stop_after is None else stop_after - made
        if left is not None and left <= 0:
            break
        made += run_phase(engine, out, ph, role, desc, lmap, stop_after=left)
    return 0


def _engine_cls():
    import tr2_engine
    return tr2_engine.Engine


# --- reading ------------------------------------------------------------------------------------

def load(folder, ckpt, link):
    """A checkpoint's groups from one of its folders, the folder and every record checked; whether each
    phase is whole; whether a torn last line was read as absent."""
    folder = Path(folder)
    meta = json.loads((folder / "meta.json").read_text(encoding="utf-8"))
    refuse(meta.get("kind") == "run", f"{folder.name} is not a run's folder")
    code = meta["engine"].get("code_sha256", "")
    refuse(meta.get("checkpoint") == ckpt and folder.name == folder_name(ckpt, code, meta["device"], meta["threads"]),
           f"{folder.name} holds another checkpoint's or another engine's run")
    refuse(code in engine_hashes(link), f"{folder.name} was made under an engine no link of the chain lists")
    refuse(all(m["link"] in link["chain"] for m in meta["links"]), f"{folder.name} names a link not in the chain")
    role = CHECKPOINTS[ckpt]["role"]
    torn = torn_last((folder / "groups.jsonl").read_bytes()) is not None if (folder / "groups.jsonl").exists() else False
    gs = written(folder, torn_ok=True)
    ids = [g.get("group") for g in gs]
    refuse(len(ids) == len(set(ids)), f"{folder.name} holds a group twice")
    have = {g["group"]: g for g in gs}
    plan = {g["id"]: g for ph in ("pilot", "main", "recognition") for g in P.phase_groups(ph)}
    for g in gs:
        refuse(set(g) == GROUP, f"{folder.name}: a group's fields are {sorted(g)}")
        pg = plan.get(g["group"])
        refuse(pg is not None, f"{g['group']} is not in the plan")
        refuse([r.get("arm") for r in g["passes"]] == pg["arms"] and g["keep_state"] == pg["keep_state"],
               f"{g['group']}'s arms differ from the plan's")
        refuse((g["phase"], g["content"], g["kind"]) == (pg["phase"], pg["content"], pg["kind"]),
               f"{g['group']}'s phase, content or kind differs from the plan's")
        for r in g["passes"]:
            need = RECORD | ({"state_file", "state_sha256"} if pg["keep_state"] else set())
            refuse(set(r) == need, f"{g['group']} {r['arm']}: its fields are not the record's")
            refuse(r["prompt_sha256"] == prompt_sha(P.prompt_of(pg, r["arm"], role)),
                   f"{g['group']} {r['arm']}: the prompt hash differs")
            if pg["keep_state"]:
                sp = folder / "states" / r["state_file"]
                refuse(sp.exists() and hashlib.sha256(sp.read_bytes()).hexdigest() == r["state_sha256"],
                       f"{g['group']} {r['arm']}: the state file differs from its hash")
    whole = {}
    for ph in ("pilot", "main", "recognition"):
        planned = [g for g in plan.values() if g["phase"] == ph]
        whole[ph] = bool(planned) and all(g["id"] in have for g in planned)
    return meta, [have[k] for k in plan if k in have], whole, torn


def folders_of(root, ckpt, link):
    """Each folder of a checkpoint, loaded, or (None, why, None, None) where it is refused."""
    out = {}
    for d in sorted(x for x in Path(root).glob(f"{ckpt}-*") if (x / "meta.json").exists()):
        try:
            out[d.name] = load(d, ckpt, link)
        except SystemExit as e:
            out[d.name] = (None, str(e), None, None)
    return out


def read_one(root, ck, link):
    loaded = folders_of(root, ck, link)
    if not loaded:
        return {"status": "not run"}
    listing = {k: ({"refused": v[1]} if v[0] is None else {"whole": v[2], "torn_last_line": v[3]})
               for k, v in loaded.items()}
    whole = [k for k, v in loaded.items() if v[0] is not None and all(v[2].values())]
    if len(whole) > 1:
        return {"status": "refused: two whole folders", "folders": listing}
    if not whole:
        return {"status": "partial", "folders": listing}
    meta, gs, _, _ = loaded[whole[0]]
    r = RU.read_checkpoint(root / whole[0], gs, meta["engine"])
    r.update({"status": "read", "folder": whole[0], "not_read": {k: v for k, v in listing.items() if k != whole[0]},
              "device": meta["device"], "threads": meta["threads"], "links": meta["links"]})
    return r


def read(root=None):
    """Each checkpoint read alone; a refusal in one is its status, and the others are read."""
    link = frozen()
    root = Path(root or RESULTS)
    out = {"label": RU.LABEL, "checkpoints": {}}
    for ck in CHECKPOINTS:
        try:
            out["checkpoints"][ck] = read_one(root, ck, link)
        except SystemExit as e:
            out["checkpoints"][ck] = {"status": "refused", "why": str(e)}
    (root / "readout.json").write_text(json.dumps(out, indent=1) + "\n", encoding="utf-8")
    return out


def main(argv=None):
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest="cmd", required=True)
    for name in ("check", "smoke", "run"):
        s = sub.add_parser(name)
        s.add_argument("--checkpoint", required=True, choices=sorted(CHECKPOINTS))
        s.add_argument("--folder", required=True)
        if name != "check":
            s.add_argument("--device", default="cpu", choices=("cpu", "mps"))
            s.add_argument("--threads", type=int, default=8)
    sub.add_parser("read")
    a = ap.parse_args(argv)
    if a.cmd == "check":
        bad = check_files(CHECKPOINTS[a.checkpoint], a.folder) + check_packages()
        print(json.dumps({"frozen": link_name(frozen()), "problems": bad}, indent=1))
        return 1 if bad else 0
    if a.cmd == "smoke":
        rep = smoke(a.checkpoint, a.folder, a.device, a.threads)
        print(json.dumps(rep, indent=1))
        return 0 if rep["go_on"] else 1
    if a.cmd == "run":
        return run(a.checkpoint, a.folder, a.device, a.threads)
    print(json.dumps(read(), indent=1)[:4000])
    return 0


if __name__ == "__main__":
    sys.exit(main())
