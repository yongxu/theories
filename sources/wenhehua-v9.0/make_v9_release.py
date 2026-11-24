"""Write the release manifest and ZIP after documents and tests are final.

The archive is written next to this project directory. Bytecode caches are
excluded. A successful verify_release_v9 check is required before packaging.
"""
from pathlib import Path
import hashlib
import json
import subprocess
import sys
import zipfile

ROOT = Path(__file__).resolve().parent


def digest(path):
    h = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            h.update(block)
    return h.hexdigest()


def included(path):
    relative = path.relative_to(ROOT)
    return (path.is_file() and "__pycache__" not in relative.parts
            and path.suffix not in {".pyc", ".pyo"})


def main():
    required = [
        "export/文合化_v9.0_严格高阶生成专论.pdf",
        "export/文合化_v9.0_理论全集.pdf",
        "export/文合化_v9.0_概念词林.pdf",
        "evidence/QA_REPORT_v9.0.md", "evidence/v9_test_results.json",
    ]
    for name in required:
        if not (ROOT / name).is_file():
            raise FileNotFoundError(name)
    test = json.loads((ROOT / "evidence/v9_test_results.json").read_text())
    if test["exit_code"] != 0 or test["tests_run"] != 313:
        raise RuntimeError("Final v9 test evidence does not match the release gate")
    paths = sorted(p for p in ROOT.rglob("*") if included(p)
                   and p.relative_to(ROOT).as_posix() not in {"manifest.json", "SHA256SUMS.txt"})
    files = [{"path": p.relative_to(ROOT).as_posix(), "sha256": digest(p),
              "size_bytes": p.stat().st_size} for p in paths]
    manifest = {"version": "9.0", "release_date": "2026-11-24", "file_count": len(files),
                "inventory_scope": "all payload files, excluding root manifest.json and SHA256SUMS.txt; bytecode caches excluded",
                "baseline_sha256": "be7f7dbf2706c5cc758a70cd6a568cf74b4c3d008e46b13678c37ee9292e5dae",
                "tests_run": 313, "demonstration_bracketing_checks": 30,
                "files": files}
    manifest_path = ROOT / "manifest.json"
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf8")
    values = {item["path"]: item["sha256"] for item in files}
    values["manifest.json"] = digest(manifest_path)
    (ROOT / "SHA256SUMS.txt").write_text(
        "".join(f"{values[name]}  {name}\n" for name in sorted(values)), encoding="utf8")
    subprocess.run([sys.executable, str(ROOT / "verify_release_v9.py")], check=True)
    archive = ROOT.parent / (ROOT.name + ".zip")
    with zipfile.ZipFile(archive, "w", zipfile.ZIP_DEFLATED, compresslevel=6) as out:
        for path in sorted(p for p in ROOT.rglob("*") if included(p)):
            out.write(path, (Path(ROOT.name) / path.relative_to(ROOT)).as_posix())
    with zipfile.ZipFile(archive) as check:
        bad = check.testzip()
        if bad:
            raise RuntimeError(f"ZIP CRC failure: {bad}")
        entry_count = len(check.infolist())
    result = {"archive": str(archive), "size_bytes": archive.stat().st_size,
              "sha256": digest(archive), "entries": entry_count, "crc_status": "passed"}
    (ROOT.parent / "v9_release_receipt.json").write_text(
        json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf8")
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
