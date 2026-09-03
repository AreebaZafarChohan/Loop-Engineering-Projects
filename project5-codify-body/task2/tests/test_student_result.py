from src.student_result import calculate_grade


def test_grade_a():
    assert calculate_grade(90) == "A"


def test_grade_b():
    assert calculate_grade(80) == "B"


def test_grade_c():
    assert calculate_grade(70) == "C"


def test_grade_d():
    assert calculate_grade(60) == "D"


def test_grade_f():
    assert calculate_grade(59) == "F"