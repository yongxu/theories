"""TR2 Stage B's dry run: the frozen run and rule, driven by stand-in engines, with no model, no torch
and no download.

    python3 -B tr2_dry_run.py        # writes results/dry-run.json

A stand-in engine has the real engine's interface (tr2_engine.Engine) and reads a pass's prompt text
(its cue lines, its content, its kind) as a model reads its tokens. Its state at the last position
is twelve numbers per layer (four of the content, a twin flag, the pilot's instruction, one per cue
factor, the prompt's kind and X's letter), its next-token distribution a softmax over 64 tokens (A,
B, Yes, No and 60 others), and its logits a function of its last state alone, except where a fault
is planted. Formation types, Stage 0's (tr2.FORMATIONS), as engines:
- content-only: the cue enters no state (couplings apart, states alike, acts alike);
- detected, not acted on: every factor enters its own coordinate; acts read none of them;
- twin on 10% of contents, through F1: as detected, and acts on F1 where the content's flag is up;
- cue-follower on F2: as detected, and X more likely with F2 up on every content;
- serving nondeterminism: as detected, with a little noise in every pass, so no two passes are equal;
- a fault: as detected, the logits shifted by a counter of passes, an input the stated lumping omits;
- off the format: as detected, nearly all the mass on tokens that are no letter;
- deaf: as content-only, and the pilot's instruction enters no state either, so the positive control
  shows no net shift and every factor's "no net shift shown" is marked uninformative.
Each runs the smoke run, the pilot, the main run (1,600 pairs) and recognition through
tr2_run's own code, and is read by tr2_run.read; each reading is checked against what the type
implies. Then: a run stopped part way and resumed equals one run whole; the probe's control voiding
the probe where the identical arm's states are shifted; every refusal of load, open_folder and run;
the file and package checks; the frozen chain in stand-in repositories; the
smoke run's report and its prompts against the scored ones.
"""

import hashlib
import json
import math
import random
import re
import shutil
import sys
import tempfile
from array import array
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import tr2_run as TR            # noqa: E402
import tr2_conditions as C      # noqa: E402
import tr2_plan as P            # noqa: E402
import tr2_rule as RU           # noqa: E402

R = TR.R
H = 12
LAYERS = 3
VOCAB = ["A", "B", "Yes", "No"] + [f"w{i}" for i in range(60)]
CODE = {f: 6 + i for i, f in enumerate(C.FACTOR_IDS)}
BY_SCENARIO = {c["scenario"]: c for c in C.CONTENTS}
# The stand-ins' code is this file, so the dry run's one link lists this file's hash as the engine's.
DRY_LINK = {"link": "FROZEN.sha256", "link_commit": "dry", "freeze_commit": "dry", "hashes": {},
            "chain": {"FROZEN.sha256": {TR.ENGINE: TR.sha_file(__file__)}}}


def run_dir(root):
    """The run's folder under root (one engine, so one folder)."""
    ds = sorted(d for d in Path(root).glob(f"{CKPT}-*") if (d / "meta.json").exists())
    assert len(ds) == 1, ds
    return ds[0]


def gauss(seed, n):
    rnd = random.Random(seed)
    return [rnd.gauss(0, 1) for _ in range(n)]


def make_engine(kind, weight=1.0):
    """A stand-in engine class of the given formation type."""
    class Stand:
        noise = random.Random(f"dry|noise|{kind}")
        calls = [0]

        def __init__(self, folder, spec, device, threads):
            self.spec, self.device, self.threads = spec, device, threads

        def describe(self):
            return {"layers": LAYERS, "hidden": H, "dtype": "stand-in", "device": self.device,
                    "threads": self.threads, "vocab": len(VOCAB), "formation": kind}

        def letters(self, names):
            return {n: [i for i, s in enumerate(VOCAB) if s == n] for n in names}

        def read(self, prompt):
            text = prompt["text"] if "text" in prompt else prompt["messages"][0]["content"] + prompt["reply_prefix"]
            content = next(c for s, c in BY_SCENARIO.items() if s in text)
            up = [f for f in C.FACTOR_IDS if C.FACTORS[f][0].format(ticket=content["ticket"]) in text]
            pilot = C.PILOT_CUE[0].format(x=content["x_letter"]) in text
            recog = C.RECOGNITION_INSTRUCTION in text
            return text, content, up, pilot, recog

        def state(self, content, up, pilot, recog):
            base = gauss(f"dry|content|{content['index']}", 4)
            twin = 1.0 if random.Random(f"dry|twin|{content['index']}").random() < 0.10 else 0.0
            cue = [0.0] * 4
            if kind not in ("content-only", "deaf"):
                cue = [0.1 * x for x in gauss(f"dry|cue-noise|{content['index']}", 4)]
                for f in up:
                    cue[CODE[f] - 6] += weight
            s = base + [twin, 3.0 if pilot and kind != "deaf" else 0.0] + cue + [1.0 if recog else 0.0,
                                                               1.0 if content["x_letter"] == "A" else 0.0]
            hs = [[0.5] * H] + [[x * l for x in s] for l in range(1, LAYERS + 1)]
            if kind == "nondeterministic":
                hs = [[x + self.noise.gauss(0, 1e-3) for x in h] for h in hs]
            return hs

        def logits(self, s):
            """A function of the last state alone (but for the fault's counter)."""
            lg = [-4.0] * len(VOCAB)
            last = [x / LAYERS for x in s]
            recog, x_is_a = last[10] > 0.5, last[11] > 0.5
            a = 0.8 * last[0] + 0.5 * last[1] + 1.0 + last[5]
            if kind == "twin" and last[4] > 0.5 and last[CODE["F1"]] > 0.5:
                a += 4.0
            if kind == "follower":
                a += 1.5 * last[CODE["F2"]]
            x, y = ("A", "B") if x_is_a else ("B", "A")
            lg[VOCAB.index(x)], lg[VOCAB.index(y)] = a, 0.0
            if recog:
                lg[VOCAB.index("Yes")] = -1.0 + (0 if kind in ("content-only", "deaf") else sum(last[6:10]))
                lg[VOCAB.index("No")] = 0.0
            if kind == "off-format":
                lg[8:] = [x + 9.0 for x in lg[8:]]
            if kind == "fault":
                self.calls[0] += 1
                lg[VOCAB.index(x)] += 1e-6 * self.calls[0]
            return lg

        def run(self, prompt, names, keep_state):
            text, content, up, pilot, recog = self.read(prompt)
            hs = self.state(content, up, pilot, recog)
            lg = self.logits(hs[-1])
            mx = max(lg)
            ex = [math.exp(v - mx) for v in lg]
            z = sum(ex)
            dist = [v / z for v in ex]
            lt = self.letters(names)
            p = {n: sum(dist[i] for i in ix) for n, ix in lt.items()}
            p["other"] = max(0.0, 1.0 - sum(p.values()))
            top = max(range(len(dist)), key=dist.__getitem__)
            greedy = next((n for n, ix in lt.items() if top in ix), "other")
            from array import array
            st = array("f", [x for h in hs for x in h]).tobytes() if keep_state else None
            return {"input_sha256": hashlib.sha256(text.encode()).hexdigest(), "n_tokens": len(re.findall(r"\S+", text)),
                    "layer_sha256": [hashlib.sha256(json.dumps(h).encode()).hexdigest() for h in hs],
                    "logits_sha256": hashlib.sha256(json.dumps(lg).encode()).hexdigest(),
                    "p": p, "greedy": greedy, "state": st, "dist": dist}

        def rendered(self, prompt):
            return prompt["text"] if "text" in prompt else prompt["messages"][0]["content"] + prompt["reply_prefix"]

        def tv(self, a, b):
            return 0.5 * sum(abs(x - y) for x, y in zip(a, b))
    return Stand


FORMATIONS = ["content-only", "detected", "twin", "follower", "nondeterministic", "fault", "off-format", "deaf"]
CKPT = "qwen-tuned"


def drive(root, kind, stop_after=None):
    """The smoke run and the run of one formation, as tr2_run makes them, into root."""
    eng = make_engine(kind)
    root = Path(root)
    TR.smoke(CKPT, root / "files", "cpu", 8, engine_cls=eng, root=root / "smoke")
    TR.run(CKPT, root / "files", "cpu", 8, engine_cls=eng, root=root, stop_after=stop_after)
    return root


def expected(kind, r):
    """What the formation type implies, against what the rule read."""
    fs = r["factors"]
    S = lambda f: fs[f]["states_exact_share_apart_by_layer"]          # noqa: E731
    probe = lambda f: fs[f]["states_probe"]["status"]                # noqa: E731
    logits = lambda f: int(fs[f]["acts_exact"]["logits_apart"].split()[0])  # noqa: E731
    beh = lambda f: fs[f]["acts_sampled"]["status"]                  # noqa: E731
    n = r["pairs"]
    exact_ok = r["premise"]["exact_comparison_attainable"]
    forb = r["forbidden"]
    clean = forb["same_token_ids_apart"] == 0 and forb["last_state_equal_logits_apart"] == 0
    control = r["pilot"]["shown_apart"]
    if kind == "deaf":
        return exact_ok and clean and not control and all(
            beh(f) == "no net shift shown; uninformative: the positive control shows none either" for f in C.FACTOR_IDS)
    if kind != "off-format" and not control:
        return False
    if kind == "content-only":
        return exact_ok and clean and all(max(S(f)) == 0 and probe(f) == "not shown apart by the probe"
                                          and logits(f) == 0 and beh(f) == "no net shift shown"
                                          and fs[f]["coverage"]["S1"] == 1.0 for f in C.FACTOR_IDS)
    if kind == "detected":
        return exact_ok and clean and all(S(f)[0] == 0 and min(S(f)[1:]) == 1 and probe(f) == "apart (probe)"
                                          and logits(f) == 0 and beh(f) == "no net shift shown"
                                          and fs[f]["coverage"] == {"S1": 0.0, "S2": round(1 / 3, 4), "S3": 0.25}
                                          for f in C.FACTOR_IDS)
    if kind == "twin":      # exact acts locate the twin; the sampled acts need not show 10% of contents moved
        return exact_ok and clean and 0.05 * n < logits("F1") < 0.16 * n and beh("F1") == "a net shift" \
            and all(logits(f) == 0 and beh(f) == "no net shift shown" for f in ("F2", "F3", "F4"))
    if kind == "follower":
        return exact_ok and clean and logits("F2") == n and beh("F2") == "a net shift" \
            and fs["F2"]["acts_exact"]["tv_above_identical"]["contents"] == n \
            and all(logits(f) == 0 for f in ("F1", "F3", "F4"))
    if kind == "nondeterministic":
        return (not exact_ok) and all(S(f) == "void: exact comparison not attainable"
                                      and probe(f) == "apart (probe)"
                                      and fs[f]["coverage"] == "void: exact comparison not attainable"
                                      for f in C.FACTOR_IDS) \
            and forb["same_token_ids_apart"] == n and forb["last_state_equal_logits_apart"] == 0 \
            and all(fs[f]["acts_exact"]["tv_above_identical"]["p"] > 0.001 for f in C.FACTOR_IDS)
    if kind == "fault":
        return forb["same_token_ids_apart"] > 0 and forb["last_state_equal_logits_apart"] > 0 \
            and not exact_ok
    if kind == "off-format":
        return (not r["format"]["behaviour_read"]) and all(
            beh(f) == "void: the checkpoint does not answer in the format" for f in C.FACTOR_IDS)
    raise ValueError(kind)


def control_voids(root):
    """The probe's control at work: the identical arm's kept states shifted (an input the arms do not
    list), every factor's probe is void; unshifted, it is read."""
    folder = run_dir(root)
    gs = [g for g in TR.written(folder) if g["phase"] == "main" and g["keep_state"]]
    real = RU.states_of

    def shifted(f, g):
        st = real(f, g)
        st["identical"] = array("f", (x + 1.0 for x in st["identical"]))
        return st
    layers, hidden = LAYERS + 1, H
    plain = {f: RU.probes(folder, gs, f, layers, hidden)["status"] for f in C.FACTOR_IDS}
    RU.states_of = shifted
    try:
        void = {f: RU.probes(folder, gs, f, layers, hidden)["status"] for f in C.FACTOR_IDS}
    finally:
        RU.states_of = real
    return {"read": plain, "shifted": void,
            "ok": all(v == "apart (probe)" for v in plain.values())
            and all(v == "void: the identical arm's control rejects" for v in void.values())}


def strip_times(rows):
    return [{**g, "passes": [{k: v for k, v in p.items() if k not in ("t0", "t1")} for p in g["passes"]]}
            for g in rows]


def refusals(tmp, clean):
    """Each refusal of load, open_folder and run, on copies of a clean folder."""
    out = {}

    def copy(name):
        d = Path(tmp) / "refuse" / name
        shutil.copytree(clean, d)
        return d

    def refused(fn):
        try:
            fn()
        except (SystemExit, AssertionError):
            return True
        return False

    def edit(d, fn):
        p = run_dir(d) / "groups.jsonl"
        rows = [json.loads(x) for x in p.read_text().splitlines()]
        fn(rows)
        p.write_text("".join(json.dumps(x, sort_keys=True) + "\n" for x in rows))
    d = copy("prompt")
    edit(d, lambda rows: rows[3]["passes"][0].update(prompt_sha256="0" * 64))
    out["a changed prompt hash, refused"] = refused(lambda: TR.load(run_dir(d), CKPT, DRY_LINK))
    d = copy("state")
    st = next((run_dir(d) / "states").iterdir())
    raw = st.read_bytes()
    st.write_bytes(raw[:-4] + bytes(x ^ 0xFF for x in raw[-4:]))     # the last number's bytes inverted
    out["a changed state file, refused"] = refused(lambda: TR.load(run_dir(d), CKPT, DRY_LINK))
    d = copy("unplanned")
    edit(d, lambda rows: rows.append({**rows[0], "group": "main/choice/9999"}))
    out["a group the plan does not hold, refused"] = refused(lambda: TR.load(run_dir(d), CKPT, DRY_LINK))
    d = copy("twice")
    edit(d, lambda rows: rows.append(rows[0]))
    out["a group held twice, refused"] = refused(lambda: TR.load(run_dir(d), CKPT, DRY_LINK))
    d = copy("arms")
    edit(d, lambda rows: rows[5]["passes"].reverse())
    out["a group's arms in another order, refused"] = refused(lambda: TR.load(run_dir(d), CKPT, DRY_LINK))
    d = copy("device")
    meta = json.loads((run_dir(d) / "meta.json").read_text())
    out["a run begun on another device, refused"] = refused(
        lambda: TR.open_folder(run_dir(d), {**{k: meta[k] for k in ("kind", "checkpoint", "threads", "engine")},
                                          "device": "mps", "link": DRY_LINK}))
    out["a run carried on under another engine's code, refused"] = refused(
        lambda: TR.open_folder(run_dir(d), {**{k: meta[k] for k in ("kind", "checkpoint", "threads", "device")},
                                          "engine": {**meta["engine"], "code_sha256": "0" * 64}, "link": DRY_LINK}))
    d = Path(tmp) / "refuse" / "no-smoke"
    out["a run with no smoke run saying go on, refused"] = refused(
        lambda: TR.run(CKPT, d / "files", "cpu", 8, engine_cls=make_engine("detected"), root=d))
    out["a run under other threads than its smoke run, refused"] = refused(
        lambda: TR.run(CKPT, clean / "files", "cpu", 4, engine_cls=make_engine("detected"), root=clean))
    bad_engine = make_engine("detected")

    class Missing(bad_engine):
        def run(self, prompt, names, keep_state):
            r = super().run(prompt, names, keep_state)
            r.pop("greedy")
            return r
    d = Path(tmp) / "refuse" / "engine"
    out["an engine returning other fields, refused"] = refused(
        lambda: TR.smoke(CKPT, d / "files", "cpu", 8, engine_cls=Missing, root=d / "smoke"))
    d = copy("keep")
    edit(d, lambda rows: rows[-1].update(keep_state=not rows[-1]["keep_state"]))
    out["a group keeping states the plan does not, refused"] = refused(lambda: TR.load(run_dir(d), CKPT, DRY_LINK))
    d = copy("content")
    edit(d, lambda rows: rows[7].update(content=rows[7]["content"] + 1))
    out["a group naming another content, refused"] = refused(lambda: TR.load(run_dir(d), CKPT, DRY_LINK))
    d = copy("field")
    edit(d, lambda rows: rows[9]["passes"][1].pop("logits_sha256"))
    out["a pass missing a field, refused"] = refused(lambda: TR.load(run_dir(d), CKPT, DRY_LINK))
    d = copy("kind")
    mp = run_dir(d) / "meta.json"
    mp.write_text(json.dumps({**json.loads(mp.read_text()), "kind": "smoke"}))
    out["a folder that is not a run's, refused"] = refused(lambda: TR.load(run_dir(d), CKPT, DRY_LINK))
    d = copy("other-checkpoint")
    out["a folder read as another checkpoint's, refused"] = refused(lambda: TR.load(run_dir(d), "olmo-tuned", DRY_LINK))
    out["a folder made under an engine no link lists, refused"] = refused(
        lambda: TR.load(run_dir(d), CKPT, {**DRY_LINK, "chain": {"FROZEN.sha256": {TR.ENGINE: "0" * 64}}}))
    out["a folder naming a link not in the chain, refused"] = refused(
        lambda: TR.load(run_dir(d), CKPT, {**DRY_LINK, "chain": {"addenda/FROZEN-1.sha256": DRY_LINK["chain"]["FROZEN.sha256"]}}))
    d = copy("two-whole")
    shutil.copytree(run_dir(d), Path(d) / f"{CKPT}-{'1' * 12}")
    mp = Path(d) / f"{CKPT}-{'1' * 12}" / "meta.json"
    m2 = json.loads(mp.read_text())
    m2["engine"]["code_sha256"] = "1" * 64
    mp.write_text(json.dumps(m2))
    out["a checkpoint with two whole folders, refused"] = _two_whole(d)
    out["a stand-in engine writing into results/, refused"] = refused(
        lambda: TR.smoke(CKPT, d / "files", "cpu", 8, engine_cls=make_engine("detected")))
    d = copy("torn")
    gp = run_dir(d) / "groups.jsonl"
    raw = gp.read_bytes()
    gp.write_bytes(raw + raw[:40])
    out["a torn last line, refused by the reading"] = refused(lambda: TR.load(run_dir(d), CKPT, DRY_LINK))
    d = copy("no-report")
    sm = sorted((d / "smoke").glob(f"{CKPT}-*"))[-1]
    newer = sm.parent / (sm.name[:-2] + "99")
    shutil.copytree(sm, newer)
    (newer / "smoke-report.json").unlink()
    out["a newest smoke run with no report, refused"] = refused(
        lambda: TR.run(CKPT, d / "files", "cpu", 8, engine_cls=make_engine("detected"), root=d))
    out["ok"] = all(out.values())
    return out


def _two_whole(d):
    """read() on a root holding two whole folders of one checkpoint, each under a listed engine."""
    link = {**DRY_LINK, "chain": {"FROZEN.sha256": {TR.ENGINE: TR.sha_file(__file__)},
                                  "addenda/FROZEN-1.sha256": {TR.ENGINE: "1" * 64}}}
    keep = TR.frozen
    TR.frozen = lambda: link
    try:
        TR.read(root=d)
        return False
    except SystemExit as e:
        return "two whole runs" in str(e)
    finally:
        TR.frozen = keep


def torn_resume(tmp, whole):
    """A run stopped inside main with a torn last line goes on: the line is kept beside the log, its
    group made again, and the records equal a run made whole."""
    root = Path(tmp) / "torn-resume"
    drive(root, "detected", stop_after=600)
    gp = run_dir(root) / "groups.jsonl"
    raw = gp.read_bytes()
    gp.write_bytes(raw + raw[-300:-100])
    drive(root, "detected")
    side = list(run_dir(root).glob("groups.jsonl.torn-*"))
    return {"stopped after 600 groups, inside main": True,
            "the torn line kept beside the log": len(side) == 1 and side[0].read_bytes() == raw[-300:-100],
            "the records equal a run made whole": strip_times(TR.written(run_dir(root))) == strip_times(whole),
            "ok": len(side) == 1 and strip_times(TR.written(run_dir(root))) == strip_times(whole)}


def file_checks(tmp):
    d = Path(tmp) / "files-check"
    d.mkdir()
    (d / "config.json").write_bytes(b'{"a": 1}\n')
    (d / "model.safetensors").write_bytes(b"weights" * 100)
    spec = {"files": [{"path": "config.json", "size": 9, "git_blob": TR.git_blob(d / "config.json")},
                      {"path": "model.safetensors", "size": 700, "sha256": TR.sha_file(d / "model.safetensors")}]}
    out = {"every file with its size and hash, read": TR.check_files(spec, d) == []}
    (d / "model.safetensors").write_bytes(b"weightz" * 100)
    out["a weight file with another hash, refused"] = TR.check_files(spec, d) != []
    (d / "model.safetensors").write_bytes(b"weights" * 99)
    out["a weight file of another size, refused"] = TR.check_files(spec, d) != []
    (d / "model.safetensors").write_bytes(b"weights" * 100)
    (d / "chat_template.jinja").write_text("{{ messages }}")
    out["a file not listed, refused"] = any("not listed" in x for x in TR.check_files(spec, d))
    (d / "chat_template.jinja").unlink()
    (d / ".cache").mkdir()
    (d / ".cache" / "x.lock").write_text("")
    (d / "README.md").write_text("readme")
    out["a download's .cache and a file not loaded, read"] = TR.check_files(spec, d) == []
    (d / "config.json").unlink()
    out["a missing file, refused"] = any("missing" in x for x in TR.check_files(spec, d))
    pins = {k: v["version"] for k, v in TR.MODELS["packages"].items()}
    out["the pinned packages, read"] = TR.check_packages(lambda n: pins[n], (3, 11)) == []
    out["another transformers, refused"] = TR.check_packages(
        lambda n: "4.57.0" if n == "transformers" else pins[n], (3, 11)) != []
    out["another Python, refused"] = TR.check_packages(lambda n: pins[n], (3, 12)) != []
    out["the four checkpoints' files listed, each with a hash"] = all(
        f.get("sha256") or f.get("git_blob") for c in TR.MODELS["checkpoints"] for f in c["files"]) \
        and len(TR.MODELS["checkpoints"]) == 4
    out["ok"] = all(out.values())
    return out


def chain_checks(tmp):
    """told/run.py's frozen_check on this freeze's folder in stand-in repositories."""
    op, told = TR.OPEN, R.TOLD

    def sha(p):
        return hashlib.sha256(p.read_bytes()).hexdigest()

    def commit(r):
        R.git(r, "add", "-A")
        R.git(r, "-c", "commit.gpgsign=false", "-c", "core.hooksPath=/dev/null", "commit", "-qm", "step")

    def link(r, name, files):
        (r / op / name).parent.mkdir(parents=True, exist_ok=True)
        (r / op / name).write_text("".join(f"{sha(r / f)}  {f}\n" for f in files))
    FILES = [str(told / "run.py"), str(op / "tr2_rule.py"), str(op / "MODELS.json"), str(op / "tr2_engine.py"),
             str(op / "tr2_pass.py"), str(op / "tr2_dry_run.py")]

    def repo(name):
        r = Path(tmp) / "chain" / name
        for f in FILES:
            (r / f).parent.mkdir(parents=True, exist_ok=True)
            (r / f).write_text(f"{Path(f).name} one\n")
        R.git(r, "init", "-q")
        R.git(r, "config", "user.email", "dry-run@localhost")
        R.git(r, "config", "user.name", "dry run")
        link(r, R.BASE_LINK, FILES)
        commit(r)
        return r

    def read(r):
        try:
            return R.frozen_check(r, op, TR.MAY_CHANGE)
        except SystemExit:
            return None

    def addendum(r, changed):
        (r / changed).write_text("two\n")
        (r / op / "addenda").mkdir(exist_ok=True)
        (r / op / "addenda" / "ADDENDUM-1.md").write_text("addendum 1\n")
        link(r, "addenda/FROZEN-1.sha256", FILES + [str(op / "addenda" / "ADDENDUM-1.md")])
        commit(r)
    out = {}
    fc = read(repo("base"))
    out["the base link read, freeze 1's run.py listed"] = bool(fc) and fc["link"] == R.BASE_LINK \
        and set(fc["hashes"]) == set(FILES)
    r = repo("told-changed")
    (r / told / "run.py").write_text("two\n")
    commit(r)
    out["freeze 1's run.py changed, refused"] = read(r) is None
    for name, f in (("models", "MODELS.json"), ("rule", "tr2_rule.py")):
        r = repo(f"own-{name}")
        (r / op / f).write_text("two\n")
        commit(r)
        out[f"its {f} changed with no addendum, refused"] = read(r) is None
    r = repo("engine")
    addendum(r, op / "tr2_engine.py")
    out["an addendum changing the engine, read"] = (read(r) or {}).get("link") == "addenda/FROZEN-1.sha256"
    r = repo("models-addendum")
    addendum(r, op / "MODELS.json")
    out["an addendum changing MODELS.json, refused"] = read(r) is None
    r = repo("pass-addendum")
    addendum(r, op / "tr2_pass.py")
    out["an addendum changing the pass, refused"] = read(r) is None
    out["ok"] = all(out.values())
    return out


def smoke_checks(roots):
    d = Path(roots["detected"])
    sm = sorted((d / "smoke").glob(f"{CKPT}-*"))[-1]
    rep = json.loads((sm / "smoke-report.json").read_text())
    smoke_sha = {p["prompt_sha256"] for g in TR.written(sm) for p in g["passes"]}
    scored = {p["prompt_sha256"] for k in roots.values() for g in TR.written(run_dir(k)) for p in g["passes"]}
    return {"go on": rep["go_on"], "passes": rep["passes"], "planned": rep["planned"],
            "letters are tokens": all(v > 0 for v in rep["letter_tokens"].values()),
            "no smoke prompt is a scored one": not (smoke_sha & scored),
            "ok": rep["go_on"] and rep["passes"] == 52 and not (smoke_sha & scored)}


def roles_differ():
    """Over every content, arm and kind: a base checkpoint is given the text with "Answer:", a tuned one
    the message and the reply begun, the two the same text; a factor toggles one line; identical is base."""
    base_ok = tuned_ok = toggle_ok = ident_ok = True
    for c in C.CONTENTS:
        for kind in ("choice", "recognition"):
            for arm in C.ARMS:
                b, t = C.prompt(c, arm, kind, "base"), C.prompt(c, arm, kind, "tuned")
                base_ok &= b["text"].endswith("\nAnswer:")
                tuned_ok &= len(t["messages"]) == 1 and t["messages"][0]["role"] == "user" \
                    and t["reply_prefix"] == "Answer:" and t["messages"][0]["content"] + "\n" + t["reply_prefix"] == b["text"]
            for f in C.FACTOR_IDS:
                toggle_ok &= sum(x != y for x, y in zip(C.body(c, "base", kind).splitlines(),
                                                         C.body(c, f, kind).splitlines())) == 1
            ident_ok &= C.body(c, "base", kind) == C.body(c, "identical", kind)
    return {"base ends in Answer:": base_ok, "tuned: one user message, the reply begun, the base text": tuned_ok,
            "toggling a factor changes one line": toggle_ok, "the identical arm is base": ident_ok}


def pass_ids():
    """tr2_pass.ids with a stand-in tokenizer: the base text with the tokenizer's special tokens; the
    tuned message through the template with the generation prompt, thinking off for Qwen only, then
    "Answer:" appended, with no special tokens added."""
    import tr2_pass as PASS
    calls = []

    class Tok:
        def __call__(self, text, add_special_tokens):
            calls.append(("tok", text, add_special_tokens))
            return {"input_ids": [ord(ch) for ch in text]}

        def apply_chat_template(self, messages, tokenize, add_generation_prompt, **kw):
            calls.append(("template", tokenize, add_generation_prompt, kw))
            return "<user>" + messages[0]["content"] + "</user><assistant>"
    c = C.MAIN[0]
    b, t = C.prompt(c, "F2", "choice", "base"), C.prompt(c, "F2", "choice", "tuned")
    out = {}
    PASS.ids(Tok(), b, "qwen")
    out["base: the text, special tokens added"] = calls[-1] == ("tok", b["text"], True)
    calls.clear()
    PASS.ids(Tok(), t, "qwen")
    out["Qwen tuned: template with thinking off, then Answer:, no special tokens"] = \
        calls[0] == ("template", False, True, {"enable_thinking": False}) \
        and calls[1] == ("tok", "<user>" + t["messages"][0]["content"] + "</user><assistant>Answer:", False)
    calls.clear()
    PASS.ids(Tok(), t, "olmo")
    out["Olmo tuned: the template with no switch"] = calls[0] == ("template", False, True, {})
    out["ok"] = all(out.values())
    return out


def main():
    TR.frozen = lambda: DRY_LINK
    out = {"what": "TR2 Stage B's dry run: the frozen run and rule driven by stand-in engines; no model, no torch, "
                   "no download", "conditions": C.summary(), "prompts": roles_differ(), "the pass's token ids": pass_ids()}
    with tempfile.TemporaryDirectory() as tmp:
        roots, rows = {}, []
        for kind in FORMATIONS:
            root = drive(Path(tmp) / kind, kind)
            roots[kind] = root
            rd = TR.read(root=root)["checkpoints"][CKPT]
            ok = rd["status"] == "read" and expected(kind, rd)
            rows.append({"formation": kind, "pairs": rd.get("pairs"), "pilot": rd.get("pilot"), "ok": ok,
                         "premise": rd.get("premise"), "forbidden": rd.get("forbidden"), "format": rd.get("format"),
                         "factors": {f: {"states_exact_last": (v["states_exact_share_apart_by_layer"][-1]
                                                               if isinstance(v["states_exact_share_apart_by_layer"], list)
                                                               else v["states_exact_share_apart_by_layer"]),
                                         "probe": v["states_probe"]["status"],
                                         "probe_layers": v["states_probe"]["layers_rejected"],
                                         "logits_apart": v["acts_exact"]["logits_apart"],
                                         "mean_tv": v["acts_exact"]["mean_tv"],
                                         "tv_above_identical": v["acts_exact"]["tv_above_identical"],
                                         "sampled": [v["acts_sampled"][k] for k in ("X_base_only", "X_up_only", "p")],
                                         "behaviour": v["acts_sampled"]["status"], "coverage": v["coverage"],
                                         "misled": v["misled_content_reader_S1"]}
                                     for f, v in rd["factors"].items()},
                         "recognition": rd.get("recognition"), "identical_arm_sampled": rd.get("identical_arm_sampled")})
            print(kind, ok, rd.get("pairs"), flush=True)
        out["formations"] = rows
        whole = TR.written(run_dir(roots["detected"]))
        part = drive(Path(tmp) / "resumed", "detected", stop_after=150)
        drive(part, "detected")
        out["a run stopped after 150 groups and resumed equals one run whole"] = \
            strip_times(TR.written(run_dir(part))) == strip_times(whole) \
            and TR.read(root=part)["checkpoints"][CKPT]["factors"] == TR.read(root=roots["detected"])["checkpoints"][CKPT]["factors"]
        out["a run stopped inside main with a torn last line goes on"] = torn_resume(tmp, whole)
        out["the probe's control"] = control_voids(roots["detected"])
        out["refusals"] = refusals(tmp, roots["detected"])
        out["files_and_packages"] = file_checks(tmp)
        out["chain"] = chain_checks(tmp)
        out["smoke"] = smoke_checks(roots)
    out["ok"] = all(r["ok"] for r in out["formations"]) and all(out["prompts"].values()) \
        and out["a run stopped after 150 groups and resumed equals one run whole"] \
        and all(out[k]["ok"] for k in ("the pass's token ids", "a run stopped inside main with a torn last line goes on",
                                       "the probe's control", "refusals", "files_and_packages", "chain", "smoke"))
    (HERE / "results").mkdir(exist_ok=True)
    (HERE / "results" / "dry-run.json").write_text(json.dumps(out, indent=1) + "\n", encoding="utf-8")
    print("every check holds:", out["ok"])
    return 0 if out["ok"] else 1


if __name__ == "__main__":
    sys.exit(main())
