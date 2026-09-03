from src.student_result import (
    calculate_average,
    get_grade,
    is_passing,
)


def test_calculate_average():
    assert calculate_average([80, 90, 70]) == 80


def test_get_grade():
    assert get_grade(85) == "A"
    assert get_grade(72) == "B"
    assert get_grade(65) == "C"
    assert get_grade(55) == "D"
    assert get_grade(40) == "F"


def test_is_passing():
    assert is_passing(50) is True
    assert is_passing(75) is True
    assert is_passing(49) is False