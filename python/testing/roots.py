#https://app.testdome.com/
# 
import math 

def find_roots(a, b, c):
    sqrt = math.sqrt(((b ** 2)-((4 * a) * c)))
    one = ((-b) - sqrt) / (2 * a)
    two = ((-b) + sqrt) / (2 * a)
    return (one, two)

print(find_roots(2, 10, 8));
