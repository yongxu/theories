"""AI-written (Fable, reader R2:lock). Print the headers (up to `:=`) of the laws for the telling,
whitespace collapsed, from the scratch TurningInTime.lean, with their line numbers."""
import importlib.util, sys
spec = importlib.util.spec_from_file_location('sc', 'statements_check.py')
import io, contextlib
sc = importlib.util.module_from_spec(spec)
with contextlib.redirect_stdout(io.StringIO()):
    spec.loader.exec_module(sc)
want = ['rises_from', 'kept_within', 'rising_takes_all', 'rising_meets_level', 'ends_with_net_rising',
        'locked_ends_rising', 'count_rises', 'windowAfterShare', 'windowAfter_every_is_share',
        'locked_turns_in_time_share_iff', 'share_corrected_stays', 'share_corrected_on_course',
        'Three.rise_count_ends', 'Three.share_read_goes_on', 'ends_with_net', 'ends_of_below']
for w in want:
    for q, k, h, a, b in sc.sd:
        if q == 'Becoming.TurningInTime.' + w:
            print('### %s  l.%d-%d' % (w, a, b))
            print(' '.join(h.split()))
            print()
