# https://app.testdome.com/
#
# Implement the function find_roots to find the roots of the quadratic equation: ax^2 + bx + c = 0.  The function
# should return a tuple containing roots in any order.  If the equation has only one solution, the function should return
# as both elements of the tuple.  The equation will always have at least one solution.
#
# The roots of the quadratic equation can be found with the following formula:
# x(1,2) = (-b +/-  sqrt(b^2 - 4ac)) / 2ac
#
# For example, find_roots(2,10,8) should return (-1,-4) or (-4,-1) as the roots of the equation 2x^2 + 10x + 8 = 0 are -1 and -4.
#  
import math 

def find_roots(a, b, c):
    sqrt = math.sqrt(((b ** 2)-((4 * a) * c)))
    one = ((-b) - sqrt) / (2 * a)
    two = ((-b) + sqrt) / (2 * a)
    return (one, two)

print(find_roots(2, 10, 8));
