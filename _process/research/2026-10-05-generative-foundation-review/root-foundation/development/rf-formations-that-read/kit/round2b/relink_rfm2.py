#!/usr/bin/env python3
"""RF round 2, second part, RF-M.2's landing: the links in the reviews' verbatim text made to resolve from the
evidence folder, which is link-checked as live (tools/research/moves.py reads every `](`, escaped or not, so the
escaped form first used does not keep a link from being checked). A link that resolves from the folder is kept; one
whose target, its line number dropped, is a path of the checkout is made relative to the folder, the line number kept
in its text; any other (an anchor of the page a quotation came from, a path of the rehearsal alone) is shown as its
text with its target as code. `relink` is used by evidence_rfm2_lean.py and evidence_rfm2_coldread.py. Run as a
script after both have been rerun, it relinks REVIEW-RFM2.md in place (its escaped links first restored), asserts that
each of the three reviews differs from its committed version only in its links and in the sentence saying how they
are shown, and brings the hashes of the three reviews in the record what-holding-for-a-reading-is-worth, made in the
same landing, to their landed bytes.
usage (from the checkout root): python3 -B relink_rfm2.py"""
import hashlib
import json
import posixpath
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path.cwd()
sys.path.insert(0, str(ROOT))
from tools.research.moves import anchors  # noqa: E402

FOLDER = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence'
LINK = re.compile(r'\[([^\]\n]*)\]\(([^)\s]+)\)')
LINE = re.compile(r':\d+(?:-\d+)?$')


def resolves(path, fragment):
    """Whether a repository-relative path is in the checkout and, for a Markdown page, has the anchor."""
    if not path or path.startswith('..') or not (ROOT / path).exists():
        return False
    if fragment and path.endswith('.md') and not re.fullmatch(r'L\d+(-L\d+)?', fragment):
        return fragment in anchors((ROOT / path).read_text(encoding='utf-8', errors='replace'))
    return True


def relink(text):
    def one(m):
        label, target = m.group(1), m.group(2)
        if re.match(r'[a-z]+:', target) and not re.match(r'[A-Za-z0-9_.-]+\.[A-Za-z]+:\d', target):
            return m.group(0)  # an external link
        path, _, fragment = target.partition('#')
        if path and resolves(posixpath.normpath(posixpath.join(FOLDER, path)), fragment):
            return m.group(0)
        bare = LINE.sub('', path)
        if bare and resolves(posixpath.normpath(bare), fragment):
            return f'[{label}]({posixpath.relpath(posixpath.normpath(bare), FOLDER)}' + (
                f'#{fragment}' if fragment else '') + ')'
        return f'{label} (`{target}`)'
    return LINK.sub(one, text)


def bare(text):
    """The text with link targets, targets shown as code, and link brackets removed: what relinking keeps."""
    text = re.sub(r'\]\([^)\s]*\)', ']', text)
    text = re.sub(r' \(`[^`\n]*`\)', '', text)
    return text.replace('\\]', ']').replace('[', '').replace(']', '')


if __name__ == '__main__':
    REVIEWS = [f'{FOLDER}/{name}.md' for name in ('REVIEW-RFM2', 'REVIEW-RFM2-LEAN', 'REVIEW-RFM2-COLDREAD')]
    OLD_SAY = "its links unlinked (`\\](`) since this folder is link-checked as live and its paths made relative to the checkout"
    NEW_SAY = ("its paths made relative to the checkout and its links to this folder, since this folder is link-checked "
               "as live: a line number kept in a link's text and dropped from its target, and a link that does not "
               "resolve here shown as its text with its target as code")
    first = ROOT / REVIEWS[0]
    text = first.read_text(encoding='utf-8')
    if OLD_SAY in text:
        assert text.count(OLD_SAY) == 1
        first.write_text(relink(text.replace(OLD_SAY, NEW_SAY).replace('\\](', '](')), encoding='utf-8')
    for path in REVIEWS:
        old = subprocess.run(['git', 'show', f'HEAD:{path}'], capture_output=True, text=True, check=True).stdout
        new = (ROOT / path).read_text(encoding='utf-8')
        assert '\\](' not in new, path
        before, after = bare(old).split('\n'), bare(new).split('\n')
        assert len(before) == len(after), (path, len(before), len(after))
        changed = [i for i, (a, b) in enumerate(zip(before, after)) if a != b]
        assert all(i < 6 for i in changed), (path, changed[:5])  # only the opening says how links are shown
        print(f'{path.split("/")[-1]}: links only, opening lines changed {changed}')
    record = ROOT / 'theories/becoming/results/records/what-holding-for-a-reading-is-worth.json'
    d = json.loads(record.read_text(encoding='utf-8'))
    for ref in d['references']:
        if ref['path'] in REVIEWS:
            assert ref['role'] == 'integration'
            new_sha = hashlib.sha256((ROOT / ref['path']).read_bytes()).hexdigest()
            print(f"{ref['path'].split('/')[-1]}: {ref['sha256'][:12]} -> {new_sha[:12]}")
            ref['sha256'] = new_sha
    record.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
