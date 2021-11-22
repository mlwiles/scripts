#https://edabit.com/challenge/mZqMnS3FsL2MPyFMg
# 
# Write a function that accepts a positive integer between 0 and 999 inclusive and returns a string representation of that integer written in English.

# Examples
# num_to_eng(0) ➞ "zero"
# num_to_eng(18) ➞ "eighteen"
# num_to_eng(126) ➞ "one hundred twenty six"
# num_to_eng(909) ➞ "nine hundred nine"

# Notes
# There are no hyphens used (e.g. "thirty five" not "thirty-five").
# The word "and" is not used (e.g. "one hundred one" not "one hundred and one").

def oneswitch(num):
    dict={
        "0" : "zero",
        "1" : "one",
        "2" : "two",
        "3" : "three",
        "4" : "four",
        "5" : "five",
        "6" : "six",
        "7" : "seven",
        "8" : "eight",
        "9" : "nine",
    }
    return dict.get(num, -1)
def undertwentyswitch(num):
    dict={
        "10" : "ten",
        "11" : "eleven",
        "12" : "twelve",
        "13" : "thirteen",
        "14" : "fourteen",
        "15" : "fifteen",
        "16" : "sixteen",
        "17" : "seventeen",
        "18" : "eighteen",
        "19" : "nineteen",
    }
    return dict.get(num, -1)
def twentyplusswitch(num):
    dict={
        "2" : "twenty",
        "3" : "thirty",
        "4" : "forty",
        "5" : "fifty",
        "6" : "sixty",
        "7" : "seventy",
        "8" : "eighty",
        "9" : "ninty",
    }
    return dict.get(num, -1)    
def num_to_eng(number):
    try:
       strnum = str(number)
    except:
        print("Not a number")
        return 
    strlen = len(strnum)
    if strlen == 1:
        onenum = strnum
        return oneswitch(onenum)
    if strlen == 2:
        if strnum[0] == "1":
            return undertwentyswitch(strnum)
        temp = twentyplusswitch(strnum[0])
        if strnum[1] != "0":
           temp += " " + oneswitch(strnum[1])
        return temp
    if strlen == 3:
        temp = oneswitch(strnum[0]) + " hundred"
        if strnum[1] != "0":
           temp += " " + twentyplusswitch(strnum[1])
        if strnum[2] != "0":
           temp += " " + oneswitch(strnum[2])
        return temp    
    return

print(num_to_eng(0))
print(num_to_eng(7))
print(num_to_eng(18))
print(num_to_eng(30))
print(num_to_eng(45))
print(num_to_eng(99))
print(num_to_eng(126))
print(num_to_eng(909))