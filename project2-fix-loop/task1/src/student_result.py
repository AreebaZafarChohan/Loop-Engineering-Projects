def calculate_average(marks):
    return sum(marks) / len(marks)


def get_grade(average):
    if average >= 80:
        return "A"
    elif average >= 70:
        return "B"
    elif average >= 60:
        return "C"
    elif average >= 50:
        return "D"
    else:
        return "F"


def is_passing(average):
    return average >= 50