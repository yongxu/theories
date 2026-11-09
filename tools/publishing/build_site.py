"""Build the reader's site: a static site of the pages a reader starts from, built from the repository at one commit.

The pages come only from the allow-list `site.pages` in _process/research-config.json, and a page whose path the push
screen's private pattern matches (tools/research/push_screen.sh, read from that file so there is one list) or that lies
under sources/ is refused. Each page is converted from its Markdown with the standard library, its headings given the
anchors GitHub gives them (tools/research/reading_catalogue.slug, which the repository's link check uses). A link to
another page of the site becomes a link to its HTML; a link to any other tracked file goes to that file on GitHub as it
stood at the build commit; a link to a path the repository does not track is shown as its text. Every link between pages
of the site, anchor included, must resolve, or the build fails. At each result's anchor (`r-<record id>`), in a table cell
or a list as at a line of its own, the page gets a small mark of the record's status, linked to the record. The home is
README's generated first screen in its own words: its "Start with" paragraph comes last of its text, then the picture and
its caption, bounded in height, then the ways in that `site.ways_in` lists, each with its reading time (`time` on a card says
what the time is of), counted as the page's own stated time is. A picture's image carries its SVG's width and height, so its
box is kept before it loads. The pages of `site.chapters` get contents and previous and next links; the
navigation line a generated page carries, as do the fronts in navigation.NAV_FRONTS and the Chinese fronts (zh_fronts), is dropped, the site having its own; `site.rewrites` changes the words of the pages a rule names, or of any page where a rule naming none matches, of named
pages at build, where a frozen copy binds the source or the words are true only off the site, or adds a link only the site
serves. With `site.map`, the
connection map is written by its generator's site mode (tools/research/connection_map.py), its links to pages of the site
kept there. Beside the pages the build writes search.json (each page's title, headings and lead, each result's name and
lead, a former id's page ranked last), read by a small script of its own (no external script), a 404.html for a project
site at /<repo>/ (`site.site_root` for another root), and a favicon. A page in Chinese names the work, describes it and
labels the site's own markup in Chinese (`site.title_zh`, `site.description_zh`); the language link stands outside the
navigation line, so that no width hides it. Where GitHub may not have the build commit (it is not on origin/main as the
clone last fetched it, and the build is not GitHub's own run of it), each page's footer says that links to GitHub at it may
not resolve. Nothing written may print a local path. Nothing generated is committed: the site is written to tmp/site/
(untracked) or --out, and the Pages job builds it from main.

Run from the repository's root:  python3 tools/publishing/build_site.py [--out DIR] [--commit SHA]
"""
import argparse
from collections import Counter
import html
from itertools import islice
import json
import os
import pathlib
import posixpath
import re
import shutil
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))
from tools.research import reading_catalogue  # noqa: E402  (GitHub's anchors, as the link check reads them)
from tools.research import navigation  # noqa: E402  (reading times and the status words)

CONFIG = ROOT / '_process' / 'research-config.json'
PUSH_SCREEN = ROOT / 'tools' / 'research' / 'push_screen.sh'
ASSET_TYPES = {'.svg', '.png', '.jpg', '.jpeg', '.gif', '.webp'}
SAFE_SCHEMES = {'http', 'https', 'mailto'}  # any other scheme (javascript:, data:, vbscript:) is not linked
# Attributes a raw tag may keep; everything else (handlers, style, srcdoc, formaction) is dropped.
SAFE_ATTRS = {'href', 'src', 'id', 'name', 'alt', 'title', 'class', 'align', 'colspan', 'rowspan', 'start', 'open', 'width',
              'height', 'lang'}
MAX_PAGE = 2_000_000  # bytes of one built page; the connection map, which carries its data inline, is exempt
STATUS_MARK = {'recorded-checked': 'Lean receipt', 'reviewed-scoped': 'reviewed at its scope', 'open': 'open target',
               'superseded': 'superseded', 'withdrawn': 'withdrawn'}
RECORDS = 'theories/becoming/results/records/'
# A path on someone's machine: a home folder, a mounted volume or a temporary folder, at a word's start or after a compiler's
# -I or -L. One /tmp/ path is told to the reader, not someone's: MAP.md's `BECOMING_OUT=/tmp/becoming-run`, for a receipt
# outside the repository. That exact string is all that passes.
LOCAL_PATH = re.compile(r"(?:(?<![\w.~-])|(?<=(?<![\w./~-])-[IL]))"
                        r"(?:/Users/[\w.-]+|/home/[\w.-]+/|/Volumes/[\w.-]+|/private/(?:tmp|var)/|/var/folders/|[A-Za-z]:\\Users\\"
                        r"|(?<!/)~/[\w.-]|(?<!BECOMING_OUT=)/tmp/|/tmp/(?!becoming-run(?![\w./-])))")
TEXT_WRITTEN = ('.html', '.svg', '.css', '.json', '.js')  # what the written-file scans read
# A table is shown wider than the text at this many columns, or with a row this long; on a phone it stacks at three or more
# columns with a row this long (short numeric cells read better scrolled than as a tall list of labels).
WIDE_COLUMNS, WIDE_ROW, STACK_ROW = 5, 500, 120
FAVICON = ('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32"><rect width="32" height="32" rx="6" fill="#8c2f1e"/>'
           '<path d="M16 27V13M16 17c0-5 4-8 9-8 0 5-4 8-9 8zM16 21c0-4-3-7-8-7 0 4 3 7 8 7z" fill="#fbfaf7" stroke="#fbfaf7" '
           'stroke-width="2" stroke-linejoin="round" stroke-linecap="round"/></svg>\n')
RESULT_ANCHOR = re.compile(r'<a\b[^<>]*\b(?:id|name)="(r-[^"]+)"[^<>]*></a>')
# What the site's own markup says to a reader (labels read aloud, titles shown on hover), in the page's language.
SAY_EN = {'here': 'Link to this section', 'back': 'Back', 'nolink': 'Not in the public repository',
          'picture': 'Open the picture at full size', 'pages': 'Pages', 'search': 'Search', 'contents': 'Contents', 'chapters': 'Chapters'}
SAY_ZH = {'here': '本节的链接', 'back': '返回', 'nolink': '不在公开的仓库中', 'picture': '打开原尺寸的图',
          'pages': '页面', 'search': '搜索', 'contents': '目录', 'chapters': '章节'}


class SiteError(Exception):
    pass


# ---------------------------------------------------------------------------------------------- what may be published

def private_pattern(screen: pathlib.Path = PUSH_SCREEN) -> re.Pattern:
    """The push screen's pattern of private paths, read from its `p=` line, so the site and the push refuse one list."""
    for line in screen.read_text().splitlines():
        if line.startswith('p=$(') and "grep -E '" in line:
            return re.compile(line.split("grep -E '", 1)[1].rsplit("')", 1)[0])
    raise SiteError('the push screen has no private-path pattern on a p= line: ' + str(screen))


def secret_pattern(screen: pathlib.Path = PUSH_SCREEN) -> re.Pattern:
    """The push screen's pattern of possible keys, from its `k=` line (its shell quoting undone)."""
    for line in screen.read_text().splitlines():
        if line.startswith('k=$(') and "grep -E -i '" in line:
            body = line.split("grep -E '^\\+' | grep -E -i '", 1)[1].rsplit("' | cut", 1)[0]
            return re.compile(body.replace("'\"'\"'", "'"), re.I)
    raise SiteError('the push screen has no key pattern on a k= line: ' + str(screen))


def refused(path: str, private: re.Pattern) -> bool:
    return bool(private.search(path)) or path.startswith('sources/')


def tracked_files(root: pathlib.Path = ROOT) -> set:
    out = subprocess.run(['git', 'ls-files', '-z'], cwd=root, capture_output=True, check=True).stdout
    return {p for p in out.decode().split('\0') if p}


def tracked_dirs(files: set) -> set:
    dirs = set()
    for f in files:
        d = posixpath.dirname(f)
        while d and d not in dirs:
            dirs.add(d)
            d = posixpath.dirname(d)
    return dirs


# ---------------------------------------------------------------------------------------------- where each page goes

def out_path(page: str) -> str:
    """X.md is served as X.html; a README.md as its folder's index.html."""
    if page.endswith('/README.md') or page == 'README.md':
        return page[:-len('README.md')] + 'index.html'
    if page.endswith('.md'):
        return page[:-3] + '.html'
    return page


def relative(target: str, page: str) -> str:
    """target (a site path) as seen from page's built file."""
    return posixpath.relpath(target, posixpath.dirname(out_path(page)) or '.')


class Links:
    """Rewrites the links of one page: to another site page, to GitHub at the commit, or to plain text."""

    def __init__(self, pages: set, assets: set, files: set, dirs: set, repo: str, commit: str, aliases=None):
        self.pages, self.assets, self.files, self.dirs = pages, assets, files, dirs
        self.aliases = aliases or {}
        self.repo, self.commit = repo, commit
        self.internal = []  # (page, target page, anchor) for the anchor check
        self.counts = {'site': 0, 'github': 0, 'untracked': 0, 'external': 0, 'private': 0, 'refused': 0}
        self.private = None  # the push screen's pattern, set by build: a link to a private path is shown as text
        self.sizes = {}  # an SVG asset's (width, height), set by build, so a picture's box is known before it loads
        self.untracked = []
        self.unbuilt = set()  # special pages this build does not write (the map, when site.map is off)

    def github(self, path: str, anchor: str = '') -> str:
        kind = 'tree' if path in self.dirs else 'blob'
        return f'https://github.com/{self.repo}/{kind}/{self.commit}/{path}' + (f'#{anchor}' if anchor else '')

    def resolve(self, href: str, page: str):
        """The rewritten href, or None where the target is not in the public repository."""
        href = href.strip()
        if href.startswith('<') and href.endswith('>'):
            href = href[1:-1]
        probe = ''.join(html.unescape(href).split())  # a browser undoes entities and ignores whitespace in a scheme
        scheme = re.match(r'^([a-z][a-z0-9+.-]*):', probe, re.I)
        if scheme:
            if scheme.group(1).lower() not in SAFE_SCHEMES:
                self.counts['refused'] += 1
                return None
            self.counts['external'] += 1
            return href
        path, _, anchor = href.partition('#')
        path, _, query = path.partition('?')  # GitHub's ?plain=1 (a source's lines) is kept on a link to GitHub
        from urllib.parse import unquote
        target = posixpath.normpath(posixpath.join(posixpath.dirname(page), unquote(path))) if path else page
        lines = bool(query) or bool(re.fullmatch(r'L\d+(-L\d+)?', anchor))  # a line of a file: only GitHub shows it
        alias = None if lines else (self.aliases.get(f'{target}#{anchor}') or self.aliases.get(target))
        if alias:
            target, _, a2 = alias.partition('#')
            anchor = a2 or anchor
        if target == page and not lines:
            self.internal.append((page, page, anchor))
            return '#' + anchor if anchor else posixpath.basename(out_path(page))
        if target in SPECIAL and target not in self.unbuilt:
            self.counts['site'] += 1
            if anchor and target == 'index.html':
                self.internal.append((page, target, anchor))  # the home's ids are checked with the rest
            return relative(target, page) + (f'#{anchor}' if anchor else '')
        if target.startswith('../') or target == '..':
            self.counts['untracked'] += 1
            self.untracked.append((page, href))
            return None
        if target in self.dirs and posixpath.join(target, 'README.md') in self.pages:
            target = posixpath.join(target, 'README.md')
        if target in self.pages and not lines:
            self.counts['site'] += 1
            self.internal.append((page, target, anchor))
            return relative(out_path(target), page) + (f'#{anchor}' if anchor else '')
        if target in self.assets:
            self.counts['site'] += 1
            return relative(target, page)
        if self.private is not None and (self.private.search(target) or (target in self.dirs and self.private.search(target + '/'))):
            self.counts['private'] += 1
            self.untracked.append((page, href))
            return None
        if target in self.files or target in self.dirs:
            self.counts['github'] += 1
            link = self.github(target)
            return link + (f'?{query}' if query else '') + (f'#{anchor}' if anchor else '')
        self.counts['untracked'] += 1
        self.untracked.append((page, href))
        return None


# ---------------------------------------------------------------------------------------------- Markdown to HTML

# Raw HTML a page may carry, kept with its links rewritten and no handler or script URL; any other tag is shown as text.
TAGS = ('a|br|sup|sub|span|small|kbd|abbr|ins|del|b|i|em|strong|code|details|summary|div|p|table|thead|tbody|tr|td|th|'
        'figure|figcaption|picture|source|hr|img|ul|ol|li|dl|dt|dd|center')
INLINE_HTML = re.compile(r'</?(?:' + TAGS + r')\b[^<>]*>', re.I)
BLOCK_HTML = re.compile(r'^\s*</?(?:details|summary|div|p|table|thead|tbody|tr|td|th|img|figure|figcaption|picture|source|br|hr|center|dl)\b[^<>]*>', re.I)


class Page:
    """One Markdown page converted to HTML: its body, title, ids and the records whose anchors it carries."""

    def __init__(self, path: str, text: str, links: Links, records: dict):
        self.path, self.links, self.records = path, links, records
        self.ids, self.slugs, self.footnotes, self.refdefs = set(), {}, {}, {}
        self.title = None
        self.fn_order, self.fn_refs = [], {}
        self.first_heading = None
        self.toc = []  # (level, id, plain text) of each heading
        self.anchors, self.marked = set(), set()  # result anchors seen, and those given their record's mark
        text = strip_comments(text)
        self.lang = 'zh' if path.endswith('.zh.md') or cjk_share(text) > 0.3 else 'en'  # before the blocks: their labels follow it
        self.say = SAY_ZH if self.lang == 'zh' else SAY_EN
        lines = text.split('\n')
        lines = self._definitions(lines)
        self.html = self._blocks(lines) + self._footnote_list()
        self.title = self.title or self.first_heading

    # -- definitions: link references and footnotes, collected before the blocks
    def _definitions(self, lines):
        out, i, fence = [], 0, None
        while i < len(lines):
            f = re.match(r'^\s*(```+|~~~+)', lines[i])
            if f and (fence is None or f.group(1).startswith(fence)):
                fence = None if fence else f.group(1)
            if fence or f:
                out.append(lines[i])
                i += 1
                continue
            m = re.match(r'^\[\^([^\]]+)\]:\s?(.*)$', lines[i])
            if m:
                body = [m.group(2)]
                i += 1
                while i < len(lines) and (lines[i].startswith('    ') or lines[i].startswith('\t')):
                    body.append(lines[i].strip())
                    i += 1
                self.footnotes[m.group(1)] = ' '.join(body)
                continue
            m = re.match(r'^\s{0,3}\[([^\]^][^\]]*)\]:\s+(\S+)(?:\s+"[^"]*")?\s*$', lines[i])
            if m:
                self.refdefs[m.group(1).lower()] = m.group(2)
                i += 1
                continue
            out.append(lines[i])
            i += 1
        return out

    def _id(self, ident):
        self.ids.add(ident)
        return ident

    def _heading(self, level, text):
        base = reading_catalogue.slug(text)
        n = self.slugs.get(base, 0)
        self.slugs[base] = n + 1
        ident = self._id(base if not n else f'{base}-{n}')
        if level == 1 and self.title is None:
            self.title = plain_title(text)
        if self.first_heading is None:
            self.first_heading = plain_title(text)
        self.toc.append((level, ident, plain_title(text)))
        return f'<h{level} id="{html.escape(ident)}">{self.inline(text)}<a class="here" href="#{html.escape(ident)}" aria-label="{self.say["here"]}">#</a></h{level}>'

    def _record_mark(self, ident):
        rid = ident[2:]
        rec = self.records.get(rid)
        if not rec:
            return ''
        self.marked.add(ident)
        status = rec.get('status', '')
        record = f'theories/becoming/results/records/{rid}.md'
        href = (relative(out_path(record), self.path) if record in self.links.pages
                else self.links.github(record))
        return (f'<a class="mark mark-{html.escape(status)}" href="{html.escape(href)}" '
                f'title="The result\'s record: {html.escape(navigation.STATUS_TEXT.get(status, status))}">'
                f'{html.escape(STATUS_MARK.get(status, status))}</a>')

    def _blocks(self, lines):
        out, para, i = [], [], 0

        def flush():
            nonlocal para
            if para:
                out.append(f'<p>{self.inline(join_lines(para))}</p>')
                para = []

        while i < len(lines):
            line = lines[i]
            stripped = line.strip()
            fence = re.match(r'^(\s*)(```+|~~~+)\s*([\w+-]*)', line)
            if fence:
                flush()
                mark, lang = fence.group(2), fence.group(3)
                i += 1
                code = []
                while i < len(lines) and not lines[i].strip().startswith(mark):
                    code.append(lines[i])
                    i += 1
                i += 1
                cls = f' class="language-{html.escape(lang)}"' if lang else ''
                out.append(f'<pre><code{cls}>' + html.escape('\n'.join(code)) + '</code></pre>')
                continue
            anchors = re.fullmatch(r'\s*((?:<a\s+(?:id|name)="[^"]+"\s*>\s*</a>\s*)+)', line)
            if anchors:
                flush()
                for ident in re.findall(r'<a\s+(?:id|name)="([^"]+)"', anchors.group(1)):
                    self._id(ident)
                    out.append(f'<a id="{html.escape(ident)}"></a>')
                    if ident.startswith('r-'):
                        self.anchors.add(ident)
                        mark = self._record_mark(ident)
                        if mark:
                            out.append(f'<div class="marks">{mark}</div>')
                i += 1
                continue
            h = re.match(r'^(#{1,6})\s+(.*?)(?:\s+#+)?\s*$', line)
            if h:
                flush()
                out.append(self._heading(len(h.group(1)), h.group(2)))
                i += 1
                continue
            if re.fullmatch(r'\s{0,3}([-*_])(\s*\1){2,}\s*', line):
                flush()
                out.append('<hr>')
                i += 1
                continue
            if stripped.startswith('>'):
                flush()
                quoted = []
                while i < len(lines) and lines[i].strip().startswith('>'):
                    quoted.append(re.sub(r'^\s*>\s?', '', lines[i]))
                    i += 1
                out.append('<blockquote>' + self._blocks(quoted) + '</blockquote>')
                continue
            if re.match(r'^\s*(?:[-*+]|1[.)])\s+', line) or (re.match(r'^\s*\d+[.)]\s+', line) and not para):
                flush()
                i = self._list(lines, i, out)
                continue
            if stripped.startswith('|') and i + 1 < len(lines) and re.fullmatch(r'\s*\|?\s*:?-{2,}:?\s*(\|\s*:?-{2,}:?\s*)*\|?\s*', lines[i + 1]):
                flush()
                i = self._table(lines, i, out)
                continue
            if BLOCK_HTML.match(line) and not para:
                flush()
                out.append(self.inline_html_block(line))
                i += 1
                continue
            if not stripped:
                flush()
                i += 1
                continue
            para.append(line)
            i += 1
        flush()
        return '\n'.join(out)

    def inline_html_block(self, line):
        """A line of raw HTML: its tags kept, any links in it rewritten, its text escaped."""
        return self.inline(line)

    def _list(self, lines, i, out):
        """A list and its nested lists, by indentation; an item's continuation lines join it, a blank line inside an
        item keeps the item open while the next line is indented."""
        m = re.match(r'^(\s*)([-*+]|\d+[.)])\s+', lines[i])
        base = len(m.group(1).expandtabs(4))
        ordered = m.group(2)[0].isdigit()
        start = int(re.match(r'\d+', m.group(2)).group(0)) if ordered else 1
        items, width = [], base + 2
        while i < len(lines):
            line = lines[i]
            m = re.match(r'^(\s*)([-*+]|\d+[.)])(\s+)(.*)$', line)
            if m and len(m.group(1).expandtabs(4)) == base:
                if m.group(2)[0].isdigit() != ordered:
                    break
                width = len(m.group(1)) + len(m.group(2)) + len(m.group(3))
                items.append([m.group(4)])
                i += 1
                continue
            if not line.strip():
                nxt = next((l for l in lines[i + 1:] if l.strip()), '')
                if nxt and len(nxt) - len(nxt.lstrip(' ')) > base:
                    items[-1].append('')
                    i += 1
                    continue
                break
            indent = len(line) - len(line.lstrip(' '))
            if indent > base and items:
                items[-1].append(line[min(indent, width):] if indent >= width else line.strip())
                i += 1
                continue
            if m and len(m.group(1).expandtabs(4)) < base:
                break
            if re.match(r'^\s{0,3}(#{1,6}(\s|$)|```[^`]*$|~~~|>)', line) or re.fullmatch(r'\s{0,3}([-*_])(\s*\1){2,}\s*', line):
                break  # a heading, fence, quote or rule ends the list, as on GitHub
            if items and not m:
                items[-1].append(line.strip())  # a lazy continuation line
                i += 1
                continue
            break
        tag = 'ol' if ordered else 'ul'
        attr = f' start="{start}"' if ordered and start != 1 else ''
        parts = []
        for item in items:
            first, rest = item[0], item[1:]
            if any(re.match(r'^\s*(?:[-*+]|\d+[.)])\s+', l) for l in rest) or '' in rest:
                head, body = [first], []
                k = 0
                while k < len(rest) and rest[k] and not re.match(r'^\s*(?:[-*+]|\d+[.)])\s+', rest[k]):
                    head.append(rest[k])
                    k += 1
                body = [l for l in rest[k:]]
                inner = self._blocks(body) if body else ''
                parts.append(f'<li>{self.inline(join_lines(head))}{inner}</li>')
            else:
                parts.append(f'<li>{self.inline(join_lines(item))}</li>')
        out.append(f'<{tag}{attr}>' + ''.join(parts) + f'</{tag}>')
        return i

    def _table(self, lines, i, out):
        head = split_row(lines[i])
        align = [('right' if c.strip().endswith(':') and not c.strip().startswith(':') else
                  'center' if c.strip().startswith(':') and c.strip().endswith(':') else '') for c in split_row(lines[i + 1])]
        i += 2
        rows = []
        while i < len(lines) and lines[i].strip().startswith('|'):
            rows.append(split_row(lines[i]))
            i += 1
        longest = max(sum(len(plain_title(c)) for c in r) for r in [head] + rows)
        wide = len(head) >= WIDE_COLUMNS or (len(head) >= 3 and longest >= WIDE_ROW)
        prose = max(sum(len(plain_title(c)) > 40 for c in r) for r in rows) if rows else 0
        stack = len(head) >= 3 and longest >= STACK_ROW and prose >= 2  # rows of prose stack; short numeric cells scroll
        labels = [plain_title(c) for c in head] if stack else []

        def cell(tag, c, k):
            a = align[k] if k < len(align) and align[k] else ''
            label = f' data-label="{html.escape(labels[k])}"' if tag == 'td' and k < len(labels) and labels[k] else ''
            return f'<{tag}{label}' + (f' style="text-align:{a}"' if a else '') + f'>{self.inline(c)}</{tag}>'
        kinds = 'table' + (' wide' if wide else '') + (' stack' if stack else '')
        t = f'<div class="{kinds}"><table><thead><tr>' + ''.join(cell('th', c, k) for k, c in enumerate(head)) + '</tr></thead><tbody>'
        for r in rows:
            r = (r + [''] * len(head))[:max(len(head), len(r))]
            t += '<tr>' + ''.join(cell('td', c, k) for k, c in enumerate(r)) + '</tr>'
        out.append(t + '</tbody></table></div>')
        return i

    def _footnote_list(self):
        if not self.footnotes:
            return ''
        items = []
        order = self.fn_order + [n for n in self.footnotes if n not in self.fn_order]
        for name in order:
            body = self.footnotes[name]
            ident = self._id(f'fn-{slug_id(name)}')
            items.append(f'<li id="{ident}">{self.inline(body)} <a class="back" href="#fnref-{slug_id(name)}" aria-label="{self.say["back"]}">↩</a></li>')
        return '\n<section class="footnotes"><ol>' + ''.join(items) + '</ol></section>'

    # -- inline
    def inline(self, text):
        keep = []

        def hold(s):
            keep.append(s)
            return f'\x00{len(keep) - 1}\x00'

        t = re.sub(r'(`+)(.+?)\1', lambda m: hold('<code>' + html.escape(m.group(2).strip()) + '</code>'), text)
        t = re.sub(r'\\([\\`*_{}\[\]()#+\-.!|<>~])', lambda m: hold(html.escape(m.group(1))), t)
        t = re.sub(r'<(https?://[^\s<>]+)>', lambda m: hold(self._a(m.group(1), html.escape(m.group(1)))), t)
        t = INLINE_HTML.sub(lambda m: hold(self._raw_tag(m.group(0))), t)
        t = re.sub(r'\[\^([^\]]+)\]', lambda m: hold(self._fnref(m.group(1))), t)
        # images, then links, innermost brackets first so that a link's text may hold code or brackets
        t = re.sub(r'!\[([^\]]*)\]\(\s*(<[^>]+>|[^)\s]+)(?:\s+"[^"]*")?\s*\)', lambda m: hold(self._img(m.group(2), m.group(1))), t)
        for _ in range(3):
            t = re.sub(r'\[((?:[^\[\]]|\x00\d+\x00)+)\]\(\s*(<[^>]+>|(?:[^()\s]|\([^()\s]*\))+)(?:\s+"[^"]*")?\s*\)',
                       lambda m: hold(self._a(m.group(2), self.inline_text(m.group(1), keep))), t)
            t = re.sub(r'\[((?:[^\[\]]|\x00\d+\x00)+)\]\[([^\]]*)\]',
                       lambda m: hold(self._ref(m.group(1), m.group(2), keep)), t)
        t = html.escape(t, quote=False)
        t = emphasis(t)
        t = re.sub(r'(?: {2,}|\\)\n', '<br>', t)
        for _ in range(4):
            if '\x00' not in t:
                break
            t = re.sub(r'\x00(\d+)\x00', lambda m: keep[int(m.group(1))], t)
        return RESULT_ANCHOR.sub(lambda m: m.group(0) + self._record_mark(m.group(1)), t)  # a result's anchor in a cell, list or line

    def inline_text(self, text, keep):
        """A link's text: escaped and emphasized, placeholders kept for the outer pass."""
        return emphasis(html.escape(text, quote=False))

    def _ref(self, text, ref, keep):
        key = (ref or re.sub(r'\x00\d+\x00', '', text)).lower()
        if key in self.refdefs:
            return self._a(self.refdefs[key], self.inline_text(text, keep))
        return '[' + self.inline_text(text, keep) + ']' + (f'[{html.escape(ref)}]' if ref else '[]')

    def _a(self, href, text_html):
        new = self.links.resolve(href, self.path)
        if new is None:
            return f'<span class="nolink" title="{self.say["nolink"]}">{text_html}</span>'
        ext = ' rel="noopener"' if new.startswith('http') else ''
        return f'<a href="{html.escape(new)}"{ext}>{text_html}</a>'

    def _img(self, src, alt):
        new = self.links.resolve(src, self.path)
        if new is None:
            return html.escape(alt)
        if new.startswith('https://github.com/'):
            new = new.replace('/blob/', '/raw/', 1)
        size = self.links.sizes.get(posixpath.normpath(posixpath.join(posixpath.dirname(self.path), src.split('#')[0])))
        box = f' width="{size[0]}" height="{size[1]}"' if size else ''  # the box is kept before the picture loads, so a lazy load starts
        img = f'<img src="{html.escape(new)}" alt="{html.escape(alt)}"{box} loading="lazy">'
        if src.split('#')[0].lower().endswith('.svg'):  # a picture opens at full size, and is shown wider than the text
            return f'<a class="picture" href="{html.escape(new)}" title="{self.say["picture"]}">{img}</a>'
        return img

    def _fnref(self, name):
        """A footnote reference, numbered by first reference as GitHub numbers it; a second reference gets an id of its own."""
        if name not in self.footnotes:
            return f'[^{html.escape(name)}]'
        if name not in self.fn_order:
            self.fn_order.append(name)
        k = self.fn_refs[name] = self.fn_refs.get(name, 0) + 1
        ident = self._id(f'fnref-{slug_id(name)}' + (f'-{k}' if k > 1 else ''))
        return f'<sup class="fnref"><a id="{ident}" href="#fn-{slug_id(name)}">{self.fn_order.index(name) + 1}</a></sup>'

    def _raw_tag(self, tag):
        """A raw tag of the allowed kinds, rebuilt from its parsed attributes: only SAFE_ATTRS are kept, an href or src is
        rewritten as a Markdown link's is (a scheme other than http, https or mailto dropped), an id recorded."""
        m = re.match(r'</\s*([a-zA-Z]+)', tag)
        if m:
            return f'</{m.group(1).lower()}>'
        parser = _TagParser()
        parser.feed(tag)
        parser.close()
        if not parser.tag:
            return html.escape(tag)
        name, attrs = parser.tag
        kept = []
        for key, value in attrs:
            key = key.lower()
            if key not in SAFE_ATTRS:
                continue
            value = value or ''
            if key in ('href', 'src'):
                new = self.links.resolve(value, self.path)
                if new is None:
                    continue
                if key == 'src' and new.startswith('https://github.com/'):
                    new = new.replace('/blob/', '/raw/', 1)
                value = new
            if key == 'id' or (key == 'name' and name == 'a'):
                self._id(value)
                if value.startswith('r-'):
                    self.anchors.add(value)
            kept.append(f' {key}="{html.escape(value)}"')
        return f'<{name}{"".join(kept)}>'


class _TagParser(__import__('html.parser').parser.HTMLParser):
    """Reads one start tag's name and attributes as a browser would."""

    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.tag = None

    def handle_starttag(self, tag, attrs):
        if self.tag is None:
            self.tag = (tag.lower(), attrs)

    handle_startendtag = handle_starttag


def emphasis(t):
    t = re.sub(r'\*\*\*(?!\s)(.+?)(?<!\s)\*\*\*', r'<strong><em>\1</em></strong>', t)
    t = re.sub(r'\*\*(?!\s)(.+?)(?<!\s)\*\*', r'<strong>\1</strong>', t)
    t = re.sub(r'(?<=[A-Za-z0-9])\*([A-Za-z0-9]{1,3})\*(?![*])', r'<em>\1</em>', t)  # inside a word, as GitHub has it: T*n*
    t = re.sub(r'(?<![A-Za-z0-9_*\\])\*(?![\s*])(.+?)(?<![\s\\])\*(?![A-Za-z0-9_*])', r'<em>\1</em>', t)
    t = re.sub(r'(?<![\w\\])__(?!\s)(.+?)(?<!\s)__(?!\w)', r'<strong>\1</strong>', t)
    t = re.sub(r'(?<![\w\\])_(?![\s_])(.+?)(?<![\s\\])_(?!\w)', r'<em>\1</em>', t)
    return re.sub(r'~~(?!\s)(.+?)(?<!\s)~~', r'<del>\1</del>', t)


def strip_comments(text):
    """HTML comments removed outside fenced code, as GitHub hides them; a fence closes on its own mark."""
    out, last = [], 0
    for m in re.finditer(r'^[ \t]*(`{3,}|~{3,})[^\n]*\n.*?^[ \t]*\1[ \t]*$', text, flags=re.S | re.M):
        out += [re.sub(r'<!--.*?-->', '', text[last:m.start()], flags=re.S), m.group(0)]
        last = m.end()
    return ''.join(out) + re.sub(r'<!--.*?-->', '', text[last:], flags=re.S)


def join_lines(lines):
    """A paragraph's lines joined as GitHub joins them: a break where a line ends in two spaces or a backslash."""
    out = ''
    for k, l in enumerate(lines):
        if k:
            prev = lines[k - 1]
            out += '\n' if (prev.endswith('  ') or prev.endswith('\\')) else ' '
        out += l.strip() if k == len(lines) - 1 or not (l.endswith('  ') or l.endswith('\\')) else l.lstrip()
    return out


def split_row(line):
    """A table row's cells: split on pipes outside code spans and not escaped."""
    s = line.strip()
    s = s[1:] if s.startswith('|') else s
    s = s[:-1] if s.endswith('|') and not s.endswith('\\|') else s
    cells, cur, code, k = [], '', 0, 0
    while k < len(s):
        c = s[k]
        if c == '\\' and k + 1 < len(s) and s[k + 1] == '|':
            cur += '|'  # GitHub undoes a table's escaped pipe inside a code span too
            k += 2
            continue
        if c == '`':
            n = len(s[k:]) - len(s[k:].lstrip('`'))
            code = 0 if code == n else (n if not code else code)
            cur += s[k:k + n]
            k += n
            continue
        if c == '|' and not code:
            cells.append(cur.strip())
            cur = ''
        else:
            cur += c
        k += 1
    cells.append(cur.strip())
    return cells


def strip_tags(s):
    return html.unescape(re.sub(r'<[^>]+>', '', s)).strip()


def plain_title(text):
    """A heading's text for <title>: links to their text, code and emphasis marks and footnote references dropped."""
    t = re.sub(r'\[\^[^\]]+\]', '', text)
    t = re.sub(r'!?\[([^\]]*)\]\([^)]*\)', r'\1', t)
    t = re.sub(r'(\*\*|\*|`)(.+?)\1', r'\2', re.sub(r'<[^>]+>', '', t))
    return html.unescape(re.sub(r'\\(.)', r'\1', t)).strip()


def slug_id(name):
    return re.sub(r'[^A-Za-z0-9_-]+', '-', name).strip('-') or 'note'


def cjk_share(text):
    letters = [c for c in text if c.isalpha()]
    return sum('一' <= c <= '鿿' for c in letters) / len(letters) if letters else 0


# ---------------------------------------------------------------------------------------------- the build

def site_config(config_path=CONFIG):
    cfg = json.loads(pathlib.Path(config_path).read_text()).get('site')
    if not isinstance(cfg, dict) or not isinstance(cfg.get('pages'), list):
        raise SiteError('_process/research-config.json has no site.pages list')
    return cfg


def records(root=ROOT):
    out = {}
    for p in (root / 'theories/becoming/results/records').glob('*.json'):
        try:
            d = json.loads(p.read_text())
        except ValueError:
            continue
        title = d.get('title') or {}
        out[d.get('id', p.stem)] = {'status': d.get('status', ''), 'title': title.get('en', ''), 'title_zh': title.get('zh', '')}
    return out


def section_text(text, anchor):
    """The part of a Markdown page a link's anchor names, read as the builder reads headings: outside fenced code and
    comments, repeated headings numbered as GitHub numbers them. A heading's part runs to the next heading of its level or
    higher; an `<a id>` line's, to the next heading."""
    lines = strip_comments(text).split('\n')
    heads, ids, fence = [], {}, None  # heads: (line, level, slug before numbering)
    for k, line in enumerate(lines):
        if fence:
            if line.strip().startswith(fence):
                fence = None
            continue
        f = re.match(r'^\s*(```+|~~~+)', line)
        if f:
            fence = f.group(1)
            continue
        h = re.match(r'^(#{1,6})\s+(.*?)(?:\s+#+)?\s*$', line)
        if h:
            heads.append((k, len(h.group(1)), reading_catalogue.slug(h.group(2))))
        for ident in re.findall(r'<a\s+(?:id|name)="([^"]+)"\s*>\s*</a>', line):
            ids.setdefault(ident, k)
    for (k, level, _), ident in zip(heads, reading_catalogue.numbered([h[2] for h in heads])):
        if ident == anchor:
            stop = next((j for j, lv, _ in heads if j > k and lv <= level), len(lines))
            return '\n'.join(lines[k:stop])
    if anchor in ids:
        k = ids[anchor]
        stop = next((j for j, _, _ in heads if j > k), len(lines))
        return '\n'.join(lines[k:stop])
    raise SiteError('site.ways_in names a section the page lacks: #' + anchor)


NAV_ITEM = r'(?:\[[^\]]+\]\([^)\s]+\)|\*\*[^*]+\*\*)'
NAV_LINE = re.compile(rf'^{NAV_ITEM}(?: · {NAV_ITEM})+\s*$')
RECORD_STATUS = re.compile(r'^(`[^`]+` · )\*\*([a-z-]+)\*\*( · )', re.M)


def strip_nav_line(text):
    """A page's text without the navigation line generated pages and navigation.NAV_FRONTS carry under their title (a line of links joined by ' · ',
    one of them to the home, or the home itself in bold on the page that is the home), the site having its own. Only one line
    near the top goes; any other line of links stays."""
    lines = text.split('\n')
    for k, line in enumerate(lines[:navigation.NAV_TOP]):
        if NAV_LINE.match(line) and re.search(r'\[(?:Home|首页)\]\(|\*\*(?:Home|首页)\*\*', line):
            return '\n'.join(lines[:k] + lines[k + 1:])
    return text


def compile_rewrites(cfg, pages):
    """`site.rewrites` as (the pages named or None, pattern, replacement, count). A rule with `page` (a path or a pattern in
    one folder) must match on every page it names, so that a rule whose words have gone fails the build; one without changes
    any page where it matches. A rule changes only the site's text: a frozen copy may bind the source."""
    rules = []
    for r in cfg.get('rewrites', []):
        try:
            pattern = re.compile(r['pattern'])
        except (KeyError, re.error) as e:
            raise SiteError(f'site.rewrites has a bad pattern: {r!r}: {e}')
        named = None
        if r.get('page'):
            named = set(expand_pages([r['page']], set(pages))) & set(pages)
            if not named:
                raise SiteError('site.rewrites names a page not on the site: ' + r['page'])
        rules.append((named, pattern, r.get('to', ''), int(r.get('count', 0))))
    return rules


def rewritten(path, text, rules):
    for named, pattern, to, count in rules:
        if named is None:
            text = pattern.sub(to, text, count=count)
        elif path in named:
            text, n = pattern.subn(to, text, count=count)
            if not n:
                raise SiteError(f'site.rewrites: a rule for {path} no longer matches: {pattern.pattern}')
    return text


def site_text(path, text, rules=()):
    """A page's Markdown as the site publishes it: rewritten as site.rewrites says, its navigation line (a generated page's, a NAV_FRONTS front's or a Chinese front's) dropped,
    and on a record page the status said in words."""
    text = strip_nav_line(rewritten(path, text, rules))
    if path.startswith(RECORDS):
        text = RECORD_STATUS.sub(lambda m: m.group(1) + '**' + navigation.STATUS_TEXT.get(m.group(2), m.group(2)) + '**' + m.group(3),
                                 text, count=1)
    return text


def first_screen(readme: str) -> str:
    """README's generated first screen: from its status line (README's title, generated comment and navigation line left
    out, since the site has its own) to the opening's heading."""
    lines = readme.split('\n')
    start = next(k for k, l in enumerate(lines) if l.startswith('> '))
    end = next(k for k, l in enumerate(lines) if k > start and l.startswith('## '))
    return '\n'.join(lines[start:end]).strip()


def svg_size(path):
    """An SVG's (width, height) in whole units from its root element's width and height, or else its viewBox; None where
    neither can be read."""
    try:
        head = path.read_text(errors='replace')[:2000]
    except OSError:
        return None
    root = re.search(r'<svg\b[^>]*>', head)
    if not root:
        return None
    tag = root.group(0)
    w, h = (re.search(rf'\s{k}="(\d+(?:\.\d+)?)(?:px)?"', tag) for k in ('width', 'height'))  # not stroke-width; no percentage
    size = (round(float(w.group(1))), round(float(h.group(1)))) if w and h else None
    if not (size and all(size)):  # a zero width or height falls back to the viewBox
        box = re.search(r'\sviewBox="\s*-?[\d.]+[\s,]+-?[\d.]+[\s,]+(\d+(?:\.\d+)?)[\s,]+(\d+(?:\.\d+)?)\s*"', tag)
        size = (round(float(box.group(1))), round(float(box.group(2)))) if box else None
    return size if size and all(size) else None


def root_prefix(page_path):
    """The relative way from a built page to the site's root: '' at the root, '../../' two folders down."""
    folder = posixpath.dirname(out_path(page_path))
    return '../' * (folder.count('/') + 1) if folder else ''


def on_github(commit, root=ROOT):
    """Whether GitHub can be expected to have `commit`, so that the site's links to files at it resolve: True in a GitHub
    Actions run of that very commit (the dispatched Pages build) or where origin/main, as this clone last fetched it, holds
    it; False where it does not; None where this clone cannot tell (no origin/main, or no repository)."""
    if os.environ.get('GITHUB_ACTIONS') == 'true' and os.environ.get('GITHUB_SHA') == commit:
        return True
    run = subprocess.run(['git', 'merge-base', '--is-ancestor', commit, 'refs/remotes/origin/main'], cwd=root, capture_output=True)
    return True if run.returncode == 0 else False if run.returncode == 1 else None


def pushed_note(pushed, zh=False):
    """What the footer adds where links to GitHub at the build commit may not resolve (on_github's answer): nothing where GitHub
    has the commit; in Chinese on a Chinese page."""
    if zh:
        if pushed is False:
            return '此提交不在本地克隆上次获取的仓库主分支（origin/main）上，所以在推送之前，指向 GitHub 上此提交的链接可能打不开。'
        if pushed is None:
            return '从本地克隆无法查明 GitHub 是否已有此提交，所以指向它的链接可能打不开。'
        return ''
    if pushed is False:
        return (' This commit is not on the repository\'s main branch as this clone last fetched it (origin/main), so a link to '
                'GitHub at this commit may not resolve until it is pushed.')
    if pushed is None:
        return ' Whether GitHub has this commit could not be checked from this clone, so a link to GitHub at it may not resolve.'
    return ''


def template(page_path, title, body, lang, cfg, commit, date, nav_html, source_href, home=False, dirty=False, base=None, pushed=True):
    root = root_prefix(page_path)
    zh = lang == 'zh'
    say = SAY_ZH if zh else SAY_EN
    css, home_href = root + 'assets/site.css', root + 'index.html'
    short = commit[:9]
    name = cfg.get('title', 'The Theory of Becoming')
    description = cfg.get('description', '')
    if zh:  # a page in Chinese names the work, describes it and goes home in Chinese, where the site has those
        name, description = cfg.get('title_zh') or name, cfg.get('description_zh') or description
        if 'README.zh.md' in cfg.get('pages', []):
            home_href = root + out_path('README.zh.md')
    head_title = name if home or title == name else f'{title} · {name}'  # a page named as the site is, the name once
    changed = ', with local paths and words true only off the site changed at build' if cfg.get('rewrites') else ''
    tree, repo = f"https://github.com/{cfg['repository']}/tree/{commit}", f"https://github.com/{cfg['repository']}"
    if zh:  # a Chinese page's footer says the same in Chinese
        footer = (f'本站由<a href="{repo}">本仓库</a>的提交 <a href="{tree}"><code>{short}</code></a> '
                  f'{"及其上尚未提交的改动" if dirty else ""}构建（{date}）。每一页都由仓库中的文本转换而来'
                  f'{"，只在站外才成立的本地路径与词句在构建时已改" if cfg.get("rewrites") else ""}；离开本站的链接，指向所链的文件在此提交时的样子。'
                  f'{pushed_note(pushed, zh=True)}'
                  f'{f"""<a href="{html.escape(source_href)}">本页的源文件</a>。""" if source_href else ""}')
    else:
        footer = (f"Built from {'uncommitted edits on top of ' if dirty else ''}commit <a href=\"{tree}\"><code>{short}</code></a> of "
                  f"<a href=\"{repo}\">the repository</a> ({date}). Every page is converted from the repository's text{changed}; a link "
                  f"that leaves the site goes to the file as it stood at that commit.{pushed_note(pushed)}"
                  + (f' <a href="{html.escape(source_href)}">This page' + "'" + 's source</a>.' if source_href else ''))
    return f'''<!doctype html>
<html lang="{'zh-Hans' if zh else 'en'}">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{html.escape(head_title)}</title>
<meta name="description" content="{html.escape(description)}">
{f'<base href="{html.escape(base)}">' + chr(10) if base else ''}<link rel="stylesheet" href="{css}">
<link rel="icon" href="{root}assets/favicon.svg" type="image/svg+xml">
<script src="{root}assets/search.js" data-root="{root}" defer></script>
</head>
<body class="{'home' if home else 'page'} lang-{lang}">
<header class="top"><a class="brand" href="{home_href}">{html.escape(name)}</a>{nav_html}<button class="find" type="button" hidden>{say['search']}</button></header>
<main>
{body}
</main>
<footer><p>{footer}</p></footer>
</body>
</html>
'''


MAP_PAGE = 'connections.html'  # the connection map; not map.html, which a case-blind disk would confuse with MAP.html
SPECIAL = ('index.html', MAP_PAGE)  # the home, and the connection map


def edition(page_path, pages):
    """A page's other-language edition on the site, if it has one: X.md and X.zh.md."""
    if page_path.endswith('.zh.md'):
        other = page_path[:-len('.zh.md')] + '.md'
    elif page_path.endswith('.md'):
        other = page_path[:-3] + '.zh.md'
    else:
        return None
    if other == 'README.md':  # README's English edition is the site's home
        return 'index.html'
    return other if other in pages else None


LANGUAGE_LINKS = {'中文': 'zh-Hans', 'English': 'en'}  # a navigation entry of this label goes to the other language


def nav(cfg, page_path, pages, lang='en'):
    """The site's navigation line: on a page in Chinese its Chinese line, and the language link goes to this page's own
    other edition where it has one. The language link stands after the line, outside it, so that it shows at every width
    (between a phone's width and a wide screen the line scrolls sideways and fades at its end)."""
    items, language = [], []
    zh = lang == 'zh' or page_path.endswith('.zh.md')
    other = edition(page_path, pages)
    for target, label in cfg.get('nav_zh' if zh and cfg.get('nav_zh') else 'nav', []):
        if label in LANGUAGE_LINKS and other:
            target = other
        if target not in pages and target not in SPECIAL:
            raise SiteError('site.nav names a page not in site.pages: ' + target)
        built = target if target in SPECIAL else out_path(target)
        here = built == (page_path if page_path in SPECIAL else out_path(page_path))
        href = relative(built, page_path) if page_path not in SPECIAL else built
        current = ' aria-current="page"' if here else ''
        if label in LANGUAGE_LINKS:
            other_lang = LANGUAGE_LINKS[label]
            language.append(f'<a class="lang" href="{href}" hreflang="{other_lang}" lang="{other_lang}"{current}>{html.escape(label)}</a>')
        else:
            items.append(f'<a href="{href}"{current}>{html.escape(label)}</a>')
    return f'<nav aria-label="{(SAY_ZH if zh else SAY_EN)["pages"]}">' + ''.join(items) + '</nav>' + ''.join(language)


def hours(time):
    """A reading time too long to count in minutes, in hours: '1533–1992 minutes' as 'about 26–33 hours'."""
    hi, lo = navigation.span(time)
    if hi < 180:
        return time
    a, b = int(lo / 60 + 0.5), int(hi / 60 + 0.5)  # halves up, as navigation.reading_time rounds
    return f'about {a} hours' if a == b else f'about {a}–{b} hours'


def card_time(w, root, files):
    """What a card says of the time it takes. By default the reading time of the part the card sends a reader to: `time_until`
    a named line, or the section its anchor names, or the page. `time`, where a card has it, says what the time is of, with
    fields that are computed, so that it cannot go stale: {time} the part just named, {whole} the card's whole page, {body} the
    page without its footnotes or the marks that call them, the text README's first screen times as {{time:opening}},
    {all:PATTERN} every file a pattern in one folder matches, together, in hours where they are that long, and {said:REGEX}
    the first group of what the page itself states, where it times a part that is not a run of its text."""
    target = w['path'].split('#')[0]
    p = root / target
    if not (p.is_file() and target.endswith('.md')):
        return w.get('time', '')
    whole = strip_comments(p.read_text())  # counted as every stated time and README's time fields count it, its navigation line in
    text = whole
    if w.get('time_until'):  # the part a reader is sent to: up to the named heading line
        assert w['time_until'] in text, ('site.ways_in times up to a heading the page lacks', target, w['time_until'])
        text = text.split(w['time_until'], 1)[0]
    elif '#' in w['path']:  # a card to one section: that section, to the next heading of its level or higher
        text = section_text(text, w['path'].split('#', 1)[1])
    part = navigation.reading_time(text)
    if not w.get('time'):
        return part + (f", {w['time_note']}" if w.get('time_note') else '')

    def field(m):
        if m.group(1) == 'time':
            return part
        if m.group(1) == 'whole':
            return navigation.reading_time(whole)
        if m.group(1) == 'body':
            return navigation.reading_time(navigation.endnotes(whole).partition('\n### Notes\n')[0])
        if m.group(1).startswith('said:'):
            said = re.search(m.group(1)[len('said:'):], whole)
            if not said:
                raise SiteError(f'site.ways_in quotes a time {target} no longer states: ' + m.group(1))
            return said.group(1)
        matched = expand_pages([m.group(1)[len('all:'):]], files)
        if not matched:
            raise SiteError('site.ways_in times a pattern that matches nothing: ' + m.group(1))
        return hours(navigation.reading_time('\n'.join(strip_comments((root / f).read_text()) for f in matched)))
    return re.sub(r'\{(time|whole|body|all:[^}]+|said:[^}]+)\}', field, w['time'])


def arrange_first_screen(blocks):
    """The first screen's blocks of HTML as (its text, ending in its "Start with" paragraph, and its pictures with their
    captions). Nothing is cut or reworded; the rule closing README's first screen is the one block the site does not need."""
    text, pictures, start, k = [], [], [], 0
    while k < len(blocks):
        block = blocks[k]
        k += 1
        if block.startswith('<p><a class="picture"'):
            pictures.append(block)
            if k < len(blocks) and blocks[k].startswith('<p><em>'):
                pictures.append(blocks[k])
                k += 1
        elif not start and 'Start with' in strip_tags(block):
            start.append(block)
        elif block != '<hr>':
            text.append(block)
    return text + start, pictures


def home_body(cfg, links, recs, root, files, rules=()):
    screen = first_screen(rewritten('README.md', (root / 'README.md').read_text(), rules))
    page = Page('README.md', screen, links, recs)
    text, pictures = arrange_first_screen(page.html.split('\n'))
    parts = [f'<section class="hero"><h1>{html.escape(cfg.get("title", "The Theory of Becoming"))}</h1>' + '\n'.join(text) + '</section>']
    cards = []
    for w in cfg.get('ways_in', []):
        target = w['path']
        time = card_time(w, root, files)
        href = target if target in SPECIAL else links.resolve(target, 'README.md')
        if href is None:
            raise SiteError('site.ways_in names a path not in the repository: ' + target)
        zh = ''
        if w.get('zh'):
            zh_href = links.resolve(w['zh'], 'README.md')
            zh = f' <a class="zh" href="{html.escape(zh_href)}" lang="zh-Hans">中文</a>' if zh_href else ''
        cards.append(f'<li><a class="card" href="{html.escape(href)}"><span class="label">{html.escape(w["label"])}</span>'
                     + (f'<span class="time">{html.escape(time)}</span>' if time else '')
                     + f'<span class="text">{Page("README.md", w["text"], links, recs).html[3:-4]}</span></a>{zh}</li>')
    grouped, order = {}, []
    for w, c in zip(cfg.get('ways_in', []), cards):
        g = w.get('group', '')
        if g not in grouped:
            grouped[g] = []
            order.append(g)
        grouped[g].append(c)
    body = ''.join((f'<h3 class="group">{html.escape(g)}</h3>' if g else '') + '<ul class="cards">' + ''.join(grouped[g]) + '</ul>'
                   for g in order)
    if pictures:  # the picture right after the first screen's words, above the cards, where a reader still is
        parts.append('<section class="picture">' + '\n'.join(pictures) + '</section>')
    parts.append('<section class="ways"><h2 id="ways-in">Ways in</h2>' + body + '</section>')
    return '\n'.join(parts), page.lang


def contents_block(page):
    """A page's contents from its h2 and h3 headings, an h3 under the h2 before it; on a phone only the h2s show."""
    groups = []
    for level, ident, text in page.toc:
        if level == 2 or (level == 3 and not groups):
            groups.append(((ident, text), []))
        elif level == 3:
            groups[-1][1].append((ident, text))
    if not groups:
        return ''

    def link(ident, text):
        return f'<a href="#{html.escape(ident)}">{html.escape(text)}</a>'
    items = ''.join('<li>' + link(*head) + ('<ul>' + ''.join('<li>' + link(*h) + '</li>' for h in subs) + '</ul>' if subs else '') + '</li>'
                    for head, subs in groups)
    return f'<nav class="contents" aria-label="{page.say["contents"]}"><p>{page.say["contents"]}</p><ul>{items}</ul></nav>'


def sequence_links(p, page, sequence, index, built):
    """The line of previous, all and next that a page of a sequence carries at its top and foot; a neighbour in the other
    language is said to be, in the language of the page."""
    k, zh = sequence.index(p), page.lang == 'zh'

    def link(target, cls, words):
        return f'<a class="{cls}" href="{html.escape(relative(out_path(target), p))}">{html.escape(words)}</a>'

    def named(target):
        other = built[target].lang != page.lang
        return (built[target].title or '') + (('（英文）' if zh else ' (in Chinese)') if other else '')
    parts = []
    if k:
        parts.append(link(sequence[k - 1], 'prev', ('← 上一章：' if zh else '← Previous: ') + named(sequence[k - 1])))
    if index:
        parts.append(link(index, 'all', '全部八章（英文）' if zh else 'All chapters'))
    if k + 1 < len(sequence):
        parts.append(link(sequence[k + 1], 'next', ('下一章：' if zh else 'Next: ') + named(sequence[k + 1]) + ' →'))
    return f'<nav class="seq" aria-label="{page.say["chapters"]}">{"".join(parts)}</nav>'


def chapter_html(p, page, sequence, index, built):
    """A chapter's body: the line of neighbours above its title and at its foot, its contents right under the title."""
    line, body = sequence_links(p, page, sequence, index, built), page.html
    if '</h1>' in body:
        head, rest = body.split('</h1>', 1)
        body = head + '</h1>\n' + contents_block(page) + rest
    else:
        body = contents_block(page) + '\n' + body
    return line + '\n' + body + '\n' + line


LEAD_MAX = 360  # characters of a page's lead that the search reads
LEAD_LOOK = 8  # the paragraphs that may be a page's lead: its first eight that pass lead_paragraphs
LEAD_SHARED = 3  # a paragraph met word for word among the leading paragraphs of more pages than this is no page's lead
STATUS_LINE = re.compile(r'<code>[^<]+</code> · <strong>')  # a record page's status line, as site_text leaves it (RECORD_STATUS)
LANGUAGE_LINK = re.compile(r'<a [^>]*>\s*(?:中文|English)[^<]{0,24}</a>\s*(?: · |$)')  # '中文', '中文（各章一览）', 'English'
READING_LINE = 200  # characters below which a paragraph that states a time to read is a reading-time line (a third of it in Chinese)
CLOSE = '["”’\')\\]]*'  # closing marks a sentence's period may sit inside
SENTENCE = (r'(?:[^.]|\.(?!' + CLOSE + r'(?:\s|$))'  # a sentence's body: a period ends it only before a space or the end, closing
            r'|\.(?=' + CLOSE[:-1] + r'+\s+[a-z])'  # marks allowed; not where a lowercase word follows a closing mark,
            r'|(?:(?<= al)|(?<=\b(?:Jan|Feb|Mar|Apr|Jun|Jul|Aug|Sep|Oct|Nov|Dec))|(?<=Sept))\.(?=\s+[a-z0-9(])'  # nor after 'et al'
            r'|(?:(?<=e\.g)|(?<=i\.e)|(?<=\bcf))\.(?=\s))*')  # or a month's abbreviation before a word or number, nor after e.g., i.e., cf.
PROVENANCE = re.compile(  # a run of opening sentences that say where a page came from, not what it says, as experiments open:
    # 'Board item EW2, 21 October 2026. AI-written (a Claude Code session). Study section 286 of …. Literature check: ….'
    r'(?:(?:Board items? [A-Z]' + SENTENCE +
    r'|AI-(?:written|authored)(?=\s*[(,.;]| study\b| by\b| from\b| in\b| on\b)' + SENTENCE +
    r'|AI-assisted [a-z]+(?: [a-z]+)?, \d{1,2} [A-Z][a-z]+ \d{4}' +
    r'|Study sections? \d' + SENTENCE +
    r'|Literature(?: and data)? check: ' + SENTENCE +
    r'|Prior art: ' + SENTENCE +
    r'|Predictions(?:,[^:.]*)? frozen before [^:.]*: \S+' +
    r'|(?:[A-Z][A-Z0-9]{0,5}[a-z]?, )?\d{1,2}(?:–\d{1,2})? [A-Z][a-z]+ \d{4}(?:; run \d{1,2} [A-Z][a-z]+ \d{4})?' +
    r'|About ' + SENTENCE + r'\b(?:minutes?|hours?|an hour) to read\b' + SENTENCE +
    r')\.' + CLOSE + r'(?:\s+|$))+')
READING_TIME = re.compile(r'\b(?:minutes?|hours?|an hour) to read\b|\d+(?:–\d+)? ?分钟|[一二三四五六七八九十两半]+(?:分钟|小时)')


def lead_paragraphs(body_html):
    """The paragraphs of a page's text that could be its lead, in order, as text: passing over a record's status line (its id
    in code, then its status in bold), a paragraph that starts with a language link ('中文 · …'), a line under READING_LINE
    characters (a third of that in Chinese) that states a time to read (a reading-time line, alone or after a label of
    provenance), a line of items
    joined by ' · ' (a navigation line), a paragraph wholly in italics (a reading time, a label of provenance) and a line too
    short to say anything; and a paragraph's opening sentences of provenance (PROVENANCE: a board item, a date alone or after
    an item's name, an AI-written or AI-authored label, an AI-assisted kind with its date, a study section, a literature check,
    prior art, predictions frozen before a named file, a time to read) are passed over, the paragraph too where too little is
    left; other openings ('Opened …', 'Index rewritten …') are not."""
    for m in re.finditer(r'<p>(.*?)</p>', body_html, re.S):
        inner = m.group(1).strip()
        text = ' '.join(strip_tags(inner).split())
        if len(text) < 40:
            continue
        if inner.startswith('<em>') and inner.endswith('</em>') and inner.count('<em>') == 1:
            continue
        if STATUS_LINE.match(inner) or LANGUAGE_LINK.match(inner):
            continue
        if len(text) < (READING_LINE // 3 if cjk_share(text) > 0.5 else READING_LINE) and READING_TIME.search(text):
            continue
        if text.count(' · ') >= 2 and all(len(part) < 60 for part in text.split(' · ')):
            continue
        head = PROVENANCE.match(text)
        if head:
            text = text[head.end():].strip()
            if len(text) < 40:
                continue
        yield text


def lead(body_html, shared=frozenset()):
    """A page's lead, for the search: the first of its first LEAD_LOOK lead_paragraphs (a record's, its statement) that is not
    in `shared` (search_index's paragraphs met on more than LEAD_SHARED pages), cut at a word near LEAD_MAX characters; ''
    where none is left."""
    for text in islice(lead_paragraphs(body_html), LEAD_LOOK):
        if text in shared:
            continue
        if len(text) <= LEAD_MAX:
            return text
        cut = text[:LEAD_MAX]
        return (cut.rsplit(' ', 1)[0] if ' ' in cut[LEAD_MAX // 2:] else cut) + '…'
    return ''


def shared_paragraphs(bodies):
    """The paragraphs met word for word among the first LEAD_LOOK lead_paragraphs of more than LEAD_SHARED of `bodies`
    (a generated page's opening that all its kind repeat), which are no page's lead."""
    seen = Counter(text for body in bodies for text in set(islice(lead_paragraphs(body), LEAD_LOOK)))
    return frozenset(text for text, pages in seen.items() if pages > LEAD_SHARED)


def search_index(built, recs, home=None):
    """What the site's search reads: each page's title, headings and lead, each result's name and its record's lead (a record
    page, its status said, its id and Chinese title findable too), and `home`, the home's entry, first. A page kept only so
    that a former id's links resolve is marked (`f`), for the search to rank it below every current name, and its lead is not
    read. A paragraph that more than LEAD_SHARED pages open with alike (shared_paragraphs) is no page's lead. Only pages built
    go in; a record's Chinese title, from its public JSON, is findable even where its page does not show it."""
    shared = shared_paragraphs([page.html for page in built.values()])

    def with_lead(entry, body):
        said = lead(body, shared)
        return dict(entry, l=said) if said else entry
    pages, results = ([home] if home else []), []
    for p, page in built.items():
        rid = posixpath.basename(p)[:-3] if p.startswith(RECORDS) else None
        if rid in recs:
            rec = recs[rid]
            results.append(with_lead({'t': rec['title'] or page.title or rid, 'z': rec['title_zh'], 'u': out_path(p), 'a': rid,
                                      's': navigation.STATUS_TEXT.get(rec['status'], rec['status'])}, page.html))
        elif rid and (page.title or '').endswith('(renamed)'):  # the page a former id keeps (registry.py), naming the id it became
            pages.append({'t': page.title or rid, 'u': out_path(p), 'h': [], 'f': 1})
        else:
            pages.append(with_lead({'t': page.title or posixpath.basename(p), 'u': out_path(p),
                                    'h': [[text, ident] for level, ident, text in page.toc if level > 1]}, page.html))
    return {'pages': pages, 'results': results}


SEARCH_JS = r"""/* The site's search over titles, headings, leads and result names, from search.json. Text goes in as text, never as markup.
   A name or heading that holds every word ranks above a lead that does, and a former id's page below all of them. */
(function () {
  var root = document.currentScript.getAttribute('data-root') || '';
  var button = document.querySelector('button.find');
  if (!button || !window.fetch) { return; }
  var zh = document.documentElement.lang.indexOf('zh') === 0;
  var say = zh ? {label: '搜索', hint: '标题、小节、开头与成果名', none: '没有找到。', fail: '搜索要在网站上才能用，直接打开文件时用不了。', more: '只显示前 40 条。', result: '成果', renamed: '旧编号，已改名'}
               : {label: 'Search', hint: 'Titles, sections, leads and result names', none: 'Nothing found.', fail: 'Search works on the site, not on files opened directly.', more: 'Showing the first 40.', result: 'Result', renamed: 'A former id, renamed'};
  var LIMIT = 40, panel, input, list, note, entries;
  button.hidden = false;
  button.setAttribute('aria-expanded', 'false');

  function flatten(data) {
    var out = [];
    data.pages.forEach(function (p) {
      out.push({text: p.t, under: p.f ? say.renamed : '', href: p.u, key: p.t.toLowerCase(), lead: p.l || '', rank: p.f ? 0 : 3});
      p.h.forEach(function (h) { out.push({text: h[0], under: p.t, href: p.u + '#' + h[1], key: h[0].toLowerCase(), lead: '', rank: 2}); });
    });
    data.results.forEach(function (r) {
      out.push({text: zh && r.z ? r.z : r.t, under: say.result + ' · ' + r.s, href: r.u, key: (r.t + ' ' + r.z + ' ' + r.a).toLowerCase(), lead: r.l || '', rank: 3});
    });
    out.forEach(function (e) { e.low = e.lead.toLowerCase(); });
    return out;
  }
  function snippet(e, word) {
    var at = Math.max(0, e.low.indexOf(word)), from = Math.max(0, at - 40), to = Math.min(e.lead.length, at + word.length + 60);
    return (from ? '…' : '') + e.lead.slice(from, to) + (to < e.lead.length ? '…' : '');
  }
  function load() {
    if (entries) { return Promise.resolve(); }
    return fetch(root + 'search.json').then(function (r) {
      if (!r.ok) { throw new Error(String(r.status)); }
      return r.json();
    }).then(function (data) { entries = flatten(data); });
  }
  function find(query) {
    var words = query.toLowerCase().split(/\s+/).filter(Boolean), hits = [];
    if (!words.length || !entries) { return hits; }
    entries.forEach(function (e) {
      if (words.every(function (w) { return e.key.indexOf(w) >= 0; })) {
        hits.push({e: e, under: e.under, score: e.rank * 2 + (e.key.indexOf(words[0]) === 0 ? 1 : 0)});
      } else if (e.low && words.every(function (w) { return e.key.indexOf(w) >= 0 || e.low.indexOf(w) >= 0; })) {
        var only = words.filter(function (w) { return e.key.indexOf(w) < 0; })[0];  // a word that only the lead holds
        hits.push({e: e, under: (e.under ? e.under + ' · ' : '') + snippet(e, only), score: 2});
      }
    });
    return hits.sort(function (a, b) { return b.score - a.score || a.e.text.length - b.e.text.length; });
  }
  function show() {
    var hits = find(input.value);
    list.textContent = '';
    hits.slice(0, LIMIT).forEach(function (h) {
      var li = document.createElement('li'), a = document.createElement('a');
      a.href = root + h.e.href;
      a.textContent = h.e.text;
      if (h.under) {
        var under = document.createElement('small');
        under.textContent = h.under;
        a.appendChild(under);
      }
      li.appendChild(a);
      list.appendChild(li);
    });
    note.textContent = input.value.trim() && !hits.length ? say.none : hits.length > LIMIT ? say.more : '';
  }
  function make() {
    panel = document.createElement('div');
    panel.className = 'find-panel';
    panel.setAttribute('role', 'search');
    input = document.createElement('input');
    input.type = 'search';
    input.placeholder = say.hint;
    input.setAttribute('aria-label', say.label);
    list = document.createElement('ul');
    note = document.createElement('p');
    note.setAttribute('role', 'status');
    panel.appendChild(input);
    panel.appendChild(note);
    panel.appendChild(list);
    document.body.appendChild(panel);
    input.addEventListener('input', show);
    // A hit on the page being read only moves the hash, and the panel would cover what was asked for. A click that opens a
    // new tab leaves the reader here, with the list.
    list.addEventListener('click', function (ev) {
      if (ev.target.closest('a') && !ev.metaKey && !ev.ctrlKey && !ev.shiftKey) { hide(); }
    });
  }
  function open() {
    if (!panel) { make(); }
    panel.hidden = false;
    button.setAttribute('aria-expanded', 'true');
    input.focus();
    load().then(show).catch(function () { note.textContent = say.fail; });
  }
  function hide() {
    panel.hidden = true;
    button.setAttribute('aria-expanded', 'false');
  }
  function close() {
    hide();
    button.focus();
  }
  function isOpen() { return panel && !panel.hidden; }
  button.addEventListener('click', function () { if (isOpen()) { close(); } else { open(); } });
  document.addEventListener('keydown', function (ev) {
    if (ev.key === 'Escape' && isOpen()) { close(); }
    else if (ev.key === '/' && !ev.metaKey && !ev.ctrlKey && !ev.altKey && !/^(INPUT|TEXTAREA|SELECT)$/.test(ev.target.tagName)) { ev.preventDefault(); open(); }
  });
  document.addEventListener('click', function (ev) { if (isOpen() && !panel.contains(ev.target) && ev.target !== button) { close(); } });
})();
"""


def site_root(cfg):
    """The path the site is served under, for the one page that cannot be reached by a relative link: `site.site_root`, or
    GitHub's project site /<repo>/ (a <user>.github.io repository is served at /)."""
    if cfg.get('site_root'):
        return cfg['site_root'].rstrip('/') + '/'
    repo = cfg['repository'].split('/')[-1]
    return '/' if repo.endswith('.github.io') else f'/{repo}/'


def not_found_body(cfg, pages):
    """The 404 page's text. GitHub serves it at whatever depth the address had, so its links are read from the site's root."""
    zh = f' <a href="{html.escape(out_path("README.zh.md"))}" lang="zh-Hans">中文首页</a>' if 'README.zh.md' in pages else ''
    where = f' <a href="{html.escape(out_path("MAP.md"))}">Where everything is</a> lists the rest.' if 'MAP.md' in pages else ''
    return ('<h1>This page is not on the site</h1>\n<p>The address may be old or mistyped, or the file may be in the repository only. '
            f'<a href="index.html">The home</a> has the ways in.{where}{zh}</p>')


def expand_pages(entries, files):
    """The allow-list as pages: an entry with * names every tracked file it matches within one folder, still an allow-list."""
    pages = []
    for entry in entries:
        if '*' in entry:
            pattern = re.compile(re.escape(entry).replace(r'\*', '[^/]*'))
            pages += sorted(f for f in files if pattern.fullmatch(f))
        else:
            pages.append(entry)
    return list(dict.fromkeys(pages))


def build(out: pathlib.Path, commit: str, root: pathlib.Path = ROOT, config_path=CONFIG, files=None):
    cfg = site_config(config_path)
    private = private_pattern(root / 'tools/research/push_screen.sh')
    secrets = secret_pattern(root / 'tools/research/push_screen.sh')
    files = tracked_files(root) if files is None else files
    dirs = tracked_dirs(files)
    pages = expand_pages(cfg['pages'], files)
    if not pages:
        raise SiteError('site.pages names no page')
    assets = set(cfg.get('assets', []))
    for p in pages + sorted(assets):
        if refused(p, private):
            raise SiteError('site.pages names a path the push screen keeps private, or a source copy: ' + p)
        if p not in files:
            raise SiteError('site.pages names a file the repository does not track: ' + p)
    for p in pages:
        if not p.endswith('.md'):
            raise SiteError('site.pages lists Markdown pages only: ' + p)
    from tools.research import connection_map
    map_ok = bool(cfg.get('map'))
    def unbuilt(target):
        return not map_ok and (target or '').split('#')[0] == MAP_PAGE
    aliases = {k: v for k, v in (cfg.get('aliases') or {}).items() if not unbuilt(v)}  # no link to an unbuilt map
    links = Links(set(pages), assets, files, dirs, cfg['repository'], commit, aliases)
    links.sizes = {a: svg_size(root / a) for a in assets if a.lower().endswith('.svg')}
    links.private = private
    links.unbuilt = set() if map_ok else {MAP_PAGE}
    if map_ok and not hasattr(connection_map, 'site_map'):
        raise SiteError('site.map is on, and this checkout\'s connection_map has no site mode (site_map)')
    if not map_ok:  # no link to a map this build does not write
        cfg = dict(cfg, nav=[n for n in cfg.get('nav', []) if not unbuilt(n[0])],
                   nav_zh=[n for n in cfg.get('nav_zh', []) if not unbuilt(n[0])],
                   ways_in=[dict(w, **({'zh': None} if unbuilt(w.get('zh')) else {}))
                            for w in cfg.get('ways_in', []) if not unbuilt(w['path'])])
    recs = records(root)
    rules = compile_rewrites(cfg, pages)
    chapters = cfg.get('chapters') or {}
    sequence = expand_pages([chapters['pages']], set(pages)) if chapters.get('pages') else []
    if chapters.get('index') and chapters['index'] not in pages:
        raise SiteError('site.chapters names an index not in site.pages: ' + chapters['index'])
    date = subprocess.run(['git', 'show', '-s', '--format=%cs', commit], cwd=root, capture_output=True, text=True).stdout.strip() or commit
    if out.exists():
        shutil.rmtree(out)
    (out / 'assets').mkdir(parents=True)
    shutil.copyfile(pathlib.Path(__file__).with_name('site.css'), out / 'assets' / 'site.css')
    (out / 'assets' / 'site.css').chmod(0o644)
    built = {}
    for p in pages:
        page = Page(p, site_text(p, (root / p).read_text(), rules), links, recs)
        built[p] = page
    for p in sequence:
        built[p].html = chapter_html(p, built[p], sequence, chapters.get('index'), built)
    home, home_lang = home_body(cfg, links, recs, root, files, rules)
    # every link between pages of the site resolves, its anchor included
    broken = []
    home_ids = set(re.findall(r'\bid="([^"]+)"', home))
    for src, target, anchor in links.internal:
        ids = built[target].ids if target in built else home_ids
        if anchor and anchor not in ids:
            broken.append(f'{src} → {target}#{anchor}')
    if broken:
        raise SiteError('links between pages of the site that do not resolve:\n  ' + '\n  '.join(sorted(set(broken))))
    status = subprocess.run(['git', 'status', '--porcelain', '--'] + pages + sorted(assets) + [
        'README.md', str(pathlib.Path(config_path).resolve()), 'theories/becoming/results/records', 'tools/publishing',
        'tools/research/push_screen.sh', 'tools/research/reading_catalogue.py', 'tools/research/navigation.py'],
                            cwd=root, capture_output=True, text=True)
    dirty = status.returncode == 0 and bool(status.stdout.strip())
    pushed = on_github(commit, root)
    written = []
    for p, page in built.items():
        dest = out / out_path(p)
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.write_text(template(p, page.title or posixpath.basename(p), page.html, page.lang, cfg, commit, date,
                                 nav(cfg, p, set(pages), page.lang), links.github(p), dirty=dirty, pushed=pushed))
        written.append(dest)
    (out / 'index.html').write_text(template('index.html', cfg.get('title', ''), home, home_lang, cfg, commit, date,
                                             nav(cfg, 'index.html', set(pages)), links.github('README.md'), home=True, dirty=dirty,
                                             pushed=pushed))
    written.append(out / 'index.html')
    (out / '404.html').write_text(template('index.html', 'Page not found', not_found_body(cfg, set(pages)), 'en', cfg, commit, date,
                                           nav(cfg, 'index.html', set(pages)).replace(' aria-current="page"', ''), None, dirty=dirty,
                                           base=site_root(cfg), pushed=pushed))
    written.append(out / '404.html')
    home_lead = lead(home)
    home_entry = dict({'t': cfg.get('title', ''), 'u': 'index.html', 'h': [['Ways in', 'ways-in']]}, **({'l': home_lead} if home_lead else {}))
    # the search's data and script, and the favicon: written here so that the scans below read them with the rest
    for name, content in (('search.json', json.dumps(search_index(built, recs, home_entry), ensure_ascii=False, separators=(',', ':'))),
                          ('assets/search.js', SEARCH_JS), ('assets/favicon.svg', FAVICON)):
        (out / name).write_text(content)
        (out / name).chmod(0o644)
        written.append(out / name)
    for a in sorted(assets):
        dest = out / a
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(root / a, dest)
        dest.chmod(0o644)
        written.append(dest)
    # the connection map (tools/research/connection_map.py's site mode), its links to pages of the site kept on the site
    map_note = 'not built: site.map is off'
    if map_ok:
        on_site = {p: out_path(p) for p in pages}
        tmp = out / '_map'
        map_nav = [(label, target if target in SPECIAL else out_path(target)) for target, label in cfg.get('nav', [])
                   if target in SPECIAL or target in pages]
        made = pathlib.Path(connection_map.site_map(tmp, f"https://github.com/{cfg['repository']}/blob/{commit}/",
                                                    on_site, home='index.html', nav=map_nav, search='assets/search.js',
                                                    name=cfg.get('title', 'The Theory of Becoming'), languages=LANGUAGE_LINKS))
        made.rename(out / MAP_PAGE)
        tmp.rmdir()
        drawn = (out / MAP_PAGE).read_text()
        if '</head>' in drawn:  # the favicon is the one thing the map's own page does not have from its generator
            drawn = drawn.replace('</head>', '<link rel="icon" href="assets/favicon.svg" type="image/svg+xml">\n</head>', 1)
        bar = drawn.find('<header class="top"')
        if pushed is not True and bar >= 0 and '</header>' in drawn[bar:]:  # its links to GitHub are at the build commit too
            end = drawn.index('</header>', bar) + len('</header>')
            drawn = (drawn[:end] + '\n<p class="pushed-note" style="margin:0;padding:6px var(--gutter-r) 6px var(--gutter-l);'
                     'font:13px/1.45 var(--sans);color:var(--muted);border-bottom:1px solid var(--rule)">'
                     + f"This page was built from {'uncommitted edits on top of ' if dirty else ''}commit <code>{html.escape(commit[:9])}</code>. "
                     + html.escape(pushed_note(pushed).strip()) + '</p>' + drawn[end:])
        (out / MAP_PAGE).write_text(drawn)
        written.append(out / MAP_PAGE)
        map_note = 'built'
    (out / '.nojekyll').write_text('')
    # what was written: no page too large, no private path, no local path, nothing the push screen reads as a key, and a mark
    # at every result anchor that has a record
    problems = []
    for p, page in built.items():
        problems += [f"{p}: the result anchor #{ident} has no mark of its record's status"
                     for ident in sorted(i for i in page.anchors if i[2:] in recs and i not in page.marked)]
    for w in written:
        rel = str(w.relative_to(out))
        if refused(rel, private):
            problems.append('a private path was written: ' + rel)
        if w.suffix == '.html' and w.name != MAP_PAGE and w.stat().st_size > MAX_PAGE:
            problems.append(f'{rel} is {w.stat().st_size} bytes, over {MAX_PAGE}')
        if w.suffix in TEXT_WRITTEN:
            text = w.read_text()
            hit = secrets.search(text)
            if hit:
                problems.append(f'{rel} holds what the push screen reads as a key, at line {text[:hit.start()].count(chr(10)) + 1}')
            hit = LOCAL_PATH.search(text)
            if hit:  # a page whose text a frozen copy binds is redacted through site.rewrites, not edited
                problems.append(f'{rel} prints a local path, at line {text[:hit.start()].count(chr(10)) + 1}: {hit.group(0)}')
            for ref in re.findall(r'\b(?:href|src)="([^"]+)"', text):
                target = ref.split('#')[0]
                gh = re.match(r'https://github\.com/[^/]+/[^/]+/(?:blob|tree|raw)/[0-9a-f]+/(.*)', target)
                if gh and (private.search(gh.group(1)) or private.search(gh.group(1).rstrip('/') + '/')):
                    problems.append(f'{rel} links a private path: {gh.group(1)}')
                if w.name != MAP_PAGE and re.match(r'\s*(javascript|data|vbscript):', html.unescape(ref), re.I):
                    problems.append(f'{rel} has a link with a refused scheme')
    if problems:
        raise SiteError('\n'.join(problems))
    return {'pages': len(built) + 1, 'assets': len(assets), 'links': dict(links.counts), 'map': map_note,
            'untracked': links.untracked, 'out': str(out), 'commit': commit, 'on_github': pushed}


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('--out', default=str(ROOT / 'tmp' / 'site'))
    ap.add_argument('--commit', default=None, help='the commit the site names (default: HEAD)')
    a = ap.parse_args(argv)
    commit = a.commit or subprocess.run(['git', 'rev-parse', 'HEAD'], cwd=ROOT, capture_output=True, text=True, check=True).stdout.strip()
    try:
        report = build(pathlib.Path(a.out), commit)
    except SiteError as e:
        print('site not built:', e, file=sys.stderr)
        return 1
    print(f"built {report['pages']} pages and {report['assets']} assets in {report['out']} at {commit[:9]}; links: "
          + ', '.join(f'{k} {v}' for k, v in report['links'].items()) + f"; the map {report['map']}")
    if report['on_github'] is not True:
        print('  the footer says so: ' + pushed_note(report['on_github']).strip())
    for page, href in report['untracked'][:20]:
        print(f'  shown as text (not in the public repository): {page} → {href}')
    if len(report['untracked']) > 20:
        print(f"  … and {len(report['untracked']) - 20} more")
    return 0


if __name__ == '__main__':
    sys.exit(main())
