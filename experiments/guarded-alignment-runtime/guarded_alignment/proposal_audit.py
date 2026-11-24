"""Six-test structural diagnostic grammar for alignment proposals.

AI-written (24 November 2026). Pure Python 3 standard library using exact
``int`` and ``fractions.Fraction`` arithmetic. Mirrors six verified
Lean obstruction-and-safeguard seams from ``Becoming`` and periphery modules:

1. ``coupling_closure``: unread sustaining substrates beyond the selection
   interface (``Becoming.Selection.Flow.unselected_beyond_coupling``,
   ``Becoming.OpenComposition.widen_interface_heals_blindness``).
2. ``self_refit_lock``: self-referential re-selection that locks onto a
   favored share while exhausting sustaining reserves, or captures the
   selection-shaping mechanism as its target
   (``Becoming.ClosedCapture.ClosedCapture.lock_outlives_loss``,
   ``Becoming.MasterSpine.whole_becoming_master_theorem``).
3. ``fiber_split``: zero-TV macro equivalence coexisting with viability
   disagreement or multi-query separation
   (``Becoming.OplaxHistory.FiberViabilitySplit``,
   ``ObservationalFidelity.zero_tv_does_not_prevent_fiber_viability_split``,
   ``ObservationalFidelity.per_query_not_implies_joint_marginal``).
4. ``pace_margin_deadline``: cadence-vs-reserve deadlines, aliasing windows,
   and intra-span slack certification (``Becoming.PacedStock.slack_certifies_fine_kernel``,
   ``Becoming.PacedStock.pace_margin_feasibility_window``,
   ``Becoming.PacedStock.unrecoverable_cadence_impossibility``).
5. ``concurrent_reserve``: individually safe agents colluding or colliding
   onto an exhaustion race unless serialized with reciprocal gating and
   relative-phase observability
   (``Becoming.AdaptiveLoops.coupled_race_theorem``,
   ``Becoming.AdaptiveLoops.assume_guarantee_joint_viable``,
   ``Becoming.EndogenousOrder.reciprocal_gate_restores_viable_nash``).

Rule 2 boundary: Exact checks hold for the finite rational state, pace, and
reserve parameters supplied in a proposal spec. Whether a real training run,
oversight loop, or governance protocol satisfies those premises requires separate
empirical inspection and can still refute the match.
"""

from __future__ import annotations

from fractions import Fraction
from typing import Any, Mapping, Sequence

from .diagnostics import CheckItem, DiagnosticReport, Verdict, combine_verdicts
from .observational_fidelity import (
    FidelityError,
    FinDist,
    QuerySpec,
    check_coarsening,
    check_fiber_viability_split,
    check_multi_query_feasibility,
    to_fraction,
)
from .oplax_history import c2_two_to_one_witness


def _as_str_tuple(items: Any, field_name: str) -> tuple[str, ...]:
    if items is None:
        return ()
    if isinstance(items, str) or not isinstance(items, Sequence):
        raise FidelityError(f"{field_name!r} must be a sequence of strings")
    out: list[str] = []
    seen: set[str] = set()
    for item in items:
        text = str(item)
        if text not in seen:
            seen.add(text)
            out.append(text)
    return tuple(out)


def _ceil_div_fraction(numerator: Fraction, denominator: Fraction) -> int:
    """Return smallest integer ``k >= 1`` with ``k * denominator >= numerator``."""
    if denominator <= 0:
        raise FidelityError(f"Expected positive divisor, got {denominator}")
    if numerator <= 0:
        return 0
    num = numerator.numerator * denominator.denominator
    den = numerator.denominator * denominator.numerator
    return (num + den - 1) // den


def _parse_dist_mapping(raw: Mapping[Any, Any], carrier: Sequence[Any]) -> FinDist:
    return FinDist.from_mapping({k: to_fraction(v) for k, v in raw.items()}, carrier=carrier)


def check_coupling_closure(spec: Mapping[str, Any]) -> CheckItem:
    """Test whether any sustaining substrate is unread by the selection interface."""
    sustained = _as_str_tuple(spec.get("sustained_substrates"), "sustained_substrates")
    if not sustained:
        raise FidelityError("coupling_closure requires non-empty 'sustained_substrates'")
    read = _as_str_tuple(spec.get("read_substrates"), "read_substrates")
    closed_interface = bool(spec.get("closed_interface", True))

    read_set = set(read)
    unread = tuple(s for s in sustained if s not in read_set)

    draw_rates_raw = spec.get("draw_rates", {})
    draw_rates = {str(k): to_fraction(v) for k, v in draw_rates_raw.items()}
    unread_draws = {s: draw_rates.get(s, Fraction(0)) for s in unread}

    differing_pair = spec.get("differing_pair")
    blind_pair = False
    if isinstance(differing_pair, Mapping):
        blind_pair = bool(differing_pair.get("same_observable", False)) and bool(
            differing_pair.get("substrate_gap")
        )

    obstructed = bool(unread) or blind_pair or closed_interface
    if unread:
        missing_guard = "widen_interface_to_sustained_substrates"
        detail = (
            f"Unread sustaining substrates {list(unread)} make zero difference to selection "
            f"(Flow.unselected_beyond_coupling); selection cannot distinguish courses draining them."
        )
        verdict = Verdict.OBSTRUCTED
    elif blind_pair:
        missing_guard = "open_observable_separator_for_differing_pair"
        detail = "Supplied course pair shares selection observables despite non-zero substrate gap."
        verdict = Verdict.OBSTRUCTED
    elif closed_interface:
        missing_guard = "keep_interface_open_to_new_substrates"
        detail = (
            "All currently listed substrates are read, but closed_interface=True locks out "
            "future disturbances (widen_interface_heals_blindness requires open seams)."
        )
        verdict = Verdict.OBSTRUCTED
    else:
        missing_guard = None
        detail = (
            f"Open interface reads all {len(sustained)} listed sustaining substrates "
            "(subject to Rule 2 external disturbance checks)."
        )
        verdict = Verdict.GUARDED

    witness: dict[str, Any] = {
        "sustained_substrates": list(sustained),
        "read_substrates": list(read),
        "unread_substrates": list(unread),
        "closed_interface": closed_interface,
        "lean_refs": [
            "Becoming.Selection.Flow.unselected_beyond_coupling",
            "Becoming.OpenComposition.widen_interface_heals_blindness",
        ],
    }
    if unread_draws:
        witness["unread_draw_rates"] = unread_draws
    if isinstance(differing_pair, Mapping):
        witness["differing_pair"] = dict(differing_pair)

    return CheckItem(
        label="coupling_closure",
        verdict=verdict,
        detail=detail,
        missing_guard=missing_guard,
        witness=witness,
    )


def check_self_refit_lock(spec: Mapping[str, Any]) -> CheckItem:
    """Test for self-referential re-selection capture or target collapse."""
    self_refit = bool(spec.get("self_refit", False))
    external_reset = bool(spec.get("external_reset_active", False))
    reset_channels = _as_str_tuple(spec.get("external_reset_channels"), "external_reset_channels")
    shaping_becomes_target = bool(spec.get("shaping_becomes_target", False))
    draw_per_step = to_fraction(spec.get("draw_per_step", 0))
    reserve_margin = to_fraction(spec.get("reserve_margin", 0))

    if draw_per_step < 0:
        raise FidelityError(f"draw_per_step must be >= 0, got {draw_per_step}")

    has_active_reset = external_reset and len(reset_channels) > 0
    steps_to_exhaustion: int | None = None
    if draw_per_step > 0 and reserve_margin >= 0:
        steps_to_exhaustion = _ceil_div_fraction(reserve_margin, draw_per_step) if reserve_margin > 0 else 1

    locked_exhaustion = self_refit and (not has_active_reset) and (draw_per_step > 0)
    self_locked = self_refit and (not has_active_reset)

    if shaping_becomes_target:
        verdict = Verdict.OBSTRUCTED
        missing_guard = "separate_selection_shaping_from_target"
        detail = (
            "Selection-shaping signal became the optimized target (meta-attractor capture); "
            "self-referential feedback no longer tracks underlying viability."
        )
    elif locked_exhaustion:
        verdict = Verdict.OBSTRUCTED
        missing_guard = "external_disturbance_reset_outside_favored_share"
        detail = (
            f"Self-refit without active external reset draws {draw_per_step}/step on favored share, "
            f"exhausting reserve margin {reserve_margin} within {steps_to_exhaustion} step(s) while "
            f"lock holds (ClosedCapture.lock_outlives_loss)."
        )
    elif self_locked:
        verdict = Verdict.OBSTRUCTED
        missing_guard = "active_external_disturbance_channel"
        detail = (
            "Self-refit resets only from the favored share with no active external disturbance channel "
            "(ClosedCapture.lock_outlives_loss)."
        )
    elif external_reset and not reset_channels:
        verdict = Verdict.OBSTRUCTED
        missing_guard = "named_external_reset_channels"
        detail = "external_reset_active=True requires at least one named external reset channel."
    else:
        verdict = Verdict.GUARDED
        missing_guard = None
        detail = (
            f"External reset channels {list(reset_channels)} remain active outside the favored "
            f"share without making shaping the optimization target."
        )

    witness: dict[str, Any] = {
        "self_refit": self_refit,
        "external_reset_active": external_reset,
        "external_reset_channels": list(reset_channels),
        "shaping_becomes_target": shaping_becomes_target,
        "draw_per_step": draw_per_step,
        "reserve_margin": reserve_margin,
        "lean_refs": [
            "Becoming.ClosedCapture.ClosedCapture.lock_outlives_loss",
            "Becoming.MasterSpine.whole_becoming_master_theorem",
        ],
    }
    if steps_to_exhaustion is not None:
        witness["steps_to_exhaustion"] = steps_to_exhaustion

    return CheckItem(
        label="self_refit_lock",
        verdict=verdict,
        detail=detail,
        missing_guard=missing_guard,
        witness=witness,
    )


def check_proposal_fiber_split(spec: Mapping[str, Any]) -> CheckItem:
    """Test for Zero-TV macro agreement hiding FiberViabilitySplit or query separation."""
    states = list(spec.get("states", ()))
    if not states:
        raise FidelityError("fiber_split requires non-empty 'states'")
    proj_map = spec["proj_map"]
    viable_pred = spec["viable_pred"]

    dist_v = _parse_dist_mapping(spec["dist_viable"], states) if "dist_viable" in spec else None
    dist_c = _parse_dist_mapping(spec["dist_collapsing"], states) if "dist_collapsing" in spec else None

    frep = check_fiber_viability_split(
        proj_map,
        viable_pred,
        states,
        dist_viable=dist_v,
        dist_collapsing=dist_c,
    )

    witness: dict[str, Any] = {
        "lean_refs": [
            "Becoming.OplaxHistory.fiberSplit_refutes_macro_viability_soundness",
            "ObservationalFidelity.zero_tv_does_not_prevent_fiber_viability_split",
        ],
        "has_split": frep.has_split,
        "projected_tv": frep.projected_tv,
    }
    if frep.has_split:
        witness.update(
            {
                "viable_state": frep.viable_state,
                "collapsing_state": frep.collapsing_state,
                "shared_projection": frep.shared_projection,
            }
        )

    conceals = False
    if "coarsen_map" in spec and "fine_query_map" in spec and ("fine_state_dist" in spec or "fine_target_dist" in spec):
        fine_map = spec["fine_query_map"]
        raw_dist = spec.get("fine_state_dist", spec.get("fine_target_dist"))
        fine_dist = _parse_dist_mapping(raw_dist, states)
        src_c = list(spec.get("fine_src_carrier", [states[0]]))
        chi_map = spec.get("fine_chi_map", {u: (u if u in states else states[0]) for u in src_c})
        crep = check_coarsening(chi_map, fine_map, spec["coarsen_map"], fine_dist, src_c)
        conceals = crep.conceals_blindness
        witness["coarsening"] = {
            "fine_floor": crep.fine_floor,
            "coarse_floor": crep.coarse_floor,
            "concealed_gap": crep.concealed_gap,
            "conceals_blindness": crep.conceals_blindness,
        }

    mq_regime: str | None = None
    if "multi_queries" in spec:
        qspecs = [
            QuerySpec(
                name=str(q["name"]),
                query_map=q["query_map"],
                target_dist=_parse_dist_mapping(
                    q["target_dist"],
                    q.get("target_carrier", tuple(q["target_dist"].keys())),
                ),
            )
            for q in spec["multi_queries"]
        ]
        mrep = check_multi_query_feasibility(states, qspecs)
        mq_regime = mrep.regime
        witness["multi_query_regime"] = mq_regime
        witness["simultaneous_min_tv_sum"] = mrep.simultaneous_min_tv_sum

    mq_obstructed = mq_regime is not None and mq_regime != "JOINTLY_REALIZABLE"
    if frep.has_split:
        verdict = Verdict.OBSTRUCTED
        missing_guard = "refine_projection_to_separate_viability_fibers"
        detail = frep.warning
    elif conceals or mq_obstructed:
        verdict = Verdict.OBSTRUCTED
        missing_guard = "preserve_fine_multi_query_separation"
        detail = (
            f"No binary fiber split on projection, but summary hides gap "
            f"(conceals_blindness={conceals}, multi_query_regime={mq_regime})."
        )
    else:
        verdict = Verdict.GUARDED
        missing_guard = None
        detail = (
            f"Macro projection separates viable and non-viable fibers across {len(states)} states "
            "with zero undetected multi-query or coarsening obstruction."
        )

    return CheckItem(
        label="zero_tv_fiber_split",
        verdict=verdict,
        detail=detail,
        missing_guard=missing_guard,
        witness=witness,
    )


def check_pace_margin_deadline(spec: Mapping[str, Any]) -> CheckItem:
    """Test aliasing lag, unrecoverable cadence impossibility, and fine-kernel slack."""
    lag = int(spec["lag"])
    n_rules = int(spec["n_rules"])
    if lag < 1 or n_rules < 1:
        raise FidelityError(f"lag and n_rules must be >= 1, got lag={lag}, n_rules={n_rules}")

    x0 = to_fraction(spec["initial_reserve"])
    thr = to_fraction(spec.get("critical_threshold", 0))
    terminal_buffer = to_fraction(spec.get("terminal_buffer", 0))
    h1 = to_fraction(spec["pre_response_draw"])
    h2 = to_fraction(spec.get("post_response_draw", h1))
    renewal = to_fraction(spec.get("paced_renewal", 0))
    intra_drop = to_fraction(spec.get("intra_span_drop", h1))

    y2 = thr + terminal_buffer
    required_floor = h2 + y2
    min_aliasing_lag = 2 * n_rules - 1
    aliasing_ok = min_aliasing_lag <= lag

    net_pre_draw = max(Fraction(0), h1 - renewal)
    impossibility_bound = required_floor + net_pre_draw * min_aliasing_lag
    feasibility_bound = required_floor + h1 * (lag + 1)
    fine_kernel_required = thr + intra_drop * (lag - 1)

    unrecoverable = (n_rules >= 2) and (h1 > renewal) and (x0 < impossibility_bound)
    window_feasible = x0 >= feasibility_bound
    fine_kernel_ok = x0 >= fine_kernel_required

    if not aliasing_ok:
        verdict = Verdict.OBSTRUCTED
        missing_guard = "extend_lag_above_two_n_minus_one_or_reduce_rule_count"
        detail = (
            f"Aliasing window broken: lag={lag} < 2*N-1={min_aliasing_lag} "
            "(pace_margin_feasibility_window premise fails)."
        )
    elif unrecoverable:
        verdict = Verdict.OBSTRUCTED
        missing_guard = "unrecoverable_cadence_requires_higher_reserve_or_paced_renewal"
        detail = (
            f"Unrecoverable cadence impossibility: initial_reserve={x0} < "
            f"impossibility_bound={impossibility_bound} ((H2+y2)+(H1-Y)*(2N-1)), "
            "reserve exhausts before identification completes."
        )
    elif not window_feasible:
        verdict = Verdict.OBSTRUCTED
        missing_guard = "close_cadence_margin_gap_before_oversight_response"
        detail = (
            f"Outside worst-case feasibility window: initial_reserve={x0} < "
            f"feasibility_bound={feasibility_bound} ((H2+y2)+H1*(L+1))."
        )
    elif not fine_kernel_ok:
        verdict = Verdict.OBSTRUCTED
        missing_guard = "increase_block_slack_above_intraspan_drop"
        detail = (
            f"Initial-block intra-span fine-kernel violation: initial_reserve={x0} < "
            f"thr+stepDrop*(L-1)={fine_kernel_required} (slack_certifies_fine_kernel)."
        )
    else:
        verdict = Verdict.GUARDED
        missing_guard = None
        detail = (
            f"Inside pace-vs-margin feasibility window: lag={lag} >= {min_aliasing_lag}, "
            f"initial_reserve={x0} >= feasibility_bound={feasibility_bound} and "
            f"initial-block fine_kernel_required={fine_kernel_required}."
        )

    witness: dict[str, Any] = {
        "lag": lag,
        "n_rules": n_rules,
        "min_aliasing_lag": min_aliasing_lag,
        "aliasing_ok": aliasing_ok,
        "initial_reserve": x0,
        "critical_threshold": thr,
        "required_floor": required_floor,
        "impossibility_bound": impossibility_bound,
        "feasibility_bound": feasibility_bound,
        "fine_kernel_required": fine_kernel_required,
        "impossibility_premise_h1_le_floor": (h1 <= required_floor),
        "unrecoverable_cadence": unrecoverable,
        "window_feasible": window_feasible,
        "fine_kernel_ok": fine_kernel_ok,
        "lean_refs": [
            "Becoming.PacedStock.slack_certifies_fine_kernel",
            "Becoming.PacedStock.pace_margin_feasibility_window",
            "Becoming.PacedStock.unrecoverable_cadence_impossibility",
        ],
    }

    return CheckItem(
        label="pace_margin_deadline",
        verdict=verdict,
        detail=detail,
        missing_guard=missing_guard,
        witness=witness,
    )


def check_concurrent_reserve(spec: Mapping[str, Any]) -> CheckItem:
    """Test whether individually viable agents collide into shared-reserve exhaustion."""
    n_agents = int(spec.get("n_agents", 2))
    if n_agents < 2:
        raise FidelityError(f"concurrent_reserve requires n_agents >= 2, got {n_agents}")

    shared_reserve = to_fraction(spec["shared_reserve"])
    min_viable = to_fraction(spec.get("min_viable_reserve", 1))
    single_draw = to_fraction(spec["single_agent_draw"])
    concurrent_draw = to_fraction(spec["concurrent_draw"])
    renewal = to_fraction(spec.get("renewal_per_step", 0))
    serialized_or_gated = bool(spec.get("serialized_or_gated", False))
    observe_phase = bool(spec.get("observe_relative_phase", False))
    serialized_draw = to_fraction(spec.get("serialized_draw", single_draw))

    individually_safe = (single_draw <= renewal) and (shared_reserve - single_draw + renewal >= min_viable)
    effective_draw = serialized_draw if serialized_or_gated else concurrent_draw
    net_drain = effective_draw - renewal

    steps_to_breach: int | None = None
    if net_drain > 0:
        headroom = shared_reserve - min_viable
        steps_to_breach = (_ceil_div_fraction(headroom, net_drain) + 1) if headroom >= 0 else 1

    c2_diag = None
    if not observe_phase:
        c2_diag = c2_two_to_one_witness()

    race_obstructed = (net_drain > 0) or (shared_reserve < min_viable)
    if race_obstructed:
        verdict = Verdict.OBSTRUCTED
        missing_guard = "reciprocal_serialization_and_phase_gate"
        detail = (
            f"Shared reserve race across {n_agents} agents: single-agent draw={single_draw} "
            f"(individually_safe={individually_safe}), active draw={effective_draw} > renewal={renewal}, "
            f"breaching min_viable={min_viable} in {steps_to_breach} step(s) (coupled_race_theorem)."
        )
    elif not serialized_or_gated:
        verdict = Verdict.OBSTRUCTED
        missing_guard = "install_serialization_or_reciprocal_gate"
        detail = (
            "Concurrent reserve check requires explicit serialization or reciprocal gating across "
            "interacting agents (concurrent_serial_dichotomy)."
        )
    elif not observe_phase:
        verdict = Verdict.OBSTRUCTED
        missing_guard = "observe_cross_agent_relative_phase"
        detail = (
            "Phase-blind componentwise observation triggers C2 quotient collapse (2->1) even when "
            "per-step net drain is non-positive."
        )
    else:
        verdict = Verdict.GUARDED
        missing_guard = None
        detail = (
            f"Reciprocal serialization and phase-aware observation hold across {n_agents} agents: "
            f"active draw={effective_draw} <= renewal={renewal} keeps reserve >= {min_viable}."
        )

    witness: dict[str, Any] = {
        "n_agents": n_agents,
        "shared_reserve": shared_reserve,
        "min_viable_reserve": min_viable,
        "single_agent_draw": single_draw,
        "concurrent_draw": concurrent_draw,
        "serialized_draw": serialized_draw,
        "renewal_per_step": renewal,
        "individually_safe": individually_safe,
        "serialized_or_gated": serialized_or_gated,
        "observe_relative_phase": observe_phase,
        "effective_draw": effective_draw,
        "net_drain_per_step": net_drain,
        "lean_refs": [
            "Becoming.AdaptiveLoops.coupled_race_theorem",
            "Becoming.AdaptiveLoops.assume_guarantee_joint_viable",
            "Becoming.PolyComposition.ConcurrentSerialWitness.concurrent_serial_dichotomy",
            "Becoming.EndogenousOrder.reciprocal_gate_restores_viable_nash",
        ],
    }
    if steps_to_breach is not None:
        witness["steps_to_breach"] = steps_to_breach
    if c2_diag is not None:
        witness["c2_universal_bc_holds"] = c2_diag.universal_bc_holds
        witness["c2_is_bijective"] = c2_diag.is_bijective
        witness["c2_domain_size"] = c2_diag.domain_size
        witness["c2_codomain_size"] = c2_diag.codomain_size

    return CheckItem(
        label="concurrent_reserve",
        verdict=verdict,
        detail=detail,
        missing_guard=missing_guard,
        witness=witness,
    )


def _is_in_span_and_insert(
    echelon: list[tuple[int, list[Fraction]]], vec: Sequence[Fraction]
) -> bool:
    """Return ``True`` and insert pivot row iff ``vec`` is linearly independent of ``echelon``."""
    row = list(vec)
    for pcol, prow in echelon:
        factor = row[pcol]
        if factor != 0:
            for j in range(pcol, len(row)):
                row[j] -= factor * prow[j]
    for j, val in enumerate(row):
        if val != 0:
            inv = Fraction(1) / val
            echelon.append((j, [x * inv for x in row]))
            return True
    return False


def _step_op(
    matrix: Mapping[str, Mapping[str, Fraction]], states: tuple[str, ...], vec: Sequence[Fraction]
) -> tuple[Fraction, ...]:
    """Compute exact ``stepOp K v``: ``(stepOp K v)(s) = sum_{s'} K[s][s'] * v[s']``."""
    out: list[Fraction] = []
    for s in states:
        row = matrix.get(s, {})
        acc = Fraction(0)
        for idx, s_next in enumerate(states):
            w = row.get(s_next, Fraction(0))
            if w != 0 and vec[idx] != 0:
                acc += w * vec[idx]
        out.append(acc)
    return tuple(out)


def check_survival_distinguishability(spec: Mapping[str, Any]) -> CheckItem:
    """Test finite-mode survival distinguishability up to the Krylov cutoff ``|S| - 1``."""
    states = _as_str_tuple(spec.get("states"), "states")
    if not states:
        raise FidelityError("survival_distinguishability requires non-empty 'states'")
    n = len(states)
    state_idx = {s: i for i, s in enumerate(states)}

    state_a = str(spec["state_a"])
    state_b = str(spec["state_b"])
    if state_a not in state_idx or state_b not in state_idx:
        raise FidelityError("state_a and state_b must both appear in 'states'")
    idx_a, idx_b = state_idx[state_a], state_idx[state_b]

    raw_modes = spec.get("modes")
    if not isinstance(raw_modes, Mapping) or not raw_modes:
        raise FidelityError("survival_distinguishability requires non-empty 'modes' mapping")

    parsed_modes: dict[str, dict[str, dict[str, Fraction]]] = {}
    for mode_name, mat in raw_modes.items():
        if not isinstance(mat, Mapping):
            raise FidelityError(f"Mode matrix for {mode_name!r} must be a mapping")
        p_mat: dict[str, dict[str, Fraction]] = {}
        for src, row in mat.items():
            src_s = str(src)
            if src_s not in state_idx:
                raise FidelityError(f"Unknown source state {src_s!r} in mode {mode_name!r}")
            if not isinstance(row, Mapping):
                raise FidelityError(f"Row for {src_s!r} in mode {mode_name!r} must be a mapping")
            p_row: dict[str, Fraction] = {}
            for tgt, weight in row.items():
                tgt_s = str(tgt)
                if tgt_s not in state_idx:
                    raise FidelityError(f"Unknown target state {tgt_s!r} in mode {mode_name!r}")
                p_row[tgt_s] = to_fraction(weight)
            p_mat[src_s] = p_row
        parsed_modes[str(mode_name)] = p_mat

    krylov_cutoff = n - 1
    audit_horizon = int(spec.get("audit_horizon", krylov_cutoff))
    if audit_horizon < 0:
        raise FidelityError(f"audit_horizon must be >= 0, got {audit_horizon}")
    allow_switching = bool(spec.get("allow_mode_switching", True))

    mode_names = tuple(parsed_modes.keys())
    v_init = tuple(Fraction(1) for _ in range(n))
    echelon: list[tuple[int, list[Fraction]]] = []
    _is_in_span_and_insert(echelon, v_init)

    frontier: list[tuple[tuple[str, ...], tuple[Fraction, ...]]] = [((), v_init)]
    stabilized_depth = 0
    sep_word: tuple[str, ...] | None = None
    sep_vals: tuple[Fraction, Fraction] | None = None

    for depth in range(1, krylov_cutoff + 1):
        next_frontier: list[tuple[tuple[str, ...], tuple[Fraction, ...]]] = []
        for word, vec in frontier:
            for m in mode_names:
                w_next = (m,) + word
                v_next = _step_op(parsed_modes[m], states, vec)
                if sep_word is None and v_next[idx_a] != v_next[idx_b]:
                    sep_word = w_next
                    sep_vals = (v_next[idx_a], v_next[idx_b])
                if _is_in_span_and_insert(echelon, v_next):
                    next_frontier.append((w_next, v_next))
        if next_frontier:
            stabilized_depth = depth
        frontier = next_frontier
        if not frontier:
            break

    const_sep_word: tuple[str, ...] | None = None
    const_sep_vals: tuple[Fraction, Fraction] | None = None
    for depth in range(1, krylov_cutoff + 1):
        if const_sep_word is not None:
            break
        for m in mode_names:
            vec = v_init
            for _ in range(depth):
                vec = _step_op(parsed_modes[m], states, vec)
            if vec[idx_a] != vec[idx_b]:
                const_sep_word = (m,) * depth
                const_sep_vals = (vec[idx_a], vec[idx_b])
                break

    indistinguishable = sep_word is None
    if indistinguishable:
        verdict = Verdict.OBSTRUCTED
        missing_guard = "add_state_separating_mode_or_interventional_probe"
        detail = (
            f"States {state_a!r} and {state_b!r} agree on all mode words up to Krylov cutoff "
            f"|S|-1={krylov_cutoff}, hence agree on all finite horizons "
            "(survival_indistinguishable_iff_le_card_pred)."
        )
        active_vals = (v_init[idx_a], v_init[idx_b])
        active_horizon: int | None = None
    elif (not allow_switching) and (const_sep_word is None):
        verdict = Verdict.OBSTRUCTED
        missing_guard = "enable_mode_switching_probes_up_to_krylov_horizon"
        detail = (
            f"Constant-mode probing fails to separate {state_a!r} and {state_b!r}, while switching "
            f"word {list(sep_word)} separates them at horizon {len(sep_word)} <= {krylov_cutoff} "
            "(three_state_mode_switch_counterexample)."
        )
        active_vals = sep_vals
        active_horizon = len(sep_word)
    else:
        chosen_word = sep_word if allow_switching else const_sep_word
        chosen_vals = sep_vals if allow_switching else const_sep_vals
        assert chosen_word is not None and chosen_vals is not None
        active_horizon = len(chosen_word)
        active_vals = chosen_vals
        if audit_horizon < active_horizon:
            verdict = Verdict.OBSTRUCTED
            missing_guard = "extend_audit_horizon_to_krylov_separating_depth"
            detail = (
                f"Audit horizon {audit_horizon} stops short of shortest separating horizon "
                f"{active_horizon} <= |S|-1={krylov_cutoff} ({list(chosen_word)})."
            )
        else:
            verdict = Verdict.GUARDED
            missing_guard = None
            detail = (
                f"Separated {state_a!r} ({active_vals[0]}) vs {state_b!r} ({active_vals[1]}) via "
                f"word {list(chosen_word)} within audit_horizon={audit_horizon} and Krylov cutoff "
                f"|S|-1={krylov_cutoff}."
            )

    witness: dict[str, Any] = {
        "krylov_cutoff": krylov_cutoff,
        "stabilized_depth": stabilized_depth,
        "audit_horizon": audit_horizon,
        "allow_mode_switching": allow_switching,
        "indistinguishable_all_horizons": indistinguishable,
        "shortest_separating_word": list(sep_word) if sep_word is not None else None,
        "shortest_separating_horizon": active_horizon,
        "constant_mode_separating_word": (
            list(const_sep_word) if const_sep_word is not None else None
        ),
        "state_a_survival": active_vals[0],
        "state_b_survival": active_vals[1],
        "lean_refs": [
            "SurvivalDistinguishability.survival_indistinguishable_iff_le_card_pred",
            "SurvivalDistinguishability.countdown_attains_card_pred",
            "SurvivalDistinguishability.three_state_mode_switch_counterexample",
            "SurvivalDistinguishability.c2_coupled_survival_separation",
        ],
    }

    return CheckItem(
        label="survival_distinguishability",
        verdict=verdict,
        detail=detail,
        missing_guard=missing_guard,
        witness=witness,
    )


def evaluate_alignment_proposal(spec: Mapping[str, Any]) -> DiagnosticReport:
    """Run up to all 6 structural failure tests over an alignment proposal JSON spec."""
    name = str(spec.get("name", "alignment_proposal"))
    proposal_family = str(spec.get("proposal_family", "unspecified"))
    checks: list[CheckItem] = []

    if "coupling_closure" in spec:
        checks.append(check_coupling_closure(spec["coupling_closure"]))
    if "self_refit_lock" in spec:
        checks.append(check_self_refit_lock(spec["self_refit_lock"]))
    if "fiber_split" in spec:
        checks.append(check_proposal_fiber_split(spec["fiber_split"]))
    if "pace_margin_deadline" in spec:
        checks.append(check_pace_margin_deadline(spec["pace_margin_deadline"]))
    if "concurrent_reserve" in spec:
        checks.append(check_concurrent_reserve(spec["concurrent_reserve"]))
    if "survival_distinguishability" in spec:
        checks.append(check_survival_distinguishability(spec["survival_distinguishability"]))

    if not checks:
        raise FidelityError(
            "alignment_proposal spec must supply at least one of: "
            "coupling_closure, self_refit_lock, fiber_split, pace_margin_deadline, "
            "concurrent_reserve, survival_distinguishability"
        )

    tup = tuple(checks)
    verdict = combine_verdicts(tup)
    obstructed_labels = [c.label for c in tup if c.verdict == Verdict.OBSTRUCTED]
    summary = (
        f"Alignment proposal grammar ({proposal_family}, {len(tup)} test(s)): "
        f"verdict {verdict.value}"
        + (f"; obstructed on {obstructed_labels}." if obstructed_labels else "; all supplied guards active.")
    )
    return DiagnosticReport(
        name=name,
        verdict=verdict,
        summary=summary,
        checks=tup,
        rule2_boundary=(
            "Rule 2 boundary: checks verify formal premises and obstructions on the supplied finite "
            "rational model only; empirical recognition that a real system matches these substrates, "
            "rates, and disturbance bounds remains fallible and outside the theorem."
        ),
    )
