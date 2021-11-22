#https://pythonprinciples.com/challenges/

# Divisible by 3
# Define a function named div_3 that returns True if its single integer parameter is divisible by 3 and False otherwise.

# For example, div_3(6) is True because 6/3 does not leave any remainder. 
# However div_3(5) is False because 5/3 leaves 2 as a remainder.
def div_3(num):
    if num % 3 == 0:
        return True
    else:
        return False

#def div_3_better(num):
#    return num % 3
    
print(div_3(9))