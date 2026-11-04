"""TR2 Stage B, the run: checks, the smoke run, the phases and the reading. No model call through an
API; each checkpoint is run locally from files that Ren's yes downloads.

    python3 -B tr2_run.py check --checkpoint ID --folder DIR
    python3 -B tr2_run.py smoke --checkpoint ID --folder DIR [--device cpu|mps] [--threads N]
    python3 -B tr2_run.py run   --checkpoint ID --folder DIR [--device ...] [--threads N]
    python3 -B tr2_run.py set-aside --checkpoint ID --name FOLDER
    python3 -B tr2_run.py read

ID is one of MODELS.json's checkpoints (qwen-base, qwen-tuned, olmo-base, olmo-tuned); DIR the folder
holding its files, downloaded at its revision. Before any pass, smoke and run refuse unless:
- every frozen file equals its hash in the newest link of this freeze's chain (open/FROZEN.sha256,
  then any addendum's in open/addenda/), each link committed once, and the working copy clean;
- every file MODELS.json lists for the checkpoint is in DIR with its size and hash, and no other file a
  loader could read is there;
- Python is 3.11 and every package MODELS.json pins is at its version;
- the engine reports the checkpoint's model class, layers and width (MODELS.json's), bfloat16, eager
  attention, the device and threads asked for, and deterministic algorithms, and a tuned checkpoint's
  tokenizer holds the chat template's text whose hash MODELS.json lists;
- the newest link lists every file this freeze holds (HELD);
- for run, the checkpoint's newest smoke run said go on, under the same link, device and threads (a
  newest smoke run with no report, stopped before its end, says no), no other run of the checkpoint
  holds its lock (results/<checkpoint>.lock), and no other folder of the checkpoint is whole or refused:
  a whole folder ends that checkpoint's run, refused or not, as does one whole by its lines or whose
  log cannot be read (raw_whole_why), in results/ or set aside, or while a set-aside slot, or set-aside/
  itself, cannot be read, and a refused one stops it until
  set-aside moves it, unchanged, to results/set-aside/<k>/, where the reading still lists it; a folder
  whole by its lines is never set aside, so it ends the checkpoint's run under this freeze unless its
  own run makes it whole. The run's own folder must load as
  the reading loads it, before anything is written to it and after its repairs.
The run calls the pass (tr2_pass.py) itself; the engine supplies torch, the model, the tokenizer and
the device. Every state and the logits of a pass must be bfloat16, made on that device.
A run writes only into results/<checkpoint>-<engine>-<device>-t<threads>/, <engine> the first 12 hex
digits of the engine file's hash, so passes made under two engines, devices or thread counts never
share a folder: meta.json (fixed at its first pass: the checkpoint, the device, the threads, what the
engine reports and its code's hash; the links listed as they come), groups.jsonl (one line per group,
written whole and synced once its passes are made), and states/ (the kept states, each named in its
pass's record with its hash). meta.json and each state file are written to a temporary name, synced and
moved into place, the states before their group's line. A run stopped part way goes on at the first
group not written; a last line torn by the stop (no newline at its end) is moved, unchanged, to
groups.jsonl.torn-<k> beside it and the group made again, and so is a last group whose state files
differ from their hashes; no state file is overwritten, an earlier one kept beside it as
<name>.torn-<k> (k its own). The phases go
pilot, main, recognition, and nothing in one moves another's plan.
read reads each checkpoint alone, and writes results/readout.json whatever any one checkpoint gives. A
checkpoint is read from the one folder whose phases are all whole. A folder is refused, listed with
why and not read, where its meta is not a run of that checkpoint under an engine and links of this
freeze's chain, or a record is one the plan does not hold, differs from the plan in its phase,
content, kind, arms or keeping of states, has a field missing or a prompt hash other than the one its
group rebuilds, names a state file that differs from its hash, or is not one whole line (a torn last
line aside: it leaves the folder partial, read as absent and left in place, as does a last group whose
kept states are missing or differ), or where its meta.json is not whole or anything else stops its
loading (the error is its reason). A checkpoint with two whole
folders is refused (the run never makes a second); one with no whole folder is listed as partial, or
refused where every folder is, each loaded folder with its groups per phase, its first and last pass
and the lines and state files set aside by groups made again, each refused one with its reason and its
lines per phase. No whole folder is read beside a refused or set-aside folder whole by its lines or
whose log or slot cannot be read; those are named. The folders not read are named, and the folders set
aside listed.
"""

import argparse
import contextlib
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
# Every file this freeze holds: the newest link must list each of them, or smoke and run refuse.
HELD = MAY_CHANGE | frozenset(str(OPEN / f) for f in (
    "MODELS.json", "tr2_conditions.py", "tr2_plan.py", "tr2_pass.py", "tr2_rule.py", "tr2_run.py",
    "tr2_power.py", "results/power.json")) | frozenset(
    (str(OPEN.parent / "tr2.py"), str(OPEN.parent / "tr2.json"), str(R.TOLD / "run.py")))
RESULTS = HERE / "results"
SMOKE_DIR = RESULTS / "smoke"
SET_ASIDE = "set-aside"                          # results/set-aside/: refused folders moved there, still listed
PHASES = ("pilot", "main", "recognition")
PLANNED = [g["id"] for ph in PHASES for g in P.phase_groups(ph)]


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


def held(link):
    """The newest link lists every file this freeze holds, the engine among them."""
    refuse(HELD <= set(link["hashes"]), f"the link {link['link']} does not list {sorted(HELD - set(link['hashes']))}")
    return link


def preflight(ckpt, folder, packages=True):
    link = held(frozen())
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
META = {"kind", "checkpoint", "spec", "device", "threads", "engine", "links", "seed"}
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
        refuse((desc["layers"], desc["hidden"], desc["class"]) == (spec["layers"], spec["hidden"], spec["architecture"]),
               f"the engine reports {desc['class']}, {desc['layers']} layers of {desc['hidden']}, not MODELS.json's")
        refuse(desc["attention"] == "eager", f"the engine's attention is {desc['attention']}, not eager")


def check_template(tok, ckpt):
    """A tuned checkpoint's tokenizer holds the chat template read at the pinned revision (the hash of its
    text, UTF-8, from the file MODELS.json names). What the template adds is in the text the ids must
    decode to, so the smoke run's decode check cannot see it; this check can, for the template's text."""
    want = CHECKPOINTS[ckpt].get("chat_template_sha256")
    if want is None:
        return
    have = getattr(tok, "chat_template", None)
    refuse(isinstance(have, str) and hashlib.sha256(have.encode("utf-8")).hexdigest() == want,
           f"{ckpt}'s tokenizer holds another chat template than the pinned one")


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
        refuse(r["dtype"] == [BF16] and r["logits_dtype"] == BF16, f"the pass made {r['dtype']}, {r['logits_dtype']}")
        refuse({d.split(":")[0] for d in r["device"]} == {desc["device"]}, f"the pass was made on {r['device']}")
        refuse(len(r["layer_sha256"]) == desc["layers"] + 1, "the pass returned another number of states")
        refuse(set(r["p"]) == set(names) | {"other"} and all(0.0 <= v <= 1.0 for v in r["p"].values()),
               "the pass returned other probabilities")
        rec = {"arm": arm, "prompt_sha256": prompt_sha(pr), **{k: r[k] for k in KEPT},
               "t0": round(t0, 3), "t1": round(t1, 3)}
        if g["keep_state"]:
            refuse(len(r["state"]) == (desc["layers"] + 1) * desc["hidden"] * 4, "the state's length differs")
            name = f"{g['id'].replace('/', '_')}_{arm}.f32"
            keep_aside(Path(states_dir) / name)
            durable(Path(states_dir) / name, r["state"])
            rec["state_file"], rec["state_sha256"] = name, hashlib.sha256(r["state"]).hexdigest()
        dists[arm] = r["dist"]
        out.append(rec)
    ref = "pilot-down" if g["kind"] == "pilot" else "base"
    for rec in out:
        rec["tv_vs_base"] = None if rec["arm"] == ref else PASS.tv(dists[rec["arm"]], dists[ref])
    return {"group": g["id"], "phase": g["phase"], "content": g["content"], "kind": g["kind"],
            "keep_state": g["keep_state"], "passes": out}


def keep_aside(p):
    """A state file already at p, from an attempt at this group before (its line torn or set aside), moved
    to <name>.torn-<k>, so no state is overwritten."""
    if p.exists():
        k = 0
        while p.with_name(f"{p.name}.torn-{k}").exists():
            k += 1
        os.replace(p, p.with_name(f"{p.name}.torn-{k}"))


def torn_last(raw):
    """Where a last line torn by a stop begins: a last line with no newline at its end, since a record
    and its newline are written in one call. None where the log ends in a newline."""
    if not raw or raw.endswith(b"\n"):
        return None
    return raw.rfind(b"\n") + 1


def durable(p, data):
    """Bytes written to a temporary name, flushed to the disk (F_FULLFSYNC where the system has it), and
    moved into place, the folder flushed after: a stop leaves the old file or the new, never a part."""
    p = Path(p)
    tmp = p.with_name(p.name + ".tmp")
    with open(tmp, "wb") as f:
        f.write(data)
        f.flush()
        sync(f.fileno())
    os.replace(tmp, p)
    fd = os.open(p.parent, os.O_RDONLY)
    try:
        os.fsync(fd)
    finally:
        os.close(fd)


def sync(fd):
    import fcntl
    if hasattr(fcntl, "F_FULLFSYNC"):
        try:
            fcntl.fcntl(fd, fcntl.F_FULLFSYNC)
            return
        except OSError:
            pass
    os.fsync(fd)


def written(folder, torn_ok=False):
    """The folder's group records. With torn_ok, a torn last line is read as absent (the folder is then
    partial; the file is not touched); any other line that is not one whole record is refused."""
    p = Path(folder) / "groups.jsonl"
    if not p.exists():
        return []
    raw = p.read_bytes()
    cut = torn_last(raw) if torn_ok else None
    out = []
    # Records are split at the newline alone: json.dumps escapes every other line break and control
    # character (and, ASCII by default, U+0085, U+2028 and U+2029), so no record holds one raw.
    lines = (raw if cut is None else raw[:cut]).decode("utf-8").split("\n")
    if lines and lines[-1] == "":
        lines.pop()                                  # the newline that ends the last record
    for k, x in enumerate(lines):
        try:
            rec = json.loads(x)
        except json.JSONDecodeError:
            raise SystemExit(f"refused: {p} line {k + 1} is not a whole record")
        refuse(isinstance(rec, dict), f"{p} line {k + 1} is not a record")
        out.append(rec)
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
    durable(side, raw[start:])
    with open(p, "r+b") as f:
        f.truncate(start)
        f.flush()
        sync(f.fileno())
    return side


def repair_states(folder):
    """A last group whose kept state files are missing or differ from their hashes (a machine stop before
    the files reached the disk) is treated as torn: its line is moved, unchanged, to groups.jsonl.torn-<k>,
    each of its state files there is kept beside it as <name>.torn-<j> (j the file's own first free number),
    and the group is made again. Returns the side
    file, or None. The run calls it only on a folder that loads, so the last line is a whole record."""
    p = Path(folder) / "groups.jsonl"
    if not p.exists():
        return None
    raw = p.read_bytes()
    if not raw:
        return None
    body = raw[:-1] if raw.endswith(b"\n") else raw
    start = body.rfind(b"\n") + 1
    g = json.loads(raw[start:])
    if not states_differ(folder, g):
        return None
    k = 0
    while (Path(folder) / f"groups.jsonl.torn-{k}").exists():
        k += 1
    side = Path(folder) / f"groups.jsonl.torn-{k}"
    for r in g["passes"]:
        keep_aside(Path(folder) / "states" / r["state_file"])
    durable(side, raw[start:])
    with open(p, "r+b") as f:
        f.truncate(start)
        f.flush()
        sync(f.fileno())
    return side


def append(folder, rec):
    with open(Path(folder) / "groups.jsonl", "a", encoding="utf-8") as f:
        f.write(json.dumps(rec, sort_keys=True) + "\n")
        f.flush()
        sync(f.fileno())


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
            durable(mp, (json.dumps(old, indent=1) + "\n").encode())
        return old
    m = {k: v for k, v in meta.items() if k != "link"}
    m["links"] = [meta["link"]]
    durable(mp, (json.dumps(m, indent=1) + "\n").encode())
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
    link = preflight(ckpt, folder) if engine_cls is None else held(frozen())
    engine = (engine_cls or _engine_cls())(folder, CHECKPOINTS[ckpt], device, threads)
    check_engine(engine.describe(), ckpt, device, threads, real=engine_cls is None)
    if engine_cls is None:
        check_template(engine.tok, ckpt)
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
    durable(out / "smoke-report.json", (json.dumps(report, indent=1) + "\n").encode())
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
    for d in sorted((x for x in root.glob(f"{ckpt}-*") if x.is_dir()), reverse=True):
        rp = d / "smoke-report.json"
        if not rp.exists():
            return False                    # the newest smoke run stopped before its report
        try:
            m = json.loads((d / "meta.json").read_text())
            rep = json.loads(rp.read_text())
            return (rep["go_on"] is True and m["links"][-1] == link_name(link) and m["device"] == device
                    and m["threads"] == threads)
        except Exception:                            # noqa: BLE001  a report or meta not whole says no
            return False
    return False


@contextlib.contextmanager
def one_run(root, ckpt):
    """One run of a checkpoint at a time: an exclusive lock on results/<checkpoint>.lock, held to the
    run's end (the system drops it when the process ends), refused while another holds it."""
    import fcntl
    root = Path(root)
    root.mkdir(parents=True, exist_ok=True)
    f = open(root / f"{ckpt}.lock", "a")
    try:
        try:
            fcntl.flock(f.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            raise SystemExit(f"refused: another run of {ckpt} holds {ckpt}.lock")
        except OSError as e:
            raise SystemExit(f"refused: {ckpt}.lock could not be taken ({e}); a run needs a folder that locks")
        yield
    finally:
        f.close()


def own_loads(out, ckpt, link):
    """The run's own folder loads as the reading loads it, or the run is refused with no pass added."""
    try:
        return load(out, ckpt, link)[3]
    except SystemExit as e:
        raise SystemExit(f"refused: the run's own folder {out.name} is refused ({e}): no pass is added to it")
    except Exception as e:                           # noqa: BLE001
        raise SystemExit(f"refused: the run's own folder {out.name} is refused ({type(e).__name__}: {e}): "
                         f"no pass is added to it")


def fresh_folder(out):
    """A folder the run may begin: absent, or holding no record, no meta and no state (a stop inside its
    first open leaves at most a meta.json.tmp and an empty states/)."""
    if not out.exists():
        return True
    states = out / "states"
    return not ((out / "meta.json").exists() or (out / "groups.jsonl").exists()
                or (states.is_dir() and any(states.iterdir())))


def run(ckpt, folder, device, threads, engine_cls=None, root=None, stop_after=None):
    """The checkpoint's run, phase by phase; with stop_after, it stops after that many groups made."""
    stand_in_root(engine_cls, root)
    base = Path(root or RESULTS)
    with one_run(base, ckpt):
        link = preflight(ckpt, folder) if engine_cls is None else held(frozen())
        if not latest_smoke(ckpt, link, device, threads, root=(Path(root) / "smoke") if root else None):
            raise SystemExit("refused: no smoke run said go on under this link, device and threads")
        engine = (engine_cls or _engine_cls())(folder, CHECKPOINTS[ckpt], device, threads)
        check_engine(engine.describe(), ckpt, device, threads, real=engine_cls is None)
        if engine_cls is None:
            check_template(engine.tok, ckpt)
        out = run_folder(base, ckpt, code_sha(engine), device, threads)
        for d, (m, why, whole, _) in folders_of(base, ckpt, link).items():
            if d != out.name:
                refuse(not (m is not None and all(whole.values())),
                       f"{ckpt} has a whole folder, {d}: a whole folder ends a checkpoint's run")
                w = raw_whole_why(base / d)
                refuse(w is None, f"{ckpt}'s folder {d} is whole by its lines, or cannot be read ({w}): such a "
                                  f"folder ends a checkpoint's run, refused or not, unless its own run makes it whole")
                refuse(m is not None, f"{ckpt}'s folder {d} is refused ({why}): no run goes on while one is; "
                                      f"set-aside moves it, unchanged, where the reading still lists it")
        found, bad = aside_folders(base, ckpt)
        refuse(not bad, f"{ckpt}'s set-aside folders cannot all be read ({bad}): nothing about a folder is "
                        f"decided by its being unreadable")
        for d in found:
            w = raw_whole_why(d)
            refuse(w is None, f"{ckpt}'s folder {d.parent.name}/{d.name}, set aside, is whole by its lines, or "
                              f"cannot be read ({w}): such a folder ends a checkpoint's run")
        if not fresh_folder(out):
            own_loads(out, ckpt, link)           # before anything is written to it
        meta = open_folder(out, meta_of(ckpt, engine, link, "run"))
        repair_torn(out)
        repair_states(out)
        info = own_loads(out, ckpt, link)
        refuse(not any(info.values()), f"the run's own folder {out.name} still has {info} after its repairs: "
                                       f"no pass is added to it")
        desc, role = meta["engine"], CHECKPOINTS[ckpt]["role"]
        lmap = letter_maps(engine)
        made = 0
        for ph in PHASES:
            left = None if stop_after is None else stop_after - made
            if left is not None and left <= 0:
                break
            made += run_phase(engine, out, ph, role, desc, lmap, stop_after=left)
    return 0


def set_aside(ckpt, name, root=None):
    """A refused folder of the checkpoint moved, unchanged, to results/set-aside/<k>/<name>/ (k the first
    free number), with the reason it was refused and the time in set-aside/<k>/why.json, written first, so
    a run may go on beside it. The reading lists it there with its reason and how far it got. Refused: a
    folder that loads, and a folder whose log is whole by its lines or cannot be read (raw_whole_why), since a
    whole folder, refused or not, ends its checkpoint's run (no second whole run is begun). Nothing is deleted."""
    base = Path(root or RESULTS)
    with one_run(base, ckpt):
        link = held(frozen())
        listed = folders_of(base, ckpt, link)
        refuse(Path(name).name == name and name not in (".", "..") and name.startswith(f"{ckpt}-")
               and (base / name).is_dir() and name in listed, f"{name} is not a folder of {ckpt}'s runs")
        m, why, _, _ = listed[name]
        refuse(m is None, f"{name} loads: only a refused folder is set aside")
        w = raw_whole_why(base / name)
        refuse(w is None, f"{name} is whole by its lines, or cannot be read ({w}): such a folder ends {ckpt}'s "
                          f"run, refused or not, and it is not set aside")
        k = 0
        while True:
            slot = base / SET_ASIDE / str(k)
            try:
                slot.mkdir(parents=True)
                break
            except FileExistsError:
                k += 1
        stamp = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
        durable(slot / "why.json", (json.dumps({"folder": name, "why": why, "set_aside_at": stamp}, indent=1) + "\n").encode())
        os.replace(base / name, slot / name)
    return {"set_aside": f"{SET_ASIDE}/{k}/{name}", "why": why}


def _engine_cls():
    import tr2_engine
    return tr2_engine.Engine


# --- reading ------------------------------------------------------------------------------------

def load(folder, ckpt, link):
    """A checkpoint's groups from one of its folders, the folder and every record checked; whether each
    phase is whole; whether a torn last line was read as absent."""
    folder = Path(folder)
    try:
        meta = json.loads((folder / "meta.json").read_text(encoding="utf-8"))
    except (OSError, UnicodeDecodeError, json.JSONDecodeError) as e:
        raise SystemExit(f"refused: {folder.name}'s meta.json is not whole ({type(e).__name__})")
    refuse(isinstance(meta, dict) and META <= set(meta) and isinstance(meta["engine"], dict)
           and isinstance(meta["links"], list) and all(isinstance(m, dict) and "link" in m for m in meta["links"]),
           f"{folder.name}'s meta.json lacks a field")
    refuse(meta.get("kind") == "run", f"{folder.name} is not a run's folder")
    code = meta["engine"].get("code_sha256", "")
    refuse(meta.get("checkpoint") == ckpt and folder.name == folder_name(ckpt, code, meta["device"], meta["threads"]),
           f"{folder.name} holds another checkpoint's or another engine's run")
    refuse(code in engine_hashes(link), f"{folder.name} was made under an engine no link of the chain lists")
    refuse(all(m["link"] in link["chain"] for m in meta["links"]), f"{folder.name} names a link not in the chain")
    role = CHECKPOINTS[ckpt]["role"]
    torn = torn_last((folder / "groups.jsonl").read_bytes()) is not None if (folder / "groups.jsonl").exists() else False
    gs = written(folder, torn_ok=True)
    # A last group whose kept states differ, as a machine stop before they reached the disk leaves them, is
    # read as absent, as a torn last line is, once every other check of it holds; a run resuming the folder
    # makes it again (repair_states).
    differ = bool(gs) and states_differ(folder, gs[-1])
    for g in gs:
        refuse(set(g) == GROUP and isinstance(g["passes"], list) and all(isinstance(r, dict) for r in g["passes"]),
               f"{folder.name}: a group's fields are {sorted(g)}, or its passes are not a list of records")
    ids = [g["group"] for g in gs]
    refuse(len(ids) == len(set(ids)), f"{folder.name} holds a group twice")
    have = {g["group"]: g for g in gs}
    plan = {g["id"]: g for ph in PHASES for g in P.phase_groups(ph)}
    for g in gs:
        pg = plan.get(g["group"])
        refuse(pg is not None, f"{g['group']} is not in the plan")
        refuse([r.get("arm") for r in g["passes"]] == pg["arms"], f"{g['group']}'s arms differ from the plan's")
        refuse(g["keep_state"] == pg["keep_state"], f"{g['group']}'s keeping of states differs from the plan's")
        refuse((g["phase"], g["content"], g["kind"]) == (pg["phase"], pg["content"], pg["kind"]),
               f"{g['group']}'s phase, content or kind differs from the plan's")
        for r in g["passes"]:
            need = RECORD | ({"state_file", "state_sha256"} if pg["keep_state"] else set())
            refuse(set(r) == need, f"{g['group']} {r.get('arm')}: its fields are not the record's")
            refuse(r["prompt_sha256"] == prompt_sha(P.prompt_of(pg, r["arm"], role)),
                   f"{g['group']} {r['arm']}: the prompt hash differs")
            if pg["keep_state"] and not (differ and g is gs[-1]):
                sp = folder / "states" / r["state_file"]
                refuse(sp.exists() and hashlib.sha256(sp.read_bytes()).hexdigest() == r["state_sha256"],
                       f"{g['group']} {r['arm']}: the state file differs from its hash")
    if differ:
        del have[gs[-1]["group"]]
    whole = {}
    for ph in PHASES:
        planned = [g for g in plan.values() if g["phase"] == ph]
        whole[ph] = bool(planned) and all(g["id"] in have for g in planned)
    return meta, [have[k] for k in plan if k in have], whole, {"torn_last_line": torn, "last_group_states_differ": differ}


def states_differ(folder, g):
    """A well-formed group keeping states, some of whose state files are missing or differ from their hashes."""
    if g.get("keep_state") is not True or not isinstance(g.get("passes"), list) or not g["passes"]:
        return False
    if not all(isinstance(r, dict) and isinstance(r.get("state_file"), str) and isinstance(r.get("state_sha256"), str)
               and "/" not in r["state_file"] for r in g["passes"]):
        return False
    return any(not (Path(folder) / "states" / r["state_file"]).exists()
               or hashlib.sha256((Path(folder) / "states" / r["state_file"]).read_bytes()).hexdigest() != r["state_sha256"]
               for r in g["passes"])


def progress(folder, gs):
    """How far a loaded folder got: its groups per phase against the plan's, its first and last pass, and
    the side files of groups made again."""
    out = {ph: f"{sum(g['phase'] == ph for g in gs)} of {len(P.phase_groups(ph))}" for ph in PHASES}
    times = [(r["t0"], r["t1"]) for g in gs for r in g["passes"]]
    out["first_pass_t0"] = min(t[0] for t in times) if times else None
    out["last_pass_t1"] = max(t[1] for t in times) if times else None
    out["made_again"] = side_files(folder)
    return out


def side_files(folder):
    """The lines and the state files set aside by a repair or by a group made again (a count of files, not
    of groups: a stop inside a group, before its line, leaves state files and no line)."""
    folder = Path(folder)
    try:
        return {"lines": sum(not x.name.endswith(".tmp") for x in folder.glob("groups.jsonl.torn-*")),
                "state_files": sum(not x.name.endswith(".tmp") for x in (folder / "states").glob("*.torn-*"))
                if (folder / "states").is_dir() else 0}
    except Exception as e:                           # noqa: BLE001  a listing never stops a reading
        return {"unreadable": f"{type(e).__name__}: {e}"}


def raw_lines(folder):
    """A folder's log line by line as it stands, each parsed where it parses (None where not)."""
    p = Path(folder) / "groups.jsonl"
    out = []
    for x in (p.read_bytes() if p.exists() else b"").split(b"\n"):
        if x.strip():
            try:
                out.append(json.loads(x))
            except Exception:                        # noqa: BLE001
                out.append(None)
    return out


def raw_groups(folder):
    """The group ids a folder's log names, its records not checked."""
    return {x["group"] for x in raw_lines(folder) if isinstance(x, dict) and isinstance(x.get("group"), str)}


LAST_GROUP = f'"group": {json.dumps(PLANNED[-1])}'.encode()     # as append writes it


def raw_whole_why(folder):
    """Why a folder's log is whole by its lines as they stand, whatever its records hold, or None: at least
    as many lines as the plan has groups (a torn last line among them), every planned group named, or the
    plan's last group's record anywhere in its bytes (the log is written in the plan's order). One byte
    changed, added or taken anywhere in the log, a newline included, leaves the first or the last of these.
    A log that cannot be read counts as whole, so that nothing about it is decided by its being unreadable;
    the reason says which."""
    try:
        p = Path(folder) / "groups.jsonl"
        raw = p.read_bytes() if p.exists() else b""
        lines = raw_lines(folder)
    except Exception as e:                           # noqa: BLE001
        return f"its log cannot be read ({type(e).__name__}: {e})"
    names = {x["group"] for x in lines if isinstance(x, dict) and isinstance(x.get("group"), str)}
    if len(lines) >= len(PLANNED):
        return f"its log has {len(lines)} lines, of {len(PLANNED)} groups planned"
    if names >= set(PLANNED):
        return "its log names every planned group"
    if LAST_GROUP in raw:
        return f"its log holds the plan's last group, {PLANNED[-1]}"
    return None


def raw_whole(folder):
    """Whether a folder's log is whole by its lines (raw_whole_why)."""
    return raw_whole_why(folder) is not None


def aside_folders(root, ckpt):
    """The checkpoint's folders set aside, by slot, and the slots (or set-aside/ itself) that cannot be read,
    each with its error: an unreadable folder is never passed over as empty."""
    top, found, bad = Path(root) / SET_ASIDE, [], {}
    if not top.exists():
        return found, bad
    try:
        slots = sorted(os.listdir(top))
    except OSError as e:
        return found, {SET_ASIDE: f"{type(e).__name__}: {e}"}
    for s in slots:
        slot = top / s
        try:
            if not slot.is_dir():
                continue
            found += [slot / n for n in sorted(os.listdir(slot)) if n.startswith(f"{ckpt}-") and (slot / n).is_dir()]
        except OSError as e:
            bad[s] = f"{type(e).__name__}: {e}"
    return found, bad


def raw_progress(folder):
    """How far a refused folder got, from its lines as they stand, its records not read: the lines naming
    each phase, the lines that name none, whether its log is whole by its lines and why (raw_whole_why, the
    same test the run and set-aside use, an unreadable log counted whole), and the side files."""
    why = raw_whole_why(folder)
    try:
        lines = raw_lines(folder)
        counts, other = {ph: 0 for ph in PHASES}, 0
        for x in lines:
            ph = x.get("phase") if isinstance(x, dict) else None
            if isinstance(ph, str) and ph in counts:
                counts[ph] += 1
            else:
                other += 1
        out = {ph: f"{n} lines, of {len(P.phase_groups(ph))} groups planned" for ph, n in counts.items()}
        out["lines_naming_no_phase"] = other
    except Exception as e:                           # noqa: BLE001  a listing never stops a reading
        out = {"unreadable": f"{type(e).__name__}: {e}"}
    out["whole_by_its_lines"] = why is not None
    if why is not None:
        out["whole_why"] = why
    out["made_again"] = side_files(folder)
    return out


def folders_of(root, ckpt, link):
    """Each folder of a checkpoint, loaded, or (None, why, None, None) where it is refused."""
    out = {}
    for d in sorted(x for x in Path(root).glob(f"{ckpt}-*") if x.is_dir()):
        try:
            out[d.name] = load(d, ckpt, link)
        except SystemExit as e:
            out[d.name] = (None, str(e), None, None)
        except Exception as e:                       # noqa: BLE001  a damaged folder is listed, never fatal
            out[d.name] = (None, f"refused: {type(e).__name__}: {e}", None, None)
    return out


def set_aside_listing(root, ck, link):
    """The checkpoint's folders set aside, each with the reason it was refused then, and now, and how far it
    got."""
    out = {}
    found, bad = aside_folders(root, ck)
    for d in found:
        slot, name = d.parent, d.name
        try:
            v = folders_of(slot, ck, link).get(name) or (None, "not listed", None, None)
            try:
                then = json.loads((slot / "why.json").read_text())
            except Exception:                        # noqa: BLE001
                then = None
            out[f"{slot.name}/{name}"] = {"set_aside": then,
                                          "now": v[1] if v[0] is None else {"loads": True, "whole": v[2]},
                                          "progress": raw_progress(d)}
        except Exception as e:                       # noqa: BLE001  a listing never stops a reading
            out[f"{slot.name}/{name}"] = {"unreadable": f"{type(e).__name__}: {e}"}
    for s, e in bad.items():
        out[s] = {"unreadable": e}
    return out


def read_one(root, ck, link):
    loaded = folders_of(root, ck, link)
    aside = set_aside_listing(root, ck, link)
    listing = {k: ({"refused": v[1], "progress": raw_progress(Path(root) / k)} if v[0] is None else
                   {"whole": v[2], **v[3], "progress": progress(Path(root) / k, v[1])})
               for k, v in loaded.items()}
    # Folders not loaded that are whole by their lines, or cannot be read: refused ones here and every one
    # set aside, a slot that cannot be read among them. Beside one, no whole folder is read, so a second whole
    # run is never the one read.
    doubt = sorted([k for k, v in listing.items() if "refused" in v and v["progress"]["whole_by_its_lines"]]
                   + [k if k == SET_ASIDE else f"{SET_ASIDE}/{k}" for k, v in aside.items()
                      if "progress" not in v or v["progress"]["whole_by_its_lines"]])
    named = {"doubt": doubt} if doubt else {}            # named whatever the status
    if not loaded:
        n_aside = sum("progress" in v for v in aside.values())
        n_bad = len(aside) - n_aside
        status = "not run" + (f"; {n_aside} set aside" if n_aside else "") \
            + (f"; {n_bad} unreadable in set-aside" if n_bad else "") + (f"; {len(doubt)} in doubt" if doubt else "")
        return {"status": status, **({"set_aside": aside} if aside else {}), **named}
    whole = [k for k, v in loaded.items() if v[0] is not None and all(v[2].values())]
    if whole and doubt:
        return {"status": "refused: a whole folder beside another whole by its lines, or one that cannot be read",
                "doubt": doubt, "folders": listing, "set_aside": aside}
    if len(whole) > 1:
        return {"status": "refused: two whole folders", "folders": listing, "set_aside": aside}
    if not whole:
        refused_n = sum(v[0] is None for v in loaded.values())
        status = ("refused: every folder refused" if refused_n == len(loaded) else
                  "partial" if not refused_n else f"partial; {refused_n} folder(s) refused")
        return {"status": status, "folders": listing, "set_aside": aside, **named}
    meta, gs, _, _ = loaded[whole[0]]
    r = RU.read_checkpoint(root / whole[0], gs, meta["engine"])
    r.update({"status": "read", "folder": whole[0], "not_read": {k: v for k, v in listing.items() if k != whole[0]},
              "set_aside": aside, "made_again": listing[whole[0]]["progress"]["made_again"],
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
        except Exception as e:                       # noqa: BLE001  one checkpoint's fault is its own
            out["checkpoints"][ck] = {"status": "refused", "why": f"{type(e).__name__}: {e}"}
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
    s = sub.add_parser("set-aside")
    s.add_argument("--checkpoint", required=True, choices=sorted(CHECKPOINTS))
    s.add_argument("--name", required=True)
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
    if a.cmd == "set-aside":
        print(json.dumps(set_aside(a.checkpoint, a.name), indent=1))
        return 0
    print(json.dumps(read(), indent=1)[:4000])
    return 0


if __name__ == "__main__":
    sys.exit(main())
