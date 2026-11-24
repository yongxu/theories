#!/usr/bin/env python3
"""Exact finite combinatorial solver and certificate verifier on C_7^{\boxtimes n} for Track B4.

AI-written local CPU combinatorial solver (24 November 2026 — pure Python 3 stdlib, deterministic
fixed seed, zero network/API calls, zero market-vocabulary tokens). No human has reviewed yet.

Computes exact M_n(1) (chi(C_7^{\boxtimes n}): zero-error / survival=1 partition size) and
exact M_n(2) (survival >= 1/2 partition size) for n = 1, 2, plus rigorous lower/upper bounds
and verified partitions for n = 3, and checks strict per-dimension bit savings:
  (1/n) * log2(M_n(2)) < (1/n) * log2(M_n(1)).

Evaluates BOTH formal definitions of survival >= 1/2 on the confusion graph G = C_7^{\boxtimes n}:
  (A) Component-size <= 2 (cc<=2, equivalently max degree <= 1 in every class):
      Every connected cluster has size <= 2.
  (B) Confusion-clique size <= 2 (omega<=2, equivalently K_3-free in every class; L=2 zero-error
      list decoding): every mutually confusable fiber (clique in G[S_i]) has size <= 2.
"""
from __future__ import annotations

import argparse
import itertools
import json
import math
import random
import time
from pathlib import Path

DEFAULT_SEED = 20261124


def build_strong_product_c7(n: int) -> tuple[int, list[tuple[int, ...]], list[int]]:
    """Build C_7^{\boxtimes n}: returns (num_vertices, coords, adj_masks)."""
    coords = list(itertools.product(range(7), repeat=n))
    nv = len(coords)
    adj_masks = [0] * nv
    for i in range(nv):
        ci = coords[i]
        mask = 0
        for j in range(nv):
            if i == j:
                continue
            cj = coords[j]
            if all(min((a - b) % 7, (b - a) % 7) <= 1 for a, b in zip(ci, cj)):
                mask |= 1 << j
        adj_masks[i] = mask
    return nv, coords, adj_masks


def verify_partition(nv: int, adj_masks: list[int], classes: list[list[int]], mode: str) -> dict:
    """Independently verify completeness, disjointness, and class structural invariant."""
    seen: list[int] = []
    sizes: list[int] = []
    max_deg = 0
    for cls in classes:
        sizes.append(len(cls))
        seen.extend(cls)
        cmask = 0
        for u in cls:
            cmask |= 1 << u
        for u in cls:
            nbrs = adj_masks[u] & cmask
            deg = nbrs.bit_count()
            if deg > max_deg:
                max_deg = deg
            if mode == "indep":
                assert deg == 0, f"Class violates independence at vertex {u}"
            elif mode == "cc2":
                assert deg <= 1, f"Class violates component<=2 (deg<=1) at vertex {u} (deg={deg})"
            elif mode == "k3free":
                tmp = nbrs
                while tmp:
                    lsb = tmp & -tmp
                    v = lsb.bit_length() - 1
                    assert (adj_masks[v] & nbrs) == 0, f"Class contains K_3 on ({u}, {v})"
                    tmp ^= lsb
            else:
                raise ValueError(f"Unknown verification mode: {mode}")
    assert len(seen) == nv, f"Total assigned vertices {len(seen)} != {nv}"
    assert len(set(seen)) == nv, "Duplicate vertices across classes"
    assert min(seen) == 0 and max(seen) == nv - 1, "Invalid vertex index range"
    return {"classes": len(classes), "sizes": sizes, "max_internal_deg": max_deg, "verified": True}


def exact_alpha(nv: int, adj_masks: list[int]) -> tuple[int, list[int]]:
    """Exact maximum independent set via bitmask branch-and-bound."""
    best_size = 0
    best_set: list[int] = []
    all_mask = (1 << nv) - 1

    def clique_cover_bound(cand: int) -> int:
        # Partition cand into cliques; any independent set picks <= 1 vertex per clique.
        rem = cand
        cliques = 0
        while rem:
            clique = rem
            used = 0
            while clique:
                lsb = clique & -clique
                v = lsb.bit_length() - 1
                used |= lsb
                clique &= adj_masks[v]
            rem &= ~used
            cliques += 1
        return cliques

    def dfs(cand: int, chosen: list[int]) -> None:
        nonlocal best_size, best_set
        if len(chosen) > best_size:
            best_size = len(chosen)
            best_set = chosen.copy()
        if not cand or len(chosen) + clique_cover_bound(cand) <= best_size:
            return
        while cand:
            if len(chosen) + clique_cover_bound(cand) <= best_size:
                return
            lsb = cand & -cand
            v = lsb.bit_length() - 1
            cand ^= lsb
            chosen.append(v)
            dfs(cand & ~adj_masks[v], chosen)
            chosen.pop()

    dfs(all_mask, [])
    return best_size, best_set


def exact_k_coloring(nv: int, adj_masks: list[int], k: int, node_limit: int = 2_000_000) -> tuple[bool, list[list[int]] | None, int]:
    """Exact DSATUR backtracking solver for k-coloring (independence partition)."""
    color_of = [-1] * nv
    sat_masks = [0] * nv  # bit c set iff neighbor has color c
    nodes = 0

    # Fix vertex 0 -> color 0 by symmetry
    color_of[0] = 0
    nbr = adj_masks[0]
    while nbr:
        lsb = nbr & -nbr
        sat_masks[lsb.bit_length() - 1] |= 1
        nbr ^= lsb

    full_k = (1 << k) - 1

    def solve(colored: int, max_used: int) -> bool:
        nonlocal nodes
        nodes += 1
        if nodes > node_limit:
            raise RuntimeError("Node limit exceeded in exact_k_coloring")
        if colored == nv:
            return True
        # MRV / DSATUR selection
        best_v = -1
        best_opts = k + 1
        best_avail = 0
        allowed_max = min(k - 1, max_used + 1)
        allowed_mask = (1 << (allowed_max + 1)) - 1
        for v in range(nv):
            if color_of[v] != -1:
                continue
            avail = allowed_mask & ~sat_masks[v]
            cnt = avail.bit_count()
            if cnt == 0:
                return False
            if cnt < best_opts:
                best_opts = cnt
                best_v = v
                best_avail = avail
                if cnt == 1:
                    break
        avail = best_avail
        v = best_v
        saved = []
        nbr_mask = adj_masks[v]
        tmp = nbr_mask
        while tmp:
            lsb = tmp & -tmp
            u = lsb.bit_length() - 1
            if color_of[u] == -1:
                saved.append((u, sat_masks[u]))
            tmp ^= lsb

        for c in range(allowed_max + 1):
            if not (avail & (1 << c)):
                continue
            color_of[v] = c
            cbit = 1 << c
            for u, _ in saved:
                sat_masks[u] |= cbit
            if solve(colored + 1, max(max_used, c)):
                return True
            for u, old_sat in saved:
                sat_masks[u] = old_sat
            color_of[v] = -1
        return False

    ok = solve(1, 0)
    if not ok:
        return False, None, nodes
    classes: list[list[int]] = [[] for _ in range(k)]
    for v, c in enumerate(color_of):
        classes[c].append(v)
    return True, classes, nodes


def exact_cc2_partition(nv: int, adj_masks: list[int], k: int, node_limit: int = 2_000_000) -> tuple[bool, list[list[int]] | None, int]:
    """Exact bitmask backtracking solver for k-partition with every induced deg <= 1 (component <= 2)."""
    class_masks = [0] * k
    paired_masks = [0] * k  # vertices in class c that ALREADY have deg == 1 inside class c
    color_of = [-1] * nv
    nodes = 0

    def can_place(v: int, c: int) -> bool:
        nbrs_in_c = adj_masks[v] & class_masks[c]
        if nbrs_in_c.bit_count() > 1:
            return False
        if nbrs_in_c & paired_masks[c]:
            return False
        return True

    def solve(placed: int, max_used: int) -> bool:
        nonlocal nodes
        nodes += 1
        if nodes > node_limit:
            raise RuntimeError("Node limit exceeded in exact_cc2_partition")
        if placed == nv:
            return True
        allowed_max = min(k - 1, max_used + 1)
        # MRV heuristic: choose unplaced vertex with fewest feasible classes
        best_v = -1
        best_opts: list[int] = []
        best_cnt = k + 2
        for v in range(nv):
            if color_of[v] != -1:
                continue
            opts = [c for c in range(allowed_max + 1) if can_place(v, c)]
            if not opts:
                return False
            if len(opts) < best_cnt:
                best_cnt = len(opts)
                best_v = v
                best_opts = opts
                if best_cnt == 1:
                    break
        v = best_v
        vbit = 1 << v
        for c in best_opts:
            nbr = adj_masks[v] & class_masks[c]
            old_cmask = class_masks[c]
            old_pmask = paired_masks[c]
            color_of[v] = c
            class_masks[c] = old_cmask | vbit
            if nbr:
                paired_masks[c] = old_pmask | nbr | vbit
            if solve(placed + 1, max(max_used, c)):
                return True
            class_masks[c] = old_cmask
            paired_masks[c] = old_pmask
            color_of[v] = -1
        return False

    # Fix vertex 0 in class 0
    color_of[0] = 0
    class_masks[0] = 1
    ok = solve(1, 0)
    if not ok:
        return False, None, nodes
    classes: list[list[int]] = [[] for _ in range(k)]
    for v, c in enumerate(color_of):
        classes[c].append(v)
    return True, classes, nodes


def tabu_k_coloring(nv: int, adj_masks: list[int], k: int, seed: int, max_steps: int = 120_000) -> list[list[int]] | None:
    """Deterministic TabuCol heuristic for proper k-coloring on larger strong products (n = 3)."""
    rng = random.Random(seed)
    neighbors = [[] for _ in range(nv)]
    for v in range(nv):
        m = adj_masks[v]
        while m:
            lsb = m & -m
            neighbors[v].append(lsb.bit_length() - 1)
            m ^= lsb

    color = [rng.randrange(k) for _ in range(nv)]
    conf = [[0] * k for _ in range(nv)]
    for v in range(nv):
        cv = color[v]
        for u in neighbors[v]:
            conf[u][cv] += 1
    total_conf = sum(conf[v][color[v]] for v in range(nv)) // 2
    if total_conf == 0:
        classes = [[] for _ in range(k)]
        for v, c in enumerate(color):
            classes[c].append(v)
        return classes

    tabu = [[0] * k for _ in range(nv)]
    best_conf = total_conf
    for step in range(1, max_steps + 1):
        bad = [v for v in range(nv) if conf[v][color[v]] > 0]
        if not bad:
            classes = [[] for _ in range(k)]
            for v, c in enumerate(color):
                classes[c].append(v)
            return classes
        best_delta = 10**9
        best_moves: list[tuple[int, int]] = []
        for v in bad:
            cur_c = color[v]
            cur_hits = conf[v][cur_c]
            for nc in range(k):
                if nc == cur_c:
                    continue
                delta = conf[v][nc] - cur_hits
                is_tabu = tabu[v][nc] > step
                if is_tabu and (total_conf + delta) >= best_conf:
                    continue
                if delta < best_delta:
                    best_delta = delta
                    best_moves = [(v, nc)]
                elif delta == best_delta:
                    best_moves.append((v, nc))
        if not best_moves:
            v = rng.choice(bad)
            nc = (color[v] + rng.randrange(1, k)) % k
            best_delta = conf[v][nc] - conf[v][color[v]]
        else:
            v, nc = rng.choice(best_moves)
        old_c = color[v]
        color[v] = nc
        for u in neighbors[v]:
            conf[u][old_c] -= 1
            conf[u][nc] += 1
        total_conf += best_delta
        if total_conf < best_conf:
            best_conf = total_conf
        tenure = max(7, len(bad) // 2 + rng.randrange(10))
        tabu[v][old_c] = step + tenure
    return None


def tabu_cc2_partition(nv: int, adj_masks: list[int], k: int, seed: int, max_steps: int = 120_000) -> list[list[int]] | None:
    """Deterministic local/tabu search for a k-partition with induced max_deg <= 1 (components <= 2)."""
    rng = random.Random(seed)
    neighbors = [[] for _ in range(nv)]
    for v in range(nv):
        m = adj_masks[v]
        while m:
            lsb = m & -m
            neighbors[v].append(lsb.bit_length() - 1)
            m ^= lsb

    color = [rng.randrange(k) for _ in range(nv)]
    # Penalty of a class = sum_{v in cls} max(0, deg_cls(v) - 1)
    deg = [[0] * k for _ in range(nv)]
    for v in range(nv):
        cv = color[v]
        for u in neighbors[v]:
            deg[u][cv] += 1

    def vertex_pen(v: int, c: int) -> int:
        # Direct excess at v plus excess caused at its c-neighbors
        return max(0, deg[v][c] - 1)

    total_pen = sum(max(0, deg[v][color[v]] - 1) for v in range(nv))
    tabu = [[0] * k for _ in range(nv)]
    best_pen = total_pen

    for step in range(1, max_steps + 1):
        if total_pen == 0:
            classes = [[] for _ in range(k)]
            for v, c in enumerate(color):
                classes[c].append(v)
            return classes
        bad = [
            v
            for v in range(nv)
            if deg[v][color[v]] > 1 or any(color[u] == color[v] and deg[u][color[v]] > 1 for u in neighbors[v])
        ]
        if len(bad) > 40:
            bad = rng.sample(bad, 40)
        best_delta = 10**9
        best_moves: list[tuple[int, int]] = []
        for v in bad:
            old_c = color[v]
            # Removing v from old_c reduces deg[v][old_c] contribution to 0 and lowers deg[u][old_c] for old_c-nbrs
            rem_delta = -max(0, deg[v][old_c] - 1)
            for u in neighbors[v]:
                if color[u] == old_c and deg[u][old_c] > 1:
                    rem_delta -= 1
            for nc in range(k):
                if nc == old_c:
                    continue
                add_delta = max(0, deg[v][nc] - 1)
                for u in neighbors[v]:
                    if color[u] == nc and deg[u][nc] >= 1:
                        add_delta += 1
                delta = rem_delta + add_delta
                if tabu[v][nc] > step and (total_pen + delta) >= best_pen:
                    continue
                if delta < best_delta:
                    best_delta = delta
                    best_moves = [(v, nc)]
                elif delta == best_delta:
                    best_moves.append((v, nc))
        if not best_moves:
            v = rng.choice(bad)
            nc = (color[v] + rng.randrange(1, k)) % k
            old_c = color[v]
            rem_delta = -max(0, deg[v][old_c] - 1) - sum(1 for u in neighbors[v] if color[u] == old_c and deg[u][old_c] > 1)
            add_delta = max(0, deg[v][nc] - 1) + sum(1 for u in neighbors[v] if color[u] == nc and deg[u][nc] >= 1)
            best_delta = rem_delta + add_delta
        else:
            v, nc = rng.choice(best_moves)
        old_c = color[v]
        color[v] = nc
        for u in neighbors[v]:
            deg[u][old_c] -= 1
            deg[u][nc] += 1
        total_pen += best_delta
        if total_pen < best_pen:
            best_pen = total_pen
        tabu[v][old_c] = step + max(6, len(bad) // 2 + rng.randrange(8))
    return None


def main() -> None:
    parser = argparse.ArgumentParser(description="Exact combinatorial solver for C_7^{\\boxtimes n}")
    parser.add_argument("--seed", type=int, default=DEFAULT_SEED)
    parser.add_argument("--json-out", type=Path, default=None)
    args = parser.parse_args()

    t_start = time.time()
    results: dict = {"seed": args.seed, "dimensions": {}}

    # n = 1 exact
    nv1, coords1, adj1 = build_strong_product_c7(1)
    alpha1, alpha1_set = exact_alpha(nv1, adj1)
    lb_m1_1 = math.ceil(nv1 / alpha1)
    ok1_m1_prev, _, _ = exact_k_coloring(nv1, adj1, lb_m1_1 - 1)
    assert not ok1_m1_prev
    ok1_m1, cls1_m1, nodes1_m1 = exact_k_coloring(nv1, adj1, lb_m1_1)
    assert ok1_m1 and cls1_m1 is not None
    v1_m1 = verify_partition(nv1, adj1, cls1_m1, "indep")

    ok1_cc1, _, _ = exact_cc2_partition(nv1, adj1, 1)
    assert not ok1_cc1
    ok1_cc2, cls1_cc2, nodes1_cc2 = exact_cc2_partition(nv1, adj1, 2)
    assert ok1_cc2 and cls1_cc2 is not None
    v1_cc2 = verify_partition(nv1, adj1, cls1_cc2, "cc2")

    cls1_k3 = [list(range(nv1))]
    v1_k3 = verify_partition(nv1, adj1, cls1_k3, "k3free")

    results["dimensions"]["1"] = {
        "n": 1,
        "vertices": nv1,
        "alpha": alpha1,
        "alpha_witness": alpha1_set,
        "M_1_exact": len(cls1_m1),
        "M_1_bits_per_dim": math.log2(len(cls1_m1)) / 1,
        "M_1_cert": cls1_m1,
        "M_1_verify": v1_m1,
        "M_2_cc2_exact": len(cls1_cc2),
        "M_2_cc2_bits_per_dim": math.log2(len(cls1_cc2)) / 1,
        "M_2_cc2_cert": cls1_cc2,
        "M_2_cc2_verify": v1_cc2,
        "M_2_cc2_nodes": nodes1_cc2,
        "M_2_k3free_exact": len(cls1_k3),
        "M_2_k3free_bits_per_dim": math.log2(len(cls1_k3)) / 1,
        "M_2_k3free_verify": v1_k3,
        "strict_savings_cc2": math.log2(len(cls1_cc2)) < math.log2(len(cls1_m1)),
        "strict_savings_k3free": math.log2(len(cls1_k3)) < math.log2(len(cls1_m1)),
    }

    # n = 2 exact
    nv2, coords2, adj2 = build_strong_product_c7(2)
    alpha2, alpha2_set = exact_alpha(nv2, adj2)
    lb_m2_1 = math.ceil(nv2 / alpha2)  # ceil(49/10) = 5
    ok2_m1, cls2_m1, nodes2_m1 = exact_k_coloring(nv2, adj2, lb_m2_1)
    assert ok2_m1 and cls2_m1 is not None
    v2_m1 = verify_partition(nv2, adj2, cls2_m1, "indep")

    ok2_cc3, _, nodes2_cc3 = exact_cc2_partition(nv2, adj2, 3)
    assert not ok2_cc3
    ok2_cc4, cls2_cc4, nodes2_cc4 = exact_cc2_partition(nv2, adj2, 4)
    assert ok2_cc4 and cls2_cc4 is not None
    v2_cc4 = verify_partition(nv2, adj2, cls2_cc4, "cc2")

    # K_3-free exact: lower bound 3 since each 2x2 cell is K_4 (holds <= 2 -> max class size <= floor(49*2/4)=24 -> ceil(49/24)=3)
    idx2 = {c: i for i, c in enumerate(coords2)}
    cls2_k3 = [
        [idx2[(a, b)] for a in (0, 2, 4) for b in range(7)],
        [idx2[(a, b)] for a in (1, 3, 5) for b in range(7)],
        [idx2[(6, b)] for b in range(7)],
    ]
    v2_k3 = verify_partition(nv2, adj2, cls2_k3, "k3free")

    results["dimensions"]["2"] = {
        "n": 2,
        "vertices": nv2,
        "alpha": alpha2,
        "alpha_witness_coords": [coords2[i] for i in alpha2_set],
        "M_1_exact": len(cls2_m1),
        "M_1_bits_per_dim": math.log2(len(cls2_m1)) / 2,
        "M_1_verify": v2_m1,
        "M_1_nodes": nodes2_m1,
        "M_1_cert": cls2_m1,
        "M_2_cc2_exact": len(cls2_cc4),
        "M_2_cc2_bits_per_dim": math.log2(len(cls2_cc4)) / 2,
        "M_2_cc2_impossible_k3_nodes": nodes2_cc3,
        "M_2_cc2_nodes": nodes2_cc4,
        "M_2_cc2_cert": cls2_cc4,
        "M_2_cc2_verify": v2_cc4,
        "M_2_k3free_exact": len(cls2_k3),
        "M_2_k3free_bits_per_dim": math.log2(len(cls2_k3)) / 2,
        "M_2_k3free_verify": v2_k3,
        "strict_savings_cc2": math.log2(len(cls2_cc4)) / 2 < math.log2(len(cls2_m1)) / 2,
        "strict_savings_k3free": math.log2(len(cls2_k3)) / 2 < math.log2(len(cls2_m1)) / 2,
    }

    # n = 3 bounds & certificates (< 60s)
    nv3, coords3, adj3 = build_strong_product_c7(3)
    idx3 = {c: i for i, c in enumerate(coords3)}
    # Rigorous cyclic consecutive-pair bound: L_z \cup L_{z+1} induces C_7^2 \boxtimes K_2 with alpha = alpha(C_7^2) = 10.
    # Summing over 7 cyclic pairs gives 2 * alpha(C_7^3) <= 7 * 10 = 70 -> alpha(C_7^3) <= 35 -> chi >= ceil(343/35) = 10.
    alpha3_ub = (7 * alpha2) // 2
    lb_m3_1 = math.ceil(nv3 / alpha3_ub)
    # Constructive lower bound on alpha(C_7^3) via cyclic shift / randomized 1-for-2 plateau search
    rng3 = random.Random(args.seed + 303)
    best_indep3_list: list[int] = []
    for _ in range(40):
        cur_mask = 0
        rem = (1 << nv3) - 1
        while rem:
            # pick random bit among remaining
            bits = []
            tm = rem
            while tm:
                lsb = tm & -tm
                bits.append(lsb.bit_length() - 1)
                tm ^= lsb
            pick = rng3.choice(bits)
            cur_mask |= 1 << pick
            rem &= ~((1 << pick) | adj3[pick])
        # Verify independence
        verts = [v for v in range(nv3) if (cur_mask >> v) & 1]
        for v in verts:
            assert (adj3[v] & cur_mask) == 0
        if len(verts) > len(best_indep3_list):
            best_indep3_list = verts
    cls3_m1_best = None
    for k_try in (11, 12, 13):
        for restart in range(2 if k_try == 11 else 1):
            found = tabu_k_coloring(nv3, adj3, k_try, args.seed + 17 * k_try + restart, max_steps=70_000)
            if found is not None:
                cls3_m1_best = found
                break
        if cls3_m1_best is not None:
            break
    assert cls3_m1_best is not None
    v3_m1 = verify_partition(nv3, adj3, cls3_m1_best, "indep")

    # Component-size <= 2 lower bound via consecutive layers: max_{deg<=1}(G \boxtimes K_2) = 2 * alpha(G) = 20 -> 2|S| <= 140 -> |S| <= 70 -> M_3 >= ceil(343/70) = 5.
    lb_m3_cc2 = math.ceil(nv3 / (7 * alpha2))
    # Constructive upper bound for cc<=2: first lift 5-coloring of C_7^2 x {2-partition of C_7} -> 10, then push heuristic down to 6/7/8/9
    cls3_cc2_best = [
        [idx3[(coords2[u][0], coords2[u][1], z)] for u in c2 for z in c1]
        for c2 in cls2_m1
        for c1 in cls1_cc2
    ]
    verify_partition(nv3, adj3, cls3_cc2_best, "cc2")
    for k_try in (6, 7, 8, 9):
        found_cc = tabu_cc2_partition(nv3, adj3, k_try, args.seed + 31 * k_try, max_steps=45_000)
        if found_cc is not None:
            cls3_cc2_best = found_cc
            break
    v3_cc2 = verify_partition(nv3, adj3, cls3_cc2_best, "cc2")

    # Exact K_3-free M_3(2) = 5: lower bound ceil(343 / floor(343*2/8)) = ceil(343/85) = 5, upper bound = cls2_m1 x C_7
    cls3_k3 = [[idx3[(coords2[u][0], coords2[u][1], z)] for u in c2 for z in range(7)] for c2 in cls2_m1]
    v3_k3 = verify_partition(nv3, adj3, cls3_k3, "k3free")

    results["dimensions"]["3"] = {
        "n": 3,
        "vertices": nv3,
        "alpha_lb_witness": len(best_indep3_list),
        "alpha_ub_rigorous": alpha3_ub,
        "M_1_lb": lb_m3_1,
        "M_1_ub_cert": len(cls3_m1_best),
        "M_1_bits_lb": math.log2(lb_m3_1) / 3,
        "M_1_bits_ub": math.log2(len(cls3_m1_best)) / 3,
        "M_1_verify": v3_m1,
        "M_2_cc2_lb": lb_m3_cc2,
        "M_2_cc2_ub_cert": len(cls3_cc2_best),
        "M_2_cc2_bits_ub": math.log2(len(cls3_cc2_best)) / 3,
        "M_2_cc2_verify": v3_cc2,
        "M_2_k3free_exact": len(cls3_k3),
        "M_2_k3free_bits_per_dim": math.log2(len(cls3_k3)) / 3,
        "M_2_k3free_verify": v3_k3,
        "strict_savings_cc2_proven": (math.log2(len(cls3_cc2_best)) / 3) < (math.log2(lb_m3_1) / 3),
        "strict_savings_k3free_proven": (math.log2(len(cls3_k3)) / 3) < (math.log2(lb_m3_1) / 3),
    }

    elapsed = time.time() - t_start
    results["elapsed_sec"] = elapsed

    d1, d2, d3 = results["dimensions"]["1"], results["dimensions"]["2"], results["dimensions"]["3"]
    print(f"n=1 (|V|=7):   alpha={d1['alpha']} | M_1(1)={d1['M_1_exact']} ({d1['M_1_bits_per_dim']:.4f} b/d) | "
          f"M_1^cc2(2)={d1['M_2_cc2_exact']} ({d1['M_2_cc2_bits_per_dim']:.4f} b/d) | "
          f"M_1^K3free(2)={d1['M_2_k3free_exact']} ({d1['M_2_k3free_bits_per_dim']:.4f} b/d)")
    print(f"n=2 (|V|=49):  alpha={d2['alpha']} | M_2(1)={d2['M_1_exact']} ({d2['M_1_bits_per_dim']:.4f} b/d) | "
          f"M_2^cc2(2)={d2['M_2_cc2_exact']} ({d2['M_2_cc2_bits_per_dim']:.4f} b/d, k=3 unsat nodes={d2['M_2_cc2_impossible_k3_nodes']}) | "
          f"M_2^K3free(2)={d2['M_2_k3free_exact']} ({d2['M_2_k3free_bits_per_dim']:.4f} b/d)")
    print(f"n=3 (|V|=343): alpha<={d3['alpha_ub_rigorous']} | M_3(1) in [{d3['M_1_lb']}, {d3['M_1_ub_cert']}] "
          f"([{d3['M_1_bits_lb']:.4f}, {d3['M_1_bits_ub']:.4f}] b/d) | "
          f"M_3^cc2(2) in [{d3['M_2_cc2_lb']}, {d3['M_2_cc2_ub_cert']}] (<={d3['M_2_cc2_bits_ub']:.4f} b/d) | "
          f"M_3^K3free(2)={d3['M_2_k3free_exact']} ({d3['M_2_k3free_bits_per_dim']:.4f} b/d)")
    print(f"elapsed_sec={elapsed:.2f}")

    if args.json_out is not None:
        args.json_out.write_text(json.dumps(results, indent=2) + "\n")


if __name__ == "__main__":
    main()
