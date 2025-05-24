from defns import *
from typing import Set
from hypothesis import given, strategies as st, settings, event

#########################################
# Example unit tests for unit propagation
#########################################

def test_unit_prop():
    test1 = set()
    assignments1 = {}
    result1 = unit_propagate(test1, assignments1)
    assert result1 == set()
    assert assignments1 == {}

    # All unit clauses
    test2 = {Axiom([Literal(1, True)]), Axiom([Literal(2, False)]), Axiom([Literal(3, True)])}
    assignments2 = {}
    result2 = unit_propagate(test2, assignments2)
    assert result2 == set()
    assert assignments2 == {1: True, 2: False, 3: True}

    # Test case with multiple layers of propagation
    test3 = {Axiom([ Literal(1, False) ]),
             Axiom([ Literal(1, True), Literal(3, True), Literal(2, False)]),
             Axiom([ Literal(1, True), Literal(5, True)]),
             Axiom([ Literal(4, True), Literal(5, False)])
             }
    assignments3 = {}
    result3 = unit_propagate(test3, assignments3)
    assert result3 == {ResolvedClause({ Literal(3, True), Literal(2, False) })}
    assert assignments3.get(1) == False
    assert assignments3.get(5)
    assert assignments3.get(4)

    # Single clause with multiple literals
    test4 = {Axiom([Literal(1, True), Literal(2, False), Literal(3, True)])}
    assignments4 = {}
    result4 = unit_propagate(test4, assignments4)
    assert result4 == test4
    assert assignments4 == {}

    # Test case without any unit clauses
    test5 = {Axiom([ Literal(1, True), Literal(2, False) ]),
             Axiom([ Literal(2, True), Literal(3, False), Literal(1, True) ]),
             Axiom([ Literal(1, True), Literal(3, True) ])
             }
    assignments5 = {}
    result5 = unit_propagate(test5, assignments5)
    assert result5 == test5
    assert assignments5 == {}

    # Redundant clauses
    test6 = {Axiom([Literal(1, True)]), Axiom([Literal(1, True), Literal(2, False)]), Axiom([Literal(1, True), Literal(3, True)])}
    assignments6 = {}
    result6 = unit_propagate(test6, assignments6)
    assert result6 == set()
    assert assignments6 == {1: True}


#########################################
# Normal input/output tests
#########################################

def test_unsat():
    formula = cnf([ [1,2], [-1,2], [1,-2], [-1,-2] ])
    assert not dpll(formula).sat()

    # Add additional various hand-written tests of unsatisfiability here.
    empty = cnf([ [] ])
    assert not dpll(empty).sat()

    contradictory = cnf([ [1], [-1] ])
    assert not dpll(contradictory).sat()

    contradictory_2 = cnf([[1, 2], [-1], [-2]])
    assert not dpll(contradictory_2).sat()

    more_contradictory = cnf([[1, -1], [2], [-2]])
    assert not dpll(more_contradictory).sat()

    large_contradiction = cnf([[1], [-1], [2], [-2]])
    assert not dpll(large_contradiction).sat()

def test_sat():
    # Simple case
    formula = cnf([ [1], [2], [2, 3] ])
    assert dpll(formula).sat()

    formula2 = cnf([[1, 2], [-1, 3], [2, -3]])
    assert dpll(formula2).sat()

    formula3 = cnf([[1, -1], [2, 3]])
    assert dpll(formula3).sat()

    formula4 = cnf([[1, 2, 3], [-1, 4], [-2, -3, 4]])
    assert dpll(formula4).sat()

    # Simple unit clause propagation
    formula5 = cnf([[1], [2, -1], [3, -2]])
    assert dpll(formula5).sat()

#########################################
# Hypothesis PBT
#########################################

# Don't set this very high. Lots of variables to pick from raises the
# probability that a given random clause will be satisfiable, meaning the UNSAT
# case will be less well-tested.
MAX_VAR = 10
MIN_CLAUSE_SIZE = 1
MAX_CLAUSE_SIZE = MAX_VAR
MIN_CLAUSES = 5
MAX_CLAUSES = 200

# The total number of examples that Hypothesis will generate for testing
MAX_EXAMPLES = 1_000  # (Python lets you use underscores for numeric grouping)

# Generators can be complex to write all at once. We've set this stencil up so 
# that you can write a series of smaller generators: first define a generator
# for literals, then clauses, and so on. We've provided the generator for
# literals to help you get started:

# Create a Hypothesis strategy that builds instances of `Literal`, using valid
# variable numbers up to `MAX_VAR`
literals: st.SearchStrategy[Literal] = st.builds(
    Literal,
    st.integers(min_value=1, max_value=MAX_VAR),
    st.booleans())

# Create a Hypothesis strategy that builds instances of `Axiom` using sequences
# (sets, lists, or iterables) of literals, with at least `MIN_CLAUSE_SIZE`
# literals and at most `MAX_CLAUSE_SIZE` literals.
# 
# Use the `unique_by` parameter to create sequences of literals that do not
# contain multiple literals with the same variable number. We don't want clauses
# like `-1 OR 1`. See documentation here:
# https://hypothesis.readthedocs.io/en/latest/data.html#hypothesis.strategies.lists
#
# Remember to use the `literals` strategy you already wrote!
#
# (FILL)
axioms: st.SearchStrategy[Axiom] = st.builds(
    Axiom,
    st.lists(
        literals,
        min_size=MIN_CLAUSE_SIZE,
        max_size=MAX_CLAUSE_SIZE,
        unique_by=lambda l: l.variable
    )
)

# Create a Hypothesis strategy that builds sets of clauses (i.e. formulas) with
# at least `MIN_CLAUSES` clauses and at most `MIN_CLAUSES` clauses.
#
# Remember to use the `axioms` strategy you already wrote!
#
# (FILL)
formulas: st.SearchStrategy[Set[Axiom]] = st.builds(
    set,
    st.lists(
        axioms,
        min_size=MIN_CLAUSES,
        max_size=MAX_CLAUSES,
    ))

@given(formulas)
@settings(deadline=None, max_examples=MAX_EXAMPLES)
def test_pbt(formula: Set[Axiom]):
    result = dpll(formula)

    if result.sat():
        event('sat') # Record a "sat" result for profiling and statistics

        # What properties should a satisfiable result observe? Use `assert` to
        # check these properties. (FILL)
        assignments = result.assignments
        for clause in formula:
            # At least one literal in every clause of the formula must be true
            assert any(
                (literal.sign and assignments.get(literal.variable, False)) or
                 (not literal.sign and not assignments.get(literal.variable, False))
                  for literal in clause
            )
    else:
        event('unsat') # Record an "unsat" result for profiling and statistics

        # What properties should an unsatisfiable result observe?
        # For now, only check that the final resolved clause is the empty
        # clause. (FILL)
        #
        # In a future assignment, you will find how to validate an UNSAT result.
        assert result.clause == ResolvedClause(set())


if __name__ == '__main__':
    test_unit_prop()
    test_sat()
    test_unsat()
    test_pbt()
    print("passes all test!")
