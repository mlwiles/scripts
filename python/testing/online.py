#https://pythonprinciples.com/challenges/

# Online status
# The aim of this challenge is, given a dictionary of people's online status, to count the number of people who are online.

# For example, consider the following dictionary:

# statuses = {
#     "Alice": "online",
#     "Bob": "offline",
#     "Eve": "online",
# }
# In this case, the number of people online is 2.

# Write a function named online_count that takes one parameter. 
# The parameter is a dictionary that maps from strings of names to the string "online" or "offline", as seen above.

# Your function should return the number of people who are online.

def online_count(status_in): 
    numonline = 0
    for x, y in status_in.items():
      if y == "online":
          numonline += 1
    return numonline

status_dict = {
    "Alice": "online",
    "Bob": "offline",
    "Eve": "online",
}
print(online_count(status_dict))

# long version
#def online_count(people):
#    count = 0
#    for person, status in people.items():
#        if status == "online":
#            count += 1
#    return count

# short version
#def online_count(people):
#    return len([p for p in people if people[p] == "online"])