"""Build the reader's site: a static site of the pages a reader starts from, built from the repository at one commit.

The pages come only from the allow-list `site.pages` in _process/research-config.json, and a page whose path the push
screen's private pattern matches (tools/research/push_screen.sh, read from that file so there is one list) or that lies
under sources/ is refused. Each page is converted from its Markdown with the standard library, its headings given the
anchors GitHub gives them (tools/research/reading_catalogue.slug, which the repository's link check uses). A link to
another page of the site becomes a link to its HTML; a link to any other tracked file goes to that file on GitHub as it
stood at the build commit; a link to a path the repository does not track is shown as its text. Every link between pages
of the site, anchor included, must resolve, or the build fails. At each result's anchor (`r-<record id>`) the page gets a
small mark of the record's status, linked to the record. The home is README's generated first screen, verbatim, then
the ways in that `site.ways_in` lists, each with its page's reading time. With `site.map`, the connection map is written
by its generator's site mode (tools/research/connection_map.py), its links to pages of the site kept there. Nothing generated is committed: the site is
written to tmp/site/ (untracked) or --out, and the Pages job builds it from main.

Run from the repository's root:  python3 tools/publishing/build_site.py [--out DIR] [--commit SHA]
"""
import argparse
import html
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
        self.untracked = []

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
        alias = self.aliases.get(f'{target}#{anchor}') or self.aliases.get(target)
        if alias:
            target, _, a2 = alias.partition('#')
            anchor = a2 or anchor
        if target == page:
            self.internal.append((page, page, anchor))
            return '#' + anchor if anchor else posixpath.basename(out_path(page))
        if target in SPECIAL:
            self.counts['site'] += 1
            return relative(target, page) + (f'#{anchor}' if anchor else '')
        if target.startswith('../') or target == '..':
            self.counts['untracked'] += 1
            self.untracked.append((page, href))
            return None
        lines = bool(query) or bool(re.fullmatch(r'L\d+(-L\d+)?', anchor))  # a line of a file: only GitHub shows it
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
        text = strip_comments(text)
        lines = text.split('\n')
        lines = self._definitions(lines)
        self.html = self._blocks(lines) + self._footnote_list()
        self.title = self.title or self.first_heading
        self.lang = 'zh' if path.endswith('.zh.md') or cjk_share(text) > 0.3 else 'en'

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
        return f'<h{level} id="{html.escape(ident)}">{self.inline(text)}<a class="here" href="#{html.escape(ident)}" aria-label="Link to this section">#</a></h{level}>'

    def _record_mark(self, ident):
        rid = ident[2:]
        rec = self.records.get(rid)
        if not rec:
            return ''
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

        def cell(tag, c, k):
            a = align[k] if k < len(align) and align[k] else ''
            return f'<{tag}' + (f' style="text-align:{a}"' if a else '') + f'>{self.inline(c)}</{tag}>'
        t = '<div class="table"><table><thead><tr>' + ''.join(cell('th', c, k) for k, c in enumerate(head)) + '</tr></thead><tbody>'
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
            items.append(f'<li id="{ident}">{self.inline(body)} <a class="back" href="#fnref-{slug_id(name)}" aria-label="Back">↩</a></li>')
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
        return t

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
            return f'<span class="nolink" title="Not in the public repository">{text_html}</span>'
        ext = ' rel="noopener"' if new.startswith('http') else ''
        return f'<a href="{html.escape(new)}"{ext}>{text_html}</a>'

    def _img(self, src, alt):
        new = self.links.resolve(src, self.path)
        if new is None:
            return html.escape(alt)
        if new.startswith('https://github.com/'):
            new = new.replace('/blob/', '/raw/', 1)
        img = f'<img src="{html.escape(new)}" alt="{html.escape(alt)}" loading="lazy">'
        if src.split('#')[0].lower().endswith('.svg'):  # a picture opens at full size, and is shown wider than the text
            return f'<a class="picture" href="{html.escape(new)}" title="Open the picture at full size">{img}</a>'
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
        out[d.get('id', p.stem)] = {'status': d.get('status', ''), 'title': (d.get('title') or {}).get('en', '')}
    return out


def first_screen(readme: str) -> str:
    """README's generated first screen: from its status line (README's title, generated comment and navigation line left
    out, since the site has its own) to the opening's heading."""
    lines = readme.split('\n')
    start = next(k for k, l in enumerate(lines) if l.startswith('> '))
    end = next(k for k, l in enumerate(lines) if k > start and l.startswith('## '))
    return '\n'.join(lines[start:end]).strip()


def template(page_path, title, body, lang, cfg, commit, date, nav_html, source_href, home=False, dirty=False):
    css = relative('assets/site.css', page_path) if page_path != 'index.html' else 'assets/site.css'
    home_href = relative('index.html', page_path) if page_path != 'index.html' else 'index.html'
    short = commit[:9]
    name = cfg.get('title', 'The Theory of Becoming')
    head_title = name if home else f'{title} · {name}'
    return f'''<!doctype html>
<html lang="{'zh-Hans' if lang == 'zh' else 'en'}">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{html.escape(head_title)}</title>
<meta name="description" content="{html.escape(cfg.get('description', ''))}">
<link rel="stylesheet" href="{css}">
</head>
<body class="{'home' if home else 'page'} lang-{lang}">
<header class="top"><a class="brand" href="{home_href}">{html.escape(name)}</a><nav aria-label="Pages">{nav_html}</nav></header>
<main>
{body}
</main>
<footer><p>Built from {'uncommitted edits on top of ' if dirty else ''}commit <a href="https://github.com/{cfg['repository']}/tree/{commit}"><code>{short}</code></a> of <a href="https://github.com/{cfg['repository']}">the repository</a> ({date}). Every page is converted from the repository's text; a link that leaves the site goes to the file as it stood at that commit. <a href="{html.escape(source_href)}">This page's source</a>.</p></footer>
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
    return other if other in pages else None


def nav(cfg, page_path, pages, lang='en'):
    """The site's navigation line: on a page in Chinese its Chinese line, and the language link goes to this page's own
    other edition where it has one."""
    items = []
    zh = lang == 'zh' or page_path.endswith('.zh.md')
    other = edition(page_path, pages)
    for target, label in cfg.get('nav_zh' if zh and cfg.get('nav_zh') else 'nav', []):
        if label in ('中文', 'English') and other:
            target = other
        if target not in pages and target not in SPECIAL:
            raise SiteError('site.nav names a page not in site.pages: ' + target)
        built = target if target in SPECIAL else out_path(target)
        here = built == (page_path if page_path in SPECIAL else out_path(page_path))
        href = relative(built, page_path) if page_path not in SPECIAL else built
        items.append(f'<a href="{href}"' + (' aria-current="page"' if here else '') + f'>{html.escape(label)}</a>')
    return ''.join(items)


def home_body(cfg, links, recs, root):
    screen = first_screen((root / 'README.md').read_text())
    page = Page('README.md', screen, links, recs)
    parts = [f'<section class="hero"><h1>{html.escape(cfg.get("title", "The Theory of Becoming"))}</h1>{page.html}</section>']
    fig = cfg.get('figure')
    if fig and (root / fig['path']).is_file():
        src = links.resolve(fig['path'], 'README.md')
        parts.append(f'<figure class="spine"><img src="{html.escape(src)}" alt="{html.escape(fig.get("alt", ""))}">'
                     f'<figcaption>{Page("README.md", fig.get("caption", ""), links, recs).html}</figcaption></figure>')
    cards = []
    for w in cfg.get('ways_in', []):
        target = w['path']
        p = root / target.split('#')[0]
        time = ''
        if p.is_file() and target.split('#')[0].endswith('.md'):
            text = p.read_text()
            if w.get('time_until'):  # the part a reader is sent to: up to the named heading line
                assert w['time_until'] in text, ('site.ways_in times up to a heading the page lacks', target, w['time_until'])
                text = text.split(w['time_until'], 1)[0]
            time = navigation.reading_time(text) + (f", {w['time_note']}" if w.get('time_note') else '')
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
    parts.append('<section class="ways"><h2 id="ways-in">Ways in</h2>' + body + '</section>')
    return '\n'.join(parts), page.lang


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
    links = Links(set(pages), assets, files, dirs, cfg['repository'], commit, cfg.get('aliases'))
    links.private = private
    from tools.research import connection_map
    map_ok = bool(cfg.get('map'))
    if map_ok and not hasattr(connection_map, 'site_map'):
        raise SiteError('site.map is on, and this checkout\'s connection_map has no site mode (site_map)')
    if not map_ok:  # no link to a map this build does not write
        cfg = dict(cfg, nav=[n for n in cfg.get('nav', []) if n[0] != MAP_PAGE],
                   ways_in=[w for w in cfg.get('ways_in', []) if w['path'] != MAP_PAGE])
    recs = records(root)
    date = subprocess.run(['git', 'show', '-s', '--format=%cs', commit], cwd=root, capture_output=True, text=True).stdout.strip() or commit
    if out.exists():
        shutil.rmtree(out)
    (out / 'assets').mkdir(parents=True)
    shutil.copy(pathlib.Path(__file__).with_name('site.css'), out / 'assets' / 'site.css')
    built = {}
    for p in pages:
        page = Page(p, (root / p).read_text(), links, recs)
        built[p] = page
    home, home_lang = home_body(cfg, links, recs, root)
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
    written = []
    for p, page in built.items():
        dest = out / out_path(p)
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.write_text(template(p, page.title or posixpath.basename(p), page.html, page.lang, cfg, commit, date,
                                 nav(cfg, p, set(pages), page.lang), links.github(p), dirty=dirty))
        written.append(dest)
    (out / 'index.html').write_text(template('index.html', cfg.get('title', ''), home, home_lang, cfg, commit, date,
                                             nav(cfg, 'index.html', set(pages)), links.github('README.md'), home=True, dirty=dirty))
    written.append(out / 'index.html')
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
                                                    on_site, home='index.html', nav=map_nav))
        made.rename(out / MAP_PAGE)
        tmp.rmdir()
        written.append(out / MAP_PAGE)
        map_note = 'built'
    (out / '.nojekyll').write_text('')
    # what was written: no page too large, no private path, nothing the push screen reads as a key
    problems = []
    for w in written:
        rel = str(w.relative_to(out))
        if refused(rel, private):
            problems.append('a private path was written: ' + rel)
        if w.suffix == '.html' and w.name != MAP_PAGE and w.stat().st_size > MAX_PAGE:
            problems.append(f'{rel} is {w.stat().st_size} bytes, over {MAX_PAGE}')
        if w.suffix in ('.html', '.svg', '.css'):
            text = w.read_text()
            hit = secrets.search(text)
            if hit:
                problems.append(f'{rel} holds what the push screen reads as a key, at line {text[:hit.start()].count(chr(10)) + 1}')
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
            'untracked': links.untracked, 'out': str(out), 'commit': commit}


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
    for page, href in report['untracked'][:20]:
        print(f'  shown as text (not in the public repository): {page} → {href}')
    if len(report['untracked']) > 20:
        print(f"  … and {len(report['untracked']) - 20} more")
    return 0


if __name__ == '__main__':
    sys.exit(main())
