def edit(text):
    lines = text.split('\n')
    i = [k for k, l in enumerate(lines) if l.startswith('| **LC3: one rest theorem over any amounts')]
    assert len(i) == 1
    cells = lines[i[0]].split(' | ')
    cells[2] = cells[2].split('; built')[0] + ('; built (`Becoming.InAmounts` 76 theorems, `Becoming.LeastLoss` 63, empty axiom '
                                               'reports); at the head of the queue after EC1, replayed on EC1\'s main, checker running')
    lines[i[0]] = ' | '.join(cells)
    return '\n'.join(lines)
