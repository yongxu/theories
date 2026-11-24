"""Typed raw third-dimensional cells over the v9 double-category syntax.

This module implements constructors and their boundary checks.  It does not
implement equality in the full relative Cat(DblCat) quotient.  Structural 2D
equality certificates may change representatives of an endpoint; such a
transport does not declare an extra directed event.  Distinct transport proofs
may represent the same mathematical 3-cell even if their Python ASTs differ.
"""

from dataclasses import dataclass
from typing import Mapping

from .generative_v9 import (
    Equality, KernelError, Path, RewriteStep, RewriteTheory, RewriteTrace,
    Signature, Term, reflexivity,
)


@dataclass(frozen=True)
class ThreeGenerator:
    name: str
    source: Term
    target: Term


@dataclass(frozen=True)
class ThreeBoundary:
    source: Term
    target: Term


@dataclass(frozen=True)
class ThreeCell:
    op: str
    payload: str | Term | None = None
    args: tuple = ()
    evidence: tuple = ()

    def __post_init__(self):
        object.__setattr__(self, "args", tuple(self.args))
        object.__setattr__(self, "evidence", tuple(self.evidence))


@dataclass(frozen=True, init=False)
class ThreeTheory:
    signature: Signature
    generators: Mapping[str, ThreeGenerator]

    def __init__(self, signature: Signature, generators=()):
        object.__setattr__(self, "signature", signature)
        object.__setattr__(self, "generators", signature._unique(generators, "3-cell generator"))
        for generator in self.generators.values():
            if not isinstance(generator, ThreeGenerator):
                raise KernelError("expected a 3-cell generator declaration")
            if signature.boundary(generator.source) != signature.boundary(generator.target):
                raise KernelError("a 3-cell generator needs parallel complete 2D frames")

    def boundary(self, cell: ThreeCell) -> ThreeBoundary:
        if not isinstance(cell, ThreeCell):
            raise KernelError("expected a typed raw 3-cell")
        sig = self.signature
        if cell.op == "id":
            if not isinstance(cell.payload, Term) or cell.args or cell.evidence:
                raise KernelError("malformed third-direction identity")
            sig.boundary(cell.payload)
            result = ThreeBoundary(cell.payload, cell.payload)
        elif cell.op == "gen":
            if not isinstance(cell.payload, str) or cell.payload not in self.generators or cell.args or cell.evidence:
                raise KernelError("undeclared or malformed 3-cell generator")
            generator = self.generators[cell.payload]
            result = ThreeBoundary(generator.source, generator.target)
        elif cell.op in ("h", "v"):
            if cell.payload is not None or len(cell.args) != 2 or cell.evidence:
                raise KernelError("malformed horizontal/vertical 3-cell paste")
            a, b = map(self.boundary, cell.args)
            operation = sig.h if cell.op == "h" else sig.v
            result = ThreeBoundary(operation(a.source, b.source), operation(a.target, b.target))
        elif cell.op == "z":
            if cell.payload is not None or len(cell.args) != 2 or len(cell.evidence) > 1:
                raise KernelError("malformed third-direction composition")
            a, b = map(self.boundary, cell.args)
            if cell.evidence:
                proof = cell.evidence[0]
                sig.verify(proof)
                if (proof.left, proof.right) != (a.target, b.source):
                    raise KernelError("middle transport certificate has wrong endpoints")
            elif a.target != b.source:
                raise KernelError("3-cell middle differs: supply a structural equality certificate")
            result = ThreeBoundary(a.source, b.target)
        elif cell.op == "transport":
            if cell.payload is not None or len(cell.args) != 1 or len(cell.evidence) != 2:
                raise KernelError("malformed endpoint transport")
            old = self.boundary(cell.args[0])
            source_proof, target_proof = cell.evidence
            sig.verify(source_proof)
            sig.verify(target_proof)
            # Explicit orientations: new_source = old_source; old_target = new_target.
            if source_proof.right != old.source or target_proof.left != old.target:
                raise KernelError("endpoint transport certificates bind the wrong representatives")
            result = ThreeBoundary(source_proof.left, target_proof.right)
        else:
            raise KernelError("unknown 3-cell constructor")
        if sig.boundary(result.source) != sig.boundary(result.target):
            raise KernelError("3-cell source and target have different complete frames")
        return result

    def checked(self, cell: ThreeCell) -> ThreeCell:
        self.boundary(cell)
        return cell

    def identity(self, square: Term) -> ThreeCell:
        return self.checked(ThreeCell("id", square))

    def hid(self, vertical_path: Path) -> ThreeCell:
        return self.identity(self.signature.hid(vertical_path))

    def vid(self, horizontal_path: Path) -> ThreeCell:
        return self.identity(self.signature.vid(horizontal_path))

    def gen(self, name: str) -> ThreeCell:
        return self.checked(ThreeCell("gen", name))

    def h(self, first: ThreeCell, second: ThreeCell) -> ThreeCell:
        return self.checked(ThreeCell("h", args=(first, second)))

    def v(self, first: ThreeCell, second: ThreeCell) -> ThreeCell:
        return self.checked(ThreeCell("v", args=(first, second)))

    def z(self, first: ThreeCell, second: ThreeCell, middle: Equality | None = None) -> ThreeCell:
        return self.checked(ThreeCell("z", args=(first, second), evidence=() if middle is None else (middle,)))

    def transport(self, cell: ThreeCell, source: Equality | None = None, target: Equality | None = None) -> ThreeCell:
        old = self.boundary(cell)
        source = reflexivity(old.source) if source is None else source
        target = reflexivity(old.target) if target is None else target
        return self.checked(ThreeCell("transport", args=(cell,), evidence=(source, target)))

    def event_counts(self, cell: ThreeCell) -> tuple[tuple[str, int], ...]:
        """Named directed 3-event counts; transports and their proofs add none.

        This coarse invariant forgets order and does not decide 3-cell equality.
        """
        from collections import Counter

        self.boundary(cell)

        def visit(current):
            result = Counter({current.payload: 1}) if current.op == "gen" else Counter()
            for child in current.args:
                result.update(visit(child))
            return result

        return tuple(sorted(visit(cell).items()))

    @classmethod
    def from_rewrite_theory(cls, theory: RewriteTheory):
        return cls(theory.signature, tuple(ThreeGenerator(rule.name, rule.left, rule.right) for rule in theory.rules.values()))

    def lift_step(self, theory: RewriteTheory, step: RewriteStep) -> ThreeCell:
        """Turn a checked concrete contextual rewrite into an h/v 3-cell term."""
        if theory.signature != self.signature:
            raise KernelError("rewrite theory uses a different lower signature")
        theory.verify_step(step)
        rule = theory.rules[step.rule]
        if self.generators.get(step.rule) != ThreeGenerator(step.rule, rule.left, rule.right):
            raise KernelError("3-cell theory does not declare this directed rule")

        def rec(term, address):
            if not address:
                return self.gen(step.rule)
            index, *tail = address
            children = tuple(rec(child, tail) if j == index else self.identity(child) for j, child in enumerate(term.args))
            return self.h(*children) if term.op == "h" else self.v(*children)

        result = rec(step.source, step.position)
        if self.boundary(result) != ThreeBoundary(step.source, step.target):
            raise KernelError("contextual rewrite embedding failed to preserve endpoints")
        return result

    def lift_trace(self, theory: RewriteTheory, trace: RewriteTrace) -> ThreeCell:
        if theory.signature != self.signature:
            raise KernelError("rewrite theory uses a different lower signature")
        theory.verify_trace(trace)
        if not trace.steps:
            return self.identity(trace.source)
        result = self.lift_step(theory, trace.steps[0])
        for step in trace.steps[1:]:
            result = self.z(result, self.lift_step(theory, step))
        return result
