"""TR2 Stage B, the reading: a measurement, no verdict on RF2.

RF2's theorems hold for every act law reading through a lumping, so a run can refute only a stated
lumping or an implementation, and nothing it shows confirms RF2. The stated lumping: what a pass
reads is its token ids (the cue lines included), with batch size one and no cache, and, for a
sampled act, the content's shared draw u. Per checkpoint, read from its log:

The premise. Exact comparison is attainable where every identical arm equals its base in every
hidden state and in the logits, on the whole checkpoint. Where it is not, the exact shares of states
and logits apart and the coverage are void, and the probe carries the states (Stage 0's serving
nondeterminism); the total variation is then read against the identical arm's, and the greedy
changes and the misled share stand (a near tie can flip under noise, which they do not separate).

Settled before the run. Every factor changes token ids before the last position, so in a causal
transformer its last state differs in its bits after the first block, almost surely, and the logits read
from that state differ too. Under exact passes the exact shares of states and of logits apart, and the
coverage, are therefore expected to be settled by the architecture: they record that the cue's tokens
enter the state and the logits. Where a cue's difference stops is carried by the size of the total
variation, the greedy changes and the sampled net shift. The probe is expected to reject for every
factor under exact passes too, since each cue is a fixed lexical change: a rejection shows the cue's
tokens readable along one direction at the last position across contents, not recognition.

The forbidden cases (each is the chain's congruence failing, so an implementation other than stated
or an input not listed, never a law's failure), counted as classes of passes:
- passes with the same token ids apart in a state or in the logits. In this plan only each main
  content's base and identical arms share token ids, so this case is met exactly where the premise
  fails: the stated implementation (deterministic passes) is not the one run, and which unlisted
  input made it so, nondeterminism or a fault, the count does not tell;
- passes with their last hidden state equal and their logits apart (acts apart, states equal), which
  separates what enters after the last state (in the head, by a fault or by noise there) from what
  enters the states.

Per cue factor (F1 to F4, each against base on the same contents):
- couplings: apart by construction (the token ids differ; checked);
- states, exactly: the share of contents whose state differs at each layer. Every factor changes token
  ids before the last position, so in a causal transformer these shares are expected to be one after
  the embedding: they record that the cue's tokens enter the state, not where a cue's difference stops;
- states by probe, on the 400 state contents: at each layer a difference-of-means probe fitted on the
  200 contents even-placed within their family (50 of each) and tested on the 200 others, paired: a
  held-out content counts where the probe scores its arm above its base state (ties count against),
  one-sided exact binomial against one half, Holm over the layers at 0.01. Exact under its null, a stated assumption: with no signal
  the two states of a content are exchangeable, independently across contents. A control probe, the
  identical arm against base, fitted and tested on the same contents and read the same way, voids the
  factor's probe where it rejects at any layer (the two arms differ in nothing listed, so a probe
  telling them apart shows the probe or the run reading something else); under exact passes its
  states equal base's and it cannot reject, so it guards only a run that is not exact. Evidence one
  way only: a probe that does not reject shows nothing;
- acts, exactly: the share of contents whose logits differ, the total variation between the two
  next-token distributions, the share whose greedy category changes; and, read only where the premise
  fails, the factor's total variation against the identical arm's on the same content (the floor):
  the contents above it and below it, ties dropped, a one-sided sign test, Holm over the four factors
  at 0.05, status "above the identical arm's floor" or "not shown above it". Exact under its null, a
  stated assumption: with no cue effect the two arms' total variations from base on a content are
  exchangeable, independently across contents. It is the counterpart of the logits' share apart where
  passes are not exact, and like it is expected to be settled by the token change. Under exact passes
  the floor is zero, the test repeats the logits' share apart, and it is not read;
- acts sampled under the shared draw: X taken where u < p(X), so the two arms of a content are coupled
  through u, and a pair is discordant only on a content whose sampled acts differ. The exact McNemar
  test, two-sided, Holm over the four factors at 0.05, tests a net shift toward X or toward Y over the
  contents: a factor moving contents both ways alike shows none. So the status is "a net shift" or "no
  net shift shown", never "alike", and "uninformative" where the pilot's positive control shows none
  either; the discordant pairs each way, their minority share and the mean p(X) at base are reported,
  to place the run against the power table. Void for a checkpoint whose mean mass on the two letters
  at base is under one half (it does not answer in the format);
- recognition (reported only): p(Yes) at base and with the factor up, and the same sampled test, with
  the mean mass on Yes and No at base; void where that is under one half;
- coverage of the unread under three schedules (Stage 0's S1 to S3, rho 1/4), with the measured
  lumping (two occasions in one lump where their states are equal at every layer, a lumping finer than
  the last state's, so a lower bound), on the occasions base, identical and the factor's arm of every
  main content (two cue-down occasions and one cue-up, so the values differ from Stage 0's symmetric
  tables). Fixed where lumped: Becoming.Learning.lumped_determines; not fixed where no read occasion
  shares the lump, among laws reading through the measured lumping: for any selection through
  agreement on the readings that selects such a law, Becoming.Learning.twin_selected gives a selected
  twin taking every value there (being in the lump decided, as equality of hashes is), so with a second
  act value one acts otherwise; the selection is the theorem's hypothesis, which the run does not
  measure. Expected to be settled by the token change, as the exact states are;
- the misled share of a reader whose class reads only the content, under S1 with the contents matched:
  the share of contents whose greedy category the cue changes. It has no Lean (in prose only, as the
  record says), and nothing rests on it.

The main run's pairs are fixed, N_B = 1,600: under the shared draw each content's two arms are coupled
monotonically, so a pair is discordant one way or the other as the cue raises or lowers p(X) on that
content, and the minority share of discordant pairs is the share of the shift running against its
mean. No cue but the factor shows how a factor's shift divides, so no pilot can size its pairs without
reading its outcome; 1,600 is the least size of Stage 0's grid with power 0.9 at 0.05/4 for 5 points at
a 10% base at every minority share up to 0.4, the worst the rates 10% and 15% allow (power_table). At
a base nearer one half the rates allow more, and the power at 1,600 is less (base_rate_power). The
pilot is a positive control instead: its cue (an instruction naming X's letter) is one known to move
the act, and the sampled measure must show it shift (exact McNemar at 0.05), or a factor's "no net
shift shown" is uninformative on that checkpoint. It reads no cue factor's outcome.
"""

import json
import math
import sys
from array import array
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent))
import tr2 as S0                                        # noqa: E402  Stage 0's exact tests, unchanged
import tr2_conditions as C                                  # noqa: E402
import tr2_plan as P                                        # noqa: E402

ALPHA_ACTS = 0.05
ALPHA_PROBE = 0.01
RHO = 0.25
GRID = (200, 300, 400, 600, 800, 1200, 1600)        # Stage 0's
PAIRS = C.MAIN_MAX                                  # 1,600: the least of the grid at the worst share
SHIFT = 0.05                                        # 5 points (at a 10% base)
WORST_MINORITY = 0.4                                # the worst coupling 0.10 and 0.15 allow
FORMAT_MASS = 0.5


# --- the exact tests ---------------------------------------------------------------------------

def mcnemar_p(n01, n10):
    """The exact two-sided McNemar (sign) p-value, at most 1."""
    D = n01 + n10
    if D == 0:
        return 1.0
    pm = S0.binom_pmf_list(D, 0.5)
    return min(1.0, 2 * sum(pm[: min(n01, n10) + 1]))


def binom_upper_p(correct, m):
    """P(Bin(m, 1/2) >= correct)."""
    return sum(S0.binom_pmf_list(m, 0.5)[correct:])


def holm(ps, alpha):
    """The keys Holm rejects at alpha."""
    keys = sorted(ps, key=lambda k: (ps[k], str(k)))
    out = set()
    for i, k in enumerate(keys):
        if ps[k] <= alpha / (len(keys) - i):
            out.add(k)
        else:
            break
    return out


def sampled(p, u):
    """The act a pass takes under the draw u: X where u < p(X)."""
    return "X" if u < p else "notX"


# --- the pilot ----------------------------------------------------------------------------------

def pilot_counts(groups):
    n_up = n_down = 0           # discordant pairs: X up only, X down only
    for g in groups:
        u = P.shared_u(g["content"], "pilot")
        c = C.CONTENTS[g["content"]]
        a = {r["arm"]: sampled(p_x(r, c, "choice"), u) for r in g["passes"]}
        n_up += a["pilot-up"] == "X" and a["pilot-down"] != "X"
        n_down += a["pilot-down"] == "X" and a["pilot-up"] != "X"
    return n_up, n_down


def power_table(shares=(0.0, 0.1, 0.2, 0.3, 0.4)):
    """Power at 0.05/4 to show a mean shift of 5 points, by minority share, at each size of the grid: a
    minority share m means discordance (1-m)d one way and md the other, with (1-2m)d = 0.05."""
    alpha = ALPHA_ACTS / len(C.FACTOR_IDS)
    out = {}
    for m in shares:
        d = SHIFT / (1 - 2 * m)
        out[str(m)] = {n: round(S0.power_discordant(n, (1 - m) * d, m * d, alpha), 4) for n in GRID}
    return out


def least_pairs():
    """The least size of the grid with power 0.9 at every share up to the worst."""
    t = power_table()
    return next(n for n in GRID if all(row[n] >= 0.9 for row in t.values()))


if least_pairs() != PAIRS:
    raise SystemExit("refused: N_B is not the least of the grid at the worst share")


def base_rate_power(bases=(0.10, 0.30, 0.50), n=PAIRS):
    """Power at 0.05/4 and n pairs for a 5-point shift up from each base under the worst coupling the
    two rates allow (Stage 0's worst_discordance)."""
    alpha = ALPHA_ACTS / len(C.FACTOR_IDS)
    out = {}
    for b in bases:
        pmaj, pmin = S0.worst_discordance(b, b + SHIFT)
        out[str(b)] = {"minority_share": round(pmin / (pmaj + pmin), 4),
                       "power": round(S0.power_discordant(n, pmaj, pmin, alpha), 4)}
    return out


def pilot_control(groups):
    """The positive control: whether the sampled measure shows the pilot's cue a net shift."""
    n_up, n_down = pilot_counts(groups)
    p = mcnemar_p(n_up, n_down)
    return {"discordant_up_only": n_up, "discordant_down_only": n_down, "p": p,
            "net_shift_shown": p <= ALPHA_ACTS,
            "reading": "a cue known to move the act; where it shows no net shift, a factor's 'no net shift "
                       "shown' is uninformative on this checkpoint"}


# --- reading one checkpoint ----------------------------------------------------------------------

def p_x(rec, content, kind):
    """The pass's probability of X (a choice) or of Yes (recognition)."""
    if kind == "recognition":
        return rec["p"]["Yes"]
    return rec["p"][content["x_letter"]]


def greedy_cat(rec, content, kind):
    g = rec["greedy"]
    return g if g == "other" or kind == "recognition" else C.category(g, content, kind)


def states_of(folder, g):
    """{arm: array of (layers + 1) * hidden float32} for a group that kept its states."""
    out = {}
    for r in g["passes"]:
        a = array("f")
        a.frombytes((Path(folder) / "states" / r["state_file"]).read_bytes())
        out[r["arm"]] = a
    return out


def probe(train_up, train_down, test_up, test_down):
    """Difference of means fitted on the training pairs; on the held-out pairs (one content each), the
    number whose arm scores strictly above its base, and the number of pairs."""
    n = len(train_up[0])
    mu1 = [s / len(train_up) for s in map(sum, zip(*train_up))]
    mu0 = [s / len(train_down) for s in map(sum, zip(*train_down))]
    w = [a - b for a, b in zip(mu1, mu0)]
    dot = lambda x: sum(map(float.__mul__, w, x))          # noqa: E731
    if n != len(test_up[0]) or len(test_up) != len(test_down):
        raise SystemExit("refused: the probe's states differ in shape")
    correct = sum(dot(u) > dot(d) for u, d in zip(test_up, test_down))
    return correct, len(test_up)


def probes(folder, state_groups, factor, layers, hidden):
    """Per layer: the probe (the factor's arm against base) and its control (the identical arm against
    base), each fitted on the state contents even-placed within their family and tested on the others."""
    gs = sorted(state_groups, key=lambda g: C.MAIN.index(C.CONTENTS[g["content"]]))
    train, test = [], []
    for fam in C.FAMILIES:
        fg = [g for g in gs if C.CONTENTS[g["content"]]["family"] == fam]
        train += fg[0::2]
        test += fg[1::2]
    st = {g["group"]: states_of(folder, g) for g in gs}
    sl = lambda a, l: list(a[l * hidden:(l + 1) * hidden])   # noqa: E731
    rows, ps, cps = [], {}, {}
    for l in range(layers):
        tu = [sl(st[g["group"]][factor], l) for g in train]
        td = [sl(st[g["group"]]["base"], l) for g in train]
        eu = [sl(st[g["group"]][factor], l) for g in test]
        ed = [sl(st[g["group"]]["base"], l) for g in test]
        k, m = probe(tu, td, eu, ed)
        cu = [sl(st[g["group"]]["identical"], l) for g in train]
        ce = [sl(st[g["group"]]["identical"], l) for g in test]
        ck, _ = probe(cu, td, ce, ed)
        ps[l], cps[l] = binom_upper_p(k, m), binom_upper_p(ck, m)
        rows.append({"layer": l, "accuracy": round(k / m, 4), "p": ps[l], "control_accuracy": round(ck / m, 4),
                     "control_p": cps[l]})
    rej, crej = holm(ps, ALPHA_PROBE), holm(cps, ALPHA_PROBE)
    status = ("void: the identical arm's control rejects" if crej else
              "apart (probe)" if rej else "not shown apart by the probe")
    return {"status": status, "layers_rejected": sorted(rej), "control_layers_rejected": sorted(crej), "rows": rows}


def coverage(eq_bu, eq_iu, eq_bi):
    """Expected coverage of the unread occasions of one content, by schedule, from the lumps of the
    occasions base, identical and the factor's arm (Stage 0's S1 to S3)."""
    lump = {"b": {"i": eq_bi, "u": eq_bu}, "i": {"b": eq_bi, "u": eq_iu}, "u": {"b": eq_bu, "i": eq_iu}}
    s1 = (eq_bu + eq_iu) / 2
    s2 = sum(1 - 0.5 ** sum(lump[o].values()) for o in "biu") / 3
    s3 = sum(1 - (0 if lump[o]["u"] else 1) * (1 - RHO * lump[o]["i" if o == "b" else "b"]) for o in "bi") / 2
    return s1, s2, s3


def read_checkpoint(folder, groups, describe):
    """Everything the rule reports for one checkpoint, from its groups (phase pilot, main and
    recognition, every one complete)."""
    layers = describe["layers"] + 1
    hidden = describe["hidden"]
    by_phase = {ph: [g for g in groups if g["phase"] == ph] for ph in P.PHASES}
    out = {"pilot": pilot_control(by_phase["pilot"]), "pairs": len(by_phase["main"])}
    control = out["pilot"]["net_shift_shown"]
    main = by_phase["main"]
    rec = {g["group"]: {r["arm"]: r for r in g["passes"]} for g in main}
    content = {g["group"]: C.CONTENTS[g["content"]] for g in main}

    # the premise and the forbidden cases
    def same_state(a, b):
        return a["layer_sha256"] == b["layer_sha256"]
    ident_apart = [gid for gid, r in rec.items() if not same_state(r["base"], r["identical"])
                   or r["base"]["logits_sha256"] != r["identical"]["logits_sha256"]]
    exact = not ident_apart
    every = [r for g in groups for r in g["passes"]]
    by_input, by_final = {}, {}
    for r in every:
        by_input.setdefault(r["input_sha256"], []).append(r)
        by_final.setdefault(r["layer_sha256"][-1], []).append(r)
    same_input_apart = sum(1 for rs in by_input.values()
                           if len({(tuple(x["layer_sha256"]), x["logits_sha256"]) for x in rs}) > 1)
    acts_apart_states_equal = sum(1 for rs in by_final.values() if len({x["logits_sha256"] for x in rs}) > 1)
    out["premise"] = {"exact_comparison_attainable": exact, "identical_arms_apart": len(ident_apart),
                      "of": len(rec)}
    out["forbidden"] = {"same_token_ids_apart": same_input_apart,
                        "last_state_equal_logits_apart": acts_apart_states_equal,
                        "counted": "classes of passes sharing token ids, or a last state, with values apart",
                        "reading": ("each is an implementation other than stated or an input not listed. The "
                                    "first is met exactly where the premise fails (only base and identical share "
                                    "token ids) and does not tell nondeterminism from a fault; the second separates "
                                    "what enters after the last state (in the head, by a fault or by noise there) "
                                    "from what enters the states")}
    mass = sum(r["base"]["p"]["A"] + r["base"]["p"]["B"] for r in rec.values()) / len(rec)
    fmt = mass >= FORMAT_MASS
    px_base = sum(p_x(r["base"], content[g], "choice") for g, r in rec.items()) / len(rec)
    out["format"] = {"mean_letter_mass_at_base": round(mass, 4), "behaviour_read": fmt,
                     "mean_px_at_base": round(px_base, 4)}
    tv_floor = {g: r["identical"]["tv_vs_base"] for g, r in rec.items()}
    out["identical_arm_tv"] = {"mean": round(sum(tv_floor.values()) / len(rec), 6),
                               "max": round(max(tv_floor.values()), 6)}

    # per factor
    state_groups = [g for g in main if g["keep_state"]]
    factors, behaviour_p, floor_p = {}, {}, {}
    for f in C.FACTOR_IDS:
        n = len(rec)
        coupled = sum(r["base"]["input_sha256"] != r[f]["input_sha256"] for r in rec.values())
        per_layer = [sum(r["base"]["layer_sha256"][l] != r[f]["layer_sha256"][l] for r in rec.values()) / n
                     for l in range(layers)]
        logits_apart = sum(r["base"]["logits_sha256"] != r[f]["logits_sha256"] for r in rec.values())
        tv = [r[f]["tv_vs_base"] for r in rec.values()]
        above = sum(r[f]["tv_vs_base"] > tv_floor[g] for g, r in rec.items())
        below = sum(r[f]["tv_vs_base"] < tv_floor[g] for g, r in rec.items())
        floor_p[f] = binom_upper_p(above, above + below) if above + below else 1.0
        greedy_changed = sum(greedy_cat(r["base"], content[g], "choice") != greedy_cat(r[f], content[g], "choice")
                             for g, r in rec.items())
        n01 = n10 = 0
        dp = 0.0
        for g, r in rec.items():
            u = P.shared_u(content[g]["index"], "choice")
            pb, pu = p_x(r["base"], content[g], "choice"), p_x(r[f], content[g], "choice")
            dp += pu - pb
            sb, su = sampled(pb, u), sampled(pu, u)
            n01 += sb == "X" and su != "X"
            n10 += su == "X" and sb != "X"
        behaviour_p[f] = mcnemar_p(n01, n10)
        cov = [coverage(same_state(r["base"], r[f]), same_state(r["identical"], r[f]),
                        same_state(r["base"], r["identical"])) for r in rec.values()]
        factors[f] = {
            "couplings_apart": f"{coupled} of {n}",
            "states_exact_share_apart_by_layer": [round(x, 4) for x in per_layer],
            "states_probe": probes(folder, state_groups, f, layers, hidden) if state_groups else None,
            "acts_exact": {"logits_apart": f"{logits_apart} of {n}", "mean_tv": round(sum(tv) / n, 6),
                           "max_tv": round(max(tv), 6), "greedy_category_changed": f"{greedy_changed} of {n}",
                           "tv_against_identical": {"above": above, "below": below, "ties": n - above - below,
                                                    "p": floor_p[f]}},
            "acts_sampled": {"X_base_only": n01, "X_up_only": n10, "p": behaviour_p[f],
                             "discordant_contents": n01 + n10,
                             "minority_share": round(min(n01, n10) / (n01 + n10), 4) if n01 + n10 else None,
                             "mean_px_up_minus_base": round(dp / n, 6)},
            "coverage": {s: round(sum(c[i] for c in cov) / n, 4) for i, s in enumerate(("S1", "S2", "S3"))},
            "misled_content_reader_S1": round(greedy_changed / n, 4),
        }
    rej, frej = holm(behaviour_p, ALPHA_ACTS), holm(floor_p, ALPHA_ACTS)
    for f in C.FACTOR_IDS:
        factors[f]["acts_exact"]["tv_against_identical"]["status"] = (
            "not read: exact passes (the floor is zero; the logits' share apart carries it)" if exact else
            "above the identical arm's floor" if f in frej else "not shown above it")
        factors[f]["acts_sampled"]["net_shift"] = (f in rej) if fmt else None
        factors[f]["acts_sampled"]["status"] = (
            "void: the checkpoint does not answer in the format" if not fmt else
            "a net shift" if f in rej else
            "no net shift shown" if control else
            "no net shift shown; uninformative: the positive control shows none either")
        if not exact:
            factors[f]["states_exact_share_apart_by_layer"] = "void: exact comparison not attainable"
            factors[f]["acts_exact"]["logits_apart"] = "void: exact comparison not attainable"
            factors[f]["coverage"] = "void: exact comparison not attainable"
    ident = [(sampled(p_x(r["base"], content[g], "choice"), P.shared_u(content[g]["index"], "choice")),
              sampled(p_x(r["identical"], content[g], "choice"), P.shared_u(content[g]["index"], "choice")))
             for g, r in rec.items()]
    out["identical_arm_sampled"] = {"discordant": sum(a != b for a, b in ident),
                                    "p": mcnemar_p(sum(a == "X" != b for a, b in ident),
                                                   sum(b == "X" != a for a, b in ident))}
    out["factors"] = factors

    # recognition, reported only
    recog = {}
    rg = {g["group"]: {r["arm"]: r for r in g["passes"]} for g in by_phase["recognition"]}
    yn = sum(r["base"]["p"]["Yes"] + r["base"]["p"]["No"] for r in rg.values()) / (len(rg) or 1)
    recog_read = yn >= FORMAT_MASS
    for f in C.FACTOR_IDS:
        n01 = n10 = 0
        yb = yu = 0.0
        for gid, r in rg.items():
            ci = int(gid.rsplit("/", 1)[1])
            u = P.shared_u(ci, "recognition")
            pb, pu = r["base"]["p"]["Yes"], r[f]["p"]["Yes"]
            yb, yu = yb + pb, yu + pu
            sb, su = sampled(pb, u), sampled(pu, u)
            n01 += sb == "X" and su != "X"
            n10 += su == "X" and sb != "X"
        k = len(rg) or 1
        recog[f] = {"mean_p_yes_base": round(yb / k, 4), "mean_p_yes_up": round(yu / k, 4),
                    "yes_base_only": n01, "yes_up_only": n10, "p": mcnemar_p(n01, n10)} if recog_read else \
            "void: the checkpoint does not answer Yes or No"
    recog["mean_yes_no_mass_at_base"] = round(yn, 4)
    out["recognition"] = recog
    return out


LABEL = ("TR2 is a measurement of the chain's correspondence, not a test of RF2: per checkpoint and cue factor, "
         "which link of couplings, states and acts is shown apart, how far, and what a schedule of reading fixes. A "
         "forbidden case observed shows an implementation other than stated or an input not listed. Nothing "
         "here confirms RF2, and a factor with no net shift shown is not shown to leave the acts alike.")


if __name__ == "__main__":
    print(json.dumps({"label": LABEL}, indent=1))
