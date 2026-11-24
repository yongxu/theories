"""A small proof-certificate kernel for a generated strict double category.

The raw terms keep their parentheses and generating-square names.  ``verify``
checks an explicit derivation in the double-category equational theory; it is
not an implementation of a general word-problem algorithm.  Directed rewrite
traces are a separate datatype and are not silently promoted to equalities.

The finite-function interpretation below is an exact *thin* double category of
commuting squares.  It is useful for soundness checks and is not faithful to
the syntax: different named events may have the same functional observation.

Python >= 3.10; standard library only.  This is executable certificate checking,
not a Lean/Coq proof of the mathematical metatheory.
"""

from __future__ import annotations

from collections import Counter
from dataclasses import dataclass
from types import MappingProxyType
from typing import Mapping


class KernelError(ValueError):
    """An ill-typed construction or an invalid certificate."""


@dataclass(frozen=True)
class Arrow:
    name: str
    source: str
    target: str


@dataclass(frozen=True)
class Path:
    axis: str
    source: str
    target: str
    edges: tuple[str, ...] = ()

    def __post_init__(self):
        object.__setattr__(self, "edges", tuple(self.edges))


@dataclass(frozen=True)
class Frame:
    top: Path
    bottom: Path
    left: Path
    right: Path


@dataclass(frozen=True)
class SquareGenerator:
    name: str
    frame: Frame


@dataclass(frozen=True)
class Term:
    op: str
    payload: str | Path | None = None
    args: tuple[Term, ...] = ()

    def __post_init__(self):
        object.__setattr__(self, "args", tuple(self.args))


@dataclass(frozen=True)
class Equality:
    rule: str
    left: Term
    right: Term
    premises: tuple[Equality, ...] = ()

    def __post_init__(self):
        object.__setattr__(self, "premises", tuple(self.premises))


@dataclass(frozen=True, init=False)
class Signature:
    """Finite declarations; generated paths and square terms need not be finite.

    The declaration dictionaries are immutable views.  Arrow names are unique
    within each axis; the same spelling in the two axes remains two generators.
    """

    objects: frozenset[str]
    horizontal: Mapping[str, Arrow]
    vertical: Mapping[str, Arrow]
    squares: Mapping[str, SquareGenerator]

    def __init__(self, objects, horizontal=(), vertical=(), squares=()):
        object.__setattr__(self, "objects", frozenset(objects))
        if any(not isinstance(o, str) or not o for o in self.objects):
            raise KernelError("object names must be nonempty strings")
        object.__setattr__(self, "horizontal", self._unique(horizontal, "horizontal arrow"))
        object.__setattr__(self, "vertical", self._unique(vertical, "vertical arrow"))
        object.__setattr__(self, "squares", self._unique(squares, "square"))
        for arrows in (self.horizontal, self.vertical):
            for arrow in arrows.values():
                if not isinstance(arrow, Arrow):
                    raise KernelError("arrow declarations must be Arrow values")
                if arrow.source not in self.objects or arrow.target not in self.objects:
                    raise KernelError("arrow endpoint is undeclared")
        for square in self.squares.values():
            if not isinstance(square, SquareGenerator):
                raise KernelError("square declarations must be SquareGenerator values")
            self.check_frame(square.frame)

    @staticmethod
    def _unique(values, label):
        result = {}
        for value in values:
            name = getattr(value, "name", None)
            if not isinstance(name, str) or not name or name in result:
                raise KernelError("missing or duplicate " + label + " name")
            result[name] = value
        return MappingProxyType(result)

    def check_path(self, path: Path) -> Path:
        if not isinstance(path, Path) or path.axis not in ("h", "v"):
            raise KernelError("expected an h or v path")
        if any(not isinstance(edge, str) for edge in path.edges):
            raise KernelError("path edges must be declared names")
        if path.source not in self.objects or path.target not in self.objects:
            raise KernelError("path endpoint is undeclared")
        arrows = self.horizontal if path.axis == "h" else self.vertical
        current = path.source
        for edge in path.edges:
            if edge not in arrows or arrows[edge].source != current:
                raise KernelError("unknown or noncomposable path edge")
            current = arrows[edge].target
        if current != path.target:
            raise KernelError("path target does not match its word")
        return path

    def path(self, axis: str, source: str, *edges: str) -> Path:
        if axis not in ("h", "v"):
            raise KernelError("path axis must be h or v")
        arrows = self.horizontal if axis == "h" else self.vertical
        current = source
        for edge in edges:
            if edge not in arrows or arrows[edge].source != current:
                raise KernelError("unknown or noncomposable path edge")
            current = arrows[edge].target
        return self.check_path(Path(axis, source, current, edges))

    def then(self, first: Path, second: Path) -> Path:
        self.check_path(first)
        self.check_path(second)
        if first.axis != second.axis or first.target != second.source:
            raise KernelError("paths do not compose")
        return Path(first.axis, first.source, second.target, first.edges + second.edges)

    def check_frame(self, frame: Frame) -> Frame:
        if not isinstance(frame, Frame):
            raise KernelError("expected a square frame")
        for path in (frame.top, frame.bottom, frame.left, frame.right):
            self.check_path(path)
        if (frame.top.axis, frame.bottom.axis, frame.left.axis, frame.right.axis) != ("h", "h", "v", "v"):
            raise KernelError("square sides have incorrect axes")
        if not (
            frame.top.source == frame.left.source
            and frame.top.target == frame.right.source
            and frame.bottom.source == frame.left.target
            and frame.bottom.target == frame.right.target
        ):
            raise KernelError("square corners do not agree")
        return frame

    def boundary(self, term: Term) -> Frame:
        """Recompute the complete frame; never trust a cached annotation."""
        if not isinstance(term, Term):
            raise KernelError("expected a square term")
        if term.op == "atom":
            if term.args or not isinstance(term.payload, str) or term.payload not in self.squares:
                raise KernelError("undeclared or malformed square generator")
            return self.squares[term.payload].frame
        if term.op in ("hid", "vid"):
            if term.args or not isinstance(term.payload, Path):
                raise KernelError("malformed unit square")
            path = self.check_path(term.payload)
            if term.op == "hid":
                if path.axis != "v":
                    raise KernelError("horizontal unit needs a vertical path")
                return Frame(self.path("h", path.source), self.path("h", path.target), path, path)
            if path.axis != "h":
                raise KernelError("vertical unit needs a horizontal path")
            return Frame(path, path, self.path("v", path.source), self.path("v", path.target))
        if term.op not in ("h", "v") or term.payload is not None or len(term.args) != 2:
            raise KernelError("unknown or malformed term constructor")
        a, b = map(self.boundary, term.args)
        if term.op == "h":
            if a.right != b.left:
                raise KernelError("horizontal paste requires equal complete vertical seams")
            return Frame(self.then(a.top, b.top), self.then(a.bottom, b.bottom), a.left, b.right)
        if a.bottom != b.top:
            raise KernelError("vertical paste requires equal complete horizontal seams")
        return Frame(a.top, b.bottom, self.then(a.left, b.left), self.then(a.right, b.right))

    def atom(self, name: str) -> Term:
        return self.checked(Term("atom", name))

    def hid(self, path: Path) -> Term:
        return self.checked(Term("hid", path))

    def vid(self, path: Path) -> Term:
        return self.checked(Term("vid", path))

    def h(self, first: Term, second: Term) -> Term:
        return self.checked(Term("h", args=(first, second)))

    def v(self, first: Term, second: Term) -> Term:
        return self.checked(Term("v", args=(first, second)))

    def checked(self, term: Term) -> Term:
        self.boundary(term)
        return term

    def axiom(self, rule: str, *values) -> Equality:
        """Build a single oriented law instance; its converse uses ``sym``."""
        if rule in ("hassoc", "vassoc") and len(values) == 3:
            a, b, c = values
            op = self.h if rule == "hassoc" else self.v
            left, right = op(op(a, b), c), op(a, op(b, c))
        elif rule in ("hunit_left", "hunit_right", "vunit_top", "vunit_bottom") and len(values) == 1:
            a = values[0]
            frame = self.boundary(a)
            left = {
                "hunit_left": lambda: self.h(self.hid(frame.left), a),
                "hunit_right": lambda: self.h(a, self.hid(frame.right)),
                "vunit_top": lambda: self.v(self.vid(frame.top), a),
                "vunit_bottom": lambda: self.v(a, self.vid(frame.bottom)),
            }[rule]()
            right = a
        elif rule == "exchange" and len(values) == 4:
            a, b, c, d = values
            left = self.v(self.h(a, b), self.h(c, d))
            right = self.h(self.v(a, c), self.v(b, d))
        elif rule == "hid_comp" and len(values) == 2:
            u, v = values
            left, right = self.v(self.hid(u), self.hid(v)), self.hid(self.then(u, v))
        elif rule == "vid_comp" and len(values) == 2:
            f, g = values
            left, right = self.h(self.vid(f), self.vid(g)), self.vid(self.then(f, g))
        elif rule == "double_unit" and len(values) == 1:
            obj = values[0]
            left, right = self.hid(self.path("v", obj)), self.vid(self.path("h", obj))
        else:
            raise KernelError("unknown axiom or incorrect argument count")
        proof = Equality(rule, left, right)
        self.verify(proof)
        return proof

    def verify(self, proof: Equality) -> bool:
        """Replay a finite equality certificate, rejecting unsupported axioms."""
        if not isinstance(proof, Equality):
            raise KernelError("directed rewrites are not equality certificates")
        left, right = proof.left, proof.right
        if self.boundary(left) != self.boundary(right):
            raise KernelError("equality endpoints have different complete frames")
        rule, ps = proof.rule, proof.premises
        arities = {"refl": 0, "sym": 1, "trans": 2, "hcong": 2, "vcong": 2}
        structural = {"hassoc", "vassoc", "hunit_left", "hunit_right", "vunit_top", "vunit_bottom", "exchange", "hid_comp", "vid_comp", "double_unit"}
        if rule not in arities and rule not in structural:
            raise KernelError("unknown equality rule")
        if len(ps) != arities.get(rule, 0):
            raise KernelError("incorrect number of equality premises")
        for premise in ps:
            self.verify(premise)
        valid = False
        if rule == "refl":
            valid = left == right
        elif rule == "sym":
            valid = (left, right) == (ps[0].right, ps[0].left)
        elif rule == "trans":
            valid = ps[0].right == ps[1].left and (left, right) == (ps[0].left, ps[1].right)
        elif rule in ("hcong", "vcong"):
            op = self.h if rule == "hcong" else self.v
            valid = (left, right) == (op(ps[0].left, ps[1].left), op(ps[0].right, ps[1].right))
        elif rule in ("hassoc", "vassoc"):
            op = "h" if rule == "hassoc" else "v"
            if left.op == op and left.args[0].op == op:
                a, b = left.args[0].args
                c = left.args[1]
                valid = right == Term(op, args=(a, Term(op, args=(b, c))))
        elif rule in ("hunit_left", "hunit_right", "vunit_top", "vunit_bottom"):
            frame = self.boundary(right)
            expected = {
                "hunit_left": lambda: self.h(self.hid(frame.left), right),
                "hunit_right": lambda: self.h(right, self.hid(frame.right)),
                "vunit_top": lambda: self.v(self.vid(frame.top), right),
                "vunit_bottom": lambda: self.v(right, self.vid(frame.bottom)),
            }[rule]()
            valid = left == expected
        elif rule == "exchange":
            if left.op == "v" and all(t.op == "h" for t in left.args):
                a, b = left.args[0].args
                c, d = left.args[1].args
                valid = right == self.h(self.v(a, c), self.v(b, d))
        elif rule == "hid_comp":
            if left.op == "v" and all(t.op == "hid" for t in left.args):
                valid = right == self.hid(self.then(left.args[0].payload, left.args[1].payload))
        elif rule == "vid_comp":
            if left.op == "h" and all(t.op == "vid" for t in left.args):
                valid = right == self.vid(self.then(left.args[0].payload, left.args[1].payload))
        elif rule == "double_unit":
            if left.op == "hid" and not left.payload.edges:
                valid = right == self.vid(self.path("h", left.payload.source))
        if not valid:
            raise KernelError("certificate does not instantiate its named rule")
        return True


def reflexivity(term: Term) -> Equality:
    return Equality("refl", term, term)


def symmetry(proof: Equality) -> Equality:
    return Equality("sym", proof.right, proof.left, (proof,))


def transitivity(first: Equality, second: Equality) -> Equality:
    return Equality("trans", first.left, second.right, (first, second))


def congruence(axis: str, first: Equality, second: Equality) -> Equality:
    if axis not in ("h", "v"):
        raise KernelError("congruence axis must be h or v")
    return Equality(axis + "cong", Term(axis, args=(first.left, second.left)), Term(axis, args=(first.right, second.right)), (first, second))


@dataclass(frozen=True)
class RewriteRule:
    name: str
    left: Term
    right: Term


@dataclass(frozen=True)
class RewriteStep:
    rule: str
    source: Term
    target: Term
    position: tuple[int, ...] = ()

    def __post_init__(self):
        object.__setattr__(self, "position", tuple(self.position))


@dataclass(frozen=True)
class RewriteTrace:
    source: Term
    target: Term
    steps: tuple[RewriteStep, ...] = ()

    def __post_init__(self):
        object.__setattr__(self, "steps", tuple(self.steps))


@dataclass(frozen=True, init=False)
class RewriteTheory:
    """Concrete, directed rewrites in well-typed binary-pasting contexts.

    Rules have no implicit metavariables, reverse direction, matching modulo
    equations, or unproved semantic guarantee.  This implements a path category
    of contextual rewrites on raw terms, not all equations of Cat(DblCat).
    """

    signature: Signature
    rules: Mapping[str, RewriteRule]

    def __init__(self, signature: Signature, rules=()):
        object.__setattr__(self, "signature", signature)
        object.__setattr__(self, "rules", signature._unique(rules, "rewrite"))
        for rule in self.rules.values():
            if not isinstance(rule, RewriteRule):
                raise KernelError("expected a directed rewrite declaration")
            if signature.boundary(rule.left) != signature.boundary(rule.right):
                raise KernelError("rewrite endpoints must have the same complete frame")

    def _replace(self, term: Term, position, before: Term, after: Term) -> Term:
        if not position:
            if term != before:
                raise KernelError("rewrite left side does not match at the address")
            return after
        index, *tail = position
        if type(index) is not int or index not in (0, 1) or term.op not in ("h", "v"):
            raise KernelError("rewrite address is not a binary-pasting context")
        args = list(term.args)
        args[index] = self._replace(args[index], tail, before, after)
        return self.signature.checked(Term(term.op, args=tuple(args)))

    def apply(self, rule_name: str, source: Term, position=()) -> RewriteStep:
        self.signature.boundary(source)
        if rule_name not in self.rules:
            raise KernelError("undeclared rewrite rule")
        rule = self.rules[rule_name]
        target = self._replace(source, tuple(position), rule.left, rule.right)
        step = RewriteStep(rule_name, source, target, tuple(position))
        self.verify_step(step)
        return step

    def verify_step(self, step: RewriteStep) -> bool:
        if not isinstance(step, RewriteStep) or step.rule not in self.rules:
            raise KernelError("expected a declared directed rewrite step")
        sig = self.signature
        if sig.boundary(step.source) != sig.boundary(step.target):
            raise KernelError("rewrite changes the external frame")
        rule = self.rules[step.rule]
        if self._replace(step.source, step.position, rule.left, rule.right) != step.target:
            raise KernelError("forged rewrite target")
        return True

    def verify_trace(self, trace: RewriteTrace) -> bool:
        if not isinstance(trace, RewriteTrace):
            raise KernelError("expected a directed rewrite trace")
        self.signature.boundary(trace.source)
        self.signature.boundary(trace.target)
        current = trace.source
        for step in trace.steps:
            self.verify_step(step)
            if current != step.source:
                raise KernelError("rewrite trace has a gap")
            current = step.target
        if current != trace.target:
            raise KernelError("rewrite trace target is incorrect")
        return True

    def identity(self, term: Term) -> RewriteTrace:
        self.signature.boundary(term)
        return RewriteTrace(term, term)

    def trace(self, *steps: RewriteStep) -> RewriteTrace:
        if not steps:
            raise KernelError("empty trace needs an explicit object: use identity(term)")
        result = RewriteTrace(steps[0].source, steps[-1].target, tuple(steps))
        self.verify_trace(result)
        return result

    def then(self, first: RewriteTrace, second: RewriteTrace) -> RewriteTrace:
        self.verify_trace(first)
        self.verify_trace(second)
        if first.target != second.source:
            raise KernelError("rewrite traces do not compose")
        result = RewriteTrace(first.source, second.target, first.steps + second.steps)
        self.verify_trace(result)
        return result


@dataclass(frozen=True)
class FiniteMap:
    source: str
    target: str
    domain: tuple[str, ...]
    codomain: tuple[str, ...]
    outputs: tuple[str, ...]

    def __post_init__(self):
        for field in ("domain", "codomain", "outputs"):
            object.__setattr__(self, field, tuple(getattr(self, field)))
        if len(set(self.domain)) != len(self.domain) or len(set(self.codomain)) != len(self.codomain):
            raise KernelError("finite sets must not repeat elements")
        if len(self.outputs) != len(self.domain) or any(x not in self.codomain for x in self.outputs):
            raise KernelError("finite function is not total into its codomain")

    def then(self, other: FiniteMap) -> FiniteMap:
        if self.target != other.source or self.codomain != other.domain:
            raise KernelError("finite maps do not compose")
        lookup = dict(zip(other.domain, other.outputs))
        return FiniteMap(self.source, other.target, self.domain, other.codomain, tuple(lookup[x] for x in self.outputs))


@dataclass(frozen=True)
class FunctionSquare:
    top: FiniteMap
    bottom: FiniteMap
    left: FiniteMap
    right: FiniteMap

    def __post_init__(self):
        if self.top.then(self.right) != self.left.then(self.bottom):
            raise KernelError("function square does not commute")


class FunctionModel:
    """Exact interpretation in commuting squares of finite total functions."""

    def __init__(self, signature: Signature, objects: Mapping[str, tuple[str, ...]], horizontal: Mapping[str, tuple[str, ...]], vertical: Mapping[str, tuple[str, ...]]):
        self.signature = signature
        if set(objects) != set(signature.objects) or set(horizontal) != set(signature.horizontal) or set(vertical) != set(signature.vertical):
            raise KernelError("semantic assignments must cover precisely the signature")
        self.objects = MappingProxyType({name: tuple(values) for name, values in objects.items()})
        self.images = {}
        for axis, declarations, assignments in (("h", signature.horizontal, horizontal), ("v", signature.vertical, vertical)):
            self.images[axis] = MappingProxyType({name: FiniteMap(arrow.source, arrow.target, self.objects[arrow.source], self.objects[arrow.target], tuple(assignments[name])) for name, arrow in declarations.items()})
        self.images = MappingProxyType(self.images)
        for obj in self.objects:
            self.identity(obj)  # Includes objects without incident arrows.
        for square in signature.squares.values():
            self.frame(square.frame)  # Reject noncommuting generator assignments.

    def identity(self, obj: str) -> FiniteMap:
        values = self.objects[obj]
        return FiniteMap(obj, obj, values, values, values)

    def path(self, path: Path) -> FiniteMap:
        self.signature.check_path(path)
        result = self.identity(path.source)
        for name in path.edges:
            result = result.then(self.images[path.axis][name])
        return result

    def frame(self, frame: Frame) -> FunctionSquare:
        self.signature.check_frame(frame)
        return FunctionSquare(*(self.path(path) for path in (frame.top, frame.bottom, frame.left, frame.right)))

    def interpret(self, term: Term) -> FunctionSquare:
        """Evaluate by structural recursion, and check its computed frame."""
        sig = self.signature
        frame = sig.boundary(term)
        if term.op in ("atom", "hid", "vid"):
            result = self.frame(frame)
        else:
            a, b = (self.interpret(t) for t in term.args)
            if term.op == "h":
                result = FunctionSquare(a.top.then(b.top), a.bottom.then(b.bottom), a.left, b.right)
            else:
                result = FunctionSquare(a.top, b.bottom, a.left.then(b.left), a.right.then(b.right))
        if result != self.frame(frame):
            raise KernelError("interpretation failed to preserve the boundary")
        return result

    def respects(self, proof: Equality) -> bool:
        self.signature.verify(proof)
        return self.interpret(proof.left) == self.interpret(proof.right)


class EventCountModel:
    """A separating invariant for named generating-square multiplicities.

    All objects/arrows map to the sole object/identity.  Squares form the free
    commutative monoid on generator names; both square compositions are addition.
    This is a strict double-category interpretation, not a faithful one: it
    forgets all boundaries and order.  Different counts nevertheless prove
    that no structural equality certificate can connect the terms.
    """

    def __init__(self, signature: Signature):
        self.signature = signature

    def interpret(self, term: Term) -> tuple[tuple[str, int], ...]:
        self.signature.boundary(term)

        def visit(current):
            if current.op == "atom":
                return Counter({current.payload: 1})
            total = Counter()
            for child in current.args:
                total.update(visit(child))
            return total

        return tuple(sorted(visit(term).items()))

    def respects(self, proof: Equality) -> bool:
        self.signature.verify(proof)
        return self.interpret(proof.left) == self.interpret(proof.right)
