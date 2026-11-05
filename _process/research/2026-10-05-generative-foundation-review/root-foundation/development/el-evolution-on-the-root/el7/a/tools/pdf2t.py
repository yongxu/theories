"""Read a PDF on stdin, print its text on stdout. No file is kept."""
import sys, io
from pypdf import PdfReader
data = sys.stdin.buffer.read()
r = PdfReader(io.BytesIO(data))
for i, p in enumerate(r.pages):
    try:
        t = p.extract_text() or ""
    except Exception as ex:
        t = "[page %d: %s]" % (i + 1, ex)
    sys.stdout.write("\n=== page %d ===\n" % (i + 1))
    sys.stdout.write(t)
