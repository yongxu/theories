"""Check the v9 release inventory and SHA-256 values (standard library only).

This verifies file integrity, not mathematical truth or authorship.
Python bytecode caches created by running examples/tests are ignored.
"""
from pathlib import Path, PurePosixPath
import hashlib
import json
import sys


def digest(path):
    h = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            h.update(block)
    return h.hexdigest()


def ignored(path):
    return "__pycache__" in path.parts or path.suffix in {".pyc", ".pyo"}


def verify(root):
    root = root.resolve()
    manifest = json.loads((root / "manifest.json").read_text(encoding="utf8"))
    errors = []
    expected = {}
    for item in manifest["files"]:
        relative = PurePosixPath(item["path"])
        if relative.is_absolute() or ".." in relative.parts:
            errors.append(f"Unsafe manifest path: {relative}")
            continue
        path = root.joinpath(*relative.parts)
        if relative.as_posix() in expected:
            errors.append(f"Duplicate path: {relative}")
        expected[relative.as_posix()] = item
        if not path.is_file() or path.is_symlink():
            errors.append(f"Missing or unsupported file: {relative}")
            continue
        if path.stat().st_size != item["size_bytes"]:
            errors.append(f"Size mismatch: {relative}")
        if digest(path) != item["sha256"]:
            errors.append(f"Hash mismatch: {relative}")
    # Only the root manifest/checksum are excluded. Historical files with the
    # same names remain ordinary payload items.
    actual = {
        p.relative_to(root).as_posix()
        for p in root.rglob("*")
        if p.is_file() and not ignored(p.relative_to(root))
        and p.relative_to(root).as_posix() not in {"manifest.json", "SHA256SUMS.txt"}
    }
    if actual != set(expected):
        errors.append(f"Inventory mismatch; added={sorted(actual-set(expected))}; "
                      f"missing={sorted(set(expected)-actual)}")
    if manifest["file_count"] != len(expected):
        errors.append("Manifest file count mismatch")
    checksums = {}
    for line in (root / "SHA256SUMS.txt").read_text(encoding="utf8").splitlines():
        value, relative = line.split("  ", 1)
        checksums[relative] = value
    expected_checksums = {p: v["sha256"] for p, v in expected.items()}
    expected_checksums["manifest.json"] = digest(root / "manifest.json")
    if checksums != expected_checksums:
        errors.append("SHA256SUMS does not match the payload plus manifest")
    return {"version": manifest["version"], "status": "failed" if errors else "passed",
            "payload_files": len(expected), "total_release_files": len(expected) + 2,
            "errors": errors}


if __name__ == "__main__":
    report = verify(Path(__file__).resolve().parent)
    print(json.dumps(report, ensure_ascii=False, indent=2))
    sys.exit(1 if report["errors"] else 0)
