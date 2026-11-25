# Guarded Alignment Runtime

*AI-written (`Wave U6 runtime`, 24 November 2026). Pure Python 3 standard library; no external packages or network calls.*

An executable reference runtime mirroring the verified Lean 4 core (`Becoming.DoubleKernel`, `Becoming.OplaxHistory`) and isolated applied periphery (`ObservationalFidelity`, `SurvivalDistinguishability`). It checks strict 2D/3D syntax certificates (which emit `PROVED` / `OBSTRUCTED`), diagnoses oplax relational-span loss and Beck–Chevalley obstructions, computes exact rational observational fidelity bounds, and audits declarative alignment proposals (`alignment_proposal` specs emit only `GUARDED` or `OBSTRUCTED`, never unconstrained `PROVED`).

## Modules & Lean Correspondence

| Module | Mirrors | Core Capabilities |
|---|---|---|
| `guarded_alignment/double_kernel.py` | `Becoming.DoubleKernel` Parts 1–3 | `DoubleSig`, `TypedPath` (`nil` carries its object), 4-boundary `Frame`, 5-constructor `SqTerm`, unique boundary typing (`T1`), 10-rule `EqCert` (`T2`), additive `natTallyDoubleCat` separator (`Cor 4.0`), relative 3D `Double3Sig` / `Cell3Term` / `Eq3Cert` (`Lem 6`, `T9`), monotone-weight 3D irreversibility. |
| `guarded_alignment/oplax_history.py` | `Becoming.OplaxHistory`, `Becoming.DoubleKernel` Part 4 | Finite `RelSpan`, `SpanHom`, `comp_span`, `coprod_span`, `SpanFunctor`, canonical `chi`, `FImageIsPullback`, universal fiberwise Beck–Chevalley check (`chi_bijective_iff_bc_all`) with empty-family vacuity warning, emergent (`0->1`, `2->4`) and `C2` (`2->1`, `2^n->1`) witnesses, and `GuardedExpr` / `GuardedProof` rejecting unguarded `ChiInv` without an explicit verified `BijCert`. |
| `guarded_alignment/observational_fidelity.py` | `ObservationalFidelity` | Exact `fractions.Fraction` `FinDist`, pushforward, data-processing TV distance, `mass_outside` query TV blindness floor (`O1`/`G.1`) + attaining witness + empty-carrier infeasibility, coarsening (`G.2`) and macro-refinement monotonicity, exact rational Simplex multi-query separation (`G.3a`/`G.3b`), `Zero-TV` vs. `FiberViabilitySplit` warnings, and finite Markov kernel / contractive tube bounds (`G.4a`/`G.4b`). |
| `guarded_alignment/diagnostics.py`, `examples.py`, `cli.py` | End-to-end DSL & CLI | Declarative JSON/dataclass specs (`strict_kernel`, `oplax_guard`, `observational_fidelity`, `coupled_alignment`, `alignment_proposal`, `suite`) emitting `PROVED` / `GUARDED` / `OBSTRUCTED` reports naming exact missing guards, witnesses, and Rule 2 boundaries. |
| `guarded_alignment/proposal_audit.py` | `Selection`, `ClosedCapture`, `OplaxHistory`, `PacedStock`, `AdaptiveLoops`, `EndogenousOrder`, `ObservationalFidelity`, `SurvivalDistinguishability` | Six-test structural grammar for alignment proposals (`coupling_closure`, `self_refit_lock`, `fiber_split`, `pace_margin_deadline`, `concurrent_reserve`, `survival_distinguishability`), with 7 worked proposal examples (`proposal_rlhf_one_pass`, `proposal_rlaif_self_refit`, `proposal_constitutional_ai_closed`, `proposal_scalable_oversight_lagged`, `proposal_multi_agent_governance_unserialized`, `proposal_finite_mode_switching_blind`, `proposal_guarded_open_alignment`). |

## Quickstart

Run from `experiments/guarded-alignment-runtime/`:

```bash
# Run the full unit test and hygiene suite
python3 -m unittest discover -s tests -v

# List built-in examples
python3 -m guarded_alignment list

# Run a single alignment example (text or JSON)
python3 -m guarded_alignment run rlhf_shared_substrate_c2
python3 -m guarded_alignment run guarded_bc_upgrade --json
python3 -m guarded_alignment run proposal_rlhf_one_pass
python3 -m guarded_alignment run proposal_guarded_open_alignment --json

# Run all built-in examples
python3 -m guarded_alignment run all

# Dump a declarative JSON spec and evaluate it via `check`
python3 -m guarded_alignment dump-example multi_query_separation > /tmp/spec.json
python3 -m guarded_alignment check /tmp/spec.json
```

## Rule 2 Scope & Honesty Boundary

Every verdict (`PROVED` for strict symbolic 2D/3D equational certificates in `double_kernel.py` and exact finite-carrier mathematical properties in `oplax_guard` / `observational_fidelity` — which require at least one concrete check section — `GUARDED` for guard-passing `alignment_proposal`, `coupled_alignment`, and contractive-tube specs, and `OBSTRUCTED` whenever a counter-witness is found) holds strictly for the finite symbolic signature, relational span, functor action, or rational probability model supplied to the checker. Passing a check does **not** prove that an empirical multi-agent or RLHF deployment satisfies finite-state assumptions, exact Beck–Chevalley preservation, or the modeled transition laws; conversely, `Zero-TV` on a macro query never rules out a `FiberViabilitySplit` unless fiberwise viability consistency is explicitly verified.
