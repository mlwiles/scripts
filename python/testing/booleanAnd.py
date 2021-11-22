#https://pythonprinciples.com/challenges/

# Boolean and
# Define a function named triple_and that takes three parameters and returns 
# True only if they are all True and False otherwise.
def triple_and(one,two, three):
    return (one == two == three == True)
print(triple_and(True, False, True))


#def triple_and(a, b, c):
#    return a and b and c