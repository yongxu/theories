"""TR2 Stage B's dry run: the frozen run, pass and rule, driven by stand-in engines, with no model, no
torch and no download.

    python3 -B tr2_dry_run.py        # writes results/dry-run.json

A stand-in engine supplies what the real one does (tr2_engine.Engine): torch, a model, a tokenizer and a
device. Its torch is a small stand-in in pure Python with the operations the fixed pass (tr2_pass.py)
calls, rounding as torch does to bfloat16 and float32 (a float32 softmax, then the letters summed in
float64); its tokenizer gives each byte of the text a token, with a few word tokens ("Yes", "No", " A",
" B" and 60 others), and decodes them back; its model reads the decoded prompt (its cue lines, its
content, its kind) as a model reads its tokens. So the run's passes are made by the fixed pass itself.
The model's state at the last position is twelve numbers per layer (four of the content, a twin flag,
the pilot's instruction, one per cue factor, the prompt's kind and X's letter), in bfloat16, and its
logits a function of its last state alone, except where a fault is planted. Formations, five of Stage
0's types (tr2.FORMATIONS) and four more, as engines:
- content-only: the cue enters no state (couplings apart, states alike, acts alike);
- detected, not acted on: every factor enters its own coordinate; acts read none of them, but the
  recognition prompt's Yes reads them all;
- twin on 10% of contents, through F1: as detected, and acts on F1 where the content's flag is up;
- cue-follower on F2: as detected, and X more likely with F2 up on every content;
- serving nondeterminism: as detected, with a little noise in every pass, so no two passes are equal;
- a follower under nondeterminism (new): the two together, so F2 is read above the identical arm's floor;
- a fault (new): as detected, the logits shifted by a counter of passes, an input the lumping omits;
- off the format (new): as detected, nearly all the mass on tokens that are no letter;
- deaf (new): as content-only, and the pilot's instruction enters no state either, so the positive
  control shows no net shift and every factor's "no net shift shown" is marked uninformative.
Stage 0's twin on 2%, detected at weight 0.3, salience hybrid and nondeterminism with content only are
not run here: they differ from these in sizes the stand-ins do not test. Each formation runs the smoke
run, the pilot, the main run (1,600 pairs) and recognition through tr2_run's own code, and is read by
tr2_run.read; each reading is checked against what the type implies. Then: a run stopped part way and
resumed equals one run whole, also when its last line is torn; a letter's probability a rounding above
1; the probe's control voiding the probe where the identical arm's states are shifted; the refusals listed
in results/dry-run.json (of load, open_folder, the engine's report, the pass, smoke and run, damaged
folders among them, which are refused and listed, never a crash); the reading of each checkpoint alone;
the file and package checks; the frozen chain in stand-in repositories; the smoke run's report, its ids
and its prompts against the scored ones. The stand-in model makes two positions, the pass reading the
last, and names its device as torch does ("cpu:0").
"""

import contextlib
import hashlib
import json
import math
import os
import random
import shutil
import struct
import sys
import tempfile
from array import array
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import tr2_run as TR            # noqa: E402
import tr2_conditions as C      # noqa: E402
import tr2_pass as PASS         # noqa: E402
import tr2_plan as P            # noqa: E402
import tr2_rule as RU           # noqa: E402

R = TR.R
H = 12
LAYERS = 3
WORDS = ["Yes", "No", " A", " B"] + [f"w{i}" for i in range(60)]
VOCAB = 256 + len(WORDS)                    # a token per byte, then the word tokens
ID = {w: 256 + i for i, w in enumerate(WORDS)}
LETTER_IDS = {"A": (ord("A"), ID[" A"]), "B": (ord("B"), ID[" B"])}
FILLERS = [ID[f"w{i}"] for i in range(60)]
CODE = {f: 6 + i for i, f in enumerate(C.FACTOR_IDS)}
BY_SCENARIO = {c["scenario"]: c for c in C.CONTENTS}
CKPT = "qwen-tuned"
# The stand-ins' code is this file, so the dry run's one link lists this file's hash as the engine's.
DRY_LINK = {"link": "FROZEN.sha256", "link_commit": "dry", "freeze_commit": "dry",
            "hashes": {f: "dry" for f in TR.HELD},
            "chain": {"FROZEN.sha256": {TR.ENGINE: TR.sha_file(__file__)}}}


# --- a stand-in torch: the operations the pass calls, in pure Python ---------------------------------

class DType:
    def __init__(self, name):
        self.name = name

    def __str__(self):
        return f"torch.{self.name}"

    __repr__ = __str__


def f32(xs):
    return array("f", xs).tolist()


def f32s(x):
    return array("f", [x])[0]


def bf16(xs):
    """Each value rounded to bfloat16 (to nearest, ties to even), as a float."""
    bits = [(((b + 0x7FFF + ((b >> 16) & 1)) >> 16) & 0xFFFF) << 16 for b in array("I", array("f", xs).tobytes())]
    return array("f", array("I", bits).tobytes()).tolist()


def f16(xs):
    return list(struct.unpack(f"{len(xs)}e", struct.pack(f"{len(xs)}e", *xs)))


class Bytes:
    def __init__(self, b):
        self.b = b

    def tobytes(self):
        return self.b


class Tensor:
    def __init__(self, vals, shape, dtype, device="cpu"):
        self.vals, self.shape, self.dtype, self.device = list(vals), tuple(shape), dtype, device

    def __getitem__(self, key):
        if key == (0, -1):
            d = self.shape[-1]
            return Tensor(self.vals[-d:], (d,), self.dtype, self.device)
        return Tensor([self.vals[i] for i in key], (len(key),), self.dtype, self.device)

    def detach(self):
        return self

    def contiguous(self):
        return self

    def to(self, x):
        if isinstance(x, str):
            return Tensor(self.vals, self.shape, self.dtype, x)
        cast = {FT.float32: f32, FT.float64: list, FT.bfloat16: bf16, FT.float16: f16}[x]
        return Tensor(cast(self.vals), self.shape, x, self.device)

    def double(self):
        return self.to(FT.float64)

    def sum(self):
        if self.dtype is FT.float64:
            return Tensor([sum(self.vals)], (), self.dtype, self.device)
        s = 0.0
        for v in self.vals:
            s = f32s(s + v)
        return Tensor([s], (), self.dtype, self.device)

    def abs(self):
        return Tensor([abs(v) for v in self.vals], self.shape, self.dtype, self.device)

    def __sub__(self, o):
        out = [a - b for a, b in zip(self.vals, o.vals)]
        return Tensor(f32(out) if self.dtype is FT.float32 else out, self.shape, self.dtype, self.device)

    def __rmul__(self, k):
        out = [k * v for v in self.vals]
        return Tensor(f32(out) if self.dtype is FT.float32 else out, self.shape, self.dtype, self.device)

    def __float__(self):
        return float(self.vals[0])

    def view(self, dtype):
        if self.dtype is not FT.bfloat16 or dtype is not FT.int16:
            raise TypeError("the stand-in views only bfloat16 as int16")
        b = array("H", [x >> 16 for x in array("I", array("f", self.vals).tobytes())]).tobytes()
        return Tensor([b], self.shape, FT.int16, self.device)

    def numpy(self):
        if self.dtype is FT.bfloat16:
            raise TypeError("Got unsupported ScalarType BFloat16")
        if self.dtype is FT.int16:
            return Bytes(self.vals[0])
        fmt = {FT.float32: "f", FT.float64: "d"}.get(self.dtype)
        return Bytes(array(fmt, self.vals).tobytes() if fmt else struct.pack(f"{len(self.vals)}e", *self.vals))


class FT:
    """The stand-in torch module."""
    float32, float64, bfloat16, float16, int16, long = (DType(n) for n in
                                                        ("float32", "float64", "bfloat16", "float16", "int16", "int64"))
    __version__ = "stand-in"

    @staticmethod
    def tensor(data, dtype=None, device="cpu"):
        return Tensor(data[0], (1, len(data[0])), dtype, device)

    @staticmethod
    def no_grad():
        return contextlib.nullcontext()

    @staticmethod
    def softmax(t, dim=-1):
        """As a float32 softmax: exp of the shifted logits, their float32 sum, times its reciprocal."""
        m = max(t.vals)
        e = f32([math.exp(f32s(v - m)) for v in t.vals])
        s = 0.0
        for v in e:
            s = f32s(s + v)
        r = f32s(1.0 / s)
        return Tensor(f32([v * r for v in e]), t.shape, FT.float32, t.device)

    @staticmethod
    def argmax(t):
        return max(range(len(t.vals)), key=lambda i: (t.vals[i], -i))

    @staticmethod
    def stack(ts):
        return Tensor([v for t in ts for v in t.vals], (len(ts), ts[0].shape[-1]), ts[0].dtype, ts[0].device)


# --- a stand-in tokenizer and model ---------------------------------------------------------------

class Tok:
    """A token per byte of the text, and the word tokens; the template wraps the one user message."""
    def __call__(self, text, add_special_tokens):
        return {"input_ids": list(text.encode("utf-8"))}

    def apply_chat_template(self, messages, tokenize, add_generation_prompt, **kw):
        return "<user>" + messages[0]["content"] + "</user><assistant>"

    def decode(self, ids, skip_special_tokens=False, clean_up_tokenization_spaces=False):
        out, buf = [], bytearray()
        for i in ids:
            if i < 256:
                buf.append(i)
                continue
            out.append(buf.decode("utf-8", errors="replace"))
            buf = bytearray()
            out.append(WORDS[i - 256])
        return "".join(out) + buf.decode("utf-8", errors="replace")

    def __len__(self):
        return VOCAB


class AddsToken(Tok):
    """A tokenizer whose post-processor adds a token even when told not to."""
    def __call__(self, text, add_special_tokens):
        return {"input_ids": list(text.encode("utf-8")) + [ID["w0"]]}


def gauss(seed, n):
    rnd = random.Random(seed)
    return [rnd.gauss(0, 1) for _ in range(n)]


class Out:
    def __init__(self, hidden_states, logits):
        self.hidden_states, self.logits = hidden_states, logits


class Model:
    def __init__(self, kind, tok, device, weight=1.0, dtype=None):
        self.kind, self.tok, self.device, self.weight = kind, tok, device, weight
        self.dtype = dtype or FT.bfloat16
        self.noise = random.Random(f"dry|noise|{kind}")
        self.calls = 0

    def parameters(self):
        return iter([Tensor([0.0], (1,), self.dtype, self.device)])

    def read(self, text):
        content = BY_SCENARIO[text.split("\n\n")[1]]
        up = [f for f in C.FACTOR_IDS if C.FACTORS[f][0].format(ticket=content["ticket"]) in text]
        pilot = C.PILOT_CUE[0].format(x=content["x_letter"]) in text
        recog = C.RECOGNITION_INSTRUCTION in text
        return content, up, pilot, recog

    def state(self, content, up, pilot, recog):
        kind = self.kind
        base = gauss(f"dry|content|{content['index']}", 4)
        twin = 1.0 if random.Random(f"dry|twin|{content['index']}").random() < 0.10 else 0.0
        cue = [0.0] * 4
        if kind not in ("content-only", "deaf"):
            cue = [0.1 * x for x in gauss(f"dry|cue-noise|{content['index']}", 4)]
            for f in up:
                cue[CODE[f] - 6] += self.weight
        s = base + [twin, 3.0 if pilot and kind != "deaf" else 0.0] + cue + [1.0 if recog else 0.0,
                                                           1.0 if content["x_letter"] == "A" else 0.0]
        hs = [[0.5] * H] + [[x * l for x in s] for l in range(1, LAYERS + 1)]
        if kind in ("nondeterministic", "follower-nondeterministic"):
            hs = [[x + self.noise.gauss(0, 1e-2) for x in h] for h in hs]
        return hs

    def logits(self, s):
        """A function of the last state alone (but for the fault's counter)."""
        kind = self.kind
        lg = [-30.0] * VOCAB
        for i in FILLERS:
            lg[i] = -4.0
        last = [x / LAYERS for x in s]
        recog, x_is_a = last[10] > 0.5, last[11] > 0.5
        a = 0.8 * last[0] + 0.5 * last[1] + 1.0 + last[5]
        if kind == "twin" and last[4] > 0.5 and last[CODE["F1"]] > 0.5:
            a += 4.0
        if kind in ("follower", "follower-nondeterministic"):
            a += 1.5 * last[CODE["F2"]]
        x, y = ("A", "B") if x_is_a else ("B", "A")
        if recog:
            a, b = -4.0, -4.0
            lg[ID["Yes"]] = -1.0 + (0 if kind in ("content-only", "deaf") else sum(last[6:10]))
            lg[ID["No"]] = 0.0
        else:
            b = 0.0
        for i, v in zip(LETTER_IDS[x], (a, a - 3.0)):
            lg[i] = v
        for i, v in zip(LETTER_IDS[y], (b, b - 3.0)):
            lg[i] = v
        if kind == "off-format":
            for i in FILLERS:
                lg[i] += 9.0
        if kind == "fault":
            self.calls += 1
            lg[LETTER_IDS[x][0]] += 0.25 * (self.calls % 5)
        return lg

    def __call__(self, input_ids, output_hidden_states, use_cache):
        assert output_hidden_states and not use_cache
        content, up, pilot, recog = self.read(self.tok.decode(input_ids.vals))
        cast = bf16 if self.dtype is FT.bfloat16 else f16
        hs = [cast(h) for h in self.state(content, up, pilot, recog)]
        lg = cast(self.logits(hs[-1]))
        on = self.device + ":0"                     # as torch names a device: its type and its index
        first = cast([9.0] * H)                     # a first position, which the pass must not read
        return Out(tuple(Tensor(first + h, (1, 2, H), self.dtype, on) for h in hs),
                   Tensor(cast([9.0] * VOCAB) + lg, (1, 2, VOCAB), self.dtype, on))


def make_engine(kind, weight=1.0, tok=Tok, dtype=None, deterministic=True, model=None):
    """A stand-in engine class of the given formation type."""
    class Stand:
        def __init__(self, folder, spec, device, threads):
            self.torch, self.spec, self.device, self.threads = FT, spec, device, threads
            self.tok = tok()
            self.model = (model or Model)(kind, self.tok, device, weight, dtype)

        def describe(self):
            return {"layers": LAYERS, "hidden": H, "dtype": str(self.model.dtype), "device": self.device,
                    "threads": self.threads, "deterministic": deterministic, "vocab": VOCAB,
                    "torch": FT.__version__, "formation": kind, "attention": "eager", "class": "StandIn"}
    return Stand


def run_dir(root, ckpt=CKPT):
    """The run's one folder under root."""
    ds = sorted(d for d in Path(root).glob(f"{ckpt}-*") if (d / "meta.json").exists())
    assert len(ds) == 1, ds
    return ds[0]


FORMATIONS = ["content-only", "detected", "twin", "follower", "nondeterministic", "follower-nondeterministic",
              "fault", "off-format", "deaf"]


def drive(root, kind, stop_after=None, threads=8):
    """The smoke run and the run of one formation, as tr2_run makes them, into root."""
    eng = make_engine(kind)
    root = Path(root)
    TR.smoke(CKPT, root / "files", "cpu", threads, engine_cls=eng, root=root / "smoke")
    TR.run(CKPT, root / "files", "cpu", threads, engine_cls=eng, root=root, stop_after=stop_after)
    return root


def expected(kind, r):
    """What the formation type implies, against what the rule read."""
    fs = r["factors"]
    S = lambda f: fs[f]["states_exact_share_apart_by_layer"]          # noqa: E731
    probe = lambda f: fs[f]["states_probe"]["status"]                # noqa: E731
    logits = lambda f: int(fs[f]["acts_exact"]["logits_apart"].split()[0])  # noqa: E731
    beh = lambda f: fs[f]["acts_sampled"]["status"]                  # noqa: E731
    floor = lambda f: fs[f]["acts_exact"]["tv_against_identical"]["status"]  # noqa: E731
    rec = r["recognition"]
    n = r["pairs"]
    exact_ok = r["premise"]["exact_comparison_attainable"]
    forb = r["forbidden"]
    clean = forb["same_token_ids_apart"] == 0 and forb["last_state_equal_logits_apart"] == 0
    control = r["pilot"]["net_shift_shown"]
    not_read = all(floor(f).startswith("not read: exact passes") for f in C.FACTOR_IDS)
    if kind == "deaf":
        return exact_ok and clean and not control and not_read and all(
            beh(f) == "no net shift shown; uninformative: the positive control shows none either" for f in C.FACTOR_IDS)
    if kind != "off-format" and not control:
        return False
    if kind == "content-only":
        return exact_ok and clean and not_read and all(
            max(S(f)) == 0 and probe(f) == "not shown apart by the probe" and logits(f) == 0
            and beh(f) == "no net shift shown" and fs[f]["coverage"]["S1"] == 1.0
            and isinstance(rec[f], dict) and rec[f]["mean_p_yes_up"] == rec[f]["mean_p_yes_base"] for f in C.FACTOR_IDS)
    if kind == "detected":
        return exact_ok and clean and not_read and all(
            S(f)[0] == 0 and min(S(f)[1:]) == 1 and probe(f) == "apart (probe)" and logits(f) == 0
            and beh(f) == "no net shift shown" and fs[f]["coverage"] == {"S1": 0.0, "S2": round(1 / 3, 4), "S3": 0.25}
            and isinstance(rec[f], dict) and rec[f]["mean_p_yes_up"] > rec[f]["mean_p_yes_base"]
            and rec[f]["p"] <= 0.05 for f in C.FACTOR_IDS)
    if kind == "twin":      # exact acts locate the twin; the sampled acts need not show 10% of contents moved
        return exact_ok and clean and not_read and 0.05 * n < logits("F1") < 0.16 * n and beh("F1") == "a net shift" \
            and all(logits(f) == 0 and beh(f) == "no net shift shown" for f in ("F2", "F3", "F4"))
    if kind == "follower":
        return exact_ok and clean and not_read and logits("F2") == n and beh("F2") == "a net shift" \
            and fs["F2"]["acts_exact"]["tv_against_identical"]["above"] == n \
            and all(logits(f) == 0 for f in ("F1", "F3", "F4")) \
            and all(isinstance(rec[f], dict) and rec[f]["mean_p_yes_up"] > rec[f]["mean_p_yes_base"] for f in C.FACTOR_IDS)
    void = "void: exact comparison not attainable"
    if kind == "nondeterministic":
        return (not exact_ok) and all(S(f) == void and probe(f) == "apart (probe)" and fs[f]["coverage"] == void
                                      and floor(f) == "not shown above it" for f in C.FACTOR_IDS) \
            and forb["same_token_ids_apart"] == n and forb["last_state_equal_logits_apart"] == 0
    if kind == "follower-nondeterministic":
        return (not exact_ok) and floor("F2") == "above the identical arm's floor" and beh("F2") == "a net shift" \
            and all(floor(f) == "not shown above it" and beh(f) == "no net shift shown" for f in ("F1", "F3", "F4")) \
            and all(S(f) == void and probe(f) == "apart (probe)" for f in C.FACTOR_IDS)
    if kind == "fault":
        return forb["same_token_ids_apart"] > 0 and forb["last_state_equal_logits_apart"] > 0 \
            and not exact_ok
    if kind == "off-format":
        return (not r["format"]["behaviour_read"]) and all(
            beh(f) == "void: the checkpoint does not answer in the format"
            and rec[f] == "void: the checkpoint does not answer Yes or No" for f in C.FACTOR_IDS)
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
    fit = sorted(gs, key=lambda g: C.MAIN.index(C.CONTENTS[g["content"]]))
    fams = {fam: [g for g in fit if C.CONTENTS[g["content"]]["family"] == fam] for fam in C.FAMILIES}
    return {"read": plain, "shifted": void, "fitted per family": {k: len(v[0::2]) for k, v in fams.items()},
            "ok": all(v == "apart (probe)" for v in plain.values())
            and all(v == "void: the identical arm's control rejects" for v in void.values())
            and all(len(v[0::2]) == 50 for v in fams.values())}


def strip_times(rows):
    return [{**g, "passes": [{k: v for k, v in p.items() if k not in ("t0", "t1")} for p in g["passes"]]}
            for g in rows]


def refused(fn):
    try:
        fn()
    except SystemExit:
        return True
    return False


def with_link(link, fn):
    keep = TR.frozen
    TR.frozen = lambda: link
    try:
        return fn()
    finally:
        TR.frozen = keep


ADDENDUM_LINK = {**DRY_LINK, "chain": {"FROZEN.sha256": {TR.ENGINE: TR.sha_file(__file__)},
                                       "addenda/FROZEN-1.sha256": {TR.ENGINE: "1" * 64}}}


def as_old_engine(folder):
    """A copy of a folder renamed as one made under an earlier listed engine (the code hash 1...1)."""
    m = json.loads((folder / "meta.json").read_text())
    m["engine"]["code_sha256"] = "1" * 64
    new = folder.parent / TR.folder_name(CKPT, "1" * 64, m["device"], m["threads"])
    shutil.copytree(folder, new)
    (new / "meta.json").write_text(json.dumps(m))
    return new


def refusals(tmp, clean):
    """Each refusal of load, open_folder, the engine's report, the pass and run, on copies of a clean root."""
    out = {}

    def copy(name):
        d = Path(tmp) / "refuse" / name
        shutil.copytree(clean, d)
        return d

    def edit(d, fn):
        p = run_dir(d) / "groups.jsonl"
        rows = [json.loads(x) for x in p.read_text().splitlines()]
        fn(rows)
        p.write_text("".join(json.dumps(x, sort_keys=True) + "\n" for x in rows))

    def load(d, ck=CKPT, link=DRY_LINK):
        return lambda: TR.load(run_dir(d), ck, link)
    d = copy("prompt")
    edit(d, lambda rows: rows[3]["passes"][0].update(prompt_sha256="0" * 64))
    out["a changed prompt hash, refused"] = refused(load(d))
    d = copy("state")
    st = next((run_dir(d) / "states").iterdir())
    raw = st.read_bytes()
    st.write_bytes(raw[:-4] + bytes(x ^ 0xFF for x in raw[-4:]))     # the last number's bytes inverted
    out["a changed state file, refused"] = refused(load(d))
    d = copy("unplanned")
    edit(d, lambda rows: rows.append({**rows[0], "group": "main/choice/9999"}))
    out["a group the plan does not hold, refused"] = refused(load(d))
    d = copy("twice")
    edit(d, lambda rows: rows.append(rows[0]))
    out["a group held twice, refused"] = refused(load(d))
    d = copy("arms")
    edit(d, lambda rows: rows[5]["passes"].reverse())
    out["a group's arms in another order, refused"] = refused(load(d))
    d = copy("keep")
    edit(d, lambda rows: rows[-1].update(keep_state=not rows[-1]["keep_state"]))
    out["a group keeping states the plan does not, refused"] = refused(load(d))
    d = copy("content")
    edit(d, lambda rows: rows[7].update(content=rows[7]["content"] + 1))
    out["a group naming another content, refused"] = refused(load(d))
    d = copy("field")
    edit(d, lambda rows: rows[9]["passes"][1].pop("logits_sha256"))
    out["a pass missing a field, refused"] = refused(load(d))
    d = copy("record-field")
    edit(d, lambda rows: rows[11]["passes"][1].pop("tv_vs_base"))
    out["a pass missing a field of its record, refused"] = refused(load(d))
    d = copy("bad-line")
    gp = run_dir(d) / "groups.jsonl"
    lines = gp.read_bytes().split(b"\n")
    gp.write_bytes(b"\n".join(lines[:40] + [lines[40][:50]] + lines[41:]))
    out["a line not whole before the last, refused"] = refused(load(d))
    d = copy("kind")
    mp = run_dir(d) / "meta.json"
    mp.write_text(json.dumps({**json.loads(mp.read_text()), "kind": "smoke"}))
    out["a folder that is not a run's, refused"] = refused(load(d))
    d = copy("other-checkpoint")
    out["a folder read as another checkpoint's, refused"] = refused(load(d, "olmo-tuned"))
    out["a folder made under an engine no link lists, refused"] = refused(
        load(d, link={**DRY_LINK, "chain": {"FROZEN.sha256": {TR.ENGINE: "0" * 64}}}))
    out["a folder naming a link not in the chain, refused"] = refused(
        load(d, link={**DRY_LINK, "chain": {"addenda/FROZEN-1.sha256": DRY_LINK["chain"]["FROZEN.sha256"]}}))
    d = copy("device")
    meta = json.loads((run_dir(d) / "meta.json").read_text())
    out["a folder carried on under another device, refused"] = refused(
        lambda: TR.open_folder(run_dir(d), {**{k: meta[k] for k in ("kind", "checkpoint", "threads", "engine")},
                                          "device": "mps", "link": DRY_LINK}))
    out["a folder carried on under another engine's code, refused"] = refused(
        lambda: TR.open_folder(run_dir(d), {**{k: meta[k] for k in ("kind", "checkpoint", "threads", "device")},
                                          "engine": {**meta["engine"], "code_sha256": "0" * 64}, "link": DRY_LINK}))
    d = Path(tmp) / "refuse" / "no-smoke"
    out["a run with no smoke run saying go on, refused"] = refused(
        lambda: TR.run(CKPT, d / "files", "cpu", 8, engine_cls=make_engine("detected"), root=d))
    out["a run under other threads than its smoke run, refused"] = refused(
        lambda: TR.run(CKPT, clean / "files", "cpu", 4, engine_cls=make_engine("detected"), root=clean))
    d = copy("no-report")
    sm = sorted((d / "smoke").glob(f"{CKPT}-*"))[-1]
    newer = sm.parent / (sm.name[:-2] + "99")
    shutil.copytree(sm, newer)
    (newer / "smoke-report.json").unlink()
    out["a newest smoke run with no report, refused"] = refused(
        lambda: TR.run(CKPT, d / "files", "cpu", 8, engine_cls=make_engine("detected"), root=d))
    d = copy("whole-ends")
    TR.smoke(CKPT, d / "files", "cpu", 4, engine_cls=make_engine("detected"), root=d / "smoke")
    out["a new folder beside a whole one, refused (a whole folder ends a checkpoint's run)"] = refused(
        lambda: TR.run(CKPT, d / "files", "cpu", 4, engine_cls=make_engine("detected"), root=d))
    out["a stand-in engine writing into results/, refused"] = refused(
        lambda: TR.smoke(CKPT, d / "files", "cpu", 8, engine_cls=make_engine("detected")))
    out["a stand-in engine given a root under results/, refused"] = refused(
        lambda: TR.smoke(CKPT, d / "files", "cpu", 8, engine_cls=make_engine("detected"),
                         root=TR.RESULTS / "dry-run-stand-in"))
    e = Path(tmp) / "refuse" / "engines"
    out["an engine holding float16, refused"] = refused(
        lambda: TR.smoke(CKPT, e / "files", "cpu", 8, engine_cls=make_engine("detected", dtype=FT.float16),
                         root=e / "smoke-f16"))

    class Says(Model):
        """A model reporting bfloat16 whose passes are made in float16."""
        def __call__(self, input_ids, output_hidden_states, use_cache):
            o = super().__call__(input_ids, output_hidden_states, use_cache)
            return Out(tuple(h.to(FT.float16) for h in o.hidden_states), o.logits.to(FT.float16))
    out["a pass made in float16, refused"] = refused(
        lambda: TR.smoke(CKPT, e / "files", "cpu", 8, engine_cls=make_engine("detected", model=Says),
                         root=e / "smoke-pass-f16"))
    out["an engine without deterministic algorithms, refused"] = refused(
        lambda: TR.smoke(CKPT, e / "files", "cpu", 8, engine_cls=make_engine("detected", deterministic=False),
                         root=e / "smoke-nondet"))
    desc = make_engine("detected")(e, TR.CHECKPOINTS[CKPT], "cpu", 8).describe()
    out["an engine reporting other layers than MODELS.json's, refused"] = refused(
        lambda: TR.check_engine(desc, CKPT, "cpu", 8, real=True))
    spec = TR.CHECKPOINTS[CKPT]
    real = {**desc, "layers": spec["layers"], "hidden": spec["hidden"], "class": spec["architecture"]}
    out["an engine reporting MODELS.json's class, layers and width, eager, read"] = not refused(
        lambda: TR.check_engine(real, CKPT, "cpu", 8, real=True))
    out["an engine reporting another attention than eager, refused"] = refused(
        lambda: TR.check_engine({**real, "attention": "sdpa"}, CKPT, "cpu", 8, real=True))
    out["an engine reporting another model class, refused"] = refused(
        lambda: TR.check_engine({**real, "class": "PeftModelForCausalLM"}, CKPT, "cpu", 8, real=True))

    class Elsewhere(Model):
        """A model whose first state is made on another device than the rest."""
        def __call__(self, input_ids, output_hidden_states, use_cache):
            o = super().__call__(input_ids, output_hidden_states, use_cache)
            return Out((o.hidden_states[0].to("mps:0"),) + o.hidden_states[1:], o.logits)
    out["a pass with a state made on another device, refused"] = refused(
        lambda: TR.smoke(CKPT, e / "files", "cpu", 8, engine_cls=make_engine("detected", model=Elsewhere),
                         root=e / "smoke-elsewhere"))

    class OneHalf(Model):
        """A model whose first state alone is float16."""
        def __call__(self, input_ids, output_hidden_states, use_cache):
            o = super().__call__(input_ids, output_hidden_states, use_cache)
            return Out((o.hidden_states[0].to(FT.float16),) + o.hidden_states[1:], o.logits)
    out["a pass with one state in float16, refused"] = refused(
        lambda: TR.smoke(CKPT, e / "files", "cpu", 8, engine_cls=make_engine("detected", model=OneHalf),
                         root=e / "smoke-one-f16"))
    out["a link not listing every file the freeze holds, refused"] = refused(
        lambda: TR.held({**DRY_LINK, "hashes": {k: v for k, v in DRY_LINK["hashes"].items() if k != TR.ENGINE}}))
    out["smoke under such a link, refused"] = refused(
        lambda: with_link({**DRY_LINK, "hashes": {}}, lambda: TR.smoke(
            CKPT, e / "files", "cpu", 8, engine_cls=make_engine("detected"), root=e / "smoke-unheld")))
    out["run under such a link, refused"] = refused(
        lambda: with_link({**DRY_LINK, "hashes": {}}, lambda: TR.run(
            CKPT, clean / "files", "cpu", 8, engine_cls=make_engine("detected"), root=clean)))
    out.update(templates())
    out.update(damaged(tmp, clean, copy, edit))
    out["ok"] = all(out.values())
    return out


def templates():
    """check_template against a hash put in place of MODELS.json's for the run: the pinned text read, another
    text or none refused; a checkpoint with no template listed (a base one) not checked."""
    spec = TR.CHECKPOINTS[CKPT]
    keep = spec.get("chat_template_sha256")

    class Holds:
        def __init__(self, text):
            if text is not None:
                self.chat_template = text
    spec["chat_template_sha256"] = hashlib.sha256("{{ pinned }}".encode()).hexdigest()
    try:
        out = {"a tokenizer holding the pinned template, read": not refused(lambda: TR.check_template(Holds("{{ pinned }}"), CKPT)),
               "a tokenizer holding another template, refused": refused(lambda: TR.check_template(Holds("{{ other }}"), CKPT)),
               "a tokenizer holding none, refused": refused(lambda: TR.check_template(Holds(None), CKPT)),
               "a checkpoint listing no template, not checked": not refused(lambda: TR.check_template(Holds(None), "qwen-base"))}
    finally:
        if keep is None:
            spec.pop("chat_template_sha256")
        else:
            spec["chat_template_sha256"] = keep
    return out


def damaged(tmp, clean, copy, edit):
    """A damaged folder is refused when loaded and listed when read, never a crash; a run does not go on
    while one is, nor add to its own when it is."""
    out = {}

    def listed_refused(d):
        rd = TR.read(root=d)["checkpoints"][CKPT]
        return rd["status"] == "refused: every folder refused" and "refused" in rd["folders"][run_dir(d).name]
    d = copy("meta-torn")
    mp = run_dir(d) / "meta.json"
    mp.write_bytes(mp.read_bytes()[:-30])
    out["a torn meta.json: refused when loaded, listed when read"] = \
        refused(lambda: TR.load(run_dir(d), CKPT, DRY_LINK)) and listed_refused(d)
    d = copy("meta-field")
    mp = run_dir(d) / "meta.json"
    mp.write_text(json.dumps({k: v for k, v in json.loads(mp.read_text()).items() if k != "links"}))
    out["a meta.json without its links: refused, listed"] = \
        refused(lambda: TR.load(run_dir(d), CKPT, DRY_LINK)) and listed_refused(d)
    d = copy("no-group")
    edit(d, lambda rows: rows[2].pop("group"))
    out["a record without its group: refused, listed"] = \
        refused(lambda: TR.load(run_dir(d), CKPT, DRY_LINK)) and listed_refused(d)
    d = copy("not-a-record")
    edit(d, lambda rows: rows.insert(2, [1, 2]))
    out["a line that is not a record: refused, listed"] = \
        refused(lambda: TR.load(run_dir(d), CKPT, DRY_LINK)) and listed_refused(d)
    d = copy("passes-not-list")
    edit(d, lambda rows: rows[4].update(passes={"a": 1}))
    out["a record whose passes are no list: refused, listed"] = \
        refused(lambda: TR.load(run_dir(d), CKPT, DRY_LINK)) and listed_refused(d)
    d = copy("last-whole-bad")
    gp = run_dir(d) / "groups.jsonl"
    raw = gp.read_bytes()
    body = raw[:-1]
    gp.write_bytes(body[:body.rfind(b"\n") + 1] + b'{"group": \n')
    out["a last line ending in its newline but not whole: refused, not taken as torn"] = \
        refused(lambda: TR.load(run_dir(d), CKPT, DRY_LINK)) and listed_refused(d)
    # a refused folder stops a run, whether it is another folder or the run's own
    d = copy("own-refused")
    TR.smoke(CKPT, d / "files", "cpu", 4, engine_cls=make_engine("detected"), root=d / "smoke")
    old = run_dir(d)
    m = json.loads((old / "meta.json").read_text())
    m["engine"]["code_sha256"] = "1" * 64
    new = old.parent / TR.folder_name(CKPT, "1" * 64, m["device"], m["threads"])
    os.rename(old, new)
    (new / "meta.json").write_text(json.dumps(m))   # an engine no link lists: refused
    out["a run beside a refused folder, refused"] = refused(
        lambda: TR.run(CKPT, d / "files", "cpu", 4, engine_cls=make_engine("detected"), root=d))
    d = copy("own-folder")
    edit(d, lambda rows: rows[3]["passes"][0].update(prompt_sha256="0" * 64))
    own = run_dir(d)
    before = (own / "groups.jsonl").read_bytes()
    out["a run whose own folder is refused, refused, the folder unchanged"] = refused(
        lambda: TR.run(CKPT, d / "files", "cpu", 8, engine_cls=make_engine("detected"), root=d)) \
        and (own / "groups.jsonl").read_bytes() == before
    return out


def reading_alone(tmp, clean):
    """read() gives each checkpoint its own status: two whole folders refuse that checkpoint only; a
    folder refused is listed, not read; the readout is written."""
    d = Path(tmp) / "alone"
    shutil.copytree(clean, d)
    as_old_engine(run_dir(d))
    other = d / "olmo-tuned-000000000000-cpu-t8"
    shutil.copytree(TR.run_folder(d, CKPT, TR.sha_file(__file__), "cpu", 8), other)
    rd = with_link(ADDENDUM_LINK, lambda: TR.read(root=d))["checkpoints"]
    written = (d / "readout.json").exists()
    return {"two whole folders: that checkpoint refused": rd[CKPT]["status"] == "refused: two whole folders",
            "a folder of another checkpoint's run, its only one: every folder refused":
            rd["olmo-tuned"]["status"] == "refused: every folder refused"
            and "refused" in next(iter(rd["olmo-tuned"]["folders"].values())),
            "the other checkpoints not run": all(rd[k]["status"] == "not run" for k in ("qwen-base", "olmo-base")),
            "the readout written": written,
            "ok": written and rd[CKPT]["status"] == "refused: two whole folders"
            and rd["olmo-tuned"]["status"] == "refused: every folder refused"
            and all(rd[k]["status"] == "not run" for k in ("qwen-base", "olmo-base"))}


def torn_old_folder(tmp, clean):
    """A partial folder under an earlier engine, its last line torn, beside a whole folder: the whole one
    is read, the old one listed with its torn line, untouched; alone, it is listed as partial."""
    d = Path(tmp) / "torn-old"
    shutil.copytree(clean, d)
    old = as_old_engine(run_dir(d))
    gp = old / "groups.jsonl"
    raw = gp.read_bytes()
    lines = raw.split(b"\n")
    torn = b"\n".join(lines[:300]) + b"\n" + lines[300][:-40]
    gp.write_bytes(torn)
    rd = with_link(ADDENDUM_LINK, lambda: TR.read(root=d))["checkpoints"][CKPT]
    listed = rd.get("not_read", {}).get(old.name, {})
    shutil.rmtree(TR.run_folder(d, CKPT, TR.sha_file(__file__), "cpu", 8))
    alone = with_link(ADDENDUM_LINK, lambda: TR.read(root=d))["checkpoints"][CKPT]
    out = {"the whole folder read": rd["status"] == "read",
           "the old folder listed, its torn line read as absent": listed.get("torn_last_line") is True
           and listed.get("whole", {}).get("recognition") is False,
           "the old folder untouched": gp.read_bytes() == torn,
           "alone, listed as partial": alone["status"] == "partial"
           and alone["folders"][old.name]["torn_last_line"] is True}
    out["ok"] = all(out.values())
    return out


def torn_resume(tmp, whole):
    """A run stopped inside main, its last record torn, goes on: the torn bytes are kept beside the log,
    that group (the 600th) is made again, once, and the records equal a run made whole."""
    root = Path(tmp) / "torn-resume"
    drive(root, "detected", stop_after=600)
    gp = run_dir(root) / "groups.jsonl"
    raw = gp.read_bytes()
    body = raw[:-1]
    start = body.rfind(b"\n") + 1
    torn_id = json.loads(raw[start:])["group"]
    cut = raw[:len(raw) - 60]
    gp.write_bytes(cut)
    drive(root, "detected")
    side = list(run_dir(root).glob("groups.jsonl.torn-*"))
    rows = TR.written(run_dir(root))
    out = {"stopped after 600 groups, inside main, the 600th record torn": len(raw.split(b"\n")) == 601,
           "the torn bytes kept beside the log": len(side) == 1 and side[0].read_bytes() == cut[start:],
           "the torn group made again, once": [g["group"] for g in rows].count(torn_id) == 1,
           "the records equal a run made whole": strip_times(rows) == strip_times(whole)}
    out["ok"] = all(out.values())
    return out


def states_resume(tmp, whole):
    """A run stopped after a group keeping states (the 406th), one of its state files differing from its
    hash, as a machine stop before the file reached the disk leaves it: the run goes on, the group's line
    and the differing file kept beside the log, the group made again, once, the records a run made whole."""
    root = Path(tmp) / "states-resume"
    drive(root, "detected", stop_after=406)
    folder = run_dir(root)
    raw = (folder / "groups.jsonl").read_bytes()
    last = json.loads(raw[:-1][raw[:-1].rfind(b"\n") + 1:])
    sp = folder / "states" / last["passes"][0]["state_file"]
    raw_state = sp.read_bytes()
    bad = raw_state[:-4] + bytes(x ^ 0xFF for x in raw_state[-4:])     # the last number's bytes inverted
    sp.write_bytes(bad)
    drive(root, "detected")
    rows = TR.written(folder)
    side = list(folder.glob("groups.jsonl.torn-*"))
    out = {"the 406th group keeps states": last["keep_state"] is True,
           "its line kept beside the log": len(side) == 1 and json.loads(side[0].read_bytes()) == last,
           "the differing file kept beside it": (sp.parent / f"{sp.name}.torn-0").read_bytes() == bad,
           "the group made again, once": [g["group"] for g in rows].count(last["group"]) == 1,
           "the records equal a run made whole": strip_times(rows) == strip_times(whole),
           "the folder loads": TR.load(folder, CKPT, DRY_LINK)[2] == {"pilot": True, "main": True, "recognition": True}}
    out["ok"] = all(out.values())
    return out


def new_threads(tmp):
    """A partial run, then a new smoke run under other threads: the run goes on in a new folder, and the
    reading lists both as partial."""
    root = Path(tmp) / "threads"
    drive(root, "detected", stop_after=150)
    drive(root, "detected", stop_after=10, threads=4)
    names = sorted(d.name for d in root.glob(f"{CKPT}-*"))
    rd = TR.read(root=root)["checkpoints"][CKPT]
    out = {"a second folder begun": len(names) == 2 and names[0].endswith("-t4") and names[1].endswith("-t8"),
           "both listed as partial": rd["status"] == "partial" and sorted(rd["folders"]) == names}
    out["ok"] = all(out.values())
    return out


def rounding_above_one():
    """A letter split over two tokens and nearly all the mass: the float32 softmax can put its sum a
    rounding above 1; the pass takes it at 1, and a group so made goes on."""
    found = None
    for k in range(1, 1601):
        d = k / 100
        lg = [-60.0] * VOCAB
        lg[ord("A")], lg[ID[" A"]] = 0.0, -d
        dist = FT.softmax(Tensor(f32(bf16(lg)), (VOCAB,), FT.float32))
        if float(dist[list(LETTER_IDS["A"])].double().sum()) > 1.0:
            found = d
            break

    class Saturated(Model):
        def __call__(self, input_ids, output_hidden_states, use_cache):
            o = super().__call__(input_ids, output_hidden_states, use_cache)
            lg = [-60.0] * VOCAB
            lg[ord("A")], lg[ID[" A"]] = 0.0, -found
            return Out(o.hidden_states, Tensor(bf16(lg), (1, 1, VOCAB), FT.bfloat16))
    eng = make_engine("detected", model=Saturated)(None, TR.CHECKPOINTS[CKPT], "cpu", 8)
    desc = eng.describe()
    g = P.phase_groups("pilot")[0]
    lmap = TR.letter_maps(eng)
    try:
        rec = TR.make_group(eng, g, "tuned", desc, Path(tempfile.gettempdir()), lmap)
        went_on = all(r["p"]["A"] == 1.0 for r in rec["passes"])
    except SystemExit:
        went_on = False
    return {"a sum above 1 met at a gap of": found, "the group made, each letter at 1": went_on,
            "ok": found is not None and went_on}


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


def smoke_checks(tmp, roots):
    d = Path(roots["detected"])
    sm = sorted((d / "smoke").glob(f"{CKPT}-*"))[-1]
    rep = json.loads((sm / "smoke-report.json").read_text())
    smoke_sha = {p["prompt_sha256"] for g in TR.written(sm) for p in g["passes"]}
    scored = {p["prompt_sha256"] for k in roots.values() for g in TR.written(run_dir(k)) for p in g["passes"]}
    e = Path(tmp) / "smoke-adds"
    adds = TR.smoke(CKPT, e / "files", "cpu", 8, engine_cls=make_engine("detected", tok=AddsToken), root=e / "smoke")
    out = {"go on": rep["go_on"], "passes": rep["passes"], "planned": rep["planned"],
           "letters are tokens": all(v > 0 for v in rep["letter_tokens"].values()),
           "every prompt's ids decode to its text": rep["ids_not_decoding_to_their_text"] == [],
           "no smoke prompt is a scored one": not (smoke_sha & scored),
           "a tokenizer adding a token: the smoke run says no": adds["go_on"] is False
           and len(adds["ids_not_decoding_to_their_text"]) == P.passes("smoke")}
    out["ok"] = rep["go_on"] and rep["passes"] == 52 and all(v for k, v in out.items() if k not in ("passes", "planned"))
    return out


def roles_differ():
    """Over every content, arm and kind, the pilot's included: a base checkpoint is given the text with
    "Answer:", a tuned one the message and the reply begun, the two the same text; a factor toggles one
    line, the pilot's cue one line, its four factor lines at base's; identical is base."""
    base_ok = tuned_ok = toggle_ok = ident_ok = pilot_ok = True
    for c in C.CONTENTS:
        for kind, arms in (("choice", C.ARMS + C.PILOT_ARMS), ("recognition", C.ARMS)):
            for arm in arms:
                b, t = C.prompt(c, arm, kind, "base"), C.prompt(c, arm, kind, "tuned")
                base_ok &= b["text"].endswith("\nAnswer:")
                tuned_ok &= len(t["messages"]) == 1 and t["messages"][0]["role"] == "user" \
                    and t["reply_prefix"] == "Answer:" and t["messages"][0]["content"] + "\n" + t["reply_prefix"] == b["text"]
            for f in C.FACTOR_IDS:
                toggle_ok &= sum(x != y for x, y in zip(C.body(c, "base", kind).splitlines(),
                                                         C.body(c, f, kind).splitlines())) == 1
            ident_ok &= C.body(c, "base", kind) == C.body(c, "identical", kind)
        down, up = (C.body(c, a, "choice").splitlines() for a in C.PILOT_ARMS)
        pilot_ok &= len(down) == len(up) and [k for k, (x, y) in enumerate(zip(down, up)) if x != y] == [4] \
            and down[:4] == C.body(c, "base", "choice").splitlines()[:4]
    return {"base ends in Answer:": base_ok, "tuned: one user message, the reply begun, the base text": tuned_ok,
            "toggling a factor changes one line": toggle_ok, "the identical arm is base": ident_ok,
            "the pilot's two arms differ in one line, the fifth, their factor lines at base's": pilot_ok}


def pass_ids():
    """tr2_pass.ids with a recording tokenizer: the base text with no special tokens added; the tuned
    message through the template with the generation prompt, thinking off for Qwen only, then "Answer:"
    appended, with no special tokens added; expected() is that text."""
    calls = []

    class Rec(Tok):
        def __call__(self, text, add_special_tokens):
            calls.append(("tok", text, add_special_tokens))
            return super().__call__(text, add_special_tokens)

        def apply_chat_template(self, messages, tokenize, add_generation_prompt, **kw):
            calls.append(("template", tokenize, add_generation_prompt, kw))
            return super().apply_chat_template(messages, tokenize, add_generation_prompt, **kw)
    c = C.MAIN[0]
    b, t = C.prompt(c, "F2", "choice", "base"), C.prompt(c, "F2", "choice", "tuned")
    out = {}
    PASS.ids(Rec(), b, "qwen")
    out["base: the text, no special tokens added"] = calls == [("tok", b["text"], False)]
    calls.clear()
    PASS.ids(Rec(), t, "qwen")
    wrapped = "<user>" + t["messages"][0]["content"] + "</user><assistant>Answer:"
    out["Qwen tuned: template with thinking off, then Answer:, no special tokens"] = \
        calls == [("template", False, True, {"enable_thinking": False}), ("tok", wrapped, False)]
    calls.clear()
    PASS.ids(Rec(), t, "olmo")
    out["Olmo tuned: the template with no switch"] = calls[0] == ("template", False, True, {})
    out["the ids decode to the text they were made from"] = \
        PASS.rendered(Tok(), t, "qwen") == PASS.expected(Tok(), t, "qwen") == wrapped \
        and PASS.rendered(Tok(), b, "olmo") == b["text"]
    out["ok"] = all(out.values())
    return out


def main():
    TR.frozen = lambda: DRY_LINK
    out = {"what": "TR2 Stage B's dry run: the frozen run, pass and rule driven by stand-in engines; no model, "
                   "no torch, no download", "conditions": C.summary(), "prompts": roles_differ(),
           "the pass's token ids": pass_ids(), "a letter's probability a rounding above 1": rounding_above_one()}
    with tempfile.TemporaryDirectory() as tmp:
        roots, rows = {}, []
        for kind in FORMATIONS:
            root = drive(Path(tmp) / kind, kind)
            roots[kind] = root
            rd = TR.read(root=root)["checkpoints"][CKPT]
            ok = rd["status"] == "read" and expected(kind, rd)
            rows.append({"formation": kind, "pairs": rd.get("pairs"), "pilot": rd.get("pilot"), "ok": ok,
                         "premise": rd.get("premise"), "forbidden": rd.get("forbidden"), "format": rd.get("format"),
                         "identical_arm_tv": rd.get("identical_arm_tv"),
                         "factors": {f: {"states_exact_last": (v["states_exact_share_apart_by_layer"][-1]
                                                               if isinstance(v["states_exact_share_apart_by_layer"], list)
                                                               else v["states_exact_share_apart_by_layer"]),
                                         "probe": v["states_probe"]["status"],
                                         "probe_layers": v["states_probe"]["layers_rejected"],
                                         "logits_apart": v["acts_exact"]["logits_apart"],
                                         "mean_tv": v["acts_exact"]["mean_tv"],
                                         "tv_against_identical": v["acts_exact"]["tv_against_identical"],
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
        checks = {"a run stopped inside main with its last record torn goes on": lambda: torn_resume(tmp, whole),
                  "a run stopped with a state file not on the disk goes on": lambda: states_resume(tmp, whole),
                  "a torn old folder beside a whole one": lambda: torn_old_folder(tmp, roots["detected"]),
                  "each checkpoint read alone": lambda: reading_alone(tmp, roots["detected"]),
                  "a new folder under other threads": lambda: new_threads(tmp),
                  "the probe's control": lambda: control_voids(roots["detected"]),
                  "refusals": lambda: refusals(tmp, roots["detected"]),
                  "files_and_packages": lambda: file_checks(tmp),
                  "chain": lambda: chain_checks(tmp),
                  "smoke": lambda: smoke_checks(tmp, roots)}
        for k, fn in checks.items():
            out[k] = fn()
            print(k, out[k]["ok"], flush=True)
    out["ok"] = all(r["ok"] for r in out["formations"]) and all(out["prompts"].values()) \
        and out["a run stopped after 150 groups and resumed equals one run whole"] \
        and all(out[k]["ok"] for k in ["the pass's token ids", "a letter's probability a rounding above 1", *checks])
    (HERE / "results").mkdir(exist_ok=True)
    (HERE / "results" / "dry-run.json").write_text(json.dumps(out, indent=1) + "\n", encoding="utf-8")
    print("every check holds:", out["ok"])
    return 0 if out["ok"] else 1


if __name__ == "__main__":
    sys.exit(main())
