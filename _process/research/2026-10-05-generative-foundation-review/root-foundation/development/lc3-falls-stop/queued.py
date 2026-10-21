def edit(text):
    lines = text.split('\n')
    i = [k for k, l in enumerate(lines) if l.startswith('| **LC3: one rest theorem over any amounts')]
    assert len(i) == 1
    cells = lines[i[0]].split(' | ')
    assert cells[2].startswith('claimed 2026-10-21')
    cells[2] = (cells[2].split(';')[0] + '; built (`Becoming.InAmounts` 76 theorems, `Becoming.LeastLoss` 63, empty axiom '
                'reports; core checker passed on `a82b71c66`, receipt `20261021T114716.733626Z`), queued after EC1, '
                'replays its kit when EC1 lands')
    lines[i[0]] = ' | '.join(cells)
    return '\n'.join(lines)
