"""Read HTML on stdin, print its visible text on stdout. No file is kept."""
import sys, re
from html.parser import HTMLParser

SKIP = {"script", "style", "noscript", "svg", "nav", "footer", "header", "button", "form"}
BLOCK = {"p", "div", "section", "article", "li", "tr", "h1", "h2", "h3", "h4", "h5", "h6",
         "table", "ul", "ol", "figure", "figcaption", "blockquote", "br"}

class T(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.out = []
        self.skip = 0

    def handle_starttag(self, tag, attrs):
        if tag in SKIP:
            self.skip += 1
        if tag in BLOCK:
            self.out.append("\n")
        if tag in ("h1", "h2", "h3", "h4"):
            self.out.append("\n## ")
        if tag == "math":
            d = dict(attrs)
            alt = d.get("alttext")
            if alt and not self.skip:
                self.out.append(" $" + alt + "$ ")
                self.skip += 1
                self._math = True
                return
        self._math = False

    def handle_endtag(self, tag):
        if tag in SKIP and self.skip:
            self.skip -= 1
        if tag == "math" and self.skip and getattr(self, "_mathopen", False):
            self.skip -= 1
        if tag in BLOCK:
            self.out.append("\n")

    def handle_data(self, data):
        if not self.skip:
            self.out.append(data)


def main():
    raw = sys.stdin.buffer.read().decode("utf-8", "replace")
    # keep tex/alt annotations of math where present
    raw = re.sub(r'<annotation[^>]*encoding="application/x-tex"[^>]*>(.*?)</annotation>', r' $\1$ ', raw, flags=re.S)
    p = T()
    p.feed(raw)
    text = "".join(p.out)
    text = re.sub(r"[ \t]+", " ", text)
    text = re.sub(r"\n\s*\n\s*\n+", "\n\n", text)
    sys.stdout.write(text)


main()
