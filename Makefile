.PHONY: research-check research-check-strict research-render research-find research-test research-imports research-links research-secrets gate gate-plan
export QUERY

research-check:
	python3 -B tools/research/research.py secrets
	python3 -B tools/research/research.py check

# CI: also fails when a render would change any generated page (directory indexes and the Lean catalogue included).
research-check-strict:
	python3 -B tools/research/research.py secrets
	python3 -B tools/research/research.py check --strict-fresh

research-render:
	python3 -B tools/research/research.py render

research-find:
	python3 -B tools/research/research.py find

research-test:
	python3 -B -m unittest discover -s tools/research/tests -p 'test_*.py'

research-imports:
	python3 -B tools/research/research.py imports

research-links:
	python3 -B tools/research/research.py links

research-secrets:
	python3 -B tools/research/research.py secrets

# A landing's gate: the checks its changed paths can reach, a pass kept per tree, heavy runs in the
# slots this repository's worktrees share (tools/research/gate.py). FULL=1 runs every check, reusing only passes on
# this same tree, at a phase's end and before a push; FRESH=1 with it reuses none.
gate:
	python3 -B tools/research/gate.py run --base $(or $(BASE),main) $(if $(FULL),--full,) $(if $(FRESH),--fresh,)

gate-plan:
	python3 -B tools/research/gate.py plan --base $(or $(BASE),main)
