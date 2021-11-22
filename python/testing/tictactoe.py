#https://pythonprinciples.com/challenges/

# Tic tac toe input
# Here's the backstory for this challenge: imagine you're writing a tic-tac-toe game, 
# where the board looks like this:

# 1:  X | O | X
#    -----------
# 2:    |   |  
#    -----------
# 3:  O |   |

#     A   B  C
# The board is represented as a 2D list:

# board = [
#     ["X", "O", "X"],
#     [" ", " ", " "],
#     ["O", " ", " "],
# ]
# Imagine if your user enters "C1" and you need to see if there's an X or O in that cell on the board. 
# To do so, you need to translate from the string "C1" to row 0 and column 2 so that you can check 
# board[row][column].

# Your task is to write a function that can translate from strings of length 2 to a tuple (row, column). 
# Name your function get_row_col; it should take a single parameter which is a string of length 2 
# consisting of an uppercase letter and a digit.

# For example, calling get_row_col("A3") should return the tuple (2, 0) because A3 corresponds to 
# the row at index 2 and column at index 0in the board.
board = [
    ["X", "O", "X"],
    [" ", " ", " "],
    ["O", " ", " "],
]
def switch(spot):
    dict={
        "A" : 0,
        "B" : 1,
        "C" : 2,
        "1" : 0,
        "2" : 1,
        "3" : 2,
    }
    return dict.get(spot, -1)
    
def get_row_col(coords):
    return(switch(coords[1]), switch(coords[0]))
print(get_row_col("A3"))



def get_row_col(choice):
    translate = {"A": 0, "B": 1, "C": 2}
    letter = choice[0]
    number = choice[1]
    row = int(number) - 1
    column = translate[letter]
    return (row, column)