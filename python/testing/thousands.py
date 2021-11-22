#https://pythonprinciples.com/challenges/

# # Thousands separator
# Write a function named format_number that takes a non-negative number as its only parameter.

# Your function should convert the number to a string and add commas as a thousands separator.

# For example, calling format_number(1000000) should return "1,000,000".

def format_number(number):
    strnum = str(number)
    comma = len(strnum) % 3
    counter = 0
    commafied = ""
    for num in strnum:
        commafied += num
        counter += 1
        if counter == comma:
           commafied += ","
           comma = -1
           counter = 0
        if counter == 3:
           commafied += ","
           counter = 0
    return commafied[:-1]

print(format_number(1000000))

# DIY solution
#def format_number(n):
#    result = ""
#    for i, digit in enumerate(reversed(str(n))):
#        if i != 0 and (i % 3) == 0:
#            result += ","
#        result += digit
#    return result[::-1]

# built-in solution
#def format_number(n):
#    return "{:,}".format(n)