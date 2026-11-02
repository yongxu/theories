"""Copy a subagent's last answer, verbatim, from its transcript to a file, printing only its size and first words.

Usage: extract_agent.py AGENT_ID OUT. The transcript is JSONL; the last assistant message with text is the answer.
"""
import json
import sys

TASKS = '/private/tmp/claude-501/-Users-ren-theories/a6174cfd-3d37-4449-8d6a-4e52f87f7e8c/tasks'
agent, out = sys.argv[1], sys.argv[2]
last = None
for line in open(f'{TASKS}/{agent}.output', encoding='utf-8'):
    try:
        row = json.loads(line)
    except ValueError:
        continue
    message = row.get('message') or {}
    if row.get('type') != 'assistant' and message.get('role') != 'assistant':
        continue
    content = message.get('content')
    if isinstance(content, str):
        text = content
    else:
        text = '\n'.join(b.get('text', '') for b in (content or []) if isinstance(b, dict) and b.get('type') == 'text')
    if text.strip():
        last = text
assert last, 'no assistant text'
open(out, 'w', encoding='utf-8').write(last.rstrip('\n') + '\n')
print(out.split('/')[-1], len(last.split()), 'words:', last[:70].replace('\n', ' '))
