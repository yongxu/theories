"""Render all v9 PDF pages and report text bounds for manual visual review.

Requires PyMuPDF and Pillow. Full-size intermediate renders go to --render-dir;
contact sheets and numeric checks are retained under evidence/pdf_v9.
This script does not claim to replace human/visual inspection.
"""
from pathlib import Path
import argparse
import hashlib
import json
import fitz
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parent
BOOKS = [
    ("monograph", "文合化_v9.0_严格高阶生成专论.pdf"),
    ("theory", "文合化_v9.0_理论全集.pdf"),
    ("lexicon", "文合化_v9.0_概念词林.pdf"),
]


def contact(doc, pages, target, scale=0.43):
    cols = 4
    tile_w, tile_h = 270, 388
    out = Image.new("RGB", (cols * tile_w, ((len(pages) + cols - 1) // cols) * tile_h), "#dce2e6")
    draw = ImageDraw.Draw(out)
    for i, number in enumerate(pages):
        pix = doc[number - 1].get_pixmap(matrix=fitz.Matrix(scale, scale), alpha=False)
        im = Image.frombytes("RGB", [pix.width, pix.height], pix.samples)
        x, y = (i % cols) * tile_w, (i // cols) * tile_h
        out.paste(im, (x + 7, y + 20))
        draw.text((x + 9, y + 4), f"PDF page {number}", fill="#243949")
    out.save(target)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--render-dir", type=Path, required=True)
    args = parser.parse_args()
    evidence = ROOT / "evidence/pdf_v9"
    evidence.mkdir(parents=True, exist_ok=True)
    args.render_dir.mkdir(parents=True, exist_ok=True)
    results = []
    for key, name in BOOKS:
        path = ROOT / "export" / name
        doc = fitz.open(path)
        render = args.render_dir / key
        render.mkdir(parents=True, exist_ok=True)
        bounds, near, replacements, empty = [], [], [], []
        for i, page in enumerate(doc):
            page.get_pixmap(matrix=fitz.Matrix(1, 1), alpha=False).save(render / f"page_{i+1:03}.png")
            text = page.get_text()
            if not text.strip():
                empty.append(i + 1)
            if "\ufffd" in text:
                replacements.append(i + 1)
            for block in page.get_text("dict")["blocks"]:
                for line in block.get("lines", []):
                    for span in line["spans"]:
                        x0, y0, x1, y1 = span["bbox"]
                        issue = {"page": i + 1, "bbox": list(span["bbox"]), "text": span["text"][:120]}
                        if x0 < 0 or y0 < 0 or x1 > page.rect.width + .5 or y1 > page.rect.height + .5:
                            bounds.append(issue)
                        elif x0 < 25 or x1 > page.rect.width - 25:
                            near.append(issue)
        if key == "monograph":
            for start in range(1, len(doc) + 1, 16):
                contact(doc, list(range(start, min(start + 16, len(doc) + 1))),
                        evidence / f"{key}_{start:03}_{min(start+15,len(doc)):03}.png")
        else:
            choices = [1, 2, 3, 5, 10, 15, 20, len(doc)//3, len(doc)//2,
                       2*len(doc)//3, 3*len(doc)//4, len(doc)-2, len(doc)-1, len(doc)]
            choices += [x["page"] for x in near]
            pages = sorted(set(max(1, min(len(doc), x)) for x in choices))
            for start in range(0, len(pages), 16):
                contact(doc, pages[start:start+16], evidence / f"{key}_selected_{start//16+1}.png")
        warning_log = path.with_suffix(".texwarnings.log").read_text(encoding="utf8")
        results.append({"file": name, "pages": len(doc), "size_bytes": path.stat().st_size,
                        "sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
                        "rendered_pages": len(doc), "outside_page_spans": bounds,
                        "near_edge_spans": near, "replacement_character_pages": replacements,
                        "empty_text_pages": empty, "pandoc_warning_text": warning_log,
                        "visual_review": "recorded separately in QA_REPORT_v9.0.md"})
        print(key, len(doc), "pages; outside", len(bounds), "near edge", len(near), flush=True)
    (evidence / "automatic_checks.json").write_text(json.dumps(results, ensure_ascii=False, indent=2) + "\n", encoding="utf8")


if __name__ == "__main__":
    main()
