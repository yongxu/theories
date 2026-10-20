// Browser interpretation of GradualInteractionTrial's supplied response laws.
// S = supporting, D = defensive, U = unresolved; newest experiences are first.
// These are chosen evidence weights, not empirical psychological quantities.
(() => {
  const revise = (score, experience, penalty) => experience === 'supporting'
    ? score + 1 : experience === 'defensive' ? Math.max(0, score - penalty) : score;

  function learned(history, penalty) {
    return [...history].reverse().reduce((score, e) => revise(score, e, penalty), 0);
  }

  function compute(config) {
    let alex = ['defensive'], maya = ['unresolved', 'defensive'];
    const states = [{a: [...alex], m: [...maya], q: [0, 0], event: null}];
    for (const control of config.plan) {
      if (!['clarify', 'habitual', 'defend'].includes(control)) {
        throw new Error('Unknown response control: ' + control);
      }
      const before = [learned(alex, config.penalty), learned(maya, config.penalty)];
      const specific = before[1] >= 2;
      const humble = control === 'clarify' ? true : control === 'defend' ? false
        : specific || before[0] >= 3;
      const ae = !humble ? 'defensive'
        : specific && config.credible ? 'supporting' : 'unresolved';
      const me = !humble ? 'defensive' : config.receptive ? 'supporting' : 'unresolved';
      alex = [ae, ...alex];
      maya = [me, ...maya];
      const q = [learned(alex, config.penalty), learned(maya, config.penalty)];
      const reduced = [revise(before[0], ae, config.penalty), revise(before[1], me, config.penalty)];
      if (q.some((n, i) => n !== reduced[i])) {
        throw new Error('History and reduced tally updates disagree');
      }
      states.push({a: [...alex], m: [...maya], q,
        event: {control, specific, humble, ae, me, before}});
    }
    return states;
  }
  globalThis.feedbackDynamics = {revise, learned, compute};
})();
