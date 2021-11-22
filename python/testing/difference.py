#https://pythonprinciples.com/challenges/

# Min-maxing
# Define a function named largest_difference that takes a list of numbers as its only parameter.

# Your function should compute and return the difference between the largest and smallest number in the list.

# For example, the call largest_difference([1, 2, 3]) should return 2 because 3 - 1 is 2.

# You may assume that no numbers are smaller or larger than -100 and 100.

def largest_difference(thelist):
    smallest = 100
    largest = -100
    for item in thelist:
        if item > largest:
            largest = item
        if item < smallest:
            smallest = item
    return abs(largest-smallest)

# short solution
#def largest_difference2(numbers):
#    return max(numbers) - min(numbers)

print(largest_difference([1, 2, 3]))