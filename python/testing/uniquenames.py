# https://app.testdome.com/
#
# Implement the unique_names method.  Whem passed two lists of names, it will return a list containing the names that appear in 
# either or both lists.  The returned list should have no duplicates.
#
# For example, calling unique_names(["Ava", "Emma", "Olivia"], ["Olivia", "Sophia", "Emma"]) should return a list containing Ava, Emma, Olivia, Sophi
# in any order.

def unique_names(names1, names2):
    names = []
    for name in names1:
        names.append(name)
    for name in names2:
        names.append(name)
    unique = []

    for name in names:
        if name in unique:
            continue
        else:
            unique.append(name)
    return unique

if __name__ == "__main__":
    names1 = ["Ava", "Emma", "Olivia"]
    names2 = ["Olivia", "Sophia", "Emma"]
    print(unique_names(names1, names2)) # should print Ava, Emma, Olivia, Sophi
