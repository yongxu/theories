"""Pin the second round's copies and prompts to one commit, cut as the first round's were.

Usage: prepare_reread.py COMMIT. Writes under scratchpad/reread: part-one/, part-two/ (exact copies, links kept, as in the
first round), briefs (the first round's, verbatim, with the directories filled), closed/note-prompt.md (the key's note prompt
with the three texts, links removed, as the key's prompt says).
"""
import pathlib
import re
import subprocess
import sys

R = '/Users/ren/theories'
S = pathlib.Path('/private/tmp/claude-501/-Users-ren-theories/a6174cfd-3d37-4449-8d6a-4e52f87f7e8c/scratchpad/reread3')
PACKET = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/review-packet'
commit = sys.argv[1]


def show(path):
    return subprocess.run(['git', '-C', R, 'show', f'{commit}:{path}'], capture_output=True, text=True, check=True).stdout


def first_screen(readme):
    lines = readme.split('\n')
    end = lines.index('---')
    kept = [l for l in lines[:end] if not l.startswith('<!-- Generated') and not l.startswith('[Home](README.md)')]
    return re.sub(r'\n{3,}', '\n\n', '\n'.join(kept)).rstrip('\n') + '\n'


def unlinked(text):
    text = re.sub(r'<a id="[^"]*"></a>\n?', '', text)
    return re.sub(r'\[([^\]]*)\]\([^)]*\)', r'\1', text)


one, two, closed = S / 'part-one', S / 'part-two', S / 'closed'
for d in (one, two, closed):
    d.mkdir(parents=True, exist_ok=True)
screen = first_screen(show('README.md'))
page = show('theories/becoming/ONE-PAGE.md')
overview = show('theories/becoming/THE-THEORY-OF-BECOMING.md')
(one / '1-first-screen.md').write_text(screen)
(one / '2-one-page.md').write_text(page)
(two / '3-overview.md').write_text(overview)

brief_one = show(f'{PACKET}/cold-read-2026-11-02/brief-part-one.txt').replace('PART_ONE_DIR', str(one))
brief_two = show(f'{PACKET}/cold-read-2026-11-02/brief-part-two.txt').replace('PART_TWO_DIR', str(two))
(S / 'brief-part-one.txt').write_text(brief_one)
(S / 'brief-part-two.txt').write_text(brief_two)

key = show(f'{PACKET}/COLD-READ-KEY.md')


def quoted(after):
    """The blockquote following the line `after` in the key's closed-book prompts."""
    lines = key.split('\n')
    i = lines.index(after)
    out = []
    for line in lines[i + 1:]:
        if line.startswith('>'):
            out.append(line[2:] if line.startswith('> ') else '')
        elif out:
            break
    return '\n'.join(out)


NOTE, ANSWERS, MARKS = quoted('The note:'), quoted('The answers, from the note alone:'), quoted('The statements, from the note alone:')
statements = key[key.index('1. Becoming is good.'):].rstrip('\n')
texts = '\n\n'.join(f'=== Text {i} ===\n\n{unlinked(t)}' for i, t in enumerate([screen, page, overview], 1))
(closed / 'note-prompt.md').write_text(f'{NOTE}\n\n{texts}\n')
(closed / 'answers-head.md').write_text(ANSWERS + '\n\n')
(closed / 'statements-head.md').write_text(f'{MARKS}\n\n{statements}\n\nThe note:\n\n')
for name, text in [('first screen', screen), ('one page', page), ('overview', overview)]:
    print(name, len(text.split()), 'words')
print('commit', commit)
print('note prompt', len((closed / 'note-prompt.md').read_text().split()), 'words')
print('---', ANSWERS[:90])
print('---', MARKS[:90])
print('statements', statements.count('\n') + 1)
